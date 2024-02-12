#define IS_AIR_BAD(P) P > WARNING_HIGH_PRESSURE || P < WARNING_LOW_PRESSURE

/obj/machinery/airlock_controller
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "airlock_control_standby"
	base_icon_state = "airlock_control"

	name = "airlock console"
	density = FALSE
	processing_flags = START_PROCESSING_MANUALLY

	var/frequency = FREQ_AIRLOCK_CONTROL
	var/datum/radio_frequency/radio_connection
	power_channel = AREA_USAGE_ENVIRON

	light_power = 0
	light_range = 7
	light_color = COLOR_VIVID_RED

	var/state = AIRLOCK_STATE_CLOSED
	var/target_state = AIRLOCK_STATE_CLOSED

	var/packetnum = 0

	// Setup parameters only
	var/exterior_door_tag
	var/interior_door_tag
	var/airpump_tag
	var/sensor_tag
	var/interior_sensor_tag
	var/exterior_sensor_tag

	var/list/memory = list("processing_ticks" = 0)

	/// If set to TRUE, enables opening both sides at once outside of maintenance and emag modes.
	/// Also enables firelock functionality. If one of the sensors are tripped, it closes, and puts itself into airlock mode.
	var/is_firelock = FALSE

	/// Is a shuttle docked to the port assigned to this airlock?
	/// When this is set to TRUE, the airlock cycles to open the exterior door, and allows the inner door to open and close freely,
	/// and co-ordinates airlock status with the other to make one large airlock.
	var/docked = FALSE

	/// Fire alarm sound. Used when the airlock is outside normal parameters, such as when hallway airlocks contain non-breathable air.
	var/datum/looping_sound/firealarm/sound_loop

/obj/machinery/airlock_controller/Initialize(mapload)
	. = ..()
	// Custom 1/2 second processing loop, otherwise it can feel very slow.
	START_PROCESSING(SSairlocks, src)

	set_frequency(frequency)

	sound_loop = new(src, FALSE)

/obj/machinery/airlock_controller/update_icon_state()
	if(machine_stat & NOPOWER)
		icon_state = "[base_icon_state]_off"
	else
		icon_state = "[base_icon_state]_[memory["processing"] ? "process" : "standby"]"
	return ..()

/obj/machinery/airlock_controller/Topic(href, href_list) // needed to override obj/machinery/embedded_controller/Topic, dont think its actually used in game other than here but the code is still here
	return

/obj/machinery/airlock_controller/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AirlockController", src)
		ui.open()

/obj/machinery/airlock_controller/ui_data(mob/user)
	var/list/data = memory.Copy()
	data["airlock_state"] = state
	data["airlock_disabled"] = machine_stat & MAINT
	data["is_firelock"] = is_firelock
	return data

/obj/machinery/airlock_controller/ui_act(action, params)
	. = ..()
	if(.)
		return

	handle_action(action)
	return TRUE

/obj/machinery/airlock_controller/proc/handle_action(action)
	if(docked)
		say("A ship is docked. Unable to rotate airlock.")
		return

	// Forcing the airlock is allowed, but don't allow anything else.
	if(is_firelock && !sound_loop.is_active() && action != "forceExterior" && action != "forceInterior")
		say("There is no emergency. Not rotating airlock.")
		return

	switch(action)
		if("cycle")
			if(state == AIRLOCK_STATE_INOPEN)
				target_state = AIRLOCK_STATE_OUTOPEN
			else
				target_state = AIRLOCK_STATE_INOPEN

		if("cycleClosed")
			target_state = AIRLOCK_STATE_CLOSED

		if("cycleExterior")
			target_state = AIRLOCK_STATE_OUTOPEN

		if("cycleInterior")
			target_state = AIRLOCK_STATE_INOPEN

		if("abort")
			target_state = AIRLOCK_STATE_CLOSED

		if("cycleOpen") // Only available for indoor airlocks, which come into action when atmos is unlivable on one side.
			if(!is_firelock)
				return // Bad exploiter
			target_state = AIRLOCK_STATE_OPEN

		if("forceExterior")
			var/new_door_state = "secure_open"

			if(state == AIRLOCK_STATE_OUTOPEN)
				new_door_state = "secure_close"
				state = memory["interior_status"] == "open" ? AIRLOCK_STATE_INOPEN : AIRLOCK_STATE_CLOSED
			else
				state = memory["interior_status"] == "open" ? AIRLOCK_STATE_OPEN : AIRLOCK_STATE_OUTOPEN

			post_signal(new /datum/signal(list(
				"tag" = exterior_door_tag,
				"command" = new_door_state,
			)))

		if("forceInterior")
			var/new_door_state = "secure_open"

			if(state == AIRLOCK_STATE_OUTOPEN)
				new_door_state = "secure_close"
				state = memory["exterior_status"] == "open" ? AIRLOCK_STATE_OUTOPEN : AIRLOCK_STATE_CLOSED
			else
				state = memory["exterior_status"] == "open" ? AIRLOCK_STATE_OPEN : AIRLOCK_STATE_INOPEN

			post_signal(new /datum/signal(list(
				"tag" = interior_door_tag,
				"command" = new_door_state,
			)))

/obj/machinery/airlock_controller/receive_signal(datum/signal/signal)
	var/receive_tag = signal.data["tag"]
	if(!receive_tag)
		return

	if(receive_tag == "dock" && !is_firelock) // Uhhhhh, we should be the only thing in range for this kind of thing.
		if(signal.data["docked"])
			docked = TRUE
			target_state = AIRLOCK_STATE_OUTOPEN
			post_signal(new /datum/signal(list( // Finish the secret handshake
				"tag" = "dock",
				"received" = TRUE,
			)))
		if(signal.data["undocked"])
			docked = FALSE
			target_state = AIRLOCK_STATE_INOPEN
		if(signal.data["received"])
			docked = TRUE
			target_state = AIRLOCK_STATE_OUTOPEN

	else if(receive_tag == sensor_tag)
		if(signal.data["pressure"])
			memory["chamber_pressure"] = text2num(signal.data["pressure"])
			SStgui.update_uis(src)

	else if(receive_tag == exterior_sensor_tag)
		handle_pressure(signal.data["pressure"], "exterior_pressure")
		SStgui.update_uis(src)

	else if(receive_tag == interior_sensor_tag)
		handle_pressure(signal.data["pressure"], "interior_pressure")
		SStgui.update_uis(src)

	else if(receive_tag == exterior_door_tag)
		memory["exterior_status"] = signal.data["door_status"]
		memory["exterior_lock_status"] = signal.data["lock_status"]
		SStgui.update_uis(src)

	else if(receive_tag == interior_door_tag)
		memory["interior_status"] = signal.data["door_status"]
		memory["interior_lock_status"] = signal.data["lock_status"]
		SStgui.update_uis(src)

	else if(receive_tag == airpump_tag)
		if(signal.data["power"])
			memory["pump_status"] = signal.data["direction"]
		else
			memory["pump_status"] = "off"

	else if(receive_tag == id_tag && signal.data["command"] == "cycle")
		handle_action("cycle")

/obj/machinery/airlock_controller/proc/handle_pressure(pressure, memory_index)
	if(isnull(pressure)) // Pressure can be 0!!!
		return

	if(!isnum(pressure))
		pressure = text2num(pressure)

	if(!is_firelock) // Non-hallways don't try to act like a firelock.
		memory[memory_index] = pressure
		return

	var/old_ext_pressure = memory["exterior_pressure"]
	var/old_int_pressure = memory["interior_pressure"]
	var/is_old_ext_bad = IS_AIR_BAD(old_ext_pressure)
	var/is_old_int_bad = IS_AIR_BAD(old_int_pressure)
	memory[memory_index] = pressure

	// Don't constantly close yourself after initially doing so. Let the crew die if they force open.
	if(is_old_ext_bad || is_old_int_bad)
		return

	var/is_bad_air = pressure > WARNING_HIGH_PRESSURE || pressure < WARNING_LOW_PRESSURE
	if(is_bad_air)
		target_state = AIRLOCK_STATE_PRESSURIZE

	// Doesn't hook into the firealarm system cause that shit's awful to work with.
	if(sound_loop.is_active() && !is_bad_air)
		sound_loop.stop()
		set_light(l_power = 0)
	else if(!sound_loop.is_active() && is_bad_air)
		sound_loop.start()
		set_light(l_power = 0.8)

/obj/machinery/airlock_controller/Destroy()
	STOP_PROCESSING(SSairlocks, src)
	SSradio.remove_object(src, frequency)
	return ..()

/obj/machinery/airlock_controller/proc/post_signal(datum/signal/signal)
	ASYNC // This hot garbage fucks up if you use waitfor false.
		signal.transmission_method = TRANSMISSION_RADIO
		signal.data["packet_num"] = packetnum++
		if(radio_connection)
			radio_connection.post_signal(src, signal, range = AIRLOCK_CONTROL_RANGE, filter = RADIO_AIRLOCK)
		else
			signal = null

/obj/machinery/airlock_controller/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = SSradio.add_object(src, frequency, RADIO_AIRLOCK)

#undef IS_AIR_BAD

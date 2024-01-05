//States for airlock_control
#define AIRLOCK_STATE_INOPEN "inopen"
#define AIRLOCK_STATE_PRESSURIZE "pressurize"
#define AIRLOCK_STATE_CLOSED "closed"
#define AIRLOCK_STATE_DEPRESSURIZE "depressurize"
#define AIRLOCK_STATE_OUTOPEN "outopen"
#define AIRLOCK_STATE_OPEN "open"

#define IS_AIR_BAD(P) P > WARNING_HIGH_PRESSURE || P < WARNING_LOW_PRESSURE

/obj/machinery/airlock_controller
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "airlock_control_standby"
	base_icon_state = "airlock_control"

	name = "airlock console"
	density = FALSE

	var/frequency = FREQ_AIRLOCK_CONTROL
	var/datum/radio_frequency/radio_connection
	power_channel = AREA_USAGE_ENVIRON

	light_power = 0
	light_range = 7
	light_color = COLOR_VIVID_RED

	var/state = AIRLOCK_STATE_CLOSED
	var/target_state = AIRLOCK_STATE_CLOSED

	// Setup parameters only
	var/exterior_door_tag
	var/interior_door_tag
	var/airpump_tag
	var/sensor_tag
	var/interior_sensor_tag
	var/exterior_sensor_tag
	var/sanitize_external

	var/memory = list()

	/// If set to TRUE, enables opening both sides at once outside of maintenance and emag modes.
	/// Also enables firelock functionality. If one of the sensors are tripped, it closes the side that's fucked.
	var/is_hallway = FALSE

	/// Fire alarm sound. Used when the airlock is outside normal parameters, such as when hallway airlocks contain non-breathable air.
	var/datum/looping_sound/firealarm/sound_loop

/obj/machinery/airlock_controller/Initialize(mapload)
	. = ..()
	if(!mapload)
		return // Placed by crew. They need to configure this themselves.

	set_frequency(frequency)

	sound_loop = new(src, FALSE)

/obj/machinery/airlock_controller/update_icon_state()
	if(machine_stat & NOPOWER)
		icon_state = "[base_icon_state]_[memory["processing"] ? "process" : "standby"]"
		return ..()
	icon_state = "[base_icon_state]_off"
	return ..()

/obj/machinery/airlock_controller/Topic(href, href_list) // needed to override obj/machinery/embedded_controller/Topic, dont think its actually used in game other than here but the code is still here
	return

/obj/machinery/airlock_controller/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AirlockController", src)
		ui.open()

/obj/machinery/airlock_controller/ui_data(mob/user)
	var/list/data = list()
	data["airlockState"] = state
	data["chamberPressure"] = memory["chamber_pressure"]
	data["interiorPressure"] = memory["interior_pressure"]
	data["exteriorPressure"] = memory["exterior_pressure"]
	data["exteriorStatus"] = memory["exterior_status"]
	data["interiorStatus"] = memory["interior_status"]
	data["pumpStatus"] = memory["pump_status"]
	data["airlockDisabled"] = machine_stat & MAINT
	data["processing"] = memory["processing"]
	return data

/obj/machinery/airlock_controller/ui_act(action, params)
	. = ..()
	if(.)
		return

	switch(action)
		if("cycleClosed")
			target_state = AIRLOCK_STATE_CLOSED
		if("cycleExterior")
			target_state = AIRLOCK_STATE_OUTOPEN
		if("cycleInterior")
			target_state = AIRLOCK_STATE_INOPEN
		if("abort")
			target_state = AIRLOCK_STATE_CLOSED
		if("cycleOpen") // Only available for indoor airlocks, which come into action when atmos is unlivable on one side.
			if(!is_hallway)
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

	return TRUE

/obj/machinery/airlock_controller/receive_signal(datum/signal/signal)
	var/receive_tag = signal.data["tag"]
	if(!receive_tag)
		return

	if(receive_tag==sensor_tag)
		if(signal.data["pressure"])
			memory["chamber_pressure"] = text2num(signal.data["pressure"])

	else if(receive_tag==exterior_sensor_tag)
		handle_pressure(signal.data["pressure"], "exterior_pressure")

	else if(receive_tag==interior_sensor_tag)
		handle_pressure(signal.data["pressure"], "interior_pressure")

	else if(receive_tag==exterior_door_tag)
		memory["exterior_status"] = signal.data["door_status"]

	else if(receive_tag==interior_door_tag)
		memory["interior_status"] = signal.data["door_status"]

	else if(receive_tag==airpump_tag)
		if(signal.data["power"])
			memory["pump_status"] = signal.data["direction"]
		else
			memory["pump_status"] = "off"

	else if(receive_tag==id_tag)
		switch(signal.data["command"])
			if("cycle")
				if(state == AIRLOCK_STATE_INOPEN)
					target_state = AIRLOCK_STATE_OUTOPEN
				else
					target_state = AIRLOCK_STATE_INOPEN

/obj/machinery/airlock_controller/proc/handle_pressure(pressure, memory_index)
	if(isnull(pressure)) // Pressure can be 0!!!
		return

	if(!isnum(pressure))
		pressure = text2num(pressure)

	if(!is_hallway) // Non-hallways don't try to act like a firelock.
		memory["chamber_pressure"] = pressure
		return

	var/old_ext_pressure = memory["exterior_pressure"]
	var/old_int_pressure = memory["interior_pressure"]
	var/old_chm_pressure = memory["chamber_pressure"]
	var/is_old_ext_bad = IS_AIR_BAD(old_ext_pressure)
	var/is_old_int_bad = IS_AIR_BAD(old_int_pressure)
	var/is_old_chm_bad = IS_AIR_BAD(old_chm_pressure)
	memory[memory_index] = pressure

	// Don't constantly close yourself after initially doing so. Let the crew die if they force open.
	if(is_old_ext_bad || is_old_int_bad || is_old_chm_bad)
		return

	var/is_bad_air = pressure > WARNING_HIGH_PRESSURE || pressure < WARNING_LOW_PRESSURE
	if(is_bad_air)
		target_state = AIRLOCK_STATE_CLOSED

	// Doesn't hook into the firealarm system cause that shit's awful to work with.
	if(sound_loop.is_active() && !is_bad_air)
		sound_loop.stop()
		set_light(l_power = 0)
	else if(!sound_loop.is_active() && is_bad_air)
		sound_loop.start()
		set_light(l_power = 0.8)

/obj/machinery/airlock_controller/Destroy()
	SSradio.remove_object(src,frequency)
	return ..()

/obj/machinery/airlock_controller/proc/post_signal(datum/signal/signal)
	signal.transmission_method = TRANSMISSION_RADIO
	if(radio_connection)
		return radio_connection.post_signal(src, signal)
	else
		signal = null

/obj/machinery/airlock_controller/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = SSradio.add_object(src, frequency)

//States for airlock_control
#define AIRLOCK_STATE_INOPEN "inopen"
#define AIRLOCK_STATE_PRESSURIZE "pressurize"
#define AIRLOCK_STATE_CLOSED "closed"
#define AIRLOCK_STATE_DEPRESSURIZE "depressurize"
#define AIRLOCK_STATE_OUTOPEN "outopen"
#define AIRLOCK_STATE_OPEN "open"

#define IS_AIR_BAD(P) P > WARNING_HIGH_PRESSURE || P < WARNING_LOW_PRESSURE

/datum/computer/file/embedded_program/airlock_controller
	var/id_tag
	var/exterior_door_tag //Burn chamber facing door
	var/interior_door_tag //Station facing door
	var/airpump_tag //See: dp_vent_pump.dm
	var/sensor_tag //See: /obj/machinery/airlock_sensor
	var/exterior_sensor_tag //See: /obj/machinery/airlock_sensor
	var/interior_sensor_tag //See: /obj/machinery/airlock_sensor
	var/sanitize_external //Before the interior airlock opens, do we first drain all gases inside the chamber and then repressurize?

	/// If set to TRUE, enables opening both sides at once outside of maintenance and emag modes.
	/// Also enables firelock functionality. If one of the sensors are tripped, it closes the side that's fucked.
	var/is_hallway = FALSE

	state = AIRLOCK_STATE_CLOSED
	var/target_state = AIRLOCK_STATE_CLOSED

/datum/computer/file/embedded_program/airlock_controller/receive_signal(datum/signal/signal)
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

/datum/computer/file/embedded_program/airlock_controller/proc/handle_pressure(pressure, memory_index)
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
	var/obj/machinery/embedded_controller/radio/airlock_controller/controller = master
	if(controller.sound_loop.is_active() && !is_bad_air)
		controller.sound_loop.stop()
		controller.set_light(l_power = 0)
	else if(!controller.sound_loop.is_active() && is_bad_air)
		controller.sound_loop.start()
		controller.set_light(l_power = 0.8)

/datum/computer/file/embedded_program/airlock_controller/receive_user_command(command)
	switch(command)
		if("cycleClosed")
			target_state = AIRLOCK_STATE_CLOSED
		if("cycleExterior")
			target_state = AIRLOCK_STATE_OUTOPEN
		if("cycleInterior")
			target_state = AIRLOCK_STATE_INOPEN
		if("abort")
			target_state = AIRLOCK_STATE_CLOSED
		if("cycleOpen") // Only available for indoor airlocks, which come into action when atmos is unlivable on one side.
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

/datum/computer/file/embedded_program/airlock_controller/process()
	var/sensor_pressure = memory["chamber_pressure"]
	switch(state)
		if(AIRLOCK_STATE_OPEN)
			if(target_state == AIRLOCK_STATE_INOPEN)
				if(sensor_pressure >= ONE_ATMOSPHERE*0.95)
					if(memory["interior_status"] == "open" && memory["exterior_status"] == "open")
						state = AIRLOCK_STATE_OPEN
					else
						if(memory["interior_status"] == "closed")
							post_signal(new /datum/signal(list(
								"tag" = interior_door_tag,
								"command" = "secure_open",
							)))
						if(memory["exterior_status"] == "closed")
							post_signal(new /datum/signal(list(
								"tag" = exterior_door_tag,
								"command" = "secure_open",
							)))
				else
					var/datum/signal/signal = new(list(
						"tag" = airpump_tag,
						"sigtype" = "command"
					))
					if(memory["pump_status"] == "siphon")
						signal.data["stabilize"] = TRUE
					else if(memory["pump_status"] != "release")
						signal.data["power"] = TRUE
					post_signal(signal)
			else
				state = AIRLOCK_STATE_CLOSED

		if(AIRLOCK_STATE_INOPEN)
			if(target_state != state)
				if(memory["interior_status"] == "closed")
					state = AIRLOCK_STATE_CLOSED
				else
					post_signal(new /datum/signal(list(
						"tag" = interior_door_tag,
						"command" = "secure_close"
					)))
			else
				if(memory["pump_status"] != "off")
					post_signal(new /datum/signal(list(
						"tag" = airpump_tag,
						"power" = FALSE,
						"sigtype" = "command"
					)))

		if(AIRLOCK_STATE_PRESSURIZE)
			if(target_state == AIRLOCK_STATE_INOPEN || target_state == AIRLOCK_STATE_OPEN)
				if(sensor_pressure >= ONE_ATMOSPHERE*0.95 && target_state == AIRLOCK_STATE_INOPEN)
					if(memory["interior_status"] == "open")
						state = AIRLOCK_STATE_INOPEN
					else
						post_signal(new /datum/signal(list(
							"tag" = interior_door_tag,
							"command" = "secure_open"
						)))
				else if(sensor_pressure >= ONE_ATMOSPHERE*0.95 && target_state == AIRLOCK_STATE_OPEN)
					if(memory["interior_status"] == "open" && memory["exterior_status"] == "open")
						state = AIRLOCK_STATE_OPEN
					else
						post_signal(new /datum/signal(list(
							"tag" = interior_door_tag,
							"command" = "secure_open"
						)))
						post_signal(new /datum/signal(list(
							"tag" = exterior_door_tag,
							"command" = "secure_open"
						)))

				else
					var/datum/signal/signal = new(list(
						"tag" = airpump_tag,
						"sigtype" = "command"
					))
					if(memory["pump_status"] == "siphon")
						signal.data["stabilize"] = TRUE
					else if(memory["pump_status"] != "release")
						signal.data["power"] = TRUE
					post_signal(signal)
			else
				state = AIRLOCK_STATE_CLOSED

		if(AIRLOCK_STATE_CLOSED)
			if(target_state == AIRLOCK_STATE_OUTOPEN)
				if(memory["interior_status"] == "closed")
					state = AIRLOCK_STATE_DEPRESSURIZE
				else
					post_signal(new /datum/signal(list(
						"tag" = interior_door_tag,
						"command" = "secure_close"
					)))
					post_signal(new /datum/signal(list(
						"tag" = exterior_door_tag,
						"command" = "secure_close"
					)))
			else if(target_state == AIRLOCK_STATE_INOPEN)
				if(memory["exterior_status"] == "closed")
					state = AIRLOCK_STATE_PRESSURIZE
				else
					post_signal(new /datum/signal(list(
						"tag" = interior_door_tag,
						"command" = "secure_close"
					)))
					post_signal(new /datum/signal(list(
						"tag" = exterior_door_tag,
						"command" = "secure_close"
					)))
			else if(target_state == AIRLOCK_STATE_OPEN)
				if(sensor_pressure >= ONE_ATMOSPHERE*0.95)
					post_signal(new /datum/signal(list(
						"tag" = interior_door_tag,
						"command" = "secure_open"
					)))
					post_signal(new /datum/signal(list(
						"tag" = exterior_door_tag,
						"command" = "secure_open"
					)))
				else
					state = AIRLOCK_STATE_PRESSURIZE

			else
				if(memory["pump_status"] != "off")
					post_signal(new /datum/signal(list(
						"tag" = airpump_tag,
						"power" = FALSE,
						"sigtype" = "command"
					)))

		if(AIRLOCK_STATE_DEPRESSURIZE)
			var/target_pressure = ONE_ATMOSPHERE*0.05
			if(sanitize_external)
				target_pressure = ONE_ATMOSPHERE*0.01

			if(sensor_pressure <= target_pressure)
				if(target_state == AIRLOCK_STATE_OUTOPEN)
					if(memory["exterior_status"] == "open")
						state = AIRLOCK_STATE_OUTOPEN
					else
						post_signal(new /datum/signal(list(
							"tag" = exterior_door_tag,
							"command" = "secure_open"
						)))
				else
					state = AIRLOCK_STATE_CLOSED
			else if((target_state != AIRLOCK_STATE_OUTOPEN) && !sanitize_external)
				state = AIRLOCK_STATE_CLOSED
			else
				var/datum/signal/signal = new(list(
					"tag" = airpump_tag,
					"sigtype" = "command"
				))
				if(memory["pump_status"] == "release")
					signal.data["purge"] = TRUE
				else if(memory["pump_status"] != "siphon")
					signal.data["power"] = TRUE
				post_signal(signal)

		if(AIRLOCK_STATE_OUTOPEN) //state 2
			if(target_state != AIRLOCK_STATE_OUTOPEN)
				if(memory["exterior_status"] == "closed")
					if(sanitize_external)
						state = AIRLOCK_STATE_DEPRESSURIZE
					else
						state = AIRLOCK_STATE_CLOSED
				else
					post_signal(new /datum/signal(list(
						"tag" = exterior_door_tag,
						"command" = "secure_close"
					)))
			else
				if(memory["pump_status"] != "off")
					post_signal(new /datum/signal(list(
						"tag" = airpump_tag,
						"power" = FALSE,
						"sigtype" = "command"
					)))

	memory["processing"] = state != target_state

	return TRUE

/obj/machinery/embedded_controller/radio/airlock_controller
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "airlock_control_standby"
	base_icon_state = "airlock_control"

	name = "airlock console"
	density = FALSE

	frequency = FREQ_AIRLOCK_CONTROL
	power_channel = AREA_USAGE_ENVIRON

	light_power = 0
	light_range = 7
	light_color = COLOR_VIVID_RED

	// Setup parameters only
	var/exterior_door_tag
	var/interior_door_tag
	var/airpump_tag
	var/sensor_tag
	var/interior_sensor_tag
	var/exterior_sensor_tag
	var/sanitize_external

	/// Fire alarm sound. Used when the airlock is outside normal parameters, such as when hallway airlocks contain non-breathable air.
	var/datum/looping_sound/firealarm/sound_loop

/obj/machinery/embedded_controller/radio/airlock_controller/Initialize(mapload)
	. = ..()
	if(!mapload)
		return

	sound_loop = new(src, FALSE)

	var/datum/computer/file/embedded_program/airlock_controller/new_prog = new

	new_prog.id_tag = id_tag
	new_prog.exterior_door_tag = exterior_door_tag
	new_prog.interior_door_tag = interior_door_tag
	new_prog.airpump_tag = airpump_tag
	new_prog.sensor_tag = sensor_tag
	new_prog.sanitize_external = sanitize_external

	new_prog.master = src
	program = new_prog

/obj/machinery/embedded_controller/radio/airlock_controller/update_icon_state()
	if(on && program)
		icon_state = "[base_icon_state]_[program.memory["processing"] ? "process" : "standby"]"
		return ..()
	icon_state = "[base_icon_state]_off"
	return ..()

/obj/machinery/embedded_controller/radio/airlock_controller/Topic(href, href_list) // needed to override obj/machinery/embedded_controller/Topic, dont think its actually used in game other than here but the code is still here
	return

/obj/machinery/embedded_controller/radio/airlock_controller/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AirlockController", src)
		ui.open()

/obj/machinery/embedded_controller/radio/airlock_controller/process(delta_time)
	if(program)
		program.process(delta_time)

	update_appearance()
	SStgui.update_uis(src)

/obj/machinery/embedded_controller/radio/airlock_controller/ui_data(mob/user)
	var/list/data = list()
	data["airlockState"] = program.state
	data["chamberPressure"] = program.memory["chamber_pressure"]
	data["interiorPressure"] = program.memory["interior_pressure"]
	data["exteriorPressure"] = program.memory["exterior_pressure"]
	data["exteriorStatus"] = program.memory["exterior_status"]
	data["interiorStatus"] = program.memory["interior_status"]
	data["pumpStatus"] = program.memory["pump_status"]
	data["airlockDisabled"] = machine_stat & MAINT
	data["processing"] = program.memory["processing"]
	return data

/obj/machinery/embedded_controller/radio/airlock_controller/ui_act(action, params)
	. = ..()
	if(.)
		return
	// no need for sanitisation, command just changes target_state and can't do anything else
	process_command(action)
	return TRUE

/obj/machinery/embedded_controller/radio/airlock_controller/incinerator_ordmix
	name = "Incinerator Access Console"
	airpump_tag = INCINERATOR_ORDMIX_DP_VENTPUMP
	exterior_door_tag = INCINERATOR_ORDMIX_AIRLOCK_EXTERIOR
	id_tag = INCINERATOR_ORDMIX_AIRLOCK_CONTROLLER
	interior_door_tag = INCINERATOR_ORDMIX_AIRLOCK_INTERIOR
	sanitize_external = TRUE
	sensor_tag = INCINERATOR_ORDMIX_AIRLOCK_SENSOR

/obj/machinery/embedded_controller/radio/airlock_controller/incinerator_atmos
	name = "Incinerator Access Console"
	airpump_tag = INCINERATOR_ATMOS_DP_VENTPUMP
	exterior_door_tag = INCINERATOR_ATMOS_AIRLOCK_EXTERIOR
	id_tag = INCINERATOR_ATMOS_AIRLOCK_CONTROLLER
	interior_door_tag = INCINERATOR_ATMOS_AIRLOCK_INTERIOR
	sanitize_external = TRUE
	sensor_tag = INCINERATOR_ATMOS_AIRLOCK_SENSOR

/obj/machinery/embedded_controller/radio/airlock_controller/incinerator_syndicatelava
	name = "Incinerator Access Console"
	airpump_tag = INCINERATOR_SYNDICATELAVA_DP_VENTPUMP
	exterior_door_tag = INCINERATOR_SYNDICATELAVA_AIRLOCK_EXTERIOR
	id_tag = INCINERATOR_SYNDICATELAVA_AIRLOCK_CONTROLLER
	interior_door_tag = INCINERATOR_SYNDICATELAVA_AIRLOCK_INTERIOR
	sanitize_external = TRUE
	sensor_tag = INCINERATOR_SYNDICATELAVA_AIRLOCK_SENSOR

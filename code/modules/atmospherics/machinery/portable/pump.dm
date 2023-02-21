///Maximum settable pressure
#define PUMP_MAX_PRESSURE (ONE_ATMOSPHERE * 25)
///Minimum settable pressure
#define PUMP_MIN_PRESSURE (ONE_ATMOSPHERE / 10)
///Defaul pressure, used in the UI to reset the settings
#define PUMP_DEFAULT_PRESSURE (ONE_ATMOSPHERE)
///What direction is the machine pumping (into pump/port or out to the tank/area)?
#define PUMP_IN TRUE
#define PUMP_OUT FALSE

/obj/machinery/portable_atmospherics/pump
	name = "portable air pump"
	icon_state = "siphon"
	density = TRUE
	max_integrity = 250
	///Is the machine on?
	var/on = FALSE
	///What direction is the machine pumping (into pump/port or out to the tank/area)?
	var/direction = PUMP_OUT
	///Player configurable, sets what's the release pressure
	var/target_pressure = ONE_ATMOSPHERE

	/// The passive sounds this scrubber emits.
	var/datum/looping_sound/sound_loop

	volume = 1000

/obj/machinery/portable_atmospherics/pump/New(loc, ...)
	sound_loop = new /datum/looping_sound/air_pump(src)
	sound_loop.volume = 25 // This is loud.
	sound_loop.falloff_distance = SOUND_DEFAULT_FALLOFF_DISTANCE
	. = ..()

/obj/machinery/portable_atmospherics/pump/Destroy()
	var/turf/local_turf = get_turf(src)
	local_turf.assume_air(air_contents)
	return ..()

/obj/machinery/portable_atmospherics/pump/update_icon_state()
	icon_state = "[initial(icon_state)]_[on]"
	if(on)
		sound_loop.start()
	else
		sound_loop.stop()
	return ..()

/obj/machinery/portable_atmospherics/pump/update_overlays()
	. = ..()
	if(holding)
		. += "siphon-open"
	if(connected_port)
		. += "siphon-connector"

/obj/machinery/portable_atmospherics/pump/process_atmos()
	var/pressure = air_contents.returnPressure()
	var/temperature = air_contents.temperature
	///function used to check the limit of the pumps and also set the amount of damage that the pump can receive, if the heat and pressure are way higher than the limit the more damage will be done
	if(temperature > temp_limit || pressure > pressure_limit)
		take_damage(clamp((temperature/temp_limit) * (pressure/pressure_limit), 5, 50), BURN, 0)
		excited = TRUE
		return ..()

	if(!on)
		return ..()

	excited = TRUE

	var/pressure_delta
	var/output_volume
	var/air_temperature
	var/turf/local_turf = get_turf(src)
	var/datum/gas_mixture/environment
	if(holding)
		environment = holding.air_contents
	else
		environment = local_turf.unsafe_return_air() //We SAFE_ZAS_UPDATE later!

	if(direction == PUMP_OUT)
		pressure_delta = target_pressure - environment.returnPressure()
		output_volume = environment.volume * environment.group_multiplier
		air_temperature = environment.temperature? environment.temperature : air_contents.temperature
	else
		pressure_delta = environment.returnPressure() - target_pressure
		output_volume = air_contents.volume * air_contents.group_multiplier
		air_temperature = air_contents.temperature? air_contents.temperature : environment.temperature

	var/transfer_moles = pressure_delta*output_volume/(air_temperature * R_IDEAL_GAS_EQUATION)

	if (pressure_delta > 0.01)
		if (direction == PUMP_OUT)
			pump_gas(air_contents, environment, transfer_moles)
		else
			draw = pump_gas(environment, air_contents, transfer_moles, power_rating)
		ATMOS_USE_POWER(draw)
		if(!holding)
			SAFE_ZAS_UPDATE(local_turf)

	return ..()

/obj/machinery/portable_atmospherics/pump/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	if(!is_operational)
		return
	if(prob(50 / severity))
		on = !on
		if(on)
			SSairmachines.start_processing_machine(src)
	if(prob(100 / severity))
		direction = PUMP_OUT
	target_pressure = rand(0, 100 * ONE_ATMOSPHERE)
	update_appearance()

/obj/machinery/portable_atmospherics/pump/replace_tank(mob/living/user, close_valve)
	. = ..()
	if(!.)
		return
	if(close_valve)
		if(on)
			on = FALSE
			update_appearance()
	else if(on && holding && direction == PUMP_OUT)
		investigate_log("[key_name(user)] started a transfer into [holding].", INVESTIGATE_ATMOS)

/obj/machinery/portable_atmospherics/pump/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PortablePump", name)
		ui.open()

/obj/machinery/portable_atmospherics/pump/ui_data()
	var/data = list()
	data["on"] = on
	data["direction"] = direction == PUMP_IN ? TRUE : FALSE
	data["connected"] = connected_port ? TRUE : FALSE
	data["pressure"] = round(air_contents.returnPressure() ? air_contents.returnPressure() : 0)
	data["tartargetPressureget_pressure"] = round(target_pressure ? target_pressure : 0)
	data["defaultPressure"] = round(PUMP_DEFAULT_PRESSURE)
	data["minPressure"] = round(PUMP_MIN_PRESSURE)
	data["maxPressure"] = round(PUMP_MAX_PRESSURE)

	if(holding)
		data["holding"] = list()
		data["holding"]["name"] = holding.name
		var/datum/gas_mixture/holding_mix = holding.return_air()
		data["holding"]["pressure"] = round(holding_mix.returnPressure())
	else
		data["holding"] = null
	return data

/obj/machinery/portable_atmospherics/pump/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		if("power")
			on = !on
			if(on)
				SSairmachines.start_processing_machine(src)
			if(on && !holding)
				var/plasma = air_contents.getGroupGas(GAS_PLASMA)
				var/n2o = air_contents.getGroupGas(GAS_N2O)
				if(n2o || plasma)
					message_admins("[ADMIN_LOOKUPFLW(usr)] turned on a pump that contains [n2o ? "N2O" : ""][n2o && plasma ? " & " : ""][plasma ? "Plasma" : ""] at [ADMIN_VERBOSEJMP(src)]")
					log_admin("[key_name(usr)] turned on a pump that contains [n2o ? "N2O" : ""][n2o && plasma ? " & " : ""][plasma ? "Plasma" : ""] at [AREACOORD(src)]")
			else if(on && direction == PUMP_OUT)
				investigate_log("[key_name(usr)] started a transfer into [holding].", INVESTIGATE_ATMOS)
			. = TRUE
		if("direction")
			if(direction == PUMP_OUT)
				direction = PUMP_IN
			else
				if(on && holding)
					investigate_log("[key_name(usr)] started a transfer into [holding].", INVESTIGATE_ATMOS)
				direction = PUMP_OUT
			. = TRUE
		if("pressure")
			var/pressure = params["pressure"]
			if(pressure == "reset")
				pressure = PUMP_DEFAULT_PRESSURE
				. = TRUE
			else if(pressure == "min")
				pressure = PUMP_MIN_PRESSURE
				. = TRUE
			else if(pressure == "max")
				pressure = PUMP_MAX_PRESSURE
				. = TRUE
			else if(text2num(pressure) != null)
				pressure = text2num(pressure)
				. = TRUE
			if(.)
				target_pressure = clamp(round(pressure), PUMP_MIN_PRESSURE, PUMP_MAX_PRESSURE)
				investigate_log("was set to [target_pressure] kPa by [key_name(usr)].", INVESTIGATE_ATMOS)
		if("eject")
			if(holding)
				replace_tank(usr, FALSE)
				. = TRUE
	update_appearance()

/obj/machinery/portable_atmospherics/pump/unregister_holding()
	on = FALSE
	return ..()

/obj/machinery/portable_atmospherics/pump/lil_pump
	name = "Lil' Pump"

/obj/machinery/portable_atmospherics/pump/lil_pump/Initialize(mapload)
	. = ..()
	//25% chance to occur
	if(prob(25))
		name = "Liler' Pump"
		desc = "When a Lil' Pump and a portable air pump love each other very much."
		var/matrix/lil_pump = matrix()
		lil_pump.Scale(0.8)
		src.transform = lil_pump

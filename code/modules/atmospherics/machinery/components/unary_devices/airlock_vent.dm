// This is a lot of copy-paste, but there's no way to subtype this without treating them like vent pumps, which I don't want at all.

#define EXT_BOUND 1
#define INT_BOUND 2
#define NO_BOUND 3

#define SIPHONING "sipon"
#define RELEASING "release"

/obj/machinery/atmospherics/components/unary/airlock_vent
	icon_state = "vent_map-3"

	name = "airlock air pump"
	desc = "Has a valve and pump attached to it. Too small for anything to fit inside."

	use_power = IDLE_POWER_USE
	idle_power_usage = BASE_MACHINE_IDLE_CONSUMPTION * 0.15
	can_unwrench = TRUE
	layer = GAS_SCRUBBER_LAYER
	hide = TRUE
	shift_underlay_only = FALSE
	pipe_state = "uvent"
	vent_movement = NONE

	///Direction of pumping the gas (RELEASING or SIPHONING)
	var/pump_direction = RELEASING
	///Should we check internal pressure, external pressure, both or none? (EXT_BOUND, INT_BOUND, NO_BOUND)
	var/pressure_checks = EXT_BOUND
	///The external pressure threshold (default 101 kPa)
	var/external_pressure_bound = ONE_ATMOSPHERE
	///The internal pressure threshold (default 0 kPa)
	var/internal_pressure_bound = 0
	// EXT_BOUND: Do not pass external_pressure_bound
	// INT_BOUND: Do not pass internal_pressure_bound
	// NO_BOUND: Do not pass either

	///Frequency id for connecting to the NTNet. These should not be used for anything but airlocks.
	var/frequency = FREQ_AIRLOCK_CONTROL
	///Reference to the radio datum
	var/datum/radio_frequency/radio_connection

	/// The passive sounds this scrubber emits.
	var/datum/looping_sound/sound_loop

/obj/machinery/atmospherics/components/unary/airlock_vent/New()
	sound_loop = new /datum/looping_sound/air_pump(src, FALSE)
	if(!id_tag)
		id_tag = assign_random_name()
		var/static/list/tool_screentips = list(
			TOOL_MULTITOOL = list(
				SCREENTIP_CONTEXT_LMB = "Log to link later with air sensor",
			)
		)
		AddElement(/datum/element/contextual_screentip_tools, tool_screentips)
	. = ..()

/obj/machinery/atmospherics/components/unary/airlock_vent/Destroy()
	var/area/vent_area = get_area(src)
	if(vent_area)
		vent_area.airlock_vent_info -= id_tag
		GLOB.airlock_vent_names -= id_tag

	SSradio.remove_object(src,frequency)
	radio_connection = null
	return ..()

/obj/machinery/atmospherics/components/unary/airlock_vent/update_icon_nopipes()
	cut_overlays()
	if(showpipe)
		var/image/cap = get_pipe_image(icon, "vent_cap", initialize_directions)
		add_overlay(cap)
	else
		PIPING_LAYER_SHIFT(src, PIPING_LAYER_DEFAULT)

	if(!nodes[1] || !on || !is_operational)
		sound_loop.stop()
		if(icon_state == "vent_welded")
			icon_state = "vent_off"
			return

		if(pump_direction == RELEASING)
			icon_state = "vent_out-off"
		else // pump_direction == SIPHONING
			icon_state = "vent_in-off"
		return

	sound_loop.start()

	if(icon_state == ("vent_out-off" || "vent_in-off" || "vent_off"))
		if(pump_direction == RELEASING)
			icon_state = "vent_out"
			flick("vent_out-starting", src)
		else // pump_direction == SIPHONING
			icon_state = "vent_in"
			flick("vent_in-starting", src)
		return

	if(pump_direction == RELEASING)
		icon_state = "vent_out"
	else // pump_direction == SIPHONING
		icon_state = "vent_in"

/obj/machinery/atmospherics/components/unary/airlock_vent/process_atmos()
	if(!is_operational)
		return
	if(!nodes[1])
		on = FALSE
	if(!on)
		return
	var/turf/open/us = loc
	if(!istype(us))
		return
	var/datum/gas_mixture/air_contents = airs[1]
	var/datum/gas_mixture/environment = us.return_air()
	var/environment_pressure = environment.return_pressure()

	if(pump_direction == RELEASING) // internal -> external
		var/pressure_delta = 10000

		if(pressure_checks&EXT_BOUND)
			pressure_delta = min(pressure_delta, (external_pressure_bound - environment_pressure))
		if(pressure_checks&INT_BOUND)
			pressure_delta = min(pressure_delta, (air_contents.return_pressure() - internal_pressure_bound))

		if(pressure_delta > 0)
			if(air_contents.temperature > 0)
				var/transfer_moles = (pressure_delta * environment.volume) / (air_contents.temperature * R_IDEAL_GAS_EQUATION)
				var/datum/gas_mixture/removed = air_contents.remove(transfer_moles)

				if(!removed || !removed.total_moles())
					return

				loc.assume_air(removed)
				update_parents()

	else // external -> internal
		var/pressure_delta = 10000
		if(pressure_checks&EXT_BOUND)
			pressure_delta = min(pressure_delta, (environment_pressure - external_pressure_bound))
		if(pressure_checks&INT_BOUND)
			pressure_delta = min(pressure_delta, (internal_pressure_bound - air_contents.return_pressure()))

		if(pressure_delta > 0 && environment.temperature > 0)
			var/transfer_moles = (pressure_delta * air_contents.volume) / (environment.temperature * R_IDEAL_GAS_EQUATION)

			var/datum/gas_mixture/removed = loc.remove_air(transfer_moles)

			if(!removed || !removed.total_moles()) //No venting from space 4head
				return

			air_contents.merge(removed)
			update_parents()

//Radio remote control

/obj/machinery/atmospherics/components/unary/airlock_vent/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency = new_frequency
	if(frequency)
		radio_connection = SSradio.add_object(src, frequency)

/obj/machinery/atmospherics/components/unary/airlock_vent/proc/broadcast_status()
	if(!radio_connection)
		return

	var/datum/signal/signal = new(list(
		"tag" = id_tag,
		"frequency" = frequency,
		"device" = "AVP",
		"timestamp" = world.time,
		"power" = on,
		"direction" = pump_direction,
		"checks" = pressure_checks,
		"internal" = internal_pressure_bound,
		"external" = external_pressure_bound,
		"sigtype" = "status"
	))

	var/area/vent_area = get_area(src)
	if(!GLOB.airlock_vent_names[id_tag])
		// If we do not have a name, assign one.
		// Produces names like "Port Quarter Solar vent pump hZ2l6".
		update_name()
		GLOB.airlock_vent_names[id_tag] = name

	vent_area.airlock_vent_info[id_tag] = signal.data

	radio_connection.post_signal(src, signal)

/obj/machinery/atmospherics/components/unary/airlock_vent/update_name()
	. = ..()
	if(override_naming)
		return
	var/area/vent_area = get_area(src)
	name = "\proper [vent_area.name] [name] [id_tag]"


/obj/machinery/atmospherics/components/unary/airlock_vent/atmos_init()
	if(frequency)
		set_frequency(frequency)
	broadcast_status()
	..()

/obj/machinery/atmospherics/components/unary/airlock_vent/receive_signal(datum/signal/signal)
	if(!is_operational)
		return
	// log_admin("DEBUG \[[world.timeofday]\]: /obj/machinery/atmospherics/components/unary/airlock_vent/receive_signal([signal.debug_print()])")
	if(!signal.data["tag"] || (signal.data["tag"] != id_tag) || (signal.data["sigtype"]!="command"))
		return

	var/atom/signal_sender = signal.data["user"]

	if("purge" in signal.data)
		pressure_checks &= ~EXT_BOUND
		pump_direction = SIPHONING
		investigate_log("pump direction was set to [pump_direction] by [key_name(signal_sender)]", INVESTIGATE_ATMOS)

	if("stabilize" in signal.data)
		pressure_checks |= EXT_BOUND
		pump_direction = RELEASING
		investigate_log("pump direction was set to [pump_direction] by [key_name(signal_sender)]", INVESTIGATE_ATMOS)

	if("power" in signal.data)
		on = text2num(signal.data["power"])

	if("power_toggle" in signal.data)
		on = !on

	if("checks" in signal.data)
		var/old_checks = pressure_checks
		pressure_checks = text2num(signal.data["checks"])
		if(pressure_checks != old_checks)
			investigate_log(" pressure checks were set to [pressure_checks] by [key_name(signal_sender)]",INVESTIGATE_ATMOS)

	if("checks_toggle" in signal.data)
		pressure_checks = (pressure_checks?0:NO_BOUND)

	if("direction" in signal.data)
		pump_direction = text2num(signal.data["direction"])

	if("set_internal_pressure" in signal.data)
		var/old_pressure = internal_pressure_bound
		internal_pressure_bound = clamp(text2num(signal.data["set_internal_pressure"]),0,ONE_ATMOSPHERE*50)
		if(old_pressure != internal_pressure_bound)
			investigate_log(" internal pressure was set to [internal_pressure_bound] by [key_name(signal_sender)]",INVESTIGATE_ATMOS)

	if("set_external_pressure" in signal.data)
		var/old_pressure = external_pressure_bound
		external_pressure_bound = clamp(text2num(signal.data["set_external_pressure"]),0,ONE_ATMOSPHERE*50)
		if(old_pressure != external_pressure_bound)
			investigate_log(" external pressure was set to [external_pressure_bound] by [key_name(signal_sender)]",INVESTIGATE_ATMOS)

	if("reset_external_pressure" in signal.data)
		external_pressure_bound = ONE_ATMOSPHERE

	if("reset_internal_pressure" in signal.data)
		internal_pressure_bound = 0

	if("adjust_internal_pressure" in signal.data)
		internal_pressure_bound = clamp(internal_pressure_bound + text2num(signal.data["adjust_internal_pressure"]),0,ONE_ATMOSPHERE*50)

	if("adjust_external_pressure" in signal.data)
		external_pressure_bound = clamp(external_pressure_bound + text2num(signal.data["adjust_external_pressure"]),0,ONE_ATMOSPHERE*50)

	if("init" in signal.data)
		name = signal.data["init"]
		return

	if("status" in signal.data)
		broadcast_status()
		return // do not update_appearance

		// log_admin("DEBUG \[[world.timeofday]\]: airlock_vent/receive_signal: unknown command \"[signal.data["command"]]\"\n[signal.debug_print()]")
	broadcast_status()
	update_appearance()

/obj/machinery/atmospherics/components/unary/airlock_vent/can_unwrench(mob/user)
	. = ..()
	if(. && on && is_operational)
		to_chat(user, span_warning("You cannot unwrench [src], turn it off first!"))
		return FALSE

/obj/machinery/atmospherics/components/unary/airlock_vent/power_change()
	. = ..()
	update_icon_nopipes()

/obj/machinery/atmospherics/components/unary/airlock_vent/high_volume
	name = "large air vent"
	power_channel = AREA_USAGE_EQUIP

/obj/machinery/atmospherics/components/unary/airlock_vent/high_volume/New()
	..()
	var/datum/gas_mixture/air_contents = airs[1]
	air_contents.volume = 1000

// mapping

/obj/machinery/atmospherics/components/unary/airlock_vent/layer4
	piping_layer = 4
	icon_state = "vent_map-4"

/obj/machinery/atmospherics/components/unary/airlock_vent/supply
	pipe_color = COLOR_BLUE

/obj/machinery/atmospherics/components/unary/airlock_vent/supply/layer4
	piping_layer = 4
	icon_state = "vent_map-4"

#undef INT_BOUND
#undef EXT_BOUND
#undef NO_BOUND

#undef SIPHONING
#undef RELEASING

#define SIPHONING 0
#define SCRUBBING 1

/obj/machinery/atmospherics/components/unary/vent_scrubber
	icon_state = "scrub_map-3"

	name = "air scrubber"
	desc = "Has a valve and pump attached to it."
	use_power = IDLE_POWER_USE
	idle_power_usage = BASE_MACHINE_IDLE_CONSUMPTION * 0.1

	can_unwrench = TRUE
	welded = FALSE
	layer = GAS_SCRUBBER_LAYER
	hide = TRUE
	shift_underlay_only = FALSE
	pipe_state = "scrubber"
	vent_movement = VENTCRAWL_ALLOWED | VENTCRAWL_CAN_SEE | VENTCRAWL_ENTRANCE_ALLOWED
	processing_flags = NONE

	power_rating = 30000

	///The mode of the scrubber (SCRUBBING or SIPHONING)
	var/scrubbing = SCRUBBING //0 = siphoning, 1 = scrubbing
	///The list of gases we are filtering
	var/list/filter_types = list(GAS_CO2, GAS_RADON, GAS_PLASMA)
	///Rate of the scrubber to remove gases from the air
	var/volume_rate = MAX_SCRUBBER_FLOWRATE
	///A fast-siphon toggle, siphons at 9x speed for 9x the power cost.
	var/quicksucc = FALSE

	///Frequency id for connecting to the NTNet
	var/frequency = FREQ_ATMOS_CONTROL
	///Reference to the radio datum
	var/datum/radio_frequency/radio_connection
	///Radio connection to the air alarm
	var/radio_filter_out
	///Radio connection from the air alarm
	var/radio_filter_in

	//Enables the use of plunger_act for ending the vent clog random event
	var/clogged = FALSE

	/// The passive sounds this scrubber emits.
	var/datum/looping_sound/sound_loop

/obj/machinery/atmospherics/components/unary/vent_scrubber/New()
	sound_loop = new /datum/looping_sound/air_pump(src, FALSE)
	if(!id_tag)
		id_tag = assign_random_name()
	. = ..()
	for(var/to_filter in filter_types)
		if(istext(to_filter))
			filter_types -= to_filter
			filter_types += to_filter

/obj/machinery/atmospherics/components/unary/vent_scrubber/Initialize(mapload)
	. = ..()
	SSairmachines.start_processing_machine(src)

/obj/machinery/atmospherics/components/unary/vent_scrubber/Destroy()
	var/area/scrub_area = get_area(src)
	if(scrub_area)
		scrub_area.air_scrub_info -= id_tag
		GLOB.air_scrub_names -= id_tag

	SSradio.remove_object(src,frequency)
	radio_connection = null
	SSairmachines.stop_processing_machine(src)
	return ..()

///adds a gas or list of gases to our filter_types. used so that the scrubber can check if its supposed to be processing after each change
/obj/machinery/atmospherics/components/unary/vent_scrubber/proc/add_filters(filter_or_filters)
	if(!islist(filter_or_filters))
		filter_or_filters = list(filter_or_filters)

	for(var/gas_to_filter in filter_or_filters)
		filter_types |= gas_to_filter

	var/turf/our_turf = get_turf(src)

	if(!our_turf.simulated)
		return FALSE

	var/datum/gas_mixture/turf_gas = our_turf.air
	if(!turf_gas)
		return FALSE

	return TRUE

///remove a gas or list of gases from our filter_types.used so that the scrubber can check if its supposed to be processing after each change
/obj/machinery/atmospherics/components/unary/vent_scrubber/proc/remove_filters(filter_or_filters)
	if(!islist(filter_or_filters))
		filter_or_filters = list(filter_or_filters)

	for(var/gas_to_filter in filter_or_filters)
		filter_types -= gas_to_filter

	return TRUE

/obj/machinery/atmospherics/components/unary/vent_scrubber/proc/toggle_filters(filter_or_filters)
	if(!islist(filter_or_filters))
		filter_or_filters = list(filter_or_filters)

	for(var/gas_to_filter in filter_or_filters)
		if(gas_to_filter in filter_types)
			filter_types -= gas_to_filter
		else
			filter_types |= gas_to_filter

	return TRUE

/obj/machinery/atmospherics/components/unary/vent_scrubber/update_icon_nopipes()
	cut_overlays()
	if(showpipe)
		var/image/cap = get_pipe_image(icon, "scrub_cap", initialize_directions)
		add_overlay(cap)
	else
		PIPING_LAYER_SHIFT(src, PIPING_LAYER_DEFAULT)

	if(welded)
		sound_loop.stop()
		icon_state = "scrub_welded"
		return

	if(!nodes[1] || !on || !is_operational)
		sound_loop.stop()
		icon_state = "scrub_off"
		return

	sound_loop.start()

	if(scrubbing & SCRUBBING)
		if(quicksucc)
			icon_state = "scrub_wide"
		else
			icon_state = "scrub_on"
	else //scrubbing == SIPHONING
		icon_state = "scrub_purge"

/obj/machinery/atmospherics/components/unary/vent_scrubber/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = SSradio.add_object(src, frequency, radio_filter_in)

/obj/machinery/atmospherics/components/unary/vent_scrubber/proc/broadcast_status()
	if(!radio_connection)
		return FALSE

	var/list/f_types = list()
	for(var/gas_id in ASSORTED_GASES)
		f_types += list(list("gas_id" = gas_id, "gas_name" = gas_id, "enabled" = (gas_id in filter_types)))

	var/datum/signal/signal = new(list(
		"tag" = id_tag,
		"frequency" = frequency,
		"device" = "VS",
		"timestamp" = world.time,
		"power" = on,
		"scrubbing" = scrubbing,
		"quicksucc" = quicksucc,
		"filter_types" = f_types,
		"sigtype" = "status"
	))

	var/area/scrub_area = get_area(src)
	if(!GLOB.air_scrub_names[id_tag])
		// If we do not have a name, assign one
		update_name()
		GLOB.air_scrub_names[id_tag] = name

	scrub_area.air_scrub_info[id_tag] = signal.data

	radio_connection.post_signal(src, signal, radio_filter_out)

	return TRUE

/obj/machinery/atmospherics/components/unary/vent_scrubber/update_name()
	. = ..()
	if(override_naming)
		return
	var/area/scrub_area = get_area(src)
	name = "\proper [scrub_area.name] [name] [id_tag]"

/obj/machinery/atmospherics/components/unary/vent_scrubber/atmos_init()
	radio_filter_in = frequency == initial(frequency) ? RADIO_FROM_AIRALARM : null
	radio_filter_out = frequency == initial(frequency) ? RADIO_TO_AIRALARM : null
	if(frequency)
		set_frequency(frequency)
	broadcast_status()
	. = ..()

/obj/machinery/atmospherics/components/unary/vent_scrubber/process_atmos()
	if(welded || !is_operational)
		return
	if(!on || !nodes[1])
		on = FALSE
		return
	var/turf/open/us = loc
	if(!istype(us))
		return

	if(scrub(us))
		if(quicksucc)
			scrub(us)
		SAFE_ZAS_UPDATE(us)

	update_icon_nopipes()

	return TRUE

///filtered gases at or below this amount automatically get removed from the mix
#define MINIMUM_MOLES_TO_SCRUB MOLAR_ACCURACY*100

/obj/machinery/atmospherics/components/unary/vent_scrubber/proc/scrub(turf/tile)
	if(!istype(tile))
		return FALSE
	var/datum/gas_mixture/environment = tile.unsafe_return_air() // The proc that calls this proc marks the turf for update!
	var/datum/gas_mixture/air_contents = airs[1]

	if(air_contents.returnPressure() >= 50 * ONE_ATMOSPHERE)
		return FALSE

	if(scrubbing) // == SCRUBBING
		if(length(environment.gas & filter_types))
			. = TRUE
			var/total_moles_to_remove = 0
			for(var/gas in filter_types & environment.gas)
				total_moles_to_remove += environment.gas[gas]

			if(total_moles_to_remove == 0)//sometimes this gets non gc'd values
				return FALSE

			//take this gases portion of removal_ratio of the turfs air, or all of that gas if less than or equal to MINIMUM_MOLES_TO_SCRUB
			//var/transfer_moles = min(environment.total_moles, volume_rate/environment.volume)*environment.total_moles
			var/transfer_moles = min(environment.total_moles, environment.total_moles*volume_rate/environment.volume)
			var/draw = scrub_gas(filter_types, environment, air_contents, transfer_moles, power_rating)
			if(draw == -1)
				. = FALSE
			ATMOS_USE_POWER(draw)
			//Remix the resulting gases
			update_parents()
			return .

	else //Just siphoning all air

		var/transfer_moles = min(environment.total_moles, environment.total_moles * (MAX_SIPHON_FLOWRATE / environment.volume))
		var/draw = pump_gas(environment, air_contents, transfer_moles, power_rating)
		ATMOS_USE_POWER(draw)
		update_parents()
		return TRUE


#undef MINIMUM_MOLES_TO_SCRUB

/obj/machinery/atmospherics/components/unary/vent_scrubber/receive_signal(datum/signal/signal)
	if(!is_operational || !signal.data["tag"] || (signal.data["tag"] != id_tag) || (signal.data["sigtype"]!="command"))
		return

	var/old_quicksucc = quicksucc
	var/old_scrubbing = scrubbing
	var/old_filter_length = length(filter_types)

	var/atom/signal_sender = signal.data["user"]

	if("power" in signal.data)
		on = text2num(signal.data["power"])
	if("power_toggle" in signal.data)
		on = !on

	if("quicksucc" in signal.data)
		quicksucc = text2num(signal.data["quicksucc"])
	if("toggle_quicksucc" in signal.data)
		quicksucc = !quicksucc

	if("scrubbing" in signal.data)
		scrubbing = text2num(signal.data["scrubbing"])
	if("toggle_scrubbing" in signal.data)
		scrubbing = !scrubbing

	if(scrubbing != old_scrubbing)
		investigate_log(" was toggled to [scrubbing ? "scrubbing" : "siphon"] mode by [key_name(signal_sender)]",INVESTIGATE_ATMOS)

	if("toggle_filter" in signal.data)
		toggle_filters(signal.data["toggle_filter"])

	if("set_filters" in signal.data)
		filter_types = list()
		add_filters(signal.data["set_filters"])

	if("init" in signal.data)
		name = signal.data["init"]
		return

	if("status" in signal.data)
		broadcast_status()
		return //do not update_appearance

	broadcast_status()
	update_appearance()


	if(length(filter_types) == old_filter_length && old_scrubbing == scrubbing && old_quicksucc == quicksucc)
		return

/obj/machinery/atmospherics/components/unary/vent_scrubber/power_change()
	. = ..()
	update_icon_nopipes()

/obj/machinery/atmospherics/components/unary/vent_scrubber/welder_act(mob/living/user, obj/item/welder)
	..()
	if(!welder.tool_start_check(user, amount=0))
		return TRUE
	to_chat(user, span_notice("Now welding the scrubber."))
	if(welder.use_tool(src, user, 20, volume=50))
		if(!welded)
			user.visible_message(span_notice("[user] welds the scrubber shut."),span_notice("You weld the scrubber shut."), span_hear("You hear welding."))
			welded = TRUE
		else
			user.visible_message(span_notice("[user] unwelds the scrubber."), span_notice("You unweld the scrubber."), span_hear("You hear welding."))
			welded = FALSE
		update_appearance()
		pipe_vision_img = image(src, loc, dir = dir)
		pipe_vision_img.plane = ABOVE_HUD_PLANE
		investigate_log("was [welded ? "welded shut" : "unwelded"] by [key_name(user)]", INVESTIGATE_ATMOS)
		add_fingerprint(user)
	return TRUE

/obj/machinery/atmospherics/components/unary/vent_scrubber/can_unwrench(mob/user)
	. = ..()
	if(. && on && is_operational)
		to_chat(user, span_warning("You cannot unwrench [src], turn it off first!"))
		return FALSE

/obj/machinery/atmospherics/components/unary/vent_scrubber/examine(mob/user)
	. = ..()
	if(welded)
		. += "It seems welded shut."

/obj/machinery/atmospherics/components/unary/vent_scrubber/attack_alien(mob/user, list/modifiers)
	if(!welded || !(do_after(user, 20, target = src)))
		return
	user.visible_message(span_warning("[user] furiously claws at [src]!"), span_notice("You manage to clear away the stuff blocking the scrubber."), span_hear("You hear loud scraping noises."))
	welded = FALSE
	update_appearance()
	pipe_vision_img = image(src, loc, dir = dir)
	pipe_vision_img.plane = ABOVE_HUD_PLANE
	playsound(loc, 'sound/weapons/bladeslice.ogg', 100, TRUE)


/obj/machinery/atmospherics/components/unary/vent_scrubber/layer2
	piping_layer = 2
	icon_state = "scrub_map-2"

/obj/machinery/atmospherics/components/unary/vent_scrubber/layer4
	piping_layer = 4
	icon_state = "scrub_map-4"

/obj/machinery/atmospherics/components/unary/vent_scrubber/on
	on = TRUE
	icon_state = "scrub_map_on-3"

/obj/machinery/atmospherics/components/unary/vent_scrubber/on/layer2
	piping_layer = 2
	icon_state = "scrub_map_on-2"

/obj/machinery/atmospherics/components/unary/vent_scrubber/on/layer4
	piping_layer = 4
	icon_state = "scrub_map_on-4"

/obj/machinery/atmospherics/components/unary/vent_scrubber/plunger_act(obj/item/plunger/plunger, mob/living/user, reinforced)
	if(!clogged)
		return

	if(welded)
		to_chat(user, span_notice("You cannot pump [src] if it's welded shut!"))
		return

	to_chat(user, span_notice("You begin pumping [src] with your plunger."))
	if(do_after(user, 6 SECONDS, target = src))
		to_chat(user, span_notice("You finish pumping [src]."))
		clogged = FALSE

/**
 * Sets "clogged" to TRUE.
 *
 * Sets the clogged value to be true. Called during the scrubber clog event to begin the production of mobs, and allows for the plunger_act to run.
 */

/obj/machinery/atmospherics/components/unary/vent_scrubber/proc/clog()
	clogged = TRUE

/**
 * Sets "clogged" to FALSE.
 *
 * Changes the clogged value to be false. Called during the scrubber clog event to stop the production of mobs and prevent further plunger use.
 */

/obj/machinery/atmospherics/components/unary/vent_scrubber/proc/unclog()
	clogged = FALSE

/**
 * Produces a mob based on the input given by scrubber clog event.
 *
 * Used by the scrubber clog random event to handle the spawning of mobs. The proc recieves the mob that will be spawned,
 * and the event's current list of living mobs produced by the event so far. After checking if the vent is welded, the
 * new mob is created on the scrubber's turf, then added to the living_mobs list.
 *
 * Arguments:
 * * spawned_mob - Stores which mob will be spawned and added to the living_mobs list.
 * * living_mobs - Used to add the spawned mob to the list of currently living mobs produced by this vent.
 * Relevant code for how the list is handled is in the scrubber_clog.dm file.
 */

/obj/machinery/atmospherics/components/unary/vent_scrubber/proc/produce_mob(spawned_mob, list/living_mobs)
	if(welded)
		return

	var/mob/new_mob = new spawned_mob(get_turf(src))
	living_mobs += WEAKREF(new_mob)
	visible_message(span_warning("[new_mob] crawls out of [src]!"))

/obj/machinery/atmospherics/components/unary/vent_scrubber/disconnect()
	..()
	on = FALSE

#undef SIPHONING
#undef SCRUBBING

#define BASE_SAIL_OVERLAY_GRAY "#7a7a7a"

/obj/machinery/atmospherics/components/unary/heat_sail
	name = "heat sail"
	desc = "A heat sail for dissapating heat into space.<br><span class=\"warning\">WARNING: NOT FOR ATMOSPHERIC USAGE!</span>"

	icon = 'icons/obj/atmospherics/heat_sail.dmi'
	icon_state = "heat_sail"

	bound_width = 64
	bound_height = 96

	density = TRUE

	var/last_oh_shit_sound

/obj/machinery/atmospherics/components/unary/heat_sail/process_atmos()
	var/datum/gas_mixture/pipe_air = airs[1]

	var/turf/local_turf = loc
	var/datum/gas_mixture/turf_air = loc.return_air()
	if(!istype(local_turf))
		CRASH("Processing HE pipe not in a turf!")

	var/oh_shit_factor = min((turf_air.total_moles / MOLES_CELLSTANDARD) * 1.2, 1)

	//If a turf has (basically) no gas, it's safe to assume its a pure vacuum. So we should radiate heat instead of doing heat exchange.
	if(!turf_air || oh_shit_factor < 0.1)
		radiate_heat_to_space(pipe_air, 1000, 2) //the magic "1000" is the surface area in square meters. Yes, this is stupidly inflated.
		update_parents()
		return

	if(world.time - last_oh_shit_sound > 10 SECONDS)
		playsound(src, SFX_HULL_CREAKING, max(oh_shit_factor * 1.2), 0.2)
		last_oh_shit_sound = world.time

	take_damage(oh_shit_factor * 10) // Take between 1 and 10 damage depending on oh shit factor.

/obj/machinery/atmospherics/components/unary/heat_sail/update_overlays()
	. = ..()
	var/datum/gas_mixture/pipe_air = airs[1]
	var/icon/heat_overlay = icon(icon, "heat_sail_heat")
	// rgb(255, 80, 0) // For VSC color hints
	heat_overlay.ColorTone(BASE_SAIL_OVERLAY_GRAY)

	heat_overlay.Blend(rgb(120 * (pipe_air.temperature / (T300C - T20C)), (80 * (pipe_air.temperature / (T300C - T20C))) - 40, 0), ICON_MULTIPLY)
	. += heat_overlay

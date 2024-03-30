//4-Way Manifold

/obj/machinery/atmospherics/pipe/heat_exchanging/heat_sail
	icon = 'icons/obj/atmospherics/pipes/he-heatsail.dmi'
	icon_state = "heatsail-3"

	name = "heat sail"
	desc = "A complex radiator designed for space-faring vessels to control their heat. <span class=\"warning\">Not atmosphere safe.</span>"

	initialize_directions = ALL_CARDINALS

	device_type = QUATERNARY

	construction_type = /obj/item/pipe/quaternary
	pipe_state = "he_heatsail"

	var/last_oh_shit_sound

/obj/machinery/atmospherics/pipe/heat_exchanging/heat_sail/set_init_directions()
	initialize_directions = initial(initialize_directions)

/obj/machinery/atmospherics/pipe/heat_exchanging/heat_sail/update_overlays()
	. = ..()
	var/mutable_appearance/center = mutable_appearance(icon, "heatsail_center")
	PIPING_LAYER_DOUBLE_SHIFT(center, piping_layer)
	. += center

	//Add non-broken pieces
	for(var/i in 1 to device_type)
		if(nodes[i])
			. += get_pipe_image(icon, "pipe-[piping_layer]", get_dir(src, nodes[i]))
	update_layer()

/obj/machinery/atmospherics/pipe/heat_exchanging/heat_sail/process_atmos()
	var/datum/gas_mixture/pipe_air = return_air()

	var/turf/local_turf = loc
	var/datum/gas_mixture/turf_air = loc.return_air()
	if(!istype(local_turf))
		CRASH("Processing HE pipe not in a turf!")

	var/oh_shit_factor = min((turf_air.total_moles / MOLES_CELLSTANDARD) * 1.2, 1)

	//If a turf has (basically) no gas, it's safe to assume its a pure vacuum. So we should radiate heat instead of doing heat exchange.
	if(!turf_air || oh_shit_factor < 0.1)
		radiate_heat_to_space(pipe_air, 10, 2) //the magic "10" is the surface area in square meters.
		if(parent)
			parent.update = TRUE
		return

	if(world.time - last_oh_shit_sound > 10 SECONDS)
		playsound(src, SFX_HULL_CREAKING, max(oh_shit_factor * 1.2), 0.2)
		last_oh_shit_sound = world.time

	take_damage(oh_shit_factor * 2) // Take between 0.2 and 2 damage depending on oh shit factor.

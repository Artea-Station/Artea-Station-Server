//node2, air2, network2 correspond to input
//node1, air1, network1 correspond to output
#define CIRCULATOR_HOT 0
#define CIRCULATOR_COLD 1

/obj/machinery/atmospherics/components/binary/circulator
	name = "circulator/heat exchanger"
	desc = "A gas circulator pump and heat exchanger."
	icon_state = "circ-off-0"

	var/active = FALSE

	var/last_pressure_delta = 0
	pipe_flags = PIPING_ONE_PER_TURF | PIPING_DEFAULT_LAYER_ONLY

	density = TRUE

	var/recent_moles_transferred = 0
	var/volume_capacity_used = 0

	circuit = /obj/item/circuitboard/machine/circulator
	initial_volume = 200

	var/flipped = 0
	var/mode = CIRCULATOR_HOT
	var/obj/machinery/power/generator/generator

/obj/machinery/atmospherics/components/binary/circulator/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/simple_rotation)

/obj/machinery/atmospherics/components/binary/circulator/AltClick(mob/user)
	return ..() // This hotkey is BLACKLISTED since it's used by /datum/component/simple_rotation

/obj/machinery/atmospherics/components/binary/circulator/New()
	. = ..()
	airs[2].volume = 400 //The input has a larger volume than the output

/obj/machinery/atmospherics/components/binary/circulator/is_connectable()
	if(!anchored)
		return FALSE
	return ..()

//default cold circ for mappers
/obj/machinery/atmospherics/components/binary/circulator/cold
	mode = CIRCULATOR_COLD

/obj/machinery/atmospherics/components/binary/circulator/Destroy()
	if(generator)
		disconnectFromGenerator()
	return ..()

/obj/machinery/atmospherics/components/binary/circulator/proc/return_transfer_air()

	var/datum/gas_mixture/air1 = airs[1]
	var/datum/gas_mixture/air2 = airs[2]
	var/datum/pipeline/input_pipeline = parents[2]
	if(!input_pipeline)
		return

	var/output_starting_pressure = air1.returnPressure()
	var/input_starting_pressure = air2.returnPressure()
	last_pressure_delta = max(input_starting_pressure - output_starting_pressure - 5, 0)

	//only circulate air if there is a pressure difference (plus 5kPa kinetic, 10kPa static friction)
	if(air1.temperature > 0 && last_pressure_delta > 5)

		//Calculate necessary moles to transfer using PV = nRT
		recent_moles_transferred = (last_pressure_delta*input_pipeline.combined_volume/(air2.temperature * R_IDEAL_GAS_EQUATION))/3 //uses the volume of the whole network, not just itself
		volume_capacity_used = min( (last_pressure_delta*input_pipeline.combined_volume/3)/(input_starting_pressure*air2.volume) , 1) //how much of the gas in the input air volume is consumed

		// //Calculate energy generated from kinetic turbine
		// stored_energy += 1/ADIABATIC_EXPONENT * min(last_pressure_delta * input_pipeline.combined_volume , input_starting_pressure*air2.volume) * (1 - volume_ratio**ADIABATIC_EXPONENT) * kinetic_efficiency

		// //Actually transfer the gas
		// removed = air2.remove(recent_moles_transferred)

		// NOTE: Typically you'd update parents here, but its all handled by the generator itself.

	else
		last_pressure_delta = 0

/obj/machinery/atmospherics/components/binary/circulator/process_atmos()
	..()
	update_appearance(UPDATE_OVERLAYS|UPDATE_ICON_STATE)

/obj/machinery/atmospherics/components/binary/circulator/update_icon_state()
	if(!is_operational)
		icon_state = "circ-p-[flipped]"
		return ..()
	if(last_pressure_delta > 0)
		if(last_pressure_delta > ONE_ATMOSPHERE)
			icon_state = "circ-run-[flipped]"
		else
			icon_state = "circ-slow-[flipped]"
		return ..()

	icon_state = "circ-off-[flipped]"
	return ..()

/obj/machinery/atmospherics/components/binary/circulator/wrench_act(mob/living/user, obj/item/I)
	if(!panel_open)
		return
	set_anchored(!anchored)
	I.play_tool_sound(src)
	if(generator)
		disconnectFromGenerator()
	to_chat(user, span_notice("You [anchored?"secure":"unsecure"] [src]."))


	var/obj/machinery/atmospherics/node1 = nodes[1]
	var/obj/machinery/atmospherics/node2 = nodes[2]

	if(node1)
		node1.disconnect(src)
		nodes[1] = null
		if(parents[1])
			nullify_pipenet(parents[1])

	if(node2)
		node2.disconnect(src)
		nodes[2] = null
		if(parents[2])
			nullify_pipenet(parents[2])

	if(anchored)
		set_init_directions()
		atmos_init()
		node1 = nodes[1]
		if(node1)
			node1.atmos_init()
			node1.add_member(src)
		node2 = nodes[2]
		if(node2)
			node2.atmos_init()
			node2.add_member(src)
		SSairmachines.add_to_rebuild_queue(src)

	return TRUE

/obj/machinery/atmospherics/components/binary/circulator/set_init_directions()
	switch(dir)
		if(NORTH, SOUTH)
			initialize_directions = EAST|WEST
		if(EAST, WEST)
			initialize_directions = NORTH|SOUTH

/obj/machinery/atmospherics/components/binary/circulator/get_node_connects()
	if(flipped)
		return list(turn(dir, 270), turn(dir, 90))
	return list(turn(dir, 90), turn(dir, 270))

/obj/machinery/atmospherics/components/binary/circulator/can_be_node(obj/machinery/atmospherics/target)
	if(anchored)
		return ..(target)
	return FALSE

/obj/machinery/atmospherics/components/binary/circulator/multitool_act(mob/living/user, obj/item/I)
	if(generator)
		disconnectFromGenerator()
	mode = !mode
	to_chat(user, span_notice("You set [src] to [mode?"cold":"hot"] mode."))
	return TRUE

/obj/machinery/atmospherics/components/binary/circulator/screwdriver_act(mob/user, obj/item/I)
	if(..())
		return TRUE
	panel_open = !panel_open
	I.play_tool_sound(src)
	to_chat(user, span_notice("You [panel_open?"open":"close"] the panel on [src]."))
	return TRUE

/obj/machinery/atmospherics/components/binary/circulator/crowbar_act(mob/user, obj/item/I)
	default_deconstruction_crowbar(I)
	return TRUE

/obj/machinery/atmospherics/components/binary/circulator/on_deconstruction()
	if(generator)
		disconnectFromGenerator()

/obj/machinery/atmospherics/components/binary/circulator/proc/disconnectFromGenerator()
	if(mode)
		generator.cold_circ = null
	else
		generator.hot_circ = null
	generator.update_appearance()
	generator = null

/obj/machinery/atmospherics/components/binary/circulator/set_piping_layer(new_layer)
	..()
	pixel_x = 0
	pixel_y = 0

/obj/machinery/atmospherics/components/binary/circulator/verb/circulator_flip()
	set name = "Flip"
	set category = "Object"
	set src in oview(1)

	if(!ishuman(usr))
		return

	if(anchored)
		to_chat(usr, span_danger("[src] is anchored!"))
		return

	flipped = !flipped
	to_chat(usr, span_notice("You flip [src]."))
	update_appearance()

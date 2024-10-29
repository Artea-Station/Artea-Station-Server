/obj/item/circuitboard/machine/heat_sink
	name = "Heat Sink"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/atmospherics/components/unary/heat_sink
	var/pipe_layer = PIPING_LAYER_DEFAULT
	req_components = list(
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stack/cable_coil = 1,
		/obj/item/stack/sheet/mineral/plastitanium = 10,
	)

/obj/machinery/atmospherics/components/unary/heat_sink
	name = "heat sink"
	desc = "A heat sink for handling huge amounts of heat and casting it into space with higher efficiency, the hotter it is.<br><span class=\"info\">A label on it reads:</span><br><span class=\"warning\">WARNING: NOT FOR ATMOSPHERIC USAGE!</span>"

	icon = 'icons/obj/atmospherics/heat_sink.dmi'
	icon_state = "heat_sink"

	bound_width = 64
	bound_height = 96

	use_power = 0
	initial_volume = 1600

	density = TRUE

	pipe_color = COLOR_DARK

	var/last_oh_shit_sound

	var/heat_capacity = 0

	// Lazy as fuck workaround to pipenets being randomly null on update appearance
	var/last_heat_intensity = 0

/obj/machinery/atmospherics/components/unary/heat_sink/Initialize(mapload)
	. = ..()
	RefreshParts()
	update_appearance()

/obj/machinery/atmospherics/components/unary/heat_sink/RefreshParts()
	. = ..()
	var/calculated_bin_rating = 0
	for(var/obj/item/stock_parts/matter_bin/bin in component_parts)
		calculated_bin_rating += bin.rating
	heat_capacity = 5000 * ((calculated_bin_rating - 1) ** 2)

/obj/machinery/atmospherics/components/unary/heat_sink/on_construction(obj_color, set_layer)
	var/obj/item/circuitboard/machine/thermomachine/board = circuit
	if(board)
		piping_layer = board.pipe_layer
		set_layer = piping_layer

	if(check_pipe_on_turf())
		deconstruct(TRUE)
		return

	return ..()

/obj/machinery/atmospherics/components/unary/heat_sink/is_connectable(obj/machinery/atmospherics/target, given_layer)
	if(panel_open)
		return FALSE

	return ..()

/obj/machinery/atmospherics/components/unary/heat_sink/process_atmos()
	var/datum/gas_mixture/pipe_air = airs[1]

	var/turf/local_turf = loc
	var/datum/gas_mixture/turf_air = loc.return_air()
	if(!istype(local_turf))
		SSairmachines.stop_processing_machine(src) // Don't keep making runtimes about this.
		CRASH("Heatsink ([type]) not in a turf!")

	if(!pipe_air.total_moles) // Nothing to cool? go home lad
		return

	var/oh_shit_factor = min((turf_air.total_moles / MOLES_CELLSTANDARD) * 1.2, 1)

	//If a turf has (basically) no gas, it's safe to assume its a pure vacuum. So we should radiate heat instead of fucking dying.
	if(!turf_air || oh_shit_factor < 0.1)

		var/port_capacity = pipe_air.getHeatCapacity()

		// The difference between target and what we need to heat/cool. Positive if heating, negative if cooling.
		var/temperature_target_delta = T20C - pipe_air.temperature // T20C is the target temp

		// We perfectly can do W1+W2 / C1+C2 here but this lets us count the power easily.
		var/heat_amount = CALCULATE_CONDUCTION_ENERGY(temperature_target_delta, port_capacity, heat_capacity)

		var/new_temp = ((pipe_air.temperature * port_capacity) + heat_amount) / port_capacity

		pipe_air.temperature = max(new_temp, TCMB)

		update_appearance()
		update_parents()
		return

	if(world.time - last_oh_shit_sound > 10 SECONDS)
		playsound(src, SFX_HULL_CREAKING, 3 * oh_shit_factor, 0.2)
		last_oh_shit_sound = world.time

	take_damage(oh_shit_factor * 10) // Take between 1 and 10 damage depending on oh shit factor.
	update_appearance()

/obj/machinery/atmospherics/components/unary/heat_sink/update_overlays()
	. = ..()
	var/datum/gas_mixture/pipe_air = airs[1]

	if(pipe_air)
		last_heat_intensity = min((pipe_air.temperature - T20C) / T300C, 1)

	var/icon/heat_overlay = icon(icon, "heat_sink_heat")

	// Peaks at ~800k
	heat_overlay.Blend(rgb(120 * last_heat_intensity, max(0, (80 * last_heat_intensity) - 40), 0), ICON_MULTIPLY)
	heat_overlay.MapColors(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,last_heat_intensity, 0,0,0,0)
	. += heat_overlay
	. += emissive_appearance(icon, "heat_sink_heat")

	if(last_heat_intensity > 0.5)
		var/icon/glow_overlay = icon(icon, "heat_sink_glow")
		glow_overlay.Blend(rgb(120 * last_heat_intensity, max(0, (80 * last_heat_intensity) - 40), 0), ICON_MULTIPLY)
		. += glow_overlay
		. += emissive_appearance(icon, "heat_sink_glow")


// Begin copy-paste bullshit. This should really be on the unary type, but whatever.
/obj/machinery/atmospherics/components/unary/heat_sink/screwdriver_act(mob/living/user, obj/item/tool)
	if(on)
		to_chat(user, span_notice("You can't open [src] while it's on!"))
		return TOOL_ACT_TOOLTYPE_SUCCESS
	if(!anchored)
		to_chat(user, span_notice("Anchor [src] first!"))
		return TOOL_ACT_TOOLTYPE_SUCCESS
	if(default_deconstruction_screwdriver(user, "[initial(icon_state)]_open", initial(icon_state), tool))
		change_pipe_connection(panel_open)
		return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/machinery/atmospherics/components/unary/heat_sink/wrench_act(mob/living/user, obj/item/tool)
	return default_change_direction_wrench(user, tool)

/obj/machinery/atmospherics/components/unary/heat_sink/crowbar_act(mob/living/user, obj/item/tool)
	return default_deconstruction_crowbar(tool)

/obj/machinery/atmospherics/components/unary/heat_sink/multitool_act(mob/living/user, obj/item/multitool/multitool)
	if(!panel_open)
		return
	piping_layer = (piping_layer >= PIPING_LAYER_MAX) ? PIPING_LAYER_MIN : (piping_layer + 1)
	to_chat(user, span_notice("You change the circuitboard to layer [piping_layer]."))
	update_appearance()
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/machinery/atmospherics/components/unary/heat_sink/default_change_direction_wrench(mob/user, obj/item/I)
	if(!..())
		return FALSE
	set_init_directions()
	update_appearance()
	return TRUE

/obj/machinery/atmospherics/components/unary/heat_sink/proc/check_pipe_on_turf()
	for(var/obj/machinery/atmospherics/device in get_turf(src))
		if(device == src)
			continue
		if(device.piping_layer == piping_layer)
			visible_message(span_warning("A pipe is hogging the port, remove the obstruction or change the machine piping layer."))
			return TRUE
	return FALSE

/obj/machinery/atmospherics/components/unary/heat_sink/proc/change_pipe_connection(disconnect)
	if(disconnect)
		disconnect_pipes()
		return
	connect_pipes()

/obj/machinery/atmospherics/components/unary/heat_sink/proc/connect_pipes()
	var/obj/machinery/atmospherics/node1 = nodes[1]
	atmos_init()
	node1 = nodes[1]
	if(node1)
		node1.atmos_init()
		node1.add_member(src)
	SSairmachines.add_to_rebuild_queue(src)

/obj/machinery/atmospherics/components/unary/heat_sink/proc/disconnect_pipes()
	var/obj/machinery/atmospherics/node1 = nodes[1]
	if(node1)
		if(src in node1.nodes) //Only if it's actually connected. On-pipe version would is one-sided.
			node1.disconnect(src)
		nodes[1] = null
	if(parents[1])
		nullify_pipenet(parents[1])

// End copy paste bullshit. Yeah, it's a lot.

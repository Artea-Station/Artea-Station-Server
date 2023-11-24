#define POT_PIXEL_WIDTH 13

/// The smoke type. Can be null.
#define CONTAINER_SMOKE_TYPE "smoke_type"
/// The smoke instance. Can be null.
#define CONTAINER_SMOKE_INSTANCE "smoke_instance"
/// Used to figure out what slots are used.
#define CONTAINER_X_POSITION "x_pos"

/**
 * # Stove Component
 *
 * Makes the attached object a stove
 *
 * Pots can be put on the stove to make soup, and attack-handing it will start processing
 * where it will heat up the pot's reagents inside
 *
 * Only supports up to two pots for now.
 */
/datum/component/stove
	/// Whether we're currently cooking
	VAR_FINAL/on = FALSE
	/// An assoc list to the current soup pots overtop to a an assoc list of their smoke type, smoke instance, and position.
	VAR_FINAL/list/containers = list()
	/// The color of the flames around the burner.
	var/flame_color = "#006eff"
	/// Container's pixel x when placed on the stove, offset by 12 for the second container.
	var/container_x = 0
	/// Container's pixel y when placed on the stove
	var/container_y = 8
	/// Modifies how much temperature is exposed to the reagents, and in turn modifies how fast the reagents are heated.
	var/heat_coefficient = 0.033
	/// The maximum amount of containers this can have. Anything more than two may have undesired results.
	var/maximum_containers = 1

/datum/component/stove/Initialize(container_x = 0, container_y = 8, maximum_containers = 1, obj/item/spawn_container)
	if(!ismachinery(parent))
		return COMPONENT_INCOMPATIBLE

	src.container_x = container_x
	src.container_y = container_y
	src.maximum_containers = maximum_containers

	// To allow maploaded pots on top of your stove.
	if(spawn_container)
		spawn_container.forceMove(parent)
		add_container(spawn_container)

/datum/component/stove/RegisterWithParent()
	RegisterSignal(parent, COMSIG_PARENT_ATTACKBY, PROC_REF(on_attackby))
	RegisterSignal(parent, COMSIG_ATOM_ATTACK_HAND_SECONDARY, PROC_REF(on_attack_hand_secondary))
	RegisterSignal(parent, COMSIG_ATOM_EXITED, PROC_REF(on_exited))
	RegisterSignal(parent, COMSIG_ATOM_UPDATE_OVERLAYS, PROC_REF(on_overlay_update))
	RegisterSignal(parent, COMSIG_OBJ_DECONSTRUCT, PROC_REF(on_deconstructed))
	RegisterSignal(parent, COMSIG_ATOM_REQUESTING_CONTEXT_FROM_ITEM, PROC_REF(on_requesting_context))
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(parent, COMSIG_MACHINERY_REFRESH_PARTS, PROC_REF(on_refresh_parts))

	var/obj/machinery/real_parent = parent
	real_parent.flags_1 |= HAS_CONTEXTUAL_SCREENTIPS_1

/datum/component/stove/UnregisterFromParent()
	if(!QDELING(parent))
		var/obj/machinery/real_parent = parent
		for(var/obj/container as anything in containers)
			container.forceMove(real_parent.drop_location())

	for(var/container in containers)
		QDEL_NULL(containers[container][CONTAINER_SMOKE_INSTANCE])

	UnregisterSignal(parent, list(
		COMSIG_ATOM_ATTACK_HAND_SECONDARY,
		COMSIG_OBJ_DECONSTRUCT,
		COMSIG_ATOM_EXITED,
		COMSIG_ATOM_REQUESTING_CONTEXT_FROM_ITEM,
		COMSIG_ATOM_UPDATE_OVERLAYS,
		COMSIG_PARENT_ATTACKBY,
		COMSIG_PARENT_EXAMINE,
		COMSIG_MACHINERY_REFRESH_PARTS,
	))

/datum/component/stove/process(delta_time)
	var/obj/machinery/real_parent = parent
	if(real_parent.machine_stat & NOPOWER)
		turn_off()
		return

	for(var/obj/container as anything in containers)
		container?.reagents.expose_temperature(SOUP_BURN_TEMP + 80, heat_coefficient)
		real_parent.use_power(real_parent.active_power_usage)

	var/turf/stove_spot = real_parent.loc
	if(isturf(stove_spot))
		stove_spot.hotspot_expose(SOUP_BURN_TEMP + 80, 100)

/datum/component/stove/proc/turn_on()
	var/obj/machinery/real_parent = parent
	if(real_parent.machine_stat & (BROKEN|NOPOWER))
		return
	START_PROCESSING(SSmachines, src)
	on = TRUE
	real_parent.update_appearance(UPDATE_OVERLAYS)

/datum/component/stove/proc/turn_off()
	var/obj/machinery/real_parent = parent
	STOP_PROCESSING(SSmachines, src)
	on = FALSE
	real_parent.update_appearance(UPDATE_OVERLAYS)

/datum/component/stove/proc/on_attack_hand_secondary(obj/machinery/source)
	SIGNAL_HANDLER

	var/obj/machinery/real_parent = parent
	if(on)
		turn_off()

	else if(real_parent.machine_stat & (BROKEN|NOPOWER))
		real_parent.balloon_alert_to_viewers("no power!")
		return COMPONENT_SECONDARY_CANCEL_ATTACK_CHAIN

	else
		turn_on()

	real_parent.balloon_alert_to_viewers("burners [on ? "on" : "off"]")
	playsound(real_parent, 'sound/machines/click.ogg', 30, TRUE)
	playsound(real_parent, on ? 'sound/items/welderactivate.ogg' : 'sound/items/welderdeactivate.ogg', 15, TRUE)

	return COMPONENT_SECONDARY_CANCEL_ATTACK_CHAIN

/datum/component/stove/proc/on_attackby(obj/machinery/source, obj/item/attacking_item, mob/user, params)
	SIGNAL_HANDLER

	if(!attacking_item.is_open_container())
		return
	if(containers.len >= maximum_containers)
		to_chat(user, span_warning("You can't fit any more containers!"))
		return COMPONENT_NO_AFTERATTACK

	if(user.transferItemToLoc(attacking_item, parent))
		add_container(attacking_item, user)
		to_chat(user, span_notice("You put [attacking_item] onto [parent]."))
	return COMPONENT_NO_AFTERATTACK

/datum/component/stove/proc/on_exited(obj/machinery/source, atom/movable/gone, direction)
	SIGNAL_HANDLER

	if(gone in containers)
		remove_container(gone)

/datum/component/stove/proc/on_deconstructed(obj/machinery/source)
	SIGNAL_HANDLER

	for(var/obj/container as anything in containers)
		container.forceMove(source.drop_location())

/datum/component/stove/proc/on_overlay_update(obj/machinery/source, list/overlays)
	SIGNAL_HANDLER

	update_smoke()

	if(!on)
		return

	var/obj/real_parent = parent

	// Flames around the pots
	for(var/index = 0, index < maximum_containers, index++)
		var/mutable_appearance/flames = mutable_appearance(real_parent.icon, "[real_parent.base_icon_state]_on_flame", alpha = real_parent.alpha)
		flames.pixel_x = index * POT_PIXEL_WIDTH
		flames.color = flame_color
		overlays += flames
		var/mutable_appearance/flames_emissive = emissive_appearance(real_parent.icon, "[real_parent.base_icon_state]_on_flame", real_parent, alpha = real_parent.alpha)
		flames_emissive.pixel_x = index * POT_PIXEL_WIDTH
		overlays += flames_emissive

	// A green light that shows it's active
	var/mutable_appearance/light = mutable_appearance(real_parent.icon, "[real_parent.base_icon_state]_on_overlay", alpha = real_parent.alpha)
	light.color = "#00ff00"
	overlays += light
	overlays += emissive_appearance(real_parent.icon, "[real_parent.base_icon_state]_on_overlay", real_parent, alpha = real_parent.alpha)

/datum/component/stove/proc/on_requesting_context(obj/machinery/source, list/context, obj/item/held_item)
	SIGNAL_HANDLER

	if(isnull(held_item))
		context[SCREENTIP_CONTEXT_RMB] = "Turn [on ? "off":"on"] burner"
		return CONTEXTUAL_SCREENTIP_SET

	if(held_item.is_open_container())
		context[SCREENTIP_CONTEXT_LMB] = "Place container"
		return CONTEXTUAL_SCREENTIP_SET

/datum/component/stove/proc/on_examine(obj/machinery/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	examine_list += span_notice("You can turn the stovetop burners [on ? "off" : "on"] with <i>right click</i>.")

/datum/component/stove/proc/on_refresh_parts(obj/machinery/source)
	SIGNAL_HANDLER

	var/new_multiplier = 0
	for(var/obj/item/stock_parts/micro_laser/part in source.component_parts)
		new_multiplier += (part.rating * 0.5)

	heat_coefficient = initial(heat_coefficient) * max(round(new_multiplier), 1)

/datum/component/stove/proc/add_container(obj/item/container, mob/user)
	var/container_x_offset = find_gap()
	if(isnull(container_x_offset))
		CRASH("Error in trying to add a container! Found no free index?")

	var/obj/real_parent = parent
	real_parent.vis_contents += container
	container.flags_1 |= IS_ONTOP_1
	container.vis_flags |= VIS_INHERIT_PLANE
	container.pixel_x = container_x + ((container_x_offset) * POT_PIXEL_WIDTH)
	container.pixel_y = container_y

	containers[container] = list(CONTAINER_SMOKE_INSTANCE = null, CONTAINER_SMOKE_TYPE = null, CONTAINER_X_POSITION = container_x_offset)
	update_smoke_type(container.reagents)
	RegisterSignal(container.reagents, COMSIG_REAGENTS_TEMP_CHANGE, PROC_REF(update_smoke_type))
	real_parent.update_appearance(UPDATE_OVERLAYS)

/// Probably definitely shitcode, but the list in the current iteration of code goes at most 2 entries long, so... yup.
/datum/component/stove/proc/find_gap()
	if(!length(containers))
		return 0
	for(var/index = 0, index < maximum_containers, index++) // Try until max containers, if this can't find anything, then a check got fucked, or an admin tried to be smart.
		for(var/container in containers)
			if(containers[container][CONTAINER_X_POSITION] == index)
				continue
			return index

/datum/component/stove/proc/remove_container(obj/item/container)
	var/obj/real_parent = parent
	container.flags_1 &= ~IS_ONTOP_1
	container.vis_flags &= ~VIS_INHERIT_PLANE
	real_parent.vis_contents -= container

	UnregisterSignal(container.reagents, COMSIG_REAGENTS_TEMP_CHANGE)

	container.pixel_x = container.base_pixel_x
	container.pixel_y = container.base_pixel_y

	qdel(containers[container][CONTAINER_SMOKE_INSTANCE])
	containers -= container

	real_parent.update_appearance(UPDATE_OVERLAYS)

/datum/component/stove/proc/update_smoke_type(datum/reagents/reagents, new_temp, old_temp)
	SIGNAL_HANDLER
	var/existing_temp = reagents.chem_temp || 0
	if(existing_temp >= SOUP_BURN_TEMP)
		containers[reagents.my_atom][CONTAINER_SMOKE_TYPE] = /particles/smoke/steam/bad
	else if(existing_temp >= WATER_BOILING_POINT)
		containers[reagents.my_atom][CONTAINER_SMOKE_TYPE] = /particles/smoke/steam/mild
	else
		containers[reagents.my_atom][CONTAINER_SMOKE_TYPE] = null

	update_smoke()

/datum/component/stove/proc/update_smoke()
	// Not turned on, yeet it all
	if(!on)
		for(var/container in containers)
			QDEL_NULL(containers[container][CONTAINER_SMOKE_INSTANCE])
		return

	for(var/obj/container as anything in containers)

		var/obj/effect/abstract/particle_holder/soup_smoke = containers[container][CONTAINER_SMOKE_INSTANCE]
		var/particle_type = containers[container][CONTAINER_SMOKE_TYPE]

		if(!isnull(soup_smoke) && soup_smoke.particles.type == particle_type)
			continue

		if(soup_smoke)
			QDEL_NULL(containers[container][CONTAINER_SMOKE_INSTANCE])

		if(isnull(particle_type))
			continue

		// this gets badly murdered by sidemap // We don't use sidemap, but this is harmless so... /shrug
		soup_smoke = new(parent, particle_type)
		soup_smoke.set_particle_position(list(container.pixel_x, round(world.icon_size * 0.66), 0))
		containers[container][CONTAINER_SMOKE_INSTANCE] = soup_smoke

#undef POT_PIXEL_WIDTH
#undef CONTAINER_SMOKE_TYPE
#undef CONTAINER_SMOKE_INSTANCE
#undef CONTAINER_X_POSITION

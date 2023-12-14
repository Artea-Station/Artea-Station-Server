/obj/machinery/stove
	name = "stove"
	desc = "Multi-track dri- wait, no, multi-hob burning!"
	icon = 'icons/obj/machines/kitchenmachines.dmi'
	icon_state = "stove"
	base_icon_state = "stove"
	density = TRUE
	pass_flags_self = PASSMACHINE | LETPASSTHROW
	layer = BELOW_OBJ_LAYER
	circuit = /obj/item/circuitboard/machine/stove
	processing_flags = START_PROCESSING_MANUALLY
	resistance_flags = FIRE_PROOF
	idle_power_usage = BASE_MACHINE_IDLE_CONSUMPTION * 0.1
	active_power_usage = BASE_MACHINE_IDLE_CONSUMPTION * 0.8
	/// The bowls currently stored
	var/list/bowls

/obj/machinery/stove/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/stove, container_x = -6, container_y = 16, maximum_containers = 2)
	if(mapload)
		bowls = list()
		for(var/i = 0, i < 6, i++) // Spawn a full bowl compliment if placed roundstart.
			var/obj/item/reagent_containers/cup/bowl/bowl = new(src)
			bowls += bowl
		update_appearance()

/obj/machinery/stove/attackby(obj/item/weapon, mob/user, params)
	if(weapon.type == /obj/item/reagent_containers/cup/bowl)
		if(length(bowls) >= 6)
			to_chat(user, span_warning("You can't fit any more bowls!"))
			return
		weapon.forceMove(src)
		LAZYADD(bowls, weapon)
		update_appearance()
		return
	return ..()

/obj/machinery/stove/attack_hand(mob/living/user, list/modifiers)
	if(!length(bowls))
		to_chat(user, span_warning("There are no more bowls!"))
		return

	var/obj/item/bowl = bowls[1]
	LAZYREMOVE(bowls, bowl)
	user.put_in_active_hand(bowl)
	update_appearance()

/obj/machinery/stove/update_overlays()
	. = ..()
	if(length(bowls))
		. += mutable_appearance(icon, "[base_icon_state]_bowls_[length(bowls)]")

/obj/machinery/table_hob
	name = "table hob"
	desc = "Compact table hob, for your tiny kitchen and survival needs."
	icon = 'icons/obj/machines/kitchenmachines.dmi'
	icon_state = "table_hob"
	base_icon_state = "table_hob"
	pass_flags_self = PASSMACHINE | LETPASSTHROW
	pass_flags = PASSTABLE
	circuit = /obj/item/circuitboard/machine/table_hob
	processing_flags = START_PROCESSING_MANUALLY
	resistance_flags = FIRE_PROOF
	idle_power_usage = BASE_MACHINE_IDLE_CONSUMPTION * 0.1
	active_power_usage = BASE_MACHINE_IDLE_CONSUMPTION * 0.8
	anchored_tabletop_offset = 6

/obj/machinery/table_hob/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/stove, container_x = 0, container_y = 2)

/obj/machinery/table_hob/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	var/datum/component/stove/stove = GetComponent(/datum/component/stove)
	if(length(stove?.containers))
		to_chat(user, span_notice("Remove the container first!"))
		return
	if(stove?.on)
		to_chat(user, span_notice("Turn off [src] first!"))
		return
	if(default_unfasten_wrench(user, tool))
		update_appearance()
	return TOOL_ACT_TOOLTYPE_SUCCESS

// Soup pot for cooking soup
// Future addention ideas:
// - Thermostat you can stick in the pot to see in examine the temperature
// - Tasting the pot to learn its exact contents w/o sci goggles (chef skillchip?)
/obj/item/reagent_containers/cup/soup_pot
	name = "soup pot"
	desc = "A tall soup designed to mix and cook all kinds of soup."
	icon = 'icons/obj/soup_pot.dmi'
	icon_state = "pot"
	base_icon_state = "pot"
	volume = 200
	possible_transfer_amounts = list(20, 50, 100, 200)
	amount_per_transfer_from_this = 50
	amount_list_position = 2
	reagent_flags = REFILLABLE | DRAINABLE
	custom_materials = list(/datum/material/iron = 5000)
	w_class = WEIGHT_CLASS_BULKY
	custom_price = PAYCHECK_LOWER * 8
	fill_icon_thresholds = null
	pickup_sound = 'sound/items/handling/pot_pickup.ogg'
	drop_sound = 'sound/items/handling/pot_drop.ogg'

	/// Max number of ingredients we can add
	var/max_ingredients = 24
	/// A lazylist of all the ingredients we have added
	var/list/obj/item/added_ingredients

/obj/item/reagent_containers/cup/soup_pot/Initialize(mapload, vol)
	. = ..()
	RegisterSignal(reagents, COMSIG_REAGENTS_CLEAR_REAGENTS, PROC_REF(on_reagents_cleared))
	RegisterSignal(src, COMSIG_PARENT_REAGENT_EXAMINE, PROC_REF(reagent_special_examine))
	register_context()

/obj/item/reagent_containers/cup/soup_pot/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	if(isnull(held_item))
		context[SCREENTIP_CONTEXT_RMB] = "Remove ingredient"
		return CONTEXTUAL_SCREENTIP_SET

	else if(can_add_ingredient(held_item))
		context[SCREENTIP_CONTEXT_LMB] = "Add ingredient"
		return CONTEXTUAL_SCREENTIP_SET

	return NONE

/obj/item/reagent_containers/cup/soup_pot/examine(mob/user)
	. = ..()
	. += span_notice("There's room for <b>[max_ingredients - LAZYLEN(added_ingredients)]</b> more ingredients \
		or <b>[reagents.maximum_volume - reagents.total_volume]</b> more units of reagents in there.")

/**
 * Override standard reagent examine with something a bit more sensible for the soup pot,
 * including the ingredients we have within as well
 */
/obj/item/reagent_containers/cup/soup_pot/proc/reagent_special_examine(datum/source, mob/user, list/examine_list, can_see_insides = FALSE)
	SIGNAL_HANDLER

	examine_list += "Inside, you can see:"

	if(LAZYLEN(added_ingredients) || reagents.total_volume > 0)
		var/list/ingredient_amounts = list()
		for(var/obj/item/ingredient as anything in added_ingredients)
			ingredient_amounts[ingredient.type] += 1

		for(var/obj/item/ingredient_type as anything in ingredient_amounts)
			examine_list += "&bull; [ingredient_amounts[ingredient_type]] [initial(ingredient_type.name)]\s"

		var/unknown_volume = 0
		for(var/datum/reagent/current_reagent as anything in reagents.reagent_list)
			if(can_see_insides \
				|| istype(current_reagent, /datum/reagent/water) \
				|| istype(current_reagent, /datum/reagent/consumable) \
			)
				examine_list += "&bull; [round(current_reagent.volume, 0.01)] units of [current_reagent.name]"
			else
				unknown_volume += current_reagent.volume

		if(unknown_volume > 0)
			examine_list += "&bull; [round(unknown_volume, 0.01)] units of unknown reagents"

		if(reagents.total_volume > 0)
			if(can_see_insides)
				examine_list += span_notice("The contents of [src] have a temperature of [reagents.chem_temp]K.")
			else if(reagents.chem_temp > WATER_BOILING_POINT) // boiling point
				examine_list += span_notice("The contents of [src] are boiling.")

	else
		examine_list += "Nothing."

	if(reagents.is_reacting)
		examine_list += span_warning("It is currently mixing!")

	return STOP_GENERIC_REAGENT_EXAMINE

/obj/item/reagent_containers/cup/soup_pot/Exited(atom/movable/gone, direction)
	. = ..()
	LAZYREMOVE(added_ingredients, gone)

/obj/item/reagent_containers/cup/soup_pot/attackby(obj/item/attacking_item, mob/user, params)
	. = ..()
	if(.)
		return

	if(!can_add_ingredient(attacking_item))
		return FALSE

	// Too many ingredients
	if(LAZYLEN(added_ingredients) >= max_ingredients)
		balloon_alert(user, "too many ingredients!")
		return TRUE
	if(!user.transferItemToLoc(attacking_item, src))
		balloon_alert(user, "can't add that!")
		return TRUE

	var/atom/balloon_loc = ismachinery(loc) ? loc : src
	balloon_loc.balloon_alert(user, "ingredient added")
	user.face_atom(balloon_loc)
	LAZYADD(added_ingredients, attacking_item)

	update_appearance(UPDATE_OVERLAYS)
	return TRUE

/obj/item/reagent_containers/cup/soup_pot/attack_hand_secondary(mob/user, list/modifiers)
	if(!LAZYLEN(added_ingredients))
		return SECONDARY_ATTACK_CALL_NORMAL

	var/obj/item/removed = added_ingredients[1]
	removed.forceMove(get_turf(src))
	user.put_in_hands(removed)
	var/atom/balloon_loc = ismachinery(loc) ? loc : src
	balloon_loc.balloon_alert(user, "ingredient removed")
	user.face_atom(balloon_loc)

	update_appearance(UPDATE_OVERLAYS)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/reagent_containers/cup/soup_pot/proc/can_add_ingredient(obj/item/ingredient)
	// Let default reagent handling take this
	if(ingredient.is_open_container())
		return FALSE
	// To big for the pot
	if(ingredient.w_class >= WEIGHT_CLASS_BULKY)
		return FALSE
	if(ingredient.item_flags & (ABSTRACT|DROPDEL|HAND_ITEM))
		return FALSE
	if(HAS_TRAIT(ingredient, TRAIT_NO_STORAGE_INSERT))
		return FALSE
	return TRUE

/obj/item/reagent_containers/cup/soup_pot/proc/on_reagents_cleared(datum/source, datum/reagent/changed)
	SIGNAL_HANDLER

	dump_ingredients()

/obj/item/reagent_containers/cup/soup_pot/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum, do_splash)
	. = ..()
	if(!. && LAZYLEN(added_ingredients))
		// Clearing reagents Will do this for us already, but if we have no reagents this is a failsafe
		dump_ingredients()

/obj/item/reagent_containers/cup/soup_pot/proc/dump_ingredients(atom/drop_loc = drop_location())
	for(var/obj/item/ingredient as anything in added_ingredients)
		ingredient.forceMove(drop_loc)
		ingredient.pixel_x += rand(-4, 4)
		ingredient.pixel_y += rand(-4, 4)
		ingredient.SpinAnimation(loops = 1)
	update_appearance(UPDATE_OVERLAYS)

/obj/item/reagent_containers/cup/soup_pot/update_overlays()
	. = ..()
	if(length(added_ingredients) <= 0 && reagents.total_volume <= 0)
		return
	var/mutable_appearance/filled_overlay = mutable_appearance(icon, "[base_icon_state]_filling_overlay")
	var/list/food_reagents = list()
	for(var/obj/item/ingredient as anything in added_ingredients)
		if(isnull(ingredient.reagents))
			continue
		food_reagents |= ingredient.reagents.reagent_list

	filled_overlay.color = mix_color_from_reagents(reagents.reagent_list + food_reagents)
	. += filled_overlay

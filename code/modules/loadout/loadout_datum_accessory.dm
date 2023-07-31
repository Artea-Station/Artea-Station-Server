// --- Loadout item datums for accessories ---

#define ADJUSTABLE_TOOLTIP "LAYER ADJUSTABLE - You can opt to have accessory above or below your suit."

/// Accessory Items (Moves overrided items to backpack)
/datum/loadout_category/accessories
	category_name = "Accessory"
	ui_title = "Uniform Accessory Items"

/datum/loadout_category/accessories/get_items()
	var/static/list/loadout_accessory = generate_loadout_items(/datum/loadout_item/accessory)
	return loadout_accessory

/datum/loadout_item/accessory
	category = LOADOUT_ITEM_ACCESSORY
	// Can we adjust this accessory to be above or below suits?
	var/can_be_layer_adjusted = FALSE

/datum/loadout_item/accessory/New()
	. = ..()
	var/obj/item/clothing/accessory/accessory = item_path
	if(!ispath(accessory))
		return

	can_be_layer_adjusted = TRUE
	add_tooltip(ADJUSTABLE_TOOLTIP, inverse_order = TRUE)

/datum/loadout_item/accessory/get_ui_buttons()
	. = ..()
	if(can_be_layer_adjusted)
		. += list(list(
			"icon" = FA_ICON_ARROW_DOWN,
			"act_key" = "set_layer",
		))

/datum/loadout_item/accessory/handle_loadout_action(datum/preference_middleware/loadout/manager, mob/user, action)
	switch(action)
		if("set_layer")
			if(can_be_layer_adjusted)
				set_accessory_layer(manager, user)
				. = TRUE // update to show the new layer

	return ..()

/datum/loadout_item/accessory/proc/set_accessory_layer(datum/preference_middleware/loadout/manager, mob/user)
	var/list/loadout = manager.loadout
	if(!loadout?[item_path])
		manager.select_item(src)

	if(isnull(loadout[item_path][INFO_LAYER]))
		loadout[item_path][INFO_LAYER] = FALSE

	loadout[item_path][INFO_LAYER] = !loadout[item_path][INFO_LAYER]
	to_chat(user, span_boldnotice("[name] will now appear [loadout[item_path][INFO_LAYER] ? "above" : "below"] suits."))
	manager.preferences.update_preference(manager.preference, loadout)

/datum/loadout_item/accessory/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE)
	if(outfit.accessory)
		LAZYADD(outfit.backpack_contents, outfit.accessory)
	outfit.accessory = item_path

/datum/loadout_item/accessory/on_equip_item(datum/preferences/preference_source, mob/living/carbon/human/equipper, visuals_only = FALSE, list/preference_list)
	. = ..()
	var/obj/item/clothing/accessory/equipped_item = .
	var/obj/item/clothing/under/suit = equipper.w_uniform
	if(!istype(equipped_item))
		return

	equipped_item.above_suit = !!preference_list[item_path]?[INFO_LAYER]
	if(!istype(suit))
		return

	// Hacky, but accessory will ONLY update when attached or detached.
	equipped_item.detach(suit)
	suit.attach_accessory(equipped_item)

/datum/loadout_item/accessory/maid_apron
	name = "Maid Apron"
	item_path = /obj/item/clothing/accessory/maidapron

/datum/loadout_item/accessory/waistcoat
	name = "Waistcoat"
	item_path = /obj/item/clothing/accessory/waistcoat

/datum/loadout_item/accessory/pocket_protector
	name = "Pocket Protector"
	item_path = /obj/item/clothing/accessory/pocketprotector

/datum/loadout_item/accessory/full_pocket_protector
	name = "Pocket Protector (Filled)"
	item_path = /obj/item/clothing/accessory/pocketprotector/full
	additional_tooltip_contents = list("CONTAINS PENS - This item contains multiple pens on spawn.")

/datum/loadout_item/accessory/ribbon
	name = "Ribbon"
	item_path = /obj/item/clothing/accessory/medal/ribbon

/datum/loadout_item/accessory/pride
	name = "Pride Pin"
	item_path = /obj/item/clothing/accessory/pride
	can_be_reskinned = TRUE

#undef ADJUSTABLE_TOOLTIP

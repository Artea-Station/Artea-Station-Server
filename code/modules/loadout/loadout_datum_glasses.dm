// --- Loadout item datums for glasses ---

/// Glasses Slot Items (Moves overrided items to backpack)
/datum/loadout_category/glasses
	category_name = "Glasses"
	ui_title = "Eye Slot Items"

/datum/loadout_category/glasses/get_items()
	var/static/list/loadout_glasses = generate_loadout_items(/datum/loadout_item/glasses)
	return loadout_glasses

/datum/loadout_item/glasses
	category = LOADOUT_ITEM_GLASSES

/datum/loadout_item/glasses/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE)
	if(outfit.glasses)
		LAZYADD(outfit.backpack_contents, outfit.glasses)
		return
	outfit.glasses = item_path

/datum/loadout_item/glasses/post_equip_item(datum/preferences/preference_source, mob/living/carbon/human/equipper)
	var/obj/item/clothing/glasses/equipped_glasses = locate(item_path) in equipper.get_equipped_items()
	if(equipped_glasses.glass_colour_type)
		equipper.update_glasses_color(equipped_glasses, TRUE)
	equipper.update_tint()
	equipper.update_sight()

/datum/loadout_item/glasses/prescription_glasses
	item_path = /obj/item/clothing/glasses/regular
	additional_tooltip_contents = list("PRESCRIPTION - This item functions with the 'nearsighted' quirk.")

/datum/loadout_item/glasses/prescription_glasses/circle_glasses
	item_path = /obj/item/clothing/glasses/regular/circle

/datum/loadout_item/glasses/prescription_glasses/hipster_glasses
	item_path = /obj/item/clothing/glasses/regular/hipster

/datum/loadout_item/glasses/prescription_glasses/jamjar_glasses
	item_path = /obj/item/clothing/glasses/regular/jamjar

/datum/loadout_item/glasses/black_blindfold
	item_path = /obj/item/clothing/glasses/blindfold

/datum/loadout_item/glasses/cold_glasses
	item_path = /obj/item/clothing/glasses/cold

/datum/loadout_item/glasses/heat_glasses
	item_path = /obj/item/clothing/glasses/heat

/datum/loadout_item/glasses/geist_glasses
	item_path = /obj/item/clothing/glasses/geist_gazers

/datum/loadout_item/glasses/orange_glasses
	item_path = /obj/item/clothing/glasses/orange

/datum/loadout_item/glasses/psych_glasses
	item_path = /obj/item/clothing/glasses/psych

/datum/loadout_item/glasses/red_glasses
	item_path = /obj/item/clothing/glasses/red

/datum/loadout_item/glasses/welding_goggles
	item_path = /obj/item/clothing/glasses/welding

/datum/loadout_item/glasses/eyepatch
	item_path = /obj/item/clothing/glasses/eyepatch

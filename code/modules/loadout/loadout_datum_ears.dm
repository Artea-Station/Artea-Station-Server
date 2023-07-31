// --- Loadout item datums for ears ---

/// Ear Slot Items (Moves overrided items to backpack)
/datum/loadout_category/ears
	category_name = "Ears"
	ui_title = "Ear Slot Items"

/datum/loadout_category/ears/get_items()
	var/static/list/loadout_ears = generate_loadout_items(/datum/loadout_item/ears)
	return loadout_ears

/datum/loadout_item/ears
	category = LOADOUT_ITEM_EARS

/datum/loadout_item/ears/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE)
	if(outfit.ears)
		LAZYADD(outfit.backpack_contents, outfit.ears)
	outfit.ears = item_path

/datum/loadout_item/ears/headphones
	name = "Headphones"
	item_path = /obj/item/instrument/piano_synth/headphones

/datum/loadout_item/ears/earmuffs
	name = "Earmuffs"
	item_path = /obj/item/clothing/ears/earmuffs

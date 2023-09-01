// --- Loadout item datums for inhand items ---

/// Inhand items (Moves overrided items to backpack)
/datum/loadout_category/inhands
	category_name = "Inhand"
	ui_title = "In-hand Items"
	type_to_generate = /datum/loadout_item/inhand

/datum/loadout_item/inhand
	abstract_type = /datum/loadout_item/inhand

/datum/loadout_item/inhand/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE)
	if(outfit.l_hand && !outfit.r_hand)
		outfit.r_hand = item_path
	else
		if(outfit.l_hand)
			LAZYADD(outfit.backpack_contents, outfit.l_hand)
			return
		outfit.l_hand = item_path

/datum/loadout_item/inhand/cane
	item_path = /obj/item/cane

/datum/loadout_item/inhand/cane_white
	item_path = /obj/item/cane/white

/datum/loadout_item/inhand/briefcase
	item_path = /obj/item/storage/briefcase

/datum/loadout_item/inhand/briefcase_secure
	item_path = /obj/item/storage/secure/briefcase

/datum/loadout_item/inhand/skateboard
	item_path = /obj/item/melee/skateboard

/datum/loadout_item/inhand/bouquet_mixed
	item_path = /obj/item/bouquet

/datum/loadout_item/inhand/bouquet_sunflower
	item_path = /obj/item/bouquet/sunflower

/datum/loadout_item/inhand/bouquet_poppy
	item_path = /obj/item/bouquet/poppy

/datum/loadout_item/inhand/bouquet_rose
	item_path = /obj/item/bouquet/rose

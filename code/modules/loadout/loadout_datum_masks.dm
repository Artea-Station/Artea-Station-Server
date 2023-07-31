// --- Loadout item datums for masks ---

/// Mask Slot Items (Deletes overrided items)
/datum/loadout_category/mask
	category_name = "Mask"
	ui_title = "Mouth Slot Items"

/datum/loadout_category/mask/get_items()
	var/static/list/loadout_mask = generate_loadout_items(/datum/loadout_item/mask)
	return loadout_mask

/datum/loadout_item/mask
	category = LOADOUT_ITEM_MASK

/datum/loadout_item/mask/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE)
	if(isplasmaman(equipper))
		if(!visuals_only)
			to_chat(equipper, "Your loadout mask was not equipped directly due to your envirosuit mask.")
			LAZYADD(outfit.backpack_contents, item_path)
	else
		outfit.mask = item_path

/datum/loadout_item/mask/balaclava
	item_path = /obj/item/clothing/mask/balaclava

/datum/loadout_item/mask/gas_mask
	item_path = /obj/item/clothing/mask/gas

/datum/loadout_item/mask/bandana_greyscale
	item_path = /obj/item/clothing/mask/bandana

/datum/loadout_item/mask/bandana_striped_greyscale
	item_path = /obj/item/clothing/mask/bandana/striped

/datum/loadout_item/mask/skull_bandana
	item_path = /obj/item/clothing/mask/bandana/skull

/datum/loadout_item/mask/surgical_mask
	item_path = /obj/item/clothing/mask/surgical

/datum/loadout_item/mask/fake_mustache
	item_path = /obj/item/clothing/mask/fakemoustache

/datum/loadout_item/mask/pipe
	item_path = /obj/item/clothing/mask/cigarette/pipe

/datum/loadout_item/mask/corn_pipe
	item_path = /obj/item/clothing/mask/cigarette/pipe/cobpipe

/datum/loadout_item/mask/plague_doctor
	item_path = /obj/item/clothing/mask/gas/plaguedoctor

/datum/loadout_item/mask/joy
	item_path = /obj/item/clothing/mask/joy

/datum/loadout_item/mask/lollipop
	item_path = /obj/item/food/lollipop

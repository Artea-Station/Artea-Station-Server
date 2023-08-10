// --- Loadout item datums for belts ---

/// Belt Slot Items (Moves overrided items to backpack)
/datum/loadout_category/belts
	category_name = "Belt"
	ui_title = "Belt Slot Items"

/datum/loadout_category/belts/get_items()
	var/static/list/loadout_belts = generate_loadout_items(/datum/loadout_item/belts)
	return loadout_belts

/datum/loadout_item/belts
	category = LOADOUT_ITEM_BELT
	always_shown = FALSE
	priority = 2

/datum/loadout_item/belts/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE)
	if(!outfit.uniform) // let's not try to put belts on underless outfits.
		outfit.backpack_contents += list(item_path = 1)
		return

	if(outfit.belt)
		LAZYADD(outfit.backpack_contents, outfit.belt)

	outfit.belt = item_path

/datum/loadout_item/belts/fanny_pack_black
	item_path = /obj/item/storage/belt/fannypack/black

/datum/loadout_item/belts/fanny_pack_blue
	item_path = /obj/item/storage/belt/fannypack/blue

/datum/loadout_item/belts/fanny_pack_brown
	item_path = /obj/item/storage/belt/fannypack

/datum/loadout_item/belts/fanny_pack_cyan
	item_path = /obj/item/storage/belt/fannypack/cyan

/datum/loadout_item/belts/fanny_pack_green
	item_path = /obj/item/storage/belt/fannypack/green

/datum/loadout_item/belts/fanny_pack_orange
	item_path = /obj/item/storage/belt/fannypack/orange

/datum/loadout_item/belts/fanny_pack_pink
	item_path = /obj/item/storage/belt/fannypack/pink

/datum/loadout_item/belts/fanny_pack_purple
	item_path = /obj/item/storage/belt/fannypack/purple

/datum/loadout_item/belts/fanny_pack_red
	item_path = /obj/item/storage/belt/fannypack/red

/datum/loadout_item/belts/fanny_pack_yellow
	item_path = /obj/item/storage/belt/fannypack/yellow

/datum/loadout_item/belts/fanny_pack_white
	item_path = /obj/item/storage/belt/fannypack/white

/datum/loadout_item/belts/lantern
	item_path = /obj/item/flashlight/lantern

/datum/loadout_item/belts/candle_box
	item_path = /obj/item/storage/fancy/candle_box

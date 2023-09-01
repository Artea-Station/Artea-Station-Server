// --- Loadout item datums for heads ---

/// Head Slot Items (Deletes overrided items)
/datum/loadout_category/head
	category_name = "Head"
	ui_title = "Head Slot Items"
	type_to_generate = /datum/loadout_item/head

/datum/loadout_item/head
	abstract_type = /datum/loadout_item/head

/datum/loadout_item/head/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE)
	if(isplasmaman(equipper))
		if(!visuals_only)
			to_chat(equipper, "Your loadout helmet was not equipped directly due to your envirosuit helmet.")
			LAZYADD(outfit.backpack_contents, item_path)
	else
		outfit.head = item_path

/datum/loadout_item/head/beanie
	item_path = /obj/item/clothing/head/beanie

/datum/loadout_item/head/christmas_beanie
	item_path = /obj/item/clothing/head/beanie/christmas

/datum/loadout_item/head/black_beret
	item_path = /obj/item/clothing/head/beret/black

/datum/loadout_item/head/red_beret
	item_path = /obj/item/clothing/head/beret

/datum/loadout_item/head/black_cap
	item_path = /obj/item/clothing/head/soft/black

/datum/loadout_item/head/blue_cap
	item_path = /obj/item/clothing/head/soft/blue

/datum/loadout_item/head/green_cap
	item_path = /obj/item/clothing/head/soft/green

/datum/loadout_item/head/grey_cap
	item_path = /obj/item/clothing/head/soft/grey

/datum/loadout_item/head/orange_cap
	item_path = /obj/item/clothing/head/soft/orange

/datum/loadout_item/head/purple_cap
	item_path = /obj/item/clothing/head/soft/purple

/datum/loadout_item/head/rainbow_cap
	item_path = /obj/item/clothing/head/soft/rainbow

/datum/loadout_item/head/red_cap
	item_path = /obj/item/clothing/head/soft/red

/datum/loadout_item/head/white_cap
	item_path = /obj/item/clothing/head/soft

/datum/loadout_item/head/yellow_cap
	item_path = /obj/item/clothing/head/soft/yellow

/datum/loadout_item/head/flatcap
	item_path = /obj/item/clothing/head/flatcap

/datum/loadout_item/head/beige_fedora
	item_path = /obj/item/clothing/head/fedora/beige

/datum/loadout_item/head/black_fedora
	item_path = /obj/item/clothing/head/fedora

/datum/loadout_item/head/white_fedora
	item_path = /obj/item/clothing/head/fedora/white

/datum/loadout_item/head/rastafarian
	item_path = /obj/item/clothing/head/rasta

/datum/loadout_item/head/poppy
	item_path = /obj/item/food/grown/poppy

/datum/loadout_item/head/lily
	item_path = /obj/item/food/grown/poppy/lily

/datum/loadout_item/head/geranium
	item_path = /obj/item/food/grown/poppy/geranium

/datum/loadout_item/head/rose
	item_path = /obj/item/food/grown/rose

/datum/loadout_item/head/sunflower
	item_path = /obj/item/food/grown/sunflower

/datum/loadout_item/head/harebell
	item_path = /obj/item/food/grown/harebell

/datum/loadout_item/head/rainbow_bunch
	item_path = /obj/item/food/grown/rainbow_flower
	additional_tooltip_contents = list(TOOLTIP_RANDOM_COLOR)

/datum/loadout_item/head/wig
	item_path = /obj/item/clothing/head/wig/natural

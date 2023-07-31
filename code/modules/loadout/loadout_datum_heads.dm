// --- Loadout item datums for heads ---

/// Head Slot Items (Deletes overrided items)
/datum/loadout_category/head
	category_name = "Head"
	ui_title = "Head Slot Items"

/datum/loadout_category/head/get_items()
	var/static/list/loadout_head = generate_loadout_items(/datum/loadout_item/head)
	return loadout_head

/datum/loadout_item/head
	category = LOADOUT_ITEM_HEAD

/datum/loadout_item/head/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE)
	if(isplasmaman(equipper))
		if(!visuals_only)
			to_chat(equipper, "Your loadout helmet was not equipped directly due to your envirosuit helmet.")
			LAZYADD(outfit.backpack_contents, item_path)
	else
		outfit.head = item_path

/datum/loadout_item/head/beanie
	name = "Greyscale Beanie"
	item_path = /obj/item/clothing/head/beanie

/datum/loadout_item/head/christmas_beanie
	name = "Christmas Beanie"
	item_path = /obj/item/clothing/head/beanie/christmas

/datum/loadout_item/head/black_beret
	name = "Black Beret"
	item_path = /obj/item/clothing/head/beret/black

/datum/loadout_item/head/red_beret
	name = "Red Beret"
	item_path = /obj/item/clothing/head/beret

/datum/loadout_item/head/black_cap
	name = "Black Cap"
	item_path = /obj/item/clothing/head/soft/black

/datum/loadout_item/head/blue_cap
	name = "Blue Cap"
	item_path = /obj/item/clothing/head/soft/blue

/datum/loadout_item/head/green_cap
	name = "Green Cap"
	item_path = /obj/item/clothing/head/soft/green

/datum/loadout_item/head/grey_cap
	name = "Grey Cap"
	item_path = /obj/item/clothing/head/soft/grey

/datum/loadout_item/head/orange_cap
	name = "Orange Cap"
	item_path = /obj/item/clothing/head/soft/orange

/datum/loadout_item/head/purple_cap
	name = "Purple Cap"
	item_path = /obj/item/clothing/head/soft/purple

/datum/loadout_item/head/rainbow_cap
	name = "Rainbow Cap"
	item_path = /obj/item/clothing/head/soft/rainbow

/datum/loadout_item/head/red_cap
	name = "Red Cap"
	item_path = /obj/item/clothing/head/soft/red

/datum/loadout_item/head/white_cap
	name = "White Cap"
	item_path = /obj/item/clothing/head/soft

/datum/loadout_item/head/yellow_cap
	name = "Yellow Cap"
	item_path = /obj/item/clothing/head/soft/yellow

/datum/loadout_item/head/flatcap
	name = "Flat Cap"
	item_path = /obj/item/clothing/head/flatcap

/datum/loadout_item/head/beige_fedora
	name = "Beige Fedora"
	item_path = /obj/item/clothing/head/fedora/beige

/datum/loadout_item/head/black_fedora
	name = "Black Fedora"
	item_path = /obj/item/clothing/head/fedora

/datum/loadout_item/head/white_fedora
	name = "White Fedora"
	item_path = /obj/item/clothing/head/fedora/white

/datum/loadout_item/head/rastafarian
	name = "Rastafarian Cap"
	item_path = /obj/item/clothing/head/rasta

/datum/loadout_item/head/poppy
	name = "Poppy"
	item_path = /obj/item/food/grown/poppy

/datum/loadout_item/head/lily
	name = "Lily"
	item_path = /obj/item/food/grown/poppy/lily

/datum/loadout_item/head/geranium
	name = "Geranium"
	item_path = /obj/item/food/grown/poppy/geranium

/datum/loadout_item/head/rose
	name = "Rose"
	item_path = /obj/item/food/grown/rose

/datum/loadout_item/head/sunflower
	name = "Sunflower"
	item_path = /obj/item/food/grown/sunflower

/datum/loadout_item/head/harebell
	name = "Harebell"
	item_path = /obj/item/food/grown/harebell

/datum/loadout_item/head/rainbow_bunch
	name = "Rainbow Bunch"
	item_path = /obj/item/food/grown/rainbow_flower
	additional_tooltip_contents = list(TOOLTIP_RANDOM_COLOR)

/datum/loadout_item/head/wig
	name = "Wig"
	item_path = /obj/item/clothing/head/wig/natural

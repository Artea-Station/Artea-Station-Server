// --- Loadout item datums for exosuits / suits ---

/// Exosuit / Outersuit Slot Items (Deletes overrided items)
/datum/loadout_category/outer_suit
	category_name = "Suit"
	ui_title = "Outer Suit Slot Items"

/datum/loadout_category/outer_suit/get_items()
	var/static/list/loadout_outer_suits = generate_loadout_items(/datum/loadout_item/suit)
	return loadout_outer_suits

/datum/loadout_item/suit
	category = LOADOUT_ITEM_SUIT

/datum/loadout_item/suit/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE)
	outfit.suit = item_path
	if(outfit.suit_store)
		LAZYADD(outfit.backpack_contents, outfit.suit_store)
		outfit.suit_store = null

/datum/loadout_item/suit/winter_coat
	item_path = /obj/item/clothing/suit/hooded/wintercoat

/datum/loadout_item/suit/winter_coat_greyscale
	item_path = /obj/item/clothing/suit/hooded/wintercoat/custom

/datum/loadout_item/suit/big_jacket
	item_path = /obj/item/clothing/suit/jacket/oversized

/datum/loadout_item/suit/fancy_jacket
	item_path = /obj/item/clothing/suit/jacket/fancy

/datum/loadout_item/suit/sweater
	item_path = /obj/item/clothing/suit/toggle/jacket/sweater

/datum/loadout_item/suit/denim_overalls
	item_path = /obj/item/clothing/suit/apron/overalls

/datum/loadout_item/suit/black_suit_jacket
	item_path = /obj/item/clothing/suit/toggle/lawyer/black

/datum/loadout_item/suit/blue_suit_jacket
	item_path = /obj/item/clothing/suit/toggle/lawyer

/datum/loadout_item/suit/purple_suit_jacket
	item_path = /obj/item/clothing/suit/toggle/lawyer/purple

/datum/loadout_item/suit/purple_apron
	item_path = /obj/item/clothing/suit/apron/purple_bartender

/datum/loadout_item/suit/suspenders_greyscale
	item_path = /obj/item/clothing/suit/toggle/suspenders

/datum/loadout_item/suit/white_dress
	item_path = /obj/item/clothing/suit/costume/whitedress

/datum/loadout_item/suit/labcoat
	item_path = /obj/item/clothing/suit/toggle/labcoat

/datum/loadout_item/suit/labcoat_green
	item_path = /obj/item/clothing/suit/toggle/labcoat/mad

/datum/loadout_item/suit/poncho
	item_path = /obj/item/clothing/suit/costume/poncho

/datum/loadout_item/suit/poncho_green
	item_path = /obj/item/clothing/suit/costume/poncho/green

/datum/loadout_item/suit/poncho_red
	item_path = /obj/item/clothing/suit/costume/poncho/red

/datum/loadout_item/suit/wawaiian_shirt
	item_path = /obj/item/clothing/suit/costume/hawaiian

/datum/loadout_item/suit/bomber_jacket
	item_path = /obj/item/clothing/suit/jacket/bomber

/datum/loadout_item/suit/military_jacket
	item_path = /obj/item/clothing/suit/jacket/miljacket

/datum/loadout_item/suit/puffer_jacket
	item_path = /obj/item/clothing/suit/jacket/puffer

/datum/loadout_item/suit/puffer_vest
	item_path = /obj/item/clothing/suit/jacket/puffer/vest

/datum/loadout_item/suit/leather_jacket
	item_path = /obj/item/clothing/suit/jacket/leather

/datum/loadout_item/suit/brown_letterman
	item_path = /obj/item/clothing/suit/jacket/letterman

/datum/loadout_item/suit/red_letterman
	item_path = /obj/item/clothing/suit/jacket/letterman_red

/datum/loadout_item/suit/blue_letterman
	item_path = /obj/item/clothing/suit/jacket/letterman_nanotrasen

/datum/loadout_item/suit/bee
	item_path = /obj/item/clothing/suit/hooded/bee_costume

/datum/loadout_item/suit/plague_doctor
	item_path = /obj/item/clothing/suit/bio_suit/plaguedoctorsuit

/datum/loadout_item/suit/ethereal_cloak
	item_path = /obj/item/clothing/suit/hooded/ethereal_raincoat

/datum/loadout_item/suit/moth_cloak
	item_path = /obj/item/clothing/suit/mothcoat

/datum/loadout_item/suit/moth_cloak_winter
	item_path = /obj/item/clothing/suit/mothcoat/winter

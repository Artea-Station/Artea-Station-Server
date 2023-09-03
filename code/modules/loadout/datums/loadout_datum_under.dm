// --- Loadout item datums for under suits ---

/// Underslot - Jumpsuit Items (Deletes overrided items)
/datum/loadout_category/undersuit
	category_name = "Jumpsuit"
	ui_title = "Under Suit Slot Items"
	type_to_generate = /datum/loadout_item/under/jumpsuit

/// Underslot - Formal Suit Items (Deletes overrided items)
/datum/loadout_category/undersuit/formal
	category_name = "Formal"
	type_to_generate = /datum/loadout_item/under/formal

/datum/loadout_item/under
	abstract_type = /datum/loadout_item/under

/datum/loadout_item/under/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE)
	if(isplasmaman(equipper) && !visuals_only)
		to_chat(equipper, "Your loadout uniform was not equipped directly due to your envirosuit.")
		LAZYADD(outfit.backpack_contents, item_path)
	else
		outfit.uniform = item_path

// jumpsuit undersuits
/datum/loadout_item/under/jumpsuit
	abstract_type = /datum/loadout_item/under/jumpsuit

/datum/loadout_item/under/jumpsuit/random
	name = "random jumpsuit"
	can_be_greyscale = DONT_GREYSCALE
	item_path = /obj/item/clothing/under/color/random
	additional_tooltip_contents = list(TOOLTIP_RANDOM_COLOR)

/datum/loadout_item/under/jumpsuit/random/on_equip_item(datum/preferences/preference_source, mob/living/carbon/human/equipper, visuals_only, list/preference_list)
	return

/datum/loadout_item/under/jumpsuit/random/skirt
	name = "random jumpskirt"
	item_path = /obj/item/clothing/under/color/jumpskirt/random

/datum/loadout_item/under/jumpsuit/jeans
	item_path = /obj/item/clothing/under/pants/jeans

/datum/loadout_item/under/jumpsuit/shorts
	item_path = /obj/item/clothing/under/shorts

/datum/loadout_item/under/jumpsuit/track
	item_path = /obj/item/clothing/under/pants/track

/datum/loadout_item/under/jumpsuit/camo
	item_path = /obj/item/clothing/under/pants/camo

/datum/loadout_item/under/jumpsuit/kilt
	item_path = /obj/item/clothing/under/costume/kilt

/datum/loadout_item/under/jumpsuit/treasure_hunter
	item_path = /obj/item/clothing/under/rank/civilian/curator/treasure_hunter

/datum/loadout_item/under/jumpsuit/overalls
	item_path = /obj/item/clothing/under/misc/overalls

/datum/loadout_item/under/jumpsuit/pj_blue
	item_path = /obj/item/clothing/under/misc/mailman

/datum/loadout_item/under/jumpsuit/vice_officer
	item_path = /obj/item/clothing/under/misc/vice_officer

/datum/loadout_item/under/jumpsuit/soviet
	item_path = /obj/item/clothing/under/costume/soviet

/datum/loadout_item/under/jumpsuit/redcoat
	item_path = /obj/item/clothing/under/costume/redcoat

/datum/loadout_item/under/jumpsuit/pj_red
	item_path = /obj/item/clothing/under/misc/pj/red

/datum/loadout_item/under/jumpsuit/pj_blue
	item_path = /obj/item/clothing/under/misc/pj/blue

// formal undersuits
/datum/loadout_item/under/formal
	abstract_type = /datum/loadout_item/under/formal

/datum/loadout_item/under/formal/amish_suit
	item_path = /obj/item/clothing/under/suit/sl

/datum/loadout_item/under/formal/assistant
	item_path = /obj/item/clothing/under/misc/assistantformal

/datum/loadout_item/under/formal/beige_suit
	item_path = /obj/item/clothing/under/suit/beige

/datum/loadout_item/under/formal/black_suit
	item_path = /obj/item/clothing/under/suit/black

/datum/loadout_item/under/formal/executive_suit_alt
	item_path = /obj/item/clothing/under/rank/civilian/lawyer/beige

/datum/loadout_item/under/formal/executive_skirt_alt
	item_path = /obj/item/clothing/under/rank/civilian/lawyer/beige/skirt

/datum/loadout_item/under/formal/black_suitskirt
	item_path = /obj/item/clothing/under/suit/black/skirt

/datum/loadout_item/under/formal/tango
	item_path = /obj/item/clothing/under/dress/tango

/datum/loadout_item/under/formal/Black_twopiece
	item_path = /obj/item/clothing/under/suit/blacktwopiece

/datum/loadout_item/under/formal/black_lawyer_suit
	item_path = /obj/item/clothing/under/rank/civilian/lawyer/black

/datum/loadout_item/under/formal/black_lawyer_skirt
	item_path = /obj/item/clothing/under/rank/civilian/lawyer/black/skirt

/datum/loadout_item/under/formal/blue_suit
	item_path = /obj/item/clothing/under/rank/civilian/lawyer/bluesuit

/datum/loadout_item/under/formal/blue_suitskirt
	item_path = /obj/item/clothing/under/rank/civilian/lawyer/bluesuit/skirt

/datum/loadout_item/under/formal/blue_lawyer_suit
	item_path = /obj/item/clothing/under/rank/civilian/lawyer/blue

/datum/loadout_item/under/formal/blue_lawyer_skirt
	item_path = /obj/item/clothing/under/rank/civilian/lawyer/blue/skirt

/datum/loadout_item/under/formal/burgundy_suit
	item_path = /obj/item/clothing/under/suit/burgundy

/datum/loadout_item/under/formal/buttondown_slacks
	item_path = /obj/item/clothing/under/costume/buttondown/slacks

/datum/loadout_item/under/formal/buttondown_shorts
	item_path = /obj/item/clothing/under/costume/buttondown/shorts

/datum/loadout_item/under/formal/charcoal_suit
	item_path = /obj/item/clothing/under/suit/charcoal

/datum/loadout_item/under/formal/checkered_suit
	item_path = /obj/item/clothing/under/suit/checkered

/datum/loadout_item/under/formal/executive_suit
	item_path = /obj/item/clothing/under/suit/black_really

/datum/loadout_item/under/formal/executive_skirt
	item_path = /obj/item/clothing/under/suit/black_really/skirt

/datum/loadout_item/under/formal/green_suit
	item_path = /obj/item/clothing/under/suit/green

/datum/loadout_item/under/formal/skirt_greyscale
	item_path = /obj/item/clothing/under/dress/skirt

/datum/loadout_item/under/formal/plaid_skirt_greyscale
	item_path = /obj/item/clothing/under/dress/skirt/plaid

/datum/loadout_item/under/formal/navy_suit
	item_path = /obj/item/clothing/under/suit/navy

/datum/loadout_item/under/formal/maid_outfit
	item_path = /obj/item/clothing/under/costume/maid

/datum/loadout_item/under/formal/maid_uniform
	item_path = /obj/item/clothing/under/rank/civilian/janitor/maid

/datum/loadout_item/under/formal/purple_suit
	item_path = /obj/item/clothing/under/rank/civilian/lawyer/purpsuit

/datum/loadout_item/under/formal/purple_suitskirt
	item_path = /obj/item/clothing/under/rank/civilian/lawyer/purpsuit/skirt

/datum/loadout_item/under/formal/red_suit
	item_path = /obj/item/clothing/under/suit/red

/datum/loadout_item/under/formal/red_lawyer_skirt
	item_path = /obj/item/clothing/under/rank/civilian/lawyer/red

/datum/loadout_item/under/formal/red_lawyer_skirt
	item_path = /obj/item/clothing/under/rank/civilian/lawyer/red/skirt

/datum/loadout_item/under/formal/red_gown
	item_path = /obj/item/clothing/under/dress/redeveninggown

/datum/loadout_item/under/formal/sailor
	item_path = /obj/item/clothing/under/costume/sailor

/datum/loadout_item/under/formal/sailor_skirt
	item_path = /obj/item/clothing/under/dress/sailor

/datum/loadout_item/under/formal/scratch_suit
	item_path = /obj/item/clothing/under/suit/white_on_white

/datum/loadout_item/under/formal/striped_skirt
	item_path = /obj/item/clothing/under/dress/striped

/datum/loadout_item/under/formal/sensible_suit
	item_path = /obj/item/clothing/under/rank/civilian/curator

/datum/loadout_item/under/formal/sensible_skirt
	item_path = /obj/item/clothing/under/rank/civilian/curator/skirt

/datum/loadout_item/under/formal/sundress
	item_path = /obj/item/clothing/under/dress/sundress

/datum/loadout_item/under/formal/tan_suit
	item_path = /obj/item/clothing/under/suit/tan

/datum/loadout_item/under/formal/turtleneck_skirt
	item_path = /obj/item/clothing/under/dress/skirt/turtleskirt

/datum/loadout_item/under/formal/tuxedo
	item_path = /obj/item/clothing/under/suit/tuxedo

/datum/loadout_item/under/formal/waiter
	item_path = /obj/item/clothing/under/suit/waiter

/datum/loadout_item/under/formal/wedding
	item_path = /obj/item/clothing/under/dress/wedding_dress

/datum/loadout_item/under/formal/white_suit
	item_path = /obj/item/clothing/under/suit/white

/datum/loadout_item/under/formal/white_skirt
	item_path = /obj/item/clothing/under/suit/white/skirt

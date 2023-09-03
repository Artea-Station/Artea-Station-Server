// --- Loadout item datums for backpack / pocket items ---

/// Pocket items (Moved to backpack)
/datum/loadout_category/pocket
	category_name = "Other"
	type_to_generate = /datum/loadout_item/pocket_items
	/// How many pocket items are allowed
	var/max_allowed = 3

/datum/loadout_category/pocket/New()
	. = ..()
	ui_title = "Backpack Items ([max_allowed] max)"

/datum/loadout_category/pocket/handle_duplicate_entires(
	datum/preference_middleware/loadout/manager,
	datum/loadout_item/conflicting_item,
	datum/loadout_item/added_item,
	list/datum/loadout_item/all_loadout_items,
)
	var/list/datum/loadout_item/pocket_items/other_pocket_items = list()
	for(var/datum/loadout_item/pocket_items/other_pocket_item in all_loadout_items)
		other_pocket_items += other_pocket_item

	if(length(other_pocket_items) >= max_allowed)
		// We only need to deselect something if we're above the limit
		// (And if we are we prioritize the first item found, FIFO)
		manager.deselect_item(other_pocket_items[1])
	return TRUE

/datum/loadout_item/pocket_items
	abstract_type = /datum/loadout_item/pocket_items

/datum/loadout_item/pocket_items/on_equip_item(datum/preferences/preference_source, mob/living/carbon/human/equipper, visuals_only, list/preference_list)
	// Backpack items aren't created if it's a visual equipping, so don't do any on equip stuff. It doesn't exist.
	if(visuals_only)
		return

	return ..()

// The wallet loadout item is special, and puts the player's ID and other small items into it on initialize (fancy!)
/datum/loadout_item/pocket_items/wallet
	item_path = /obj/item/storage/wallet
	additional_tooltip_contents = list("FILLS AUTOMATICALLY - This item will populate itself with your ID card and other small items you may have on spawn.")

// We add our wallet manually, later, so no need to put it in any outfits.
/datum/loadout_item/pocket_items/wallet/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only)
	return

// We didn't spawn any item yet, so nothing to call here.
/datum/loadout_item/pocket_items/wallet/on_equip_item(datum/preferences/preference_source, mob/living/carbon/human/equipper, visuals_only, list/preference_list)
	return

// We add our wallet at the very end of character initialization (after quirks, etc) to ensure the backpack / their ID is all set by now.
/datum/loadout_item/pocket_items/wallet/post_equip_item(datum/preferences/preference_source, mob/living/carbon/human/equipper, is_visual = FALSE)
	if(is_visual)
		return

	var/obj/item/card/id/advanced/id_card = equipper.get_item_by_slot(ITEM_SLOT_ID)
	if(istype(id_card, /obj/item/storage/wallet)) // Wallets station trait guard
		return

	var/obj/item/storage/wallet/wallet = new(equipper)
	if(istype(id_card))
		equipper.temporarilyRemoveItemFromInventory(id_card, force = TRUE)
		equipper.equip_to_slot_if_possible(wallet, ITEM_SLOT_ID, initial = TRUE)
		id_card.forceMove(wallet)

		for(var/obj/item/thing in equipper?.back)
			if(wallet.contents.len >= 3)
				break
			if(thing.w_class > WEIGHT_CLASS_SMALL)
				continue
			wallet.atom_storage.attempt_insert(thing, override = TRUE, force = TRUE)

	else
		if(!equipper.equip_to_slot_if_possible(wallet, slot = ITEM_SLOT_BACKPACK, initial = TRUE))
			wallet.forceMove(equipper.drop_location())

/datum/loadout_item/pocket_items/rag
	item_path = /obj/item/reagent_containers/cup/rag

/datum/loadout_item/pocket_items/gum_pack
	item_path = /obj/item/storage/box/gum

/datum/loadout_item/pocket_items/gum_pack_nicotine
	item_path = /obj/item/storage/box/gum/nicotine

/datum/loadout_item/pocket_items/gum_pack_hp
	item_path = /obj/item/storage/box/gum/happiness

/datum/loadout_item/pocket_items/lipstick_black
	item_path = /obj/item/lipstick/black

/datum/loadout_item/pocket_items/lipstick_jade
	item_path = /obj/item/lipstick/jade

/datum/loadout_item/pocket_items/lipstick_purple
	item_path = /obj/item/lipstick/purple

/datum/loadout_item/pocket_items/lipstick_red
	item_path = /obj/item/lipstick

/datum/loadout_item/pocket_items/razor
	item_path = /obj/item/razor

/datum/loadout_item/pocket_items/lighter
	item_path = /obj/item/lighter

/datum/loadout_item/pocket_items/plush
	abstract_type = /datum/loadout_item/pocket_items/plush
	can_be_named = TRUE

/datum/loadout_item/pocket_items/plush/bee
	item_path = /obj/item/toy/plush/beeplushie

/datum/loadout_item/pocket_items/plush/carp
	item_path = /obj/item/toy/plush/carpplushie

/datum/loadout_item/pocket_items/plush/lizard_random
	name = "random lizard plush"
	can_be_greyscale = LOADOUT_DONT_GREYSCALE
	item_path = /obj/item/toy/plush/lizard_plushie
	additional_tooltip_contents = list(TOOLTIP_RANDOM_COLOR)

/datum/loadout_item/pocket_items/plush/moth
	item_path = /obj/item/toy/plush/moth

/datum/loadout_item/pocket_items/plush/narsie
	item_path = /obj/item/toy/plush/narplush

/datum/loadout_item/pocket_items/plush/nukie
	item_path = /obj/item/toy/plush/nukeplushie

/datum/loadout_item/pocket_items/plush/peacekeeper
	item_path = /obj/item/toy/plush/pkplush

/datum/loadout_item/pocket_items/plush/plasmaman
	item_path = /obj/item/toy/plush/plasmamanplushie

/datum/loadout_item/pocket_items/plush/ratvar
	item_path = /obj/item/toy/plush/ratplush

/datum/loadout_item/pocket_items/plush/rouny
	item_path = /obj/item/toy/plush/rouny

/datum/loadout_item/pocket_items/plush/snake
	item_path = /obj/item/toy/plush/snakeplushie

/datum/loadout_item/pocket_items/card_binder
	item_path = /obj/item/storage/card_binder

/datum/loadout_item/pocket_items/card_deck
	item_path = /obj/item/toy/cards/deck

/datum/loadout_item/pocket_items/kotahi_deck
	item_path = /obj/item/toy/cards/deck/kotahi

/datum/loadout_item/pocket_items/wizoff_deck
	item_path = /obj/item/toy/cards/deck/wizoff

/datum/loadout_item/pocket_items/dice_bag
	item_path = /obj/item/storage/dice

/datum/loadout_item/pocket_items/d12
	item_path = /obj/item/dice/d1

/datum/loadout_item/pocket_items/d2
	item_path = /obj/item/dice/d2

/datum/loadout_item/pocket_items/d4
	item_path = /obj/item/dice/d4

/datum/loadout_item/pocket_items/d6
	item_path = /obj/item/dice/d6

/datum/loadout_item/pocket_items/d6_ebony
	item_path = /obj/item/dice/d6/ebony

/datum/loadout_item/pocket_items/d6_space
	item_path = /obj/item/dice/d6/space

/datum/loadout_item/pocket_items/d8
	item_path = /obj/item/dice/d8

/datum/loadout_item/pocket_items/d10
	item_path = /obj/item/dice/d10

/datum/loadout_item/pocket_items/d12
	item_path = /obj/item/dice/d12

/datum/loadout_item/pocket_items/d20
	item_path = /obj/item/dice/d20

/datum/loadout_item/pocket_items/d100
	item_path = /obj/item/dice/d100

/datum/loadout_item/pocket_items/d00
	item_path = /obj/item/dice/d00

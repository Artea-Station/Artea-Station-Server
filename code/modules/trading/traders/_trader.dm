/datum/trader
	/// A runtime assigned ID.
	var/id
	/// Name of the trader
	var/name = "unsuspicious trader"
	/// Place where he comes from, it'll be shown to the user
	var/origin = "some place"
	/// A list of possible places where he'll be from
	var/list/possible_origins
	/// A list of possible names he'll have
	var/list/possible_names
	/// The hub they belong to
	var/datum/trade_hub/hub

	/// The maximum amount of packs held.
	var/max_packs_amount = 10
	/// The minimum amount of packs held.
	var/min_packs_amount = 8
	/// What group of packs can this trader sell? Accepts any TRADER_CATEGORY define. Can be a list, or a singleton.
	var/pack_groups
	/// List of sold supply packs. Setting this to null effectively disables the trader's selling functionality.
	var/list/sold_packs = list()

	/// Cash they hold, they won't be able to pay out if it gets too low
	var/current_credits = DEFAULT_TRADER_CREDIT_AMOUNT

	/// A list of connected trade consoles, in case the trader is destroyed we want to disconnect the consoles
	var/list/connected_consoles = list()

	/// Whether the trader rotates stock or not
	var/rotates_stock = TRUE
	/// What's the chance the vendor will rotate stock. 1 to 100.
	var/rotate_stock_chance = 100

	/// Current listed bounties
	var/list/bounties
	/// Possible normal bounties, associative to weight
	var/list/possible_bounties
	/// Possible supplies bounties, associative to weight
	var/list/possible_supplies_bounties
	/// Chance to gain a bounty per stock rotation
	var/bounty_gain_chance = 15
	/// Chance to gain a bounty when the trader is spawned in
	var/initial_bounty_gain_chance = 50

	/// Current listed deliveries
	var/list/deliveries
	/// All possible deliveries, associative to weight
	var/list/possible_deliveries
	/// Chance to gain a delivery per stock rotation
	var/delivery_gain_chance = 15
	/// Chance to gain a delivery when the trader is spawned in
	var/initial_delivery_gain_chance = 50

	/// An associative list of unique responses
	var/list/speech

	/// Does this trader hate robots/synths?
	var/technophobic = FALSE

	/// The speech color for this trader. If null, it will pick a (semi) random color on init.
	var/speech_color

/datum/trader/New(datum/trade_hub/our_hub)
	. = ..()
	id = SStrading.get_next_trader_id()
	hub = our_hub
	hub.traders += src
	SStrading.all_traders["[id]"] = src
	if(possible_origins)
		origin = pick(possible_origins)
		possible_origins = null
	if(possible_names)
		name = pick(possible_names)
		possible_names = null

	if(!speech_color)
		speech_color = pick(
			"#aaaaaa",
			"#aaaaaa",
		)

	initialize_stock()

/// Separate proc so admins can force shop restocks easily.
/datum/trader/proc/initialize_stock()
	if(prob(initial_bounty_gain_chance))
		gain_bounty()
	if(prob(initial_bounty_gain_chance))
		gain_supplies_bounty()
	if(prob(initial_delivery_gain_chance))
		gain_delivery()
	if(!pack_groups)
		CRASH("Trader [type] ([id]) has no pack groups set! Set them!")
	if(sold_packs)
		var/list/sold_goods_init = list()
		var/goods_to_sell = rand(min_packs_amount, max_packs_amount)

		for(var/i = 0, i < goods_to_sell, i++)
			var/group_to_use = pack_groups
			if(islist(group_to_use))
				group_to_use = pick(group_to_use)

			var/datum/supply_pack/pack = pick(SStrading.group_to_supplies[group_to_use])
			if(!pack) // ARTEA TODO: Fix groups having the potential to be null. (What the fuck?)
				i--
				continue
			pack.stock["[id]"] = pack.default_stock
			sold_goods_init += pack.id

		sold_packs = sold_goods_init

/datum/trader/proc/tick()
	if(current_credits < (initial(current_credits)*(TRADER_LOW_CASH_THRESHOLD/100)))
		current_credits += rand(TRADER_PAYCHECK_LOW, TRADER_PAYCHECK_HIGH)
	if(rotates_stock && prob(rotate_stock_chance))
		rotate_stock()

/// For the traders to override and do some special interactions after trading
/datum/trader/proc/after_trade(mob/user, obj/machinery/computer/trade_console/console, datum/supply_pack/pack)
	return

/// TRUE to accept hail, FALSE to reject it. Speciest traders could reject hails from some species.
/// Default behavior checks if the trader is technophobic, and if the user is a silicon or synth, before declining the hail if the conditions are met.
/// This will also be called every interaction, and may shut down the comms, last response will be the close reason
/datum/trader/proc/get_hailed(mob/user, obj/machinery/computer/trade_console/console)
	if(technophobic && (issilicon(user) || issynthetic(user)))
		return FALSE

	return TRUE

/// Called when someone tries to buy a supply pack. THE PACK IS CLIENT-PROVIDED, CHECK YOUR SHIT.
/datum/trader/proc/requested_buy(mob/user, obj/machinery/computer/trade_console/console, datum/supply_pack/goodie)
	var/proposed_cost = goodie.get_cost()

	var/obj/item/coupon/applied_coupon
	for(var/i in console.loaded_coupons)
		var/obj/item/coupon/coupon_check = i
		if(goodie.type == coupon_check.discounted_pack)
			applied_coupon = coupon_check
			break

	if(!goodie.stock["[id]"])
		return get_response("out_of_stock", "I'm afraid I don't have any more of these!", user)
	if(!console.inserted_id.registered_account.adjust_money(-proposed_cost))
		return get_response("user_no_money", "You can't afford this", user)

	if(applied_coupon)
		applied_coupon.moveToNullspace()
		console.say("Coupon found! [round(applied_coupon.discount_pct_off * 100)]% off applied!")

	//We established there's stock and we have enough money for it
	console.inserted_id.registered_account.adjust_money(-proposed_cost)
	current_credits += proposed_cost
	if(goodie.stock["[id]"] != -1)
		goodie.stock["[id]"]--
	var/obj/item/card/id/inserted_id = console.inserted_id
	SStrading.shopping_list += new /datum/supply_order(goodie, inserted_id.registered_name, inserted_id.assignment, user.ckey, null, inserted_id.registered_account, null, applied_coupon)
	after_trade(user, console, goodie)
	console.write_manifest(src, goodie.name, 1, proposed_cost, FALSE, user.name)
	return get_response("trade_complete", "Thanks for your business!", user)

// ARTEA TODO: Make the shuttle check the itself for bounty items when it departs, and flag completed bounties as done and remove the items before selling anything.
// Then allow the console to claim the bounty. I'm not gonna add locking bounties to an ID. It's up to the crew to not stab each other over the payouts.
/datum/trader/proc/requested_bounty_claim(mob/user, obj/machinery/computer/trade_console/console, datum/trader_bounty/bounty)
	return
	// var/list/items_on_pad = console.linked_pad.get_valid_items()
	// var/list/valid_items = list()
	// var/counted_amount = 0
	// var/bounty_completed = FALSE
	// for(var/i in items_on_pad)
	// 	var/atom/movable/AM = i
	// 	var/amount_in_this_item = bounty.Validate(AM)
	// 	if(!amount_in_this_item)
	// 		continue
	// 	counted_amount += amount_in_this_item
	// 	valid_items += AM
	// 	if(counted_amount >= bounty.amount)
	// 		bounty_completed = TRUE
	// 		break
	// if(!bounty_completed)
	// 	return get_response("bounty_fail_claim", "I'm afraid you're a bit short of what I need!", user)
	// for(var/i in valid_items)
	// 	var/atom/movable/AM = i
	// 	qdel(AM)
	// console.inserted_id.registered_account.adjust_money(bounty.reward_cash)
	// if(bounty.reward_item_path)
	// 	console.write_manifest(src, bounty.reward_item_name, 1, 0, FALSE, user.name)
	// 	new bounty.reward_item_path(get_turf(console.linked_pad))
	// console.linked_pad.do_teleport_effect()
	// after_trade(user,console)
	// console.write_manifest(src, bounty.name, counted_amount, bounty.reward_cash, TRUE, user.name)
	// . = bounty.bounty_complete_text
	// bounties -= bounty
	// if(bounty.supplies_bounty)
	// 	current_supplies_bounty = null
	// else
	// 	current_bounty = null
	// qdel(bounty)
	// if(!bounties.len)
	// 	bounties = null

/// Returns a greeting message.
/datum/trader/proc/hail_msg(is_success, mob/user)
	var/key = is_success ? "hail" : "hail_deny"
	var/default = is_success ? "Greetings, MOB!" : "We're closed!"
	. = get_response(key, default, user)

/// Handles a mob accepting a delivery.
/datum/trader/proc/requested_delivery_take(mob/user, obj/machinery/computer/trade_console/console, datum/delivery_run/delivery)
	delivery.Accept(user, console)
	deliveries -= delivery
	qdel(delivery)
	if(!deliveries.len)
		deliveries = null
	return get_response("delivery_take", "Don't take too long!", user)

/// Returns a response suffix depending on the mob using the console. Can return species IDs, and the TRADE_USER_SUFFIX defines.
/datum/trader/proc/get_user_suffix(mob/user)
	if(!isliving(user))
		return
	if(isAI(user))
		return TRADE_USER_SUFFIX_AI
	if(iscyborg(user))
		return TRADE_USER_SUFFIX_CYBORG
	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		if(isgolem(human_user))
			return TRADE_USER_SUFFIX_GOLEM
		if(issynthetic(user))
			return TRADE_USER_SUFFIX_ROBOT_PERSON
		return human_user.dna.species.id

/// Generic getter for responses. Handles replacing keywords and getting species-specific responses as well.
/datum/trader/proc/get_response(key, default, mob/user)
	var/suffix = get_user_suffix(user)
	if(speech)
		if(speech["[key]_[suffix]"])
			. = speech["[key]_[suffix]"]
		else if (speech[key])
			. = speech[key]
	if(!.)
		. = default
	. = replacetext(., "MERCHANT", name)
	. = replacetext(., "ORIGIN", origin)
	. = replacetext(., "MOB", user.name)

/// Adds a new bounty. Remember to remove any old bounties yourself first, if you're replacing them.
/datum/trader/proc/gain_bounty()
	if(!possible_bounties)
		return
	LAZYINITLIST(bounties)
	var/bounty_type = pick_weight(possible_bounties)
	var/datum/trader_bounty/new_bounty = new bounty_type()
	bounties += new_bounty

/// Adds a new bounty supplies bounty. Remember to remove any old bounties yourself first, if you're replacing them.
/datum/trader/proc/gain_supplies_bounty()
	if(!possible_supplies_bounties)
		return
	LAZYINITLIST(bounties)
	var/bounty_type = pick_weight(possible_supplies_bounties)
	var/datum/trader_bounty/new_bounty = new bounty_type()
	new_bounty.supplies_bounty = TRUE
	bounties += new_bounty

/// Adds a new delivery IF there is no other delivery up for grabs. Deliveries pay *a lot* relative to effort.
/datum/trader/proc/gain_delivery()
	if(deliveries || !possible_deliveries)
		return
	LAZYINITLIST(deliveries)
	var/delivery_type = pick_weight(possible_deliveries)
	deliveries += new delivery_type(src)

#define TRADER_RESTOCK_ESCAPE_CHANCE 60

/datum/trader/proc/rotate_stock()
	if(prob(bounty_gain_chance))
		gain_bounty()
	if(prob(bounty_gain_chance))
		gain_supplies_bounty()
	if(prob(delivery_gain_chance))
		gain_delivery()
	// Restock some sold goodies
	if(sold_packs)
		var/sold_goods_pick_n_take = sold_packs.Copy()
		var/datum/supply_pack/goodie = SStrading.supply_packs[pick_n_take(sold_goods_pick_n_take)]
		while(goodie)
			if(goodie.stock["[id]"] == -1)
				continue
			var/percentage_remaining = goodie.stock["[id]"] / goodie.default_stock
			if(percentage_remaining <= TRADER_RESTOCK_THRESHOLD)
				goodie.stock["[id]"] = goodie.default_stock
				if(prob(TRADER_RESTOCK_ESCAPE_CHANCE)) //Chance that it's the end of restocking for this tick
					return
			goodie = pick_n_take(sold_goods_pick_n_take)

#undef TRADER_RESTOCK_ESCAPE_CHANCE

/// Removes the
/datum/trader/proc/clear_stock()
	for(var/goodie_id as anything in sold_packs)
		var/datum/supply_pack/goodie = SStrading.supply_packs[goodie_id]
		LAZYREMOVE(goodie.stock, id)
		sold_packs -= goodie

/datum/trader/Destroy()
	clear_stock()
	sold_packs = null

	for(var/i in connected_consoles)
		var/obj/machinery/computer/trade_console/console = i
		console.disconnect_trader()
	connected_consoles = null

	hub.traders -= src
	hub = null

	SStrading.all_traders -= "[id]"
	return ..()

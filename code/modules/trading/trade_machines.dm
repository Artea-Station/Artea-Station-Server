/obj/machinery/computer/trade_console
	name = "trade console"
	icon_screen = "supply"
	desc = "Used for communication between the trade networks and for conducting trades."
	circuit = /obj/item/circuitboard/computer/trade_console
	light_color = COLOR_BRIGHT_ORANGE
	var/obj/machinery/trade_pad/linked_pad
	var/credits_held = 0

	var/last_transmission = ""
	var/denied_hail_transmission

	var/datum/trade_hub/connected_hub
	var/datum/trader/connected_trader
	var/trader_screen_state = TRADER_SCREEN_NOTHING

	var/viewed_log = FALSE
	var/makes_log = TRUE
	var/makes_manifests = TRUE

	var/list/trade_log

	var/list/manifest_purchased
	var/list/manifest_sold
	var/manifest_loss = 0
	var/manifest_profit = 0
	var/last_user_name = "name"
	var/last_trade_time = ""
	var/manifest_counter = 0

	var/next_bounty_print = 0

/obj/machinery/computer/trade_console/proc/write_manifest(datum/trader/trader, item_name, amount, price, user_selling, user_name)
	var/trade_string
	last_user_name = user_name
	last_trade_time = station_time_timestamp()
	if(user_selling)
		trade_string = "[amount] of [item_name] for [price] cr."
		write_log("[last_trade_time]: [user_name] sold [trade_string] to [trader.name] (new balance: [credits_held] cr.)")
		if(!makes_manifests)
			return
		LAZYINITLIST(manifest_sold)
		manifest_sold += trade_string
		manifest_profit += price
	else
		trade_string = "[amount] of [item_name] for [price] cr."
		write_log("[last_trade_time]: [user_name] bought [trade_string] from [trader.name] (new balance: [credits_held] cr.)")
		if(!makes_manifests)
			return
		LAZYINITLIST(manifest_purchased)
		manifest_purchased += trade_string
		manifest_loss += price

/obj/machinery/computer/trade_console/proc/print_manifest()
	if(!makes_manifests)
		return
	if(!manifest_sold && !manifest_purchased)
		return
	var/turf/my_turf = get_turf(src)
	playsound(my_turf, 'sound/items/poster_being_created.ogg', 20, 1)
	var/obj/item/paper/P = new /obj/item/paper(my_turf)
	manifest_counter++
	P.name = "trade manifest #[manifest_counter]"
	P.add_raw_text("<CENTER><B>TRADE MANIFEST #[manifest_counter] - [last_trade_time]</B></CENTER><BR>Transaction between [last_user_name] and [connected_trader.name] at [connected_trader.origin]")
	if(manifest_purchased)
		P.add_raw_text("<HR><b>BOUGHT ITEMS:</b><BR>")
		for(var/line in manifest_purchased)
			P.add_raw_text("[line]<BR>")
	if(manifest_sold)
		P.add_raw_text("<HR><b>SOLD ITEMS:</b><BR>")
		for(var/line in manifest_sold)
			P.add_raw_text("[line]<BR>")
	P.add_raw_text("<HR>Total gain: [manifest_profit]<BR>Total loss: [manifest_loss]<BR><b>TOTAL PROFIT: [manifest_profit - manifest_loss]</b>")
	P.update_icon()
	manifest_purchased = null
	manifest_sold = null
	manifest_loss = 0
	manifest_profit = 0

/obj/machinery/computer/trade_console/proc/write_log(log_entry)
	if(!makes_log)
		return
	LAZYINITLIST(trade_log)
	trade_log += log_entry

/obj/machinery/computer/trade_console/proc/connect_hub(datum/trade_hub/passed_hub)
	if(connected_hub)
		disconnect_hub()
	connected_hub = passed_hub
	connected_hub.connected_consoles += src

/obj/machinery/computer/trade_console/proc/connect_trader(datum/trader/passed_trader)
	if(connected_trader)
		disconnect_trader()
	connected_trader = passed_trader
	connected_trader.connected_consoles += src
	denied_hail_transmission = null

/obj/machinery/computer/trade_console/proc/disconnect_hub()
	if(!connected_hub)
		return
	if(connected_trader)
		disconnect_trader()
	connected_hub.connected_consoles -= src
	connected_hub = null
	denied_hail_transmission = null

/obj/machinery/computer/trade_console/proc/disconnect_trader()
	print_manifest()
	if(!connected_trader)
		return
	connected_trader.connected_consoles -= src
	connected_trader = null
	trader_screen_state = TRADER_SCREEN_NOTHING

/obj/machinery/computer/trade_console/proc/withdraw_credits(amount, mob/user)
	if(!amount || !credits_held)
		return
	if(amount > credits_held)
		amount = credits_held
	credits_held -= amount
	var/obj/item/holochip/holochip = new(loc, amount)
	if(user)
		to_chat(user, "<span class='notice'>You withdraw [amount] credits.</span>")
		user.put_in_hands(holochip)
		write_log("[station_time_timestamp()]: [user.name] withdrew [amount] cr. (new balance: [credits_held] cr.)")

/obj/machinery/computer/trade_console/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/holochip) || istype(I, /obj/item/stack/spacecash) || istype(I, /obj/item/coin))
		var/worth = I.get_item_credit_value()
		if(!worth)
			to_chat(user, "<span class='warning'>[I] doesn't seem to be worth anything!</span>")
		credits_held += worth
		to_chat(user, "<span class='notice'>You slot [I] into [src] and it reports a total of [credits_held] credits inserted.</span>")
		qdel(I)
		write_log("[station_time_timestamp()]: [user.name] deposited [worth] cr. (new balance: [credits_held] cr.)")
		return
	. = ..()

/obj/machinery/computer/trade_console/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TraderConsole", "Trade Console")
		ui.open()

/obj/machinery/computer/trade_console/ui_data()
	if(!linked_pad)
		try_link_pad()

	var/list/trade_hubs = list()
	var/list/traders = list()
	var/list/data = list(
		"pad_linked" = !!linked_pad,
		"trade_log" = trade_log,
		"connected_hub" = connected_hub ? list(
			"name" = connected_hub.name,
			"id" = connected_hub.id,
			"last_transmission" = last_transmission,
			"traders" = traders,
		) : null,
		"last_transmission" = last_transmission,
		"trade_hubs" = trade_hubs,
		"makes_manifests" = makes_manifests,
		"makes_log" = makes_log,
	)

	if(connected_hub)
		for(var/datum/trader/trader as anything in connected_hub.traders)
			traders += list(list(
				"name" = trader.name,
				"id" = trader.id,
			))

	if(connected_trader)
		var/list/trades = list()
		var/list/bounties = list()
		var/list/buying = list()
		var/list/deliveries = list()
		// Index is used cause it requires the least amount of refactoring, and I've refactored enough as it is, dammit.
		var/index = 1
		for(var/datum/sold_goods/sold_goods as anything in connected_trader.sold_goods)
			trades += list(list(
				"name" = sold_goods.name,
				"desc" = sold_goods.description,
				"index" = index,
				"cost" = sold_goods.cost,
				"amount" = sold_goods.current_stock,
			))
			index += 1
		index = 1
		for(var/datum/trader_bounty/bounty as anything in connected_trader.bounties)
			bounties += list(list(
				"name" = bounty.bounty_name,
				"desc" = bounty.bounty_text,
				"index" = index,
				"reward" = bounty.reward_cash,
			))
			index += 1
		index = 1
		for(var/datum/delivery_run/delivery_run as anything in connected_trader.deliveries)
			deliveries += list(list(
				"name" = delivery_run.name,
				"desc" = delivery_run.desc,
				"index" = index,
				"reward" = delivery_run.reward_cash,
			))
			index += 1
		index = 1
		for(var/datum/bought_goods/bought_goods as anything in connected_trader.bought_goods)
			buying += list(list(
				"name" = bought_goods.name,
				"index" = index,
				"cost" = bought_goods.cost,
				"amount" = bought_goods.stock,
			))
			index += 1
		data["connected_trader"] = list(
			"name" = connected_trader.name,
			"id" = connected_trader.id,
			"trades" = trades,
			"buying" = buying,
			"bounties" = bounties,
			"deliveries" = deliveries,
		)

	for(var/datum/trade_hub/trade_hub as anything in SStrading.get_available_trade_hubs(get_turf(src)))
		trade_hubs += list(list(
			"name" = trade_hub.name,
			"id" = trade_hub.id,
		))

	. = data

/obj/machinery/computer/trade_console/ui_act(action, list/params, datum/tgui/ui)
	..()
	. = TRUE // Just.. always update.
	switch(action)
		if("choose_hub")
			var/datum/trade_hub/trade_hub = SStrading.get_trade_hub_by_id(text2num(params["id"]))
			if(trade_hub)
				connect_hub(trade_hub)
				write_log("Connected to hub [trade_hub.name]")
				return
		if("choose_trader")
			var/datum/trader/trader = SStrading.get_trader_by_id(text2num(params["id"]))
			if(trader)
				connect_trader(trader)
				write_log("Connected to trader [trader.name]")
				return
		if("buy") // This code fucking hurts me. Don't look in requested_buy, don't look.
			if(!linked_pad)
				say("Please connect a trade tele-pad before conducting in trade.")
				return
			var/index = text2num(params["index"])
			if(connected_trader.sold_goods.len < index)
				return
			var/datum/sold_goods/goodie = connected_trader.sold_goods[index]
			last_transmission = connected_trader.requested_buy(ui.user, src, goodie)
		if("sell")
			if(!linked_pad)
				say("Please connect a trade tele-pad before conducting in trade.")
				return
			var/index = text2num(params["index"])
			if(connected_trader.bought_goods.len < index)
				return
			var/datum/bought_goods/goodie = connected_trader.bought_goods[index]
			last_transmission = connected_trader.requested_sell(ui.user, src, goodie)
		if("bounty")
			if(!linked_pad)
				say("Please connect a trade tele-pad before conducting in trade.")
				return
			var/index = text2num(params["index"])
			if(connected_trader.bounties.len < index)
				return
			var/datum/trader_bounty/goodie = connected_trader.bounties[index]
			last_transmission = connected_trader.requested_bounty_claim(ui.user, src, goodie)
		if("delivery")
			if(!linked_pad)
				say("Please connect a trade tele-pad before conducting in trade.")
				return
			var/index = text2num(params["index"])
			if(connected_trader.deliveries.len < index)
				return
			var/datum/delivery_run/goodie = connected_trader.deliveries[index]
			last_transmission = connected_trader.requested_delivery_take(ui.user, src, goodie)
		if("toggle_log")
			makes_log = !makes_log
			return
		if("toggle_manifest")
			makes_manifests = !makes_manifests
			return

/obj/machinery/computer/trade_console/Topic(href, href_list)
	. = ..()
	var/mob/living/living_user = usr
	if(!istype(living_user) || !living_user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		return
	switch(href_list["task"])
		if("trader_task")
			if(!connected_trader)
				return
			if(!linked_pad)
				say("Please connect a trade tele-pad before conducting in trade.")
				return
			switch(href_list["pref"])
				if("early_manifest_print")
					print_manifest()
				if("interact_with_delivery")
					if(!connected_trader.deliveries)
						return
					var/index = text2num(href_list["index"])
					if(connected_trader.deliveries.len < index)
						return
					var/datum/delivery_run/delivery = connected_trader.deliveries[index]
					switch(href_list["delivery_type"])
						if("take")
							last_transmission = connected_trader.requested_delivery_take(living_user, src, delivery)
				if("interact_with_bounty")
					if(!connected_trader.bounties)
						return
					var/index = text2num(href_list["index"])
					if(connected_trader.bounties.len < index)
						return
					var/datum/trader_bounty/bounty = connected_trader.bounties[index]
					switch(href_list["bounty_type"])
						if("print")
							if(world.time < next_bounty_print)
								return
							next_bounty_print = world.time + 5 SECONDS
							var/turf/my_turf = get_turf(src)
							playsound(my_turf, 'sound/items/poster_being_created.ogg', 20, 1)
							var/obj/item/paper/P = new /obj/item/paper(my_turf)
							P.name = "Bounty: [bounty.bounty_name]"
							P.default_raw_text = "<CENTER><B>[connected_trader.origin] - BOUNTY: [bounty.bounty_name]</B></CENTER><HR>"
							P.add_raw_text("[bounty.bounty_text]")
							P.add_raw_text("<BR>Requested items: [bounty.name] x[bounty.amount]")
							var/reward_line
							if(bounty.reward_cash)
								reward_line = "[bounty.reward_cash] cr."
							if(bounty.reward_item_path)
								if(reward_line)
									reward_line += " & [bounty.reward_item_name]"
								else
									reward_line = bounty.reward_item_name
							P.add_raw_text("<BR>Rewards: [reward_line]")
							P.update_icon()
						if("claim")
							last_transmission = connected_trader.requested_bounty_claim(living_user, src, bounty)
				if("interact_with_sold")
					var/index = text2num(href_list["index"])
					if(connected_trader.sold_goods.len < index)
						return
					var/datum/sold_goods/goodie = connected_trader.sold_goods[index]
					switch(href_list["sold_type"])
						if("buy")
							last_transmission = connected_trader.requested_buy(living_user, src, goodie)
						if("barter")
							last_transmission = connected_trader.requested_barter(living_user, src, goodie)
						if("haggle")
							var/proposed_value = input(living_user, "How much credits do you offer?", "Trade Console") as num|null
							if(!proposed_value || QDELETED(connected_trader) || QDELETED(goodie))
								return
							last_transmission = connected_trader.requested_buy(living_user, src, goodie, proposed_value)
				if("interact_with_bought")
					var/index = text2num(href_list["index"])
					if(connected_trader.bought_goods.len < index)
						return
					var/datum/bought_goods/goodie = connected_trader.bought_goods[index]
					switch(href_list["bought_type"])
						if("sell")
							last_transmission = connected_trader.requested_sell(living_user, src, goodie)
						if("haggle")
							var/proposed_value = input(living_user, "How much credits do you demand?", "Trade Console") as num|null
							if(!proposed_value || QDELETED(connected_trader) || QDELETED(goodie))
								return
							last_transmission = connected_trader.requested_sell(living_user, src, goodie, proposed_value)
				if("button_show_goods")
					if(connected_trader.trade_flags & TRADER_SELLS_GOODS)
						trader_screen_state = TRADER_SCREEN_SOLD_GOODS
						last_transmission = connected_trader.get_response("trade_show_goods", "This is what I've got to offer!", living_user)
					else
						last_transmission = connected_trader.get_response("trade_no_sell_goods", "I don't sell any goods.", living_user)

				if("button_show_purchasables")
					if(connected_trader.trade_flags & TRADER_BUYS_GOODS)
						trader_screen_state = TRADER_SCREEN_BOUGHT_GOODS
						last_transmission = connected_trader.get_response("what_want", "Hm, I want.. those..", living_user)
					else
						last_transmission = connected_trader.get_response("trade_no_goods", "I don't deal in goods!", living_user)

				if("button_show_bounties")
					trader_screen_state = TRADER_SCREEN_BOUNTIES

				if("button_show_deliveries")
					trader_screen_state = TRADER_SCREEN_DELIVERIES

				if("button_compliment")
					if(prob(50))
						last_transmission = connected_trader.get_response("compliment_deny", "Ehhh.. thanks?", living_user)
					else
						last_transmission = connected_trader.get_response("compliment_accept", "Thank you!", living_user)

				if("button_insult")
					if(prob(50))
						last_transmission = connected_trader.get_response("insult_bad", "What? I thought we were cool!", living_user)
					else
						last_transmission = connected_trader.get_response("insult_good", "Right back at you asshole!", living_user)
				if("button_appraise")
					if(connected_trader.trade_flags & TRADER_BUYS_GOODS)
						last_transmission = connected_trader.get_appraisal(living_user, src)
					else
						last_transmission = connected_trader.get_response("trade_no_goods", "I don't deal in goods!", living_user)

				if("button_sell_item")
					if(!(connected_trader.trade_flags & TRADER_BUYS_GOODS))
						last_transmission = connected_trader.get_response("trade_no_goods", "I don't deal in goods!", living_user)
					else if (!(connected_trader.trade_flags & TRADER_MONEY))
						last_transmission = connected_trader.get_response("doesnt_use_cash", "I don't deal in cash!", living_user)
					else
						last_transmission = connected_trader.sell_all_on_pad(living_user, src)
			if(!connected_trader.get_hailed(living_user, src))
				denied_hail_transmission = last_transmission
				disconnect_trader()
		if("hub_task")
			if(!connected_hub)
				return
			switch(href_list["pref"])
				if("disconnect_trader")
					disconnect_trader()
				if("hail_merchant")
					var/id = text2num(href_list["id"])
					var/datum/trader/trader = SStrading.get_trader_by_id(id)
					if(!trader)
						return
					var/is_hail_success = trader.get_hailed(living_user, src)
					var/hail_msg = trader.hail_msg(is_hail_success, living_user)
					if(is_hail_success)
						connect_trader(trader)
						last_transmission = hail_msg
					else
						denied_hail_transmission = hail_msg

		if("main_task")
			switch(href_list["pref"])
				if("toggle_logging")
					makes_log = !makes_log
				if("toggle_manifest")
					makes_manifests = !makes_manifests
				if("view_log")
					viewed_log = !viewed_log
				if("purge_log")
					trade_log = null
				if("choose_hub")
					var/id = text2num(href_list["id"])
					var/trade_hub = SStrading.get_trade_hub_by_id(id)
					if(trade_hub)
						connect_hub(trade_hub)
				if("withdraw_money")
					var/amount = input(living_user, "How much credits would you like to withdraw?", "Trade Console") as num|null
					if(amount && amount > 0)
						withdraw_credits(amount, living_user)
				if("disconnect_hub")
					disconnect_hub()
	ui_interact(living_user)

/obj/machinery/computer/trade_console/proc/try_link_pad()
	if(linked_pad)
		return
	for(var/direction in GLOB.cardinals)
		linked_pad = locate(/obj/machinery/trade_pad, get_step(src, direction))
		if(linked_pad && !linked_pad.linked_console)
			linked_pad.linked_console = src
			break
	return linked_pad

/obj/machinery/computer/trade_console/proc/unlink_pad()
	linked_pad.linked_console = null
	linked_pad = null

/obj/machinery/computer/trade_console/Destroy()
	if(linked_pad)
		unlink_pad()
	if(!credits_held)
		return ..()
	new /obj/item/holochip(loc, credits_held)
	credits_held = 0
	return ..()

/obj/item/circuitboard/computer/trade_console
	name = "Trade Console (Computer Board)"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/computer/trade_console
/obj/machinery/trade_pad
	name = "trade tele-pad"
	desc = "It's the hub of a teleporting machine."
	icon = 'icons/obj/machines/teleporter.dmi'
	icon_state = "tele0"
	base_icon_state = "tele"
	use_power = IDLE_POWER_USE
	idle_power_usage = 10
	active_power_usage = 2000
	circuit = /obj/item/circuitboard/machine/trade_pad
	density = FALSE
	var/obj/machinery/computer/trade_console/linked_console
	var/list/ignore_typecache = list(
									/obj/machinery/trade_pad = TRUE,
									/obj/machinery/navbeacon  = TRUE)
	var/list/types_of_to_add_to_ignore = list(/obj/structure/cable, /obj/structure/disposalpipe, /obj/machinery/atmospherics/pipe, /obj/effect)

/obj/machinery/trade_pad/proc/get_valid_items()
	var/turf/my_turf = get_turf(src)
	var/list/valid_items = my_turf.contents.Copy()
	for(var/item in valid_items)
		var/atom/movable/AM = item
		if(ignore_typecache[AM.type])
			valid_items -= item
	return valid_items

/obj/machinery/trade_pad/proc/do_teleport_effect()
	do_sparks(3, TRUE, src)

/obj/machinery/trade_pad/Initialize()
	. = ..()
	for(var/type in types_of_to_add_to_ignore)
		for(var/typeof in typesof(type))
			ignore_typecache[typeof] = TRUE
	types_of_to_add_to_ignore = null

/obj/machinery/trade_pad/Destroy()
	if(linked_console)
		linked_console.unlink_pad()
	ignore_typecache = null
	return ..()

/obj/item/circuitboard/machine/trade_pad
	name = "Trade Tele-Pad (Machine Board)"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/trade_pad
	req_components = list(
		/obj/item/stack/ore/bluespace_crystal = 2,
		/obj/item/stock_parts/subspace/ansible = 1,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/scanning_module = 2)
	def_components = list(/obj/item/stack/ore/bluespace_crystal = /obj/item/stack/ore/bluespace_crystal/artificial)

// This was meant to be simple, dammit.

#define SHUTTLE_BLOCKADE_WARNING "Shuttle movement impossible. See console for details."
#define SHUTTLE_SAFETY_WARNING "For safety and ethical reasons, the automated supply shuttle cannot transport \
		human remains, classified nuclear weaponry, mail, undelivered departmental order crates, enemy bombs, \
		homing beacons, unstable eigenstates, fax machines, or machinery housing any form of artificial intelligence."

/obj/machinery/computer/trade_console
	name = "trade console"
	icon_screen = "supply"
	desc = "Used for communication between the trade networks and for conducting trades. This one can't send the shuttle."
	circuit = /obj/item/circuitboard/computer/trade_console
	light_color = COLOR_BRIGHT_ORANGE
	manufacturer = MANUFACTURER_ARTEA_LOGISTICS
	var/obj/machinery/trade_pad/linked_pad

	var/last_transmission = ""
	var/denied_hail_transmission

	var/datum/trade_hub/connected_hub
	var/datum/trader/connected_trader

	var/viewed_log = FALSE
	var/makes_log = TRUE
	var/makes_manifests = TRUE

	// Mostly for admins.
	var/list/trade_log

	var/list/manifest_purchased
	var/manifest_loss = 0
	var/last_user_name = "name"
	var/last_trade_time = ""
	var/manifest_counter = 0

	var/next_bounty_print = 0

	var/obj/item/card/id/inserted_id

	///The name of the shuttle template being used as the cargo shuttle. 'cargo' is default and contains critical code. Don't change this unless you know what you're doing.
	var/cargo_shuttle = "cargo"
	///The docking port called when returning to the station.
	var/docking_home = "cargo_home"
	///The docking port called when leaving the station.
	var/docking_away = "cargo_away"
	///If this console can loan the cargo shuttle. Set to false to disable.
	var/stationcargo = TRUE

	var/list/loaded_coupons = list()

	var/can_send_shuttle = FALSE

/obj/machinery/computer/trade_console/cargo
	name = "cargo trade console"
	desc = "Used for communication between the trade networks and for conducting trades."
	can_send_shuttle = TRUE

/obj/machinery/computer/trade_console/proc/write_manifest(datum/trader/trader, item_name, amount, price, user_name)
	var/trade_string
	last_user_name = user_name
	if(price)
		trade_string = "[amount] of [item_name] for [price] cr"
		write_log("[user_name] bought [trade_string] from [trader.name] (new balance on [inserted_id.registered_account.account_holder]: [inserted_id.registered_account.account_balance] cr.)")
	else
		trade_string = "[amount] of [item_name]"
		trade_string = "[user_name] gained [trade_string] from [trader.name]"
	if(!makes_manifests)
		return
	LAZYINITLIST(manifest_purchased)
	manifest_purchased += trade_string + "."
	manifest_loss += price

/obj/machinery/computer/trade_console/proc/print_manifest()
	if(!makes_manifests)
		QDEL_NULL(manifest_purchased)
		return
	if(!manifest_purchased)
		return
	var/turf/my_turf = get_turf(src)
	playsound(my_turf, 'sound/items/poster_being_created.ogg', 20, 1)
	var/obj/item/paper/P = new /obj/item/paper(my_turf)
	manifest_counter++
	P.name = "trade manifest #[manifest_counter]"
	P.add_raw_text("<CENTER><B>TRADE MANIFEST #[manifest_counter] - [last_trade_time]</B></CENTER><BR>Transaction between [last_user_name] and [connected_trader.name] at [connected_trader.origin]")
	P.add_raw_text("<HR><b>BOUGHT ITEMS:</b><BR>")
	for(var/line in manifest_purchased)
		P.add_raw_text("[line]<BR>")
	P.add_raw_text("<HR>Total cost: [manifest_loss]")
	P.update_icon()
	manifest_purchased = null
	manifest_loss = 0

/obj/machinery/computer/trade_console/proc/write_log(log_entry)
	LAZYADD(trade_log, log_entry)
	if(!makes_log)
		return
	var/datum/signal/subspace/messaging/trade_msg/message = new(src, list(
		"timestamp" = station_time_timestamp(),
		"message" = log_entry,
	))
	message.send_to_receivers()

/obj/machinery/computer/trade_console/proc/connect_hub(datum/trade_hub/passed_hub)
	if(connected_hub)
		disconnect_hub()
	connected_hub = passed_hub
	connected_hub.connected_consoles += src

/obj/machinery/computer/trade_console/proc/connect_trader(datum/trader/passed_trader, mob/user)
	if(connected_trader)
		disconnect_trader()
	connected_trader = passed_trader
	connected_trader.connected_consoles += src
	last_transmission = passed_trader.get_response("hail", "Welcome to ORIGIN!", user)
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

/obj/machinery/computer/trade_console/proc/insert_id(obj/item/card/id/id, mob/user)
	if(!istype(id))
		return
	if(inserted_id)
		if(user)
			balloon_alert(user, "ID already inside!")
		return

	id.forceMove(src)
	inserted_id = id
	playsound(src, 'sound/machines/id_insert.ogg', 50, FALSE)

/obj/machinery/computer/trade_console/proc/remove_id(mob/user)
	if(!inserted_id)
		if(user)
			balloon_alert(user, "no ID!")
		return

	if(user)
		visible_message(span_info("[user] takes [inserted_id] from \the [src]."))
		try_put_in_hand(inserted_id, user)
		inserted_id = null
		playsound(src, 'sound/machines/id_eject.ogg', 50, FALSE)
		return

	inserted_id.forceMove(get_turf(src))
	inserted_id = null
	playsound(src, 'sound/machines/id_eject.ogg', 50, FALSE)

/obj/machinery/computer/trade_console/attackby(obj/item/item, mob/user, params)
	if(isidcard(item))
		insert_id(item)
		return TRUE
	. = ..()

/obj/machinery/computer/trade_console/CtrlClick(mob/user)
	. = ..()
	remove_id(user)
	return TRUE

/obj/machinery/computer/trade_console/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TradeConsole", "Trade Console")
		ui.open()

/obj/machinery/computer/trade_console/ui_data()
	var/list/trade_hubs = list()
	var/list/traders = list()
	var/list/data = list(
		"connected_hub" = connected_hub ? list(
			"name" = connected_hub.name,
			"id" = connected_hub.id,
			"last_transmission" = last_transmission,
			"traders" = traders,
		) : null,
		"last_transmission" = last_transmission,
		"trade_hubs" = trade_hubs,
		"makes_manifests" = makes_manifests,
		"rank" = istype(inserted_id?.registered_account, /datum/bank_account/department) ? "Department Account" : inserted_id?.registered_account?.account_job?.title,
		"wallet_name" = inserted_id?.registered_account?.account_holder,
		"credits" = inserted_id?.registered_account?.account_balance,
		"shuttle_sendable" = can_send_shuttle,
		"shuttle_location" = SSshuttle.supply.get_status_text_tgui(),
		"shuttle_away" = docking_away,
		"shuttle_home" = docking_home,
		"shuttle_loanable" = !!SSshuttle.shuttle_loan,
		"shuttle_loan_dispatched" = SSshuttle.shuttle_loan && SSshuttle.shuttle_loan.dispatched,
		"shuttle_blockaded" = !!SSshuttle.trade_blockade.len || !!SSshuttle.supply_blocked,
		"shuttle_eta" = time2text(world.realtime + SSshuttle.supply.timeLeft(), "mm:ss"),
		"grocery_amount" = SStrading.chef_groceries.len,
	)

	var/message = "Remember to stamp and send back the supply manifests."
	if(SStrading.trade_message)
		message = SStrading.trade_message
	if(SSshuttle.supply_blocked)
		message = SHUTTLE_BLOCKADE_WARNING
	data["shuttle_message"] = message
	var/list/cart = list()
	data["cart"] = cart
	for(var/datum/supply_order/order in SStrading.shopping_list)
		cart += list(list(
			"name" = order.pack.name,
			"desc" = order.pack.desc || order.pack.name,
			"cost" = order.pack.get_cost(),
			"id" = order.id,
			"orderer" = order.orderer,
			"paid" = !isnull(order.paying_account), //paid by requester
			"dep_order" = !!order.department_destination
		))

	if(connected_hub)
		for(var/datum/trader/trader as anything in connected_hub.traders)
			traders += list(list(
				"name" = trader.name,
				"id" = trader.id,
			))

	if(connected_trader)
		var/list/trades = list()
		var/list/bounties = list()
		var/list/deliveries = list()
		// Index is used cause it requires the least amount of refactoring, and I've refactored enough as it is, dammit.
		var/index = 1
		for(var/sold_good_id as anything in connected_trader.sold_packs)
			var/datum/supply_pack/sold_goods = SStrading.supply_packs["[sold_good_id]"]

			var/access_desc
			var/end_text
			var/list/access_list
			if(length(sold_goods.access))
				access_desc += "Requires "
				end_text = "and"
				access_list = sold_goods.access
			else if (length(sold_goods.access_any))
				access_desc = "Requires "
				end_text = "or"
				access_list = sold_goods.access_any

			if(access_desc && length(access_list)) // Just break the desc instead of breaking the entire UI.
				if(istext(access_list))
					access_desc += "[SSid_access.desc_by_access[access_list]] access to open."
				else if(access_list.len == 1)
					access_desc += "[SSid_access.desc_by_access[access_list[1]]] access to open."
				else
					var/list/access_names = list()
					for(var/access in access_list)
						access_names += SSid_access.desc_by_access[access]

					var/last = access_names.Copy(access_names.len)[1]
					access_names.Cut(access_names.len)
					access_desc += "[access_names.Join(", ")] [end_text] [last] [ end_text == "or" ? "access" : "accesses" ] to open."

			trades += list(list(
				"name" = sold_goods.name,
				"desc" = sold_goods.desc,
				"id" = sold_goods.id,
				"cost" = sold_goods.get_cost(),
				"amount" = sold_goods.stock["[connected_trader.id]"],
				"access_desc" = access_desc,
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
		data["connected_trader"] = list(
			"name" = connected_trader.name,
			"id" = connected_trader.id,
			"trades" = trades,
			"bounties" = bounties,
			"deliveries" = deliveries,
			"color" = connected_trader.speech_color,
		)

	for(var/datum/trade_hub/trade_hub as anything in SStrading.get_available_trade_hubs(get_turf(src)))
		trade_hubs += list(list(
			"name" = trade_hub.name,
			"id" = trade_hub.id,
		))

	. = data

/obj/machinery/computer/trade_console/ui_static_data(mob/user)
	var/list/data = list()
	data["static_galactic_imports"] = list()
	for(var/datum/supply_pack/galactic_imports/pack as anything in SStrading.group_to_supplies[TRADER_GROUP_GALACTIC_IMPORTS])
		// I'll eventually make contraband work again.
		if((pack.hidden && !(obj_flags & EMAGGED)) || pack.contraband || (pack.special && !pack.special_enabled))
			continue
		if(!data["static_galactic_imports"][pack.category])
			data["static_galactic_imports"][pack.category] = list(
				"name" = pack.category,
				"packs" = list(),
			)
		data["static_galactic_imports"][pack.category]["packs"] += list(list(
			"name" = pack.name,
			"cost" = pack.get_cost(),
			"id" = pack.id,
			"desc" = pack.desc || pack.name, // If there is a description, use it. Otherwise use the pack's name.
			"goody" = pack.goody,
			"access" = pack.access,
		))
	return data

/obj/machinery/computer/trade_console/ui_act(action, list/params, datum/tgui/ui)
	..()
	. = TRUE // Just.. always update.
	if(!ui.user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK, TRUE))
		return TRUE
	switch(action)
		if("eject_id")
			if(inserted_id)
				remove_id(ui.user)
				print_manifest()
				return
			var/item = ui.user.get_active_held_item()
			insert_id(isidcard(item) ? item : null, ui.user)
		if("choose_hub")
			var/datum/trade_hub/trade_hub = SStrading.get_trade_hub_by_id(text2num(params["id"]))
			if(trade_hub)
				connect_hub(trade_hub)
				write_log("Connected to hub [trade_hub.name]")
		if("disconnect_hub")
			disconnect_hub()
		if("choose_trader")
			var/datum/trader/trader = SStrading.get_trader_by_id(text2num(params["id"]))
			if(trader)
				connect_trader(trader, ui.user)
				write_log("Connected to trader [trader.name]")
		if("disconnect_trader")
			disconnect_trader()
		if("buy")
			if(!inserted_id)
				say("No ID detected.")
				return
			if(!inserted_id.registered_account)
				say("No bank account detected.")
				return

			var/pack_id = params["id"]
			var/datum/supply_pack/goodie = SStrading.supply_packs["[pack_id]"]
			var/is_import = islist(goodie.group) ? (TRADER_GROUP_GALACTIC_IMPORTS in goodie.group) : goodie.group == TRADER_GROUP_GALACTIC_IMPORTS

			if(!(pack_id in connected_trader?.sold_packs) && !is_import)
				say("Unknown product code.")
				return

			if(!is_import)
				last_transmission = connected_trader.requested_buy(ui.user, src, goodie)
				return

			var/datum/supply_order/order = new /datum/supply_order(goodie, inserted_id.registered_account.account_holder, inserted_id.assignment, ui.user.ckey, null, inserted_id.registered_account)
			if(inserted_id.registered_account.adjust_money(-order.cost, "Galactic Import: Purchase of [goodie.name]"))
				SStrading.shopping_list += order
				say("Import requested.")
			else
				say("Not enough credits. Import rejected.")
				qdel(order)
		if("bounty")
			if(!inserted_id)
				say("No ID detected.")
				return
			if(!istype(!console.inserted_id?.registered_account, /datum/bank_account/department))
				say("This card is not a department card! Bounties are ineligable for private accounts!")
				return
			var/index = text2num(params["index"])
			if(connected_trader.bounties.len < index)
				say("Invalid bounty!")
				return

			var/datum/trader_bounty/goodie = connected_trader.bounties[index]
			last_transmission = connected_trader.requested_bounty_claim(ui.user, src, goodie)
		if("delivery")
			var/index = text2num(params["index"])
			if(connected_trader.deliveries.len < index)
				return
			var/datum/delivery_run/goodie = connected_trader.deliveries[index]
			last_transmission = connected_trader.requested_delivery_take(ui.user, src, goodie)
		if("print_manifest")
			print_manifest() // This auto-prints when you change trader.
		if("send_shuttle")
			if(!SSshuttle.supply.canMove())
				say(SHUTTLE_SAFETY_WARNING)
				return
			if(SSshuttle.supply_blocked)
				say(SHUTTLE_BLOCKADE_WARNING)
				return
			if(SSshuttle.supply.getDockedId() == docking_home)
				// SSshuttle.supply.export_categories = EXPORT_CARGO // ARTEA TODO: (maybe) readd emag/contraband-specific exports.
				SSshuttle.moveShuttle(cargo_shuttle, docking_away, TRUE)
				say("The supply shuttle is departing.")
				investigate_log("[key_name(usr)] sent the supply shuttle away.", INVESTIGATE_CARGO)
		if("loan_shuttle")
			if(!SSshuttle.shuttle_loan)
				return
			if(SSshuttle.supply_blocked)
				say(SHUTTLE_BLOCKADE_WARNING)
				return
			else if(SSshuttle.supply.mode != SHUTTLE_IDLE)
				return
			else if(SSshuttle.supply.getDockedId() != docking_home)
				return
			else if(stationcargo != TRUE)
				return
			else
				SSshuttle.shuttle_loan.loan_shuttle()
				say("The supply shuttle has been loaned to CentCom.")
				investigate_log("[key_name(usr)] accepted a shuttle loan event.", INVESTIGATE_CARGO)
				usr.log_message("accepted a shuttle loan event.", LOG_GAME)
		if("remove")
			if(!inserted_id)
				say("No ID detected.")
				return
			var/id = params["id"]
			for(var/datum/supply_order/SO in SStrading.shopping_list)
				if(SO.id != id)
					continue
				if(SO.pack.cant_be_removed)
					say("This is an order that can't be cancelled.")
					return
				if(!can_send_shuttle && SO.paying_account.account_id != inserted_id.registered_account?.account_id)
					say("Only the orderer may cancel their order.")
					return
				if(SO.applied_coupon)
					say("Coupon refunded.")
					SO.applied_coupon.forceMove(get_turf(src))
				SStrading.shopping_list -= SO
				if(SO.paying_account)
					SO.paying_account.adjust_money(SO.cost, "Cargo: Refund of [SO.pack.name]")
				qdel(SO)
				break
		if("clear")
			for(var/datum/supply_order/cancelled_order in SStrading.shopping_list)
				if(cancelled_order.department_destination || cancelled_order.pack.cant_be_removed)
					continue //don't cancel other department's orders
				SStrading.shopping_list -= cancelled_order
		if("unload_coupons")
			for(var/obj/coupon in loaded_coupons)
				coupon.forceMove(get_turf(src))
		if("get_estimate")
			if(!can_send_shuttle)
				say("This console has no shuttle access.")
				return
			SSshuttle.supply.sell()
	if(.)
		post_signal(cargo_shuttle)

/obj/machinery/computer/trade_console/emag_act(mob/user, obj/item/card/emag/emag_card)
	. = ..()
	if(obj_flags & EMAGGED)
		return

	obj_flags |= EMAGGED
	do_sparks(1, FALSE, src)
	makes_log = FALSE
	update_static_data_for_all_viewers()
	balloon_alert(user, "disabled logging")

/obj/machinery/computer/trade_console/Destroy()
	if(!inserted_id)
		return ..()
	inserted_id.forceMove(get_turf(src))
	inserted_id = null
	return ..()

/obj/machinery/computer/trade_console/proc/post_signal(command)

	var/datum/radio_frequency/frequency = SSradio.return_frequency(FREQ_STATUS_DISPLAYS)

	if(!frequency)
		return

	var/datum/signal/status_signal = new(list("command" = command))
	frequency.post_signal(src, status_signal)

/obj/item/circuitboard/computer/trade_console
	name = "Trade Console (Computer Board)"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/computer/trade_console
	manufacturer = MANUFACTURER_ARTEA_LOGISTICS

/obj/item/circuitboard/computer/trade_console/cargo
	name = "Cargo Trade Console (Computer Board)"
	build_path = /obj/machinery/computer/trade_console/cargo

#undef SHUTTLE_BLOCKADE_WARNING

/obj/machinery/computer/trade_console
	name = "trade console"
	icon_screen = "supply"
	desc = "Used for communication between the trade networks and for conducting trades."
	circuit = /obj/item/circuitboard/computer/trade_console
	light_color = COLOR_BRIGHT_ORANGE
	var/obj/machinery/trade_pad/linked_pad

	var/last_transmission = ""
	var/denied_hail_transmission

	var/datum/trade_hub/connected_hub
	var/datum/trader/connected_trader
	var/trader_screen_state = TRADER_SCREEN_NOTHING

	var/viewed_log = FALSE
	var/makes_log = TRUE
	var/makes_manifests = TRUE

	// Mostly for admins.
	var/list/trade_log

	var/list/manifest_purchased
	var/list/manifest_sold
	var/manifest_loss = 0
	var/manifest_profit = 0
	var/last_user_name = "name"
	var/last_trade_time = ""
	var/manifest_counter = 0

	var/next_bounty_print = 0

	var/obj/item/card/id/inserted_id

/obj/machinery/computer/trade_console/proc/write_manifest(datum/trader/trader, item_name, amount, price, user_selling, user_name)
	var/trade_string
	last_user_name = user_name
	if(user_selling)
		trade_string = "[amount] of [item_name] for [price] cr."
		write_log("[user_name] sold [trade_string] to [trader.name] (new balance on [inserted_id.registered_account.account_holder]: [inserted_id.registered_account.account_balance] cr.)")
		if(!makes_manifests)
			return
		LAZYINITLIST(manifest_sold)
		manifest_sold += trade_string
		manifest_profit += price
	else
		trade_string = "[amount] of [item_name] for [price] cr."
		write_log("[user_name] bought [trade_string] from [trader.name] (new balance on [inserted_id.registered_account.account_holder]: [inserted_id.registered_account.account_balance] cr.)")
		if(!makes_manifests)
			return
		LAZYINITLIST(manifest_purchased)
		manifest_purchased += trade_string
		manifest_loss += price

/obj/machinery/computer/trade_console/proc/print_manifest()
	if(!makes_manifests)
		QDEL_NULL(manifest_sold)
		QDEL_NULL(manifest_purchased)
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
	trader_screen_state = TRADER_SCREEN_NOTHING

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
		ui = new(user, src, "TraderConsole", "Trade Console")
		ui.open()

/obj/machinery/computer/trade_console/ui_data()
	if(!linked_pad)
		try_link_pad()

	var/list/trade_hubs = list()
	var/list/traders = list()
	var/list/data = list(
		"pad_linked" = !!linked_pad,
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
		data["connected_trader"] = list(
			"name" = connected_trader.name,
			"id" = connected_trader.id,
			"trades" = trades,
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
	if(!ui.user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK, TRUE))
		return FALSE
	switch(action)
		if("eject_id")
			if(inserted_id)
				remove_id(ui.user)
				return
			var/item = ui.user.get_active_held_item()
			insert_id(isidcard(item) ? item : null, ui.user)
		if("choose_hub")
			var/datum/trade_hub/trade_hub = SStrading.get_trade_hub_by_id(text2num(params["id"]))
			if(trade_hub)
				connect_hub(trade_hub)
				write_log("Connected to hub [trade_hub.name]")
		if("choose_trader")
			var/datum/trader/trader = SStrading.get_trader_by_id(text2num(params["id"]))
			if(trader)
				connect_trader(trader, ui.user)
				write_log("Connected to trader [trader.name]")
		if("buy") // This code fucking hurts me. Don't look in requested_buy, don't look.
			if(!inserted_id)
				say("No ID detected.")
				return
			if(!linked_pad)
				say("Please connect a trade tele-pad before conducting in trade.")
				return
			var/index = text2num(params["index"])
			if(connected_trader.sold_goods.len < index)
				return
			var/datum/sold_goods/goodie = connected_trader.sold_goods[index]
			last_transmission = connected_trader.requested_buy(ui.user, src, goodie)
		if("bounty")
			if(!inserted_id)
				say("No ID detected.")
				return
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
		if("print_manifest")
			print_manifest()
		if("toggle_manifest")
			makes_manifests = !makes_manifests

/obj/machinery/computer/trade_console/emag_act(mob/user, obj/item/card/emag/emag_card)
	. = ..()
	if(obj_flags & EMAGGED)
		return

	obj_flags |= EMAGGED
	do_sparks(1, FALSE, src)
	makes_log = FALSE
	balloon_alert(user, "disabled logging")

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
	if(!inserted_id)
		return ..()
	inserted_id.forceMove(get_turf(src))
	inserted_id = null
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

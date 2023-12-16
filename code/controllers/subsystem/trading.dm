SUBSYSTEM_DEF(trading)
	name = "Trading"
	init_order = INIT_ORDER_TRADING
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	wait = 5 MINUTES
	///List of all trade hubs
	var/list/trade_hubs = list()
	///List of all traders
	var/list/all_traders = list()
	///A dedicated global trade hub
	var/datum/trade_hub/central_trade_hub

	var/list/trader_types_spawned = list()

	var/next_trade_hub_id = 0

	var/next_trader_id = 0

	var/list/delivery_runs = list()

	/**
	 * Supply shuttle stuff
	 * Moved to SSTrading cause this subsystem handles almost everything related to buying and selling things now. Let's debloat SSShuttle a little.
	 */

	/// Order number given to next order.
	var/order_number = 1
	/// Number of trade-points we have (basically money).
	var/points = 5000
	/// Remarks from CentCom on how well you checked the last order.
	var/trade_message = ""
	/// Typepaths for unusual plants we've already sent CentCom, associated with their potencies.
	var/list/discovered_plants = list()

	/// All of the possible supply packs that can be purchased by cargo.
	var/list/supply_packs = list()

	/// Assoc list of supply pack group to their packs.
	var/list/group_to_supplies = list()

	/// Stuff the chef ordered. Will be added onto the shuttle, and cargo gets no say.
	var/list/chef_groceries = list()

	/// History of successful orders in chronological order. Admin-view only at the moment, though the telecomms message server has a much more simple version of this.
	var/list/order_history = list()

	/// Queued supply packs to be purchased.
	var/list/shopping_list = list()

	/// An assoc list of traders to the amount of orders that are on the shopping list from them.
	/// This is *not* precise. Don't use it for anything critical to economy.
	/// This is a bit fucked, but it simplifies code and removes the need to scan lists.
	/// Managed by trade consoles.
	var/list/traders_to_visit = list()

/datum/controller/subsystem/trading/proc/get_trade_hub_by_id(id)
	RETURN_TYPE(/datum/trade_hub)
	return trade_hubs["[id]"]

/datum/controller/subsystem/trading/proc/get_trader_by_id(id)
	RETURN_TYPE(/datum/trader)
	return all_traders["[id]"]

/datum/controller/subsystem/trading/proc/get_next_trade_hub_id()
	next_trade_hub_id++
	return next_trade_hub_id

/datum/controller/subsystem/trading/proc/get_next_trader_id()
	next_trader_id++
	return next_trader_id

//Gets all available trade hubs from a turf position
/datum/controller/subsystem/trading/proc/get_available_trade_hubs(turf/position)
	var/list/passed_trade_hubs = list()
	if(central_trade_hub)
		passed_trade_hubs += central_trade_hub
	var/datum/overmap_object/overmap_object = GetHousingOvermapObject(position)
	if(overmap_object)
		var/list/overmap_objects = overmap_object.current_system.GetObjectsInRadius(overmap_object.x,overmap_object.y,0)
		for(var/i in overmap_objects)
			var/datum/overmap_object/iterated_object = i
			if(istype(iterated_object, /datum/overmap_object/trade_hub))
				var/datum/overmap_object/trade_hub/th_obj = iterated_object
				passed_trade_hubs += th_obj.hub
	return passed_trade_hubs

/datum/controller/subsystem/trading/Initialize(timeofday)
	order_number = rand(1, 9000)

	var/list/pack_processing = subtypesof(/datum/supply_pack)
	while(length(pack_processing))
		var/datum/supply_pack/pack = pack_processing[length(pack_processing)]
		pack_processing.len--
		if(ispath(pack, /datum/supply_pack))
			pack = new pack

		var/list/generated_packs = pack.generate_supply_packs()
		if(generated_packs)
			pack_processing += generated_packs

		if(!pack.contains)
			continue

		supply_packs[pack.id] = pack
		if(!pack.group) // Don't throw any warnings or errors. Probably an admin-only or template pack.
			continue
		if(islist(pack.group))
			for(var/group in pack.group)
				LAZYADD(group_to_supplies[group], pack)
			return
		LAZYADD(group_to_supplies[pack.group], pack)

	var/datum/map_config/config = SSmapping.config
	// Create central trade hub
	if(config.central_trading_hub_type)
		central_trade_hub = new config.central_trading_hub_type()
	// Localised trade hubs are handled in overmap. Please don't try to make them here, they rely on overmap existing.
	return SS_INIT_SUCCESS

/datum/controller/subsystem/trading/fire(resumed = FALSE)
	for(var/i in trade_hubs)
		var/datum/trade_hub/hub = trade_hubs[i]
		hub.Tick()

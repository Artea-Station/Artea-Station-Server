GLOBAL_LIST_INIT(blacklisted_cargo_types, typecacheof(list(
		/mob/living,
		/obj/structure/blob,
		/obj/effect/rune,
		/obj/structure/spider/spiderling,
		/obj/item/disk/nuclear,
		/obj/machinery/nuclearbomb,
		/obj/item/beacon,
		/obj/narsie,
		/obj/tear_in_reality,
		/obj/machinery/teleport/station,
		/obj/machinery/teleport/hub,
		/obj/machinery/quantumpad,
		/obj/effect/mob_spawn,
		/obj/effect/hierophant,
		/obj/structure/receiving_pad,
		/obj/item/warp_cube,
		/obj/machinery/rnd/production, //print tracking beacons, send shuttle
		/obj/machinery/autolathe, //same
		/obj/projectile/beam/wormhole,
		/obj/effect/portal,
		/obj/item/shared_storage,
		/obj/structure/extraction_point,
		/obj/machinery/syndicatebomb,
		/obj/item/hilbertshotel,
		/obj/item/swapper,
		/obj/docking_port,
		/obj/machinery/launchpad,
		/obj/machinery/disposal,
		/obj/structure/disposalpipe,
		/obj/item/mail,
		/obj/machinery/camera,
		/obj/item/gps,
		/obj/structure/checkoutmachine,
		/obj/machinery/fax,
		/obj/item/delivery_cargo,
	)))

/// How many goody orders we can fit in a lockbox before we upgrade to a crate
#define GOODY_FREE_SHIPPING_MAX 5
/// How much to charge oversized goody orders
#define CRATE_TAX 700

/obj/docking_port/mobile/supply
	name = "supply shuttle"
	shuttle_id = "cargo"
	callTime = 20 SECONDS

	dir = WEST
	port_direction = EAST
	movement_force = list("KNOCKDOWN" = 0, "THROW" = 0)

	/// Export categories for this run, this is set by console sending the shuttle.
	var/export_categories = EXPORT_CARGO
	/// How many traders did we trade with last time we left home?
	var/last_trade_trader_amount = 0

/obj/docking_port/mobile/supply/register()
	. = ..()
	SSshuttle.supply = src

/obj/docking_port/mobile/supply/canMove()
	if(is_station_level(z))
		return check_blacklist(shuttle_areas)
	return ..()

/obj/docking_port/mobile/supply/proc/check_blacklist(areaInstances)
	for(var/place in areaInstances)
		var/area/shuttle/shuttle_area = place
		for(var/turf/shuttle_turf in shuttle_area)
			for(var/atom/passenger in shuttle_turf.get_all_contents())
				if((is_type_in_typecache(passenger, GLOB.blacklisted_cargo_types) || HAS_TRAIT(passenger, TRAIT_BANNED_FROM_CARGO_SHUTTLE)) && !istype(passenger, /obj/docking_port))
					return FALSE
	return TRUE

/obj/docking_port/mobile/supply/request(obj/docking_port/stationary/S)
	if(mode != SHUTTLE_IDLE)
		return 2
	return ..()

/obj/docking_port/mobile/supply/initiate_docking()
	if(getDockedId() == "cargo_away") // Sell and buy when we leave home.
		var/new_call_time = initial(callTime)

		var/datum/export_report/exports = sell()
		if(exports.unique_exports && exports.unique_exports.len)
			new_call_time += exports.unique_exports.len * (15 SECONDS) // Simulate haggling and trading items in a shitty way

		var/list/empty_turfs = list() // Used for crates and other dense objects.
		for(var/obj/marker as anything in GLOB.cargo_shuttle_crate_markers)
			var/turf/turf = get_turf(marker)
			if(!turf.is_blocked_turf())
				empty_turfs += turf

		var/list/traders_bought_from = buy(empty_turfs)
		last_trade_trader_amount = traders_bought_from && traders_bought_from.len
		create_mail(empty_turfs)
		// Look man, this isn't ideal, probably, but I don't care at this point.
		// This is called once every few minutes at most, and the crew will just have to cry about the sub-optimal pathing.
		if(last_trade_trader_amount)
			var/datum/overmap_object/home = SSmapping.station_overmap_object
			var/total_distance = 0
			var/min_distance = INFINITY // This should be impossible to be larger than... right?
			var/datum/trader/min_trader
			while(traders_bought_from.len)
				for(var/trader_id in traders_bought_from)
					var/datum/trader/trader = SStrading.all_traders["[trader_id]"]
					var/datum/overmap_object/hub = trader.hub.overmap_object
					if(!hub)
						stack_trace("Unknown hub for trader [trader_id] ([trader])")
						continue
					var/dist = GET_DIST_2D_NUMERICAL(hub.x, hub.y, home.x, home.y)
					if(dist < min_distance)
						min_distance = dist
						min_trader = trader_id
				total_distance += min_distance
				traders_bought_from -= min_trader
				min_distance = INFINITY
			// Shuttle travels at 1 tile every 5 seconds, if that makes this make more sense.
			new_call_time += total_distance * (5 SECONDS)
		setTimer(new_call_time)

	. = ..() // Fly/enter transit.
	if(. != DOCKING_SUCCESS)
		return

	if(getDockedId() == "cargo_away")
		if(!SSshuttle.getDock("cargo_home"))
			return // No runtimes, thanks
		SSshuttle.moveShuttle("cargo", "cargo_home") // And immediately return to the station!

/obj/docking_port/mobile/supply/proc/buy(list/empty_turfs)
	SEND_SIGNAL(SSshuttle, COMSIG_SUPPLY_SHUTTLE_BUY)

	var/list/shelf_turfs = list() // Used for anything that isn't dense.
	for(var/place in shuttle_areas)
		var/area/shuttle/shuttle_area = place
		for(var/turf/open/floor/T in shuttle_area)
			if(locate(/obj/structure/rack) in T)
				shelf_turfs += T

	//quickly and greedily handle chef's grocery runs first, there are a few reasons why this isn't attached to the rest of cargo...
	//but the biggest reason is that the chef requires produce to cook and do their job, and if they are using this system they
	//already got let down by the botanists. So to open a new chance for cargo to also screw them over any more than is necessary is bad.
	if(SStrading.chef_groceries.len)
		var/obj/structure/closet/crate/freezer/grocery_crate = new(pick_n_take(empty_turfs))
		grocery_crate.name = "kitchen produce freezer"
		investigate_log("Chef's [SStrading.chef_groceries.len] sized produce order arrived. Cost was deducted from orderer, not cargo.", INVESTIGATE_CARGO)
		for(var/datum/orderable_item/item as anything in SStrading.chef_groceries)//every order
			for(var/amt in 1 to SStrading.chef_groceries[item])//every order amount
				new item.item_instance.type(grocery_crate)
		SStrading.chef_groceries.Cut() //This lets the console know it can order another round.

	if(!SStrading.shopping_list.len)
		return

	var/value = 0
	var/purchases = 0
	var/list/goodies_by_buyer = list() // if someone orders more than GOODY_FREE_SHIPPING_MAX goodies, we upcharge to a normal crate so they can't carry around 20 combat shotties
	var/list/traders_bought_from = list()

	for(var/datum/supply_order/spawning_order in SStrading.shopping_list)
		if(!empty_turfs.len) // Let's not risk it.
			break

		var/datum/bank_account/paying_for_this = spawning_order.paying_account

		//give traders their hard-earned cash, now that the order is complete.
		if(!spawning_order.department_destination && spawning_order.trader_id)
			var/datum/trader/trader = SStrading.get_trader_by_id(spawning_order.trader_id)
			trader.current_credits += spawning_order.cost

		if(paying_for_this)
			if(spawning_order.pack.goody)
				LAZYADD(goodies_by_buyer[paying_for_this], spawning_order)
			paying_for_this.bank_talk("Cargo order #[spawning_order.id] is now locked in and will be on cargo shuttle when it returns.")
			SSeconomy.track_purchase(paying_for_this, spawning_order.cost, spawning_order.pack.name)
			var/datum/bank_account/department/cargo = SSeconomy.get_dep_account(ACCOUNT_CAR)
			cargo.adjust_money(spawning_order.cost / 50, "Cargo: Handling fee for [spawning_order.pack.name]") //Cargo gets the handling fee.
		value += spawning_order.pack.get_cost()
		SStrading.shopping_list -= spawning_order
		SStrading.order_history += spawning_order
		QDEL_NULL(spawning_order.applied_coupon)

		var/obj/item/package/package = spawning_order.generate(pick(empty_turfs))
		package.forceMove(package.density ? pick_n_take(empty_turfs) : pick(shelf_turfs))
		if(!package.density)
			package.pixel_x = rand(-8, 8)
			package.pixel_y = rand(-8, 8)

		SSblackbox.record_feedback("nested tally", "cargo_imports", 1, list("[spawning_order.pack.get_cost()]", "[spawning_order.pack.name]"))

		var/from_whom = paying_for_this?.account_holder || "nobody (department order)"

		investigate_log("Order #[spawning_order.id] ([spawning_order.pack.name], placed by [key_name(spawning_order.orderer_ckey)]), paid by [from_whom] has shipped.", INVESTIGATE_CARGO)
		if(spawning_order.pack.dangerous)
			message_admins("\A [spawning_order.pack.name] ordered by [ADMIN_LOOKUPFLW(spawning_order.orderer_ckey)], paid by [from_whom] has shipped.")
		purchases++
		if(spawning_order.trader_id)
			traders_bought_from["[spawning_order.trader_id]"] = TRUE // Shut. This is the fastest way to non-duplicate add to a list.

	SSeconomy.import_total += value
	var/datum/bank_account/cargo_budget = SSeconomy.get_dep_account(ACCOUNT_CAR)
	investigate_log("[purchases] orders in this shipment, worth [value] credits. [cargo_budget.account_balance] credits left.", INVESTIGATE_CARGO)
	return traders_bought_from

/obj/docking_port/mobile/supply/proc/sell()
	var/datum/bank_account/D = SSeconomy.get_dep_account(ACCOUNT_CAR)
	var/presale_points = D.account_balance

	if(!GLOB.exports_list.len) // No exports list? Generate it!
		setupExports()

	var/msg = ""

	var/datum/export_report/ex = new

	for(var/place in shuttle_areas)
		var/area/shuttle/shuttle_area = place
		for(var/atom/movable/AM in shuttle_area)
			if(iscameramob(AM))
				continue
			if(!AM.anchored)
				var/bounty_instead = FALSE
				for(var/datum/trader_bounty/bounty as anything in GLOB.trader_bounties)
					ex.unique_exports += 1 // Bounties are significantly more time efficient. Do them.
					if(bounty.hand_in(AM))
						bounty_instead = TRUE
						break
				if(bounty_instead)
					continue
				var/datum/export_report/report = export_item_and_contents(AM, export_categories, dry_run = FALSE, external_report = ex)
				ex.unique_exports += report.unique_exports

	for(var/datum/export/E in ex.total_amount)
		var/export_text = E.total_printout(ex)
		if(!export_text)
			continue

		msg += export_text + "\n"
		D.adjust_money(ex.total_value[E])

	SSeconomy.export_total += (D.account_balance - presale_points)
	SStrading.trade_message = msg
	investigate_log("Shuttle contents sold for [D.account_balance - presale_points] credits. Contents: [ex.exported_atoms ? ex.exported_atoms.Join(",") + "." : "none."] Message: [SStrading.trade_message || "none."]", INVESTIGATE_CARGO)
	return ex

/*
	Generates a box of mail depending on our exports and imports.
	Applied in the cargo shuttle sending/arriving, by building the crate if the round is ready to introduce mail based on the economy subsystem.
	Then, fills the mail crate with mail, by picking applicable crew who can recieve mail at the time to sending.
*/
/obj/docking_port/mobile/supply/proc/create_mail(list/empty_turfs)
	//Early return if there's no mail waiting to prevent taking up a slot. We also don't send mails on sundays or holidays.
	if(!SSeconomy.mail_waiting || SSeconomy.mail_blocked)
		return

	new /obj/structure/closet/crate/mail/economy(pick(empty_turfs))

/obj/docking_port/mobile/supply/get_status_text_tgui()
	var/obj/docking_port/stationary/port = get_docked()

	if(port.shuttle_id != "cargo_home")
		return "Engaging in trade with [last_trade_trader_amount] traders ([getTimerStr()])"

	return "Docked: [port.name]"

// At some point, maybe make this a set of markers or beacons that players can set? Dunno. Would people use that?
GLOBAL_LIST_EMPTY(cargo_shuttle_crate_markers)

/obj/effect/landmark/cargo_shuttle_crate
	name = "Cargo Shuttle Crate Marker"
	desc = "If you're seeing this, uh, cool! Tell a coder please!"
	icon_state = "loot_site"

/obj/effect/landmark/cargo_shuttle_crate/Initialize(mapload)
	. = ..()
	GLOB.cargo_shuttle_crate_markers += src

/obj/effect/landmark/cargo_shuttle_crate/Destroy()
	GLOB.cargo_shuttle_crate_markers -= src
	. = ..()

#undef GOODY_FREE_SHIPPING_MAX
#undef CRATE_TAX

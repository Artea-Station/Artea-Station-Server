/datum/supply_pack
	/// The name of the supply pack, as listed on the trader UI.
	var/name
	/// The group that the supply pack is sorted into within the trader UI. Use the TRADER_GROUP defines. Can be a list.
	var/group
	/// Is this cargo supply pack visible to traders.
	var/hidden = FALSE
	/// Is this supply pack purchasable outside of the standard purchasing band? Contraband is available by multitooling the trade console board.
	var/contraband = FALSE
	/// Cost of the pack. Cargo crate value should be used as a base, despite crates not actually being used.
	var/cost = CARGO_CRATE_VALUE * 1.4
	/// What access is required to open the crate when spawned?
	var/access
	/// Who can view this supply_pack and with what access.
	var/access_view
	/// If someone with any of the following accesses in a list can open this cargo pack crate.
	var/access_any
	/// A list of items that are spawned in the crate of the supply pack.
	var/list/contains
	/// The ID that's used to find this order in SStrading.supply_packs. Used instead of `type` for allowing dynamically generating packs.
	var/id
	/// The description shown on the trader UI. No desc by default.
	var/desc
	/// What is the name of the crate that is spawned with the crate's contents?
	var/container_name = "crate"
	/// What typepath of container do you spawn? Can be a crate OR /obj/item/delivery.
	var/container_type = /obj/item/delivery
	/// Should we message admins?
	var/dangerous = FALSE
	/// Event/Station Goals/Admin enabled packs
	var/special = FALSE
	/// When a cargo pack can be unlocked by special events (as seen in special), this toggles if it's been enabled in the round yet (For example, after the station alert, we can now enable buying the station goal pack).
	var/special_enabled = FALSE
	/// Was this spawned through an admin proc?
	var/admin_spawned = FALSE
	/// Goodies can only be purchased by private accounts and can have coupons apply to them. They also come in a lockbox instead of a full crate, so the 700 min doesn't apply
	var/goody = FALSE
	/// Traders will have this amount this pack initially.
	var/default_stock = 5
	/// An assoc list of trader IDs to the amount of this item they currently have.
	var/list/stock = list()
	/// Set to TRUE to make it show in the galactic imports menu. Will inherit the FIRST group of the pack as the category.
	var/galactic_import = FALSE
	/// If set to TRUE, only admins can remove this pack once added to the shopping list. Used for important things like bounty reward items.
	/// Also hides the pack from traders.
	var/cant_be_removed = FALSE

/datum/supply_pack/New()
	id = "[type]"
	if(!name && islist(contains))
		var/obj/ordered_item = contains[1]
		if(ordered_item)
			name = initial(ordered_item.name) // The UI capitalizes everything using transorm-text, as doing it DM-side properly would be a ball-ache.
		else
			CRASH("No name given for supply pack \"[type]\"!")

/datum/supply_pack/proc/generate(atom/A, datum/bank_account/paying_account)
	if(!container_type)
		CRASH("tried to generate a supply pack without a valid crate type")

	var/obj/item/delivery/package

	if(ispath(container_type, /obj/structure/closet) || ispath(container_type, /obj/item/storage/secure))
		// Briefcase and crate both have req_access vars, so this is fine.
		var/obj/structure/closet/crate/crate
		if(paying_account)
			crate = ispath(container_type, /obj/item/storage/secure) ? new container_type(A) : new /obj/structure/closet/crate/secure/owned(A, paying_account)
			crate.name = "[container_name] - Purchased by [paying_account.account_holder]"
		else
			crate = new container_type(A)
			crate.name = container_name
		if(access)
			crate.req_access = list(access)
		if(access_any)
			crate.req_one_access = access_any

		fill(crate)

		var/obj/item/yarr = crate
		if(istype(crate, /obj/item/storage/secure) && yarr.w_class < WEIGHT_CLASS_GIGANTIC)
			package = new /obj/item/delivery/small(crate)
			package.icon_state = "deliverypackage[yarr.w_class]"
			package.w_class = yarr.w_class
		else
			package = new /obj/item/delivery/big(crate)
			if(istype(crate))
				package.icon_state = "deliverycrate"
			else if(!istype(crate, /obj/structure/closet))
				package.icon_state = "deliverybox"

	else if(ispath(container_type, /obj/item/delivery))
		package = new /obj/item/delivery/big(A)
		fill(package)

		var/target_state = 0
		var/list/all_contents = package.get_all_contents()
		for(var/atom/movable/thing as anything in all_contents)
			if(istype(thing, /obj/item))
				var/obj/item/item = thing
				target_state += item.w_class
			else if(istype(thing, /obj/structure/closet))
				target_state = "deliverycloset"
			else if(istype(thing, /obj/structure/closet/crate))
				target_state = "deliverycrate"
			else
				target_state = "deliverybox"

			if(!isnum(target_state))
				break
			if(target_state > WEIGHT_CLASS_HUGE)
				target_state = "deliverybox"

		if(isnum(target_state)) // Is smol, and has very few items, let's give it a little dignity.
			qdel(package)
			package = new /obj/item/delivery/small
			target_state = "deliverypackage[target_state]"
			for(var/atom/movable/thing as anything in all_contents)
				thing.forceMove(package)

		package.name = "[container_name] - Purchased by [paying_account.account_holder]"
		package.icon_state = target_state

	else
		CRASH("Invalid container_type given for [type]!")

	return package

/datum/supply_pack/proc/get_cost()
	. = cost
	. *= SSeconomy.pack_price_modifier

/datum/supply_pack/proc/fill(obj/container)
	if (admin_spawned)
		for(var/item in contains)
			var/atom/A = new item(container)
			A.flags_1 |= ADMIN_SPAWNED_1
	else
		for(var/item in contains)
			new item(container)

/// For generating supply packs at runtime. Returns a list of supply packs to use ALONGSIDE this one.
/// Make sure the contents are nulled if you don't want the pack generating these to do anything else.
/datum/supply_pack/proc/generate_supply_packs()
	if(galactic_import)
		return list(new /datum/supply_pack/galactic_imports/generated("[/datum/supply_pack/galactic_imports/generated]|[type]", src))

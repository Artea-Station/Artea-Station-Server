/datum/delivery_run
	/// Name of the delivery mission
	var/name = "Badly Coded Delivery Run"
	/// Description of the delivery mission
	var/desc = "We need some stuff delivered."
	/// Type of the cargo to spawn, neeed to be types of /obj/item/delivery_cargo
	var/obj/cargo_type = /obj/item/delivery_cargo
	/// Possible flavor namings for the cargo we'll be carrying
	var/list/possible_cargo_names = list("valuable cargo")
	/// Possible flavor namings for our recipients we'll be delivering to
	var/list/possible_recipients = list("our trusted client")
	/// Cash reward we'll get, can be null
	var/reward_cash = 2000
	/// Path to the rewarded item, can be null
	var/obj/reward_item_path
	/// Name of the rewarded item, automatically filled if above is present
	var/reward_item_name

	//Below are internals
	/// System to deliver to
	var/datum/overmap_sun_system/system_to_deliver
	/// Overmap X coordinate to deliver to
	var/overmap_x
	/// Overmap Y coordinate to deliver to
	var/overmap_y
	/// Name of the cargo that was chosen
	var/cargo_name
	/// Name of the recipient that was chosen
	var/recipient_name

/datum/delivery_run/New(datum/trader/source_trader)
	if(reward_item_path && !reward_item_name)
		var/atom/movable/cast = reward_item_path
		reward_item_name = initial(cast.name)

	cargo_name = pick(possible_cargo_names)
	recipient_name = pick(possible_recipients)

	return ..()

/datum/delivery_run/proc/Accept(mob/user, obj/machinery/computer/trade_console/console)
	system_to_deliver = SSovermap.main_system
	var/list/safe_coords = system_to_deliver.GetRandomSafeCoords()
	overmap_x = safe_coords[1]
	overmap_y = safe_coords[2]
	new /datum/delivery_run_instance(src, user, console)

/datum/delivery_run_instance
	//All internal variables holding data from /datum/delivery_run
	var/obj/item/delivery_cargo/delivery_object
	var/reward_cash
	var/reward_item_path
	var/waiting_for_reward = FALSE

	var/overmap_x
	var/overmap_y

	var/system_to_deliver

	var/datum/overmap_object/delivery_ship/fluff_overmap_object

/datum/delivery_run_instance/New(datum/delivery_run/source_datum, mob/orderer, obj/machinery/computer/trade_console/console)
	SStrading.delivery_runs += src
	reward_cash = source_datum.reward_cash
	reward_item_path = source_datum.reward_item_path
	system_to_deliver = source_datum.system_to_deliver
	overmap_x = source_datum.overmap_x
	overmap_y = source_datum.overmap_y

	fluff_overmap_object = new(system_to_deliver, overmap_x, overmap_y)

	var/obj/item/paper/manifest = new /obj/item/paper()
	manifest.name = "Delivery: [source_datum.name]"
	manifest.add_raw_text("<CENTER><B>[console.connected_trader.origin] - DELIVERY: [source_datum.name]</B></CENTER><HR>")
	manifest.add_raw_text("[source_datum.desc]")
	manifest.add_raw_text("<BR>A delivery of [source_datum.cargo_name] for [source_datum.recipient_name]")
	manifest.add_raw_text("<BR>Star System: [source_datum.system_to_deliver.name]<BR>X:[source_datum.overmap_x], Y:[source_datum.overmap_y]")
	manifest.update_appearance()

	var/datum/supply_pack/delivery_run/pack = new(list(source_datum.cargo_name, source_datum.cargo_type, src, manifest))
	SStrading.shopping_list += new /datum/supply_order(pack, orderer, console.inserted_id?.assignment, orderer.ckey, "Delivery: [source_datum.name]")
	return ..()

/datum/delivery_run_instance/Destroy()
	SStrading.delivery_runs -= src
	QDEL_NULL(fluff_overmap_object)
	return ..()

/datum/delivery_run_instance/proc/CargoDeleted()
	delivery_object = null
	if(waiting_for_reward)
		return
	qdel(src)

/datum/delivery_run_instance/proc/TryDeliver(mob/living/user)
	var/datum/overmap_object/overmap_object = GetHousingOvermapObject(user)
	if(!overmap_object)
		return
	if(overmap_object.x == overmap_x && overmap_object.y == overmap_y)
		Delivered(user)

/// I really don't like this, but I've spent long enough on cargo.
/datum/delivery_run_instance/proc/Delivered(mob/living/user)
	var/turf/user_turf = get_turf(user)
	waiting_for_reward = TRUE
	addtimer(CALLBACK(src, PROC_REF(TimedReward), user_turf, fluff_overmap_object.name), rand(2 SECONDS, 4 SECONDS))
	do_sparks(3, TRUE, user_turf)
	qdel(delivery_object)

/datum/delivery_run_instance/proc/TimedReward(turf/position, delivery_name)
	if(reward_cash)
		var/split_cash = round(SSeconomy.department_accounts.len / reward_cash)
		for(var/datum/bank_account/department_account as anything in SSeconomy.department_accounts)
			department_account.adjust_money(split_cash, "DELIVERY: [delivery_name]")
	if(reward_item_path)
		new reward_item_path(position)
	do_sparks(3, TRUE, position)
	addtimer(CALLBACK(src, PROC_REF(TimedDestroy)), rand(20 SECONDS, 40 SECONDS))

/datum/delivery_run_instance/proc/TimedDestroy()
	qdel(src)

/obj/item/delivery_cargo
	name = "secure package"
	desc = "Package wrapped with a surprisingly durable material. Probably contains valuable cargo for delivery."
	icon_state = "normal_package"
	w_class = WEIGHT_CLASS_NORMAL
	icon = 'icons/obj/storage/delivery_package.dmi'
	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/datum/delivery_run_instance/delivery_instance
	var/spooling_delivery = FALSE
	var/obj/item/paper/manifest

/obj/item/delivery_cargo/update_overlays()
	. = ..()
	if(manifest)
		. += "manifest"

/obj/item/delivery_cargo/examine(mob/user)
	. = ..()
	if(manifest)
		. += span_notice("There's a manifest on it.")
		. += manifest.examine(user)

/obj/item/delivery_cargo/attack_self(mob/living/user)
	if(spooling_delivery)
		return
	to_chat(user, span_notice("You press a button on \the [src]"))
	spooling_delivery = TRUE
	addtimer(CALLBACK(src, PROC_REF(TimedDelivery), user), rand(2 SECONDS, 4 SECONDS))

/obj/item/delivery_cargo/proc/TimedDelivery(mob/living/user)
	spooling_delivery = FALSE
	delivery_instance.TryDeliver(user)

/obj/item/delivery_cargo/Destroy()
	if(delivery_instance && !QDELETED(delivery_instance))
		delivery_instance.CargoDeleted()
		delivery_instance = null
	if(manifest)
		QDEL_NULL(manifest)
	return ..()

/obj/item/delivery_cargo/tiny
	name = "tiny secure package"
	icon_state = "tiny_package"
	w_class = WEIGHT_CLASS_TINY

/obj/item/delivery_cargo/small
	name = "small secure package"
	icon_state = "small_package"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/delivery_cargo/bulky
	name = "bulky secure package"
	icon_state = "bulky_package"
	w_class = WEIGHT_CLASS_BULKY

/datum/overmap_object/delivery_ship
	name = "remote ship"
	visual_type = /obj/effect/abstract/overmap/delivery_ship

/datum/overmap_object/delivery_ship/New()
	. = ..()
	partial_y = rand(-13,13)
	partial_x = rand(-13,13)
	UpdateVisualOffsets()

/obj/effect/abstract/overmap/delivery_ship
	icon_state = "interestobject"
	layer = OVERMAP_LAYER_SHUTTLE
	color = LIGHT_COLOR_CYAN

// Compat code to make delivery runs work with the cargo system. Probably never gonna be touched again, knowing me. - Rimi
/datum/supply_pack/delivery_run
	var/cargo_type
	var/delivery_instance
	var/obj/item/paper/manifest

// I DON'T FUCKING KNOW WHY, FOR SOME FUCKING REASON IT ADDS AN EXTRA NULL BETWEEN CARGO_TYPE AND DELIVERY_INSTANCE. I'M SO DONE WITH THIS SHITTY FUCKING CUNT ENGINE
/datum/supply_pack/delivery_run/New(list/data) // name, cargo_type, /datum/delivery_run_instance/delivery_instance, manifest
	if(!data)
		return
	cant_be_removed = TRUE
	src.name = data[1]
	src.cargo_type = data[2]
	src.delivery_instance = data[3]
	src.manifest = data[4]
	return ..()

/datum/supply_pack/delivery_run/generate(atom/A, datum/bank_account/paying_account)
	var/obj/item/delivery_cargo/cargo = new cargo_type(A)
	cargo.delivery_instance = delivery_instance
	cargo.manifest = manifest
	if(cargo.manifest)
		manifest.forceMove(cargo)
	cargo.update_appearance()

#define CART_PACK_NAME "name"
#define CART_PACK_GROUP "group"
#define CART_PACK_ACCESS "access"
#define CART_COST_MULTIPLIER "cost_multiplier"

// Oh shit, I somehow lost all my chems, and need get back in business!
/datum/supply_pack/galactic_imports/cart_pack
	group = TRADER_GROUP_GALACTIC_IMPORTS
	category = "Cartridge Packs"

/datum/supply_pack/galactic_imports/cart_pack/fill(obj/crate)
	for(var/datum/reagent/chem as anything in contains)
		var/obj/item/reagent_containers/chem_cartridge/cartridge = contains[chem]
		cartridge = new cartridge(crate)
		if(admin_spawned)
			cartridge.flags_1 |= ADMIN_SPAWNED_1
		cartridge.setLabel(initial(chem.name))
		cartridge.reagents.add_reagent(chem, cartridge.volume)

/datum/supply_pack/galactic_imports/cart_pack/chem_cartridge_get_out_of_jail_card
	name = "Chem Cartridge Luxury Pack (Full Dispenser)"
	desc = "Contains a full set of chem cartridges of the same size inside a chemist's dispenser at shift start."
	cost = CARGO_CRATE_VALUE * 30
	contains = CARTRIDGE_LIST_CHEM_DISPENSER
	container_type = /obj/structure/closet/crate/medical

/datum/supply_pack/galactic_imports/cart_pack/soft_drinks_chem_cartridge_get_out_of_jail_card
	name = "Soft Drinks Cartridge Luxury Pack (Full Dispenser)"
	desc = "Contains a full set of chem cartridges of the same size inside a soft drinks dispenser at shift start."
	cost = CARGO_CRATE_VALUE * 20
	contains = CARTRIDGE_LIST_DRINKS
	category = "Cartridge Packs"
	container_type = /obj/structure/closet/crate

/datum/supply_pack/galactic_imports/cart_pack/booze_chem_cartridge_get_out_of_jail_card
	group = TRADER_GROUP_GALACTIC_IMPORTS
	name = "Booze Cartridge Luxury Pack (Full Dispenser)"
	desc = "Contains a full set of chem cartridges of the same size inside a booze dispenser at shift start."
	cost = CARGO_CRATE_VALUE * 25
	contains = CARTRIDGE_LIST_BOOZE
	category = "Cartridge Packs"
	container_type = /obj/structure/closet/crate

// The amount of shit going into this *will* warrant it's own category.
/datum/supply_pack/galactic_imports/cartridges
	container_type = /obj/structure/closet/crate/medical
	group = TRADER_GROUP_GALACTIC_IMPORTS

	var/static/list/cartridge_params = list(
		"Small" = CARGO_CRATE_VALUE * 0.6,
		"Medium" = CARGO_CRATE_VALUE,
		"Large" = CARGO_CRATE_VALUE * 2,
	)

	/// An assoc list of premade chem lists to an assoc list of the base name for each cartridge, the cargo group they belong to, required access (optional), and cost multiplier.
	var/static/list/chem_lists = list(
		// Yes, this is a list assoc'd to a list. No, I am not sorry.
		CARTRIDGE_LIST_CHEM_DISPENSER = list(
			CART_PACK_NAME = "Chem Cartridge",
			CART_PACK_GROUP = "Single Chem Cartridges",
			CART_PACK_ACCESS = ACCESS_MEDICAL,
			CART_COST_MULTIPLIER = 1.4,
		),
		CARTRIDGE_LIST_DRINKS = list(
			CART_PACK_NAME = "Drink Cartridge",
			CART_PACK_GROUP = "Single Drink Cartridges",
			CART_COST_MULTIPLIER = 1.6,
		),
		CARTRIDGE_LIST_BOOZE = list(
			CART_PACK_NAME = "Booze Cartridge",
			CART_PACK_GROUP = "Single Booze Cartridges",
			CART_PACK_ACCESS = ACCESS_BAR,
			CART_COST_MULTIPLIER = 1.2,
		),
		CARTRIDGE_LIST_BOTANY = list(
			CART_PACK_NAME = "Botanical Cartridge",
			CART_PACK_GROUP = "Single Botanical Cartridges",
			CART_PACK_ACCESS = ACCESS_HYDROPONICS,
			CART_COST_MULTIPLIER = 1.4,
		)
	)

	var/datum/reagent/chem

/datum/supply_pack/galactic_imports/cartridges/generate_supply_packs()
	var/list/packs_to_return = list()

	for(var/list/chem_list as anything in chem_lists)
		var/list/chem_pack_properties = chem_lists[chem_list]
		var/pack_name = chem_pack_properties[CART_PACK_NAME]
		var/pack_group = chem_pack_properties[CART_PACK_GROUP]
		var/pack_access = chem_pack_properties[CART_PACK_ACCESS]
		var/pack_cost_multiplier = chem_pack_properties[CART_COST_MULTIPLIER]
		for(var/datum/reagent/chem as anything in chem_list)
			for(var/size in cartridge_params)
				var/pack_cost = cartridge_params[size]
				var/obj/item/reagent_containers/chem_cartridge/cartridge
				switch(size)
					if("Small")
						cartridge = /obj/item/reagent_containers/chem_cartridge/small
					if("Medium")
						cartridge = /obj/item/reagent_containers/chem_cartridge/medium
					if("Large")
						cartridge = /obj/item/reagent_containers/chem_cartridge/large

				var/datum/supply_pack/galactic_imports/cartridges/generated/pack = new
				pack.name = "[initial(chem.name)] [pack_name] ([size])"
				pack.category = pack_group
				pack.id = "[chem]|[initial(chem.name)]|[size]"
				pack.desc = "Contains a single [lowertext(size)] cartridge of [initial(chem.name)]. [initial(chem.description)]"
				pack.access_view = pack_access
				pack.contains = list(cartridge)
				pack.chem = chem
				pack.cost = (pack_cost * pack_cost_multiplier) + CARGO_CRATE_VALUE

				packs_to_return += pack

	QDEL_NULL(chem_lists) // Let's not keep these in memory if we don't have to.

	return packs_to_return

// Spawn the ordered cartridge and properly set it up with the desired chem.
/datum/supply_pack/galactic_imports/cartridges/fill(obj/crate)
	for(var/item in contains)
		var/obj/item/reagent_containers/chem_cartridge/cartridge = new item(crate)
		if(admin_spawned)
			cartridge.flags_1 |= ADMIN_SPAWNED_1
		cartridge.setLabel(initial(chem.name))
		cartridge.reagents.add_reagent(chem, cartridge.volume)

// Don't endlessly make packs. Thanks.
/datum/supply_pack/galactic_imports/cartridges/generated/generate_supply_packs()
	return

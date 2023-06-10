
// Oh shit, I somehow lost all my chems, and need get back in business!
/datum/supply_pack/medical/chem_cartridge_get_out_of_jail_card
	name = "Chem Cartridge Luxury Pack (Full Dispenser)"
	cost = CARGO_CRATE_VALUE * 20
	contains = list(
		CHEM_CARTRIDGE_S(aluminium),
		CHEM_CARTRIDGE_S(bromine),
		CHEM_CARTRIDGE_M(carbon),
		CHEM_CARTRIDGE_M(chlorine),
		CHEM_CARTRIDGE_S(copper),
		CHEM_CARTRIDGE_S(consumable/ethanol),
		CHEM_CARTRIDGE_S(fluorine),
		CHEM_CARTRIDGE_M(hydrogen),
		CHEM_CARTRIDGE_S(iodine),
		CHEM_CARTRIDGE_S(iron),
		CHEM_CARTRIDGE_S(lithium),
		CHEM_CARTRIDGE_S(mercury),
		CHEM_CARTRIDGE_M(nitrogen),
		CHEM_CARTRIDGE_M(oxygen),
		CHEM_CARTRIDGE_S(phosphorus),
		CHEM_CARTRIDGE_S(potassium),
		CHEM_CARTRIDGE_S(uranium/radium),
		CHEM_CARTRIDGE_S(silicon),
		CHEM_CARTRIDGE_S(sodium),
		CHEM_CARTRIDGE_S(stable_plasma),
		CHEM_CARTRIDGE_S(consumable/sugar),
		CHEM_CARTRIDGE_S(sulfur),
		CHEM_CARTRIDGE_S(toxin/acid),
		CHEM_CARTRIDGE_M(water),
		CHEM_CARTRIDGE_M(fuel),
	)

/datum/supply_pack/medical/chem_cartridge_large_cartridge
	name = "Chem Cartridge (Large)"
	cost = CARGO_CRATE_VALUE * 2

/datum/supply_pack/medical/chem_cartridge_large_cartridge
	name = "Chem Cartridge (Medium)"
	cost = CARGO_CRATE_VALUE

/datum/supply_pack/medical/chem_cartridge_large_cartridge
	name = "Chem Cartridge (Small)"
	cost = CARGO_CRATE_VALUE * 0.6

// The amount of shit going into this *will* warrant it's own category.
/datum/supply_pack/cartridges
	group = "Single Chem Cartridges"

	var/static/list/cartridge_params = list("Small" = CARGO_CRATE_VALUE * 0.6, "Medium" = CARGO_CRATE_VALUE, "Large" = CARGO_CRATE_VALUE * 2)

	var/datum/reagent/chem

/datum/supply_pack/cartridges/generate_supply_packs()
	var/list/found_chems = list()

	for(var/obj/item/reagent_containers/chem_disp_cartridge/cartridge as anything in subtypesof(/obj/item/reagent_containers/chem_disp_cartridge))
		found_chems += initial(cartridge.spawn_reagent)

	found_chems -= null

	var/list/packs_to_return = list()

	for(var/datum/reagent/chem in found_chems)
		var/is_consumable = ispath(chem, /datum/reagent/consumable) && chem != /datum/reagent/consumable/ethanol
		for(var/size in cartridge_params)
			var/pack_cost = cartridge_params[size]

			var/datum/supply_pack/cartridges/pack = new
			pack.name = "[initial(chem.name)] Chem Cartridge ([size])"
			pack.contains = size == "Small" ? /obj/item/reagent_containers/chem_disp_cartridge/small : size == "Medium" ? /obj/item/reagent_containers/chem_disp_cartridge/medium : /obj/item/reagent_containers/chem_disp_cartridge
			pack.chem = chem
			pack.cost = is_consumable ? pack_cost * 0.8 : pack_cost * 1.2 // Source: I MADE IT THE FUCK UP
			packs_to_return += pack

	return packs_to_return

/datum/supply_pack/cartridges/fill(obj/structure/closet/crate/crate)
	for(var/item in contains)
		var/obj/item/reagent_containers/chem_disp_cartridge/cartridge = new item(crate)
		if(admin_spawned)
			cartridge.flags_1 |= ADMIN_SPAWNED_1
		cartridge.setLabel(initial(chem.name))
		cartridge.reagents.add_reagent(chem, cartridge.volume)

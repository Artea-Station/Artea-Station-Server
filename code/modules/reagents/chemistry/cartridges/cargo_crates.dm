
// Oh shit, I somehow lost all my chems, and need get back in business!
/datum/supply_pack/medical/chem_cartridge_get_out_of_jail_card
	name = "Chem Cartridge Luxury Pack (Full Dispenser)"
	desc = "Contains a full set of chem cartridges of the same size inside a chemist's dispenser at shift start."
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

/datum/supply_pack/service/soft_drinks_chem_cartridge_get_out_of_jail_card
	name = "Soft Drinks Cartridge Luxury Pack (Full Dispenser)"
	desc = "Contains a full set of chem cartridges of the same size inside a soft drinks dispenser at shift start."
	cost = CARGO_CRATE_VALUE * 20
	contains = list(
		CHEM_CARTRIDGE_M(consumable/coffee),
		CHEM_CARTRIDGE_M(consumable/space_cola),
		CHEM_CARTRIDGE_M(consumable/cream),
		CHEM_CARTRIDGE_M(consumable/dr_gibb),
		CHEM_CARTRIDGE_M(consumable/grenadine),
		CHEM_CARTRIDGE_M(consumable/ice),
		CHEM_CARTRIDGE_M(consumable/icetea),
		CHEM_CARTRIDGE_M(consumable/lemonjuice),
		CHEM_CARTRIDGE_M(consumable/lemon_lime),
		CHEM_CARTRIDGE_M(consumable/limejuice),
		CHEM_CARTRIDGE_M(consumable/menthol),
		CHEM_CARTRIDGE_M(consumable/orangejuice),
		CHEM_CARTRIDGE_M(consumable/pineapplejuice),
		CHEM_CARTRIDGE_M(consumable/pwr_game),
		CHEM_CARTRIDGE_M(consumable/shamblers),
		CHEM_CARTRIDGE_M(consumable/spacemountainwind),
		CHEM_CARTRIDGE_M(consumable/sodawater),
		CHEM_CARTRIDGE_M(consumable/space_up),
		CHEM_CARTRIDGE_M(consumable/sugar),
		CHEM_CARTRIDGE_M(consumable/tea),
		CHEM_CARTRIDGE_M(consumable/tomatojuice),
		CHEM_CARTRIDGE_M(consumable/tonic),
	)

/datum/supply_pack/service/booze_chem_cartridge_get_out_of_jail_card
	name = "Booze Cartridge Luxury Pack (Full Dispenser)"
	desc = "Contains a full set of chem cartridges of the same size inside a booze dispenser at shift start."
	cost = CARGO_CRATE_VALUE * 20
	contains = list(
		CHEM_CARTRIDGE_S(consumable/ethanol/absinthe),
		CHEM_CARTRIDGE_S(consumable/ethanol/ale),
		CHEM_CARTRIDGE_S(consumable/ethanol/applejack),
		CHEM_CARTRIDGE_S(consumable/ethanol/beer),
		CHEM_CARTRIDGE_S(consumable/ethanol/cognac),
		CHEM_CARTRIDGE_S(consumable/ethanol/creme_de_cacao),
		CHEM_CARTRIDGE_S(consumable/ethanol/creme_de_coconut),
		CHEM_CARTRIDGE_S(consumable/ethanol/creme_de_menthe),
		CHEM_CARTRIDGE_S(consumable/ethanol/curacao),
		CHEM_CARTRIDGE_S(consumable/ethanol/gin),
		CHEM_CARTRIDGE_S(consumable/ethanol/hcider),
		CHEM_CARTRIDGE_S(consumable/ethanol/kahlua),
		CHEM_CARTRIDGE_S(consumable/ethanol/beer/maltliquor),
		CHEM_CARTRIDGE_S(consumable/ethanol/navy_rum),
		CHEM_CARTRIDGE_S(consumable/ethanol/rum),
		CHEM_CARTRIDGE_S(consumable/ethanol/sake),
		CHEM_CARTRIDGE_S(consumable/ethanol/tequila),
		CHEM_CARTRIDGE_S(consumable/ethanol/triple_sec),
		CHEM_CARTRIDGE_S(consumable/ethanol/vermouth),
		CHEM_CARTRIDGE_S(consumable/ethanol/vodka),
		CHEM_CARTRIDGE_S(consumable/ethanol/whiskey),
		CHEM_CARTRIDGE_S(consumable/ethanol/wine),
	)

/datum/supply_pack/service/chem_cartridge_large
	name = "Chem Cartridge (Large)"
	desc = "Contains a single, empty large chem cartridge."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/reagent_containers/chem_disp_cartridge)
/datum/supply_pack/service/chem_cartridge_medium
	name = "Chem Cartridge (Medium)"
	cost = CARGO_CRATE_VALUE
	contains = list(/obj/item/reagent_containers/chem_disp_cartridge/medium)

/datum/supply_pack/service/chem_cartridge_small
	name = "Chem Cartridge (Small 2x)"
	cost = CARGO_CRATE_VALUE
	contains = list(/obj/item/reagent_containers/chem_disp_cartridge/small, /obj/item/reagent_containers/chem_disp_cartridge/small)

/datum/supply_pack/medical/chem_cartridge_large
	name = "Chem Cartridge (Large)"
	desc = "Contains a single, empty large chem cartridge."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/reagent_containers/chem_disp_cartridge)

/datum/supply_pack/medical/chem_cartridge_medium
	name = "Chem Cartridge (Medium)"
	desc = "Contains a single, empty medium chem cartridge."
	cost = CARGO_CRATE_VALUE
	contains = list(/obj/item/reagent_containers/chem_disp_cartridge/medium)

/datum/supply_pack/medical/chem_cartridge_small
	name = "Chem Cartridge (Small 2x)"
	desc = "Contains two, empty small chem cartridge."
	cost = CARGO_CRATE_VALUE
	contains = list(/obj/item/reagent_containers/chem_disp_cartridge/small, /obj/item/reagent_containers/chem_disp_cartridge/small)

// The amount of shit going into this *will* warrant it's own category.
/datum/supply_pack/cartridges
	group = "Single Chem Cartridges"
	access_view = ACCESS_MEDICAL
	crate_type = /obj/structure/closet/crate/medical

	var/static/list/cartridge_params = list(
		"Small" = CARGO_CRATE_VALUE * 0.6,
		"Medium" = CARGO_CRATE_VALUE,
		"Large" = CARGO_CRATE_VALUE * 2,
	)
	var/static/list/botany_chems = list(
		/datum/reagent/plantnutriment/eznutriment,
		/datum/reagent/plantnutriment/left4zednutriment,
		/datum/reagent/plantnutriment/robustharvestnutriment,
		/datum/reagent/toxin/plantbgone,
		/datum/reagent/toxin/plantbgone/weedkiller,
		/datum/reagent/toxin/pestkiller,
	)

	var/datum/reagent/chem

/datum/supply_pack/cartridges/generate_supply_packs()
	var/list/found_chems = list()

	for(var/obj/item/reagent_containers/chem_disp_cartridge/cartridge as anything in subtypesof(/obj/item/reagent_containers/chem_disp_cartridge))
		found_chems[initial(cartridge.spawn_reagent)] = TRUE

	var/list/packs_to_return = list()

	for(var/datum/reagent/chem as anything in found_chems)
		if(!chem)
			continue
		var/is_consumable = ispath(chem, /datum/reagent/consumable) && chem != /datum/reagent/consumable/ethanol
		for(var/size in cartridge_params)
			var/pack_cost = cartridge_params[size]
			var/obj/item/reagent_containers/chem_disp_cartridge/cartridge
			switch(size)
				if("Small")
					cartridge = /obj/item/reagent_containers/chem_disp_cartridge/small
				if("Medium")
					cartridge = /obj/item/reagent_containers/chem_disp_cartridge/medium
				if("Large")
					cartridge = /obj/item/reagent_containers/chem_disp_cartridge

			var/datum/supply_pack/cartridges/generated/pack = new
			pack.name = "[initial(chem.name)] Chem Cartridge ([size])"
			pack.id = "[chem]|[initial(chem.name)]|[size]"
			pack.desc = "Contains a single [lowertext(size)] cartridge of [initial(chem.name)]. [initial(chem.description)]"
			pack.contains = list(cartridge)
			pack.chem = chem
			pack.cost = is_consumable ? pack_cost * 1.2 : pack_cost * 1.4 // Source: I MADE IT THE FUCK UP
			if(botany_chems.Find(chem))
				pack.group = "Single Botany Cartridges"
			else if(is_consumable)
				pack.group = "Single Beverage Cartridges"
			if(ispath(chem, /datum/reagent/consumable/ethanol) && chem != /datum/reagent/consumable/ethanol)
				pack.cost *= 1.2 // Fuck you, alcohol tax time.
			packs_to_return += pack

	return packs_to_return

/datum/supply_pack/cartridges/fill(obj/structure/closet/crate/crate)
	for(var/item in contains)
		var/obj/item/reagent_containers/chem_disp_cartridge/cartridge = new item(crate)
		if(admin_spawned)
			cartridge.flags_1 |= ADMIN_SPAWNED_1
		cartridge.setLabel(initial(chem.name))
		cartridge.reagents.add_reagent(chem, cartridge.volume)

/datum/supply_pack/cartridges/generated/generate_supply_packs()
	return

// Premade dispensers for mappers.

/obj/machinery/chem_dispenser/drinks
	name = "soda dispenser"
	desc = "Contains a large reservoir of soft drinks."
	icon = 'icons/obj/medical/chemical.dmi'
	icon_state = "soda_dispenser"
	base_icon_state = "soda_dispenser"
	has_panel_overlay = FALSE
	dispensed_temperature = WATER_MATTERSTATE_CHANGE_TEMP // magical mystery temperature of 274.5, where ice does not melt, and water does not freeze
	heater_coefficient = SOFT_DISPENSER_HEATER_COEFFICIENT
	amount = 10
	pixel_y = 6
	circuit = /obj/item/circuitboard/machine/chem_dispenser/drinks
	working_state = null
	nopower_state = null
	pass_flags = PASSTABLE
	spawn_cartridges = list(
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
		CHEM_CARTRIDGE_M(water),
	)

/obj/machinery/chem_dispenser/drinks/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/simple_rotation)

/obj/machinery/chem_dispenser/drinks/setDir()
	var/old = dir
	. = ..()
	if(dir != old)
		update_appearance()  // the beaker needs to be re-positioned if we rotate

/obj/machinery/chem_dispenser/drinks/display_beaker()
	var/mutable_appearance/b_o = beaker_overlay || mutable_appearance(icon, "disp_beaker")
	switch(dir)
		if(NORTH)
			b_o.pixel_y = 7
			b_o.pixel_x = rand(-9, 9)
		if(EAST)
			b_o.pixel_x = 4
			b_o.pixel_y = rand(-5, 7)
		if(WEST)
			b_o.pixel_x = -5
			b_o.pixel_y = rand(-5, 7)
		else//SOUTH
			b_o.pixel_y = -7
			b_o.pixel_x = rand(-9, 9)
	return b_o

/obj/machinery/chem_dispenser/drinks/beer
	name = "booze dispenser"
	desc = "Contains a large reservoir of the good stuff."
	icon = 'icons/obj/medical/chemical.dmi'
	icon_state = "booze_dispenser"
	base_icon_state = "booze_dispenser"
	dispensed_temperature = WATER_MATTERSTATE_CHANGE_TEMP
	heater_coefficient = SOFT_DISPENSER_HEATER_COEFFICIENT
	circuit = /obj/item/circuitboard/machine/chem_dispenser/drinks/beer
	spawn_cartridges = list(
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

/obj/machinery/chem_dispenser/mutagen
	name = "mutagen dispenser"
	desc = "Creates and dispenses mutagen."
	spawn_cartridges = list(CHEM_CARTRIDGE_M(toxin/mutagen))


/obj/machinery/chem_dispenser/mutagensaltpeter
	name = "botanical chemical dispenser"
	desc = "Creates and dispenses chemicals useful for botany."
	flags_1 = NODECONSTRUCT_1

	circuit = /obj/item/circuitboard/machine/chem_dispenser/mutagensaltpeter

	spawn_cartridges = list(
		CHEM_CARTRIDGE_M(toxin/mutagen),
		CHEM_CARTRIDGE_M(saltpetre),
		CHEM_CARTRIDGE_M(plantnutriment/eznutriment),
		CHEM_CARTRIDGE_M(plantnutriment/left4zednutriment),
		CHEM_CARTRIDGE_M(plantnutriment/robustharvestnutriment),
		CHEM_CARTRIDGE_M(water),
		CHEM_CARTRIDGE_M(toxin/plantbgone),
		CHEM_CARTRIDGE_M(toxin/plantbgone/weedkiller),
		CHEM_CARTRIDGE_M(toxin/pestkiller),
		CHEM_CARTRIDGE_M(medicine/cryoxadone),
		CHEM_CARTRIDGE_M(ammonia),
		CHEM_CARTRIDGE_M(ash),
		CHEM_CARTRIDGE_M(diethylamine),
	)

// This is unused. Gonna be left in code for now, though it's likely to be removed if aliens get fully removed.
/obj/machinery/chem_dispenser/abductor
	name = "reagent synthesizer"
	desc = "Synthesizes a variety of reagents using proto-matter."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "chem_dispenser"
	base_icon_state = "chem_dispenser"
	has_panel_overlay = FALSE
	circuit = /obj/item/circuitboard/machine/chem_dispenser/abductor
	working_state = null
	nopower_state = null
	use_power = NO_POWER_USE
	// dispensable_reagents = list(
	// 	/datum/reagent/aluminium,
	// 	/datum/reagent/bromine,
	// 	/datum/reagent/carbon,
	// 	/datum/reagent/chlorine,
	// 	/datum/reagent/copper,
	// 	/datum/reagent/consumable/ethanol,
	// 	/datum/reagent/fluorine,
	// 	/datum/reagent/hydrogen,
	// 	/datum/reagent/iodine,
	// 	/datum/reagent/iron,
	// 	/datum/reagent/lithium,
	// 	/datum/reagent/mercury,
	// 	/datum/reagent/nitrogen,
	// 	/datum/reagent/oxygen,
	// 	/datum/reagent/phosphorus,
	// 	/datum/reagent/potassium,
	// 	/datum/reagent/uranium/radium,
	// 	/datum/reagent/silicon,
	// 	/datum/reagent/silver,
	// 	/datum/reagent/sodium,
	// 	/datum/reagent/stable_plasma,
	// 	/datum/reagent/consumable/sugar,
	// 	/datum/reagent/sulfur,
	// 	/datum/reagent/toxin/acid,
	// 	/datum/reagent/water,
	// 	/datum/reagent/fuel,
	// 	/datum/reagent/acetone,
	// 	/datum/reagent/ammonia,
	// 	/datum/reagent/ash,
	// 	/datum/reagent/diethylamine,
	// 	/datum/reagent/fuel/oil,
	// 	/datum/reagent/saltpetre,
	// 	/datum/reagent/medicine/mine_salve,
	// 	/datum/reagent/medicine/morphine,
	// 	/datum/reagent/drug/space_drugs,
	// 	/datum/reagent/toxin,
	// 	/datum/reagent/toxin/plasma,
	// 	/datum/reagent/uranium,
	// 	/datum/reagent/consumable/liquidelectricity/enriched,
	// 	/datum/reagent/medicine/c2/synthflesh
	// )

// Use the spawn reagents container verb under "Admin.Events" to get a reagent cartridge that's not here.
// NOTE: DO NOT ADD NEW CARTRIDGE TYPES UNLESS YOU'RE PREPARED TO MAKE SURE THAT IT'S ACCEPTABLE FOR THE STATION TO ORDER IT.
// MAKE A FILTER SYSTEM FOR THE CARGO ORDER LIST IF YOU END UP WANTING A PRESET FOR A CHEM THAT YOU DON'T WANT THE STATION TO ORDER.

// Helper macros, cause copying this same shit over and over is *painful*.
#define NEW_CHEM_CARTRIDGE_S(X) \
/obj/item/reagent_containers/chem_cartridge/small/X { \
	spawn_reagent = /datum/reagent/X \
}

#define NEW_CHEM_CARTRIDGE_M(X) \
/obj/item/reagent_containers/chem_cartridge/medium/X { \
	spawn_reagent = /datum/reagent/X \
}

#define NEW_CHEM_CARTRIDGE_L(X) \
/obj/item/reagent_containers/chem_cartridge/X { \
	spawn_reagent = /datum/reagent/X \
}

// Chem Dispenser
NEW_CHEM_CARTRIDGE_S(aluminium)
NEW_CHEM_CARTRIDGE_S(bromine)
NEW_CHEM_CARTRIDGE_M(carbon)
NEW_CHEM_CARTRIDGE_M(chlorine)
NEW_CHEM_CARTRIDGE_S(copper)
NEW_CHEM_CARTRIDGE_S(consumable/ethanol)
NEW_CHEM_CARTRIDGE_S(fluorine)
NEW_CHEM_CARTRIDGE_M(hydrogen)
NEW_CHEM_CARTRIDGE_S(iodine)
NEW_CHEM_CARTRIDGE_S(iron)
NEW_CHEM_CARTRIDGE_S(lithium)
NEW_CHEM_CARTRIDGE_S(mercury)
NEW_CHEM_CARTRIDGE_M(nitrogen)
NEW_CHEM_CARTRIDGE_M(oxygen)
NEW_CHEM_CARTRIDGE_S(phosphorus)
NEW_CHEM_CARTRIDGE_S(potassium)
NEW_CHEM_CARTRIDGE_S(uranium/radium)
NEW_CHEM_CARTRIDGE_S(silicon)
NEW_CHEM_CARTRIDGE_S(sodium)
NEW_CHEM_CARTRIDGE_S(stable_plasma)
NEW_CHEM_CARTRIDGE_S(consumable/sugar)
NEW_CHEM_CARTRIDGE_S(sulfur)
NEW_CHEM_CARTRIDGE_S(toxin/acid)
NEW_CHEM_CARTRIDGE_M(water)
NEW_CHEM_CARTRIDGE_M(fuel)

// Soft Drinks
NEW_CHEM_CARTRIDGE_M(consumable/coffee)
NEW_CHEM_CARTRIDGE_M(consumable/space_cola)
NEW_CHEM_CARTRIDGE_M(consumable/cream)
NEW_CHEM_CARTRIDGE_M(consumable/dr_gibb)
NEW_CHEM_CARTRIDGE_M(consumable/grenadine)
/obj/item/reagent_containers/chem_cartridge/medium/consumable/ice
	spawn_reagent = /datum/reagent/consumable/ice
	spawn_temperature = WATER_MATTERSTATE_CHANGE_TEMP
NEW_CHEM_CARTRIDGE_M(consumable/icetea)
NEW_CHEM_CARTRIDGE_M(consumable/lemonjuice)
NEW_CHEM_CARTRIDGE_M(consumable/lemon_lime)
NEW_CHEM_CARTRIDGE_M(consumable/limejuice)
NEW_CHEM_CARTRIDGE_M(consumable/menthol)
NEW_CHEM_CARTRIDGE_M(consumable/orangejuice)
NEW_CHEM_CARTRIDGE_M(consumable/pineapplejuice)
NEW_CHEM_CARTRIDGE_M(consumable/pwr_game)
NEW_CHEM_CARTRIDGE_M(consumable/shamblers)
NEW_CHEM_CARTRIDGE_M(consumable/spacemountainwind)
NEW_CHEM_CARTRIDGE_M(consumable/sodawater)
NEW_CHEM_CARTRIDGE_M(consumable/space_up)
NEW_CHEM_CARTRIDGE_M(consumable/sugar)
NEW_CHEM_CARTRIDGE_M(consumable/tea)
NEW_CHEM_CARTRIDGE_M(consumable/tomatojuice)
NEW_CHEM_CARTRIDGE_M(consumable/tonic)

// Alcohol
// Yes, this is all small by default. Alcohol is a premium product, soft drinks are not.
NEW_CHEM_CARTRIDGE_S(consumable/ethanol/absinthe)
NEW_CHEM_CARTRIDGE_S(consumable/ethanol/ale)
NEW_CHEM_CARTRIDGE_S(consumable/ethanol/applejack)
NEW_CHEM_CARTRIDGE_S(consumable/ethanol/beer)
NEW_CHEM_CARTRIDGE_S(consumable/ethanol/cognac)
NEW_CHEM_CARTRIDGE_S(consumable/ethanol/creme_de_cacao)
NEW_CHEM_CARTRIDGE_S(consumable/ethanol/creme_de_coconut)
NEW_CHEM_CARTRIDGE_S(consumable/ethanol/creme_de_menthe)
NEW_CHEM_CARTRIDGE_S(consumable/ethanol/curacao)
NEW_CHEM_CARTRIDGE_S(consumable/ethanol/gin)
NEW_CHEM_CARTRIDGE_S(consumable/ethanol/hcider)
NEW_CHEM_CARTRIDGE_S(consumable/ethanol/kahlua)
NEW_CHEM_CARTRIDGE_S(consumable/ethanol/beer/maltliquor)
NEW_CHEM_CARTRIDGE_S(consumable/ethanol/navy_rum)
NEW_CHEM_CARTRIDGE_S(consumable/ethanol/rum)
NEW_CHEM_CARTRIDGE_S(consumable/ethanol/sake)
NEW_CHEM_CARTRIDGE_S(consumable/ethanol/tequila)
NEW_CHEM_CARTRIDGE_S(consumable/ethanol/triple_sec)
NEW_CHEM_CARTRIDGE_S(consumable/ethanol/vermouth)
NEW_CHEM_CARTRIDGE_S(consumable/ethanol/vodka)
NEW_CHEM_CARTRIDGE_S(consumable/ethanol/whiskey)
NEW_CHEM_CARTRIDGE_S(consumable/ethanol/wine)

// Mutagen Dispenser
NEW_CHEM_CARTRIDGE_M(toxin/mutagen)

// Botanical Dispenser
NEW_CHEM_CARTRIDGE_M(saltpetre)
NEW_CHEM_CARTRIDGE_M(plantnutriment/eznutriment)
NEW_CHEM_CARTRIDGE_M(plantnutriment/left4zednutriment)
NEW_CHEM_CARTRIDGE_M(plantnutriment/robustharvestnutriment)
NEW_CHEM_CARTRIDGE_M(toxin/plantbgone)
NEW_CHEM_CARTRIDGE_M(toxin/plantbgone/weedkiller)
NEW_CHEM_CARTRIDGE_M(toxin/pestkiller)
NEW_CHEM_CARTRIDGE_M(medicine/cryoxadone)
NEW_CHEM_CARTRIDGE_M(ammonia)
NEW_CHEM_CARTRIDGE_M(ash)
NEW_CHEM_CARTRIDGE_M(diethylamine)

/// Exploration drone unlockables ///

/datum/supply_pack/exploration
	special = TRUE
	group = "Outsourced"

/datum/supply_pack/exploration/scrapyard
	name = "Scrapyard Crate"
	desc = "Outsourced crate containing various junk."
	cost = CARGO_CRATE_VALUE * 5
	contains = list(/obj/item/relic,
					/obj/item/broken_bottle,
					/obj/item/pickaxe/rusted)
	container_name = "scrapyard crate"

/datum/supply_pack/exploration/catering
	name = "Catering Crate"
	desc = "No cook? No problem! Food quality may vary depending on provider."
	cost = CARGO_CRATE_VALUE * 5
	contains = list(/obj/item/food/sandwich,
					/obj/item/food/sandwich,
					/obj/item/food/sandwich,
					/obj/item/food/sandwich,
					/obj/item/food/sandwich)
	container_name = "outsourced food crate"

/datum/supply_pack/exploration/catering/fill(obj/C)
	. = ..()
	if(prob(30))
		for(var/obj/item/food/F in C)
			F.name = "spoiled [F.name]"
			F.foodtypes |= GROSS
			F.MakeEdible()

/datum/supply_pack/exploration/shrubbery
	name = "Shrubbery Crate"
	desc = "Crate full of hedge shrubs."
	cost = CARGO_CRATE_VALUE * 5
	container_name = "shrubbery crate"
	var/shrub_amount = 8

/datum/supply_pack/exploration/shrubbery/fill(obj/C)
	for(var/i in 1 to shrub_amount)
		new /obj/item/grown/shrub(C)

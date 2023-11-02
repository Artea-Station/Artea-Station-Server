/datum/supply_pack/galactic_imports/medical
	group = "Medical"

/datum/supply_pack/galactic_imports/medical/large_dispenser
	name = "Large Chem Dispenser Board"
	desc = "Contains a single chem dispenser board."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/obj/item/circuitboard/machine/chem_dispenser/big)

/datum/supply_pack/galactic_imports/medical/emergency_kit
	name = "Emergency Treatment Kit"
	desc = "Contains one advanced medkit, one regular medkit, one surgical medkit, and one of each specialized kit."
	cost = CARGO_CRATE_VALUE * 16
	contains = list(
		/obj/item/storage/medkit/advanced,
		/obj/item/storage/medkit/emergency,
		/obj/item/storage/medkit/surgery,
		/obj/item/storage/medkit/fire,
		/obj/item/storage/medkit/brute,
		/obj/item/storage/medkit/toxin,
		/obj/item/storage/medkit/o2,
	)

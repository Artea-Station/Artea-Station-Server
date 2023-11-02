/datum/supply_pack/galactic_imports/materials
    category = "Materials"

/datum/supply_pack/galactic_imports/materials/iron
	name = "50x Iron"
	desc = "Contains 50 iron sheets."
	cost = CARGO_CRATE_VALUE
	contains = list(/obj/item/stack/sheet/iron/fifty)

/datum/supply_pack/galactic_imports/materials/iron/hundred
	name = "100x Iron"
	desc = "Contains 100 iron sheets."
	cost = CARGO_CRATE_VALUE * 1.9
	contains = list(/obj/item/stack/sheet/iron/fifty, /obj/item/stack/sheet/iron/fifty)

/datum/supply_pack/galactic_imports/materials/glass
	name = "50x Glass"
	desc = "Contains 50 glass sheets."
	cost = CARGO_CRATE_VALUE
	contains = list(/obj/item/stack/sheet/glass/fifty)

/datum/supply_pack/galactic_imports/materials/glass/hundred
	name = "100x Glass"
	desc = "Contains 100 glass sheets."
	cost = CARGO_CRATE_VALUE * 1.9
	contains = list(/obj/item/stack/sheet/glass/fifty, /obj/item/stack/sheet/glass/fifty)

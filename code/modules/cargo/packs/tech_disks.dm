/datum/supply_pack/tech_disk
	group = TRADER_GROUP_TECH_DISKS
	default_stock = -1

/datum/supply_pack/tech_disk/major
	name = "Random Middle Tech Disk"
	desc = "Contains a single minor tech disk. What does it contain? No one knows!"
	cost = CARGO_CRATE_VALUE * 3.4
	contains = list(/obj/item/disk/tech_disk/research/major)

/datum/supply_pack/tech_disk/middle
	name = "Random Middle Tech Disk"
	desc = "Contains a single minor tech disk. What does it contain? No one knows!"
	cost = CARGO_CRATE_VALUE * 2.2
	contains = list(/obj/item/disk/tech_disk/research/middle)

/datum/supply_pack/tech_disk/minor
	name = "Random Minor Tech Disk"
	desc = "Contains a single minor tech disk. What does it contain? No one knows!"
	contains = list(/obj/item/disk/tech_disk/research/minor)

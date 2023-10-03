/obj/structure/closet/secure_closet/pathfinders_tools
	name = "Pathfinders Tool Locker"
	desc = "Filled with tools that'd prove helpful for shuttle repairs and retrofitting."
	req_access = list(ACCESS_PATHFINDERS_HIGHSEC)
	icon_state = "science"
	icon_door = "science"

/obj/structure/closet/secure_closet/pathfinders_tools/PopulateContents()
	..()
	var/static/items_inside = list(
		/obj/item/storage/toolbox/mechanical = 2,
		/obj/item/multitool = 2,
		/obj/item/pipe_dispenser = 1,
		/obj/item/airlock_painter = 1,
		/obj/item/pipe_painter = 1,
		/obj/item/stack/sheet/iron/fifty = 1,
	)
	generate_items_inside(items_inside,src)

/obj/structure/closet/secure_closet/pathfinders_materials
	name = "Pathfinders Emergency Materials Locker"
	desc = "You feel like you really should take some of what's inside with you onto the shuttle."
	req_access = list(ACCESS_PATHFINDERS_HIGHSEC)
	icon_state = "science"
	icon_door = "science"

/obj/structure/closet/secure_closet/pathfinders_materials/PopulateContents()
	..()
	var/static/items_inside = list(
		/obj/item/circuitboard/computer/pathfinders_shuttle = 1,
		/obj/item/inducer = 2,
		/obj/item/stock_parts/cell/high = 2,
		/obj/item/storage/box/stockparts/basic = 2,
	)
	generate_items_inside(items_inside,src)

/obj/item/storage/bag/garment/lead_pathfinder
	name = "lead pathfinder's garment bag"
	desc = "A bag for storing extra clothes and shoes. This one belongs to the lead pathfinder."

/obj/item/storage/bag/garment/lead_pathfinder/PopulateContents()
	new /obj/item/clothing/under/rank/pathfinder(src)
	new /obj/item/clothing/under/rank/pathfinder/skirt(src)
	new /obj/item/clothing/gloves/color/black(src)
	new /obj/item/clothing/shoes/sneakers/purple(src)
	new /obj/item/clothing/suit/hooded/wintercoat/science/rd(src)

/obj/item/storage/photo_album/pl
	name = "photo album (Lead Pathfinder)"
	icon_state = "album_purple"
	persistence_id = "PL"

/obj/item/storage/lockbox/medal/pl
	name = "Lead Pathfinder medal box"
	desc = "A locked box used to store medals to be given to those exhibiting excellence in pathfinding."
	req_access = list(ACCESS_PATHFINDERS_LEAD)

/obj/item/storage/lockbox/medal/pl/PopulateContents()
	for(var/i in 1 to 2)
		new /obj/item/clothing/accessory/medal/silver/pathfinding(src)

/obj/item/clothing/accessory/medal/silver/pathfinding
	name = "\improper Robust Pathfinder Medal"
	desc = "Awarded for standing out to the lead pathfinder."

/obj/structure/closet/secure_closet/lead_pathfinder
	name = "\proper lead pathfinder's locker"
	req_access = list(ACCESS_PATHFINDERS_LEAD)
	icon_state = "rd"

/obj/structure/closet/secure_closet/lead_pathfinder/PopulateContents()
	..()

	new /obj/item/storage/bag/garment/lead_pathfinder(src)
	new /obj/item/radio/headset/heads/pl(src)
	new /obj/item/megaphone/command(src)
	new /obj/item/storage/medkit/pathfinder(src)
	new /obj/item/healthanalyzer(src)
	new /obj/item/assembly/flash/handheld(src)
	new /obj/item/door_remote/pathfinders(src)
	new /obj/item/clothing/neck/petcollar(src)
	new /obj/item/pet_carrier(src)
	new /obj/item/gun/energy/e_gun/mini(src)
	new /obj/item/circuitboard/machine/techfab/department/pathfinders(src)
	new /obj/item/storage/photo_album/pl(src)
	new /obj/item/storage/lockbox/medal/pl(src)

/obj/structure/closet/secure_closet/pathfinder_weapons
	name = "\proper pathfinder's weapons locker"
	req_access = list(ACCESS_PATHFINDERS_HIGHSEC)
	icon_state = "armory"

/obj/structure/closet/secure_closet/pathfinder_weapons/PopulateContents()
	..()

	new /obj/item/gun/energy/laser(src)
	new /obj/item/clothing/suit/armor/vest(src)
	new /obj/item/flashlight(src)

/obj/structure/closet/secure_closet/pathfinders_ballistic
	name = "\proper pathfinder's ballistics locker"
	req_access = list(ACCESS_PATHFINDERS_LEAD)
	icon_state = "tac"

/obj/structure/closet/secure_closet/pathfinders_ballistic/PopulateContents()
	..()

	new /obj/item/gun/ballistic/automatic/pistol(src)
	new /obj/item/ammo_box/magazine/m9mm(src)
	new /obj/item/ammo_box/magazine/m9mm(src)
	new /obj/item/flashlight(src)

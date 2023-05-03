/obj/structure/closet/secure_closet/pathfinders_tools
	name = "Pathfinders Tool Locker"
	desc = "Filled with tools that'd prove helpful for shuttle repairs and retrofitting."
	req_access = list(ACCESS_PATHFINDERS_STORAGE)
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
	req_access = list(ACCESS_PATHFINDERS_STORAGE)
	icon_state = "science"
	icon_door = "science"

/obj/structure/closet/secure_closet/pathfinders_materials/PopulateContents()
	..()
	var/static/items_inside = list(
		/obj/item/circuitboard/computer/pathfinders_shuttle = 1,
		/obj/item/inducer = 2,
		/obj/item/stock_parts/cell/high = 2,
		/obj/item/storage/box/stockparts = 2,
	)
	generate_items_inside(items_inside,src)

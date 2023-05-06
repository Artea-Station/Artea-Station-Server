////////////////////////////////////////
//////////////////Power/////////////////
////////////////////////////////////////

/datum/design/basic_cell
	name = "Basic Power Cell"
	desc = "A basic power cell that holds 1 MJ of energy."
	id = "basic_cell"
	build_type = PROTOLATHE | AWAY_LATHE | AUTOLATHE |MECHFAB
	materials = list(/datum/material/iron = 1500, /datum/material/glass = 1500)
	construction_time=100
	build_path = /obj/item/stock_parts/cell/empty
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_1
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/high_cell
	name = "High-Capacity Power Cell"
	desc = "A power cell that holds 10 MJ of energy."
	id = "high_cell"
	build_type = PROTOLATHE | AWAY_LATHE | AUTOLATHE | MECHFAB
	materials = list(/datum/material/iron = 2000, /datum/material/glass = 2000, /datum/material/silver = 1000)
	construction_time=100
	build_path = /obj/item/stock_parts/cell/high/empty
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_2
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/super_cell
	name = "Super-Capacity Power Cell"
	desc = "A power cell that holds 20 MJ of energy."
	id = "super_cell"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	materials = list(/datum/material/iron = 2500, /datum/material/glass = 2500, /datum/material/gold = 1000)
	construction_time=100
	build_path = /obj/item/stock_parts/cell/super/empty
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_3
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/hyper_cell
	name = "Hyper-Capacity Power Cell"
	desc = "A power cell that holds 30 MJ of energy."
	id = "hyper_cell"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	materials = list(/datum/material/iron = 3000, /datum/material/glass = 3000, /datum/material/gold = 1000, /datum/material/silver = 1000, /datum/material/plasma = 3000) // Stronk cell requires stronk resources.
	construction_time=100
	build_path = /obj/item/stock_parts/cell/hyper/empty
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_3
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/inducer
	name = "Inducer"
	desc = "The NT-75 Electromagnetic Power Inducer can wirelessly induce electric charge in an object, allowing you to recharge power cells without having to remove them. Despite the rumors, there is no microwave transformer inside."
	id = "inducer"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = 3000, /datum/material/glass = 1000)
	build_path = /obj/item/inducer/sci
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/pacman
	name = "PACMAN Board"
	desc = "The circuit board for a PACMAN-type portable generator."
	id = "pacman"
	build_path = /obj/item/circuitboard/machine/pacman
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/turbine_part_compressor
	name = "Turbine Compressor"
	desc = "The basic tier of a compressor blade."
	id = "turbine_part_compressor"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 500)
	construction_time = 100
	build_path = /obj/item/turbine_parts/compressor
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_TURBINE
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/turbine_part_rotor
	name = "Turbine Rotor"
	desc = "The basic tier of a rotor shaft."
	id = "turbine_part_rotor"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 500)
	construction_time = 100
	build_path = /obj/item/turbine_parts/rotor
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_TURBINE
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/turbine_part_stator
	name = "Turbine Stator"
	desc = "The basic tier of a stator."
	id = "turbine_part_stator"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 500)
	construction_time = 100
	build_path = /obj/item/turbine_parts/stator
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_TURBINE
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

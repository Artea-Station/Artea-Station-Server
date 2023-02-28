//Modelled after the 5x7 mining shuttles
/obj/docking_port/stationary/small
	name = "small dock"
	shuttle_id = "smalldock"
	width = 7
	dwidth = 3
	height = 5

/obj/docking_port/stationary/medium
	name = "medium dock"
	shuttle_id = "mediumdock"
	width = 17
	dwidth = 8
	height = 13

//Modelled after boxstation whiteship, with 1 extra margin in width and in dwidth, and 2 height
/obj/docking_port/stationary/large
	name = "large dock"
	shuttle_id = "largedock"
	width = 31
	dwidth = 8
	height = 19

//Modelled after the SS13 standard auxilliary dock
/obj/docking_port/stationary/huge
	name = "huge dock"
	shuttle_id = "hugedock"
	width = 35
	dwidth = 11
	height = 22

/obj/machinery/computer/shuttle/common_docks
	circuit = /obj/item/circuitboard/computer/shuttle_common_docks
	possible_destinations = "mediumdock;largedock;hugedock;smalldock"

/obj/item/circuitboard/computer/shuttle_common_docks
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/computer/shuttle/common_docks

/datum/map_template/shuttle/common
	port_id = "common"
	who_can_purchase = null

/datum/map_template/shuttle/common/vulture
	suffix = "vulture"
	name = "MS Vulture"

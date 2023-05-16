// The stuff for the pathfinders shuttle.
/obj/item/circuitboard/computer/pathfinders_shuttle
	name = "Pathfinders Shuttle"
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/computer/shuttle/pathfinders_shuttle

/obj/machinery/computer/shuttle/pathfinders_shuttle
	name = "pathfinders shuttle console"
	desc = "Used to control the pathfinders shuttle. If you're seeing this, your shuttle got blown up, or you're looking at the spare."
	circuit = /obj/item/circuitboard/computer/pathfinders_shuttle
	shuttleId = "pathfinders"
	possible_destinations = "pathfinders_home;hugedock;largedock;mediumdock"
	no_destination_swap = TRUE

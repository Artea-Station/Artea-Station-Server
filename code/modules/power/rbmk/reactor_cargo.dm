/obj/machinery/atmospherics/components/trinary/nuclear_reactor/cargo/New()
	. = ..()
	id = rand(1, 9999999) // cmon, what are the chances? The chances are... Very low friend... But maybe we can make this a bit better.

// Cargo variants can be wrenched down and don't start linked to the default RMBK reactor

/obj/machinery/computer/reactor/control_rods/cargo
	anchored = FALSE
	id = null

/obj/machinery/computer/reactor/stats/cargo
	anchored = FALSE
	id = null

/obj/machinery/computer/reactor/fuel_rods/cargo
	anchored = FALSE
	id = null

/obj/item/paper/fluff/rbmkcargo
	name = "Nuclear Reactor Instructions"
	default_raw_text = "Make sure a 5x5 area is completely clear of pipes, cables and machinery when using the beacon. Those will be provided automatically with the beacon's bluespace decompression. Use a multitool on the reactor then on the computers provided to link them together. Also make sure the reactor has a proper pipeline filled with cooling gas before inserting fuel rods. Good luck!"

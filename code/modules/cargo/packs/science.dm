//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Science /////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/science
	group = "Science"
	access_view = ACCESS_RESEARCH
	container_type = /obj/structure/closet/crate/science

/datum/supply_pack/science/plasma
	name = "Plasma Assembly Crate"
	desc = "Everything you need to burn something to the ground, this contains three plasma assembly sets. Each set contains a plasma tank, igniter, proximity sensor, and timer! Warranty void if exposed to high temperatures. Requires Ordnance access to open."
	cost = CARGO_CRATE_VALUE * 2
	access = ACCESS_ORDNANCE
	access_view = ACCESS_ORDNANCE
	contains = list(/obj/item/tank/internals/plasma,
					/obj/item/tank/internals/plasma,
					/obj/item/tank/internals/plasma,
					/obj/item/assembly/igniter,
					/obj/item/assembly/igniter,
					/obj/item/assembly/igniter,
					/obj/item/assembly/prox_sensor,
					/obj/item/assembly/prox_sensor,
					/obj/item/assembly/prox_sensor,
					/obj/item/assembly/timer,
					/obj/item/assembly/timer,
					/obj/item/assembly/timer)
	container_name = "plasma assembly crate"
	container_type = /obj/structure/closet/crate/secure/plasma

/datum/supply_pack/science/raw_flux_anomaly
	name = "Raw Flux Anomaly"
	desc = "The raw core of a flux anomaly, ready to be implosion-compressed into a powerful artifact."
	cost = CARGO_CRATE_VALUE * 10
	access = ACCESS_ORDNANCE
	access_view = ACCESS_ORDNANCE
	contains = list(/obj/item/raw_anomaly_core/flux)
	container_name = "raw flux anomaly"
	container_type = /obj/structure/closet/crate/secure/science

/datum/supply_pack/science/raw_hallucination_anomaly
	name = "Raw Hallucination Anomaly"
	desc = "The raw core of a hallucination anomaly, ready to be implosion-compressed into a powerful artifact."
	cost = CARGO_CRATE_VALUE * 10
	access = ACCESS_ORDNANCE
	access_view = ACCESS_ORDNANCE
	contains = list(/obj/item/raw_anomaly_core/hallucination)
	container_name = "raw hallucination anomaly"
	container_type = /obj/structure/closet/crate/secure/science

/datum/supply_pack/science/raw_grav_anomaly
	name = "Raw Gravitational Anomaly"
	desc = "The raw core of a gravitational anomaly, ready to be implosion-compressed into a powerful artifact."
	cost = CARGO_CRATE_VALUE * 10
	access = ACCESS_ORDNANCE
	access_view = ACCESS_ORDNANCE
	contains = list(/obj/item/raw_anomaly_core/grav)
	container_name = "raw gravitational anomaly"
	container_type = /obj/structure/closet/crate/secure/science

/datum/supply_pack/science/raw_vortex_anomaly
	name = "Raw Vortex Anomaly"
	desc = "The raw core of a vortex anomaly, ready to be implosion-compressed into a powerful artifact."
	cost = CARGO_CRATE_VALUE * 10
	access = ACCESS_ORDNANCE
	access_view = ACCESS_ORDNANCE
	contains = list(/obj/item/raw_anomaly_core/vortex)
	container_name = "raw vortex anomaly"
	container_type = /obj/structure/closet/crate/secure/science

/datum/supply_pack/science/raw_bluespace_anomaly
	name = "Raw Bluespace Anomaly"
	desc = "The raw core of a bluespace anomaly, ready to be implosion-compressed into a powerful artifact."
	cost = CARGO_CRATE_VALUE * 10
	access = ACCESS_ORDNANCE
	access_view = ACCESS_ORDNANCE
	contains = list(/obj/item/raw_anomaly_core/bluespace)
	container_name = "raw bluespace anomaly"
	container_type = /obj/structure/closet/crate/secure/science

/datum/supply_pack/science/raw_pyro_anomaly
	name = "Raw Pyro Anomaly"
	desc = "The raw core of a pyro anomaly, ready to be implosion-compressed into a powerful artifact."
	cost = CARGO_CRATE_VALUE * 10
	access = ACCESS_ORDNANCE
	access_view = ACCESS_ORDNANCE
	contains = list(/obj/item/raw_anomaly_core/pyro)
	container_name = "raw pyro anomaly"
	container_type = /obj/structure/closet/crate/secure/science

/datum/supply_pack/science/raw_bioscrambler_anomaly
	name = "Raw Bioscrambler Anomaly"
	desc = "The raw core of a bioscrambler anomaly, ready to be implosion-compressed into a powerful artifact."
	cost = CARGO_CRATE_VALUE * 10
	access = ACCESS_ORDNANCE
	access_view = ACCESS_ORDNANCE
	contains = list(/obj/item/raw_anomaly_core/bioscrambler)
	container_name = "raw bioscrambler anomaly"
	container_type = /obj/structure/closet/crate/secure/science


/datum/supply_pack/science/robotics
	name = "Robotics Assembly Crate"
	desc = "The tools you need to replace those finicky humans with a loyal robot army! Contains four proximity sensors, two empty first aid kits, two health analyzers, two red hardhats, two mechanical toolboxes, and two cleanbot assemblies! Requires Robotics access to open."
	cost = CARGO_CRATE_VALUE * 3
	access = ACCESS_ROBOTICS
	access_view = ACCESS_ROBOTICS
	contains = list(/obj/item/assembly/prox_sensor,
					/obj/item/assembly/prox_sensor,
					/obj/item/assembly/prox_sensor,
					/obj/item/assembly/prox_sensor,
					/obj/item/storage/medkit,
					/obj/item/storage/medkit,
					/obj/item/healthanalyzer,
					/obj/item/healthanalyzer,
					/obj/item/clothing/head/hardhat/red,
					/obj/item/clothing/head/hardhat/red,
					/obj/item/storage/toolbox/mechanical,
					/obj/item/storage/toolbox/mechanical,
					/obj/item/bot_assembly/cleanbot,
					/obj/item/bot_assembly/cleanbot)
	container_name = "robotics assembly crate"
	container_type = /obj/structure/closet/crate/secure/science

/datum/supply_pack/science/rped
	name = "RPED crate"
	desc = "Need to rebuild the ORM but science got annihialted after a bomb test? Buy this for the most advanced parts NT can give you."
	cost = CARGO_CRATE_VALUE * 3
	access_view = FALSE
	contains = list(/obj/item/storage/part_replacer/cargo)
	container_name = "\improper RPED crate"

/datum/supply_pack/science/shieldwalls
	name = "Shield Generator Crate"
	desc = "These high powered Shield Wall Generators are guaranteed to keep any unwanted lifeforms on the outside, where they belong! Contains four shield wall generators. Requires Teleporter access to open."
	cost = CARGO_CRATE_VALUE * 4
	access = ACCESS_TELEPORTER
	access_view = ACCESS_TELEPORTER
	contains = list(/obj/machinery/power/shieldwallgen,
					/obj/machinery/power/shieldwallgen,
					/obj/machinery/power/shieldwallgen,
					/obj/machinery/power/shieldwallgen)
	container_name = "shield generators crate"
	container_type = /obj/structure/closet/crate/secure/science

/datum/supply_pack/science/transfer_valves
	name = "Tank Transfer Valves Crate"
	desc = "The key ingredient for making a lot of people very angry very fast. Contains two tank transfer valves. Requires RD access to open."
	cost = CARGO_CRATE_VALUE * 12
	access = ACCESS_CE
	contains = list(/obj/item/transfer_valve,
					/obj/item/transfer_valve)
	container_name = "tank transfer valves crate"
	container_type = /obj/structure/closet/crate/secure/science
	dangerous = TRUE

/datum/supply_pack/science/monkey_helmets
	name = "Monkey Mind Magnification Helmet crate"
	desc = "Some research is best done with monkeys, yet sometimes they're just too dumb to complete more complicated tasks. These helmets should help."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/clothing/head/helmet/monkey_sentience,
					/obj/item/clothing/head/helmet/monkey_sentience)
	container_name = "monkey mind magnification crate"

/datum/supply_pack/science/cytology
	name = "Cytology supplies crate"
	desc = "Did out of control specimens pulverize xenobiology? Here is some more supplies for further testing."
	cost = CARGO_CRATE_VALUE * 3
	access_view = ACCESS_XENOBIOLOGY
	contains = list(
		/obj/structure/microscope,
		/obj/item/biopsy_tool,
		/obj/item/storage/box/petridish,
		/obj/item/storage/box/petridish,
		/obj/item/storage/box/swab,
	)
	container_name = "cytology supplies crate"

/datum/supply_pack/science/mod_core
	name = "MOD core Crate"
	desc = "Three cores, perfect for any MODsuit construction! Naturally harvested™, of course."
	cost = CARGO_CRATE_VALUE * 3
	access = ACCESS_ROBOTICS
	access_view = ACCESS_ROBOTICS
	contains = list(/obj/item/mod/core/standard,
		/obj/item/mod/core/standard,
		/obj/item/mod/core/standard)
	container_name = "\improper MOD core crate"
	container_type = /obj/structure/closet/crate/secure/science

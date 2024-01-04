// Hey! Listen! Update \config\lavaruinblacklist.txt with your new ruins!

/datum/map_template/ruin/planet
	ruin_type = ZTRAIT_PLANET_RUINS
	prefix = "_maps/RandomRuins/PlanetRuins/"
	default_area = /area/planet/barren

/datum/map_template/ruin/planet/engioutpost
	name = "Engineer Outpost"
	id = "engioutpost"
	description = "Blown up by an unfortunate accident."
	suffix = "planet_ruin_engioutpost.dmm"
	cost = 10
	allow_duplicates = FALSE

/datum/map_template/ruin/planet/crashedshuttle
	name = "Crashed Shuttle"
	id = "crashedshuttle"
	description = "A shuttle that met an unfortunate end on a planet."
	suffix = "planet_ruin_crashedshuttle.dmm"
	cost = 10
	allow_duplicates = FALSE

/datum/map_template/ruin/planet/mining_facility
	name = "Mining Facility"
	id = "miningfacility"
	description = "An old mining facility, long abandoned and forgotten, its crew left to an unfortunate fate."
	suffix = "planet_ruin_mining_facility.dmm"
	cost = 10
	allow_duplicates = FALSE

/*
DO NOT ADD THIS TO THE LIST, IT NEEDS MAPPING WORK DONE ON IT!!!!
/datum/map_template/ruin/planet/plasma_facility
	name = "Abandoned Plasma Facility"
	id = "plasma_facility"
	description = "Rumors have developed over the many years of Freyja plasma mining. These rumors suggest that the ghosts of dead mistreated excavation staff have returned to \
	exact revenge on their (now former) employers. Coorperate reminds all staff that rumors are just that: Old Housewife tales meant to scare misbehaving kids to bed."
	suffix = "planet_ruin_abandoned_plasma_facility.dmm"
	cost = 20
*/

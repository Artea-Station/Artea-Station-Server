/// Planetary Areas
/area/planet
	icon = 'icons/area/areas_planet.dmi'
	icon_state = "planet"
	has_gravity = STANDARD_GRAVITY
	flags_1 = NONE
	area_flags = VALID_TERRITORY | UNIQUE_AREA | CAVES_ALLOWED | FLORA_ALLOWED | MOB_SPAWN_ALLOWED | MEGAFAUNA_SPAWN_ALLOWED | NO_ALERTS
	ambience_index = AMBIENCE_AWAY
	outdoors = TRUE

/*
Planetary Ruin areas
*/
/area/planet/ruin
	name = "Planetary ruin"
	icon_state = "planet_ruin"
	ambience_index = AMBIENCE_AWAY
	area_flags = VALID_TERRITORY | UNIQUE_AREA

/area/planet/ruin/engi_outpost
	name = "\improper Engineering Outpost"

/area/planet/ruin/crashed_shuttle
	name = "\improper Crashed Shuttle"

/*
Barren planet areas
*/
/area/planet/barren
	name = "Barren Planet Surface"
	icon_state = "planet_barren"
	ambientsounds = list(
		'sound/effects/wind/wind1.ogg',
		'sound/effects/wind/wind2.ogg',
		'sound/effects/wind/wind3.ogg',
		'sound/effects/wind/wind4.ogg',
		'sound/effects/wind/wind5.ogg',
		'sound/effects/wind/wind6.ogg',
	)
	min_ambience_cooldown = 12 SECONDS
	max_ambience_cooldown = 30 SECONDS

/*
Chlorine planet areas
*/
/area/planet/chlorine
	name = "Chlorine Planet Surface"
	icon_state = "planet_chlorine"
	ambientsounds = list(
		'sound/effects/wind/desert0.ogg',
		'sound/effects/wind/desert1.ogg',
		'sound/effects/wind/desert2.ogg',
		'sound/effects/wind/desert3.ogg',
		'sound/effects/wind/desert4.ogg',
		'sound/effects/wind/desert5.ogg',
	)

/*
Desert planet areas
*/
/area/planet/desert
	name = "Desert Planet Surface"
	icon_state = "planet_desert"
	ambientsounds = list(
		'sound/effects/wind/desert0.ogg',
		'sound/effects/wind/desert1.ogg',
		'sound/effects/wind/desert2.ogg',
		'sound/effects/wind/desert3.ogg',
		'sound/effects/wind/desert4.ogg',
		'sound/effects/wind/desert5.ogg',
	)

/*
Jungle planet areas
*/
/area/planet/jungle
	name = "Jungle Planet Surface"
	icon_state = "planet_jungle"
	ambientsounds = list(
		'sound/ambience/jungle.ogg',
		'sound/ambience/eeriejungle1.ogg',
		'sound/ambience/eeriejungle2.ogg',
	)
	min_ambience_cooldown = 2 MINUTES
	max_ambience_cooldown = 3 MINUTES

/*
Lush planet areas
*/
/area/planet/lush
	name = "Lush Planet Surface"
	icon_state = "planet_lush"
	ambientsounds = list(
		'sound/effects/wind/wind1.ogg',
		'sound/effects/wind/wind2.ogg',
		'sound/effects/wind/wind3.ogg',
		'sound/effects/wind/wind4.ogg',
		'sound/effects/wind/wind5.ogg',
		'sound/effects/wind/wind6.ogg',
	)
	min_ambience_cooldown = 12 SECONDS
	max_ambience_cooldown = 30 SECONDS

/*
Shrouded planet areas
*/
/area/planet/shrouded
	name = "Shrouded Planet Surface"
	icon_state = "planet_shroud"
	ambientsounds = list(
		"sound/ambience/spookyspace1.ogg",
		"sound/ambience/spookyspace2.ogg",
	)
	min_ambience_cooldown = 2 MINUTES
	max_ambience_cooldown = 4 MINUTES

/*
Snow planet areas
*/
/area/planet/snow
	name = "Snow Planet Surface"
	icon_state = "planet_snow"
	ambientsounds = list(
		'sound/effects/wind/tundra0.ogg',
		'sound/effects/wind/tundra1.ogg',
		'sound/effects/wind/tundra2.ogg',
		'sound/effects/wind/spooky0.ogg',
		'sound/effects/wind/spooky1.ogg',
	)

/*
volcanic planet areas
*/
/area/planet/volcanic
	name = "Volcanic Planet Surface"
	icon_state = "planet_volcanic"
	ambientsounds = list('sound/ambience/magma.ogg')
	min_ambience_cooldown = 2 MINUTES
	max_ambience_cooldown = 4 MINUTES


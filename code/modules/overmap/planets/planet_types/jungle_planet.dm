/datum/planet_template/jungle_planet
	name = "Jungle Planet"
	area_type = /area/planet/jungle
	generator_type = /datum/map_generator/planet_gen/jungle

	default_traits_input = list(ZTRAIT_MINING = TRUE, ZTRAIT_BASETURF = /turf/open/lava/smooth/lava_land_surface)
	overmap_type = /datum/overmap_object/shuttle/planet/jungle
	atmosphere_type = /datum/atmosphere/jungle
	weather_controller_type = /datum/weather_controller/lush

	rock_color = list(COLOR_BEIGE_GRAYISH, COLOR_BEIGE, COLOR_ASTEROID_ROCK)
	plant_color = list(COLOR_PALE_BTL_GREEN)
	plant_color_as_grass = TRUE

/datum/overmap_object/shuttle/planet/jungle
	name = "Jungle Planet"
	planet_color = COLOR_PALE_BTL_GREEN

/area/planet/jungle
	name = "Jungle Planet Surface"
	ambientsounds = list(
		'sound/ambience/jungle.ogg',
		'sound/ambience/eeriejungle1.ogg',
		'sound/ambience/eeriejungle2.ogg',
	)
	min_ambience_cooldown = 2 MINUTES
	max_ambience_cooldown = 3 MINUTES

/datum/map_generator/planet_gen/jungle
	possible_biomes = list(
	BIOME_LOW_HEAT = list(
		BIOME_LOW_HUMIDITY = /datum/biome/plains,
		BIOME_LOWMEDIUM_HUMIDITY = /datum/biome/mudlands,
		BIOME_HIGHMEDIUM_HUMIDITY = /datum/biome/mudlands,
		BIOME_HIGH_HUMIDITY = /datum/biome/water,
		),
	BIOME_LOWMEDIUM_HEAT = list(
		BIOME_LOW_HUMIDITY = /datum/biome/plains,
		BIOME_LOWMEDIUM_HUMIDITY = /datum/biome/jungle,
		BIOME_HIGHMEDIUM_HUMIDITY = /datum/biome/jungle,
		BIOME_HIGH_HUMIDITY = /datum/biome/mudlands,
		),
	BIOME_HIGHMEDIUM_HEAT = list(
		BIOME_LOW_HUMIDITY = /datum/biome/plains,
		BIOME_LOWMEDIUM_HUMIDITY = /datum/biome/plains,
		BIOME_HIGHMEDIUM_HUMIDITY = /datum/biome/jungle/deep,
		BIOME_HIGH_HUMIDITY = /datum/biome/jungle,
		),
	BIOME_HIGH_HEAT = list(
		BIOME_LOW_HUMIDITY = /datum/biome/wasteland,
		BIOME_LOWMEDIUM_HUMIDITY = /datum/biome/plains,
		BIOME_HIGHMEDIUM_HUMIDITY = /datum/biome/jungle,
		BIOME_HIGH_HUMIDITY = /datum/biome/jungle/deep,
		),
	)
	high_height_biome = /datum/biome/mountain
	perlin_zoom = 65

/datum/biome/mudlands
	turf_type = /turf/open/misc/dirt/jungle/dark
	flora_types = list(
		/obj/structure/flora/grass/jungle,
		/obj/structure/flora/grass/jungle/b/style_random,
		/obj/structure/flora/rock/pile/jungle,
		/obj/structure/flora/rock/pile/jungle/large,
	)
	flora_density = 3

/datum/biome/plains
	turf_type = /turf/open/misc/grass/jungle
	flora_types = list(
		/obj/structure/flora/grass/jungle,
		/obj/structure/flora/grass/jungle/b/style_random,
		/obj/structure/flora/tree/jungle/style_random,
		/obj/structure/flora/rock/pile/jungle/style_random,
		/obj/structure/flora/bush/jungle,
		/obj/structure/flora/bush/jungle/b/style_random,
		/obj/structure/flora/bush/jungle/c/style_random,
		/obj/structure/flora/bush/large/style_random,
		/obj/structure/flora/rock/pile/jungle/large/style_random,
	)
	flora_density = 15

/datum/biome/jungle
	turf_type = /turf/open/misc/grass/jungle
	flora_types = list(
		/obj/structure/flora/grass/jungle,
		/obj/structure/flora/grass/jungle/b/style_random,
		/obj/structure/flora/tree/jungle/style_random,
		/obj/structure/flora/rock/pile/jungle/style_random,
		/obj/structure/flora/bush/jungle,
		/obj/structure/flora/bush/jungle/b/style_random,
		/obj/structure/flora/bush/jungle/c/style_random,
		/obj/structure/flora/bush/large/style_random,
		/obj/structure/flora/rock/pile/jungle/large/style_random,
	)
	flora_density = 40
	fauna_density = 0.5
	fauna_weight_types = list(
		/mob/living/simple_animal/hostile/jungle/leaper = 100,
		/mob/living/simple_animal/hostile/jungle/mega_arachnid = 100,
		/mob/living/simple_animal/hostile/jungle/mook = 100,
		/mob/living/simple_animal/hostile/jungle/seedling = 100,
	)

/datum/biome/jungle/deep
	flora_density = 65
	fauna_density = 0.5
	fauna_weight_types = list(
		/mob/living/simple_animal/hostile/jungle/leaper = 100,
		/mob/living/simple_animal/hostile/jungle/mega_arachnid = 100,
		/mob/living/simple_animal/hostile/jungle/mook = 100,
		/mob/living/simple_animal/hostile/jungle/seedling = 100,
	)

/datum/biome/wasteland
	turf_type = /turf/open/misc/dirt/jungle/wasteland

/datum/atmosphere/jungle
	base_gases = list(
		GAS_NITROGEN=80,
		GAS_OXYGEN=20,
	)
	normal_gases = list(
		GAS_OXYGEN=5,
		GAS_NITROGEN=5,
		GAS_CO2=2,
	)
	restricted_chance = 0

	minimum_pressure = ONE_ATMOSPHERE
	maximum_pressure = ONE_ATMOSPHERE + 20

	minimum_temp = T20C + 20
	maximum_temp = T20C + 40

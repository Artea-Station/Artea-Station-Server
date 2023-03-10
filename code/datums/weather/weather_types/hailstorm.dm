/datum/weather/hailstorm
	name = "hailstorm"
	desc = "Harsh hailstorm, battering the unfortunate who wound up in it."

	telegraph_message = "<span class='warning'>Dark clouds converge as drifting particles of snow begin to dust the surrounding area..</span>"
	telegraph_duration = 300
	telegraph_overlay = "snowfall_light"
	telegraph_skyblock = 0.2

	weather_message = "<span class='userdanger'><i>Hail starts to rain down from the sky! Seek shelter!</i></span>"
	weather_overlay = "hail"
	weather_duration_lower = 600
	weather_duration_upper = 1500
	weather_skyblock = 0.4

	end_duration = 100
	end_message = "<span class='boldannounce'>The hailstorm dies down, it should be safe to go outside again.</span>"
	end_skyblock = 0.4

	area_type = /area
	protect_indoors = TRUE

	immunity_type = "snow"

	barometer_predictable = TRUE
	affects_underground = FALSE
	thunder_chance = 4

	sound_active_outside = /datum/looping_sound/weather/wind/indoors
	sound_active_inside = /datum/looping_sound/weather/wind
	sound_weak_outside = /datum/looping_sound/weather/wind/indoors
	sound_weak_inside = /datum/looping_sound/weather/wind

/datum/weather/hailstorm/weather_act(mob/living/L)
	L.adjust_bodytemperature(-rand(3,6))
	L.adjustBruteLoss(rand(2,4))

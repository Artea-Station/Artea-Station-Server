/datum/weather/rain
	name = "rain"
	desc = "Rain falling down the surface."

	telegraph_message = "<span class='notice'>Dark clouds hover above and you feel humidity in the air..</span>"
	telegraph_duration = 300
	telegraph_skyblock = 0.2

	weather_message = "<span class='notice'>Rain starts to fall down..</span>"
	weather_overlay = "rain"
	weather_duration_lower = 600
	weather_duration_upper = 1500
	weather_skyblock = 0.4

	end_duration = 100
	end_message = "<span class='notice'>The rain stops...</span>"
	end_skyblock = 0.2

	area_type = /area
	protect_indoors = TRUE
	barometer_predictable = TRUE
	affects_underground = FALSE
	aesthetic = TRUE

	sound_active_outside = /datum/looping_sound/weather/rain/indoors
	sound_active_inside = /datum/looping_sound/weather/rain

/datum/weather/rain/heavy
	name = "heavy rain"
	desc = "Downpour of rain."

	telegraph_message = "<span class='notice'>Rather suddenly, clouds converge and tear into rain..</span>"
	telegraph_overlay = "rain"
	telegraph_skyblock = 0.4

	weather_message = "<span class='notice'>The rain turns into a downpour..</span>"
	weather_overlay = "storm"
	weather_skyblock = 0.6

	end_message = "<span class='notice'>The downpour dies down...</span>"
	end_overlay = "rain"
	end_skyblock = 0.4

	sound_active_outside = /datum/looping_sound/weather/rain/indoors
	sound_active_inside = /datum/looping_sound/weather/rain
	sound_weak_outside = /datum/looping_sound/weather/rain/indoors
	sound_weak_inside = /datum/looping_sound/weather/rain

	thunder_chance = 2

/datum/weather/rain/heavy/storm
	name = "storm"
	desc = "Storm with rain and lightning."
	weather_message = "<span class='warning'>The clouds blacken and the sky starts to flash as thunder strikes down!</span>"
	thunder_chance = 10

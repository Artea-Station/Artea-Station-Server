//Acid rain is part of the natural weather cycle in the humid forests of Planetstation, and cause acid damage to anyone unprotected.
/datum/weather/acid_rain
	name = "acid rain"
	desc = "The planet's thunderstorms are by nature acidic, and will incinerate anyone standing beneath them without protection."

	telegraph_duration = 400
	telegraph_message = "<span class='boldwarning'>Thunder rumbles far above. You hear droplets drumming against the canopy. Seek shelter.</span>"
	telegraph_skyblock = 0.2

	weather_message = "<span class='userdanger'><i>Acidic rain pours down around you! Get inside!</i></span>"
	weather_overlay = "acid_rain"
	weather_duration_lower = 600
	weather_duration_upper = 1500
	weather_skyblock = 0.3

	end_duration = 100
	end_message = "<span class='boldannounce'>The downpour gradually slows to a light shower. It should be safe outside now.</span>"
	end_skyblock = 0.2

	area_type = /area
	protect_indoors = TRUE

	immunity_type = ACID // temp

	barometer_predictable = TRUE

	sound_active_outside = /datum/looping_sound/weather/rain/indoors
	sound_active_inside = /datum/looping_sound/weather/rain
	sound_weak_outside = /datum/looping_sound/weather/rain/indoors
	sound_weak_inside = /datum/looping_sound/weather/rain


/datum/weather/acid_rain/weather_act(mob/living/L)
	var/resist = L.getarmor(null, ACID)
	if(prob(max(0,100-resist)))
		L.acid_act(20,20)

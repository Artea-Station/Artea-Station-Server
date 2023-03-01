#define THUNDER_SOUND pick('sound/effects/thunder/thunder1.ogg', 'sound/effects/thunder/thunder2.ogg', 'sound/effects/thunder/thunder3.ogg', 'sound/effects/thunder/thunder4.ogg', \
			'sound/effects/thunder/thunder5.ogg', 'sound/effects/thunder/thunder6.ogg', 'sound/effects/thunder/thunder7.ogg', 'sound/effects/thunder/thunder8.ogg', 'sound/effects/thunder/thunder9.ogg', \
			'sound/effects/thunder/thunder10.ogg')

/**
 * Causes weather to occur on a z level in certain area types
 *
 * The effects of weather occur across an entire z-level. For instance, lavaland has periodic ash storms that scorch most unprotected creatures.
 * Weather always occurs on different z levels at different times, regardless of weather type.
 * Can have custom durations, targets, and can automatically protect indoor areas.
 *
 */

/datum/weather
	/// name of weather
	var/name = "space wind"
	/// description of weather
	var/desc = "Heavy gusts of wind blanket the area, periodically knocking down anyone caught in the open."
	/// The message displayed in chat to foreshadow the weather's beginning
	var/telegraph_message = "<span class='warning'>The wind begins to pick up.</span>"
	/// In deciseconds, how long from the beginning of the telegraph until the weather begins
	var/telegraph_duration = 300
	/// The sound file played to everyone on an affected z-level
	var/telegraph_sound
	/// The overlay applied to all tiles on the z-level
	var/telegraph_overlay
	/// Amount of skyblock during the telegraph. Skyblock makes day/night effects "blocked"
	var/telegraph_skyblock = 0

	/// Displayed in chat once the weather begins in earnest
	var/weather_message = "<span class='userdanger'>The wind begins to blow ferociously!</span>"
	/// In deciseconds, how long the weather lasts once it begins
	var/weather_duration = 1200
	/// See above - this is the lowest possible duration
	var/weather_duration_lower = 1200
	/// See above - this is the highest possible duration
	var/weather_duration_upper = 1500
	/// Looping sound while weather is occuring
	var/weather_sound
	/// Area overlay while the weather is occuring
	var/weather_overlay
	/// Color to apply to the area while weather is occuring
	var/weather_color = null
	/// Amount of skyblock during the weather. Skyblock makes day/night effects "blocked"
	var/weather_skyblock = 0

	/// Displayed once the weather is over
	var/end_message = "<span class='danger'>The wind relents its assault.</span>"
	/// In deciseconds, how long the "wind-down" graphic will appear before vanishing entirely
	var/end_duration = 300
	/// Sound that plays while weather is ending
	var/end_sound
	/// Area overlay while weather is ending
	var/end_overlay
	/// Amount of skyblock during the end. Skyblock makes day/night effects "blocked"
	var/end_skyblock = 0

	/// Types of area to affect
	var/area_type = /area/space
	/// TRUE value protects areas with outdoors marked as false, regardless of area type
	var/protect_indoors = FALSE
	/// Areas to be affected by the weather, calculated when the weather begins
	var/list/impacted_areas = list()
	/// Areas that were protected by either being outside or underground
	var/list/outside_areas = list()
	/// Areas that are protected and excluded from the affected areas.
	var/list/protected_areas = list()
	/// The list of z-levels that this weather is actively affecting
	var/impacted_z_levels

	/// Since it's above everything else, this is the layer used by default. TURF_LAYER is below mobs and walls if you need to use that.
	var/overlay_layer = AREA_LAYER
	/// Plane for the overlay
	var/overlay_plane = AREA_PLANE
	/// If the weather has no purpose other than looks
	var/aesthetic = FALSE
	/// Used by mobs (or movables containing mobs, such as enviro bags) to prevent them from being affected by the weather.
	var/immunity_type
	/// If this bit of weather should also draw an overlay that's uneffected by lighting onto the area
	/// Taken from weather_glow.dmi
	var/use_glow = TRUE
	var/mutable_appearance/current_glow

	/// The stage of the weather, from 1-4
	var/stage = END_STAGE

	/// Whether a barometer can predict when the weather will happen
	var/barometer_predictable = FALSE
	/// For barometers to know when the next storm will hit
	var/next_hit_time = 0
	/// This causes the weather to only end if forced to
	var/perpetual = FALSE
	/// Whether the weather affects underground areas
	var/affects_underground = TRUE
	/// Whether the weather affects above ground areas
	var/affects_aboveground = TRUE
	/// Reference to the weather controller
	var/datum/weather_controller/my_controller
	/// A type of looping sound to be played for people outside the active weather
	var/datum/looping_sound/sound_active_outside
	/// A type of looping sound to be played for people inside the active weather
	var/datum/looping_sound/sound_active_inside
	/// A type of looping sound to be played for people outside the winding up/ending weather
	var/datum/looping_sound/sound_weak_outside
	/// A type of looping sound to be played for people inside the winding up/ending weather
	var/datum/looping_sound/sound_weak_inside
	/// Whether the areas should use a blend multiplication during the main weather, for stuff like fulltile storms
	var/multiply_blend_on_main_stage = FALSE
	/// Whether currently theres a lightning displayed
	var/lightning_in_progress = FALSE
	/// Chance for a thunder to happen
	var/thunder_chance = 0
	/// Whether the main stage will block vision
	var/opacity_in_main_stage = FALSE
	/// Overlays for the lightning effect
	var/obj/effect/lightning_add/lightning_add
	var/obj/effect/lightning_overlay/lightning_overlay

/datum/weather/New(datum/weather_controller/passed_controller)
	..()
	lightning_add = new
	lightning_overlay = new
	my_controller = passed_controller
	my_controller.current_weathers[type] = src
	var/list/z_levels = list()
	for(var/i in my_controller.z_levels)
		var/datum/space_level/level = i
		z_levels += level.z_value
	impacted_z_levels = z_levels
	if(sound_active_outside)
		sound_active_outside = new sound_active_outside(src, FALSE, TRUE)
	if(sound_active_inside)
		sound_active_inside = new sound_active_inside(src, FALSE, TRUE)
	if(sound_weak_outside)
		sound_weak_outside = new sound_weak_outside(src, FALSE, TRUE)
	if(sound_weak_inside)
		sound_weak_inside = new sound_weak_inside(src, FALSE, TRUE)

/datum/weather/process()
	if(stage != MAIN_STAGE)
		return
	if(prob(thunder_chance))
		do_thunder()
	if(aesthetic)
		return
	for(var/i in GLOB.mob_living_list)
		var/mob/living/L = i
		if(can_weather_act(L))
			weather_act(L)

/datum/weather/Destroy()
	qdel(lightning_add)
	qdel(lightning_overlay)
	my_controller.current_weathers -= type
	UNSETEMPTY(my_controller.current_weathers)
	my_controller = null
	return ..()

/datum/weather/process()
	if(aesthetic || stage != MAIN_STAGE)
		return
	for(var/i in GLOB.mob_living_list)
		var/mob/living/L = i
		if(can_weather_act(L))
			weather_act(L)

/**
 * Telegraphs the beginning of the weather on the impacted z levels
 *
 * Sends sounds and details to mobs in the area
 * Calculates duration and hit areas, and makes a callback for the actual weather to start
 *
 */
/datum/weather/proc/telegraph()
	if(stage == STARTUP_STAGE)
		return
	SEND_GLOBAL_SIGNAL(COMSIG_WEATHER_TELEGRAPH(type))
	stage = STARTUP_STAGE
	my_controller.skyblock += telegraph_skyblock
	my_controller.UpdateSkyblock()
	var/list/affectareas = list()
	for(var/V in get_areas(area_type))
		affectareas += V
	for(var/V in protected_areas)
		affectareas -= get_areas(V)
	for(var/V in affectareas)
		var/area/A = V
		if(!(A.z in impacted_z_levels))
			continue
		if(protect_indoors && !A.outdoors)
			outside_areas |= A
			continue
		if(A.underground && !affects_underground)
			outside_areas |= A
			continue
		if(!A.underground && !affects_aboveground)
			outside_areas |= A
			continue
		impacted_areas |= A
	weather_duration = rand(weather_duration_lower, weather_duration_upper)
	update_areas()
	for(var/z_level in impacted_z_levels)
		for(var/mob/player as anything in SSmobs.clients_by_zlevel[z_level])
			var/turf/mob_turf = get_turf(player)
			if(!mob_turf)
				continue
			if(telegraph_message)
				to_chat(player, telegraph_message)
			if(telegraph_sound)
				SEND_SOUND(player, sound(telegraph_sound))
	addtimer(CALLBACK(src, PROC_REF(start)), telegraph_duration)

/**
 * Starts the actual weather and effects from it
 *
 * Updates area overlays and sends sounds and messages to mobs to notify them
 * Begins dealing effects from weather to mobs in the area
 *
 */
/datum/weather/proc/start()
	if(stage >= MAIN_STAGE)
		return
	SEND_GLOBAL_SIGNAL(COMSIG_WEATHER_START(type))
	stage = MAIN_STAGE
	my_controller.skyblock -= telegraph_skyblock
	my_controller.skyblock += weather_skyblock
	my_controller.UpdateSkyblock()
	update_areas()
	for(var/z_level in impacted_z_levels)
		for(var/mob/player as anything in SSmobs.clients_by_zlevel[z_level])
			var/turf/mob_turf = get_turf(player)
			if(!mob_turf)
				continue
			if(weather_message)
				to_chat(player, weather_message)
			if(weather_sound)
				SEND_SOUND(player, sound(weather_sound))
	if(!perpetual)
		addtimer(CALLBACK(src, PROC_REF(wind_down)), weather_duration)

	if(sound_weak_outside)
		sound_weak_outside.stop()
	if(sound_weak_inside)
		sound_weak_inside.stop()
	if(sound_active_outside)
		sound_active_outside.start()
	if(sound_active_inside)
		sound_active_inside.start()

/**
 * Weather enters the winding down phase, stops effects
 *
 * Updates areas to be in the winding down phase
 * Sends sounds and messages to mobs to notify them
 *
 */
/datum/weather/proc/wind_down()
	if(stage >= WIND_DOWN_STAGE)
		return
	SEND_GLOBAL_SIGNAL(COMSIG_WEATHER_WINDDOWN(type))
	stage = WIND_DOWN_STAGE
	my_controller.skyblock += end_skyblock
	my_controller.skyblock -= weather_skyblock
	my_controller.UpdateSkyblock()
	update_areas()
	for(var/z_level in impacted_z_levels)
		for(var/mob/player as anything in SSmobs.clients_by_zlevel[z_level])
			var/turf/mob_turf = get_turf(player)
			if(!mob_turf)
				continue
			if(end_message)
				to_chat(player, end_message)
			if(end_sound)
				SEND_SOUND(player, sound(end_sound))
	addtimer(CALLBACK(src, PROC_REF(end)), end_duration)

	if(sound_active_outside)
		sound_active_outside.stop()
	if(sound_active_inside)
		sound_active_inside.stop()
	if(sound_weak_outside)
		sound_weak_outside.start()
	if(sound_weak_inside)
		sound_weak_inside.start()

/**
 * Fully ends the weather
 *
 * Effects no longer occur and area overlays are removed
 * Removes weather from processing completely
 *
 */
/datum/weather/proc/end()
	if(stage == END_STAGE)
		return
	SEND_GLOBAL_SIGNAL(COMSIG_WEATHER_END(type))
	stage = END_STAGE
	my_controller.skyblock -= end_skyblock
	my_controller.UpdateSkyblock()
	update_areas()
	if(sound_weak_outside)
		sound_weak_outside.start()
	if(sound_weak_inside)
		sound_weak_inside.start()
	if(sound_active_outside)
		qdel(sound_active_outside)
	if(sound_active_inside)
		qdel(sound_active_inside)
	if(sound_weak_outside)
		sound_weak_outside.stop()
		qdel(sound_weak_outside)
	if(sound_weak_inside)
		sound_weak_inside.stop()
		qdel(sound_weak_inside)
	if(lightning_in_progress)
		end_thunder()
	qdel(src)

/**
 * Returns TRUE if the living mob can be affected by the weather
 *
 */
/datum/weather/proc/can_weather_act(mob/living/mob_to_check)
	var/turf/mob_turf = get_turf(mob_to_check)

	if(!mob_turf)
		return

	if(!(mob_turf.z in impacted_z_levels))
		return

	if((immunity_type && HAS_TRAIT(mob_to_check, immunity_type)) || HAS_TRAIT(mob_to_check, TRAIT_WEATHER_IMMUNE))
		return

	var/atom/loc_to_check = mob_to_check.loc
	while(loc_to_check != mob_turf)
		if((immunity_type && HAS_TRAIT(loc_to_check, immunity_type)) || HAS_TRAIT(loc_to_check, TRAIT_WEATHER_IMMUNE))
			return
		loc_to_check = loc_to_check.loc

	if(!(get_area(mob_to_check) in impacted_areas))
		return

	return TRUE

/**
 * Affects the mob with whatever the weather does
 *
 */
/datum/weather/proc/weather_act(mob/living/L)
	return

/**
 * Updates the overlays on impacted areas
 *
 */
/datum/weather/proc/update_areas()
	for(var/V in impacted_areas)
		var/area/N = V
		if(stage == MAIN_STAGE)
			if(multiply_blend_on_main_stage)
				N.blend_mode = BLEND_MULTIPLY
			else
				N.blend_mode = BLEND_OVERLAY
			if(opacity_in_main_stage)
				N.set_opacity(TRUE)
			else
				N.set_opacity(FALSE)
		N.layer = overlay_layer
		N.plane = overlay_plane
		N.icon = 'icons/effects/weather_effects.dmi'
		N.color = weather_color
		set_area_icon_state(N)
		if(stage == END_STAGE)
			N.color = null
			N.icon = initial(N.icon)
			N.layer = initial(N.layer)
			N.plane = initial(N.plane)
			N.set_opacity(FALSE)

/datum/weather/proc/set_area_icon_state(area/Area)
	switch(stage)
		if(STARTUP_STAGE)
			Area.icon_state = telegraph_overlay
		if(MAIN_STAGE)
			Area.icon_state = weather_overlay
		if(WIND_DOWN_STAGE)
			Area.icon_state = end_overlay
		if(END_STAGE)
			Area.icon_state = ""

/datum/weather/proc/do_thunder()
	if(lightning_in_progress)
		return
	lightning_in_progress = TRUE
	addtimer(CALLBACK(src, PROC_REF(end_thunder)), 4 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(do_thunder_sound)), 2 SECONDS)
	for(var/V in impacted_areas)
		var/area/N = V
		N.luminosity++
		N.add_overlay(lightning_add)
		N.add_overlay(lightning_overlay)

/datum/weather/proc/do_thunder_sound()
	var/picked_sound = THUNDER_SOUND
	for(var/i in 1 to impacted_areas.len)
		var/atom/thing = impacted_areas[i]
		SEND_SOUND(thing, sound(picked_sound, volume = 65))
	for(var/i in 1 to outside_areas.len)
		var/atom/thing = outside_areas[i]
		SEND_SOUND(thing, sound(picked_sound, volume = 35))

/datum/weather/proc/end_thunder()
	if(QDELETED(src))
		return
	if(!lightning_in_progress)
		return
	lightning_in_progress = FALSE
	for(var/V in impacted_areas)
		var/area/N = V
		N.cut_overlay(lightning_add)
		N.cut_overlay(lightning_overlay)
		N.luminosity--

/obj/effect/lightning_add
	icon = 'icons/effects/weather_effects.dmi'
	icon_state = "lightning_flash"
	plane = LIGHTING_PLANE
	blend_mode = BLEND_ADD

/obj/effect/lightning_overlay
	icon = 'icons/effects/weather_effects.dmi'
	icon_state = "lightning_flash"
	plane = LIGHTING_PLANE
	blend_mode = BLEND_OVERLAY

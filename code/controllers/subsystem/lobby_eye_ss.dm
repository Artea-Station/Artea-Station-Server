SUBSYSTEM_DEF(lobby_eye)
	name = "Lobby Eye"
	wait = 50
	flags = SS_TICKER

	///the camera that is linked to the subsystem
	var/obj/new_player_cam/linked_camera
	///how many tiles the camera will do
	var/path_target = 30
	///how many tiles into invalid areas can we go
	var/invalid_reset = 8
	///the areas that are considered invalid
	var/static/list/invalid_areas = list(/area/space, /area/icemoon)
	///how fast the camera will "move"
	var/moving_speed = 4
	///the screen that will fade in and out
	var/atom/movable/screen/movable/black_fade/fading_screen
	///the pathway that the camera will take
	var/list/pathway = list()

/datum/controller/subsystem/lobby_eye/Initialize(start_timeofday)
	. = SS_INIT_SUCCESS
	linked_camera = new()
	fading_screen = new()
	fire()

//fades out the artea logo in the bottom left

//gets everyone on the camera
/datum/controller/subsystem/lobby_eye/proc/lock_eyes()
	for(var/mob/checking_mob as anything in GLOB.new_player_list)
		if(!checking_mob.client)
			continue
		if(!checking_mob.client?.prefs.read_preference(/datum/preference/toggle/lobby_cam))
			continue
		if(SSticker.current_state < GAME_STATE_PREGAME)
			continue
		if(!(fading_screen in checking_mob.client?.screen))
			checking_mob.client?.screen += fading_screen
		if(checking_mob.client?.eye != linked_camera)
			checking_mob.client?.eye = linked_camera
		if(checking_mob.lighting_alpha != LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE)
			checking_mob.lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE

//gets everyone off of the camera
/datum/controller/subsystem/lobby_eye/proc/unlock_eyes()
	for(var/mob/checking_mob in GLOB.new_player_list)
		if(!checking_mob.client)
			continue
		if(fading_screen && (fading_screen in checking_mob.client?.screen))
			checking_mob.client?.screen -= fading_screen
		if(checking_mob.client?.eye != linked_camera)
			continue
		checking_mob.client?.eye = checking_mob.client?.mob

/datum/controller/subsystem/lobby_eye/fire(resumed)
	//the config
	if(!CONFIG_GET(flag/lobby_camera))
		return

	//fade out the logo and unlock eyes when 20 seconds until round start
	var/time_remaining = SSticker.GetTimeLeft()
	if(time_remaining <= 20 SECONDS && time_remaining >= 0 && SSticker.current_state == GAME_STATE_PREGAME)
		unlock_eyes()
		return

	//we should only work in pregame
	if(SSticker.current_state != GAME_STATE_PREGAME)
		unlock_eyes()
		return

	//find the starting location
	var/turf/starting_turf = get_safe_random_station_turf()
	pathway = list(starting_turf)

	//start building the pathway
	var/chosen_direction = pick(GLOB.cardinals)
	var/invalid_crossed = 0
	var/turf/chosen_turf = starting_turf
	for(var/creating_pathway in 1 to path_target)
		chosen_turf = get_step(chosen_turf, chosen_direction)
		if(!chosen_turf)
			break
		if(is_type_in_list(get_area(chosen_turf), invalid_areas))
			invalid_crossed++
		if(invalid_crossed >= invalid_reset)
			break
		pathway += chosen_turf

	//move camera to starting location and lock
	linked_camera.loc = starting_turf
	lock_eyes()

	//fade in
	fading_screen.icon_state = "1"
	animate(fading_screen, alpha = LIGHTING_PLANE_ALPHA_INVISIBLE, time = 1 SECONDS, easing = LINEAR_EASING)
	sleep(1 SECONDS)

	//move
	for(var/turf/moving_turf in pathway)
		linked_camera.loc = moving_turf
		sleep(moving_speed)

	//fade out
	animate(fading_screen, alpha = LIGHTING_PLANE_ALPHA_VISIBLE, time = 1 SECONDS, easing = LINEAR_EASING)
	sleep(1 SECONDS)

	fire()

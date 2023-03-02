/atom/movable/screen/movable/black_fade
	name = "black screen"
	icon = 'icons/lobby_cam/black_screen.dmi'
	icon_state = "1"
	screen_loc = "SOUTHWEST to NORTHEAST"
	plane = SPLASHSCREEN_PLANE
	layer = LOBBY_BACKGROUND_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/new_player_cam
	name = "floor"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	density = FALSE
	anchored = TRUE
	alpha = 0
	invisibility = INVISIBILITY_ABSTRACT

/datum/preference/toggle/lobby_cam
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	default_value = TRUE
	savefile_key = "lobby_cam_pref"
	savefile_identifier = PREFERENCE_PLAYER

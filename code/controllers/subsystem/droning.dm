//Used to manage sending droning sounds to various clients
SUBSYSTEM_DEF(droning)
	name = "Droning"
	flags = SS_NO_INIT|SS_NO_FIRE

/datum/controller/subsystem/droning/proc/area_entered(area/area_entered, client/entering)
	if(!area_entered || !entering)
		return
	var/list/last_droning = list()
	last_droning |= entering.last_droning_sound
	var/list/new_droning = list()
	new_droning |= area_entered.droning_sound
	//Same ambience, don't bother
	if(last_droning ~= new_droning)
		return
	play_area_sound(area_entered, entering)

/datum/controller/subsystem/droning/proc/play_area_sound(area/area_player, client/listener)
	if(!area_player || !listener)
		return
	if(LAZYLEN(area_player.droning_sound) && (listener.prefs.toggles & SOUND_SHIP_AMBIENCE))
		//kill the previous droning sound
		kill_droning(listener)
		var/sound/droning = sound(pick(area_player.droning_sound), area_player.droning_repeat, area_player.droning_wait, area_player.droning_channel, area_player.droning_volume)
		SEND_SOUND(listener, droning)
		listener.droning_sound = droning
		listener.last_droning_sound = area_player.droning_sound

/datum/controller/subsystem/droning/proc/kill_droning(client/victim)
	if(!victim?.droning_sound)
		return
	var/sound/sound_killer = sound()
	sound_killer.channel = victim.droning_sound.channel
	SEND_SOUND(victim, sound_killer)
	victim.droning_sound = null
	victim.last_droning_sound = null

/mob/dead/new_player/Login()
	if(!client)
		return

	if(CONFIG_GET(flag/use_exp_tracking))
		client.set_exp_from_db()
		client.set_db_player_flags()
	if(!mind)
		mind = new /datum/mind(key)
		mind.active = TRUE
		mind.set_current(src)

	// Check if user should be added to interview queue
	if (!client.holder && CONFIG_GET(flag/panic_bunker) && CONFIG_GET(flag/panic_bunker_interview) && !(client.ckey in GLOB.interviews.approved_ckeys))
		var/required_living_minutes = CONFIG_GET(number/panic_bunker_living)
		var/living_minutes = client.get_exp_living(TRUE)
		if (required_living_minutes >= living_minutes)
			client.interviewee = TRUE

	. = ..()
	if(!. || !client || !SSdiscord)
		return FALSE

	/// Artea's own scuffed version of discord verification, cause TGCode's version doesn't quite do what we need it to.
	if(CONFIG_GET(flag/sql_enabled) && CONFIG_GET(flag/discord_verification))
		var/datum/discord_link_record/discord_link = SSdiscord.find_discord_link_by_ckey(client.ckey)
		if(!discord_link?.discord_id)
			client.interviewee = TRUE

	var/motd = global.config.motd
	if(motd)
		to_chat(src, "<div class=\"motd\">[motd]</div>", handle_whitespace=FALSE)

	if(GLOB.admin_notice)
		to_chat(src, span_notice("<b>Admin Notice:</b>\n \t [GLOB.admin_notice]"))

	var/spc = CONFIG_GET(number/soft_popcap)
	if(spc && living_player_count() >= spc)
		to_chat(src, span_notice("<b>Server Notice:</b>\n \t [CONFIG_GET(string/soft_popcap_message)]"))

	sight |= SEE_TURFS

	client.playtitlemusic()

	var/datum/asset/asset_datum = get_asset_datum(/datum/asset/simple/lobby)
	asset_datum.send(client)

	// The parent call for Login() may do a bunch of stuff, like add verbs.
	// Delaying the prepare_for_linking until the very end makes sure it can clean everything up
	// and set the player's client up for linking.
	if(client.interviewee)
		prepare_for_linking()
		return

	if(SSticker.current_state < GAME_STATE_SETTING_UP)
		var/tl = SSticker.GetTimeLeft()
		to_chat(src, "Please set up your character and select \"Ready\". The game will start [tl > 0 ? "in about [DisplayTimeText(tl)]" : "soon"].")



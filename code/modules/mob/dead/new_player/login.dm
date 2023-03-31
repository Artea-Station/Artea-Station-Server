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

	/// Artea's own scuffed version of discord verification, cause TGCode's version doesn't quite do what we need it to.
	var/datum/discord_link_record/discord_link = SSdiscord.find_discord_link_by_ckey(client.ckey)
	if(!discord_link?.discord_id)
		client.interviewee = TRUE
		var/message = "<h3 class='good'>Welcome!</h3>Considering this is either your first time connecting, or you haven't given our bot your discord link token, you will be unable to play until you go into the <span class='good'>OOC</span> tab > <span class='good'>Verify Discord Account</span>, and follow the given instructions!<br><br>This is required to prevent spam and underage users!<br><br>If you have already verified, please wait five minutes before reconnecting, and contact an admin if this notice does not go away."
		var/datum/browser/window = new/datum/browser(usr, "discordverification", "Discord verification")
		window.set_content("<span>[message]</span>")
		window.open()

	. = ..()
	if(!. || !client)
		return FALSE

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
	// Delaying the register_for_interview until the very end makes sure it can clean everything up
	// and set the player's client up for interview.
	if(client.interviewee)
		register_for_interview()
		return

	if(SSticker.current_state < GAME_STATE_SETTING_UP)
		var/tl = SSticker.GetTimeLeft()
		to_chat(src, "Please set up your character and select \"Ready\". The game will start [tl > 0 ? "in about [DisplayTimeText(tl)]" : "soon"].")



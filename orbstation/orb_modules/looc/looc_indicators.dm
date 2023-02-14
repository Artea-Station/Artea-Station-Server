//Typing indicators when using LOOC chat.
/datum/tgui_say/proc/start_looc_thinking()
	if(!window_open)
		return FALSE
	client.mob.thinking_LOOC = TRUE
	client.mob.create_thinking_indicator()

/mob
	/// Used for LOOC typing indicators.
	var/thinking_LOOC = FALSE

/mob/proc/vv_load_prefs()
	if(!check_rights(R_ADMIN))
		return

	if(!client)
		to_chat(usr, span_warning("No client found!"))
		return

	if(!ishuman(src))
		to_chat(usr, span_warning("Mob is not human!"))
		return

	var/notice = tgui_alert(usr, "Are you sure you want to load the clients current prefs onto their mob?", "Load Preferences", list("Yes", "No"))
	if(notice != "Yes")
		return

	client?.prefs?.apply_prefs_to(src)
	var/msg = span_notice("[key_name_admin(usr)] has loaded [key_name(src)]'s preferences onto their current mob [ADMIN_VERBOSEJMP(src)].")
	message_admins(msg)
	admin_ticket_log(src, msg)

// IF you have linked your account, this will trigger a verify of the user
/client/verb/verify_in_discord()
	set category = "OOC"
	set name = "Verify Discord Account"
	set desc = "Verify your discord account with your BYOND account"

	// Safety checks
	if(!CONFIG_GET(flag/sql_enabled))
		to_chat(src, span_warning("This feature requires the SQL backend to be running."))
		return

	// Why this would ever be unset, who knows
	var/prefix = CONFIG_GET(string/discordbotcommandprefix)
	if(!prefix)
		to_chat(src, span_warning("This feature is disabled."))

	if(!SSdiscord || !SSdiscord.reverify_cache)
		to_chat(src, span_warning("Wait for the Discord subsystem to finish initialising"))
		return

	var/message = ""
	// Simple sanity check to prevent a user doing this too often
	var/cached_one_time_token = SSdiscord.reverify_cache[usr.ckey]
	if(!cached_one_time_token || cached_one_time_token == "")
		// Will generate one if an expired one doesn't exist already, otherwise will grab existing token
		var/one_time_token = SSdiscord.get_or_generate_one_time_token_for_ckey(ckey)
		SSdiscord.reverify_cache[usr.ckey] = one_time_token

	message = "<h3 class='good'>Welcome!</h3>\
	Your one time token is <span class='bad'>[cached_one_time_token]</span>\
	<br><br>You can verify yourself in discord by using the command <span class='bad'>[prefix]verify [cached_one_time_token]</span> inside the #user-bot-spam channel!\
	If you haven't done so already, you will need to apply to gain access to the channel to verify yourself upon joining the discord.\
	<br><br><a href=\"[CONFIG_GET(string/discord_link)]\">Discord</a>"

	//Now give them a browse window so they can't miss whatever we told them
	var/datum/browser/window = new/datum/browser(usr, "discordverification", "Discord verification")
	window.set_content("<span>[message]</span>")
	window.open()



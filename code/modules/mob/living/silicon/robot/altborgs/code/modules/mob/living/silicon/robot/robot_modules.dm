/obj/item/robot_model/proc/dogborg_equip()
	has_snowflake_deadsprite = TRUE
	cyborg_pixel_offset = -16
	hat_offset = INFINITY
	basic_modules += new /obj/item/dogborg_nose(src)
	basic_modules += new /obj/item/dogborg_tongue(src)
	var/mob/living/silicon/robot/cyborg = loc
	add_verb(cyborg , /mob/living/silicon/robot/proc/robot_lay_down)
	add_verb(cyborg , /mob/living/silicon/robot/proc/rest_style)
	add_verb(cyborg , /mob/living/silicon/robot/proc/user_reset_model)
	rebuild_modules()

//ROBOT ADDITIONAL MODULES

//STANDARD
/obj/item/robot_model/standard/be_transformed_to(obj/item/robot_model/old_model)
	var/mob/living/silicon/robot/cyborg = loc
	var/static/list/standard_icons = list(
		"Default" = image(icon = 'icons/mob/robots.dmi', icon_state = "robot"),
		"Marina" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "marinasd"),
		"Heavy" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "heavysd"),
		"Eyebot" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "eyebotsd"),
		"Robot" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "robot_old"),
		"Bootyborg" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "bootysd"),
		"Male Bootyborg" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "male_bootysd"),
		"Bird Borg" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "bird_pk"),
		"Protectron" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "protectron_standard"),
		"Miss m" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "missm_sd")
		)
	var/list/L = list("Fabulous" = "k69")
	for(var/a in L)
		var/image/wide = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/widerobot.dmi', icon_state = L[a])
		wide.pixel_x = -16
		standard_icons[a] = wide
	standard_icons = sortList(standard_icons)
	var/standard_borg_icon = show_radial_menu(cyborg, cyborg , standard_icons, custom_check = CALLBACK(src, .proc/check_menu, cyborg, old_model), radius = 42, require_near = TRUE)
	switch(standard_borg_icon)
		if("Default")
			cyborg_base_icon = "robot"
		if("Marina")
			cyborg_base_icon = "marinasd"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
			has_snowflake_deadsprite = TRUE
		if("Heavy")
			cyborg_base_icon = "heavysd"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
			has_snowflake_deadsprite = TRUE
		if("Eyebot")
			cyborg_base_icon = "eyebotsd"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
			has_snowflake_deadsprite = TRUE
		if("Robot")
			cyborg_base_icon = "robot_old"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
			has_snowflake_deadsprite = TRUE
		if("Bootyborg")
			cyborg_base_icon = "bootysd"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Male Bootyborg")
			cyborg_base_icon = "male_bootysd"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Bird Borg")
			cyborg_base_icon = "bird_pk"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Protectron")
			cyborg_base_icon = "protectron_standard"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Miss m")
			cyborg_base_icon = "missm_sd"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		//Dogborgs
		if("Fabulous")
			cyborg_base_icon = "k69"
			sleeper_overlay = "k9sleeper"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/widerobot.dmi'
			dogborg = TRUE
		else
			return FALSE
	return ..()

//MEDICAL
/obj/item/robot_model/medical/be_transformed_to(obj/item/robot_model/old_model)
	var/mob/living/silicon/robot/cyborg = loc
	var/static/list/med_icons
	if(!med_icons)
		med_icons = list(
		"Default" = image(icon = 'icons/mob/robots.dmi', icon_state = "medical"),
		"Droid" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "medical"),
		"Sleek" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "sleekmed"),
		"Marina" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "marinamed"),
		"Eyebot" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "eyebotmed"),
		"Heavy" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "heavymed"),
		"Bootyborg" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "bootymedical"),
		"Male Bootyborg" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "male_bootymedical"),
		"Bird Borg" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "bird_med"),
		"Protectron" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "protectron_medical"),
		"Miss m" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "missm_med"),
		"Qualified Doctor" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "qualified_doctor"),
		"Zoomba" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "zoomba_med"),
		)
		var/list/L = list("Medihound" = "medihound", "Medihound Dark" = "medihounddark", "Vale" = "valemed", "Drake" = "drakemedbox")
		for(var/a in L)
			var/image/wide = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/widerobot.dmi', icon_state = L[a])
			wide.pixel_x = -16
			med_icons[a] = wide
		med_icons = sortList(med_icons)
	var/med_borg_icon = show_radial_menu(cyborg, cyborg , med_icons, custom_check = CALLBACK(src, .proc/check_menu, cyborg, old_model), radius = 42, require_near = TRUE)
	switch(med_borg_icon)
		if("Default")
			cyborg_base_icon = "medical"
		if("Zoomba")
			cyborg_base_icon = "zoomba_med"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
			has_snowflake_deadsprite = TRUE
		if("Droid")
			cyborg_base_icon = "medical"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
			hat_offset = 4
		if("Sleek")
			cyborg_base_icon = "sleekmed"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Marina")
			cyborg_base_icon = "marinamed"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Eyebot")
			cyborg_base_icon = "eyebotmed"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Heavy")
			cyborg_base_icon = "heavymed"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Bootyborg")
			cyborg_base_icon = "bootymedical"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Male Bootyborg")
			cyborg_base_icon = "male_bootymedical"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Bird Borg")
			cyborg_base_icon = "bird_med"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Protectron")
			cyborg_base_icon = "protectron_medical"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Miss m")
			cyborg_base_icon = "missm_med"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Qualified Doctor")
			cyborg_base_icon = "qualified_doctor"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		//Dogborgs
		if("Medihound")
			cyborg_base_icon = "medihound"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/widerobot.dmi'
			sleeper_overlay = "msleeper"
			model_select_icon = "medihound"
			model_select_alternate_icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/ui/screen_cyborg.dmi'
			dogborg = TRUE
		if("Medihound Dark")
			cyborg_base_icon = "medihounddark"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/widerobot.dmi'
			sleeper_overlay = "mdsleeper"
			model_select_icon = "medihound"
			model_select_alternate_icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/ui/screen_cyborg.dmi'
			dogborg = TRUE
		if("Vale")
			cyborg_base_icon = "valemed"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/widerobot.dmi'
			sleeper_overlay = "valemedsleeper"
			model_select_icon = "medihound"
			model_select_alternate_icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/ui/screen_cyborg.dmi'
			dogborg = TRUE
		if("Alina")
			cyborg_base_icon = "alina-med"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/widerobot.dmi'
			special_light_key = "alina"
			sleeper_overlay = "alinasleeper"
			model_select_icon = "medihound"
			model_select_alternate_icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/ui/screen_cyborg.dmi'
			dogborg = TRUE
		if("Drake")
			cyborg_base_icon = "drakemed"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/widerobot.dmi'
			sleeper_overlay = "drakemedsleeper"
			model_select_icon = "medihound"
			model_select_alternate_icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/ui/screen_cyborg.dmi'
			dogborg = TRUE
		else
			return FALSE
	return ..()

//ENGINEERING
/obj/item/robot_model/engineering/be_transformed_to(obj/item/robot_model/old_model)
	var/mob/living/silicon/robot/cyborg = loc
	var/static/list/engi_icons
	if(!engi_icons)
		engi_icons = list(
		"Default" = image(icon = 'icons/mob/robots.dmi', icon_state = "engineer"),
		"Default - Treads" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "engi-tread"),
		"Loader" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "loaderborg"),
		"Handy" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "handyeng"),
		"Sleek" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "sleekeng"),
		"Can" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "caneng"),
		"Marina" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "marinaeng"),
		"Spider" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "spidereng"),
		"Heavy" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "heavyeng"),
		"Bootyborg" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "bootyeng"),
		"Male Bootyborg" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "male_bootyeng"),
		"Bird Borg" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "bird_eng"),
		"Protectron" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "protectron_eng"),
		"Miss m" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "missm_eng"),
		"Zoomba" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "zoomba_engi"),
		)
		var/list/L = list("Pup Dozer" = "pupdozer", "Vale" = "valeeng", "Hound" = "engihound", "Darkhound" = "engihounddark", "Drake" = "drakeengbox")
		for(var/a in L)
			var/image/wide = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/widerobot.dmi', icon_state = L[a])
			wide.pixel_x = -16
			engi_icons[a] = wide
		engi_icons = sortList(engi_icons)
	var/engi_borg_icon = show_radial_menu(cyborg, cyborg , engi_icons, custom_check = CALLBACK(src, .proc/check_menu, cyborg, old_model), radius = 42, require_near = TRUE)
	switch(engi_borg_icon)
		if("Default")
			cyborg_base_icon = "engineer"
		if("Zoomba")
			cyborg_base_icon = "zoomba_engi"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
			has_snowflake_deadsprite = TRUE
		if("Default - Treads")
			cyborg_base_icon = "engi-tread"
			special_light_key = "engineer"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Loader")
			cyborg_base_icon = "loaderborg"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
			has_snowflake_deadsprite = TRUE
		if("Handy")
			cyborg_base_icon = "handyeng"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Sleek")
			cyborg_base_icon = "sleekeng"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Can")
			cyborg_base_icon = "caneng"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Marina")
			cyborg_base_icon = "marinaeng"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Spider")
			cyborg_base_icon = "spidereng"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Heavy")
			cyborg_base_icon = "heavyeng"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Bootyborg")
			cyborg_base_icon = "bootyeng"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Male Bootyborg")
			cyborg_base_icon = "male_bootyeng"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Bird Borg")
			cyborg_base_icon = "bird_eng"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Protectron")
			cyborg_base_icon = "protectron_eng"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Miss m")
			cyborg_base_icon = "missm_eng"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		//Dogborgs
		if("Pup Dozer")
			cyborg_base_icon = "pupdozer"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/widerobot.dmi'
			sleeper_overlay = "dozersleeper"
			dogborg = TRUE
		if("Vale")
			cyborg_base_icon = "valeeng"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/widerobot.dmi'
			sleeper_overlay = "valeengsleeper"
			dogborg = TRUE
		if("Hound")
			cyborg_base_icon = "engihound"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/widerobot.dmi'
			sleeper_overlay = "engihoundsleeper"
			dogborg = TRUE
		if("Darkhound")
			cyborg_base_icon = "engihounddark"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/widerobot.dmi'
			sleeper_overlay = "engihounddarksleeper"
			dogborg = TRUE
		if("Alina")
			cyborg_base_icon = "alina-eng"
			special_light_key = "alina"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/widerobot.dmi'
			sleeper_overlay = "alinasleeper"
			dogborg = TRUE
		if("Drake")
			cyborg_base_icon = "drakeeng"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/widerobot.dmi'
			sleeper_overlay = "drakesecsleeper"
			dogborg = TRUE
		else
			return FALSE
	return ..()

//SECURITY
/obj/item/robot_model/security/be_transformed_to(obj/item/robot_model/old_model)
	var/mob/living/silicon/robot/cyborg = loc
	var/static/list/sec_icons
	if(!sec_icons)
		sec_icons = list(
		"Default" = image(icon = 'icons/mob/robots.dmi', icon_state = "sec"),
		"Default - Treads" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "sec-tread"),
		"Sleek" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "sleeksec"),
		"Can" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "cansec"),
		"Marina" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "marinasec"),
		"Spider" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "spidersec"),
		"Heavy" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "heavysec"),
		"Bootyborg" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "bootysecurity"),
		"Male Bootyborg" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "male_bootysecurity"),
		"Bird Borg" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "bird_sec"),
		"Protectron" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "protectron_security"),
		"Miss m" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "missm_security"),
		"Zoomba" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "zoomba_sec"),
		)
		var/list/L = list("K9" = "k9", "Vale" = "valesec", "K9 Dark" = "k9dark", "Otie" = "oties", "Drake" = "drakesecbox")
		for(var/a in L)
			var/image/wide = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/widerobot.dmi', icon_state = L[a])
			wide.pixel_x = -16
			sec_icons[a] = wide
		sec_icons = sortList(sec_icons)
	var/sec_borg_icon = show_radial_menu(cyborg, cyborg , sec_icons, custom_check = CALLBACK(src, .proc/check_menu, cyborg, old_model), radius = 42, require_near = TRUE)
	switch(sec_borg_icon)
		if("Default")
			cyborg_base_icon = "sec"
		if("Zoomba")
			cyborg_base_icon = "zoomba_sec"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Default - Treads")
			cyborg_base_icon = "sec-tread"
			special_light_key = "sec"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Sleek")
			cyborg_base_icon = "sleeksec"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Marina")
			cyborg_base_icon = "marinasec"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Can")
			cyborg_base_icon = "cansec"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Spider")
			cyborg_base_icon = "spidersec"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Heavy")
			cyborg_base_icon = "heavysec"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Bootyborg")
			cyborg_base_icon = "bootysecurity"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Male Bootyborg")
			cyborg_base_icon = "male_bootysecurity"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Bird Borg")
			cyborg_base_icon = "bird_sec"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Protectron")
			cyborg_base_icon = "protectron_security"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Miss m")
			cyborg_base_icon = "missm_security"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		//Dogborgs
		if("K9")
			cyborg_base_icon = "k9"
			sleeper_overlay = "ksleeper"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/widerobot.dmi'
			dogborg = TRUE
		if("Otie")
			cyborg_base_icon = "oties"
			sleeper_overlay = "otiessleeper"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/widerobot.dmi'
			dogborg = TRUE
		if("Alina")
			cyborg_base_icon = "alina-sec"
			special_light_key = "alina"
			sleeper_overlay = "alinasleeper"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/widerobot.dmi'
			dogborg = TRUE
		if("K9 Dark")
			cyborg_base_icon = "k9dark"
			sleeper_overlay = "k9darksleeper"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/widerobot.dmi'
			dogborg = TRUE
		if("Vale")
			cyborg_base_icon = "valesec"
			sleeper_overlay = "valesecsleeper"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/widerobot.dmi'
			dogborg = TRUE
		if("Drake")
			cyborg_base_icon = "drakesec"
			sleeper_overlay = "drakesecsleeper"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/widerobot.dmi'
			dogborg = TRUE
		else
			return FALSE
	return ..()

//PEACEKEEPER
/obj/item/robot_model/peacekeeper/be_transformed_to(obj/item/robot_model/old_model)
	var/mob/living/silicon/robot/cyborg = loc
	var/static/list/peace_icons
	if(!peace_icons)
		peace_icons = list(
		"Default" = image(icon = 'icons/mob/robots.dmi', icon_state = "peace"),
		"Borgi" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "borgi"),
		"Spider" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "whitespider"),
		"Sleek" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "sleekpeace"),
		"Marina" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "marinapeace"),
		"Bootyborg" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "bootypeace"),
		"Male Bootyborg" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "male_bootypeace"),
		"Bird Borg" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "bird_pk"),
		"Protectron" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "protectron_peacekeeper")
		)
		var/list/L = list("Drake" = "drakepeacebox")
		for(var/a in L)
			var/image/wide = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/widerobot.dmi', icon_state = L[a])
			wide.pixel_x = -16
			peace_icons[a] = wide
		peace_icons = sortList(peace_icons)
	var/peace_borg_icon = show_radial_menu(cyborg, cyborg , peace_icons, custom_check = CALLBACK(src, .proc/check_menu, cyborg, old_model), radius = 42, require_near = TRUE)
	switch(peace_borg_icon)
		if("Default")
			cyborg_base_icon = "peace"
		if("Sleek")
			cyborg_base_icon = "sleekpeace"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
			has_snowflake_deadsprite = TRUE
		if("Spider")
			cyborg_base_icon = "whitespider"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Borgi")
			cyborg_base_icon = "borgi"
			model_select_icon = "borgi"
			model_select_alternate_icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/ui/screen_cyborg.dmi'
			hat_offset = INFINITY
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
			has_snowflake_deadsprite = TRUE
		if("Marina")
			cyborg_base_icon = "marinapeace"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
			has_snowflake_deadsprite = TRUE
		if("Bootyborg")
			cyborg_base_icon = "bootypeace"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Male Bootyborg")
			cyborg_base_icon = "male_bootypeace"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Bird Borg")
			cyborg_base_icon = "bird_pk"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Protectron")
			cyborg_base_icon = "protectron_peacekeeper"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		//Dogborgs
		if("Drake")
			cyborg_base_icon = "drakepeace"
			sleeper_overlay = "drakepeacesleeper"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/widerobot.dmi'
			dogborg = TRUE
		else
			return FALSE
	return ..()

//JANITOR
/obj/item/robot_model/janitor/be_transformed_to(obj/item/robot_model/old_model)
	var/mob/living/silicon/robot/cyborg = loc
	var/static/list/janitor_icons
	if(!janitor_icons)
		janitor_icons = list(
		"Default" = image(icon = 'icons/mob/robots.dmi', icon_state = "janitor"),
		"Marina" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "marinajan"),
		"Sleek" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "sleekjan"),
		"Can" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "canjan"),
		"Bootyborg" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "bootyjanitor"),
		"Male Bootyborg" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "male_bootyjanitor"),
		"Bird Borg" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "bird_jani"),
		"Protectron" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "protectron_janitor"),
		"Miss m" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "missm_janitor"),
		"Heavy" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "heavyres"),
		"Zoomba" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "zoomba_jani"),
		)
		var/list/L = list("Drake" = "drakejanitbox", "Otie" = "otiej", "Scrubpuppy" = "scrubpup")
		for(var/a in L)
			var/image/wide = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/widerobot.dmi', icon_state = L[a])
			wide.pixel_x = -16
			janitor_icons[a] = wide
		janitor_icons = sortList(janitor_icons)
	var/janitor_robot_icon = show_radial_menu(cyborg, cyborg , janitor_icons, custom_check = CALLBACK(src, .proc/check_menu, cyborg, old_model), radius = 42, require_near = TRUE)
	switch(janitor_robot_icon)
		if("Default")
			cyborg_base_icon = "janitor"
		if("Zoomba")
			cyborg_base_icon = "zoomba_jani"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
			has_snowflake_deadsprite = TRUE
		if("Marina")
			cyborg_base_icon = "marinajan"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Sleek")
			cyborg_base_icon = "sleekjan"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Can")
			cyborg_base_icon = "canjan"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Heavy")
			cyborg_base_icon = "heavyres"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Bootyborg")
			cyborg_base_icon = "bootyjanitor"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Male Bootyborg")
			cyborg_base_icon = "male_bootyjanitor"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Bird Borg")
			cyborg_base_icon = "bird_jani"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Protectron")
			cyborg_base_icon = "protectron_janitor"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Miss m")
			cyborg_base_icon = "missm_janitor"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		//Dogborgs
		if("Scrubpuppy")
			cyborg_base_icon = "scrubpup"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/widerobot.dmi'
			sleeper_overlay = "jsleeper"
			dogborg = TRUE
		if("Otie")
			cyborg_base_icon = "otiej"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/widerobot.dmi'
			sleeper_overlay = "otiejsleeper"
			dogborg = TRUE
		if("Drake")
			cyborg_base_icon = "drakejanit"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/widerobot.dmi'
			sleeper_overlay = "drakesecsleeper"
			dogborg = TRUE
		else
			return FALSE
	return ..()

//CLOWN
/obj/item/robot_model/clown/be_transformed_to(obj/item/robot_model/old_model)
	var/mob/living/silicon/robot/cyborg = loc
	var/static/list/clown_icons = sortList(list(
		"Default" = image(icon = 'icons/mob/robots.dmi', icon_state = "clown"),
		"Bootyborg" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "bootyclown"),
		"Male Bootyborg" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "male_bootyclown"),
		"Marina" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "marina_mommy"),
		"Garish" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "garish"),
		"Robot" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "clownbot"),
		"Sleek" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "clownman")
		))
	var/clown_borg_icon = show_radial_menu(cyborg, cyborg , clown_icons, custom_check = CALLBACK(src, .proc/check_menu, cyborg, old_model), radius = 42, require_near = TRUE)
	switch(clown_borg_icon)
		if("Default")
			cyborg_base_icon = "clown"
		if("Bootyborg")
			cyborg_base_icon = "bootyclown"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Male Bootyborg")
			cyborg_base_icon = "male_bootyclown"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Marina")
			cyborg_base_icon = "marina_mommy"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
			has_snowflake_deadsprite = TRUE
		if("Garish")
			cyborg_base_icon = "garish"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Robot")
			cyborg_base_icon = "clownbot"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Sleek")
			cyborg_base_icon = "clownman"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
			has_snowflake_deadsprite = TRUE
		else
			return FALSE
	return ..()

//SERVICE
/obj/item/robot_model/service/be_transformed_to(obj/item/robot_model/old_model)
	var/mob/living/silicon/robot/cyborg = loc
	var/static/list/service_icons
	if(!service_icons)
		service_icons = list(
		"Bro" = image(icon = 'icons/mob/robots.dmi', icon_state = "brobot"),
		"Butler" = image(icon = 'icons/mob/robots.dmi', icon_state = "service_m"),
		"Can" = image(icon = 'icons/mob/robots.dmi', icon_state = "kent"),
		"Tophat" = image(icon = 'icons/mob/robots.dmi', icon_state = "tophat"),
		"Waitress" = image(icon = 'icons/mob/robots.dmi', icon_state = "service_f"),
		"Sleek" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "sleekserv"),
		"Heavy" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "heavyserv"),
		"Bootyborg" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "bootyservice"),
		"Male Bootyborg" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "male_bootyservice"),
		"Bird Borg" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "bird_serv"),
		"Protectron" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "protectron_service"),
		"Miss m" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "missm_service"),
		)
		var/list/L = list("DarkK9" = "k50", "Vale" = "valeserv", "ValeDark" = "valeservdark", "Fabulous" = "k69")
		for(var/a in L)
			var/image/wide = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/widerobot.dmi', icon_state = L[a])
			wide.pixel_x = -16
			service_icons[a] = wide
		service_icons = sortList(service_icons)
	var/service_robot_icon = show_radial_menu(cyborg, cyborg , service_icons, custom_check = CALLBACK(src, .proc/check_menu, cyborg, old_model), radius = 42, require_near = TRUE)
	switch(service_robot_icon)
		if("Bro")
			cyborg_base_icon = "brobot"
		if("Butler")
			cyborg_base_icon = "service_m"
		if("Can")
			cyborg_base_icon = "kent"
			special_light_key = "medical"
			hat_offset = 3
		if("Tophat")
			cyborg_base_icon = "tophat"
			special_light_key = null
			hat_offset = INFINITY //He is already wearing a hat
		if("Waitress")
			cyborg_base_icon = "service_f"
		if("Sleek")
			cyborg_base_icon = "sleekserv"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Heavy")
			cyborg_base_icon = "heavyserv"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Bootyborg")
			cyborg_base_icon = "bootyservice"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Male Bootyborg")
			cyborg_base_icon = "male_bootyservice"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Bird Borg")
			cyborg_base_icon = "bird_serv"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Protectron")
			cyborg_base_icon = "protectron_service"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Miss m")
			cyborg_base_icon = "missm_service"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		//Dogborgs
		if("DarkK9")
			cyborg_base_icon = "k50"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/widerobot.dmi'
			sleeper_overlay = "ksleeper"
			dogborg = TRUE
		if("Vale")
			cyborg_base_icon = "valeserv"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/widerobot.dmi'
			sleeper_overlay = "valeservsleeper"
			dogborg = TRUE
		if("ValeDark")
			cyborg_base_icon = "valeservdark"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/widerobot.dmi'
			sleeper_overlay = "valeservsleeper"
			dogborg = TRUE
		if("Fabulous")
			cyborg_base_icon = "k69"
			sleeper_overlay = "k9sleeper"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/widerobot.dmi'
			dogborg = TRUE
		else
			return FALSE
	return ..()

//MINING
/obj/item/robot_model/miner/be_transformed_to(obj/item/robot_model/old_model)
	var/mob/living/silicon/robot/cyborg = loc
	var/static/list/mining_icons
	if(!mining_icons)
		mining_icons = list(
		"Asteroid Miner" = image(icon = 'icons/mob/robots.dmi', icon_state = "minerOLD"),
		"Spider Miner" = image(icon = 'icons/mob/robots.dmi', icon_state = "spidermin"),
		"Lavaland Miner" = image(icon = 'icons/mob/robots.dmi', icon_state = "miner"),
		"Droid" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "miner"),
		"Sleek" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "sleekmin"),
		"Marina" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "marinamin"),
		"Can" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "canmin"),
		"Heavy" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "heavymin"),
		"Bootyborg" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "bootyminer"),
		"Male Bootyborg" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "male_bootyminer"),
		"Bird Borg Mining" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "bird_mine"),
		"Bird Borg Cargo" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "bird_cargo"),
		"Protectron" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "protectron_miner"),
		"Miss m" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "missm_miner"),
		"Zoomba" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi', icon_state = "zoomba_miner"),
		"Drake" = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/widerobot.dmi', icon_state = "drakeminebox")
		)
		var/list/L = list("Blade" = "blade", "Vale" = "valemine")
		for(var/a in L)
			var/image/wide = image(icon = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/widerobot.dmi', icon_state = L[a])
			wide.pixel_x = -16
			mining_icons[a] = wide
		mining_icons = sortList(mining_icons)
	var/mining_borg_icon = show_radial_menu(cyborg, cyborg, mining_icons, custom_check = CALLBACK(src, .proc/check_menu, cyborg, old_model), radius = 42, require_near = TRUE)
	switch(mining_borg_icon)
		if("Asteroid Miner")
			cyborg_base_icon = "minerOLD"
			special_light_key = "miner"
		if("Spider Miner")
			cyborg_base_icon = "spidermin"
		if("Lavaland Miner")
			cyborg_base_icon = "miner"
		if("Droid")
			cyborg_base_icon = "miner"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
			hat_offset = 4
		if("Sleek")
			cyborg_base_icon = "sleekmin"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Can")
			cyborg_base_icon = "canmin"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Marina")
			cyborg_base_icon = "marinamin"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Spider")
			cyborg_base_icon = "spidermin"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Heavy")
			cyborg_base_icon = "heavymin"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Bootyborg")
			cyborg_base_icon = "bootyminer"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Male Bootyborg")
			cyborg_base_icon = "male_bootyminer"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Bird Borg Mining")
			cyborg_base_icon = "bird_mine"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Bird Borg Cargo")
			cyborg_base_icon = "bird_cargo"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Protectron")
			cyborg_base_icon = "protectron_miner"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Miss m")
			cyborg_base_icon = "missm_miner"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
		if("Zoomba")
			cyborg_base_icon = "zoomba_miner"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/robots.dmi'
			has_snowflake_deadsprite = TRUE
		//Dogborgs
		if("Blade")
			cyborg_base_icon = "blade"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/widerobot.dmi'
			sleeper_overlay = "bladesleeper"
			dogborg = TRUE
		if("Vale")
			cyborg_base_icon = "valemine"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/widerobot.dmi'
			sleeper_overlay = "valeminesleeper"
			dogborg = TRUE
		if("Drake")
			cyborg_base_icon = "drakemine"
			cyborg_icon_override = 'code/modules/mob/living/silicon/robot/altborgs/icons/mob/widerobot.dmi'
			sleeper_overlay = "drakeminesleeper"
			dogborg = TRUE
		else
			return FALSE
	return ..()

/// Trim for admins and debug cards. Has every single access in the game.
/datum/id_trim/admin
	assignment = "Jannie"
	department_state = "dept-adm-gold"
	department_color = COLOR_CENTCOM_BLUE
	subdepartment_color = COLOR_SERVICE_LIME

/datum/id_trim/admin/New()
	. = ..()
	// Every single access in the game, all on one handy trim.
	access = SSid_access.get_region_access_list(list(REGION_ALL_GLOBAL))

/// Trim for highlander cards, used during the highlander adminbus event.
/datum/id_trim/highlander
	assignment = "Highlander"
	department_state = "dept-deathsquad"
	department_color = COLOR_CENTCOM_BLUE
	subdepartment_color = COLOR_SERVICE_LIME

/datum/id_trim/highlander/New()
	. = ..()
	access = SSid_access.get_region_access_list(list(REGION_CENTCOM, REGION_ALL_STATION))

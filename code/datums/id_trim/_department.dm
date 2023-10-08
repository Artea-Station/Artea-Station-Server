// Not using job or department datums due to the fact I want to support adding weird random departments for ghost roles and such.
/datum/id_department
	/// The region tied to this department. When put on an ID, all accesses in the region are granted. Unless it's a subdepartment on a grey ID, in which case, only basic access is granted.
	var/region
	/// The department's colour. Shown on the relevant stripe.
	var/color
	/// The department's icon state. Shown in the top right of the ID.
	var/icon_state

/datum/id_department/command
	region = "Command"
	color = COLOR_COMMAND_BLUE
	icon_state = "dept-command"

/datum/id_department/engineering
	region = "Engineering"
	color = COLOR_ENGINEERING_ORANGE
	icon_state = "dept-engineering"

/datum/id_department/medical
	region = "Medical"
	color = COLOR_MEDICAL_BLUE
	icon_state = "dept-medical"

/datum/id_department/pathfinders
	region = "Pathfinders"
	color = COLOR_PATHFINDERS_PURPLE
	icon_state = "dept-pathfinders"

/datum/id_department/security
	region = "Security"
	color = COLOR_SECURITY_RED
	icon_state = "dept-security"

/datum/id_department/service
	region = "Service"
	color = COLOR_SERVICE_LIME
	icon_state = "dept-service"

/datum/id_department/cargo
	region = "Cargo"
	color = COLOR_CARGO_BROWN
	icon_state = "dept-cargo"

/datum/id_department/syndicate
	region = "Syndicate"
	color = COLOR_SYNDIE_RED
	icon_state = "dept-security"

/datum/id_department/centcom
	region = "Central Command"
	color = COLOR_CENTCOM_BLUE
	icon_state = "dept-corporate"

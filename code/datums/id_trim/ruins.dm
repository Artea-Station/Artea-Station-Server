/// Generic away/offstation trim.
/datum/id_trim/away
	access = list(ACCESS_AWAY_GENERAL)

/// Trim for the hotel ruin. Not Hilbert's Hotel.
/datum/id_trim/away/hotel
	access = list(ACCESS_AWAY_GENERAL, ACCESS_AWAY_MAINTENANCE)

/// Trim for the hotel ruin. Not Hilbert's Hotel.
/datum/id_trim/away/hotel/security
	access = list(ACCESS_AWAY_GENERAL, ACCESS_AWAY_MAINTENANCE, ACCESS_AWAY_SEC)

/// Trim for the oldstation ruin/Charlie station
/datum/id_trim/away/old/sec
	access = list(ACCESS_AWAY_GENERAL, ACCESS_AWAY_SEC)
	assignment = "Charlie Station Security Officer"

/// Trim for the oldstation ruin/Charlie station
/datum/id_trim/away/old/sci
	access = list(ACCESS_AWAY_GENERAL, ACCESS_AWAY_SCIENCE)
	assignment = "Charlie Station Scientist"

/// Trim for the oldstation ruin/Charlie station
/datum/id_trim/away/old/eng
	access = list(ACCESS_AWAY_GENERAL, ACCESS_AWAY_ENGINEERING)
	assignment = "Charlie Station Engineer"

/// Trim for the oldstation ruin/Charlie station to access APCs and other equipment
/datum/id_trim/away/old/apc
	access = list(ACCESS_ENGINEERING_LOWSEC, ACCESS_ENGINEERING_LOWSEC)
	assignment = "Engineering Equipment Access"

/// Trim for the oldstation ruin/Charlie station to access robots, and downloading of paper publishing software for experiments
/datum/id_trim/away/old/robo
	access = list(ACCESS_AWAY_GENERAL, ACCESS_ENGINEERING_HIGHSEC, ACCESS_ENGINEERING_HIGHSEC)

/// Trim for the cat surgeon ruin.
/datum/id_trim/away/cat_surgeon
	assignment = "Cat Surgeon"
	department_state = "dept-medical"
	department_color = COLOR_MEDICAL_BLUE
	subdepartment_color = COLOR_SERVICE_LIME
	access = list(ACCESS_AWAY_GENERAL, ACCESS_AWAY_MAINTENANCE)

/// Trim for Hilbert in Hilbert's Hotel.
/datum/id_trim/away/hilbert
	assignment = "Head Researcher"
	department_color = COLOR_COMMAND_BLUE
	subdepartment_color = COLOR_SCIENCE_PINK
	department_state = "dept-science"
	access = list(ACCESS_AWAY_GENERIC3, ACCESS_PATHFINDERS_LOWSEC)

/// Trim for beach bum lifeguards.
/datum/id_trim/lifeguard
	assignment = "Lifeguard"

/// Trim for beach bum bartenders.
/datum/id_trim/space_bartender
	assignment = "Space Bartender"
	department_state = "dept-service"
	department_color = COLOR_SERVICE_LIME
	subdepartment_color = COLOR_SERVICE_LIME
	access = list(ACCESS_SERVICE_HIGHSEC, ACCESS_SERVICE_LOWSEC)

/// Trim for various Centcom corpses.
/datum/id_trim/centcom/corpse/bridge_officer
	assignment = "Bridge Officer"
	access = list(ACCESS_CENTCOM_HIGHSEC)

/// Trim for various Centcom corpses.
/datum/id_trim/centcom/corpse/commander
	assignment = "Commander"
	access = list(ACCESS_CENTCOM_HIGHSEC, ACCESS_CENTCOM_LOWSEC, ACCESS_CENTCOM_HIGHSEC, ACCESS_CENTCOM_LOWSEC, ACCESS_CENTCOM_HIGHSEC)

/// Trim for various Centcom corpses.
/datum/id_trim/centcom/corpse/private_security
	assignment = JOB_CENTCOM_PRIVATE_SECURITY
	department_color = COLOR_CENTCOM_BLUE
	subdepartment_color = COLOR_CENTCOM_BLUE
	access = list(ACCESS_CENTCOM_HIGHSEC, ACCESS_CENTCOM_LOWSEC, ACCESS_CENTCOM_HIGHSEC, ACCESS_CENTCOM_LOWSEC, ACCESS_CENTCOM_HIGHSEC, ACCESS_SECURITY_LOWSEC, ACCESS_SECURITY_VEHICLES)

/// Trim for various Centcom corpses.
/datum/id_trim/centcom/corpse/private_security/tradepost_officer
	assignment = "Tradepost Officer"
	subdepartment_color = COLOR_CARGO_BROWN

/// Trim for various Centcom corpses.
/datum/id_trim/centcom/corpse/assault
	assignment = "Nanotrasen Assault Force"
	access = list(ACCESS_CENTCOM_HIGHSEC, ACCESS_CENTCOM_LOWSEC, ACCESS_CENTCOM_HIGHSEC, ACCESS_CENTCOM_LOWSEC, ACCESS_CENTCOM_HIGHSEC, ACCESS_SECURITY_LOWSEC, ACCESS_SECURITY_VEHICLES)

/// Trim for various various ruins.
/datum/id_trim/engioutpost
	assignment = "Senior Station Engineer"
	department_state = "dept-engineering"
	department_color = COLOR_ENGINEERING_ORANGE
	subdepartment_color = COLOR_ENGINEERING_ORANGE
	access = list(ACCESS_AWAY_GENERAL, ACCESS_AWAY_ENGINEERING, ACCESS_ENGINEERING_LOWSEC, ACCESS_ENGINEERING_LOWSEC, ACCESS_ARTEA_COMMON)

/// Trim for various various ruins.
/datum/id_trim/job/station_engineer/gunner
	assignment = "Gunner"
	template_access = null

/// Trim for pirates.
/datum/id_trim/pirate
	assignment = "Pirate"
	department_state = "dept-deathsquad"
	department_color = COLOR_MOSTLY_PURE_RED
	subdepartment_color = COLOR_MOSTLY_PURE_RED
	access = list(ACCESS_SYNDICATE_LOWSEC)

/// Trim for pirates.
/datum/id_trim/pirate/silverscale
	assignment = "Silver Scale Member"

/// Trim for the pirate captain.
/datum/id_trim/pirate/captain
	assignment = "Pirate Captain"
	department_state = "dept-deathsquad-gold"

/// Trim for the pirate captain.
/datum/id_trim/pirate/captain/silverscale
	assignment = "Silver Scale VIP"

//Trims for waystation.dmm space ruin
/datum/id_trim/away/waystation/cargo_technician
	assignment = "Waystation Cargo Hauler"
	department_state = "dept-cargo"
	department_color = COLOR_CARGO_BROWN
	access = list(ACCESS_AWAY_SUPPLY)

/datum/id_trim/away/waystation/quartermaster
	assignment = "Waystation Quartermaster"
	department_state = "dept-cargo"
	department_color = COLOR_CARGO_BROWN
	access = list(ACCESS_AWAY_SUPPLY, ACCESS_AWAY_COMMAND)

/datum/id_trim/away/waystation/security
	assignment = "Waystation Security Officer"
	department_state = "dept-security"
	department_color = COLOR_CARGO_BROWN
	access = list(ACCESS_AWAY_SUPPLY, ACCESS_AWAY_SEC)

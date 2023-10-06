/// Trim for Syndicate mobs, outfits and corpses.
/datum/id_trim/syndicom
	assignment = "Syndicate Overlord"
	department_state = "dept-vip"
	department_color = COLOR_SYNDIE_RED
	subdepartment_color = COLOR_SYNDIE_RED
	sechud_icon_state = SECHUD_SYNDICATE
	access = list(ACCESS_SYNDICATE_LOWSEC)

/// Trim for Syndicate mobs, outfits and corpses.
/datum/id_trim/syndicom/crew
	assignment = "Syndicate Operative"
	access = list(ACCESS_SYNDICATE_LOWSEC, ACCESS_ENGINEERING_HIGHSEC)

/// Trim for Syndicate mobs, outfits and corpses.
/datum/id_trim/syndicom/captain
	assignment = "Syndicate Ship Captain"
	department_state = "dept-captain-gold"
	access = list(ACCESS_SYNDICATE_LOWSEC, ACCESS_SYNDICATE_HIGHSEC, ACCESS_ENGINEERING_HIGHSEC)

/// Trim for Syndicate mobs, outfits and corpses.
/datum/id_trim/battlecruiser
	assignment = "Syndicate Battlecruiser Crew"
	department_state = "dept-security"
	access = list(ACCESS_SYNDICATE_LOWSEC)

/// Trim for Syndicate mobs, outfits and corpses.
/datum/id_trim/battlecruiser/captain
	assignment = "Syndicate Battlecruiser Captain"
	access = list(ACCESS_SYNDICATE_LOWSEC, ACCESS_SYNDICATE_HIGHSEC)

/// Trim for Chameleon ID cards. Many outfits, nuke ops and some corpses hold Chameleon ID cards.
/datum/id_trim/chameleon
	assignment = "Unknown"
	letter_state = "letter-darkof"
	access = list(ACCESS_SYNDICATE_LOWSEC, ACCESS_ARTEA_COMMON)

/// Trim for Chameleon ID cards. Many outfits, nuke ops and some corpses hold Chameleon ID cards.
/datum/id_trim/chameleon/operative
	assignment = "Syndicate Operative"
	department_state = "dept-security"
	department_color = COLOR_SYNDIE_RED
	subdepartment_color = COLOR_SYNDIE_RED
	sechud_icon_state = SECHUD_SYNDICATE

/// Trim for Chameleon ID cards. Many outfits, nuke ops and some corpses hold Chameleon ID cards.
/datum/id_trim/chameleon/operative/nuke_leader
	assignment = "Syndicate Operative Leader"
	department_state = "dept-security"
	access = list(ACCESS_ARTEA_COMMON, ACCESS_SYNDICATE_LOWSEC, ACCESS_SYNDICATE_HIGHSEC)

/// Trim for Chameleon ID cards. Many outfits, nuke ops and some corpses hold Chameleon ID cards.
/datum/id_trim/chameleon/operative/clown
	assignment = "Syndicate Entertainment Operative"
	department_state = "dept-clown"

/// Trim for Chameleon ID cards. Many outfits, nuke ops and some corpses hold Chameleon ID cards.
/datum/id_trim/chameleon/operative/clown_leader
	assignment = "Syndicate Entertainment Operative Leader"
	access = list(ACCESS_ARTEA_COMMON, ACCESS_SYNDICATE_LOWSEC, ACCESS_SYNDICATE_HIGHSEC)

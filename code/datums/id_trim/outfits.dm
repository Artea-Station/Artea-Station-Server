/**
 * This file contains all the trims associated with outfits.
 */

/// Trim for the assassin outfit.
/datum/id_trim/reaper_assassin
	assignment = "Reaper"
	department_state = "dept-deathsquad"
	department_color = COLOR_DARK
	subdepartment_color = COLOR_RED // I AM THE VIOLENCE

/datum/id_trim/highlander/New()
	. = ..()
	access = SSid_access.get_region_access_list(list(REGION_ALL_STATION))

/// Trim for the mobster outfit.
/datum/id_trim/mobster
	assignment = "Mobster"
	department_state = "dept-civilian"

/// Trim for VR outfits.
/datum/id_trim/vr
	assignment = "VR Participant"

/datum/id_trim/vr/New()
	. = ..()
	access |= SSid_access.get_region_access_list(list(REGION_ALL_STATION))

/// Trim for VR outfits.
/datum/id_trim/vr/operative
	assignment = "Syndicate VR Operative"
	department_color = COLOR_RED
	subdepartment_color = COLOR_RED

/datum/id_trim/vr/operative/New()
	. = ..()
	access |= list(ACCESS_SYNDICATE, ACCESS_MAINT_TUNNELS)

/// Trim for the Tunnel Clown! outfit. Has all access.
/datum/id_trim/tunnel_clown
	assignment = "Tunnel Clown!"
	department_state = "dept-clown"
	department_color = COLOR_MAGENTA
	subdepartment_color = COLOR_MAGENTA

/datum/id_trim/tunnel_clown/New()
	. = ..()
	access |= SSid_access.get_region_access_list(list(REGION_ALL_STATION))

/// Trim for Bounty Hunters NOT hired by centcom. (?)
/datum/id_trim/bounty_hunter
	assignment = "Bounty Hunter"
	department_color = COLOR_PRISONER_ORANGE
	subdepartment_color = COLOR_PRISONER_BLACK

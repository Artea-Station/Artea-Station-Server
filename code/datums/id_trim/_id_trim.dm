/// Simple datum that holds the basic information associated with an ID card trim.
/datum/id_trim
	/// Icon file for this trim.
	var/trim_icon = 'icons/obj/card.dmi'
	/// Department icon state, for differentiating between heads and normal crew and other use cases.
	var/department_state
	/// Department color for this trim. Displayed in the box under the department_state.
	var/department_color = COLOR_ASSISTANT_GRAY
	/// The company letter/logo displayed on the ID.
	var/letter_state = "letter-unknown"
	/// Subdepartment color for this trim. Displayed as a bar under the department_state and department_color.
	var/subdepartment_color = COLOR_ASSISTANT_OLIVE
	/// Job/assignment associated with this trim. Can be transferred to ID cards holding this trim.
	var/assignment
	/// The name of the job for interns. If unset it will default to "[assignment] (Intern)".
	var/intern_alt_name
	/// The icon_state associated with this trim, as it will show on the security HUD.
	var/sechud_icon_state = SECHUD_UNKNOWN
	/// Icons to be displayed in the orbit ui. Source: FontAwesome v5. Use the FA_ICON defines.
	var/orbit_icon

	/// A list of regions that will be visible to the ID modification console for this specific trim.
	/// Accepts both ACCESS_REGION_ and ACCESS_REGIONS_ defines.
	var/special_regions = list(ACCESS_REGIONS_STATION)

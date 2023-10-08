/**
 * Non-processing subsystem that holds various procs and data structures to manage ID cards, trims and access.
 */
SUBSYSTEM_DEF(id_access)
	name = "IDs and Access"
	init_order = INIT_ORDER_IDACCESS
	flags = SS_NO_FIRE

	/// Dictionary of trim singletons. Keys are paths. Values are their associated singletons.
	var/list/trim_singletons_by_path = list()
	/// Dictionary of access names. Keys are access levels. Values are their associated names.
	var/list/access_to_name = ALL_ACCESS_NAMES
	/// List of accesses for the Heads of each sub-department alongside the regions they control and their job name.
	var/list/sub_department_managers_tgui = list()
	/// Helper list containing all trim paths that can be used as job templates. Intended to be used alongside logic for ACCESS_COMMAND_LOWSEC. Grab templates from sub_department_managers_tgui for Head of Staff restrictions.
	var/list/station_job_templates = list()
	/// Helper list containing all trim paths that can be used as Centcom templates.
	var/list/centcom_job_templates = list()
	/// Helper list containing all PDA paths that can be painted by station machines. Intended to be used alongside logic for ACCESS_COMMAND_LOWSEC. Grab templates from sub_department_managers_tgui for Head of Staff restrictions.
	var/list/station_pda_templates = list()

	/// Region to access. Shrimple. Any access not on this list cannot be accessed without VV!
	var/list/region_name_to_accesses = list(
		ACCESS_REGION_STATION_HEADS_NAME = ACCESS_REGION_STATION_HEADS,
		ACCESS_REGION_COMMAND_NAME = ACCESS_REGION_COMMAND,
		ACCESS_REGION_ENGINEERING_NAME = ACCESS_REGION_ENGINEERING,
		ACCESS_REGION_MEDICAL_NAME = ACCESS_REGION_MEDICAL,
		ACCESS_REGION_PATHFINDERS_NAME = ACCESS_REGION_PATHFINDERS,
		ACCESS_REGION_SECURITY_NAME = ACCESS_REGION_SECURITY,
		ACCESS_REGION_SERVICE_NAME = ACCESS_REGION_SERVICE,
		ACCESS_REGION_CARGO_NAME = ACCESS_REGION_CARGO,
		ACCESS_REGION_CENTCOM_NAME = ACCESS_REGION_CENTCOM,
		ACCESS_REGION_SYNDICATE_NAME = ACCESS_REGION_SYNDICATE,
	)

	/// A list of ID manufacturers to regions that they natively can access. These DO NOT prevent IDs from gaining accesses not inside these via non-ID-console means!
	var/list/manufacturer_to_region_names = list(
		ID_MANUFACTURER_UNKNOWN = list(), // These can't be edited. Oh no!
		ID_MANUFACTURER_ARTEA = list(
			ACCESS_REGION_STATION_HEADS_NAME,
			ACCESS_REGION_COMMAND_NAME,
			ACCESS_REGION_ENGINEERING_NAME,
			ACCESS_REGION_MEDICAL_NAME,
			ACCESS_REGION_PATHFINDERS_NAME,
			ACCESS_REGION_SECURITY_NAME,
			ACCESS_REGION_SERVICE_NAME,
			ACCESS_REGION_CARGO_NAME,
			ACCESS_REGION_CENTCOM_NAME,
		),
		ID_MANUFACTURER_SYNDICATE = list( // Syndie and darkof IDs can be given normal station (but not centcom) accesses freely.
			ACCESS_REGION_STATION_HEADS_NAME,
			ACCESS_REGION_COMMAND_NAME,
			ACCESS_REGION_ENGINEERING_NAME,
			ACCESS_REGION_MEDICAL_NAME,
			ACCESS_REGION_PATHFINDERS_NAME,
			ACCESS_REGION_SECURITY_NAME,
			ACCESS_REGION_SERVICE_NAME,
			ACCESS_REGION_CARGO_NAME,
			ACCESS_REGION_SYNDICATE_NAME,
		),
		ID_MANUFACTURER_DARKOF = list(
			ACCESS_REGION_STATION_HEADS_NAME,
			ACCESS_REGION_COMMAND_NAME,
			ACCESS_REGION_ENGINEERING_NAME,
			ACCESS_REGION_MEDICAL_NAME,
			ACCESS_REGION_PATHFINDERS_NAME,
			ACCESS_REGION_SECURITY_NAME,
			ACCESS_REGION_SERVICE_NAME,
			ACCESS_REGION_CARGO_NAME,
			ACCESS_REGION_SYNDICATE_NAME,
		),
	)

	/// A list of accesses that are silver ID only.
	/// !!NOTE!!: Before the subsystem initializes, this is a mixed list of regions and accesses, which are then converted.
	var/silver_accesses = list(
		ACCESS_REGION_STATION_HEADS_NAME,
		ACCESS_REGION_COMMAND_NAME,
	)

	/// The roundstart generated code for the spare ID safe. This is given to the Captain on shift start. If there's no Captain, it's given to the HoP. If there's no HoP
	var/spare_id_safe_code = ""

/datum/controller/subsystem/id_access/Initialize()
	// Look man, I don't want to hardcode every single access if I don't have to.
	var/silver_access_regions = silver_accesses
	silver_accesses = list()
	for(var/region in silver_access_regions)
		// If it's a valid region, slap the accesses inside.
		// If it's not, then uh- I hope it's an access!
		silver_accesses |= region_name_to_accesses[region] || region

	spare_id_safe_code = "[rand(0,9)][rand(0,9)][rand(0,9)][rand(0,9)][rand(0,9)]"

	return SS_INIT_SUCCESS

/datum/controller/subsystem/id_access/proc/get_region_access_list(list/regions)
	var/list/accesses = list()

	for(var/region in regions)
		if(islist(region)) // Allow for being lazy with the defines to save lots of effort. Cursed? Maybe. Do I care much at this point? Nope. - Rimi
			for(var/access in get_region_access_list(region))
				accesses |= access

		var/list/temp_accesses = region_name_to_accesses[region]
		if(temp_accesses)
			for(var/access in temp_accesses)
				accesses |= access

	return accesses

/**
 * Applies a trim singleton to a card.
 *
 * Returns FALSE if the trim could not be applied due to being incompatible with the card.
 * Incompatibility is defined as a card not being able to hold all the trim's required wildcards.
 * Returns TRUE otherwise.
 * Arguments:
 * * id_card - ID card to apply the trim_path to.
 * * trim_path - A trim path to apply to the card. Grabs the trim's associated singleton and applies it.
 * * copy_access - Boolean value. If true, the trim's access is also copied to the card.
 */
/datum/controller/subsystem/id_access/proc/apply_trim_to_card(obj/item/card/id/id_card, trim_path, copy_access = TRUE)
	var/datum/id_trim/trim = trim_singletons_by_path[trim_path]

	if(!id_card.can_edit_region(trim.wildcard_access))
		return FALSE

	id_card.clear_access()
	id_card.trim = trim

	if(copy_access)
		id_card.access = trim.access.Copy()
		id_card.add_regions(trim.wildcard_access)


	if(trim.assignment)
		id_card.assignment = trim.assignment

	id_card.update_label()
	id_card.update_icon()

	return TRUE

/**
 * Removes a trim from an ID card. Also removes all accesses from it too.
 *
 * Arguments:
 * * id_card - The ID card to remove the trim from.
 */
/datum/controller/subsystem/id_access/proc/remove_trim_from_card(obj/item/card/id/id_card)
	id_card.trim = null
	id_card.clear_access()
	id_card.update_label()
	id_card.update_icon()

/**
 * Applies a trim to a chameleon card. This is purely visual, utilising the card's override vars.
 *
 * Arguments:
 * * id_card - The chameleon card to apply the trim visuals to.
* * trim_path - A trim path to apply to the card. Grabs the trim's associated singleton and applies it.
 * * check_forged - Boolean value. If TRUE, will not overwrite the card's assignment if the card has been forged.
 */
/datum/controller/subsystem/id_access/proc/apply_trim_to_chameleon_card(obj/item/card/id/advanced/chameleon/id_card, trim_path, check_forged = TRUE)
	var/datum/id_trim/trim = trim_singletons_by_path[trim_path]
	id_card.trim_icon_override = trim.trim_icon
	id_card.trim_assignment_override = trim.assignment
	id_card.sechud_icon_state_override = trim.sechud_icon_state
	id_card.department_color_override = trim.department_color
	id_card.department_state_override = trim.department_state
	id_card.subdepartment_color_override = trim.subdepartment_color

	if(!check_forged || !id_card.forged)
		id_card.assignment = trim.assignment

	// We'll let the chameleon action update the card's label as necessary instead of doing it here.

/**
 * Removes a trim from a chameleon ID card.
 *
 * Arguments:
 * * id_card - The ID card to remove the trim from.
 */
/datum/controller/subsystem/id_access/proc/remove_trim_from_chameleon_card(obj/item/card/id/advanced/chameleon/id_card)
	id_card.trim_icon_override = null
	id_card.trim_letter_state_override = null
	id_card.trim_assignment_override = null
	id_card.sechud_icon_state_override = null
	id_card.department_color_override = null
	id_card.department_state_override = null
	id_card.subdepartment_color_override = null

/**
 * Adds the accesses associated with a trim to an ID card.
 *
 * Clears the card's existing access levels first.
 * Primarily intended for applying trim templates to cards. Will attempt to add as many ordinary access
 * levels as it can, without consuming any wildcards. Will then attempt to apply the trim-specific wildcards after.
 *
 * Arguments:
 * * id_card - The ID card to remove the trim from.
 */
/datum/controller/subsystem/id_access/proc/add_trim_access_to_card(obj/item/card/id/id_card, trim_path)
	var/datum/id_trim/trim = trim_singletons_by_path[trim_path]

	id_card.clear_access()

	id_card.add_access(trim.access, mode = TRY_ADD_ALL_NO_WILDCARD)
	id_card.add_regions(trim.wildcard_access, mode = TRY_ADD_ALL)
	if(istype(trim, /datum/id_trim/job))
		var/datum/id_trim/job/job_trim = trim // Here is where we update a player's paycheck department for the purposes of discounts/paychecks.
		id_card.registered_account.account_job.paycheck_department = job_trim.job.paycheck_department

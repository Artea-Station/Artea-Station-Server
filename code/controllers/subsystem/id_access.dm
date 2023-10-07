/**
 * Non-processing subsystem that holds various procs and data structures to manage ID cards, trims and access.
 */
SUBSYSTEM_DEF(id_access)
	name = "IDs and Access"
	init_order = INIT_ORDER_IDACCESS
	flags = SS_NO_FIRE

	/// Dictionary of access flags. Keys are accesses. Values are their associated bitflags.
	var/list/flags_by_access = list()
	/// Dictionary of access lists. Keys are access flag names. Values are lists of all accesses as part of that access.
	var/list/accesses_by_flag = list()
	/// Dictionary of access flag string representations. Keys are bitflags. Values are their associated names.
	var/list/access_flag_string_by_flag = list()
	/// Dictionary of trim singletons. Keys are paths. Values are their associated singletons.
	var/list/trim_singletons_by_path = list()
	/// Dictionary of wildcard compatibility flags. Keys are strings for the wildcards. Values are their associated flags.
	var/list/wildcard_flags_by_wildcard = list()
	/// Dictionary of accesses based on station region. Keys are region strings. Values are lists of accesses.
	var/list/accesses_by_region = list()
	/// Specially formatted list for sending access levels to tgui interfaces.
	var/list/all_region_access_tgui = list()
	/// Dictionary of access names. Keys are access levels. Values are their associated names.
	var/list/desc_by_access = ALL_ACCESS_NAMES
	/// List of accesses for the Heads of each sub-department alongside the regions they control and their job name.
	var/list/sub_department_managers_tgui = list()
	/// Helper list containing all trim paths that can be used as job templates. Intended to be used alongside logic for ACCESS_COMMAND_LOWSEC. Grab templates from sub_department_managers_tgui for Head of Staff restrictions.
	var/list/station_job_templates = list()
	/// Helper list containing all trim paths that can be used as Centcom templates.
	var/list/centcom_job_templates = list()
	/// Helper list containing all PDA paths that can be painted by station machines. Intended to be used alongside logic for ACCESS_COMMAND_LOWSEC. Grab templates from sub_department_managers_tgui for Head of Staff restrictions.
	var/list/station_pda_templates = list()
	/// Helper list containing all station regions.
	var/list/station_regions = ACCESS_REGIONS_STATION

	/// The roundstart generated code for the spare ID safe. This is given to the Captain on shift start. If there's no Captain, it's given to the HoP. If there's no HoP
	var/spare_id_safe_code = ""

/datum/controller/subsystem/id_access/Initialize()
	// We use this because creating the trim singletons requires the config to be loaded.
	setup_trim_singletons()

	spare_id_safe_code = "[rand(0,9)][rand(0,9)][rand(0,9)][rand(0,9)][rand(0,9)]"

	return SS_INIT_SUCCESS

/**
 * Called by [/datum/controller/subsystem/ticker/proc/setup]
 *
 * This runs through every /datum/id_trim/job singleton and ensures that its access is setup according to
 * appropriate config entries.
 */
/datum/controller/subsystem/id_access/proc/refresh_job_trim_singletons()
	for(var/trim in typesof(/datum/id_trim/job))
		var/datum/id_trim/job/job_trim = trim_singletons_by_path[trim]

		if(QDELETED(job_trim))
			stack_trace("Trim \[[trim]\] missing from trim singleton list. Reinitialising this trim.")
			trim_singletons_by_path[trim] = new trim()
			continue

		job_trim.refresh_trim_access()

/// Instantiate trim singletons and add them to a list.
/datum/controller/subsystem/id_access/proc/setup_trim_singletons()
	for(var/trim in typesof(/datum/id_trim))
		trim_singletons_by_path[trim] = new trim()

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

	if(!id_card.can_add_wildcards(trim.wildcard_access))
		return FALSE

	id_card.clear_access()
	id_card.trim = trim

	if(copy_access)
		id_card.access = trim.access.Copy()
		id_card.add_wildcards(trim.wildcard_access)


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
	id_card.add_wildcards(trim.wildcard_access, mode = TRY_ADD_ALL)
	if(istype(trim, /datum/id_trim/job))
		var/datum/id_trim/job/job_trim = trim // Here is where we update a player's paycheck department for the purposes of discounts/paychecks.
		id_card.registered_account.account_job.paycheck_department = job_trim.job.paycheck_department

/**
 * Tallies up all accesses the card has that have flags greater than or equal to the access_flag supplied.
 *
 * Returns the number of accesses that have flags matching access_flag or a higher tier access.
 * Arguments:
 * * id_card - The ID card to tally up access for.
 * * access_flag - The minimum access flag required for an access to be tallied up.
 */
/datum/controller/subsystem/id_access/proc/tally_access(obj/item/card/id/id_card, access_flag = NONE)
	var/tally = 0

	var/list/id_card_access = id_card.access
	for(var/access in id_card_access)
		if(flags_by_access["[access]"] >= access_flag)
			tally++

	return tally

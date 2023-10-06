/**
 * This file contains all the trims associated with station jobs.
 * It also contains special prisoner trims and the miner's spare ID trim.
 */

/// ID Trims for station jobs.
/datum/id_trim/job
	department_state = "dept-civilian"
	letter_state = "letter-artea"

	/// The extra access the card should have when CONFIG_GET(flag/jobs_have_minimal_access) is FALSE.
	var/list/extra_access = list()
	/// The extra wildcard_access the card should have when CONFIG_GET(flag/jobs_have_minimal_access) is FALSE.
	var/list/extra_wildcard_access = list()
	/// The base access the card should have when CONFIG_GET(flag/jobs_have_minimal_access) is TRUE.
	var/list/minimal_access = list()
	/// The base wildcard_access the card should have when CONFIG_GET(flag/jobs_have_minimal_access) is TRUE.
	var/list/minimal_wildcard_access = list()
	/// Static list. Cache of any mapping config job changes.
	var/static/list/job_changes
	/// An ID card with an access in this list can apply this trim to IDs or use it as a job template when adding access to a card. If the list is null, cannot be used as a template. Should be Head of Staff or ID Console accesses or it may do nothing.
	var/list/template_access
	/// The typepath to the job datum from the id_trim. This is converted to one of the job singletons in New().
	var/datum/job/job = /datum/job/unassigned

/datum/id_trim/job/New()
	if(ispath(job))
		job = SSjob.GetJobType(job)

	if(isnull(job_changes))
		job_changes = SSmapping.config.job_changes

	if(!length(job_changes))
		refresh_trim_access()
		return

	var/list/access_changes = job_changes[job.title]

	if(!length(access_changes))
		refresh_trim_access()
		return

	if(islist(access_changes["additional_access"]))
		extra_access |= access_changes["additional_access"]
	if(islist(access_changes["additional_minimal_access"]))
		minimal_access |= access_changes["additional_minimal_access"]
	if(islist(access_changes["additional_wildcard_access"]))
		extra_wildcard_access |= access_changes["additional_wildcard_access"]
	if(islist(access_changes["additional_minimal_wildcard_access"]))
		minimal_wildcard_access |= access_changes["additional_minimal_wildcard_access"]

	refresh_trim_access()

/**
 * Goes through various non-map config settings and modifies the trim's access based on this.
 *
 * Returns TRUE if the config is loaded, FALSE otherwise.
 */
/datum/id_trim/job/proc/refresh_trim_access()
	// If there's no config loaded then assume minimal access.
	if(!config)
		access = minimal_access.Copy()
		wildcard_access = minimal_wildcard_access.Copy()
		return FALSE

	// There is a config loaded. Check for the jobs_have_minimal_access flag being set.
	if(CONFIG_GET(flag/jobs_have_minimal_access))
		access = minimal_access.Copy()
		wildcard_access = minimal_wildcard_access.Copy()
	else
		access = minimal_access | extra_access
		wildcard_access = minimal_wildcard_access | extra_wildcard_access

	// If the config has global maint access set, we always want to add maint access.
	if(CONFIG_GET(flag/everyone_has_maint_access))
		access |= list(ACCESS_ARTEA_COMMON)

	return TRUE

/datum/id_trim/job/assistant
	assignment = "Assistant"
	orbit_icon = "toolbox"
	sechud_icon_state = SECHUD_ASSISTANT
	minimal_access = list()
	extra_access = list(
		ACCESS_ARTEA_COMMON,
		)
	template_access = list(
		ACCESS_SPECIAL_CAPTAIN,
		ACCESS_COMMAND_LOWSEC,
		ACCESS_COMMAND_LOWSEC,
		)
	job = /datum/job/assistant

/datum/id_trim/job/assistant/refresh_trim_access()
	. = ..()

	if(!.)
		return

	// Config has assistant maint access set.
	if(CONFIG_GET(flag/assistants_have_maint_access))
		access |= list(
			ACCESS_ARTEA_COMMON)

/datum/id_trim/job/bartender
	assignment = "Bartender"
	department_state = "dept-service"
	orbit_icon = "cocktail"
	department_color = COLOR_SERVICE_LIME
	subdepartment_color = COLOR_SERVICE_LIME
	sechud_icon_state = SECHUD_BARTENDER
	minimal_access = list(
		ACCESS_SERVICE_HIGHSEC,
		ACCESS_CARGO_HIGHSEC,
		ACCESS_SERVICE_LOWSEC,
		ACCESS_SERVICE_LOWSEC,
		ACCESS_SPECIAL_WEAPONS,
		)
	extra_access = list(
		ACCESS_SERVICE_LOWSEC,
		ACCESS_SERVICE_LOWSEC,
		)
	template_access = list(
		ACCESS_SPECIAL_CAPTAIN,
		ACCESS_COMMAND_LOWSEC,
		ACCESS_COMMAND_LOWSEC,
		)
	job = /datum/job/bartender

/datum/id_trim/job/botanist
	assignment = "Botanist"
	department_state = "dept-service"
	orbit_icon = "seedling"
	department_color = COLOR_SERVICE_LIME
	subdepartment_color = COLOR_SERVICE_LIME
	sechud_icon_state = SECHUD_BOTANIST
	minimal_access = list(
		ACCESS_SERVICE_LOWSEC,
		ACCESS_CARGO_HIGHSEC,
		ACCESS_SERVICE_LOWSEC,
		)
	extra_access = list(
		ACCESS_SERVICE_HIGHSEC,
		ACCESS_SERVICE_LOWSEC,
		ACCESS_MEDICAL_LOWSEC,
		)
	template_access = list(
		ACCESS_SPECIAL_CAPTAIN,
		ACCESS_COMMAND_LOWSEC,
		ACCESS_COMMAND_LOWSEC,
		)
	job = /datum/job/botanist

/datum/id_trim/job/captain
	assignment = "Captain"
	intern_alt_name = "Captain-in-Training"
	department_state = "dept-captain-gold"
	orbit_icon = "crown"
	department_color = COLOR_COMMAND_BLUE
	subdepartment_color = COLOR_COMMAND_BLUE
	sechud_icon_state = SECHUD_CAPTAIN
	template_access = list(
		ACCESS_SPECIAL_CAPTAIN,
		ACCESS_COMMAND_LOWSEC,
		)
	job = /datum/job/captain

/// Captain gets all station accesses hardcoded in because it's the Captain.
/datum/id_trim/job/captain/New()
	extra_access |= (SSid_access.get_flag_access_list(ACCESS_FLAG_COMMON) + SSid_access.get_flag_access_list(ACCESS_FLAG_COMMAND))
	extra_wildcard_access |= (SSid_access.get_flag_access_list(ACCESS_FLAG_PRV_COMMAND) + SSid_access.get_flag_access_list(ACCESS_FLAG_CAPTAIN))
	minimal_access |= (SSid_access.get_flag_access_list(ACCESS_FLAG_COMMON) + SSid_access.get_flag_access_list(ACCESS_FLAG_COMMAND))
	minimal_wildcard_access |= (SSid_access.get_flag_access_list(ACCESS_FLAG_PRV_COMMAND) + SSid_access.get_flag_access_list(ACCESS_FLAG_CAPTAIN))

	return ..()

/datum/id_trim/job/cargo_technician
	assignment = "Cargo Technician"
	department_state = "dept-cargo"
	orbit_icon = "box"
	department_color = COLOR_CARGO_BROWN
	subdepartment_color = COLOR_CARGO_BROWN
	sechud_icon_state = SECHUD_CARGO_TECHNICIAN
	minimal_access = list(
		ACCESS_CARGO_LOWSEC,
		ACCESS_ARTEA_COMMON,
		ACCESS_CARGO_VEHICLES,
		ACCESS_CARGO_HIGHSEC,
		ACCESS_CARGO_LOWSEC,
		)
	extra_access = list(
		ACCESS_PATHFINDERS_LOWSEC,
		ACCESS_PATHFINDERS_LOWSEC,
		)
	template_access = list(
		ACCESS_SPECIAL_CAPTAIN,
		ACCESS_COMMAND_LOWSEC,
		ACCESS_CARGO_HEAD,
		)
	job = /datum/job/cargo_technician

/datum/id_trim/job/chaplain
	assignment = "Chaplain"
	department_state = "dept-service"
	orbit_icon = "cross"
	department_color = COLOR_SERVICE_LIME
	subdepartment_color = COLOR_SERVICE_LIME
	sechud_icon_state = SECHUD_CHAPLAIN
	minimal_access = list(
		ACCESS_SERVICE_HIGHSEC,
		ACCESS_SERVICE_HIGHSEC,
		ACCESS_MEDICAL_LOWSEC,
		ACCESS_SERVICE_LOWSEC,
		ACCESS_SERVICE_LOWSEC,
		)
	extra_access = list()
	template_access = list(
		ACCESS_SPECIAL_CAPTAIN,
		ACCESS_COMMAND_LOWSEC,
		ACCESS_COMMAND_LOWSEC,
		)
	job = /datum/job/chaplain

/datum/id_trim/job/chemist
	assignment = "Chemist"
	department_state = "dept-medical"
	orbit_icon = "prescription-bottle"
	department_color = COLOR_MEDICAL_BLUE
	subdepartment_color = COLOR_MEDICAL_BLUE
	sechud_icon_state = SECHUD_CHEMIST
	minimal_access = list(
		ACCESS_MEDICAL_VEHICLES,
		ACCESS_MEDICAL_LOWSEC,
		ACCESS_CARGO_HIGHSEC,
		ACCESS_MEDICAL_HIGHSEC,
		)
	extra_access = list(
		ACCESS_MEDICAL_LOWSEC,
		ACCESS_MEDICAL_HIGHSEC,
		ACCESS_MEDICAL_HIGHSEC,
		)
	template_access = list(
		ACCESS_SPECIAL_CAPTAIN,
		ACCESS_COMMAND_LOWSEC,
		ACCESS_MEDICAL_HEAD,
		)
	job = /datum/job/chemist

/datum/id_trim/job/chief_engineer
	assignment = "Chief Engineer"
	intern_alt_name = "Chief Engineer-in-Training"
	department_state = "dept-engineering"
	orbit_icon = "user-astronaut"
	department_color = COLOR_COMMAND_BLUE
	subdepartment_color = COLOR_ENGINEERING_ORANGE
	sechud_icon_state = SECHUD_CHIEF_ENGINEER
	extra_wildcard_access = list()
	minimal_access = list(
		ACCESS_ENGINEERING_HIGHSEC,
		ACCESS_ARTEA_COMMON,
		ACCESS_SECURITY_LOWSEC,
		ACCESS_ENGINEERING_HEAD,
		ACCESS_COMMAND_LOWSEC,
		ACCESS_ENGINEERING_LOWSEC,
		ACCESS_ENGINEERING_LOWSEC,
		ACCESS_ENGINEERING_LOWSEC,
		ACCESS_ARTEA_COMMON,
		ACCESS_ARTEA_COMMON,
		ACCESS_COMMAND_HIGHSEC,
		ACCESS_ARTEA_COMMON,
		ACCESS_ENGINEERING_VEHICLES,
		ACCESS_CARGO_HIGHSEC,
		ACCESS_COMMAND_LOWSEC,
		ACCESS_COMMAND_LOWSEC,
		ACCESS_ENGINEERING_HIGHSEC,
		ACCESS_ENGINEERING_HIGHSEC,
		ACCESS_ENGINEERING_HIGHSEC,
		ACCESS_PATHFINDERS_LOWSEC,
		)
	minimal_wildcard_access = list(
		ACCESS_ENGINEERING_HEAD,
		)
	extra_access = list(
		ACCESS_COMMAND_HIGHSEC,
		)
	template_access = list(
		ACCESS_SPECIAL_CAPTAIN,
		ACCESS_COMMAND_LOWSEC,
		)
	job = /datum/job/chief_engineer

/datum/id_trim/job/chief_medical_officer
	assignment = "Chief Medical Officer"
	intern_alt_name = "Chief Medical Officer-in-Training"
	department_state = "dept-medical"
	orbit_icon = "user-md"
	department_color = COLOR_COMMAND_BLUE
	subdepartment_color = COLOR_MEDICAL_BLUE
	sechud_icon_state = SECHUD_CHIEF_MEDICAL_OFFICER
	extra_wildcard_access = list()
	minimal_access = list(
		ACCESS_SECURITY_LOWSEC,
		ACCESS_COMMAND_LOWSEC,
		ACCESS_COMMAND_HIGHSEC,
		ACCESS_ARTEA_COMMON,
		ACCESS_ARTEA_COMMON,
		ACCESS_MEDICAL_VEHICLES,
		ACCESS_MEDICAL_LOWSEC,
		ACCESS_CARGO_HIGHSEC,
		ACCESS_MEDICAL_LOWSEC,
		ACCESS_MEDICAL_HIGHSEC,
		ACCESS_MEDICAL_LOWSEC,
		ACCESS_COMMAND_LOWSEC,
		ACCESS_MEDICAL_HIGHSEC,
		ACCESS_MEDICAL_HIGHSEC,
		ACCESS_MEDICAL_VEHICLES,
		)
	minimal_wildcard_access = list(
		ACCESS_MEDICAL_HEAD,
		)
	extra_access = list(
		ACCESS_COMMAND_HIGHSEC,
		)
	template_access = list(
		ACCESS_SPECIAL_CAPTAIN,
		ACCESS_COMMAND_LOWSEC,
		)
	job = /datum/job/chief_medical_officer

/datum/id_trim/job/clown
	assignment = "Clown"
	department_state = "dept-clown"
	orbit_icon = "face-grin-tears"
	department_color = COLOR_MOSTLY_PURE_PINK
	subdepartment_color = COLOR_MAGENTA
	sechud_icon_state = SECHUD_CLOWN
	minimal_access = list(
		ACCESS_SERVICE_LOWSEC,
		ACCESS_SERVICE_LOWSEC,
		)
	extra_access = list()
	template_access = list(
		ACCESS_SPECIAL_CAPTAIN,
		ACCESS_COMMAND_LOWSEC,
		ACCESS_COMMAND_LOWSEC,
		)
	job = /datum/job/clown

/datum/id_trim/job/cook
	assignment = "Cook"
	department_state = "dept-service"
	orbit_icon = "utensils"
	department_color = COLOR_SERVICE_LIME
	subdepartment_color = COLOR_SERVICE_LIME
	sechud_icon_state = SECHUD_COOK
	minimal_access = list(
		ACCESS_SERVICE_LOWSEC,
		ACCESS_CARGO_HIGHSEC,
		ACCESS_MEDICAL_LOWSEC,
		ACCESS_SERVICE_LOWSEC,
		)
	extra_access = list(
		ACCESS_SERVICE_HIGHSEC,
		ACCESS_SERVICE_LOWSEC,
		)
	template_access = list(
		ACCESS_SPECIAL_CAPTAIN,
		ACCESS_COMMAND_LOWSEC,
		ACCESS_COMMAND_LOWSEC,
		)
	job = /datum/job/cook

/datum/id_trim/job/cook/chef
	assignment = "Chef"
	sechud_icon_state = SECHUD_CHEF

/datum/id_trim/job/curator
	assignment = "Curator"
	department_state = "dept-service"
	orbit_icon = "book"
	department_color = COLOR_SERVICE_LIME
	subdepartment_color = COLOR_SERVICE_LIME
	sechud_icon_state = SECHUD_CURATOR
	minimal_access = list(
		ACCESS_ARTEA_COMMON,
		ACCESS_SERVICE_LOWSEC,
		ACCESS_PATHFINDERS_LOWSEC,
		ACCESS_SERVICE_LOWSEC,
		)
	extra_access = list()
	template_access = list(
		ACCESS_SPECIAL_CAPTAIN,
		ACCESS_COMMAND_LOWSEC,
		ACCESS_COMMAND_LOWSEC,
		)
	job = /datum/job/curator

/datum/id_trim/job/detective
	assignment = "Detective"
	department_state = "dept-security"
	orbit_icon = "user-secret"
	department_color = COLOR_SECURITY_RED
	subdepartment_color = COLOR_SECURITY_RED
	sechud_icon_state = SECHUD_DETECTIVE
	minimal_access = list(
		ACCESS_SECURITY_LOWSEC,
		ACCESS_SECURITY_LOWSEC,
		ACCESS_SECURITY_LOWSEC,
		ACCESS_ARTEA_COMMON,
		ACCESS_SECURITY_VEHICLES,
		ACCESS_CARGO_HIGHSEC,
		ACCESS_MEDICAL_LOWSEC,
		ACCESS_SECURITY_LOWSEC,
		ACCESS_SPECIAL_WEAPONS,
		)
	extra_access = list(
		ACCESS_SECURITY_HIGHSEC,
		)
	template_access = list(
		ACCESS_SPECIAL_CAPTAIN,
		ACCESS_COMMAND_LOWSEC,
		ACCESS_SECURITY_HEAD,
		)
	job = /datum/job/detective

/datum/id_trim/job/detective/refresh_trim_access()
	. = ..()

	if(!.)
		return

	// Config check for if sec has maint access.
	if(CONFIG_GET(flag/security_has_maint_access))
		access |= list(ACCESS_ARTEA_COMMON)

/datum/id_trim/job/head_of_personnel
	assignment = "Head of Personnel"
	intern_alt_name = "Head of Personnel-in-Training"
	department_state = "dept-hop"
	orbit_icon = "dog"
	department_color = COLOR_COMMAND_BLUE
	subdepartment_color = COLOR_SERVICE_LIME
	sechud_icon_state = SECHUD_HEAD_OF_PERSONNEL
	minimal_access = list(
		ACCESS_COMMAND_HIGHSEC,
		ACCESS_COMMAND_HIGHSEC,
		ACCESS_ARTEA_COMMON,
		ACCESS_SERVICE_HIGHSEC,
		ACCESS_SECURITY_LOWSEC,
		ACCESS_SERVICE_HIGHSEC,
		ACCESS_COMMAND_LOWSEC,
		ACCESS_SERVICE_HIGHSEC,
		ACCESS_COMMAND_LOWSEC,
		ACCESS_SECURITY_LOWSEC,
		ACCESS_ENGINEERING_LOWSEC,
		ACCESS_ARTEA_COMMON,
		ACCESS_COMMAND_LOWSEC,
		ACCESS_SERVICE_LOWSEC,
		ACCESS_SERVICE_LOWSEC,
		ACCESS_COMMAND_HIGHSEC,
		ACCESS_SERVICE_LOWSEC,
		ACCESS_SERVICE_HIGHSEC,
		ACCESS_SERVICE_LOWSEC,
		ACCESS_ARTEA_COMMON,
		ACCESS_MEDICAL_LOWSEC,
		ACCESS_CARGO_HIGHSEC,
		ACCESS_MEDICAL_LOWSEC,
		ACCESS_COMMAND_LOWSEC,
		ACCESS_PATHFINDERS_LOWSEC,
		ACCESS_SERVICE_LOWSEC,
		ACCESS_COMMAND_HIGHSEC,
		ACCESS_SERVICE_LOWSEC,
		ACCESS_SPECIAL_WEAPONS,
		)
	minimal_wildcard_access = list(
		ACCESS_COMMAND_LOWSEC,
		)
	extra_access = list()
	extra_wildcard_access = list()
	template_access = list(
		ACCESS_SPECIAL_CAPTAIN,
		ACCESS_COMMAND_LOWSEC,
	)
	job = /datum/job/head_of_personnel

/datum/id_trim/job/head_of_security
	assignment = "Head of Security"
	intern_alt_name = "Head of Security-in-Training"
	department_state = "dept-security"
	orbit_icon = "user-shield"
	department_color = COLOR_COMMAND_BLUE
	subdepartment_color = COLOR_SECURITY_RED
	sechud_icon_state = SECHUD_HEAD_OF_SECURITY
	extra_access = list(ACCESS_COMMAND_HIGHSEC)
	extra_wildcard_access = list()
	minimal_access = list(
		ACCESS_COMMAND_HIGHSEC,
		ACCESS_SECURITY_HIGHSEC,
		ACCESS_ARTEA_COMMON,
		ACCESS_SECURITY_HIGHSEC,
		ACCESS_SECURITY_LOWSEC,
		ACCESS_CARGO_LOWSEC,
		ACCESS_COMMAND_LOWSEC,
		ACCESS_ENGINEERING_LOWSEC,
		ACCESS_SECURITY_LOWSEC,
		ACCESS_SECURITY_LOWSEC,
		ACCESS_ENGINEERING_LOWSEC,
		ACCESS_ARTEA_COMMON,
		ACCESS_COMMAND_LOWSEC,
		ACCESS_COMMAND_HIGHSEC,
		ACCESS_ARTEA_COMMON,
		ACCESS_SECURITY_VEHICLES,
		ACCESS_MEDICAL_LOWSEC,
		ACCESS_CARGO_HIGHSEC,
		ACCESS_PATHFINDERS_LOWSEC,
		ACCESS_MEDICAL_LOWSEC,
		ACCESS_COMMAND_LOWSEC,
		ACCESS_PATHFINDERS_LOWSEC,
		ACCESS_SECURITY_LOWSEC,
		ACCESS_SERVICE_LOWSEC,
		ACCESS_CARGO_LOWSEC,
		ACCESS_SPECIAL_WEAPONS,
		)
	minimal_wildcard_access = list(
		ACCESS_SECURITY_HEAD,
		)
	template_access = list(
		ACCESS_SPECIAL_CAPTAIN,
		ACCESS_COMMAND_LOWSEC,
		)
	job = /datum/job/head_of_security

/datum/id_trim/job/head_of_security/refresh_trim_access()
	. = ..()

	if(!.)
		return

	// Config check for if sec has maint access.
	if(CONFIG_GET(flag/security_has_maint_access))
		access |= list(ACCESS_ARTEA_COMMON)

/datum/id_trim/job/internal_affairs_agent
	assignment = "Internal Affairs Agent"
	department_state = "dept-internal-affairs"
	orbit_icon = "print"
	department_color = COLOR_COMMAND_BLUE
	subdepartment_color = COLOR_SECURITY_RED
	sechud_icon_state = SECHUD_INTERNAL_AFFAIRS_AGENT
	minimal_access = list(
		ACCESS_SECURITY_LOWSEC,
		ACCESS_SECURITY_LOWSEC,
		ACCESS_SERVICE_HIGHSEC,
		)
	extra_access = list()
	template_access = list(
		ACCESS_SPECIAL_CAPTAIN,
		ACCESS_COMMAND_LOWSEC,
		ACCESS_COMMAND_LOWSEC,
		)
	job = /datum/job/internal_affairs_agent

/datum/id_trim/job/janitor
	assignment = "Janitor"
	department_state = "dept-service"
	orbit_icon = "broom"
	department_color = COLOR_SERVICE_LIME
	subdepartment_color = COLOR_SERVICE_LIME
	sechud_icon_state = SECHUD_JANITOR
	minimal_access = list(
		ACCESS_SERVICE_LOWSEC,
		ACCESS_ARTEA_COMMON,
		ACCESS_CARGO_HIGHSEC,
		ACCESS_SERVICE_LOWSEC,
		)
	extra_access = list()
	template_access = list(
		ACCESS_SPECIAL_CAPTAIN,
		ACCESS_COMMAND_LOWSEC,
		ACCESS_COMMAND_LOWSEC,
		)
	job = /datum/job/janitor

/datum/id_trim/job/lawyer
	assignment = "Lawyer"
	department_state = "dept-service"
	orbit_icon = "gavel"
	department_color = COLOR_SERVICE_LIME
	subdepartment_color = COLOR_SECURITY_RED
	sechud_icon_state = SECHUD_LAWYER
	minimal_access = list(
		ACCESS_SECURITY_LOWSEC,
		ACCESS_SECURITY_LOWSEC,
		ACCESS_SERVICE_HIGHSEC,
		ACCESS_SERVICE_LOWSEC,
		)
	extra_access = list()
	template_access = list(
		ACCESS_SPECIAL_CAPTAIN,
		ACCESS_COMMAND_LOWSEC,
		ACCESS_COMMAND_LOWSEC,
		)
	job = /datum/job/lawyer

/datum/id_trim/job/medical_doctor
	assignment = "Medical Doctor"
	department_state = "dept-medical"
	orbit_icon = "staff-snake"
	department_color = COLOR_MEDICAL_BLUE
	subdepartment_color = COLOR_MEDICAL_BLUE
	sechud_icon_state = SECHUD_MEDICAL_DOCTOR
	extra_access = list(
		ACCESS_MEDICAL_HIGHSEC,
		)
	minimal_access = list(
		ACCESS_MEDICAL_VEHICLES,
		ACCESS_MEDICAL_LOWSEC,
		ACCESS_CARGO_HIGHSEC,
		ACCESS_MEDICAL_LOWSEC,
		ACCESS_MEDICAL_HIGHSEC,
		ACCESS_MEDICAL_HIGHSEC,
		ACCESS_MEDICAL_VEHICLES,
		)
	template_access = list(
		ACCESS_SPECIAL_CAPTAIN,
		ACCESS_COMMAND_LOWSEC,
		ACCESS_MEDICAL_HEAD,
		)
	job = /datum/job/doctor

/datum/id_trim/job/mime
	assignment = "Mime"
	department_state = "dept-service"
	orbit_icon = "comment-slash"
	department_color = COLOR_SILVER
	subdepartment_color = COLOR_PRISONER_BLACK
	sechud_icon_state = SECHUD_MIME
	minimal_access = list(
		ACCESS_SERVICE_LOWSEC,
		ACCESS_SERVICE_LOWSEC,
		)
	extra_access = list()
	template_access = list(
		ACCESS_SPECIAL_CAPTAIN,
		ACCESS_COMMAND_LOWSEC,
		ACCESS_COMMAND_LOWSEC,
		)
	job = /datum/job/mime

/datum/id_trim/job/paramedic
	assignment = "Paramedic"
	department_state = "dept-medical"
	orbit_icon = "truck-medical"
	department_color = COLOR_MEDICAL_BLUE
	subdepartment_color = COLOR_MEDICAL_BLUE
	sechud_icon_state = SECHUD_PARAMEDIC
	minimal_access = list(
		ACCESS_CARGO_LOWSEC,
		ACCESS_ENGINEERING_LOWSEC,
		ACCESS_SERVICE_LOWSEC,
		ACCESS_ARTEA_COMMON,
		ACCESS_MEDICAL_VEHICLES,
		ACCESS_MEDICAL_LOWSEC,
		ACCESS_CARGO_HIGHSEC,
		ACCESS_PATHFINDERS_LOWSEC,
		ACCESS_MEDICAL_LOWSEC,
		ACCESS_PATHFINDERS_LOWSEC,
		ACCESS_SERVICE_LOWSEC,
		ACCESS_MEDICAL_VEHICLES,
		)
	extra_access = list(
		ACCESS_MEDICAL_HIGHSEC,
		)
	template_access = list(
		ACCESS_SPECIAL_CAPTAIN,
		ACCESS_COMMAND_LOWSEC,
		ACCESS_MEDICAL_HEAD,
		)
	job = /datum/job/paramedic

/datum/id_trim/job/prisoner
	assignment = "Prisoner"
	department_state = "dept-prisoner"
	orbit_icon = "lock"
	department_color = COLOR_PRISONER_BLACK
	subdepartment_color = COLOR_PRISONER_ORANGE
	sechud_icon_state = SECHUD_PRISONER
	template_access = list(
		ACCESS_SPECIAL_CAPTAIN,
		ACCESS_COMMAND_LOWSEC,
		ACCESS_COMMAND_LOWSEC,
		ACCESS_SECURITY_HEAD,
		)
	job = /datum/job/prisoner

/datum/id_trim/job/prisoner/one
	template_access = null

/datum/id_trim/job/prisoner/two
	template_access = null

/datum/id_trim/job/prisoner/three
	template_access = null

/datum/id_trim/job/prisoner/four
	template_access = null

/datum/id_trim/job/prisoner/five
	template_access = null

/datum/id_trim/job/prisoner/six
	template_access = null

/datum/id_trim/job/prisoner/seven
	template_access = null

/datum/id_trim/job/psychologist
	assignment = "Psychologist"
	department_state = "dept-service"
	orbit_icon = "brain"
	department_color = COLOR_SERVICE_LIME
	subdepartment_color = COLOR_MEDICAL_BLUE
	sechud_icon_state = SECHUD_PSYCHOLOGIST
	minimal_access = list(
		ACCESS_MEDICAL_LOWSEC,
		ACCESS_MEDICAL_LOWSEC,
		ACCESS_SERVICE_LOWSEC,
		)
	extra_access = list()
	template_access = list(
		ACCESS_SPECIAL_CAPTAIN,
		ACCESS_COMMAND_LOWSEC,
		ACCESS_MEDICAL_HEAD,
		ACCESS_COMMAND_LOWSEC,
		)
	job = /datum/job/psychologist

/datum/id_trim/job/quartermaster
	assignment = "Quartermaster"
	department_state = "dept-cargo"
	orbit_icon = "sack-dollar"
	department_color = COLOR_COMMAND_BLUE
	subdepartment_color = COLOR_CARGO_BROWN
	sechud_icon_state = SECHUD_QUARTERMASTER
	minimal_access = list(
		ACCESS_ARTEA_COMMON,
		ACCESS_CARGO_LOWSEC,
		ACCESS_ARTEA_COMMON,
		ACCESS_CARGO_VEHICLES,
		ACCESS_PATHFINDERS_LOWSEC,
		ACCESS_CARGO_HIGHSEC,
		ACCESS_PATHFINDERS_LOWSEC,
		ACCESS_CARGO_HEAD,
		ACCESS_COMMAND_LOWSEC,
		ACCESS_CARGO_LOWSEC,
		ACCESS_VAULT,
		ACCESS_COMMAND_HIGHSEC,
		ACCESS_COMMAND_LOWSEC,
		ACCESS_ARTEA_COMMON,
		ACCESS_SECURITY_LOWSEC,
		)
	extra_access = list()
	minimal_wildcard_access = list(
		ACCESS_CARGO_HEAD,
	)
	template_access = list(
		ACCESS_SPECIAL_CAPTAIN,
		ACCESS_COMMAND_LOWSEC,
	)
	job = /datum/job/quartermaster

/datum/id_trim/job/roboticist
	assignment = "Roboticist"
	department_state = "dept-engineering"
	orbit_icon = "battery-half"
	department_color = COLOR_ENGINEERING_ORANGE
	subdepartment_color = COLOR_ENGINEERING_ORANGE
	sechud_icon_state = SECHUD_ROBOTICIST
	minimal_access = list(
		ACCESS_ARTEA_COMMON,
		ACCESS_ENGINEERING_VEHICLES,
		ACCESS_CARGO_HIGHSEC,
		ACCESS_MEDICAL_LOWSEC,
		ACCESS_ENGINEERING_HIGHSEC,
		ACCESS_ENGINEERING_HIGHSEC,
		ACCESS_ENGINEERING_LOWSEC,
		ACCESS_ENGINEERING_LOWSEC,
		ACCESS_ENGINEERING_LOWSEC,
		)
	template_access = list(
		ACCESS_SPECIAL_CAPTAIN,
		ACCESS_COMMAND_LOWSEC,
		ACCESS_ENGINEERING_HEAD,
		)
	job = /datum/job/roboticist

/// Sec officers have departmental variants. They each have their own trims with bonus departmental accesses.
/datum/id_trim/job/security_officer
	assignment = "Security Officer"
	department_state = "dept-security"
	orbit_icon = "shield-halved"
	department_color = COLOR_SECURITY_RED
	subdepartment_color = COLOR_SECURITY_RED
	sechud_icon_state = SECHUD_SECURITY_OFFICER
	minimal_access = list(
		ACCESS_SECURITY_HIGHSEC,
		ACCESS_SECURITY_LOWSEC,
		ACCESS_SECURITY_LOWSEC,
		ACCESS_SECURITY_VEHICLES,
		ACCESS_CARGO_HIGHSEC,
		ACCESS_SECURITY_LOWSEC,
		ACCESS_SPECIAL_WEAPONS,
		)
	extra_access = list(
		ACCESS_SECURITY_LOWSEC,
		ACCESS_ARTEA_COMMON,
		ACCESS_MEDICAL_LOWSEC,
		)
	template_access = list(
		ACCESS_SPECIAL_CAPTAIN,
		ACCESS_COMMAND_LOWSEC,
		ACCESS_SECURITY_HEAD,
		)
	job = /datum/job/security_officer
	/// List of bonus departmental accesses that departmental sec officers get by default.
	var/department_access = list()
	/// List of bonus departmental accesses that departmental security officers can in relation to how many overall security officers there are if the scaling system is set up. These can otherwise be granted via config settings.
	var/elevated_access = list()

/datum/id_trim/job/security_officer/refresh_trim_access()
	. = ..()

	if(!.)
		return

	access |= department_access

	// Config check for if sec has maint access.
	if(CONFIG_GET(flag/security_has_maint_access))
		access |= list(ACCESS_ARTEA_COMMON)

	// Scaling access (POPULATION_SCALED_ACCESS) is a system directly tied into calculations derived via a config entered variable, as well as the amount of players in the shift.
	// Thus, it makes it possible to judge if departmental security officers should have more access to their department on a lower population shift.
	// Server operators can modify config to change it such that security officers can use this system, or alternatively either: A) always give the "elevated" access (ALWAYS_GETS_ACCESS) or B) never give this access (null value).

	#define POPULATION_SCALED_ACCESS 1
	#define ALWAYS_GETS_ACCESS 2

	// If null, then the departmental security officer will not get any elevated access.
	if(!CONFIG_GET(number/depsec_access_level))
		return

	if(CONFIG_GET(number/depsec_access_level) == POPULATION_SCALED_ACCESS)
		var/minimal_security_officers = 3 // We do not spawn in any more lockers if there are 5 or less security officers, so let's keep it lower than that number.
		var/datum/job/J = SSjob.GetJob(JOB_SECURITY_OFFICER)
		if((J.spawn_positions - minimal_security_officers) <= 0)
			access |= elevated_access

	if(CONFIG_GET(number/depsec_access_level) == ALWAYS_GETS_ACCESS)
		access |= elevated_access

/datum/id_trim/job/security_officer/supply
	assignment = "Security Officer (Cargo)"
	subdepartment_color = COLOR_CARGO_BROWN
	department_access = list(
		ACCESS_CARGO_LOWSEC,
		ACCESS_PATHFINDERS_LOWSEC,
		ACCESS_CARGO_LOWSEC,
	)
	elevated_access = list(
		ACCESS_ARTEA_COMMON,
		ACCESS_PATHFINDERS_LOWSEC,
	)

/datum/id_trim/job/security_officer/engineering
	assignment = "Security Officer (Engineering)"
	subdepartment_color = COLOR_ENGINEERING_ORANGE
	department_access = list(
		ACCESS_ENGINEERING_HIGHSEC,
		ACCESS_ENGINEERING_LOWSEC,
	)
	elevated_access = list(
		ACCESS_ARTEA_COMMON,
		ACCESS_ENGINEERING_LOWSEC,
		ACCESS_ENGINEERING_LOWSEC,
		ACCESS_ENGINEERING_HIGHSEC,
	)

/datum/id_trim/job/security_officer/medical
	assignment = "Security Officer (Medical)"
	subdepartment_color = COLOR_MEDICAL_BLUE
	department_access = list(
		ACCESS_MEDICAL_LOWSEC,
		ACCESS_MEDICAL_LOWSEC,
	)
	elevated_access = list(
		ACCESS_MEDICAL_HIGHSEC,
		ACCESS_MEDICAL_HIGHSEC,
		ACCESS_MEDICAL_HIGHSEC,
	)

/datum/id_trim/job/security_officer/science
	assignment = "Security Officer (Science)"
	subdepartment_color = COLOR_SCIENCE_PINK
	department_access = list(
		ACCESS_PATHFINDERS_LOWSEC,
		ACCESS_PATHFINDERS_LOWSEC,
	)
	elevated_access = list(
		ACCESS_ARTEA_COMMON,
		ACCESS_PATHFINDERS_LOWSEC,
		ACCESS_ENGINEERING_LOWSEC,
		ACCESS_ENGINEERING_HIGHSEC,
		ACCESS_ENGINEERING_HIGHSEC,
		ACCESS_ENGINEERING_HIGHSEC,
	)

/datum/id_trim/job/station_engineer
	assignment = "Station Engineer"
	department_state = "dept-engineering"
	orbit_icon = "gears"
	department_color = COLOR_ENGINEERING_ORANGE
	subdepartment_color = COLOR_ENGINEERING_ORANGE
	sechud_icon_state = SECHUD_STATION_ENGINEER
	minimal_access = list(
		ACCESS_ENGINEERING_HIGHSEC,
		ACCESS_ARTEA_COMMON,
		ACCESS_ENGINEERING_LOWSEC,
		ACCESS_ENGINEERING_LOWSEC,
		ACCESS_ENGINEERING_LOWSEC,
		ACCESS_ARTEA_COMMON,
		ACCESS_ARTEA_COMMON,
		ACCESS_ENGINEERING_VEHICLES,
		ACCESS_CARGO_HIGHSEC,
		ACCESS_COMMAND_LOWSEC,
		ACCESS_ENGINEERING_HIGHSEC,
		ACCESS_ENGINEERING_HIGHSEC,
		)
	template_access = list(
		ACCESS_SPECIAL_CAPTAIN,
		ACCESS_COMMAND_LOWSEC,
		ACCESS_ENGINEERING_HEAD,
		)
	job = /datum/job/station_engineer

/datum/id_trim/job/warden
	assignment = "Warden"
	department_state = "dept-security"
	orbit_icon = "handcuffs"
	department_color = COLOR_SECURITY_RED
	subdepartment_color = COLOR_SECURITY_RED
	sechud_icon_state = SECHUD_WARDEN
	minimal_access = list(
		ACCESS_SECURITY_HIGHSEC,
		ACCESS_SECURITY_HIGHSEC,
		ACCESS_SECURITY_LOWSEC,
		ACCESS_SECURITY_LOWSEC,
		ACCESS_SECURITY_VEHICLES,
		ACCESS_CARGO_HIGHSEC,
		ACCESS_SECURITY_LOWSEC,
		ACCESS_SPECIAL_WEAPONS,
		) // See /datum/job/warden/get_access()
	extra_access = list(
		ACCESS_SECURITY_LOWSEC,
		ACCESS_ARTEA_COMMON,
		ACCESS_MEDICAL_LOWSEC,
		)
	template_access = list(
		ACCESS_SPECIAL_CAPTAIN,
		ACCESS_COMMAND_LOWSEC,
		ACCESS_SECURITY_HEAD,
		)
	job = /datum/job/warden

/datum/id_trim/job/warden/refresh_trim_access()
	. = ..()

	if(!.)
		return

	// Config check for if sec has maint access.
	if(CONFIG_GET(flag/security_has_maint_access))
		access |= list(ACCESS_ARTEA_COMMON)

#undef POPULATION_SCALED_ACCESS
#undef ALWAYS_GETS_ACCESS

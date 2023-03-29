//////////////////////////////////////////////
//                                          //
//            LATEJOIN RULESETS             //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/latejoin/trim_candidates()
	for(var/mob/P in candidates)
		if(!P.client || !P.mind || is_unassigned_job(P.mind.assigned_role)) // Are they connected?
			candidates.Remove(P)
		else if (P.client.get_remaining_days(minimum_required_age) > 0)
			candidates.Remove(P)
		else if(P.mind.assigned_role.title in restricted_roles) // Does their job allow for it?
			candidates.Remove(P)
		else if((exclusive_roles.len > 0) && !(P.mind.assigned_role.title in exclusive_roles)) // Is the rule exclusive to their job?
			candidates.Remove(P)
		else if (!((antag_preference || antag_flag) in P.client.prefs.be_special) || is_banned_from(P.ckey, list(antag_flag_override || antag_flag, ROLE_SYNDICATE)))
			candidates.Remove(P)

/datum/dynamic_ruleset/latejoin/ready(forced = 0)
	if (forced)
		return ..()

	var/job_check = 0
	if (enemy_roles.len > 0)
		for (var/mob/M in GLOB.alive_player_list)
			if (M.stat == DEAD)
				continue // Dead players cannot count as opponents
			if (M.mind && (M.mind.assigned_role.title in enemy_roles) && (!(M in candidates) || (M.mind.assigned_role.title in restricted_roles)))
				job_check++ // Checking for "enemies" (such as sec officers). To be counters, they must either not be candidates to that rule, or have a job that restricts them from it

	var/threat = round(mode.threat_level/10)

	if (job_check < required_enemies[threat])
		log_dynamic("FAIL: [src] is not ready, because there are not enough enemies: [required_enemies[threat]] needed, [job_check] found")
		return FALSE

	return ..()

/datum/dynamic_ruleset/latejoin/execute()
	var/mob/M = pick(candidates)
	assigned += M.mind
	M.mind.special_role = antag_flag
	M.mind.add_antag_datum(antag_datum)
	return TRUE

//////////////////////////////////////////////
//                                          //
//           SYNDICATE TRAITORS             //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/latejoin/infiltrator
	name = "Darkoth Infiltrator"
	antag_datum = /datum/antagonist/traitor/saboteur
	antag_flag = ROLE_SYNDICATE_INFILTRATOR
	antag_flag_override = ROLE_TRAITOR
	protected_roles = list(
		JOB_CAPTAIN,
		JOB_DETECTIVE,
		JOB_HEAD_OF_PERSONNEL,
		JOB_HEAD_OF_SECURITY,
		JOB_SECURITY_OFFICER,
		JOB_WARDEN,
	)
	restricted_roles = list(
		JOB_AI,
		JOB_CYBORG,
	)
	required_candidates = 1
	weight = 7
	cost = 5
	requirements = list(5,5,5,5,5,5,5,5,5,5)
	repeatable = TRUE

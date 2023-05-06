/// Probability the AI going malf will be accompanied by an ion storm announcement and some ion laws.
#define MALF_ION_PROB 33
/// The probability to replace an existing law with an ion law instead of adding a new ion law.
#define REPLACE_LAW_WITH_ION_PROB 10

//////////////////////////////////////////////
//                                          //
//            MIDROUND RULESETS             //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/midround // Can be drafted once in a while during a round
	ruletype = "Midround"
	var/midround_ruleset_style
	/// If the ruleset should be restricted from ghost roles.
	var/restrict_ghost_roles = TRUE
	/// What mob type the ruleset is restricted to.
	var/required_type = /mob/living/carbon/human
	var/list/living_players = list()
	var/list/living_antags = list()
	var/list/dead_players = list()
	var/list/list_observers = list()

	/// The minimum round time before this ruleset will show up
	var/minimum_round_time = 0
	/// Abstract root value
	var/abstract_type = /datum/dynamic_ruleset/midround

/datum/dynamic_ruleset/midround/from_ghosts
	weight = 0
	required_type = /mob/dead/observer
	abstract_type = /datum/dynamic_ruleset/midround/from_ghosts
	/// Whether the ruleset should call generate_ruleset_body or not.
	var/makeBody = TRUE
	/// The rule needs this many applicants to be properly executed.
	var/required_applicants = 1

/datum/dynamic_ruleset/midround/from_ghosts/check_candidates()
	var/dead_count = dead_players.len + list_observers.len
	if (required_candidates <= dead_count)
		return TRUE

	log_dynamic("FAIL: [src], a from_ghosts ruleset, did not have enough dead candidates: [required_candidates] needed, [dead_count] found")

	return FALSE

/datum/dynamic_ruleset/midround/trim_candidates()
	living_players = trim_list(GLOB.alive_player_list)
	living_antags = trim_list(GLOB.current_living_antags)
	dead_players = trim_list(GLOB.dead_player_list)
	list_observers = trim_list(GLOB.current_observers_list)

/datum/dynamic_ruleset/midround/proc/trim_list(list/L = list())
	var/list/trimmed_list = L.Copy()
	for(var/mob/M in trimmed_list)
		if (!istype(M, required_type))
			trimmed_list.Remove(M)
			continue
		if (!M.client) // Are they connected?
			trimmed_list.Remove(M)
			continue
		if(M.client.get_remaining_days(minimum_required_age) > 0)
			trimmed_list.Remove(M)
			continue
		if (!((antag_preference || antag_flag) in M.client.prefs.be_special))
			trimmed_list.Remove(M)
			continue
		if (is_banned_from(M.ckey, list(antag_flag_override || antag_flag, ROLE_SYNDICATE)))
			trimmed_list.Remove(M)
			continue
		if (M.mind)
			if (restrict_ghost_roles && (M.mind.assigned_role.title in GLOB.exp_specialmap[EXP_TYPE_SPECIAL])) // Are they playing a ghost role?
				trimmed_list.Remove(M)
				continue
			if (M.mind.assigned_role.title in restricted_roles) // Does their job allow it?
				trimmed_list.Remove(M)
				continue
			if ((exclusive_roles.len > 0) && !(M.mind.assigned_role.title in exclusive_roles)) // Is the rule exclusive to their job?
				trimmed_list.Remove(M)
				continue
	return trimmed_list

// You can then for example prompt dead players in execute() to join as strike teams or whatever
// Or autotator someone

// IMPORTANT, since /datum/dynamic_ruleset/midround may accept candidates from both living, dead, and even antag players
// subtype your midround with /from_ghosts or /from_living to get candidate checking. Or check yourself by subtyping from neither
/datum/dynamic_ruleset/midround/ready(forced = FALSE)
	if (forced)
		return TRUE

	var/job_check = 0
	if (enemy_roles.len > 0)
		for (var/mob/M in GLOB.alive_player_list)
			if (M.stat == DEAD || !M.client)
				continue // Dead/disconnected players cannot count as opponents
			if (M.mind && (M.mind.assigned_role.title in enemy_roles) && (!(M in candidates) || (M.mind.assigned_role.title in restricted_roles)))
				job_check++ // Checking for "enemies" (such as sec officers). To be counters, they must either not be candidates to that rule, or have a job that restricts them from it

	var/threat = round(mode.threat_level/10)

	if (job_check < required_enemies[threat])
		log_dynamic("FAIL: [src] is not ready, because there are not enough enemies: [required_enemies[threat]] needed, [job_check] found")
		return FALSE

	return TRUE

/datum/dynamic_ruleset/midround/from_ghosts/execute()
	var/list/possible_candidates = list()
	possible_candidates.Add(dead_players)
	possible_candidates.Add(list_observers)
	send_applications(possible_candidates)
	if(assigned.len > 0)
		return TRUE
	else
		return FALSE

/// This sends a poll to ghosts if they want to be a ghost spawn from a ruleset.
/datum/dynamic_ruleset/midround/from_ghosts/proc/send_applications(list/possible_volunteers = list())
	if (possible_volunteers.len <= 0) // This shouldn't happen, as ready() should return FALSE if there is not a single valid candidate
		message_admins("Possible volunteers was 0. This shouldn't appear, because of ready(), unless you forced it!")
		return

	mode.log_dynamic_and_announce("Polling [possible_volunteers.len] players to apply for the [name] ruleset.")
	candidates = poll_ghost_candidates("The mode is looking for volunteers to become [antag_flag] for [name]", antag_flag_override, antag_flag || antag_flag_override, poll_time = 300)

	if(!candidates || candidates.len <= 0)
		mode.log_dynamic_and_announce("The ruleset [name] received no applications.")
		mode.executed_rules -= src
		attempt_replacement()
		return

	mode.log_dynamic_and_announce("[candidates.len] players volunteered for [name].")
	review_applications()

/// Here is where you can check if your ghost applicants are valid for the ruleset.
/// Called by send_applications().
/datum/dynamic_ruleset/midround/from_ghosts/proc/review_applications()
	if(candidates.len < required_applicants)
		mode.executed_rules -= src
		return
	for (var/i = 1, i <= required_candidates, i++)
		if(candidates.len <= 0)
			break
		var/mob/applicant = pick(candidates)
		candidates -= applicant
		if(!isobserver(applicant))
			if(applicant.stat == DEAD) // Not an observer? If they're dead, make them one.
				applicant = applicant.ghostize(FALSE)
			else // Not dead? Disregard them, pick a new applicant
				i--
				continue
		if(!applicant)
			i--
			continue
		assigned += applicant
	finish_applications()

/// Here the accepted applications get generated bodies and their setup is finished.
/// Called by review_applications()
/datum/dynamic_ruleset/midround/from_ghosts/proc/finish_applications()
	var/i = 0
	for(var/mob/applicant as anything in assigned)
		i++
		var/mob/new_character = applicant
		if(makeBody)
			new_character = generate_ruleset_body(applicant)
		finish_setup(new_character, i)
		notify_ghosts("[applicant.name] has been picked for the ruleset [name]!", source = new_character, action = NOTIFY_ORBIT, header="Something Interesting!")

/datum/dynamic_ruleset/midround/from_ghosts/proc/generate_ruleset_body(mob/applicant)
	var/mob/living/carbon/human/new_character = make_body(applicant)
	new_character.dna.remove_all_mutations()
	return new_character

/datum/dynamic_ruleset/midround/from_ghosts/proc/finish_setup(mob/new_character, index)
	var/datum/antagonist/new_role = new antag_datum()
	setup_role(new_role)
	new_character.mind.add_antag_datum(new_role)
	new_character.mind.special_role = antag_flag

/datum/dynamic_ruleset/midround/from_ghosts/proc/setup_role(datum/antagonist/new_role)
	return

/// Fired when there are no valid candidates. Will spawn a sleeper agent or latejoin traitor.
/datum/dynamic_ruleset/midround/from_ghosts/proc/attempt_replacement()
	var/datum/dynamic_ruleset/midround/from_living/autotraitor/sleeper_agent = new

	mode.configure_ruleset(sleeper_agent)

	if (!mode.picking_specific_rule(sleeper_agent))
		return

	mode.picking_specific_rule(/datum/dynamic_ruleset/latejoin/infiltrator)

///subtype to handle checking players
/datum/dynamic_ruleset/midround/from_living
	weight = 0
	abstract_type = /datum/dynamic_ruleset/midround/from_living

/datum/dynamic_ruleset/midround/from_living/ready(forced)
	if(!check_candidates())
		return FALSE
	return ..()


//////////////////////////////////////////////
//                                          //
//           SYNDICATE TRAITORS             //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/midround/from_living/autotraitor
	name = "Darkoth Sleeper Agent"
	midround_ruleset_style = MIDROUND_RULESET_STYLE_LIGHT
	antag_datum = /datum/antagonist/traitor/saboteur
	antag_flag = ROLE_SLEEPER_AGENT
	antag_flag_override = ROLE_TRAITOR
	protected_roles = list(
		JOB_CAPTAIN,
		JOB_DETECTIVE,
		JOB_HEAD_OF_PERSONNEL,
		JOB_HEAD_OF_SECURITY,
		JOB_PRISONER,
		JOB_SECURITY_OFFICER,
		JOB_WARDEN,
	)
	restricted_roles = list(
		JOB_AI,
		JOB_CYBORG,
		ROLE_POSITRONIC_BRAIN,
	)
	required_candidates = 1
	weight = 35
	cost = 3
	requirements = list(3,3,3,3,3,3,3,3,3,3)
	repeatable = TRUE

/datum/dynamic_ruleset/midround/from_living/autotraitor/trim_candidates()
	..()
	candidates = living_players
	for(var/mob/living/player in candidates)
		if(issilicon(player)) // Your assigned role doesn't change when you are turned into a silicon.
			candidates -= player
		else if(is_centcom_level(player.z))
			candidates -= player // We don't autotator people in CentCom
		else if(player.mind && (player.mind.special_role || player.mind.antag_datums?.len > 0))
			candidates -= player // We don't autotator people with roles already

/datum/dynamic_ruleset/midround/from_living/autotraitor/execute()
	var/mob/M = pick(candidates)
	assigned += M
	candidates -= M
	var/datum/antagonist/traitor/newTraitor = new
	M.mind.add_antag_datum(newTraitor)
	message_admins("[ADMIN_LOOKUPFLW(M)] was selected by the [name] ruleset and has been made into a midround traitor.")
	log_dynamic("[key_name(M)] was selected by the [name] ruleset and has been made into a midround traitor.")
	return TRUE

//////////////////////////////////////////////
//                                          //
//         Malfunctioning AI                //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/midround/malf
	name = "Malfunctioning AI"
	midround_ruleset_style = MIDROUND_RULESET_STYLE_HEAVY
	antag_datum = /datum/antagonist/malf_ai
	antag_flag = ROLE_MALF_MIDROUND
	antag_flag_override = ROLE_MALF
	enemy_roles = list(
		JOB_CHEMIST,
		JOB_CHIEF_ENGINEER,
		JOB_HEAD_OF_SECURITY,
		JOB_SECURITY_OFFICER,
		JOB_WARDEN,
	)
	exclusive_roles = list(JOB_AI)
	required_enemies = list(4,4,4,4,4,4,2,2,2,0)
	required_candidates = 1
	minimum_players = 25
	weight = 2
	cost = 10
	required_type = /mob/living/silicon/ai
	blocking_rules = list(/datum/dynamic_ruleset/roundstart/malf_ai)

/datum/dynamic_ruleset/midround/malf/trim_candidates()
	..()
	candidates = living_players
	for(var/mob/living/player in candidates)
		if(!isAI(player))
			candidates -= player
			continue

		if(is_centcom_level(player.z))
			candidates -= player
			continue

		if(player.mind && (player.mind.special_role || player.mind.antag_datums?.len > 0))
			candidates -= player

/datum/dynamic_ruleset/midround/malf/execute()
	if(!candidates || !candidates.len)
		return FALSE
	var/mob/living/silicon/ai/new_malf_ai = pick_n_take(candidates)
	assigned += new_malf_ai.mind
	var/datum/antagonist/malf_ai/malf_antag_datum = new
	new_malf_ai.mind.special_role = antag_flag
	new_malf_ai.mind.add_antag_datum(malf_antag_datum)
	if(prob(MALF_ION_PROB))
		priority_announce("Ion storm detected near the station. Please check all AI-controlled equipment for errors.", "Anomaly Alert", ANNOUNCER_IONSTORM)
		if(prob(REPLACE_LAW_WITH_ION_PROB))
			new_malf_ai.replace_random_law(generate_ion_law(), list(LAW_INHERENT, LAW_SUPPLIED, LAW_ION), LAW_ION)
		else
			new_malf_ai.add_ion_law(generate_ion_law())
	return TRUE

//////////////////////////////////////////////
//                                          //
//            SPACE NINJA (GHOST)           //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/midround/from_ghosts/space_ninja
	name = "Space Ninja"
	midround_ruleset_style = MIDROUND_RULESET_STYLE_HEAVY
	antag_datum = /datum/antagonist/ninja
	antag_flag = ROLE_NINJA
	enemy_roles = list(
		JOB_CAPTAIN,
		JOB_DETECTIVE,
		JOB_HEAD_OF_SECURITY,
		JOB_SECURITY_OFFICER,
	)
	required_enemies = list(2,2,1,1,1,1,1,0,0,0)
	required_candidates = 1
	weight = 4
	cost = 8
	minimum_players = 30
	repeatable = TRUE
	var/list/spawn_locs = list()

/datum/dynamic_ruleset/midround/from_ghosts/space_ninja/execute()
	for(var/obj/effect/landmark/carpspawn/carp_spawn in GLOB.landmarks_list)
		if(!isturf(carp_spawn.loc))
			stack_trace("Carp spawn found not on a turf: [carp_spawn.type] on [isnull(carp_spawn.loc) ? "null" : carp_spawn.loc.type]")
			continue
		spawn_locs += carp_spawn.loc
	if(!spawn_locs.len)
		message_admins("No valid spawn locations found, aborting...")
		return MAP_ERROR
	return ..()

/datum/dynamic_ruleset/midround/from_ghosts/space_ninja/generate_ruleset_body(mob/applicant)
	var/mob/living/carbon/human/ninja = create_space_ninja(pick(spawn_locs))
	ninja.key = applicant.key
	ninja.mind.add_antag_datum(/datum/antagonist/ninja)

	message_admins("[ADMIN_LOOKUPFLW(ninja)] has been made into a Space Ninja by the midround ruleset.")
	log_dynamic("[key_name(ninja)] was spawned as a Space Ninja by the midround ruleset.")
	return ninja

//////////////////////////////////////////////
//                                          //
//            SPIDERS     (GHOST)           //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/midround/spiders
	name = "Spiders"
	midround_ruleset_style = MIDROUND_RULESET_STYLE_HEAVY
	antag_flag = ROLE_SPIDER
	required_type = /mob/dead/observer
	enemy_roles = list(
		JOB_CAPTAIN,
		JOB_DETECTIVE,
		JOB_HEAD_OF_SECURITY,
		JOB_SECURITY_OFFICER,
	)
	required_enemies = list(2,2,1,1,1,1,1,0,0,0)
	required_candidates = 0
	weight = 3
	cost = 8
	minimum_players = 27
	repeatable = TRUE
	var/spawncount = 2

/datum/dynamic_ruleset/midround/spiders/execute()
	create_midwife_eggs(spawncount)
	return ..()

/// Space Pirates ruleset
/datum/dynamic_ruleset/midround/pirates
	name = "Space Pirates"
	midround_ruleset_style = MIDROUND_RULESET_STYLE_HEAVY
	antag_flag = "Space Pirates"
	required_type = /mob/dead/observer
	enemy_roles = list(
		JOB_CAPTAIN,
		JOB_DETECTIVE,
		JOB_HEAD_OF_SECURITY,
		JOB_SECURITY_OFFICER,
	)
	required_enemies = list(2,2,1,1,1,1,1,0,0,0)
	required_candidates = 0
	weight = 4
	cost = 8
	minimum_players = 27
	repeatable = TRUE

/datum/dynamic_ruleset/midround/pirates/acceptable(population=0, threat=0)
	if (!SSmapping.empty_space)
		return FALSE
	return ..()

/datum/dynamic_ruleset/midround/pirates/execute()
	send_pirate_threat()
	return ..()

//////////////////////////////////////////////
//                                          //
//           NIGHTMARE (GHOST)              //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/midround/from_ghosts/nightmare
	name = "Nightmare"
	midround_ruleset_style = MIDROUND_RULESET_STYLE_LIGHT
	antag_datum = /datum/antagonist/nightmare
	antag_flag = ROLE_NIGHTMARE
	antag_flag_override = ROLE_ALIEN
	enemy_roles = list(
		JOB_CAPTAIN,
		JOB_DETECTIVE,
		JOB_HEAD_OF_SECURITY,
		JOB_SECURITY_OFFICER,
	)
	required_enemies = list(2,2,1,1,1,1,1,0,0,0)
	required_candidates = 1
	weight = 3
	cost = 5
	minimum_players = 15
	repeatable = TRUE
	var/list/spawn_locs = list()

/datum/dynamic_ruleset/midround/from_ghosts/nightmare/acceptable(population=0, threat=0)
	for(var/X in GLOB.xeno_spawn)
		var/turf/T = X
		var/light_amount = T.get_lumcount()
		if(light_amount < SHADOW_SPECIES_LIGHT_THRESHOLD)
			spawn_locs += T
	if(!spawn_locs.len)
		return FALSE
	. = ..()

/datum/dynamic_ruleset/midround/from_ghosts/nightmare/generate_ruleset_body(mob/applicant)
	var/datum/mind/player_mind = new /datum/mind(applicant.key)
	player_mind.active = TRUE

	var/mob/living/carbon/human/S = new (pick(spawn_locs))
	player_mind.transfer_to(S)
	player_mind.set_assigned_role(SSjob.GetJobType(/datum/job/nightmare))
	player_mind.special_role = ROLE_NIGHTMARE
	player_mind.add_antag_datum(/datum/antagonist/nightmare)
	S.set_species(/datum/species/shadow/nightmare)

	playsound(S, 'sound/magic/ethereal_exit.ogg', 50, TRUE, -1)
	message_admins("[ADMIN_LOOKUPFLW(S)] has been made into a Nightmare by the midround ruleset.")
	log_dynamic("[key_name(S)] was spawned as a Nightmare by the midround ruleset.")
	return S

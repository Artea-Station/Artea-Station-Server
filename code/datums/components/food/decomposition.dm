//"Don't leave food on the floor, that's how we get ants"

#define DECOMPOSITION_TIME 10 MINUTES
#define DECOMPOSITION_TIME_RAW 5 MINUTES
#define DECOMPOSITION_TIME_GROSS 7 MINUTES

///Makes things decompose when exposed to germs. Requires /datum/component/germ_sensitive to detect exposure.
/datum/component/decomposition
	dupe_mode = COMPONENT_DUPE_UNIQUE
	/// Makes sure maploaded food only starts decomposing if a player's EVER picked it up before
	var/handled = TRUE
	/// Used to stop food in someone's hand & in storage slots from decomposing.
	var/protected = FALSE
	/// Used to stop the timer & check for the examine proc
	var/timerid
	/// The total time that this takes to decompose
	var/original_time = DECOMPOSITION_TIME
	/// Used so the timer won't reset.
	var/time_remaining = DECOMPOSITION_TIME
	/// Used to give raw/gross food lower timers
	var/decomp_flags
	/// Use for determining what kind of item the food decomposes into.
	var/decomp_result
	/// Does our food attract ants?
	var/produce_ants = FALSE

/datum/component/decomposition/Initialize(mapload, decomp_req_handle, decomp_flags = NONE, decomp_result, ant_attracting = FALSE, custom_time = 0, stink_particles = /particles/stink)
	if(!ismovable(parent) || !HAS_TRAIT(parent, TRAIT_GERM_SENSITIVE))
		return COMPONENT_INCOMPATIBLE

	src.decomp_flags = decomp_flags
	src.decomp_result = decomp_result
	if(mapload || decomp_req_handle)
		handled = FALSE
	src.produce_ants = ant_attracting

	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(handle_movement))
	RegisterSignal(parent, list(
		COMSIG_ITEM_PICKUP, //person picks up an item
		COMSIG_ATOM_ENTERED), //Object enters a storage object (boxes, etc.)
		PROC_REF(picked_up))
	RegisterSignal(parent, list(
		COMSIG_ITEM_DROPPED, //Object is dropped anywhere
		COMSIG_ATOM_EXITED), //Object exits a storage object (boxes, etc)
		PROC_REF(dropped))
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(examine))

	if(custom_time) // We have a custom decomposition time, set it to that
		original_time = custom_time
	else if(decomp_flags & RAW) // Raw food overrides gross
		original_time = DECOMPOSITION_TIME_RAW
	else if(decomp_flags & GROSS)
		original_time = DECOMPOSITION_TIME_GROSS

	time_remaining = original_time

	src.stink_particles = stink_particles

/datum/component/decomposition/Destroy()
	. = ..()
	if(particle_effect)
		QDEL_NULL(particle_effect)

/datum/component/decomposition/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ATOM_GERM_EXPOSED, PROC_REF(start_timer))
	RegisterSignal(parent, COMSIG_ATOM_GERM_UNEXPOSED, PROC_REF(remove_timer))
	RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(examine))

/datum/component/decomposition/UnregisterFromParent()
	UnregisterSignal(parent, list(
		COMSIG_ATOM_GERM_EXPOSED,
		COMSIG_ATOM_GERM_UNEXPOSED,
		COMSIG_ATOM_EXAMINE
	))

/datum/component/decomposition/proc/start_timer()
	SIGNAL_HANDLER
	if(!handled) // If maploaded, has someone touched this previously?
		handled = TRUE // First germ exposure is ignored
		return

	// If all other checks fail, then begin decomposition.
	timerid = addtimer(CALLBACK(src, PROC_REF(decompose)), time_remaining, TIMER_STOPPABLE | TIMER_UNIQUE)

/datum/component/decomposition/Destroy()
	remove_timer()
	return ..()

/datum/component/decomposition/proc/remove_timer()
	if(active_timers) // Makes sure there's an active timer to delete.
		time_remaining = timeleft(timerid)
		deltimer(timerid)

/datum/component/decomposition/proc/stink_up()
	stink_timerid = null
	// Neither should happen, but to be sure
	if(particle_effect || !stink_particles)
		return
	// we don't want stink lines on mobs (even though it'd be quite funny)
	particle_effect = new(parent, stink_particles, isitem(parent) ? NONE : PARTICLE_ATTACH_MOB)

/datum/component/decomposition/proc/decompose()
	var/obj/decomp = parent //Lets us spawn things at decomp
	if(produce_ants)
		new /obj/effect/decal/cleanable/ants(decomp.loc)
	if(decomp_result)
		new decomp_result(decomp.loc)
	decomp.visible_message("<span class='notice'>[decomp] gets overtaken by mold[produce_ants ? " and ants":""]! Gross!</span>")
	qdel(decomp)
	return

/datum/component/decomposition/proc/examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	var/time_d = 0
	if(active_timers) // Is the timer currently applied to this?
		time_d = timeleft(timerid)
	else
		time_d = time_remaining
	switch(time_d / original_time)
		if(0.5 to 0.75) // 25% rotten
			examine_list += span_notice("[parent] looks kinda stale.")
		if(0.25 to 0.5) // 50% rotten
			examine_list += span_notice("[parent] is starting to look pretty gross.")
		if(0 to 0.25) // 75% rotten
			examine_list += span_danger("[parent] barely looks edible.")

#undef DECOMPOSITION_TIME
#undef DECOMPOSITION_TIME_GROSS
#undef DECOMPOSITION_TIME_RAW

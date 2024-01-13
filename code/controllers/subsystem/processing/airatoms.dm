PROCESSING_SUBSYSTEM_DEF(airatoms)
	name = "Air (Atoms)"
	priority = FIRE_PRIORITY_AIRATOMS
	wait = 0.5 SECONDS

/datum/controller/subsystem/processing/airatoms/fire(resumed = FALSE)
	if (!resumed)
		currentrun = processing.Copy()
	//cache for sanic speed (lists are references anyways)
	var/list/current_run = currentrun

	while(current_run.len)
		var/atom/thing = current_run[current_run.len]
		current_run.len--
		if(QDELETED(thing))
			processing -= thing
		else if(thing.process_atmos_exposure(wait * 0.1) == PROCESS_KILL)
			// fully stop so that a future START_PROCESSING will work
			STOP_PROCESSING(src, thing)
		if (MC_TICK_CHECK)
			return

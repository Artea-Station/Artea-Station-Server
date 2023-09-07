/// Element that will tell anyone who examines the parent what company made it
/datum/element/manufacturer_examine
	element_flags = ELEMENT_DETACH

/datum/element/manufacturer_examine/Attach(atom/target)
	. = ..()

	if(!istype(target)) // Just in case someone loses it and tries to put this on a datum
		return ELEMENT_INCOMPATIBLE

	RegisterSignal(target, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))

/datum/element/manufacturer_examine/Detach(datum/target)
	. = ..()
	UnregisterSignal(target, COMSIG_PARENT_EXAMINE)

/// Sticks the string given to the element in Attach in the description of the attached target
/datum/element/manufacturer_examine/proc/on_examine(atom/target, mob/examiner, list/examine_list)
	SIGNAL_HANDLER

	if(istext(!target.manufacturer))
		return

	examine_list += "<br>[target.p_they(TRUE)] [target.p_have()] [target.manufacturer] [target.p_them()]."

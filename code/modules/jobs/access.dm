
/// Returns TRUE if this mob has sufficient access to use this object.
/// Can be provided an optional list of extra required accesses. Mostly for conditional accesses.
/obj/proc/allowed(mob/accessor, list/extra_accesses)
	// ARTEA TODO: Yeet this signal garbage. A whole ass signal at the very start of a proc for a singular usecase that should've just been a proc override.
	var/result_bitflags = SEND_SIGNAL(src, COMSIG_OBJ_ALLOWED, accessor)
	if(result_bitflags & COMPONENT_OBJ_ALLOW)
		return TRUE
	if(result_bitflags & COMPONENT_OBJ_DISALLOW) // override all other checks
		return FALSE
	// ARTEA TODO: Yeet this signal garbage too. This should be tied to an ID, what the fuck?!
	//If the mob has the simple_access component with the requried access, we let them in.
	else if(SEND_SIGNAL(accessor, COMSIG_MOB_TRIED_ACCESS, src) & ACCESS_ALLOWED)
		return TRUE

	if(!req_access && !req_one_access)
		return TRUE

	if(accessor.has_unlimited_silicon_privilege)
		return TRUE

	var/obj/item/card/id/id_card

	//If the mob is holding a valid ID, we let them in. get_active_held_item() is on the mob level, so no need to copypasta everywhere.
	if(check_access(accessor.get_active_held_item(), extra_accesses))
		return TRUE
	//if they are wearing a card that has access, that works
	else if(ishuman(accessor))
		var/mob/living/carbon/human/human_accessor = accessor
		if(check_access(human_accessor.wear_id, extra_accesses))
			return TRUE
	//if they have a hacky abstract animal ID with the required access, let them in i guess...
	else if(isanimal(accessor))
		var/mob/living/simple_animal/animal = accessor
		if(check_access(animal.access_card, extra_accesses))
			return TRUE

	var/list/card_accesses

	if(isbrain(accessor)) // Fucking snowflake mecha code.
		var/mob/living/brain/brain = accessor
		if(istype(brain.loc, /obj/item/mmi))
			var/obj/item/mmi/brain_mmi = brain.loc
			if(ismecha(brain_mmi.loc))
				var/obj/vehicle/sealed/mecha/big_stompy_robot = brain_mmi.loc
				return check_access(big_stompy_robot.operation_req_access, extra_accesses)

	if(!istype(id_card) && !card_accesses)
		return FALSE
	else if(id_card)
		LAZYADD(card_accesses, id_card.GetAccess())

	return check_access(card_accesses, extra_accesses)

/obj/proc/check_access(target, list/extra_accesses)
	if(!target && req_access)
		return FALSE

	var/list/accesses
	if(isitem(target))
		var/obj/item/item = target
		accesses = item.GetAccess()
	else if(islist(target))
		accesses = target

	if(req_access || extra_accesses)
		var/accesses = list()
		if(req_access)
			accesses += req_access
		if(extra_accesses)
			accesses += extra_accesses

		for(var/access in req_access)
			if(access in accesses)
				return TRUE
		return FALSE

	if(req_one_access)
		for(var/access in req_one_access)
			if(!(access in accesses))
				return FALSE
	return TRUE

/obj/item/proc/GetAccess()
	return list()

/obj/item/proc/GetID()
	return null

/obj/item/proc/RemoveID()
	return null

/obj/item/proc/InsertID()
	return FALSE

/*
 * Checks if this packet can access this device
 *
 * Normally just checks the access list however you can override it for
 * hacking proposes or if wires are cut
 *
 * Arguments:
 * * passkey - passkey from the datum/netdata packet
 */
/obj/proc/check_access_ntnet(list/passkey)
	return check_access(passkey)

/// Returns the SecHUD job icon state for whatever this object's ID card is, if it has one.
/obj/item/proc/get_sechud_job_icon_state()
	var/obj/item/card/id/id_card = GetID()

	return id_card?.get_trim_sechud_icon_state() || SECHUD_NO_ID

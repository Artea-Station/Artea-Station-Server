
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

	if(!required_access)
		return TRUE

	if(accessor.has_unlimited_silicon_privilege)
		return TRUE

	var/obj/item/card/id/id_card = get_id(accessor)
	var/list/card_accesses

	if(isbrain(accessor)) // Fucking snowflake mecha code.
		var/mob/living/brain/brain = accessor
		if(istype(brain.loc, /obj/item/mmi))
			var/obj/item/mmi/brain_mmi = brain.loc
			if(ismecha(brain_mmi.loc))
				var/obj/vehicle/sealed/mecha/big_stompy_robot = brain_mmi.loc
				card_accesses = big_stompy_robot.operation_req_access

	if(!istype(id_card) && !card_accesses)
		return FALSE
	else if(id_card)
		LAZYADD(card_accesses, id_card.GetAccess())

	if(istext(required_access))
		return required_access in card_accesses

	if(req_access || extra_accesses)
		var/accesses = list()
		if(req_access)
			accesses += req_access
		if(extra_accesses)
			accesses += extra_accesses

		for(var/access in accesses)
			if(access in card_accesses)
				return TRUE
		return FALSE

	if(req_one_access)
		for(var/access in req_one_access)
			if(!(access in card_accesses))
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

	var/datum/access/access = GLOB.access_datums[required_access]
	return access.can_access(passkey)

/// Returns the SecHUD job icon state for whatever this object's ID card is, if it has one.
/obj/item/proc/get_sechud_job_icon_state()
	var/obj/item/card/id/id_card = GetID()

	return id_card?.get_trim_sechud_icon_state() || SECHUD_NO_ID

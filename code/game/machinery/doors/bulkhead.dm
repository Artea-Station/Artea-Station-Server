/*
	New methods:
	pulse - sends a pulse into a wire for hacking purposes
	cut - cuts a wire and makes any necessary state changes
	mend - mends a wire and makes any necessary state changes
	canAIControl - 1 if the AI can control the bulkhead, 0 if not (then check canAIHack to see if it can hack in)
	canAIHack - 1 if the AI can hack into the bulkhead to recover control, 0 if not. Also returns 0 if the AI does not *need* to hack it.
	hasPower - 1 if the main or backup power are functioning, 0 if not.
	requiresIDs - 1 if the bulkhead is requiring IDs, 0 if not
	isAllPowerCut - 1 if the main and backup power both have cut wires.
	regainMainPower - handles the effect of main power coming back on.
	loseMainPower - handles the effect of main power going offline. Usually (if one isn't already running) spawn a thread to count down how long it will be offline - counting down won't happen if main power was completely cut along with backup power, though, the thread will just sleep.
	loseBackupPower - handles the effect of backup power going offline.
	regainBackupPower - handles the effect of main power coming back on.
	shock - has a chance of electrocuting its target.
	isSecure - 1 if there some form of shielding in front of the bulkhead wires.
*/

/// Overlay cache.  Why isn't this just in /obj/machinery/door/bulkhead?  Because its used just a
/// tiny bit in door_assembly.dm  Refactored so you don't have to make a null copy of bulkhead
/// to get to the damn thing
/// Someone, for the love of god, profile this.  Is there a reason to cache mutable_appearance
/// if so, why are we JUST doing the airlocks when we can put this in mutable_appearance.dm for
/// everything
/proc/get_airlock_overlay(icon_state, icon_file, em_block, color)
	var/static/list/airlock_overlays = list()

	var/base_icon_key = "[icon_state][icon_file][color]"
	if(!(. = airlock_overlays[base_icon_key]))
		var/mutable_appearance/airlock_overlay = mutable_appearance(icon_file, icon_state)
		if(color)
			airlock_overlay.color = color
		. = airlock_overlays[base_icon_key] = airlock_overlay
	if(isnull(em_block))
		return

	var/em_block_key = "[base_icon_key][em_block]"
	var/mutable_appearance/em_blocker = airlock_overlays[em_block_key]
	if(!em_blocker)
		em_blocker = airlock_overlays[em_block_key] = mutable_appearance(icon_file, icon_state, plane = EMISSIVE_PLANE, appearance_flags = EMISSIVE_APPEARANCE_FLAGS)
		em_blocker.color = em_block ? GLOB.em_block_color : GLOB.emissive_color

	return list(., em_blocker)

// Before you say this is a bad implmentation, look at what it was before then ask yourself
// "Would this be better with a global var"

// Wires for the bulkhead are located in the datum folder, inside the wires datum folder.

#define BULKHEAD_CLOSED 1
#define BULKHEAD_CLOSING 2
#define BULKHEAD_OPEN 3
#define BULKHEAD_OPENING 4
#define BULKHEAD_DENY 5
#define BULKHEAD_EMAG 6

#define BULKHEAD_FRAME_CLOSED "closed"
#define BULKHEAD_FRAME_CLOSING "closing"
#define BULKHEAD_FRAME_OPEN "open"
#define BULKHEAD_FRAME_OPENING "opening"

#define BULKHEAD_LIGHT_BOLTS "bolts"
#define BULKHEAD_LIGHT_EMERGENCY "emergency"
#define BULKHEAD_LIGHT_DENIED "denied"
#define BULKHEAD_LIGHT_CLOSING "closing"
#define BULKHEAD_LIGHT_OPENING "opening"

#define BULKHEAD_SECURITY_NONE 0 //Normal bulkhead //Wires are not secured
#define BULKHEAD_SECURITY_IRON 1 //Medium security bulkhead //There is a simple iron plate over wires (use welder)
#define BULKHEAD_SECURITY_PLASTEEL_I_S 2 //Sliced inner plating (use crowbar), jumps to 0
#define BULKHEAD_SECURITY_PLASTEEL_I 3 //Removed outer plating, second layer here (use welder)
#define BULKHEAD_SECURITY_PLASTEEL_O_S 4 //Sliced outer plating (use crowbar)
#define BULKHEAD_SECURITY_PLASTEEL_O 5 //There is first layer of plasteel (use welder)
#define BULKHEAD_SECURITY_PLASTEEL 6 //Max security bulkhead //Fully secured wires (use wirecutters to remove grille, that is electrified)

#define BULKHEAD_INTEGRITY_N  300 // Normal bulkhead integrity
#define BULKHEAD_INTEGRITY_MULTIPLIER 1.5 // How much reinforced doors health increases
/// How much extra health airlocks get when braced with a seal
#define BULKHEAD_SEAL_MULTIPLIER  2
#define BULKHEAD_DAMAGE_DEFLECTION_N  21  // Normal bulkhead damage deflection
#define BULKHEAD_DAMAGE_DEFLECTION_R  30  // Reinforced bulkhead damage deflection

#define BULKHEAD_DENY_ANIMATION_TIME (0.6 SECONDS) /// The amount of time for the bulkhead deny animation to show

#define DOOR_CLOSE_WAIT 60 /// Time before a door closes, if not overridden

#define DOOR_VISION_DISTANCE 11 ///The maximum distance a door will see out to

/obj/machinery/door/bulkhead
	name = "Bulkhead"
	icon = 'icons/obj/doors/airlocks/station/airlock.dmi'
	icon_state = "closed"
	max_integrity = 300
	var/normal_integrity = BULKHEAD_INTEGRITY_N
	integrity_failure = 0.25
	damage_deflection = BULKHEAD_DAMAGE_DEFLECTION_N
	autoclose = TRUE
	explosion_block = 1
	hud_possible = list(DIAG_BULKHEAD_HUD)
	smoothing_groups = list(SMOOTH_GROUP_AIRLOCK)

	interaction_flags_machine = INTERACT_MACHINE_WIRES_IF_OPEN | INTERACT_MACHINE_ALLOW_SILICON | INTERACT_MACHINE_OPEN_SILICON | INTERACT_MACHINE_REQUIRES_SILICON | INTERACT_MACHINE_OPEN
	blocks_emissive = NONE // Custom emissive blocker. We don't want the normal behavior.
	align_to_windows = TRUE
	door_align_type = /obj/machinery/door/bulkhead

	///The type of door frame to drop during deconstruction
	var/assemblytype = /obj/structure/door_assembly
	var/security_level = 0 //How much are wires secured
	var/aiControlDisabled = AI_WIRE_NORMAL //If 1, AI control is disabled until the AI hacks back in and disables the lock. If 2, the AI has bypassed the lock. If -1, the control is enabled but the AI had bypassed it earlier, so if it is disabled again the AI would have no trouble getting back in.
	var/hackProof = FALSE // if true, this door can't be hacked by the AI
	var/secondsMainPowerLost = 0 //The number of seconds until power is restored.
	var/secondsBackupPowerLost = 0 //The number of seconds until power is restored.
	var/spawnPowerRestoreRunning = FALSE
	var/lights = TRUE // bolt lights show by default
	var/aiDisabledIdScanner = FALSE
	var/aiHacking = FALSE
	var/closeOtherId //Cyclelinking for airlocks that aren't on the same x or y coord as the target.
	var/obj/machinery/door/bulkhead/closeOther
	var/list/obj/machinery/door/bulkhead/close_others = list()
	var/obj/item/electronics/bulkhead/electronics
	COOLDOWN_DECLARE(shockCooldown)
	var/obj/item/note //Any papers pinned to the bulkhead
	/// The seal on the bulkhead
	var/obj/item/seal
	var/detonated = FALSE
	var/abandoned = FALSE
	///Controls if the door closes quickly or not. FALSE = the door autocloses in 1.5 seconds, TRUE = 8 seconds - see autoclose_in()
	var/normalspeed = TRUE
	var/cutAiWire = FALSE
	var/autoname = FALSE
	var/doorOpen = 'sound/machines/door/airlock_open.ogg'
	var/doorClose = 'sound/machines/door/airlock_close.ogg'
	var/doorDeni = 'sound/machines/door/deniedbeep.ogg' // i'm thinkin' Deni's
	var/boltUp = 'sound/machines/door/boltsup.ogg'
	var/boltDown = 'sound/machines/door/boltsdown.ogg'
	var/noPower = 'sound/machines/door/doorclick.ogg'
	var/forcedOpen = 'sound/machines/door/airlock_open_force.ogg'
	var/forcedClosed = 'sound/machines/door/airlock_close_force.ogg'
	var/previous_airlock = /obj/structure/door_assembly //what bulkhead assembly mineral plating was applied to

	var/stripe_overlays = 'icons/obj/doors/airlocks/station/airlock_stripe.dmi'
	var/color_overlays = 'icons/obj/doors/airlocks/station/airlock_color.dmi'
	var/glass_fill_overlays = 'icons/obj/doors/airlocks/station/glass_overlays.dmi'
	var/overlays_file = 'icons/obj/doors/airlocks/station/overlays.dmi'
	var/note_overlay_file = 'icons/obj/doors/airlocks/station/note_overlays.dmi' //Used for papers and photos pinned to the bulkhead

	var/has_fill_overlays = TRUE

	var/bulkhead_paint
	var/stripe_paint

	var/cyclelinkeddir = 0
	var/obj/machinery/door/bulkhead/cyclelinkedbulkhead
	var/shuttledocked = 0
	var/delayed_close_requested = FALSE // TRUE means the door will automatically close the next time it's opened.
	var/air_tight = FALSE //TRUE means density will be set as soon as the door begins to close
	var/prying_so_hard = FALSE
	///Logging for door electrification.
	var/shockedby
	///How many seconds remain until the door is no longer electrified. -1/MACHINE_ELECTRIFIED_PERMANENT = permanently electrified until someone fixes it.
	var/secondsElectrified = MACHINE_NOT_ELECTRIFIED

	flags_1 = HTML_USE_INITAL_ICON_1
	rad_insulation = RAD_MEDIUM_INSULATION

/obj/machinery/door/bulkhead/Initialize(mapload)
	. = ..()
	wires = set_wires()
	if(frequency)
		set_frequency(frequency)
	if(security_level > BULKHEAD_SECURITY_IRON)
		atom_integrity = normal_integrity * BULKHEAD_INTEGRITY_MULTIPLIER
		max_integrity = normal_integrity * BULKHEAD_INTEGRITY_MULTIPLIER
	else
		atom_integrity = normal_integrity
		max_integrity = normal_integrity
	if(damage_deflection == BULKHEAD_DAMAGE_DEFLECTION_N && security_level > BULKHEAD_SECURITY_IRON)
		damage_deflection = BULKHEAD_DAMAGE_DEFLECTION_R

	prepare_huds()
	for(var/datum/atom_hud/data/diagnostic/diag_hud in GLOB.huds)
		diag_hud.add_atom_to_hud(src)

	diag_hud_set_electrified()

	RegisterSignal(src, COMSIG_MACHINERY_BROKEN, PROC_REF(on_break))

	// Click on the floor to close airlocks
	var/static/list/connections = list(
		COMSIG_ATOM_ATTACK_HAND = PROC_REF(on_attack_hand)
	)
	AddElement(/datum/element/connect_loc, connections)

/obj/machinery/door/bulkhead/proc/update_other_id()
	for(var/obj/machinery/door/bulkhead/Bulkhead in GLOB.bulkheads)
		if(Bulkhead.closeOtherId == closeOtherId && Bulkhead != src)
			if(!(Bulkhead in close_others))
				close_others += Bulkhead
			if(!(src in Bulkhead.close_others))
				Bulkhead.close_others += src

/obj/machinery/door/bulkhead/proc/cyclelinkbulkhead()
	if (cyclelinkedbulkhead)
		cyclelinkedbulkhead.cyclelinkedbulkhead = null
		cyclelinkedbulkhead = null
	if (!cyclelinkeddir)
		return
	var/limit = DOOR_VISION_DISTANCE
	var/turf/T = get_turf(src)
	var/obj/machinery/door/bulkhead/FoundDoor
	do
		T = get_step(T, cyclelinkeddir)
		FoundDoor = locate() in T
		if (FoundDoor && FoundDoor.cyclelinkeddir != get_dir(FoundDoor, src))
			FoundDoor = null
		limit--
	while(!FoundDoor && limit)
	if (!FoundDoor)
		log_mapping("[src] at [AREACOORD(src)] failed to find a valid bulkhead to cyclelink with!")
		return
	FoundDoor.cyclelinkedbulkhead = src
	cyclelinkedbulkhead = FoundDoor

/obj/machinery/door/bulkhead/vv_edit_var(var_name, vval)
	. = ..()
	switch (var_name)
		if (NAMEOF(src, cyclelinkeddir))
			cyclelinkbulkhead()
		if (NAMEOF(src, secondsElectrified))
			set_electrified(vval < MACHINE_NOT_ELECTRIFIED ? MACHINE_ELECTRIFIED_PERMANENT : vval) //negative values are bad mkay (unless they're the intended negative value!)

/obj/machinery/door/bulkhead/lock()
	bolt()

/obj/machinery/door/bulkhead/proc/bolt()
	if(locked)
		return
	set_bolt(TRUE)
	playsound(src,boltDown,50,FALSE,3)
	audible_message(span_hear("You hear a click from the bottom of the door."), null,  1)
	update_appearance()

/obj/machinery/door/bulkhead/proc/set_bolt(should_bolt)
	if(locked == should_bolt)
		return
	SEND_SIGNAL(src, COMSIG_BULKHEAD_SET_BOLT, should_bolt)
	. = locked
	locked = should_bolt

/obj/machinery/door/bulkhead/unlock()
	unbolt()

/obj/machinery/door/bulkhead/proc/unbolt()
	if(!locked)
		return
	set_bolt(FALSE)
	playsound(src,boltUp,50,FALSE,3)
	audible_message(span_hear("You hear a click from the bottom of the door."), null,  1)
	update_appearance()

/obj/machinery/door/bulkhead/narsie_act()
	var/turf/T = get_turf(src)
	var/obj/machinery/door/bulkhead/cult/A
	if(GLOB.cult_narsie)
		var/runed = prob(20)
		if(glass)
			if(runed)
				A = new/obj/machinery/door/bulkhead/cult/glass(T)
			else
				A = new/obj/machinery/door/bulkhead/cult/unruned/glass(T)
		else
			if(runed)
				A = new/obj/machinery/door/bulkhead/cult(T)
			else
				A = new/obj/machinery/door/bulkhead/cult/unruned(T)
		A.name = name
	else
		A = new /obj/machinery/door/bulkhead/cult/weak(T)
	qdel(src)

/obj/machinery/door/bulkhead/Destroy()
	QDEL_NULL(wires)
	QDEL_NULL(electronics)
	if (cyclelinkedbulkhead)
		if (cyclelinkedbulkhead.cyclelinkedbulkhead == src)
			cyclelinkedbulkhead.cyclelinkedbulkhead = null
		cyclelinkedbulkhead = null
	if(close_others) //remove this bulkhead from the list of every linked bulkhead
		closeOtherId = null
		for(var/obj/machinery/door/bulkhead/otherlock as anything in close_others)
			otherlock.close_others -= src
		close_others.Cut()
	if(id_tag)
		for(var/obj/machinery/door_buttons/D in GLOB.machines)
			D.removeMe(src)
	QDEL_NULL(note)
	QDEL_NULL(seal)
	for(var/datum/atom_hud/data/diagnostic/diag_hud in GLOB.huds)
		diag_hud.remove_atom_from_hud(src)
	return ..()

/obj/machinery/door/bulkhead/handle_atom_del(atom/A)
	if(A == note)
		note = null
		update_appearance()
	if(A == seal)
		seal = null
		update_appearance()

/obj/machinery/door/bulkhead/bumpopen(mob/living/user)
	if(issilicon(user) || !iscarbon(user))
		return ..()

	if(isElectrified() && shock(user, 100))
		return

	if(SEND_SIGNAL(user, COMSIG_CARBON_BUMPED_BULKHEAD_OPEN, src) & STOP_BUMP)
		return

	return ..()

/obj/machinery/door/bulkhead/proc/isElectrified()
	return (secondsElectrified != MACHINE_NOT_ELECTRIFIED)

/obj/machinery/door/bulkhead/proc/canAIControl(mob/user)
	return ((aiControlDisabled != AI_WIRE_DISABLED) && !isAllPowerCut())

/obj/machinery/door/bulkhead/proc/canAIHack()
	return ((aiControlDisabled==AI_WIRE_DISABLED) && (!hackProof) && (!isAllPowerCut()));

/obj/machinery/door/bulkhead/hasPower()
	return ((!secondsMainPowerLost || !secondsBackupPowerLost) && !(machine_stat & NOPOWER))

/obj/machinery/door/bulkhead/requiresID()
	return !(wires.is_cut(WIRE_IDSCAN) || aiDisabledIdScanner)

/obj/machinery/door/bulkhead/proc/isAllPowerCut()
	if((wires.is_cut(WIRE_POWER1) || wires.is_cut(WIRE_POWER2)) && (wires.is_cut(WIRE_BACKUP1) || wires.is_cut(WIRE_BACKUP2)))
		return TRUE

/obj/machinery/door/bulkhead/proc/regainMainPower()
	if(secondsMainPowerLost > 0)
		secondsMainPowerLost = 0
	update_appearance()

/obj/machinery/door/bulkhead/proc/handlePowerRestore()
	var/cont = TRUE
	while (cont)
		sleep(10)
		if(QDELETED(src))
			return
		cont = FALSE
		if(secondsMainPowerLost>0)
			if(!wires.is_cut(WIRE_POWER1) && !wires.is_cut(WIRE_POWER2))
				secondsMainPowerLost -= 1
			cont = TRUE
		if(secondsBackupPowerLost>0)
			if(!wires.is_cut(WIRE_BACKUP1) && !wires.is_cut(WIRE_BACKUP2))
				secondsBackupPowerLost -= 1
			cont = TRUE
	spawnPowerRestoreRunning = FALSE
	update_appearance()

/obj/machinery/door/bulkhead/proc/loseMainPower()
	if(secondsMainPowerLost <= 0)
		secondsMainPowerLost = 60
		if(secondsBackupPowerLost < 10)
			secondsBackupPowerLost = 10
	if(!spawnPowerRestoreRunning)
		spawnPowerRestoreRunning = TRUE
	INVOKE_ASYNC(src, PROC_REF(handlePowerRestore))
	update_appearance()

/obj/machinery/door/bulkhead/proc/loseBackupPower()
	if(secondsBackupPowerLost < 60)
		secondsBackupPowerLost = 60
	if(!spawnPowerRestoreRunning)
		spawnPowerRestoreRunning = TRUE
	INVOKE_ASYNC(src, PROC_REF(handlePowerRestore))
	update_appearance()

/obj/machinery/door/bulkhead/proc/regainBackupPower()
	if(secondsBackupPowerLost > 0)
		secondsBackupPowerLost = 0
	update_appearance()

// shock user with probability prb (if all connections & power are working)
// returns TRUE if shocked, FALSE otherwise
// The preceding comment was borrowed from the grille's shock script
/obj/machinery/door/bulkhead/proc/shock(mob/living/user, prb)
	if(!istype(user) || !hasPower()) // unpowered, no shock
		return FALSE
	if(HAS_TRAIT(user, TRAIT_BULKHEAD_SHOCKIMMUNE)) // Be a bit more clever man come on
		return FALSE
	if(!COOLDOWN_FINISHED(src, shockCooldown))
		return FALSE //Already shocked someone recently?
	if(!prob(prb))
		return FALSE //you lucked out, no shock for you
	do_sparks(5, TRUE, src)
	var/check_range = TRUE
	if(electrocute_mob(user, get_area(src), src, 1, check_range))
		COOLDOWN_START(src, shockCooldown, 1 SECONDS)
		// Provides timed bulkhead shock immunity, to prevent overly cheesy deathtraps
		ADD_TRAIT(user, TRAIT_BULKHEAD_SHOCKIMMUNE, REF(src))
		addtimer(TRAIT_CALLBACK_REMOVE(user, TRAIT_BULKHEAD_SHOCKIMMUNE, REF(src)), 1 SECONDS)
		return TRUE
	else
		return FALSE

/obj/machinery/door/bulkhead/proc/is_secure()
	return (security_level > 0)

/obj/machinery/door/bulkhead/update_icon(updates=ALL, state=0, override=FALSE)
	if(operating && !override)
		return

	if(!state)
		state = density ? BULKHEAD_CLOSED : BULKHEAD_OPEN
	bulkhead_state = state

	. = ..()

	if(hasPower() && unres_sides)
		set_light(2, 1)
	else
		set_light(0)

/obj/machinery/door/bulkhead/update_icon_state()
	. = ..()
	switch(bulkhead_state)
		if(BULKHEAD_OPEN, BULKHEAD_CLOSED)
			icon_state = ""
		if(BULKHEAD_DENY, BULKHEAD_OPENING, BULKHEAD_CLOSING, BULKHEAD_EMAG)
			icon_state = "nonexistenticonstate" //MADNESS

/obj/machinery/door/bulkhead/update_overlays()
	. = ..()

	var/frame_state
	var/light_state
	switch(bulkhead_state)
		if(BULKHEAD_CLOSED)
			frame_state = BULKHEAD_FRAME_CLOSED
			if(locked)
				light_state = BULKHEAD_LIGHT_BOLTS
			else if(emergency)
				light_state = BULKHEAD_LIGHT_EMERGENCY
		if(BULKHEAD_DENY)
			frame_state = BULKHEAD_FRAME_CLOSED
			light_state = BULKHEAD_LIGHT_DENIED
		if(BULKHEAD_EMAG)
			frame_state = BULKHEAD_FRAME_CLOSED
		if(BULKHEAD_CLOSING)
			frame_state = BULKHEAD_FRAME_CLOSING
			light_state = BULKHEAD_LIGHT_CLOSING
		if(BULKHEAD_OPEN)
			frame_state = BULKHEAD_FRAME_OPEN
		if(BULKHEAD_OPENING)
			frame_state = BULKHEAD_FRAME_OPENING
			light_state = BULKHEAD_LIGHT_OPENING

	. += get_airlock_overlay(frame_state, icon, em_block = TRUE)
	if(has_fill_overlays)
		if(glass)
			. += get_airlock_overlay("glass_[frame_state]", glass_fill_overlays, em_block = TRUE)
		else
			. += get_airlock_overlay("fill_[frame_state]", icon, em_block = TRUE)

	if(bulkhead_paint && color_overlays)
		. += get_airlock_overlay(frame_state, color_overlays, color = bulkhead_paint)
		if(!glass && has_fill_overlays)
			. += get_airlock_overlay("fill_[frame_state]", color_overlays, color = bulkhead_paint)

	if(stripe_paint && stripe_overlays)
		. += get_airlock_overlay(frame_state, stripe_overlays, color = stripe_paint)
		if(!glass && has_fill_overlays)
			. += get_airlock_overlay("fill_[frame_state]", stripe_overlays, color = stripe_paint)

	if(lights && hasPower())
		. += get_airlock_overlay("lights_[light_state]", overlays_file, em_block = FALSE)

	if(panel_open)
		. += get_airlock_overlay("panel_[frame_state][security_level ? "_protected" : null]", overlays_file, em_block = TRUE)
	if(frame_state == BULKHEAD_FRAME_CLOSED && welded)
		. += get_airlock_overlay("welded", overlays_file, em_block = TRUE)

	if(bulkhead_state == BULKHEAD_EMAG)
		. += get_airlock_overlay("sparks", overlays_file, em_block = FALSE)

	if(hasPower())
		if(frame_state == BULKHEAD_FRAME_CLOSED)
			if(atom_integrity < integrity_failure * max_integrity)
				. += get_airlock_overlay("sparks_broken", overlays_file, em_block = FALSE)
			else if(atom_integrity < (0.75 * max_integrity))
				. += get_airlock_overlay("sparks_damaged", overlays_file, em_block = FALSE)
		else if(frame_state == BULKHEAD_FRAME_OPEN)
			if(atom_integrity < (0.75 * max_integrity))
				. += get_airlock_overlay("sparks_open", overlays_file, em_block = FALSE)

	if(note)
		. += get_airlock_overlay(get_note_state(frame_state), note_overlay_file, em_block = TRUE)

	if(frame_state == BULKHEAD_FRAME_CLOSED && seal)
		. += get_airlock_overlay("sealed", overlays_file, em_block = TRUE)

	if(hasPower() && unres_sides)
		if(unres_sides & NORTH)
			var/image/I = image(icon='icons/obj/doors/airlocks/unrestricted_overlays.dmi', icon_state="unres_n")
			I.pixel_y = 32
			. += I
		if(unres_sides & SOUTH)
			var/image/I = image(icon='icons/obj/doors/airlocks/unrestricted_overlays.dmi', icon_state="unres_s")
			I.pixel_y = -32
			. += I
		if(unres_sides & EAST)
			var/image/I = image(icon='icons/obj/doors/airlocks/unrestricted_overlays.dmi', icon_state="unres_e")
			I.pixel_x = 32
			. += I
		if(unres_sides & WEST)
			var/image/I = image(icon='icons/obj/doors/airlocks/unrestricted_overlays.dmi', icon_state="unres_w")
			I.pixel_x = -32
			. += I

/obj/machinery/door/bulkhead/do_animate(animation)
	switch(animation)
		if("opening")
			update_icon(ALL, BULKHEAD_OPENING)
		if("closing")
			update_icon(ALL, BULKHEAD_CLOSING)
		if("deny")
			if(!machine_stat)
				update_icon(ALL, BULKHEAD_DENY)
				playsound(src,doorDeni,50,FALSE,3)
				addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, update_icon), ALL, BULKHEAD_CLOSED), BULKHEAD_DENY_ANIMATION_TIME)

/obj/machinery/door/bulkhead/examine(mob/user)
	. = ..()
	if(closeOtherId)
		. += span_warning("This bulkhead cycles on ID: [sanitize(closeOtherId)].")
	else if(!closeOtherId)
		. += span_warning("This bulkhead does not cycle.")
	if(obj_flags & EMAGGED)
		. += span_warning("Its access panel is smoking slightly.")
	if(note)
		if(!in_range(user, src))
			. += "There's a [note.name] pinned to the front. You can't read it from here."
		else
			. += "There's a [note.name] pinned to the front..."
			. += note.examine(user)
			. += span_info("You could [span_bold("cut")] this down.")
	if(seal)
		. += "It's been braced with \a [seal]."
	if(welded)
		. += "It's welded shut."
	if(panel_open)
		switch(security_level)
			if(BULKHEAD_SECURITY_NONE)
				. += "Its wires are exposed!"
			if(BULKHEAD_SECURITY_IRON)
				. += "Its wires are hidden behind a welded iron cover."
			if(BULKHEAD_SECURITY_PLASTEEL_I_S)
				. += "There is some shredded plasteel inside."
			if(BULKHEAD_SECURITY_PLASTEEL_I)
				. += "Its wires are behind an inner layer of plasteel."
			if(BULKHEAD_SECURITY_PLASTEEL_O_S)
				. += "There is some shredded plasteel inside."
			if(BULKHEAD_SECURITY_PLASTEEL_O)
				. += "There is a welded plasteel cover hiding its wires."
			if(BULKHEAD_SECURITY_PLASTEEL)
				. += "There is a protective grille over its panel."
	else if(security_level)
		if(security_level == BULKHEAD_SECURITY_IRON)
			. += "It looks a bit stronger."
		else
			. += "It looks very robust."

	if(issilicon(user) && !(machine_stat & BROKEN))
		. += span_notice("Shift-click [src] to [ density ? "open" : "close"] it.")
		. += span_notice("Ctrl-click [src] to [ locked ? "raise" : "drop"] its bolts.")
		. += span_notice("Alt-click [src] to [ secondsElectrified ? "un-electrify" : "permanently electrify"] it.")
		. += span_notice("Ctrl-Shift-click [src] to [ emergency ? "disable" : "enable"] emergency access.")

/obj/machinery/door/bulkhead/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()

	if(isAI(user) || iscyborg(user))
		if(!(machine_stat & BROKEN))
			var/ui = SStgui.try_update_ui(user, src)
			if(!ui && !held_item)
				context[SCREENTIP_CONTEXT_LMB] = "Open UI"
			context[SCREENTIP_CONTEXT_SHIFT_LMB] = density ? "Open" : "Close"
			context[SCREENTIP_CONTEXT_CTRL_LMB] = locked ? "Unbolt" : "Bolt"
			context[SCREENTIP_CONTEXT_ALT_LMB] = isElectrified() ? "Unelectrify" : "Electrify"
			context[SCREENTIP_CONTEXT_CTRL_SHIFT_LMB] = emergency ? "Unset emergency access" : "Set emergency access"
			. = CONTEXTUAL_SCREENTIP_SET

	if(!isliving(user))
		return .

	if(!Adjacent(user))
		return .

	switch (held_item?.tool_behaviour)
		if (TOOL_SCREWDRIVER)
			context[SCREENTIP_CONTEXT_LMB] = panel_open ? "Close panel" : "Open panel"
			return CONTEXTUAL_SCREENTIP_SET
		if (TOOL_CROWBAR)
			if (panel_open)
				if (security_level == BULKHEAD_SECURITY_PLASTEEL_O_S || security_level == BULKHEAD_SECURITY_PLASTEEL_I_S)
					context[SCREENTIP_CONTEXT_LMB] = "Remove shielding"
					return CONTEXTUAL_SCREENTIP_SET
				else if (should_try_removing_electronics())
					context[SCREENTIP_CONTEXT_LMB] = "Remove electronics"
					return CONTEXTUAL_SCREENTIP_SET

			// Not always contextually true, but is contextually false in ways that make gameplay interesting.
			// For example, trying to pry open an bulkhead, only for the bolts to be down and the lights off.
			context[SCREENTIP_CONTEXT_LMB] = "Pry open"

			return CONTEXTUAL_SCREENTIP_SET
		if (TOOL_WELDER)
			context[SCREENTIP_CONTEXT_RMB] = "Weld shut"

			if (panel_open)
				switch (security_level)
					if (BULKHEAD_SECURITY_IRON, BULKHEAD_SECURITY_PLASTEEL_I, BULKHEAD_SECURITY_PLASTEEL_O)
						context[SCREENTIP_CONTEXT_LMB] = "Cut shielding"
						return CONTEXTUAL_SCREENTIP_SET

			context[SCREENTIP_CONTEXT_LMB] = "Repair"
			return CONTEXTUAL_SCREENTIP_SET
		if (TOOL_WIRECUTTER)
			if(panel_open)
				return

			context[SCREENTIP_CONTEXT_LMB] = "Take down note"
			return CONTEXTUAL_SCREENTIP_SET

/obj/machinery/door/bulkhead/attack_ai(mob/user)
	if(!canAIControl(user))
		if(canAIHack())
			hack(user)
			return
		else
			to_chat(user, span_warning("Bulkhead AI control has been blocked with a firewall. Unable to hack."))
	if(obj_flags & EMAGGED)
		to_chat(user, span_warning("Unable to interface: Bulkhead is unresponsive."))
		return
	if(detonated)
		to_chat(user, span_warning("Unable to interface. Bulkhead control panel damaged."))
		return

	ui_interact(user)

/obj/machinery/door/bulkhead/proc/hack(mob/user)
	set waitfor = 0
	if(!aiHacking)
		aiHacking = TRUE
		to_chat(user, span_warning("Bulkhead AI control has been blocked. Beginning fault-detection."))
		sleep(50)
		if(canAIControl(user))
			to_chat(user, span_notice("Alert cancelled. Bulkhead control has been restored without our assistance."))
			aiHacking = FALSE
			return
		else if(!canAIHack())
			to_chat(user, span_warning("Connection lost! Unable to hack bulkhead."))
			aiHacking = FALSE
			return
		to_chat(user, span_notice("Fault confirmed: bulkhead control wire disabled or cut."))
		sleep(20)
		to_chat(user, span_notice("Attempting to hack into bulkhead. This may take some time."))
		sleep(200)
		if(canAIControl(user))
			to_chat(user, span_notice("Alert cancelled. Bulkhead control has been restored without our assistance."))
			aiHacking = FALSE
			return
		else if(!canAIHack())
			to_chat(user, span_warning("Connection lost! Unable to hack bulkhead."))
			aiHacking = FALSE
			return
		to_chat(user, span_notice("Upload access confirmed. Loading control program into bulkhead software."))
		sleep(170)
		if(canAIControl(user))
			to_chat(user, span_notice("Alert cancelled. Bulkhead control has been restored without our assistance."))
			aiHacking = FALSE
			return
		else if(!canAIHack())
			to_chat(user, span_warning("Connection lost! Unable to hack bulkhead."))
			aiHacking = FALSE
			return
		to_chat(user, span_notice("Transfer complete. Forcing bulkhead to execute program."))
		sleep(50)
		//disable blocked control
		aiControlDisabled = AI_WIRE_HACKED
		to_chat(user, span_notice("Receiving control information from bulkhead."))
		sleep(10)
		//bring up bulkhead dialog
		aiHacking = FALSE
		if(user)
			attack_ai(user)

/obj/machinery/door/bulkhead/attack_animal(mob/user, list/modifiers)
	if(isElectrified() && shock(user, 100))
		return
	return ..()

/obj/machinery/door/bulkhead/attack_paw(mob/user, list/modifiers)
	return attack_hand(user, modifiers)

/obj/machinery/door/bulkhead/proc/on_attack_hand(atom/source, mob/user, list/modifiers)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, /atom/proc/attack_hand, user, modifiers)
	return COMPONENT_CANCEL_ATTACK_CHAIN

/obj/machinery/door/bulkhead/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(!(issilicon(user) || isAdminGhostAI(user)))
		if(isElectrified() && shock(user, 100))
			return

	if(.)
		return

	if(ishuman(user) && prob(40) && density)
		var/mob/living/carbon/human/H = user
		if((HAS_TRAIT(H, TRAIT_DUMB)) && Adjacent(user))
			playsound(src, 'sound/effects/bang.ogg', 25, TRUE)
			if(!istype(H.head, /obj/item/clothing/head/helmet))
				H.visible_message(
					span_danger("[user] headbutts the bulkhead."), \
					span_userdanger("You headbutt the bulkhead!"),
					span_hear("You hear a loud thud.")
				)
				H.Paralyze(100)
				H.apply_damage(10, BRUTE, BODY_ZONE_HEAD)
			else
				visible_message(
					span_danger("[user] headbutts the bulkhead. Good thing [user.p_theyre()] wearing a helmet."),
					span_danger("You slam your head into the bulkhead"),
					span_hear("You hear a loud thud.")
				)

/obj/machinery/door/bulkhead/attempt_wire_interaction(mob/user)
	if(security_level)
		to_chat(user, span_warning("Wires are protected!"))
		return WIRE_INTERACTION_FAIL
	return ..()

/obj/machinery/door/bulkhead/proc/electrified_loop()
	while (secondsElectrified > MACHINE_NOT_ELECTRIFIED)
		sleep(10)
		if(QDELETED(src))
			return

		if(secondsElectrified <= MACHINE_NOT_ELECTRIFIED) //make sure they weren't unelectrified during the sleep.
			break
		secondsElectrified = max(MACHINE_NOT_ELECTRIFIED, secondsElectrified - 1) //safety to make sure we don't end up permanently electrified during a timed electrification.
	// This is to protect against changing to permanent, mid loop.
	if(secondsElectrified == MACHINE_NOT_ELECTRIFIED)
		set_electrified(MACHINE_NOT_ELECTRIFIED)
	else
		set_electrified(MACHINE_ELECTRIFIED_PERMANENT)

/obj/machinery/door/bulkhead/screwdriver_act(mob/living/user, obj/item/tool)
	if(panel_open && detonated)
		to_chat(user, span_warning("[src] has no maintenance panel!"))
		return TOOL_ACT_TOOLTYPE_SUCCESS
	panel_open = !panel_open
	to_chat(user, span_notice("You [panel_open ? "open":"close"] the maintenance panel of the bulkhead."))
	tool.play_tool_sound(src)
	update_appearance()
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/machinery/door/bulkhead/wirecutter_act(mob/living/user, obj/item/tool)
	if(panel_open && security_level == BULKHEAD_SECURITY_PLASTEEL)
		. = TOOL_ACT_TOOLTYPE_SUCCESS  // everything after this shouldn't result in attackby
		if(hasPower() && shock(user, 60)) // Protective grille of wiring is electrified
			return .
		to_chat(user, span_notice("You start cutting through the outer grille."))
		if(!tool.use_tool(src, user, 10, volume=100))
			return .
		if(!panel_open)  // double check it wasn't closed while we were trying to snip
			return .
		user.visible_message(
			span_notice("[user] cut through [src]'s outer grille."),
			span_notice("You cut through [src]'s outer grille."),
			span_hear("You hear thin metal being cut.")
		)
		security_level = BULKHEAD_SECURITY_PLASTEEL_O
		return .
	if(note)
		if(user.CanReach(src))
			user.visible_message(span_notice("[user] cuts down [note] from [src]."), span_notice("You remove [note] from [src]."))
		else //telekinesis
			visible_message(span_notice("[tool] cuts down [note] from [src]."))
		tool.play_tool_sound(src)
		note.forceMove(tool.drop_location())
		note = null
		update_appearance()
		return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/machinery/door/bulkhead/crowbar_act(mob/living/user, obj/item/tool)

	if(!panel_open || security_level == BULKHEAD_SECURITY_NONE)
		return ..()

	var/layer_flavor
	var/next_level
	var/starting_level = security_level

	switch(security_level)
		if(BULKHEAD_SECURITY_PLASTEEL_O_S)
			layer_flavor = "outer layer of shielding"
			next_level = BULKHEAD_SECURITY_PLASTEEL_I

		if(BULKHEAD_SECURITY_PLASTEEL_I_S)
			layer_flavor = "inner layer of shielding"
			next_level = BULKHEAD_SECURITY_NONE
		else
			return TOOL_ACT_TOOLTYPE_SUCCESS

	user.visible_message(span_notice("You start prying away [src]'s [layer_flavor]."))
	if(!tool.use_tool(src, user, 40, volume=100))
		return TOOL_ACT_TOOLTYPE_SUCCESS
	if(!panel_open || security_level != starting_level)
		// if the plating's already been broken, don't break it again
		return TOOL_ACT_TOOLTYPE_SUCCESS
	user.visible_message(
		span_notice("[user] removes [src]'s shielding."),
		span_notice("You remove [src]'s [layer_flavor]."),
		span_hear("You hear metal being pryed up.")
	)
	security_level = next_level
	spawn_atom_to_turf(/obj/item/stack/sheet/plasteel, user.loc, 1)
	if(next_level == BULKHEAD_SECURITY_NONE)
		modify_max_integrity(max_integrity / BULKHEAD_INTEGRITY_MULTIPLIER)
		damage_deflection = BULKHEAD_DAMAGE_DEFLECTION_N
		update_appearance()
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/machinery/door/bulkhead/welder_act(mob/living/user, obj/item/tool)

	if(!panel_open || security_level == BULKHEAD_SECURITY_NONE)
		return ..()

	var/layer_flavor
	var/next_level
	var/starting_level = security_level

	var/material_to_spawn
	var/amount_to_spawn

	switch(security_level)
		if(BULKHEAD_SECURITY_IRON)
			layer_flavor = "panel's shielding"
			next_level = BULKHEAD_SECURITY_NONE
			material_to_spawn = /obj/item/stack/sheet/iron
			amount_to_spawn = 2
		if(BULKHEAD_SECURITY_PLASTEEL_O)
			layer_flavor = "outer layer of shielding"
			next_level = BULKHEAD_SECURITY_PLASTEEL_O_S
		if(BULKHEAD_SECURITY_PLASTEEL_I)
			layer_flavor = "inner layer of shielding"
			next_level = BULKHEAD_SECURITY_PLASTEEL_I_S
		else
			return TOOL_ACT_TOOLTYPE_SUCCESS

	if(!tool.tool_start_check(user, amount=2))
		return TOOL_ACT_TOOLTYPE_SUCCESS

	to_chat(user, span_notice("You begin cutting the [layer_flavor]..."))

	if(!tool.use_tool(src, user, 4 SECONDS, volume=50, amount=2))
		return TOOL_ACT_TOOLTYPE_SUCCESS

	if(!panel_open || security_level != starting_level)
		// see if anyone's screwing with us
		return TOOL_ACT_TOOLTYPE_SUCCESS

	user.visible_message(
		span_notice("[user] cuts through [src]'s shielding."),  // passers-by don't get the full picture
		span_notice("You cut through [src]'s [layer_flavor]."),
		span_hear("You hear welding.")
	)

	security_level = next_level

	if(material_to_spawn)
		spawn_atom_to_turf(material_to_spawn, user.loc, amount_to_spawn)

	if(security_level == BULKHEAD_SECURITY_NONE)
		update_appearance()

	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/machinery/door/bulkhead/proc/try_reinforce(mob/user, obj/item/stack/sheet/material, amt_required, new_security_level)
	if(material.get_amount() < amt_required)
		to_chat(user, span_warning("You need at least [amt_required] sheets of [material] to reinforce [src]."))
		return FALSE
	to_chat(user, span_notice("You start reinforcing [src]."))
	if(!do_after(user, 2 SECONDS, src))
		return FALSE
	if(!panel_open || !material.use(amt_required))
		return FALSE
	user.visible_message(
		span_notice("[user] reinforces [src] with [material]."),
		span_notice("You reinforce [src] with [material]."),
		span_hear("You hear metal clang together.")
	)
	security_level = new_security_level
	update_appearance()
	return TRUE

/obj/machinery/door/bulkhead/attackby(obj/item/C, mob/user, params)
	if(!issilicon(user) && !isAdminGhostAI(user))
		if(isElectrified() && shock(user, 75))
			return
	add_fingerprint(user)

	if(is_wire_tool(C) && panel_open)
		attempt_wire_interaction(user)
		return
	else if(panel_open && security_level == BULKHEAD_SECURITY_NONE && istype(C, /obj/item/stack/sheet))
		if(istype(C, /obj/item/stack/sheet/iron))
			return try_reinforce(user, C, 2, BULKHEAD_SECURITY_IRON)

		else if(istype(C, /obj/item/stack/sheet/plasteel))
			if(!try_reinforce(user, C, 2, BULKHEAD_SECURITY_PLASTEEL))
				return FALSE
			modify_max_integrity(max_integrity * BULKHEAD_INTEGRITY_MULTIPLIER)
			damage_deflection = BULKHEAD_DAMAGE_DEFLECTION_R
			update_appearance()
			return TRUE

	else if(istype(C, /obj/item/pai_cable))
		var/obj/item/pai_cable/cable = C
		cable.plugin(src, user)
	else if(istype(C, /obj/item/bulkhead_painter))
		change_paintjob(C, user)
	else if(istype(C, /obj/item/door_seal)) //adding the seal
		var/obj/item/door_seal/airlockseal = C
		if(!density)
			to_chat(user, span_warning("[src] must be closed before you can seal it!"))
			return
		if(seal)
			to_chat(user, span_warning("[src] has already been sealed!"))
			return
		user.visible_message(span_notice("[user] begins sealing [src]."), span_notice("You begin sealing [src]."))
		playsound(src, 'sound/items/jaws_pry.ogg', 30, TRUE)
		if(!do_after(user, airlockseal.seal_time, target = src))
			return
		if(!density)
			to_chat(user, span_warning("[src] must be closed before you can seal it!"))
			return
		if(seal)
			to_chat(user, span_warning("[src] has already been sealed!"))
			return
		if(!user.transferItemToLoc(airlockseal, src))
			to_chat(user, span_warning("For some reason, you can't attach [airlockseal]!"))
			return
		playsound(src, forcedClosed, 60, TRUE)
		user.visible_message(span_notice("[user] finishes sealing [src]."), span_notice("You finish sealing [src]."))
		seal = airlockseal
		modify_max_integrity(max_integrity * BULKHEAD_SEAL_MULTIPLIER)
		update_appearance()

	else if(istype(C, /obj/item/paper) || istype(C, /obj/item/photo))
		if(note)
			to_chat(user, span_warning("There's already something pinned to this bulkhead! Use wirecutters to remove it."))
			return
		if(!user.transferItemToLoc(C, src))
			to_chat(user, span_warning("For some reason, you can't attach [C]!"))
			return
		user.visible_message(span_notice("[user] pins [C] to [src]."), span_notice("You pin [C] to [src]."), span_hear("You hear a metallic thud."))
		note = C
		update_appearance()
	else
		return ..()


/obj/machinery/door/bulkhead/try_to_weld(obj/item/weldingtool/W, mob/living/user)
	if(!operating && density)
		if(seal)
			to_chat(user, span_warning("[src] is blocked by a seal!"))
			return

		if(atom_integrity < max_integrity)
			if(!W.tool_start_check(user, amount=0))
				return
			user.visible_message(span_notice("[user] begins welding the bulkhead."), \
							span_notice("You begin repairing the bulkhead..."), \
							span_hear("You hear a welding torch fusing metal."))
			if(W.use_tool(src, user, 40, volume=50, extra_checks = CALLBACK(src, PROC_REF(weld_checks), W, user)))
				atom_integrity = max_integrity
				set_machine_stat(machine_stat & ~BROKEN)
				user.visible_message(span_notice("[user] finishes welding [src]."), \
									span_notice("You finish repairing the bulkhead."))
				update_appearance()
		else
			to_chat(user, span_notice("The bulkhead doesn't need repairing."))

/obj/machinery/door/bulkhead/try_to_weld_secondary(obj/item/weldingtool/tool, mob/user)
	if(!tool.tool_start_check(user, amount=0))
		return
	user.visible_message(span_notice("[user] begins [welded ? "unwelding":"welding"] the bulkhead."), \
		span_notice("You begin [welded ? "unwelding":"welding"] the bulkhead..."), \
		span_hear("You hear welding."))
	if(!tool.use_tool(src, user, 40, volume=50, extra_checks = CALLBACK(src, PROC_REF(weld_checks), tool, user)))
		return
	welded = !welded
	user.visible_message(span_notice("[user] [welded? "welds shut":"unwelds"] [src]."), \
		span_notice("You [welded ? "weld the bulkhead shut":"unweld the bulkhead"]."), \
		span_hear("You hear metal a welding torch splitting metal."))
	user.log_message("[welded ? "welded":"unwelded"] bulkhead [src] with [tool].", LOG_GAME)
	update_appearance()

/obj/machinery/door/bulkhead/proc/weld_checks(obj/item/weldingtool/W, mob/user)
	return !operating && density

/**
 * Used when attempting to remove a seal from an bulkhead
 *
 * Called when attacking an bulkhead with an empty hand, returns TRUE (there was a seal and we removed it, or failed to remove it)
 * or FALSE (there was no seal)
 * Arguments:
 * * user - Whoever is attempting to remove the seal
 */
/obj/machinery/door/bulkhead/try_remove_seal(mob/living/user)
	if(!seal)
		return FALSE
	var/obj/item/door_seal/airlockseal = seal
	if(!ishuman(user))
		to_chat(user, span_warning("You don't have the dexterity to remove the seal!"))
		return TRUE
	user.visible_message(span_notice("[user] begins removing the seal from [src]."), span_notice("You begin removing [src]'s pneumatic seal."))
	playsound(src, forcedClosed, 60, TRUE)
	if(!do_after(user, airlockseal.unseal_time, target = src))
		return TRUE
	if(!seal)
		return TRUE
	playsound(src, 'sound/items/jaws_pry.ogg', 30, TRUE)
	airlockseal.forceMove(get_turf(user))
	user.visible_message(span_notice("[user] finishes removing the seal from [src]."), span_notice("You finish removing [src]'s pneumatic seal."))
	seal = null
	modify_max_integrity(max_integrity / BULKHEAD_SEAL_MULTIPLIER)
	update_appearance()
	return TRUE

/// Returns if a crowbar would remove the bulkhead electronics
/obj/machinery/door/bulkhead/proc/should_try_removing_electronics()
	if (security_level != 0)
		return FALSE

	if (!panel_open)
		return FALSE

	if (obj_flags & EMAGGED)
		return TRUE

	if (!density)
		return FALSE

	if (!welded)
		return FALSE

	if (hasPower())
		return FALSE

	if (locked)
		return FALSE

	return TRUE

/obj/machinery/door/bulkhead/try_to_crowbar(obj/item/I, mob/living/user, forced = FALSE)
	if(I?.tool_behaviour == TOOL_CROWBAR && should_try_removing_electronics() && !operating)
		user.visible_message(span_notice("[user] removes the electronics from the bulkhead assembly."), \
			span_notice("You start to remove electronics from the bulkhead assembly..."))
		if(I.use_tool(src, user, 40, volume=100))
			deconstruct(TRUE, user)
			return
	if(seal)
		to_chat(user, span_warning("Remove the seal first!"))
		return
	if(locked)
		to_chat(user, span_warning("The bulkhead's bolts prevent it from being forced!"))
		return
	if(welded)
		to_chat(user, span_warning("It's welded, it won't budge!"))
		return
	if(hasPower())
		if(forced)
			var/check_electrified = isElectrified() //setting this so we can check if the mob got shocked during the do_after below
			if(check_electrified && shock(user,100))
				return //it's like sticking a fork in a power socket

			if(!density)//already open
				return

			if(!prying_so_hard)
				var/time_to_open = 50
				playsound(src, 'sound/machines/door/airlock_alien_prying.ogg', 100, TRUE) //is it aliens or just the CE being a dick?
				prying_so_hard = TRUE
				if(do_after(user, time_to_open, src))
					if(check_electrified && shock(user,100))
						prying_so_hard = FALSE
						return
					open(2)
					take_damage(25, BRUTE, 0, 0) // Enough to sometimes spark
					if(density && !open(2))
						to_chat(user, span_warning("Despite your attempts, [src] refuses to open."))
				prying_so_hard = FALSE
				return
		to_chat(user, span_warning("The bulkhead's motors resist your efforts to force it!"))
		return

	if(!operating)
		if(istype(I, /obj/item/fireaxe) && !HAS_TRAIT(I, TRAIT_WIELDED)) //being fireaxe'd
			to_chat(user, span_warning("You need to be wielding [I] to do that!"))
			return
		INVOKE_ASYNC(src, density ? PROC_REF(open) : PROC_REF(close), 2)

/obj/machinery/door/bulkhead/open(forced=0)
	if( operating || welded || locked || seal )
		return FALSE
	if(!forced)
		if(!hasPower() || wires.is_cut(WIRE_OPEN))
			return FALSE
	if(forced < 2)
		if(obj_flags & EMAGGED)
			return FALSE
		use_power(50)
		playsound(src, doorOpen, 60, TRUE)
	else
		playsound(src, forcedOpen, 60, TRUE)

	if(autoclose)
		autoclose_in(normalspeed ? 8 SECONDS : 1.5 SECONDS)

	if(!density)
		return TRUE

	if(closeOther != null && istype(closeOther, /obj/machinery/door/bulkhead))
		addtimer(CALLBACK(closeOther, PROC_REF(close)), 2)

	if(close_others)
		for(var/obj/machinery/door/bulkhead/otherlock as anything in close_others)
			if(!shuttledocked && !emergency && !otherlock.shuttledocked && !otherlock.emergency)
				if(otherlock.operating)
					otherlock.delayed_close_requested = TRUE
				else
					addtimer(CALLBACK(otherlock, PROC_REF(close)), 2)

	if(cyclelinkedbulkhead)
		if(!shuttledocked && !emergency && !cyclelinkedbulkhead.shuttledocked && !cyclelinkedbulkhead.emergency)
			if(cyclelinkedbulkhead.operating)
				cyclelinkedbulkhead.delayed_close_requested = TRUE
			else
				addtimer(CALLBACK(cyclelinkedbulkhead, PROC_REF(close)), 2)

	SEND_SIGNAL(src, COMSIG_BULKHEAD_OPEN, forced)
	operating = TRUE
	update_icon(ALL, BULKHEAD_OPENING, TRUE)
	sleep(1)
	set_opacity(0)
	update_freelook_sight()
	sleep(6)
	set_density(FALSE)
	flags_1 &= ~PREVENT_CLICK_UNDER_1
	zas_update_loc()
	sleep(8)
	layer = OPEN_DOOR_LAYER
	update_icon(ALL, BULKHEAD_OPEN, TRUE)
	operating = FALSE
	if(delayed_close_requested)
		delayed_close_requested = FALSE
		addtimer(CALLBACK(src, PROC_REF(close)), 1)
	return TRUE


/obj/machinery/door/bulkhead/close(forced = FALSE, force_crush = FALSE)
	if(operating || welded || locked || seal)
		return
	if(density)
		return TRUE
	if(!forced)
		if(!hasPower() || wires.is_cut(WIRE_BOLTS))
			return

	var/dangerous_close = !safe || force_crush
	if(!dangerous_close)
		for(var/atom/movable/M in get_turf(src))
			if(M.density && M != src) //something is blocking the door
				autoclose_in(DOOR_CLOSE_WAIT)
				return
	if(forced < 2)
		if(obj_flags & EMAGGED)
			return
		use_power(50)
		playsound(src, doorClose, 60, TRUE)

	else
		playsound(src, forcedClosed, 60, TRUE)

	var/obj/structure/window/killthis = (locate(/obj/structure/window) in get_turf(src))
	if(killthis)
		SSexplosions.med_mov_atom += killthis
	SEND_SIGNAL(src, COMSIG_BULKHEAD_CLOSE, forced)
	operating = TRUE
	update_icon(ALL, BULKHEAD_CLOSING, 1)
	layer = CLOSED_DOOR_LAYER
	if(air_tight)
		set_density(TRUE)
		flags_1 |= PREVENT_CLICK_UNDER_1
		zas_update_loc()
	sleep(6)
	if(!air_tight)
		set_density(TRUE)
		flags_1 |= PREVENT_CLICK_UNDER_1
		zas_update_loc()
	sleep(8)
	if(dangerous_close)
		crush()
	if(visible && !glass)
		set_opacity(1)
	update_freelook_sight()
	sleep(1)
	update_icon(ALL, BULKHEAD_CLOSED, 1)
	operating = FALSE
	delayed_close_requested = FALSE
	if(!dangerous_close)
		CheckForMobs()
	return TRUE

/obj/machinery/door/bulkhead/proc/prison_open()
	if(obj_flags & EMAGGED)
		return
	locked = FALSE
	open()
	locked = TRUE
	return

// gets called when a player uses an bulkhead painter on this bulkhead
/obj/machinery/door/bulkhead/proc/change_paintjob(obj/item/bulkhead_painter/painter, mob/user)
	if((!in_range(src, user) && loc != user) || !painter.can_use(user)) // user should be adjacent to the bulkhead, and the painter should have a toner cartridge that isn't empty
		return

	// reads from the bulkhead painter's `available paintjob` list. lets the player choose a paint option, or cancel painting
	var/current_paintjob = tgui_input_list(user, "Paintjob for this bulkhead", "Customize", sort_list(painter.available_paint_jobs))
	if(isnull(current_paintjob)) // if the user clicked cancel on the popup, return
		return

	var/airlock_type = painter.available_paint_jobs["[current_paintjob]"] // get the bulkhead type path associated with the bulkhead name the user just chose
	var/obj/machinery/door/bulkhead/bulkhead = airlock_type // we need to create a new instance of the bulkhead and assembly to read vars from them
	var/obj/structure/door_assembly/assembly = initial(bulkhead.assemblytype)

	if(glass && initial(assembly.noglass)) // prevents painting glass airlocks with a paint job that doesn't have a glass version, such as the freezer
		to_chat(user, span_warning("This paint job can only be applied to non-glass airlocks."))
		return

	// applies the user-chosen bulkhead's icon, overlays and assemblytype to the src bulkhead
	painter.use_paint(user)
	icon = initial(bulkhead.icon)
	stripe_overlays = initial(bulkhead.stripe_overlays)
	color_overlays = initial(bulkhead.color_overlays)
	glass_fill_overlays = initial(bulkhead.glass_fill_overlays)
	overlays_file = initial(bulkhead.overlays_file)
	note_overlay_file = initial(bulkhead.note_overlay_file)
	bulkhead_paint = initial(bulkhead.bulkhead_paint)
	stripe_paint = initial(bulkhead.stripe_paint)
	assemblytype = initial(bulkhead.assemblytype)
	update_appearance()

/obj/machinery/door/bulkhead/CanAStarPass(obj/item/card/id/ID, to_dir, atom/movable/caller, no_id = FALSE)
	//Bulkhead is passable if it is open (!density), bot has access, and is not bolted shut or powered off)
	return !density || (check_access(ID) && !locked && hasPower() && !no_id)

/obj/machinery/door/bulkhead/emag_act(mob/user, obj/item/card/emag/doorjack/D)
	if(!operating && density && hasPower() && !(obj_flags & EMAGGED))
		if(istype(D, /obj/item/card/emag/doorjack))
			D.use_charge(user)
		operating = TRUE
		update_icon(ALL, BULKHEAD_EMAG, 1)
		sleep(6)
		if(QDELETED(src))
			return
		operating = FALSE
		if(!open())
			update_icon(ALL, BULKHEAD_CLOSED, 1)
		obj_flags |= EMAGGED
		lights = FALSE
		locked = TRUE
		loseMainPower()
		loseBackupPower()

/obj/machinery/door/bulkhead/attack_alien(mob/living/carbon/alien/adult/user, list/modifiers)
	if(isElectrified() && shock(user, 100)) //Mmm, fried xeno!
		add_fingerprint(user)
		return
	if(!density) //Already open
		return ..()
	if(locked || welded || seal) //Extremely generic, as aliens only understand the basics of how airlocks work.
		if(user.combat_mode)
			return ..()
		to_chat(user, span_warning("[src] refuses to budge!"))
		return
	add_fingerprint(user)
	user.visible_message(span_warning("[user] begins prying open [src]."),\
						span_noticealien("You begin digging your claws into [src] with all your might!"),\
						span_warning("You hear groaning metal..."))
	var/time_to_open = 5 //half a second
	if(hasPower())
		time_to_open = 5 SECONDS //Powered airlocks take longer to open, and are loud.
		playsound(src, 'sound/machines/door/airlock_alien_prying.ogg', 100, TRUE)


	if(do_after(user, time_to_open, src))
		if(density && !open(2)) //The bulkhead is still closed, but something prevented it opening. (Another player noticed and bolted/welded the bulkhead in time!)
			to_chat(user, span_warning("Despite your efforts, [src] managed to resist your attempts to open it!"))

/obj/machinery/door/bulkhead/hostile_lockdown(mob/origin)
	// Must be powered and have working AI wire.
	if(canAIControl(src) && !machine_stat)
		locked = FALSE //For airlocks that were bolted open.
		safe = FALSE //DOOR CRUSH
		close()
		bolt() //Bolt it!
		set_electrified(MACHINE_ELECTRIFIED_PERMANENT)  //Shock it!
		if(origin)
			LAZYADD(shockedby, "\[[time_stamp()]\] [key_name(origin)]")


/obj/machinery/door/bulkhead/disable_lockdown()
	// Must be powered and have working AI wire.
	if(canAIControl(src) && !machine_stat)
		unbolt()
		set_electrified(MACHINE_NOT_ELECTRIFIED)
		open()
		safe = TRUE


/obj/machinery/door/bulkhead/proc/on_break()
	SIGNAL_HANDLER

	if(!panel_open)
		panel_open = TRUE
	wires.cut_all()

/obj/machinery/door/bulkhead/emp_act(severity)
	. = ..()
	if (. & EMP_PROTECT_SELF)
		return
	if(prob(severity*10 - 20) && (secondsElectrified < 30) && (secondsElectrified != MACHINE_ELECTRIFIED_PERMANENT))
		set_electrified(30)
		LAZYADD(shockedby, "\[[time_stamp()]\]EM Pulse")

/obj/machinery/door/bulkhead/proc/set_electrified(seconds, mob/user)
	secondsElectrified = seconds
	diag_hud_set_electrified()
	if(secondsElectrified > MACHINE_NOT_ELECTRIFIED)
		INVOKE_ASYNC(src, PROC_REF(electrified_loop))

	if(user)
		var/message
		switch(secondsElectrified)
			if(MACHINE_ELECTRIFIED_PERMANENT)
				message = "permanently shocked"
			if(MACHINE_NOT_ELECTRIFIED)
				message = "unshocked"
			else
				message = "temp shocked for [secondsElectrified] seconds"
		LAZYADD(shockedby, text("\[[time_stamp()]\] [key_name(user)] - ([uppertext(message)])"))
		log_combat(user, src, message)
		add_hiddenprint(user)

/obj/machinery/door/bulkhead/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	if((damage_amount >= atom_integrity) && (damage_flag == BOMB))
		flags_1 |= NODECONSTRUCT_1  //If an explosive took us out, don't drop the assembly
	. = ..()
	if(atom_integrity < (0.75 * max_integrity))
		update_appearance()

/obj/machinery/door/bulkhead/proc/prepare_deconstruction_assembly(obj/structure/door_assembly/assembly)
	assembly.heat_proof_finished = heat_proof //tracks whether there's rglass in
	assembly.set_anchored(TRUE)
	assembly.glass = glass
	assembly.state = BULKHEAD_ASSEMBLY_NEEDS_ELECTRONICS
	assembly.created_name = name
	assembly.previous_assembly = previous_airlock
	assembly.update_name()
	assembly.update_appearance()

/obj/machinery/door/bulkhead/deconstruct(disassembled = TRUE, mob/user)
	if(!(flags_1 & NODECONSTRUCT_1))
		var/obj/structure/door_assembly/A
		if(assemblytype)
			A = new assemblytype(loc)
		else
			A = new /obj/structure/door_assembly(loc)
			//If you come across a null assemblytype, it will produce the default assembly instead of disintegrating.
		prepare_deconstruction_assembly(A)

		if(!disassembled)
			A?.update_integrity(A.max_integrity * 0.5)
		else if(obj_flags & EMAGGED)
			if(user)
				to_chat(user, span_warning("You discard the damaged electronics."))
		else
			if(user)
				to_chat(user, span_notice("You remove the bulkhead electronics."))

			var/obj/item/electronics/bulkhead/ae
			if(!electronics)
				ae = new/obj/item/electronics/bulkhead(loc)
				gen_access()
				if(length(req_one_access))
					ae.one_access = 1
					ae.accesses = req_one_access
				else
					ae.accesses = req_access
			else
				ae = electronics
				electronics = null
				ae.forceMove(drop_location())
	qdel(src)

/obj/machinery/door/bulkhead/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	switch(the_rcd.mode)
		if(RCD_DECONSTRUCT)
			if(seal)
				to_chat(user, span_notice("[src]'s seal needs to be removed first."))
				return FALSE
			if(security_level != BULKHEAD_SECURITY_NONE)
				to_chat(user, span_notice("[src]'s reinforcement needs to be removed first."))
				return FALSE
			return list("mode" = RCD_DECONSTRUCT, "delay" = 50, "cost" = 32)
	return FALSE

/obj/machinery/door/bulkhead/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, passed_mode)
	switch(passed_mode)
		if(RCD_DECONSTRUCT)
			to_chat(user, span_notice("You deconstruct the bulkhead."))
			qdel(src)
			return TRUE
	return FALSE

/**
 * Returns a string representing the type of note pinned to this bulkhead
 * Arguments:
 * * frame_state - The BULKHEAD_FRAME_ value, as used in update_overlays()
 **/
/obj/machinery/door/bulkhead/proc/get_note_state(frame_state)
	if(!note)
		return
	else if(istype(note, /obj/item/paper))
		return "note_[frame_state]"

	else if(istype(note, /obj/item/photo))
		return "photo_[frame_state]"

/obj/machinery/door/bulkhead/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AiBulkhead", name)
		ui.open()
	return TRUE

/obj/machinery/door/bulkhead/ui_data()
	var/list/data = list()

	var/list/power = list()
	power["main"] = secondsMainPowerLost ? 0 : 2 // boolean
	power["main_timeleft"] = secondsMainPowerLost
	power["backup"] = secondsBackupPowerLost ? 0 : 2 // boolean
	power["backup_timeleft"] = secondsBackupPowerLost
	data["power"] = power

	data["shock"] = secondsElectrified == MACHINE_NOT_ELECTRIFIED ? 2 : 0
	data["shock_timeleft"] = secondsElectrified
	data["id_scanner"] = !aiDisabledIdScanner
	data["emergency"] = emergency // access
	data["locked"] = locked // bolted
	data["lights"] = lights // bolt lights
	data["safe"] = safe // safeties
	data["speed"] = normalspeed // safe speed
	data["welded"] = welded // welded
	data["opened"] = !density // opened

	var/list/wire = list()
	wire["main_1"] = !wires.is_cut(WIRE_POWER1)
	wire["main_2"] = !wires.is_cut(WIRE_POWER2)
	wire["backup_1"] = !wires.is_cut(WIRE_BACKUP1)
	wire["backup_2"] = !wires.is_cut(WIRE_BACKUP2)
	wire["shock"] = !wires.is_cut(WIRE_SHOCK)
	wire["id_scanner"] = !wires.is_cut(WIRE_IDSCAN)
	wire["bolts"] = !wires.is_cut(WIRE_BOLTS)
	wire["lights"] = !wires.is_cut(WIRE_LIGHT)
	wire["safe"] = !wires.is_cut(WIRE_SAFETY)
	wire["timing"] = !wires.is_cut(WIRE_TIMING)

	data["wires"] = wire
	return data

/obj/machinery/door/bulkhead/ui_act(action, params)
	. = ..()
	if(.)
		return

	if(!user_allowed(usr))
		return
	switch(action)
		if("disrupt-main")
			if(!secondsMainPowerLost)
				loseMainPower()
				update_appearance()
			else
				to_chat(usr, span_warning("Main power is already offline."))
			. = TRUE
		if("disrupt-backup")
			if(!secondsBackupPowerLost)
				loseBackupPower()
				update_appearance()
			else
				to_chat(usr, span_warning("Backup power is already offline."))
			. = TRUE
		if("shock-restore")
			shock_restore(usr)
			. = TRUE
		if("shock-temp")
			shock_temp(usr)
			. = TRUE
		if("shock-perm")
			shock_perm(usr)
			. = TRUE
		if("idscan-toggle")
			aiDisabledIdScanner = !aiDisabledIdScanner
			. = TRUE
		if("emergency-toggle")
			toggle_emergency(usr)
			. = TRUE
		if("bolt-toggle")
			toggle_bolt(usr)
			. = TRUE
		if("light-toggle")
			lights = !lights
			update_appearance()
			. = TRUE
		if("safe-toggle")
			safe = !safe
			. = TRUE
		if("speed-toggle")
			normalspeed = !normalspeed
			. = TRUE
		if("open-close")
			user_toggle_open(usr)
			. = TRUE

/obj/machinery/door/bulkhead/proc/user_allowed(mob/user)
	return (issilicon(user) && canAIControl(user)) || isAdminGhostAI(user)

/obj/machinery/door/bulkhead/proc/shock_restore(mob/user)
	if(!user_allowed(user))
		return
	if(wires.is_cut(WIRE_SHOCK))
		to_chat(user, span_warning("Can't un-electrify the bulkhead - The electrification wire is cut."))
	else if(isElectrified())
		set_electrified(MACHINE_NOT_ELECTRIFIED, user)

/obj/machinery/door/bulkhead/proc/shock_temp(mob/user)
	if(!user_allowed(user))
		return
	if(wires.is_cut(WIRE_SHOCK))
		to_chat(user, span_warning("The electrification wire has been cut."))
	else
		set_electrified(MACHINE_DEFAULT_ELECTRIFY_TIME, user)

/obj/machinery/door/bulkhead/proc/shock_perm(mob/user)
	if(!user_allowed(user))
		return
	if(wires.is_cut(WIRE_SHOCK))
		to_chat(user, span_warning("The electrification wire has been cut."))
	else
		set_electrified(MACHINE_ELECTRIFIED_PERMANENT, user)

/obj/machinery/door/bulkhead/proc/toggle_bolt(mob/user)
	if(!user_allowed(user))
		return
	if(wires.is_cut(WIRE_BOLTS))
		to_chat(user, span_warning("The door bolt drop wire is cut - you can't toggle the door bolts."))
		return
	if(locked)
		if(!hasPower())
			to_chat(user, span_warning("The door has no power - you can't raise the door bolts."))
		else
			unbolt()
			log_combat(user, src, "unbolted")
	else
		bolt()
		log_combat(user, src, "bolted")

/obj/machinery/door/bulkhead/proc/toggle_emergency(mob/user)
	if(!user_allowed(user))
		return
	emergency = !emergency
	update_appearance()

/obj/machinery/door/bulkhead/proc/user_toggle_open(mob/user)
	if(!user_allowed(user))
		return
	if(welded)
		to_chat(user, span_warning("The bulkhead has been welded shut!"))
	else if(locked)
		to_chat(user, span_warning("The door bolts are down!"))
	else if(!density)
		close()
	else
		open()

/**
 * Generates the bulkhead's wire layout based on the current area the bulkhead resides in.
 *
 * Returns a new /datum/wires/ with the appropriate wire layout based on the airlock_wires
 * of the area the bulkhead is in.
 */
/obj/machinery/door/bulkhead/proc/set_wires()
	var/area/source_area = get_area(src)
	return source_area?.airlock_wires ? new source_area.airlock_wires(src) : new /datum/wires/bulkhead(src)

#undef BULKHEAD_CLOSED
#undef BULKHEAD_CLOSING
#undef BULKHEAD_OPEN
#undef BULKHEAD_OPENING
#undef BULKHEAD_DENY
#undef BULKHEAD_EMAG

#undef BULKHEAD_SECURITY_NONE
#undef BULKHEAD_SECURITY_IRON
#undef BULKHEAD_SECURITY_PLASTEEL_I_S
#undef BULKHEAD_SECURITY_PLASTEEL_I
#undef BULKHEAD_SECURITY_PLASTEEL_O_S
#undef BULKHEAD_SECURITY_PLASTEEL_O
#undef BULKHEAD_SECURITY_PLASTEEL

#undef BULKHEAD_INTEGRITY_N
#undef BULKHEAD_INTEGRITY_MULTIPLIER
#undef BULKHEAD_SEAL_MULTIPLIER
#undef BULKHEAD_DAMAGE_DEFLECTION_N
#undef BULKHEAD_DAMAGE_DEFLECTION_R

#undef BULKHEAD_DENY_ANIMATION_TIME

#undef DOOR_CLOSE_WAIT

#undef DOOR_VISION_DISTANCE

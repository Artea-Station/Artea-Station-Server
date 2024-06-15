/obj/effect/decal/cleanable/blood/hitsplatter
	name = "blood splatter"
	icon_state = "hitsplatter1"
	random_icon_states = list("hitsplatter1", "hitsplatter2", "hitsplatter3")
	pass_flags = PASSTABLE | PASSGRILLE
	/// The turf we just came from, so we can back up when we hit a wall
	var/turf/prev_loc
	/// Skip making the final blood splatter when we're done, like if we're not in a turf
	var/skip = FALSE
	/// How many tiles/items/people we can paint red
	var/splatter_strength = 3
	/// Insurance so that we don't keep moving once we hit a stoppoint
	var/hit_endpoint = FALSE
	/// Type of squirt decals we should try to create when moving
	var/squirt_type = /obj/effect/decal/cleanable/blood/squirt

/obj/effect/decal/cleanable/blood/hitsplatter/Initialize(mapload, splatter_strength)
	. = ..()
	prev_loc = loc //Just so we are sure prev_loc exists
	if(splatter_strength)
		src.splatter_strength = splatter_strength

/obj/effect/decal/cleanable/blood/hitsplatter/Destroy()
	if(isturf(loc) && !skip)
		playsound(src, 'sound/effects/wounds/splatter.ogg', 60, TRUE, -1)
	return ..()

/// Set the splatter up to fly through the air until it rounds out of steam or hits something
/obj/effect/decal/cleanable/blood/hitsplatter/proc/fly_towards(turf/target_turf, range)
	var/delay = 2
	var/datum/move_loop/loop = SSmove_manager.move_towards(src, target_turf, delay, timeout = delay * range, priority = MOVEMENT_ABOVE_SPACE_PRIORITY, flags = MOVEMENT_LOOP_START_FAST)
	RegisterSignal(loop, COMSIG_MOVELOOP_PREPROCESS_CHECK, PROC_REF(pre_move))
	RegisterSignal(loop, COMSIG_MOVELOOP_POSTPROCESS, PROC_REF(post_move))
	RegisterSignal(loop, COMSIG_PARENT_QDELETING, PROC_REF(loop_done))

/obj/effect/decal/cleanable/blood/hitsplatter/proc/pre_move(datum/move_loop/source)
	SIGNAL_HANDLER
	prev_loc = loc

/obj/effect/decal/cleanable/blood/hitsplatter/proc/post_move(datum/move_loop/source)
	SIGNAL_HANDLER
	var/list/blood_dna_info = GET_ATOM_BLOOD_DNA(src)
	for(var/atom/iter_atom in get_turf(src))
		if(hit_endpoint)
			return
		if(splatter_strength <= 0)
			break

		if(isitem(iter_atom))
			iter_atom.add_blood_DNA(blood_dna_info)
			splatter_strength--
		else if(ishuman(iter_atom))
			var/mob/living/carbon/human/splashed_human = iter_atom
			if(!splashed_human.is_eyes_covered())
				splashed_human.adjust_blurriness(3)
				to_chat(splashed_human, span_userdanger("You're blinded by a spray of blood!"))
			if(splashed_human.glasses)
				splashed_human.glasses.add_blood_DNA(blood_dna_info)
				splashed_human.update_worn_glasses() //updates mob overlays to show the new blood (no refresh)
			if(splashed_human.wear_mask)
				splashed_human.wear_mask.add_blood_DNA(blood_dna_info)
				splashed_human.update_worn_mask() //updates mob overlays to show the new blood (no refresh)
			if(splashed_human.wear_suit)
				splashed_human.wear_suit.add_blood_DNA(blood_dna_info)
				splashed_human.update_worn_oversuit() //updates mob overlays to show the new blood (no refresh)
			if(splashed_human.w_uniform)
				splashed_human.w_uniform.add_blood_DNA(blood_dna_info)
				splashed_human.update_worn_undersuit() //updates mob overlays to show the new blood (no refresh)
			splatter_strength--
	if(splatter_strength <= 0) // we used all the puff so we delete it.
		qdel(src)
		return

	if(squirt_type && isturf(loc))
		var/obj/effect/decal/cleanable/squirt = locate(squirt_type) in loc
		if(squirt)
			squirt.add_blood_DNA(blood_dna_info)
		else
			squirt = new squirt_type(loc, get_dir(prev_loc, loc))
			squirt.add_blood_DNA(blood_dna_info)
			squirt.alpha = 0
			animate(squirt, alpha = initial(squirt.alpha), time = 2)

/obj/effect/decal/cleanable/blood/hitsplatter/proc/loop_done(datum/source)
	SIGNAL_HANDLER
	if(!QDELETED(src))
		qdel(src)

/obj/effect/decal/cleanable/blood/hitsplatter/Bump(atom/bumped_atom)
	if(!iswallturf(bumped_atom) && !istype(bumped_atom, /obj/structure/window))
		qdel(src)
		return

	if(istype(bumped_atom, /obj/structure/window))
		var/obj/structure/window/bumped_window = bumped_atom
		if(!bumped_window.fulltile)
			hit_endpoint = TRUE
			qdel(src)
			return

	hit_endpoint = TRUE
	if(istype(bumped_atom, /obj/structure/window))
		//special window case
		var/obj/structure/window/window = bumped_atom
		window.become_bloodied(src)
		skip = TRUE
	else if(isturf(prev_loc))
		abstract_move(bumped_atom)
		skip = TRUE
		//Adjust pixel offset to make splatters appear on the wall
		var/obj/effect/decal/cleanable/blood/splatter/over_window/final_splatter = new(prev_loc)
		var/dir_to_wall = get_dir(src, bumped_atom)
		final_splatter.pixel_x = (dir_to_wall & EAST ? world.icon_size : (dir_to_wall & WEST ? -world.icon_size : 0))
		final_splatter.pixel_y = (dir_to_wall & NORTH ? world.icon_size : (dir_to_wall & SOUTH ? -world.icon_size : 0))
		final_splatter.alpha = 0
		animate(final_splatter, alpha = initial(final_splatter.alpha), time = 2)
	else // This will only happen if prev_loc is not even a turf, which is highly unlikely.
		abstract_move(bumped_atom)
	qdel(src)

// A special case for hitsplatters hitting windows, since those can actually be moved around, store it in the window and slap it in the vis_contents
/obj/effect/decal/cleanable/blood/hitsplatter/proc/land_on_window(obj/structure/window/the_window)
	if(!the_window.fulltile)
		return
	if(the_window.bloodied)
		qdel(src)
		return
	var/obj/effect/decal/cleanable/blood/splatter/over_window/final_splatter = new
	final_splatter.forceMove(the_window)
	the_window.vis_contents += final_splatter
	the_window.bloodied = TRUE
	qdel(src)

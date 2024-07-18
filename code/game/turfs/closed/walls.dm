#define MAX_DENT_DECALS 15
/// Typecache of all objects that we seek out to apply a neighbor stripe overlay
GLOBAL_REAL_VAR(neighbor_typecache) = typecacheof(list(
	/obj/machinery/door/bulkhead,
	/obj/structure/window/reinforced/fulltile,
	/obj/structure/window/fulltile,
	/obj/structure/window/reinforced/shuttle,
	/obj/machinery/door/poddoor,
	/obj/structure/window/reinforced/plasma/fulltile,
	/obj/structure/window/plasma/fulltile,
	/obj/structure/low_wall
	))

GLOBAL_REAL_VAR(wall_overlays_cache) = list()

/turf/closed/wall
	name = "wall"
	desc = "A huge chunk of iron used to separate rooms."
	icon = 'icons/turf/walls/solid_wall.dmi'
	icon_state = "wall-0"
	base_icon_state = "wall"

	explosion_block = 1
	blocks_air = AIR_BLOCKED
	baseturfs = /turf/open/floor/plating

	flags_ricochet = RICOCHET_HARD

	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_CLOSED_TURFS, SMOOTH_GROUP_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_WINDOW_FULLTILE, SMOOTH_GROUP_LOW_WALL, SMOOTH_GROUP_AIRLOCK, SMOOTH_GROUP_SHUTTERS_BLASTDOORS)
	lighting_uses_jen = TRUE

	heat_capacity = 312500 //a little over 5 cm thick , 312500 for 1 m by 2.5 m by 0.25 m plasteel wall

	rcd_memory = RCD_MEMORY_WALL

	color = "#57575c" //To display in mapping softwares

	///lower numbers are harder. Used to determine the probability of a hulk smashing through.
	var/hardness = 40
	var/slicing_duration = 100  //default time taken to slice the wall
	/// Material type of the plating
	var/plating_material = /datum/material/iron
	/// Material type of the reinforcement
	var/reinf_material

	//These are set by the material, do not touch!!!
	var/material_color
	var/shiny_wall
	var/icon/shiny_wall_icon

	var/shiny_stripe
	var/stripe_icon
	var/icon/shiny_stripe_icon
	//Ok you can touch vars again :)

	/// Paint color of which the wall has been painted with.
	var/wall_paint
	/// Paint color of which the stripe has been painted with. Will not overlay a stripe if no paint is applied
	var/stripe_paint
	/// Whether this wall is hard to deconstruct, like a reinforced plasteel wall. Dictated by material
	var/hard_decon
	/// Deconstruction state, matters if the wall is hard to deconstruct (hard_decon)
	var/d_state = INTACT
	/// Whether this wall is rusted or not, to apply the rusted overlay
	var/rusted
	/// Material Set Name
	var/matset_name

	var/list/dent_decals

	///Appearance cache key. This is very touchy.
	VAR_PRIVATE/cache_key

	// Vars for bullet hitting wall interactions
	max_integrity = 300 // Most common ballistics deal 20-30 damage a shot.
	damage_deflection = 5

/turf/closed/wall/take_damage(damage_amount, damage_type, damage_flag, sound_effect, attack_dir, armour_penetration)
	if(damage_type != BRUTE)
		return 0 // We don't take any damage from non-brute sources.

	if(damage_amount <= damage_deflection)
		return 0 // Don't take damage from sources too weak to hurt.

	//Note: Walls are weaker the higher the hardness. Don't ask me why.

	if(hardness > 70) // Some mineral walls are weaker than this.
		damage_amount *= 3
	else if(hardness > 10) // 10 is the hardness of r-walls.
		damage_amount *= 2

	. = damage_amount

	atom_integrity = max(0, get_integrity() - damage_amount)

	if(get_integrity() <= 0)
		dismantle_wall()
		return damage_amount

/turf/closed/wall/has_material_type(datum/material/mat_type, exact=FALSE, mat_amount=0)
	if(plating_material == mat_type)
		return TRUE
	if(reinf_material == mat_type)
		return TRUE
	return FALSE

/turf/closed/wall/update_name()
	. = ..()
	if(rusted)
		name = "rusted "+ matset_name
	else
		name = matset_name

/turf/closed/wall/Initialize(mapload)
	color = null // Remove the color that was set for mapping clarity
	. = ..()
	set_materials(plating_material, reinf_material, FALSE)
	if(is_station_level(z))
		GLOB.station_turfs += src

	// Yes, this is required, because we don't actually follow the normal integrity implementation in walls.
	atom_integrity = max_integrity

/turf/closed/wall/Destroy()
	if(is_station_level(z))
		GLOB.station_turfs -= src
	return ..()

/turf/closed/wall/copyTurf(turf/T)
	. = ..()
	if(istype(., /turf/closed/wall))
		var/turf/closed/wall/pasted_turf = .
		pasted_turf.d_state = d_state
		pasted_turf.set_wall_information(plating_material, reinf_material, wall_paint, stripe_paint)

/// Most of this code is pasted within /obj/structure/falsewall. Be mindful of this
/turf/closed/wall/update_overlays()
	var/plating_color = wall_paint || material_color
	var/stripe_color = stripe_paint || wall_paint || material_color

	var/neighbor_stripe = NONE
	for (var/cardinal = NORTH; cardinal <= WEST; cardinal *= 2) //No list copy please good sir
		var/turf/step_turf = get_step(src, cardinal)
		if(!can_area_smooth(step_turf))
			continue
		for(var/atom/movable/movable_thing as anything in step_turf)
			if(global.neighbor_typecache[movable_thing.type])
				neighbor_stripe ^= cardinal
				break

	var/old_cache_key = cache_key
	cache_key = "[icon]:[smoothing_junction]:[plating_color]:[stripe_icon]:[stripe_color]:[neighbor_stripe]:[shiny_wall]:[shiny_stripe]:[rusted]:[hard_decon && d_state]"
	if(!(old_cache_key == cache_key))

		var/potential_overlays = global.wall_overlays_cache[cache_key]
		if(potential_overlays)
			overlays = potential_overlays
			color = plating_color
		else
			color = plating_color
			//Updating the unmanaged wall overlays (unmanaged for optimisations)
			overlays.len = 0
			var/list/new_overlays = list()

			if(shiny_wall)
				var/image/shine = image(shiny_wall_icon, "shine-[smoothing_junction]")
				shine.appearance_flags = RESET_COLOR
				new_overlays += shine

			var/image/smoothed_stripe = image(stripe_icon, "stripe-[smoothing_junction]")
			smoothed_stripe.appearance_flags = RESET_COLOR
			smoothed_stripe.color = stripe_color
			new_overlays += smoothed_stripe

			if(shiny_stripe)
				var/image/stripe_shine = image(shiny_stripe_icon, "shine-[smoothing_junction]")
				stripe_shine.appearance_flags = RESET_COLOR
				new_overlays += stripe_shine

			if(neighbor_stripe)
				var/image/neighb_stripe_overlay = image('icons/turf/walls/neighbor_stripe.dmi', "stripe-[neighbor_stripe]")
				neighb_stripe_overlay.appearance_flags = RESET_COLOR
				neighb_stripe_overlay.color = stripe_color
				new_overlays += neighb_stripe_overlay
				if(shiny_wall)
					var/image/shine = image('icons/turf/walls/neighbor_stripe_shine.dmi', "shine-[neighbor_stripe]")
					shine.appearance_flags = RESET_COLOR
					new_overlays += shine

			if(rusted)
				var/image/rust_overlay = image('icons/turf/rust_overlay.dmi', "blobby_rust")
				rust_overlay.appearance_flags = RESET_COLOR
				new_overlays += rust_overlay

			if(hard_decon && d_state)
				var/image/decon_overlay = image('icons/turf/walls/decon_states.dmi', "[d_state]")
				decon_overlay.appearance_flags = RESET_COLOR
				new_overlays += decon_overlay

			overlays = new_overlays
			global.wall_overlays_cache[cache_key] = new_overlays


	if(dent_decals)
		add_overlay(dent_decals)

	//And letting anything else that may want to render on the wall to work (ie components)
	return ..()

/turf/closed/wall/examine(mob/user)
	. += ..()
	if(wall_paint)
		. += span_notice("It's coated with a <font color=[wall_paint]>layer of paint</font>.")
	if(stripe_paint)
		. += span_notice("It has a <font color=[stripe_paint]>painted stripe</font> around its base.")
	. += deconstruction_hints(user)

/turf/closed/wall/proc/deconstruction_hints(mob/user)
	if(hard_decon)
		switch(d_state)
			if(INTACT)
				return span_notice("The outer <b>grille</b> is fully intact.")
			if(SUPPORT_LINES)
				return span_notice("The outer <i>grille</i> has been cut, and the support lines are <b>screwed</b> securely to the outer cover.")
			if(COVER)
				return span_notice("The support lines have been <i>unscrewed</i>, and the metal cover is <b>welded</b> firmly in place.")
			if(CUT_COVER)
				return span_notice("The metal cover has been <i>sliced through</i>, and is <b>connected loosely</b> to the girder.")
			if(ANCHOR_BOLTS)
				return span_notice("The outer cover has been <i>pried away</i>, and the bolts anchoring the support rods are <b>wrenched</b> in place.")
			if(SUPPORT_RODS)
				return span_notice("The bolts anchoring the support rods have been <i>loosened</i>, but are still <b>welded</b> firmly to the girder.")
			if(SHEATH)
				return span_notice("The support rods have been <i>sliced through</i>, and the outer sheath is <b>connected loosely</b> to the girder.")
	else
		return span_notice("The outer plating is <b>welded</b> firmly in place.")

/turf/closed/wall/attack_tk()
	return

/// Most of this code is pasted within /obj/structure/falsewall. Be mindful of this
/turf/closed/wall/proc/paint_wall(new_paint)
	wall_paint = new_paint
	update_appearance()

/// Most of this code is pasted within /obj/structure/falsewall. Be mindful of this
/turf/closed/wall/proc/paint_stripe(new_paint)
	stripe_paint = new_paint
	update_appearance()

/// Most of this code is pasted within /obj/structure/falsewall. Be mindful of this
/turf/closed/wall/proc/set_wall_information(plating_mat, reinf_mat, new_paint, new_stripe_paint)
	wall_paint = new_paint
	stripe_paint = new_stripe_paint
	set_materials(plating_mat, reinf_mat)

/// Most of this code is pasted within /obj/structure/falsewall. Be mindful of this
/turf/closed/wall/proc/set_materials(plating_mat, reinf_mat, update_appearance = TRUE)
	if(!plating_mat)
		CRASH("Something tried to set wall plating to null!")

	var/datum/material/plating_mat_ref = GET_MATERIAL_REF(plating_mat)
	var/datum/material/reinf_mat_ref
	if(reinf_mat)
		reinf_mat_ref = GET_MATERIAL_REF(reinf_mat)

	if(reinf_mat_ref && plating_mat_ref.hard_wall_decon)
		hard_decon = TRUE
	else
		hard_decon = null

	if(reinf_mat_ref) // Wait, why does both shiny_wall and shiny_stripe exist- ugh, whatever.
		icon = plating_mat_ref.reinforced_wall_icon
		shiny_wall = plating_mat_ref.wall_shine & WALL_SHINE_REINFORCED
		if(shiny_wall)
			shiny_wall_icon = plating_mat_ref.wall_shine_icon
		shiny_stripe = plating_mat_ref.wall_shine & WALL_SHINE_REINFORCED
		material_color = plating_mat_ref.wall_color
	else
		icon = plating_mat_ref.wall_icon
		shiny_wall = plating_mat_ref.wall_shine & WALL_SHINE_PLATING
		if(shiny_wall)
			shiny_wall_icon = plating_mat_ref.reinforced_wall_shine_icon
		shiny_stripe = plating_mat_ref.wall_shine & WALL_SHINE_PLATING
		material_color = plating_mat_ref.wall_color

	stripe_icon = plating_mat_ref.wall_stripe_icon
	if(shiny_stripe)
		shiny_stripe_icon = plating_mat_ref.wall_stripe_shine_icon

	plating_material = plating_mat
	reinf_material = reinf_mat

	if(reinf_material)
		name = "reinforced [plating_mat_ref.name] [plating_mat_ref.wall_name]"
		desc = "It seems to be a section of hull reinforced with [reinf_mat_ref.name] and plated with [plating_mat_ref.name]."
	else
		name = "[plating_mat_ref.name] [plating_mat_ref.wall_name]"
		desc = "It seems to be a section of hull plated with [plating_mat_ref.name]."
	matset_name = name

	if(update_appearance)
		update_appearance()

/turf/closed/wall/proc/dismantle_wall(devastated = FALSE, explode = FALSE)
	if(devastated)
		devastate_wall()
	else
		playsound(src, 'sound/items/welder.ogg', 100, TRUE)
		var/newgirder = break_wall()
		if(newgirder) //maybe we don't /want/ a girder!
			transfer_fingerprints_to(newgirder)

	for(var/obj/O in src.contents) //Eject contents!
		if(istype(O, /obj/structure/sign/poster))
			var/obj/structure/sign/poster/P = O
			P.roll_and_drop(src)

	ScrapeAway()

/turf/closed/wall/proc/break_wall(drop_mats = TRUE)
	if(drop_mats)
		drop_materials_used()
	return new /obj/structure/girder(src, reinf_material, wall_paint, stripe_paint)

/turf/closed/wall/proc/devastate_wall()
	drop_materials_used(TRUE)
	new /obj/item/stack/sheet/iron(src)

/turf/closed/wall/proc/drop_materials_used(drop_reinf = FALSE)
	var/datum/material/plating_mat_ref = GET_MATERIAL_REF(plating_material)
	new plating_mat_ref.sheet_type(src, 2)
	if(drop_reinf && reinf_material)
		var/datum/material/reinf_mat_ref = GET_MATERIAL_REF(reinf_material)
		new reinf_mat_ref.sheet_type(src, 2)

/turf/closed/wall/ex_act(severity, target)
	if(target == src)
		dismantle_wall(1,1)
		return

	switch(severity)
		if(EXPLODE_DEVASTATE)
			//SN src = null
			var/turf/NT = ScrapeAway()
			NT.contents_explosion(severity, target)
			return
		if(EXPLODE_HEAVY)
			dismantle_wall(prob(50), TRUE)
		if(EXPLODE_LIGHT)
			if (prob(hardness))
				dismantle_wall(0,1)
	if(!density)
		..()


/turf/closed/wall/blob_act(obj/structure/blob/B)
	if(prob(50))
		dismantle_wall()
	else
		add_dent(WALL_DENT_HIT)

/turf/closed/wall/attack_paw(mob/living/user, list/modifiers)
	user.changeNext_move(CLICK_CD_MELEE)
	return attack_hand(user, modifiers)


/turf/closed/wall/attack_animal(mob/living/simple_animal/user, list/modifiers)
	if(hard_decon)
		user.changeNext_move(CLICK_CD_MELEE)
		user.do_attack_animation(src)
		if(!user.environment_smash)
			return
		if(user.environment_smash & ENVIRONMENT_SMASH_RWALLS)
			dismantle_wall(1)
			playsound(src, 'sound/effects/meteorimpact.ogg', 100, TRUE)
		else
			playsound(src, 'sound/effects/bang.ogg', 50, TRUE)
			to_chat(user, span_warning("This wall is far too strong for you to destroy."))
	else
		user.changeNext_move(CLICK_CD_MELEE)
		user.do_attack_animation(src)
		if((user.environment_smash & ENVIRONMENT_SMASH_WALLS) || (user.environment_smash & ENVIRONMENT_SMASH_RWALLS))
			playsound(src, 'sound/effects/meteorimpact.ogg', 100, TRUE)
			dismantle_wall(1)
			return

/**
 *Deals damage back to the hulk's arm.
 *
 *When a hulk manages to break a wall using their hulk smash, this deals back damage to the arm used.
 *This is in its own proc just to be easily overridden by other wall types. Default allows for three
 *smashed walls per arm. Also, we use CANT_WOUND here because wounds are random. Wounds are applied
 *by hulk code based on arm damage and checked when we call break_an_arm().
 *Arguments:
 **arg1 is the arm to deal damage to.
 **arg2 is the hulk
 */

/turf/closed/wall/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	to_chat(user, span_notice("You push the wall but nothing happens!"))
	playsound(src, 'sound/weapons/genhit.ogg', 25, TRUE)
	add_fingerprint(user)

/turf/closed/wall/attackby(obj/item/W, mob/user, params)
	user.changeNext_move(CLICK_CD_MELEE)
	if (!ISADVANCEDTOOLUSER(user))
		to_chat(user, span_warning("You don't have the dexterity to do this!"))
		return

	//get the user's location
	if(!isturf(user.loc))
		return //can't do this stuff whilst inside objects and such

	add_fingerprint(user)

	var/turf/T = user.loc //get user's location for delay checks

	//the istype cascade has been spread among various procs for easy overriding
	if(try_clean(W, user, T) || try_wallmount(W, user, T) || try_decon(W, user, T))
		return

	return ..()

/turf/closed/wall/proc/try_clean(obj/item/W, mob/living/user, turf/T)
	if((user.combat_mode) || !LAZYLEN(dent_decals))
		return FALSE

	if(W.tool_behaviour == TOOL_WELDER)
		if(!W.tool_start_check(user, amount=0))
			return FALSE

		to_chat(user, span_notice("You begin fixing dents on the wall..."))
		if(W.use_tool(src, user, 0, volume=100))
			if(iswallturf(src) && LAZYLEN(dent_decals))
				to_chat(user, span_notice("You fix some dents on the wall."))
				update_integrity(max_integrity)
				cut_overlay(dent_decals)
				dent_decals.Cut()
			return TRUE

	return FALSE

/turf/closed/wall/proc/try_wallmount(obj/item/W, mob/user, turf/T)
	//check for wall mounted frames
	if(istype(W, /obj/item/wallframe))
		var/obj/item/wallframe/F = W
		if(F.try_build(src, user))
			F.attach(src, user)
		return TRUE
	//Poster stuff
	else if(istype(W, /obj/item/poster))
		place_poster(W,user)
		return TRUE

	return FALSE

/turf/closed/wall/proc/try_decon(obj/item/I, mob/user, turf/T)
	if(hard_decon)
		switch(d_state)
			if(INTACT)
				if(I.tool_behaviour == TOOL_WIRECUTTER)
					I.play_tool_sound(src, 100)
					d_state = SUPPORT_LINES
					update_appearance()
					to_chat(user, span_notice("You cut the outer grille."))
					return TRUE

			if(SUPPORT_LINES)
				if(I.tool_behaviour == TOOL_SCREWDRIVER)
					to_chat(user, span_notice("You begin unsecuring the support lines..."))
					if(I.use_tool(src, user, 40, volume=100))
						if(!istype(src, /turf/closed/wall) || d_state != SUPPORT_LINES)
							return TRUE
						d_state = COVER
						update_appearance()
						to_chat(user, span_notice("You unsecure the support lines."))
					return TRUE

				else if(I.tool_behaviour == TOOL_WIRECUTTER)
					I.play_tool_sound(src, 100)
					d_state = INTACT
					update_appearance()
					to_chat(user, span_notice("You repair the outer grille."))
					return TRUE

			if(COVER)
				if(I.tool_behaviour == TOOL_WELDER)
					if(!I.tool_start_check(user, amount=0))
						return
					to_chat(user, span_notice("You begin slicing through the metal cover..."))
					if(I.use_tool(src, user, 60, volume=100))
						if(!istype(src, /turf/closed/wall) || d_state != COVER)
							return TRUE
						d_state = CUT_COVER
						update_appearance()
						to_chat(user, span_notice("You press firmly on the cover, dislodging it."))
					return TRUE

				if(I.tool_behaviour == TOOL_SCREWDRIVER)
					to_chat(user, span_notice("You begin securing the support lines..."))
					if(I.use_tool(src, user, 40, volume=100))
						if(!istype(src, /turf/closed/wall) || d_state != COVER)
							return TRUE
						d_state = SUPPORT_LINES
						update_appearance()
						to_chat(user, span_notice("The support lines have been secured."))
					return TRUE

			if(CUT_COVER)
				if(I.tool_behaviour == TOOL_CROWBAR)
					to_chat(user, span_notice("You struggle to pry off the cover..."))
					if(I.use_tool(src, user, 100, volume=100))
						if(!istype(src, /turf/closed/wall) || d_state != CUT_COVER)
							return TRUE
						d_state = ANCHOR_BOLTS
						update_appearance()
						to_chat(user, span_notice("You pry off the cover."))
					return TRUE

				if(I.tool_behaviour == TOOL_WELDER)
					if(!I.tool_start_check(user, amount=0))
						return
					to_chat(user, span_notice("You begin welding the metal cover back to the frame..."))
					if(I.use_tool(src, user, 60, volume=100))
						if(!istype(src, /turf/closed/wall) || d_state != CUT_COVER)
							return TRUE
						d_state = COVER
						update_appearance()
						to_chat(user, span_notice("The metal cover has been welded securely to the frame."))
					return TRUE

			if(ANCHOR_BOLTS)
				if(I.tool_behaviour == TOOL_WRENCH)
					to_chat(user, span_notice("You start loosening the anchoring bolts which secure the support rods to their frame..."))
					if(I.use_tool(src, user, 40, volume=100))
						if(!istype(src, /turf/closed/wall) || d_state != ANCHOR_BOLTS)
							return TRUE
						d_state = SUPPORT_RODS
						update_appearance()
						to_chat(user, span_notice("You remove the bolts anchoring the support rods."))
					return TRUE

				if(I.tool_behaviour == TOOL_CROWBAR)
					to_chat(user, span_notice("You start to pry the cover back into place..."))
					if(I.use_tool(src, user, 20, volume=100))
						if(!istype(src, /turf/closed/wall) || d_state != ANCHOR_BOLTS)
							return TRUE
						d_state = CUT_COVER
						update_appearance()
						to_chat(user, span_notice("The metal cover has been pried back into place."))
					return TRUE

			if(SUPPORT_RODS)
				if(I.tool_behaviour == TOOL_WELDER)
					if(!I.tool_start_check(user, amount=0))
						return
					to_chat(user, span_notice("You begin slicing through the support rods..."))
					if(I.use_tool(src, user, 100, volume=100))
						if(!istype(src, /turf/closed/wall) || d_state != SUPPORT_RODS)
							return TRUE
						d_state = SHEATH
						update_appearance()
						to_chat(user, span_notice("You slice through the support rods."))
					return TRUE

				if(I.tool_behaviour == TOOL_WRENCH)
					to_chat(user, span_notice("You start tightening the bolts which secure the support rods to their frame..."))
					I.play_tool_sound(src, 100)
					if(I.use_tool(src, user, 40))
						if(!istype(src, /turf/closed/wall) || d_state != SUPPORT_RODS)
							return TRUE
						d_state = ANCHOR_BOLTS
						update_appearance()
						to_chat(user, span_notice("You tighten the bolts anchoring the support rods."))
					return TRUE

			if(SHEATH)
				if(I.tool_behaviour == TOOL_CROWBAR)
					to_chat(user, span_notice("You struggle to pry off the outer sheath..."))
					if(I.use_tool(src, user, 100, volume=100))
						if(!istype(src, /turf/closed/wall) || d_state != SHEATH)
							return TRUE
						to_chat(user, span_notice("You pry off the outer sheath."))
						dismantle_wall()
					return TRUE

				if(I.tool_behaviour == TOOL_WELDER)
					if(!I.tool_start_check(user, amount=0))
						return
					to_chat(user, span_notice("You begin welding the support rods back together..."))
					if(I.use_tool(src, user, 100, volume=100))
						if(!istype(src, /turf/closed/wall) || d_state != SHEATH)
							return TRUE
						d_state = SUPPORT_RODS
						update_appearance()
						to_chat(user, span_notice("You weld the support rods back together."))
					return TRUE
	else
		if(I.tool_behaviour == TOOL_WELDER)
			if(!I.tool_start_check(user, amount=0))
				return FALSE

			to_chat(user, span_notice("You begin slicing through the outer plating..."))
			if(I.use_tool(src, user, slicing_duration, volume=100))
				if(iswallturf(src))
					to_chat(user, span_notice("You remove the outer plating."))
					dismantle_wall()
				return TRUE

	return FALSE

/turf/closed/wall/singularity_pull(S, current_size)
	..()
	wall_singularity_pull(current_size)

/turf/closed/wall/proc/wall_singularity_pull(current_size)
	if(hard_decon)
		if(current_size >= STAGE_FIVE)
			if(prob(30))
				dismantle_wall()
	else
		if(current_size >= STAGE_FIVE)
			if(prob(50))
				dismantle_wall()
			return
		if(current_size == STAGE_FOUR)
			if(prob(30))
				dismantle_wall()

/turf/closed/wall/narsie_act(force, ignore_mobs, probability = 20)
	. = ..()
	if(.)
		ChangeTurf(/turf/closed/wall/mineral/cult)

/turf/closed/wall/get_dumping_location(obj/item/storage/source, mob/user)
	return null

/turf/closed/wall/acid_act(acidpwr, acid_volume)
	if(explosion_block >= 2)
		acidpwr = min(acidpwr, 50) //we reduce the power so strong walls never get melted.
	return ..()

/turf/closed/wall/acid_melt()
	dismantle_wall(1)

/turf/closed/wall/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	if(hard_decon && !the_rcd.canRturf)
		return
	switch(the_rcd.mode)
		if(RCD_DECONSTRUCT)
			return list("mode" = RCD_DECONSTRUCT, "delay" = 40, "cost" = 26)
	return FALSE

/turf/closed/wall/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, passed_mode)
	if(hard_decon && !the_rcd.canRturf)
		return
	switch(passed_mode)
		if(RCD_DECONSTRUCT)
			to_chat(user, span_notice("You deconstruct the wall."))
			ScrapeAway()
			return TRUE
	return FALSE

/turf/closed/wall/proc/add_dent(denttype, x=rand(-8, 8), y=rand(-8, 8))
	if(LAZYLEN(dent_decals) >= MAX_DENT_DECALS)
		return

	var/mutable_appearance/decal = mutable_appearance('icons/effects/effects.dmi', "", BULLET_HOLE_LAYER)
	switch(denttype)
		if(WALL_DENT_SHOT)
			decal.icon_state = "bullet_hole"
		if(WALL_DENT_HIT)
			decal.icon_state = "impact[rand(1, 3)]"

	decal.pixel_x = x
	decal.pixel_y = y

	if(LAZYLEN(dent_decals))
		cut_overlay(dent_decals)
		dent_decals += decal
	else
		dent_decals = list(decal)

	add_overlay(dent_decals)

/turf/closed/wall/rust_heretic_act()
	if(rusted)
		return
	if(hard_decon && prob(50))
		return
	if(prob(70))
		new /obj/effect/temp_visual/glowing_rune(src)
	rusted = TRUE
	update_appearance()

#undef MAX_DENT_DECALS

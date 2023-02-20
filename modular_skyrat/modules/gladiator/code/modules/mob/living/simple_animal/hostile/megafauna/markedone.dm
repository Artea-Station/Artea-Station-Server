#define MARKED_ONE_STUN_DURATION 1.5 SECONDS
#define MARKED_ONE_ANGER_DURATION 10 MINUTES
#define MARKED_ONE_FIRST_PHASE 1
#define MARKED_ONE_SECOND_PHASE 2
#define MARKED_ONE_THIRD_PHASE 3
#define MARKED_ONE_FINAL_PHASE 4
#define ONE_HUNDRED_PERCENT 100
#define SEVENTY_FIVE_PERCENT 75
#define FIFTY_PERCENT 50
#define SHOWDOWN_PERCENT 25

/**
 * A mean-ass single-combat sword-wielding nigh-demigod that is nothing but a walking, talking, breathing Berserk reference. He do kill shit doe!
 */
/mob/living/simple_animal/hostile/megafauna/gladiator
	name = "\proper The Marked One"
	desc = "An ancient miner lost to time, chosen and changed by the Necropolis, encased in a suit of armor. Only a chosen few can match his speed and strength."
	icon = 'modular_skyrat/modules/gladiator/icons/markedone.dmi'
	icon_state = "marked1"
	icon_dead = "marked_dying"
	attack_verb_simple = "cleave"
	attack_verb_continuous = "cleaves"
	attack_sound = 'modular_skyrat/master_files/sound/weapons/bloodyslice.ogg'
	death_sound = 'sound/creatures/space_dragon_roar.ogg'
	death_message = "falls on his sword, ash evaporating from every hole in his armor."
	gps_name = "Forgotten Signal"
	gender = MALE
	rapid_melee = 1
	melee_queue_distance = 2
	melee_damage_lower = 40
	melee_damage_upper = 40
	speed = 1
	move_to_delay = 2.25
	pixel_x = -32
	pixel_y = -9
	wander = FALSE
	ranged = 1
	ranged_cooldown_time = 30
	minimum_distance = 1
	health = 4000
	maxHealth = 4000 //for contrast, bubblegum and the colossus both have 2500 health
	movement_type = GROUND
	mouse_opacity = MOUSE_OPACITY_OPAQUE
	loot = list(/obj/structure/closet/crate/necropolis/gladiator)
	crusher_loot = list(/obj/structure/closet/crate/necropolis/gladiator/crusher)
	/// Boss phase, from 1 to 3
	var/phase = MARKED_ONE_FIRST_PHASE
	/// People we have introduced ourselves to - WEAKREF list
	var/list/introduced = list()
	/// Are we doing the spin attack?
	var/spinning = FALSE
	/// Range of spin attack
	var/spinning_range = 4
	/// Are we doing the charge attack
	var/charging = FALSE
	/// If we are charging, this is a counter for how many tiles we have ran past
	var/chargetiles = 0
	/// Maximum range for charging, in case we don't ram any closed turf
	var/chargerange = 21
	/// We get stunned whenever we ram into a closed turf
	var/stunned = FALSE
	/// Move_to_delay but only while we are charging
	var/move_to_delay_charge = 1.5
	/// Chance to block damage entirely on phase 1
	var/phase_1_block_chance = 50
	/// This mob will not attack mobs randomly if not in anger, the time doubles as a check for anger
	var/anger_timer_id = null

/mob/living/simple_animal/hostile/megafauna/gladiator/Destroy()
	get_calm()
	return ..()

/mob/living/simple_animal/hostile/megafauna/gladiator/Life()
	. = ..()
	if(stat >= DEAD)
		return
	/// Try introducing ourselvess to people while not pissed off
	if(!anger_timer_id)
		/// Yes, i am calling view on life! I don't think i can avoid this!
		for(var/mob/living/friend_or_foe in (view(4, src)-src))
			var/datum/weakref/friend_or_foe_ref = WEAKREF(friend_or_foe)
			if(!(friend_or_foe_ref in introduced) && (friend_or_foe.stat != DEAD))
				introduction(friend_or_foe)
				break

/mob/living/simple_animal/hostile/megafauna/gladiator/Found(atom/A)
	//We only attac when pissed off
	if(!anger_timer_id)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/megafauna/gladiator/ListTargets()
	if(!anger_timer_id)
		return list()
	return ..()

/mob/living/simple_animal/hostile/megafauna/gladiator/examine() //is it really any secret what this does
	if(stat >= DEAD)
		. = ..()
		. += span_boldwarning("Unearthly energies bind the body to it's place of defeat. You cannot move it.")
	else
		. = ..()
		. += span_boldwarning("They are currently in Phase [phase].")

/mob/living/simple_animal/hostile/megafauna/gladiator/adjustHealth(amount, updating_health, forced) //gets him mad at you if you're a species he's not racist towards, only once he takes damage
	get_angry()
	if(spinning)
		visible_message(span_danger("[src] brushes off all incoming attacks with his spinning blade!"))
		return FALSE
	else if(prob(phase_1_block_chance) && (phase == 1) && !stunned)
		visible_message(span_danger("[src] blocks all incoming damage with his arm!"))
		return FALSE
	. = ..()
	update_phase()
	// Taking damage makes us unable to attack for a while
	var/adjustment_amount = min(amount * 0.15, 15)
	if((world.time + adjustment_amount) > next_move)
		changeNext_move(adjustment_amount)

/mob/living/simple_animal/hostile/megafauna/gladiator/AttackingTarget() //calls bump when charging into a target
	. = ..()
	if(spinning || stunned)
		return
	if(charging && (get_dist(src, target) <= 1))
		Bump(target)
	if(. && prob(5 * phase))
		INVOKE_ASYNC(src, PROC_REF(teleport), target)

/mob/living/simple_animal/hostile/megafauna/gladiator/Move(atom/newloc, dir, step_x, step_y) //chasms are for sissies
	if(spinning || stunned)
		return FALSE
	if(ischasm(newloc))
		var/list/possible_locs = list()
		switch(get_dir(src, newloc))
			if(NORTH)
				possible_locs += locate(x +1, y + 1, z)
				possible_locs += locate(x -1, y + 1, z)
			if(EAST)
				possible_locs += locate(x + 1, y + 1, z)
				possible_locs += locate(x + 1, y - 1, z)
			if(WEST)
				possible_locs += locate(x - 1, y + 1, z)
				possible_locs += locate(x - 1, y - 1, z)
			if(SOUTH)
				possible_locs += locate(x - 1, y - 1, z)
				possible_locs += locate(x + 1, y - 1, z)
			if(SOUTHEAST)
				possible_locs += locate(x + 1, y, z)
				possible_locs += locate(x + 1, y + 1, z)
			if(SOUTHWEST)
				possible_locs += locate(x - 1, y, z)
				possible_locs += locate(x - 1, y + 1, z)
			if(NORTHWEST)
				possible_locs += locate(x - 1, y, z)
				possible_locs += locate(x - 1, y - 1, z)
			if(NORTHEAST)
				possible_locs += locate(x + 1, y - 1, z)
				possible_locs += locate(x + 1, y, z)
		//locates may add nulls to the list
		for(var/turf/possible_turf as anything in possible_locs)
			if(!istype(possible_turf) || ischasm(possible_turf))
				possible_locs -= possible_turf
		if(LAZYLEN(possible_locs))
			var/turf/validloc = pick(possible_locs)
			. = ..(validloc)
			if(. && charging)
				chargetiles++
				if(chargetiles >= chargerange)
					INVOKE_ASYNC(src, PROC_REF(discharge))
		return FALSE
	. = ..()
	if(. && charging)
		chargetiles++
		if(chargetiles >= chargerange)
			INVOKE_ASYNC(src, PROC_REF(discharge))

/mob/living/simple_animal/hostile/megafauna/gladiator/Bump(atom/A) //used for charge-induced ass-tappage
	. = ..()
	if(!charging)
		return
	if(isliving(A))
		var/mob/living/living_atom = A
		forceMove(get_turf(living_atom))
		visible_message(span_danger("[src] knocks [living_atom] down!"))
		living_atom.Paralyze(20)
		discharge()
	else if(istype(A, /turf/closed))
		visible_message(span_danger("[src] crashes headfirst into [A]!"))
		discharge(1.33)

/mob/living/simple_animal/hostile/megafauna/gladiator/proc/get_angry() //GET MAD! I DON'T WANT YOUR DAMN LEMONS WHAT THE HELL AM I SUPPOSED TO DO WITH THESE
	if(stat >= DEAD)
		return
	if(anger_timer_id)
		deltimer(anger_timer_id)
	anger_timer_id = addtimer(CALLBACK(src, PROC_REF(get_calm)), MARKED_ONE_ANGER_DURATION, TIMER_STOPPABLE)

/mob/living/simple_animal/hostile/megafauna/gladiator/proc/get_calm() //I'M THE MAN THAT'S GONNA BURN YOUR HOUSE DOWN! With the lemons!
	if(anger_timer_id)
		deltimer(anger_timer_id)
	anger_timer_id = null

/mob/living/simple_animal/hostile/megafauna/gladiator/proc/introduction(mob/living/target) //monologue.txt
	if(ishuman(target))
		var/mob/living/carbon/human/human_target = target
		var/datum/species/targetspecies = human_target.dna.species
		// The gladiator hates non-humans, he especially hates ash walkers.
		if(targetspecies.id == SPECIES_HUMAN)
			var/static/list/human_messages = list(
									"Is this all that is left?",
									"Show the necropolis it was wrong to choose me.",
									"Ironic that I become what I once fought like you.",
									"Sometimes, the abyss gazes back.",
									"Show me a good time, miner!",
									"I'll give you the first hit.",
								)
			say(message = pick(human_messages))
			introduced |= WEAKREF(target)
		else if(targetspecies.id == SPECIES_LIZARD_ASH)
			var/static/list/ashie_messages = list(
									"Foolishness, ash walker!",
									"I've had enough of you for a lifetime!",
									"I don't need a crusher to KICK YOUR ASS!",
									"GET OVER HERE!!",
								)

			say(message = pick(ashie_messages), language = /datum/language/ashtongue)
			introduced |= WEAKREF(target)
			get_angry()
			GiveTarget(target)
		else
			var/static/list/other_humanoid_messages = list(
									"I will smite you!",
									"I will show you true power!",
									"Let us see how worthy you are!",
									"You will make a fine rug!",
									"For the necropolis!"
									)
			say(message = pick(other_humanoid_messages))
			introduced |= WEAKREF(target)
			get_angry()
			GiveTarget(target)
	else
		//simplemobs beware
		say("FRESH MEAT!")
		introduced |= WEAKREF(target)

/mob/living/simple_animal/hostile/megafauna/gladiator/proc/update_phase() //this checks against his current health and updates his phase accordingly
	var/healthpercentage = 100 * (health/maxHealth)
	if(src.stat >= DEAD)
		return
	switch(healthpercentage)
		if(SEVENTY_FIVE_PERCENT to ONE_HUNDRED_PERCENT)
			phase = MARKED_ONE_FIRST_PHASE
			rapid_melee = initial(rapid_melee)
			move_to_delay = initial(move_to_delay)
			melee_damage_upper = initial(melee_damage_upper)
			melee_damage_lower = initial(melee_damage_lower)
		if(FIFTY_PERCENT to SEVENTY_FIVE_PERCENT)
			if(phase == MARKED_ONE_FIRST_PHASE)
				phase = MARKED_ONE_SECOND_PHASE
				INVOKE_ASYNC(src, PROC_REF(charge), target, 21)
				playsound(src, 'sound/effects/clockcult_gateway_disrupted.ogg', 200, 1, 2)
				icon_state = "marked2"
				rapid_melee = 2
				move_to_delay = 2
				melee_damage_upper = 30
				melee_damage_lower = 30
		if(SHOWDOWN_PERCENT to FIFTY_PERCENT)
			if(phase == MARKED_ONE_SECOND_PHASE)
				phase = MARKED_ONE_THIRD_PHASE
				INVOKE_ASYNC(src, PROC_REF(charge), target, 21)
				playsound(src, 'sound/effects/clockcult_gateway_charging.ogg', 200, 1, 2)
				rapid_melee = 4
				melee_damage_upper = 25
				melee_damage_lower = 25
				move_to_delay = 1.7
		if(0 to SHOWDOWN_PERCENT)
			if (phase == MARKED_ONE_THIRD_PHASE)
				phase = MARKED_ONE_FINAL_PHASE
				INVOKE_ASYNC(src, PROC_REF(charge), target, 21)
				playsound(src, 'sound/effects/clockcult_gateway_active.ogg', 200, 1, 2)
				icon_state = "marked3"
				rapid_melee = 1
				melee_damage_upper = 50
				melee_damage_lower = 50
				move_to_delay = 2.5
	if(charging)
		move_to_delay = move_to_delay_charge

/mob/living/simple_animal/hostile/megafauna/gladiator/proc/spinattack() //SPEEEEN
	var/turf/our_turf = get_turf(src)
	if(!istype(our_turf))
		return
	visible_message(span_userdanger("[src] lifts his ancient blade, and prepares to spin!"))
	spinning = TRUE
	animate(src, color = "#ff6666", 10)
	SLEEP_CHECK_DEATH(5, src)
	var/list/spinningturfs = list()
	var/current_angle = 360
	while(current_angle > 0)
		var/turf/target_turf = get_turf_in_angle(current_angle, our_turf, spinning_range)
		if(!istype(target_turf))
			continue
		// Yes, there may be repeats with previous turfs! Yes, this is intentional!
		spinningturfs += get_line(our_turf, target_turf)
		current_angle -= 30
	var/list/hit_things = list()
	spinning = TRUE
	for(var/turf/targeted as anything in spinningturfs)
		dir = get_dir(src, targeted)
		var/obj/effect/temp_visual/small_smoke/halfsecond/smonk = new /obj/effect/temp_visual/small_smoke/halfsecond(targeted)
		QDEL_IN(smonk, 0.5 SECONDS)
		for(var/mob/living/slapped in targeted)
			if(!faction_check(faction, slapped.faction) && !(slapped in hit_things))
				playsound(src, 'sound/weapons/slash.ogg', 75, 0)
				if(slapped.apply_damage(40, BRUTE, BODY_ZONE_CHEST, slapped.run_armor_check(BODY_ZONE_CHEST), wound_bonus = CANT_WOUND))
					visible_message(span_danger("[src] slashes through [slapped] with his spinning blade!"))
				else
					visible_message(span_danger("[src]'s spinning blade is stopped by [slapped]!"))
					spinning = FALSE
				hit_things |= slapped
		if(!spinning)
			break
		addtimer(CALLBACK(src, PROC_REF(animate_speen)), 0.5 SECONDS)

/mob/living/simple_animal/hostile/megafauna/gladiator/proc/animate_speen()
	animate(src, color = initial(color), 3)
	addtimer(CALLBACK(src, PROC_REF(stop_speen)), 0.5 SECONDS)

/mob/living/simple_animal/hostile/megafauna/gladiator/proc/stop_speen()
	spinning = FALSE

/mob/living/simple_animal/hostile/megafauna/gladiator/proc/charge(atom/target, range = 1) //the marked one's charge has an instant travel time, but takes a moment to power-up, allowing you to get behind cover to stun him
	face_atom(target)
	visible_message(span_userdanger("[src] lifts his arm, and prepares to charge!"))
	animate(src, color = "#ff6666", 3)
	SLEEP_CHECK_DEATH(4, src)
	face_atom(target)
	minimum_distance = 0
	charging = TRUE
	update_phase()

/mob/living/simple_animal/hostile/megafauna/gladiator/proc/discharge(modifier = 1) //discharge is a proc that occurs when the marked one charges into a solid turf on his way to your ass, causing a stun
	stunned = TRUE
	charging = FALSE
	minimum_distance = initial(minimum_distance)
	chargetiles = 0
	animate(src, color = initial(color), 5)
	update_phase()
	sleep(CEILING(MARKED_ONE_STUN_DURATION * modifier, 1))
	stunned = FALSE

/mob/living/simple_animal/hostile/megafauna/gladiator/proc/teleport(atom/target) //teleport is a proc that makes him teleport
	var/turf/targeted = get_step(target, target.dir)
	new /obj/effect/temp_visual/small_smoke/halfsecond(get_turf(src))
	SLEEP_CHECK_DEATH(4, src)
	if(istype(targeted) && !ischasm(targeted) && !istype(targeted, /turf/open/openspace))
		new /obj/effect/temp_visual/small_smoke/halfsecond(targeted)
		forceMove(targeted)
	else
		var/list/possible_locs = (view(3, target))
		for(var/turf/possible_turf as anything in possible_locs)
			if(!istype(possible_turf) || ischasm(possible_turf) || istype(targeted, /turf/open/openspace) || istype(possible_turf, /turf/closed))
				possible_locs -= possible_turf
				continue
		if(LAZYLEN(possible_locs))
			targeted = pick(possible_locs)
			new /obj/effect/temp_visual/small_smoke/halfsecond(targeted)
			forceMove(targeted)

/mob/living/simple_animal/hostile/megafauna/gladiator/proc/bone_knife_throw(atom/target) //bone_knife_throw is a proc that throws bone knives
	var/obj/item/knife/combat/bone/boned = new /obj/item/knife/combat/bone(get_turf(src))
	boned.throwforce = 35
	playsound(src, 'sound/weapons/bolathrow.ogg', 60, 0)
	boned.throw_at(target, 7, 3, thrower = src)
	QDEL_IN(boned, 3 SECONDS)

/mob/living/simple_animal/hostile/megafauna/gladiator/proc/swordslam() //this kills the crab
	wendigo_slam(src, 5, 1 SECONDS, 8)

/mob/living/simple_animal/hostile/megafauna/gladiator/proc/stomp()
	wendigo_slam(src, 2, 0.5 SECONDS, 3)

/mob/living/simple_animal/hostile/megafauna/gladiator/OpenFire() //used to actually decide what attacks he does. abandon all hope ye who enter here
	if(!COOLDOWN_FINISHED(src, ranged_cooldown))
		return FALSE
	if(spinning || stunned || charging)
		return FALSE
	ranged_cooldown = world.time
	switch(phase)
		if(MARKED_ONE_FIRST_PHASE)
			if(prob(10) && (get_dist(src, target) <= spinning_range))
				INVOKE_ASYNC(src, PROC_REF(spinattack))
				INVOKE_ASYNC(src, PROC_REF(stomp))
				ranged_cooldown += 5.5 SECONDS
			else
				if(prob(50))
					INVOKE_ASYNC(src, PROC_REF(swordslam))
					ranged_cooldown += 3 SECONDS
				else
					INVOKE_ASYNC(src, PROC_REF(bone_knife_throw), target)
					ranged_cooldown += 1 SECONDS
		if(MARKED_ONE_SECOND_PHASE)
			if(prob(75))
				if(prob(80))
					if(prob(50) && (get_dist(src, target) <= spinning_range))
						INVOKE_ASYNC(src, PROC_REF(spinattack))
						INVOKE_ASYNC(src, PROC_REF(stomp))
						ranged_cooldown += 5 SECONDS
					else
						INVOKE_ASYNC(src, PROC_REF(swordslam))
						ranged_cooldown += 2 SECONDS
				else
					INVOKE_ASYNC(src, PROC_REF(bone_knife_throw), target)
					INVOKE_ASYNC(src, PROC_REF(teleport), target)
					ranged_cooldown += 2 SECONDS
			else
				INVOKE_ASYNC(src, PROC_REF(teleport), target)
				ranged_cooldown += 0.5 SECONDS
		if(MARKED_ONE_THIRD_PHASE)
			if(prob(70))
				if(prob(50))
					if(prob(30) && (get_dist(src, target) <= spinning_range))
						INVOKE_ASYNC(src, PROC_REF(spinattack))
						INVOKE_ASYNC(src, PROC_REF(stomp))
						ranged_cooldown += 4.5 SECONDS
					else
						INVOKE_ASYNC(src, PROC_REF(swordslam))
						ranged_cooldown += 2 SECONDS
				else
					INVOKE_ASYNC(src, PROC_REF(bone_knife_throw), target)
					INVOKE_ASYNC(src, PROC_REF(teleport), target)
					ranged_cooldown += 2 SECONDS
			else
				INVOKE_ASYNC(src, PROC_REF(bone_knife_throw), target)
				ranged_cooldown += 0.5 SECONDS
		if(MARKED_ONE_FINAL_PHASE)
			if(prob(50))
				if(prob(50))
					if(prob(25))
						INVOKE_ASYNC(src, PROC_REF(bone_knife_throw), target)
						INVOKE_ASYNC(src, PROC_REF(teleport), target)
						INVOKE_ASYNC(src, PROC_REF(stomp))
						ranged_cooldown += 2 SECONDS
					else
						INVOKE_ASYNC(src, PROC_REF(swordslam))
						ranged_cooldown += 2 SECONDS
				else
					INVOKE_ASYNC(src, PROC_REF(bone_knife_throw), target)
					INVOKE_ASYNC(src, PROC_REF(stomp))
					ranged_cooldown += 0.5 SECONDS
			else
				INVOKE_ASYNC(src, PROC_REF(teleport), target)
				INVOKE_ASYNC(src, PROC_REF(stomp))
				ranged_cooldown += 0.5 SECONDS

#undef MARKED_ONE_STUN_DURATION
#undef MARKED_ONE_ANGER_DURATION
#undef MARKED_ONE_FIRST_PHASE
#undef MARKED_ONE_SECOND_PHASE
#undef MARKED_ONE_THIRD_PHASE
#undef MARKED_ONE_FINAL_PHASE
#undef ONE_HUNDRED_PERCENT
#undef SEVENTY_FIVE_PERCENT
#undef FIFTY_PERCENT
#undef SHOWDOWN_PERCENT

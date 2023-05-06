/obj/item/organ/internal/ears
	name = "ears"
	icon_state = "ears"
	desc = "There are three parts to the ear. Inner, middle and outer. Only one of these parts should be normally visible."
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EARS
	visual = FALSE
	gender = PLURAL

	healing_factor = STANDARD_ORGAN_HEALING
	decay_factor = STANDARD_ORGAN_DECAY

	low_threshold_passed = "<span class='info'>Your ears begin to resonate with an internal ring sometimes.</span>"
	now_failing = "<span class='warning'>You are unable to hear at all!</span>"
	now_fixed = "<span class='info'>Noise slowly begins filling your ears once more.</span>"
	low_threshold_cleared = "<span class='info'>The ringing in your ears has died down.</span>"

	// `deaf` measures "ticks" of deafness. While > 0, the person is unable
	// to hear anything.
	var/deaf = 0

	// `damage` in this case measures long term damage to the ears, if too high,
	// the person will not have either `deaf` or `ear_damage` decrease
	// without external aid (earmuffs, drugs)

	//Resistance against loud noises
	var/bang_protect = 0
	// Multiplier for both long term and short term ear damage
	var/damage_multiplier = 1

/obj/item/organ/internal/ears/on_life(delta_time, times_fired)
	// only inform when things got worse, needs to happen before we heal
	if((damage > low_threshold && prev_damage < low_threshold) || (damage > high_threshold && prev_damage < high_threshold))
		to_chat(owner, span_warning("The ringing in your ears grows louder, blocking out any external noises for a moment."))

	. = ..()
	// if we have non-damage related deafness like mutations, quirks or clothing (earmuffs), don't bother processing here. Ear healing from earmuffs or chems happen elsewhere
	if(HAS_TRAIT_NOT_FROM(owner, TRAIT_DEAF, EAR_DAMAGE))
		return

	if((organ_flags & ORGAN_FAILING))
		deaf = max(deaf, 1) // if we're failing we always have at least 1 deaf stack (and thus deafness)
	else // only clear deaf stacks if we're not failing
		deaf = max(deaf - (0.5 * delta_time), 0)
		if((damage > low_threshold) && DT_PROB(damage / 60, delta_time))
			adjustEarDamage(0, 4)
			SEND_SOUND(owner, sound('sound/weapons/flash_ring.ogg'))

	if(deaf)
		ADD_TRAIT(owner, TRAIT_DEAF, EAR_DAMAGE)
	else
		REMOVE_TRAIT(owner, TRAIT_DEAF, EAR_DAMAGE)

/obj/item/organ/internal/ears/proc/adjustEarDamage(ddmg, ddeaf)
	if(owner.status_flags & GODMODE)
		return
	setOrganDamage(max(damage + (ddmg*damage_multiplier), 0))
	deaf = max(deaf + (ddeaf*damage_multiplier), 0)

/obj/item/organ/internal/ears/invincible
	damage_multiplier = 0

/obj/item/organ/internal/ears/cat
	name = "cat ears"
	icon = 'icons/obj/clothing/hats.dmi'
	icon_state = "kitty"
	visual = TRUE
	damage_multiplier = 2

/obj/item/organ/internal/ears/cat/Insert(mob/living/carbon/human/ear_owner, special = 0, drop_if_replaced = TRUE)
	. = ..()
	if(istype(ear_owner) && ear_owner.dna)
		color = ear_owner.hair_color
		ear_owner.dna.features["ears"] = ear_owner.dna.species.mutant_bodyparts["ears"] = "Cat"
		ear_owner.dna.update_uf_block(DNA_EARS_BLOCK)
		ear_owner.update_body()

/obj/item/organ/internal/ears/cat/Remove(mob/living/carbon/human/ear_owner,  special = 0)
	. = ..()
	if(istype(ear_owner) && ear_owner.dna)
		color = ear_owner.hair_color
		ear_owner.dna.species.mutant_bodyparts -= "ears"
		ear_owner.update_body()

/obj/item/organ/internal/ears/penguin
	name = "penguin ears"
	desc = "The source of a penguin's happy feet."

/obj/item/organ/internal/ears/penguin/Insert(mob/living/carbon/human/ear_owner, special = 0, drop_if_replaced = TRUE)
	. = ..()
	if(istype(ear_owner))
		to_chat(ear_owner, span_notice("You suddenly feel like you've lost your balance."))
		ear_owner.AddElement(/datum/element/waddling)

/obj/item/organ/internal/ears/penguin/Remove(mob/living/carbon/human/ear_owner,  special = 0)
	. = ..()
	if(istype(ear_owner))
		to_chat(ear_owner, span_notice("Your sense of balance comes back to you."))
		ear_owner.RemoveElement(/datum/element/waddling)

/obj/item/organ/internal/ears/bronze
	name = "tin ears"
	desc = "The robust ears of a bronze golem. "
	damage_multiplier = 0.1 //STRONK
	bang_protect = 1 //Fear me weaklings.

/obj/item/organ/internal/ears/cybernetic
	name = "cybernetic ears"
	icon_state = "ears-c"
	desc = "A basic cybernetic organ designed to mimic the operation of ears."
	damage_multiplier = 0.9
	organ_flags = ORGAN_SYNTHETIC

/obj/item/organ/internal/ears/cybernetic/upgraded
	name = "upgraded cybernetic ears"
	icon_state = "ears-c-u"
	desc = "An advanced cybernetic ear, surpassing the performance of organic ears."
	damage_multiplier = 0.5

/obj/item/organ/internal/ears/cybernetic/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	applyOrganDamage(40/severity)

#define SYNTH_BAD_EFFECT_DURATION 30 SECONDS
#define SYNTH_DEAF_STACKS 30
#define SYNTH_KNOCKDOWN_POWER 40
#define SYNTH_HEAVY_EMP_MULTIPLIER 2

/obj/item/organ/internal/ears/synth
	name = "auditory sensors"
	icon = 'icons/mob/species/synth/surgery.dmi'
	icon_state = "ears-ipc"
	desc = "A pair of microphones intended to be installed in an IPC head, that grant the ability to hear."
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EARS
	gender = PLURAL
	status = ORGAN_ROBOTIC
	organ_flags = ORGAN_SYNTHETIC

/obj/item/organ/internal/ears/synth/emp_act(severity)
	. = ..()

	if(!owner || . & EMP_PROTECT_SELF)
		return

	switch(severity)
		if(EMP_HEAVY)
			owner.set_jitter_if_lower(SYNTH_BAD_EFFECT_DURATION * SYNTH_HEAVY_EMP_MULTIPLIER)
			owner.set_dizzy_if_lower(SYNTH_BAD_EFFECT_DURATION * SYNTH_HEAVY_EMP_MULTIPLIER)
			owner.Knockdown(SYNTH_KNOCKDOWN_POWER * SYNTH_HEAVY_EMP_MULTIPLIER)
			adjustEarDamage(SYNTH_ORGAN_HEAVY_EMP_DAMAGE, SYNTH_DEAF_STACKS)
			to_chat(owner, span_warning("Your system reports a complete lack of input from your auditory sensors."))

		if(EMP_LIGHT)
			owner.set_jitter_if_lower(SYNTH_BAD_EFFECT_DURATION)
			owner.set_dizzy_if_lower(SYNTH_BAD_EFFECT_DURATION)
			owner.Knockdown(SYNTH_KNOCKDOWN_POWER)
			to_chat(owner, span_warning("Your system reports anomalous feedback from your auditory sensors."))

#undef SYNTH_BAD_EFFECT_DURATION
#undef SYNTH_DEAF_STACKS
#undef SYNTH_KNOCKDOWN_POWER
#undef SYNTH_HEAVY_EMP_MULTIPLIER

/datum/job/prisoner
	title = JOB_PRISONER
	description = "Keep yourself occupied in permabrig."
	department_head = list("The Security Team")
	supervisors = "the security team"
	selection_color = "#ffe1c3"
	exp_granted_type = EXP_TYPE_CREW
	paycheck = PAYCHECK_LOWER

	outfit = /datum/outfit/job/prisoner
	plasmaman_outfit = /datum/outfit/plasmaman/prisoner

	display_order = JOB_DISPLAY_ORDER_PRISONER
	department_for_prefs = /datum/job_department/security
	guestbook_flags = NONE

	exclusive_mail_goodies = TRUE
	mail_goodies = list (
		/obj/effect/spawner/random/contraband/prison = 1
	)

	family_heirlooms = list(/obj/item/pen/blue)
	rpg_title = "Defeated Miniboss"

/datum/job/prisoner/New()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_CREWMEMBER_JOINED, PROC_REF(add_pref_crime))

/datum/job/prisoner/proc/add_pref_crime(datum/source, mob/living/crewmember, rank)
	SIGNAL_HANDLER
	if(rank != title)
		return //not a prisoner

/datum/outfit/job/prisoner
	name = "Prisoner"
	jobtype = /datum/job/prisoner

	id = /obj/item/card/id/advanced/prisoner
	id_trim = /datum/id_trim/job/prisoner
	uniform = /obj/item/clothing/under/rank/prisoner
	belt = null
	ears = null
	shoes = /obj/item/clothing/shoes/sneakers/orange

/datum/outfit/job/prisoner/pre_equip(mob/living/carbon/human/H)
	..()
	if(prob(1)) // D BOYYYYSSSSS
		head = /obj/item/clothing/head/beanie/black/dboy

/datum/outfit/job/prisoner/post_equip(mob/living/carbon/human/new_prisoner, visualsOnly)
	. = ..()
	if(!length(SSpersistence.prison_tattoos_to_use) || visualsOnly)
		return
	var/obj/item/bodypart/tatted_limb = pick(new_prisoner.bodyparts)
	var/list/tattoo = pick(SSpersistence.prison_tattoos_to_use)
	tatted_limb.AddComponent(/datum/component/tattoo, tattoo["story"])
	SSpersistence.prison_tattoos_to_use -= tattoo

/datum/job/internal_affairs_agent
	title = JOB_INTERNAL_AFFAIRS_AGENT
	description = "Your job is to deal with affairs regarding Standard Operating Procedure. You are NOT in charge of Space Law affairs, nor can you override it. You are not a prisoner defence lawyer."
	department_head = list(JOB_CAPTAIN)
	faction = FACTION_STATION
	total_positions = 2
	spawn_positions = 2
	supervisors = SUPERVISOR_CAPTAIN
	selection_color = "#ccccff"
	exp_granted_type = EXP_TYPE_CREW

	outfit = /datum/outfit/job/internal_affairs_agent
	plasmaman_outfit = /datum/outfit/plasmaman/bar

	paycheck = PAYCHECK_CREW
	paycheck_department = ACCOUNT_SEC

	mind_traits = list(TRAIT_DONUT_LOVER)
	liver_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_INTERNAL_AFFAIRS_AGENT
	departments_list = list(
		/datum/job_department/command,
		)
	rpg_title = null
	family_heirlooms = list(/obj/item/pen/fountain, /obj/item/book/manual/wiki/security_space_law,)

	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN

/datum/outfit/job/internal_affairs_agent
	name = "Internal Affairs Agent"
	jobtype = /datum/job/internal_affairs_agent

	id = /obj/item/card/id/advanced/silver
	id_trim = /datum/id_trim/job/internal_affairs_agent
	uniform = /obj/item/clothing/under/suit/black_really
	belt = /obj/item/modular_computer/tablet/pda/internal_affairs_agent
	ears = /obj/item/radio/headset/headset_internalaffairs
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses
	shoes = /obj/item/clothing/shoes/laceup
	neck = /obj/item/clothing/neck/tie/red/tied
	l_pocket = /obj/item/laser_pointer
	r_pocket = /obj/item/clothing/accessory/lawyers_badge
	l_hand = /obj/item/storage/briefcase/lawyer

	implants = list(/obj/item/implant/mindshield)

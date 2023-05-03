/datum/job/pathfinder
	title = JOB_PATHFINDER
	description = "Be the resident deckhand, be crammed into a tiny shuttle, get blown up by the first overmap encounter."
	department_head = list(JOB_PATHFINDER_LEAD)
	faction = FACTION_STATION
	total_positions = 4
	spawn_positions = 4
	supervisors = SUPERVISOR_PL
	selection_color = COLOR_PATHFINDERS_PURPLE
	exp_requirements = 120 // Play a round as a station-goer before playing this, yes?
	exp_required_type = EXP_TYPE_CREW
	exp_granted_type = EXP_TYPE_CREW

	outfit = /datum/outfit/job/pathfinder

	paycheck = PAYCHECK_CREW
	paycheck_department = ACCOUNT_PTH

	liver_traits = list(TRAIT_PATHFINDER_METABOLISM) // In the future, bring some looted booze back in order to get some neat stuff from the bartender!

	display_order = JOB_DISPLAY_ORDER_PATHFINDER
	//bounty_types = CIV_JOB_PTH // These are going to be axed before launch, so I'm not bothering.
	departments_list = list(
		/datum/job_department/pathfinders,
		)

	family_heirlooms = list(/obj/item/clothing/head/hardhat, /obj/item/screwdriver, /obj/item/wrench, /obj/item/weldingtool, /obj/item/crowbar, /obj/item/wirecutters, /obj/item/storage/toolbox/mechanical/old/heirloom)

	mail_goodies = list(
		/obj/item/tank/internals = 1
	)
	rpg_title = "Orbiter"
	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN


/datum/outfit/job/pathfinder
	name = "Pathfinder"
	jobtype = /datum/job/pathfinder

	id_trim = /datum/id_trim/job/pathfinder
	uniform = /obj/item/clothing/under/rank/pathfinders
	ears = /obj/item/radio/headset/headset_pth
	shoes = /obj/item/clothing/shoes/jackboots
	belt = /obj/item/modular_computer/pda/pathfinder

	box = /obj/item/storage/box/survival/engineer

/datum/outfit/job/pathfinder/gloved
	name = "Pathfinder (Gloves)"

	gloves = /obj/item/clothing/gloves/color/yellow

/datum/outfit/job/pathfinder/mod
	name = "Pathfinder (MODsuit)"

	suit_store = /obj/item/tank/internals/oxygen
	back = /obj/item/mod/control/pre_equipped/pathfinders
	mask = /obj/item/clothing/mask/breath
	internals_slot = ITEM_SLOT_SUITSTORE

// These are mostly for admeme intervention efforts.
/datum/outfit/job/pathfinder/medic
	name = "Pathfinder Medic"

	gloves = /obj/item/clothing/gloves/color/latex
	backpack_contents = list(
		/obj/item/storage/medkit/pathfinder = 1
	)

/datum/outfit/job/pathfinder/medic/mod
	name = "Pathfinder Medic (MODsuit)"

	suit_store = /obj/item/tank/internals/oxygen
	back = /obj/item/mod/control/pre_equipped/pathfinders/medic
	mask = /obj/item/clothing/mask/breath
	internals_slot = ITEM_SLOT_SUITSTORE

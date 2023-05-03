/datum/job/pathfinder_lead
	title = JOB_PATHFINDER_LEAD
	description = "Be the captain that isn't actually the captain, and be the one who gets yelled at when there's no materials."
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD
	department_head = list(JOB_CAPTAIN)
	head_announce = list(RADIO_CHANNEL_PATHFINDERS)
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	supervisors = SUPERVISOR_CAPTAIN
	selection_color = COLOR_PATHFINDERS_PURPLE
	req_admin_notify = TRUE
	minimal_player_age = 7
	exp_requirements = 180
	exp_required_type = EXP_TYPE_CREW
	exp_required_type_department = EXP_TYPE_PATHFINDERS
	exp_granted_type = EXP_TYPE_CREW

	outfit = /datum/outfit/job/pathfinder_lead
	departments_list = list(
		/datum/job_department/pathfinders,
		/datum/job_department/command,
		)

	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_PTH

	liver_traits = list(TRAIT_PATHFINDER_METABOLISM, TRAIT_ROYAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_PATHFINDER_LEAD

	family_heirlooms = list(/obj/item/clothing/head/hardhat, /obj/item/screwdriver, /obj/item/wrench, /obj/item/weldingtool, /obj/item/crowbar, /obj/item/wirecutters, /obj/item/storage/toolbox/mechanical/old/heirloom)

	mail_goodies = list(
		/obj/item/stack/sheet/mineral/diamond = 15,
		/obj/item/stack/sheet/mineral/uranium/five = 15,
		/obj/item/stack/sheet/mineral/plasma/five = 15,
		/obj/item/stack/sheet/mineral/gold = 15,
		/obj/effect/spawner/random/ore = 3,
		/obj/effect/spawner/random/weapon/ammo = 6,
	)
	rpg_title = "Orbiter Captain"
	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_BOLD_SELECT_TEXT | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN

	voice_of_god_power = 1.4 //Command staff has authority

/datum/outfit/job/pathfinder_lead
	name = "Pathfinder Lead"
	jobtype = /datum/job/pathfinder_lead

	id_trim = /datum/id_trim/job/pathfinder_lead
	uniform = /obj/item/clothing/under/rank/pathfinder
	ears = /obj/item/radio/headset/heads/pl
	shoes = /obj/item/clothing/shoes/jackboots
	belt = /obj/item/modular_computer/pda/heads/pl
	backpack_contents = list(
		/obj/item/melee/baton/telescopic = 1,
	)

	box = /obj/item/storage/box/survival/engineer

/datum/outfit/job/pathfinder_lead/mod
	name = "Pathfinder (MODsuit)"

	suit_store = /obj/item/tank/internals/oxygen
	back = /obj/item/mod/control/pre_equipped/pathfinders
	mask = /obj/item/clothing/mask/breath
	internals_slot = ITEM_SLOT_SUITSTORE

/datum/id_trim/job/pathfinder_lead
	assignment = "Pathfinder Lead"
	intern_alt_name = "Honorary Pathfinder Lead"
	trim_state = "trim_virologist"
	orbit_icon = "anchor"
	department_color = COLOR_COMMAND_BLUE
	subdepartment_color = COLOR_PATHFINDERS_PURPLE
	department_state = "departmenthead"
	sechud_icon_state = SECHUD_PATHFINDER_LEAD
	extra_wildcard_access = list()
	minimal_access = list(
		ACCESS_BRIG_ENTRANCE,
		ACCESS_COMMAND,
		ACCESS_EVA,
		ACCESS_EXTERNAL_AIRLOCKS,
		ACCESS_KEYCARD_AUTH,
		ACCESS_MAINT_TUNNELS,
		ACCESS_PATHFINDERS,
		ACCESS_PATHFINDERS_DOCK,
		ACCESS_PATHFINDERS_LEAD,
		ACCESS_PATHFINDERS_STORAGE,
		)
	minimal_wildcard_access = list(
		ACCESS_PATHFINDERS_LEAD,
		)
	extra_access = list(
		ACCESS_MINERAL_STOREROOM,
		ACCESS_TECH_STORAGE,
		)
	template_access = list(
		ACCESS_CAPTAIN,
		ACCESS_CHANGE_IDS,
		)
	job = /datum/job/chief_engineer

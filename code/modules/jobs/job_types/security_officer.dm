/datum/job/security_officer
	title = JOB_SECURITY_OFFICER
	description = "Protect company assets, follow the Standard Operating \
		Procedure, eat donuts."
	auto_deadmin_role_flags = DEADMIN_POSITION_SECURITY
	department_head = list(JOB_HEAD_OF_SECURITY)
	faction = FACTION_STATION
	total_positions = 5 //Handled in /datum/controller/occupations/proc/setup_officer_positions()
	spawn_positions = 5 //Handled in /datum/controller/occupations/proc/setup_officer_positions()
	supervisors = "the Colonel"
	selection_color = "#ffeeee"
	minimal_player_age = 7
	exp_requirements = 300
	exp_required_type = EXP_TYPE_CREW
	exp_granted_type = EXP_TYPE_CREW

	outfit = /datum/outfit/job/security
	plasmaman_outfit = /datum/outfit/plasmaman/security

	paycheck = PAYCHECK_CREW
	paycheck_department = ACCOUNT_SEC

	mind_traits = list(TRAIT_DONUT_LOVER)
	liver_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_SECURITY_OFFICER
	bounty_types = CIV_JOB_SEC
	departments_list = list(
		/datum/job_department/security,
		)

	family_heirlooms = list(/obj/item/book/manual/wiki/security_space_law, /obj/item/clothing/head/beret/sec)

	mail_goodies = list(
		/obj/item/food/donut/caramel = 10,
		/obj/item/food/donut/matcha = 10,
		/obj/item/food/donut/blumpkin = 5,
		/obj/item/clothing/mask/whistle = 5,
		/obj/item/melee/baton/security/boomerang/loaded = 1
	)
	rpg_title = "Guard"
	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN

/datum/job/security_officer/proc/announce_latejoin(
	mob/officer,
	department,
	distribution,
)
	var/obj/machinery/announcement_system/announcement_system = pick(GLOB.announcement_systems)
	if (isnull(announcement_system))
		return

	announcement_system.announce_officer(officer, department)

	var/list/targets = list()

	var/list/partners = list()
	for (var/officer_ref in distribution)
		var/mob/partner = locate(officer_ref)
		if (!istype(partner) || distribution[officer_ref] != department)
			continue
		partners += partner.real_name

	if (partners.len)
		for(var/messenger_ref in GLOB.pda_messengers)
			var/datum/computer_file/program/messenger/messenger = GLOB.pda_messengers[messenger_ref]
			if(!(messenger.computer?.saved_identification in partners))
				continue
			targets += messenger

	if (!targets.len)
		return

	var/datum/signal/subspace/messaging/tablet_message/signal = new(announcement_system, list(
		"fakename" = "Security Department Update",
		"fakejob" = "Automated Announcement System",
		"message" = "Officer [officer.real_name] has been assigned to your department, [department].",
		"targets" = targets,
		"automated" = TRUE,
	))

	signal.send_to_receivers()

/datum/outfit/job/security
	name = "Security Officer"
	jobtype = /datum/job/security_officer

	id_trim = /datum/id_trim/job/security_officer
	uniform = /obj/item/clothing/under/rank/security/officer/white
	suit = /obj/item/clothing/suit/armor/vest/alt/sec
	suit_store = /obj/item/gun/energy/disabler
	backpack_contents = list(
		/obj/item/evidencebag = 1,
		)
	belt = /obj/item/modular_computer/pda/security
	ears = /obj/item/radio/headset/headset_sec/alt
	gloves = /obj/item/clothing/gloves/color/black
	head = /obj/item/clothing/head/helmet/sec
	shoes = /obj/item/clothing/shoes/jackboots/sec
	l_pocket = /obj/item/restraints/handcuffs
	r_pocket = /obj/item/assembly/flash/handheld

	backpack = /obj/item/storage/backpack/security
	satchel = /obj/item/storage/backpack/satchel/sec
	duffelbag = /obj/item/storage/backpack/duffelbag/sec

	box = /obj/item/storage/box/survival/security
	chameleon_extras = list(
		/obj/item/clothing/glasses/hud/security/sunglasses,
		/obj/item/clothing/head/helmet,
		/obj/item/gun/energy/disabler,
		)
		//The helmet is necessary because /obj/item/clothing/head/helmet/sec is overwritten in the chameleon list by the standard helmet, which has the same name and icon state
	implants = list(/obj/item/implant/mindshield)

/datum/outfit/job/security/mod
	name = "Security Officer (MODsuit)"

	suit_store = /obj/item/tank/internals/oxygen
	back = /obj/item/mod/control/pre_equipped/security
	suit = null
	head = null
	mask = /obj/item/clothing/mask/gas/sechailer
	internals_slot = ITEM_SLOT_SUITSTORE

/datum/outfit/job/security/hardsuit
	name = "Security Officer (Hardsuit)"

	head = null
	mask = /obj/item/clothing/mask/gas/sechailer
	suit = /obj/item/clothing/suit/space/hardsuit/security
	suit_store = /obj/item/tank/internals/oxygen
	internals_slot = ITEM_SLOT_SUITSTORE

/obj/item/radio/headset/headset_sec/alt/department/Initialize(mapload)
	. = ..()
	wires = new/datum/wires/radio(src)
	secure_radio_connections = list()
	recalculateChannels()

/obj/item/radio/headset/headset_sec/alt/department/engi
	keyslot = new /obj/item/encryptionkey/headset_sec
	keyslot2 = new /obj/item/encryptionkey/headset_eng

/obj/item/radio/headset/headset_sec/alt/department/supply
	keyslot = new /obj/item/encryptionkey/headset_sec
	keyslot2 = new /obj/item/encryptionkey/headset_cargo
/obj/item/radio/headset/headset_sec/alt/department/med
	keyslot = new /obj/item/encryptionkey/headset_sec
	keyslot2 = new /obj/item/encryptionkey/headset_med

/obj/item/radio/headset/headset_sec/alt/department/sci
	keyslot = new /obj/item/encryptionkey/headset_sec
	keyslot2 = new /obj/item/encryptionkey/headset_sci

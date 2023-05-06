/datum/outfit/job/atmos
	name = "Atmospheric Technician"
	jobtype = /datum/job/station_engineer

	id_trim = /datum/id_trim/job/station_engineer
	uniform = /obj/item/clothing/under/rank/engineering/atmospheric_technician
	belt = /obj/item/storage/belt/utility/atmostech
	ears = /obj/item/radio/headset/headset_eng
	l_pocket = /obj/item/modular_computer/pda/atmos
	r_pocket = /obj/item/analyzer

	backpack = /obj/item/storage/backpack/industrial
	satchel = /obj/item/storage/backpack/satchel/eng
	duffelbag = /obj/item/storage/backpack/duffelbag/engineering

	box = /obj/item/storage/box/survival/engineer
	pda_slot = ITEM_SLOT_LPOCKET

/datum/outfit/job/atmos/mod
	name = "Atmospheric Technician (MODsuit)"

	suit_store = /obj/item/tank/internals/oxygen
	back = /obj/item/mod/control/pre_equipped/atmospheric
	mask = /obj/item/clothing/mask/gas/atmos
	internals_slot = ITEM_SLOT_SUITSTORE

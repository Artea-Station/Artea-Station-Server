/// Dorms Room Papers
/obj/item/paper/fluff/ruins/waystation/menu
	name = "This week's food menu"
	default_raw_text = "Here is what Corporate sent us for this week, The usual.<BR><BR><B>Monday</B> - Pizza and Mac & Cheese<BR><B>Tuesday</B> - Space Carp Sashimi & Sushi<BR><B>ednesday</B> - Garlic-and-oil nizaya & Khinkali<BR><B>Thursday</B> - QM's birthday, Cake and a bunch of Pastries<BR><B>Friday</B> - Fish & Chips<BR><BR>Plus whatever kind of booze and food that the techies manage to \"accidentally\" steal from the crates (This is a reminder) -Cook"

/obj/item/paper/fluff/ruins/waystation/toilet
	name = "REMINDER!!"
	default_raw_text = "I already told you fucks verbally but none of you listened, Flush the goddamn toilet after you use it!<BR>I'm the only guy that cleans things around here and you need to appreciate it! -Grey"

/// Cargo Bay Paper
/obj/item/paper/fluff/ruins/waystation/sop
	name = "S.O.P Reminder"
	default_raw_text= "Quick reminder for the new SOP guidelines.<BR>Please remember to haul all security-locked crates and other high-value items into secure storage. I don't care if you steal from the other crates, that paperwork is on you. Just don't steal anything that would get all of us in trouble, alright?"

/// Vault Paper
/obj/item/paper/fluff/ruins/waystation/memo
	name = "Memo"
	default_raw_text= "Please keep the documents from the malfunctioning shuttle safe until someone picks it up. We really shouldn't have this kind of stuff on us."

// Outfits
/datum/outfit/waystation/
	name = "improper Waystation Outfit"

/datum/outfit/waystation/cargohauler
	name = "Waystation Cargo Hauler"
	id = /obj/item/card/id/advanced
	id_trim = /datum/id_trim/away/waystation/cargo_technician
	uniform = /obj/item/clothing/under/rank/cargo/tech
	belt = /obj/item/modular_computer/pda/cargo
	ears = /obj/item/radio/headset/headset_cargo

/datum/outfit/waystation/qm
	name = "Waystation Quartermaster"
	id = /obj/item/card/id/advanced/silver
	id_trim = /datum/id_trim/away/waystation/quartermaster
	uniform = /obj/item/clothing/under/rank/cargo/qm
	belt = /obj/item/modular_computer/pda/heads/quartermaster
	ears = /obj/item/radio/headset/headset_cargo
	glasses = /obj/item/clothing/glasses/sunglasses
	shoes = /obj/item/clothing/shoes/sneakers/brown

/datum/outfit/waystation/nanotrasenofficer
	name = "Waystation Security Officer"
	id = /obj/item/card/id/advanced
	id_trim = /datum/id_trim/away/waystation/security
	uniform = /obj/item/clothing/under/rank/security/officer
	suit = /obj/item/clothing/suit/armor/vest
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/tackler/combat
	mask = /obj/item/clothing/mask/gas/sechailer/swat
	head = /obj/item/clothing/head/helmet/swat/nanotrasen
	back = /obj/item/storage/backpack/security
	l_pocket = /obj/item/ammo_box/magazine/m45

// Corpse Spawner
/obj/effect/mob_spawn/corpse/human/waystation/cargo_technician
	name = "Waystation Cargo Hauler"
	outfit = /datum/outfit/waystation/cargohauler

/obj/effect/mob_spawn/corpse/human/waystation/quartermaster
	name = "Waystation Quartermaster"
	outfit = /datum/outfit/waystation/qm

/obj/effect/mob_spawn/corpse/human/waystation/nanotrasenofficer
	name = "Waystation Security Officer"
	outfit = /datum/outfit/waystation/nanotrasenofficer

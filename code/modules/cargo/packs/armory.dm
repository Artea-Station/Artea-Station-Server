//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Armory //////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/security/armory
	group = "Armory"
	access = ACCESS_ARMORY
	access_view = ACCESS_ARMORY
	crate_type = /obj/structure/closet/crate/secure/weapon

/datum/supply_pack/security/armory/bulletarmor
	name = "Bulletproof Armor Crate"
	desc = "Contains three sets of bulletproof armor. Guaranteed to reduce a bullet's stopping power by over half. Requires Armory access to open."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/clothing/suit/armor/bulletproof,
					/obj/item/clothing/suit/armor/bulletproof,
					/obj/item/clothing/suit/armor/bulletproof)
	crate_name = "bulletproof armor crate"

/datum/supply_pack/security/armory/bullethelmets
	name = "Bulletproof Helmets Crate"
	desc = "Contains three bulletproof helmets. Requires Armory access to open."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/clothing/head/helmet/alt,
					/obj/item/clothing/head/helmet/alt,
					/obj/item/clothing/head/helmet/alt)
	crate_name = "bulletproof helmets crate"

/datum/supply_pack/security/armory/chemimp
	name = "Chemical Implants Crate"
	desc = "Contains five Remote Chemical implants. Requires Armory access to open."
	cost = CARGO_CRATE_VALUE * 3.5
	contains = list(/obj/item/storage/box/chemimp)
	crate_name = "chemical implant crate"

/datum/supply_pack/security/armory/ballistic
	name = "Combat Shotguns Crate"
	desc = "For when the enemy absolutely needs to be replaced with lead. Contains three Aussec-designed Combat Shotguns, and three Shotgun Bandoliers. Requires Armory access to open."
	cost = CARGO_CRATE_VALUE * 17.5
	contains = list(/obj/item/gun/ballistic/shotgun/automatic/combat,
					/obj/item/gun/ballistic/shotgun/automatic/combat,
					/obj/item/gun/ballistic/shotgun/automatic/combat,
					/obj/item/storage/belt/bandolier,
					/obj/item/storage/belt/bandolier,
					/obj/item/storage/belt/bandolier)
	crate_name = "combat shotguns crate"

/datum/supply_pack/security/armory/dragnet
	name = "DRAGnet Crate"
	desc = "Contains three \"Dynamic Rapid-Apprehension of the Guilty\" netting devices, a recent breakthrough in law enforcement prisoner management technology. Requires armory access to open."
	cost = CARGO_CRATE_VALUE * 5
	contains = list(/obj/item/gun/energy/e_gun/dragnet,
					/obj/item/gun/energy/e_gun/dragnet,
					/obj/item/gun/energy/e_gun/dragnet)
	crate_name = "\improper DRAGnet crate"

/datum/supply_pack/security/armory/energy
	name = "Energy Guns Crate"
	desc = "Contains two Energy Guns, capable of firing both nonlethal and lethal blasts of light. Requires Armory access to open."
	cost = CARGO_CRATE_VALUE * 18
	contains = list(/obj/item/gun/energy/e_gun,
					/obj/item/gun/energy/e_gun)
	crate_name = "energy gun crate"
	crate_type = /obj/structure/closet/crate/secure/plasma

/datum/supply_pack/security/armory/exileimp
	name = "Exile Implants Crate"
	desc = "Contains five Exile implants. Requires Armory access to open."
	cost = CARGO_CRATE_VALUE * 3.5
	contains = list(/obj/item/storage/box/exileimp)
	crate_name = "exile implant crate"

/datum/supply_pack/security/armory/fire
	name = "Incendiary Weapons Crate"
	desc = "Burn, baby burn. Contains three incendiary grenades, three plasma canisters, and a flamethrower. Requires Armory access to open."
	cost = CARGO_CRATE_VALUE * 7
	access = ACCESS_COMMAND
	contains = list(/obj/item/flamethrower/full,
					/obj/item/tank/internals/plasma,
					/obj/item/tank/internals/plasma,
					/obj/item/tank/internals/plasma,
					/obj/item/grenade/chem_grenade/incendiary,
					/obj/item/grenade/chem_grenade/incendiary,
					/obj/item/grenade/chem_grenade/incendiary)
	crate_name = "incendiary weapons crate"
	crate_type = /obj/structure/closet/crate/secure/plasma
	dangerous = TRUE

/datum/supply_pack/security/armory/mindshield
	name = "Mindshield Implants Crate"
	desc = "Prevent against radical thoughts with three Mindshield implants. Requires Armory access to open."
	cost = CARGO_CRATE_VALUE * 6
	contains = list(/obj/item/storage/lockbox/loyalty)
	crate_name = "mindshield implant crate"

/datum/supply_pack/security/armory/trackingimp
	name = "Tracking Implants Crate"
	desc = "Contains four tracking implants and three tracking speedloaders of tracing .38 ammo. Requires Armory access to open."
	cost = CARGO_CRATE_VALUE * 4.5
	contains = list(/obj/item/storage/box/trackimp,
					/obj/item/ammo_box/c38/trac,
					/obj/item/ammo_box/c38/trac,
					/obj/item/ammo_box/c38/trac)
	crate_name = "tracking implant crate"

/datum/supply_pack/security/armory/laserarmor
	name = "Reflector Vest Crate"
	desc = "Contains two vests of highly reflective material. Each armor piece diffuses a laser's energy by over half, as well as offering a good chance to reflect the laser entirely. Requires Armory access to open."
	cost = CARGO_CRATE_VALUE * 5
	contains = list(/obj/item/clothing/suit/armor/laserproof,
					/obj/item/clothing/suit/armor/laserproof)
	crate_name = "reflector vest crate"
	crate_type = /obj/structure/closet/crate/secure/plasma

/datum/supply_pack/security/armory/riotarmor
	name = "Riot Armor Crate"
	desc = "Contains three sets of heavy body armor. Advanced padding protects against close-ranged weaponry, making melee attacks feel only half as potent to the user. Requires Armory access to open."
	cost = CARGO_CRATE_VALUE * 6
	contains = list(/obj/item/clothing/suit/armor/riot,
					/obj/item/clothing/suit/armor/riot,
					/obj/item/clothing/suit/armor/riot)
	crate_name = "riot armor crate"

/datum/supply_pack/security/armory/riothelmets
	name = "Riot Helmets Crate"
	desc = "Contains three riot helmets. Requires Armory access to open."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/obj/item/clothing/head/helmet/riot,
					/obj/item/clothing/head/helmet/riot,
					/obj/item/clothing/head/helmet/riot)
	crate_name = "riot helmets crate"

/datum/supply_pack/security/armory/riotshields
	name = "Riot Shields Crate"
	desc = "For when the greytide gets really uppity. Contains three riot shields. Requires Armory access to open."
	cost = CARGO_CRATE_VALUE * 5
	contains = list(/obj/item/shield/riot,
					/obj/item/shield/riot,
					/obj/item/shield/riot)
	crate_name = "riot shields crate"

/datum/supply_pack/security/armory/russian
	name = "Russian Surplus Crate"
	desc = "Hello Comrade, we have the most modern russian military equipment the black market can offer, for the right price of course. Sadly we couldnt remove the lock so it requires Armory access to open."
	cost = CARGO_CRATE_VALUE * 12
	contraband = TRUE
	contains = list(/obj/item/food/rationpack,
					/obj/item/ammo_box/a762,
					/obj/item/storage/toolbox/ammo,
					/obj/item/storage/toolbox/maint_kit,
					/obj/item/clothing/suit/armor/vest/russian,
					/obj/item/clothing/head/helmet/rus_helmet,
					/obj/item/clothing/shoes/russian,
					/obj/item/clothing/gloves/tackler/combat,
					/obj/item/clothing/under/syndicate/rus_army,
					/obj/item/clothing/under/costume/soviet,
					/obj/item/clothing/mask/russian_balaclava,
					/obj/item/clothing/head/helmet/rus_ushanka,
					/obj/item/clothing/suit/armor/vest/russian_coat,
					/obj/item/gun/ballistic/rifle/boltaction,
					/obj/item/gun/ballistic/rifle/boltaction)
	crate_name = "surplus military crate"

/datum/supply_pack/security/armory/russian/fill(obj/structure/closet/crate/C)
	for(var/i in 1 to 10)
		var/item = pick(contains)
		new item(C)

/datum/supply_pack/security/armory/swat
	name = "SWAT Crate"
	desc = "Contains two fullbody sets of tough, fireproof suits designed in a joint effort by IS-ERI and Nanotrasen. Each set contains a suit, helmet, mask, combat belt, and combat gloves. Requires Armory access to open."
	cost = CARGO_CRATE_VALUE * 7
	contains = list(/obj/item/clothing/head/helmet/swat/nanotrasen,
					/obj/item/clothing/head/helmet/swat/nanotrasen,
					/obj/item/clothing/suit/armor/swat,
					/obj/item/clothing/suit/armor/swat,
					/obj/item/clothing/mask/gas/sechailer/swat,
					/obj/item/clothing/mask/gas/sechailer/swat,
					/obj/item/storage/belt/military/assault,
					/obj/item/storage/belt/military/assault,
					/obj/item/clothing/gloves/tackler/combat,
					/obj/item/clothing/gloves/tackler/combat)
	crate_name = "swat crate"

/datum/supply_pack/security/armory/thermal
	name = "Thermal Pistol Crate"
	desc = "Contains a pair of holsters each with two experimental thermal pistols, using nanites as the basis for their ammo. Requires Armory access to open."
	cost = CARGO_CRATE_VALUE * 7
	contains = list(/obj/item/storage/belt/holster/thermal,
					/obj/item/storage/belt/holster/thermal)
	crate_name = "thermal pistol crate"

/datum/supply_pack/security/armory/hardsuit_security
	name = "Security Hardsuit Crate"
	desc = "Contains a single security hardsuit used for space travel!"
	cost = CARGO_CRATE_VALUE * 5
	access = ACCESS_SECURITY
	contains = list(/obj/item/clothing/suit/space/hardsuit/security)
	crate_name = "security hardsuit crate"

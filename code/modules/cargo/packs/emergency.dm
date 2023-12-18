//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Emergency ///////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/emergency
	group = "Emergency"

/datum/supply_pack/emergency/vehicle
	name = "Biker Gang Kit" //TUNNEL SNAKES OWN THIS TOWN
	desc = "TUNNEL SNAKES OWN THIS TOWN. Contains an unbranded All Terrain Vehicle, and a complete gang outfit -- consists of black gloves, a menacing skull bandanna, and a SWEET leather overcoat!"
	cost = CARGO_CRATE_VALUE * 4
	contraband = TRUE
	contains = list(/obj/vehicle/ridden/atv,
					/obj/item/key/atv,
					/obj/item/clothing/suit/jacket/leather/overcoat,
					/obj/item/clothing/gloves/color/black,
					/obj/item/clothing/head/soft,
					/obj/item/clothing/mask/bandana/skull/black)//so you can properly #cargoniabikergang
	container_name = "biker kit"
	container_type = /obj/structure/closet/crate/large

/datum/supply_pack/emergency/bio
	name = "Biological Emergency Crate"
	desc = "This crate holds 2 full bio suits which will protect you from viruses."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/clothing/head/bio_hood,
					/obj/item/clothing/head/bio_hood,
					/obj/item/clothing/suit/bio_suit,
					/obj/item/clothing/suit/bio_suit,
					/obj/item/storage/bag/bio,
					/obj/item/reagent_containers/syringe/antiviral,
					/obj/item/reagent_containers/syringe/antiviral,
					/obj/item/clothing/gloves/color/latex/nitrile,
					/obj/item/clothing/gloves/color/latex/nitrile)
	container_name = "bio suit crate"
	galactic_import = TRUE

/datum/supply_pack/emergency/equipment
	name = "Emergency Bot/Internals Crate"
	desc = "Explosions got you down? These supplies are guaranteed to patch up holes, in stations and people alike! Comes with two floorbots, two medbots, five oxygen masks and five small oxygen tanks."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/mob/living/simple_animal/bot/floorbot,
					/mob/living/simple_animal/bot/floorbot,
					/mob/living/simple_animal/bot/medbot,
					/mob/living/simple_animal/bot/medbot,
					/obj/item/tank/internals/emergency_oxygen,
					/obj/item/tank/internals/emergency_oxygen,
					/obj/item/tank/internals/emergency_oxygen,
					/obj/item/tank/internals/emergency_oxygen,
					/obj/item/tank/internals/emergency_oxygen,
					/obj/item/clothing/mask/breath,
					/obj/item/clothing/mask/breath,
					/obj/item/clothing/mask/breath,
					/obj/item/clothing/mask/breath,
					/obj/item/clothing/mask/breath)
	container_name = "emergency crate"
	container_type = /obj/structure/closet/crate/internals

/datum/supply_pack/emergency/bomb
	name = "Explosive Emergency Crate"
	desc = "Science gone bonkers? Beeping behind the airlock? Buy now and be the hero the station des... I mean needs! (time not included)"
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/clothing/head/bomb_hood,
					/obj/item/clothing/suit/utility/bomb_suit,
					/obj/item/clothing/mask/gas,
					/obj/item/screwdriver,
					/obj/item/wirecutters,
					/obj/item/multitool)
	container_name = "bomb suit crate"
	galactic_import = TRUE

/datum/supply_pack/emergency/firefighting
	name = "Firefighting Crate"
	desc = "Only you can prevent station fires. Partner up with two firefighter suits, gas masks, flashlights, large oxygen tanks, extinguishers, and hardhats!"
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/clothing/suit/utility/fire/firefighter,
					/obj/item/clothing/suit/utility/fire/firefighter,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/gas,
					/obj/item/flashlight,
					/obj/item/flashlight,
					/obj/item/tank/internals/oxygen/red,
					/obj/item/tank/internals/oxygen/red,
					/obj/item/extinguisher/advanced,
					/obj/item/extinguisher/advanced,
					/obj/item/clothing/head/hardhat/red,
					/obj/item/clothing/head/hardhat/red)
	container_name = "firefighting crate"
	galactic_import = TRUE

/datum/supply_pack/emergency/atmostank
	name = "Firefighting Tank Backpack"
	desc = "Mow down fires with this high-capacity fire fighting tank backpack."
	cost = CARGO_CRATE_VALUE * 1.8
	access = ACCESS_ATMOSPHERICS
	contains = list(/obj/item/watertank/atmos)
	container_name = "firefighting backpack crate"
	container_type = /obj/structure/closet/crate/secure

/datum/supply_pack/emergency/internals
	name = "Internals Crate"
	desc = "Master your life energy and control your breathing with three breath masks, three emergency oxygen tanks and three large air tanks."//IS THAT A
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/breath,
					/obj/item/clothing/mask/breath,
					/obj/item/clothing/mask/breath,
					/obj/item/tank/internals/emergency_oxygen,
					/obj/item/tank/internals/emergency_oxygen,
					/obj/item/tank/internals/emergency_oxygen,
					/obj/item/tank/internals/oxygen,
					/obj/item/tank/internals/oxygen,
					/obj/item/tank/internals/oxygen)
	container_name = "internals crate"
	container_type = /obj/structure/closet/crate/internals
	galactic_import = TRUE

/datum/supply_pack/emergency/metalfoam
	name = "Metal Foam Grenade Crate"
	desc = "Seal up those pesky hull breaches with 7 Metal Foam Grenades."
	cost = CARGO_CRATE_VALUE * 2.4
	contains = list(/obj/item/storage/box/metalfoam)
	container_name = "metal foam grenade crate"

/datum/supply_pack/emergency/radiation
	name = "Radiation Protection Crate"
	desc = "Survive the Nuclear Apocalypse and Supermatter Engine alike with two sets of Radiation suits. Each set contains a helmet, suit, and Geiger counter. We'll even throw in a bottle of vodka and some glasses too, considering the life-expectancy of people who order this."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/clothing/head/radiation,
					/obj/item/clothing/head/radiation,
					/obj/item/clothing/suit/utility/radiation,
					/obj/item/clothing/suit/utility/radiation,
					/obj/item/geiger_counter,
					/obj/item/geiger_counter,
					/obj/item/reagent_containers/cup/glass/bottle/vodka,
					/obj/item/reagent_containers/cup/glass/drinkingglass/shotglass,
					/obj/item/reagent_containers/cup/glass/drinkingglass/shotglass)
	container_name = "radiation protection crate"
	container_type = /obj/structure/closet/crate/radiation

/datum/supply_pack/emergency/spacesuit
	name = "Space Suit Crate"
	desc = "Contains one aging suit from Space-Goodwill and a jetpack."
	cost = CARGO_CRATE_VALUE * 3
	access = ACCESS_EVA
	contains = list(/obj/item/clothing/suit/space,
					/obj/item/clothing/head/helmet/space,
					/obj/item/clothing/mask/breath,
					/obj/item/tank/jetpack/carbondioxide)
	container_name = "space suit crate"
	container_type = /obj/structure/closet/crate/secure
	galactic_import = TRUE

/datum/supply_pack/emergency/specialops
	name = "Special Ops Supplies"
	desc = "(*!&@#SAD ABOUT THAT NULL_ENTRY, HUH OPERATIVE? WELL, THIS LITTLE ORDER CAN STILL HELP YOU OUT IN A PINCH. CONTAINS A BOX OF FIVE EMP GRENADES, THREE SMOKEBOMBS, AN INCENDIARY GRENADE, AND A \"SLEEPY PEN\" FULL OF NICE TOXINS!#@*$"
	hidden = TRUE
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/obj/item/storage/box/emps,
					/obj/item/grenade/smokebomb,
					/obj/item/grenade/smokebomb,
					/obj/item/grenade/smokebomb,
					/obj/item/pen/sleepy,
					/obj/item/grenade/chem_grenade/incendiary)
	container_name = "emergency crate"
	container_type = /obj/structure/closet/crate/internals

/datum/supply_pack/emergency/weedcontrol
	name = "Weed Control Crate"
	desc = "Keep those invasive species OUT. Contains a scythe, gasmask, and two anti-weed chemical grenades. Warranty void if used on ambrosia."
	cost = CARGO_CRATE_VALUE * 2.5
	access = ACCESS_HYDROPONICS
	contains = list(/obj/item/scythe,
					/obj/item/clothing/mask/gas,
					/obj/item/grenade/chem_grenade/antiweed,
					/obj/item/grenade/chem_grenade/antiweed)
	container_name = "weed control crate"
	container_type = /obj/structure/closet/crate/secure/hydroponics
	galactic_import = TRUE

/datum/supply_pack/emergency/mothic_rations
	name = "Surplus Mothic Rations Triple-Pak"
	desc = "Crew starving? Chef slacking off? Keep everyone fed on the barest minimum of what can be considered food with surplus ration packs, directly from the Mothic Fleet! Pack includes 3 packs of 3 bars each."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/storage/box/mothic_rations,
					/obj/item/storage/box/mothic_rations,
					/obj/item/storage/box/mothic_rations,)
	container_name = "surplus rations box"
	container_type = /obj/structure/closet/crate/cardboard/mothic
	galactic_import = TRUE

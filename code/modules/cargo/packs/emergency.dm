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
	crate_name = "biker kit"
	crate_type = /obj/structure/closet/crate/large

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
	crate_name = "bio suit crate"

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
	crate_name = "emergency crate"
	crate_type = /obj/structure/closet/crate/internals

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
	crate_name = "bomb suit crate"

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
	crate_name = "firefighting crate"

/datum/supply_pack/emergency/atmostank
	name = "Firefighting Tank Backpack"
	desc = "Mow down fires with this high-capacity fire fighting tank backpack. Requires Atmospherics access to open."
	cost = CARGO_CRATE_VALUE * 1.8
	access = ACCESS_ATMOSPHERICS
	contains = list(/obj/item/watertank/atmos)
	crate_name = "firefighting backpack crate"
	crate_type = /obj/structure/closet/crate/secure

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
	crate_name = "internals crate"
	crate_type = /obj/structure/closet/crate/internals

/datum/supply_pack/emergency/metalfoam
	name = "Metal Foam Grenade Crate"
	desc = "Seal up those pesky hull breaches with 7 Metal Foam Grenades."
	cost = CARGO_CRATE_VALUE * 2.4
	contains = list(/obj/item/storage/box/metalfoam)
	crate_name = "metal foam grenade crate"

/datum/supply_pack/emergency/plasma_spacesuit
	name = "Plasmaman Space Envirosuits"
	desc = "Contains two space-worthy envirosuits for Plasmamen. Order now and we'll throw in two free helmets! Requires EVA access to open."
	cost = CARGO_CRATE_VALUE * 3.5
	access = ACCESS_EVA
	contains = list(/obj/item/clothing/suit/space/eva/plasmaman,
					/obj/item/clothing/suit/space/eva/plasmaman,
					/obj/item/clothing/head/helmet/space/plasmaman,
					/obj/item/clothing/head/helmet/space/plasmaman)
	crate_name = "plasmaman EVA crate"
	crate_type = /obj/structure/closet/crate/secure

/datum/supply_pack/emergency/plasmaman
	name = "Plasmaman Supply Kit"
	desc = "Keep those Plasmamen alive with two sets of Plasmaman outfits. Each set contains a plasmaman jumpsuit, gloves, internals tank, and helmet."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/clothing/under/plasmaman,
					/obj/item/clothing/under/plasmaman,
					/obj/item/tank/internals/plasmaman/belt/full,
					/obj/item/tank/internals/plasmaman/belt/full,
					/obj/item/clothing/head/helmet/space/plasmaman,
					/obj/item/clothing/head/helmet/space/plasmaman,
					/obj/item/clothing/gloves/color/plasmaman,
					/obj/item/clothing/gloves/color/plasmaman)
	crate_name = "plasmaman supply kit"

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
	crate_name = "radiation protection crate"
	crate_type = /obj/structure/closet/crate/radiation

/datum/supply_pack/emergency/spacesuit
	name = "Space Suit Crate"
	desc = "Contains one aging suit from Space-Goodwill and a jetpack. Requires EVA access to open."
	cost = CARGO_CRATE_VALUE * 3
	access = ACCESS_EVA
	contains = list(/obj/item/clothing/suit/space,
					/obj/item/clothing/head/helmet/space,
					/obj/item/clothing/mask/breath,
					/obj/item/tank/jetpack/carbondioxide)
	crate_name = "space suit crate"
	crate_type = /obj/structure/closet/crate/secure

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
	crate_name = "emergency crate"
	crate_type = /obj/structure/closet/crate/internals

/datum/supply_pack/emergency/weedcontrol
	name = "Weed Control Crate"
	desc = "Keep those invasive species OUT. Contains a scythe, gasmask, and two anti-weed chemical grenades. Warranty void if used on ambrosia. Requires Hydroponics access to open."
	cost = CARGO_CRATE_VALUE * 2.5
	access = ACCESS_HYDROPONICS
	contains = list(/obj/item/scythe,
					/obj/item/clothing/mask/gas,
					/obj/item/grenade/chem_grenade/antiweed,
					/obj/item/grenade/chem_grenade/antiweed)
	crate_name = "weed control crate"
	crate_type = /obj/structure/closet/crate/secure/hydroponics

/datum/supply_pack/emergency/mothic_rations
	name = "Surplus Mothic Rations Triple-Pak"
	desc = "Crew starving? Chef slacking off? Keep everyone fed on the barest minimum of what can be considered food with surplus ration packs, directly from the Mothic Fleet! Pack includes 3 packs of 3 bars each."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/storage/box/mothic_rations,
					/obj/item/storage/box/mothic_rations,
					/obj/item/storage/box/mothic_rations,)
	crate_name = "surplus rations box"
	crate_type = /obj/structure/closet/crate/cardboard/mothic

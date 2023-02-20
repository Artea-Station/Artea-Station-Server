/*
*	EMERGENCY RACIAL EQUIPMENT
*/

/datum/supply_pack/goody/airsuppliesnitrogen
	name = "Emergency Air Supplies (Nitrogen)"
	desc = "A vox breathing mask and nitrogen tank."
	cost = PAYCHECK_CREW
	contains = list(
		/obj/item/tank/internals/nitrogen/belt,
		/obj/item/clothing/mask/breath/vox,
	)

/datum/supply_pack/goody/airsuppliesoxygen
	name = "Emergency Air Supplies (Oxygen)"
	desc = "A breathing mask and emergency oxygen tank."
	cost = PAYCHECK_CREW
	contains = list(
		/obj/item/tank/internals/emergency_oxygen,
		/obj/item/clothing/mask/breath,
	)

/datum/supply_pack/goody/airsuppliesplasma
	name = "Emergency Air Supplies (Plasma)"
	desc = "A breathing mask and plasmaman plasma tank."
	cost = PAYCHECK_CREW
	contains = list(
		/obj/item/tank/internals/plasmaman/belt,
		/obj/item/clothing/mask/breath,
	)

/*
*	ENGINEERING STUFF
*/

/datum/supply_pack/goody/improvedrcd
	name = "Improved RCD"
	desc = "An upgraded RCD featuring superior material storage. Comes with complimentary frames and circuitry upgrades to boot!"
	cost = PAYCHECK_CREW * 38
	contains = list(/obj/item/construction/rcd/improved)

/*
*	MISC
*/

/datum/supply_pack/goody/crayons
	name = "Box of Crayons"
	desc = "Colorful!"
	cost = PAYCHECK_CREW * 2
	contains = list(/obj/item/storage/crayons)

/datum/supply_pack/goody/diamondring
	name = "Diamond Ring"
	desc = "Show them your love is like a diamond: unbreakable and everlasting. No refunds."
	cost = PAYCHECK_CREW * 50
	contains = list(/obj/item/storage/fancy/ringbox/diamond)
	crate_name = "diamond ring crate"

/datum/supply_pack/goody/paperbin
	name = "Paper Bin"
	desc = "Pushing paperwork is always easier when you have paper to push!"
	cost = PAYCHECK_CREW * 4
	contains = list(/obj/item/paper_bin)

/datum/supply_pack/goody/nri_rations
	name = "Surplus NRI Combat Ration"
	desc = "A single surplus ration pack from the NRI Defense Collegium. Comes with a standard-issue selection of food selected and approved by at least one Imperial regiment."
	cost = PAYCHECK_COMMAND * 2 //Less nourishing than the mothic one but you get cigarettes and wo'oh.
	contains = list(/obj/item/storage/box/nri_rations)

/*
*	WEAPONS / AMMO
*/

/datum/supply_pack/goody/gunmaint
	name = "Gun Maintenance Kits"
	desc = "Keep your pa's rifle in best condition, with two sets of cleaning supplies. Or your standard issue pistol if you're an itchy trigger, we're not here to judge."
	cost = PAYCHECK_CREW * 3
	contains = list(
		/obj/item/gun_maintenance_supplies,
		/obj/item/gun_maintenance_supplies,
	)

/*
*	CARPET PACKS
*/

/datum/supply_pack/goody/carpet
	name = "Classic Carpet Single-Pack"
	desc = "Plasteel floor tiles getting on your nerves? This 50 units stack of extra soft carpet will tie any room together."
	cost = PAYCHECK_CREW * 3
	contains = list(/obj/item/stack/tile/carpet/fifty)

/datum/supply_pack/goody/carpet/black
	name = "Black Carpet Single-Pack"
	contains = list(/obj/item/stack/tile/carpet/black/fifty)

/datum/supply_pack/goody/carpet/premium
	name = "Royal Black Carpet Single-Pack"
	desc = "Exotic carpets for all your decorating needs. This 50 unit stack of extra soft carpet will tie any room together."
	cost = PAYCHECK_CREW * 3.5
	contains = list(/obj/item/stack/tile/carpet/royalblack/fifty)

/datum/supply_pack/goody/carpet/premium/royalblue
	name = "Royal Blue Carpet Single-Pack"
	contains = list(/obj/item/stack/tile/carpet/royalblue/fifty)

/datum/supply_pack/goody/carpet/premium/red
	name = "Red Carpet Single-Pack"
	contains = list(/obj/item/stack/tile/carpet/red/fifty)

/datum/supply_pack/goody/carpet/premium/purple
	name = "Purple Carpet Single-Pack"
	contains = list(/obj/item/stack/tile/carpet/purple/fifty)

/datum/supply_pack/goody/carpet/premium/orange
	name = "Orange Carpet Single-Pack"
	contains = list(/obj/item/stack/tile/carpet/orange/fifty)

/datum/supply_pack/goody/carpet/premium/green
	name = "Green Carpet Single-Pack"
	contains = list(/obj/item/stack/tile/carpet/green/fifty)

/datum/supply_pack/goody/carpet/premium/cyan
	name = "Cyan Carpet Single-Pack"
	contains = list(/obj/item/stack/tile/carpet/cyan/fifty)

/datum/supply_pack/goody/carpet/premium/blue
	name = "Blue Carpet Single-Pack"
	contains = list(/obj/item/stack/tile/carpet/blue/fifty)

/*
*	MEDICAL STUFF
*/


/datum/supply_pack/goody/afad
	name = "Automated First Aid Device"
	desc = "Someone mildly hurt and it's too much of a bother to manually handle their burns or cuts? Look no further than the AFAD, a state-of-the-art pain-relief device!"
	cost = PAYCHECK_CREW * 40
	contains = list(/obj/item/gun/medbeam/afad)

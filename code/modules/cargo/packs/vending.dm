//////////////////////////////////////////////////////////////////////////////
/////////////////////// General Vending Restocks /////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/vending
	group = "Vending Restocks"

/datum/supply_pack/vending/bartending
	name = "Booze-o-mat and Coffee Supply Crate"
	desc = "Bring on the booze and coffee vending machine refills."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/obj/item/vending_refill/boozeomat,
					/obj/item/vending_refill/coffee)
	container_name = "bartending supply crate"

/datum/supply_pack/vending/cigarette
	name = "Cigarette Supply Crate"
	desc = "Don't believe the reports - smoke today! Contains a cigarette vending machine refill."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/vending_refill/cigarette)
	container_name = "cigarette supply crate"
	container_type = /obj/structure/closet/crate

/datum/supply_pack/vending/dinnerware
	name = "Dinnerware Supply Crate"
	desc = "More knives for the chef."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/vending_refill/dinnerware)
	container_name = "dinnerware supply crate"

/datum/supply_pack/vending/science/modularpc
	name = "Deluxe Silicate Selections Restock"
	desc = "What's a computer? Contains a Deluxe Silicate Selections restocking unit."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/vending_refill/modularpc)
	container_name = "computer supply crate"

/datum/supply_pack/vending/engivend
	name = "EngiVend Supply Crate"
	desc = "The engineers are out of metal foam grenades? This should help."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/vending_refill/engivend)
	container_name = "engineering supply crate"

/datum/supply_pack/vending/games
	name = "Games Supply Crate"
	desc = "Get your game on with this game vending machine refill."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/vending_refill/games)
	container_name = "games supply crate"
	container_type = /obj/structure/closet/crate

/datum/supply_pack/vending/hydro_refills
	name = "Hydroponics Vending Machines Refills"
	desc = "When the clown takes all the banana seeds. Contains a NutriMax refill and a MegaSeed Servitor refill."
	cost = CARGO_CRATE_VALUE * 4
	container_type = /obj/structure/closet/crate
	contains = list(/obj/item/vending_refill/hydroseeds,
					/obj/item/vending_refill/hydronutrients)
	container_name = "hydroponics supply crate"

/datum/supply_pack/vending/imported
	name = "Imported Vending Machines"
	desc = "Vending machines famous in other parts of the galaxy."
	cost = CARGO_CRATE_VALUE * 8
	contains = list(/obj/item/vending_refill/sustenance,
					/obj/item/vending_refill/robotics,
					/obj/item/vending_refill/sovietsoda,
					/obj/item/vending_refill/engineering)
	container_name = "unlabeled supply crate"

/datum/supply_pack/vending/medical
	name = "Medical Vending Crate"
	desc = "Contains one NanoMed Plus refill, one NanoDrug Plus refill, and one wall-mounted NanoMed refill."
	cost = CARGO_CRATE_VALUE * 5
	contains = list(/obj/item/vending_refill/medical,
					/obj/item/vending_refill/drugs,
					/obj/item/vending_refill/wallmed)
	container_name = "medical vending crate"

/datum/supply_pack/vending/ptech
	name = "PTech Supply Crate"
	desc = "Not enough cartridges after half the crew lost their PDA to explosions? This may fix it."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/vending_refill/cart)
	container_name = "\improper PTech supply crate"

/datum/supply_pack/vending/sectech
	name = "SecTech Supply Crate"
	desc = "Officer Paul bought all the donuts? Then refill the security vendor with ths crate."
	cost = CARGO_CRATE_VALUE * 3
	access = ACCESS_SECURITY
	contains = list(/obj/item/vending_refill/security)
	container_name = "\improper SecTech supply crate"
	container_type = /obj/structure/closet/crate/secure/gear

/datum/supply_pack/vending/snack
	name = "Snack Supply Crate"
	desc = "One vending machine refill of cavity-bringin' goodness! The number one dentist recommended order!"
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/vending_refill/snack)
	container_name = "snacks supply crate"

/datum/supply_pack/vending/cola
	name = "Softdrinks Supply Crate"
	desc = "Got whacked by a toolbox, but you still have those pesky teeth? Get rid of those pearly whites with this soda machine refill, today!"
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/vending_refill/cola)
	container_name = "soft drinks supply crate"

/datum/supply_pack/vending/vendomat
	name = "Part-Mart & YouTool Supply Crate"
	desc = "More tools for your IED testing facility."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/vending_refill/assist,
					/obj/item/vending_refill/youtool)
	container_name = "\improper Part-Mart & YouTool supply crate"

/datum/supply_pack/vending/clothesmate
	name = "ClothesMate Supply Crate"
	desc = "Out of cowboy boots? Buy this crate."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/vending_refill/clothing)
	container_name = "\improper ClothesMate supply crate"

//////////////////////////////////////////////////////////////////////////////
/////////////////////// Clothing Vending Restocks ////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/vending/wardrobes/autodrobe
	name = "Autodrobe Supply Crate"
	desc = "Autodrobe missing your favorite dress? Solve that issue today with this autodrobe refill."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/vending_refill/autodrobe)
	container_name = "autodrobe supply crate"

/datum/supply_pack/vending/wardrobes/cargo
	name = "Cargo Wardrobe Supply Crate"
	desc = "This crate contains a refill for the CargoDrobe."
	cost = CARGO_CRATE_VALUE * 1.5
	contains = list(/obj/item/vending_refill/wardrobe/cargo_wardrobe)
	container_name = "cargo department supply crate"

/datum/supply_pack/vending/wardrobes/engineering
	name = "Engineering Wardrobe Supply Crate"
	desc = "This crate contains refills for the EngiDrobe and AtmosDrobe."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/vending_refill/wardrobe/engi_wardrobe,
					/obj/item/vending_refill/wardrobe/atmos_wardrobe)
	container_name = "engineering department wardrobe supply crate"

/datum/supply_pack/vending/wardrobes/general
	name = "General Wardrobes Supply Crate"
	desc = "This crate contains refills for the CuraDrobe, BarDrobe, ChefDrobe and ChapDrobe."
	cost = CARGO_CRATE_VALUE * 6
	contains = list(/obj/item/vending_refill/wardrobe/curator_wardrobe,
					/obj/item/vending_refill/wardrobe/bar_wardrobe,
					/obj/item/vending_refill/wardrobe/chef_wardrobe,
					/obj/item/vending_refill/wardrobe/chap_wardrobe)
	container_name = "general wardrobes vendor refills"

/datum/supply_pack/vending/wardrobes/hydroponics
	name = "Hydrobe Supply Crate"
	desc = "This crate contains a refill for the Hydrobe."
	cost = CARGO_CRATE_VALUE * 1.5
	contains = list(/obj/item/vending_refill/wardrobe/hydro_wardrobe)
	container_name = "hydrobe supply crate"

/datum/supply_pack/vending/wardrobes/janitor
	name = "JaniDrobe Supply Crate"
	desc = "This crate contains a refill for the JaniDrobe."
	cost = CARGO_CRATE_VALUE * 1.5
	contains = list(/obj/item/vending_refill/wardrobe/jani_wardrobe)
	container_name = "janidrobe supply crate"

/datum/supply_pack/vending/wardrobes/medical
	name = "Medical Wardrobe Supply Crate"
	desc = "This crate contains refills for the MediDrobe, ChemDrobe, and ViroDrobe."
	cost = CARGO_CRATE_VALUE * 6
	contains = list(/obj/item/vending_refill/wardrobe/medi_wardrobe,
					/obj/item/vending_refill/wardrobe/chem_wardrobe,
					/obj/item/vending_refill/wardrobe/viro_wardrobe)
	container_name = "medical department wardrobe supply crate"

/datum/supply_pack/vending/wardrobes/science
	name = "Science Wardrobe Supply Crate"
	desc = "This crate contains refills for the SciDrobe, GeneDrobe, and RoboDrobe."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/vending_refill/wardrobe/robo_wardrobe,
					/obj/item/vending_refill/wardrobe/gene_wardrobe,
					/obj/item/vending_refill/wardrobe/science_wardrobe)
	container_name = "science department wardrobe supply crate"

/datum/supply_pack/vending/wardrobes/security
	name = "Security Wardrobe Supply Crate"
	desc = "This crate contains refills for the SecDrobe, DetDrobe and LawDrobe."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/obj/item/vending_refill/wardrobe/sec_wardrobe,
					/obj/item/vending_refill/wardrobe/det_wardrobe,
					/obj/item/vending_refill/wardrobe/law_wardrobe)
	container_name = "security department supply crate"

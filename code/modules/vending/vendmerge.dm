/obj/machinery/vending/engivend/deluxe //If, dear reader, you are porting this to another server, do it better.
	name = "\improper Engi-Vend Deluxe"
	product_categories = list(
		list(
			"name" = "Engi-vend", //It doesn't list these categories in the same
			"icon" = "car-battery", //order that I made them and I don't know why
			"products" = list(
				/obj/item/clothing/glasses/meson/engine = 2,
				/obj/item/clothing/glasses/welding = 3,
				/obj/item/multitool = 4,
				/obj/item/grenade/chem_grenade/smart_metal_foam = 10,
				/obj/item/geiger_counter = 5,
				/obj/item/stock_parts/cell/high = 10,
				/obj/item/electronics/airlock = 10,
				/obj/item/electronics/apc = 10,
				/obj/item/electronics/airalarm = 10,
				/obj/item/electronics/firealarm = 10,
				/obj/item/electronics/firelock = 10,
			),
		),

		list(
			"name" = "Robco",
			"icon" = "screwdriver-wrench",
			"products" = list(
				/obj/item/clothing/under/rank/engineering/chief_engineer = 4,
				/obj/item/clothing/under/rank/engineering/engineer = 4,
				/obj/item/clothing/shoes/sneakers/orange = 4,
				/obj/item/clothing/head/hardhat = 4,
				/obj/item/storage/belt/utility = 4,
				/obj/item/clothing/glasses/meson/engine = 4,
				/obj/item/clothing/gloves/color/yellow = 4,
				/obj/item/screwdriver = 12,
				/obj/item/crowbar = 12,
				/obj/item/wirecutters = 12,
				/obj/item/multitool = 12,
				/obj/item/wrench = 12,
				/obj/item/t_scanner = 12,
				/obj/item/stock_parts/cell = 8,
				/obj/item/weldingtool = 8,
				/obj/item/clothing/head/welding = 8,
				/obj/item/light/tube = 10,
				/obj/item/clothing/suit/utility/fire = 4,
				/obj/item/stock_parts/scanning_module = 5,
				/obj/item/stock_parts/micro_laser = 5,
				/obj/item/stock_parts/matter_bin = 5,
				/obj/item/stock_parts/manipulator = 5,
			),
		),

		list(
			"name" = "EngiDrobe",
			"icon" = "vest",
			"products" = list(
				/obj/item/clothing/accessory/pocketprotector = 3,
				/obj/item/storage/backpack/duffelbag/engineering = 3,
				/obj/item/storage/backpack/industrial = 3,
				/obj/item/storage/backpack/satchel/eng = 3,
				/obj/item/clothing/suit/hooded/wintercoat/engineering = 3,
				/obj/item/clothing/under/rank/engineering/engineer = 3,
				/obj/item/clothing/under/rank/engineering/engineer/skirt = 3,
				/obj/item/clothing/under/rank/engineering/engineer/hazard = 3,
				/obj/item/clothing/suit/hazardvest = 3,
				/obj/item/clothing/shoes/workboots = 3,
				/obj/item/clothing/head/beret/engi = 3,
				/obj/item/clothing/mask/bandana/striped/engineering = 3,
				/obj/item/clothing/head/hardhat = 3,
				/obj/item/clothing/head/hardhat/weldhat = 3,
			),
		),
	) //same contraband & premium as normal engi-vend, which we inherit from. Other vendors we took from have no contraband/premium products
	refill_canister = /obj/item/vending_refill/engivend/deluxe

/obj/item/vending_refill/engivend/deluxe
	machine_name = "Engi-Vend Deluxe"

/obj/machinery/vending/medical/deluxe
	name = "\improper NanoMed Deluxe"
	desc = "All-in-one medical dispenser."
	req_access = list(ACCESS_MEDICAL)
	product_categories = list(
		list(
			"name" = "NanoMed",
			"icon" = "kit-medical",
			"products" = list(
				/obj/item/stack/medical/gauze = 8,
				/obj/item/reagent_containers/syringe = 12,
				/obj/item/reagent_containers/dropper = 3,
				/obj/item/healthanalyzer = 4,
				/obj/item/wrench/medical = 1,
				/obj/item/stack/sticky_tape/surgical = 3,
				/obj/item/healthanalyzer/wound = 4,
				/obj/item/stack/medical/ointment = 2,
				/obj/item/stack/medical/suture = 2,
				/obj/item/stack/medical/bone_gel/four = 4,
				/obj/item/cane/white = 2,
			),
		),
		list(
			"name" = "NanoDrug",
			"icon" = "flask",
			"products" = list(
				/obj/item/reagent_containers/pill/patch/libital = 5,
				/obj/item/reagent_containers/pill/patch/aiuri = 5,
				/obj/item/reagent_containers/syringe/convermol = 2,
				/obj/item/reagent_containers/pill/insulin = 5,
				/obj/item/reagent_containers/cup/bottle/multiver = 2,
				/obj/item/reagent_containers/cup/bottle/syriniver = 2,
				/obj/item/reagent_containers/cup/bottle/epinephrine = 3,
				/obj/item/reagent_containers/cup/bottle/morphine = 4,
				/obj/item/reagent_containers/cup/bottle/potass_iodide = 1,
				/obj/item/reagent_containers/cup/bottle/salglu_solution = 3,
				/obj/item/reagent_containers/cup/bottle/toxin = 3,
				/obj/item/reagent_containers/syringe/antiviral = 6,
				/obj/item/reagent_containers/medigel/libital = 2,
				/obj/item/reagent_containers/medigel/aiuri = 2,
				/obj/item/reagent_containers/medigel/sterilizine = 1,
			),
		),
		list(
			"name" = "ChemDrobe",
			"icon" = "flask-vial",
			"products" = list(
				/obj/item/clothing/under/rank/medical/chemist = 2,
				/obj/item/clothing/under/rank/medical/chemist/skirt = 2,
				/obj/item/clothing/head/beret/medical = 2,
				/obj/item/clothing/shoes/sneakers/white = 2,
				/obj/item/clothing/suit/toggle/labcoat/chemist = 2,
				/obj/item/clothing/suit/hooded/wintercoat/medical/chemistry = 2,
				/obj/item/storage/backpack/chemistry = 2,
				/obj/item/storage/backpack/satchel/chem = 2,
				/obj/item/storage/backpack/duffelbag/chemistry = 2,
				/obj/item/storage/bag/chemistry = 2,
			),
		),
		list(
			"name" = "MediDrobe",
			"icon" = "suitcase-medical",
			"products" = list(
				/obj/item/clothing/accessory/pocketprotector = 4,
				/obj/item/storage/backpack/duffelbag/med = 4,
				/obj/item/storage/backpack/medic = 4,
				/obj/item/storage/backpack/satchel/med = 4,
				/obj/item/clothing/suit/hooded/wintercoat/medical = 4,
				/obj/item/clothing/suit/hooded/wintercoat/medical/paramedic = 4,
				/obj/item/clothing/under/rank/medical/paramedic = 4,
				/obj/item/clothing/under/rank/medical/paramedic/skirt = 4,
				/obj/item/clothing/head/nursehat = 4,
				/obj/item/clothing/head/beret/medical = 4,
				/obj/item/clothing/head/surgerycap = 4,
				/obj/item/clothing/head/surgerycap/purple = 4,
				/obj/item/clothing/head/surgerycap/green = 4,
				/obj/item/clothing/mask/bandana/striped/medical = 4,
				/obj/item/clothing/under/rank/medical/doctor = 4,
				/obj/item/clothing/under/rank/medical/doctor/skirt = 4,
				/obj/item/clothing/under/rank/medical/scrubs/blue = 4,
				/obj/item/clothing/under/rank/medical/scrubs/green = 4,
				/obj/item/clothing/under/rank/medical/scrubs/purple = 4,
				/obj/item/clothing/suit/toggle/labcoat = 4,
				/obj/item/clothing/suit/toggle/labcoat/paramedic = 4,
				/obj/item/clothing/shoes/sneakers/white = 4,
				/obj/item/clothing/head/beret/medical/paramedic = 4,
				/obj/item/clothing/head/soft/paramedic = 4,
				/obj/item/clothing/shoes/sneakers/blue = 4,
				/obj/item/clothing/suit/apron/surgical = 4,
				/obj/item/clothing/mask/surgical = 4,
			),
		),
		list(
			"name" = "ViroDrobe",
			"icon" = "virus",
			"products" = list(
				/obj/item/clothing/under/rank/medical/virologist = 2,
				/obj/item/clothing/under/rank/medical/virologist/skirt = 2,
				/obj/item/clothing/head/beret/medical = 2,
				/obj/item/clothing/shoes/sneakers/white = 2,
				/obj/item/clothing/suit/toggle/labcoat/virologist = 2,
				/obj/item/clothing/suit/hooded/wintercoat/medical/viro = 2,
				/obj/item/clothing/mask/surgical = 2,
				/obj/item/storage/backpack/virology = 2,
				/obj/item/storage/backpack/satchel/vir = 2,
				/obj/item/storage/backpack/duffelbag/virology = 2,
			),
		),
	)
	contraband = list(
		/obj/item/storage/box/gum/happiness = 3,
		/obj/item/storage/box/hug/medical = 1,
		/obj/item/reagent_containers/pill/tox = 3,
		/obj/item/reagent_containers/pill/morphine = 4,
		/obj/item/reagent_containers/pill/multiver = 6,
		/obj/item/reagent_containers/spray/syndicate = 2,
	)
	premium = list(
		/obj/item/reagent_containers/hypospray/medipen = 3,
		/obj/item/storage/belt/medical = 3,
		/obj/item/sensor_device = 2,
		/obj/item/pinpointer/crew = 2,
		/obj/item/storage/medkit/advanced = 2,
		/obj/item/shears = 1,
		/obj/item/storage/organbox = 1,
		/obj/item/reagent_containers/medigel/synthflesh = 2,
		/obj/item/storage/pill_bottle/psicodine = 2,
	)
	refill_canister = /obj/item/vending_refill/medical/deluxe

/obj/item/vending_refill/medical/deluxe
	machine_name = "NanoMed Deluxe"

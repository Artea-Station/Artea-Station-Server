/obj/machinery/vending/engivend/deluxe
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

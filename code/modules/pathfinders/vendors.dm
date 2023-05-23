/obj/machinery/vending/wardrobe/pathfinder_wardrobe
	name = "PathDrobe"
	desc = "A familiar-looking machine that dispenses outfits fit for space. Not certified for EVA use."
	icon_state = "pathdrobe"
	product_ads = "Airlock yourself in style!;Shuttle explosion take your clothes?;Our outfits are fit for spacer use!;Not certified for extra-vehicular activity!"
	vend_reply = "Thank you for using the ViroDrobe"
	products = list(
		/obj/item/clothing/under/rank/pathfinder = 2,
		/obj/item/clothing/under/rank/pathfinder/skirt = 2,
		/obj/item/clothing/head/beret/pathfinders = 2,
		/obj/item/clothing/shoes/jackboots = 2,
		/obj/item/radio/headset/headset_pth = 2,
		)
	refill_canister = /obj/item/vending_refill/wardrobe/pathfinder_wardrobe
	payment_department = ACCOUNT_PTH

/obj/item/vending_refill/wardrobe/pathfinder_wardrobe
	machine_name = "PathDrobe"

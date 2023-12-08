// Contains a bit of cursed shitcode to help with the rapid prototyping phase.

#define ARTEA_CLOTHING(PTH, ICN, ICNS, NME) /obj/item/clothing/under/artea/##PTH { \
	name = ##NME; \
	icon_state = ##ICN; \
} \
/obj/item/clothing/under/artea/##PTH/skirt { \
	name = ##NME; \
	icon_state = ##ICNS; \
	body_parts_covered = CHEST|GROIN|ARMS; \
	dying_key = DYE_REGISTRY_JUMPSKIRT; \
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY; \
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON; \
}

/obj/item/clothing/under/artea
	icon = 'icons/obj/clothing/under/artea_core_clothes.dmi'
	worn_icon = 'icons/mob/clothing/under/artea_core_clothes.dmi'
	can_adjust = FALSE

// Misc heads
ARTEA_CLOTHING(captain, "captain", "captain_skirt", "Captain Uniform")
ARTEA_CLOTHING(hop, "hop", "hop_skirt", "Head of Personnel Uniform")

// Defense
ARTEA_CLOTHING(hos, "rhos", "rhos_skirt", "Head of Shitcurity Uniform")
ARTEA_CLOTHING(warden, "rwarden", "rwarden_skirt", "Warden Uniform")
ARTEA_CLOTHING(sec, "sec", "sec_skirt", "Defense Uniform")
ARTEA_CLOTHING(corrections_officer, "corrections_officer", "corrections_officer_skirt", "Corrections Officer Uniform")
ARTEA_CLOTHING(detective, "detective", "detective_skirt", "Detective Uniform")

// Cargo
ARTEA_CLOTHING(qm, "qm", "qm_skirt", "Quartermaster Uniform")
ARTEA_CLOTHING(cargo, "cargo", "cargo_skirt", "Cargo Uniform")

// Engi
ARTEA_CLOTHING(ce, "ce", "ce_skirt", "Chief Engineer Uniform")
ARTEA_CLOTHING(engine, "engineer", "engine_skirt", "Engineer Uniform")
ARTEA_CLOTHING(atmos, "atmos", "atmos_skirt", "Atmospheric Technician Uniform")

// Medical
ARTEA_CLOTHING(cmo, "cmo", "cmo_skirt", "Chief Medical Officer Uniform")
ARTEA_CLOTHING(medical, "medical", "medical_skirt", "Medical Uniform")
ARTEA_CLOTHING(chemistry, "chemistry", "chemistry_skirt", "Chemistry Uniform")
ARTEA_CLOTHING(paramedic, "paramedic", "paramedic_skirt", "Paramedic Uniform")

// Civ
ARTEA_CLOTHING(bartender, "bartender", "bartender_skirt", "Bartender Uniform")
ARTEA_CLOTHING(chef, "chef", "chef_skirt", "Chef Uniform")
ARTEA_CLOTHING(lawyer_black, "lawyer_black", "lawyer_black_skirt", "Black Lawyer Uniform")
ARTEA_CLOTHING(lawyer_blue, "lawyer_blue", "lawyer_blue_skirt", "Blue Lawyer Uniform")
ARTEA_CLOTHING(lawyer_red, "lawyer_red", "lawyer_red_skirt", "Red Lawyer Uniform")
ARTEA_CLOTHING(curator, "curator", "curator_skirt", "Curator Uniform")
ARTEA_CLOTHING(hydroponics, "hydroponics", "hydroponics_skirt", "Hydroponics Uniform")
ARTEA_CLOTHING(chaplain, "chaplain", "chaplain_skirt", "Chaplain Uniform")
ARTEA_CLOTHING(janitor, "janitor", "janitor_skirt", "Janitor Uniform")

/obj/machinery/vending/artea
	name = "Artea Rapid Prototyping Vendor"
	desc = "A vending machine for prototype items by Artea Logistics."
	color = "#f06000"
	icon_state = "clothes"
	icon_deny = "clothes-deny"
	panel_type = "panel15"
	product_slogans = "Dress for success!;Prepare to look swagalicious!;Look at all this swag!;Why leave style up to fate? Use the ClothesMate!"
	vend_reply = "Thank you for using the ClothesMate!"
	product_categories = list(
		list(
			"name" = "Under",
			"icon" = "shirt",
			"products" = list(
				/obj/item/clothing/under/artea = 5,
			),
		),
	)
	refill_canister = /obj/item/vending_refill/artea
	default_price = 0
	extra_price = 0
	payment_department = NO_FREEBIES
	light_mask = "wardrobe-light-mask"
	light_color = LIGHT_COLOR_ELECTRIC_GREEN
	manufacturer = MANUFACTURER_ARTEA_LOGISTICS

/obj/machinery/vending/artea/build_inventory(list/productlist, list/recordlist, list/categories, start_empty = FALSE)
	var/list/product_to_category = list()
	for (var/list/category as anything in categories)
		var/list/products = category["products"]
		for (var/subtype in subtypesof(products))
			for (var/product_key in subtype)
				product_to_category[product_key] = category

	for(var/base_typepath in productlist)
		for(var/typepath in subtypesof(base_typepath))
			var/amount = 10

			var/obj/item/temp = typepath
			var/datum/data/vending_product/R = new /datum/data/vending_product()
			GLOB.vending_products[typepath] = 1
			R.name = initial(temp.name)
			R.product_path = typepath
			R.amount = amount
			R.max_amount = amount
			///Prices of vending machines are all increased uniformly.
			R.custom_price = round(initial(temp.custom_price) * SSeconomy.inflation_value())
			R.custom_premium_price = round(initial(temp.custom_premium_price) * SSeconomy.inflation_value())
			R.age_restricted = initial(temp.age_restricted)
			R.colorable = !!(initial(temp.greyscale_config) && initial(temp.greyscale_colors) && (initial(temp.flags_1) & IS_PLAYER_COLORABLE_1))
			R.category = product_to_category[typepath]
			recordlist += R

/obj/item/vending_refill/artea
	machine_name = "Artea"
	icon_state = "refill_clothes"

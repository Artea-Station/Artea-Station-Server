/obj/item/clothing/under/rank/pathfinder
	icon = 'icons/obj/clothing/under/pathfinders.dmi'
	worn_icon = 'icons/mob/clothing/under/pathfinders.dmi'

	name = "pathfinder's jumpsuit"
	desc = "A comfy and durable jumpsuit."
	icon_state = "pathfinder"
	inhand_icon_state = "lb_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION

/obj/item/clothing/under/rank/pathfinder/skirt
	name = "pathfinder's jumpskirt"
	desc = "A comfy and durable jumpskirt. Comes with pockets!"
	icon_state = "pathfinder_skirt"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY

/obj/item/clothing/under/rank/pathfinder/head
	icon = 'icons/obj/clothing/under/artea_core_clothes.dmi'
	worn_icon = 'icons/mob/clothing/under/artea_core_clothes.dmi'
	name = "lead pathfinder's jumpsuit"
	desc = "A comfy and durable jumpsuit."
	icon_state = "pathfinder_h"

/obj/item/clothing/under/rank/pathfinder/head/skirt
	name = "lead pathfinder's jumpskirt"
	desc = "A comfy and durable jumpskirt. Comes with pockets!"
	icon_state = "pathfinder_h_skirt"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY

/obj/item/mod/control/pre_equipped/pathfinders
	theme = /datum/mod_theme/pathfinders
	initial_modules = list(
		/obj/item/mod/module/storage,
		/obj/item/mod/module/flashlight,
		/obj/item/mod/module/magboot,
		/obj/item/mod/module/tether,
	)

/obj/item/mod/control/pre_equipped/pathfinders/medic
	initial_modules = list(
		/obj/item/mod/module/storage,
		/obj/item/mod/module/flashlight,
		/obj/item/mod/module/magboot,
		/obj/item/mod/module/tether,
		/obj/item/mod/module/quick_carry,
	)

/datum/mod_theme/pathfinders
	name = "pathfinders"
	desc = "A pathfinder-fit suit with heat and damage resistance. Artea Logistic's classic."
	extended_desc = "A classic by Artea Logistics, and is widely used by their salvage teams due to a relatively low cost to manufacture, \
		low complexity, and almost most importantly, a wide array of safety features to avoid drifting off into space. Comes with lightweight armor plating. Does not come with warranty."
	default_skin = "engineering"
	armor = list(MELEE = 20, BULLET = 15, LASER = 30, ENERGY = 10, BOMB = 20, BIO = 100, FIRE = 60, ACID = 25, WOUND = 15)
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT
	allowed_suit_storage = list(
		/obj/item/ammo_box, // Pathfinders are expected to get into fights, so I think this is fair.
		/obj/item/pipe_dispenser,
		/obj/item/pipe_painter,
	)
	skins = list(
		"engineering" = list(
			HELMET_FLAGS = list(
				UNSEALED_LAYER = NECK_LAYER,
				UNSEALED_CLOTHING = SNUG_FIT,
				SEALED_CLOTHING = THICKMATERIAL|STOPSPRESSUREDAMAGE,
				UNSEALED_INVISIBILITY = HIDEFACIALHAIR,
				SEALED_INVISIBILITY = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDESNOUT,
				SEALED_COVER = HEADCOVERSMOUTH|HEADCOVERSEYES|PEPPERPROOF,
			),
			CHESTPLATE_FLAGS = list(
				UNSEALED_CLOTHING = THICKMATERIAL,
				SEALED_CLOTHING = STOPSPRESSUREDAMAGE,
				SEALED_INVISIBILITY = HIDEJUMPSUIT,
			),
			GAUNTLETS_FLAGS = list(
				UNSEALED_CLOTHING = THICKMATERIAL,
				SEALED_CLOTHING = STOPSPRESSUREDAMAGE,
				CAN_OVERSLOT = TRUE,
			),
			BOOTS_FLAGS = list(
				UNSEALED_CLOTHING = THICKMATERIAL,
				SEALED_CLOTHING = STOPSPRESSUREDAMAGE,
				CAN_OVERSLOT = TRUE,
			),
		),
	)

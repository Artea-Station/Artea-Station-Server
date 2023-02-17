/**************SKYRAT REWARDS**************/
//SUITS
/obj/item/clothing/suit/hooded/wintercoat/colourable
	name = "custom winter coat"
	icon_state = "winter_coat"
	hoodtype = /obj/item/clothing/head/hooded/winterhood/colourable
	greyscale_config = /datum/greyscale_config/winter_coat
	greyscale_config_worn = /datum/greyscale_config/winter_coat_worn
	greyscale_colors = "#666666#CCBBAA#0000FF"
	flags_1 = IS_PLAYER_COLORABLE_1

//In case colors are changed after initialization
/obj/item/clothing/suit/hooded/wintercoat/colourable/set_greyscale(list/colors, new_config, new_worn_config, new_inhand_left, new_inhand_right)
	. = ..()
	if(hood)
		var/list/coat_colors = SSgreyscale.ParseColorString(greyscale_colors)
		var/list/new_coat_colors = coat_colors.Copy(1,3)
		hood.set_greyscale(new_coat_colors) //Adopt the suit's grayscale coloring for visual clarity.

//But also keep old method in case the hood is (re-)created later
/obj/item/clothing/suit/hooded/wintercoat/colourable/MakeHood()
	. = ..()
	var/list/coat_colors = (SSgreyscale.ParseColorString(greyscale_colors))
	var/list/new_coat_colors = coat_colors.Copy(1,3)
	hood.set_greyscale(new_coat_colors) //Adopt the suit's grayscale coloring for visual clarity.

/obj/item/clothing/head/hooded/winterhood/colourable
	icon_state = "winter_hood"
	greyscale_config = /datum/greyscale_config/winter_hood
	greyscale_config_worn = /datum/greyscale_config/winter_hood/worn

// NECK

/obj/item/clothing/neck/cloak/colourable
	name = "colourable cloak"
	icon_state = "gags_cloak"
	greyscale_config = /datum/greyscale_config/cloak
	greyscale_config_worn = /datum/greyscale_config/cloak/worn
	greyscale_colors = "#917A57#4e412e#4e412e"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/neck/cloak/colourable/veil
	name = "colourable veil"
	icon_state = "gags_veil"
	greyscale_config = /datum/greyscale_config/cloak/veil
	greyscale_config_worn = /datum/greyscale_config/cloak/veil/worn

/obj/item/clothing/neck/cloak/colourable/boat
	name = "colourable boatcloak"
	icon_state = "gags_boat"
	greyscale_config = /datum/greyscale_config/cloak/boat
	greyscale_config_worn = /datum/greyscale_config/cloak/boat/worn

/obj/item/clothing/neck/cloak/colourable/shroud
	name = "colourable shroud"
	icon_state = "gags_shroud"
	greyscale_config = /datum/greyscale_config/cloak/shroud
	greyscale_config_worn = /datum/greyscale_config/cloak/shroud/worn

//UNIFORMS
/obj/item/clothing/under/dress/skirt/polychromic
	name = "polychromic skirt"
	desc = "A fancy skirt made with polychromic threads."
	icon = 'modular_skyrat/master_files/icons/donator/obj/clothing/uniform.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/donator/mob/clothing/uniform.dmi'
	icon_state = "polyskirt"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	var/list/poly_colors = list("#FFFFFF", "#FF8888", "#888888")

/obj/item/clothing/under/dress/skirt/polychromic/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/polychromic, poly_colors)

/obj/item/clothing/under/misc/poly_shirt
	name = "polychromic button-up shirt"
	desc = "A fancy button-up shirt made with polychromic threads."
	icon = 'modular_skyrat/master_files/icons/donator/obj/clothing/uniform.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/donator/mob/clothing/uniform.dmi'
	icon_state = "polysuit"
	supports_variations_flags = NONE

/obj/item/clothing/under/misc/poly_shirt/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/polychromic, list("#FFFFFF", "#333333", "#333333"))

/obj/item/clothing/under/misc/polyshorts
	name = "polychromic shorts"
	desc = "For ease of movement and style."
	icon = 'modular_skyrat/master_files/icons/donator/obj/clothing/uniform.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/donator/mob/clothing/uniform.dmi'
	icon_state = "polyshorts"
	can_adjust = FALSE
	body_parts_covered = CHEST|GROIN|ARMS
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/misc/polyshorts/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/polychromic, list("#333333", "#888888", "#888888"))

/obj/item/clothing/under/misc/polyjumpsuit
	name = "polychromic tri-tone jumpsuit"
	desc = "A fancy jumpsuit made with polychromic threads."
	icon = 'modular_skyrat/master_files/icons/donator/obj/clothing/uniform.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/donator/mob/clothing/uniform.dmi'
	icon_state = "polyjump"
	can_adjust = FALSE
	supports_variations_flags = NONE

/obj/item/clothing/under/misc/polyjumpsuit/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/polychromic, list("#FFFFFF", "#888888", "#333333"))

/obj/item/clothing/under/misc/poly_bottomless
	name = "polychromic bottomless shirt"
	desc = "Great for showing off your underwear in dubious style."
	icon = 'modular_skyrat/master_files/icons/donator/obj/clothing/uniform.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/donator/mob/clothing/uniform.dmi'
	icon_state = "polybottomless"
	body_parts_covered = CHEST|ARMS	//Because there's no bottom included
	can_adjust = FALSE
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/misc/poly_bottomless/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/polychromic, list("#888888", "#FF3333", "#FFFFFF"))

/obj/item/clothing/under/misc/poly_tanktop
	name = "polychromic tank top"
	desc = "For those lazy summer days."
	icon = 'modular_skyrat/master_files/icons/donator/obj/clothing/uniform.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/donator/mob/clothing/uniform.dmi'
	icon_state = "polyshimatank"
	body_parts_covered = CHEST|GROIN
	can_adjust = FALSE
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	var/list/poly_colors = list("#888888", "#FFFFFF", "#88CCFF")

/obj/item/clothing/under/misc/poly_tanktop/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/polychromic, poly_colors)

/obj/item/clothing/under/misc/poly_tanktop/female
	name = "polychromic feminine tank top"
	desc = "Great for showing off your chest in style. Not recommended for males."
	icon_state = "polyfemtankpantsu"
	poly_colors = list("#888888", "#FF3333", "#FFFFFF")

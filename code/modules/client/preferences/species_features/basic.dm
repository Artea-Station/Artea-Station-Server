/proc/generate_possible_values_for_sprite_accessories_on_head(accessories)
	var/list/values = possible_values_for_sprite_accessory_list(accessories)

	var/icon/head_icon = icon('icons/mob/species/human/bodyparts_greyscale.dmi', "human_head_m")
	head_icon.Blend(skintone2hex("caucasian1"), ICON_MULTIPLY)

	for (var/name in values)
		var/datum/sprite_accessory/accessory = accessories[name]
		if (accessory == null || accessory.icon_state == null)
			continue

		var/icon/final_icon = new(head_icon)

		var/icon/beard_icon = values[name]
		beard_icon.Blend(COLOR_DARK_BROWN, ICON_MULTIPLY)
		final_icon.Blend(beard_icon, ICON_OVERLAY)

		final_icon.Crop(10, 19, 22, 31)
		final_icon.Scale(32, 32)

		values[name] = final_icon

	return values

/datum/preference/color/eye_color
	savefile_key = "eye_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_APPEARANCE_LIST
	relevant_species_trait = EYECOLOR

/datum/preference/color/eye_color/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	var/hetero = target.eye_color_heterochromatic
	target.eye_color_left = value
	if(!hetero)
		target.eye_color_right = value

	var/obj/item/organ/internal/eyes/eyes_organ = target.getorgan(/obj/item/organ/internal/eyes)
	if (!eyes_organ || !istype(eyes_organ))
		return

	if (!initial(eyes_organ.eye_color_left))
		eyes_organ.eye_color_left = value
	eyes_organ.old_eye_color_left = value

	if(hetero) // Don't override the snowflakes please
		return

	if (!initial(eyes_organ.eye_color_right))
		eyes_organ.eye_color_right = value
	eyes_organ.old_eye_color_right = value
	eyes_organ.refresh()

/datum/preference/color/eye_color/create_default_value()
	return random_eye_color()

/datum/preference/choiced/facial_hairstyle
	savefile_key = "facial_style_name"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_APPEARANCE
	main_feature_name = "Facial hair"
	should_generate_icons = TRUE
	relevant_species_trait = FACEHAIR

/datum/preference/choiced/facial_hairstyle/init_possible_values()
	return generate_possible_values_for_sprite_accessories_on_head(GLOB.facial_hairstyles_list)

/datum/preference/choiced/facial_hairstyle/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.facial_hairstyle = value
	target.update_body_parts()

/datum/preference/choiced/facial_hairstyle/compile_constant_data()
	var/list/data = ..()

	data[SUPPLEMENTAL_FEATURE_KEY] = "facial_hair_color"

	return data

/datum/preference/color/facial_hair_color
	savefile_key = "facial_hair_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES
	relevant_species_trait = FACEHAIR

/datum/preference/color/facial_hair_color/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.facial_hair_color = value
	target.update_body_parts()

/datum/preference/choiced/facial_hair_gradient
	category = PREFERENCE_CATEGORY_APPEARANCE
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "facial_hair_gradient"
	relevant_species_trait = FACEHAIR
	should_generate_icons = TRUE
	main_feature_name = "Facial hair gradient"

/datum/preference/choiced/facial_hair_gradient/init_possible_values()
	var/list/hair_gradients = list()
	var/datum/sprite_accessory/hair/hair = GLOB.hairstyles_list["Floorlength Bedhead"]
	var/icon/hair_icon = icon(hair.icon, hair.icon_state, NORTH)

	for(var/gradient_key in GLOB.facial_hair_gradients_list)
		if(gradient_key == "None")
			hair_gradients[gradient_key] = icon('icons/mob/landmarks.dmi', "x")
			continue

		var/datum/sprite_accessory/gradient/gradient = GLOB.facial_hair_gradients_list[gradient_key]
		var/icon/temp = icon(gradient.icon, gradient.icon_state)
		temp.Blend(hair_icon, ICON_ADD)
		temp.ColorTone("#ff0000")
		var/icon/temp_hair = icon(hair_icon)
		temp_hair.Blend(temp, ICON_OVERLAY)
		hair_gradients[gradient_key] = temp_hair

	return hair_gradients

/datum/preference/choiced/hair_gradient/compile_constant_data()
	. = ..()
	.[SUPPLEMENTAL_FEATURE_KEY] = "facial_hair_gradient_color"

/datum/preference/choiced/facial_hair_gradient/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	LAZYSETLEN(target.grad_style, GRADIENTS_LEN)
	target.grad_style[GRADIENT_FACIAL_HAIR_KEY] = value
	target.update_body_parts()

/datum/preference/choiced/facial_hair_gradient/create_default_value()
	return "None"

/datum/preference/color/facial_hair_gradient
	category = PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "facial_hair_gradient_color"
	relevant_species_trait = FACEHAIR

/datum/preference/color/facial_hair_gradient/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	LAZYSETLEN(target.grad_color, GRADIENTS_LEN)
	target.grad_color[GRADIENT_FACIAL_HAIR_KEY] = value
	target.update_body_parts()

/datum/preference/color/facial_hair_gradient/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE
	return preferences.read_preference(/datum/preference/choiced/facial_hair_gradient) != "None"

/datum/preference/color/hair_color
	savefile_key = "hair_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES
	relevant_species_trait = HAIR

/datum/preference/color/hair_color/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.hair_color = value

/datum/preference/choiced/hairstyle
	savefile_key = "hairstyle_name"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_APPEARANCE
	main_feature_name = "Hairstyle"
	should_generate_icons = TRUE
	relevant_species_trait = HAIR

/datum/preference/choiced/hairstyle/init_possible_values()
	return generate_possible_values_for_sprite_accessories_on_head(GLOB.hairstyles_list)

/datum/preference/choiced/hairstyle/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.hairstyle = value

/datum/preference/choiced/hairstyle/compile_constant_data()
	var/list/data = ..()

	data[SUPPLEMENTAL_FEATURE_KEY] = "hair_color"

	return data

/datum/preference/choiced/hair_gradient
	category = PREFERENCE_CATEGORY_APPEARANCE
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "hair_gradient"
	relevant_species_trait = HAIR
	should_generate_icons = TRUE
	main_feature_name = "Hair gradient"

/datum/preference/choiced/hair_gradient/init_possible_values()
	var/list/hair_gradients = list()
	var/datum/sprite_accessory/hair/hair = GLOB.hairstyles_list["Floorlength Bedhead"]
	var/icon/hair_icon = icon(hair.icon, hair.icon_state, NORTH)

	for(var/gradient_key in GLOB.hair_gradients_list)
		if(gradient_key == "None")
			hair_gradients[gradient_key] = icon('icons/mob/landmarks.dmi', "x")
			continue

		var/datum/sprite_accessory/gradient/gradient = GLOB.hair_gradients_list[gradient_key]
		var/icon/temp = icon(gradient.icon, gradient.icon_state)
		temp.Blend(hair_icon, ICON_ADD)
		temp.ColorTone("#ff0000")
		var/icon/temp_hair = icon(hair_icon)
		temp_hair.Blend(temp, ICON_OVERLAY)
		hair_gradients[gradient_key] = temp_hair

	return hair_gradients

/datum/preference/choiced/hair_gradient/compile_constant_data()
	. = ..()
	.[SUPPLEMENTAL_FEATURE_KEY] = "hair_gradient_color"

/datum/preference/choiced/hair_gradient/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	LAZYSETLEN(target.grad_style, GRADIENTS_LEN)
	target.grad_style[GRADIENT_HAIR_KEY] = value
	target.update_body_parts()

/datum/preference/choiced/hair_gradient/create_default_value()
	return "None"

/datum/preference/choiced/hair_gradient/ui_static_data(mob/user)
	. = ..()
	.[SUPPLEMENTAL_FEATURE_KEY] = "hair_gradient_color"

/datum/preference/color/hair_gradient
	category = PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "hair_gradient_color"
	relevant_species_trait = HAIR

/datum/preference/color/hair_gradient/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	LAZYSETLEN(target.grad_color, GRADIENTS_LEN)
	target.grad_color[GRADIENT_HAIR_KEY] = value
	target.update_body_parts()

/datum/preference/color/hair_gradient/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE
	return preferences.read_preference(/datum/preference/choiced/hair_gradient) != "None"

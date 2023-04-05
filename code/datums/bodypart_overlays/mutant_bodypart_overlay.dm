///Variant of bodypart_overlay meant to work synchronously with external organs. Gets imprinted upon Insert in on_species_gain
/datum/bodypart_overlay/mutant
	///Sprite datum we use to draw on the bodypart
	var/datum/sprite_accessory/sprite_datum

	/// Defines what kind of 'organ' we're looking at. Sprites have names like 'm_mothwings_firemoth_ADJ'. 'mothwings' would then be feature_key
	/// This value is a default, and sprite_accessory.key is used instead of this if it's defined.
	/// The default override color proc always uses the initial value of this.
	var/feature_key = ""

	/// The color this organ draws with. Updated by bodypart/inherit_color()
	/// Can be null, a color, or a list.
	var/draw_color
	///Where does this organ inherit it's color from?
	var/color_source = ORGAN_COLOR_OVERRIDE
	///Take on the dna/preference from whoever we're gonna be inserted in
	var/imprint_on_next_insertion = TRUE
	/// A simple list of indexes to color (as we don't want to color emissives, MOD overlays or inner ears)
	var/list/overlay_indexes_to_color

///Completely random image and color generation (obeys what a player can choose from)
/datum/bodypart_overlay/mutant/proc/randomize_appearance()
	randomize_sprite()
	draw_color = "#[random_color()]"
	imprint_on_next_insertion = FALSE

///Grab a random sprite
/datum/bodypart_overlay/mutant/proc/randomize_sprite()
	sprite_datum = get_random_appearance()

///Grab a random appearance datum (thats not locked)
/datum/bodypart_overlay/mutant/proc/get_random_appearance()
	var/list/valid_restyles = list()
	var/list/feature_list = get_global_feature_list()
	for(var/accessory in feature_list)
		var/datum/sprite_accessory/accessory_datum = feature_list[accessory]
		if(initial(accessory_datum.locked)) //locked is for stuff that shouldn't appear here
			continue
		valid_restyles += accessory_datum
	return pick(valid_restyles)

///Return the BASE icon state of the sprite datum (so not the gender, layer, feature_key)
/datum/bodypart_overlay/mutant/proc/get_base_icon_state()
	return sprite_datum.icon_state

///Get the image we need to draw on the person. Called from get_overlay() which is called from _bodyparts.dm. Limb can be null
/datum/bodypart_overlay/mutant/get_images(image_layer, obj/item/bodypart/limb)
	if(!sprite_datum)
		return

	// Override feature key with what the sprite_datum wants, otherwise, use our initial value. Useful for weird uses elsewhere.
	if(sprite_datum.key)
		feature_key = sprite_datum.key
	else
		feature_key = initial(feature_key)

	overlay_indexes_to_color = list()

	var/gender = (limb?.limb_gender == FEMALE) ? "f" : "m"
	var/list/icon_state_builder = list()
	icon_state_builder += sprite_datum.gender_specific ? gender : "m" //Male is default because sprite accessories are so ancient they predate the concept of not hardcoding gender
	icon_state_builder += feature_key
	icon_state_builder += get_base_icon_state()
	icon_state_builder += mutant_bodyparts_layertext(image_layer)

	var/finished_icon_state = icon_state_builder.Join("_")

	var/list/returned_images = list()

	switch(sprite_datum.color_src)
		if(TRI_COLOR_LAYERS)
			var/index = 1
			for(var/color_index in sprite_datum.color_layer_names)
				var/mutable_appearance/layer_image = mutable_appearance(sprite_datum.icon, "[finished_icon_state]_[sprite_datum.color_layer_names[color_index]]", -image_layer)

				if(sprite_datum.center)
					center_image(layer_image, sprite_datum.dimension_x, sprite_datum.dimension_y)

				returned_images += layer_image
				overlay_indexes_to_color += index
				index++

		else
			var/mutable_appearance/layer_image = mutable_appearance(sprite_datum.icon, finished_icon_state, -image_layer)

			if(sprite_datum.center)
				center_image(layer_image, sprite_datum.dimension_x, sprite_datum.dimension_y)

			returned_images += layer_image
			overlay_indexes_to_color += 1

	return returned_images

/datum/bodypart_overlay/mutant/color_images(list/image/overlays, obj/item/bodypart/limb)
	if(!sprite_datum || !overlays)
		return

	var/index = 1

	if(!length(sprite_datum.color_layer_names))
		var/image/overlay = overlays[1]
		if(sprite_datum.color_src)
			overlay.color = islist(draw_color) ? "#[draw_color[index]]" : draw_color
		else
			overlay.color = null
		return

	for(var/color_index in sprite_datum.color_layer_names)

		var/color_index_num = text2num(color_index)
		if(color_index_num > length(overlays))
			break

		var/image/overlay = overlays[color_index_num]
		if(sprite_datum.color_src)
			overlay.color = islist(draw_color) ? "#[draw_color[index]]" : draw_color
			index++
		else
			overlay.color = null


/datum/bodypart_overlay/mutant/added_to_limb(obj/item/bodypart/limb)
	inherit_color(limb)

///Change our accessory sprite, using the accesssory type. If you need to change the sprite for something, use simple_change_sprite()
/datum/bodypart_overlay/mutant/set_appearance(accessory_type)
	sprite_datum = fetch_sprite_datum(accessory_type)
	cache_key = jointext(generate_icon_cache(), "_")

///In a lot of cases, appearances are stored in DNA as the Name, instead of the path. Use set_appearance instead of possible
/datum/bodypart_overlay/mutant/proc/set_appearance_from_name(accessory_name)
	sprite_datum = fetch_sprite_datum_from_name(accessory_name)
	cache_key = jointext(generate_icon_cache(), "_")

///Generate a unique key based on our sprites. So that if we've aleady drawn these sprites, they can be found in the cache and wont have to be drawn again (blessing and curse, but mostly curse)
/datum/bodypart_overlay/mutant/generate_icon_cache()
	. = list()
	. += "[get_base_icon_state()]"
	. += "[feature_key]"
	if(sprite_datum.color_src)
		. += "[islist(draw_color) ? jointext(draw_color, ";") : draw_color]"
	return .

///Return a dumb glob list for this specific feature (called from parse_sprite)
/datum/bodypart_overlay/mutant/proc/get_global_feature_list()
	CRASH("External organ has no feature list, it will render invisible")

///Give the organ its color. Force will override the existing one.
/datum/bodypart_overlay/mutant/proc/inherit_color(obj/item/bodypart/ownerlimb, force)
	if(draw_color && !force)
		return
	switch(color_source)
		if(ORGAN_COLOR_OVERRIDE)
			draw_color = override_color(ownerlimb)
		if(ORGAN_COLOR_INHERIT)
			draw_color = ownerlimb.draw_color
		if(ORGAN_COLOR_HAIR)
			if(!ishuman(ownerlimb.owner))
				return
			var/mob/living/carbon/human/human_owner = ownerlimb.owner
			draw_color = human_owner.hair_color
	return TRUE

/datum/bodypart_overlay/mutant/override_color(obj/item/bodypart/bodypart)
	return sprite_datum?.color_src ? bodypart.owner.dna.features["[initial(feature_key)]_color"] : null

///Sprite accessories are singletons, stored list("Big Snout" = instance of /datum/sprite_accessory/snout/big), so here we get that singleton
/datum/bodypart_overlay/mutant/proc/fetch_sprite_datum(datum/sprite_accessory/accessory_path)
	var/list/feature_list = get_global_feature_list()

	return feature_list[initial(accessory_path.name)]

///Get the singleton from the sprite name
/datum/bodypart_overlay/mutant/proc/fetch_sprite_datum_from_name(accessory_name)
	var/list/feature_list = get_global_feature_list()

	return feature_list[accessory_name]

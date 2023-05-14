GLOBAL_LIST_EMPTY_TYPED(cached_sprite_accessory_sprites, /icon)
GLOBAL_LIST_INIT(sprite_accessory_layers, list( \
	BODY_BEHIND_LAYER, \
	BODY_ADJ_LAYER, \
	BODY_FRONT_UNDER_CLOTHES, \
	BODY_FRONT_LAYER, \
))

/*

	Hello and welcome to sprite_accessories: For sprite accessories, such as hair,
	facial hair, and possibly tattoos and stuff somewhere along the line. This file is
	intended to be friendly for people with little to no actual coding experience.
	The process of adding in new hairstyles has been made pain-free and easy to do.
	Enjoy! - Doohl


	Notice: This all gets automatically compiled in a list in dna.dm, so you do not
	have to define any UI values for sprite accessories manually for hair and facial
	hair. Just add in new hair types and the game will naturally adapt.

	!!WARNING!!: changing existing hair information can be VERY hazardous to savefiles,
	to the point where you may completely corrupt a server's savefiles. Please refrain
	from doing this unless you absolutely know what you are doing, and have defined a
	conversion in savefile.dm
*/
/proc/init_sprite_accessory_subtypes(prototype, list/accessory_list, list/male, list/female, roundstart = FALSE, add_blank)//Roundstart argument builds a specific list for roundstart parts where some parts may be locked
	if(!istype(accessory_list))
		accessory_list = list()
	if(!istype(male))
		male = list()
	if(!istype(female))
		female = list()

	for(var/path in subtypesof(prototype))
		if(roundstart)
			var/datum/sprite_accessory/P = path
			if(initial(P.locked))
				continue
		var/datum/sprite_accessory/D = new path()

		if(!D.name) // Holy fuck holy shit why isn't this checked
			continue

		if(D.icon_state)
			accessory_list[D.name] = D
		else
			accessory_list += D.name

		switch(D.gender)
			if(MALE)
				male += D.name
			if(FEMALE)
				female += D.name
			else
				male += D.name
				female += D.name

	var/list/temp_list = sort_list(accessory_list)
	accessory_list.Cut()

	if(add_blank)
		accessory_list += list("None" = new /datum/sprite_accessory/blank)
	else
		// Catch sprite accessory datums that have snowflake none entries.
		var/none_entry = accessory_list["None"]
		if(none_entry)
			temp_list -= "None"
			accessory_list += list("None" = none_entry)

	accessory_list += temp_list

	return accessory_list

/datum/sprite_accessory
	/// The icon file the accessory is located in.
	var/icon
	/// The icon_state of the accessory.
	var/icon_state
	/// The preview name of the accessory.
	var/name
	/// Is appended onto icon_state. Used for caching purposes. Unfortunately used for nothing else, as sprite_overlay handes the rendering.
	var/key
	/// Determines if the accessory will be skipped or included in random hair generations.
	var/gender = NEUTER
	/// Something that can be worn by either gender, but looks different on each.
	var/gender_specific
	/// Determines if the accessory will be skipped by color preferences.
	var/use_static
	/**
	 * Currently only used by mutantparts so don't worry about hair and stuff.
	 * This is the source that this accessory will get its color from. Default is MUTCOLOR, but can also be HAIR, FACEHAIR, EYECOLOR and 0 if none.
	 * Also takes TRI_COLOR_LAYERS, which allows for up to three individually colored layers.
	 */
	var/color_src = MUTCOLORS
	/// Decides if this sprite has an "inner" part, such as the fleshy parts on ears.
	var/hasinner = FALSE
	/// Is this part locked from roundstart selection? Used for parts that apply effects.
	var/locked = FALSE
	/// Should we center the sprite?
	var/center = FALSE
	/// The width of the sprite in pixels. Used to center it if necessary.
	var/dimension_x = 32
	/// The height of the sprite in pixels. Used to center it if necessary.
	var/dimension_y = 32
	/// Should this sprite block emissives?
	var/em_block = FALSE
	/// Organ to use for this sprite accessory. The organ's sprites are overriden by the accessory sprites.
	var/organ_type_to_use
	/// A list of indexes to layer names. See /datum/sprite_accessory/New() for the defaults.
	var/list/color_layer_names = list()

/datum/sprite_accessory/New()
	. = ..()
	if(color_src == TRI_COLOR_LAYERS)
		color_layer_names = list()
		if(!GLOB.cached_sprite_accessory_sprites[icon])
			GLOB.cached_sprite_accessory_sprites[icon] = icon_states(new /icon(icon))
		for(var/layer in GLOB.sprite_accessory_layers)
			var/layertext = layer == BODY_BEHIND_LAYER ? "BEHIND" : (layer == BODY_ADJ_LAYER ? "ADJ" : "FRONT")
			var/key_text = key? "[key]_" : ""
			if("m_[key_text][icon_state]_[layertext]_primary" in GLOB.cached_sprite_accessory_sprites[icon])
				color_layer_names["1"] = "primary"
			if("m_[key_text][icon_state]_[layertext]_secondary" in GLOB.cached_sprite_accessory_sprites[icon])
				color_layer_names["2"] = "secondary"
			if("m_[key_text][icon_state]_[layertext]_tertiary" in GLOB.cached_sprite_accessory_sprites[icon])
				color_layer_names["3"] = "tertiary"

/datum/sprite_accessory/blank
	name = "None"
	icon_state = "None"

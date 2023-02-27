/datum/space_level
	var/name = "NAME MISSING"
	var/list/neigbours = list()
	var/list/traits
	var/z_value = 1 //actual z placement
	var/linkage = SELFLOOPING
	var/xi
	var/yi   //imaginary placements on the grid
	var/datum/overmap_object/related_overmap_object
	var/is_overmap_controllable = FALSE
	var/parallax_direction_override
	///Extensions for z levels as overmap objects
	var/list/all_extensions = list()

/datum/space_level/New(new_z, new_name, list/new_traits = list())
	z_value = new_z
	name = new_name
	traits = new_traits

	if (islist(new_traits))
		for (var/trait in new_traits)
			SSmapping.z_trait_levels[trait] += list(new_z)
	else // in case a single trait is passed in
		SSmapping.z_trait_levels[new_traits] += list(new_z)

	if(length(GLOB.default_lighting_underlays_by_z) < z_value)
		GLOB.default_lighting_underlays_by_z.len = z_value
	GLOB.default_lighting_underlays_by_z[z_value] = mutable_appearance(LIGHTING_ICON, "transparent", new_z, LIGHTING_PLANE, 255, RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM)
	
	set_linkage(new_traits[ZTRAIT_LINKAGE])

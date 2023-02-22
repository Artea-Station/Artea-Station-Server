//Engage Copypasta
GLOBAL_DATUM_INIT(space_overlay, /mutable_appearance, create_space_overlay())

/proc/create_space_overlay()
	var/mutable_appearance/lighting_effect = mutable_appearance('icons/effects/alphacolors.dmi')
	lighting_effect.plane = LIGHTING_PLANE
	lighting_effect.layer = LIGHTING_PRIMARY_LAYER
	lighting_effect.blend_mode = BLEND_ADD
	lighting_effect.alpha = 160
	return lighting_effect


//Non static lighting areas.
//Any lighting area that wont support static lights.
//These areas will NOT have corners generated.


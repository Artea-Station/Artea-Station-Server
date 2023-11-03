/// Supply box used for hauling/selling/buying cargo. It can be pried open to spawn related loot aswell
/obj/structure/supplies_box
	name = "supplies box"
	icon = 'icons/obj/structures/supplies_box.dmi'
	icon_state = "wodden_supply"
	anchored = FALSE
	density = TRUE
	max_integrity = 100
	interaction_flags_atom = NONE
	/// Type of the material the supply box will drop
	var/material_drop
	/// Amount of the material the supply box will drop
	var/material_drop_amount
	/// The type of the supply box
	var/supply_box_type = SUPPLY_BOX_WOOD
	/// Name of the sticker overlay
	var/sticker_overlay = "empty"
	/// Loot sheet of the supply box
	var/supply_box_loot_sheet

/obj/structure/supplies_box/Initialize()
	switch(supply_box_type)
		if(SUPPLY_BOX_WOOD)
			max_integrity = 100
			material_drop = /obj/item/stack/sheet/mineral/wood
			material_drop_amount = 4
			icon_state = "wooden_supply"
		if(SUPPLY_BOX_METAL, SUPPLY_BOX_MILITARY)
			max_integrity = 200
			material_drop = /obj/item/stack/sheet/plasteel
			material_drop_amount = 2
			if(supply_box_type == SUPPLY_BOX_MILITARY)
				icon_state = "mil_supply"
			else
				icon_state = "metal_supply"
	. = ..()
	AddElement(/datum/element/climbable, climb_time = 2 SECONDS, climb_stun = 0)
	update_appearance()

/obj/structure/supplies_box/update_overlays()
	. = ..()
	. += sticker_overlay

/obj/structure/supplies_box/deconstruct(disassembled = TRUE, mob/user)
	drop_loot()
	return ..()

/obj/structure/supplies_box/attackby(obj/item/attacking_item, mob/user, params)
	if(attacking_item.tool_behaviour == TOOL_WRENCH)
		if(isinspace() && !anchored)
			return
		set_anchored(!anchored)
		attacking_item.play_tool_sound(src, 75)
		user.visible_message(span_notice("[user] [anchored ? "anchored" : "unanchored"] \the [src] [anchored ? "to" : "from"] the ground."), \
						span_notice("You [anchored ? "anchored" : "unanchored"] \the [src] [anchored ? "to" : "from"] the ground."), \
						span_hear("You hear a ratchet."))
		return TRUE
	else if(attacking_item.tool_behaviour == TOOL_CROWBAR)
		to_chat(user, span_notice("You start prying open \the [src]..."))
		if(attacking_item.use_tool(src, user, 2 SECONDS, volume = 75))
			user.visible_message(span_notice("[user] pries open \the [src]."), \
							span_notice("You pry open \the [src]."), \
							span_hear("You hear a crack."))
			drop_loot()
			qdel(src)
		return TRUE
	return ..()

/obj/structure/supplies_box/examine(mob/user)
	. = ..()
	if(anchored)
		. += span_notice("It is <b>bolted</b> to the ground.")
	else
		. += span_notice("You could <b>bolt</b> it to the ground with a <b>wrench</b>.")
	. += span_notice("You could <b>pry</b> it open.")

/obj/structure/supplies_box/ex_act(severity)
	if(severity >= EXPLODE_DEVASTATE)
		drop_loot()
		qdel(src)
	else
		. = ..()

/obj/structure/supplies_box/proc/drop_loot()
	var/turf/my_turf = get_turf(src)
	playsound(my_turf, 'sound/items/poster_ripped.ogg', 50, TRUE)
	if(material_drop)
		new material_drop(my_turf, material_drop_amount)
	var/datum/supplies_box_loot/sheet = new supply_box_loot_sheet()
	sheet.spawn_loot(my_turf)
	qdel(sheet)

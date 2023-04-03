/**********************Ore Redemption Unit**************************/
//Turns all the various mining machines into a single unit to speed up mining and establish a point system

/obj/machinery/mineral/ore_redemption
	name = "ore redemption machine"
	desc = "A machine that accepts ore and instantly transforms it into workable material sheets. Points for ore are generated based on type and can be redeemed at a mining equipment vendor."
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "ore_redemption"
	density = TRUE
	input_dir = NORTH
	output_dir = SOUTH
	req_access = list(ACCESS_MINERAL_STOREROOM)
	layer = BELOW_OBJ_LAYER
	circuit = /obj/item/circuitboard/machine/ore_redemption
	needs_item_input = TRUE
	processing_flags = START_PROCESSING_MANUALLY

	var/points = 0
	var/ore_multiplier = 1
	var/point_upgrade = 1
	var/list/ore_values = list(/datum/material/iron = 1, /datum/material/glass = 1,  /datum/material/plasma = 15,  /datum/material/silver = 16, /datum/material/gold = 18, /datum/material/titanium = 30, /datum/material/uranium = 30, /datum/material/diamond = 50, /datum/material/bluespace = 50, /datum/material/bananium = 60)
	/// Variable that holds a timer which is used for callbacks to `send_console_message()`. Used for preventing multiple calls to this proc while the ORM is eating a stack of ores.
	var/console_notify_timer
	var/datum/techweb/stored_research
	var/obj/item/disk/design_disk/inserted_disk
	var/datum/component/remote_materials/materials

/obj/machinery/mineral/ore_redemption/Initialize(mapload)
	. = ..()
	stored_research = new /datum/techweb/specialized/autounlocking/smelter
	materials = AddComponent(/datum/component/remote_materials, "orm", mapload, mat_container_flags=BREAKDOWN_FLAGS_ORM)

/obj/machinery/mineral/ore_redemption/Destroy()
	QDEL_NULL(stored_research)
	materials = null
	return ..()

/obj/machinery/mineral/ore_redemption/examine(mob/user)
	. = ..()
	if(in_range(user, src) || isobserver(user))
		. += span_notice("The status display reads: Smelting <b>[ore_multiplier]</b> sheet(s) per piece of ore.<br>Reward point generation at <b>[point_upgrade*100]%</b>.")
	if(panel_open)
		. += span_notice("Alt-click to rotate the input and output direction.")

/obj/machinery/mineral/ore_redemption/proc/smelt_ore(obj/item/stack/ore/O)
	if(QDELETED(O))
		return
	var/datum/component/material_container/mat_container = materials.mat_container
	if (!mat_container)
		return

	if(O.refined_type == null)
		return

	if(O?.refined_type)
		points += O.points * point_upgrade * O.amount

	var/material_amount = mat_container.get_item_material_amount(O, BREAKDOWN_FLAGS_ORM)

	if(!material_amount)
		qdel(O) //no materials, incinerate it

	else if(!mat_container.has_space(material_amount * O.amount)) //if there is no space, eject it
		unload_mineral(O)

	else
		var/list/stack_mats = O.get_material_composition(BREAKDOWN_FLAGS_ORM)
		var/mats = stack_mats & mat_container.materials
		var/amount = O.amount
		mat_container.insert_item(O, ore_multiplier, breakdown_flags=BREAKDOWN_FLAGS_ORM) //insert it
		materials.silo_log(src, "smelted", amount, "someone", mats)
		qdel(O)

/obj/machinery/mineral/ore_redemption/proc/can_smelt_alloy(datum/design/D)
	var/datum/component/material_container/mat_container = materials.mat_container
	if(!mat_container || D.make_reagents.len)
		return FALSE

	var/build_amount = 0

	for(var/mat in D.materials)
		var/amount = D.materials[mat]
		var/datum/material/redemption_mat_amount = mat_container.materials[mat]

		if(!amount || !redemption_mat_amount)
			return FALSE

		var/smeltable_sheets = FLOOR(redemption_mat_amount / amount, 1)

		if(!smeltable_sheets)
			return FALSE

		if(!build_amount)
			build_amount = smeltable_sheets

		build_amount = min(build_amount, smeltable_sheets)

	return build_amount

/obj/machinery/mineral/ore_redemption/proc/process_ores(list/ores_to_process)
	for(var/ore in ores_to_process)
		smelt_ore(ore)

/obj/machinery/mineral/ore_redemption/pickup_item(datum/source, atom/movable/target, direction)
	if(QDELETED(target))
		return
	if(!materials.mat_container || panel_open || !powered())
		return

	if(istype(target, /obj/structure/ore_box))
		var/obj/structure/ore_box/box = target
		process_ores(box.contents)
	else if(istype(target, /obj/item/stack/ore))
		var/obj/item/stack/ore/O = target
		smelt_ore(O)
	else
		return

/obj/machinery/mineral/ore_redemption/default_unfasten_wrench(mob/user, obj/item/I)
	. = ..()
	if(. != SUCCESSFUL_UNFASTEN)
		return
	if(anchored)
		register_input_turf() // someone just wrenched us down, re-register the turf
	else
		unregister_input_turf() // someone just un-wrenched us, unregister the turf

/obj/machinery/mineral/ore_redemption/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	default_unfasten_wrench(user, tool)
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/machinery/mineral/ore_redemption/attackby(obj/item/W, mob/user, params)
	if(default_deconstruction_screwdriver(user, "ore_redemption-open", "ore_redemption", W))
		return
	if(default_deconstruction_crowbar(W))
		return

	if(!powered())
		return ..()

	if(istype(W, /obj/item/disk/design_disk))
		if(user.transferItemToLoc(W, src))
			inserted_disk = W
			return TRUE

	var/obj/item/stack/ore/O = W
	if(istype(O))
		if(O.refined_type == null)
			to_chat(user, span_warning("[O] has already been refined!"))
			return

	return ..()

/obj/machinery/mineral/ore_redemption/AltClick(mob/living/user)
	. = ..()
	if(!user.canUseTopic(src, BE_CLOSE))
		return
	if(panel_open)
		input_dir = turn(input_dir, -90)
		output_dir = turn(output_dir, -90)
		to_chat(user, span_notice("You change [src]'s I/O settings, setting the input to [dir2text(input_dir)] and the output to [dir2text(output_dir)]."))
		unregister_input_turf() // someone just rotated the input and output directions, unregister the old turf
		register_input_turf() // register the new one
		update_appearance(UPDATE_OVERLAYS)
		return TRUE

/obj/machinery/mineral/ore_redemption/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "OreRedemptionMachine")
		ui.open()

/obj/machinery/mineral/ore_redemption/ui_data(mob/user)
	var/list/data = list()
	data["unclaimedPoints"] = points
	data["materials"] = list()
	var/datum/component/material_container/mat_container = materials.mat_container
	if (mat_container)
		for(var/datum/material/material as anything in mat_container.materials)
			var/amount = mat_container.materials[material]
			var/sheet_amount = amount / MINERAL_MATERIAL_AMOUNT
			data["materials"] += list(list(
				"name" = material.name,
				"id" = REF(material),
				"amount" = sheet_amount,
				"category" = "material",
				"value" = ore_values[material.type],
			))

		for(var/research in stored_research.researched_designs)
			var/datum/design/alloy = SSresearch.techweb_design_by_id(research)
			data["materials"] += list(list(
				"name" = alloy.name,
				"id" = alloy.id,
				"category" = "alloy",
				"amount" = can_smelt_alloy(alloy),
			))

	if (!mat_container)
		data["disconnected"] = "local mineral storage is unavailable"
	else if (!materials.silo)
		data["disconnected"] = "no ore silo connection is available; storing locally"
	else if (materials.on_hold())
		data["disconnected"] = "mineral withdrawal is on hold"

	var/obj/item/card/id/card
	if(isliving(user))
		var/mob/living/customer = user
		card = customer.get_idcard(hand_first = TRUE)
		if(card?.registered_account)
			data["user"] = list(
				"name" = card.registered_account.account_holder,
				"cash" = card.registered_account.account_balance,
			)

		else if(issilicon(user))
			var/mob/living/silicon/silicon_player = user
			data["user"] = list(
				"name" = silicon_player.name,
				"cash" = "No valid account",
			)
	return data

/obj/machinery/mineral/ore_redemption/ui_static_data(mob/user)
	var/list/data = list()

	var/datum/component/material_container/mat_container = materials.mat_container
	if (mat_container)
		for(var/datum/material/material as anything in mat_container.materials)
			var/obj/material_display = initial(material.sheet_type)
			data["material_icons"] += list(list(
				"id" = REF(material),
				"product_icon" = icon2base64(getFlatIcon(image(icon = initial(material_display.icon), icon_state = initial(material_display.icon_state)), no_anim=TRUE)),
			))

	for(var/research in stored_research.researched_designs)
		var/datum/design/alloy = SSresearch.techweb_design_by_id(research)
		var/obj/alloy_display = initial(alloy.build_path)
		data["material_icons"] += list(list(
			"id" = alloy.id,
			"product_icon" = icon2base64(getFlatIcon(image(icon = initial(alloy_display.icon), icon_state = initial(alloy_display.icon_state)), no_anim=TRUE)),
		))

	return data


/obj/machinery/mineral/ore_redemption/ui_act(action, params)
	. = ..()
	if(.)
		return
	var/datum/component/material_container/mat_container = materials.mat_container
	switch(action)
		if("Claim")
			var/obj/item/card/id/user_id_card
			if(isliving(usr))
				var/mob/living/user = usr
				user_id_card = user.get_idcard(TRUE)
			if(points)
				if(user_id_card)
					user_id_card.mining_points += points
					points = 0
				else
					to_chat(usr, span_warning("No valid ID detected."))
			else
				to_chat(usr, span_warning("No points to claim."))
			return TRUE
		if("Release")
			if(!mat_container)
				return
			if(materials.on_hold())
				to_chat(usr, span_warning("Mineral access is on hold, please contact the quartermaster."))
			else if(!allowed(usr)) //Check the ID inside, otherwise check the user
				to_chat(usr, span_warning("Required access not found."))
			else
				var/datum/material/mat = locate(params["id"])

				var/amount = mat_container.materials[mat]
				if(!amount)
					return

				var/stored_amount = CEILING(amount / MINERAL_MATERIAL_AMOUNT, 0.1)

				if(!stored_amount)
					return

				var/desired = 0
				if (params["sheets"])
					desired = text2num(params["sheets"])
				else
					desired = tgui_input_number(usr, "How many sheets would you like to smelt?", "Smelt",  max_value = stored_amount)
					if(!desired || QDELETED(usr) || QDELETED(src) || !usr.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
						return
				var/sheets_to_remove = round(min(desired,50,stored_amount))

				var/count = mat_container.retrieve_sheets(sheets_to_remove, mat, get_step(src, output_dir))
				var/list/mats = list()
				mats[mat] = MINERAL_MATERIAL_AMOUNT
				materials.silo_log(src, "released", -count, "sheets", mats)
				//Logging deleted for quick coding
			return TRUE
		if("diskInsert")
			var/obj/item/disk/design_disk/disk = usr.get_active_held_item()
			if(istype(disk))
				if(!usr.transferItemToLoc(disk,src))
					return
				inserted_disk = disk
			else
				to_chat(usr, span_warning("Not a valid Design Disk!"))
			return TRUE
		if("diskEject")
			if(inserted_disk)
				usr.put_in_hands(inserted_disk)
				inserted_disk = null
			return TRUE
		if("diskUpload")
			var/n = text2num(params["design"])
			if(inserted_disk && inserted_disk.blueprints && inserted_disk.blueprints[n])
				stored_research.add_design(inserted_disk.blueprints[n])
			return TRUE
		if("Smelt")
			if(!mat_container)
				return
			if(materials.on_hold())
				to_chat(usr, span_warning("Mineral access is on hold, please contact the quartermaster."))
				return
			var/alloy_id = params["id"]
			var/datum/design/alloy = stored_research.isDesignResearchedID(alloy_id)
			var/obj/item/card/id/user_id_card
			if(isliving(usr))
				var/mob/living/user = usr
				user_id_card = user.get_idcard(TRUE)
			if((check_access(user_id_card) || allowed(usr)) && alloy)
				var/smelt_amount = can_smelt_alloy(alloy)
				var/desired = 0
				if (params["sheets"])
					desired = text2num(params["sheets"])
				else
					desired = tgui_input_number(usr, "How many sheets would you like to smelt?", "Smelt", max_value = smelt_amount)
					if(!desired || QDELETED(usr) || QDELETED(src) || !usr.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
						return
				var/amount = round(min(desired,50,smelt_amount))
				if(amount < 1) //no negative mats
					return
				mat_container.use_materials(alloy.materials, amount)
				materials.silo_log(src, "released", -amount, "sheets", alloy.materials)
				var/output
				if(ispath(alloy.build_path, /obj/item/stack/sheet))
					output = new alloy.build_path(src, amount)
				else
					output = new alloy.build_path(src)
				unload_mineral(output)
			else
				to_chat(usr, span_warning("Required access not found."))
			return TRUE

/obj/machinery/mineral/ore_redemption/ex_act(severity, target)
	do_sparks(5, TRUE, src)
	return ..()

/obj/machinery/mineral/ore_redemption/update_icon_state()
	icon_state = "[initial(icon_state)][powered() ? null : "-off"]"
	return ..()

/obj/machinery/mineral/ore_redemption/update_overlays()
	. = ..()
	if((machine_stat & NOPOWER))
		return
	var/image/ore_input
	var/image/ore_output

	switch(input_dir)
		if(NORTH)
			ore_input = image(icon='icons/obj/doors/airlocks/station/overlays.dmi', icon_state="unres_n")
			ore_input.pixel_y = 32
			ore_output = image(icon='icons/obj/doors/airlocks/station/overlays.dmi', icon_state="unres_s")
			ore_output.pixel_y = -32
		if(SOUTH)
			ore_input = image(icon='icons/obj/doors/airlocks/station/overlays.dmi', icon_state="unres_s")
			ore_input.pixel_y = -32
			ore_output = image(icon='icons/obj/doors/airlocks/station/overlays.dmi', icon_state="unres_n")
			ore_output.pixel_y = 32
		if(EAST)
			ore_input = image(icon='icons/obj/doors/airlocks/station/overlays.dmi', icon_state="unres_e")
			ore_input.pixel_x = 32
			ore_output = image(icon='icons/obj/doors/airlocks/station/overlays.dmi', icon_state="unres_w")
			ore_output.pixel_x = -32
		if(WEST)
			ore_input = image(icon='icons/obj/doors/airlocks/station/overlays.dmi', icon_state="unres_w")
			ore_input.pixel_x = -32
			ore_output = image(icon='icons/obj/doors/airlocks/station/overlays.dmi', icon_state="unres_e")
			ore_output.pixel_x = 32
	ore_input.color = COLOR_MODERATE_BLUE
	ore_output.color = COLOR_SECURITY_RED
	var/mutable_appearance/light_in = emissive_appearance(ore_input.icon, ore_input.icon_state, alpha = ore_input.alpha)
	light_in.pixel_y = ore_input.pixel_y
	light_in.pixel_x = ore_input.pixel_x
	var/mutable_appearance/light_out = emissive_appearance(ore_output.icon, ore_output.icon_state, alpha = ore_output.alpha)
	light_out.pixel_y = ore_output.pixel_y
	light_out.pixel_x = ore_output.pixel_x
	. += ore_input
	. += ore_output
	. += light_in
	. += light_out


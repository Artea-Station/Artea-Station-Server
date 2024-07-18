/datum/computer_file/program/restock_tracker
	filename = "restockapp"
	filedesc = "Restock Tracker"
	category = PROGRAM_CATEGORY_SUPL
	program_icon_state = "restock"
	extended_desc = "An IoT-networked app listing all official vending machines found onboard and how well-stocked they are."
	requires_ntnet = TRUE
	size = 4
	program_icon = "cash-register"
	tgui_id = "NtosRestock"

/datum/computer_file/program/restock_tracker/ui_data()
	var/list/data = list()
	var/list/vending_list = list()
	var/id_increment = 1
	for(var/obj/machinery/vending/vendor as anything in GLOB.vending_machines_to_restock)
		var/stock = vendor.total_loaded_stock()
		var/max_stock = vendor.total_max_stock()
		if(max_stock == 0 || (stock >= max_stock))
			continue
		vending_list += list(list(
			"name" = vendor.name,
			"location" = get_area_name(vendor),
			"percentage" = (stock / max_stock) * 100,
			"id" = id_increment,
		))
		id_increment++
	data["vending_list"] = vending_list
	return data

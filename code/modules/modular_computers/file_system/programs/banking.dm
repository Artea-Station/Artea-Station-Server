/datum/computer_file/program/banking
	filename = "banking"
	filedesc = "Banking"
	category = PROGRAM_CATEGORY_MISC
	program_icon_state = "generic"
	extended_desc = "An application that helps track your expenses and profits."
	size = 2
	tgui_id = "NtosBanking"
	program_icon = "money-bill-wave"
	usage_flags = PROGRAM_ALL
	///Reference to the currently logged in user.
	var/datum/bank_account/current_user

/datum/computer_file/program/banking/ui_data(mob/user)
	var/list/data = ..()
	var/obj/item/card/id/id = computer.GetID()

	if(id)
		current_user = id.registered_account
	else
		current_user = null

	if(!current_user)
		data["name"] = null
	else
		data["name"] = current_user.account_holder
		data["money"] = current_user.account_balance
		data["transaction_list"] = current_user.transaction_history

	return data

/// Logs the contents of the gasmix to the game log, prefixed by text
/proc/log_atmos(text, datum/gas_mixture/mix)
	var/message = text
	message += "TEMP=[mix.temperature] K, MOL=[mix.total_moles], VOL=[mix.volume]L"
	for(var/key in mix.gas)
		message += "[xgm_gas_data.name[key]]=[mix.gas[key]] moles;"
	log_game(message)

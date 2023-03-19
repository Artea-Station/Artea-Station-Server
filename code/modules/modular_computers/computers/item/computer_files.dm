/**
 * find_file_by_name
 *
 * Will check all applications in a tablet for files and, if they have \
 * the same filename (disregarding extension), will return it.
 * If a computer disk is passed instead, it will check the disk over the computer.
 */
/obj/item/modular_computer/proc/find_file_by_name(filename, obj/item/computer_disk/target_disk)
	if(!filename)
		return null
	if(target_disk)
		for(var/datum/computer_file/file as anything in target_disk.stored_files)
			if(file.filename == filename)
				return file
	else
		for(var/datum/computer_file/file as anything in stored_files)
			if(file.filename == filename)
				return file
	return null

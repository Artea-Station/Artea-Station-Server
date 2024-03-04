/obj/effect/mapping_helpers/bulkhead/access/all/pathfinders
	icon_state = "access_helper_sci"

/obj/effect/mapping_helpers/bulkhead/access/all/pathfinders/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_PATHFINDERS
	return access_list

/obj/effect/mapping_helpers/bulkhead/access/all/pathfinders/dock/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_PATHFINDERS_DOCK
	return access_list

/obj/effect/mapping_helpers/bulkhead/access/all/pathfinders/storage/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_PATHFINDERS_STORAGE
	return access_list

/obj/effect/mapping_helpers/bulkhead/access/all/pathfinders/leader/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_PATHFINDERS_LEAD
	return access_list

/obj/effect/mapping_helpers/bulkhead/access/all/pathfinders/pathfinders_server_room/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_PATHFINDERS_SERVER_ROOM
	return access_list

// Any
/obj/effect/mapping_helpers/bulkhead/access/any/pathfinders
	icon_state = "access_helper_sci"

/obj/effect/mapping_helpers/bulkhead/access/any/pathfinders/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_PATHFINDERS
	return access_list

/obj/effect/mapping_helpers/bulkhead/access/any/pathfinders/dock/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_PATHFINDERS_DOCK
	return access_list

/obj/effect/mapping_helpers/bulkhead/access/any/pathfinders/storage/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_PATHFINDERS_STORAGE
	return access_list

/obj/effect/mapping_helpers/bulkhead/access/any/pathfinders/leader/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_PATHFINDERS_LEAD
	return access_list

/obj/effect/mapping_helpers/bulkhead/access/any/pathfinders/pathfinders_server_room/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_PATHFINDERS_SERVER_ROOM
	return access_list

/// Sent when /datum/storage/dump_content_at(): (obj/item/storage_source, mob/user)
#define COMSIG_STORAGE_DUMP_CONTENT "storage_dump_contents"
///(obj/item/inserting, mob/user, silent, force) - returns bool
#define COMSIG_TRY_STORAGE_INSERT "storage_try_insert"
///(obj, new_loc, force = FALSE) - returns bool
#define COMSIG_TRY_STORAGE_TAKE "storage_take_obj"
	/// Return to stop the standard dump behavior.
	#define STORAGE_DUMP_HANDLED (1<<0)

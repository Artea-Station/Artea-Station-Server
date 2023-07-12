
/obj/item/disk/tech_disk
	name = "technology disk"
	desc = "A disk for storing technology data for further research."
	icon_state = "datadisk0"
	custom_materials = list(/datum/material/iron=300, /datum/material/glass=100)
	var/datum/techweb/stored_research

/obj/item/disk/tech_disk/Initialize(mapload)
	. = ..()
	pixel_x = base_pixel_x + rand(-5, 5)
	pixel_y = base_pixel_y + rand(-5, 5)

	if(!stored_research)
		stored_research = new /datum/techweb
		return

	stored_research = new stored_research

/obj/item/disk/tech_disk/debug
	name = "\improper CentCom technology disk"
	desc = "A debug item for research"
	custom_materials = null
	stored_research = /datum/techweb/admin

/obj/item/disk/tech_disk/bepis
	name = "Reformatted technology disk"
	desc = "A disk containing a new, completed tech from the B.E.P.I.S. Upload the disk to an R&D Console to redeem the tech."
	icon_state = "rndmajordisk"
	custom_materials = list(/datum/material/iron=300, /datum/material/glass=100)
	stored_research = /datum/techweb/bepis

/obj/item/disk/tech_disk/bepisloot
	name = "Old experimental technology disk"
	desc = "A disk containing some long-forgotten technology from a past age. You hope it still works after all these years. Upload the disk to an R&D Console to redeem the tech."
	icon_state = "rndmajordisk"
	custom_materials = list(/datum/material/iron=300, /datum/material/glass=100)
	stored_research = /datum/techweb/bepis/no_remove

/obj/item/disk/tech_disk/minor
	name = "written technology disk"
	desc = "A disk containing some technology. You hope it still works after all this time. Upload the disk to an R&D Console to redeem the tech."
	icon_state = "rndmajordisk"
	custom_materials = list(/datum/material/iron=300, /datum/material/glass=100)
	stored_research = /datum/techweb/bepis/no_remove

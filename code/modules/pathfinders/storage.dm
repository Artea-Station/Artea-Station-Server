// Yes, it's the tactical medkit sprite. No, I don't care.
/obj/item/storage/medkit/pathfinder
	name = "Emergency Medical Kit"
	desc = "Contains life insurance papers, and a host of general purpose meds. Intended last until you get back to the station for proper treatment."
	icon_state = "medkit_tactical"
	damagetype_healed = "all"

/obj/item/storage/medkit/pathfinder/empty
	empty = TRUE

/obj/item/storage/medkit/pathfinder/PopulateContents()
	atom_storage.max_slots = 8
	if(empty)
		return
	var/static/items_inside = list(
		/obj/item/paper/fluff/pathfinder = 1,
		/obj/item/stack/medical/gauze = 2,
		/obj/item/stack/medical/suture = 2,
		/obj/item/stack/medical/ointment = 1,
		/obj/item/reagent_containers/hypospray/medipen = 2,
	)
	generate_items_inside(items_inside,src)

/obj/item/paper/fluff/pathfinder
	name = "Pathfinder Insurance Policy"
	desc = "A paper that says... something about legal technicalities, and how you are already owned by the company, and how it's illegal to die."

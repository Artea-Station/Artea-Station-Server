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
	default_raw_text = "Welcome to the Galactic Insurance Agency! We are pleased to offer you our comprehensive insurance policy for all your needs. This policy covers everything from space travel accidents to intergalactic pet care. Please note that this policy is only valid for individuals who are alive and well, as it is illegal to die in the year 623. \
 \
Section 1: Coverage for Space Travel Accidents \
In the event of a space travel accident, this policy covers all medical expenses, including but not limited to emergency transportation, medical procedures, and rehabilitation. This policy also covers property damage caused by space debris or other space-related incidents. \
 \
Section 2: Coverage for Intergalactic Pet Care \
We understand that pets are important members of your family, even in the year 623. That's why this policy includes coverage for all pet-related expenses, including medical care, grooming, and even intergalactic pet hotels. \
 \
Section 3: Coverage for Cyber Attacks \
As technology advances, so do the risks of cyber attacks. This policy covers all expenses related to cyber attacks, including but not limited to data recovery, system repairs, and legal fees. \
 \
Section 4: Coverage for Time Travel Mishaps \
Time travel can be unpredictable, which is why we offer coverage for any time travel mishaps, including but not limited to accidentally altering historical events or getting stuck in a time loop. \
 \
Section 5: Coverage for Alien Abduction \
In the unlikely event that you are abducted by extraterrestrial beings, this policy provides coverage for any medical expenses, including examinations and treatments for injuries or illnesses resulting from the abduction. This policy also covers any property damage caused during the abduction, including damage to vehicles or buildings. In addition, we offer a reimbursement for any lost wages or income resulting from the abduction. Please note that this coverage is subject to verification by our claims department and may require documentation of the abduction event. \
 \
Section 6: Illegal to Die \
Please note that it is illegal to die in the year 623. Any individuals found to be deceased will not be covered under this policy. However, in the event of a near-death experience, this policy covers all medical expenses related to resuscitation and recovery. \
 \
Section 7: Exclusions \
This policy does not cover intentional acts of harm or damage caused by criminal activity. This policy also does not cover damages caused by acts of war or terrorism. \
 \
Thank you for choosing the Galactic Insurance Agency for all your insurance needs. We hope that you never have to use this policy, but rest assured that we are here for you in the event of any unforeseen circumstances."

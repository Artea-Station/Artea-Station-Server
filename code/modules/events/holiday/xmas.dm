/obj/item/toy/xmas_cracker
	name = "xmas cracker"
	icon = 'icons/obj/holiday/christmas.dmi'
	icon_state = "cracker"
	desc = "Directions for use: Requires two people, one to pull each end."
	/// The crack state of the toy. If set to TRUE, you can no longer crack it by attacking.
	var/cracked = FALSE

/obj/item/toy/xmas_cracker/attack(mob/target, mob/user)
	if( !cracked && ishuman(target) && (target.stat == CONSCIOUS) && !target.get_active_held_item() )
		target.visible_message(span_notice("[user] and [target] pop \an [src]! *pop*"), span_notice("You pull \an [src] with [target]! *pop*"), span_hear("You hear a pop."))
		var/obj/item/paper/joke_paper = new /obj/item/paper(user.loc)
		joke_paper.name = "[pick("awful","terrible","unfunny")] joke"
		joke_paper.add_raw_text(pick("What did one snowman say to the other?\n\n<i>'Is it me or can you smell carrots?'</i>",
			"Why couldn't the snowman get laid?\n\n<i>He was frigid!</i>",
			"Where are santa's helpers educated?\n\n<i>Nowhere, they're ELF-taught.</i>",
			"What happened to the man who stole advent calanders?\n\n<i>He got 25 days.</i>",
			"What does Santa get when he gets stuck in a chimney?\n\n<i>Claus-trophobia.</i>",
			"Where do you find chili beans?\n\n<i>The north pole.</i>",
			"What do you get from eating tree decorations?\n\n<i>Tinsilitis!</i>",
			"What do snowmen wear on their heads?\n\n<i>Ice caps!</i>",
			"Why is Christmas just like life on ss13?\n\n<i>You do all the work and the fat guy gets all the credit.</i>",
			"Why doesn't Santa have any children?\n\n<i>Because he only comes down the chimney.</i>"))
		joke_paper.update_appearance()
		new /obj/item/clothing/head/festive(target.loc)
		user.update_icons()
		cracked = TRUE
		icon_state = "cracker1"
		var/obj/item/toy/xmas_cracker/other_half = new /obj/item/toy/xmas_cracker(target)
		other_half.cracked = 1
		other_half.icon_state = "cracker2"
		target.put_in_active_hand(other_half)
		playsound(user, 'sound/effects/snap.ogg', 50, TRUE)
		return TRUE
	return ..()

/obj/item/clothing/head/festive
	name = "festive paper hat"
	icon_state = "xmashat"
	desc = "A crappy paper hat that you are REQUIRED to wear."
	flags_inv = 0
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 0, ACID = 0)
	dog_fashion = /datum/dog_fashion/head/festive

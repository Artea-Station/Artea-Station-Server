// Valentine's Day events //
// why are you playing spessmens on valentine's day you wizard //

#define VALENTINE_FILE "valentines.json"

// valentine / candy heart distribution //

/obj/item/valentine
	name = "valentine"
	desc = "A Valentine's card! Wonder what it says..."
	icon = 'icons/obj/toys/playing_cards.dmi'
	icon_state = "sc_Ace of Hearts_syndicate" // shut up // bye felicia
	var/message = "A generic message of love or whatever."
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_TINY

/obj/item/valentine/Initialize(mapload)
	. = ..()
	message = pick(strings(VALENTINE_FILE, "valentines"))

/obj/item/valentine/attackby(obj/item/W, mob/user, params)
	..()
	if(istype(W, /obj/item/pen) || istype(W, /obj/item/toy/crayon))
		if(!user.can_write(W))
			return
		var/recipient = tgui_input_text(user, "Who is receiving this valentine?", "To:", max_length = MAX_NAME_LEN)
		var/sender = tgui_input_text(user, "Who is sending this valentine?", "From:", max_length = MAX_NAME_LEN)
		if(!user.canUseTopic(src, BE_CLOSE))
			return
		if(recipient && sender)
			name = "valentine - To: [recipient] From: [sender]"

/obj/item/valentine/examine(mob/user)
	. = ..()
	if(in_range(user, src) || isobserver(user))
		if( !(ishuman(user) || isobserver(user) || issilicon(user)) )
			user << browse("<HTML><HEAD><TITLE>[name]</TITLE></HEAD><BODY>[stars(message)]</BODY></HTML>", "window=[name]")
			onclose(user, "[name]")
		else
			user << browse("<HTML><HEAD><TITLE>[name]</TITLE></HEAD><BODY>[message]</BODY></HTML>", "window=[name]")
			onclose(user, "[name]")
	else
		. += span_notice("It is too far away.")

/obj/item/valentine/attack_self(mob/user)
	user.examinate(src)

/obj/item/food/candyheart
	name = "candy heart"
	icon = 'icons/obj/holiday/holiday_misc.dmi'
	icon_state = "candyheart"
	desc = "A heart-shaped candy that reads: "
	food_reagents = list(/datum/reagent/consumable/sugar = 2)
	junkiness = 5

/obj/item/food/candyheart/Initialize(mapload)
	. = ..()
	desc = pick(strings(VALENTINE_FILE, "candyhearts"))
	icon_state = pick("candyheart", "candyheart2", "candyheart3", "candyheart4")

/obj/item/clothing/head/clownmitre
	name = "Hat of the Honkmother"
	desc = "It's hard for parishoners to see a banana peel on the floor when they're looking up at your glorious chapeau."
	icon_state = "clownmitre"

/obj/item/clothing/head/kippah
	name = "kippah"
	desc = "Signals that you follow the Jewish Halakha. Keeps the head covered and the soul extra-Orthodox."
	icon_state = "kippah"

/obj/item/clothing/head/taqiyahwhite
	name = "white taqiyah"
	desc = "An extra-mustahabb way of showing your devotion to Allah."
	icon_state = "taqiyahwhite"

/obj/item/clothing/head/taqiyahwhite/Initialize(mapload)
	. = ..()
	
	create_storage(type = /datum/storage/pockets/small)

/obj/item/clothing/head/taqiyahred
	name = "red taqiyah"
	desc = "An extra-mustahabb way of showing your devotion to Allah."
	icon_state = "taqiyahred"

/obj/item/clothing/head/taqiyahred/Initialize(mapload)
	. = ..()
	
	create_storage(type = /datum/storage/pockets/small)

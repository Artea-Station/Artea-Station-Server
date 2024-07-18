//spooky foods (you can't actually make these when it's not halloween)
/obj/item/food/cookie/sugar/spookyskull
	name = "skull cookie"
	desc = "Spooky! It's got delicious calcium flavouring!"
	icon = 'icons/obj/holiday/halloween_items.dmi'
	icon_state = "skeletoncookie"

/obj/item/food/cookie/sugar/spookycoffin
	name = "coffin cookie"
	desc = "Spooky! It's got delicious coffee flavouring!"
	icon = 'icons/obj/holiday/halloween_items.dmi'
	icon_state = "coffincookie"

//spooky items

/obj/item/storage/spooky
	name = "trick-o-treat bag"
	desc = "A pumpkin-shaped bag that holds all sorts of goodies!"
	icon = 'icons/obj/holiday/halloween_items.dmi'
	icon_state = "treatbag"

/obj/item/storage/spooky/Initialize(mapload)
	. = ..()
	for(var/distrobuteinbag in 0 to 5)
		var/type = pick(/obj/item/food/cookie/sugar/spookyskull,
		/obj/item/food/cookie/sugar/spookycoffin,
		/obj/item/food/candy_corn,
		/obj/item/food/candy,
		/obj/item/food/candiedapple,
		/obj/item/food/chocolatebar,
		/obj/item/organ/internal/brain ) // OH GOD THIS ISN'T CANDY!
		new type(src)

/obj/item/radio/headset/headset_pth
	name = "pathfinders radio headset"
	desc = "A spacey headset. Has no ratings on vacuum resistance."
	icon_state = "pathfinder_headset"
	keyslot = new /obj/item/encryptionkey/headset_pth

/obj/item/radio/headset/headset_pth_medic
	name = "pathfinders medical radio headset"
	desc = "A spacey headset with extra blue. Does not come with a doctorate."
	icon_state = "pathfindermed_headset"
	keyslot = new /obj/item/encryptionkey/headset_pthmed

/obj/item/encryptionkey/headset_pth
	name = "pathfinders radio encryption key"
	icon_state = "cypherkey_research"
	channels = list(RADIO_CHANNEL_PATHFINDERS = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_pathfinders
	greyscale_colors = "#847A96#575577"

/obj/item/encryptionkey/headset_pthmed
	name = "pathfinders medic radio encryption key"
	icon_state = "cypherkey_research"
	channels = list(RADIO_CHANNEL_PATHFINDERS = 1, RADIO_CHANNEL_MEDICAL = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_pathfinders
	greyscale_colors = "#847A96#ebebeb"

/obj/item/radio/headset/heads/pl
	name = "\proper the lead pathfinder's headset"
	desc = "The headset of the guy who insists they're technically a captain."
	icon_state = "com_headset"
	keyslot = new /obj/item/encryptionkey/heads/pl

/obj/item/encryptionkey/heads/pl
	name = "\proper the lead pathfinder's encryption key"
	icon_state = "cypherkey_research"
	channels = list(RADIO_CHANNEL_PATHFINDERS = 1, RADIO_CHANNEL_SUPPLY = 1, RADIO_CHANNEL_COMMAND = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_pathfinders
	greyscale_colors = "#847A96#575577"

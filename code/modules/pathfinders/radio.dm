/obj/item/radio/headset/headset_pth
	name = "pathfinders radio headset"
	desc = "A spacey headset. Has no ratings on vacuum resistance."
	icon_state = "pathfinder_headset"
	keyslot = new /obj/item/encryptionkey/headset_pth

/obj/item/radio/headset/headset_pth
	name = "pathfinders medical radio headset"
	desc = "A spacey headset with extra blue. Does not come with a doctorate or medical comms access."
	icon_state = "pathfindermedical_headset"
	keyslot = new /obj/item/encryptionkey/headset_pth

/obj/item/encryptionkey/headset_pth
	name = "pathfinders radio encryption key"
	icon_state = "cypherkey_research"
	channels = list(RADIO_CHANNEL_PATHFINDERS = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_pathfinders
	greyscale_colors = "#847A96#575577"

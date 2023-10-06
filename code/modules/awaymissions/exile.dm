
/obj/structure/closet/secure_closet/exile
	name = "exile implants"
	req_access = list(ACCESS_SECURITY_HEAD)

/obj/structure/closet/secure_closet/exile/PopulateContents()
	new /obj/item/implanter/exile(src)
	for(var/i in 1 to 5)
		new /obj/item/implantcase/exile(src)

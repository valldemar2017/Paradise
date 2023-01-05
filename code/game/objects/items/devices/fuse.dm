/obj/item/fuse
	name = "fuse"
	icon = 'icons/obj/device.dmi'
	icon_state = "fuse"
	w_class = WEIGHT_CLASS_TINY

/obj/item/fuse/bluespace
	name = "bluespace fuse"
	icon = 'icons/obj/device.dmi'
	icon_state = "bs_fuse"
	w_class = WEIGHT_CLASS_TINY

/obj/item/fakeartefact/fuse
	possible = list(
		/obj/item/fuse
	)

/obj/item/fakeartefact/fuse/New()
	. = ..()
	icon = 'icons/obj/device.dmi'
	icon_state ="fuse-b"

/obj/item/fakeartefact/fuse/decompile_act(obj/item/matter_decompiler/C, mob/user)
	C.stored_comms["metal"] += 1
	qdel(src)
	return TRUE



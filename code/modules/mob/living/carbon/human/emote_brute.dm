#define BME_FORCE 1

/mob/proc/emote_brute()
	return

/mob/living/carbon/human/verb/me_brute(mob/M as mob)
	set name = "Me Brute"
	set category = "IC"

	if (istype(M, /mob/living/carbon/human) && usr != M && src != M)
		emote_brute(M)

/mob/living/carbon/human/emote_brute(mob/living/carbon/human/P)

	var/mob/living/carbon/human/H = usr

	var/meMsg = sanitize(copytext_char(input(src,, "brute me (text)") as text|null,1,MAX_MESSAGE_LEN))
	if (!meMsg)
		return

	var/obj/item/I = H.get_active_hand();

	if (!Adjacent(P) || !(P in view(H.loc)))
		to_chat(usr, "<span class='notice'><b>[P.name]</b> слишком далеко!</span>")
		return

	var/obj/item/organ/external/affecting = P.get_organ(usr.zone_selected)
	if(!affecting)
		to_chat(usr, "<span class='notice'>У <b>[P.name]</b> нет этой конечности!</span>")
		return

	if(world.time <= H.last_interract + 1 SECONDS)
		return

	H.last_interract = world.time

	H.visible_message("<span class='red'><b>[H]</b> [meMsg]</span>")
	if (istype(P.loc, /obj/structure/closet))
		P.visible_message("<span class='red'><b>[H]</b> [meMsg]</span>")

	H.do_attack_animation(P)

	var/damtype = I ? I.damtype : BRUTE

	if (affecting.brute_dam < 5 && damtype == BRUTE)
		affecting.receive_damage(BME_FORCE)

	if (affecting.burn_dam < 5 && damtype == BURN)
		affecting.receive_damage(0, BME_FORCE)

	playsound(loc, (I && I.hitsound) ? I.hitsound : 'sound/weapons/thudswoosh.ogg', (I && I.hitsound) ? 50 : 15, 1, -1)
	add_attack_logs(usr, P, "Melee attacked with [I ? I : "fists"] (BruteMe)")
	log_emote(meMsg, usr)

	P.UpdateDamageIcon()

#undef BME_FORCE
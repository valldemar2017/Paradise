// Basic lighters
/obj/item/lighter
	name = "cheap lighter"
	desc = "A cheap-as-free lighter."
	icon = 'icons/obj/items.dmi'
	icon_state = "lighter-g"
	item_state = "lighter-g"
	w_class = WEIGHT_CLASS_TINY
	throwforce = 4
	flags = CONDUCT
	slot_flags = SLOT_BELT
	attack_verb = null
	resistance_flags = FIRE_PROOF
	var/lit = FALSE
	var/icon_on = "lighter-g-on"
	var/icon_off = "lighter-g"

/obj/item/lighter/random/New()
	..()
	var/color = pick("r","c","y","g")
	icon_on = "lighter-[color]-on"
	icon_off = "lighter-[color]"
	icon_state = icon_off

/obj/item/lighter/attack_self(mob/living/user)
	. = ..()
	if(!lit)
		turn_on_lighter(user)
	else
		turn_off_lighter(user)

/obj/item/lighter/proc/turn_on_lighter(mob/living/user)
	lit = TRUE
	w_class = WEIGHT_CLASS_BULKY
	icon_state = icon_on
	item_state = icon_on
	force = 5
	damtype = BURN
	hitsound = 'sound/items/welder.ogg'
	attack_verb = list("burnt", "singed")

	attempt_light(user)
	set_light(2)
	START_PROCESSING(SSobj, src)

/obj/item/lighter/proc/attempt_light(mob/living/user)
	if(prob(75) || issilicon(user)) // Robots can never burn themselves trying to light it.
		to_chat(user, "<span class='notice'>You light [src].</span>")
	else
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/affecting = H.get_organ("[user.hand ? "l" : "r" ]_hand")
		if(affecting.receive_damage( 0, 5 ))		//INFERNO
			H.UpdateDamageIcon()
		to_chat(user,"<span class='notice'>You light [src], but you burn your hand in the process.</span>")

/obj/item/lighter/proc/turn_off_lighter(mob/living/user)
	lit = FALSE
	w_class = WEIGHT_CLASS_TINY
	icon_state = icon_off
	item_state = icon_off
	hitsound = "swing_hit"
	force = 0
	attack_verb = null //human_defense.dm takes care of it

	show_off_message(user)
	set_light(0)
	STOP_PROCESSING(SSobj, src)

/obj/item/lighter/proc/show_off_message(mob/living/user)
	to_chat(user, "<span class='notice'>You shut off [src].")

/obj/item/lighter/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!isliving(M))
		return
	M.IgniteMob()
	if(!istype(M, /mob))
		return

	if(istype(M.wear_mask, /obj/item/clothing/mask/cigarette) && user.zone_selected == "mouth" && lit)
		var/obj/item/clothing/mask/cigarette/cig = M.wear_mask
		if(M == user)
			cig.attackby(src, user)
		else
			if(istype(src, /obj/item/lighter/zippo))
				cig.light("<span class='rose'>[user] whips the [name] out and holds it for [M]. [user.p_their(TRUE)] arm is as steady as the unflickering flame [user.p_they()] light[user.p_s()] \the [cig] with.</span>")
			else
				cig.light("<span class='notice'>[user] holds the [name] out for [M], and lights the [cig.name].</span>")
			M.update_inv_wear_mask()
	else
		..()

/obj/item/lighter/process()
	var/turf/location = get_turf(src)
	if(location)
		location.hotspot_expose(700, 5)
	return

// Zippo lighters
/obj/item/lighter/zippo
	name = "zippo lighter"
	desc = "The zippo."
	icon_state = "zippo"
	item_state = "zippo"
	icon_on = "zippoon"
	icon_off = "zippo"
	var/next_on_message
	var/next_off_message

/obj/item/lighter/zippo/turn_on_lighter(mob/living/user)
	. = ..()
	if(world.time > next_on_message)
		user.visible_message("<span class='rose'>Without even breaking stride, [user] flips open and lights [src] in one smooth movement.</span>")
		playsound(src.loc, 'sound/items/zippolight.ogg', 25, 1)
		next_on_message = world.time + 5 SECONDS
	else
		to_chat(user, "<span class='notice'>You light [src].</span>")

/obj/item/lighter/zippo/turn_off_lighter(mob/living/user)
	. = ..()
	if(world.time > next_off_message)
		user.visible_message("<span class='rose'>You hear a quiet click, as [user] shuts off [src] without even looking at what [user.p_theyre()] doing. Wow.")
		playsound(src.loc, 'sound/items/zippoclose.ogg', 25, 1)
		next_off_message = world.time + 5 SECONDS
	else
		to_chat(user, "<span class='notice'>You shut off [src].")

/obj/item/lighter/zippo/show_off_message(mob/living/user)
	return

/obj/item/lighter/zippo/attempt_light(mob/living/user)
	return

//EXTRA LIGHTERS
/obj/item/lighter/zippo/nt_rep
	name = "gold engraved zippo"
	desc = "An engraved golden Zippo lighter with the letters NT on it."
	icon_state = "zippo_nt_off"
	icon_on = "zippo_nt_on"
	icon_off = "zippo_nt_off"

/obj/item/lighter/zippo/blue
	name = "blue zippo lighter"
	desc = "A zippo lighter made of some blue metal."
	icon_state = "bluezippo"
	icon_on = "bluezippoon"
	icon_off = "bluezippo"

/obj/item/lighter/zippo/black
	name = "black zippo lighter"
	desc = "A black zippo lighter."
	icon_state = "blackzippo"
	icon_on = "blackzippoon"
	icon_off = "blackzippo"

/obj/item/lighter/zippo/engraved
	name = "engraved zippo lighter"
	desc = "A intricately engraved zippo lighter."
	icon_state = "engravedzippo"
	icon_on = "engravedzippoon"
	icon_off = "engravedzippo"

/obj/item/lighter/zippo/gonzofist
	name = "Gonzo Fist zippo"
	desc = "A Zippo lighter with the iconic Gonzo Fist on a matte black finish."
	icon_state = "gonzozippo"
	icon_on = "gonzozippoon"
	icon_off = "gonzozippo"
/obj/item/lighter/zippo/head_security
	name ="Head of Security zippo"
	desc = "A limited edition Zippo for NT Heads. Fuel it with the clown's tears."
	icon_state = "zippo_hos"
	icon_on = "zippo_hos_open"
	icon_off = "zippo_hos"
/obj/item/lighter/zippo/head_personnel
	name="Head of Personnel lighter"
	desc="A limited edition lighter for NT Heads. Tries its best to look like the Captains."
	icon_state = "zippo_hop"
	icon_on = "zippo_hop_open"
	icon_off="zippo_hop"
/obj/item/lighter/zippo/head_ce
	name="Chief Engineer electric lighter"
	desc="A tiny handmade tesla coil, apparently used like a lighter. Does not seem to have a power source.. What?"
	icon_state="zippo_ce"
	icon_on = "zippo_ce_open"
	icon_off = "zippo_ce"
/obj/item/lighter/zippo/head_cmo
	name="Chief Medical Officer zippo"
	desc="A limited edition Zippo for NT Heads. It's made of silver and smells sterile"
	icon_state="zippo_cmo"
	icon_on = "zippo_cmo_open"
	icon_off="zippo_cmo"
/obj/item/lighter/zippo/head_rd
	name="Research Director lighter"
	desc = "A handheld micro-laser, has enough power to light something on fire. Does not seem to have a power source.. Weird."
	icon_state="zippo_rd"
	icon_on = "zippo_rd_open"
	icon_off="zippo_rd"
/obj/item/lighter/zippo/captain
	name = "Captain's lighter"
	desc = "A limited edition golden lighter made specifically for NT Captains. Look very expensive, and trust me, it is."
	icon_state = "zippo_cap"
	icon_on = "zippo_cap_open"
	icon_off = "zippo_cap"
/obj/item/lighter/zippo/ai
	name = "AI zippo"
	desc = "A limited edition zippo, made to look like an AI core"
	icon_state = "zippo_ai"
	icon_on = "zippo_ai_open"
	icon_off ="zippo_ai"
/obj/item/lighter/zippo/ai/attempt_light(mob/living/user)
	to_chat(user,"<span class='rose'>[generate_ion_law]()</span>")
	overlays.Cut()
	overlays.Add(pick("zippo_ai-ai","zippo_ai-bliss","zippo_ai-banned","zippo_ai-anima","zippo_ai-angry","zippo_ai-angel","zippo_ai-clown","zippo_ai-database","zippo_ai-dorf","zippo_ai-fuzz","zippo_ai-glitchman","zippo_ai-goon","zippo_ai-hades","zippo_ai-heartline","zippo_ai-helios","zippo_ai-house","zippo_ai-murica","zippo_ai-syndicatmeow","zippo_ai-magma","zippo_ai-malf","zippo_ai-mono","zippo_ai-red","zippo_ai-text"))
	return

/obj/item/lighter/zippo/ai/show_off_message(mob/living/user)
	to_chat(user,"<span class='rose'>You hear a quiet click. The screen turns black</span>")
	overlays.Cut()
	overlays.Add("zippo_ai-empty")
	return
///////////
//MATCHES//
///////////
/obj/item/match
	name = "match"
	desc = "A simple match stick, used for lighting fine smokables."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "match_unlit"
	var/lit = FALSE
	var/burnt = FALSE
	var/smoketime = 5
	w_class = WEIGHT_CLASS_TINY
	origin_tech = "materials=1"
	attack_verb = null

/obj/item/match/process()
	var/turf/location = get_turf(src)
	smoketime--
	if(smoketime < 1)
		matchburnout()
	if(location)
		location.hotspot_expose(700, 5)
		return

/obj/item/match/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume, global_overlay = TRUE)
	..()
	matchignite()

/obj/item/match/proc/matchignite()
	if(!lit && !burnt)
		lit = TRUE
		icon_state = "match_lit"
		damtype = "fire"
		force = 3
		hitsound = 'sound/items/welder.ogg'
		item_state = "cigon"
		name = "lit match"
		desc = "A match. This one is lit."
		attack_verb = list("burnt","singed")
		START_PROCESSING(SSobj, src)
		update_icon()
		return TRUE

/obj/item/match/proc/matchburnout()
	if(lit)
		lit = FALSE
		burnt = TRUE
		damtype = "brute"
		force = initial(force)
		icon_state = "match_burnt"
		item_state = "cigoff"
		name = "burnt match"
		desc = "A match. This one has seen better days."
		attack_verb = list("flicked")
		STOP_PROCESSING(SSobj, src)
		return TRUE

/obj/item/match/dropped(mob/user)
	matchburnout()
	. = ..()

/obj/item/match/attack(mob/living/carbon/M, mob/living/carbon/user)
	if(!isliving(M))
		return ..()
	if(lit && M.IgniteMob())
		message_admins("[key_name_admin(user)] set [key_name_admin(M)] on fire")
		log_game("[key_name(user)] set [key_name(M)] on fire")
	var/obj/item/clothing/mask/cigarette/cig = help_light_cig(M)
	if(lit && cig && user.a_intent == INTENT_HELP)
		if(cig.lit)
			to_chat(user, "<span class='notice'>[cig] is already lit.</span>")
		if(M == user)
			cig.attackby(src, user)
		else
			cig.light("<span class='notice'>[user] holds [src] out for [M], and lights [cig].</span>")
	else
		..()

/obj/item/match/decompile_act(obj/item/matter_decompiler/C, mob/user)
	if(burnt)
		C.stored_comms["wood"] += 1
		qdel(src)
		return TRUE
	return ..()

/obj/item/proc/help_light_cig(mob/living/M)
	var/mask_item = M.get_item_by_slot(slot_wear_mask)
	if(istype(mask_item, /obj/item/clothing/mask/cigarette))
		return mask_item

/obj/item/match/firebrand
	name = "firebrand"
	desc = "An unlit firebrand. It makes you wonder why it's not just called a stick."
	smoketime = 20 //40 seconds

/obj/item/match/firebrand/New()
	..()
	matchignite()

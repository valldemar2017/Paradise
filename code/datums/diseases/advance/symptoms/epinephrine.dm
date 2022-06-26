/*
//////////////////////////////////////

Inotropical hyperfunction
	Lowers stealth
	Lowers resistance.
	Decreases stage speed slightly.
	Decreases transmittablity.
	Fatal Level.

Bonus
	The body generates epinephrine at low health slowly overdosing host

//////////////////////////////////////
*/

/datum/symptom/epinephrine

	name = "Inotropical Hyperfunction"
	stealth = -5
	resistance = -4
	stage_speed = -1
	transmittable = -2
	level = 7

/datum/symptom/epinephrine/Activate(datum/disease/advance/A)
	..()
	var/mob/living/M = A.affected_mob
	if(prob(SYMPTOM_ACTIVATION_PROB * 0.5) && A.stage == 5)
		to_chat(M, "<span class='notice'>[pick("Your body feels tough.", "You are feeling on edge.")]</span>")
	if(A.stage > 4 && M.health <= HEALTH_THRESHOLD_CRIT)
		M.reagents.add_reagent("epinephrine", 0.5)
	return

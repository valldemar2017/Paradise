//Ancient cryogenic sleepers. Players become NT crewmen from a hundred year old space station, now on the verge of collapse.

/obj/effect/mob_spawn/human/oldsec
	name = "old cryogenics pod"
	desc = "Гудящая криокапсула. Вы едва узнаете форму офицера безопасности под накопившимся льдом. Машина пытается разбудить своего пользователя."
	mob_name = "a security officer"
	icon = 'icons/obj/cryogenic2.dmi'
	icon_state = "sleeper"
	roundstart = FALSE
	death = FALSE
	random = TRUE
	mob_species = /datum/species/human
	description = "Работайте в команде с другими выжившими на этой разрушенной, древней космической станции."
	important_info = ""
	flavour_text = "Вы офицер безопасности работающий на Нанотрейзен, вы служите на борту исследовательской станции, оснащенной по последнему слову науки. Вы отдаленно помните \
	как вы запрыгнули в криогенную капсулу из-за надвигающегося радиационного шторма. Последнее что вы помните, это как станционная Исскуственная Программа сообщила вам, что вы будете спать восемь часов. \
	Открыв свои глаза, вы видите, как всё вокруг проржавело и покосилось, чувство ужаса поднимается в вашем животе, пока вы выкарабкиваетесь из своей капсулы..."
	uniform = /obj/item/clothing/under/retro/security
	shoes = /obj/item/clothing/shoes/jackboots
	id = /obj/item/card/id/away/old/sec
	r_pocket = /obj/item/restraints/handcuffs
	l_pocket = /obj/item/flash
	assignedrole = "Ancient Crew"

/obj/effect/mob_spawn/human/oldsec/Destroy()
	new /obj/structure/showcase/machinery/oldpod/used(drop_location())
	return ..()

/obj/effect/mob_spawn/human/oldmed
	name = "old cryogenics pod"
	desc = "Гудящая криокапсула. Вы едва узнаете форму медицинского офицера под накопившимся льдом. Машина пытается разбудить своего пользователя."
	mob_name = "a medical doctor"
	icon = 'icons/obj/cryogenic2.dmi'
	icon_state = "sleeper"
	roundstart = FALSE
	death = FALSE
	random = TRUE
	mob_species = /datum/species/human
	description = "Работайте в команде с другими выжившими на этой разрушенной, древней космической станции."
	important_info = ""
	flavour_text = "Вы доктор работающий на Нанотрейзен, вы служите на борту исследовательской станции, оснащенной по последнему слову науки. Вы отдаленно помните \
	как вы запрыгнули в криогенную капсулу из-за надвигающегося радиационного шторма. Последнее что вы помните, это как станционная Исскуственная Программа сообщила вам, что вы будете спать восемь часов. \
	Открыв свои глаза, вы видите, как всё вокруг проржавело и покосилось, чувство ужаса поднимается в вашем животе, пока вы выкарабкиваетесь из своей капсулы..."
	uniform = /obj/item/clothing/under/retro/medical
	shoes = /obj/item/clothing/shoes/black
	id = /obj/item/card/id/away/old/med
	l_pocket = /obj/item/stack/medical/ointment
	r_pocket = /obj/item/stack/medical/ointment
	assignedrole = "Ancient Crew"

/obj/effect/mob_spawn/human/oldmed/Destroy()
	new /obj/structure/showcase/machinery/oldpod/used(drop_location())
	return ..()

/obj/effect/mob_spawn/human/oldeng
	name = "old cryogenics pod"
	desc = "Гудящая криокапсула. Вы едва узнаете форму инженера под накопившимся льдом. Машина пытается разбудить своего пользователя."
	mob_name = "an engineer"
	icon = 'icons/obj/cryogenic2.dmi'
	icon_state = "sleeper"
	roundstart = FALSE
	death = FALSE
	random = TRUE
	mob_species = /datum/species/human
	description = "Работайте в команде с другими выжившими на этой разрушенной, древней космической станции."
	important_info = ""
	flavour_text = "Вы инженер работающий на Нанотрейзен, вы служите на борту исследовательской станции, оснащенной по последнему слову науки. Вы отдаленно помните \
	как вы запрыгнули в криогенную капсулу из-за надвигающегося радиационного шторма. Последнее что вы помните, это как станционная Исскуственная Программа сообщила вам, что вы будете спать восемь часов. \
	Открыв свои глаза, вы видите, как всё вокруг проржавело и покосилось, чувство ужаса поднимается в вашем животе, пока вы выкарабкиваетесь из своей капсулы..."
	uniform = /obj/item/clothing/under/retro/engineering
	shoes = /obj/item/clothing/shoes/workboots
	id = /obj/item/card/id/away/old/eng
	gloves = /obj/item/clothing/gloves/color/fyellow/old
	l_pocket = /obj/item/tank/emergency_oxygen
	assignedrole = "Ancient Crew"

/obj/effect/mob_spawn/human/oldeng/Destroy()
	new /obj/structure/showcase/machinery/oldpod/used(drop_location())
	return ..()

/obj/effect/mob_spawn/human/oldsci
	name = "old cryogenics pod"
	desc = "Гудящая криокапсула. Вы едва узнаете форму ученого под накопившимся льдом. Машина пытается разбудить своего пользователя."
	mob_name = "a scientist"
	icon = 'icons/obj/cryogenic2.dmi'
	icon_state = "sleeper"
	roundstart = FALSE
	death = FALSE
	random = TRUE
	mob_species = /datum/species/human
	description = "Работайте в команде с другими выжившими на этой разрушенной, древней космической станции."
	important_info = ""
	flavour_text = "Вы ученый работающий на Нанотрейзен, вы служите на борту исследовательской станции, оснащенной по последнему слову науки. Вы отдаленно помните \
	как вы запрыгнули в криогенную капсулу из-за надвигающегося радиационного шторма. Последнее что вы помните, это как станционная Исскуственная Программа сообщила вам, что вы будете спать восемь часов. \
	Открыв свои глаза, вы видите, как всё вокруг проржавело и покосилось, чувство ужаса поднимается в вашем животе, пока вы выкарабкиваетесь из своей капсулы..."
	uniform = /obj/item/clothing/under/retro/science
	shoes = /obj/item/clothing/shoes/laceup
	id = /obj/item/card/id/away/old/sci
	l_pocket = /obj/item/stack/medical/bruise_pack
	assignedrole = "Ancient Crew"

/obj/effect/mob_spawn/human/oldsci/Destroy()
	new /obj/structure/showcase/machinery/oldpod/used(drop_location())
	return ..()

/obj/structure/showcase/machinery/oldpod
	name = "damaged cryogenic pod"
	desc = "Сломанная криогенная капсула, давно потерянная во времени. Как и её пользователь..."
	icon = 'icons/obj/cryogenic2.dmi'
	icon_state = "sleeper-open"

/obj/structure/showcase/machinery/oldpod/used
	name = "opened cryogenic pod"
	desc = "Криогенная капсула, которая совсем недавно выпустила своего пользователя. Капсула выглядит сломанной."

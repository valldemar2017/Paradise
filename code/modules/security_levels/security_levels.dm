GLOBAL_VAR_INIT(security_level, 0)
//0 = code green
//1 = code blue
//2 = code red
//3 = gamma
//4 = epsilon
//5 = code delta

//config.alert_desc_blue_downto
GLOBAL_DATUM_INIT(security_announcement_up, /datum/announcement/priority/security, new(do_log = 0, do_newscast = 0, new_sound = sound('sound/misc/notice1.ogg')))
GLOBAL_DATUM_INIT(security_announcement_down, /datum/announcement/priority/security, new(do_log = 0, do_newscast = 0))

/proc/set_security_level(var/level)
	switch(level)
		if("green")
			level = SEC_LEVEL_GREEN
		if("blue")
			level = SEC_LEVEL_BLUE
		if("red")
			level = SEC_LEVEL_RED
		if("gamma")
			level = SEC_LEVEL_GAMMA
		if("epsilon")
			level = SEC_LEVEL_EPSILON
		if("delta")
			level = SEC_LEVEL_DELTA

	//Will not be announced if you try to set to the same level as it already is
	if(level >= SEC_LEVEL_GREEN && level <= SEC_LEVEL_DELTA && level != GLOB.security_level)
		if(level >= SEC_LEVEL_RED && GLOB.security_level < SEC_LEVEL_RED)
			// Mark down this time to prevent shuttle cheese
			SSshuttle.emergency_sec_level_time = world.time

		switch(level)
			if(SEC_LEVEL_GREEN)
				GLOB.security_announcement_down.Announce("Все угрозы станции закончились. Любое оружие должно быть убрано, и законы приватности снова действуют в полную силу.","Внимание! Код безопасности был понижен до Зеленого.")
				GLOB.security_level = SEC_LEVEL_GREEN

				post_status("alert", "outline")

				for(var/obj/machinery/firealarm/FA in GLOB.machines)
					if(is_station_contact(FA.z))
						FA.overlays.Cut()
						FA.overlays += image('icons/obj/monitors.dmi', "overlay_green")
						FA.update_icon()

			if(SEC_LEVEL_BLUE)
				if(GLOB.security_level < SEC_LEVEL_BLUE)
					GLOB.security_announcement_up.Announce("Станция получила достоверные доказательства о возможной враждебной ситуации на станции. Служба безопасности может держать оружие на виду,а случайные обыски теперь дозволены..","Внимание! Код безопасности был повышен до Синего.")
				else
					GLOB.security_announcement_down.Announce("Непосредственная угроза была разререшена. Служба безопасности более не может держать оружие на полной боеготовности, однако все еще может держать его на виду. Случайные обыски все еще дозволены.","Внимание! Код безопасности был снижен до Синего.")
				GLOB.security_level = SEC_LEVEL_BLUE

				post_status("alert", "default")

				for(var/obj/machinery/firealarm/FA in GLOB.machines)
					if(is_station_contact(FA.z))
						FA.overlays.Cut()
						FA.overlays += image('icons/obj/monitors.dmi', "overlay_blue")
						FA.update_icon()

			if(SEC_LEVEL_RED)
				if(GLOB.security_level < SEC_LEVEL_RED)
					GLOB.security_announcement_up.Announce("На станции присутствует непосредственная, подтвержденная угроза. Служба безопасности имеет право держать оружие в полной боеготовности.Случайные обыски разрешены и рекомендуются.","Внимание! Код Красный!")
				else
					GLOB.security_announcement_down.Announce("Станционный механзм самоуничтожения был деактивирован, однако все еще присутствует непосредственная, подтвержденная угроза активам и экипажу. Служба безопасности имеет право держать оружие в полной боеготовности.Случайные обыски разрешены и рекомендуются.","Внимание! Код Красный!")
				GLOB.security_level = SEC_LEVEL_RED

				var/obj/machinery/door/airlock/highsecurity/red/R = locate(/obj/machinery/door/airlock/highsecurity/red) in GLOB.airlocks
				if(R && is_station_level(R.z))
					R.locked = 0
					R.update_icon()

				post_status("alert", "redalert")

				for(var/obj/machinery/firealarm/FA in GLOB.machines)
					if(is_station_contact(FA.z))
						FA.overlays.Cut()
						FA.overlays += image('icons/obj/monitors.dmi', "overlay_red")
						FA.update_icon()

			if(SEC_LEVEL_GAMMA)
				GLOB.security_announcement_up.Announce("Центральное Командование отдало приказ об активации кода безопасности Гамма. Служба безопасности обязана быть вооружена и в полной боевой готовности, гражданский экипаж должен немедленно направиться в ближайшее безопасное место. Оружейная кода Гамма разблокированна и готова к использованию.","Внимание! Код безопасности Гамма был активирован!", new_sound = sound('sound/effects/new_siren.ogg'))
				GLOB.security_level = SEC_LEVEL_GAMMA

				move_gamma_ship()

				if(GLOB.security_level < SEC_LEVEL_RED)
					for(var/obj/machinery/door/airlock/highsecurity/red/R in GLOB.airlocks)
						if(is_station_level(R.z))
							R.locked = 0
							R.update_icon()

				for(var/obj/machinery/door/airlock/hatch/gamma/H in GLOB.airlocks)
					if(is_station_level(H.z))
						H.locked = 0
						H.update_icon()

				post_status("alert", "gammaalert")

				for(var/obj/machinery/firealarm/FA in GLOB.machines)
					if(is_station_contact(FA.z))
						FA.overlays.Cut()
						FA.overlays += image('icons/obj/monitors.dmi', "overlay_gamma")
						FA.update_icon()

			if(SEC_LEVEL_EPSILON)
				GLOB.security_announcement_up.Announce("Центральное Командование авторизовало активацию кода Эпсилон на станции. Элитный отряд быстрого реагирования будет отправлен для неитрализации угрозы и защиты активов корпорации. Экипажу следует сохранять спокойствие и проследовать в ближайшее безопасное место на станции, а затем ожидать указаний от отряда быстрого реагирования.","Внимание! Код Эпсилон был активирован!", new_sound = sound('sound/effects/purge_siren.ogg'))
				GLOB.security_level = SEC_LEVEL_EPSILON

				post_status("alert", "epsilonalert")

				for(var/obj/machinery/firealarm/FA in GLOB.machines)
					if(is_station_contact(FA.z))
						FA.overlays.Cut()
						FA.overlays += image('icons/obj/monitors.dmi', "overlay_epsilon")
						FA.update_icon()

			if(SEC_LEVEL_DELTA)
				GLOB.security_announcement_up.Announce("Станционный механизм самоуничтожения был активирован.Всему экипажу надлежит подчиняться любым приказам глав станции. Любое нарушение этих приказов может быть наказуемо немедленной казнью. Это не учебная тревога.","Внимание! Код безопасности Дельта был активирован!", new_sound = sound('sound/effects/deltaalarm.ogg'))
				GLOB.security_level = SEC_LEVEL_DELTA

				post_status("alert", "deltaalert")

				for(var/obj/machinery/firealarm/FA in GLOB.machines)
					if(is_station_contact(FA.z))
						FA.overlays.Cut()
						FA.overlays += image('icons/obj/monitors.dmi', "overlay_delta")
						FA.update_icon()

		SSnightshift.check_nightshift(TRUE)
		SSblackbox.record_feedback("tally", "security_level_changes", 1, level)

		if(GLOB.sibsys_automode && !isnull(GLOB.guns_registry))
			var/limit = SIBYL_NONLETHAL
			switch(GLOB.security_level)
				if(SEC_LEVEL_GREEN)
					limit = SIBYL_NONLETHAL
				if(SEC_LEVEL_BLUE)
					limit = SIBYL_LETHAL
				if(SEC_LEVEL_RED)
					limit = SIBYL_LETHAL
				if(SEC_LEVEL_GAMMA)
					limit = SIBYL_DESTRUCTIVE
				if(SEC_LEVEL_EPSILON)
					limit = SIBYL_DESTRUCTIVE
				if(SEC_LEVEL_DELTA)
					limit = SIBYL_DESTRUCTIVE

			for(var/obj/item/sibyl_system_mod/mod in GLOB.guns_registry)
				mod.set_limit(limit)
	else
		return

/proc/get_security_level()
	switch(GLOB.security_level)
		if(SEC_LEVEL_GREEN)
			return "green"
		if(SEC_LEVEL_BLUE)
			return "blue"
		if(SEC_LEVEL_RED)
			return "red"
		if(SEC_LEVEL_GAMMA)
			return "gamma"
		if(SEC_LEVEL_EPSILON)
			return "epsilon"
		if(SEC_LEVEL_DELTA)
			return "delta"

/proc/num2seclevel(var/num)
	switch(num)
		if(SEC_LEVEL_GREEN)
			return "green"
		if(SEC_LEVEL_BLUE)
			return "blue"
		if(SEC_LEVEL_RED)
			return "red"
		if(SEC_LEVEL_GAMMA)
			return "gamma"
		if(SEC_LEVEL_EPSILON)
			return "epsilon"
		if(SEC_LEVEL_DELTA)
			return "delta"

/proc/seclevel2num(var/seclevel)
	switch( lowertext(seclevel) )
		if("green")
			return SEC_LEVEL_GREEN
		if("blue")
			return SEC_LEVEL_BLUE
		if("red")
			return SEC_LEVEL_RED
		if("gamma")
			return SEC_LEVEL_GAMMA
		if("epsilon")
			return SEC_LEVEL_EPSILON
		if("delta")
			return SEC_LEVEL_DELTA

/proc/get_security_level_ru()
	switch(GLOB.security_level)
		if(SEC_LEVEL_GREEN)
			return "ЗЕЛЕНЫЙ"
		if(SEC_LEVEL_BLUE)
			return "СИНИЙ"
		if(SEC_LEVEL_RED)
			return "КРАСНЫЙ"
		if(SEC_LEVEL_GAMMA)
			return "ГАММА"
		if(SEC_LEVEL_EPSILON)
			return "ЭПСИЛОН"
		if(SEC_LEVEL_DELTA)
			return "ДЕЛЬТА"

/proc/get_security_level_l_range()
	switch(GLOB.security_level)
		if(SEC_LEVEL_GREEN)
			return 1
		if(SEC_LEVEL_BLUE)
			return 2
		if(SEC_LEVEL_RED)
			return 2
		if(SEC_LEVEL_GAMMA)
			return 2
		if(SEC_LEVEL_EPSILON)
			return 2
		if(SEC_LEVEL_DELTA)
			return 2

/proc/get_security_level_l_power()
	switch(GLOB.security_level)
		if(SEC_LEVEL_GREEN)
			return 1
		if(SEC_LEVEL_BLUE)
			return 2
		if(SEC_LEVEL_RED)
			return 2
		if(SEC_LEVEL_GAMMA)
			return 2
		if(SEC_LEVEL_EPSILON)
			return 2
		if(SEC_LEVEL_DELTA)
			return 2

/proc/get_security_level_l_color()
	switch(GLOB.security_level)
		if(SEC_LEVEL_GREEN)
			return COLOR_GREEN
		if(SEC_LEVEL_BLUE)
			return COLOR_ALARM_BLUE
		if(SEC_LEVEL_RED)
			return COLOR_RED_LIGHT
		if(SEC_LEVEL_GAMMA)
			return COLOR_AMBER
		if(SEC_LEVEL_EPSILON)
			return COLOR_ORANGE
		if(SEC_LEVEL_DELTA)
			return COLOR_DARK_ORANGE

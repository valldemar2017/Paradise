//TODO: переназвать всё правильно. Добавить доп. проверки
/datum/long_item_action
	var/obj/item/master_item
	var/datum/progressbar/progress
	var/endtime
	var/starttime
	var/time
	var/mob/user
	var/datum/callback/action
	var/list/extra_checks
	var/item_loc
	var/last_key_press

/datum/long_item_action/New(var/mob/_user,var/item,var/list/checks = list(),var/new_action)
	user = _user
	master_item = item
	item_loc = master_item.loc
	starttime = world.time
	endtime = starttime + time
	action = new_action
	extra_checks = checks
	progress = new(user, time, user)
	last_key_press = world.time
	if(!start())
		fail()

/datum/long_item_action/proc/fire()
	set waitfor = FALSE
	if(world.time > endtime)
		finish()
		return
	// if(!user.client.keys_held["Space"])
	// 	if(world.time-last_key_press>(endtime-starttime)/10)
	// 		fail()
	// else if(check_for_true_callbacks(extra_checks))
	// 	return 0


	progress.update(world.time - starttime)
	sleep(1)

	if(!user || !master_item /*||master_item.loc != item_loc || user.get_active_hand() != master_item */|| user.incapacitated(ignore_lying = TRUE)||!user.client.keys_held["Space"])
		fail()
		return
	fire()


/datum/long_item_action/proc/start()
	world.log<<"start [src]"

/datum/long_item_action/proc/finish()
	world.log<<"finish [src]"
	action.Invoke()
	master_item.action = null
	qdel(progress)
	qdel(src)

/datum/long_item_action/proc/fail()
	world.log<<"failed [src]"
	master_item.action = null
	qdel(progress)
	qdel(src)

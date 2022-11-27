//TODO: переназвать всё правильно. Добавить доп. проверки

#define SPACEBAR_ACTION_NEED_HOLD (1<<1)
#define SPACEBAR_ACTION_NOT_ITEM_ACTION (1<<2)
#define SPACEBAR_ACTION_NO_PRESS_NEEDED (1<<3) //Action starts and continue activation without pressing spacebar. Maybe some items ideas wiil be requires it ¯\_(ツ)_/¯

/datum/spacebar_action
	var/obj/item/master_item
	var/datum/progressbar/progress
	var/endtime
	var/starttime
	var/time
	var/mob/user
	var/datum/callback/action
	var/list/extra_checks
	var/item_loc
	var/action_flags
	var/proccesing = FALSE

/datum/spacebar_action/New(var/mob/_user,var/item,var/list/checks = list(),var/new_action)
	user = _user
	master_item = item
	item_loc = master_item.loc
	starttime = world.time
	endtime = starttime + time
	action = new_action
	extra_checks = checks
	progress = new(user, time, user)
	if(!start())
		fail()
	proccesing=TRUE

/datum/spacebar_action/proc/fire()
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

	if(!user || (!(action_flags&SPACEBAR_ACTION_NOT_ITEM_ACTION) && !master_item)|| user.incapacitated(ignore_lying = TRUE)||(!(action_flags&SPACEBAR_ACTION_NO_PRESS_NEEDED)&&!user.client.keys_held["Space"])||!proccesing)
		fail()
		return
	fire()


/datum/spacebar_action/proc/start()
	log_admin("[user] started empty spacebar action: [src]")
	log_debug("[user] started empty spacebar action: [src]")

/datum/spacebar_action/proc/finish()
	proccesing=FALSE
	log_admin("[user] successfuly finished empty spacebar action: [src]")
	log_debug("[user] successfuly finished: [src]")
	action.Invoke()
	if(master_item)
		master_item.spc_action = null
	qdel(progress)
	qdel(src)

/datum/spacebar_action/proc/fail()
	proccesing=FALSE
	log_admin("[user] сompleted unsuccessfully empty spacebar action: [src]")
	log_debug("[user] сompleted unsuccessfully finished: [src]")
	if(master_item)
		master_item.spc_action = null
	qdel(progress)
	qdel(src)

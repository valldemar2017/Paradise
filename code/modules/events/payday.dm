/datum/event/payday
	name="Зарплата"
	var/terminal
	announceWhen	= 5
	var/Value=list(100,200,300,400,500)


/datum/event/payday/setup()
	terminal="NTGalaxyNet Terminal #[rand(111,1111)]"
/datum/event/payday/announce()
	GLOB.event_announcement.Announce("Payday! Check your bank account", "Payday!")
/datum/event/payday/start()
	if(GLOB.all_money_accounts.len)
		for(var/datum/money_account/MC in GLOB.all_money_accounts)
			MC.credit(Value[rand(1,5)],"Зарплата",terminal,MC.owner_name,,world.time)

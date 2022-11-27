/obj/item/robot_module
	name = "robot module"
	icon = 'icons/obj/module.dmi'
	icon_state = "std_module"
	w_class = 100
	item_state = "electronic"
	flags = CONDUCT

	var/list/modules = list()
	var/obj/item/emag = null
	var/list/subsystems = list()
	var/list/module_actions = list()

	var/module_type = "NoMod" // For icon usage

	var/list/storages = list()
	var/channels = list()
	var/list/custom_removals = list()


/obj/item/robot_module/emp_act(severity)
	if(modules)
		for(var/obj/O in modules)
			O.emp_act(severity)
	if(emag)
		emag.emp_act(severity)
	..()


/obj/item/robot_module/New()
	..()
	add_default_robot_items()
	emag = new /obj/item/toy/sword(src)
	emag.name = "Placeholder Emag Item"

/obj/item/robot_module/Destroy()
	QDEL_LIST(modules)
	QDEL_NULL(emag)
	return ..()

// By default, all robots will get the items in this proc, unless you override it for your specific module. See: ../robot_module/drone
/obj/item/robot_module/proc/add_default_robot_items()
	modules += new /obj/item/flash/cyborg(src)

/obj/item/robot_module/proc/fix_modules()
	for(var/obj/item/I in modules)
		I.flags |= NODROP
		I.mouse_opacity = MOUSE_OPACITY_OPAQUE
	if(emag)
		emag.flags |= NODROP
		emag.mouse_opacity = MOUSE_OPACITY_OPAQUE

/obj/item/robot_module/proc/handle_storages()
	for(var/obj/item/stack/I in modules)
		var/obj/item/stack/S = I
		if(istype(S, /obj/item/stack/sheet/metal))
			S.cost = 4
			S.source = get_or_create_estorage(/datum/robot_energy_storage/metal)
		else if(istype(S, /obj/item/stack/sheet/glass))
			S.cost = 1
			S.source = get_or_create_estorage(/datum/robot_energy_storage/glass)
		else if(istype(S, /obj/item/stack/sheet/rglass))
			var/obj/item/stack/sheet/rglass/cyborg/G = S
			G.source = get_or_create_estorage(/datum/robot_energy_storage/metal)
			G.glasource = get_or_create_estorage(/datum/robot_energy_storage/glass)
		else if(istype(S, /obj/item/stack/cable_coil))
			S.cost = 1
			S.source = get_or_create_estorage(/datum/robot_energy_storage/wire)
		else if(istype(S, /obj/item/stack/rods))
			S.cost = 2
			S.source = get_or_create_estorage(/datum/robot_energy_storage/metal)
		else if(istype(S, /obj/item/stack/tile/plasteel))
			S.cost = 1
			S.source = get_or_create_estorage(/datum/robot_energy_storage/metal)
		else if(is_type_in_list(S, list(/obj/item/stack/medical/bruise_pack, /obj/item/stack/medical/ointment)))
			S.cost = 1
			if(istype(src, /obj/item/robot_module/syndicate_medical))
				S.source = get_or_create_estorage(/datum/robot_energy_storage/medical/syndicate)
			else
				S.source = get_or_create_estorage(/datum/robot_energy_storage/medical)
		else if(istype(S, /obj/item/stack/nanopaste))
			S.cost = 1
			S.source = get_or_create_estorage(/datum/robot_energy_storage/nanopaste)
		else if(istype(S, /obj/item/stack/medical/splint))
			S.cost = 1
			S.source = get_or_create_estorage(/datum/robot_energy_storage/splint)
		else if(istype(S, /obj/item/stack/sheet/wood/cyborg))
			S.cost = 4
			S.source = get_or_create_estorage(/datum/robot_energy_storage/wood)
		else if(istype(S, /obj/item/stack/tile/wood/cyborg))
			S.cost = 1
			S.source = get_or_create_estorage(/datum/robot_energy_storage/wood)

/obj/item/robot_module/proc/get_or_create_estorage(var/storage_type)
	for(var/datum/robot_energy_storage/S in storages)
		if(istype(S, storage_type))
			return S

	return new storage_type(src)

/obj/item/robot_module/proc/respawn_consumable(mob/living/silicon/robot/R)
	for(var/datum/robot_energy_storage/st in storages)
		st.energy = min(st.max_energy, st.energy + st.recharge_rate)

/obj/item/robot_module/proc/rebuild()//Rebuilds the list so it's possible to add/remove items from the module
	var/list/temp_list = modules
	modules = list()
	for(var/obj/O in temp_list)
		if(!QDELETED(O)) //so items getting deleted don't stay in module list and haunt you
			modules += O

/obj/item/robot_module/proc/add_languages(mob/living/silicon/robot/R)
	//full set of languages
	R.add_language("Galactic Common", 1)
	R.add_language("Sol Common", 1)
	R.add_language("Tradeband", 1)
	R.add_language("Gutter", 0)
	R.add_language("Neo-Russkiya", 0)
	R.add_language("Sinta'unathi", 0)
	R.add_language("Siik'tajr", 0)
	R.add_language("Canilunzt", 0)
	R.add_language("Skrellian", 0)
	R.add_language("Vox-pidgin", 0)
	R.add_language("Rootspeak", 0)
	R.add_language("Trinary", 1)
	R.add_language("Chittin", 0)
	R.add_language("Bubblish", 0)
	R.add_language("Orluum", 0)
	R.add_language("Clownish",0)

/obj/item/robot_module/proc/add_subsystems_and_actions(mob/living/silicon/robot/R)
	R.verbs |= subsystems
	for(var/A in module_actions)
		var/datum/action/act = new A()
		act.Grant(R)
		R.module_actions += act

/obj/item/robot_module/proc/remove_subsystems_and_actions(mob/living/silicon/robot/R)
	R.verbs -= subsystems
	for(var/datum/action/A in R.module_actions)
		A.Remove(R)
		qdel(A)
	R.module_actions.Cut()

// Return true in an overridden subtype to prevent normal removal handling
/obj/item/robot_module/proc/handle_custom_removal(component_id, mob/living/user, obj/item/W)
	return FALSE

/obj/item/robot_module/proc/handle_death(mob/living/silicon/robot/R, gibbed)
	return

/obj/item/robot_module/standard
	// if station is fine, assist with constructing station goal room, cleaning, and repairing cables chewed by rats
	// if medical crisis, assist by providing basic healthcare, retrieving corpses, and monitoring crew lifesigns
	// if eng crisis, assist by helping repair hull breaches
	// if sec crisis, assist by opening doors for sec and providing backup zipties on patrols
	name = "generalist robot module"
	module_type = "Standard"
	subsystems = list(/mob/living/silicon/proc/subsystem_power_monitor, /mob/living/silicon/proc/subsystem_crew_monitor)

/obj/item/robot_module/standard/New()
	..()
	modules += new /obj/item/stack/sheet/metal/cyborg(src)
	modules += new /obj/item/stack/cable_coil/cyborg(src)
	modules += new /obj/item/stack/rods/cyborg(src)
	modules += new /obj/item/stack/tile/plasteel/cyborg(src)
	// sec
	modules += new /obj/item/restraints/handcuffs/cable/zipties/cyborg(src)
	// janitorial
	modules += new /obj/item/soap/nanotrasen(src)
	modules += new /obj/item/lightreplacer/cyborg(src)
	// eng
	modules += new /obj/item/crowbar/cyborg(src)
	modules += new /obj/item/wrench/cyborg(src)
	modules += new /obj/item/extinguisher(src) // for firefighting, and propulsion in space
	modules += new /obj/item/weldingtool/largetank/cyborg(src)
	// mining
	modules += new /obj/item/pickaxe(src)
	modules += new /obj/item/t_scanner/adv_mining_scanner(src)
	modules += new /obj/item/storage/bag/ore/cyborg(src)
	// med
	modules += new /obj/item/healthanalyzer(src)
	modules += new /obj/item/reagent_containers/borghypo/basic(src)
	modules += new /obj/item/roller_holder(src) // for taking the injured to medbay without worsening their injuries or leaving a blood trail the whole way
	emag = new /obj/item/melee/energy/sword/cyborg(src)

	fix_modules()
	handle_storages()

/obj/item/robot_module/medical
	name = "medical robot module"
	module_type = "Medical"
	subsystems = list(/mob/living/silicon/proc/subsystem_crew_monitor)

/obj/item/robot_module/medical/New()
	..()
	modules += new /obj/item/healthanalyzer/advanced(src)
	modules += new /obj/item/robotanalyzer(src)
	modules += new /obj/item/reagent_scanner/adv(src)
	modules += new /obj/item/borg_defib(src)
	modules += new /obj/item/handheld_defibrillator(src)
	modules += new /obj/item/roller_holder(src)
	modules += new /obj/item/reagent_containers/borghypo(src)
	modules += new /obj/item/reagent_containers/glass/beaker/large(src)
	modules += new /obj/item/reagent_containers/dropper(src)
	modules += new /obj/item/reagent_containers/syringe(src)
	modules += new /obj/item/extinguisher/mini(src)
	modules += new /obj/item/stack/medical/bruise_pack/advanced/cyborg(src)
	modules += new /obj/item/stack/medical/ointment/advanced/cyborg(src)
	modules += new /obj/item/stack/medical/splint/cyborg(src)
	modules += new /obj/item/stack/nanopaste/cyborg(src)
	modules += new /obj/item/scalpel/laser/laser1(src)
	modules += new /obj/item/hemostat(src)
	modules += new /obj/item/retractor(src)
	modules += new /obj/item/bonegel(src)
	modules += new /obj/item/FixOVein(src)
	modules += new /obj/item/bonesetter(src)
	modules += new /obj/item/circular_saw(src)
	modules += new /obj/item/surgicaldrill(src)
	modules += new /obj/item/gripper/medical(src)

	emag = new /obj/item/reagent_containers/spray(src)

	emag.reagents.add_reagent("facid", 250)
	emag.name = "Polyacid spray"

	fix_modules()
	handle_storages()

/obj/item/robot_module/medical/respawn_consumable(mob/living/silicon/robot/R)
	if(emag)
		var/obj/item/reagent_containers/spray/PS = emag
		PS.reagents.add_reagent("facid", 2)
	..()

/obj/item/robot_module/engineering
	name = "engineering robot module"
	module_type = "Engineer"
	subsystems = list(/mob/living/silicon/proc/subsystem_power_monitor)
	module_actions = list(
		/datum/action/innate/robot_sight/meson,
	)

/obj/item/robot_module/engineering/New()
	..()
	modules += new /obj/item/rcd/borg(src)
	modules += new /obj/item/rpd(src)
	modules += new /obj/item/extinguisher(src)
	modules += new /obj/item/weldingtool/largetank/cyborg(src)
	modules += new /obj/item/screwdriver/cyborg(src)
	modules += new /obj/item/wrench/cyborg(src)
	modules += new /obj/item/crowbar/cyborg(src)
	modules += new /obj/item/wirecutters/cyborg(src)
	modules += new /obj/item/multitool/cyborg(src)
	modules += new /obj/item/t_scanner(src)
	modules += new /obj/item/analyzer(src)
	modules += new /obj/item/holosign_creator/engineering(src)
	modules += new /obj/item/gripper(src)
	modules += new /obj/item/matter_decompiler(src)
	modules += new /obj/item/floor_painter(src)
	modules += new /obj/item/areaeditor/blueprints/cyborg(src)
	modules += new /obj/item/stack/sheet/metal/cyborg(src)
	modules += new /obj/item/stack/sheet/glass/cyborg(src)
	modules += new /obj/item/stack/sheet/rglass/cyborg(src)
	modules += new /obj/item/stack/cable_coil/cyborg(src)
	modules += new /obj/item/stack/rods/cyborg(src)
	modules += new /obj/item/stack/tile/plasteel/cyborg(src)
	modules += new /obj/item/lightreplacer/cyborg(src)
	emag = new /obj/item/borg/stun(src)

	fix_modules()
	handle_storages()

/obj/item/robot_module/engineering/handle_death(mob/living/silicon/robot/R, gibbed)
	var/obj/item/gripper/G = locate(/obj/item/gripper) in modules
	if(G)
		G.drop_gripped_item(silent = TRUE)

/obj/item/robot_module/security
	name = "security robot module"
	module_type = "Security"
	subsystems = list(/mob/living/silicon/proc/subsystem_crew_monitor)

/obj/item/robot_module/security/New()
	..()
	modules += new /obj/item/restraints/handcuffs/cable/zipties/cyborg(src)
	modules += new /obj/item/melee/baton/loaded(src)
	modules += new /obj/item/gun/energy/disabler/cyborg(src)
	modules += new /obj/item/holosign_creator/security(src)
	modules += new /obj/item/clothing/mask/gas/sechailer/cyborg(src)
	emag = new /obj/item/gun/energy/laser/cyborg(src)

	fix_modules()

/obj/item/robot_module/janitor
	name = "janitorial robot module"
	module_type = "Janitor"

/obj/item/robot_module/janitor/New()
	..()
	modules += new /obj/item/soap/nanotrasen(src)
	modules += new /obj/item/storage/bag/trash/cyborg(src)
	modules += new /obj/item/mop/advanced/cyborg(src)
	modules += new /obj/item/lightreplacer/cyborg(src)
	modules += new /obj/item/holosign_creator(src)
	modules += new /obj/item/extinguisher/mini(src)
	emag = new /obj/item/reagent_containers/spray(src)

	emag.reagents.add_reagent("lube", 250)
	emag.name = "Lube spray"

	fix_modules()

/obj/item/robot_module/butler
	name = "service robot module"
	module_type = "Service"

/obj/item/robot_module/butler/New()
	..()
	modules += new /obj/item/handheld_chem_dispenser/booze(src)
	modules += new /obj/item/handheld_chem_dispenser/soda(src)

	modules += new /obj/item/pen(src)
	modules += new /obj/item/razor(src)
	modules += new /obj/item/instrument/piano_synth(src)
	modules += new /obj/item/healthanalyzer/advanced(src)
	modules += new /obj/item/reagent_scanner/adv(src)

	var/obj/item/rsf/M = new /obj/item/rsf(src)
	M.matter = 30
	modules += M

	modules += new /obj/item/reagent_containers/dropper/cyborg(src)
	modules += new /obj/item/lighter/zippo(src)
	modules += new /obj/item/storage/bag/tray/cyborg(src)
	modules += new /obj/item/reagent_containers/food/drinks/shaker(src)
	emag = new /obj/item/reagent_containers/food/drinks/cans/beer(src)

	var/datum/reagents/R = new/datum/reagents(50)
	emag.reagents = R
	R.my_atom = emag
	R.add_reagent("beer2", 50)
	emag.name = "Mickey Finn's Special Brew"

	fix_modules()

/obj/item/robot_module/butler/respawn_consumable(var/mob/living/silicon/robot/R)
	if(emag)
		var/obj/item/reagent_containers/food/drinks/cans/beer/B = emag
		B.reagents.add_reagent("beer2", 2)
	..()

/obj/item/robot_module/butler/add_languages(var/mob/living/silicon/robot/R)
	//full set of languages
	R.add_language("Galactic Common", 1)
	R.add_language("Sol Common", 1)
	R.add_language("Tradeband", 1)
	R.add_language("Gutter", 1)
	R.add_language("Sinta'unathi", 1)
	R.add_language("Siik'tajr", 1)
	R.add_language("Canilunzt", 1)
	R.add_language("Skrellian", 1)
	R.add_language("Vox-pidgin", 1)
	R.add_language("Rootspeak", 1)
	R.add_language("Trinary", 1)
	R.add_language("Chittin", 1)
	R.add_language("Bubblish", 1)
	R.add_language("Clownish",1)
	R.add_language("Neo-Russkiya", 1)

/obj/item/robot_module/butler/handle_death(mob/living/silicon/robot/R, gibbed)
	var/obj/item/storage/bag/tray/cyborg/T = locate(/obj/item/storage/bag/tray/cyborg) in modules
	if(istype(T))
		T.drop_inventory(R)


/obj/item/robot_module/miner
	name = "miner robot module"
	module_type = "Miner"
	module_actions = list(
		/datum/action/innate/robot_sight/meson,
	)
	custom_removals = list("KA modkits")

/obj/item/robot_module/miner/New()
	..()
	modules += new /obj/item/storage/bag/ore/cyborg(src)
	modules += new /obj/item/pickaxe/drill/cyborg(src)
	modules += new /obj/item/shovel(src)
	modules += new /obj/item/weldingtool/mini(src)
	modules += new /obj/item/extinguisher/mini(src)
	modules += new /obj/item/storage/bag/sheetsnatcher/borg(src)
	modules += new /obj/item/t_scanner/adv_mining_scanner/cyborg(src)
	modules += new /obj/item/gun/energy/kinetic_accelerator/cyborg(src)
	modules += new /obj/item/gps/cyborg(src)
	emag = new /obj/item/borg/stun(src)

	fix_modules()

/obj/item/robot_module/miner/handle_custom_removal(component_id, mob/living/user, obj/item/W)
    if(component_id == "KA modkits")
        for(var/obj/item/gun/energy/kinetic_accelerator/cyborg/D in src)
            D.attackby(W, user)
        return TRUE
    return ..()

/obj/item/robot_module/deathsquad
	name = "NT advanced combat module"
	module_type = "Malf"
	module_actions = list(
		/datum/action/innate/robot_sight/thermal,
	)

/obj/item/robot_module/deathsquad/New()
	..()
	modules += new /obj/item/melee/energy/sword/cyborg(src)
	modules += new /obj/item/gun/energy/pulse/cyborg(src)
	modules += new /obj/item/crowbar(src)
	emag = null

	fix_modules()

/obj/item/robot_module/syndicate
	name = "syndicate assault robot module"
	module_type = "Malf" // cuz it looks cool

/obj/item/robot_module/syndicate/New()
	..()
	modules += new /obj/item/melee/energy/sword/cyborg(src)
	modules += new /obj/item/gun/energy/printer(src)
	modules += new /obj/item/gun/projectile/revolver/grenadelauncher/multi/cyborg(src)
	modules += new /obj/item/card/emag(src)
	modules += new /obj/item/crowbar/cyborg(src)
	modules += new /obj/item/pinpointer/operative(src)
	emag = null

	fix_modules()

/obj/item/robot_module/syndicate_medical
	name = "syndicate medical robot module"
	module_type = "Malf"

/obj/item/robot_module/syndicate_medical/New()
	..()
	modules += new /obj/item/healthanalyzer/advanced(src)
	modules += new /obj/item/reagent_scanner/adv(src)
	modules += new /obj/item/bodyanalyzer/borg/syndicate(src)
	modules += new /obj/item/borg_defib(src)
	modules += new /obj/item/handheld_defibrillator(src)
	modules += new /obj/item/roller_holder(src)
	modules += new /obj/item/reagent_containers/borghypo/syndicate(src)
	modules += new /obj/item/extinguisher/mini(src)
	modules += new /obj/item/stack/medical/bruise_pack/advanced/cyborg(src)
	modules += new /obj/item/stack/medical/ointment/advanced/cyborg(src)
	modules += new /obj/item/stack/medical/splint/cyborg(src)
	modules += new /obj/item/stack/nanopaste/cyborg(src)
	modules += new /obj/item/scalpel/laser/laser1(src)
	modules += new /obj/item/hemostat(src)
	modules += new /obj/item/retractor(src)
	modules += new /obj/item/bonegel(src)
	modules += new /obj/item/FixOVein(src)
	modules += new /obj/item/bonesetter(src)
	modules += new /obj/item/surgicaldrill(src)
	modules += new /obj/item/gripper/medical(src)
	modules += new /obj/item/gun/medbeam(src)
	modules += new /obj/item/melee/energy/sword/cyborg/saw(src) //Energy saw -- primary weapon
	modules += new /obj/item/card/emag(src)
	modules += new /obj/item/crowbar/cyborg(src)
	modules += new /obj/item/pinpointer/operative(src)
	emag = null

	fix_modules()
	handle_storages()

/obj/item/robot_module/syndicate_saboteur
	name = "engineering robot module" //to disguise in examine
	module_type = "Malf"

/obj/item/robot_module/syndicate_saboteur/New()
	..()
	modules += new /obj/item/rcd/borg/syndicate(src)
	modules += new /obj/item/rpd(src)
	modules += new /obj/item/extinguisher(src)
	modules += new /obj/item/weldingtool/largetank/cyborg(src)
	modules += new /obj/item/screwdriver/cyborg(src)
	modules += new /obj/item/wrench/cyborg(src)
	modules += new /obj/item/crowbar/cyborg(src)
	modules += new /obj/item/wirecutters/cyborg(src)
	modules += new /obj/item/multitool/cyborg(src)
	modules += new /obj/item/t_scanner(src)
	modules += new /obj/item/analyzer(src)
	modules += new /obj/item/gripper(src)
	modules += new /obj/item/melee/energy/sword/cyborg(src)
	modules += new /obj/item/card/emag(src)
	modules += new /obj/item/borg_chameleon(src)
	modules += new /obj/item/pinpointer/operative(src)
	modules += new /obj/item/stack/sheet/metal/cyborg(src)
	modules += new /obj/item/stack/sheet/glass/cyborg(src)
	modules += new /obj/item/stack/sheet/rglass/cyborg(src)
	modules += new /obj/item/stack/cable_coil/cyborg(src)
	modules += new /obj/item/stack/rods/cyborg(src)
	modules += new /obj/item/stack/tile/plasteel/cyborg(src)
	emag = null

	fix_modules()
	handle_storages()

/obj/item/robot_module/destroyer
	name = "destroyer robot module"
	module_type = "Malf"
	module_actions = list(
		/datum/action/innate/robot_sight/thermal,
	)

/obj/item/robot_module/destroyer/New()
	..()

	modules += new /obj/item/gun/energy/immolator/multi/cyborg(src) // See comments on /robot_module/combat below
	modules += new /obj/item/melee/baton/loaded(src) // secondary weapon, for things immune to burn, immune to ranged weapons, or for arresting low-grade threats
	modules += new /obj/item/restraints/handcuffs/cable/zipties/cyborg(src)
	modules += new /obj/item/pickaxe/drill/jackhammer(src) // for breaking walls to execute flanking moves
	modules += new /obj/item/borg/destroyer/mobility(src)
	emag = null
	fix_modules()


/obj/item/robot_module/combat
	name = "combat robot module"
	module_type = "Malf"
	module_actions = list()

/obj/item/robot_module/combat/New()
	..()
	modules += new /obj/item/gun/energy/immolator/multi/cyborg(src) // primary weapon, strong at close range (ie: against blob/terror/xeno), but consumes a lot of energy per shot.
	// Borg gets 40 shots of this weapon. Gamma Sec ERT gets 10.
	// So, borg has way more burst damage, but also takes way longer to recharge / get back in the fight once depleted. Has to find a borg recharger and sit in it for ages.
	// Organic gamma sec ERT carries alternate weapons, including a box of flashbangs, and can load up on a huge number of guns from science. Borg cannot do either.
	// Overall, gamma borg has higher skill floor but lower skill ceiling.
	modules += new /obj/item/melee/baton/loaded(src) // secondary weapon, for things immune to burn, immune to ranged weapons, or for arresting low-grade threats
	modules += new /obj/item/restraints/handcuffs/cable/zipties/cyborg(src)
	modules += new /obj/item/pickaxe/drill/jackhammer(src) // for breaking walls to execute flanking moves
	emag = null
	fix_modules()


/obj/item/robot_module/alien/hunter
	name = "alien hunter module"
	module_type = "Standard"
	module_actions = list(
		/datum/action/innate/robot_sight/thermal/alien,
	)

/obj/item/robot_module/alien/hunter/New()
	..()
	modules += new /obj/item/melee/energy/alien/claws(src)
	modules += new /obj/item/flash/cyborg/alien(src)
	var/obj/item/reagent_containers/spray/alien/stun/S = new /obj/item/reagent_containers/spray/alien/stun(src)
	S.reagents.add_reagent("ether",250) //nerfed to sleeptoxin to make it less instant drop.
	modules += S
	var/obj/item/reagent_containers/spray/alien/smoke/A = new /obj/item/reagent_containers/spray/alien/smoke(src)
	S.reagents.add_reagent("water",50) //Water is used as a dummy reagent for the smoke bombs. More of an ammo counter.
	modules += A
	emag = new /obj/item/reagent_containers/spray/alien/acid(src)
	emag.reagents.add_reagent("facid", 125)
	emag.reagents.add_reagent("sacid", 125)

	fix_modules()

/obj/item/robot_module/alien/hunter/add_languages(var/mob/living/silicon/robot/R)
	..()
	R.add_language("xenocommon", 1)

/obj/item/robot_module/drone
	name = "drone module"
	module_type = "Engineer"

/obj/item/robot_module/drone/New()
	..()
	modules += new /obj/item/weldingtool/largetank/cyborg(src)
	modules += new /obj/item/screwdriver/cyborg(src)
	modules += new /obj/item/wrench/cyborg(src)
	modules += new /obj/item/crowbar/cyborg(src)
	modules += new /obj/item/wirecutters/cyborg(src)
	modules += new /obj/item/multitool/cyborg(src)
	modules += new /obj/item/lightreplacer/cyborg(src)
	modules += new /obj/item/gripper(src)
	modules += new /obj/item/matter_decompiler(src)
	modules += new /obj/item/reagent_containers/spray/cleaner/drone(src)
	modules += new /obj/item/soap(src)
	modules += new /obj/item/t_scanner(src)
	modules += new /obj/item/rpd(src)
	modules += new /obj/item/stack/sheet/wood/cyborg(src)
	modules += new /obj/item/stack/sheet/rglass/cyborg(src)
	modules += new /obj/item/stack/tile/wood/cyborg(src)
	modules += new /obj/item/stack/rods/cyborg(src)
	modules += new /obj/item/stack/tile/plasteel/cyborg(src)
	modules += new /obj/item/stack/sheet/metal/cyborg(src)
	modules += new /obj/item/stack/sheet/glass/cyborg(src)
	modules += new /obj/item/stack/cable_coil/cyborg(src)
	modules += new /obj/item/analyzer(src)
	modules += new /obj/item/extinguisher(src)

	fix_modules()
	handle_storages()

/obj/item/robot_module/drone/add_default_robot_items()
	return

/obj/item/robot_module/drone/respawn_consumable(mob/living/silicon/robot/R)
	var/obj/item/reagent_containers/spray/cleaner/C = locate() in modules
	C.reagents.add_reagent("cleaner", 3)
	..()


/obj/item/robot_module/drone/handle_death(mob/living/silicon/robot/R, gibbed)
	var/obj/item/gripper/G = locate(/obj/item/gripper) in modules
	if(G)
		G.drop_gripped_item(silent = TRUE)

//checks whether this item is a module of the robot it is located in.
/obj/item/proc/is_robot_module()
	if(!istype(loc, /mob/living/silicon/robot))
		return 0

	var/mob/living/silicon/robot/R = loc

	return (src in R.module.modules)

/datum/robot_energy_storage
	var/name = "Generic energy storage"
	var/max_energy
	var/recharge_rate
	var/energy

/datum/robot_energy_storage/New(var/obj/item/robot_module/R = null)
	energy = max_energy
	if(R)
		R.storages |= src
	return

/datum/robot_energy_storage/proc/use_charge(amount)
	if (energy >= amount)
		energy -= amount
		if (energy == 0)
			return TRUE
		return TRUE
	else
		return FALSE

/datum/robot_energy_storage/proc/add_charge(amount)
	energy = min(energy + amount, max_energy)

/datum/robot_energy_storage/metal
	name = "Metal Storage"
	max_energy = 400
	recharge_rate = 15

/datum/robot_energy_storage/glass
	name = "Glass Storage"
	max_energy = 50
	recharge_rate = 2

/datum/robot_energy_storage/wire
	max_energy = 50
	recharge_rate = 2
	name = "Wire Storage"

/datum/robot_energy_storage/medical
	max_energy = 12
	recharge_rate = 1
	name = "Medical Supplies Storage"

/datum/robot_energy_storage/medical/syndicate
	max_energy = 50
	recharge_rate = 4
	name = "Medical Supplies Storage"

/datum/robot_energy_storage/nanopaste
	max_energy = 6
	recharge_rate = 1
	name = "Nanopaste"

/datum/robot_energy_storage/splint
	max_energy = 6
	recharge_rate = 1
	name = "Splints"

/datum/robot_energy_storage/wood
	max_energy = 40
	recharge_rate = 2
	name = "Wood Storage"

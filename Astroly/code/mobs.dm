// Basic

/mob
	icon = 'mobs.dmi'
	var/can_move = TRUE
	var/move_delay
	var/move_speed = 1

/mob/Login()
	..()

	move_delay = world.time

/mob/proc/SelectSlot(id)
	return

/mob/proc/PickUp(var/obj/item/I)
	return

// Player

/mob/player
	name = "Космонавт"
	desc = "Это вы"
	icon_state = "spaceman"
	move_speed = 1

	var/eye_locked = FALSE

	var/datum/inventory/inventory = null

/mob/player/Login()            //spawn location
	InitialiseInventory()
	/var/home = locate(/area/home_mark)
	loc = home
	. = ..()

/mob/player/proc/InitialiseInventory()
	var/datum/inventory/I = new()

	if(I)
		inventory = I

/mob/player/proc/GetItemHolding()
	return inventory.GetItemSelected()

/mob/player/SelectSlot(id)
	inventory.SelectSlot(id)

/mob/player/proc/Die() // TODO
	return

/world
    mob = /mob/player

// HOSTILE

// Alien

#ifdef TEST
/mob/hostile
	var/clicked = FALSE
	move_speed = 0.2

/mob/hostile/Click(location, control, params)
	Test(usr)

/mob/hostile/DblClick()
	del(src)

/mob/hostile/proc/Test(var/mob/user)
	clicked = !clicked
	if(clicked)
		walk_towards(src, user, move_speed SECONDS)
	else
		walk(src, 0)

/mob/player/verb/freeze()
	SCD
	name = "freeze"
	for(var/mob/hostile/H in world)
		H.Test(usr)

#endif

/mob/hostile/alien
	/var/clicked = 0
	name = "alien"
	icon_state = "alien"

/mob/hostile/energy_ball
	name = "Energy Ball"
	desc = "Mysterious blob of energy. Seems dangerous."
	icon = 'energy_ball.dmi'
	icon_state = "small"

	var/stage = 1
	var/mob/target = null

/mob/hostile/energy_ball/proc/scan()
	if(target)
		if(get_dist(src.loc, target.loc) <= 4)
			stage = (stage == 5) ? 5 : stage+1
		else
			stage = (stage == 1) ? 1 : stage-1

	else
		for(var/mob/player/P in oview(4, src))
			target = P     // start following
			return

/mob/hostile/energy_ball/proc/activate()
	set waitfor = FALSE
#ifndef TEST
	return
#else
	while(TRUE)  // main ball's life cycle

		if(target)
			sleep(1.5 SECONDS)
			//step_towards(src, target)

		else
			sleep(4 SECONDS)
			//step_rand(src)

		scan()

		switch(stage)
			if(1)
				icon_state = "small"
			if(2)
				icon_state = "mid"
			if(3)
				icon_state = "big"
			if(4)
				icon_state = "active"
			if(5)
				icon_state = "active_big"
#endif

/mob/hostile/energy_ball/proc/explode(var/mob/player/P)
	if(get_dist(P, src) <= 2)
		P.Die()
		del(src)

/mob/hostile/energy_ball/New()
	..()
	activate()


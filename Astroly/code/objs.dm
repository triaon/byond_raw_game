// Objects


/obj
	icon = 'objs.dmi'

// Shuttle

/obj/spaceship
	name = "spaceship"
	desc = "Your spaceship"
	icon = 'spaceship.dmi'
	density = 1
	opacity = 1

/obj/spaceship/wall
	icon_state = "wall"

/obj/spaceship/wall/corner
	icon_state = "corner"

/obj/spaceship/window
	icon_state = "window"
	opacity = 0

/obj/spaceship/door
	icon_state = "door_close"
	var/opened = 0
	var/blocked = 0

/obj/spaceship/door/AttackedHand(var/mob/player/User)
	set waitfor = FALSE
	if(!blocked)
		icon_state = "door_semi_open"
		sleep(5)
		density = !density
		opacity = !opacity
		opened = !opened
		icon_state = "door" + (opened ? "_open" : "_close")

/obj/spaceship/console
	icon_state = "console"
	opacity = 1

/obj/spaceship/console/dirt_analyser
	icon_state = "console2"
	var/obj/item/dirt/dirt_loaded

/obj/spaceship/console/dirt_analyser/AttackedHand(var/mob/player/User)
	set waitfor = FALSE
	if(!dirt_loaded)
		User.DoAlert("no dirt loaded")
		return

	User.DoAlert("analysing dirt...")
	User.can_move = FALSE
	User.client.view = "10x5"

	icon_state = "console_analysing"

	User << 'buzz.wav'
	sleep(6 SECONDS)

	User.client.view = world.view

	sleep(0.5 SECONDS)

	User << 'ping.wav'
	User.DoAlert("dirt analysis completed")
	User.can_move = TRUE

	icon_state = "console_done"
	dirt_loaded = null

/obj/spaceship/console/dirt_analyser/Attacked(var/obj/item/ByWhat, var/mob/player/User)
	if(istype(ByWhat, /obj/item/dirt))
		var/obj/item/dirt/D = ByWhat
		InsertDirt(D, User)

/obj/spaceship/console/dirt_analyser/proc/InsertDirt(var/obj/item/dirt/D, var/mob/player/User)
	dirt_loaded = D
	User.inventory.RemoveItem(1)
	D.loc = src

	icon_state = "console_dirt_loaded"

/obj/spaceship/light
	name = "light bulb"
	icon_state = "light_bulb"
	opacity = 0
	density = 0

/obj/spaceship/sit
	name = "sit"
	icon_state = "sit"
	opacity = 0
	density = 0

var/global/barrier_level = 1 // 1 - start, 2-5 mid

/obj/barrier
	icon_state = "barrier"
	opacity = 0
	density = 1

// Rocks

/obj/rock
	name = "rock"
	icon_state = "rock"
	var/mass // in kilos
	var/min_mass = 75
	var/max_mass = 150
	var/resource_type
	var/resource_amount

/obj/rock/New()
	..()

/obj/rock/stone
	name = "stone"
	icon_state = "stone"

/obj/rock/stone/New()
	. = ..()
	pixel_x = rand(-12, 12)
	pixel_y = rand(-12, 12)
	var/icon/I = new(src.icon)
	I.Turn(rand(1,360))
	src.icon = I

// Items

/obj/item
	name = ""
	icon = 'icons/items.dmi'

/obj/item/proc/Attack(var/atom/What, var/mob/player/User)
	What.Attacked(src, User)
	return

/obj/item/proc/Use(var/mob/Who)
	return

/obj/item/AttackedHand(var/mob/player/User)
	User.inventory.InsertItem(src)

/obj/item/shovel
	name = "shovel"
	icon_state = "shovel"

/obj/item/shovel/Use(var/mob/player/User)
	User.DoAlert("shovel") // TEST

/obj/item/dirt
	name = "dirt"
	icon_state = "dirt"

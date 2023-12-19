// Turfs

/turf
    icon = 'turfs.dmi'
    var/list/walk_sounds = list()

// Mars ground

/turf/ground
	icon_state = "ground"
	var/digged = FALSE

/turf/ground/New()
	..()
	dir = pick(1, 2, 4, 8)

/turf/ground/Attacked(var/obj/item/ByWhat, var/mob/player/User)
	if(istype(ByWhat, /obj/item/shovel))
		var/obj/item/shovel/S = ByWhat
		Dig(S, User)

/turf/ground/proc/Dig(var/obj/item/shovel/S, var/mob/player/User)
	set waitfor = FALSE

	if(digged)
		return

	if(!S)
		return

	User.can_move = FALSE
	digged = TRUE

	User << 'dig1.wav'
	for(var/i in 1 to 3)
		User.DoAlert("digging...")
		sleep(1 SECONDS)

	User << 'dig2.wav'
	User.can_move = TRUE

	new/obj/item/dirt(src)

	icon_state += "_digged"

/turf/wallrock
	icon_state = "wallrock"
	density = 1

// Shuttle floor

/turf/spaceship
	icon_state = "shuttle"
//	walk_sounds = list('floor_walk1.wav', 'floor_walk2.wav')
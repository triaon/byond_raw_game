/*
	These are simple defaults for your project.
 */

world
	fps = 60		// 25 frames per second
	icon_size = 32	// 32x32 icon size by default

	view = "24x11"


// Make objects move 8 pixels per tick when walking DO NOT USED

mob
	step_size = 8

obj
	step_size = 8


/area
	icon = 'areas.dmi'

/area/home_mark
	icon_state = "home" // Spawn location for our player

/area/barrier_mark
	icon_state = "barrier" // Spawn location for the barrier

///obj/barrier_mark/New()
//	CreateBarrier()

/obj/barrier_mark/proc/CreateBarrier(var/lvl = 2) // standart level is 2
	var/R = 6 + 2 * lvl

	for(var/turf/T in block(locate(x - R, y - R, z), locate(x + R, y + R, z)))
		var/dx = T.x > x ? T.x - x : x - T.x
		var/dy = T.y > y ? T.y - y : y - T.y
		if(dx * dx + dy * dy >= R * R && dx * dx + dy * dy <= (R + 1.5) * (R + 1.5))
			new/obj/barrier(T)


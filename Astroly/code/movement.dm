/world
	movement_mode = TILE_MOVEMENT_MODE


/mob
	glide_size = 6


/mob/Move()
	if(!can_move)
		return

	if(move_delay > world.time)
		return

	move_delay = world.time + move_speed
	src.dir = dir
	. = ..()

/mob/player/Move()
	. = ..()
	if(.)
		var/turf/T = GET_TURF(src)
		if(length(T.walk_sounds))
			src << sound(pick(T.walk_sounds))

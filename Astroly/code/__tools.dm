// Defines

#define SECONDS * 10

#define MINUTES * 600


#define GET_TURF(A) get_step(A, 0)


#define UI_PLANE 100

// Useful

/proc/shake(mob/S, dur, str = 1) // shakes the screen
	if(!S || !S.client || !str) return
	spawn()
		str *= 32
		for(var/i=0; i < dur, i++)
			animate(S.client, pixel_x = rand(-str, str), pixel_y = rand(-str, str), time = 2)
			sleep(2)
		animate(S.client, pixel_x = 0, pixel_y = 0, time = 2)


//DEV//

#define TEST
#define DEBUG

#define SCD set category = "Developer"

#ifdef TEST

/mob/player/verb/shake_camera(duration as num, strength as num)
	SCD
	shake(src, duration, strength)

/mob/player/verb/set_speed()
	SCD
	var/newspeed = input("Введите задержку к перемещнию", "Изменение скорости", 2)
	move_speed = newspeed

/mob/player/verb/set_mob_speed()
	SCD
	var/newspeed = input("Введите задержку к перемещнию", "Изменение скорости", 2)
	for(var/mob/hostile/H in world)
		H.move_speed = newspeed

/mob/player/verb/set_glide_size()
	SCD
	var/newsize = input("Введите значение glide_size", "Изменение glide_size", 6)
	usr.glide_size = newsize

/mob/player/verb/lock_camera()
	SCD
	client.eye = eye_locked ? src : loc
	eye_locked = !eye_locked


/mob/player/verb/spawn_energy_ball()
	SCD
	new/mob/hostile/energy_ball(loc)

/mob/player/verb/spawn_alien()
	SCD
	new/mob/hostile/alien(loc)

#endif

// 'Stylesheet'

#define ALERT_STYLE style='font-size: 5px; color: white; text-align: center; -dm-text-outline: 1px #0005;'

/client/script = {"<style>

.maptext
{
   font-family: 'Small Fonts';
   font-size: 7px;
   -dm-text-outline: 1px black;
   color: white;
   line-height: 1.1;
}

.alert   { font-size: 5px; color: white; text-align: center; -dm-text-outline: 1px #0005; }

</style>"}

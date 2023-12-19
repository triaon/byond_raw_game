// Flying Alerts

// .maptext { font-family: 'Small Fonts'; font-size: 7px; -dm-text-outline: 1px black; color: white; line-height: 1.1; }

mob/player/proc/DoAlert(text)
	set waitfor = FALSE

	if(!client)
		return

	var/image/alert = image(loc = GET_TURF(src), layer = UI_PLANE)

	alert.alpha = 0
	alert.appearance_flags = RESET_ALPHA | RESET_COLOR | RESET_TRANSFORM
	alert.maptext = "<span style='font-size: 5px; color: white; text-align: center; -dm-text-outline: 1px #0005'>[text]</span>"
	alert.maptext_x = -(200 - bound_width) / 2

	var/measurement = client.MeasureText(text, null, 200)
	var/height = copytext(measurement, findtextEx(measurement, "x") + 1)

	alert.maptext_height = text2num(height)
	alert.maptext_width = 200

	client?.images += alert

	var/time_mult = 1 + (length(text) - 1 SECONDS) / 20

	animate(
		alert,
		pixel_y = world.icon_size * 1.2,
		time = 1 SECONDS,
		easing = SINE_EASING | EASE_OUT,
	)

	animate(
		alpha = 255,
		time = 0.2 SECONDS,
		easing = CUBIC_EASING | EASE_OUT,
		flags = ANIMATION_PARALLEL,
	)

	animate(
		alpha = 0,
		time = 0.7 SECONDS * time_mult,
		easing = CUBIC_EASING | EASE_IN,
	)

	sleep(1 SECONDS)

	client?.images -= alert

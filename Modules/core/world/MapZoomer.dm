mob/proc/MapZoom()
	if(!client) return

	// If not already created, make one zoom controller
	if(!client.map_zoom)
		var/obj/map_zoom/Z = new()
		Z.appearance_flags = PLANE_MASTER | PIXEL_SCALE
		Z.plane = 1 // map plane only
		Z.screen_loc = "1,1"
		client.map_zoom = Z
		client.screen += Z

obj/map_zoom
	appearance_flags = PLANE_MASTER || PIXEL_SCALE
	screen_loc = "1,1"
	plane = 0

client/var
	iconsize = 1
	obj/map_zoom/map_zoom // store the zoom controller

client/MouseWheel(src, delta_x, delta_y, location, control, params)
	if(control != "map.map") return
	if(!usr || !usr.client.map_zoom) return

	var/obj/map_zoom/Z = usr.client.map_zoom

	// clamp zoom range
	if(delta_y > 0)
		if(usr.client.iconsize >= 2.5) return
		usr.client.iconsize += 0.1
	else if(delta_y < 0)
		if(usr.client.iconsize <= 1)
			usr.client.iconsize = 1
		else
			usr.client.iconsize -= 0.1

	// Apply zoom only to map plane
	animate(Z, transform = matrix() * usr.client.iconsize, time = 2)

	// Reposition map relative to screen center to keep it anchored visually
	Z.transform = matrix() * usr.client.iconsize
	Z.transform.Translate((1 - usr.client.iconsize) * world.icon_size * 8, (1 - usr.client.iconsize) * world.icon_size * 7)

	// Optional: re-align HUD after zoom to ensure consistent layout
	if(usr.client.mob && usr.client.mob.HUD)
		usr.client.mob.HUD.Rescale_HUD(usr.client.mob)

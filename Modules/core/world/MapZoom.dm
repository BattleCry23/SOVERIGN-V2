

// Only zoom the map plane (0) and the dedicated world-effects plane (15).
// Plane 15 is reserved for world-located combat effects that use PIXEL_SCALE
// (large-sprite objects like beams, balls, charge orbs).
// HUD planes (22,24,28,29,30,32,33,34,35,36,37,etc.) are intentionally excluded.
#define WORLD_ZOOM_PLANES list(0,15)

obj/map_zoom
	appearance_flags = PLANE_MASTER | PIXEL_SCALE
	screen_loc = "LEFT,TOP to RIGHT,BOTTOM"
	plane = 0
	//mouse_opacity = 0
	blend_mode = BLEND_DEFAULT
	//color = list(null,null,null,null,"#FFFFFF00")  // 0 alpha

client/var/iconsize = 1 // current zoom multiplier

// Creates one plane-master per world plane and starts zoom at current iconsize.
mob/proc/MapZoom()
	for(var/p in WORLD_ZOOM_PLANES)
		var/obj/map_zoom/Z = new()
		Z.plane = p
		Z.appearance_flags = PLANE_MASTER | PIXEL_SCALE
		client.screen += Z
	_apply_zoom(client, client.iconsize, 2)
	MouseWheel(control="map.map")

// Animates all world-plane masters to the given zoom level.
mob/proc/_apply_zoom(var/client/C, var/zoom_level, var/anim_time = 1)
	for(var/obj/map_zoom/Z in C.screen)
		animate(Z, transform = matrix() * zoom_level, time = anim_time)

client/MouseWheel(src, delta_x, delta_y, location, control, params)
	if(usr.client && control == "map.map")
		if(delta_y >= 1)
			if(iconsize >= 10) return
			iconsize += 0.1
		else if(delta_y <= -1)
			iconsize -= 0.1
			if(iconsize < 1) iconsize = 1
		else
			return
		usr._apply_zoom(usr.client, iconsize, 1)
		usr.client.mob.HUD.Rescale_HUD(usr.client.mob)



mob/proc/SetZoom(var/zoom_level = 1, var/smooth = 1)
	// Ensure valid zoom target
	if(zoom_level < 0.5) zoom_level = 0.5
	if(zoom_level > 10) zoom_level = 10

	var/client/C = src.client
	if(!C) return

	// Ensure plane masters exist for all world planes.
	var/list/existing_planes = list()
	for(var/obj/map_zoom/Z in C.screen)
		existing_planes += Z.plane
	for(var/p in WORLD_ZOOM_PLANES)
		if(!(p in existing_planes))
			var/obj/map_zoom/Z = new()
			Z.plane = p
			Z.appearance_flags = PLANE_MASTER | PIXEL_SCALE
			Z.screen_loc = "LEFT,TOP to RIGHT,BOTTOM"
			C.screen += Z

	// Apply the zoom immediately or smoothly
	C.iconsize = zoom_level
	if(smooth)
		_apply_zoom(C, zoom_level, 5)
	else
		for(var/obj/map_zoom/Z in C.screen)
			Z.transform = matrix() * zoom_level

	if(C.mob && C.mob.HUD)
		C.mob.HUD.Rescale_HUD(C.mob)

	//C.mob << "Zoom level set to [zoom_level]x"

/*
mob/verb/DebugZoom()
	set name = "Debug Zoom"
	set category = "Debug"
	if(!client) return

	var/zoom = input("Enter zoom level (1 = normal, 2 = 2x, 0.5 = half zoom):", "Zoom") as num
	var/smooth = alert("Smooth transition?", "", "Yes", "No")

	src.SetZoom(zoom, smooth == "Yes")
*/
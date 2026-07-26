

mob/proc/MapZoom()
	var/obj/map_zoom/Z = new() ; Z.appearance_flags = PLANE_MASTER | PIXEL_SCALE
	client.screen += Z
	animate(Z, transform = matrix()*client.iconsize, time = 2)
	//MouseWheel(control="newmain.map")
	MouseWheel(control="map.map")


obj/map_zoom
	appearance_flags = PLANE_MASTER || PIXEL_SCALE
	screen_loc = "TOP,LEFT to RIGHT,BOTTOM"
	plane = 0
	//mouse_opacity = 0
	blend_mode = BLEND_DEFAULT
	//color = list(null,null,null,null,"#FFFFFF00")  // 0 alpha

client/var/iconsize = 1 //this var is what defines by how much we zoom in!

client/MouseWheel(src,delta_x,delta_y,location,control,params) //Control zooming with the mouse wheel!
//	if(usr.inSpacePod==1) return
	if(usr.client && control =="map.map") // newmain.map
		//if(usr.ZoomToggled==0) return
		var/obj/map_zoom/z =  locate() in usr.client.screen
		if(z)
			if(delta_y>=1)
				if(iconsize>= 10) return
				iconsize += 0.1
				animate(z, transform = matrix()*iconsize, time = 1)
				//if(usr.client.ShouldScaleUI()) usr.client.mob.HUD.Rescale_HUD(usr.client.mob)
				usr.client.mob.HUD.Rescale_HUD(usr.client.mob)
				return
			if(delta_y<=-1)
				iconsize -= 0.1
				if(iconsize<= 1)
					iconsize = 1
					animate(z, transform = matrix()*iconsize, time = 1)
					//if(usr.client.ShouldScaleUI()) usr.client.mob.HUD.Rescale_HUD(usr.client.mob)
					usr.client.mob.HUD.Rescale_HUD(usr.client.mob)
					return

				animate(z, transform = matrix()*(iconsize), time =1)
				//if(usr.client.ShouldScaleUI()) usr.client.mob.HUD.Rescale_HUD(usr.client.mob)
				usr.client.mob.HUD.Rescale_HUD(usr.client.mob)
				return




mob/proc/SetZoom(var/zoom_level = 1, var/smooth = 1)
	// Ensure valid zoom target
	if(zoom_level < 0.5) zoom_level = 0.5
	if(zoom_level > 10) zoom_level = 10

	var/client/C = src.client
	if(!C) return

	// Find or create the zoom master
	var/obj/map_zoom/Z = null
	for(var/obj/map_zoom/x in C.screen)
		Z = x
	if(!Z)
		Z = new
		Z.appearance_flags = PLANE_MASTER | PIXEL_SCALE
		Z.plane = 0
		Z.screen_loc = "1,1"
		C.screen += Z

	// Apply the zoom immediately or smoothly
	C.iconsize = zoom_level
	if(smooth)
		animate(Z, transform = matrix() * zoom_level, time = 5)
	else
		Z.transform = matrix() * zoom_level

	// Recalibrate HUD (optional)

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
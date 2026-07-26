mob/var/tmp/HUD/HUD
client
	control_freak=CONTROL_FREAK_SKIN
	view="18x15"
	//pixel_x=16
	var
		autosnap=1
		stretchmap=0
		camera_x=0
		camera_y=0
		offset_x=0
		offset_y=0
		tmp
			window_x=0
			window_y=0
			fullscreen=0
			//splitter=0
			HUD/HUD

	verb
		/*toggleAutoSnap()
			autosnap=!autosnap
			if(autosnap)src<<"Autosnap enabled."
			else src<<"Autosnap disabled."*/

		Splitter()
			set hidden=1
			if(!stretchmap)setMap()

		WindowResize()
			set hidden=1
			if(!stretchmap)
				if(winget(src,"main","is-maximized")=="true")
					src.mob.alertbox("Going full-screen may cause lag on low performance computers.")
				setMap(1)

	proc
		ResetWindow()
			view="18x15"
			winset(src,"main","size=900x480;is-maximized=false")
			winset(src,"main.child","splitter=65")
			saveWindow()

		setMap(size)
			var
				map_size=winget(src,"map.map","size")
				map_x=text2num(copytext(map_size,1,findtext(map_size,"x",1,length(map_size))))
				map_y=text2num(copytext(map_size,findtext(map_size,"x",1,length(map_size))+1,lentext(map_size)+1))
				nx=round(map_x/32,1)
				ny=round(map_y/32,1)

			if(nx<15)nx=15
			if(ny<10)ny=15
			var
				view_x=text2num(copytext(view,1,findtext(view,"x",1,length(view))))
				view_y=text2num(copytext(view,findtext(view,"x",1,length(view))+1,lentext(view)+1))
				diff_x=nx-view_x
				diff_y=ny-view_y
			view="[nx]x[ny]"

			if(nx%2)camera_x=0
			else camera_x=16
			if(ny%2)camera_y=0
			else camera_y=16
			setCamera()

			if(fullscreen)
				if(winget(src,"main","is-maximized")=="false")
					fullscreen=0
			else if(size)
				if(winget(src,"main","is-maximized")=="false")
					if(autosnap)
						if(!diff_x)
							if(!diff_y)
								winset(src,"main","size=[window_x]x[window_y]")//full reset
							else
								winset(src,"main","size=[window_x]x[window_y+(diff_y*32)]")//reset x - update y
								saveWindow()
						else
							if(!diff_y)
								winset(src,"main","size=[window_x+(diff_x*32)]x[window_y]")//reset y - update x
								saveWindow()
							else
								winset(src,"main","size=[window_x+(diff_x*32)]x[window_y+(diff_y*32)]")//full update
								saveWindow()
				else fullscreen=1
		setCamera()
			pixel_x=camera_x+offset_x
			pixel_y=camera_y+offset_y

		saveWindow()
			var/main_size=winget(src,"main","size")
			window_x=text2num(copytext(main_size,1,findtext(main_size,"x",1,lentext(main_size))))
			window_y=text2num(copytext(main_size,findtext(main_size,"x",1,lentext(main_size))+1,lentext(main_size)+1))
			//splitter=winget(src,"main.child","splitter")
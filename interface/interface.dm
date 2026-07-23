var/global/BASE_WIDTH  = 1920//1920
var/global/BASE_HEIGHT = 1080//1080
var/global/BASE_VIEW_X = 60 // was 20
var/global/BASE_VIEW_Y = 33 // was 15

mob/var/tmp/HUD/HUD
mob/var/map_initialized = 0  // Per-player persistent flag
var/global/savefile/map_init_flags = new("data/map_initialized_flags.sav")
proc/GetScreenResolution(mob/M) // Yay dynamic HUDS?!
	var/POS = "[winget(M, "label","pos")]"
	var/COMA = findtext(POS,",",1,0)
	var/X = text2num(copytext(POS,1,COMA))
	var/Y = text2num(copytext(POS,COMA+1,0))
	M.client.view="[round(X/60)]x[round(Y/33)]"

client/proc/CalculateGlobalScale()

    var/main_size = winget(src, "main", "size")
    if(!main_size) return 1

    var/split = findtext(main_size, "x")
    if(!split) return 1

    var/w = text2num(copytext(main_size, 1, split))
    var/h = text2num(copytext(main_size, split + 1))

    if(!w || !h) return 1

    var/scale_x = w / BASE_WIDTH
    var/scale_y = h / BASE_HEIGHT

    var/scale = min(scale_x, scale_y)

    // Prevent microscopic scaling
    if(scale < 0.75)
        scale = 0.75

    return scale

/*client/proc/setMap(var/force = FALSE)

    if(!mob) return

    // --------------------------------------------------
    // 1️⃣ Calculate resolution scale
    // --------------------------------------------------

    var/scale = CalculateGlobalScale()

    var/new_view_x = round(BASE_VIEW_X * scale)
    var/new_view_y = round(BASE_VIEW_Y * scale)

    // Optional Eternia-style extra vertical expansion
    new_view_y += 2

    var/new_view = "[new_view_x]x[new_view_y]"

    // Prevent redundant recalculation
    if(!force && view == new_view)
        return

    view = new_view

    // --------------------------------------------------
    // 2️⃣ Reset camera safely
    // --------------------------------------------------

    eye = mob
    perspective = EYE_PERSPECTIVE

    mob.pixel_x = 0
    mob.pixel_y = 0

    // --------------------------------------------------
    // 3️⃣ Rescale HUD safely
    // --------------------------------------------------

    //if(mob.HUD)
     //   mob.HUD.Rescale_HUD(mob)

    // Optional title screen rescale
    //if(istype(mob, /mob))
      //  Rescale_TitleScreen(mob)

    winset(src, null, "refresh=1")

    */
client
	control_freak=CONTROL_FREAK_ALL//CONTROL_FREAK_SKIN|CONTROL_FREAK_MACROS
	//control_freak = 0
	//view="18x15"
	//pixel_x=32
	var
		autosnap=1
		stretchmap=0
		camera_x=0
		camera_y=0
		offset_x=0
		offset_y=0
		window_x=0
		window_y=0

		tmp

			fullscreen=0
			splitter=0
			fullscreen_warning = 0
			HUD/HUD
			custom_view

	var/tmp
		last_map_view = null      // Stores previous map view size like "53x30"
		last_resize_call = 0      // Tracks last resize time for debounce

	verb
		/*toggleAutoSnap()
			autosnap=!autosnap
			if(autosnap)src<<"Autosnap enabled."
			else src<<"Autosnap disabled."*/

		Splitter()
			set hidden=1
			if(!stretchmap)setMap(1)


		WindowResize()
			set hidden = 1
			if(world.time < last_resize_call + 10) return // 1 second debounce
			last_resize_call = world.time
			if(!stretchmap)
				if(istype(mob,/mob) && !fullscreen_warning)
					if(winget(src,"main","is-maximized")=="true")
					//	alert(src,"Going full-screen may cause lag on low performance computers.")
						fullscreen_warning = 1
				setMap(1)


		/*WindowResize()
			set hidden=1
			var/time = world.time
			if(!stretchmap)
				if(istype(mob,/mob) && !fullscreen_warning)
					if(winget(src,"main","is-maximized")=="true")
					//	alert(src,"Going full-screen may cause lag on low performance computers.")
						fullscreen_warning = 1
				setMap(1)*/


	proc

		ResetWindow()
			//view="15x15"
			//winset(src,"main","size=900x480;is-maximized=false")
			winset(src,"main.child","splitter=54")
			saveWindow()

		setMap(size)


			if(!mob) return



			/*if(!ShouldScaleUI())
				var/map_size = winget(src, "map.map", "size")
				var/split = findtext(map_size, "x")
				var/w = text2num(copytext(map_size, 1, split))
				var/h = text2num(copytext(map_size, split + 1))
				view = "[w]x[h]"
				eye = mob
				perspective = MOB_PERSPECTIVE
				world<<"Should Scale False"
				return*/


			//ResetWindow(
			var
				map_size=winget(src,"map.map","size")
				map_x=text2num(copytext(map_size,1,findtext(map_size,"x",1,length(map_size))))
				map_y=text2num(copytext(map_size,findtext(map_size,"x",1,length(map_size))+1,length(map_size)+1))
				nx=round(map_x/36,1)
				ny=round(map_y/36,1)
				//nx = round(map_x / world.icon_size)
				//ny = round(map_y / world.icon_size)
			if(!ShouldScaleUI())
				//view = "18x15"
				view = "[BASE_VIEW_X]x[BASE_VIEW_Y]"
				eye = mob
				perspective = MOB_PERSPECTIVE
				//setCamera()

				return
			if(nx<15)nx=15
			if(ny<10)ny=10

			var
				view_x=text2num(copytext(view,1,findtext(view,"x",1,length(view))))
				view_y=text2num(copytext(view,findtext(view,"x",1,length(view))+1,length(view)+1))
				diff_x=nx-view_x
				diff_y=ny-view_y

			//world<< "([view])"
			//view="[nx]x[ny]"


			view = "[nx]x[ny]"

			// Properly center the camera

			eye = mob
			perspective = EYE_PERSPECTIVE

			if(nx%2) camera_x=32
			else camera_x=-32
			//camera_x = -32
			if(ny%2) camera_y=0
			else camera_y=32
			setCamera()

			if(fullscreen)
				if(winget(src,"main","is-maximized")=="false")
					fullscreen=0
			else if(size)
				if(winget(src,"main","is-maximized")=="false")
					if(autosnap)
						if(!diff_x)
							if(!diff_y)
							//	world << "Full reset !diff_y"
							//	winset(src,"main","size=[window_x]x[window_y]")//full reset
							else
								//world << " reset x - update y"
								//winset(src,"main","size=[window_x]x[window_y+(diff_y*32)]")//reset x - update y
								saveWindow()
						else
							if(!diff_y)
							//	world << "reset y - update x"
								//winset(src,"main","size=[window_x+(diff_x*32)]x[window_y]")//reset y - update x
								saveWindow()
							else
								//world << " full update"
							//	winset(src,"main","size=[window_x+(diff_x*32)]x[window_y+(diff_y*32)]")//full update
								saveWindow()
				else fullscreen=1
		//	winset(src,"main","size=[window_x+(diff_x*32)]x[window_y+(diff_y*32)]")//full update
			//mob.Awaken()
			saveWindow()
			//world<<"Window x: [window_x] | Camera_x [camera_x] - Offset_x [offset_x]"
			//world<<"Window y: [window_y] | Camera_y [camera_y] - Offset_y [offset_y]"
			if(mob && mob.HUD)
				mob.HUD.Rescale_HUD(mob)
			//pixel_x = 0
			//pixel_y = 0




		/*setMap(size = 0, force = FALSE)
			// Early exit to prevent redundant runs
			//if(mob.map_initialized >=3 && !size && !force)
			//	world << "[src] setMap() already ran, skipping."
			//	return
			//mob.map_initialized += 1


			var/map_size = winget(src, "map.map", "size")
			var/map_x = text2num(copytext(map_size, 1, findtext(map_size, "x")))
			var/map_y = text2num(copytext(map_size, findtext(map_size, "x") + 1))

			var/nx = round(map_x / 36, 1)
			var/ny = round(map_y / 36, 1)

			if(nx < 15) nx = 15
			if(ny < 10) ny = 15

			var/current_view = "[nx]x[ny]"
			var/view_x = text2num(copytext(view, 1, findtext(view, "x")))
			var/view_y = text2num(copytext(view, findtext(view, "x") + 1))

			var/diff_x = nx - view_x
			var/diff_y = ny - view_y

			// Skip if the view is already correct
			if(!size && !force && view == current_view && last_map_view == current_view && !diff_x && !diff_y)
				world<< "[src] skipping setMap: unchanged view ([view])"
				return
			else
				world << "[src] applying setMap: view changing to [current_view]"

			// Store last applied view
			last_map_view = current_view
			view = current_view

			// Set up camera
			eye = mob
			perspective = EYE_PERSPECTIVE
			camera_x = (nx % 2) ? 32 : -32
			camera_y = (ny % 2) ? 0 : 32
			setCamera()

			// Fullscreen behavior
			if(fullscreen)
				if(winget(src, "main", "is-maximized") == "false")
					fullscreen = 0
			else if(size)
				if(winget(src, "main", "is-maximized") == "false")
					if(autosnap)
						if(!diff_x && !diff_y)
							winset(src, "main", "size=[window_x]x[window_y]")
						else if(!diff_x)
							winset(src, "main", "size=[window_x]x[window_y + (diff_y * 32)]")
						else if(!diff_y)
							winset(src, "main", "size=[window_x + (diff_x * 32)]x[window_y]")
						else
							winset(src, "main", "size=[window_x + (diff_x * 32)]x[window_y + (diff_y * 32)]")
						saveWindow()
				else fullscreen = 1

			// Adjust HUD
			if(mob && mob.HUD)
				mob.HUD.Rescale_HUD(mob)

			pixel_x = 0
			pixel_y = 0 */

		setCamera()
			if(custom_view)
				if(custom_view == "Auto")

					pixel_x = 32
					pixel_y = 32
				else if(custom_view == "Zero")
					pixel_x = 0
					pixel_y = 0
				else if(custom_view != "Auto" && custom_view != "Zero" )
					pixel_x = custom_view
					pixel_y = custom_view
			else

				pixel_x=camera_x+offset_x
				pixel_y=camera_y+offset_y

		saveWindow()
			var/main_size=winget(src,"main","size")
			window_x=text2num(copytext(main_size,1,findtext(main_size,"x",1,length(main_size))))
			window_y=text2num(copytext(main_size,findtext(main_size,"x",1,length(main_size))+1,length(main_size)+1))
			splitter=winget(src,"main.child","splitter")

client/proc/Rescale_TitleScreen(var/mob/m)
	set background = 1
	if(!m || !m.client) return

	var/view_size = m.client.view
	//var/vx = text2num(copytext(view_size, 1, findtext(view_size, "x")))
	var/vy = text2num(copytext(view_size, findtext(view_size, "x") + 1))

	for(var/obj/hud/titles/title/h in m.client.screen)
		//m<"Moving Title."
		h.screen_loc = "5,[vy-10]:13"
	for(var/obj/hud/titles/Join_World/h in m.client.screen)
	//	m<"Moving Join Now Icon."
		h.screen_loc = "15,[vy-5]:13"
HUD/proc/Rescale_Debuffs_Hud(var/mob/m)
	set background = 1
	if(!m || !m.client) return

	var/view_size = m.client.view
	//var/vx = text2num(copytext(view_size, 1, findtext(view_size, "x")))
	var/vy = text2num(copytext(view_size, findtext(view_size, "x") + 1))
	var/start_x = 3
	var/start_y = 5
	for(var/obj/buffs_and_debuffs/b in m.client.screen)

		//src.client.screen -= b;
		if(b.active)
			b.screen_loc = "[start_x]:[start_y],[vy]"
			if(start_x == "3") b.info_txt.maptext_x = b.x_shift
			//else b.info_txt.maptext_x = -38
			//if(src.client) src.client.screen += b;
			//if(src && src.HUD)
			//	src.HUD.Rescale_HUD(src)
			start_x += 1

mob/var/tmp/last_hud_rescale = 0

HUD/proc/Rescale_HUD(var/mob/m)
	if(!m || !m.client ) return
	if(world.time < m.last_hud_rescale + 2) return
	m.last_hud_rescale = world.time
	var/view_size = m.client.view
	var/vx = text2num(copytext(view_size, 1, findtext(view_size, "x")))
	var/vy = text2num(copytext(view_size, findtext(view_size, "x") + 1))


	// === Core HUD Bars ===
	//if(m.hud_info)
		//m.hud_info.screen_loc = "BOTTOM,RIGHT"
	if(m.hud_hp_bar)
		m.hud_hp_bar.screen_loc = "3:1,[vy-1]:4"
	if(m.hud_hp_bar_inner)
		m.hud_hp_bar_inner.screen_loc = "3:2,[vy-1]:4"

	if(m.hud_eng_bar)
		m.hud_eng_bar.screen_loc = "3:1,[vy-2]:17"
	if(m.hud_eng_bar_inner)
		m.hud_eng_bar_inner.screen_loc = "3:2,[vy-2]:18"
	var/start_x = 3
	var/start_y = 5
	for(var/obj/effects/over_displays/lvl_up_overlay/h in m.client.screen)
		var/orig = h.screen_loc
		var/comma = findtext(orig, ",")
		if(!comma) continue

		var/y_part = copytext(orig, comma+1) // everything after the comma (Y side)
		h.screen_loc = "[vx-12],[y_part]"


	for(var/obj/hud/menus/bodyparts_background/h in m.client.screen)
		h.plane=29
		var/matched = FALSE
		var/growth_rate = 1.3
		switch(h.name)
			if("Left Arm", "leftarm", "left_arm")
				animate(h)
				h.transform = matrix().Scale(growth_rate, growth_rate)
				//animate(h, transform = matrix().Scale(growth_rate, growth_rate), time = growth_time)
				h.screen_loc = "TOP-3,LEFT+2"
				matched = TRUE

			if("Right Arm", "rightarm", "right_arm")
				animate(h)
				h.transform = matrix().Scale(growth_rate, growth_rate)
				//animate(h, transform = matrix().Scale(growth_rate, growth_rate), time = growth_time)
				h.screen_loc = "TOP-3,LEFT+3:8" // 2L28
				matched = TRUE

			if("Left Leg", "leftleg", "left_leg")
				animate(h)
				h.transform = matrix().Scale(growth_rate, growth_rate)
				//animate(h, transform = matrix().Scale(growth_rate, growth_rate), time = growth_time)
				//h.screen_loc = "TOP-3:-28,LEFT+2"
				h.screen_loc = "TOP-4:-8,LEFT+2"
				matched = TRUE

			if("Right Leg", "rightleg", "right_leg")
				animate(h)
				h.transform = matrix().Scale(growth_rate, growth_rate)
				//animate(h, transform = matrix().Scale(growth_rate, growth_rate), time = growth_time)
			//	h.screen_loc = "TOP-4,LEFT+2:32"
				h.screen_loc = "TOP-4:-8,LEFT+3:8"
				matched = TRUE



		if(!matched)
			h.screen_loc = "TOP,LEFT"

	for(var/obj/help_topics/h in m.client.screen)
		var/orig = h.screen_loc
		var/comma = findtext(orig, ",")
		if(!comma) continue

		var/y_part = copytext(orig, comma+1) // everything after the comma (Y side)
		h.screen_loc = "[vx-15],[y_part]"
	for(var/obj/quests/tutorials/h in m.client.screen)
		var/orig = h.screen_loc
		var/comma = findtext(orig, ",")
		if(!comma) continue

		var/y_part = copytext(orig, comma+1) // everything after the comma (Y side)
		h.screen_loc = "[vx-15],[y_part]"

	for(var/obj/buffs_and_debuffs/b in m.client.screen)

		//src.client.screen -= b;
		if(b.active)
			b.screen_loc = "[start_x]:[start_y],[vy]"
			if(start_x == "3") b.info_txt.maptext_x = b.x_shift
			//else b.info_txt.maptext_x = -38
			//if(src.client) src.client.screen += b;
			//if(src && src.HUD)
				//src.HUD.Rescale_HUD(src)
			start_x += 1

			//b.screen_loc = "3:5,[vy]"

	// === Power/Stat Display ===
	if(m.hud_pp)
		m.hud_pp.plane=29
		m.hud_pp.screen_loc = "3:5,[vy-1]:20"

	// === Skill Buttons / Menu ===
	if(m.hud_passivetree)
		m.hud_passivetree.screen_loc = "1:1,[vy-3]:13"
	if(m.hud_immersionshop)
		m.hud_immersionshop.screen_loc = "2:1,[vy-3]:13"
	if(m.hud_dokushop)
		m.hud_dokushop.screen_loc = "3:1,[vy-3]:13"

	if(m.hud_cft)
		m.hud_cft.screen_loc = "1:55,[vy-5]:13"
	if(m.hud_rptree)
		m.hud_rptree.screen_loc = "2:1,[vy-5]:13"

	// === Optional eating bar ===
	if(m.hud_eat)
		m.hud_eat.screen_loc = "3:[vx-3],[vy-3]"


	for(var/obj/hud/buttons/main/button_admin/h in m.client.screen)

		h.screen_loc = "1:1,[vy-4]:13"
	for(var/obj/hud/buttons/main/button_emote/h in m.client.screen)
		h.screen_loc = "BOTTOM,RIGHT-10"

	for(var/obj/portrait/h in m.client.screen)
		h.screen_loc = "1,[vy-2]:14"
	// === Revive Bar (center mid-screen) ===
	//for(var/obj/hud/bars/revive_bar/h in m.client.screen)
	//	h.screen_loc = "CENTER,TOP+([vy]/2)"
	//for(var/obj/hud/bars/revive_bar_inner/h in m.client.screen)
	//	h.screen_loc = "CENTER,TOP+([vy]/2)"

	// === Name Bar (above character) ===
	//for(var/obj/hud/bars/name_bar/h in m.client.screen)
	//	h.screen_loc = "CENTER,TOP-[vy-3]"

	m.pixel_x = 0
	m.pixel_y = 0
	winset(m, null, "refresh=1")

	//m << "HUD recalibrated for view [vx]x[vy]"
client/proc/ShouldScaleUI()
    var/map_size = winget(src, "map.map", "size")
    //if(!map_size) return FALSE

    var/split = findtext(map_size, "x")
   // if(!split) return FALSE

    var/w = text2num(copytext(map_size, 1, split))
    var/h = text2num(copytext(map_size, split + 1))

   // if(!w || !h) return FALSE

    if(w < BASE_WIDTH && h < BASE_HEIGHT)
        return FALSE
    //if(tile_x < BASE_VIEW_X-12 || tile_y < BASE_VIEW_Y)
       // return FALSE

    return TRUE

client/proc/ApplyResolutionScale(var/fake_w, var/fake_h)

    if(!mob) return

    // Calculate scale relative to base resolution
    var/scale_x = fake_w / BASE_WIDTH
    var/scale_y = fake_h / BASE_HEIGHT

    var/scale = min(scale_x, scale_y)

    if(scale < 0.75)
        scale = 0.75

    var/new_view_x = round(BASE_VIEW_X * scale)
    var/new_view_y = round(BASE_VIEW_Y * scale)

    if(new_view_x < BASE_VIEW_X) new_view_x = BASE_VIEW_X
    if(new_view_y < BASE_VIEW_Y) new_view_y = BASE_VIEW_Y

    view = "[new_view_x]x[new_view_y]"

    eye = mob
    perspective = MOB_PERSPECTIVE

    mob.pixel_x = 0
    mob.pixel_y = 0

    if(mob.HUD)
        mob.HUD.Rescale_HUD(mob)

    winset(mob, null, "refresh=1")

client/proc/FinalizeUI()
    if(!mob) return
    // Always reset these so old offsets don't linger
    mob.pixel_x = 0
    mob.pixel_y = 0
    if(mob.HUD) mob.HUD.Rescale_HUD(mob)
    winset(src, null, "refresh=1")

client/proc/setMaptest(force=FALSE)
    if(!mob) return

    var/map_size = winget(src,"map.map","size")
    var/s = findtext(map_size,"x")
    if(!s) return

    var/map_x = text2num(copytext(map_size,1,s))
    var/map_y = text2num(copytext(map_size,s+1))
    if(!map_x || !map_y) return

    var/nx = max(BASE_VIEW_X, round(map_x / world.icon_size))
    var/ny = max(BASE_VIEW_Y, round(map_y / world.icon_size))

    var/new_view = "[nx]x[ny]"
    if(!force && view == new_view) return

    view = new_view

    eye = mob
    perspective = EYE_PERSPECTIVE

    // Use icon_size, not hardcoded 32
    camera_x = (nx % 2) ? world.icon_size : -world.icon_size
    camera_y = (ny % 2) ? 0 : world.icon_size
    setCamera()

    FinalizeUI()
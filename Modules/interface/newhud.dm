image
	var
		ref = null
		current_z = 1
	map_blip
		/*
		Click()
			if(src.ref)
				var/mob/m = null
				for(var/mob/p in players)
					if(p.client.key == src.ref)
						m = p
						break
				if(m)
					usr.target = m
					usr.estimates()

					usr.create_target_bars(m)

					if(!m.target_img)
						var/image/trg = image('target.dmi',m,"",2)
						m.target_img = trg
					usr.client.images += m.target_img

					usr.client.images += m.bar_energy

					usr.client.images += m.bar_health


		*/
mob
    var
        obj/hud/emote_window/open_emote_hud = null
obj/hud/emote_window
    icon = 'spr_menu.dmi'
    layer = 100
    screen_loc = "CENTER,CENTER"
    var
        obj/hud/input_text/input_box
        obj/hud/buttons/emote_button
        input_text = ""
        char_count = 0
        estimated_reward = 0
    New()
        ..()
        // Add the input box
        var/obj/hud/input_text/input_box = new
        input_box.screen_loc = "15,15-3" // Adjust relative to emote window
        input_box.maptext_width = 200
        input_box.maptext_height = 20
        input_box.maptext_x = 10
        input_box.maptext_y = 5
        src.input_box = input_box
        vis_contents += input_box

        // Add the emote button
        var/obj/hud/buttons/emote_button = new
        emote_button.screen_loc = "15+6,15+3" // Bottom-right corner
        src.emote_button = emote_button
        vis_contents += emote_button

        spawn while (usr && usr.open_emote)
            var/text = winget(usr, "input_box", "text") // Get text from the hidden input box
            if (text != src.input_text)
                src.input_text = text
                input_box.maptext = "<font size=2 color=white>[text]</font>" // Update the input box display
            sleep(1)


    proc/display()
        // Update display for character count and reward
    //    input_box.maptext = ">.. "//"<font size=2 color=white>[input_text]</font>"
        var/text = "Estimated Reward: [estimated_reward]"
        maptext = text
        maptext_x = 150
        maptext_y =7
obj/hud/input_text
    icon = null // No background, text only
    layer = 101
    maptext_width = 200
    maptext_height = 20
    maptext_x = 10
    maptext_y = 5
    maptext = "<font size=2 color=white>Click to start typing...</font>"
    var/is_focused = 0
    Click()
        if (!is_focused)
            maptext = "<font size=2 color=white></font>" // Clear placeholder text
            is_focused = 1
            usr.client << output("", "input_box") // Clear the hidden input field
            winset(usr, "input_box", "focus=true") // Focus the input box for typing
            usr << "You can now type in the input box."

obj/hud/buttons/emote_button
    icon = 'emote.dmi' // Replace with your button's icon file
    icon_state = "" // Define the icon state if needed
    layer = 101
    screen_loc = "CENTER,CENTER"
    Click()
        if (usr && usr.open_emote_hud)
            var/text = usr.open_emote_hud.input_text
            if (length(text) <= 0)
                usr << "You must type something to emote!"
                return
            usr.emote(text) // Call the Emote() verb
            usr.client.screen -= usr.open_emote_hud // Close the emote window
            del(usr.open_emote_hud)
            usr.open_emote_hud = null
            usr.open_emote = 0
            usr.overlays -= 'Typing.dmi'


obj
	hud
		New()
			spawn(10)
				if(src)
					//src.check_screen_loc()
					var/icon/i = new(src.icon)
					src.i_width = i.Width()
					src.i_height = i.Height()
			..()

		/*
		bars_adjustable
			var/obj/scroller = null
			var/obj/bar = null
			bar_slider_leftright
				icon = 'new_hud_slider_leftright.dmi'
				layer = 35
			bar_str
				icon = 'new_hud_use_bar.dmi'
				layer = 34
				New()
					var/obj/hud/bars_adjustable/bar_slider_leftright/s = new
					src.scroller = s
					src.vis_contents += s
					var/matrix/m = matrix()
					m.Translate(200,-3)
					s.transform = m
					s.bar = src
				Click(location,control,params)
					usr.client.MousePosition(params)
					params = params2list(params)
					var/icon_x = text2num(params["icon-x"])
					var/obj/hud/bars_adjustable/s = src.scroller
					s.y_start = usr.client.client_mouse_x-icon_x
					var/matrix/m = matrix()
					m.Translate(icon_x,-3)
					s.transform = m
					if(usr.hud_stats)
						if(src in usr.hud_stats.txt_tab1)
							var/obj/hud/menus/core_stats_background/bg = usr.hud_stats
							usr.mod_str_usage = round(icon_x / 200,0.01)
							usr.mod_str_usage = clamp(usr.mod_str_usage,0.01,1)
							bg.txt_str.maptext = "[css_outline]<font size = 1><text align=left valign=top>[round(usr.mod_str_usage*100,0.01)]%"
							if(usr.skill_psi_clone)
								for(var/mob/m in usr.skill_psi_clone.active_splits)
									m.mod_str_usage = usr.mod_str_usage
							if(usr.skill_divine_weapon)
								for(var/mob/m in usr.skill_divine_weapon.active_splits)
									m.mod_str_usage = usr.mod_str_usage
			bar_force
				icon = 'new_hud_use_bar.dmi'
				layer = 34
				New()
					var/obj/hud/bars_adjustable/bar_slider_leftright/s = new
					src.scroller = s
					src.vis_contents += s
					var/matrix/m = matrix()
					m.Translate(200,-3)
					s.transform = m
					s.bar = src
				Click(location,control,params)
					usr.client.MousePosition(params)
					params = params2list(params)
					var/icon_x = text2num(params["icon-x"])
					var/obj/hud/bars_adjustable/s = src.scroller
					s.y_start = usr.client.client_mouse_x-icon_x
					var/matrix/m = matrix()
					m.Translate(icon_x,-3)
					s.transform = m
					if(usr.hud_stats)
						if(src in usr.hud_stats.txt_tab1)
							var/obj/hud/menus/core_stats_background/bg = usr.hud_stats
							usr.mod_force_usage = round(icon_x / 200,0.01)
							usr.mod_force_usage = clamp(usr.mod_force_usage,0.01,1)
							bg.txt_force.maptext = "[css_outline]<font size = 1><text align=left valign=top>[round(usr.mod_force_usage*100,0.01)]%"
							if(usr.skill_psi_clone)
								for(var/mob/m in usr.skill_psi_clone.active_splits)
									m.mod_force_usage = usr.mod_force_usage
							if(usr.skill_divine_weapon)
								for(var/mob/m in usr.skill_divine_weapon.active_splits)
									m.mod_force_usage = usr.mod_force_usage
		*/

		bars
			var/saved_num = 0
			var/obj/hud/bars/exp_bar
			plane=29
			player_hp_inner
				icon = 'hud_bar_new_inner.dmi'
				screen_loc = "3:2,18:18"
				layer = 7
				mouse_opacity = 0
				icon_state = "hp"
			player_hp
				icon = 'hud_bar_new.dmi'
				screen_loc = "3:1,18:17"
				layer = 6
				icon_state = "bar holder"
				var/obj/txt_percent
				MouseEntered()
					if(src.txt_percent)
						usr.client.screen += src.txt_percent
					//	usr.client.screen += src.txt_percent
				MouseExited()
					if(src.txt_percent)
						usr.client.screen -= src.txt_percent
				New()
					..()
					var/obj/txt = new
					txt.maptext = "<font size = 1> <text align=center valign=top>[css_outline]100%"
					txt.maptext_width = 128
					txt.screen_loc = "4,29:03"
					txt.layer = 25
					txt.loc = src
					src.txt_percent = txt
					src.txt_percent.layer=999
					src.txt_percent.plane = 30
			player_eat
				icon = 'bars_eat.dmi'
				layer = 7
				appearance_flags = KEEP_APART
				pixel_x = -2
				pixel_y = -9
			player_eng_inner
				icon = 'hud_bar_new_inner.dmi'
				screen_loc = "3:2,18:3"
				layer = 7
				mouse_opacity = 0
				icon_state = "mp"
			player_stamina_inner
				icon = 'hud_bar_new_inner.dmi'
				screen_loc = "3:2,17:3"
				layer = 7
				mouse_opacity = 0
				icon_state = "mp"
				color = rgb(50, 205, 50)
			player_stamina
				icon = 'hud_bar_new.dmi'
				screen_loc = "3:1,17:17"
				layer = 6
				icon_state = "bar holder"
				color = rgb(50, 205, 50)
				var/obj/txt_percent
				MouseEntered()
					if(src.txt_percent)
						usr.client.screen += src.txt_percent
				MouseExited()
					if(src.txt_percent)
						usr.client.screen -= src.txt_percent
				New()
					..()
					var/obj/txt = new
					txt.maptext = "<font size = 1> <text align=center valign=top>[css_outline]100%"
					txt.maptext_width = 128
					txt.screen_loc = "4,28:03"
					txt.layer = 25
					txt.loc = src
					src.txt_percent = txt
					src.txt_percent.layer = 999
					src.txt_percent.plane = 30
			cft_button
				icon = 'TBMS.dmi'
				screen_loc = "1:55,15:13"
				layer = 6
				icon_state = ""

				New()
					..()
				MouseEntered(location,control,params)
					src.overlays -= /obj/hud/buttons/main/button_mouseover
					src.overlays += /obj/hud/buttons/main/button_mouseover
					if(usr.info_box1)
						usr.client.screen += usr.info_box1
						usr.client.screen += usr.info_box2
						usr.client.screen += usr.info_box3
						usr.info_box(src,src.name,params)
				MouseExited(location,control,params)
					src.overlays = null
					if(usr.info_box1)
						usr.client.screen -= usr.info_box1
						usr.client.screen -= usr.info_box2
						usr.client.screen -= usr.info_box3
						usr.info_box3.maptext = null
				MouseMove(location,control,params)
					..()
					usr.info_box(src,"Cycle Free Time",params)
				Click()
					if(usr.started == 0) return
					if(usr.cycle_free_time<27 && usr.cft_activated == 0)
						usr<<"You require more character development."
						return
					else if(usr.cycle_free_time>=27 && usr.cft_activated == 0)
						if(src.icon_state == "active") src.icon_state = ""
						switch(alert(usr,"You currently have [usr.cycle_free_time] minutes worth of Cycle Free Time, do you wish to activate this now?\n\nNote: Once activated you must wait until your current cft is finished to acquire more.","","Activate","Cancel"))
							if("Activate")
								usr.cft_activated = 1
								usr<<"<b>You have activated CFT</b>(You will not get resillient from any training during this phase.)"

					else if(usr.cft_activated == 1)
						usr<<"<b>CFT Time: [usr.cycle_free_time]</b>"
					winset(usr,"map.map","focus=true")
			immersionshop
				icon = 'RPBoxes.dmi'
				screen_loc = "2:1,15:13"
				layer = 6
				icon_state = "rp"

				New()
					..()
				MouseEntered(location,control,params)
					src.overlays -= /obj/hud/buttons/main/button_mouseover
					src.overlays += /obj/hud/buttons/main/button_mouseover
					/*if(usr.info_box1)
						var/obj/box = usr.info_box1
						usr.client.screen += usr.info_box1
						usr.client.screen += usr.info_box2
						usr.client.screen += usr.info_box3
						usr.info_box(src,src.name,params)
						box.screen_loc = "1,30"*/
				MouseExited(location,control,params)
					src.overlays = null
					/*if(usr.info_box1)
						usr.client.screen -= usr.info_box1
						usr.client.screen -= usr.info_box2
						usr.client.screen -= usr.info_box3
						usr.info_box3.maptext = null*/
			//	MouseMove(location,control,params)
				//	..()
					//usr.info_box(src,"Passive Tree",params)
				Click()
					if(usr.started == 0) return
					usr.show_immersion_shop()
			dokushop
				icon = 'RPBoxes.dmi'
				screen_loc = "3:1,15:13"
				layer = 6
				icon_state = "doku"

				New()
					..()
				MouseEntered(location,control,params)
					src.overlays -= /obj/hud/buttons/main/button_mouseover
					src.overlays += /obj/hud/buttons/main/button_mouseover
					/*if(usr.info_box1)
						var/obj/box = usr.info_box1
						usr.client.screen += usr.info_box1
						usr.client.screen += usr.info_box2
						usr.client.screen += usr.info_box3
						usr.info_box(src,src.name,params)
						box.screen_loc = "1,30"*/
				MouseExited(location,control,params)
					src.overlays = null
					/*if(usr.info_box1)
						usr.client.screen -= usr.info_box1
						usr.client.screen -= usr.info_box2
						usr.client.screen -= usr.info_box3
						usr.info_box3.maptext = null*/
			//	MouseMove(location,control,params)
				//	..()
					//usr.info_box(src,"Passive Tree",params)
				Click()
					if(usr.started == 0) return
					usr.show_dokuro_shop()
			passivetree
				icon = 'RPBoxes.dmi'
				screen_loc = "1:1,15:13"
				layer = 6
				icon_state = "skill"

				New()
					..()
				MouseEntered(location,control,params)
					src.overlays -= /obj/hud/buttons/main/button_mouseover
					src.overlays += /obj/hud/buttons/main/button_mouseover
					/*if(usr.info_box1)
						var/obj/box = usr.info_box1
						usr.client.screen += usr.info_box1
						usr.client.screen += usr.info_box2
						usr.client.screen += usr.info_box3
						usr.info_box(src,src.name,params)
						box.screen_loc = "1,30"*/
				MouseExited(location,control,params)
					src.overlays = null
					/*if(usr.info_box1)
						usr.client.screen -= usr.info_box1
						usr.client.screen -= usr.info_box2
						usr.client.screen -= usr.info_box3
						usr.info_box3.maptext = null*/
			//	MouseMove(location,control,params)
				//	..()
					//usr.info_box(src,"Passive Tree",params)
				Click()
					if(usr.started == 0) return
					if(usr.open_traits)
						usr.client.screen -= usr.hud_unlocks
						usr.open_traits = 0
						usr.open_menus.Remove(".open_traits")
					else
						usr.client.screen += usr.hud_unlocks
						usr.open_traits = 1
						usr.open_menus.Add(".open_traits")
						if(usr.hud_unlocks) usr.hud_unlocks.switch_tab(1,usr)
					winset(usr,"map.map","focus=true")
			rptree
				icon = 'RPBoxes.dmi'
				screen_loc = "2:1,15:13"
				layer = 6
				icon_state = "rp"

				New()
					..()
			player_eng
				icon = 'hud_bar_new.dmi'
				screen_loc = "3:1,18:2"
				layer = 6
				icon_state = "bar holder"
				var/obj/txt_percent
				MouseEntered()
					if(src.txt_percent)
						usr.client.screen += src.txt_percent
				MouseExited()
					if(src.txt_percent)
						usr.client.screen -= src.txt_percent
				New()
					..()
					var/obj/txt = new
					txt.maptext = "<font size = 1> <text align=center valign=top>[css_outline]100%"
					txt.maptext_width = 128
					txt.screen_loc = "4,28:17"
					txt.layer = 25
					txt.loc = src
					src.txt_percent = txt
					src.txt_percent.layer=999
					src.txt_percent.plane = 30
			hp_slice
				icon = 'bars_health.dmi'
				icon_state = "bar hp"
				pixel_x = 1
				plane = FLOAT_PLANE
				layer = FLOAT_LAYER
				blend_mode = BLEND_INSET_OVERLAY
				appearance_flags = KEEP_TOGETHER | TILE_BOUND
			name_bar
				//icon = 'new_hud_namebar.dmi'
				layer = 101
				mouse_opacity = 0;
				pixel_x = 32;
				pixel_y = -10;
				New()
					..()
					var/image/txt = image('new_hud_namebar.dmi',src,null,102)
					txt.maptext_x = 4
					txt.maptext_y = 2
					txt.maptext_width = 72
					txt.maptext_height = 16
					//txt.filters += filter(type="outline", size=1, color=rgb(0,0,0))
					src.txt_i = txt
			revive_bar
				icon = 'revive_bar.dmi'
				icon_state = "bar"
				screen_loc  = "20:-7,13:-3"
				layer = 11
				mouse_opacity = 0

				//plane = 7
			revive_bar_inner
				icon = 'revive_bar_inner.dmi'
				screen_loc  = "20:-7,13:-3"
				layer = 10
				mouse_opacity = 0
				//plane = 7
			gather_bar_inner
				icon = 'gather_bar_inner.dmi'
				screen_loc  = "20:-7,13:-3"
				layer = 10
				mouse_opacity = 0
			divine_bar_inner
				icon = 'divine_bar_inner.dmi'
				screen_loc  = "20:-7,13:-3"
				layer = 10
				mouse_opacity = 0
				//plane = 7
			breathing_bar
				icon = 'minigame_breathing.dmi'
				screen_loc  = "17:-10,10"
				layer = 10
				mouse_opacity = 0
				appearance_flags = KEEP_APART
			breathing_bar_inner
				icon = 'minigame_breathing_inner.dmi'
				screen_loc  = "17:-8,11:-6"
				layer = 11
				mouse_opacity = 0
				appearance_flags = KEEP_APART
			e_button
				icon = 'e button.dmi'
				icon_state = "normal"
				layer = 11
				screen_loc  = "16:4,11"
				appearance_flags = KEEP_APART

		planes
			plane_liquid
				screen_loc = "1,1"
				plane = 0//-2
				//appearance_flags = PLANE_MASTER | KEEP_TOGETHER | NO_CLIENT_COLOR
				appearance_flags = PLANE_MASTER | KEEP_TOGETHER | PIXEL_SCALE
				mouse_opacity = 0
				layer = 1
				proc
					remove_ripple(var/xx = 0,var/yy = 0)
						spawn(60)
							if(src)
								src.filters -= filter(type="ripple",x=xx,y=yy,size=0,repeat=2,radius=640,falloff=1)

					ripples()
						filters += filter(type="ripple", size = 2, radius = 1, falloff = 1)
						animate(filters[1], time = 15, loop = -1, easing = LINEAR_EASING, radius = 8)
					wavesold()
						src.filters = null
						//src.filters += filter(type="drop_shadow", x=0, y=0, size=4, offset=1, color=rgb(102,0,0))
						//src.filters += filter(type="motion_blur", x=1, y=0)
						var/start = filters.len
						var/X,Y,rsq,i,f
						for(i=1, i<=WAVE_COUNT, ++i)
							// choose a wave with a random direction and a period between 10 and 30 pixels
							do
								X = 60*rand() - 30
								Y = 60*rand() - 30
								rsq = X*X + Y*Y
							while(rsq<100 || rsq>900)
							// keep distortion small, from 0.5 to 3 pixels
							// choose a random phase
							filters += filter(type="wave", x=X, y=Y, size=rand()*2.5+0.5, offset=rand(), flags = WAVE_BOUNDED)
						for(i=1, i<=WAVE_COUNT, ++i)
							// animate phase of each wave from its original phase to phase-1 and then reset;
							// this moves the wave forward in the X,Y direction
							f = filters[start+i]
							animate(f, offset=f:offset, time=0, loop=-1, flags=ANIMATION_PARALLEL)
							animate(offset=f:offset-1, time=rand()*20+20)
				New()
					src.wavesold()

			plane_energy
				screen_loc = "1,1"
				plane = 1
				appearance_flags = PLANE_MASTER | KEEP_TOGETHER | TILE_BOUND// | NO_CLIENT_COLOR
				mouse_opacity = 0
				proc
					apply_filters()
						src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(102,0,204))
						src.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
				New()
					//src.waves()
					src.filters = null
					src.apply_filters()
					//animate(src.filters[src.filters.len], offset = 4, time = 5, loop = -1,flags=ANIMATION_PARALLEL)
					//animate(offset = 1, time = 5)
			plane_divine
				screen_loc = "1,1"
				plane = 2
				appearance_flags = PLANE_MASTER | KEEP_TOGETHER// | NO_CLIENT_COLOR
				mouse_opacity = 0
				proc
					apply_filters()
						src.filters = null
						src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(255,255,170))
						src.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
				New()
					src.apply_filters()
			plane_wings
				screen_loc = "1,1"
				plane = 4
				appearance_flags = PLANE_MASTER | KEEP_TOGETHER/// | NO_CLIENT_COLOR
				mouse_opacity = 0
				New()
					src.filters = null
					src.waves()
					src.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
			plane_hud
				screen_loc = "1,1"
				plane = 10
				appearance_flags = PLANE_MASTER | KEEP_TOGETHER | PIXEL_SCALE
		hellbackground
			icon = 'backgroundhell.dmi'
			screen_loc = "1,1"
			plane = -2
			//blend_mode = BLEND_OVERLAY
			//layer = 1.9
			appearance_flags = TILE_BOUND
			mouse_opacity = 0
			//pixel_x = -596
			//pixel_y = -300
			New()
				var/start = filters.len
				var/i,f
				for(i=1, i<=WAVE_COUNT, ++i)
					filters += filter(type="wave", x=20, y=20, size=1, offset=1)
				for(i=1, i<=WAVE_COUNT, ++i)
					// animate phase of each wave from its original phase to phase-1 and then reset;
					// this moves the wave forward in the X,Y direction
					f = filters[start+i]
					animate(f, offset=f:offset, time=0, loop=-1, flags=ANIMATION_PARALLEL)
					animate(offset=f:offset-1, time=33)
		darkrealmbackground
			icon = 'backgrounddemonrealm.dmi'
			screen_loc = "1,1"
			plane = -2
			//blend_mode = BLEND_OVERLAY
			//layer = 1.9
			appearance_flags = TILE_BOUND
			mouse_opacity = 0
			//pixel_x = -596
			//pixel_y = -300
			New()
				var/start = filters.len
				var/i,f
				for(i=1, i<=WAVE_COUNT, ++i)
					filters += filter(type="wave", x=20, y=20, size=1, offset=1)
				for(i=1, i<=WAVE_COUNT, ++i)
					// animate phase of each wave from its original phase to phase-1 and then reset;
					// this moves the wave forward in the X,Y direction
					f = filters[start+i]
					animate(f, offset=f:offset, time=0, loop=-1, flags=ANIMATION_PARALLEL)
					animate(offset=f:offset-1, time=33)
		afterlifebackground
			icon = 'backgroundafterlife.dmi'
			screen_loc = "1,1"
			plane = -2
			//blend_mode = BLEND_OVERLAY
			//layer = 1.9
			appearance_flags = TILE_BOUND
			mouse_opacity = 0
			//pixel_x = -596
			//pixel_y = -300
			New()
				var/start = filters.len
				var/i,f
				for(i=1, i<=WAVE_COUNT, ++i)
					filters += filter(type="wave", x=20, y=20, size=1, offset=1)
				for(i=1, i<=WAVE_COUNT, ++i)
					// animate phase of each wave from its original phase to phase-1 and then reset;
					// this moves the wave forward in the X,Y direction
					f = filters[start+i]
					animate(f, offset=f:offset, time=0, loop=-1, flags=ANIMATION_PARALLEL)
					animate(offset=f:offset-1, time=33)
		login2background
			icon = 'backgroundnight.dmi'
			screen_loc = "1,1"
			plane = -2
			//blend_mode = BLEND_OVERLAY
			//layer = 1.9
			appearance_flags = TILE_BOUND
			mouse_opacity = 0
			//pixel_x = -596
			//pixel_y = -300
			New()
				var/start = filters.len
				var/i,f
				for(i=1, i<=WAVE_COUNT, ++i)
					filters += filter(type="wave", x=20, y=20, size=1, offset=1)
				for(i=1, i<=WAVE_COUNT, ++i)
					// animate phase of each wave from its original phase to phase-1 and then reset;
					// this moves the wave forward in the X,Y direction
					f = filters[start+i]
					animate(f, offset=f:offset, time=0, loop=-1, flags=ANIMATION_PARALLEL)
					animate(offset=f:offset-1, time=33)
		korintowerbackground
			icon = 'backgroundsky1.dmi'
			screen_loc = "1,1"
			plane = -2
			//blend_mode = BLEND_OVERLAY
			//layer = 1.9
			appearance_flags = TILE_BOUND
			mouse_opacity = 0
			//pixel_x = -596
			//pixel_y = -300
			New()
				var/start = filters.len
				var/i,f
				for(i=1, i<=WAVE_COUNT, ++i)
					filters += filter(type="wave", x=20, y=20, size=1, offset=1)
				for(i=1, i<=WAVE_COUNT, ++i)
					// animate phase of each wave from its original phase to phase-1 and then reset;
					// this moves the wave forward in the X,Y direction
					f = filters[start+i]
					animate(f, offset=f:offset, time=0, loop=-1, flags=ANIMATION_PARALLEL)
					animate(offset=f:offset-1, time=33)
		hbtcbackground
			icon = 'backgroundsky3.dmi'
			screen_loc = "1,1"
			plane = -2
			//blend_mode = BLEND_OVERLAY
			//layer = 1.9
			appearance_flags = TILE_BOUND
			mouse_opacity = 0
			//pixel_x = -596
			//pixel_y = -300
			New()
				var/start = filters.len
				var/i,f
				for(i=1, i<=WAVE_COUNT, ++i)
					filters += filter(type="wave", x=20, y=20, size=1, offset=1)
				for(i=1, i<=WAVE_COUNT, ++i)
					// animate phase of each wave from its original phase to phase-1 and then reset;
					// this moves the wave forward in the X,Y direction
					f = filters[start+i]
					animate(f, offset=f:offset, time=0, loop=-1, flags=ANIMATION_PARALLEL)
					animate(offset=f:offset-1, time=33)
		gravityoverlay
			icon = 'redbg.dmi'
			screen_loc = "1,1"
			plane = 34
			layer=5
			blend_mode = BLEND_OVERLAY
			//layer = 1.9
			appearance_flags = TILE_BOUND
			mouse_opacity = 0
			//pixel_x = -596
			//pixel_y = -300
			alpha = 10
			New()
				var/start = filters.len
				var/i,f
				for(i=1, i<=WAVE_COUNT, ++i)
					filters += filter(type="wave", x=20, y=20, size=1, offset=1)
				for(i=1, i<=WAVE_COUNT, ++i)
					// animate phase of each wave from its original phase to phase-1 and then reset;
					// this moves the wave forward in the X,Y direction
					f = filters[start+i]
					animate(f, offset=f:offset, time=0, loop=-1, flags=ANIMATION_PARALLEL)
					animate(offset=f:offset-1, time=33)

		loginbackground
			icon = 'backgroundday.dmi'
			screen_loc = "1,1"
			plane = -2
			//blend_mode = BLEND_OVERLAY
			//layer = 1.9
			appearance_flags = TILE_BOUND
			mouse_opacity = 0
			//pixel_x = -596
			//pixel_y = -300
			New()
				var/start = filters.len
				var/i,f
				for(i=1, i<=WAVE_COUNT, ++i)
					filters += filter(type="wave", x=20, y=20, size=1, offset=1)
				for(i=1, i<=WAVE_COUNT, ++i)
					// animate phase of each wave from its original phase to phase-1 and then reset;
					// this moves the wave forward in the X,Y direction
					f = filters[start+i]
					animate(f, offset=f:offset, time=0, loop=-1, flags=ANIMATION_PARALLEL)
					animate(offset=f:offset-1, time=33)
		background
			icon = 'background_small.dmi'
			screen_loc = "1,1"
			plane = -2
			//blend_mode = BLEND_OVERLAY
			//layer = 1.9
			appearance_flags = TILE_BOUND
			mouse_opacity = 0
			//pixel_x = -596
			//pixel_y = -300
			New()
				var/start = filters.len
				var/i,f
				for(i=1, i<=WAVE_COUNT, ++i)
					filters += filter(type="wave", x=20, y=20, size=1, offset=1)
				for(i=1, i<=WAVE_COUNT, ++i)
					// animate phase of each wave from its original phase to phase-1 and then reset;
					// this moves the wave forward in the X,Y direction
					f = filters[start+i]
					animate(f, offset=f:offset, time=0, loop=-1, flags=ANIMATION_PARALLEL)
					animate(offset=f:offset-1, time=33)
		map
			menus
				map_holder
					icon = 'HUD_menu_map_holder.dmi'
					screen_loc = "13:1,7:1"
					//appearance_flags = KEEP_TOGETHER
					plane = 8
				map_holder_wrap
					icon = 'HUD_menu_map.dmi'
					screen_loc = "12,6"
					//appearance_flags = KEEP_TOGETHER
					plane = 8
				map_loc
					maptext_width = 128
					maptext_height = 32
					plane = 8
					screen_loc = "25:8,17:6"
					New()
						src.maptext = "<u>[css_outline]Locations"
				map_cords
					maptext_width = 264
					maptext_height = 32
					plane = 8
					screen_loc = "10:-13,18:-4"
			map_overlay
				icon = 'map_large.dmi'
				icon_state = "none"
				plane = 8
				layer = 10
				screen_loc = "CENTER-7,CENTER-7:-9"
			map_box_large
				icon = 'map_location_box_large.dmi'
				screen_loc = "25:7,14"
				plane = 8
			map_locations
				icon = 'map_location_box.dmi'
				icon_state = "0"
				plane = 8
				MouseEntered(location,control,params)
					if(src.icon_state == "down") src.icon_state = "down over"
					else if(src.icon_state == "0") src.icon_state = "1"
				MouseExited(location,control,params)
					if(src.icon_state == "down over") src.icon_state = "down"
					else if(src.icon_state == "1") src.icon_state = "0"
				darkrealm_location

					//filters = filter(type="outline", size=1, color=rgb(0,0,0))
					maptext_width = 128
					maptext_height = 64
					maptext_x = 32
					screen_loc = "25:9,16:18"
					layer = 101
					map_z = 12
					maptext = "<font size = 2><text align=middle valign=bottom>Dark Realm"
					Click()
						if(maps_created)
							var/obj/m = usr.hud_map[2]
							m.maptext = "[css_outline]Dark Realm: X - 0, Y - 0"
							if(usr.skill_sense && usr.skill_sense.active) usr.map_blip("both")
							if(usr.z != 1) usr.client.images -= usr.map_blip
							else usr.client.images += usr.map_blip
							/*
							for(var/mob/p in players)
								if(p.map_blip)
									if(p.loc && p.z == 1)
										if(p == usr || usr.skill_ && usr.skill_.active && p.z == usr.z) usr.client.images += p.map_blip
									else usr.client.images -= p.map_blip
							*/
							sleep(0.1)
							for(var/obj/hud/map/map_large/x in maps)
								usr.client.screen -= x
								if(x.build_overlay) usr.client.screen -= x.build_overlay
							sleep(0.1)
							usr.client.screen += maps[12]
							sleep(0.1)
							if(usr.z == 12)
								var/obj/hud/map/map_large/x = maps[12]
								if(x.build_overlay) usr.client.screen += x.build_overlay

				icer_location
					//filters = filter(type="outline", size=1, color=rgb(0,0,0))
					maptext_width = 128
					maptext_height = 64
					maptext_x = 32
					screen_loc = "25:9,16:18"
					layer = 101
					map_z = 9
					maptext = "<font size = 2><text align=middle valign=bottom>Icer"
					Click()
						if(maps_created)
							var/obj/m = usr.hud_map[2]
							m.maptext = "[css_outline]Icer: X - 0, Y - 0"
							if(usr.skill_sense && usr.skill_sense.active) usr.map_blip("both")
							if(usr.z != 9) usr.client.images -= usr.map_blip
							else usr.client.images += usr.map_blip
							/*
							for(var/mob/p in players)
								if(p.map_blip)
									if(p.loc && p.z == 1)
										if(p == usr || usr.skill_ && usr.skill_.active && p.z == usr.z) usr.client.images += p.map_blip
									else usr.client.images -= p.map_blip
							*/
							sleep(0.1)
							for(var/obj/hud/map/map_large/x in maps)
								usr.client.screen -= x
								if(x.build_overlay) usr.client.screen -= x.build_overlay
							sleep(0.1)
							usr.client.screen += maps[7]
							sleep(0.1)
							if(usr.z == 9)
								var/obj/hud/map/map_large/x = maps[7]
								if(x.build_overlay) usr.client.screen += x.build_overlay
				vegeta_location
					//filters = filter(type="outline", size=1, color=rgb(0,0,0))
					maptext_width = 105
					maptext_height = 64
					maptext_x = 32
					screen_loc = "25:9,16:18"
					layer = 101
					map_z = 10
					maptext = "<font size = 2><text align=middle valign=bottom>Vegeta"
					Click()
						if(maps_created)
							var/obj/m = usr.hud_map[2]
							m.maptext = "[css_outline]Vegeta: X - 0, Y - 0"
							if(usr.skill_sense && usr.skill_sense.active) usr.map_blip("both")
							if(usr.z != 10) usr.client.images -= usr.map_blip
							else usr.client.images += usr.map_blip
							/*
							for(var/mob/p in players)
								if(p.map_blip)
									if(p.loc && p.z == 1)
										if(p == usr || usr.skill_ && usr.skill_.active && p.z == usr.z) usr.client.images += p.map_blip
									else usr.client.images -= p.map_blip
							*/
							sleep(0.1)
							for(var/obj/hud/map/map_large/x in maps)
								usr.client.screen -= x
								if(x.build_overlay) usr.client.screen -= x.build_overlay
							sleep(0.1)
							usr.client.screen += maps[8]
							sleep(0.1)
							if(usr.z == 10)
								var/obj/hud/map/map_large/x = maps[8]
								if(x.build_overlay) usr.client.screen += x.build_overlay
				earth_location
					//filters = filter(type="outline", size=1, color=rgb(0,0,0))
					maptext_width = 128
					maptext_height = 64
					maptext_x = 32
					screen_loc = "25:9,16:18"
					layer = 101
					map_z = 1
					maptext = "<font size = 2><text align=middle valign=bottom>Earth"
					Click()
						if(maps_created)
							var/obj/m = usr.hud_map[2]
							m.maptext = "[css_outline]Earth: X - 0, Y - 0"
							if(usr.skill_sense && usr.skill_sense.active) usr.map_blip("both")
							if(usr.z != 1) usr.client.images -= usr.map_blip
							else usr.client.images += usr.map_blip
							/*
							for(var/mob/p in players)
								if(p.map_blip)
									if(p.loc && p.z == 1)
										if(p == usr || usr.skill_ && usr.skill_.active && p.z == usr.z) usr.client.images += p.map_blip
									else usr.client.images -= p.map_blip
							*/
							sleep(0.1)
							for(var/obj/hud/map/map_large/x in maps)
								usr.client.screen -= x
								if(x.build_overlay) usr.client.screen -= x.build_overlay
							sleep(0.1)
							usr.client.screen += maps[1]
							sleep(0.1)
							if(usr.z == 1)
								var/obj/hud/map/map_large/x = maps[1]
								if(x.build_overlay) usr.client.screen += x.build_overlay
				earth_underground_location
					icon = 'map_location_earth.dmi'
					icon_state = "down"
					//filters = filter(type="outline", size=1, color=rgb(0,0,0))
					maptext_width = 128
					maptext_height = 64
					maptext_x = 32
					screen_loc = "28:12,16:18"
					layer = 101
					map_z = 1
					//maptext = "<font size = 2><text align=middle valign=bottom>Underground"
					Click()
						if(maps_created)
							var/obj/m = usr.hud_map[2]
							m.maptext = "[css_outline]Earth Underground: X - 0, Y - 0"
							if(usr.skill_sense && usr.skill_sense.active) usr.map_blip("both")
							if(usr.z != 3) usr.client.images -= usr.map_blip
							else usr.client.images += usr.map_blip
							sleep(0.1)
							for(var/obj/hud/map/map_large/x in maps)
								usr.client.screen -= x
								if(x.build_overlay) usr.client.screen -= x.build_overlay
							sleep(0.1)
							usr.client.screen += maps[2]
							sleep(0.1)
							if(usr.z == 3)
								var/obj/hud/map/map_large/x = maps[2]
								if(x.build_overlay) usr.client.screen += x.build_overlay
				psi_location
					//filters = filter(type="outline", size=1, color=rgb(0,0,0))
					maptext_width = 128
					maptext_height = 64
					maptext_x = 4
					screen_loc = "25:9,16:18"
					layer = 101
					maptext = "<font size = 2><text align=middle valign=bottom>Other Realm"
					map_z = 2
					Click()
						if(maps_created)
							var/obj/m = usr.hud_map[2]
							m.maptext = "[css_outline]Other Realm: X - 0, Y - 0"
							if(usr.skill_sense && usr.skill_sense.active) usr.map_blip("both")
							if(usr.z != 2) usr.client.images -= usr.map_blip
							else usr.client.images += usr.map_blip
							sleep(0.1)
							for(var/obj/hud/map/map_large/x in maps)
								usr.client.screen -= x
								if(x.build_overlay) usr.client.screen -= x.build_overlay
							sleep(0.1)
							usr.client.screen += maps[2]
							sleep(0.1)
							if(usr.z == 2)
								var/obj/hud/map/map_large/x = maps[2]
								if(x.build_overlay) usr.client.screen += x.build_overlay
				psi_underground_location
					icon = 'map_location_psi.dmi'
					icon_state = "down"
					//filters = filter(type="outline", size=1, color=rgb(0,0,0))
					maptext_width = 128
					maptext_height = 64
					maptext_x = 32
					screen_loc = "28:12,16:18"
					layer = 101
					map_z = 6
					//maptext = "<font size = 2><text align=middle valign=bottom>Underground"
					Click()
						if(maps_created)
							var/obj/m = usr.hud_map[2]
							m.maptext = "[css_outline]Other Realm Underground: X - 0, Y - 0"
							if(usr.skill_sense && usr.skill_sense.active) usr.map_blip("both")
							if(usr.z != 6) usr.client.images -= usr.map_blip
							else usr.client.images += usr.map_blip
							sleep(0.1)
							for(var/obj/hud/map/map_large/x in maps)
								usr.client.screen -= x
								if(x.build_overlay) usr.client.screen -= x.build_overlay
							sleep(0.1)
							usr.client.screen += maps[6]
							sleep(0.1)
							if(usr.z == 6)
								var/obj/hud/map/map_large/x = maps[6]
								if(x.build_overlay) usr.client.screen += x.build_overlay
				yuk_location
					//filters = filter(type="outline", size=1, color=rgb(0,0,0))
					maptext_width = 128
					maptext_height = 64
					maptext_x = 24
					screen_loc = "25:9,15:10"
					layer = 101
					maptext = "<font size = 2><text align=middle valign=bottom>Namek"
					map_z = 4
					Click()
						if(maps_created)
							var/obj/m = usr.hud_map[2]
							m.maptext = "[css_outline]Namek: X - 0, Y - 0"
							if(usr.skill_sense && usr.skill_sense.active) usr.map_blip("both")
							if(usr.z != 4) usr.client.images -= usr.map_blip
							else usr.client.images += usr.map_blip
							sleep(0.1)
							for(var/obj/hud/map/map_large/x in maps)
								usr.client.screen -= x
								if(x.build_overlay) usr.client.screen -= x.build_overlay
							sleep(0.1)
							usr.client.screen += maps[4]
							sleep(0.1)
							if(usr.z == 4)
								var/obj/hud/map/map_large/x = maps[4]
								if(x.build_overlay) usr.client.screen += x.build_overlay
				yuk_location_underground
					icon = 'map_location_yukopia.dmi'
					icon_state = "down"
					//filters = filter(type="outline", size=1, color=rgb(0,0,0))
					maptext_width = 128
					maptext_height = 64
					maptext_x = 32
					screen_loc = "28:12,15:10"
					layer = 101
					map_z = 7
					//maptext = "<font size = 2><text align=middle valign=bottom>Underground"
					Click()
						if(maps_created)
							var/obj/m = usr.hud_map[2]
							m.maptext = "[css_outline]Namek Underground: X - 0, Y - 0"
							if(usr.skill_sense && usr.skill_sense.active) usr.map_blip("both")
							if(usr.z != 7) usr.client.images -= usr.map_blip
							else usr.client.images += usr.map_blip
							sleep(0.1)
							for(var/obj/hud/map/map_large/x in maps)
								usr.client.screen -= x
								if(x.build_overlay) usr.client.screen -= x.build_overlay
							sleep(0.1)
							usr.client.screen += maps[5]
							sleep(0.1)
							if(usr.z == 7)
								var/obj/hud/map/map_large/x = maps[5]
								if(x.build_overlay) usr.client.screen += x.build_overlay
			map_large
				icon = 'map_large_blank.dmi'
				//layer = 100
				plane = 8
				screen_loc = "CENTER-7,CENTER-7:-9"
				//plane = FLOAT_PLANE
				//layer = FLOAT_LAYER
				//blend_mode = BLEND_INSET_OVERLAY
				//appearance_flags = KEEP_TOGETHER | TILE_BOUND
				//filters = filter(type="outline", size=3, color=rgb(255,255,255))
				var/z_level = 1
				var/list/map_blips = list()
				var/obj/build_overlay
				var/in_use = 0
				var/delay = 0
				var/zoom = 1
				/*
				MouseWheel()
					src.zoom += 0.1
					var/matrix/m = matrix()
					src.appearance_flags = PIXEL_SCALE
					m.Scale(src.zoom,src.zoom)
					src.transform = m
				*/
				MouseMove(location,control,params)
					params = params2list(params)
					if(params["icon-x"]) if(params["icon-y"])
						var/X = text2num(params["icon-x"])
						var/Y = text2num(params["icon-y"])
						//usr.map_cords.maptext = "<font size = 2><text align=middle valign=bottom>X - [X], Y - [Y]"
						if(usr.hud_map[2])
							var/obj/o = usr.hud_map[2]
							o.maptext = "[css_outline][src.name]: X - [X], Y - [Y]"
				Click(location,control,params)
					params = params2list(params)
					var/X = text2num(params["icon-x"])
					var/Y = text2num(params["icon-y"])
					if(params["right"])
						if(usr.skill_remote_viewing && usr.skill_remote_viewing.active)
							call(usr.skill_remote_viewing.act)(usr,usr.skill_remote_viewing)
							usr.map_proc(1)
						for(var/obj/skills/Astral_Projection/ap in usr)
							if(ap.active)
								call(ap.act)(usr,ap)
								usr.map_proc(1)
						for(var/obj/skills/Teleportation/t in usr)
							if(t.active)
								call(t.act)(usr,t)
								usr.map_proc(1)
						return
					if(params["left"])
						if(params["icon-x"]) if(params["icon-y"])
							for(var/obj/skills/Astral_Projection/ap in usr)
								if(ap.active)
									if(usr.projection == null)
										for(var/obj/skills/Meditate/med in usr)
											if(med.active == 0) call(med.act)(usr,med)
										var/mob/p = new
										p.icon = usr.icon
										p.icon += rgb(155,155,155)
										p.loc = locate(X,Y,src.z_level)
										p.icon_state = ""
										p.name = "[usr.name] projection"
										p.name_txt()
										p.filters = null
										p.vis_contents = null
										p.particles = null
										p.race = usr.race
										p.wings_hidden = usr.wings_hidden
										p.halo_hidden = usr.halo_hidden
										if(usr.halo && usr.halo_hidden == 0) p.overlays += usr.halo
										p.filters += filter(type="outline",size=1, color=rgb(100,136,255))
										p.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(204,236,255))
										p.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
										p.afk = 1
										p.started = 1
										p.ref = usr
										if(p.z == 2)
											usr.apply_hell_glow(0)
											usr.apply_afterlife_glow(1)
										else if(p.z == 6)
											usr.apply_afterlife_glow(0)
											usr.apply_hell_glow(1)
										else if(p.z == 12)
											usr.apply_afterlife_glow(0)
											usr.apply_hell_glow(0)
											usr.apply_demonrealm_glow(1)
										else if(p.z == 16)
											usr.apply_hell_glow(0)
											usr.apply_afterlife_glow(0)
											usr.apply_space_glow(1)
										else
											usr.apply_hell_glow(0)
											usr.apply_afterlife_glow(0)
											usr.apply_space_glow(0)
											usr.apply_demonrealm_glow(0)
										//if(p.z == 4) usr.show_worldtree(1,1)
										if(p.z != usr.z)
											usr.screen_text.maptext = "<font size = 6><center>[src.name]"
											animate(usr.screen_text,alpha = 255,time = 60)
											animate(alpha = 0,time = 60)
										if(usr.eyes)
											p.eyes = usr.eyes
											p.vis_contents += p.eyes
										if(usr.eyes_white)
											p.eyes_white = usr.eyes_white
											p.vis_contents += p.eyes_white
										p.immune_dmg = 1
										var/obj/effects/weapon_energy/we = new
										p.vis_contents += we
										usr.projection = p
										usr.client.perspective = EYE_PERSPECTIVE | EDGE_PERSPECTIVE
										usr.client.eye = p
										p.Move(p.loc)
										usr.map_proc(1)
										return
						//Follower go
						if(usr.left_click_function == "clone go")
							if(usr.left_click_ref)
								if(params["icon-x"] && params["icon-y"])
									var/mob/NPC/m = usr.left_click_ref
									if(m.loc && src.z_level == m.z)
										usr << output("Selected [src] as target for [usr.left_click_ref] to travel to.","chat.world")
										usr << output("Selected [src] as target for [usr.left_click_ref] to travel to.","chat.local")
										m.idle_ticks = 0
										m.function = "go"
										m.target_go = locate(X,Y,src.z_level)
										usr.left_click_function = null
										usr.left_click_ref = null
										usr.client.mouse_pointer_icon = 'mouse.dmi'
										winshow(usr,"contacts",1)
										usr.open_contacts = 1
										usr.open_menus.Add(".open_contacts")
										if(m.activated == 0)
											m.activated = 1
											m.follower_ai()
										return
						if(usr.skill_remote_viewing && usr.skill_remote_viewing.active)
							if(params["icon-x"] && params["icon-y"])
								usr.client.perspective = EYE_PERSPECTIVE | EDGE_PERSPECTIVE
								usr.client.eye = locate(X,Y,src.z_level)
								usr.map_proc(1)
								return
						for(var/obj/skills/Teleportation/t in usr)
							if(t.active && usr.stunned == 0)
								if(usr.energy >= usr.energy_max)
									if(params["icon-x"] && params["icon-y"])
										if(t.cd_state < 32)
											usr << output("<font color = teal>Skill is on cooldown, please wait.","chat.system")
											//var/is = t.icon_state
											t.icon_state = "cd"
											spawn(3)
												if(t) t.icon_state = "Teleportation off"
											return
										for(var/obj/skills/Astral_Projection/ap in usr)
											if(ap.active) call(ap.act)(usr,ap)
										usr.map_proc(1)

									//	if(usr.z == 2 && usr.dead && src.z_level != 2)
										//	usr << output("<font color = teal>Unable to leave the Psionic Realm via Teleportation while dead.","chat.system")
										//	usr.set_alert("Can't leave Psionic Realm while dead",t.icon,t.icon_state)
										//	usr.create_chat_entry("alerts","Can't leave the Afterlife while dead.")
										//	return

										var/map_z = usr.z
										if(usr.z != src.z_level)
											if(usr.move_lvl < 10)
												usr << output("You are not advanced enough to teleport between realms.","actionoutput")
												usr.set_alert("You are not advanced enough to teleport between realms.",t.icon,t.icon_state)
												return
											else usr.divine_energy -= 10
										switch(alert(usr,"This will sacrifice some years of your lifespan, are you sure you wish to teleport?","","Yes","No"))
											if("Yes")

												usr.submerge(0,1,usr.loc)
												usr.stunned += 1
												usr.stunned_pending += 1
												usr.skill_cooldown(t)
												var/obj/effects/black_hole/b = new
												var/obj/effects/black_hole/b2 = new
												//var/X_Square = X-usr.x ; var/Y_Square = Y-usr.y
												//var/DIST = (X_Square*X_Square)+(Y_Square*Y_Square)
												//var/ROOT = round(sqrt(DIST))
												sleep(1)
												if(usr)
													for(var/obj/skills/Meditate/m in usr)
														if(m.active == 0)
															call(m.act)(usr,m)
												sleep(1)
												if(usr)
													if(usr.loc)
														var/turf/x = usr.loc
														if(x.liquid == null)
															var/obj/effects/craters/crater_small/c = new
															c.SetCenter(usr)
															var/obj/effects/dust_medium/d = new
															d.SetCenter(usr)
													animate(usr,pixel_z = 16,10)
													usr.filters += filter(type="drop_shadow", x=0, y=0,size=5, offset=2, color=rgb(0,0,0,125))
													b.SetCenter(usr)
													b.step_y += 25
													b.transform*=0.1
													b2.loc = locate(X,Y,src.z_level)
													b2.transform*=0.1
													animate(b,transform = matrix()*2, time = 20)
												sleep(10)
												if(usr)
													usr.shockwave(16)
													usr.energy = 1
												sleep(1)
												if(usr) animate(usr.filters[usr.filters.len], offset = 33, time = 10)
												sleep(10)
												if(usr) animate(usr,transform = matrix()*0.1, alpha = 0, time = 10)
												sleep(10)
												if(usr)
													if(usr.shadow) usr.shadow.loc = null
													animate(b,transform = matrix()*0.1, time = 20)
												sleep(20)
												if(usr)
													usr.map_blip("remove all")
													usr.loc = locate(X,Y,src.z_level)
													usr.loc.Enter(usr)
													if(usr.z == 2)
														usr.apply_hell_glow(0)
														usr.apply_demonrealm_glow(0)
														usr.apply_afterlife_glow(1)
													else if(usr.z == 6)
														usr.apply_hell_glow(1)
														usr.apply_afterlife_glow(0)
														usr.apply_demonrealm_glow(0)
													else if(usr.z == 12)
														usr.apply_hell_glow(0)
														usr.apply_afterlife_glow(0)
														usr.apply_demonrealm_glow(1)
													else if(usr.z == 16)
														usr.apply_hell_glow(0)
														usr.apply_afterlife_glow(0)
														usr.apply_demonrealm_glow(0)
														usr.apply_space_glow(1)
													else if(usr.z != 6 && usr.z !=2 && usr.z != 12)
														usr.apply_hell_glow(0)
														usr.apply_afterlife_glow(0)
														usr.apply_demonrealm_glow(0)
														usr.apply_space_glow(0)

													//if(usr.z == 4) usr.show_worldtree(1)
													if(usr.z != map_z)
														usr.screen_text.maptext = "<font size = 6><center>[src.name]"
														animate(usr.screen_text,alpha = 255,time = 60)
														animate(alpha = 0,time = 60)
													if(usr.map_blip)
														usr.map_blip.pixel_x = usr.x-3
														usr.map_blip.pixel_y = usr.y-3
													b2.SetCenter(usr)
													b2.step_y += 25
													animate(b2,transform = matrix()*2, time = 20)
													if(usr.loc)
														var/turf/x2 = usr.loc
														if(x2.liquid == null)
															var/obj/effects/dust_medium/d2 = new
															d2.SetCenter(usr)
															var/obj/effects/craters/crater_small/c2 = new
															c2.SetCenter(usr)
													usr.shockwave(16)
												sleep(20)
												if(usr)
													animate(usr,transform = matrix()*1, alpha = 255, time = 10)
													animate(usr.filters[usr.filters.len], offset = 2, time = 10)
													usr.set_shadow()
												sleep(10)
												if(usr)
													animate(usr,pixel_z = initial(usr.pixel_z),10)
													animate(b2,transform = matrix()*0.1, time = 20)
												sleep(10)
												if(usr) usr.filters -= filter(type="drop_shadow", x=0, y=0,size=5, offset=2, color=rgb(0,0,0,125))
												sleep(10)
												if(b && b2)
													b.loc = null
													b2.loc = null
												//del(b)
												//del(b2)
												if(usr)
													usr.stunned -= 1
													usr.stunned_pending -= 1
													call(t.act)(usr,t)
												var/x = rand(3,9)
												usr.lifespan -= x
												usr<<output("You sacrificed [x] years of your lifespan teleporting!","actionoutput")
												return
								else
									usr.set_alert("Need max energy",t.icon,t.icon_state)
						//Cause follower to travel to that map location
						if(usr.target_follower)
							if(params["icon-x"] && params["icon-y"])
								var/turf/t = locate(X,Y,src.z_level)
								usr.follower_go_dblclick(t)
								return
						//Clicking player map blips
						for(var/mob/m in players)
							if(X > m.x-3 && X < m.x+3)
								if(Y > m.y-3 && Y < m.y+3)
									if(m == usr || usr.skill_sense && usr.skill_sense.active)
										if(m == usr.target)
											usr.add_remove_target(m,1)
										else
											usr.add_remove_target(m,0)
									//world << "DEBUG - clicked on [m]"
									return
		menus
			/*
			Notes
			- var/result = -146 + ((usr.mouse_y_true-s.body_background_y)-54)
			- The -146 part seems to be how far up on the y axis the top of the bar is, then minus 68
			*/
			expanding_box
				icon = 'new_hud_tiny_box.dmi'
				plane = 11
				layer = 40
				appearance_flags = PIXEL_SCALE
				screen_loc = "10,10"
				Click(location,control,params)
					params = params2list(params)
				//	var/xx = params["vis-x"]
					//var/yy = params["vis-y"]
				//	world << "DEBUG - Click at [xx],[yy]"
			menu_text
				maptext_width = 200;
				maptext_height = 200;
				maptext_y = 150;
				maptext_x = 16;
				layer = 102
			settings_background
				/*
				.:Tabs:.
				Game
					- Text color local
					- Text color world
					- Show tutorials on/off
					- Show damage numbers on/off
					- Profanity filter on/off
					- Show fps/cpu
					Alerts
						- Toggle alerts
						- Add different alerts here
				Audio
					- Master volume
					- Music volume
					- Sound volume
				Video
					- Windowed
					- Hide Particles
				Control
				Server
					- Server name
					- Host name
					- Server up-time
					- Show latency
					Moderator/Server options/controls
						- Options to add/remove mods
						- Mod list
						Powers
							- Server power options
							- Moderator powers
				*/
			options_background
				icon = 'new_hud_options.dmi'
				icon_state = "menu"
				screen_loc = "1,1"
				maptext_width = 144
				maptext_height = 16
				maptext_y = 231
				plane = 36
				layer = 33
				var/hh = 0
				var/ww = 0
				/*
				Would be good to have logos and stuff for different links at the bottom
				     - Facebook
				     - Reddit
				     - Twitter (Or whatever it gets named to?)
				     - Website
				     - Wiki Page
				     - Byond Page
				     - Steam Page
				*/
				MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
					params = params2list(params)
					var/icon_y = text2num(params["icon-y"])
					if(icon_y >= 246 || usr.mouse_down)
						usr.client.MousePosition(params)
						var/matrix/m = matrix()
						var/icon_x = text2num(params["icon-x"])
						if(usr.drag_icon_x == 0) usr.drag_icon_x = icon_x
						var/x_result = usr.client.client_mouse_x-usr.drag_icon_x
						var/y_result = usr.client.client_mouse_y-src.hh
						x_result = clamp(x_result,0,1023-src.ww)
						y_result = clamp(y_result,0,575-(src.hh/2))
						m.Translate(x_result,y_result)
						src.transform = m
						usr.mouse_down = src
				proc
					menu_create()
						var/matrix/m_main = matrix()
						m_main.Translate(456,192)
						src.transform = m_main

						var/icon/I = new(src.icon)
						src.ww = I.Width()
						src.hh = I.Height()

						src.maptext = "[css_outline]<font size = 1><center>Options"

						var/obj/hud/menus/options_background/option_version/ver = new
						ver.maptext = "[css_outline]<font size = 1><center>Version - [game_version]"
						var/matrix/m0 = matrix()
						m0.Translate(ver.hud_x,ver.hud_y)
						ver.transform = m0
						src.vis_contents += ver

						var/obj/hud/menus/options_background/option_server_options/op1 = new
						op1.maptext = "[css_outline]<font size = 1><center>Admin Help Channel"
						var/matrix/m1 = matrix()
						m1.Translate(op1.hud_x,op1.hud_y)
						op1.transform = m1
						src.vis_contents += op1

						var/obj/hud/menus/options_background/option_help/op2 = new
						op2.maptext = "[css_outline]<font size = 1><center>Knowledge & Guides"
						var/matrix/m2 = matrix()
						m2.Translate(op2.hud_x,op2.hud_y)
						op2.transform = m2
						src.vis_contents += op2

						var/obj/hud/menus/options_background/option_settings/op3 = new
						op3.maptext = "[css_outline]<font size = 1><center>Settings"
						var/matrix/m3 = matrix()
						m3.Translate(op3.hud_x,op3.hud_y)
						op3.transform = m3
						src.vis_contents += op3

						var/obj/hud/menus/options_background/option_notes/op0 = new
						op0.maptext = "[css_outline]<font size = 1><center>Version Notes"
						var/matrix/m00 = matrix()
						m00.Translate(op0.hud_x,op0.hud_y)
						op0.transform = m00
						src.vis_contents += op0

						var/obj/hud/menus/options_background/option_return/op4 = new
						op4.maptext = "[css_outline]<font size = 1><center>Return"
						var/matrix/m4 = matrix()
						m4.Translate(op4.hud_x,op4.hud_y)
						op4.transform = m4
						src.vis_contents += op4

						/*var/obj/hud/menus/options_background/option_logout/op5 = new
						op5.maptext = "[css_outline]<font size = 1><center>Logout"
						var/matrix/m5 = matrix()
						m5.Translate(op5.hud_x,op5.hud_y)
						op5.transform = m5
						src.vis_contents += op5
						  */

						var/obj/hud/menus/options_background/option_leaderboards/op6 = new
						op6.maptext = "[css_outline]<font size = 1><center>Leaderboards"
						var/matrix/m6 = matrix()
						m6.Translate(op6.hud_x,op6.hud_y)
						op6.transform = m6
						src.vis_contents += op6
				option_version
					icon = null
					plane = 36
					layer = 34
					hud_x = 22
					hud_y = 8
					maptext_width = 100
					maptext_height = 16
					maptext_x = 0
					maptext_y = 5
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					New()
						return
				option_server_options
					icon = 'new_hud_options_buttons.dmi'
					icon_state = "button"
					plane = 36
					layer = 34
					hud_x = 22
					hud_y = 199
					maptext_width = 100
					maptext_height = 16
					maptext_x = 0
					maptext_y = 5
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					New()
						return
					MouseEntered()
						src.icon_state = "button hover"
					MouseExited()
						src.icon_state = "button"
					Click()
						if(usr.typing) return
						if(usr.started == 0) return
						var/ahcmsg = input("How can we help you?") as text
						ahcmsg = copytext(sanitize(ahcmsg), 1, MAX_MESSAGE_LEN)


						if (!ahcmsg)
							return


						for (var/mob/M in players)
							if (M.client && M.key in StaffTeam)
								M << "<b><u><font size=2><font color=red>ADMIN HELP CHANNEL:</u></b> </font>[usr.key]([usr.fullname]):</b> [ahcmsg]</font>"
						usr <<"<b><u><font size=2><font color=red>AHC:</b></font></u>\n[ahcmsg]\nhas been broadcast to the administrators."
						return
				option_help
					icon = 'new_hud_options_buttons.dmi'
					icon_state = "button"
					plane = 36
					layer = 34
					hud_x = 22
					hud_y = 172
					maptext_width = 100
					maptext_height = 16
					maptext_x = 0
					maptext_y = 5
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					New()
						return
					MouseEntered()
						src.icon_state = "button hover"
					MouseExited()
						src.icon_state = "button"
					Click()
						if(usr.typing) return
						if(usr.started == 0) return
						if(!usr.open_menus) usr.open_menus = list()
						if(usr.open_help)
							usr.open_help = 0
							usr.open_menus.Remove(".open_help")
							usr.client.screen -= usr.hud_help
						else
							usr.open_help = 1
							usr.open_menus.Add(".open_help")
							usr.client.screen += usr.hud_help
							usr.client.screen -= usr.hud_opt
							usr.open_options = 0
							usr.open_menus.Remove("open_options")
						winset(usr,"map.map","focus=true")
				option_settings
					icon = 'new_hud_options_buttons.dmi'
					icon_state = "button"
					plane = 36
					layer = 34
					hud_x = 22
					hud_y = 145
					maptext_width = 100
					maptext_height = 16
					maptext_x = 0
					maptext_y = 5
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE

					New()
						return

					MouseEntered()
						src.icon_state = "button hover"
					MouseExited()
						src.icon_state = "button"

					Click()
						if(usr.typing) return
						if(usr.started == 0) return

						switch(input(usr, "Settings:") in list("Change IC Color", "General Fix", "Toggle Battle Text", "Toggle Anger Text"))
							if("Change IC Color")
								var/new_c = input("New color for IC:") as color
								usr.text_color_ic = new_c

							if("Toggle Battle Text")
								usr.battle_text = !usr.battle_text
								usr << "You toggle Battle Text: <font color=[usr.battle_text ? "green" : "red"]>[usr.battle_text ? "ON" : "OFF"]</font>"
								return

							if("Toggle Anger Text")
								usr.anger_text = !usr.anger_text
								usr << "You toggle Anger Text: <font color=[usr.anger_text ? "green" : "red"]>[usr.anger_text ? "ON" : "OFF"]</font>"
								return

							if("General Fix")
								usr.particles = null //Keep this for a while, I think saving them makes the player crash.

								var/list/screen_mobs = list()
								if(usr && usr.client)
									for(var/mob/m in usr.client.screen)
										usr.client.screen -= m
										screen_mobs += m
								if(usr.filters) usr.filters = null

								if(usr.client.custom_view)
									if(usr.client.custom_view == "Auto")

										usr.client.pixel_x = 32
										usr.client.pixel_y = 32
									else if(usr.client.custom_view == "Zero")
										usr.client.pixel_x = 0
										usr.client.pixel_y = 0
									else if(usr.client.custom_view != "Auto" && usr.client.custom_view != "Zero" )
										usr.client.pixel_x = usr.client.custom_view
										usr.client.pixel_y = usr.client.custom_view
								else
									usr.client.pixel_x = 0
									usr.client.pixel_y = 0

								for(var/mob/m in screen_mobs)
									if(usr.client) usr.client.screen += m
								if(usr.skill_divine_weapon)
									for(var/mob/s in usr.skill_divine_weapon.active_splits)
										s.filters += filter(type="outline",size=1, color=rgb(204,236,255))
										s.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(204,236,255))
										s.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
										if(s.shadow) s.shadow.vis_contents += new/obj/effects/weapon_energy



								usr.check_glow_planes()
								usr.reset_ui_proc()
								//usr.redraw_appearance()
								//update_rating(usr)
								//update_qp(usr)
								//usr.update_looks(usr)
								if(usr.moved) usr.moved = 0
								if(usr.KB & usr.loc) usr.KB = 0
								//General_Portrait_Fix(usr)
								usr.update_icon(usr)
								view(5,usr)<<output("[usr] Generally fixed themselves.","actionoutput")
								return

							if("Change Interface")
								var/list/interfaces = list(
									"Modern (Full Screen HUD)" = 'interface.dmf',
									"Classic (Dynamic-Chat HUD)" = 'interface - unanchored - Copy.dmf'
								)
								var/choice = input(usr, "Select interface style:", "Interface") as null|anything in interfaces
								if(!choice) return


								if(findtext(choice, "Modern"))
									winset(usr.client, null, "loadskin=\"interface.dmf\"")
									usr.client.current_interface = "interface.dmf"
									usr.saved_interface = "interface.dmf" // <- Save choice here
									usr.interface_style = "[choice]"
									usr << "Switched to [choice]."

								if(findtext(choice, "Classic"))
									winset(usr.client, null, "loadskin=\"interface - unanchored - Copy.dmf\"")
									usr.client.current_interface = "interface - unanchored - Copy.dmf"
									usr.saved_interface = "interface - unanchored - Copy.dmf" // <- Save choice here
									usr.interface_style = "[choice]"
									usr << "Switched to [choice]."

								// Clear old HUD
								if(usr.client)
									for(var/atom/a in usr.client.screen)
										if(istype(a, /obj/hud/) || istype(a, /obj/hud/bars/) || istype(a, /obj/hud/buttons/))
											usr.client.screen -= a

							// Recreate HUD
								usr.create_main_bars()
								usr.create_player_blip()

								// Apply rescaling for modern HUD
								if(findtext(choice, "Modern"))
									if(usr.HUD)
										usr.HUD.Rescale_HUD(usr)


								// If player chose the modern HUD, apply rescaling


				option_notes
					icon = 'new_hud_options_buttons.dmi'
					icon_state = "button"
					plane = 36
					layer = 34
					hud_x = 22
					hud_y = 118
					maptext_width = 100
					maptext_height = 16
					maptext_x = 0
					maptext_y = 5
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					New()
						return
					MouseEntered()
						src.icon_state = "button hover"
					MouseExited()
						src.icon_state = "button"
					Click()
						if(usr.typing) return
						if(usr.started == 0) return
						if(usr.open_updates == 0)
							usr.client.screen += usr.hud_updates
							usr.open_updates = 1
							usr.client.screen -= usr.hud_opt
							usr.open_options = 0
							usr.open_menus.Remove("open_options")
						else
							usr.open_updates = 0
							usr.client.screen -= usr.hud_updates
				option_return
					icon = 'new_hud_options_buttons.dmi'
					icon_state = "button"
					plane = 36
					layer = 34
					hud_x = 22
					hud_y = 64
				//	plane = 36
					//layer = 34
					//hud_x = 22
					//hud_y = 91
					maptext_width = 100
					maptext_height = 16
					maptext_x = 0
					maptext_y = 5
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					New()
						return
					MouseEntered()
						src.icon_state = "button hover"
					MouseExited()
						src.icon_state = "button"
					Click()
						if(usr.typing) return
						if(usr.started == 0) return
						if(usr.open_options)
							//winshow(usr,"options",0)
							usr.client.screen -= usr.hud_opt
							usr.open_options = 0
							winshow(usr,"help",0)
							usr.open_help = 0
							usr.open_menus.Remove("open_options")
						winset(usr,"map.map","focus=true")
				option_leaderboards
					icon = 'new_hud_options_buttons.dmi'
					icon_state = "button"
					plane = 36
					layer = 34
					hud_x = 22
					hud_y = 91
					maptext_width = 100
					maptext_height = 16
					maptext_x = 0
					maptext_y = 5
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					New()
						return
					MouseEntered()
						src.icon_state = "button hover"
					MouseExited()
						src.icon_state = "button"
					Click()
						usr.OpenLeaderboard("rpps")
						return
				option_exit
					icon = 'new_hud_options_buttons.dmi'
					icon_state = "button"
					plane = 36
					layer = 34
					hud_x = 22
					hud_y = 64
					maptext_width = 100
					maptext_height = 16
					maptext_x = 0
					maptext_y = 5
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					New()
						return
					MouseEntered()
						src.icon_state = "button hover"
					MouseExited()
						src.icon_state = "button"
					Click()
						if(usr.typing) return
						usr.Mob_Save(1)
						//queue_mob_save(usr) // Replaces direct Mob_Save()

						usr.confirm = "quit game"
						if(usr.client) usr.hud_confirm.confirm_text(1,"Really quit game?",usr)
				/*option_logout
					icon = 'new_hud_options_buttons.dmi'
					icon_state = "button"
					plane = 36
					layer = 34
					hud_x = 22
					hud_y = 64
					maptext_width = 100
					maptext_height = 16
					maptext_x = 0
					maptext_y = 5
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					New()
						return
					MouseEntered()
						src.icon_state = "button hover"
					MouseExited()
						src.icon_state = "button"
					Click()
						if(usr.typing) return
						usr.Mob_Save(1)
						usr.confirm = "logout"
						if(usr.client) usr.hud_confirm.confirm_text(1,"Really logout?",usr)*/
			chat_background
				icon = 'new_chat_box2.dmi'
				icon_state = "menu"
				screen_loc = "1,1"
				plane = 21
				layer = 32
				var/body_background_x = 0
				var/body_background_y = 0
				var/hh = 0
				var/ww = 0
				var/obj/scrollbar_local
				var/obj/scrollbar_global
				var/obj/scrollbar_system
				var/obj/scrollbar_alerts
				var/obj/scroller_local
				var/obj/scroller_global
				var/obj/scroller_system
				var/obj/scroller_alerts
				var/obj/hud/menus/chat_background/menu
				var/obj/tab_local
				var/obj/tab_global
				var/obj/tab_system
				var/obj/tab_alerts
				var/obj/input
				var/obj/hud/menus/chat_background/txt_display_global
				var/obj/hud/menus/chat_background/txt_display_local
				var/obj/hud/menus/chat_background/txt_display_system
				var/obj/hud/menus/chat_background/txt_display_alerts
				var/entries_max = 100
				var/global_scroll_y = 0
				var/global_size = -76
				var/local_scroll_y = 0
				var/local_size = -76
				var/system_scroll_y = 0
				var/system_size = -76
				var/alerts_scroll_y = 0
				var/alerts_size = -76
				var/size_y = 0 //The size of the total chat in pixels so far
				var/scrolled_y = 0
				var/obj/tab_selected
				var/obj/hud/menus/chat_background/chat_entry/entry_system
				var/obj/hud/menus/chat_background/chat_entry/entry_local
				var/obj/hud/menus/chat_background/chat_entry/entry_alerts
				var/obj/hud/menus/chat_background/chat_entry/entry_global
				proc
					menu_create()
						var/obj/hud/menus/chat_background/chat_txt_holder_local/c_holder_local = new
						src.vis_contents += c_holder_local
						c_holder_local.menu = src
						src.txt_display_local = c_holder_local

						var/obj/hud/menus/chat_background/chat_entry/e_local = new
						e_local.menu = src
						c_holder_local.vis_contents += e_local
						src.entry_local = e_local
						var/matrix/mat_local = matrix()
						mat_local.Translate(e_local.hud_x,e_local.hud_y)
						e_local.transform = mat_local

						var/obj/hud/menus/chat_background/chat_txt_holder_system/c_holder_system = new
						c_holder_system.menu = src
						src.txt_display_system = c_holder_system

						var/obj/hud/menus/chat_background/chat_entry/e_system = new
						e_system.menu = src
						c_holder_system.vis_contents += e_system
						src.entry_system = e_system
						var/matrix/mat_system = matrix()
						mat_system.Translate(e_system.hud_x,e_system.hud_y)
						e_system.transform = mat_system

						var/obj/hud/menus/chat_background/chat_txt_holder_alerts/c_holder_alerts = new
						c_holder_alerts.menu = src
						src.txt_display_alerts = c_holder_alerts

						var/obj/hud/menus/chat_background/chat_entry/e_alerts = new
						e_alerts.menu = src
						c_holder_alerts.vis_contents += e_alerts
						src.entry_alerts = e_alerts
						var/matrix/mat_alerts = matrix()
						mat_alerts.Translate(e_alerts.hud_x,e_alerts.hud_y)
						e_alerts.transform = mat_alerts

						var/obj/hud/menus/chat_background/chat_txt_holder_global/c_holder_global = new
						c_holder_global.menu = src
						src.txt_display_global = c_holder_global

						var/obj/hud/menus/chat_background/chat_entry/e_global = new
						e_global.menu = src
						c_holder_global.vis_contents += e_global
						src.entry_global = e_global
						var/matrix/mat_global = matrix()
						mat_global.Translate(e_global.hud_x,e_global.hud_y)
						e_global.transform = mat_global

						var/obj/hud/menus/chat_background/chat_tab_local/a_tab_local = new
						src.vis_contents += a_tab_local
						a_tab_local.menu = src
						src.tab_local = a_tab_local
						src.tab_selected = a_tab_local

						var/obj/hud/menus/chat_background/chat_tab_global/a_tab_global = new
						src.vis_contents += a_tab_global
						a_tab_global.menu = src
						src.tab_global = a_tab_global

						var/obj/hud/menus/chat_background/chat_tab_system/a_tab_system = new
						src.vis_contents += a_tab_system
						a_tab_system.menu = src
						src.tab_system = a_tab_system

						var/obj/hud/menus/chat_background/chat_tab_alerts/a_tab_alerts = new
						src.vis_contents += a_tab_alerts
						a_tab_alerts.menu = src
						src.tab_alerts = a_tab_alerts

						var/obj/hud/menus/chat_background/chat_input/a_input = new
						src.vis_contents += a_input
						a_input.menu = src
						src.input = a_input

						var/obj/hud/menus/chat_background/chat_scrollbar_local/c_bar_local = new
						src.vis_contents += c_bar_local
						c_bar_local.menu = src
						src.scrollbar_local = c_bar_local

						var/obj/hud/menus/chat_background/chat_scrollbar_global/c_bar_global = new
						c_bar_global.menu = src
						src.scrollbar_global = c_bar_global

						var/obj/hud/menus/chat_background/chat_scrollbar_system/c_bar_system = new
						c_bar_system.menu = src
						src.scrollbar_system = c_bar_system

						var/obj/hud/menus/chat_background/chat_scrollbar_alerts/c_bar_alerts = new
						c_bar_alerts.menu = src
						src.scrollbar_alerts = c_bar_alerts

						var/obj/hud/menus/chat_background/chat_scroller_local/scroller1 = new
						src.vis_contents += scroller1
						scroller1.menu = src
						src.scroller_local = scroller1

						var/obj/hud/menus/chat_background/chat_scroller_global/scroller2 = new
						scroller2.menu = src
						src.scroller_global = scroller2

						var/obj/hud/menus/chat_background/chat_scroller_system/scroller3 = new
						scroller3.menu = src
						src.scroller_system = scroller3

						var/obj/hud/menus/chat_background/chat_scroller_alerts/scroller4 = new
						scroller4.menu = src
						src.scroller_alerts = scroller4
					clear_box()
						var/obj/o = src//.input
						o.select_started = 0
						o.select_end = 0
						o.string_selected = ""
						o.excluded_before = ""
						o.excluded_after = ""
						o.maptext = ""
						//o.maptext = "[css_outline]<font size = 1><left>|"
						o.string_full = ""
						o.caret_pos = 1
				chat_entry
					icon = null
					layer = 34
					plane = 21
					maptext_width = 292
					hud_x = 10
					hud_y = 115
					render_target = "chatbox local"
					blend_mode = BLEND_INSET_OVERLAY
					//vis_flags = VIS_INHERIT_ID
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					//New()
						//var/icon/I = icon(icon='new_chat_box.dmi',icon_state="txt holder solid")
						//src.filters += filter(type="layer", render_source = "chatbox local")
						//src.filters += filter(type="outline",size=1,rgb(255,255,255))
					MouseEntered()
						return
					MouseExited()
						return
				chat_scrollbar_local
					icon = 'new_chat_box2.dmi'
					icon_state = "scrollbar"
					layer = 33
					plane = 21
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/chat_background/s = src.menu
						if(s.local_size <= 0) return
						var/obj/sc = s.scroller_local
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 2
						else if(delta_y < 0) wheel_move = -2
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-62)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/ratio = -1 + ((-62 + result) / -62)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(s.local_size*ratio)

						s.local_scroll_y = scroll_y

						var/matrix/m2 = matrix()
						m2.Translate(s.entry_local.hud_x,s.entry_local.hud_y+scroll_y)
						s.entry_local.translated_y = scroll_y
						s.entry_local.transform = m2
					Click(location,control,params)
						var/obj/hud/menus/chat_background/s = src.menu
						if(s.local_size <= 0) return
						var/obj/sc = s.scroller_local
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/result = -49 + ((usr.mouse_y_true-s.body_background_y)-54)
						result = clamp(result,0,-62)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/ratio = -1 + ((-62 + result) / -62)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(s.local_size*ratio)

						s.local_scroll_y = scroll_y

						var/matrix/m2 = matrix()
						m2.Translate(s.entry_local.hud_x,s.entry_local.hud_y+scroll_y)
						s.entry_local.translated_y = scroll_y
						s.entry_local.transform = m2
					New()
						return
					MouseDrag()
						return
					MouseEntered()
						return
					MouseExited()
						return
				chat_scrollbar_global
					icon = 'new_chat_box2.dmi'
					icon_state = "scrollbar"
					layer = 33
					plane = 21
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/chat_background/s = src.menu
						if(s.global_size <= 0) return
						var/obj/sc = s.scroller_global
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 2
						else if(delta_y < 0) wheel_move = -2
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-62)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/ratio = -1 + ((-62 + result) / -62)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(s.global_size*ratio)

						s.global_scroll_y = scroll_y

						var/matrix/m2 = matrix()
						m2.Translate(s.entry_global.hud_x,s.entry_global.hud_y+scroll_y)
						s.entry_global.translated_y = scroll_y
						s.entry_global.transform = m2
					Click(location,control,params)
						var/obj/hud/menus/chat_background/s = src.menu
						if(s.global_size <= 0) return
						var/obj/sc = s.scroller_global
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/result = -49 + ((usr.mouse_y_true-s.body_background_y)-54)
						result = clamp(result,0,-62)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/ratio = -1 + ((-62 + result) / -62)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(s.global_size*ratio)

						s.global_scroll_y = scroll_y

						var/matrix/m2 = matrix()
						m2.Translate(s.entry_global.hud_x,s.entry_global.hud_y+scroll_y)
						s.entry_global.translated_y = scroll_y
						s.entry_global.transform = m2
					New()
						return
					MouseDrag()
						return
					MouseEntered()
						return
					MouseExited()
						return
				chat_scrollbar_system
					icon = 'new_chat_box2.dmi'
					icon_state = "scrollbar"
					layer = 33
					plane = 21
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/chat_background/s = src.menu
						if(s.system_size <= 0) return
						var/obj/sc = s.scroller_system
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 2
						else if(delta_y < 0) wheel_move = -2
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-62)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/ratio = -1 + ((-62 + result) / -62)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(s.system_size*ratio)

						s.system_scroll_y = scroll_y

						var/matrix/m2 = matrix()
						m2.Translate(s.entry_system.hud_x,s.entry_system.hud_y+scroll_y)
						s.entry_system.translated_y = scroll_y
						s.entry_system.transform = m2
					Click(location,control,params)
						var/obj/hud/menus/chat_background/s = src.menu
						if(s.system_size <= 0) return
						var/obj/sc = s.scroller_system
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/result = -49 + ((usr.mouse_y_true-s.body_background_y)-54)
						result = clamp(result,0,-62)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/ratio = -1 + ((-62 + result) / -62)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(s.system_size*ratio)

						s.system_scroll_y = scroll_y

						var/matrix/m2 = matrix()
						m2.Translate(s.entry_system.hud_x,s.entry_system.hud_y+scroll_y)
						s.entry_system.translated_y = scroll_y
						s.entry_system.transform = m2
					New()
						return
					MouseDrag()
						return
					MouseEntered()
						return
					MouseExited()
						return
				chat_scrollbar_alerts
					icon = 'new_chat_box2.dmi'
					icon_state = "scrollbar"
					layer = 33
					plane = 21
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/chat_background/s = src.menu
						if(s.alerts_size <= 0) return
						var/obj/sc = s.scroller_alerts
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 2
						else if(delta_y < 0) wheel_move = -2
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-62)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/ratio = -1 + ((-62 + result) / -62)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(s.alerts_size*ratio)

						s.alerts_scroll_y = scroll_y

						var/matrix/m2 = matrix()
						m2.Translate(s.entry_alerts.hud_x,s.entry_alerts.hud_y+scroll_y)
						s.entry_alerts.translated_y = scroll_y
						s.entry_alerts.transform = m2
					Click(location,control,params)
						var/obj/hud/menus/chat_background/s = src.menu
						if(s.alerts_size <= 0) return
						var/obj/sc = s.scroller_alerts
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/result = -49 + ((usr.mouse_y_true-s.body_background_y)-54)
						result = clamp(result,0,-62)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/ratio = -1 + ((-62 + result) / -62)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(s.alerts_size*ratio)

						s.alerts_scroll_y = scroll_y

						var/matrix/m2 = matrix()
						m2.Translate(s.entry_alerts.hud_x,s.entry_alerts.hud_y+scroll_y)
						s.entry_alerts.translated_y = scroll_y
						s.entry_alerts.transform = m2
					New()
						return
					MouseDrag()
						return
					MouseEntered()
						return
					MouseExited()
						return
				chat_scroller_local
					icon = 'new_chat_box2.dmi'
					icon_state = "scroller"
					layer = 33
					plane = 21
					translated_y = -62
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					New()
						var/matrix/m = matrix()
						m.Translate(0,src.translated_y)
						src.transform = m
						return
					MouseEntered()
						return
					MouseExited()
						return
					MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
						var/obj/hud/menus/chat_background/s = src.menu
						if(s.local_size <= 0) return
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/result = -49 + ((usr.mouse_y_true-s.body_background_y)-54)
						result = clamp(result,0,-62)
						var/matrix/m = matrix()
						m.Translate(0,result)
						src.transform = m
						src.translated_y = result

						var/ratio = -1 + ((-62 + result) / -62)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(s.local_size*ratio)

						s.local_scroll_y = scroll_y

						var/matrix/m2 = matrix()
						m2.Translate(s.entry_local.hud_x,s.entry_local.hud_y+scroll_y)
						s.entry_local.translated_y = scroll_y
						s.entry_local.transform = m2
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/chat_background/s = src.menu
						if(s.local_size <= 0) return
						var/obj/sc = src
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 2
						else if(delta_y < 0) wheel_move = -2
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-62)

						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result
						var/ratio = -1 + ((-62 + result) / -62)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(s.local_size*ratio)

						s.local_scroll_y = scroll_y

						var/matrix/m2 = matrix()
						m2.Translate(s.entry_local.hud_x,s.entry_local.hud_y+scroll_y)
						s.entry_local.translated_y = scroll_y
						s.entry_local.transform = m2
				chat_scroller_global
					icon = 'new_chat_box2.dmi'
					icon_state = "scroller"
					layer = 33
					plane = 21
					translated_y = -62
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					New()
						var/matrix/m = matrix()
						m.Translate(0,src.translated_y)
						src.transform = m
						return
					MouseEntered()
						return
					MouseExited()
						return
					MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
						var/obj/hud/menus/chat_background/s = src.menu
						if(s.global_size <= 0) return
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/result = -49 + ((usr.mouse_y_true-s.body_background_y)-54)
						result = clamp(result,0,-62)
						var/matrix/m = matrix()
						m.Translate(0,result)
						src.transform = m
						src.translated_y = result

						var/ratio = -1 + ((-62 + result) / -62)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(s.global_size*ratio)

						s.global_scroll_y = scroll_y

						var/matrix/m2 = matrix()
						m2.Translate(s.entry_global.hud_x,s.entry_global.hud_y+scroll_y)
						s.entry_global.translated_y = scroll_y
						s.entry_global.transform = m2
				chat_scroller_system
					icon = 'new_chat_box2.dmi'
					icon_state = "scroller"
					layer = 33
					plane = 21
					translated_y = -62
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					New()
						var/matrix/m = matrix()
						m.Translate(0,src.translated_y)
						src.transform = m
						return
					MouseEntered()
						return
					MouseExited()
						return
					MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
						var/obj/hud/menus/chat_background/s = src.menu
						if(s.system_size <= 0) return
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/result = -49 + ((usr.mouse_y_true-s.body_background_y)-54)
						result = clamp(result,0,-62)
						var/matrix/m = matrix()
						m.Translate(0,result)
						src.transform = m
						src.translated_y = result

						var/ratio = -1 + ((-62 + result) / -62)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(s.system_size*ratio)

						s.system_scroll_y = scroll_y

						var/matrix/m2 = matrix()
						m2.Translate(s.entry_system.hud_x,s.entry_system.hud_y+scroll_y)
						s.entry_system.translated_y = scroll_y
						s.entry_system.transform = m2
				chat_scroller_alerts
					icon = 'new_chat_box2.dmi'
					icon_state = "scroller"
					layer = 33
					plane = 21
					translated_y = -62
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					New()
						var/matrix/m = matrix()
						m.Translate(0,src.translated_y)
						src.transform = m
						return
					MouseEntered()
						return
					MouseExited()
						return
					MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
						var/obj/hud/menus/chat_background/s = src.menu
						if(s.alerts_size <= 0) return
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/result = -49 + ((usr.mouse_y_true-s.body_background_y)-54)
						result = clamp(result,0,-62)
						var/matrix/m = matrix()
						m.Translate(0,result)
						src.transform = m
						src.translated_y = result

						var/ratio = -1 + ((-62 + result) / -62)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(s.alerts_size*ratio)

						s.alerts_scroll_y = scroll_y

						var/matrix/m2 = matrix()
						m2.Translate(s.entry_alerts.hud_x,s.entry_alerts.hud_y+scroll_y)
						s.entry_alerts.translated_y = scroll_y
						s.entry_alerts.transform = m2
				chat_txt_holder_local
					icon = 'new_chat_box2.dmi'
					icon_state = "txt holder"
					layer = 33
					plane = 21
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					New()
						return
					MouseEntered()
						return
					MouseExited()
						return
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/chat_background/s = src.menu
						if(s.local_size <= 0) return
						var/obj/sc = s.scroller_local
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 2
						else if(delta_y < 0) wheel_move = -2
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-62)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/ratio = -1 + ((-62 + result) / -62)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(s.local_size*ratio)
						//var/scroll_y = round(200*ratio)

						s.local_scroll_y = scroll_y

						var/matrix/m2 = matrix()
						m2.Translate(s.entry_local.hud_x,s.entry_local.hud_y+scroll_y)
						s.entry_local.translated_y = scroll_y
						s.entry_local.transform = m2
				chat_txt_holder_global
					icon = 'new_chat_box2.dmi'
					icon_state = "txt holder"
					layer = 33
					plane = 21
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					New()
						return
					MouseEntered()
						return
					MouseExited()
						return
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/chat_background/s = src.menu
						if(s.global_size <= 0) return
						var/obj/sc = s.scroller_global
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 2
						else if(delta_y < 0) wheel_move = -2
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-62)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/ratio = -1 + ((-62 + result) / -62)
						ratio = clamp(ratio,0,1)
						//var/scroll_y = round(200*ratio)
						var/scroll_y = round(s.global_size*ratio)

						s.global_scroll_y = scroll_y

						var/matrix/m2 = matrix()
						m2.Translate(s.entry_global.hud_x,s.entry_global.hud_y+scroll_y)
						s.entry_global.translated_y = scroll_y
						s.entry_global.transform = m2
				chat_txt_holder_system
					icon = 'new_chat_box2.dmi'
					icon_state = "txt holder"
					layer = 33
					plane = 21
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					New()
						return
					MouseEntered()
						return
					MouseExited()
						return
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/chat_background/s = src.menu
						if(s.system_size <= 0) return
						var/obj/sc = s.scroller_system
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 2
						else if(delta_y < 0) wheel_move = -2
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-62)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/ratio = -1 + ((-62 + result) / -62)
						ratio = clamp(ratio,0,1)
						//var/scroll_y = round(200*ratio)
						var/scroll_y = round(s.system_size*ratio)

						s.system_scroll_y = scroll_y

						var/matrix/m2 = matrix()
						m2.Translate(s.entry_system.hud_x,s.entry_system.hud_y+scroll_y)
						s.entry_system.translated_y = scroll_y
						s.entry_system.transform = m2
				chat_txt_holder_alerts
					icon = 'new_chat_box2.dmi'
					icon_state = "txt holder"
					layer = 33
					plane = 21
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					New()
						return
					MouseEntered()
						return
					MouseExited()
						return
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/chat_background/s = src.menu
						if(s.alerts_size <= 0) return
						var/obj/sc = s.scroller_alerts
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 2
						else if(delta_y < 0) wheel_move = -2
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-62)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/ratio = -1 + ((-62 + result) / -62)
						ratio = clamp(ratio,0,1)
						//var/scroll_y = round(200*ratio)
						var/scroll_y = round(s.alerts_size*ratio)

						s.alerts_scroll_y = scroll_y


						var/matrix/m2 = matrix()
						m2.Translate(s.entry_alerts.hud_x,s.entry_alerts.hud_y+scroll_y)
						s.entry_alerts.translated_y = scroll_y
						s.entry_alerts.transform = m2
				chat_tab_local
					icon = 'new_chat_box2.dmi'
					icon_state = "tab local clicked"
					maptext_width = 80
					maptext_height = 16
					maptext_y = 127
					maptext_x = 0
					layer = 33
					plane = 21
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					New()
						src.maptext = "[css_outline]<font size = 2><center>IC"
						return
					MouseEntered()
						if(src != src.menu.tab_selected) src.icon_state = "tab local hover"
					MouseExited()
						if(src != src.menu.tab_selected) src.icon_state = "tab local"
					Click()
						if(src.menu.tab_selected == src.menu.tab_global)
							var/obj/t = src.menu.tab_global
							t.icon_state = "tab global"
						else if(src.menu.tab_selected == src.menu.tab_system)
							var/obj/t = src.menu.tab_system
							t.icon_state = "tab system"
						else if(src.menu.tab_selected == src.menu.tab_alerts)
							var/obj/t = src.menu.tab_alerts
							t.icon_state = "tab alerts"
						src.menu.vis_contents += src.menu.txt_display_local
						src.menu.vis_contents -= src.menu.txt_display_system
						src.menu.vis_contents -= src.menu.txt_display_alerts
						src.menu.vis_contents -= src.menu.txt_display_global

						src.menu.vis_contents += src.menu.scrollbar_local
						src.menu.vis_contents += src.menu.scroller_local
						src.menu.vis_contents -= src.menu.scrollbar_system
						src.menu.vis_contents -= src.menu.scroller_system
						src.menu.vis_contents -= src.menu.scrollbar_alerts
						src.menu.vis_contents -= src.menu.scroller_alerts
						src.menu.vis_contents -= src.menu.scrollbar_global
						src.menu.vis_contents -= src.menu.scroller_global

						src.menu.tab_selected = src
						src.icon_state = "tab local clicked"
				chat_tab_global
					icon = 'new_chat_box2.dmi'
					icon_state = "tab global"
					maptext_width = 80
					maptext_height = 16
					maptext_y = 127
					maptext_x = 82
					layer = 33
					plane = 21
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					New()
						src.maptext = "[css_outline]<font size = 2><center>OOC"
						return
					MouseEntered()
						if(src != src.menu.tab_selected) src.icon_state = "tab global hover"
					MouseExited()
						if(src != src.menu.tab_selected) src.icon_state = "tab global"
					Click()
						if(src.menu.tab_selected == src.menu.tab_local)
							var/obj/t = src.menu.tab_local
							t.icon_state = "tab local"
						else if(src.menu.tab_selected == src.menu.tab_system)
							var/obj/t = src.menu.tab_system
							t.icon_state = "tab system"
						else if(src.menu.tab_selected == src.menu.tab_alerts)
							var/obj/t = src.menu.tab_alerts
							t.icon_state = "tab alerts"
						src.menu.vis_contents -= src.menu.txt_display_local
						src.menu.vis_contents -= src.menu.txt_display_system
						src.menu.vis_contents -= src.menu.txt_display_alerts
						src.menu.vis_contents += src.menu.txt_display_global

						src.menu.vis_contents -= src.menu.scrollbar_local
						src.menu.vis_contents -= src.menu.scroller_local
						src.menu.vis_contents -= src.menu.scrollbar_system
						src.menu.vis_contents -= src.menu.scroller_system
						src.menu.vis_contents -= src.menu.scrollbar_alerts
						src.menu.vis_contents -= src.menu.scroller_alerts
						src.menu.vis_contents += src.menu.scrollbar_global
						src.menu.vis_contents += src.menu.scroller_global
						src.menu.tab_selected = src
						src.icon_state = "tab global clicked"
				chat_tab_system
					icon = 'new_chat_box2.dmi'
					icon_state = "tab system"
					maptext_width = 80
					maptext_height = 16
					maptext_y = 128
					maptext_x = 165
					layer = 33
					plane = 21
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					New()
						src.maptext = "[css_outline]<font size = 2><center>System"
						return
					MouseEntered()
						if(src != src.menu.tab_selected) src.icon_state = "tab system hover"
					MouseExited()
						if(src != src.menu.tab_selected) src.icon_state = "tab system"
					Click()
						if(src.menu.tab_selected == src.menu.tab_local)
							var/obj/t = src.menu.tab_local
							t.icon_state = "tab local"
						else if(src.menu.tab_selected == src.menu.tab_global)
							var/obj/t = src.menu.tab_global
							t.icon_state = "tab global"
						else if(src.menu.tab_selected == src.menu.tab_alerts)
							var/obj/t = src.menu.tab_alerts
							t.icon_state = "tab alerts"
						src.menu.vis_contents -= src.menu.txt_display_local
						src.menu.vis_contents += src.menu.txt_display_system
						src.menu.vis_contents -= src.menu.txt_display_alerts
						src.menu.vis_contents -= src.menu.txt_display_global

						src.menu.vis_contents -= src.menu.scrollbar_local
						src.menu.vis_contents -= src.menu.scroller_local
						src.menu.vis_contents += src.menu.scrollbar_system
						src.menu.vis_contents += src.menu.scroller_system
						src.menu.vis_contents -= src.menu.scrollbar_alerts
						src.menu.vis_contents -= src.menu.scroller_alerts
						src.menu.vis_contents -= src.menu.scrollbar_global
						src.menu.vis_contents -= src.menu.scroller_global
						src.menu.tab_selected = src
						src.icon_state = "tab system clicked"
				chat_tab_alerts
					icon = 'new_chat_box2.dmi'
					icon_state = "tab alerts"
					maptext_width = 80
					maptext_height = 16
					maptext_y = 127
					maptext_x = 242
					layer = 33
					plane = 21
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					New()
						src.maptext = "[css_outline]<font size = 2><center>Alerts"
						return
					MouseEntered()
						if(src != src.menu.tab_selected) src.icon_state = "tab alerts hover"
					MouseExited()
						if(src != src.menu.tab_selected) src.icon_state = "tab alerts"
					Click()
						if(src.menu.tab_selected == src.menu.tab_local)
							var/obj/t = src.menu.tab_local
							t.icon_state = "tab local"
						else if(src.menu.tab_selected == src.menu.tab_global)
							var/obj/t = src.menu.tab_global
							t.icon_state = "tab global"
						else if(src.menu.tab_selected == src.menu.tab_system)
							var/obj/t = src.menu.tab_system
							t.icon_state = "tab system"
						src.menu.vis_contents -= src.menu.txt_display_local
						src.menu.vis_contents -= src.menu.txt_display_system
						src.menu.vis_contents += src.menu.txt_display_alerts
						src.menu.vis_contents -= src.menu.txt_display_global

						src.menu.vis_contents -= src.menu.scrollbar_local
						src.menu.vis_contents -= src.menu.scroller_local
						src.menu.vis_contents -= src.menu.scrollbar_system
						src.menu.vis_contents -= src.menu.scroller_system
						src.menu.vis_contents += src.menu.scrollbar_alerts
						src.menu.vis_contents += src.menu.scroller_alerts
						src.menu.vis_contents -= src.menu.scrollbar_global
						src.menu.vis_contents -= src.menu.scroller_global
						src.menu.tab_selected = src
						src.icon_state = "tab alerts clicked"
				chat_input_text
					icon = null
					//icon = 'new_hud_tiny_box.dmi'
					layer = 35//33
					plane = 21//9
					maptext_width = 308
					maptext_height = 300
					maptext_y = 5
					maptext_x = 3
					//blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseEntered()
						return
					MouseExited()
						return
				chat_input
					icon = 'new_chat_box2.dmi'
					icon_state = "input bar"
					layer = 32
					plane = 21
					var/a = 1
					var/selecting = 0
					var/selected = 0
					var/wid = 3 //How many pixels from the left side of the icon as a whole
					var/dis_min = 1
					var/dis_max = 1
					var/obj/hud/menus/chat_background/chat_input_carot/carot
					var/pix = 0
					maptext_y = 4
					maptext_x = 2
					maptext_width = 308
					maptext_height = 16
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					//For this input box, want to try and have a dis_min and dis_max var.
					//The dis_min/max vars would help keep track of the pos that the text is being displayed from.
					//So the start of the maptext display would be dis_min.
					//dis_min would be set once the MeasureText() returns more than 300 pixels.
					//dis_max would be then be dis_min+300
					MouseEntered()
						return
					MouseExited()
						return
					proc
						chat_input_select(var/p,var/mob/m)
							var/obj/hud/menus/chat_background/s = src.menu
							if(s.tab_selected == s.tab_system) return
							else if(s.tab_selected == s.tab_alerts) return
							if(src.maptext == null || src.maptext == "" || src.maptext == "[css_outline]<font size = 1><left>" || src.maptext == " ") src.maptext = "[css_outline]<font size = 1><left>|"
							src.selected = 1
							m.typing = src
							//If the params (p) var is null, probably means return/enter was hit, or something went wrong.
							if(p == null)
								src.caret_pos = 1
								return
						//	world << "DEBUG - clicked [src]"
							p = params2list(p)
							var/icon_x = text2num(p["icon-x"])
							//world << "DEBUG - icon-x: [icon_x]"
							var/L = m.client.MeasureText("[src.maptext]")
							var/x_pos = findtext(L, "x")
							L = text2num(copytext(L, 1, x_pos))
							if(L <= 0)
								return
							//world << "DEBUG - len: [L]"
							var/L_C = length_char(src.string_full)
							//world << "DEBUG - len chars: [L_C]"
							var/pos = (icon_x-wid)/L
							pos = round(pos*L_C)
							pos = pos+1
							src.caret_pos = pos
							if(src.caret_pos >= length(src.string_full)+1) src.caret_pos = length(src.string_full)+1
							// Combine the new strings with "|" in between.
							src.maptext = "[css_outline]<font size = 1><left>[splicetext(src.string_full,src.caret_pos,src.caret_pos,"|")]"
							src.select_started = 0
							src.select_end += 0
							src.string_selected = ""
							src.excluded_before = ""
							src.excluded_after = ""
							return
					Click(location,control,params)
						// Track where player clicked on input box (icon_x)
						// Measure the maptext itself using MeasureText() (L)
						// Measure how many characters were in the text string (L_C)
						// Find the pos by taking icon_x and subtracting wid, which is how far the start of the text is from the left side of the icon
						// Then divide that result by the total pixel length of the text string (pos)
						// Then take pos and multply it by total characters in the string (L_C), and round the result, then add +1
						src.chat_input_select(params,usr)

			confirm_menu_numbers_background
				icon = 'new_hud_num_confirm.dmi'
				icon_state = "menu"
				screen_loc = "1,1"
				maptext_width = 216
				maptext_height = 34
				maptext_x = 5
				maptext_y = 45
				plane = 37
				layer = 35
				var/hh = 0
				var/ww = 0
				var/obj/input_box
				proc
					clear_box()
						var/obj/o = src.input_box
						o.select_started = 0
						o.select_end = 0
						o.string_selected = ""
						o.excluded_before = ""
						o.excluded_after = ""
						o.maptext = ""
						o.caret_pos = 1
					confirm_text(var/show = 0,var/t,var/mob/m)
						if(show == 0)
							m.client.screen -= src
						else
							m.client.screen += src
							m.typing = src.input_box
						if(t) src.maptext = "[css_outline]<font size = 1><center>[t]"
						else if(src.input_box) src.clear_box()
				MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
					params = params2list(params)
					var/icon_y = text2num(params["icon-y"])
					if(icon_y >= 40 || usr.mouse_down)
						usr.client.MousePosition(params)
						var/matrix/m = matrix()
						var/icon_x = text2num(params["icon-x"])
						if(usr.drag_icon_x == 0) usr.drag_icon_x = icon_x
						var/x_result = usr.client.client_mouse_x-usr.drag_icon_x
						var/y_result = usr.client.client_mouse_y-src.hh
						x_result = clamp(x_result,0,1023-src.ww)
						y_result = clamp(y_result,0,575-(src.hh/2))
						m.Translate(x_result,y_result)
						src.transform = m
						usr.mouse_down = src
				New()
					var/matrix/m_main = matrix()
					m_main.Translate(416,256)
					src.transform = m_main

					var/icon/I = new(src.icon)
					src.ww = I.Width()
					src.hh = I.Height()

					var/obj/hud/menus/confirm_menu_numbers_background/confirm_tick/tick = new
					var/matrix/m1 = matrix()
					m1.Translate(74,6)
					tick.transform = m1
					src.vis_contents += tick
					tick.menu = src

					var/obj/hud/menus/confirm_menu_numbers_background/confirm_cross/cross = new
					var/matrix/m2 = matrix()
					m2.Translate(132,6)
					cross.transform = m2
					src.vis_contents += cross
					cross.menu = src

					var/obj/hud/menus/confirm_menu_numbers_background/num_input/n_input = new
					src.vis_contents += n_input
					src.input_box = n_input
					n_input.menu = src
					return
				confirm_cross
					icon = 'new_hud_tick_cross.dmi'
					icon_state = "cross"
					var/obj/menu
					New()
						return
					MouseEntered()
						src.icon_state = "cross hover"
					MouseExited()
						src.icon_state = "cross"
					Click()
						if(usr.typing) return
						usr.hud_confirm_nums.confirm_text(0,null,usr)
						usr.numbers = null
						usr.numbers_text = null
						usr.numbers_accessing = null
				confirm_tick
					icon = 'new_hud_tick_cross.dmi'
					icon_state = "tick"
					var/obj/menu
					New()
						return
					MouseEntered()
						src.icon_state = "tick hover"
					MouseExited()
						src.icon_state = "tick"
					Click()
						//if(usr.confirm == null) return
						var/nm
						if(src.menu)
							var/obj/hud/menus/confirm_menu_numbers_background/c = src.menu
							if(c.input_box)
								var/input = "[c.input_box.string_full]"
								nm = text2num(input)
						usr.hud_confirm_nums.confirm_text(0,null,usr)
						//var/nm = num
						//var/go_through_this_proc_make_sure_all_works
						if(nm == null)
							//world << "DEBUG - nm was null, returning."
							return
						if(nm == "default") nm = winget(usr,"numbers.input_number","text")
						else if(isnum(nm) == 0) return
						if(usr.numbers_text == "tech weights")
							if(usr.left_click_ref)
								var/obj/items/tech/w = usr.left_click_ref
								if(istext(nm) == 1) nm = text2num(nm)
								if(isnum(nm) == 1 && nm > 0)
									w.weight = nm
									w.value = w.weight*100
									w.name = "[initial(w.name)] ([w.weight]kg)"
									w.desc_extra = "- [w.weight]kg weights"
									if(usr.build_tech_selected == w)
										winset(usr,"tech.label_cost","text=\"Needed Minerals: <text align=right valign=top> Stone: [w.stone_cost]\nCopper: [w.copper_cost]\nCoal: [w.coal_cost]\nSilver: [w.silver_cost]\nGold: [w.gold_cost]\nTitanium: [w.titanium_cost]\nMystille: [w.mystille_cost]\n\n<text align=left valign=top>\"")

										winset(usr,"tech.label_name","text=\"[w.name]\"")
							usr.numbers = null
							usr.numbers_text = null
							usr.left_click_ref = null
							winset(usr,"numbers.input_number","text=")
							return
						if(usr.numbers_text == "set door password")
							winshow(usr,"numbers",0)
							if(usr.left_click_ref)
								var/obj/items/tech/doors/d = usr.left_click_ref
								if(get_dist(usr,d) <= 1)
									usr.numbers = null
									usr.numbers_text = null
									usr.left_click_ref = null
									d.pass = nm
									//world << "DEBUG - Password is [d.pass]"
							usr.numbers = null
							usr.numbers_text = null
							usr.left_click_ref = null
							winset(usr,"numbers.input_number","text=")
							return
						if(usr.numbers_text == "door password")
							winshow(usr,"numbers",0)
							if(nm)
								if(usr.left_click_ref)
									var/obj/items/tech/doors/d = usr.left_click_ref
									if(nm == d.pass)
										if(get_dist(usr,d) <= 1)
											d.icon_state = "opening"
											d.density_factor = 0
											d.opacity = 0
											usr.numbers = null
											usr.numbers_text = null
											usr.left_click_ref = null
											winset(usr,"numbers.input_number","text=")
											sleep(60)
											d.icon_state = "closing"
											d.density_factor = 2
											d.opacity = 1
							usr.numbers = null
							usr.numbers_text = null
							usr.left_click_ref = null
							winset(usr,"numbers.input_number","text=")
							return
						if(usr.numbers_text == "telepath")
							//world << "DEBUG - text is [nm]"
							if(nm)
								if(usr.left_click_ref)
									var/mob/m = usr.left_click_ref

									m << output("<font color = white>[usr] says in telepathy - [nm]", "chat.local")
									usr << output("<font color = white>You say in telepathy to [m] - [nm]", "chat.local")

									m << output("[usr] says in telepathy - [nm]","chat.output_alerts")
									usr << output("You say in telepathy to [m] - [nm]","chat.output_alerts")

									usr.left_click_ref = null
									//world << "DEBUG - left_click_ref rendered null - from telepathy"
									winshow(usr,"numbers",0)

									winset(usr,"numbers.input_number","text=")
							return
						var/n = nm//text2num(nm)
						//world << "DEBUG - The number is [n]"
						winshow(usr,"numbers",0)
						var/reset = 0
						if(n <= 0)
							reset = 1
						if(!isnum(n))
							reset = 1
						if(reset)
							winset(usr,"numbers.input_number","text=")
							usr.numbers = null
							usr.numbers_text = null
							usr.numbers_accessing = null
							usr.open_spread = 0
							return
						if(istype(usr.numbers_text,/obj/items/tech/Gravity_Machine))
							var/obj/g = usr.numbers_text
							if(g in range(2,usr))
								if(n > 1000) n = 1000
								g.setting = n
								g.icon_state = "on"
								g.on = 1;
								var/stay_on = 0
								for(var/turf/trf in g.locs)
									for(var/obj/items/tech/Power_Line/p in trf)
										p.reconnect_power()
										if(p.network)
											var/area/a = p.network
											if(a.excess_grid >= 0 || a.stored_grid > 0) stay_on = 1;
											break
								if(stay_on) g.pulsate_field()
							usr.numbers_text = null
							view(6,usr) << "[usr] sets the gravity to [n]"
							winset(usr,"numbers.input_number","text=")
							return
						if(istype(usr.numbers_text,/obj/items/tech/Microwave_Generator))
							var/obj/items/tech/Microwave_Generator/g = usr.numbers_text
							if(g in range(2,usr))
								if(n > 1000) n = 1000
								g.setting = n
								g.on = 1;
								g.icon_state = "front"
								g.vis_contents += g.back
								g.vis_contents += g.orb
								g.vis_contents += g.elec
								g.vis_contents += g.pulse
								g.vis_contents += g.outline

								usr.loc = g.loc
								usr.step_x = g.step_x
								usr.step_y = g.step_y+50
								usr.set_shadow()
								usr.layer = g.layer+0.1
								//usr.overlays += /obj/effects/elec //Replace later with a server-wide vis_contents of this for both microwaves and focus skill
								for(var/obj/skills/Meditate/m in usr)
									if(m.active == 0)
										call(m.act)(usr,m)

								var/stay_on = 0
								for(var/turf/trf in g.locs)
									for(var/obj/items/tech/Power_Line/p in trf)
										p.reconnect_power()
										if(p.network)
											var/area/a = p.network
											if(a.excess_grid >= 0 || a.stored_grid > 0) stay_on = 1;
											break
								if(stay_on) g.microwave_field()
							usr.numbers_text = null
							view(6,usr) << "[usr] sets the microwaves to [n]"
							winset(usr,"numbers.input_number","text=")
							return
						if(usr.numbers_text == "fps player")
							if(n) if(n>10)
								usr.client.fps = n
								winset(usr,"settings_main.fps","text=\"[usr.client.fps]\"")
								usr.numbers_text = null
								winset(usr,"numbers.input_number","text=")
								usr << "Frames per second set to [n]"
								return
						if(usr.numbers_text == "blast spread")
							if(n >= 0 && n <= 4)
								usr.numbers_text = null
								for(var/obj/skills/Blast/b in usr)
									b.ki_spread = n
									usr << "[b] now has a spread of [n] tiles."
									return
						if(n < 0)
							usr.numbers_accessing = null
							return
				num_input
					icon_state = "num input"
					var/a = 1
					var/selecting = 0
					var/wid = 48 //How many pixels from the left side of the icon as a whole
					var/obj/menu
					maptext_x = 51
					maptext_y = 27
					input_type = "num"
					New()
						spawn(10)
							if(src)
								if(src.menu)
									var/mob/player
									if(ismob(src.menu.loc))
										player = src.menu.loc
									while(src)
										if(player && player.typing == src && src.select_started == 0)
											if(src.caret_pos == length("[src.string_full]")+1)
												if(a)
													src.maptext = "[css_outline]<font size = 1><left>[src.string_full]"
													a = 0
												else
													a = 1
													src.maptext = "[css_outline]<font size = 1><left>[src.string_full]"
										sleep(6)
					MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
						params = params2list(params)
						var/icon_x = text2num(params["icon-x"])
						var/L = usr.client.MeasureText("[src.maptext]")
						var/x_pos = findtext(L, "x")
						L = text2num(copytext(L, 1, x_pos))
						if(L <= 0)
							return
						var/L_C = length_char(src.string_full)
						var/pos = (icon_x-wid)/L
						pos = round(pos*L_C)
						pos = pos+1
						src.caret_pos = pos
						if(src.caret_pos > length(src.string_full)+1) src.caret_pos = length(src.string_full)+1
						if(src.select_started == 0)
							src.select_started = pos//+1
							//world << "DEBUG - Started selecting text at [pos]"
							src.selecting = 2
						else if(src.select_started > 0)
							src.select_end = pos-1
							//world << "DEBUG - Select start: [src.select_started], Select end: [src.select_end]"
							if(src.select_end > 0)
								//Now replace the text with a version that has a colored background. Swap them around if selecting from right to left
								if(src.select_started > src.select_end)
									src.string_selected = copytext(src.string_full,src.select_end,src.select_started+1)
									src.excluded_before = copytext(src.string_full, 1, src.select_end)
									src.excluded_after = copytext(src.string_full, src.select_started+1,0)
								else
									src.string_selected = copytext(src.string_full,src.select_started,src.select_end+1)
									src.excluded_before = copytext(src.string_full, 1, src.select_started)
									src.excluded_after = copytext(src.string_full, src.select_end+1,0)
								src.maptext = "[css_outline]<font size = 1><left>[src.excluded_before][css_background][src.string_selected]</span>[src.excluded_after]"
								//world << "DEBUG - Selected [src.string_selected]"
						return
					Click(location,control,params)
						// Track where player clicked on input box (icon_x)
						// Measure the maptext itself using MeasureText() (L)
						// Measure how many characters were in the text string (L_C)
						// Find the pos by taking icon_x and subtracting wid, which is how far the start of the text is from the left side of the icon
						// Then divide that result by the total pixel length of the text string (pos)
						// Then take pos and multply it by total characters in the string (L_C), and round the result, then add +1
						usr.typing = src
						src.selecting -= 1
						if(src.selecting < 0) src.selecting = 0
						if(src.selecting == 0)
							params = params2list(params)
							var/icon_x = text2num(params["icon-x"])
							var/L = usr.client.MeasureText("[src.maptext]")
							var/x_pos = findtext(L, "x")
							L = text2num(copytext(L, 1, x_pos))
							if(L <= 0)
								return
							var/L_C = length_char(src.string_full)
							var/pos = (icon_x-wid)/L
							pos = round(pos*L_C)
							pos = pos+1
							src.string_full = replacetext_char(src.string_full,"|","",1,0)
							src.caret_pos = pos
							if(src.caret_pos >= length(src.string_full)+1) src.caret_pos = length(src.string_full)+1
							// Combine the new strings with "|" in between.
							var/new_string = splicetext(src.string_full,src.caret_pos,src.caret_pos,"|")
							src.maptext = "[css_outline]<font size = 1><left>[new_string]"
							src.select_started = 0
							src.select_end += 0
							src.string_selected = ""
							src.excluded_before = ""
							src.excluded_after = ""
						return
			confirm_menu_background
				icon = 'new_hud_confirm.dmi'
				screen_loc = "1,1"
				maptext_width = 208
				maptext_height = 34
				maptext_x = 6
				maptext_y = 33
				plane = 37
				layer = 35
				var/hh = 0
				var/ww = 0
				proc
					confirm_text(var/show = 0,var/t,var/mob/m)
						if(show == 0)
							m.client.screen -= src
						else
							m.client.screen += src
						if(t) src.maptext = "[css_outline]<font size = 1><center>[t]"
				MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
					params = params2list(params)
					var/icon_y = text2num(params["icon-y"])
					if(icon_y >= 40 || usr.mouse_down)
						usr.client.MousePosition(params)
						var/matrix/m = matrix()
						var/icon_x = text2num(params["icon-x"])
						if(usr.drag_icon_x == 0) usr.drag_icon_x = icon_x
						var/x_result = usr.client.client_mouse_x-usr.drag_icon_x
						var/y_result = usr.client.client_mouse_y-src.hh
						x_result = clamp(x_result,0,1023-src.ww)
						y_result = clamp(y_result,0,575-(src.hh/2))
						m.Translate(x_result,y_result)
						src.transform = m
						usr.mouse_down = src
				New()
					var/matrix/m_main = matrix()
					m_main.Translate(416,256)
					src.transform = m_main

					var/icon/I = new(src.icon)
					src.ww = I.Width()
					src.hh = I.Height()

					var/obj/hud/menus/confirm_menu_background/confirm_tick/tick = new
					var/matrix/m1 = matrix()
					m1.Translate(74,8)
					tick.transform = m1
					src.vis_contents += tick

					var/obj/hud/menus/confirm_menu_background/confirm_cross/cross = new
					var/matrix/m2 = matrix()
					m2.Translate(132,8)
					cross.transform = m2
					src.vis_contents += cross
					..() // <-- THIS WAS NOT ALWAYS HERE, I ADDED THIS ON 4/5 12:15AM
					return
				confirm_cross
					icon = 'new_hud_tick_cross.dmi'
					icon_state = "cross"
					New()
						return
					MouseEntered()
						src.icon_state = "cross hover"
					MouseExited()
						src.icon_state = "cross"
					Click()
						if(usr.typing) return
						usr.hud_confirm.confirm_text(0,null,usr)
						usr.confirm = null
						usr.confirm_text = null
				confirm_tick
					icon = 'new_hud_tick_cross.dmi'
					icon_state = "tick"
					New()
						return
					MouseEntered()
						src.icon_state = "tick hover"
					MouseExited()
						src.icon_state = "tick"
					Click()
						if(usr.typing) return
						if(usr.confirm == null) return
						usr.hud_confirm.confirm_text(0,null,usr)
						if(usr.confirm == "confirm cybertech removal")
							if(usr.left_click_ref)
								if(istype(usr.left_click_ref,/obj/body_related/bodyparts/cybernetics/) == 1)
									var/obj/o = usr.left_click_ref.loc
									if(o.loc in usr.bodyparts)
										var/obj/body_related/bodyparts/limb = o
										var/obj/body_related/bodyparts/cybernetics/cyber = usr.left_click_ref
										limb.cybernetics_current -= 1
										for(var/c=1, c<limb.cybernetics.len, c++)
											if(limb.cybernetics[c] == cyber)
												limb.cybernetics[c] = null
												for(var/obj/hud/buttons/cybernetic_slot/cs in limb)
													if(cs.slot == c)
														cs.icon_state = "empty"
														cs.full = 0
														break
												break
										var/list/parts = list(cyber)
										usr.disable_parts(parts,0,1,0)
										parts = list(o)
										//usr.disable_parts(parts,0,1,1)
										usr.damage_limb(usr,0, 1, 100,o)
										usr.set_alert("[usr.left_click_ref] removed from [limb]",o.icon,o.icon_state)
										usr<<output("[usr.left_click_ref] removed from [limb].","actionoutput")
										cyber.loc = usr
										usr.pickup(cyber,1)
										usr.refresh_inv()
										usr.refresh_cyber(limb)
										//winshow(usr,"confirm",0)
										usr.hud_confirm.confirm_text(0,null,usr)
										cyber.desc = "Level: [cyber.level]/1000 \n[initial(cyber.info)]"
										usr.confirm = null
										usr.left_click_ref = null
										if(usr.client) winset(usr,"body.label_cyber","text=\"Cybernetic slots: [limb.cybernetics_current]/[limb.cybernetics_max]\"")

										return
						if(usr.confirm == "accept delete obj")
							var/obj/N = usr.left_click_ref
							view(10,usr)<<output("[N] was deleted.","actionoutput")
							N.destroy()
							N.loc = null
							usr.left_click_ref = null
							usr.left_click_function = null
							return
						if(usr.confirm == "accept delete mob")
							var/mob/N = usr.left_click_ref
							view(10,usr)<<output("[N] was deleted.","actionoutput")
							N.destroy()
							N.loc = null
							usr.left_click_ref = null
							usr.left_click_function = null
							return
						if(usr.confirm == "cancel char")
							//winshow(usr,"confirm",0)
							usr.hud_confirm.confirm_text(0,null,usr)
							return
						if(usr.confirm == "accept icon reset")
							usr.confirm = null
							usr.icon = usr.icon_original
							usr.hud_confirm.confirm_text(0,null,usr)
							//winshow(usr,"confirm",0)
							return
						if(usr.confirm == "accept teaching")
							usr.confirm = null
							if(usr.learning)
								var/obj/skills/s = usr.learning
								if(ismob(s.loc))
									var/mob/m = s.loc
									if(get_dist(usr,m) <= 8)

										for(var/obj/skills/sk in usr)
											/*if(!sk.can_teach)
												usr<<"You cannot teach this skill."
												usr.set_alert("You cannot teach this skill",s.icon,s.icon_state)
												return*/
											if(istype(sk,/obj/skills/Conceive_Offspring))
												usr<<"You cannot teach this skill."
												usr.set_alert("You cannot teach this skill",s.icon,s.icon_state)
												return
											if(sk.type == s.type)
												usr.set_alert("Already have skill",s.icon,s.icon_state)
												m.set_alert("They already have that skill",s.icon,s.icon_state)
												usr.learning = null
												//winshow(usr,"confirm",0)
												usr.hud_confirm.confirm_text(0,null,usr)
												return
										//winshow(usr,"confirm",0)
										for(var/mob/mm in view(20,usr))
											mm<<output("[mm.get_strangername(m)] taught [mm.get_strangername(usr)] [s]","actionoutput")
										usr.hud_confirm.confirm_text(0,null,usr)
										usr.taught_skill(m,s)
								usr.learning = null
							return
						if(usr.confirm == "accept icon")
							usr.confirm = null
							usr.icon = usr.icon_offered
							usr.icon_offered = null
							usr.hud_confirm.confirm_text(0,null,usr)
							return
						if(usr.confirm == "confirm save delete")
							if(usr.left_click_ref == null || isnum(usr.left_click_ref) == 0)
							//	world << "DEBUG - Error, player's left_click_ref was not a number."
								usr.confirm = null
								usr.hud_confirm.confirm_text(0,null,usr)
								usr.left_click_ref = null
								return
							if(usr.started)
							//	world << "DEBUG - Error, tried to delete save when already loaded into a character."
								usr.confirm = null
								usr.hud_confirm.confirm_text(0,null,usr)
								usr.left_click_ref = null
								return
							//if(fexists("saves/players/[usr.client.key]/[usr.client.key]_info.sav"))
							//	fdel("saves/players/[usr.client.key]/[usr.client.key]_info.sav")
							//if(fexists("saves/players/[usr.client.key]/[usr.client.key].sav"))
							//	fdel("saves/players/[usr.client.key]/[usr.client.key].sav")
							var/key = "[usr.key]"

							var/base_path = "saves/players/[key]/"
							var/main_path = "[base_path]sav[usr.left_click_ref].sav"
							var/backup_path = "[base_path]sav[usr.left_click_ref]_backup.sav"
							var/info_path = "[base_path][key]_info.sav"

							if(fexists(main_path))
								fdel(main_path)

								if(fexists(backup_path))
									fdel(backup_path)

								if(fexists(info_path))
									fdel(info_path)

								usr.confirm = null
								usr.hud_confirm.confirm_text(0,null,usr)
								var/obj/hud/menus/load_background/load_menu = usr.hud_load
								if(usr.left_click_ref == 1)
									load_menu.vis_contents -= load_menu.port1
									load_menu.but_new_01.maptext = "[css_outline]<font size = 1><center>New"
									load_menu.vis_contents -= load_menu.but_del_01
									load_menu.vis_contents -= load_menu.sav_txt1
								else if(usr.left_click_ref == 2)
									load_menu.vis_contents -= load_menu.port2
									load_menu.but_new_02.maptext = "[css_outline]<font size = 1><center>New"
									load_menu.vis_contents -= load_menu.but_del_02
									load_menu.vis_contents -= load_menu.sav_txt2
								else if(usr.left_click_ref == 3)
									load_menu.vis_contents -= load_menu.port3
									load_menu.but_new_03.maptext = "[css_outline]<font size = 1><center>New"
									load_menu.vis_contents -= load_menu.but_del_03
									load_menu.vis_contents -= load_menu.sav_txt3
								global.names_taken -= usr.sav_names[usr.left_click_ref]
								usr.sav[usr.left_click_ref] = null
								usr.sav_names[usr.left_click_ref] = null
								usr.sav_races[usr.left_click_ref] = null
								usr.byond_key = usr.key
								usr.key_save()
								usr.left_click_ref = null
								return
							else
								usr.hud_confirm.confirm_text(0,null,usr)
								return
					/*	if(usr.confirm == "logout")
							//winshow(usr,"confirm",0)
							//usr.key_save()
							usr.client.images = null
							usr.hud_confirm.confirm_text(0,null,usr)
							usr.remove_player_blip()
							if(usr.origin && istype(usr.origin,/obj/origins/chosen_one)) chosen_ones -= 1
							for(var/mob/z in players)
								if(z.target == usr) z.add_remove_target(usr,1)
							if(usr.target) usr.add_remove_target(usr.target,1)
							var/mob/m = new
							m.loc = locate(250,250,2)
							for(var/obj/o in usr.client.screen)
								usr.client.screen -= o
							for(var/mob/x in usr.client.screen)
								usr.client.screen -= x
							winshow(usr,"chat",0)
							winshow(usr,"options",0)
							m.key = usr.key
							return */
						if(usr.confirm == "quit game")
							usr.client.images = null
							winset(usr, null, "command=.quit")
							usr.client.Del()

							return
						if(usr.can_save == 1) return
						if(usr.confirm == "confirm char")
							if(usr.started) return

							usr.confirm = null
							usr.confirm_text = null
							winset(usr,"map.map","focus=true")
							//winshow(usr,"confirm",0)
							usr.hud_confirm.confirm_text(0,null,usr)
							winshow(usr,"char_creation",0)
							usr.client.screen -= usr.hud_char
							usr.confirm_new_character()
							usr.client.eye = usr
							usr.save_portrait_icon()
			info_txt_box
				icon = 'new_hud_info_box.dmi'
			char_creation_background
				//+62 pixels after shifting/re-design menus.
				//+35 pixels for menu contents
				//+32 on menu lore/pros/cons
				icon = 'new_hud_char_creation4.dmi'
				icon_state = "main"
				layer = 33
				screen_loc = "CENTER-10,BOTTOM+10"
				//screen_loc = "8,1:7"
				plane = 24
				var/clicked = 0
				var/og_state = null
				var/list/race_buttons = list()
				var/list/stat_buttons = list()
				var/obj/hud/menus/char_creation_background/menu
				var/obj/text_bodysize
				var/obj/num_psi
				var/obj/num_eng
				var/obj/num_str
				var/obj/num_end
				var/obj/num_res
				var/obj/num_for
				var/obj/num_off
				var/obj/num_def
				var/obj/num_regen
				var/obj/num_recov
				var/obj/num_agi
				var/arrow_tag
				var/setup = 0
				var/obj/pro_txt_holder = null
				var/obj/pro_txt = null
				var/obj/con_txt_holder = null
				var/obj/con_txt = null
				var/obj/lore_txt_holder = null
				var/obj/origins_txt_holder = null
				var/obj/ages_txt_holder = null
				var/obj/ages_desc_txt = null
				//var/obj/origins_desc_txt_holder = null
				var/obj/lore_txt = null
				//var/obj/origins_txt = null
				//var/obj/origins_desc_txt = null
				var/obj/scrollbar_pro = null
				var/obj/scrollbar_con = null
				var/obj/scrollbar_lore = null
				var/obj/scrollbar_origins = null
				var/obj/scrollbar_origins_desc = null
				var/obj/scroller_lore = null
				var/obj/scroller_origins = null
				var/obj/scroller_origins_desc = null
				var/obj/scroller_pro = null
				var/obj/scroller_con = null
				var/obj/avatar = null
				var/obj/avatar_holder = null
				var/obj/name_input = null
				var/obj/points = null
				//New()
					//src.ScaleInterface(1.1)
				//	src.ScaleBackground(1.25, 1.25)
				proc
					ScaleInterface(var/scale = 1.0)
					// scale affects entire UI, including vis_contents
						var/matrix/m = matrix()
						m.Scale(scale, scale)

						// Adjust translation so scaling is centered properly
						// Tune these offsets for perfect alignment
						var/shift_x = (scale - 1) * -120
						var/shift_y = (scale - 1) * -70
						m.Translate(shift_x, shift_y)

						src.transform = m
					ScaleBackground(var/scale_x = 1, var/scale_y = 1, var/center = 1)
					// scale_x / scale_y define how much to enlarge
						// center=1 recenters scaling around the middle of the screen
						var/matrix/m = matrix()
						m.Scale(scale_x, scale_y)

						if(center)
							// Adjust so scaling grows from the center rather than top-left
							var/shift_x = (scale_x - 1) * 240 // adjust if your art width ≠ 480px
							var/shift_y = (scale_y - 1) * 135 // adjust if your art height ≠ 270px
							m.Translate(-shift_x, -shift_y)

						src.transform = m
					reset_bars()
						//Resets all the scrollers back to default
						var/matrix/s1 = matrix()
						s1.Translate(0,0)
						scroller_origins.transform = s1
						scroller_origins.translated_y = 0

						var/matrix/s2 = matrix()
						s2.Translate(0,0)
						scroller_lore.transform = s2
						scroller_lore.translated_y = 0

						var/matrix/s3 = matrix()
						s3.Translate(0,0)
						scroller_origins_desc.transform = s3
						scroller_origins_desc.translated_y = 0
						//Resets all the text visuals back to default
						/*for(var/obj/txt in src.origins_txt_holder.vis_contents)
							var/matrix/m = matrix()
							m.Translate(txt.hud_x,txt.hud_y)
							txt.transform = m*/
						for(var/obj/txt in src.lore_txt_holder.vis_contents)
							var/matrix/m = matrix()
							m.Translate(txt.hud_x,txt.hud_y)
							txt.transform = m
						/*for(var/obj/txt in src.origins_desc_txt_holder.vis_contents)
							var/matrix/m = matrix()
							m.Translate(txt.hud_x,txt.hud_y)
							txt.transform = m*/
					menu_avatar()
						//Make sure menu is sitting inside player.
						var/mob/player = src.loc
						//player.render_target = "*player [player.name]"
						if(player.race == "Celestial")
							player.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=1, color=rgb(102,204,255))
						//	spawn(20)
							//	if(src && player) player.Celestial_Wings()

						//Adjust the menu's avatar based on the players selected race.
						var/obj/ava = src.avatar
						//ava.render_source = "*player [player.name]"
						ava.plane = 24
						ava.layer = 34
						var/t = ava.transform
						//player.plane = 24
						//player.layer = 34
						src.avatar_holder.vis_contents = null
						src.avatar_holder.vis_contents += player
						player.transform = t

					clear_portrait_vis()
						var/mob/player = src.loc
						if(player.port)
							src.vis_contents -= player.port
						if(player.babyport)
							src.vis_contents -= player.babyport
					update_portrait_transform()
						var/mob/player = src.loc
						for(var/mob/m in src.vis_contents)
							src.vis_contents -= m
						if(player.port)
							src.vis_contents -= player.port
							src.vis_contents += player.port
							var/matrix/m = matrix()
							m.Translate(42,454)
							player.port.transform = m
							if(player.hud_hud)
								player.hud_hud.filters = null
								if(player.race == "Celestial")
									player.hud_hud.filters += filter(type="outline",size=1, color=rgb(102,204,255))
									player.hud_hud.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(102,204,255))
						if(player.babyport)
							src.vis_contents -= player.babyport
							src.vis_contents += player.babyport
							var/matrix/m = matrix()
							m.Translate(42,454)
							player.babyport.transform = m
					switch_buttons()
						var/obj/hud/menus/char_creation_background/m = src.menu
						for(var/obj/hud/menus/char_creation_background/b in m.race_buttons)
							b.clicked = 0
							b.icon_state = b.og_state
						if(ismob(m.loc))
							var/mob/player = m.loc
							//m.num_psi.maptext = "[css_outline]<font size = 1><center>[player.mod_psionic_power]"
							m.num_eng.maptext = "[css_outline]<font size = 1><center>[player.mod_energy_points]"
							m.num_str.maptext = "[css_outline]<font size = 1><center>[player.mod_strength_points]"
							m.num_end.maptext = "[css_outline]<font size = 1><center>[player.mod_endurance_points]"
							m.num_res.maptext = "[css_outline]<font size = 1><center>[player.mod_resistance_points]"
							m.num_for.maptext = "[css_outline]<font size = 1><center>[player.mod_force_points]"
							m.num_off.maptext = "[css_outline]<font size = 1><center>[player.mod_offence_points]"
							m.num_def.maptext = "[css_outline]<font size = 1><center>[player.mod_defence_points]"
							m.num_regen.maptext = "[css_outline]<font size = 1><center>[player.mod_regeneration_points]"
							m.num_recov.maptext = "[css_outline]<font size = 1><center>[player.mod_recovery_points]"
							m.num_agi.maptext = "[css_outline]<font size = 1><center>[player.mod_agility_points]"
							if(player.bodysize == 3) m.text_bodysize.maptext = "[css_outline]<font size=1><center>Large"
							if(player.bodysize == 2)  m.text_bodysize.maptext = "[css_outline]<font size=1><center>Medium"
							if(player.bodysize == 1)  m.text_bodysize.maptext = "[css_outline]<font size=1><center>Small"
							if(player.hud_char)
								var/obj/p = player.hud_char.points
								p.maptext = "[css_outline]<font size = 1><center>[player.mod_points]"
					menu_create()
						spawn(6)
							if(src)
								if(src.setup)
									return
								else
									src.setup = 1

									//var/mob/player = null
									if(ismob(src.loc))
										src.update_portrait_transform()
										//player = src.loc
									else
										src.destroy()
										return

									var/obj/hud/menus/char_creation_background/char_name_input/input = new
									input.menu = src
									src.vis_contents += input
									src.name_input = input

									var/obj/hud/menus/char_creation_background/char_confirm_button/confirm = new
									confirm.menu = src
									src.vis_contents += confirm

									var/obj/hud/menus/char_creation_background/char_avatar_holder/ava_holder = new
									ava_holder.menu = src
									src.vis_contents += ava_holder
									src.avatar_holder = ava_holder

									var/obj/ava = new
									ava.icon = 'NewMalesWhite(faceless).dmi'
									ava.hud_x = 180
									ava.hud_y = 484
									ava.layer = 33
									ava.plane = 24
									ava.blend_mode = BLEND_INSET_OVERLAY
									ava.appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
									var/matrix/av_m1 = matrix()
									av_m1.Translate(ava.hud_x,ava.hud_y)
									ava.transform = av_m1
									ava_holder.vis_contents += ava
									src.avatar = ava

									var/obj/hud/menus/char_creation_background/char_lore_txt/lore_t = new
									lore_t.hud_x = 46
									lore_t.hud_y = -380
									var/matrix/t_m1 = matrix()
									t_m1.Translate(lore_t.hud_x,lore_t.hud_y)
									lore_t.transform = t_m1
									lore_t.menu = src
									src.lore_txt = lore_t

									var/obj/hud/menus/char_creation_background/char_lore_txt_holder/lore_t_h = new
									lore_t_h.menu = src
									lore_t_h.vis_contents += lore_t
									src.vis_contents += lore_t_h
									src.lore_txt_holder = lore_t_h


									/*var/obj/hud/menus/char_creation_background/char_origins_txt/origins_t = new
									origins_t.hud_x = 404
									origins_t.hud_y = 516
									var/matrix/t_m3 = matrix()
									t_m3.Translate(origins_t.hud_x,origins_t.hud_y)
									origins_t.transform = t_m3
									origins_t.menu = src
									src.origins_txt = origins_t*/

									/*var/obj/hud/menus/char_creation_background/char_origins_txt_holder/origins_t_h = new
									origins_t_h.menu = src
									//origins_t_h.vis_contents += ages_t
									src.vis_contents += origins_t_h
									src.origins_txt_holder = origins_t_h*/

									var/obj/hud/menus/char_creation_background/char_ages_desc_txt/ages_desc_t = new
									ages_desc_t.hud_x = 392
									ages_desc_t.hud_y = -380
									var/matrix/t_m5 = matrix()
									t_m5.Translate(ages_desc_t.hud_x,ages_desc_t.hud_y)
									ages_desc_t.transform = t_m5
									ages_desc_t.menu = src
									src.ages_desc_txt = ages_desc_t

								/*	var/obj/hud/menus/char_creation_background/char_ages_desc_txt_holder/ages_desc_t_h = new
									ages_desc_t_h.menu = src
									//ages_desc_t_h.vis_contents += ages_desc_t
									src.vis_contents += ages_desc_t_h
									src.ages_desc_txt_holder = ages_desc_t_h*/

									var/obj/hud/menus/char_creation_background/char_pro_txt/pros_txt = new
									pros_txt.hud_x = 43
									pros_txt.hud_y = -198
									var/matrix/t_m6 = matrix()
									t_m6.Translate(pros_txt.hud_x,pros_txt.hud_y)
									pros_txt.transform = t_m6
									pros_txt.menu = src
									src.pro_txt = pros_txt

									var/obj/hud/menus/char_creation_background/char_pro_holder/pros_txt_h = new
									pros_txt_h.menu = src
									pros_txt_h.vis_contents += pros_txt
									src.vis_contents += pros_txt_h
									src.pro_txt_holder = pros_txt_h

									var/obj/hud/menus/char_creation_background/char_con_txt/cons_txt = new
									cons_txt.hud_x = 217
									cons_txt.hud_y = -198
									var/matrix/t_m7 = matrix()
									t_m7.Translate(cons_txt.hud_x,cons_txt.hud_y)
									cons_txt.transform = t_m7
									cons_txt.menu = src
									src.con_txt = cons_txt

									var/obj/hud/menus/char_creation_background/char_con_holder/cons_txt_h = new
									cons_txt_h.menu = src
									cons_txt_h.vis_contents += cons_txt
									src.vis_contents += cons_txt_h
									src.con_txt_holder = cons_txt_h



								/*	var/obj/hud/menus/char_creation_background/char_ages_adult_txt/ages_t = new
									ages_t.hud_x = 404
									ages_t.hud_y = 516
									var/matrix/t_m3 = matrix()
									t_m3.Translate(ages_t.hud_x,ages_t.hud_y)
									ages_t.transform = t_m3
									ages_t.menu = src
									src.ages_txt = ages_t */

									var/obj/ages/adult/ages_t_h = new
									//var/obj/hud/menus/char_creation_background/char_ages_adult_txt_holder/ages_t_h = new
									ages_t_h.hud_x = 443
									ages_t_h.hud_y = 470
									var/matrix/t_m4 = matrix()
									t_m4.Translate(ages_t_h.hud_x,ages_t_h.hud_y)
									ages_t_h.transform = t_m4
									//ages_t_h.menu = src
									//ages_t_h.vis_contents += ages_t
									src.vis_contents += ages_t_h
									src.ages_txt_holder = ages_t_h

									var/obj/ages/teen/ages_ta_h = new
									//var/obj/hud/menus/char_creation_background/char_ages_adult_txt_holder/ages_t_h = new
									ages_ta_h.hud_x = 443
									ages_ta_h.hud_y = 420
									var/matrix/t_m44 = matrix()
									t_m44.Translate(ages_ta_h.hud_x,ages_ta_h.hud_y)
									ages_ta_h.transform = t_m44
									//ages_t_h.menu = src
									//ages_t_h.vis_contents += ages_t
									src.vis_contents += ages_ta_h
									src.ages_txt_holder = ages_ta_h

									var/obj/ages/kid/ages_tk_h = new
									//var/obj/hud/menus/char_creation_background/char_ages_adult_txt_holder/ages_t_h = new
									ages_tk_h.hud_x = 443
									ages_tk_h.hud_y = 380
									var/matrix/t_m55 = matrix()
									t_m55.Translate(ages_tk_h.hud_x,ages_tk_h.hud_y)
									ages_tk_h.transform = t_m55
									//ages_t_h.menu = src
									//ages_t_h.vis_contents += ages_t
									src.vis_contents += ages_tk_h
									src.ages_txt_holder = ages_tk_h

									var/obj/ages/baby/ages_tb_h = new
									//var/obj/hud/menus/char_creation_background/char_ages_adult_txt_holder/ages_t_h = new
									ages_tb_h.hud_x = 443
									ages_tb_h.hud_y = 330
									var/matrix/t_m66 = matrix()
									t_m66.Translate(ages_tb_h.hud_x,ages_tb_h.hud_y)
									ages_tb_h.transform = t_m66
									//ages_t_h.menu = src
									//ages_t_h.vis_contents += ages_t
									src.vis_contents += ages_tb_h
									src.ages_txt_holder = ages_tb_h

									/*
									var/obj/origin_title = new
									origin_title.maptext_width = 128
									origin_title.maptext_height = 32
									origin_title.maptext = "[css_outline]<font size = 1><u>Origins</u>"
									var/matrix/m_txt = matrix()
									origin_title.hud_x = 256
									origin_title.hud_y = -105
									m_txt.Translate(origin_title.hud_x,origin_title.hud_y)
									origin_title.transform = m_txt
									src.vis_contents += origin_title
									*/

									var/obj/hud/menus/char_creation_background/scrollbar_lore/sb1 = new
									sb1.menu = src
									src.vis_contents += sb1
									src.scrollbar_lore = sb1

									var/obj/hud/menus/char_creation_background/scrollbar_origins/sb2 = new
									sb2.menu = src
									src.vis_contents += sb2
									src.scrollbar_origins = sb2

									var/obj/hud/menus/char_creation_background/scrollbar_origins_desc/sb3 = new
									sb3.menu = src
									src.vis_contents += sb3
									src.scrollbar_origins_desc = sb3

									var/obj/hud/menus/char_creation_background/scrollbar_pro/sb4 = new
									sb4.menu = src
									src.vis_contents += sb4
									src.scrollbar_pro = sb4

									var/obj/hud/menus/char_creation_background/scrollbar_con/sb5 = new
									sb5.menu = src
									src.vis_contents += sb5
									src.scrollbar_con = sb5

									var/obj/hud/menus/char_creation_background/scroller_lore/s1 = new
									s1.menu = src
									src.vis_contents += s1
									src.scroller_lore = s1

									var/obj/hud/menus/char_creation_background/scroller_origins/s2 = new
									s2.menu = src
									src.vis_contents += s2
									src.scroller_origins = s2

									var/obj/hud/menus/char_creation_background/scroller_origins_desc/s3 = new
									s3.menu = src
									src.vis_contents += s3
									src.scroller_origins_desc = s3

									var/obj/hud/menus/char_creation_background/scroller_pro/s4 = new
									s4.menu = src
									src.vis_contents += s4
									src.scroller_pro = s4

									//var/obj/hud/menus/char_creation_background/scroller_con/s5 = new
								//	s5.menu = src
									//src.vis_contents += s5
								//	src.scroller_con = s5

									var/obj/hud/menus/char_creation_background/race_button_newborn/r001 = new
									var/matrix/m001 = matrix()
									m001.Translate(r001.hud_x,r001.hud_y)
									r001.transform = m001
									r001.clicked = 1
									r001.menu = src
									src.vis_contents += r001
									src.race_buttons += r001

									var/obj/hud/menus/char_creation_background/race_button_human/r1 = new
									var/matrix/m1 = matrix()
									m1.Translate(r1.hud_x,r1.hud_y)
									r1.transform = m1
									r1.clicked = 1
									r1.menu = src
									src.vis_contents += r1
									src.race_buttons += r1

									var/obj/hud/menus/char_creation_background/race_button_demon/r2 = new
									var/matrix/m2 = matrix()
									m2.Translate(r2.hud_x,r2.hud_y)
									r2.transform = m2
									r2.menu = src
									src.vis_contents += r2
									src.race_buttons += r2


									var/obj/hud/menus/char_creation_background/race_button_celestial/r3 = new
									var/matrix/m3 = matrix()
									m3.Translate(r3.hud_x,r3.hud_y)
									r3.transform = m3
									r3.menu = src
									src.vis_contents += r3
									src.race_buttons += r3

									var/obj/hud/menus/char_creation_background/race_button_imp/r4 = new
									var/matrix/m4 = matrix()
									m4.Translate(r4.hud_x,r4.hud_y)
									r4.transform = m4
									r4.menu = src
									src.vis_contents += r4
									src.race_buttons += r4

									var/obj/hud/menus/char_creation_background/race_button_cerebroid/r5 = new
									var/matrix/m5 = matrix()
									m5.Translate(r5.hud_x,r5.hud_y)
									r5.transform = m5
									r5.menu = src
									src.vis_contents += r5
									src.race_buttons += r5

									var/obj/hud/menus/char_creation_background/race_button_saiyan/r6 = new
									var/matrix/m6 = matrix()
									m6.Translate(r6.hud_x,r6.hud_y)
									r6.transform = m6
									r6.menu = src
									src.vis_contents += r6
									src.race_buttons += r6

									var/obj/hud/menus/char_creation_background/race_button_yukopian/r7 = new
									var/matrix/m7 = matrix()
									m7.Translate(r7.hud_x,r7.hud_y)
									r7.transform = m7
									r7.menu = src
									src.vis_contents += r7
									src.race_buttons += r7

									var/obj/hud/menus/char_creation_background/race_button_doll/r8 = new
									var/matrix/m8 = matrix()
									m8.Translate(r8.hud_x,r8.hud_y)
									r8.transform = m8
									r8.menu = src
									src.vis_contents += r8
									src.race_buttons += r8

									var/obj/hud/menus/char_creation_background/race_button_makyo/r9 = new
									var/matrix/m9 = matrix()
									m9.Translate(r9.hud_x,r9.hud_y)
									r9.transform = m9
									r9.menu = src
									src.vis_contents += r9
									src.race_buttons += r9

									//var/obj/hud/menus/char_creation_background/race_button_halfgod/r10 = new
								//	var/matrix/m10 = matrix()
								//	m10.Translate(r10.hud_x,r10.hud_y)
								//	r10.transform = m10
								//	r10.menu = src
								//	src.vis_contents += r10
								//	src.race_buttons += r10

									var/obj/hud/menus/char_creation_background/race_button_tuffle/r11 = new
									var/matrix/m11 = matrix()
									m11.Translate(r11.hud_x,r11.hud_y)
									r11.transform = m11
									r11.menu = src
									src.vis_contents += r11
									src.race_buttons += r11

									var/obj/hud/menus/char_creation_background/race_button_ling/r12 = new
									var/matrix/m12 = matrix()
									m12.Translate(r12.hud_x,r12.hud_y)
									r12.transform = m12
									r12.menu = src
									src.vis_contents += r12
									src.race_buttons += r12

									/*
									var/obj/hud/menus/char_creation_background/race_button_blank/r8 = new
									var/matrix/m8 = matrix()
									m8.Translate(r8.hud_x,r8.hud_y)
									r8.transform = m8
									r8.menu = src
									src.vis_contents += r8
									src.race_buttons += r8

									var/obj/hud/menus/char_creation_background/race_button_blank/r9 = new
									r9.hud_y = 248
									var/matrix/m9 = matrix()
									m9.Translate(r9.hud_x,r9.hud_y)
									r9.transform = m9
									r9.menu = src
									src.vis_contents += r9
									src.race_buttons += r9

									var/obj/hud/menus/char_creation_background/race_button_blank/r10 = new
									r10.hud_y = 215
									var/matrix/m10 = matrix()
									m10.Translate(r10.hud_x,r10.hud_y)
									r10.transform = m10
									r10.menu = src
									src.vis_contents += r10
									src.race_buttons += r10

									var/obj/hud/menus/char_creation_background/race_button_blank/r11 = new
									r11.hud_y = 182
									var/matrix/m11 = matrix()
									m11.Translate(r11.hud_x,r11.hud_y)
									r11.transform = m11
									r11.menu = src
									src.vis_contents += r11
									src.race_buttons += r11

									var/obj/hud/menus/char_creation_background/race_button_blank/r12 = new
									r12.hud_y = 149
									var/matrix/m12 = matrix()
									m12.Translate(r12.hud_x,r12.hud_y)
									r12.transform = m12
									r12.menu = src
									src.vis_contents += r12
									src.race_buttons += r12

									var/obj/hud/menus/char_creation_background/race_button_blank/r13 = new
									r13.hud_y = 116
									var/matrix/m13 = matrix()
									m13.Translate(r13.hud_x,r13.hud_y)
									r13.transform = m13
									r13.menu = src
									src.vis_contents += r13
									src.race_buttons += r13

									var/obj/hud/menus/char_creation_background/race_button_blank/r14 = new
									r14.hud_y = 83
									var/matrix/m14 = matrix()
									m14.Translate(r14.hud_x,r14.hud_y)
									r14.transform = m14
									r14.menu = src
									src.vis_contents += r14
									src.race_buttons += r14

									var/obj/hud/menus/char_creation_background/race_button_blank/r15 = new
									r15.hud_y = 50
									var/matrix/m15 = matrix()
									m15.Translate(r15.hud_x,r15.hud_y)
									r15.transform = m15
									r15.menu = src
									src.vis_contents += r15
									src.race_buttons += r15

									var/obj/hud/menus/char_creation_background/race_button_blank/r16 = new
									r16.hud_y = 17
									var/matrix/m16 = matrix()
									m16.Translate(r16.hud_x,r16.hud_y)
									r16.transform = m16
									r16.menu = src
									src.vis_contents += r16
									src.race_buttons += r16
									*/

									//LOOKS ARROWS START

									//20 PIXEL Y GAP FOR LOOKS CUSTOMIZATION
									var/obj/hud/menus/char_creation_background/arrow_left/A1 = new
									var/matrix/a_m1 = matrix()
									A1.hud_x = 30
									A1.hud_y = 430
									a_m1.Translate(A1.hud_x,A1.hud_y)
									A1.transform = a_m1
									A1.menu = src
									A1.arrow_tag = "hair minus"
									src.vis_contents += A1
									src.stat_buttons += A1

									var/obj/hud/menus/char_creation_background/arrow_right/A2 = new
									var/matrix/a_m2 = matrix()
									A2.hud_x = 94
									A2.hud_y = 430
									a_m2.Translate(A2.hud_x,A2.hud_y)
									A2.transform = a_m2
									A2.menu = src
									A2.arrow_tag = "hair add"
									src.vis_contents += A2
									src.stat_buttons += A2

									var/obj/hud/menus/char_creation_background/arrow_left/A3 = new
									var/matrix/a_m3 = matrix()
									A3.hud_x = 30
									A3.hud_y = 410
									a_m3.Translate(A3.hud_x,A3.hud_y)
									A3.transform = a_m3
									A3.menu = src
									A3.arrow_tag = "skin minus"
									src.vis_contents += A3
									src.stat_buttons += A3

									var/obj/hud/menus/char_creation_background/arrow_right/A4 = new
									var/matrix/a_m4 = matrix()
									A4.hud_x = 94
									A4.hud_y = 410
									a_m4.Translate(A4.hud_x,A4.hud_y)
									A4.transform = a_m4
									A4.menu = src
									A4.arrow_tag = "skin add"
									src.vis_contents += A4
									src.stat_buttons += A4

									var/obj/hud/menus/char_creation_background/arrow_left/A5 = new
									var/matrix/a_m5 = matrix()
									A5.hud_x = 30
									A5.hud_y = 390
									a_m5.Translate(A5.hud_x,A5.hud_y)
									A5.transform = a_m5
									A5.menu = src
									A5.arrow_tag = "sex minus"
									src.vis_contents += A5
									src.stat_buttons += A5

									var/obj/hud/menus/char_creation_background/arrow_right/A6 = new
									var/matrix/a_m6 = matrix()
									A6.hud_x = 94
									A6.hud_y = 390
									a_m6.Translate(A6.hud_x,A6.hud_y)
									A6.transform = a_m6
									A6.menu = src
									A6.arrow_tag = "sex add"
									src.vis_contents += A6
									src.stat_buttons += A6

									var/obj/hud/menus/char_creation_background/arrow_left/A7 = new
									var/matrix/a_m7 = matrix()
									A7.hud_x = 30
									A7.hud_y = 370
									a_m7.Translate(A7.hud_x,A7.hud_y)
									A7.transform = a_m7
									A7.menu = src
									A7.arrow_tag = "eyes minus"
									src.vis_contents += A7
									src.stat_buttons += A7

									var/obj/hud/menus/char_creation_background/arrow_right/A8 = new
									var/matrix/a_m8 = matrix()
									A8.hud_x = 94
									A8.hud_y = 370
									a_m8.Translate(A8.hud_x,A8.hud_y)
									A8.transform = a_m8
									A8.menu = src
									A8.arrow_tag = "eyes add"
									src.vis_contents += A8
									src.stat_buttons += A8

									var/obj/hud/menus/char_creation_background/arrow_left/A9 = new
									var/matrix/a_m9 = matrix()
									A9.hud_x = 30
									A9.hud_y = 350
									a_m9.Translate(A9.hud_x,A9.hud_y)
									A9.transform = a_m9
									A9.menu = src
									A9.arrow_tag = "nose minus"
									src.vis_contents += A9
									src.stat_buttons += A9

									var/obj/hud/menus/char_creation_background/arrow_right/A10 = new
									var/matrix/a_m10 = matrix()
									A10.hud_x = 94
									A10.hud_y = 350
									a_m10.Translate(A10.hud_x,A10.hud_y)
									A10.transform = a_m10
									A10.menu = src
									A10.arrow_tag = "nose add"
									src.vis_contents += A10
									src.stat_buttons += A10

									var/obj/hud/menus/char_creation_background/arrow_left/A11 = new
									var/matrix/a_m11 = matrix()
									A11.hud_x = 30
									A11.hud_y = 330
									a_m11.Translate(A11.hud_x,A11.hud_y)
									A11.transform = a_m11
									A11.menu = src
									A11.arrow_tag = "mouth minus"
									src.vis_contents += A11
									src.stat_buttons += A11

									var/obj/hud/menus/char_creation_background/arrow_right/A12 = new
									var/matrix/a_m12 = matrix()
									A12.hud_x = 94
									A12.hud_y = 330
									a_m12.Translate(A12.hud_x,A12.hud_y)
									A12.transform = a_m12
									A12.menu = src
									A12.arrow_tag = "mouth add"
									src.vis_contents += A12
									src.stat_buttons += A12

									var/obj/hud/menus/char_creation_background/arrow_left/A33 = new
									var/matrix/a_m33 = matrix()
									A33.hud_x = 30
									A33.hud_y = 310
									a_m33.Translate(A33.hud_x,A33.hud_y)
									A33.transform = a_m33
									A33.menu = src
									A33.arrow_tag = "body minus"
									src.vis_contents += A33
									src.stat_buttons += A33

									var/obj/hud/menus/char_creation_background/arrow_right/A34 = new
									var/matrix/a_m34 = matrix()
									A34.hud_x = 94
									A34.hud_y = 310
									a_m34.Translate(A34.hud_x,A34.hud_y)
									A34.transform = a_m34
									A34.menu = src
									A34.arrow_tag = "body add"
									src.vis_contents += A34
									src.stat_buttons += A34
									//LOOKS ARROWS END

									//STAT ARROWS

									//34 PIXEL Y GAP
									var/obj/hud/menus/char_creation_background/arrow_left/A13 = new
									var/matrix/a_m13 = matrix()
									A13.hud_x = 163
									A13.hud_y = 426
									a_m13.Translate(A13.hud_x,A13.hud_y)
									A13.transform = a_m13
									A13.menu = src
									A13.arrow_tag = "strength minus"
									src.vis_contents += A13
									src.stat_buttons += A13

									var/obj/hud/menus/char_creation_background/arrow_right/A14 = new
									var/matrix/a_m14 = matrix()
									A14.hud_x = 207
									A14.hud_y = 426
									a_m14.Translate(A14.hud_x,A14.hud_y)
									A14.transform = a_m14
									A14.menu = src
									A14.arrow_tag = "strength add"
									src.vis_contents += A14
									src.stat_buttons += A14

									var/obj/hud/menus/char_creation_background/arrow_left/A15 = new
									var/matrix/a_m15 = matrix()
									A15.hud_x = 257
									A15.hud_y = 426
									a_m15.Translate(A15.hud_x,A15.hud_y)
									A15.transform = a_m15
									A15.menu = src
									A15.arrow_tag = "energy minus"
									src.vis_contents += A15
									src.stat_buttons += A15

									var/obj/hud/menus/char_creation_background/arrow_right/A16 = new
									var/matrix/a_m16 = matrix()
									A16.hud_x = 301
									A16.hud_y = 426
									a_m16.Translate(A16.hud_x,A16.hud_y)
									A16.transform = a_m16
									A16.menu = src
									A16.arrow_tag = "energy add"
									src.vis_contents += A16
									src.stat_buttons += A16

									var/obj/hud/menus/char_creation_background/arrow_left/A17 = new
									var/matrix/a_m17 = matrix()
									A17.hud_x = 257
									A17.hud_y = 392
									a_m17.Translate(A17.hud_x,A17.hud_y)
									A17.transform = a_m17
									A17.menu = src
									A17.arrow_tag = "agility minus"
									src.vis_contents += A17
									src.stat_buttons += A17

									var/obj/hud/menus/char_creation_background/arrow_right/A18 = new
									var/matrix/a_m18 = matrix()
									A18.hud_x = 301
									A18.hud_y = 392
									a_m18.Translate(A18.hud_x,A18.hud_y)
									A18.transform = a_m18
									A18.menu = src
									A18.arrow_tag = "agility add"
									src.vis_contents += A18
									src.stat_buttons += A18

									var/obj/hud/menus/char_creation_background/arrow_left/A19 = new
									var/matrix/a_m19 = matrix()
									A19.hud_x = 163
									A19.hud_y = 392
									a_m19.Translate(A19.hud_x,A19.hud_y)
									A19.transform = a_m19
									A19.menu = src
									A19.arrow_tag = "endurance minus"
									src.vis_contents += A19
									src.stat_buttons += A19

									var/obj/hud/menus/char_creation_background/arrow_right/A20 = new
									var/matrix/a_m20 = matrix()
									A20.hud_x = 207
									A20.hud_y = 392
									a_m20.Translate(A20.hud_x,A20.hud_y)
									A20.transform = a_m20
									A20.menu = src
									A20.arrow_tag = "endurance add"
									src.vis_contents += A20
									src.stat_buttons += A20

									var/obj/hud/menus/char_creation_background/arrow_left/A21 = new
									var/matrix/a_m21 = matrix()
									A21.hud_x = 163
									A21.hud_y = 358
									a_m21.Translate(A21.hud_x,A21.hud_y)
									A21.transform = a_m21
									A21.menu = src
									A21.arrow_tag = "force minus"
									src.vis_contents += A21
									src.stat_buttons += A21

									var/obj/hud/menus/char_creation_background/arrow_right/A22 = new
									var/matrix/a_m22 = matrix()
									A22.hud_x = 207
									A22.hud_y = 358
									a_m22.Translate(A22.hud_x,A22.hud_y)
									A22.transform = a_m22
									A22.menu = src
									A22.arrow_tag = "force add"
									src.vis_contents += A22
									src.stat_buttons += A22

									var/obj/hud/menus/char_creation_background/arrow_left/A23 = new
									var/matrix/a_m23 = matrix()
									A23.hud_x = 257
									A23.hud_y = 358
									a_m23.Translate(A23.hud_x,A23.hud_y)
									A23.transform = a_m23
									A23.menu = src
									A23.arrow_tag = "resistance minus"
									src.vis_contents += A23
									src.stat_buttons += A23

									var/obj/hud/menus/char_creation_background/arrow_right/A24 = new
									var/matrix/a_m24 = matrix()
									A24.hud_x = 301
									A24.hud_y = 358
									a_m24.Translate(A24.hud_x,A24.hud_y)
									A24.transform = a_m24
									A24.menu = src
									A24.arrow_tag = "resistance add"
									src.vis_contents += A24
									src.stat_buttons += A24

									var/obj/hud/menus/char_creation_background/arrow_left/A25 = new
									var/matrix/a_m25 = matrix()
									A25.hud_x = 163
									A25.hud_y = 324
									a_m25.Translate(A25.hud_x,A25.hud_y)
									A25.transform = a_m25
									A25.menu = src
									A25.arrow_tag = "offence minus"
									src.vis_contents += A25
									src.stat_buttons += A25

									var/obj/hud/menus/char_creation_background/arrow_right/A26 = new
									var/matrix/a_m26 = matrix()
									A26.hud_x = 207
									A26.hud_y = 324
									a_m26.Translate(A26.hud_x,A26.hud_y)
									A26.transform = a_m26
									A26.menu = src
									A26.arrow_tag = "offence add"
									src.vis_contents += A26
									src.stat_buttons += A26

									var/obj/hud/menus/char_creation_background/arrow_left/A27 = new
									var/matrix/a_m27 = matrix()
									A27.hud_x = 257
									A27.hud_y = 324
									a_m27.Translate(A27.hud_x,A27.hud_y)
									A27.transform = a_m27
									A27.menu = src
									A27.arrow_tag = "defence minus"
									src.vis_contents += A27
									src.stat_buttons += A27

									var/obj/hud/menus/char_creation_background/arrow_right/A28 = new
									var/matrix/a_m28 = matrix()
									A28.hud_x = 301
									A28.hud_y = 324
									a_m28.Translate(A28.hud_x,A28.hud_y)
									A28.transform = a_m28
									A28.menu = src
									A28.arrow_tag = "defence add"
									src.vis_contents += A28
									src.stat_buttons += A28

									var/obj/hud/menus/char_creation_background/arrow_left/A29 = new
									var/matrix/a_m29 = matrix()
									A29.hud_x = 163
									A29.hud_y = 290
									a_m29.Translate(A29.hud_x,A29.hud_y)
									A29.transform = a_m29
									A29.menu = src
									A29.arrow_tag = "regen minus"
									src.vis_contents += A29
									src.stat_buttons += A29

									var/obj/hud/menus/char_creation_background/arrow_right/A30 = new
									var/matrix/a_m30 = matrix()
									A30.hud_x = 207
									A30.hud_y = 290
									a_m30.Translate(A30.hud_x,A30.hud_y)
									A30.transform = a_m30
									A30.menu = src
									A30.arrow_tag = "regen add"
									src.vis_contents += A30
									src.stat_buttons += A30

									var/obj/hud/menus/char_creation_background/arrow_left/A31 = new
									var/matrix/a_m31 = matrix()
									A31.hud_x = 257 //-18
									A31.hud_y = 290
									a_m31.Translate(A31.hud_x,A31.hud_y)
									A31.transform = a_m31
									A31.menu = src
									A31.arrow_tag = "recovery minus"
									src.vis_contents += A31
									src.stat_buttons += A31

									var/obj/hud/menus/char_creation_background/arrow_right/A32 = new
									var/matrix/a_m32 = matrix()
									A32.hud_x = 301
									A32.hud_y = 290
									a_m32.Translate(A32.hud_x,A32.hud_y)
									A32.transform = a_m32
									A32.menu = src
									A32.arrow_tag = "recovery add"
									src.vis_contents += A32
									src.stat_buttons += A32
									//STAT ARROWS END

									//Taking 30 away from the x seems to result in the center, when measuring from the bottom left corner of the text box.

									//TXT START
									var/obj/hud/menus/char_creation_background/char_stat_txt/txt0 = new
									txt0.icon_state = "stat points"
									txt0.layer = 33
									txt0.plane = 24
									txt0.maptext_x = 227 //+27
									txt0.maptext_y = 517
									txt0.maptext_height = 16
									txt0.maptext_width = 128
									txt0.maptext = "[css_outline]<font size = 1><center>Points"
									txt0.txt_info = "[css_outline]<font size = 1><text align=left valign=top>[tooltip_points]"
									src.vis_contents += txt0

								//	var/obj/hud/menus/char_creation_background/char_stat_txt/txt1 = new
								//	txt1.icon_state = "stat psi power"
								//	txt1.layer = 33
									//txt1.plane = 24
								//	txt1.maptext_x = 227 //+27
								//	txt1.maptext_y = 483
								//	txt1.maptext_height = 16
								//	txt1.maptext_width = 128
								//	txt1.maptext = "[css_outline]<font size = 1><center>[css_psionic_power]Power"
									//txt1.txt_info = "[css_psionic_power]<font size = 1><text align=left valign=top>[tooltip_psionic_power]"
								//	src.vis_contents += txt1

									var/obj/hud/menus/char_creation_background/char_stat_txt/txt2 = new
									txt2.icon_state = "stat energy"
									txt2.layer = 33
									txt2.plane = 24
									txt2.maptext_x = 227
									txt2.maptext_y = 449
									txt2.maptext_height = 16
									txt2.maptext_width = 128
									txt2.maptext = "[css_outline]<font size = 1><center>[css_energy]Energy"
									txt2.txt_info = "[css_energy]<font size = 1><text align=left valign=top>[tooltip_energy]"
									src.vis_contents += txt2

									var/obj/hud/menus/char_creation_background/char_stat_txt/txt3 = new
									txt3.icon_state = "stat strength"
									txt3.layer = 33
									txt3.plane = 24
									txt3.maptext_x = 132
									txt3.maptext_y = 449
									txt3.maptext_height = 16
									txt3.maptext_width = 128
									txt3.maptext = "[css_outline]<font size = 1><center>[css_strength]Strength"
									txt3.txt_info = "[css_strength]<font size = 1><text align=left valign=top>[tooltip_strength]"
									src.vis_contents += txt3

									var/obj/hud/menus/char_creation_background/char_stat_txt/txt4 = new
									txt4.icon_state = "stat endurance"
									txt4.layer = 33
									txt4.plane = 24
									txt4.maptext_x = 132
									txt4.maptext_y = 415
									txt4.maptext_height = 16
									txt4.maptext_width = 128
									txt4.maptext = "[css_outline]<font size = 1><center>[css_endurance]Endurance"
									txt4.txt_info = "[css_endurance]<font size = 1><text align=left valign=top>[tooltip_endurance]"
									src.vis_contents += txt4

									var/obj/hud/menus/char_creation_background/char_stat_txt/txt5 = new
									txt5.icon_state = "stat agility"
									txt5.layer = 33
									txt5.plane = 24
									txt5.maptext_x = 227
									txt5.maptext_y = 415
									txt5.maptext_height = 16
									txt5.maptext_width = 128
									txt5.maptext = "[css_outline]<font size = 1><center>[css_agility]Agility"
									txt5.txt_info = "[css_agility]<font size = 1><text align=left valign=top>[tooltip_agility2]"
									src.vis_contents += txt5

									var/obj/hud/menus/char_creation_background/char_stat_txt/txt6 = new
									txt6.icon_state = "stat force"
									txt6.layer = 33
									txt6.plane = 24
									txt6.maptext_x = 132
									txt6.maptext_y = 381
									txt6.maptext_height = 16
									txt6.maptext_width = 128
									txt6.maptext = "[css_outline]<font size = 1><center>[css_force]Force"
									txt6.txt_info = "[css_force]<font size = 1><text align=left valign=top>[tooltip_force]"
									src.vis_contents += txt6

									var/obj/hud/menus/char_creation_background/char_stat_txt/txt7 = new
									txt7.icon_state = "stat resistance"
									txt7.layer = 33
									txt7.plane = 24
									txt7.maptext_x = 227
									txt7.maptext_y = 381
									txt7.maptext_height = 16
									txt7.maptext_width = 128
									txt7.maptext = "[css_outline]<font size = 1><center>[css_resistance]Resistance"
									txt7.txt_info = "[css_resistance]<font size = 1><text align=left valign=top>[tooltip_resistance]"
									src.vis_contents += txt7

									var/obj/hud/menus/char_creation_background/char_stat_txt/txt8 = new
									txt8.icon_state = "stat offence"
									txt8.layer = 33
									txt8.plane = 24
									txt8.maptext_x = 132
									txt8.maptext_y = 347
									txt8.maptext_height = 16
									txt8.maptext_width = 128
									txt8.maptext = "[css_outline]<font size = 1><center>[css_off]Offence"
									txt8.txt_info = "[css_off]<font size = 1><text align=left valign=top>[tooltip_offence]"
									src.vis_contents += txt8

									var/obj/hud/menus/char_creation_background/char_stat_txt/txt9 = new
									txt9.icon_state = "stat defence"
									txt9.layer = 33
									txt9.plane = 24
									txt9.maptext_x = 227
									txt9.maptext_y = 347
									txt9.maptext_height = 16
									txt9.maptext_width = 128
									txt9.maptext = "[css_outline]<font size = 1><center>[css_def]Defence"
									txt9.txt_info = "[css_def]<font size = 1><text align=left valign=top>[tooltip_defence]"
									src.vis_contents += txt9

									var/obj/hud/menus/char_creation_background/char_stat_txt/txt10 = new
									txt10.icon_state = "stat regen"
									txt10.layer = 33
									txt10.plane = 24
									txt10.maptext_x = 132
									txt10.maptext_y = 313
									txt10.maptext_height = 16
									txt10.maptext_width = 128
									txt10.maptext = "[css_outline]<font size = 1><center>[css_regen]Regeneration"
									txt10.txt_info = "[css_regen]<font size = 1><text align=left valign=top>[tooltip_regen2]"
									src.vis_contents += txt10

									var/obj/hud/menus/char_creation_background/char_stat_txt/txt11 = new
									txt11.icon_state = "stat recovery"
									txt11.layer = 33
									txt11.plane = 24
									txt11.maptext_x = 227
									txt11.maptext_y = 313
									txt11.maptext_height = 16
									txt11.maptext_width = 128
									txt11.maptext = "[css_outline]<font size = 1><center>[css_recov]Recovery"
									txt11.txt_info = "[css_recov]<font size = 1><text align=left valign=top>[tooltip_recovery2]"
									src.vis_contents += txt11

									//NUM START -18 y
									var/obj/num0 = new
									num0.layer = 33
									num0.plane = 24
									num0.hud_x = 226
									num0.hud_y = 499
									num0.maptext_height = 16
									num0.maptext_width = 128
									num0.maptext = "[css_outline]<font size = 1><center>10"
									var/matrix/n0 = matrix()
									n0.Translate(num0.hud_x,num0.hud_y)
									num0.transform = n0
									src.vis_contents += num0
									src.points = num0

									var/obj/num1 = new
									num1.layer = 33
									num1.plane = 24
									num1.hud_x = 226
									num1.hud_y = 465
								//	num1.maptext_height = 16
								//	num1.maptext_width = 128
								//	num1.maptext = "[css_outline]<font size = 1><center>1"
								//	src.num_psi = num1
								//	var/matrix/n1 = matrix()
									//n1.Translate(num1.hud_x,num1.hud_y)
									//num1.transform = n1
									//src.vis_contents += num1

									var/obj/num2 = new
									num2.layer = 33
									num2.plane = 24
									num2.hud_x = 226
									num2.hud_y = 431
									num2.maptext_height = 16
									num2.maptext_width = 128
									num2.maptext = "[css_outline]<font size = 1><center>2"
									src.num_eng = num2
									var/matrix/n2 = matrix()
									n2.Translate(num2.hud_x,num2.hud_y)
									num2.transform = n2
									src.vis_contents += num2

									var/obj/num3 = new
									num3.layer = 33
									num3.plane = 24
									num3.hud_x = 132
									num3.hud_y = 431
									num3.maptext_height = 16
									num3.maptext_width = 128
									num3.maptext = "[css_outline]<font size = 1><center>2"
									src.num_str = num3
									var/matrix/n3 = matrix()
									n3.Translate(num3.hud_x,num3.hud_y)
									num3.transform = n3
									src.vis_contents += num3

									var/obj/num4 = new
									num4.layer = 33
									num4.plane = 24
									num4.hud_x = 132
									num4.hud_y = 397
									num4.maptext_height = 16
									num4.maptext_width = 128
									num4.maptext = "[css_outline]<font size = 1><center>2"
									src.num_end = num4
									var/matrix/n4 = matrix()
									n4.Translate(num4.hud_x,num4.hud_y)
									num4.transform = n4
									src.vis_contents += num4

									var/obj/num5 = new
									num5.layer = 33
									num5.plane = 24
									num5.hud_x = 226
									num5.hud_y = 397
									num5.maptext_height = 16
									num5.maptext_width = 128
									num5.maptext = "[css_outline]<font size = 1><center>2"
									src.num_agi = num5
									var/matrix/n5 = matrix()
									n5.Translate(num5.hud_x,num5.hud_y)
									num5.transform = n5
									src.vis_contents += num5

									var/obj/num6 = new
									num6.layer = 33
									num6.plane = 24
									num6.hud_x = 132
									num6.hud_y = 363
									num6.maptext_height = 16
									num6.maptext_width = 128
									num6.maptext = "[css_outline]<font size = 1><center>2"
									src.num_for = num6
									var/matrix/n6 = matrix()
									n6.Translate(num6.hud_x,num6.hud_y)
									num6.transform = n6
									src.vis_contents += num6

									var/obj/num7 = new
									num7.layer = 33
									num7.plane = 24
									num7.hud_x = 226
									num7.hud_y = 363
									num7.maptext_height = 16
									num7.maptext_width = 128
									num7.maptext = "[css_outline]<font size = 1><center>2"
									src.num_res = num7
									var/matrix/n7 = matrix()
									n7.Translate(num7.hud_x,num7.hud_y)
									num7.transform = n7
									src.vis_contents += num7

									var/obj/num8 = new
									num8.layer = 33
									num8.plane = 24
									num8.hud_x = 132
									num8.hud_y = 329
									num8.maptext_height = 16
									num8.maptext_width = 128
									num8.maptext = "[css_outline]<font size = 1><center>2"
									src.num_off = num8
									var/matrix/n8 = matrix()
									n8.Translate(num8.hud_x,num8.hud_y)
									num8.transform = n8
									src.vis_contents += num8

									var/obj/num9 = new
									num9.layer = 33
									num9.plane = 24
									num9.hud_x = 226
									num9.hud_y = 329
									num9.maptext_height = 16
									num9.maptext_width = 128
									num9.maptext = "[css_outline]<font size = 1><center>2"
									src.num_def = num9
									var/matrix/n9 = matrix()
									n9.Translate(num9.hud_x,num9.hud_y)
									num9.transform = n9
									src.vis_contents += num9

									var/obj/num10 = new
									num10.layer = 33
									num10.plane = 24
									num10.hud_x = 132
									num10.hud_y = 295
									num10.maptext_height = 16
									num10.maptext_width = 128
									num10.maptext = "[css_outline]<font size = 1><center>2"
									src.num_regen = num10
									var/matrix/n10 = matrix()
									n10.Translate(num10.hud_x,num10.hud_y)
									num10.transform = n10
									src.vis_contents += num10

									var/obj/num11 = new
									num11.layer = 33
									num11.plane = 24
									num11.hud_x = 226
									num11.hud_y = 295
									num11.maptext_height = 16
									num11.maptext_width = 128
									num11.maptext = "[css_outline]<font size = 1><center>2"
									src.num_recov = num11
									var/matrix/n11 = matrix()
									n11.Translate(num11.hud_x,num11.hud_y)
									num11.transform = n11
									src.vis_contents += num11

									//BODY START
									var/obj/hair_color_select/bod1 = new
									bod1.layer = 33
									bod1.plane = 24
									bod1.hud_x = 76
									bod1.hud_y = 427 // 435
									bod1.maptext_height = 16
									bod1.maptext_width = 128
									bod1.maptext_x = -68
									bod1.maptext_y = 8
									bod1.maptext = "[css_outline]<font size = 1><center>Hair"
									src.num_psi = num1
									var/matrix/b1 = matrix()
									b1.Translate(bod1.hud_x,bod1.hud_y)
									bod1.transform = b1
									src.vis_contents += bod1

									/*var/obj/bod2 = new
									bod2.layer = 33
									bod2.plane = 24
									bod2.hud_x = 9
									bod2.hud_y = 415
									bod2.maptext_height = 16
									bod2.maptext_width = 128
									bod2.maptext = "[css_outline]<font size = 1><center>Skin"
									var/matrix/b2 = matrix()
									b2.Translate(bod2.hud_x,bod2.hud_y)
									bod2.transform = b2
									src.vis_contents += bod2 */

									var/obj/skin_color_select/bod2 = new
									bod2.layer = 33
									bod2.plane = 24
									bod2.hud_x = 76
									bod2.hud_y = 406 // 435
									bod2.maptext_height = 16
									bod2.maptext_width = 128
									bod2.maptext_x = -68
									bod2.maptext_y = 8
									bod2.maptext = "[css_outline]<font size = 1><center>Skin"
									//src.num_psi = num1
									var/matrix/b19 = matrix()
									b19.Translate(bod2.hud_x,bod2.hud_y)
									bod2.transform = b19
									src.vis_contents += bod2


									var/obj/bod3 = new
									bod3.layer = 33
									bod3.plane = 24
									bod3.hud_x = 9
									bod3.hud_y = 395
									bod3.maptext_height = 16
									bod3.maptext_width = 128
									bod3.maptext = "[css_outline]<font size = 1><center>Sex"
									var/matrix/b3 = matrix()
									b3.Translate(bod3.hud_x,bod3.hud_y)
									bod3.transform = b3
									src.vis_contents += bod3

									var/obj/eye_color_select/bod4 = new
									bod4.layer = 33
									bod4.plane = 24
									bod4.hud_x = 76
									bod4.hud_y = 367
									bod4.maptext_height = 16
									bod4.maptext_width = 128
									bod4.maptext_x = -68
									bod4.maptext_y = 8
									bod4.maptext = "[css_outline]<font size = 1><center>Eyes"
									var/matrix/b4 = matrix()
									b4.Translate(bod4.hud_x,bod4.hud_y)
									bod4.transform = b4
									src.vis_contents += bod4

									var/obj/bod5 = new
									bod5.layer = 33
									bod5.plane = 24
									bod5.hud_x = 9
									bod5.hud_y = 355
									bod5.maptext_height = 16
									bod5.maptext_width = 128
									bod5.maptext = "[css_outline]<font size = 1><center>Nose"
									var/matrix/b5 = matrix()
									b5.Translate(bod5.hud_x,bod5.hud_y)
									bod5.transform = b5
									src.vis_contents += bod5

									var/obj/bod6 = new
									bod6.layer = 33
									bod6.plane = 24
									bod6.hud_x = 9
									bod6.hud_y = 335
									bod6.maptext_height = 16
									bod6.maptext_width = 128
									bod6.maptext = "[css_outline]<font size = 1><center>Mouth"
									var/matrix/b6 = matrix()
									b6.Translate(bod6.hud_x,bod6.hud_y)
									bod6.transform = b6
									src.vis_contents += bod6

									var/obj/bod7 = new
									bod7.layer = 33
									bod7.plane = 24
									bod7.hud_x = 9
									bod7.hud_y = 315
									bod7.maptext_height = 16
									bod7.maptext_width = 128
									bod7.maptext = "[css_outline]<font size = 1><center>Body"
									var/matrix/b7 = matrix()
									b7.Translate(bod7.hud_x,bod7.hud_y)
									bod7.transform = b7
									src.vis_contents += bod7

									var/obj/bod8 = new
									bod8.layer = 33
									bod8.plane = 24
									bod8.hud_x = 9
									bod8.hud_y = 295
									bod8.maptext_height = 16
									bod8.maptext_width = 128


									if(usr.bodysize == 3) bod8.maptext = "[css_outline]<font size = 1><center>Large"
									if(usr.bodysize == 2) bod8.maptext = "[css_outline]<font size = 1><center>Medium"
									if(usr.bodysize == 1) bod8.maptext = "[css_outline]<font size = 1><center>Small"
									var/matrix/b8 = matrix()
									b8.Translate(bod8.hud_x,bod8.hud_y)
									bod8.transform = b8
									src.text_bodysize = bod8
									src.vis_contents += bod8
				scroller_pro
					icon = 'new_hud_char_creation4.dmi'
					icon_state = "scroller pros"
					layer = 33
					plane = 24
					appearance_flags = KEEP_TOGETHER
					MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
						var/obj/hud/menus/char_creation_background/s = src.menu
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/result = -43 + (usr.mouse_y_true-54) //54 is the size of the scroller x 2 (basically its height in pixels).
						result = clamp(result,0,-60)
						var/matrix/m = matrix()
						m.Translate(0,result)
						src.transform = m
						src.translated_y = result

						var/obj/txt = s.pro_txt
						var/ratio = -1 + ((-60 + result) / -60)
						ratio = clamp(ratio,0,1)
						ratio = 1 - ratio
						var/scroll_y = round(txt.hud_y*ratio)
						var/matrix/m2 = matrix()
						m2.Translate(txt.hud_x,scroll_y)
						txt.transform = m2
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/char_creation_background/s = src.menu
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = src.translated_y+wheel_move
						result = clamp(result,0,-60)
						var/matrix/m = matrix()
						m.Translate(0,result)
						src.transform = m
						src.translated_y = result

						var/obj/txt = s.pro_txt
						var/ratio = -1 + ((-60 + result) / -60)
						ratio = clamp(ratio,0,1)
						ratio = 1 - ratio
						var/scroll_y = round(txt.hud_y*ratio)
						var/matrix/m2 = matrix()
						m2.Translate(txt.hud_x,scroll_y)
						txt.transform = m2
				scroller_con
					icon = 'new_hud_char_creation4.dmi'
					icon_state = "scroller cons"
					layer = 33
					plane = 24
					appearance_flags = KEEP_TOGETHER
					MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
						var/obj/hud/menus/char_creation_background/s = src.menu
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/result = -43 + (usr.mouse_y_true-54) //54 is the size of the scroller x 2 (basically its height in pixels).
						result = clamp(result,0,-60)
						var/matrix/m = matrix()
						m.Translate(0,result)
						src.transform = m
						src.translated_y = result

						var/obj/txt = s.con_txt
						var/ratio = -1 + ((-60 + result) / -60)
						ratio = clamp(ratio,0,1)
						ratio = 1 - ratio
						var/scroll_y = round(txt.hud_y*ratio)
						var/matrix/m2 = matrix()
						m2.Translate(txt.hud_x,scroll_y)
						txt.transform = m2
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/char_creation_background/s = src.menu
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = src.translated_y+wheel_move
						result = clamp(result,0,-60)
						var/matrix/m = matrix()
						m.Translate(0,result)
						src.transform = m
						src.translated_y = result

						var/obj/txt = s.con_txt
						var/ratio = -1 + ((-60 + result) / -60)
						ratio = clamp(ratio,0,1)
						ratio = 1 - ratio
						var/scroll_y = round(txt.hud_y*ratio)
						var/matrix/m2 = matrix()
						m2.Translate(txt.hud_x,scroll_y)
						txt.transform = m2
				scroller_lore
					icon = 'new_hud_char_creation4.dmi'
					icon_state = "scroller lore"
					layer = 33
					plane = 24
					appearance_flags = KEEP_TOGETHER
					MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
						var/obj/hud/menus/char_creation_background/s = src.menu
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/result = -200 + (usr.mouse_y_true-54) //54 is the size of the scroller x 2 (basically its height in pixels).
						result = clamp(result,0,-121)
						var/matrix/m = matrix()
						m.Translate(0,result)
						src.transform = m
						src.translated_y = result

						var/obj/txt = s.lore_txt
						var/ratio = -1 + ((-121 + result) / -121)
						ratio = clamp(ratio,0,1)
						ratio = 1 - ratio
						var/scroll_y = round(txt.hud_y*ratio)
						var/matrix/m2 = matrix()
						m2.Translate(txt.hud_x,scroll_y)
						txt.transform = m2
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/char_creation_background/s = src.menu
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = src.translated_y+wheel_move
						result = clamp(result,0,-121)
						var/matrix/m = matrix()
						m.Translate(0,result)
						src.transform = m
						src.translated_y = result

						var/obj/txt = s.lore_txt
						var/ratio = -1 + ((-121 + result) / -121)
						ratio = clamp(ratio,0,1)
						ratio = 1 - ratio
						var/scroll_y = round(txt.hud_y*ratio)
						var/matrix/m2 = matrix()
						m2.Translate(txt.hud_x,scroll_y)
						txt.transform = m2
				scrollbar_pro
					icon = 'new_hud_char_creation4.dmi'
					icon_state = "scrollbar pros"
					layer = 33
					plane = 24
					appearance_flags = KEEP_TOGETHER
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
					MouseWheel(delta_x,delta_y,location,control,params)
						/*
						.:NOTES:.
						- 256 in the default example is the bar length/height.
						- 256 (bar length/height) is fine to use in var/result
						- Bar length - scroller length/height (usually 27) is the smaller number, in this case 227, which is used for clamping result and ratio
						- After subtracting the scroller length/height (usually 27) from the scrollbar, use it in clamping result and ratio.
						- IMPORTANT - scroll_y's first number is the total height of the inside area we want the bar/scroller to let us move up and down inside of.
						*/
						var/obj/hud/menus/char_creation_background/s = src.menu
						var/obj/sc = s.scroller_pro
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-60)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/obj/txt = s.pro_txt
						var/ratio = -1 + ((-60 + result) / -60)
						ratio = clamp(ratio,0,1)
						ratio = 1 - ratio
						var/scroll_y = round(txt.hud_y*ratio)
						var/matrix/m2 = matrix()
						m2.Translate(txt.hud_x,scroll_y)
						txt.transform = m2
					Click(location,control,params)
						/*
						.:NOTES:.
						- 256 in the default example is the bar length/height.
						- 256 (bar length/height) is fine to use in var/result
						- Bar length - scroller length/height (usually 27) is the smaller number, in this case 227, which is used for clamping result and ratio
						- After subtracting the scroller length/height (usually 27) from the scrollbar, use it in clamping result and ratio.
						- IMPORTANT - scroll_y's first number is the total height of the inside area we want the bar/scroller to let us move up and down inside of.
						*/
						var/obj/hud/menus/char_creation_background/s = src.menu
						var/obj/sc = s.scroller_pro
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/result = -43 + (usr.mouse_y_true-54) //54 is the size of the scroller x 2 (basically its height in pixels).
						result = clamp(result,0,-60)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/obj/txt = s.pro_txt
						var/ratio = -1 + ((-60 + result) / -60)
						ratio = clamp(ratio,0,1)
						ratio = 1 - ratio
						var/scroll_y = round(txt.hud_y*ratio)
						var/matrix/m2 = matrix()
						m2.Translate(txt.hud_x,scroll_y)
						txt.transform = m2
				scrollbar_con
					icon = 'new_hud_char_creation4.dmi'
					icon_state = "scrollbar cons"
					layer = 33
					plane = 24
					appearance_flags = KEEP_TOGETHER
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
					MouseWheel(delta_x,delta_y,location,control,params)
						/*
						.:NOTES:.
						- 256 in the default example is the bar length/height.
						- 256 (bar length/height) is fine to use in var/result
						- Bar length - scroller length/height (usually 27) is the smaller number, in this case 227, which is used for clamping result and ratio
						- After subtracting the scroller length/height (usually 27) from the scrollbar, use it in clamping result and ratio.
						- IMPORTANT - scroll_y's first number is the total height of the inside area we want the bar/scroller to let us move up and down inside of.
						*/
						var/obj/hud/menus/char_creation_background/s = src.menu
						var/obj/sc = s.scroller_con
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-60)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/obj/txt = s.con_txt
						var/ratio = -1 + ((-60 + result) / -60)
						ratio = clamp(ratio,0,1)
						ratio = 1 - ratio
						var/scroll_y = round(txt.hud_y*ratio)
						var/matrix/m2 = matrix()
						m2.Translate(txt.hud_x,scroll_y)
						txt.transform = m2
					Click(location,control,params)
						/*
						.:NOTES:.
						- 256 in the default example is the bar length/height.
						- 256 (bar length/height) is fine to use in var/result
						- Bar length - scroller length/height (usually 27) is the smaller number, in this case 227, which is used for clamping result and ratio
						- After subtracting the scroller length/height (usually 27) from the scrollbar, use it in clamping result and ratio.
						- IMPORTANT - scroll_y's first number is the total height of the inside area we want the bar/scroller to let us move up and down inside of.
						*/
						var/obj/hud/menus/char_creation_background/s = src.menu
						var/obj/sc = s.scroller_con
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/result = -43 + (usr.mouse_y_true-54) //54 is the size of the scroller x 2 (basically its height in pixels).
						result = clamp(result,0,-60)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/obj/txt = s.con_txt
						var/ratio = -1 + ((-60 + result) / -60)
						ratio = clamp(ratio,0,1)
						ratio = 1 - ratio
						var/scroll_y = round(txt.hud_y*ratio)
						var/matrix/m2 = matrix()
						m2.Translate(txt.hud_x,scroll_y)
						txt.transform = m2
				scrollbar_lore
					icon = 'new_hud_char_creation4.dmi'
					icon_state = "scrollbar lore"
					layer = 33
					plane = 24
					appearance_flags = KEEP_TOGETHER
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
					MouseWheel(delta_x,delta_y,location,control,params)
						/*
						.:NOTES:.
						- 256 in the default example is the bar length/height.
						- 256 (bar length/height) is fine to use in var/result
						- Bar length - scroller length/height (usually 27) is the smaller number, in this case 227, which is used for clamping result and ratio
						- After subtracting the scroller length/height (usually 27) from the scrollbar, use it in clamping result and ratio.
						- IMPORTANT - scroll_y's first number is the total height of the inside area we want the bar/scroller to let us move up and down inside of.
						*/
						var/obj/hud/menus/char_creation_background/s = src.menu
						var/obj/sc = s.scroller_lore
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-121)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/obj/txt = s.lore_txt
						var/ratio = -1 + ((-121 + result) / -121)
						ratio = clamp(ratio,0,1)
						ratio = 1 - ratio
						var/scroll_y = round(txt.hud_y*ratio)
						var/matrix/m2 = matrix()
						m2.Translate(txt.hud_x,scroll_y)
						txt.transform = m2
					Click(location,control,params)
						/*
						.:NOTES:.
						- 256 in the default example is the bar length/height.
						- 256 (bar length/height) is fine to use in var/result
						- Bar length - scroller length/height (usually 27) is the smaller number, in this case 227, which is used for clamping result and ratio
						- After subtracting the scroller length/height (usually 27) from the scrollbar, use it in clamping result and ratio.
						- IMPORTANT - scroll_y's first number is the total height of the inside area we want the bar/scroller to let us move up and down inside of.
						*/
						var/obj/hud/menus/char_creation_background/s = src.menu
						var/obj/sc = s.scroller_lore
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/result = -200 + (usr.mouse_y_true-54) //54 is the size of the scroller x 2 (basically its height in pixels).
						result = clamp(result,0,-121)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/obj/txt = s.lore_txt
						var/ratio = -1 + ((-121 + result) / -121)
						ratio = clamp(ratio,0,1)
						ratio = 1 - ratio
						var/scroll_y = round(txt.hud_y*ratio)
						var/matrix/m2 = matrix()
						m2.Translate(txt.hud_x,scroll_y)
						txt.transform = m2
				scroller_origins
					icon = 'new_hud_char_creation4.dmi'
					icon_state = "scroller origins"
					layer = 33
					plane = 24
					appearance_flags = KEEP_TOGETHER
					MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
						var/obj/hud/menus/char_creation_background/s = src.menu

						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/result = -473 + (usr.mouse_y_true-54) //54 is the size of the scroller x 2 (basically its height in pixels). -416 seems is how many pixels from bottom of menu.
						result = clamp(result,0,-218)
						var/matrix/m = matrix()
						m.Translate(0,result)
						src.transform = m
						src.translated_y = result

						var/ratio = -1 + ((-218 + result) / -218)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(700*ratio)

						for(var/obj/txt in s.origins_txt_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/char_creation_background/s = src.menu
						var/obj/sc = s.scroller_origins

						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-218)

						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result
						var/ratio = -1 + ((-218 + result) / -218)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(700*ratio)

						for(var/obj/txt in s.origins_txt_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2
				scrollbar_origins
					icon = 'new_hud_char_creation4.dmi'
					icon_state = "scrollbar origins"
					layer = 33
					plane = 24
					appearance_flags = KEEP_TOGETHER
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/char_creation_background/s = src.menu
						var/obj/sc = s.scroller_origins

						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-218)

						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result
						var/ratio = -1 + ((-218 + result) / -218)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(700*ratio)

						for(var/obj/txt in s.origins_txt_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2
					Click(location,control,params)
						var/obj/hud/menus/char_creation_background/s = src.menu
						var/obj/sc = s.scroller_origins
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/result = -473 + (usr.mouse_y_true-54) //54 is the size of the scroller x 2 (basically its height in pixels). -416 seems is how many pixels from bottom of menu.
						result = clamp(result,0,-218)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/ratio = -1 + ((-218 + result) / -218)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(700*ratio)

						for(var/obj/txt in s.origins_txt_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2
				scroller_origins_desc
					icon = 'new_hud_char_creation4.dmi'
					icon_state = "scroller origins desc"
					layer = 33
					plane = 24
					appearance_flags = KEEP_TOGETHER
					MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
						//var/obj/hud/menus/char_creation_background/s = src.menu

						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/result = -200 + (usr.mouse_y_true-54) //54 is the size of the scroller x 2 (basically its height in pixels). -246 seems is how many pixels from bottom of menu.
						result = clamp(result,0,-218)
						var/matrix/m = matrix()
						m.Translate(0,result)
						src.transform = m
						src.translated_y = result

						var/ratio = -1 + ((-218 + result) / -218)
						ratio = clamp(ratio,0,1)
					//	var/scroll_y = round(200*ratio)

						/*for(var/obj/txt in s.origins_desc_txt_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2*/
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/char_creation_background/s = src.menu
						var/obj/sc = s.scroller_origins_desc

						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-218)

						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result
						var/ratio = -1 + ((-218 + result) / -218)
						ratio = clamp(ratio,0,1)
					//	var/scroll_y = round(200*ratio)

						/*for(var/obj/txt in s.origins_desc_txt_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2*/
				scrollbar_origins_desc
					icon = 'new_hud_char_creation4.dmi'
					icon_state = "scrollbar origins desc"
					layer = 33
					plane = 24
					appearance_flags = KEEP_TOGETHER
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/char_creation_background/s = src.menu
						var/obj/sc = s.scroller_origins_desc

						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-218)

						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result
						var/ratio = -1 + ((-218 + result) / -218)
						ratio = clamp(ratio,0,1)
					//	var/scroll_y = round(200*ratio)

						/*for(var/obj/txt in s.origins_desc_txt_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2*/
					Click(location,control,params)
						var/obj/hud/menus/char_creation_background/s = src.menu
						var/obj/sc = s.scroller_origins_desc
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/result = -200 + (usr.mouse_y_true-54) //54 is the size of the scroller x 2 (basically its height in pixels). -246 seems is how many pixels from bottom of menu.
						result = clamp(result,0,-218)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/ratio = -1 + ((-218 + result) / -218)
						ratio = clamp(ratio,0,1)
					//	var/scroll_y = round(200*ratio)

						/*for(var/obj/txt in s.origins_desc_txt_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2*/
				char_ages_adult_txt_holder
					icon = 'age_huds.dmi'
					icon_state = "adult"
					layer = 33
					plane = 24
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND

					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				char_origins_txt_holder
					icon = 'new_hud_char_creation4.dmi'
					icon_state = "origins txt"
					layer = 33
					plane = 24
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/char_creation_background/s = src.menu
						var/obj/sc = s.scroller_origins

						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-218)

						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result
						var/ratio = -1 + ((-218 + result) / -218)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(700*ratio)

						for(var/obj/txt in src.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				char_avatar_holder
					//icon = 'new_hud_char_creation4.dmi'
					//icon_state = "portrait"
					icon = null
					layer = 33
					plane = 24
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				char_pro_holder
					icon = 'new_hud_char_creation4.dmi'
					icon_state = "pros txt"
					layer = 33
					plane = 24
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/char_creation_background/s = src.menu
						var/obj/sc = s.scroller_pro
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-60)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result
						var/obj/txt = s.pro_txt
						var/ratio = -1 + ((-60 + result) / -60)
						ratio = clamp(ratio,0,1)
						ratio = 1 - ratio
						var/scroll_y = round(txt.hud_y*ratio)
						var/matrix/m2 = matrix()
						m2.Translate(txt.hud_x,scroll_y)
						txt.transform = m2
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				char_con_holder
					icon = 'new_hud_char_creation4.dmi'
					icon_state = "cons txt"
					layer = 33
					plane = 24
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/char_creation_background/s = src.menu
						var/obj/sc = s.scroller_con
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-60)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result
						var/obj/txt = s.con_txt
						var/ratio = -1 + ((-60 + result) / -60)
						ratio = clamp(ratio,0,1)
						ratio = 1 - ratio
						var/scroll_y = round(txt.hud_y*ratio)
						var/matrix/m2 = matrix()
						m2.Translate(txt.hud_x,scroll_y)
						txt.transform = m2
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				char_lore_txt_holder
					icon = 'new_hud_char_creation4.dmi'
					icon_state = "lore txt"
					layer = 33
					plane = 24
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/char_creation_background/s = src.menu
						var/obj/sc = s.scroller_lore
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-121)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result
						var/obj/txt = s.lore_txt
						var/ratio = -1 + ((-121 + result) / -121)
						ratio = clamp(ratio,0,1)
						ratio = 1 - ratio
						var/scroll_y = round(txt.hud_y*ratio)
						var/matrix/m2 = matrix()
						m2.Translate(txt.hud_x,scroll_y)
						txt.transform = m2
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				char_origins_desc_txt_holder
					icon = 'new_hud_char_creation4.dmi'
					icon_state = "origins desc txt"
					layer = 33
					plane = 24
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/char_creation_background/s = src.menu
						var/obj/sc = s.scroller_origins_desc

						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-218)

						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result
						var/ratio = -1 + ((-218 + result) / -218)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(200*ratio)

						for(var/obj/txt in src.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				char_stat_txt
					icon_state = "stat energy"
					maptext_width = 300
					maptext_height = 300
					plane = 24
					layer = 34
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					var/txt_info
					MouseExited()
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseEntered(location,control,params)
						if(usr.info_box1)
							usr.client.screen += usr.info_box1
							usr.client.screen += usr.info_box2
							usr.client.screen += usr.info_box3
							usr.info_box(src,src.txt_info,params)
					MouseMove(location,control,params)
						..()
						usr.info_box(src,src.txt_info,params)
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				char_lore_txt
					icon = null
					icon_state = null
					maptext_width = 322
					maptext_height = 640
					plane = 24
					layer = 34
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						src.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Humans</u>\n<text align=left valign=top>[text_human]"
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				char_pro_txt
					icon = null
					icon_state = null
					maptext_width = 150
					maptext_height = 300
					plane = 24
					layer = 34
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						src.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Traits</u><text align=left valign=top><font color = green>[text_human_pros]"
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				char_con_txt
					icon = null
					icon_state = null
					maptext_width = 150
					maptext_height = 300
					plane = 24
					layer = 34
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						src.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Home World</u><text align=left valign=top><font color = white>[text_human_cons]"
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				char_origins_txt
					icon = null
					icon_state = null
					maptext_width = 120
					maptext_height = 16
					plane = 24
					layer = 34
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						src.maptext = "[css_outline]<font size = 1><center><u>Origins</u>"
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				char_ages_desc_txt
					icon = null
					icon_state = null
					maptext_width = 147
					maptext_height = 640
					plane = 24
					layer = 34
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				char_origins_desc_txt
					icon = null
					icon_state = null
					maptext_width = 147
					maptext_height = 640
					plane = 24
					layer = 34
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				char_confirm_button
					icon = 'new_hud_char_creation4.dmi'
					icon_state = "confirm"
					maptext_width = 96
					maptext_height = 16
					maptext_x = 196
					maptext_y = 271
					plane = 24
					layer = 34
					Click()
						if(findtext(usr.hud_char.name_input,"Name"))
							alert("Cannot use that name")
							return
						usr.confirm_creation()
					New()
						src.maptext = "[css_outline]<font size = 1><center>Confirm"
						src.filters += filter(type="outline",size=1, color=rgb(204,236,255))
						src.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=1, color=rgb(102,0,204))
						animate(src.filters[2], size = 4,offset = 2, time = 15, loop = -1)
						animate(size = 0,offset = 0, time = 15, loop = -1)
						return
					MouseEntered()
						if(src.menu == usr.hud_char) src.icon_state = "[initial(src.icon_state)] hover"
					MouseExited()
						if(src.menu == usr.hud_char) src.icon_state = "[initial(src.icon_state)]"
				char_name_input
					icon = 'new_hud_char_creation4.dmi'
					icon_state = "name"
					maptext_width = 128
					maptext_height = 16
					maptext_x = 46
					maptext_y = 272
					plane = 24
					layer = 34
					var/a = 1
					var/wid = 44 //How many pixels from the left side of the icon as a whole
					var/selecting = 0
					Click(location,control,params)
						if(usr.offspring) return
						// Track where player clicked on input box (icon_x)
						// Measure the maptext itself using MeasureText() (L)
						// Measure how many characters were in the text string (L_C)
						// Find the pos by taking icon_x and subtracting wid, which is how far the start of the text is from the left side of the icon
						// Then divide that result by the total pixel length of the text string (pos)
						// Then take pos and multply it by total characters in the string (L_C), and round the result, then add +1
						if(src.string_full == "Name") src.string_full = ""
						usr.typing = src
						src.selecting -= 1
						if(src.selecting < 0) src.selecting = 0
						if(src.selecting == 0)
							params = params2list(params)
							var/icon_x = text2num(params["icon-x"])
							var/L = usr.client.MeasureText("[src.maptext]")
							var/x_pos = findtext(L, "x")
							L = text2num(copytext(L, 1, x_pos))
							if(L <= 0)
								return
							var/L_C = length_char(src.string_full)
							var/pos = (icon_x-wid)/L
							pos = round(pos*L_C)
							pos = pos+1
							src.string_full = replacetext_char(src.string_full,"|","",1,0)
							src.caret_pos = pos
							if(src.caret_pos >= length(src.string_full)+1) src.caret_pos = length(src.string_full)+1
							// Combine the new strings with "|" in between.
							var/new_string = splicetext(src.string_full,src.caret_pos,src.caret_pos,"|")
							src.maptext = "[css_outline]<font size = 1><left>[new_string]"
							src.select_started = 0
							src.select_end += 0
							src.string_selected = ""
							src.excluded_before = ""
							src.excluded_after = ""
						return
						//return
					New()
						src.maptext = "[css_outline]<font size = 1><left>Name"
						src.string_full = "Name"
						spawn(10)
							if(src)
								if(src.menu)
									var/mob/player
									if(ismob(src.menu.loc))
										player = src.menu.loc
									while(src)
										if(player && player.typing == src)
											if(src.caret_pos == length("[src.string_full]")+1)
												if(a)
													src.maptext = "[css_outline]<font size = 1><left>[string_full]"
													a = 0
												else
													a = 1
													src.maptext = "[css_outline]<font size = 1><left>[string_full]"
										sleep(6)

				race_button_newborn
					icon = 'new_hud_race_select.dmi'
					icon_state = "newborn selected"
					hud_x = 0
					hud_y = 146
					Click()
						var/current_time = world.time
						if(current_time - usr.last_click_time < 10) // 10 = 1 second (BYOND uses 1/10th sec units)
							return

						usr.last_click_time = current_time
						if(usr.screen_text && usr.screen_text in usr.client.screen) usr.client.screen -= usr.screen_text
						usr.switch_race("Newborn")
						var/obj/txt = src.menu.lore_txt
						txt.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Newborns/New Creations</u>\n<text align=left valign=top>[text_newborns]"
						var/obj/txt_pro = src.menu.pro_txt
						txt_pro.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Traits</u><text align=left valign=top><font color = green>[text_newborns_pros]"
						var/obj/txt_con = src.menu.con_txt
						txt_con.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Home World</u><text align=left valign=top><font color = white>[text_newborns_cons]"
						//usr.babyport = new /obj/portrait/babybody
						//src.menu.update_portrait_transform()

						//src.menu.reset_bars()
						/*var/mob/choice = input("Pick a creature to create into. Warning: You will be punished for wasting someones child slot. This includes creating into one and remaking, purposely killing, or trolling the IC of that child.") in ActiveChildren
						if(choice.name == "Cancel")
							return
						if(choice.pw==""||choice.pw==null)
							switch(alert(usr,"Creature's Description: [choice.race]","","Continue","Return"))
								if("Continue")
									if(usr.client )
							//Copy the players in-game avatar icon, but save the layer/plane/transform.
										//src.menu.menu_avatar()
							//Update the players portrait, if they have one, to reflect the new race choice.

										//src.menu.update_portrait_transform()
										usr.creature_started=1
										usr.offspring_transport = choice
						else
							var/PW=input("Input the password for [choice]!") as text
							if(PW==choice.pw)
								switch(alert(usr,"Creature's Description: [choice.race]","","Continue","Return"))
									if("Continue")
										if(usr.client )
								//Copy the players in-game avatar icon, but save the layer/plane/transform.
										//	src.menu.menu_avatar()
								//Update the players portrait, if they have one, to reflect the new race choice.

											//src.menu.update_portrait_transform()
											usr.creature_started=1
											usr.offspring_transport = choice */


						if(src.clicked)
							src.switch_buttons()
							src.clicked = 0
							src.icon_state = "newborn not selected"
						else
							src.switch_buttons()
							src.clicked = 1
							src.icon_state = "newborn selected"
						if(usr.screen_text) usr.client.screen -= usr.screen_text
					New()
						src.og_state = "newborn not selected"
						return
				race_button_human
					icon = 'new_hud_race_select.dmi'
					icon_state = "human selected"
					hud_x = 0
					hud_y = 511
					Click()
						if(usr.screen_text && usr.screen_text in usr.client.screen) usr.client.screen -= usr.screen_text
						var/current_time = world.time
						if(current_time - usr.last_click_time < 10) // 10 = 1 second (BYOND uses 1/10th sec units)
							return
						usr.last_click_time = current_time
						if(usr.creature_started == 1) usr.creature_started = 0
						src.menu.clear_portrait_vis()
						usr.switch_race("Human")
						var/obj/txt = src.menu.lore_txt
						txt.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Humans</u>\n<text align=left valign=top>[text_human]"
						var/obj/txt_pro = src.menu.pro_txt
						txt_pro.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Traits</u><text align=left valign=top><font color = green>[text_human_pros]"
						var/obj/txt_con = src.menu.con_txt
						txt_con.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Home World</u><text align=left valign=top><font color = white>[text_human_cons]"
						src.menu.reset_bars()

						//Copy the players in-game avatar icon, but save the layer/plane/transform.
						src.menu.menu_avatar()
						//Update the players portrait, if they have one, to reflect the new race choice.

						src.menu.update_portrait_transform()

						if(src.clicked)
							src.switch_buttons()
							src.clicked = 0
							src.icon_state = "human not selected"
						else
							src.switch_buttons()
							src.clicked = 1
							src.icon_state = "human selected"

					New()
						src.og_state = "human not selected"
						return
				race_button_demon
					icon = 'new_hud_race_select.dmi'
					icon_state = "demon not selected"
					hud_x = 0
					hud_y = 479
					Click()
						if(usr.screen_text && usr.screen_text in usr.client.screen) usr.client.screen -= usr.screen_text
						var/current_time = world.time
						if(current_time - usr.last_click_time < 10) // 10 = 1 second (BYOND uses 1/10th sec units)
							return
						usr.last_click_time = current_time
						if(usr.creature_started == 1) usr.creature_started = 0
						src.menu.clear_portrait_vis()
						usr.switch_race("Demon")
						var/obj/txt = src.menu.lore_txt
						txt.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Demons</u>\n<text align=left valign=top>[text_demon]"
						var/obj/txt_pro = src.menu.pro_txt
						txt_pro.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Traits</u><text align=left valign=top><font color = green>[text_demon_pros]"
						var/obj/txt_con = src.menu.con_txt
						txt_con.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Home World</u><text align=left valign=top><font color = white>[text_demon_cons]"
						src.menu.reset_bars()

						//Copy the players in-game avatar icon, but save the layer/plane/transform.
						src.menu.menu_avatar()
						//Update the players portrait, if they have one, to reflect the new race choice.
						src.menu.update_portrait_transform()
						if(src.clicked)
							src.switch_buttons()
							src.clicked = 0
							src.icon_state = "demon not selected"
						else
							src.switch_buttons()
							src.clicked = 1
							src.icon_state = "demon selected"

					New()
						src.og_state = "demon not selected"
						return
				race_button_celestial
					icon = 'new_hud_race_select.dmi'
					icon_state = "celestial not selected"
					hud_x = 0
					hud_y = 446
					Click()
						if(usr.screen_text && usr.screen_text in usr.client.screen) usr.client.screen -= usr.screen_text
						var/current_time = world.time
						if(current_time - usr.last_click_time < 10) // 10 = 1 second (BYOND uses 1/10th sec units)
							return
						usr.last_click_time = current_time
						if(usr.creature_started == 1) usr.creature_started = 0
						src.menu.clear_portrait_vis()
						usr.switch_race("Kai")
						var/obj/txt = src.menu.lore_txt
						txt.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Kais</u>\n<text align=left valign=top>[text_celestial]"
						var/obj/txt_pro = src.menu.pro_txt
						txt_pro.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Traits</u><text align=left valign=top><font color = green>[text_celestial_pros]"
						var/obj/txt_con = src.menu.con_txt
						txt_con.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Home World</u><text align=left valign=top><font color = white>[text_celestial_cons]"
						src.menu.reset_bars()

						//Copy the players in-game avatar icon, but save the layer/plane/transform.
						src.menu.menu_avatar()
						//Update the players portrait, if they have one, to reflect the new race choice.
						src.menu.update_portrait_transform()
						if(src.clicked)
							src.switch_buttons()
							src.clicked = 0
							src.icon_state = "celestial not selected"
						else
							src.switch_buttons()
							src.clicked = 1
							src.icon_state = "celestial selected"

					New()
						src.og_state = "celestial not selected"
						return
				race_button_imp
					icon = 'new_hud_race_select.dmi'
					icon_state = "oni not selected"
					hud_x = 0
					hud_y = 413
					Click()
						if(usr.screen_text && usr.screen_text in usr.client.screen) usr.client.screen -= usr.screen_text
						var/current_time = world.time
						if(current_time - usr.last_click_time < 10) // 10 = 1 second (BYOND uses 1/10th sec units)
							return
						usr.last_click_time = current_time
						if(usr.creature_started == 1) usr.creature_started = 0
						src.menu.clear_portrait_vis()
						usr.switch_race("Oni")
						var/obj/txt = src.menu.lore_txt
						txt.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Onis</u>\n<text align=left valign=top>[text_imp]"
						var/obj/txt_pro = src.menu.pro_txt
						txt_pro.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Traits</u><text align=left valign=top><font color = green>[text_imp_pros]"
						var/obj/txt_con = src.menu.con_txt
						txt_con.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Home World</u><text align=left valign=top><font color = white>[text_imp_cons]"
						src.menu.reset_bars()

						//Copy the players in-game avatar icon, but save the layer/plane/transform.
						src.menu.menu_avatar()
						//Update the players portrait, if they have one, to reflect the new race choice.
						src.menu.update_portrait_transform()
						if(src.clicked)
							src.switch_buttons()
							src.clicked = 0
							src.icon_state = "oni not selected"
						else
							src.switch_buttons()
							src.clicked = 1
							src.icon_state = "oni selected"

					New()
						src.og_state = "oni not selected"
						return
				race_button_saiyan
					icon = 'new_hud_race_select.dmi'
					icon_state = "saiyan not selected"
					hud_x = 0
					hud_y = 381
					Click()
						if(usr.screen_text && usr.screen_text in usr.client.screen) usr.client.screen -= usr.screen_text
						var/current_time = world.time
						if(current_time - usr.last_click_time < 10) // 10 = 1 second (BYOND uses 1/10th sec units)
							return
						usr.last_click_time = current_time
						if(usr.creature_started == 1) usr.creature_started = 0
						src.menu.clear_portrait_vis()
						usr.switch_race("Saiyan")
						var/obj/txt = src.menu.lore_txt
						txt.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Saiyan</u>\n<text align=left valign=top>[text_saiyan]"
						var/obj/txt_pro = src.menu.pro_txt
						txt_pro.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Traits</u><text align=left valign=top><font color = green>[text_saiyan_pros]"
						var/obj/txt_con = src.menu.con_txt
						txt_con.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Home World</u><text align=left valign=top><font color = white>[text_saiyan_cons]"
						src.menu.reset_bars()

						//Copy the players in-game avatar icon, but save the layer/plane/transform.
						src.menu.menu_avatar()
						//Update the players portrait, if they have one, to reflect the new race choice.
						src.menu.update_portrait_transform()
						if(src.clicked)
							src.switch_buttons()
							src.clicked = 0
							src.icon_state = "saiyan not selected"
						else
							src.switch_buttons()
							src.clicked = 1
							src.icon_state = "saiyan selected"
					New()
						src.og_state = "saiyan not selected"
						return
				race_button_cerebroid
					icon = 'new_hud_race_select.dmi'
					icon_state = "cerebroid not selected"
					hud_x = 0
					hud_y = 281
					Click()
						if(usr.screen_text && usr.screen_text in usr.client.screen) usr.client.screen -= usr.screen_text
						var/current_time = world.time
						if(current_time - usr.last_click_time < 10) // 10 = 1 second (BYOND uses 1/10th sec units)
							return
						usr.last_click_time = current_time
						if(usr.creature_started == 1) usr.creature_started = 0
						src.menu.clear_portrait_vis()
						usr.switch_race("Alien")
						var/obj/txt = src.menu.lore_txt
						txt.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Aliens</u>\n<text align=left valign=top>[text_cerebroid]"
						var/obj/txt_pro = src.menu.pro_txt
						txt_pro.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Traits</u><text align=left valign=top><font color = green>[text_cerebroid_pros]"
						var/obj/txt_con = src.menu.con_txt
						txt_con.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Home World</u><text align=left valign=top><font color = white>[text_cerebroid_cons]"
						src.menu.reset_bars()

						//Copy the players in-game avatar icon, but save the layer/plane/transform.
						src.menu.menu_avatar()
						//Update the players portrait, if they have one, to reflect the new race choice.
						src.menu.update_portrait_transform()
						if(src.clicked)
							src.switch_buttons()
							src.clicked = 0
							src.icon_state = "cerebroid not selected"
						else
							src.switch_buttons()
							src.clicked = 1
							src.icon_state = "cerebroid selected"

					New()
						src.og_state = "cerebroid not selected"
						return
				/*race_button_android
					icon = 'new_hud_race_select.dmi'
					icon_state = "android not selected"
					hud_x = 0
					hud_y = 347
					Click()
						src.menu.clear_portrait_vis()
						usr.switch_race("Android")
						var/obj/txt = src.menu.lore_txt
						txt.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Androids</u>\n<text align=left valign=top>[text_android]"
						var/obj/txt_pro = src.menu.pro_txt
						txt_pro.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Pros</u><text align=left valign=top><font color = green>[text_android_pros]"
						var/obj/txt_con = src.menu.con_txt
						txt_con.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Cons</u><text align=left valign=top><font color = red>[text_android_cons]"
						src.menu.reset_bars()

						//Copy the players in-game avatar icon, but save the layer/plane/transform.
						src.menu.menu_avatar()
						//Update the players portrait, if they have one, to reflect the new race choice.
						src.menu.portrait_transform()
						if(src.clicked)
							src.switch_buttons()
							src.clicked = 0
							src.icon_state = "android not selected"
						else
							src.switch_buttons()
							src.clicked = 1
							src.icon_state = "android selected"
					New()
						src.og_state = "android not selected"
						return
						*/

				race_button_yukopian
					icon = 'new_hud_race_select.dmi'
					icon_state = "yukopian not selected"
					hud_x = 0
					hud_y = 314
					Click()
						if(usr.screen_text && usr.screen_text in usr.client.screen) usr.client.screen -= usr.screen_text
						var/current_time = world.time
						if(current_time - usr.last_click_time < 10) // 10 = 1 second (BYOND uses 1/10th sec units)
							return
						usr.last_click_time = current_time
						if(usr.creature_started == 1) usr.creature_started = 0
						src.menu.clear_portrait_vis()
						usr.switch_race("Namekian")
						var/obj/txt = src.menu.lore_txt
						txt.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Namekians</u>\n<text align=left valign=top>[text_yukopian]"
						var/obj/txt_pro = src.menu.pro_txt
						txt_pro.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Traits</u><text align=left valign=top><font color = green>[text_yukopian_pros]"
						var/obj/txt_con = src.menu.con_txt
						txt_con.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Home World</u><text align=left valign=top><font color = white>[text_yukopian_cons]"
						src.menu.reset_bars()

						//Copy the players in-game avatar icon, but save the layer/plane/transform.
						src.menu.menu_avatar()
						//Update the players portrait, if they have one, to reflect the new race choice.
						src.menu.update_portrait_transform()
						if(src.clicked)
							src.switch_buttons()
							src.clicked = 0
							src.icon_state = "yukopian not selected"
						else
							src.switch_buttons()
							src.clicked = 1
							src.icon_state = "yukopian selected"

					New()
						src.og_state = "yukopian not selected"
						return
				race_button_doll
					icon = 'new_hud_race_select.dmi'
					icon_state = "doll not selected"
					hud_x = 0
					hud_y = 214
					Click()
						if(usr.screen_text && usr.screen_text in usr.client.screen) usr.client.screen -= usr.screen_text
						var/current_time = world.time
						if(current_time - usr.last_click_time < 10) // 10 = 1 second (BYOND uses 1/10th sec units)
							return
						usr.last_click_time = current_time
						if(usr.creature_started == 1) usr.creature_started = 0
						src.menu.clear_portrait_vis()
						usr.switch_race("Spirit Doll")
						var/obj/txt = src.menu.lore_txt
						txt.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Spirit Doll</u>\n<text align=left valign=top>[text_doll]"
						var/obj/txt_pro = src.menu.pro_txt
						txt_pro.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Traits</u><text align=left valign=top><font color = green>[text_doll_pros]"
						var/obj/txt_con = src.menu.con_txt
						txt_con.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Home World</u><text align=left valign=top><font color = white>[text_doll_cons]"
						src.menu.reset_bars()

						//Copy the players in-game avatar icon, but save the layer/plane/transform.
						src.menu.menu_avatar()
						//Update the players portrait, if they have one, to reflect the new race choice.
						src.menu.update_portrait_transform()
						if(src.clicked)
							src.switch_buttons()
							src.clicked = 0
							src.icon_state = "doll not selected"
						else
							src.switch_buttons()
							src.clicked = 1
							src.icon_state = "doll selected"

					New()
						src.og_state = "doll not selected"
						return
				race_button_makyo
					icon = 'new_hud_race_select.dmi'
					icon_state = "makyo not selected"
					hud_x = 0
					hud_y = 248
					Click()
						if(usr.screen_text && usr.screen_text in usr.client.screen) usr.client.screen -= usr.screen_text
						var/current_time = world.time
						if(current_time - usr.last_click_time < 10) // 10 = 1 second (BYOND uses 1/10th sec units)
							return
						usr.last_click_time = current_time
						if(usr.creature_started == 1) usr.creature_started = 0
						src.menu.clear_portrait_vis()
						usr.switch_race("Makyo")
						var/obj/txt = src.menu.lore_txt
						txt.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Makyo</u>\n<text align=left valign=top>[text_makyo]"
						var/obj/txt_pro = src.menu.pro_txt
						txt_pro.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Traits</u><text align=left valign=top><font color = green>[text_makyo_pros]"
						var/obj/txt_con = src.menu.con_txt
						txt_con.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Home World</u><text align=left valign=top><font color = white>[text_makyo_cons]"
						src.menu.reset_bars()

						//Copy the players in-game avatar icon, but save the layer/plane/transform.
						src.menu.menu_avatar()
						//Update the players portrait, if they have one, to reflect the new race choice.
						src.menu.update_portrait_transform()
						if(src.clicked)
							src.switch_buttons()
							src.clicked = 0
							src.icon_state = "makyo not selected"
						else
							src.switch_buttons()
							src.clicked = 1
							src.icon_state = "makyo selected"

					New()
						src.og_state = "makyo not selected"
						return
				race_button_halfgod
					icon = 'new_hud_race_select.dmi'
					icon_state = "demi not selected"
					hud_x = 0
					hud_y = 214
					Click()
						if(usr.screen_text && usr.screen_text in usr.client.screen) usr.client.screen -= usr.screen_text
						var/current_time = world.time
						if(current_time - usr.last_click_time < 10) // 10 = 1 second (BYOND uses 1/10th sec units)
							return
						usr.last_click_time = current_time
						if(usr.creature_started == 1) usr.creature_started = 0
						src.menu.clear_portrait_vis()
						usr.switch_race("Half God")
						var/obj/txt = src.menu.lore_txt
						txt.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Half God</u>\n<text align=left valign=top>[text_doll]"
						var/obj/txt_pro = src.menu.pro_txt
						txt_pro.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Traits</u><text align=left valign=top><font color = green>[text_doll_pros]"
						var/obj/txt_con = src.menu.con_txt
						txt_con.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Home World</u><text align=left valign=top><font color = white>[text_doll_cons]"
						src.menu.reset_bars()

						//Copy the players in-game avatar icon, but save the layer/plane/transform.
						src.menu.menu_avatar()
						//Update the players portrait, if they have one, to reflect the new race choice.
						src.menu.update_portrait_transform()
						if(src.clicked)
							src.switch_buttons()
							src.clicked = 0
							src.icon_state = "demi not selected"
						else
							src.switch_buttons()
							src.clicked = 1
							src.icon_state = "demi selected"

					New()
						src.og_state = "demi not selected"
						return
				race_button_ling
					icon = 'new_hud_race_select.dmi'
					icon_state = "ling not selected"
					hud_x = 0
					hud_y = 347
					Click()
						if(usr.screen_text && usr.screen_text in usr.client.screen) usr.client.screen -= usr.screen_text
						var/current_time = world.time
						if(current_time - usr.last_click_time < 10) // 10 = 1 second (BYOND uses 1/10th sec units)
							return
						usr.last_click_time = current_time
						if(usr.creature_started == 1) usr.creature_started = 0
						src.menu.clear_portrait_vis()
						usr.switch_race("Changeling")
						var/obj/txt = src.menu.lore_txt
						txt.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Changeling</u>\n<text align=left valign=top>[text_changeling]"
						var/obj/txt_pro = src.menu.pro_txt
						txt_pro.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Traits</u><text align=left valign=top><font color = green>[text_changeling_pros]"
						var/obj/txt_con = src.menu.con_txt
						txt_con.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Home World</u><text align=left valign=top><font color = white>[text_changeling_cons]"
						src.menu.reset_bars()

						//Copy the players in-game avatar icon, but save the layer/plane/transform.
						src.menu.menu_avatar()
						//Update the players portrait, if they have one, to reflect the new race choice.
						src.menu.update_portrait_transform()
						if(src.clicked)
							src.switch_buttons()
							src.clicked = 0
							src.icon_state = "ling not selected"
						else
							src.switch_buttons()
							src.clicked = 1
							src.icon_state = "ling selected"

					New()
						src.og_state = "ling not selected"
						return
				race_button_tuffle
					icon = 'new_hud_race_select.dmi'
					icon_state = "tuffle not selected"
					hud_x = 0
					hud_y = 180
					Click()
						if(usr.screen_text && usr.screen_text in usr.client.screen) usr.client.screen -= usr.screen_text
						var/current_time = world.time
						if(current_time - usr.last_click_time < 10) // 10 = 1 second (BYOND uses 1/10th sec units)
							return
						usr.last_click_time = current_time
						if(usr.creature_started == 1) usr.creature_started = 0
						src.menu.clear_portrait_vis()
						usr.switch_race("Tuffle")
						var/obj/txt = src.menu.lore_txt
						txt.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Tuffle</u>\n<text align=left valign=top>[text_tuffle]"
						var/obj/txt_pro = src.menu.pro_txt
						txt_pro.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Traits</u><text align=left valign=top><font color = green>[text_tuffle_pros]"
						var/obj/txt_con = src.menu.con_txt
						txt_con.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Home World</u><text align=left valign=top><font color = white>[text_tuffle_cons]"
						src.menu.reset_bars()

						//Copy the players in-game avatar icon, but save the layer/plane/transform.
						src.menu.menu_avatar()
						//Update the players portrait, if they have one, to reflect the new race choice.
						src.menu.update_portrait_transform()
						if(src.clicked)
							src.switch_buttons()
							src.clicked = 0
							src.icon_state = "tuffle not selected"
						else
							src.switch_buttons()
							src.clicked = 1
							src.icon_state = "tuffle selected"

					New()
						src.og_state = "tuffle not selected"
						return
				race_button_blank
					icon = 'new_hud_race_select.dmi'
					icon_state = "not selected"
					hud_x = 0
					hud_y = 281
					Click()

						if(src.clicked)
							src.switch_buttons()
							src.clicked = 0
							src.icon_state = "not selected"
						else
							src.switch_buttons()
							src.clicked = 1
							src.icon_state = "not selected"
					New()
						src.og_state = "not selected"
						return
				arrow_left
					icon = 'char_creation_arrows.dmi'
					icon_state = "left"
					//KEEP_TOGETHER | TILE_BOUND
					layer=30
					plane = 35
					Click()
						var/current_time = world.time
						if(current_time - usr.last_click_time < 3) // 10 = 1 second (BYOND uses 1/10th sec units)
							return
						usr.last_click_time = current_time
						if(usr.offspring) return
						switch(src.arrow_tag)
							if("energy minus")
								usr.mod_points("-","energy")
								if(usr.hud_char)
									var/obj/hud/menus/char_creation_background/c = usr.hud_char
									if(c.num_eng) c.num_eng.maptext = "[css_outline]<font size = 1><center>[usr.mod_energy_points]"
							if("strength minus")
								usr.mod_points("-","strength")
								if(usr.hud_char)
									var/obj/hud/menus/char_creation_background/c = usr.hud_char
									if(c.num_str) c.num_str.maptext = "[css_outline]<font size = 1><center>[usr.mod_strength_points]"
							if("endurance minus")
								usr.mod_points("-","endurance")
								if(usr.hud_char)
									var/obj/hud/menus/char_creation_background/c = usr.hud_char
									if(c.num_end) c.num_end.maptext = "[css_outline]<font size = 1><center>[usr.mod_endurance_points]"
							if("agility minus")
								usr.mod_points("-","agility")
								if(usr.hud_char)
									var/obj/hud/menus/char_creation_background/c = usr.hud_char
									if(c.num_agi) c.num_agi.maptext = "[css_outline]<font size = 1><center>[usr.mod_agility_points]"
							if("resistance minus")
								usr.mod_points("-","resistance")
								if(usr.hud_char)
									var/obj/hud/menus/char_creation_background/c = usr.hud_char
									if(c.num_res) c.num_res.maptext = "[css_outline]<font size = 1><center>[usr.mod_resistance_points]"
							if("regen minus")
								usr.mod_points("-","regen")
								if(usr.hud_char)
									var/obj/hud/menus/char_creation_background/c = usr.hud_char
									if(c.num_regen) c.num_regen.maptext = "[css_outline]<font size = 1><center>[usr.mod_regeneration_points]"
							if("recovery minus")
								usr.mod_points("-","recovery")
								if(usr.hud_char)
									var/obj/hud/menus/char_creation_background/c = usr.hud_char
									if(c.num_recov) c.num_recov.maptext = "[css_outline]<font size = 1><center>[usr.mod_recovery_points]"
							if("offence minus")
								usr.mod_points("-","offence")
								if(usr.hud_char)
									var/obj/hud/menus/char_creation_background/c = usr.hud_char
									if(c.num_off) c.num_off.maptext = "[css_outline]<font size = 1><center>[usr.mod_offence_points]"
							if("defence minus")
								usr.mod_points("-","defence")
								if(usr.hud_char)
									var/obj/hud/menus/char_creation_background/c = usr.hud_char
									if(c.num_def) c.num_def.maptext = "[css_outline]<font size = 1><center>[usr.mod_defence_points]"
							if("force minus")
								usr.mod_points("-","force")
								if(usr.hud_char)
									var/obj/hud/menus/char_creation_background/c = usr.hud_char
									if(c.num_for) c.num_for.maptext = "[css_outline]<font size = 1><center>[usr.mod_force_points]"
							if("skin minus")
								usr.update_looks("- skin")
								if(usr.port && usr.hud_char)
									//Adjust players portrait first.
									usr.hud_char.update_portrait_transform()
									//Adjust players in-game avatar next.
									usr.hud_char.menu_avatar()
							if("nose minus")
								usr.update_looks("- nose")
								if(usr.port && usr.hud_char)
									//Adjust players portrait first.
									usr.hud_char.update_portrait_transform()
									//Adjust players in-game avatar next.
									usr.hud_char.menu_avatar()
							if("mouth minus")
								usr.update_looks("- mouth")
								if(usr.port && usr.hud_char)
									//Adjust players portrait first.
									usr.hud_char.update_portrait_transform()
									//Adjust players in-game avatar next.
									usr.hud_char.menu_avatar()
							if("body minus")
								usr.update_looks("- body")
								if(usr.port && usr.hud_char)
									//Adjust players portrait first.
									var/obj/hud/menus/char_creation_background/c = usr.hud_char

									usr.hud_char.update_portrait_transform()
									//Adjust players in-game avatar next.
									usr.hud_char.menu_avatar()
									usr.bodysize("-")
									if(c.text_bodysize)
										if(usr.bodysize == 3) c.text_bodysize.maptext = "[css_outline]<font size = 1><center>Large"
										if(usr.bodysize == 2) c.text_bodysize.maptext = "[css_outline]<font size = 1><center>Medium"
										if(usr.bodysize == 1) c.text_bodysize.maptext = "[css_outline]<font size = 1><center>Small"
							if("eyes minus")
								usr.update_looks("- eyes")
								if(usr.port && usr.hud_char)
									//Adjust players portrait first.
									usr.hud_char.update_portrait_transform()
									//Adjust players in-game avatar next.
									usr.hud_char.menu_avatar()
							if("hair minus")
								usr.update_looks("-")
								if(usr.port && usr.hud_char)
									//Adjust players portrait first.
									usr.hud_char.update_portrait_transform()
									//Adjust players in-game avatar next.
									usr.hud_char.menu_avatar()
							if("sex minus")
								usr.update_looks("gender")
								if(usr.port && usr.hud_char)
									//Adjust players portrait first.
									usr.hud_char.update_portrait_transform()
									//Adjust players in-game avatar next.
									usr.hud_char.menu_avatar()
					New()
						return
					MouseEntered()
						src.icon_state = "left hover"
						/*
						animate(src)
						var/matrix/m = matrix()
						m.Scale(1.3,1.3)
						m.Translate(src.hud_x,src.hud_y)
						animate(src,transform = m,time = 2)
						*/
					MouseExited()
						src.icon_state = "left"
						/*
						animate(src)
						var/matrix/m = matrix()
						m.Scale(1,1)
						m.Translate(src.hud_x,src.hud_y)
						animate(src,transform = m,time = 2)
						*/
				arrow_right
					icon = 'char_creation_arrows.dmi'
					icon_state = "right"
					//appearance_flags =  KEEP_TOGETHER | TILE_BOUND //PIXEL_SCALE
					layer=30
					plane = 35
					Click()
						var/current_time = world.time
						if(current_time - usr.last_click_time < 3) // 10 = 1 second (BYOND uses 1/10th sec units)
							return
						usr.last_click_time = current_time
						if(usr.offspring) return
						switch(src.arrow_tag)
							if("energy add")
								usr.mod_points("+","energy")
								if(usr.hud_char)
									var/obj/hud/menus/char_creation_background/c = usr.hud_char
									if(c.num_eng) c.num_eng.maptext = "[css_outline]<font size = 1><center>[usr.mod_energy_points]"
							if("strength add")
								usr.mod_points("+","strength")
								if(usr.hud_char)
									var/obj/hud/menus/char_creation_background/c = usr.hud_char
									if(c.num_str) c.num_str.maptext = "[css_outline]<font size = 1><center>[usr.mod_strength_points]"
							if("endurance add")
								usr.mod_points("+","endurance")
								if(usr.hud_char)
									var/obj/hud/menus/char_creation_background/c = usr.hud_char
									if(c.num_end) c.num_end.maptext = "[css_outline]<font size = 1><center>[usr.mod_endurance_points]"
							if("agility add")
								usr.mod_points("+","agility")
								if(usr.hud_char)
									var/obj/hud/menus/char_creation_background/c = usr.hud_char
									if(c.num_agi) c.num_agi.maptext = "[css_outline]<font size = 1><center>[usr.mod_agility_points]"
							if("resistance add")
								usr.mod_points("+","resistance")
								if(usr.hud_char)
									var/obj/hud/menus/char_creation_background/c = usr.hud_char
									if(c.num_res) c.num_res.maptext = "[css_outline]<font size = 1><center>[usr.mod_resistance_points]"
							if("regen add")
								usr.mod_points("+","regen")
								if(usr.hud_char)
									var/obj/hud/menus/char_creation_background/c = usr.hud_char
									if(c.num_regen) c.num_regen.maptext = "[css_outline]<font size = 1><center>[usr.mod_regeneration_points]"
							if("recovery add")
								usr.mod_points("+","recovery")
								if(usr.hud_char)
									var/obj/hud/menus/char_creation_background/c = usr.hud_char
									if(c.num_recov) c.num_recov.maptext = "[css_outline]<font size = 1><center>[usr.mod_recovery_points]"
							if("offence add")
								usr.mod_points("+","offence")
								if(usr.hud_char)
									var/obj/hud/menus/char_creation_background/c = usr.hud_char
									if(c.num_off) c.num_off.maptext = "[css_outline]<font size = 1><center>[usr.mod_offence_points]"
							if("defence add")
								usr.mod_points("+","defence")
								if(usr.hud_char)
									var/obj/hud/menus/char_creation_background/c = usr.hud_char
									if(c.num_def) c.num_def.maptext = "[css_outline]<font size = 1><center>[usr.mod_defence_points]"
							if("force add")
								usr.mod_points("+","force")
								if(usr.hud_char)
									var/obj/hud/menus/char_creation_background/c = usr.hud_char
									if(c.num_for) c.num_for.maptext = "[css_outline]<font size = 1><center>[usr.mod_force_points]"
							if("skin add")
								usr.update_looks("+ skin")
								if(usr.port && usr.hud_char)
									//Adjust players portrait first.
									usr.hud_char.update_portrait_transform()
									//Adjust players in-game avatar next.
									usr.hud_char.menu_avatar()
							if("nose add")
								usr.update_looks("+ nose")
								if(usr.port && usr.hud_char)
									//Adjust players portrait first.
									usr.hud_char.update_portrait_transform()
									//Adjust players in-game avatar next.
									usr.hud_char.menu_avatar()
							if("mouth add")
								usr.update_looks("+ mouth")
								if(usr.port && usr.hud_char)
									//Adjust players portrait first.
									usr.hud_char.update_portrait_transform()
									//Adjust players in-game avatar next.
									usr.hud_char.menu_avatar()
							if("body add")
								usr.update_looks("+ body")
								if(usr.port && usr.hud_char)
									//Adjust players portrait first.
									var/obj/hud/menus/char_creation_background/c = usr.hud_char
									usr.hud_char.update_portrait_transform()
									//Adjust players in-game avatar next.
									usr.hud_char.menu_avatar()
									usr.bodysize("+")
									if(c.text_bodysize)
										if(usr.bodysize == 3) c.text_bodysize.maptext = "[css_outline]<font size = 1><center>Large"
										if(usr.bodysize == 2) c.text_bodysize.maptext = "[css_outline]<font size = 1><center>Medium"
										if(usr.bodysize == 1) c.text_bodysize.maptext = "[css_outline]<font size = 1><center>Small"
							if("eyes add")
								usr.update_looks("+ eyes")
								if(usr.port && usr.hud_char)
									//Adjust players portrait first.
									usr.hud_char.update_portrait_transform()
									//Adjust players in-game avatar next.
									usr.hud_char.menu_avatar()
							if("hair add")
								usr.update_looks("+")
								if(usr.port && usr.hud_char)
									//Adjust players portrait first.
									usr.hud_char.update_portrait_transform()
									//Adjust players in-game avatar next.
									usr.hud_char.menu_avatar()
							if("sex add")
								usr.update_looks("gender")
								if(usr.port && usr.hud_char)
									//Adjust players portrait first.
									usr.hud_char.update_portrait_transform()
									//Adjust players in-game avatar next.
									usr.hud_char.menu_avatar()
					New()
						return
					MouseEntered()
						src.icon_state = "right hover"
						/*
						animate(src)
						var/matrix/m = matrix()
						m.Scale(1.3,1.3)
						m.Translate(src.hud_x,src.hud_y)
						animate(src,transform = m,time = 2)
						*/
					MouseExited()
						src.icon_state = "right"
						/*
						animate(src)
						var/matrix/m = matrix()
						m.Scale(1,1)
						m.Translate(src.hud_x,src.hud_y)
						animate(src,transform = m,time = 2)
						*/
			load_background
				icon = 'new_hud_load.dmi'
				icon_state="1"
				layer = 32
				screen_loc = "CENTER-5,CENTER"
				plane = 22
				var/obj/sav_txt1
				var/obj/sav_txt2
				var/obj/sav_txt3
				var/obj/but_new_01
				var/obj/but_new_02
				var/obj/but_new_03
				var/obj/but_del_01
				var/obj/but_del_02
				var/obj/but_del_03
				var/obj/port1
				var/obj/port2
				var/obj/port3
				var/obj/txt_title
				proc
					menu_create()
						var/obj/hud/menus/load_background/txt_title/title = new
						var/matrix/m_t = matrix()
						m_t.Translate(title.hud_x,title.hud_y)
						title.transform = m_t
						title.maptext = "[css_outline]<font size = 1><center>Character Selection"
						src.vis_contents += title
						src.txt_title = title

						var/obj/hud/menus/load_background/new_load_button_01/n1 = new
						var/matrix/m_n1 = matrix()
						m_n1.Translate(n1.hud_x,n1.hud_y)
						n1.transform = m_n1
						n1.maptext = "[css_outline]<font size = 1><center>New"
						src.vis_contents += n1
						src.but_new_01 = n1

						var/obj/hud/menus/load_background/new_load_button_02/n2 = new
						var/matrix/m_n2 = matrix()
						m_n2.Translate(n2.hud_x,n2.hud_y)
						n2.transform = m_n2
						n2.maptext = "[css_outline]<font size = 1><center>New"
					//	src.vis_contents += n2
					//	src.but_new_02 = n2

						var/obj/hud/menus/load_background/new_load_button_03/n3 = new
						var/matrix/m_n3 = matrix()
						m_n3.Translate(n3.hud_x,n3.hud_y)
						n3.transform = m_n3
						n3.maptext = "[css_outline]<font size = 1><center>New"
					//	src.vis_contents += n3
					//	src.but_new_03 = n3

						var/obj/hud/menus/load_background/delete_button_01/d1 = new
						var/matrix/m_d1 = matrix()
						m_d1.Translate(d1.hud_x,d1.hud_y)
						d1.transform = m_d1
						d1.maptext = "[css_outline]<font size = 1><center>Delete"
						src.but_del_01 = d1

					//	var/obj/hud/menus/load_background/delete_button_02/d2 = new
					//	var/matrix/m_d2 = matrix()
						//m_d2.Translate(d2.hud_x,d2.hud_y)
						//d2.transform = m_d2
						//d2.maptext = "[css_outline]<font size = 1><center>Delete"
					//	src.but_del_02 = d2

					//	var/obj/hud/menus/load_background/delete_button_03/d3 = new
					//	var/matrix/m_d3 = matrix()
						//m_d3.Translate(d3.hud_x,d3.hud_y)
						//d3.transform = m_d3
						//d3.maptext = "[css_outline]<font size = 1><center>Delete"
					//	src.but_del_03 = d3

						var/obj/hud/menus/load_background/txt_save/ts1 = new
						var/matrix/m_s1 = matrix()
						m_s1.Translate(ts1.hud_x,ts1.hud_y)
						ts1.transform = m_s1
						src.vis_contents += ts1
						src.sav_txt1 = ts1

					//	var/obj/hud/menus/load_background/txt_save/ts2 = new
					//	var/matrix/m_s2 = matrix()
						//m_s2.Translate(77,58)
						//ts2.transform = m_s2
					//	src.vis_contents += ts2
					//	src.sav_txt2 = ts2

					//	var/obj/hud/menus/load_background/txt_save/ts3 = new
					//	var/matrix/m_s3 = matrix()
					//	m_s3.Translate(77,-36)
					//	ts3.transform = m_s3
					//	src.vis_contents += ts3
					//	src.sav_txt3 = ts3
				new_load_button_01
					icon = 'load_buttons.dmi'
					icon_state = "normal"
					layer = 32
					plane = 22
					hud_x = 76
					hud_y = 95
					maptext_width = 52
					maptext_height = 18
					maptext_y = 3
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					Click()
						var/current_time = world.time
						if(current_time - usr.last_click_time < 10) // 10 = 1 second (BYOND uses 1/10th sec units)
							return
						usr.last_click_time = current_time
						usr.save_load(1)
						return
					New()
						return
					MouseEntered()
						src.icon_state = "hover"
					MouseExited()
						src.icon_state = "normal"
				new_load_button_02
					icon = 'load_buttons.dmi'
					icon_state = "normal"
					layer = 32
					plane = 22
				//	hud_x = 76
				//	hud_y = 102
					maptext_width = 52
					maptext_height = 18
					maptext_y = 3
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					Click()
						var/current_time = world.time
						if(current_time - usr.last_click_time < 10) // 10 = 1 second (BYOND uses 1/10th sec units)
							return
						usr.last_click_time = current_time
						usr.save_load(2)
						return
					New()
						return
					MouseEntered()
						src.icon_state = "hover"
					MouseExited()
						src.icon_state = "normal"
				new_load_button_03
					icon = 'load_buttons.dmi'
					icon_state = "normal"
					layer = 32
					plane = 22
				//	hud_x = 76
				//	hud_y = 8
					maptext_width = 52
					maptext_height = 18
					maptext_y = 3
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					Click()
						var/current_time = world.time
						if(current_time - usr.last_click_time < 10) // 10 = 1 second (BYOND uses 1/10th sec units)
							return
						usr.last_click_time = current_time
						usr.save_load(3)
						return
					New()
						return
					MouseEntered()
						src.icon_state = "hover"
					MouseExited()
						src.icon_state = "normal"
				txt_title
					icon = null
					layer = 32
					plane = 22
					hud_x = 67
					hud_y = 175
					maptext_width = 128
					maptext_height = 16
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					New()
						return
				txt_save
					icon = null
					layer = 32
					plane = 22
					hud_x = 77
					hud_y = 50
					maptext_width = 128
					maptext_height = 128
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					New()
						return
				delete_button_01
					icon = 'load_buttons.dmi'
					icon_state = "normal"
					layer = 32
					plane = 22
					hud_x = 131
					hud_y = 95
					maptext_width = 52
					maptext_height = 18
					maptext_y = 3
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					Click()
						var/current_time = world.time
						if(current_time - usr.last_click_time < 10) // 10 = 1 second (BYOND uses 1/10th sec units)
							return
						usr.last_click_time = current_time
						usr.save_delete(1)

					New()
						return
					MouseEntered()
						src.icon_state = "hover"
					MouseExited()
						src.icon_state = "normal"
				delete_button_02
					icon = 'load_buttons.dmi'
					icon_state = "normal"
					layer = 32
					plane = 22
					hud_x = 131
					hud_y = 102
					maptext_width = 52
					maptext_height = 18
					maptext_y = 3
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					Click()
						var/current_time = world.time
						if(current_time - usr.last_click_time < 10) // 10 = 1 second (BYOND uses 1/10th sec units)
							return
						usr.last_click_time = current_time
						usr.save_delete(2)
					New()
						return
					MouseEntered()
						src.icon_state = "hover"
					MouseExited()
						src.icon_state = "normal"
				delete_button_03
					icon = 'load_buttons.dmi'
					icon_state = "normal"
					layer = 32
					plane = 22
					hud_x = 131
					hud_y = 8
					maptext_width = 52
					maptext_height = 18
					maptext_y = 3
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					Click()
						usr.save_delete(3)
					New()
						return
					MouseEntered()
						src.icon_state = "hover"
					MouseExited()
						src.icon_state = "normal"
			contacts_background
				//Tabs for "Players","Relations", "Followers" and "Quests/Missions"

				/*
				Could display server name at top, how long it's been open, and the server status too. i.e, "Server Open", ect ect.


				.:Players tab:.

				What it looks like and does...
				- So this one would be like, the social tab for WoW, where you can add friends, ect.
				- Should display total players at top
				- Have a mute button at the side of the players name, so players don't have to listen to others. (Different from admin mute)
				- Have an "invite" button, to create groups with others
				- Have a "friend" button, so you can add them to your friends list
				- Should be able to sort them by friends, ect (Little drop down menu)
				- Would probably only be the players "Steam/Byond Key" displayed, and if the server is not in rp mode, probably their Character name also
				- Might be good to have their name colored, or have a tag if they're an admin, host, ect.
				- Add a search bar once text input is added
				- Have the players friends list save the same way their save/load data is, instead of per character.

				.:Relations tab:.

				What it looks like and does...
				- This is like the old "contacts" tab, where anyone you meet is placed here, so you can track who you've met before in game.
				- Should be able to set relations here for various bonuses
				- Could also sort the contacts by players, npc, ect (Little drop down menu)
				- Color the names text to the color of the race text, i.e, Demon = Red
				- Sort by last met shoulc/could probably just have a single num, like 1632, so long as that number is lower than previous contacts
				- Shows portraits of the contact
				- Add a search bar once text input is added
				 - Race
				 - Name
				 - Relation
				 - Relation Score if there's room?
				 - Location

				What it needs next...
				- Need a sort button
				- Need to apply AND make use of the info_ vars assigned to the contacts
				- Need a button in the top right of the contact which is a cross, which can remove that contact, for whatever reason
				- Add a search bar once text input is added

				When a contact is clicked
				- Should show the last stat info from when that mob was last d, otherwise will show ???'s
				- Bounty?
				- Race
				- Name
				- Last Location seen


				.:Followers tab:.

				What it looks like and does...
				- Shows a list of all the followrs you have, including split forms, ect.
				- Should be able to sort them by certain things, such as by "Splitforms", "Clones", "Core Followers", ect (Little drop down menu)
				- Possibly by relations too? (Little drop down menu)
				- Color the names text to the color of the race text, i.e, Demon = Red
				- Should have a bunch of buttons in the holder_info plane that lets you control the follower?

				*/
				icon = 'new_hud_contacts2.dmi'
				icon_state = "empty"
				layer = 32
				screen_loc = "1,1"
				plane = 28
				appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
				var/setup = 0
				var/icon/I
				var/ww = 0
				var/hh = 0
				var/contacts_background_x = 300
				var/contacts_background_y = 100
				var/obj/hud/menus/contacts_background/menu
				var/selected = 1
				var/list/tabs
				var/list/bar_pos_y_info = list(0,0,0,0)
				var/list/bar_pos_y_main = list(0,0,0,0)
				var/list/scroller_transforms_main = list(null,null,null,null)
				var/list/scroller_transforms_info = list(null,null,null,null)
				var/obj/scroller_main
				var/obj/scroller_info
				var/obj/holder_main
				var/obj/holder_info
				var/obj/txt_relations
				var/obj/txt_info
				var/obj/txt_info_player
				var/obj/txt_name
				var/obj/txt_players_online
				var/obj/info_port
				var/obj/hud/menus/contacts_background/sort_box
				var/obj/hud/menus/contacts_background/contacts_relation_dropdown/relations_box
				var/obj/hud/menus/contacts_background/contacts_players_dropdown/players_box
				var/list/sort_boxes
				var/list/relation_buttons
				var/list/player_bars
				var/list/player_social
				var/sort_type
				var/contacts_size = 0
				var/players_size = 0
				var/list/buttons
				var/obj/quests/q_personal
				var/obj/quests/q_tutorials
				var/obj/quests/q_rumours
				var/obj/quests/q_completed
				var/quest_size = 0
				var/obj/quest_selected = null
				var/list/total_quests = list()
				var/list/organized_quests[0]
				New()
					spawn(20)
						if(src)
							if(ismob(src.loc))
								var/mob/m = src.loc
								src.display_contacts(m,m.player_contacts)
								src.quests(m)
								src.sort_quests()
								if(src.selected == 1)
									src.players("Online")
					return
				MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
					params = params2list(params)
					var/icon_y = text2num(params["icon-y"])
					if(icon_y >= 331 || usr.mouse_down)
						usr.client.MousePosition(params)
						var/matrix/m = matrix()
						var/icon_x = text2num(params["icon-x"])
						if(usr.drag_icon_x == 0) usr.drag_icon_x = icon_x
						var/x_result = usr.client.client_mouse_x-usr.drag_icon_x
						var/y_result = usr.client.client_mouse_y-src.hh
						x_result = clamp(x_result,0,1023-src.ww)
						y_result = clamp(y_result,0,575-(src.hh/2))
						m.Translate(x_result,y_result)
						src.transform = m
						src.contacts_background_x = x_result
						src.contacts_background_y = y_result
						usr.mouse_down = src
				proc
					sort_quests()
						for(var/obj/quests/q in src.total_quests)
							switch(q.type)
							//Personal

								//Needs
								if(/obj/quests/personal/quest_needs/needs_hunger_high)
									src.organized_quests["needs_hunger_high"] = q
								if(/obj/quests/personal/quest_needs/needs_hunger_low)
									src.organized_quests["needs_hunger_low"] = q
								if(/obj/quests/personal/quest_needs/needs_rare_food)
									src.organized_quests["needs_rare_food"] = q
								if(/obj/quests/personal/quest_needs/needs_rest_high)
									src.organized_quests["needs_rest_high"] = q
								if(/obj/quests/personal/quest_needs/needs_rest_low)
									src.organized_quests["needs_rest_low"] = q
								if(/obj/quests/personal/quest_needs/needs_thirst_high)
									src.organized_quests["needs_thirst_high"] = q
								if(/obj/quests/personal/quest_needs/needs_thirst_low)
									src.organized_quests["needs_thirst_low"] = q
								//Stats
								if(/obj/quests/personal/quest_stats/test_agility)
									src.organized_quests["test_agility"] = q
								if(/obj/quests/personal/quest_stats/test_defence)
									src.organized_quests["test_defence"] = q
								if(/obj/quests/personal/quest_stats/test_endurance)
									src.organized_quests["test_endurance"] = q
								if(/obj/quests/personal/quest_stats/test_energy)
									src.organized_quests["test_energy"] = q
								if(/obj/quests/personal/quest_stats/test_force)
									src.organized_quests["test_force"] = q
								if(/obj/quests/personal/quest_stats/test_offence)
									src.organized_quests["test_offence"] = q
								if(/obj/quests/personal/quest_stats/test_power)
									src.organized_quests["test_power"] = q
								if(/obj/quests/personal/quest_stats/test_recovery)
									src.organized_quests["test_recovery"] = q
								if(/obj/quests/personal/quest_stats/test_regen)
									src.organized_quests["test_regen"] = q
								if(/obj/quests/personal/quest_stats/test_resistance)
									src.organized_quests["test_resistance"] = q
								if(/obj/quests/personal/quest_stats/test_strength)
									src.organized_quests["test_strength"] = q
								//Bodyparts
								if(/obj/quests/personal/quests_bodyparts/lvl_bodypart)
									src.organized_quests["lvl_bodypart"] = q
								if(/obj/quests/personal/quests_bodyparts/lvl_bodypart_specific)
									src.organized_quests["lvl_bodypart_specific"] = q
								//Environmental
								if(/obj/quests/personal/quests_environmental/env_breath)
									src.organized_quests["env_breath"] = q
								if(/obj/quests/personal/quests_environmental/env_cold)
									src.organized_quests["env_cold"] = q
								if(/obj/quests/personal/quests_environmental/env_grav)
									src.organized_quests["env_grav"] = q
								if(/obj/quests/personal/quests_environmental/env_heat)
									src.organized_quests["env_heat"] = q
								if(/obj/quests/personal/quests_environmental/env_micro)
									src.organized_quests["env_micro"] = q
								if(/obj/quests/personal/quests_environmental/env_rads)
									src.organized_quests["env_rads"] = q
								//General
								if(/obj/quests/personal/quests_general/gen_meditate)
									src.organized_quests["gen_meditate"] = q
								if(/obj/quests/personal/quests_general/gen_build)
									src.organized_quests["gen_build"] = q
								if(/obj/quests/personal/quests_general/gen_ascend)
									src.organized_quests["gen_ascend"] = q
								if(/obj/quests/personal/quests_general/gen_gather_resources)
									src.organized_quests["gen_gather_resources"] = q
								if(/obj/quests/personal/quests_general/gen_higher_realm)
									src.organized_quests["gen_higher_realm"] = q
								if(/obj/quests/personal/quests_general/gen_highest_realms)
									src.organized_quests["gen_highest_realms"] = q
								if(/obj/quests/personal/quests_general/gen_life_and_death)
									src.organized_quests["gen_life_and_death"] = q
								if(/obj/quests/personal/quests_general/gen_lvl_research)
									src.organized_quests["gen_lvl_research"] = q
								if(/obj/quests/personal/quests_general/gen_lvl_research_specific)
									src.organized_quests["gen_lvl_research_specific"] = q
								if(/obj/quests/personal/quests_general/gen_psiforged)
									src.organized_quests["gen_psiforged"] = q
								if(/obj/quests/personal/quests_general/gen_rest_month)
									src.organized_quests["gen_rest_month"] = q
								if(/obj/quests/personal/quests_general/gen_scientific_paper)
									src.organized_quests["gen_scientific_paper"] = q
								if(/obj/quests/personal/quests_general/gen_teach)
									src.organized_quests["gen_teach"] = q
								if(/obj/quests/personal/quests_general/gen_travel)
									src.organized_quests["gen_travel"] = q
								if(/obj/quests/personal/quests_general/gen_true_nature)
									src.organized_quests["gen_true_nature"] = q
								if(/obj/quests/personal/quests_general/gen_win_battle)
									src.organized_quests["gen_win_battle"] = q
								if(/obj/quests/personal/quests_general/gen_write_manual)
									src.organized_quests["gen_write_manual"] = q
								if(/obj/quests/personal/quests_general/gen_xp_chaos)
									src.organized_quests["gen_xp_chaos"] = q
								if(/obj/quests/personal/quests_general/gen_xp_peace)
									src.organized_quests["gen_xp_peace"] = q
							//Tutorials

								if(/obj/quests/tutorials/tutorial_drink)
									src.organized_quests["tutorial_drink"] = q
								if(/obj/quests/tutorials/tutorial_eat)
									src.organized_quests["tutorial_eat"] = q
								if(/obj/quests/tutorials/tutorial_environmentals)
									src.organized_quests["tutorial_environmentals"] = q
								if(/obj/quests/tutorials/tutorial_infuse)
									src.organized_quests["tutorial_infuse"] = q
								if(/obj/quests/tutorials/tutorial_lifespan)
									src.organized_quests["tutorial_lifespan"] = q
								if(/obj/quests/tutorials/tutorial_psiforge)
									src.organized_quests["tutorial_psiforge"] = q
								if(/obj/quests/tutorials/tutorial_sleep)
									src.organized_quests["tutorial_sleep"] = q
								if(/obj/quests/tutorials/tutorial_unlock_skill)
									src.organized_quests["tutorial_unlock_skill"] = q
								if(/obj/quests/tutorials/tutorial_use_skill)
									src.organized_quests["tutorial_use_skill"] = q
					quests(var/mob/m)
						src.holder_main.vis_contents = null
						src.quest_size = 0
						src.total_quests = list()


						//Find all the different types of quests inside the menus buttons list, then organise them all correctly into their individual roles
						var/quests_tutorials = list()
						var/quests_personal = list()
						var/quests_rumours = list()
						var/quests_completed = list()

						for(var/obj/quests/b in src.buttons)
							if(b.completed == 0)
								//Main tutorial button
								if(istype(b,/obj/quests/tutorials/))
									quests_tutorials += b
									src.total_quests += b
									//Sub tutorial buttons
									for(var/obj/quests/sub_b in b.buttons)
										src.total_quests += sub_b
										if(sub_b.completed == 0 && b.opened) quests_tutorials += sub_b
										else if(sub_b.completed)
											quests_completed += sub_b
											sub_b.hud_x = 26
								//Main personal button
								if(istype(b,/obj/quests/personal/))
									quests_personal += b
									src.total_quests += b
									//Sub personal buttons
									for(var/obj/quests/sub_b in b.buttons)
										src.total_quests += sub_b
										if(sub_b.completed == 0 && b.opened) quests_personal += sub_b
										else if(sub_b.completed)
											quests_completed += sub_b
											sub_b.hud_x = 26
										//Deepest personal buttons
										for(var/obj/quests/last_layer in sub_b.buttons)
											src.total_quests += last_layer
											if(last_layer.completed == 0 && b.opened && sub_b.opened) quests_personal += last_layer
											else if(last_layer.completed)
												quests_completed += last_layer
												last_layer.hud_x = 26
										//	if(last_layer.type == /obj/quests/personal/quests_bodyparts/lvl_bodypart_specific)
												//last_layer.quest_set_bodypart(m)
								//Main world button
								if(istype(b,/obj/quests/world_quests/))
									quests_rumours += b
									src.total_quests += b
									//Sub world buttons
									for(var/obj/quests/sub_b in b.buttons)
										src.total_quests += sub_b
										if(sub_b.completed == 0 && b.opened) quests_rumours += sub_b
										else if(sub_b.completed)
											quests_completed += sub_b
											sub_b.hud_x = 26
							else
								quests_completed += b

						var/yy = 268
						for(var/obj/quests/b in quests_tutorials)
							b.hud_y = yy
							var/matrix/mat = matrix()
							mat.Translate(b.hud_x,b.hud_y+src.bar_pos_y_main[src.selected])
							b.transform = mat
							src.holder_main.vis_contents += b
							b.maptext = "[css_outline]<font size = 2><text align=left valign=top>[b.info_name]"
							b.maptext_x = 16
							src.quest_size += 16
							yy -= 17

						for(var/obj/quests/b in quests_personal)
							b.hud_y = yy
							var/matrix/mat = matrix()
							mat.Translate(b.hud_x,b.hud_y+src.bar_pos_y_main[src.selected])
							b.transform = mat
							src.holder_main.vis_contents += b
							b.maptext = "[css_outline]<font size = 2><text align=left valign=top>[b.info_name]"
							b.maptext_x = 16
							src.quest_size += 16
							yy -= 17

						for(var/obj/quests/b in quests_rumours)
							b.hud_y = yy
							var/matrix/mat = matrix()
							mat.Translate(b.hud_x,b.hud_y+src.bar_pos_y_main[src.selected])
							b.transform = mat
							src.holder_main.vis_contents += b
							b.maptext = "[css_outline]<font size = 2><text align=left valign=top>[b.info_name]"
							b.maptext_x = 16
							src.quest_size += 16
							yy -= 17

						for(var/obj/quests/b in quests_completed)
							if(src.q_completed.opened || b == src.q_completed)
								b.hud_y = yy
								var/matrix/mat = matrix()
								mat.Translate(b.hud_x,b.hud_y+src.bar_pos_y_main[src.selected])
								b.transform = mat
								src.holder_main.vis_contents += b
								b.maptext = "[css_outline]<font size = 2><text align=left valign=top>[b.info_name]"
								b.maptext_x = 16
								src.quest_size += 16
								yy -= 17
					players(var/sort_kind)
						//Create or remove player bars as needed
						if(src.player_bars.len != global.players.len)
							src.player_bars = list()
							src.player_bars.len = global.players.len
							var/yy = 268
							var/pos = 0
							for(var/mob/m in global.players)
								pos += 1
								var/obj/hud/menus/contacts_background/contacts_player/p1 = new
								p1.hud_x = 10
								p1.hud_y = yy
								var/matrix/m_p1 = matrix()
								m_p1.Translate(p1.hud_x,p1.hud_y)
								p1.transform = m_p1
								src.player_bars += p1
								src.player_bars[pos] = p1
								if(m.client)
									p1.maptext = "[css_outline]<font size = 1><left>[m.key]"
									p1.name = m.key
									p1.info_name = m.key
									p1.info_auth = "Byond"
								else
									p1.maptext = "[css_outline]<font size = 1><left>[m.name]"
									p1.name = m.name
									p1.info_name = m.name
									p1.info_auth = "N/A"
								yy -= 22
								src.players_size += 10
						src.holder_main.vis_contents = null
						src.holder_main.vis_contents += src.txt_players_online
						src.holder_main.vis_contents += src.players_box
						if(sort_kind == "Online") src.txt_players_online.maptext = "[css_outline]<font size = 1><left>Players Online: [global.players.len]"
						for(var/obj/o in src.player_bars)
							src.holder_main.vis_contents += o
					contacts(var/mob/m,var/update = "both")
						//Updates just the maptext of the contacts, inside the main window (left window)
						if(m)
							var/obj/hud/menus/contacts_background/bg = src
							if(update == "both" || update == "all contacts")
								for(var/obj/hud/contact/c in m.player_contacts)
									c.maptext = "[css_outline]<font size = 1><text align=left valign=bottom>Name: [c.info_name]\nRace: [c.info_race]\nLast Seen: [c.info_last_seen] months ago\nLast Location: [c.info_last_loc]\nRelations: [c.info_relation]\nRelation Points: [c.info_relation_points]"
							if(update == "both" || update == "one contact")
								if(m.contact_selected)
									var/obj/hud/contact/c = m.contact_selected
									bg.holder_info.vis_contents += bg.txt_name
									bg.holder_info.vis_contents += bg.txt_info
									bg.txt_name.maptext = "[css_outline]<font size = 1><center><u>[c.info_name]</u>\n\n[c.info_race]"
									bg.txt_info.maptext = "[css_outline]<font size = 1><text align=left valign=top>Relation: \n\nRelation Points: [c.info_relation_points]\n\nLast Location: [c.info_last_loc]\n\nSeen: [c.info_last_seen] months ago\n\nLast known statistics\n\nEnergy: [c.txt_energy]\nStrength: [c.txt_strength]\nEndurance: [c.txt_endurance]\nAgility: [c.txt_agility]\nForce: [c.txt_force]\nResistance: [c.txt_resistance]\nOffence: [c.txt_offence]\nDefence: [c.txt_defence]\nRegeneration: [c.txt_regen]\nRecovery: [c.txt_recovery]"
									var/matrix/mat = matrix()
									mat.Translate(bg.txt_name.hud_x,bg.txt_name.hud_y)
									bg.txt_name.transform = mat
									bg.txt_info.maptext_width = 148
									var/matrix/m2 = matrix()
									m2.Translate(bg.txt_info.hud_x,bg.txt_info.hud_y)
									bg.txt_info.transform = m2
					display_contacts(var/mob/m,var/list/the_list)
						if(m)
							var/obj/hud/menus/contacts_background/bg = src
							bg.holder_main.vis_contents = null
							bg.holder_main.vis_contents += bg.sort_box
							var/xx = 14
							var/yy = 200
							for(var/obj/hud/contact/c in the_list)
								var/matrix/x = matrix()
								x.Translate(xx,yy)
								c.transform = x
								c.hud_x = xx
								c.hud_y = yy
								bg.holder_main.vis_contents += c
								if(c.txt_contact == null)
									var/obj/txt = new
									txt.maptext_width = 400
									txt.maptext_height = 96
									txt.plane = 28
									txt.layer = 34
									txt.blend_mode = BLEND_INSET_OVERLAY
									txt.appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
									txt.maptext = "[css_outline]<font size = 1><text align=left valign=bottom>Name: [c.info_name]\nRace: [c.info_race]\nLast Seen: [c.info_last_seen] months ago\nLast Location: [c.info_last_loc]\nRelations: [c.info_relation]\nRelation Points: [c.info_relation_points]"
									c.txt_contact = txt
								var/obj/txt_c = c.txt_contact
								var/matrix/x2 = matrix()
								x2.Translate(xx+68,yy+5)
								txt_c.transform = x2
								txt_c.hud_x = xx+68
								txt_c.hud_y = yy+5
								bg.holder_main.vis_contents += txt_c
								yy -= 91
								src.contacts_size += 64
					menu_create()
						if(src.setup)
							return
						spawn(10)
							if(src)
								src.setup = 1
								src.tabs = list()
								src.player_bars = list()
								src.player_social = list()

								src.I = new(src.icon)
								src.ww = I.Width()
								src.hh = I.Height()

								var/matrix/m_main = matrix()
								m_main.Translate(300,100)
								src.transform = m_main

								var/obj/hud/buttons/close_menu/cm = new
								cm.plane = src.plane
								cm.closes = src
								var/matrix/close_m = matrix()
								close_m.Translate(src.ww-15,src.hh-15)
								cm.transform = close_m
								src.vis_contents += cm

								var/obj/hud/menus/contacts_background/contacts_tab1/tab1 = new
								var/matrix/m1 = matrix()
								m1.Translate(tab1.hud_x,tab1.hud_y)
								tab1.transform = m1
								tab1.menu = src
								src.vis_contents += tab1
								src.tabs += tab1

								var/obj/hud/menus/contacts_background/contacts_tab2/tab2 = new
								var/matrix/m2 = matrix()
								m2.Translate(tab2.hud_x,tab2.hud_y)
								tab2.transform = m2
								tab2.menu = src
								src.vis_contents += tab2
								src.tabs += tab2

								//var/obj/hud/menus/contacts_background/contacts_tab3/tab3 = new
								//var/matrix/m3 = matrix()
								//m3.Translate(tab3.hud_x,tab3.hud_y)
								//tab3.transform = m3
								//tab3.menu = src
								//src.vis_contents += tab3
								//src.tabs += tab3

								var/obj/hud/menus/contacts_background/contacts_tab4/tab4 = new
								var/matrix/m4 = matrix()
								m4.Translate(tab4.hud_x,tab4.hud_y)
								tab4.transform = m4
								tab4.menu = src
								src.vis_contents += tab4
								src.tabs += tab4

								var/obj/hud/menus/contacts_background/contacts_title/title = new
								title.maptext = "[css_outline]<font size = 1><center>Relations & Questlog"
								var/matrix/m_rq = matrix()
								m_rq.Translate(227,338)
								title.transform = m_rq
								title.menu = src
								src.vis_contents += title

								var/obj/hud/menus/contacts_background/contacts_title/tab1_txt = new
								tab1_txt.maptext = "[css_outline]<font size = 1><center>Players"
								var/matrix/m_t1 = matrix()
								m_t1.Translate(9,319)
								tab1_txt.transform = m_t1
								tab1_txt.menu = src
								src.vis_contents += tab1_txt

								var/obj/hud/menus/contacts_background/contacts_title/tab2_txt = new
								tab2_txt.maptext = "[css_outline]<font size = 1><center>Relations"
								var/matrix/m_t2 = matrix()
								m_t2.Translate(81,319)
								tab2_txt.transform = m_t2
								tab2_txt.menu = src
								src.vis_contents += tab2_txt

								//var/obj/hud/menus/contacts_background/contacts_title/tab3_txt = new
							//	tab3_txt.maptext = "[css_outline]<font size = 1><center>Followers"
							//	var/matrix/m_t3 = matrix()
							//	m_t3.Translate(151,319)
							//	tab3_txt.transform = m_t3
								//tab3_txt.menu = src
								//src.vis_contents += tab3_txt

								var/obj/hud/menus/contacts_background/contacts_title/tab4_txt = new
								tab4_txt.maptext = "[css_outline]<font size = 1><center>Quests"
								var/matrix/m_t4 = matrix()
								m_t4.Translate(151,319)
								tab4_txt.transform = m_t4
								tab4_txt.menu = src
								src.vis_contents += tab4_txt

								var/obj/hud/menus/contacts_background/contacts_bar_info/bar1 = new
								bar1.menu = src
								src.vis_contents += bar1

								var/obj/hud/menus/contacts_background/contacts_bar_main/bar2 = new
								bar2.menu = src
								src.vis_contents += bar2

								var/obj/hud/menus/contacts_background/contacts_scroller_main/scroller1 = new
								scroller1.menu = src
								src.vis_contents += scroller1
								src.scroller_main = scroller1

								var/obj/hud/menus/contacts_background/contacts_scroller_info/scroller2 = new
								scroller2.menu = src
								src.vis_contents += scroller2
								src.scroller_info = scroller2

								var/obj/hud/menus/contacts_background/contacts_holder_info/holder1 = new
								holder1.menu = src
								src.vis_contents += holder1
								src.holder_info = holder1

								var/obj/hud/menus/contacts_background/contacts_holder_main/holder2 = new
								holder2.menu = src
								src.vis_contents += holder2
								src.holder_main = holder2

								src.buttons = list(new /:completed,new /:tutorials,new /:personal,new /:world_quests)
								src.q_completed = src.buttons[1]
								src.q_tutorials = src.buttons[2]
								src.q_personal = src.buttons[3]
								src.q_rumours = src.buttons[4]
								//src.buttons = list()
								//var/yy = 268
								for(var/obj/quests/b in src.buttons)
									b.menu = src

								src.q_tutorials.icon_state = "plus"
								src.q_personal.icon_state = "plus"
								src.q_rumours.icon_state = "plus"
								src.q_completed.icon_state = "plus"


								var/obj/hud/menus/contacts_background/contacts_relation_dropdown/bar3 = new
								bar3.menu = src
								var/matrix/m_bar1 = matrix()
								m_bar1.Translate(bar3.hud_x,bar3.hud_y)
								bar3.transform = m_bar1
								src.relations_box = bar3
								//holder1.vis_contents += bar3

								var/obj/hud/menus/contacts_background/contacts_info_txt/txt1 = new
								txt1.menu = src
								var/matrix/m_txt1 = matrix()
								m_txt1.Translate(txt1.hud_x,txt1.hud_y)
								txt1.transform = m_txt1
								holder1.vis_contents += txt1
								src.txt_info = txt1

								var/obj/hud/menus/contacts_background/contacts_name/txt2 = new
								txt2.menu = src
								//txt2.maptext = "[css_outline]<font size = 1><center><u>Name"
								var/matrix/m_txt2 = matrix()
								m_txt2.Translate(txt2.hud_x,txt2.hud_y)
								txt2.transform = m_txt2
								//holder1.vis_contents += txt2
								src.txt_name = txt2

								var/obj/hud/menus/contacts_background/contacts_info_txt_player/txt3 = new
								txt3.menu = src
								var/matrix/m_txt3 = matrix()
								m_txt3.Translate(txt3.hud_x,txt3.hud_y)
								txt3.transform = m_txt3
								src.txt_info_player = txt3

								var/obj/hud/menus/contacts_background/contacts_portrait_info/port1 = new
								port1.menu = src
								var/matrix/m_port1 = matrix()
								m_port1.Translate(port1.hud_x,port1.hud_y)
								port1.transform = m_port1
								src.info_port = port1

								var/obj/hud/menus/contacts_background/contacts_sort_bar/box1 = new
								box1.menu = src
								var/matrix/m_box1 = matrix()
								m_box1.Translate(box1.hud_x,box1.hud_y)
								box1.transform = m_box1
								src.sort_box = box1

								var/obj/hud/menus/contacts_background/contacts_players_dropdown/box2 = new
								box2.menu = src
								var/matrix/m_box2 = matrix()
								m_box2.Translate(box2.hud_x,box2.hud_y)
								box2.transform = m_box2
								src.players_box = box2

								//----------------------------------------------------------------------------
								//Buttons - Contact organization
								var/obj/hud/menus/contacts_background/contacts_sort_button/but1 = new
								but1.menu = src
								but1.hud_x = 190
								but1.hud_y = 165
								var/matrix/m_but1 = matrix()
								m_but1.Translate(but1.hud_x,but1.hud_y)
								but1.transform = m_but1
								but1.maptext = "[css_outline]<font size = 1><center>NPCs"
								but1.sort_type = "NPCs"

								var/obj/hud/menus/contacts_background/contacts_sort_button/but2 = new
								but2.menu = src
								but2.hud_x = 190
								but2.hud_y = 147
								var/matrix/m_but2 = matrix()
								m_but2.Translate(but2.hud_x,but2.hud_y)
								but2.transform = m_but2
								but2.maptext = "[css_outline]<font size = 1><center>Last Seen"
								but2.sort_type = "Last Seen"

								var/obj/hud/menus/contacts_background/contacts_sort_button/but3 = new
								but3.menu = src
								but3.hud_x = 190
								but3.hud_y = 129
								var/matrix/m_but3 = matrix()
								m_but3.Translate(but3.hud_x,but3.hud_y)
								but3.transform = m_but3
								but3.maptext = "[css_outline]<font size = 1><center>Location"
								but3.sort_type = "Location"

								var/obj/hud/menus/contacts_background/contacts_sort_button/but4 = new
								but4.menu = src
								but4.hud_x = 190
								but4.hud_y = 111
								var/matrix/m_but4 = matrix()
								m_but4.Translate(but4.hud_x,but4.hud_y)
								but4.transform = m_but4
								but4.maptext = "[css_outline]<font size = 1><center>Relations"
								but4.sort_type = "Relations"

								var/obj/hud/menus/contacts_background/contacts_sort_button/but5 = new
								but5.menu = src
								but5.hud_x = 190
								but5.hud_y = 93
								var/matrix/m_but5 = matrix()
								m_but5.Translate(but5.hud_x,but5.hud_y)
								but5.transform = m_but5
								but5.maptext = "[css_outline]<font size = 1><center>Points"
								but5.sort_type = "Points"

								var/obj/hud/menus/contacts_background/contacts_sort_button/but6 = new
								but6.menu = src
								but6.hud_x = 190
								but6.hud_y = 75
								var/matrix/m_but6 = matrix()
								m_but6.Translate(but6.hud_x,but6.hud_y)
								but6.transform = m_but6
								but6.maptext = "[css_outline]<font size = 1><center>Players"
								but6.sort_type = "Players"

								src.sort_boxes = list(but1,but2,but3,but4,but5,but6)

								//----------------------------------------------------------------------------

								//----------------------------------------------------------------------------
								//Buttons - Player sorting
								var/obj/hud/menus/contacts_background/contacts_players_button/social1 = new
								social1.menu = src
								social1.hud_x = 190
								social1.hud_y = 183
								var/matrix/m_soc1 = matrix()
								m_soc1.Translate(social1.hud_x,social1.hud_y)
								social1.transform = m_soc1
								social1.maptext = "[css_outline]<font size = 1><center>Online"
								social1.sort_type = "Online"

								var/obj/hud/menus/contacts_background/contacts_players_button/social2 = new
								social2.menu = src
								social2.hud_x = 190
								social2.hud_y = 165
								var/matrix/m_soc2 = matrix()
								m_soc2.Translate(social2.hud_x,social2.hud_y)
								social2.transform = m_soc2
								social2.maptext = "[css_outline]<font size = 1><center>Friends"
								social2.sort_type = "Friends"

								var/obj/hud/menus/contacts_background/contacts_players_button/social3 = new
								social3.menu = src
								social3.hud_x = 190
								social3.hud_y = 147
								var/matrix/m_soc3 = matrix()
								m_soc3.Translate(social3.hud_x,social3.hud_y)
								social3.transform = m_soc3
								social3.maptext = "[css_outline]<font size = 1><center>Sect/Guild"
								social3.sort_type = "Sect/Guild"

								var/obj/hud/menus/contacts_background/contacts_players_button/social4 = new
								social4.menu = src
								social4.hud_x = 190
								social4.hud_y = 129
								var/matrix/m_soc4 = matrix()
								m_soc4.Translate(social4.hud_x,social4.hud_y)
								social4.transform = m_soc4
								social4.maptext = "[css_outline]<font size = 1><center>Group"
								social4.sort_type = "Group"

								var/obj/hud/menus/contacts_background/contacts_players_button/social5 = new
								social5.menu = src
								social5.hud_x = 190
								social5.hud_y = 111
								var/matrix/m_soc5 = matrix()
								m_soc5.Translate(social5.hud_x,social5.hud_y)
								social5.transform = m_soc5
								social5.maptext = "[css_outline]<font size = 1><center>Ignored"
								social5.sort_type = "Ignored"

								src.player_social = list(social1,social2,social3,social4,social5)

								//----------------------------------------------------------------------------

								//----------------------------------------------------------------------------
								//Buttons - Set Relations
								var/obj/hud/menus/contacts_background/contacts_relation_button/r_but0 = new
								r_but0.menu = src
								r_but0.hud_x = 348
								r_but0.hud_y = 96
								var/matrix/m_r_but0 = matrix()
								m_r_but0.Translate(r_but0.hud_x,r_but0.hud_y)
								r_but0.transform = m_r_but0
								r_but0.maptext = "[css_outline]<font size = 1><center>None"
								r_but0.sort_type = "None"
								r_but0.tooltip = "<center>None"

								var/obj/hud/menus/contacts_background/contacts_relation_button/r_but1 = new
								r_but1.menu = src
								r_but1.hud_x = 348
								r_but1.hud_y = 78
								var/matrix/m_r_but1 = matrix()
								m_r_but1.Translate(r_but1.hud_x,r_but1.hud_y)
								r_but1.transform = m_r_but1
								r_but1.maptext = "[css_outline]<font size = 1><center>Friendship"
								r_but1.sort_type = "Friendship"
								r_but1.tooltip = "<text align=center valign=top>Friendship<text align=left valign=top><font color = grey>\n\n Acquaintance\n  - unlocks past 25 points\n  - other bonus here\n\n Friend\n  - unlocks past 50 points\n  - other bonus here\n\n Close Friend\n  - unlocks past 75 points\n  - other bonus here\n\n Best Friend\n  - unlocks past 100 points\n  - other bonus here\n\n<font color = white>Relation desc placeholder, will have a short bit of text, followed by a bit of fluff/lore text for flavour"

								var/obj/hud/menus/contacts_background/contacts_relation_button/r_but2 = new
								r_but2.menu = src
								r_but2.hud_x = 348
								r_but2.hud_y = 60
								var/matrix/m_r_but2 = matrix()
								m_r_but2.Translate(r_but2.hud_x,r_but2.hud_y)
								r_but2.transform = m_r_but2
								r_but2.maptext = "[css_outline]<font size = 1><center>Rivalry"
								r_but2.sort_type = "Rivalry"
								r_but2.tooltip = "<text align=center valign=top>Rivalry<text align=left valign=top><font color = grey>\n\n Competitor\n  - unlocks past 25 points\n  - other bonus here\n\n Rival\n  - unlocks past 50 points\n  - other bonus here\n\n Major Rival\n  - unlocks past 75 points\n  - other bonus here\n\n Extreme Rival\n  - unlocks past 100 points\n  - other bonus here\n\n<font color = white>Relation desc placeholder, will have a short bit of text, followed by a bit of fluff/lore text for flavour"

								var/obj/hud/menus/contacts_background/contacts_relation_button/r_but3 = new
								r_but3.menu = src
								r_but3.hud_x = 348
								r_but3.hud_y = 42
								var/matrix/m_r_but3 = matrix()
								m_r_but3.Translate(r_but3.hud_x,r_but3.hud_y)
								r_but3.transform = m_r_but3
								r_but3.maptext = "[css_outline]<font size = 1><center>Romantic"
								r_but3.sort_type = "Romantic"
								r_but3.tooltip = "<text align=center valign=top>Romantic<text align=left valign=top><font color = grey>\n\n Interest\n  - unlocks past 25 points\n  - other bonus here\n\n Infatuated\n  - unlocks past 50 points\n  - other bonus here\n\n Committed\n  - unlocks past 75 points\n  - other bonus here\n\n Lover\n  - unlocks past 100 points\n  - other bonus here\n\n<font color = white>Relation desc placeholder, will have a short bit of text, followed by a bit of fluff/lore text for flavour"

								var/obj/hud/menus/contacts_background/contacts_relation_button/r_but4 = new
								r_but4.menu = src
								r_but4.hud_x = 348
								r_but4.hud_y = 24
								var/matrix/m_r_but4 = matrix()
								m_r_but4.Translate(r_but4.hud_x,r_but4.hud_y)
								r_but4.transform = m_r_but4
								r_but4.maptext = "[css_outline]<font size = 1><center>Trust"
								r_but4.sort_type = "Trust"
								r_but4.tooltip = "<text align=center valign=top>Trust<text align=left valign=top><font color = grey>\n\n Associate\n  - unlocks past 25 points\n  - other bonus here\n\n Colleague\n  - unlocks past 50 points\n  - other bonus here\n\n Partner\n  - unlocks past 75 points\n  - other bonus here\n\n Ally\n  - unlocks past 100 points\n  - other bonus here\n\n<font color = white>Relation desc placeholder, will have a short bit of text, followed by a bit of fluff/lore text for flavour"

								var/obj/hud/menus/contacts_background/contacts_relation_button/r_but5 = new
								r_but5.menu = src
								r_but5.hud_x = 348
								r_but5.hud_y = 6
								var/matrix/m_r_but5 = matrix()
								m_r_but5.Translate(r_but5.hud_x,r_but5.hud_y)
								r_but5.transform = m_r_but5
								r_but5.maptext = "[css_outline]<font size = 1><center>Animosity"
								r_but5.sort_type = "Animosity"
								r_but5.tooltip = "<text align=center valign=top>Animosity<text align=left valign=top><font color = grey>\n\n Dislike\n  - unlocks past 25 points\n  - other bonus here\n\n Contempt\n  - unlocks past 50 points\n  - other bonus here\n\n Hatred\n  - unlocks past 75 points\n  - other bonus here\n\n Nemesis\n  - unlocks past 100 points\n  - other bonus here\n\n<font color = white>Relation desc placeholder, will have a short bit of text, followed by a bit of fluff/lore text for flavour"

								var/obj/hud/menus/contacts_background/contacts_relation_button/r_but6 = new
								r_but6.menu = src
								r_but6.hud_x = 348
								r_but6.hud_y = -12
								var/matrix/m_r_but6 = matrix()
								m_r_but6.Translate(r_but6.hud_x,r_but6.hud_y)
								r_but6.transform = m_r_but6
								r_but6.maptext = "[css_outline]<font size = 1><center>Respect"
								r_but6.sort_type = "Respect"
								r_but6.tooltip = "<text align=center valign=top>Respect<text align=left valign=top><font color = grey>\n\n Acknowledged\n  - unlocks past 25 points\n  - other bonus here\n\n Respected\n  - unlocks past 50 points\n  - other bonus here\n\n Admired\n  - unlocks past 75 points\n  - other bonus here\n\n Venerated\n  - unlocks past 100 points\n  - other bonus here\n\n<font color = white>Relation desc placeholder, will have a short bit of text, followed by a bit of fluff/lore text for flavour"

								var/obj/hud/menus/contacts_background/contacts_relation_button/r_but7 = new
								r_but7.menu = src
								r_but7.hud_x = 348
								r_but7.hud_y = -30
								var/matrix/m_r_but7 = matrix()
								m_r_but7.Translate(r_but7.hud_x,r_but7.hud_y)
								r_but7.transform = m_r_but7
								r_but7.maptext = "[css_outline]<font size = 1><center>Envy"
								r_but7.sort_type = "Envy"
								r_but7.tooltip = "<text align=center valign=top>Envy<text align=left valign=top><font color = grey>\n\n Covetous\n  - unlocks past 25 points\n  - other bonus here\n\n Jealous\n  - unlocks past 50 points\n  - other bonus here\n\n Obsessed\n  - unlocks past 75 points\n  - other bonus here\n\n Resentful\n  - unlocks past 100 points\n  - other bonus here\n\n<font color = white>Relation desc placeholder, will have a short bit of text, followed by a bit of fluff/lore text for flavour"

								var/obj/hud/menus/contacts_background/contacts_relation_button/r_but8 = new
								r_but8.menu = src
								r_but8.hud_x = 348
								r_but8.hud_y = -48
								var/matrix/m_r_but8 = matrix()
								m_r_but8.Translate(r_but8.hud_x,r_but8.hud_y)
								r_but8.transform = m_r_but8
								r_but8.maptext = "[css_outline]<font size = 1><center>Deception"
								r_but8.sort_type = "Deception"
								r_but8.tooltip = "<text align=center valign=top>Deception<text align=left valign=top><font color = grey>\n\n Distrusted\n  - unlocks past 25 points\n  - other bonus here\n\n Deceiver\n  - unlocks past 50 points\n  - other bonus here\n\n Betrayer\n  - unlocks past 75 points\n  - other bonus here\n\n Traitor\n  - unlocks past 100 points\n  - other bonus here\n\n<font color = white>Relation desc placeholder, will have a short bit of text, followed by a bit of fluff/lore text for flavour"

								src.relation_buttons = list(r_but0,r_but1,r_but2,r_but3,r_but4,r_but5,r_but6,r_but7,r_but8)

								//----------------------------------------------------------------------------

								var/obj/hud/menus/contacts_background/contacts_title/relation_txt_title = new
								relation_txt_title.maptext = "[css_outline]<font size = 1><center>Contacts: 0"
								var/matrix/m_rtt = matrix()
								relation_txt_title.hud_x = 42
								relation_txt_title.hud_y = 294
								m_rtt.Translate(42,296)
								relation_txt_title.transform = m_rtt
								relation_txt_title.menu = src
								relation_txt_title.blend_mode = BLEND_INSET_OVERLAY
								src.txt_relations = relation_txt_title

								var/obj/hud/menus/contacts_background/contacts_players_online/relation_txt_players = new
								relation_txt_players.maptext = "[css_outline]<font size = 1><left>Players Online: 0"
								var/matrix/m_p = matrix()
								m_p.Translate(42,296)
								relation_txt_players.transform = m_p
								relation_txt_players.menu = src
								src.txt_players_online = relation_txt_players
				contacts_portrait_info
					icon = 'hud_contact.dmi'
					icon_state = "port"
					layer = 33
					plane = 28
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					hud_x = 302
					hud_y = 245
					New()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
				contacts_players_online
					icon = null
					layer = 32
					plane = 28
					maptext_width = 128
					maptext_height = 16
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					hud_x = 42
					hud_y = 294
					maptext_x = -32
					New()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
				contacts_title
					icon = null
					layer = 32
					plane = 28
					maptext_width = 128
					maptext_height = 16
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					hud_x = 9
					hud_y = 319
					maptext_x = -32
					New()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
				contacts_name
					icon = null
					layer = 32
					plane = 28
					maptext_width = 196
					maptext_height = 64
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					hud_x = 358
					hud_y = 291
					maptext_x = -32
					New()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
				contacts_sort_button
					icon = 'hud_contacts_sorted.dmi'
					icon_state = "button"
					layer = 34
					plane = 28
					maptext_width = 96
					maptext_height = 18
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					hud_x = 190
					hud_y = 196
					maptext_x = -7
					maptext_y = 113
					Click()
						var/obj/hud/menus/contacts_background/bg = src.menu
						bg.sort_box.icon_state = "normal"
						for(var/obj/o in bg.sort_boxes)
							bg.holder_main.vis_contents -= o
						var/sort_box_type = bg.sort_box.sort_type
						var/sort_button_type = src.sort_type
						bg.sort_box.maptext = "[css_outline]<font size = 1><center>[sort_button_type]"
						bg.sort_box.sort_type = sort_button_type
						src.maptext = "[css_outline]<font size = 1><center>[sort_box_type]"
						src.sort_type = sort_box_type

						var/list/new_list = list()

						switch(bg.sort_box.sort_type)
							if("All")
								new_list = usr.player_contacts
								bg.display_contacts(usr,new_list)
							if("NPCs")
								for(var/obj/hud/contact/c in usr.player_contacts)
									if(c.info_client == "NPC") new_list += c
								bg.display_contacts(usr,new_list)
							if("Last Seen")
								return
							if("Players")
								for(var/obj/hud/contact/c in usr.player_contacts)
									if(c.info_client == "Player") new_list += c
								bg.display_contacts(usr,new_list)
							if("Location")
								for(var/obj/hud/contact/c in usr.player_contacts)
									if(c.info_last_loc == "Earth") new_list += c
								for(var/obj/hud/contact/c in usr.player_contacts)
									if(c.info_last_loc == "Yukopia") new_list += c
								for(var/obj/hud/contact/c in usr.player_contacts)
									if(c.info_last_loc == "Psionica") new_list += c
								for(var/obj/hud/contact/c in usr.player_contacts)
									if(c.info_last_loc == "Psionic Realm") new_list += c
								bg.display_contacts(usr,new_list)
							if("Relations")
								for(var/obj/hud/contact/c in usr.player_contacts)
									if(c.info_relation != "None") new_list += c
								bg.display_contacts(usr,new_list)
							if("Points")
								new_list = usr.player_contacts
								for(var/i = 1 to new_list.len - 1)
									for(var/j = i + 1 to new_list.len)
										var/obj/o = new_list[i]
										var/obj/o2 = new_list[j]
										if(o.info_relation_points > o2.info_relation_points)
											new_list.Swap(i, j)
								return
						bg.txt_relations.maptext = "[css_outline]<font size = 1><left>Contacts: [new_list.len]"
						bg.holder_main.vis_contents += bg.txt_relations
					MouseEntered()
						src.icon_state = "button hover"
					MouseExited()
						src.icon_state = "button"
					New()
						src.maptext = "[css_outline]<font size = 1><center>NPCs"
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
				contacts_sort_bar
					icon = 'hud_contacts_sorted.dmi'
					icon_state = "normal"
					layer = 35
					plane = 28
					maptext_width = 96
					maptext_height = 18
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					hud_x = 190
					hud_y = 184
					maptext_x = -16
					maptext_y = 113
					sort_type = "All"
					Click()
						var/obj/hud/menus/contacts_background/bg = src.menu
						if(src.icon_state == "hover" || src.icon_state == "normal")
							src.icon_state = "selected"
							for(var/obj/hud/menus/contacts_background/contacts_sort_button/b in bg.sort_boxes)
								bg.holder_main.vis_contents += b
							return
						if(src.icon_state == "selected")
							src.icon_state = "hover"
							for(var/obj/o in bg.sort_boxes)
								bg.holder_main.vis_contents -= o
							return
					MouseEntered()
						if(src.icon_state != "selected") src.icon_state = "hover"
					MouseExited()
						if(src.icon_state != "selected") src.icon_state = "normal"
					New()
						src.maptext = "[css_outline]<font size = 1><center>All"
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
				contacts_player
					icon = 'hud_players.dmi'
					icon_state = "normal"
					layer = 35
					plane = 28
					maptext_width = 160
					maptext_height = 18
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					hud_x = 10
					hud_y = 268
					maptext_x = 3
					maptext_y = 3
					MouseEntered()
						if(src.icon_state != "selected") src.icon_state = "hover"
					MouseExited()
						if(src.icon_state != "selected") src.icon_state = "normal"
					New()
						src.maptext = "[css_outline]<font size = 1><left>Player name"
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					Click()
						//Handle selecting a player via mouse click.
						usr.player_selected = src
						var/obj/hud/menus/contacts_background/bg = usr.hud_contacts
						bg.holder_info.vis_contents += bg.txt_info_player

						bg.txt_info_player.maptext = "[css_outline]<font size = 1><text align=left valign=top>[src.info_name]"
				/*
				.:Sort options for Players:.
				Online
				Friends
				Sect/Guild (Guild members)
				Group
				Ignored
				*/
				contacts_players_dropdown
					icon = 'hud_contacts_players.dmi'
					icon_state = "normal"
					layer = 36
					plane = 28
					maptext_width = 96
					maptext_height = 18
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					hud_x = 190
					hud_y = 202
					maptext_x = -16
					maptext_y = 95
					sort_type = "Online"
					var/tooltip = "Online"
					Click()
						var/obj/hud/menus/contacts_background/bg = src.menu
						if(src.icon_state == "hover" || src.icon_state == "normal")
							src.icon_state = "selected"
							for(var/obj/hud/menus/contacts_background/contacts_players_button/b in bg.player_social)
								bg.holder_main.vis_contents += b
							return
						if(src.icon_state == "selected")
							src.icon_state = "hover"
							for(var/obj/o in bg.player_social)
								bg.holder_main.vis_contents -= o
							return
					MouseMove(location,control,params)
						..()
						usr.info_box(src,src.tooltip,params)
					MouseEntered()
						if(src.icon_state != "selected") src.icon_state = "hover"
						if(usr.info_box1)
							usr.client.screen += usr.info_box1
							usr.client.screen += usr.info_box2
							usr.client.screen += usr.info_box3
					MouseExited()
						if(src.icon_state != "selected") src.icon_state = "normal"
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					New()
						src.maptext = "[css_outline]<font size = 1><center>Online"
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
				contacts_players_button
					icon = 'hud_contacts_players.dmi'
					icon_state = "button"
					layer = 36
					plane = 28
					maptext_width = 96
					maptext_height = 18
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					hud_x = 190
					hud_y = 196
					maptext_x = -7
					maptext_y = 95
					Click()
						var/obj/hud/menus/contacts_background/bg = src.menu
						bg.players_box.icon_state = "normal"

						for(var/obj/o in bg.player_social)
							bg.holder_main.vis_contents -= o

						switch(src.sort_type)
							if("Online")
								bg.txt_players_online.maptext = "[css_outline]<font size = 1><left>Players Online: 0"
							if("Friends")
								bg.txt_players_online.maptext = "[css_outline]<font size = 1><left>Friends:"
							if("Sect/Guild")
								bg.txt_players_online.maptext = "[css_outline]<font size = 1><left>Members:"
							if("Group")
								bg.txt_players_online.maptext = "[css_outline]<font size = 1><left>Group Members:"
							if("Ignored")
								bg.txt_players_online.maptext = "[css_outline]<font size = 1><left>Ignored:"
						bg.players(src.sort_type)
						bg.players_box.tooltip = src.sort_type
						bg.players_box.maptext = "[css_outline]<font size = 1><center>[src.sort_type]"
						bg.holder_main.vis_contents += bg.txt_players_online
					MouseEntered()
						src.icon_state = "button hover"
					MouseExited()
						src.icon_state = "button"
					New()
						src.maptext = "[css_outline]<font size = 1><center>NPCs"
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
				contacts_relation_dropdown
					icon = 'hud_contacts_relations.dmi'
					icon_state = "normal"
					layer = 35
					plane = 28
					maptext_width = 96
					maptext_height = 18
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					hud_x = 348
					hud_y = 59
					maptext_x = -16
					maptext_y = 167
					sort_type = "None"
					var/tooltip = "None"
					Click()
						var/obj/hud/menus/contacts_background/bg = src.menu
						if(src.icon_state == "hover" || src.icon_state == "normal")
							src.icon_state = "selected"
							for(var/obj/hud/menus/contacts_background/contacts_relation_button/b in bg.relation_buttons)
								bg.holder_info.vis_contents += b
							return
						if(src.icon_state == "selected")
							src.icon_state = "hover"
							for(var/obj/o in bg.relation_buttons)
								bg.holder_info.vis_contents -= o
							return
					MouseMove(location,control,params)
						..()
						usr.info_box(src,src.tooltip,params)
					MouseEntered()
						if(src.icon_state != "selected") src.icon_state = "hover"
						if(usr.info_box1)
							usr.client.screen += usr.info_box1
							usr.client.screen += usr.info_box2
							usr.client.screen += usr.info_box3
					MouseExited()
						if(src.icon_state != "selected") src.icon_state = "normal"
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					New()
						src.maptext = "[css_outline]<font size = 1><center>None"
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
				contacts_relation_button
					icon = 'hud_contacts_sorted.dmi'
					icon_state = "button"
					layer = 34
					plane = 28
					maptext_width = 96
					maptext_height = 18
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					hud_x = 348
					hud_y = 196
					maptext_x = -7
					maptext_y = 113
					var/tooltip
					Click()
						var/obj/hud/menus/contacts_background/bg = src.menu
						bg.relations_box.icon_state = "normal"
						for(var/obj/o in bg.relation_buttons)
							bg.holder_info.vis_contents -= o

						switch(src.sort_type)
							if("None")
								bg.relations_box.maptext = "[css_outline]<font size = 1><center>[src.sort_type]"
							if("Friendship")
								bg.relations_box.maptext = "[css_outline]<font size = 1><center>[src.sort_type]"
							if("Rivalry")
								bg.relations_box.maptext = "[css_outline]<font size = 1><center>[src.sort_type]"
							if("Romantic")
								bg.relations_box.maptext = "[css_outline]<font size = 1><center>[src.sort_type]"
							if("Trust")
								bg.relations_box.maptext = "[css_outline]<font size = 1><center>[src.sort_type]"
							if("Animosity")
								bg.relations_box.maptext = "[css_outline]<font size = 1><center>[src.sort_type]"
							if("Respect")
								bg.relations_box.maptext = "[css_outline]<font size = 1><center>[src.sort_type]"
							if("Envy")
								bg.relations_box.maptext = "[css_outline]<font size = 1><center>[src.sort_type]"
							if("Deception")
								bg.relations_box.maptext = "[css_outline]<font size = 1><center>[src.sort_type]"

						bg.relations_box.tooltip = src.tooltip
					MouseMove(location,control,params)
						..()
						usr.info_box(src,src.tooltip,params)
					MouseEntered()
						src.icon_state = "button hover"
						if(usr.info_box1)
							usr.client.screen += usr.info_box1
							usr.client.screen += usr.info_box2
							usr.client.screen += usr.info_box3
					MouseExited()
						src.icon_state = "button"
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					New()
						src.maptext = "[css_outline]<font size = 1><center>NPCs"
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
				contacts_info_txt
					icon = null
					layer = 33
					plane = 28
					maptext_width = 148
					maptext_height = 640
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					hud_x = 303
					hud_y = -400
					New()
						//src.maptext = "[css_outline]<font size = 1><text align=left valign=top>Testing text location on the holder screen to make sure it fits correctly."
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
				contacts_info_txt_player
					icon = null
					layer = 33
					plane = 28
					maptext_width = 152
					maptext_height = 640
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					hud_x = 303
					hud_y = -324
					New()
						//src.maptext = "[css_outline]<font size = 1><text align=left valign=top>Testing text location on the holder screen to make sure it fits correctly."
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
				button
					icon = 'help_expand_buttons.dmi'
					icon_state = "expanded"
					maptext_width = 320
					maptext_height = 16
					plane = 35
					layer = 34
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					var/opened = 0
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						src.maptext = "[css_outline]<font size = 1><text align=left valign=top>Text here"
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/help_background/s = usr.hud_help
						var/obj/sc = s.help_scroller

						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-218)

						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result
						var/ratio = -1 + ((-218 + result) / -218)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(200*ratio)

						s.help_holder_y = scroll_y

						for(var/obj/txt in s.help_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2
					Click()
						return
				contacts_tab1
					//Players
					icon = 'hud_contacts_tabs.dmi'
					icon_state = "selected"
					layer = 32
					plane = 28
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					hud_x = 7
					hud_y = 317
					Click()
						if(src.menu == usr.hud_contacts)
							var/obj/hud/menus/contacts_background/bg = src.menu
							bg.selected = 1
							for(var/obj/t in bg.tabs)
								t.icon_state = "normal"
							src.icon_state = "selected"
							bg.holder_main.vis_contents = null
							bg.holder_info.vis_contents = null
							bg.players("Online")
					MouseEntered()
						if(src.icon_state != "selected") src.icon_state = "hover"
					MouseExited()
						if(src.icon_state != "selected") src.icon_state = "normal"
					New()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
				contacts_tab2
					//Relations
					icon = 'hud_contacts_tabs.dmi'
					icon_state = "normal"
					layer = 32
					plane = 28
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					hud_x = 78
					hud_y = 317
					Click()
						if(src.menu == usr.hud_contacts)
							var/obj/hud/menus/contacts_background/bg = src.menu
							bg.holder_main.vis_contents = null
							bg.holder_info.vis_contents = null
							bg.selected = 2
							for(var/obj/t in bg.tabs)
								t.icon_state = "normal"
							src.icon_state = "selected"
							bg.display_contacts(usr,usr.player_contacts)
							bg.holder_main.vis_contents += bg.txt_relations
					MouseEntered()
						if(src.icon_state != "selected") src.icon_state = "hover"
					MouseExited()
						if(src.icon_state != "selected") src.icon_state = "normal"
					New()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
				contacts_tab3
					//Followers
					icon = 'hud_contacts_tabs.dmi'
					icon_state = "normal"
					layer = 32
					plane = 28
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					hud_x = 149
					hud_y = 317
					Click()
						if(src.menu == usr.hud_contacts)
							var/obj/hud/menus/contacts_background/bg = src.menu
							bg.holder_main.vis_contents = null
							bg.holder_info.vis_contents = null
							bg.selected = 3
							for(var/obj/t in bg.tabs)
								t.icon_state = "normal"
							src.icon_state = "selected"
					MouseEntered()
						if(src.icon_state != "selected") src.icon_state = "hover"
					MouseExited()
						if(src.icon_state != "selected") src.icon_state = "normal"
					New()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
				contacts_tab4
					//Quests
					icon = 'hud_contacts_tabs.dmi'
					icon_state = "normal"
					layer = 32
					plane = 28
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					hud_x =149
					hud_y = 317
					Click()
						if(src.menu == usr.hud_contacts)
							var/obj/hud/menus/contacts_background/bg = src.menu
							bg.holder_main.vis_contents = null
							bg.holder_info.vis_contents = null
							bg.selected = 4
							for(var/obj/t in bg.tabs)
								t.icon_state = "normal"
							src.icon_state = "selected"
							usr.hud_contacts.quests(usr)
					MouseEntered()
						if(src.icon_state != "selected") src.icon_state = "hover"
					MouseExited()
						if(src.icon_state != "selected") src.icon_state = "normal"
					New()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
				contacts_bar_main
					icon_state = "bar main"
					layer = 32
					plane = 28
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/contacts_background/s = src.menu
						var/obj/sc = s.scroller_main
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-263)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						s.scroller_transforms_main[s.selected] = m

						var/ratio = -1 + ((-263 + result) / -263)
						ratio = clamp(ratio,0,1)
						var/size = 0
						if(s.selected == 1) size = s.players_size
						else if(s.selected == 2) size = s.contacts_size
						else if(s.selected == 4) size = s.quest_size
						var/scroll_y = round(size*ratio)

						s.bar_pos_y_main[s.selected] = scroll_y

						for(var/obj/o in s.holder_main.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(o.hud_x,o.hud_y+scroll_y)
							o.transform = m2
					Click(location,control,params)
						var/obj/hud/menus/contacts_background/s = src.menu
						var/obj/sc = s.scroller_main
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/result = -246 + ((usr.mouse_y_true-s.contacts_background_y)-54)
						result = clamp(result,0,-263)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						s.scroller_transforms_main[s.selected] = m

						var/ratio = -1 + ((-263 + result) / -263)
						ratio = clamp(ratio,0,1)
						var/size = 0
						if(s.selected == 1) size = s.players_size
						else if(s.selected == 2) size = s.contacts_size
						else if(s.selected == 4) size = s.quest_size
						var/scroll_y = round(size*ratio)

						s.bar_pos_y_main[s.selected] = scroll_y

						for(var/obj/o in s.holder_main.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(o.hud_x,o.hud_y+scroll_y)
							o.transform = m2
					New()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
				contacts_bar_info
					icon_state = "bar info"
					layer = 32
					plane = 28
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/contacts_background/s = src.menu
						var/obj/sc = s.scroller_info
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-280)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						s.scroller_transforms_info[s.selected] = m

						var/ratio = -1 + ((-280 + result) / -280)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(200*ratio)

						s.bar_pos_y_info[s.selected] = scroll_y

						for(var/obj/o in s.holder_info.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(o.hud_x,o.hud_y+scroll_y)
							o.transform = m2
					Click(location,control,params)
						var/obj/hud/menus/contacts_background/s = src.menu
						var/obj/sc = s.scroller_info
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/result = -264 + ((usr.mouse_y_true-s.contacts_background_y)-54)
						result = clamp(result,0,-280)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						s.scroller_transforms_info[s.selected] = m

						var/ratio = -1 + ((-280 + result) / -280)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(200*ratio)

						s.bar_pos_y_info[s.selected] = scroll_y

						for(var/obj/o in s.holder_info.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(o.hud_x,o.hud_y+scroll_y)
							o.transform = m2
					New()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
				contacts_scroller_main
					icon_state = "scroller main"
					layer = 32
					plane = 28
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					New()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/contacts_background/s = src.menu
						var/obj/sc = s.scroller_main
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-263)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						s.scroller_transforms_main[s.selected] = m

						var/ratio = -1 + ((-263 + result) / -263)
						ratio = clamp(ratio,0,1)
						var/size = 0
						if(s.selected == 1) size = s.players_size
						else if(s.selected == 2) size = s.contacts_size
						else if(s.selected == 4) size = s.quest_size
						var/scroll_y = round(size*ratio)

						s.bar_pos_y_main[s.selected] = scroll_y

						for(var/obj/o in s.holder_main.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(o.hud_x,o.hud_y+scroll_y)
							o.transform = m2
					MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
						var/obj/hud/menus/contacts_background/s = src.menu
						var/obj/sc = s.scroller_main
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/result = -246 + ((usr.mouse_y_true-s.contacts_background_y)-54)
						result = clamp(result,0,-263)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						s.scroller_transforms_main[s.selected] = m

						var/ratio = -1 + ((-263 + result) / -263)
						ratio = clamp(ratio,0,1)
						var/size = 0
						if(s.selected == 1) size = s.players_size
						else if(s.selected == 2) size = s.contacts_size
						else if(s.selected == 4) size = s.quest_size
						var/scroll_y = round(size*ratio)

						s.bar_pos_y_main[s.selected] = scroll_y

						for(var/obj/o in s.holder_main.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(o.hud_x,o.hud_y+scroll_y)
							o.transform = m2
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
				contacts_scroller_info
					icon_state = "scroller info"
					layer = 32
					plane = 28
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					New()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/contacts_background/s = src.menu
						var/obj/sc = s.scroller_info
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-280)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						s.scroller_transforms_info[s.selected] = m

						var/ratio = -1 + ((-280 + result) / -280)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(200*ratio)

						s.bar_pos_y_info[s.selected] = scroll_y

						for(var/obj/o in s.holder_info.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(o.hud_x,o.hud_y+scroll_y)
							o.transform = m2
					MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
						var/obj/hud/menus/contacts_background/s = src.menu
						var/obj/sc = s.scroller_info
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/result = -264 + ((usr.mouse_y_true-s.contacts_background_y)-54)
						result = clamp(result,0,-280)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						s.scroller_transforms_info[s.selected] = m

						var/ratio = -1 + ((-280 + result) / -280)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(200*ratio)

						s.bar_pos_y_info[s.selected] = scroll_y

						for(var/obj/o in s.holder_info.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(o.hud_x,o.hud_y+scroll_y)
							o.transform = m2
				contacts_holder_info
					icon_state = "pane info"
					layer = 32
					plane = 28
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/contacts_background/s = src.menu
						var/obj/sc = s.scroller_info
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-280)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						s.scroller_transforms_main[s.selected] = m

						var/ratio = -1 + ((-280 + result) / -280)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(200*ratio)

						s.bar_pos_y_main[s.selected] = scroll_y

						for(var/obj/o in s.holder_info.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(o.hud_x,o.hud_y+scroll_y)
							o.transform = m2
					New()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
				contacts_holder_main
					icon_state = "pane main"
					layer = 32
					plane = 28
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/contacts_background/s = src.menu
						var/obj/sc = s.scroller_main
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-263)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						s.scroller_transforms_main[s.selected] = m

						var/ratio = -1 + ((-263 + result) / -263)
						ratio = clamp(ratio,0,1)

						var/size = 0
						if(s.selected == 1) size = s.players_size
						else if(s.selected == 2) size = s.contacts_size
						else if(s.selected == 4) size = s.quest_size
						var/scroll_y = round(size*ratio)

						s.bar_pos_y_main[s.selected] = scroll_y

						for(var/obj/o in s.holder_main.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(o.hud_x,o.hud_y+scroll_y)
							o.transform = m2
					New()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
			build_background
				icon = 'new_hud_build.dmi'
				icon_state = "main"
				layer = 32
				screen_loc = "1,1"
				plane = 23
				appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
				var/hh = 0
				var/ww = 0
				var/icon/I
				var/build_background_x = 200
				var/build_background_y = 100
				var/obj/hud/menus/build_background/menu
				var/obj/hud/menus/build_background/build_holder/holder_build
				var/obj/scrollbar
				var/obj/scroller
				var/setup = 0
				MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
					params = params2list(params)
					var/icon_y = text2num(params["icon-y"])
					if(icon_y >= 331 || usr.mouse_down)
						usr.client.MousePosition(params)
						var/matrix/m = matrix()
						var/icon_x = text2num(params["icon-x"])
						if(usr.drag_icon_x == 0) usr.drag_icon_x = icon_x
						var/x_result = usr.client.client_mouse_x-usr.drag_icon_x
						var/y_result = usr.client.client_mouse_y-src.hh
						x_result = clamp(x_result,0,1023-src.ww)
						y_result = clamp(y_result,0,575-(src.hh/2))
						m.Translate(x_result,y_result)
						src.transform = m
						src.build_background_x = x_result
						src.build_background_y = y_result
						usr.mouse_down = src
						//world << "DEBUG - [src.unlocks_background_x],[src.unlocks_background_y]"
				proc
					menu_create()
						if(src.setup)
							return
						spawn(10)
							if(src)
								src.setup = 1

								var/matrix/m_main = matrix()
								m_main.Translate(200,100)
								src.transform = m_main

								src.I = new(src.icon)
								src.ww = I.Width()
								src.hh = I.Height()

								var/obj/hud/buttons/close_menu/cm = new
								cm.plane = src.plane
								cm.closes = src
								var/matrix/close_m = matrix()
								close_m.Translate(src.ww-15,src.hh-15)
								cm.transform = close_m
								src.vis_contents += cm

								var/obj/hud/menus/build_background/build_holder/bh = new
								bh.menu = src
								src.vis_contents += bh
								src.holder_build = bh

								/*
								var/obj/hud/menus/build_background/build_scrollbar/sc1 = new
								sc1.menu = src
								src.vis_contents += sc1
								src.scrollbar = sc1

								var/obj/hud/menus/build_background/build_scroller/scer1 = new
								scer1.menu = src
								src.vis_contents += scer1
								src.scroller = scer1
								*/

								var/obj/hud/menus/build_background/tab/tab1 = new
								tab1.menu = src
								tab1.hud_x = 7
								tab1.hud_y = 311
								var/matrix/m1 = matrix()
								m1.Translate(tab1.hud_x,tab1.hud_y)
								tab1.transform = m1
								tab1.maptext = "[css_outline]<font size = 1><center>Floors"
								src.vis_contents += tab1
								tab1.icon_state = "selected"
								tab1.tab_type = "floors"

								var/obj/hud/menus/build_background/tab/tab2 = new
								tab2.menu = src
								tab2.hud_x = 78
								tab2.hud_y = 311
								var/matrix/m2 = matrix()
								m2.Translate(tab2.hud_x,tab2.hud_y)
								tab2.transform = m2
								tab2.maptext = "[css_outline]<font size = 1><center>Walls"
								src.vis_contents += tab2
								tab2.tab_type = "walls"

								var/obj/hud/menus/build_background/tab/tab3 = new
								tab3.menu = src
								tab3.hud_x = 149
								tab3.hud_y = 311
								var/matrix/m3 = matrix()
								m3.Translate(tab3.hud_x,tab3.hud_y)
								tab3.transform = m3
								tab3.maptext = "[css_outline]<font size = 1><center>Roofs"
								src.vis_contents += tab3
								tab3.tab_type = "roofs"

								var/obj/hud/menus/build_background/tab/tab4 = new
								tab4.menu = src
								tab4.hud_x = 220
								tab4.hud_y = 311
								var/matrix/m4 = matrix()
								m4.Translate(tab4.hud_x,tab4.hud_y)
								tab4.transform = m4
								tab4.maptext = "[css_outline]<font size = 1><center>Misc"
								src.vis_contents += tab4
								tab4.tab_type = "misc"

								var/obj/hud/menus/build_background/tab/tab5 = new
								tab5.menu = src
								tab5.hud_x = 7
								tab5.hud_y = 294
								var/matrix/m5 = matrix()
								m5.Translate(tab5.hud_x,tab5.hud_y)
								tab5.transform = m5
								tab5.maptext = "[css_outline]<font size = 1><center>Furniture"
								src.vis_contents += tab5
								tab5.tab_type = "furniture"

								var/obj/hud/menus/build_background/tab/tab6 = new
								tab6.menu = src
								tab6.hud_x = 78
								tab6.hud_y = 294
								var/matrix/m6 = matrix()
								m6.Translate(tab6.hud_x,tab6.hud_y)
								tab6.transform = m6
								tab6.maptext = "[css_outline]<font size = 1><center>Doors"
								src.vis_contents += tab6
								tab6.tab_type = "doors"

								var/obj/hud/menus/build_background/tab/tab7 = new
								tab7.menu = src
								tab7.hud_x = 149
								tab7.hud_y = 294
								var/matrix/m7 = matrix()
								m7.Translate(tab7.hud_x,tab7.hud_y)
								tab7.transform = m7
								tab7.maptext = null
								src.vis_contents += tab7

								var/obj/hud/menus/build_background/tab/tab8 = new
								tab8.menu = src
								tab8.hud_x = 220
								tab8.hud_y = 294
								var/matrix/m8 = matrix()
								m8.Translate(tab8.hud_x,tab8.hud_y)
								tab8.transform = m8
								tab8.maptext = null
								src.vis_contents += tab8
				build_scroller
					icon_state = "scroller"
					layer = 32
					plane = 23
					MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
						var/obj/hud/menus/skills_background/s = src.menu

						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						//var/result = -218 + (usr.mouse_y_true-54) //54 is the size of the scroller x 2 (basically its height in pixels). -285 seems is how many pixels from bottom of menu.
						var/result = -218 + ((usr.mouse_y_true-s.skills_background_y)-54)
						result = clamp(result,0,-245)
						var/matrix/m = matrix()
						m.Translate(0,result)
						src.transform = m
						src.translated_y = result

						var/ratio = -1 + ((-245 + result) / -245)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(700*ratio)

						for(var/obj/txt in s.txt_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2
							txt.translated_y = scroll_y
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/skills_background/s = src.menu
						var/obj/sc = s.txt_scroller

						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-218)

						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result
						var/ratio = -1 + ((-218 + result) / -218)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(700*ratio)

						for(var/obj/txt in s.txt_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2
							txt.translated_y = scroll_y
				build_scrollbar
					icon_state = "scrollbar"
					layer = 32
					plane = 23
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/skills_background/s = src.menu
						var/obj/sc = s.txt_scroller
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-245)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/ratio = -1 + ((-245 + result) / -245)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(700*ratio)

						for(var/obj/txt in s.txt_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.translated_y = scroll_y
							txt.transform = m2
					Click(location,control,params)
						var/obj/hud/menus/skills_background/s = src.menu
						var/obj/sc = s.txt_scroller
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/result = -218 + ((usr.mouse_y_true-s.skills_background_y)-54)
						result = clamp(result,0,-245)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/ratio = -1 + ((-245 + result) / -245)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(700*ratio)

						for(var/obj/txt in s.txt_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.translated_y = scroll_y
							txt.transform = m2
					New()
						return
					MouseDrag()
						return
				tab
					icon = 'hud_build_tabs.dmi'
					icon_state = "unselected"
					layer = 33
					plane = 23
					maptext_width = 96
					maptext_height = 16
					maptext_y = 3
					maptext_x = -13
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					var/tab_type
					New()
						return
					MouseDrag()
						return
					MouseEntered()
						if(src.icon_state != "selected") src.icon_state = "hover"
					MouseExited()
						if(src.icon_state != "selected") src.icon_state = "unselected"
					Click()
						for(var/obj/hud/menus/build_background/tab/t in src.menu.vis_contents)
							t.icon_state = "unselected"
						src.icon_state = "selected"
						var/obj/hud/menus/build_background/b_m = src.menu
						b_m.holder_build.vis_contents = null
						switch(src.tab_type)
							if("floors")
								for(var/obj/buildings/floors/O in floors)
									b_m.holder_build.vis_contents += O
								return
							if("walls")
								for(var/obj/buildings/walls/O in walls)
									b_m.holder_build.vis_contents += O
								return
							if("roofs")
								for(var/obj/buildings/roofs/O in roofs)
									b_m.holder_build.vis_contents += O
								return
							if("doors")
								return
							if("furniture")
								return
							if("misc")
								return
				build_holder
					icon_state = "build holder"
					layer = 32
					plane = 23
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/skills_background/s = src.menu
						var/obj/sc = s.skills_scroller

						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-218)

						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result
						var/ratio = -1 + ((-218 + result) / -218)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(200*ratio)

						for(var/obj/txt in s.skills_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2
					New()
						return
					MouseDrag()
						return
			unlocks_background
				icon = 'new_hud_unlocks2.dmi'
				icon_state = "empty"
				layer = 32
				screen_loc = "1,1"//"1,1"//"9,5"//"1,1"
				plane = 33
				appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
				var/list/unlock_overlays[12]
				var/setup = 0
				var/selected = 1
				var/select_name = "physical"
				var/obj/hud/menus/unlocks_background/menu
				var/list/bar_pos_y_skills = list(0,0,0,0,0,0,0,0,0,0,0,0)
				var/list/bar_pos_x_hori_skills = list(0,0,0,0,0,0,0,0,0,0,0,0)
				var/list/bar_pos_y_info = list(0,0,0,0,0,0,0,0,0,0,0,0)
				var/list/scrl_transform_skills[12]
				var/list/scrl_transform_hori_skills[12]
				var/list/tabs = list()
				var/obj/holder_skills
				var/obj/holder_special
				var/obj/holder_info
				var/obj/scroller_info
				var/obj/scroller_skills
				var/obj/scroller_hori_skills
				var/unlocks_background_x = 200
				var/unlocks_background_y = 100
				var/obj/points_txt
				var/obj/info_txt
				var/obj/name_txt
				var/hh = 0
				var/ww = 0
				var/icon/I
				var/obj/unlock_icon
				var/obj/bar_rating
				var/obj/bar_power
				var/obj/bar_speed
				var/obj/bar_cooldown
				var/obj/bar_mastery
				var/obj/bar_energy
				/*
				1 - eng
				2 - str
				3 - end
				4 - agil
				5 - off
				6 - def
				7 - for
				8 - res
				9 - regen
				10 - recov
				11 - traits
				12 - stances
				*/
				MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
					params = params2list(params)
					var/icon_y = text2num(params["icon-y"])
					if(icon_y >= 331 || usr.mouse_down)
						usr.client.MousePosition(params)
						var/matrix/m = matrix()
						var/icon_x = text2num(params["icon-x"])
						if(usr.drag_icon_x == 0) usr.drag_icon_x = icon_x
						var/x_result = usr.client.client_mouse_x-usr.drag_icon_x
						var/y_result = usr.client.client_mouse_y-src.hh
						x_result = clamp(x_result,0,1023-src.ww)
						y_result = clamp(y_result,0,575-(src.hh/2))
						m.Translate(x_result,y_result)
						src.transform = m
						src.unlocks_background_x = x_result
						src.unlocks_background_y = y_result
						usr.mouse_down = src
						//world << "DEBUG - [src.unlocks_background_x],[src.unlocks_background_y]"
				proc
					clear_unlocks(var/mob/m)
						if(!m.client) return
						for(var/obj/skills/s in global.learnable_skills)
							m.client.images -= s.img_select
						for(var/obj/stances/s in global.learnable_stances)
							m.client.images -= s.img_select
						for(var/obj/traits/s in global.learnable_traits)
							m.client.images -= s.img_select
					check_status(var/mob/m)
						if(!m.client) return
						for(var/obj/skills/s in global.learnable_skills)
							for(var/obj/skills/s_p in m)
								if(s.name == s_p.name && s.img_select)
								//	world<<"Adding Learnable: [s]"
									m.client.images += s.img_select
								//	world << "DEBUG - added overlays for [s], after finding [s_p] in [m]"
									break
					switch_tab(var/tab_num,var/mob/m)
						var/obj/hud/menus/unlocks_background/bg = m.hud_unlocks
						var/txt
						var/tab_name
						var/list/L = global.learnable_skills

						bg.holder_special.vis_contents = null

						switch(tab_num)
							if(1) tab_name = "physical"
							if(2) tab_name = "technology"
							if(3) tab_name = "combat"
							if(4)
								L = global.learnable_traits
								tab_name = "combat"
							if(5)
								L = global.learnable_stances
								tab_name = "combat"

						switch(tab_name)
							if("energy") txt = "[css_outline]<font size = 1><left>Energy Skill Points: [m.skill_points_energy]"
							if("strength") txt = "[css_outline]<font size = 1><left>Strength Skill Points: [m.skill_points_strength]"
							if("endurance") txt = "[css_outline]<font size = 1><left>Endurance Skill Points: [m.skill_points_endurance]"
							if("agility") txt = "[css_outline]<font size = 1><left>Agility Skill Points: [m.skill_points_agility]"
							if("force") txt = "[css_outline]<font size = 1><left>Force Skill Points: [m.skill_points_force]"
							if("resistance") txt = "[css_outline]<font size = 1><left>Resistance Skill Points: [m.skill_points_resistance]"
							if("combat") txt = "[css_outline]<font size = 1><left>Stance Points: [m.stance_points]"
							if("defence") txt = "[css_outline]<font size = 1><left>Defence Skill Points: [m.skill_points_defence]"
							if("regen") txt = "[css_outline]<font size = 1><left>Regeneration Skill Points: [m.skill_points_regen]"
							if("physical") txt = "[css_outline]<font size = 1><left>Passive Points: [m.passive_points]"
							if("technology") txt = "[css_outline]<font size = 1><left>Passive Points: [m.passive_points]"
							//if("research") txt = "[css_outline]<font size = 1><left>Quality % Points: [m.intel_points]"
							if("research") txt = ""

						bg.holder_special.vis_contents += bg.points_txt
						bg.points_txt.maptext = txt

						bg.holder_special.vis_contents += bg.unlock_overlays[tab_num]

						for(var/obj/o in bg.tabs)
							o.icon_state = "unselected"

						bg.selected = tab_num
						bg.select_name = tab_name

						if(src != bg) src.icon_state = "selected"

						for(var/obj/s in L)
							if(s.info_point_cost_type == tab_name)
								bg.holder_special.vis_contents += s
						/*for(var/obj/skills/path in L)
							var/obj/skills/s = new path

							if(s.info_point_cost_type == tab_name)
								bg.holder_special.vis_contents += s
							else
								s.destroy()
								s.loc=null*/


						var/matrix/mat = matrix()
						mat.Translate(bg.holder_special.hud_x-bg.bar_pos_x_hori_skills[bg.selected],bg.holder_special.hud_y+bg.bar_pos_y_skills[bg.selected])
						bg.holder_special.transform = mat

						bg.scroller_skills.transform = bg.scrl_transform_skills[bg.selected]
						bg.scroller_hori_skills.transform = bg.scrl_transform_hori_skills[bg.selected]
					menu_create()
						if(src.setup)
							return
						spawn(10)
							if(src)
								src.setup = 1

								var/matrix/m_main = matrix()
								m_main.Translate(200,100)
								src.transform = m_main

								src.I = new(src.icon)
								src.ww = I.Width()
								src.hh = I.Height()

								var/obj/hud/buttons/close_menu/cm = new
								cm.plane = src.plane
								cm.closes = src
								var/matrix/close_m = matrix()
								close_m.Translate(src.ww-15,src.hh-15)
								cm.transform = close_m
								src.vis_contents += cm

								var/obj/hud/menus/unlocks_background/unlock_button/button = new
								var/matrix/mb = matrix()
								mb.Translate(button.hud_x,button.hud_y)
								button.transform = mb
								src.vis_contents += button
								button.menu = src

								var/obj/hud/menus/unlocks_background/unlocks_title/title = new
								var/matrix/m0 = matrix()
								m0.Translate(title.hud_x,title.hud_y)
								title.transform = m0
								src.vis_contents += title

								var/obj/hud/menus/unlocks_background/holder_skills/h_skills = new
								src.vis_contents += h_skills
								src.holder_skills = h_skills

								var/obj/hud/menus/unlocks_background/holder_special/h_special = new
								var/matrix/m_sp = matrix()
								m_sp.Translate(h_special.hud_x,h_special.hud_y)
								h_special.transform = m_sp
								h_skills.vis_contents += h_special
								src.holder_special = h_special
								h_special.menu = src

								var/obj/hud/menus/unlocks_background/holder_info/h_info = new
								src.vis_contents += h_info
								src.holder_info = h_info
								h_info.menu = src

								var/obj/hud/menus/unlocks_background/unlocks_info_txt/txt_info = new
								var/matrix/m_txt = matrix()
								m_txt.Translate(txt_info.hud_x,txt_info.hud_y)
								txt_info.transform = m_txt
								h_info.vis_contents += txt_info
								src.info_txt = txt_info

								var/obj/hud/menus/unlocks_background/scrollbar_skills/sb_skills = new
								src.vis_contents += sb_skills
								sb_skills.menu = src

								var/obj/hud/menus/unlocks_background/scrollbar_skills_horizontal/sb_skills_h = new
								src.vis_contents += sb_skills_h
								sb_skills_h.menu = src

								var/obj/hud/menus/unlocks_background/scrollbar_info/sb_info = new
								src.vis_contents += sb_info
								sb_info.menu = src

								var/obj/hud/menus/unlocks_background/scroller_skills/sc_skills = new
								src.vis_contents += sc_skills
								sc_skills.menu = src
								src.scroller_skills = sc_skills

								var/obj/hud/menus/unlocks_background/scroller_skills_horizontal/sc_skills_h = new
								src.vis_contents += sc_skills_h
								src.scroller_hori_skills = sc_skills_h
								sc_skills_h.menu = src

								var/obj/hud/menus/unlocks_background/scroller_info/sc_info = new
								src.vis_contents += sc_info
								src.scroller_info = sc_info
								sc_info.menu = src


								//var/obj/hud/menus/unlocks_background/unlocks_energy/u_energy = new
							//	h_special.vis_contents += u_energy
								//src.unlock_overlays[1] = u_energy

							//	var/obj/hud/menus/unlocks_background/unlocks_strength/u_strength = new
							//	src.unlock_overlays[2] = u_strength

							//	var/obj/hud/menus/unlocks_background/unlocks_endurance/u_endurance = new
							//	src.unlock_overlays[3] = u_endurance

							//	var/obj/hud/menus/unlocks_background/unlocks_agility/u_agility = new
								//src.unlock_overlays[4] = u_agility

							//	var/obj/hud/menus/unlocks_background/unlocks_offence/u_offence = new
								//src.unlock_overlays[5] = u_offence

							//	var/obj/hud/menus/unlocks_background/unlocks_defence/u_defence = new
								//src.unlock_overlays[6] = u_defence

							//	var/obj/hud/menus/unlocks_background/unlocks_force/u_force = new
						//		src.unlock_overlays[7] = u_force

							//	var/obj/hud/menus/unlocks_background/unlocks_resistance/u_resistance = new
						//		src.unlock_overlays[8] = u_resistance

							//	var/obj/hud/menus/unlocks_background/unlocks_regen/u_regen = new
							//	src.unlock_overlays[9] = u_regen

								var/obj/hud/menus/unlocks_background/unlocks_recovery/u_recovery = new
								src.unlock_overlays[1] = u_recovery

								var/obj/hud/menus/unlocks_background/unlocks_traits/u_traits = new
								src.unlock_overlays[2] = u_traits

								var/obj/hud/menus/unlocks_background/unlocks_stances/u_stances = new
								src.unlock_overlays[3] = u_stances

								var/obj/hud/menus/unlocks_background/unlocks_points/points = new
								var/matrix/m00 = matrix()
								m00.Translate(points.hud_x,points.hud_y)
								points.transform = m00
								h_special.vis_contents += points
								src.points_txt = points

								var/obj/hud/menus/unlocks_background/tab_energy/tab1 = new
								var/matrix/m1 = matrix()
								m1.Translate(tab1.hud_x,tab1.hud_y)
								tab1.transform = m1
							//	src.vis_contents += tab1
							//	tab1.menu = src
							//	src.tabs += tab1

								var/obj/hud/menus/unlocks_background/tab_strength/tab2 = new
								var/matrix/m2 = matrix()
								m2.Translate(tab2.hud_x,tab2.hud_y)
								tab2.transform = m2
							//	src.vis_contents += tab2
							//	tab2.menu = src
							//	src.tabs += tab2

								var/obj/hud/menus/unlocks_background/tab_endurance/tab3 = new
								var/matrix/m3 = matrix()
								m3.Translate(tab3.hud_x,tab3.hud_y)
								tab3.transform = m3
							//	src.vis_contents += tab3
							//	tab3.menu = src
							//	src.tabs += tab3

								var/obj/hud/menus/unlocks_background/tab_agility/tab4 = new
								var/matrix/m4 = matrix()
								m4.Translate(tab4.hud_x,tab4.hud_y)
								tab4.transform = m4
							//	src.vis_contents += tab4
							//	tab4.menu = src
							//	src.tabs += tab4

								var/obj/hud/menus/unlocks_background/tab_offence/tab5 = new
								var/matrix/m5 = matrix()
								m5.Translate(tab5.hud_x,tab5.hud_y)
								tab5.transform = m5
							//	src.vis_contents += tab5
							//	tab5.menu = src
							//	src.tabs += tab5

								var/obj/hud/menus/unlocks_background/tab_defence/tab6 = new
								var/matrix/m6 = matrix()
								m6.Translate(tab6.hud_x,tab6.hud_y)
								tab6.transform = m6
							//	src.vis_contents += tab6
							//	tab6.menu = src
							//	src.tabs += tab6

								var/obj/hud/menus/unlocks_background/tab_force/tab7 = new
								var/matrix/m7 = matrix()
								m7.Translate(tab7.hud_x,tab7.hud_y)
								tab7.transform = m7
								//src.vis_contents += tab7
							//	tab7.menu = src
								//src.tabs += tab7

								var/obj/hud/menus/unlocks_background/tab_resistance/tab8 = new
								var/matrix/m8 = matrix()
								m8.Translate(tab8.hud_x,tab8.hud_y)
								tab8.transform = m8
							//	src.vis_contents += tab8
							//	tab8.menu = src
							//	src.tabs += tab8

								var/obj/hud/menus/unlocks_background/tab_regen/tab9 = new
								var/matrix/m9 = matrix()
								m9.Translate(tab9.hud_x,tab9.hud_y)
								tab9.transform = m9
							//	src.vis_contents += tab9
							//	tab9.menu = src
							//	src.tabs += tab9

								var/obj/hud/menus/unlocks_background/tab_recovery/tab10 = new
								var/matrix/m10 = matrix()
								m10.Translate(tab10.hud_x,tab10.hud_y)
								tab10.transform = m10
								src.vis_contents += tab10
								tab10.menu = src
								src.tabs += tab10

								var/obj/hud/menus/unlocks_background/tab_traits/tab11 = new
								var/matrix/m11 = matrix()
								m11.Translate(tab11.hud_x,tab11.hud_y)
								tab11.transform = m11
								src.vis_contents += tab11
								tab11.menu = src
								src.tabs += tab11

								var/obj/hud/menus/unlocks_background/tab_stances/tab12 = new
								var/matrix/m12 = matrix()
								m12.Translate(tab12.hud_x,tab12.hud_y)
								tab12.transform = m12
								src.vis_contents += tab12
								tab12.menu = src
								src.tabs += tab12

								var/obj/hud/menus/unlocks_background/unlocks_overlays/overlays = new
								h_info.vis_contents += overlays
								overlays.menu = src

								var/obj/hud/menus/unlocks_background/unlocks_icon/u_icon = new
								h_info.vis_contents += u_icon
								src.unlock_icon = u_icon

								var/obj/hud/menus/unlocks_background/unlocks_skill_name/name = new
								var/matrix/m_n = matrix()
								m_n.Translate(name.hud_x,name.hud_y)
								name.transform = m_n
								h_info.vis_contents += name
								name.menu = src
								src.name_txt = name

								//--------------------------------------------------------------------------
								var/obj/hud/menus/unlocks_background/unlocks_icon_power/symbol_power = new
								var/matrix/m_symbol_01 = matrix()
								m_symbol_01.Translate(symbol_power.hud_x,symbol_power.hud_y)
								symbol_power.transform = m_symbol_01
								h_info.vis_contents += symbol_power
								symbol_power.menu = src

								var/obj/hud/menus/unlocks_background/unlocks_icon_energy/symbol_energy = new
								var/matrix/m_symbol_02 = matrix()
								m_symbol_02.Translate(symbol_energy.hud_x,symbol_energy.hud_y)
								symbol_energy.transform = m_symbol_02
								h_info.vis_contents += symbol_energy
								symbol_energy.menu = src

								var/obj/hud/menus/unlocks_background/unlocks_icon_cooldown/symbol_cooldown = new
								var/matrix/m_symbol_03 = matrix()
								m_symbol_03.Translate(symbol_cooldown.hud_x,symbol_cooldown.hud_y)
								symbol_cooldown.transform = m_symbol_03
								h_info.vis_contents += symbol_cooldown
								symbol_cooldown.menu = src

								var/obj/hud/menus/unlocks_background/unlocks_icon_mastery/symbol_mastery = new
								var/matrix/m_symbol_04 = matrix()
								m_symbol_04.Translate(symbol_mastery.hud_x,symbol_mastery.hud_y)
								symbol_mastery.transform = m_symbol_04
								h_info.vis_contents += symbol_mastery
								symbol_mastery.menu = src

								var/obj/hud/menus/unlocks_background/unlocks_icon_speed/symbol_speed = new
								var/matrix/m_symbol_05 = matrix()
								m_symbol_05.Translate(symbol_speed.hud_x,symbol_speed.hud_y)
								symbol_speed.transform = m_symbol_05
								h_info.vis_contents += symbol_speed
								symbol_speed.menu = src

								//--------------------------------------------------------------------------

								var/obj/hud/menus/unlocks_background/unlocks_bar_power/b_power = new
								var/matrix/m_bar_01 = matrix()
								m_bar_01.Translate(b_power.hud_x,b_power.hud_y)
								b_power.transform = m_bar_01
								h_info.vis_contents += b_power
								b_power.menu = src
								src.bar_power = b_power

								var/obj/hud/menus/unlocks_background/unlocks_bar_energy/b_energy = new
								var/matrix/m_bar_02 = matrix()
								m_bar_02.Translate(b_energy.hud_x,b_energy.hud_y)
								b_energy.transform = m_bar_02
								h_info.vis_contents += b_energy
								b_energy.menu = src
								src.bar_energy = b_energy

								var/obj/hud/menus/unlocks_background/unlocks_bar_cooldown/b_cooldown = new
								var/matrix/m_bar_03 = matrix()
								m_bar_03.Translate(b_cooldown.hud_x,b_cooldown.hud_y)
								b_cooldown.transform = m_bar_03
								h_info.vis_contents += b_cooldown
								b_cooldown.menu = src
								src.bar_cooldown = b_cooldown

								var/obj/hud/menus/unlocks_background/unlocks_bar_mastery/b_mastery = new
								var/matrix/m_bar_04 = matrix()
								m_bar_04.Translate(b_mastery.hud_x,b_mastery.hud_y)
								b_mastery.transform = m_bar_04
								h_info.vis_contents += b_mastery
								b_mastery.menu = src
								src.bar_mastery = b_mastery

								var/obj/hud/menus/unlocks_background/unlocks_bar_speed/b_speed = new
								var/matrix/m_bar_05 = matrix()
								m_bar_05.Translate(b_speed.hud_x,b_speed.hud_y)
								b_speed.transform = m_bar_05
								h_info.vis_contents += b_speed
								b_speed.menu = src
								src.bar_speed = b_speed
								//--------------------------------------------------------------------------

								for(var/obj/skills/s in global.learnable_skills)
									if(s.info_point_cost_type == "physical")
										h_special.vis_contents += s
				unlocks_info_txt
					icon = null
					layer = 33
					plane = 33
					maptext_width = 140
					maptext_height = 500
					hud_x = 464
					hud_y = -228
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					New()
						src.maptext = "[css_outline]<font size = 1><left>Skill info here"
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
				unlocks_icon
					icon = 'new_hud_unlocks2.dmi'
					icon_state = "skills portrait"
					layer = 33
					plane = 33
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					hud_x = 460
					hud_y = 327
					New()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
				unlocks_energy
					icon = 'unlocks_energy.dmi'
					layer = 33
					plane = 33
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseDrag()
						return
					New()
						return
				unlocks_strength
					icon = 'unlocks_strength.dmi'
					layer = 33
					plane = 33
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseDrag()
						return
					New()
						return
				unlocks_endurance
					icon = 'unlocks_endurance.dmi'
					layer = 33
					plane = 33
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseDrag()
						return
					New()
						return
				unlocks_force
					icon = 'unlocks_force.dmi'
					layer = 33
					plane = 33
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseDrag()
						return
					New()
						return
				unlocks_resistance
					icon = 'unlocks_resistance.dmi'
					layer = 33
					plane = 33
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseDrag()
						return
					New()
						return
				unlocks_agility
					icon = 'unlocks_agility.dmi'
					layer = 33
					plane = 33
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseDrag()
						return
					New()
						return
				unlocks_offence
					icon = 'unlocks_offence.dmi'
					layer = 33
					plane = 33
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseDrag()
						return
					New()
						return
				unlocks_defence
					icon = 'unlocks_defence.dmi'
					layer = 33
					plane = 33
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseDrag()
						return
					New()
						return
				unlocks_regen
					icon = 'unlocks_regen.dmi'
					layer = 33
					plane = 33
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					New()
						return
					MouseDrag()
						return
				unlocks_recovery
					icon = 'unlocks_recovery.dmi'
					layer = 33
					plane = 33
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					New()
						return
					MouseDrag()
						return
				unlocks_traits
					icon = 'unlocks_recovery.dmi'
					layer = 33
					plane = 33
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					New()
						return
					MouseDrag()
						return
				unlocks_stances
					icon = 'unlocks_recovery.dmi'
					layer = 33
					plane = 33
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					New()
						return
					MouseDrag()
						return
				holder_special
					icon = 'holder_skills.dmi'
					layer = 33
					plane = 33
					hud_x = 12
					hud_y = -374
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					New()
						return
					MouseDrag()
						return
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/unlocks_background/s = src.menu
						var/obj/sc = s.scroller_skills
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-264)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						s.scrl_transform_skills[s.selected] = m

						var/ratio = -1 + ((-264 + result) / -264)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(200*ratio)

						s.bar_pos_y_skills[s.selected] = scroll_y

						var/matrix/m2 = matrix()
						m2.Translate(s.holder_special.hud_x-s.bar_pos_x_hori_skills[s.selected],s.holder_special.hud_y+s.bar_pos_y_skills[s.selected])
						s.holder_special.transform = m2
				holder_skills
					icon_state = "holder skills"
					layer = 33
					plane = 33
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					New()
						return
					MouseDrag()
						return
				holder_info
					icon_state = "holder skill info"
					layer = 33
					plane = 33
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					New()
						return
					MouseDrag()
						return
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/unlocks_background/s = src.menu
						var/obj/sc = s.scroller_info
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-298)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/ratio = -1 + ((-264 + result) / -264)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(200*ratio)

						for(var/obj/o in s.holder_info.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(o.hud_x,o.hud_y+scroll_y)
							o.transform = m2
				scrollbar_skills
					icon_state = "scrollbar skills"
					layer = 33
					plane = 33
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/unlocks_background/s = src.menu
						var/obj/sc = s.scroller_skills
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-264)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						s.scrl_transform_skills[s.selected] = m

						var/ratio = -1 + ((-264 + result) / -264)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(200*ratio)

						s.bar_pos_y_skills[s.selected] = scroll_y

						var/matrix/m2 = matrix()
						m2.Translate(s.holder_special.hud_x-s.bar_pos_x_hori_skills[s.selected],s.holder_special.hud_y+s.bar_pos_y_skills[s.selected])
						s.holder_special.transform = m2
					Click(location,control,params)
						var/obj/hud/menus/unlocks_background/s = src.menu
						var/obj/sc = s.scroller_skills
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/result = -260 + ((usr.mouse_y_true-s.unlocks_background_y)-54)
						result = clamp(result,0,-264)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						s.scrl_transform_skills[s.selected] = m

						var/ratio = -1 + ((-264 + result) / -264)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(200*ratio)

						s.bar_pos_y_skills[s.selected] = scroll_y

						var/matrix/m2 = matrix()
						m2.Translate(s.holder_special.hud_x-s.bar_pos_x_hori_skills[s.selected],s.holder_special.hud_y+s.bar_pos_y_skills[s.selected])
						s.holder_special.transform = m2
					New()
						return
					MouseDrag()
						return
				scrollbar_skills_horizontal
					icon_state = "scrollbar skills horizontal"
					layer = 33
					plane = 33
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					New()
						return
					MouseDrag()
						return
					Click(location,control,params)
						var/obj/hud/menus/unlocks_background/s = src.menu
						var/obj/sc = s.scroller_hori_skills

						usr.check_mouse_loc(params)
						var/true_x = ((usr.mouse_x-1)*32)+usr.mouse_pix_x
						usr.mouse_x_true = true_x
						var/result = (usr.mouse_x_true-s.unlocks_background_x)-27
						result = clamp(result,0,379)
						var/matrix/m = matrix()
						m.Translate(result,0)
						sc.transform = m

						s.scrl_transform_hori_skills[s.selected] = m

						var/ratio = 1 - ((379 - result) / 379)
						ratio = clamp(ratio,0,1)
						var/scroll_x = round(290*ratio)
						sc.translated_x = scroll_x

						s.bar_pos_x_hori_skills[s.selected] = scroll_x

						var/matrix/m2 = matrix()
						m2.Translate(s.holder_special.hud_x-s.bar_pos_x_hori_skills[s.selected],s.holder_special.hud_y+s.bar_pos_y_skills[s.selected])
						s.holder_special.transform = m2
				scrollbar_info
					icon_state = "scrollbar skill info"
					layer = 33
					plane = 33
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					New()
						return
					MouseDrag()
						return
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/unlocks_background/s = src.menu
						var/obj/sc = s.scroller_info
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-298)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/ratio = -1 + ((-264 + result) / -264)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(200*ratio)

						for(var/obj/o in s.holder_info.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(o.hud_x,o.hud_y+scroll_y)
							o.transform = m2
					Click(location,control,params)
						var/obj/hud/menus/unlocks_background/s = src.menu
						var/obj/sc = s.scroller_info
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/result = -293 + ((usr.mouse_y_true-s.unlocks_background_y)-54)
						result = clamp(result,0,-298)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/ratio = -1 + ((-298 + result) / -298)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(200*ratio)

						for(var/obj/o in s.holder_info.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(o.hud_x,o.hud_y+scroll_y)
							o.transform = m2
					New()
						return
					MouseDrag()
						return
				scroller_skills
					icon_state = "scroller skills"
					layer = 33
					plane = 33
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
						var/obj/hud/menus/unlocks_background/s = src.menu
						var/obj/sc = s.scroller_skills
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/result = -260 + ((usr.mouse_y_true-s.unlocks_background_y)-54)
						result = clamp(result,0,-264)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						s.scrl_transform_skills[s.selected] = m

						var/ratio = -1 + ((-264 + result) / -264)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(200*ratio)

						s.bar_pos_y_skills[s.selected] = scroll_y

						var/matrix/m2 = matrix()
						m2.Translate(s.holder_special.hud_x-s.bar_pos_x_hori_skills[s.selected],s.holder_special.hud_y+s.bar_pos_y_skills[s.selected])
						s.holder_special.transform = m2
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/unlocks_background/s = src.menu
						var/obj/sc = s.scroller_skills
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-264)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						s.scrl_transform_skills[s.selected] = m

						var/ratio = -1 + ((-264 + result) / -264)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(200*ratio)

						s.bar_pos_y_skills[s.selected] = scroll_y

						var/matrix/m2 = matrix()
						m2.Translate(s.holder_special.hud_x-s.bar_pos_x_hori_skills[s.selected],s.holder_special.hud_y+s.bar_pos_y_skills[s.selected])
						s.holder_special.transform = m2
				scroller_skills_horizontal
					icon_state = "scroller skills horizontal"
					layer = 33
					plane = 33
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					New()
						return
					MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
						var/obj/hud/menus/unlocks_background/s = src.menu
						var/obj/sc = s.scroller_hori_skills

						usr.check_mouse_loc(params)
						var/true_x = ((usr.mouse_x-1)*32)+usr.mouse_pix_x
						usr.mouse_x_true = true_x
						var/result = (usr.mouse_x_true-s.unlocks_background_x)-27
						result = clamp(result,0,379)
						var/matrix/m = matrix()
						m.Translate(result,0)
						sc.transform = m

						s.scrl_transform_hori_skills[s.selected] = m

						var/ratio = 1 - ((379 - result) / 379)
						ratio = clamp(ratio,0,1)
						var/scroll_x = round(290*ratio)
						sc.translated_x = scroll_x

						s.bar_pos_x_hori_skills[s.selected] = scroll_x

						var/matrix/m2 = matrix()
						m2.Translate(s.holder_special.hud_x-s.bar_pos_x_hori_skills[s.selected],s.holder_special.hud_y+s.bar_pos_y_skills[s.selected])
						s.holder_special.transform = m2
				scroller_info
					icon_state = "scroller skill info"
					layer = 33
					plane = 33
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					New()
						return
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/unlocks_background/s = src.menu
						var/obj/sc = s.scroller_info
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-298)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/ratio = -1 + ((-298 + result) / -298)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(200*ratio)

						for(var/obj/o in s.holder_info.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(o.hud_x,o.hud_y+scroll_y)
							o.transform = m2
					MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
						var/obj/hud/menus/unlocks_background/s = src.menu
						var/obj/sc = s.scroller_info
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/result = -293 + ((usr.mouse_y_true-s.unlocks_background_y)-54)
						result = clamp(result,0,-298)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/ratio = -1 + ((-298 + result) / -298)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(200*ratio)

						for(var/obj/o in s.holder_info.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(o.hud_x,o.hud_y+scroll_y)
							o.transform = m2
				unlock_button
					icon = 'psiforge_button.dmi'
					icon_state = "button"
					layer = 32
					plane = 33
					maptext_width = 64
					maptext_height = 16
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					hud_x = 510
					hud_y = 6
					maptext_x = -5
					maptext_y = 4
					New()
						src.maptext = "[css_outline]<font size = 1><center>Increase"
						return
					MouseEntered()
						src.icon_state = "button hover"
					MouseExited()
						src.icon_state = "button"
					MouseDrag()
						return
					Click()
						if(usr.skill_selected.name) usr.increase_passive("[usr.skill_selected.name]")
				unlocks_title
					icon = null
					layer = 33
					plane = 33
					hud_x = 160
					hud_y = 368
					maptext_width = 128
					maptext_height = 16
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					New()
						src.maptext = "[css_outline]<font size = 1><center>Passive Tree"
						return
					MouseDrag()
						return
				unlocks_skill_name
					icon = null
					layer = 33
					plane = 33
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					hud_x = 438
					hud_y = 350
					maptext_width = 200
					maptext_height = 16
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					New()
						src.maptext = "[css_outline]<font size = 1><center>Skill Name"
						return
					MouseDrag()
						return
				unlocks_points
					icon = null
					layer = 33
					plane = 33
					hud_x = 2
					hud_y = 688
					maptext_width = 200
					maptext_height = 16
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					New()
						src.maptext = "[css_outline]<font size = 1><left>Passive Points: 0"
						return
					MouseDrag()
						return
				/*
				1 - eng
				2 - str
				3 - end
				4 - agil
				5 - off
				6 - def
				7 - for
				8 - res
				9 - regen
				10 - recov
				11 - traits
				12 - stances
				*/
				tab_energy
					icon = 'hud_unlock_tabs.dmi'
					icon_state = "selected"
					layer = 33
					plane = 33
					hud_x = 11
					hud_y = 347
					maptext_width = 96
					maptext_height = 16
					maptext_y = 3
					maptext_x = -13
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					New()
						src.maptext = "[css_outline]<font size = 1><center>Energy"
						return
					MouseDrag()
						return
					MouseEntered()
						if(src.icon_state != "selected") src.icon_state = "hover"
					MouseExited()
						if(src.icon_state != "selected") src.icon_state = "unselected"
					Click()
						if(src.menu == usr.hud_unlocks) src.switch_tab(1,usr)
				tab_strength
					icon = 'hud_unlock_tabs.dmi'
					icon_state = "unselected"
					layer = 33
					plane = 33
					hud_x = 82
					hud_y = 347
					maptext_width = 96
					maptext_height = 16
					maptext_y = 3
					maptext_x = -13
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					New()
						src.maptext = "[css_outline]<font size = 1><center>Strength"
						return
					MouseDrag()
						return
					MouseEntered()
						if(src.icon_state != "selected") src.icon_state = "hover"
					MouseExited()
						if(src.icon_state != "selected") src.icon_state = "unselected"
					Click()
						if(src.menu == usr.hud_unlocks) src.switch_tab(2,usr)
				tab_endurance
					icon = 'hud_unlock_tabs.dmi'
					icon_state = "unselected"
					layer = 33
					plane = 33
					hud_x = 153
					hud_y = 347
					maptext_width = 96
					maptext_height = 16
					maptext_y = 3
					maptext_x = -13
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					New()
						src.maptext = "[css_outline]<font size = 1><center>Endurance"
						return
					MouseDrag()
						return
					MouseEntered()
						if(src.icon_state != "selected") src.icon_state = "hover"
					MouseExited()
						if(src.icon_state != "selected") src.icon_state = "unselected"
					Click()
						if(src.menu == usr.hud_unlocks) src.switch_tab(3,usr)
				tab_agility
					icon = 'hud_unlock_tabs.dmi'
					icon_state = "unselected"
					layer = 33
					plane = 33
					hud_x = 224
					hud_y = 347
					maptext_width = 96
					maptext_height = 16
					maptext_y = 3
					maptext_x = -13
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					New()
						src.maptext = "[css_outline]<font size = 1><center>Agility"
						return
					MouseDrag()
						return
					MouseEntered()
						if(src.icon_state != "selected") src.icon_state = "hover"
					MouseExited()
						if(src.icon_state != "selected") src.icon_state = "unselected"
					Click()
						if(src.menu == usr.hud_unlocks) src.switch_tab(4,usr)
				tab_offence
					icon = 'hud_unlock_tabs.dmi'
					icon_state = "unselected"
					layer = 33
					plane = 33
					hud_x = 295
					hud_y = 347
					maptext_width = 96
					maptext_height = 16
					maptext_y = 3
					maptext_x = -13
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					New()
						src.maptext = "[css_outline]<font size = 1><center>Offence"
						return
					MouseDrag()
						return
					MouseEntered()
						if(src.icon_state != "selected") src.icon_state = "hover"
					MouseExited()
						if(src.icon_state != "selected") src.icon_state = "unselected"
					Click()
						if(src.menu == usr.hud_unlocks) src.switch_tab(5,usr)
				tab_defence
					icon = 'hud_unlock_tabs.dmi'
					icon_state = "unselected"
					layer = 33
					plane = 33
					hud_x = 366
					hud_y = 347
					maptext_width = 96
					maptext_height = 16
					maptext_y = 3
					maptext_x = -13
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					New()
						src.maptext = "[css_outline]<font size = 1><center>Defence"
						return
					MouseDrag()
						return
					MouseEntered()
						if(src.icon_state != "selected") src.icon_state = "hover"
					MouseExited()
						if(src.icon_state != "selected") src.icon_state = "unselected"
					Click()
						if(src.menu == usr.hud_unlocks) src.switch_tab(6,usr)
				tab_force
					icon = 'hud_unlock_tabs.dmi'
					icon_state = "unselected"
					layer = 33
					plane = 33
					hud_x = 11
					hud_y = 330
					maptext_width = 96
					maptext_height = 16
					maptext_y = 3
					maptext_x = -13
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					New()
						src.maptext = "[css_outline]<font size = 1><center>Force"
						return
					MouseDrag()
						return
					MouseEntered()
						if(src.icon_state != "selected") src.icon_state = "hover"
					MouseExited()
						if(src.icon_state != "selected") src.icon_state = "unselected"
					Click()
						if(src.menu == usr.hud_unlocks) src.switch_tab(7,usr)
				tab_resistance
					icon = 'hud_unlock_tabs.dmi'
					icon_state = "unselected"
					layer = 33
					plane = 33
					hud_x = 82
					hud_y = 330
					maptext_width = 96
					maptext_height = 16
					maptext_y = 3
					maptext_x = -13
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					New()
						src.maptext = "[css_outline]<font size = 1><center>Resistance"
						return
					MouseDrag()
						return
					MouseEntered()
						if(src.icon_state != "selected") src.icon_state = "hover"
					MouseExited()
						if(src.icon_state != "selected") src.icon_state = "unselected"
					Click()
						if(src.menu == usr.hud_unlocks) src.switch_tab(8,usr)
				tab_regen
					icon = 'hud_unlock_tabs.dmi'
					icon_state = "unselected"
					layer = 33
					plane = 33
					hud_x = 153
					hud_y = 330
					maptext_width = 96
					maptext_height = 16
					maptext_y = 3
					maptext_x = -13
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					New()
						src.maptext = "[css_outline]<font size = 1><center>Regeneration"
						return
					MouseDrag()
						return
					MouseEntered()
						if(src.icon_state != "selected") src.icon_state = "hover"
					MouseExited()
						if(src.icon_state != "selected") src.icon_state = "unselected"
					Click()
						if(src.menu == usr.hud_unlocks) src.switch_tab(9,usr)
				tab_recovery
					icon = 'hud_unlock_tabs3.dmi'
					icon_state = "unselected"
					layer = 33
					plane = 33
					hud_x = 11
					hud_y = 330
					maptext_width = 96
					maptext_height = 16
					maptext_y = 3
					maptext_x = -2
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					New()
						src.maptext = "[css_outline]<font size = 1><center>Combat Tree"
						return
					MouseDrag()
						return
					MouseEntered()
						if(src.icon_state != "selected") src.icon_state = "hover"
					MouseExited()
						if(src.icon_state != "selected") src.icon_state = "unselected"
					Click()
						if(src.menu == usr.hud_unlocks) src.switch_tab(1,usr)
				tab_traits
					icon = 'hud_unlock_tabs3.dmi'
					icon_state = "unselected"
					layer = 33
					plane = 33
					hud_x = 153
					hud_y = 330
					maptext_width = 96
					maptext_height = 16
					maptext_y = 3
					maptext_x = -2
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					New()
						src.maptext = "[css_outline]<font size = 1><center>Technology Tree"
						return
					MouseDrag()
						return
					MouseEntered()
						if(src.icon_state != "selected") src.icon_state = "hover"
					MouseExited()
						if(src.icon_state != "selected") src.icon_state = "unselected"
					Click()
						if(src.menu == usr.hud_unlocks) src.switch_tab(2,usr)
				tab_stances
					icon = 'hud_unlock_tabs3.dmi'
					icon_state = "unselected"
					layer = 33
					plane = 33
					hud_x = 295
					hud_y = 330
					maptext_width = 96
					maptext_height = 16
					maptext_y = 3
					maptext_x = -2
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					New()
						src.maptext = "[css_outline]<font size = 1><center>Stances"
						return
					MouseDrag()
						return
					MouseEntered()
						if(src.icon_state != "selected") src.icon_state = "hover"
					MouseExited()
						if(src.icon_state != "selected") src.icon_state = "unselected"
					Click()
						if(src.menu == usr.hud_unlocks) src.switch_tab(3,usr)
				unlocks_icon_power
					icon = 'new_hud_skill_icons.dmi'
					icon_state = "dmg"
					layer = 33
					plane = 33
					hud_x = 534
					hud_y = 328
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseExited()
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseEntered()
						spawn(6)
							if(usr && usr.mouse_saved_loc == src)
								if(usr.info_box1)
									usr.client.screen += usr.info_box1
									usr.client.screen += usr.info_box2
									usr.client.screen += usr.info_box3
					MouseMove(location,control,params)
						..()
						usr.info_box(src,"This is the damage rating of the skill. The more bars, the higher the damage.",params)
					New()
						return
					MouseDrag()
						return
				unlocks_icon_speed
					icon = 'new_hud_skill_icons.dmi'
					icon_state = "spd"
					layer = 33
					plane = 33
					hud_x = 534
					hud_y = 308
					box_x_scale = 128
					box_y_scale = 50
					box_x_shift = 64
					box_y_shift = 25
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseExited()
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseEntered()
						spawn(6)
							if(usr && usr.mouse_saved_loc == src)
								if(usr.info_box1)
									usr.client.screen += usr.info_box1
									usr.client.screen += usr.info_box2
									usr.client.screen += usr.info_box3
					MouseMove(location,control,params)
						..()
						usr.info_box(src,"This is either how fast a skill projectile moves, or how fast a skill charges.",params)
					New()
						return
					MouseDrag()
						return
				unlocks_icon_energy
					icon = 'new_hud_skill_icons.dmi'
					icon_state = "eng"
					layer = 33
					plane = 33
					hud_x = 534
					hud_y = 288
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseExited()
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseEntered()
						spawn(6)
							if(usr && usr.mouse_saved_loc == src)
								if(usr.info_box1)
									usr.client.screen += usr.info_box1
									usr.client.screen += usr.info_box2
									usr.client.screen += usr.info_box3
					MouseMove(location,control,params)
						..()
						usr.info_box(src,"This is the energy usage of the skill. The more bars, the more energy is expended when used.",params)
					New()
						return
					MouseDrag()
						return
				unlocks_icon_mastery
					icon = 'new_hud_skill_icons.dmi'
					icon_state = "xp"
					layer = 33
					plane = 33
					hud_x = 534
					hud_y = 268
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseExited()
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseEntered()
						spawn(6)
							if(usr && usr.mouse_saved_loc == src)
								if(usr.info_box1)
									usr.client.screen += usr.info_box1
									usr.client.screen += usr.info_box2
									usr.client.screen += usr.info_box3
					MouseMove(location,control,params)
						..()
						usr.info_box(src,"Here you can see how quickly a skill is mastered. The more bars, the quicker it will level when used.",params)
					New()
						return
					MouseDrag()
						return
				unlocks_icon_cooldown
					icon = 'new_hud_skill_icons.dmi'
					icon_state = "cd"
					layer = 33
					plane = 33
					hud_x = 534
					hud_y = 248
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseExited()
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseEntered()
						spawn(6)
							if(usr && usr.mouse_saved_loc == src)
								if(usr.info_box1)
									usr.client.screen += usr.info_box1
									usr.client.screen += usr.info_box2
									usr.client.screen += usr.info_box3
					MouseMove(location,control,params)
						..()
						usr.info_box(src,"Skill cooldowns can be found here. More bars represent a higher cooldown on a skill. No bars means it has no cooldown at all.",params)
					New()
						return
					MouseDrag()
						return

				unlocks_bar_power
					icon = 'new_hud_skill_bars.dmi'
					icon_state = "1"
					layer = 33
					plane = 33
					hud_x = 553
					hud_y = 333
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseExited()
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseEntered()
						spawn(6)
							if(usr && usr.mouse_saved_loc == src)
								if(usr.info_box1)
									usr.client.screen += usr.info_box1
									usr.client.screen += usr.info_box2
									usr.client.screen += usr.info_box3
					MouseMove(location,control,params)
						..()
						usr.info_box(src,"This is the damage rating of the skill. The more bars, the higher the damage.",params)
					New()
						return
					MouseDrag()
						return
				unlocks_bar_speed
					icon = 'new_hud_skill_bars.dmi'
					icon_state = "1"
					layer = 33
					plane = 33
					hud_x = 553
					hud_y = 313
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseExited()
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseEntered()
						spawn(6)
							if(usr && usr.mouse_saved_loc == src)
								if(usr.info_box1)
									usr.client.screen += usr.info_box1
									usr.client.screen += usr.info_box2
									usr.client.screen += usr.info_box3
					MouseMove(location,control,params)
						..()
						usr.info_box(src,"This is either how fast a skill projectile moves, or how fast a skill charges.",params)
					New()
						return
					MouseDrag()
						return
				unlocks_bar_energy
					icon = 'new_hud_skill_bars.dmi'
					icon_state = "1"
					layer = 33
					plane = 33
					hud_x = 553
					hud_y = 293
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseExited()
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseEntered()
						spawn(6)
							if(usr && usr.mouse_saved_loc == src)
								if(usr.info_box1)
									usr.client.screen += usr.info_box1
									usr.client.screen += usr.info_box2
									usr.client.screen += usr.info_box3
					MouseMove(location,control,params)
						..()
						usr.info_box(src,"This is the energy usage of the skill. The more bars, the more energy is expended when used.",params)
					New()
						return
					MouseDrag()
						return
				unlocks_bar_mastery
					icon = 'new_hud_skill_bars.dmi'
					icon_state = "1"
					layer = 33
					plane = 33
					hud_x = 553
					hud_y = 273
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseExited()
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseEntered()
						spawn(6)
							if(usr && usr.mouse_saved_loc == src)
								if(usr.info_box1)
									usr.client.screen += usr.info_box1
									usr.client.screen += usr.info_box2
									usr.client.screen += usr.info_box3
					MouseMove(location,control,params)
						..()
						usr.info_box(src,"Here you can see how quickly a skill is mastered. The more bars, the quicker it will level when used.",params)
					New()
						return
					MouseDrag()
						return
				unlocks_bar_cooldown
					icon = 'new_hud_skill_bars.dmi'
					icon_state = "1"
					layer = 33
					plane = 33
					hud_x = 553
					hud_y = 253
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseExited()
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseEntered()
						spawn(6)
							if(usr && usr.mouse_saved_loc == src)
								if(usr.info_box1)
									usr.client.screen += usr.info_box1
									usr.client.screen += usr.info_box2
									usr.client.screen += usr.info_box3
					MouseMove(location,control,params)
						..()
						usr.info_box(src,"Skill cooldowns can be found here. More bars represent a higher cooldown on a skill. No bars means it has no cooldown at all.",params)
					New()
						return
					MouseDrag()
						return
				unlocks_overlays
					icon = 'new_hud_unlocks2.dmi'
					icon_state = "overlays"
					layer = 33
					plane = 33
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					New()
						return
					MouseDrag()
						return
			/*
			Needs a Psiforge button
			Needs a cybernetics tab/menu/window
			Maybe show what stats were earned from the bodypart already, inside the info holder
			Maybe make the bodyparts have a filter outline
			Have the reason for a part being disabled displayed in the info holder, i.e Disabled by: broken Left Lower Arm Bone, Disabled by: No body, ect.
			*/
			limb_paperdoll
				//icon = 'new_hud_body4.dmi'
				//icon_state = "body male"
				icon = 'limbStats.dmi'
				layer=29
				screen_loc = "TOP+1:5 , RIGHT+8:10"
				//plane = 22
				var/icon/I
				var/setup = 0
				var/body_background_x = 300
				var/body_background_y = 100
				var/obj/hud/menus/limb_paperdoll/menu
				var/obj/hud/menus/limb_paperdoll/bodypart/area_selected
				var/bodypart_type
				var/obj/overs
				var/obj/bodypart_holder
				var/obj/info_holder
				var/obj/other_holder
				var/obj/default_holder
				var/obj/hud/menus/limb_paperdoll/bodypart/bodypart_icon
				var/obj/part_name
				var/obj/part_status
				var/obj/part_health
				var/obj/part_level
				var/obj/part_training
				var/obj/part_cyber
				var/obj/part_cybernetics
				var/obj/part_stats
				var/obj/part_stats_trained
				var/obj/part_infuse
				var/obj/part_disabled
				var/obj/part_req
				var/obj/button_remove
				var/obj/hp_bar
				var/obj/xp_bar
				var/obj/scroller_i
				var/obj/scroller_p
				var/obj/scroller_o
				var/obj/bar_i
				var/obj/bar_p
				var/obj/bar_o
				var/obj/psiforge
				var/list/body
				var/obj/tab1
				var/obj/tab2
				var/obj/tab3
				var/obj/tab4
				var/obj/tab5
				var/obj/symbol_1
				var/obj/txt_tab
				var/obj/txt_requirements
				var/max_scroll_parts
				var/max_scroll_reqs
				/*proc/color_paperdoll(var/mob/player)
						/*
						bodyparts list indexes are
						1 = head
						2 = torso
						3 = left arm
						4 = right arm
						5 = right leg
						6 = left leg
					*/
					var/hps = 1
					var/hps_max = 1
					var/hp_percent = 0
					var/G = "male"
					if(player.gen == "Female") G = "female"

					//Color the head first
					var/obj/left_arm = src.body[1]
					var/obj/head_actual = player.body[1]
					if(player.has_body == 0)
						left_arm.icon_state = "1"
					else
						for(var/obj/body_related/part in head_actual)
							if(part.damaged || part.disabled) hps += 0
							else hps += part.hp
							hps_max += part.hp_max
						if(hps_max <= 0) hps_max = 1
						hp_percent = round((hps/hps_max)*100)
						if(hp_percent >= 100 ) left_arm.icon_state = "1"
						else if(hp_percent >= 66 && hp_percent < 100) left_arm.icon_state = "1G"
						else if(hp_percent >= 33 && hp_percent < 66) left_arm.icon_state = "1Y"
						else if(hp_percent >= 0 && hp_percent < 33) left_arm.icon_state = "1R"
						//world << "DEBUG - head: [hp_percent]%"
						hps = 0
						hps_max = 0

					//Color the torso
					var/obj/right_arm = src.body[2]
					var/obj/torso_actual = player.body[2]
					if(player.has_body == 0)
						right_arm.icon_state = "2"
					else
						for(var/obj/body_related/part in torso_actual)
							if(part.damaged || part.disabled) hps += 0
							else hps += part.hp
							hps_max += part.hp_max
						if(hps_max <= 0) hps_max = 1
						hp_percent = round((hps/hps_max)*100)
						if(hp_percent >= 100) right_arm.icon_state = "2"
						else if(hp_percent >= 66 && hp_percent < 100) right_arm.icon_state = "2G"
						else if(hp_percent >= 33 && hp_percent < 66) right_arm.icon_state = "2Y"
						else if(hp_percent >= 0 && hp_percent < 33) right_arm.icon_state = "2R"
						//world << "DEBUG - torso: [hp_percent]%"
						hps = 0
						hps_max = 0

					//Color the left arm
					var/obj/left_leg = src.body[3]
					var/obj/leftarm_actual = player.body[3]
					if(player.has_body == 0)
						left_leg.icon_state = "3"
					else
						for(var/obj/body_related/part in leftarm_actual)
							if(part.damaged || part.disabled) hps += 0
							else hps += part.hp
							hps_max += part.hp_max
						if(hps_max <= 0) hps_max = 1
						hp_percent = round((hps/hps_max)*100)
						if(hp_percent >= 100) left_leg.icon_state = "3"
						else if(hp_percent >= 66 && hp_percent < 100) left_leg.icon_state = "3G"
						else if(hp_percent >= 33 && hp_percent < 66) left_leg.icon_state = "3Y"
						else if(hp_percent >= 0 && hp_percent < 33) left_leg.icon_state = "3R"
						//world << "DEBUG - left arm: [hp_percent]%"
						hps = 0
						hps_max = 0

					//Color the right arm
					var/obj/right_leg = src.body[4]
					var/obj/rightarm_actual = player.body[4]
					if(player.has_body == 0)
						right_leg.icon_state = "4"
					else
						for(var/obj/body_related/part in rightarm_actual)
							if(part.damaged || part.disabled) hps += 0
							else hps += part.hp
							hps_max += part.hp_max
						if(hps_max <= 0) hps_max = 1
						hp_percent = round((hps/hps_max)*100)
						if(hp_percent >= 100) right_leg.icon_state = "4"
						else if(hp_percent >= 66 && hp_percent < 100) right_leg.icon_state = "4G"
						else if(hp_percent >= 33 && hp_percent < 66) right_leg.icon_state = "4Y"
						else if(hp_percent >= 0 && hp_percent < 33) right_leg.icon_state = "4R"
						//world << "DEBUG - right arm: [hp_percent]%"
						hps = 0
						hps_max = 0

					/*//Color the right leg
					var/obj/rightleg_doll = src.body[5]
					var/obj/rightleg_actual = player.bodyparts[5]
					if(player.has_body == 0)
						rightleg_doll.icon_state = "body [G] right leg grey"
					else
						for(var/obj/body_related/part in rightleg_actual)
							if(part.damaged || part.disabled) hps += 0
							else hps += part.hp
							hps_max += part.hp_max
						if(hps_max <= 0) hps_max = 1
						hp_percent = round((hps/hps_max)*100)
						if(hp_percent >= 100) rightleg_doll.icon_state = "body [G] right leg green"
						else if(hp_percent >= 66) rightleg_doll.icon_state = "body [G] right leg yellow"
						else if(hp_percent >= 33) rightleg_doll.icon_state = "body [G] right leg orange"
						else if(hp_percent >= 0) rightleg_doll.icon_state = "body [G] right leg red"
						//world << "DEBUG - right leg: [hp_percent]%"
						hps = 0
						hps_max = 0

					//Color the left leg
					var/obj/leftleg_doll = src.body[6]
					var/obj/leftleg_actual = player.bodyparts[6]
					if(player.has_body == 0)
						leftleg_doll.icon_state = "body [G] left leg grey"
					else
						for(var/obj/body_related/part in leftleg_actual)
							if(part.damaged || part.disabled) hps += 0
							else hps += part.hp
							hps_max += part.hp_max
						if(hps_max <= 0) hps_max = 1
						hp_percent = round((hps/hps_max)*100)
						if(hp_percent >= 100) leftleg_doll.icon_state = "body [G] left leg green"
						else if(hp_percent >= 66) leftleg_doll.icon_state = "body [G] left leg yellow"
						else if(hp_percent >= 33) leftleg_doll.icon_state = "body [G] left leg orange"
						else if(hp_percent >= 0) leftleg_doll.icon_state = "body [G] left leg red"
						//world << "DEBUG - left leg: [hp_percent]%"
						*/
				proc/show_parts(var/mob/m)
					src.info_holder.vis_contents = null
					//Proceed to check which tab was selected, then re-add the appropiate objs to the vis_contents

					//Bodyparts
					if(m.started==1)

						src.info_holder.vis_contents += src.bodypart_icon
						//src.info_holder.vis_contents += src.part_status
						src.info_holder.vis_contents += src.part_health
						src.info_holder.vis_contents += src.part_level
						src.info_holder.vis_contents += src.part_training
					//	src.info_holder.vis_contents += src.part_cyber
					//	src.info_holder.vis_contents += src.part_stats_trained
					//	src.info_holder.vis_contents += src.psiforge
					//	src.info_holder.vis_contents += src.part_stats
						src.info_holder.vis_contents += src.overs
					//	src.info_holder.vis_contents += src.xp_bar
				proc/menu_create()
					//if(src.setup)
					//	return
					spawn()
						if(src)
							src.setup = 1

							src.body = list()

							if(ismob(src.loc) == 0)
								src.destroy()
								return

							src.I = new(src.icon)

							var/matrix/m_main = matrix()
							m_main.Translate(100,100)
							src.transform = m_main

							var/obj/hud/menus/limb_paperdoll/bodypart/bodypart1 = new
							bodypart1.icon_state = "1"
							bodypart1.menu = src
						//	bodypart1.bodypart_type = "head"
							bodypart1.bodypart_type = "leftarm"
						//	src.vis_contents += bodypart1
							//src.body += bodypart1
							bodypart1.name = "Left Arm"
							bodypart1.layer = 33
							bodypart1.screen_loc = "1,1"
							//bodypart1.filters += filter(type="outline",size=1, color=rgb(255,255,255))

							var/obj/hud/menus/limb_paperdoll/bodypart/bodypart2 = new
							bodypart2.icon_state = "2"
							bodypart2.menu = src
							// torso
							bodypart2.bodypart_type = "rightarm"
							src.vis_contents += bodypart2
						//	src.body += bodypart2
							bodypart2.name = "Right Arm"
							src.area_selected = bodypart2
							bodypart2.layer = 33
							bodypart2.screen_loc = "1,2"
						//	bodypart2.filters += filter(type="outline",size=1, color=rgb(255,255,255))
						//	spawn(30)
							//	if(src && bodypart2 && ismob(src.loc))
									//bodypart2.display_selected_part(bodypart2.bodypart_type,src.loc)

							var/obj/hud/menus/limb_paperdoll/bodypart/bodypart3 = new
							bodypart3.icon_state = "3"
							bodypart3.menu = src
							//leftarm
							bodypart3.bodypart_type = "leftleg"
						//src.vis_contents += bodypart3
						//	src.body += bodypart3
							bodypart3.screen_loc = "2,1"
							bodypart3.name = "Left Leg"

							var/obj/hud/menus/limb_paperdoll/bodypart/bodypart4 = new
							bodypart4.icon_state = "4"
							bodypart4.menu = src
							//rightarm
							bodypart4.bodypart_type = "rightleg"
							//src.vis_contents += bodypart4
							//src.body += bodypart4
							bodypart4.screen_loc = "2,2"
							bodypart4.name = "Right Leg"

						/*	var/obj/hud/menus/limb_paperdoll/bodypart/bodypart5 = new
							bodypart5.icon_state = "body male right leg green"
							bodypart5.menu = src
							bodypart5.bodypart_type = "rightleg"
							src.vis_contents += bodypart5
							src.body += bodypart5
							bodypart5.name = "Right Leg"

							var/obj/hud/menus/limb_paperdoll/bodypart/bodypart6 = new
							bodypart6.icon_state = "body male left leg green"
							bodypart6.menu = src
							bodypart6.bodypart_type = "leftleg"
							src.vis_contents += bodypart6
							src.body += bodypart6
							bodypart6.name = "Left Leg"
							*/

				bodypart
					icon = 'new_hud_body4.dmi'
					icon_state = "body female"
					layer = 32
					plane = 22
					var/scroller_transform //The y location of where the scrollbar was saved, so when switching between different bodyparts it doesn't just reset for each one.
					var/scroller_translated = 0
					var/parts_transform //The transform of the vis_contents inside parts_holder
					/*
					bodyparts list indexes are
					1 = head
					2 = torso
					3 = left arm
					4 = right arm
					5 = right leg
					6 = left leg
					*/
					MouseEntered(location,control,params)
						if(src.menu.area_selected != src)
							src.layer = 33
							if(src.filters) src.filters -= filter(type="outline",size=1, color=rgb(255,255,255))
							src.filters += filter(type="outline",size=1, color=rgb(255,255,255))
						if(usr.info_box1)
							usr.client.screen += usr.info_box1
							usr.client.screen += usr.info_box2
							usr.client.screen += usr.info_box3
							usr.info_box(src,src.name,params)
					MouseExited(location,control,params)
						if(src.menu.area_selected != src)
							src.layer = 32
							src.filters -= filter(type="outline",size=1, color=rgb(255,255,255))
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseMove(location,control,params)
						..()
						usr.info_box(src,src.name,params)
					New()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
*/

			bodyparts_background
				//icon = 'new_hud_body4.dmi'
				icon = 'limbStats.dmi'
				icon_state = "1"
				//icon_state = "empty2"
				layer = 32
				screen_loc = "1,1"
				plane = 22
				var/selected = 1
				var/ww = 0
				var/hh = 0
				var/icon/I
				var/setup = 0
				var/body_background_x = 300
				var/body_background_y = 100
				var/obj/hud/menus/bodyparts_background/menu
				var/obj/hud/menus/bodyparts_background/bodypart/area_selected
				var/bodypart_type
				var/obj/overs
				var/obj/bodypart_holder
				var/obj/info_holder
				var/obj/other_holder
				var/obj/default_holder
				var/obj/hud/menus/bodyparts_background/part_icon/bodypart_icon
				var/obj/part_name
				var/obj/part_status
				var/obj/part_health
				var/obj/part_level
				var/obj/part_training
				var/obj/part_cyber
				var/obj/part_cybernetics
				var/obj/part_stats
				var/obj/part_stats_trained
				var/obj/part_infuse
				var/obj/part_disabled
				var/obj/part_req
				var/obj/button_remove
				var/obj/hp_bar
				var/obj/xp_bar
				var/obj/scroller_i
				var/obj/scroller_p
				var/obj/scroller_o
				var/obj/bar_i
				var/obj/bar_p
				var/obj/bar_o
				var/obj/psiforge
				var/list/body
				var/obj/tab1
				var/obj/tab2
				//var/obj/tab3
				//var/obj/tab4
				//var/obj/tab5
				var/obj/symbol_1
				var/obj/txt_tab
				var/obj/txt_requirements
				var/max_scroll_parts
				var/max_scroll_reqs
				MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
					params = params2list(params)
					var/icon_y = text2num(params["icon-y"])
					if(icon_y >= 331 || usr.mouse_down)
						usr.client.MousePosition(params)
						var/matrix/m = matrix()
						var/icon_x = text2num(params["icon-x"])
						if(usr.drag_icon_x == 0) usr.drag_icon_x = icon_x
						var/x_result = usr.client.client_mouse_x-usr.drag_icon_x
						var/y_result = usr.client.client_mouse_y-src.hh
						x_result = clamp(x_result,0,1023-src.ww)
						y_result = clamp(y_result,0,575-(src.hh/2))
						m.Translate(x_result,y_result)
						src.transform = m
						src.body_background_x = x_result
						src.body_background_y = y_result
						usr.mouse_down = src
				proc
					/// Removes the visual paperdoll icon for a given limb by name.
					remove_limb_doll(var/limb_name)
						var/index = 0
						switch(limb_name)
							if("Left Arm") index = 1
							if("Right Arm") index = 2
							if("Right Leg") index = 4
							if("Left Leg") index = 3
						if(index)
							var/obj/limb_doll = body[index]
							if(limb_doll)
								if(index == 1 ) limb_doll.icon_state = "1N" // You can create a blank state or hide it visually
								if(index == 2 ) limb_doll.icon_state = "2N"
								if(index == 3 ) limb_doll.icon_state = "3N"
								if(index == 4 ) limb_doll.icon_state = "4N"
					show_parts(var/mob/m)
						src.info_holder.vis_contents = null
						//Proceed to check which tab was selected, then re-add the appropiate objs to the vis_contents

						//Bodyparts
						if(m.started==1)

							src.info_holder.vis_contents += src.bodypart_icon
							src.info_holder.vis_contents += src.part_status
							src.info_holder.vis_contents += src.part_health
							src.info_holder.vis_contents += src.part_level
							src.info_holder.vis_contents += src.part_training
							src.info_holder.vis_contents += src.part_cyber
							src.info_holder.vis_contents += src.part_stats_trained
							src.info_holder.vis_contents += src.psiforge
							src.info_holder.vis_contents += src.part_stats
							src.info_holder.vis_contents += src.overs
							src.info_holder.vis_contents += src.xp_bar
					color_paperdoll(var/mob/player)
						/*
						bodyparts list indexes are
						1 = head
						2 = torso
						3 = left arm
						4 = right arm
						5 = right leg
						6 = left leg
						*/
						var/hps = 1
						var/hps_max = 1
						var/hp_percent = 0

						//Color the head first
						var/obj/body_related/left_arm = src.body[1]
						var/obj/body_related/head_actual = player.body[1]
						if(player.has_body == 0)
							left_arm.icon_state = "1"
						else
							//for(var/obj/body_related/part in head_actual)
							if(head_actual.damaged || head_actual.disabled) hps += 0
							else hps += head_actual.hp
							hps_max += head_actual.hp_max
							if(hps_max <= 0) hps_max = 1
							hp_percent = round((hps/hps_max)*100)

							if(hp_percent >= 100 ) left_arm.icon_state = "1"
							else if(hp_percent >= 66 && hp_percent < 100) left_arm.icon_state = "1G"
							else if(hp_percent >= 33 && hp_percent < 66) left_arm.icon_state = "1Y"
							else if(hp_percent > 0 && hp_percent < 33) left_arm.icon_state = "1R"
							else if(hp_percent <=0) left_arm.icon_state = "1B"
							//world << "DEBUG - head: [hp_percent]%"
							hps = 0
							hps_max = 0

						//Color the torso
						var/obj/body_related/right_arm = src.body[2]
						var/obj/body_related/torso_actual = player.body[2]
						if(player.has_body == 0)
							right_arm.icon_state = "2"
						else
							//for(var/obj/body_related/part in torso_actual)
							if(torso_actual.damaged || torso_actual.disabled) hps += 0
							else hps += torso_actual.hp
							hps_max += torso_actual.hp_max
							if(hps_max <= 0) hps_max = 1
							hp_percent = round((hps/hps_max)*100)
							if(hp_percent >= 100) right_arm.icon_state = "2"
							else if(hp_percent >= 66 && hp_percent < 100) right_arm.icon_state = "2G"
							else if(hp_percent >= 33 && hp_percent < 66) right_arm.icon_state = "2Y"
							else if(hp_percent >= 0 && hp_percent < 33) right_arm.icon_state = "2R"
							else if(hp_percent <=0) right_arm.icon_state = "2B"
							//world << "DEBUG - torso: [hp_percent]%"
							hps = 0
							hps_max = 0

						//Color the left arm
						var/obj/body_related/left_leg = src.body[3]
						var/obj/body_related/leftarm_actual = player.body[3]
						if(player.has_body == 0)
							left_leg.icon_state = "3"
						else
							//for(var/obj/body_related/part in leftarm_actual)
							if(leftarm_actual.damaged || leftarm_actual.disabled) hps += 0
							else hps += leftarm_actual.hp
							hps_max += leftarm_actual.hp_max
							if(hps_max <= 0) hps_max = 1
							hp_percent = round((hps/hps_max)*100)
							if(hp_percent >= 100) left_leg.icon_state = "3"
							else if(hp_percent >= 66 && hp_percent < 100) left_leg.icon_state = "3G"
							else if(hp_percent >= 33 && hp_percent < 66) left_leg.icon_state = "3Y"
							else if(hp_percent >= 0 && hp_percent < 33) left_leg.icon_state = "3R"
							else if(hp_percent <=0) left_leg.icon_state = "3B"
							//world << "DEBUG - left arm: [hp_percent]%"
							hps = 0
							hps_max = 0

						//Color the right arm
						var/obj/body_related/right_leg = src.body[4]
						var/obj/body_related/rightarm_actual = player.body[4]
						if(player.has_body == 0)
							right_leg.icon_state = "4"
						else
							//for(var/obj/body_related/part in rightarm_actual)
							if(rightarm_actual.damaged || rightarm_actual.disabled) hps += 0
							else hps += rightarm_actual.hp
							hps_max += rightarm_actual.hp_max
							if(hps_max <= 0) hps_max = 1
							hp_percent = round((hps/hps_max)*100)
							if(hp_percent >= 100) right_leg.icon_state = "4"
							else if(hp_percent >= 66 && hp_percent < 100) right_leg.icon_state = "4G"
							else if(hp_percent >= 33 && hp_percent < 66) right_leg.icon_state = "4Y"
							else if(hp_percent >= 0 && hp_percent < 33) right_leg.icon_state = "4R"
							else if(hp_percent <=0) right_leg.icon_state = "4B"
							//world << "DEBUG - right arm: [hp_percent]%"
							hps = 0
							hps_max = 0

					menu_create()
						if(src.setup)
							return
						spawn()
							if(src)
								src.setup = 1

								src.body = list()

								if(ismob(src.loc) == 0)
									src.destroy()
									return

								src.I = new(src.icon)
								src.ww = I.Width()
								src.hh = I.Height()

								var/matrix/m_main = matrix()
								m_main.Translate(300,100)
								src.transform = m_main


								var/obj/hud/buttons/close_menu/cm = new
								cm.plane = src.plane
								cm.closes = src
								var/matrix/close_m = matrix()
								close_m.Translate(src.ww-15,src.hh-15)
								cm.transform = close_m
								src.vis_contents += cm

								var/obj/hud/menus/bodyparts_background/part_tab1/t1 = new
								t1.menu = src
								var/matrix/m_t1 = matrix()
								m_t1.Translate(t1.hud_x,t1.hud_y)
								t1.transform = m_t1
								src.vis_contents += t1
								src.tab1 = t1

								var/obj/hud/menus/bodyparts_background/part_tab2/t2 = new
								t2.menu = src
								var/matrix/m_t2 = matrix()
								m_t2.Translate(t2.hud_x,t2.hud_y)
								t2.transform = m_t2
								src.vis_contents += t2
								src.tab2 = t2

								//var/obj/hud/menus/bodyparts_background/part_tab4/t4 = new
								//t4.menu = src
								//var/matrix/m_t4 = matrix()
								//m_t4.Translate(t4.hud_x,t4.hud_y)
								//t4.transform = m_t4
								//src.vis_contents += t4
								//src.tab4 = t4

							//	var/obj/hud/menus/bodyparts_background/part_tab5/t5 = new
							//	t5.menu = src
							//	var/matrix/m_t5 = matrix()
							//	m_t5.Translate(t5.hud_x,t5.hud_y)
							//	t5.transform = m_t5
								//src.vis_contents += t5
							//	src.tab5 = t5

								var/obj/hud/menus/bodyparts_background/tab_bodyparts/holder1 = new
								holder1.menu = src
								src.vis_contents += holder1
								src.default_holder = holder1

								var/obj/hud/menus/bodyparts_background/tab_other/holder2 = new
								holder2.menu = src
								src.other_holder = holder2

								var/obj/hud/menus/bodyparts_background/part_flag/flag = new
								flag.menu = src
								src.symbol_1 = flag

								var/obj/hud/menus/bodyparts_background/scroller_info/scroller1 = new
								scroller1.menu = src
								src.scroller_i = scroller1
								src.vis_contents += scroller1

								var/obj/hud/menus/bodyparts_background/scroller_parts/scroller2 = new
								scroller2.menu = src
								src.scroller_p = scroller2
								src.vis_contents += scroller2

								var/obj/hud/menus/bodyparts_background/scroller_other/scroller3 = new
								scroller3.menu = src
								src.scroller_o = scroller3

								var/obj/hud/menus/bodyparts_background/scrollbar_info/bar1 = new
								bar1.menu = src
								src.bar_i = bar1
								src.vis_contents += bar1

								var/obj/hud/menus/bodyparts_background/scrollbar_parts/bar2 = new
								bar2.menu = src
								src.bar_p = bar2
								src.vis_contents += bar2

								var/obj/hud/menus/bodyparts_background/scrollbar_other/bar3 = new
								bar3.menu = src
								src.bar_o = bar3

								var/obj/hud/menus/bodyparts_background/parts_holder/p_holder = new
								p_holder.menu = src
								src.bodypart_holder = p_holder
								src.vis_contents += p_holder

								var/obj/hud/menus/bodyparts_background/parts_info/i_holder = new
								i_holder.menu = src
								src.info_holder = i_holder
								src.vis_contents += i_holder

								var/obj/hud/menus/bodyparts_background/part_overlays/over = new
								over.menu = src
								src.overs = over
								//i_holder.vis_contents += over

								var/obj/hud/menus/bodyparts_background/part_hp_bar/bar_hp = new
								bar_hp.menu = src
								src.hp_bar = bar_hp
								var/matrix/m0 = matrix()
								m0.Scale(50,1)
								m0.Translate(bar_hp.hud_x+25,bar_hp.hud_y)
								bar_hp.transform = m0

								var/obj/hud/menus/bodyparts_background/part_xp_bar/bar_xp = new
								bar_xp.menu = src
								src.xp_bar = bar_xp
								var/matrix/m = matrix()
								m.Scale(50,1)
								m.Translate(bar_xp.hud_x+25,bar_xp.hud_y)
								bar_xp.transform = m

								var/obj/hud/menus/bodyparts_background/part_tab_txt/txt_tab = new
								var/matrix/ms = matrix()
								ms.Translate(txt_tab.hud_x,txt_tab.hud_y)
								txt_tab.transform = ms
								txt_tab.menu = src
								txt_tab.maptext = "[css_outline]<font size = 1><center>Bodyparts"
								src.vis_contents += txt_tab
								src.txt_tab = txt_tab

								var/obj/hud/menus/bodyparts_background/part_requirements/txt_req = new
								var/matrix/mr = matrix()
								mr.Translate(txt_req.hud_x,txt_req.hud_y)
								txt_req.transform = mr
								txt_req.menu = src
								txt_req.maptext = "[css_outline]<font size = 1><center>Level Requirements"
								src.txt_requirements = txt_req
								holder1.vis_contents += txt_req
								holder2.vis_contents += txt_req

								var/obj/hud/menus/bodyparts_background/part_title/p_title = new
								var/matrix/mt = matrix()
								mt.Translate(p_title.hud_x,p_title.hud_y)
								p_title.transform = mt
								p_title.menu = src
								p_title.maptext = "[css_outline]<font size = 1><center><u>Body, Mind, & Spirit Ascension"
								src.vis_contents += p_title

								var/obj/hud/menus/bodyparts_background/part_icon/p_icon = new
								var/matrix/m1 = matrix()
								m1.Translate(p_icon.hud_x,p_icon.hud_y)
								p_icon.transform = m1
								p_icon.menu = src
								src.bodypart_icon = p_icon
								//i_holder.vis_contents += p_icon

								var/obj/hud/menus/bodyparts_background/part_name/p_name = new
								var/matrix/m2 = matrix()
								m2.Translate(p_name.hud_x,p_name.hud_y)
								p_name.transform = m2
								p_name.menu = src
								p_name.maptext = "[css_outline]<font size = 1><left>Name: Bodypart"
								src.part_name = p_name
								//i_holder.vis_contents += p_name

								var/obj/hud/menus/bodyparts_background/part_status/p_status = new
								var/matrix/m3 = matrix()
								m3.Translate(p_status.hud_x,p_status.hud_y)
								p_status.transform = m3
								p_status.menu = src
								p_status.maptext = "[css_outline]<font size = 1><left>Status:"
								src.part_status = p_status
								//i_holder.vis_contents += p_status

								var/obj/hud/menus/bodyparts_background/part_txt_req/p_req = new
								var/matrix/m_r = matrix()
								m_r.Translate(p_req.hud_x,p_req.hud_y)
								p_req.transform = m_r
								p_req.menu = src
								src.part_req = p_req
								holder2.vis_contents += p_req

								var/obj/hud/menus/bodyparts_background/part_health/p_health = new
								var/matrix/m4 = matrix()
								m4.Translate(p_health.hud_x,p_health.hud_y)
								p_health.transform = m4
								p_health.menu = src
								p_health.maptext = "[css_outline]<font size = 1><left>Health:"
								src.part_health = p_health
								//i_holder.vis_contents += p_health

								var/obj/hud/menus/bodyparts_background/part_level/p_level = new
								var/matrix/m5 = matrix()
								m5.Translate(p_level.hud_x,p_level.hud_y)
								p_level.transform = m5
								p_level.menu = src
								p_level.maptext = "[css_outline]<font size = 1><left>Level: 0/1000"
								src.part_level = p_level
								//i_holder.vis_contents += p_level

								var/obj/hud/menus/bodyparts_background/part_training/p_training = new
								var/matrix/m6 = matrix()
								m6.Translate(p_training.hud_x,p_training.hud_y)
								p_training.transform = m6
								p_training.menu = src
								p_training.maptext = "[css_outline]<font size = 1><left>Training:"
								src.part_training = p_training
								//i_holder.vis_contents += p_training

								var/obj/hud/menus/bodyparts_background/part_cyber/p_cyber = new
								var/matrix/m7 = matrix()
								m7.Translate(p_cyber.hud_x,p_cyber.hud_y)
								p_cyber.transform = m7
								p_cyber.menu = src
								p_cyber.maptext = "[css_outline]<font size = 1><left>Cybernetic Slots: 0/0"
								src.part_cyber = p_cyber
								//i_holder.vis_contents += p_cyber

								var/obj/hud/menus/bodyparts_background/part_stats_trained/p_trained = new
								var/matrix/m10 = matrix()
								m10.Translate(p_trained.hud_x,p_trained.hud_y)
								p_trained.transform = m10
								p_trained.menu = src
								p_trained.maptext = "[css_outline]<font size = 1><text align=left valign=top>Current Stats"
								src.part_stats_trained = p_trained
								//i_holder.vis_contents += p_trained

								var/obj/hud/menus/bodyparts_background/psiforge_button/psi = new
								var/matrix/p = matrix()
								p.Translate(psi.hud_x,psi.hud_y)
								psi.transform = p
								psi.menu = src
								psi.maptext = "[css_outline]<font size = 1><center>Tone"
								src.psiforge = psi
								//i_holder.vis_contents += psi

								var/obj/hud/menus/bodyparts_background/remove_button/remove = new
								var/matrix/r = matrix()
								r.Translate(remove.hud_x,remove.hud_y)
								remove.transform = r
								remove.menu = src
								remove.maptext = "[css_outline]<font size = 1><center>Remove"
								src.button_remove = remove
								//i_holder.vis_contents += remove

								var/obj/hud/menus/bodyparts_background/part_stats/p_stats = new
								var/matrix/m9 = matrix()
								m9.Translate(p_stats.hud_x,p_stats.hud_y)
								p_stats.transform = m9
								p_stats.menu = src
								src.part_stats = p_stats
								//i_holder.vis_contents += p_stats

								var/obj/hud/menus/bodyparts_background/bodypart/bodypart1 = new
								bodypart1.icon_state = "1"
								bodypart1.menu = src
							//	bodypart1.bodypart_type = "head"
								bodypart1.bodypart_type = "leftarm"
								src.vis_contents += bodypart1
								src.body += bodypart1
								bodypart1.name = "Left Arm"
								bodypart1.layer = 33
								bodypart1.screen_loc = "1,1"
								bodypart1.filters += filter(type="outline",size=1, color=rgb(255,255,255))

								var/obj/hud/menus/bodyparts_background/bodypart/bodypart2 = new
								bodypart2.icon_state = "2"
								bodypart2.menu = src
								// torso
								bodypart2.bodypart_type = "rightarm"
								src.vis_contents += bodypart2
								src.body += bodypart2
								bodypart2.name = "Right Arm"
								src.area_selected = bodypart2
								bodypart2.layer = 33
								bodypart2.screen_loc = "2,1"
								bodypart2.filters += filter(type="outline",size=1, color=rgb(255,255,255))
							//	spawn(30)
								//	if(src && bodypart2 && ismob(src.loc))
										//bodypart2.display_selected_part(bodypart2.bodypart_type,src.loc)

								var/obj/hud/menus/bodyparts_background/bodypart/bodypart3 = new
								bodypart3.icon_state = "3"
								bodypart3.menu = src
								//leftarm
								bodypart3.bodypart_type = "leftleg"
								src.vis_contents += bodypart3
								src.body += bodypart3
								bodypart3.screen_loc = "1,2"
								bodypart3.name = "Left Leg"

								var/obj/hud/menus/bodyparts_background/bodypart/bodypart4 = new
								bodypart4.icon_state = "4"
								bodypart4.menu = src
								//rightarm
								bodypart4.bodypart_type = "rightleg"
								src.vis_contents += bodypart4
								src.body += bodypart4
								bodypart1.screen_loc = "2,2"
								bodypart4.name = "Right Leg"
				psiforge_button
					icon = 'psiforge_button.dmi'
					icon_state = "button"
					layer = 32
					plane = 22
					maptext_width = 64
					maptext_height = 16
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					hud_x = 311
					hud_y = 143
					maptext_x = -5
					maptext_y = 4
					box_x_scale = 128
					box_y_scale = 128
					box_x_shift = 64
					box_y_shift = 64
					New()
						src.info = "[css_outline]<font size = 1><text align=left valign=top><u>Toning</u>\n\nClicking this button starts the Toning process on the associated bodypart. Then whenever you gain xp toward your core stats, a portion of that xp converts into xp for this bodypart."
					MouseMove(location,control,params)
						..()
						usr.info_box(src,"[src.info]",params)
					MouseEntered()
						src.icon_state = "button hover"
						spawn(6)
							if(usr && usr.mouse_saved_loc == src)
								if(usr.info_box1)
									usr.client.screen += usr.info_box1
									usr.client.screen += usr.info_box2
									usr.client.screen += usr.info_box3
					MouseExited()
						src.icon_state = "button"
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					Click()
						var/obj/body_related/p = null
						if(usr.part_focus)
							p = usr.part_focus
							p.underlays = null
							if(bodypart_underlay) bodypart_underlay.icon_state = "menu"
							p.underlays += bodypart_underlay
							p.filters = null
						usr.part_train()
						if(usr.part_selected == usr.part_focus)
							src.maptext = "[css_outline]<font size = 1><center>Cancel"
							if(usr.part_selected)
								usr.part_selected.underlays = null
								if(bodypart_underlay) bodypart_underlay.icon_state = "menu focus"
								usr.part_selected.underlays += bodypart_underlay

								usr.part_selected.filters = null
								//usr.part_selected.filters += filter(type="outline",size=1, color=rgb(204,236,255))
								usr.part_selected.filters += filter(type="drop_shadow", x=0, y=0, size=0, offset=0, color=rgb(102,0,204))

								//animate(usr.part_selected.filters[1], size = 4,offset = 2, time = 15, loop = -1)
								//animate(size = 0,offset = 0, time = 15)

								//var/obj/hud/menus/bodyparts_background/h = src.menu
								//h.psiforge_xp.layer = 34
						else
							if(p && p.cybernetic) src.maptext = "[css_outline]<font size = 1><center>Upgrade"
							else if(usr.part_selected && usr.part_selected.cybernetic) src.maptext = "[css_outline]<font size = 1><center>Upgrade"
							else src.maptext = "[css_outline]<font size = 1><center>Tone"
							if(usr.part_selected)
								usr.part_selected.filters = null
					/*
					New()
						src.filters += filter(type="outline",size=1, color=rgb(204,236,255))
						src.filters += filter(type="drop_shadow", x=0, y=0, size=0, offset=0, color=rgb(102,0,204))

						animate(src.filters[2], size = 4,offset = 2, time = 15, loop = -1)
						animate(size = 0,offset = 0, time = 15)
					*/
				remove_button
					icon = 'psiforge_button.dmi'
					icon_state = "button"
					layer = 32
					plane = 22
					maptext_width = 64
					maptext_height = 16
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					hud_x = 253
					hud_y = 143
					maptext_x = -5
					maptext_y = 4
					box_x_scale = 128
					box_y_scale = 128
					box_x_shift = 64
					box_y_shift = 64
					var/txt = ""
					New()
						src.txt = "[css_outline]<font size = 1><text align=left valign=top><u>Removing Cybernetics</u>\n\nRemoving cybernetics places the part back into your inventory, but harms the bodypart it was attached to. The cyberware will keep its level, so you can place it back into another bodypart or person later."
					MouseMove(location,control,params)
						usr.info_box(src,"[src.txt]",params)
					MouseEntered()
						src.icon_state = "button hover"
						spawn(6)
							if(usr && usr.mouse_saved_loc == src)
								if(usr.info_box1)
									var/L = usr.client.MeasureText(src.txt,width=192)
									var/x_pos = findtext(L, "x")
									L = text2num(copytext(L, 1, x_pos))
									src.box_x_scale = L + 6
									src.box_x_shift = 2 + round(src.box_x_scale/2)
									src.box_y_scale = round(src.box_x_scale/2)
									src.box_y_shift = round(box_y_scale/2)
									usr.client.screen += usr.info_box1
									usr.client.screen += usr.info_box2
									usr.client.screen += usr.info_box3
					MouseExited()
						src.icon_state = "button"
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					Click()
						var/obj/body_related/p = usr.part_selected
						if(p && p.cybernetic) p.select_part(usr,"right")
				scrollbar_other
					icon = 'new_hud_body4.dmi'
					icon_state = "bar other"
					layer = 32
					plane = 22
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/bodyparts_background/s = src.menu
						var/obj/sc = s.scroller_o
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-152)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/ratio = -1 + ((-152 + result) / -152)
						ratio = clamp(ratio,0,1)
						var/scroll_y = s.max_scroll_reqs*ratio//round(400*ratio)

						for(var/obj/txt in s.other_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2
					Click(location,control,params)
						var/obj/hud/menus/bodyparts_background/s = src.menu
						var/obj/sc = s.scroller_o
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/result = -333 + ((usr.mouse_y_true-s.body_background_y)-54)
						result = clamp(result,0,-152)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/ratio = -1 + ((-152 + result) / -152)
						ratio = clamp(ratio,0,1)
						var/scroll_y = s.max_scroll_reqs*ratio//round(400*ratio)

						for(var/obj/txt in s.other_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2
					New()
						return
					MouseDrag()
						return
				scrollbar_parts
					icon = 'new_hud_body4.dmi'
					icon_state = "bar parts"
					layer = 32
					plane = 22
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/bodyparts_background/s = src.menu
						var/obj/sc = s.scroller_p
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-169)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/ratio = -1 + ((-169 + result) / -169)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(s.max_scroll_parts*ratio)//760*ratio)

						for(var/obj/txt in s.bodypart_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2
						if(s.area_selected)
							s.area_selected.scroller_transform = m
							s.area_selected.scroller_translated = result
							s.area_selected.parts_transform = scroll_y
					Click(location,control,params)
						var/obj/hud/menus/bodyparts_background/s = src.menu
						var/obj/sc = s.scroller_p
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/result = -350 + ((usr.mouse_y_true-s.body_background_y)-54)
						result = clamp(result,0,-169)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/ratio = -1 + ((-169 + result) / -169)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(s.max_scroll_parts*ratio)//760*ratio)

						for(var/obj/txt in s.bodypart_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2
						if(s.area_selected)
							s.area_selected.scroller_transform = m
							s.area_selected.scroller_translated = result
							s.area_selected.parts_transform = scroll_y
					New()
						return
					MouseDrag()
						return
				scrollbar_info
					icon = 'new_hud_body4.dmi'
					icon_state = "bar info"
					layer = 32
					plane = 22
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/bodyparts_background/s = src.menu
						var/obj/sc = s.scroller_i
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-169)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/ratio = -1 + ((-169 + result) / -169)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(200*ratio)

						for(var/obj/txt in s.info_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.translated_y = scroll_y
							txt.transform = m2
						usr.body_exp_hp()
					Click(location,control,params)
						var/obj/hud/menus/bodyparts_background/s = src.menu
						var/obj/sc = s.scroller_i
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/result = -146 + ((usr.mouse_y_true-s.body_background_y)-54)
						result = clamp(result,0,-169)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/ratio = -1 + ((-169 + result) / -169)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(200*ratio)

						for(var/obj/txt in s.info_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2
					New()
						return
					MouseDrag()
						return
				scroller_info
					icon = 'new_hud_body4.dmi'
					icon_state = "scroller info"
					layer = 33
					plane = 22
					MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
						var/obj/hud/menus/bodyparts_background/s = src.menu

						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/result = -146 + ((usr.mouse_y_true-s.body_background_y)-54)
						result = clamp(result,0,-169)
						var/matrix/m = matrix()
						m.Translate(0,result)
						src.transform = m
						src.translated_y = result

						var/ratio = -1 + ((-169 + result) / -169)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(200*ratio)

						for(var/obj/txt in s.info_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.translated_y = scroll_y
							txt.transform = m2
						usr.body_exp_hp()
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/bodyparts_background/s = src.menu
						var/obj/sc = s.scroller_i

						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-169)

						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result
						var/ratio = -1 + ((-169 + result) / -169)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(200*ratio)

						for(var/obj/txt in s.info_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2
				scroller_parts
					icon = 'new_hud_body4.dmi'
					icon_state = "scroller parts"
					layer = 33
					plane = 22
					MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
						var/obj/hud/menus/bodyparts_background/s = src.menu

						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/result = -350 + ((usr.mouse_y_true-s.body_background_y)-54)
						result = clamp(result,0,-169)
						var/matrix/m = matrix()
						m.Translate(0,result)
						src.transform = m
						src.translated_y = result

						var/ratio = -1 + ((-169 + result) / -169)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(s.max_scroll_parts*ratio)//760*ratio)

						for(var/obj/txt in s.bodypart_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2
							txt.translated_y = scroll_y
						if(s.area_selected)
							s.area_selected.scroller_transform = m
							s.area_selected.scroller_translated = result
							s.area_selected.parts_transform = scroll_y
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/bodyparts_background/s = src.menu
						var/obj/sc = s.scroller_p

						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-169)

						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result
						var/ratio = -1 + ((-169 + result) / -169)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(s.max_scroll_parts*ratio)//760*ratio)

						for(var/obj/txt in s.bodypart_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2
							txt.translated_y = scroll_y
						if(s.area_selected) s.area_selected.saved_y = scroll_y
				scroller_other
					icon = 'new_hud_body4.dmi'
					icon_state = "scroller other"
					layer = 33
					plane = 22
					MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
						var/obj/hud/menus/bodyparts_background/s = src.menu

						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/result = -333 + ((usr.mouse_y_true-s.body_background_y)-54)
						result = clamp(result,0,-152)
						var/matrix/m = matrix()
						m.Translate(0,result)
						src.transform = m
						src.translated_y = result

						var/ratio = -1 + ((-152 + result) / -152)
						ratio = clamp(ratio,0,1)
						var/scroll_y = s.max_scroll_reqs*ratio//round(400*ratio)

						for(var/obj/txt in s.other_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2
							txt.translated_y = scroll_y
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/bodyparts_background/s = src.menu
						var/obj/sc = s.scroller_o

						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-152)

						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result
						var/ratio = -1 + ((-152 + result) / -152)
						ratio = clamp(ratio,0,1)
						var/scroll_y = s.max_scroll_reqs*ratio//round(400*ratio)

						for(var/obj/txt in s.other_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2
							txt.translated_y = scroll_y
				part_stats
					icon = null
					layer = 32
					plane = 22
					maptext_width = 384
					maptext_height = 640
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					hud_x = 16
					hud_y = -500
					New()
						//src.maptext = "[css_outline]<font size = 1><text align=left valign=top>Here is the information about the bodypart, not sure if this will be the lore part or the actual info about what you gain from lvling that part. Should be enough room to add all of the pros and cons of training a stat for example?"
						src.maptext = "[css_outline]<font size = 1><text align=left valign=top>Stat info here\nMore stat info here\nAnd more here, ect?"
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
				part_txt_req
					icon = null
					layer = 32
					plane = 22
					maptext_width = 160
					maptext_height = 640
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					hud_x = 13
					hud_y = -260
					New()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
				part_txt
					icon = null
					layer = 32
					plane = 22
					maptext_width = 432
					maptext_height = 640
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					hud_x = 16
					hud_y = -562
					New()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
				part_training
					icon = null
					layer = 32
					plane = 22
					maptext_width = 100
					maptext_height = 16
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					hud_x = 268
					hud_y = 176
					maptext_y = -8
					maptext_x = 2
					New()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
				part_cyber
					icon = null
					layer = 32
					plane = 22
					maptext_width = 128
					maptext_height = 16
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					hud_x = 268
					hud_y = 176
					maptext_y = 22
					maptext_x = 2
					New()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
				part_infusions
					icon = null
					layer = 32
					plane = 22
					maptext_width = 128
					maptext_height = 640
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					hud_x = 240
					hud_y = -507
					maptext_y = 7
					maptext_x = 2
					New()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
				part_stats_trained
					icon = null
					layer = 32
					plane = 22
					maptext_width = 128
					maptext_height = 640
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					hud_x = 240
					hud_y = -507
					maptext_y = 7
					maptext_x = 2
					New()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
				part_cybernetics
					icon = null
					layer = 32
					plane = 22
					maptext_width = 128
					maptext_height = 128
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					hud_x = 240
					hud_y = -450
					New()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
				part_level
					icon = null
					layer = 32
					plane = 22
					maptext_width = 128
					maptext_height = 16
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					hud_x = 268
					hud_y = 176
					maptext_y = 7
					maptext_x = 2
					New()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
				part_health
					icon = null
					layer = 32
					plane = 22
					maptext_width = 128
					maptext_height = 16
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					hud_x = 50
					hud_y = 176
					maptext_y = -8
					maptext_x = 2
					New()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
				part_status
					icon = null
					layer = 32
					plane = 22
					maptext_width = 128
					maptext_height = 16
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					hud_x = 50
					hud_y = 176
					maptext_y = 7
					maptext_x = 2
					New()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
				part_name
					icon = null
					layer = 32
					plane = 22
					maptext_width = 232
					maptext_height = 16
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					hud_x = 50
					hud_y = 176
					maptext_y = 22
					maptext_x = 2
					New()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
				part_flag
					icon_state = "milestone symbol"
					layer = 32
					plane = 22
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					New()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
				part_tab1
					icon = 'hud_body_tabs.dmi'
					icon_state = "selected"
					layer = 32
					plane = 22
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					hud_x = 11
					hud_y = 402
					MouseMove(location,control,params)
						..()
						usr.info_box(src,"Toning",params)
					MouseEntered()
						if(src.icon_state != "selected") src.icon_state = "hover"
						if(usr.info_box1)
							usr.client.screen += usr.info_box1
							usr.client.screen += usr.info_box2
							usr.client.screen += usr.info_box3
					MouseExited()
						if(src.icon_state != "selected") src.icon_state = "unselected"
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					New()
						var/obj/o = new
						o.icon = src.icon
						o.icon_state = "psi"
						o.layer = 32
						o.plane = 22
						src.overlays = null
						src.overlays += o
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					Click()
						if(src.menu)
							var/obj/hud/menus/bodyparts_background/b = src.menu

							b.tab1.icon_state = "selected"
							b.tab2.icon_state = "unselected"
							//b.tab3.icon_state = "unselected"
						//	b.tab4.icon_state = "unselected"
						//	b.tab5.icon_state = "unselected"

							b.selected = 1

							b.bodypart_holder.vis_contents = null


							b.vis_contents += b.default_holder
							b.vis_contents -= b.other_holder
							b.vis_contents -= b.bar_o
							b.vis_contents -= b.scroller_o

							usr.part_selected = null
							b.show_parts(usr)

							for(var/obj/hud/menus/bodyparts_background/bodypart/o in b.body)
								b.vis_contents += o
								if(b.area_selected == o) o.display_selected_part(o.bodypart_type,usr)

							b.txt_tab.maptext = "[css_outline]<font size = 1><center>Bodyparts"
							b.txt_requirements.maptext = "[css_outline]<font size = 1><center>Toning Speed: [usr.psiforging_speed]%"
				part_tab2
					icon = 'hud_body_tabs.dmi'
					icon_state = "unselected"
					layer = 32
					plane = 22
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					hud_x = 36
					hud_y = 402
					MouseMove(location,control,params)
						..()
						usr.info_box(src,"Milestones",params)
					MouseEntered()
						if(src.icon_state != "selected") src.icon_state = "hover"
						if(usr.info_box1)
							usr.client.screen += usr.info_box1
							usr.client.screen += usr.info_box2
							usr.client.screen += usr.info_box3
					MouseExited()
						if(src.icon_state != "selected") src.icon_state = "unselected"
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					New()
						var/obj/o = new
						o.icon = src.icon
						o.icon_state = "milestones"
						o.layer = 32
						o.plane = 22
						src.overlays = null
						src.overlays += o
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					Click()
						if(src.menu)
							var/obj/hud/menus/bodyparts_background/b = src.menu

							b.tab1.icon_state = "unselected"
							b.tab2.icon_state = "selected"
						//	b.tab3.icon_state = "unselected"
						//	b.tab4.icon_state = "unselected"
						//	b.tab5.icon_state = "unselected"

							b.selected = 2

							for(var/obj/o in b.body)
								b.vis_contents -= o

							b.vis_contents -= b.default_holder
							b.vis_contents += b.other_holder
							b.vis_contents += b.bar_o
							b.vis_contents += b.scroller_o

							usr.part_selected = null
							b.show_parts(usr)

							b.txt_tab.maptext = "[css_outline]<font size = 1><center>Milestones"
							b.txt_requirements.maptext = "[css_outline]<font size = 1><center>Level Requirements"

							b.bodypart_holder.vis_contents = null

							b.max_scroll_parts = 0

							var/yy = 385
							for(var/obj/body_related/bp in usr.milestones)
								if(bodypart_underlay)
									bp.underlays = null
									bodypart_underlay.icon_state = "menu"
									bp.underlays += bodypart_underlay

								var/matrix/mat = matrix()
								mat.Translate(200,yy)
								bp.transform = mat
								bp.hud_x = 200
								bp.hud_y = yy

								bp.maptext_width = 128
								bp.maptext_height = 16
								bp.maptext_x = 34
								bp.maptext_y = 4
								bp.maptext = "[css_outline]<font size = 1><left><font color = [bp.txt_col]>[bp.info_name]"

								bp.blend_mode = BLEND_INSET_OVERLAY
								bp.appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE

								b.bodypart_holder.vis_contents += bp

								b.max_scroll_parts += 30

								yy -= 34
				/*part_tab3
					icon = 'hud_body_tabs.dmi'
					icon_state = "unselected"
					layer = 32
					plane = 22
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					hud_x = 61
					hud_y = 402
					MouseMove(location,control,params)
						..()
						usr.info_box(src,"Soul Cultivation",params)
					MouseEntered()
						if(src.icon_state != "selected") src.icon_state = "hover"
						if(usr.info_box1)
							usr.client.screen += usr.info_box1
							usr.client.screen += usr.info_box2
							usr.client.screen += usr.info_box3
					MouseExited()
						if(src.icon_state != "selected") src.icon_state = "unselected"
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					New()
						var/obj/o = new
						o.icon = src.icon
						o.icon_state = "soul"
						o.layer = 32
						o.plane = 22
						src.overlays = null
						src.overlays += o
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					Click()
						if(src.menu)
							var/obj/hud/menus/bodyparts_background/b = src.menu

							b.tab1.icon_state = "unselected"
							b.tab2.icon_state = "unselected"
							b.tab3.icon_state = "selected"
							b.tab4.icon_state = "unselected"
						//	b.tab5.icon_state = "unselected"

							b.selected = 3

							for(var/obj/o in b.body)
								b.vis_contents -= o

							b.vis_contents -= b.default_holder
							b.vis_contents += b.other_holder
							b.vis_contents += b.bar_o
							b.vis_contents += b.scroller_o

							usr.part_selected = null
							b.show_parts(usr)

							b.txt_tab.maptext = "[css_outline]<font size = 1><center>Soul"
							b.txt_requirements.maptext = "[css_outline]<font size = 1><center>Level Requirements"

							b.bodypart_holder.vis_contents = null
							b.max_scroll_parts = 0

							var/yy = 385
							for(var/obj/body_related/bp in usr.soul)
								if(bodypart_underlay)
									bp.underlays = null
									bodypart_underlay.icon_state = "menu"
									bp.underlays += bodypart_underlay

								var/matrix/mat = matrix()
								mat.Translate(200,yy)
								bp.transform = mat
								bp.hud_x = 200
								bp.hud_y = yy

								bp.maptext_width = 128
								bp.maptext_height = 16
								bp.maptext_x = 34
								bp.maptext_y = 4
								bp.maptext = "[css_outline]<font size = 1><left><font color = [bp.txt_col]>[bp.info_name]"

								bp.blend_mode = BLEND_INSET_OVERLAY
								bp.appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE

								b.bodypart_holder.vis_contents += bp

								b.max_scroll_parts += 30

								yy -= 34
						*/
				part_tab4
					icon = 'hud_body_tabs.dmi'
					icon_state = "unselected"
					layer = 32
					plane = 22
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					hud_x = 86
					hud_y = 402
					MouseMove(location,control,params)
						..()
						usr.info_box(src,"Ascensions",params)
					MouseEntered()
						if(src.icon_state != "selected") src.icon_state = "hover"
						if(usr.info_box1)
							usr.client.screen += usr.info_box1
							usr.client.screen += usr.info_box2
							usr.client.screen += usr.info_box3
					MouseExited()
						if(src.icon_state != "selected") src.icon_state = "unselected"
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					New()
						var/obj/o = new
						o.icon = src.icon
						o.icon_state = "med"
						o.layer = 32
						o.plane = 22
						src.overlays = null
						src.overlays += o
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					Click()
						if(src.menu)
							var/obj/hud/menus/bodyparts_background/b = src.menu

							b.tab1.icon_state = "unselected"
							b.tab2.icon_state = "unselected"
						//	b.tab3.icon_state = "unselected"
							//b.tab4.icon_state = "selected"
						//	b.tab5.icon_state = "unselected"

							b.selected = 4

							for(var/obj/o in b.body)
								b.vis_contents -= o

							b.vis_contents -= b.default_holder
							b.vis_contents += b.other_holder
							b.vis_contents += b.bar_o
							b.vis_contents += b.scroller_o

							usr.part_selected = null
							b.show_parts(usr)

							b.txt_tab.maptext = "[css_outline]<font size = 1><center>Ascensions"
							b.txt_requirements.maptext = "[css_outline]<font size = 1><center>Requirements"

							b.bodypart_holder.vis_contents = null
							b.max_scroll_parts = 0

							var/yy = 385
							for(var/obj/body_related/bp in usr.ascensions)
								if(bodypart_underlay)
									bp.underlays = null
									bodypart_underlay.icon_state = "menu"
									bp.underlays += bodypart_underlay

								var/matrix/mat = matrix()
								mat.Translate(200,yy)
								bp.transform = mat
								bp.hud_x = 200
								bp.hud_y = yy

								bp.maptext_width = 128
								bp.maptext_height = 16
								bp.maptext_x = 34
								bp.maptext_y = 4
								bp.maptext = "[css_outline]<font size = 1><left><font color = [bp.txt_col]>[bp.info_name]"

								bp.blend_mode = BLEND_INSET_OVERLAY
								bp.appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE

								b.bodypart_holder.vis_contents += bp

								b.max_scroll_parts += 30

								yy -= 34
				part_tab5
					icon = 'hud_body_tabs.dmi'
					icon_state = "unselected"
					layer = 32
					plane = 22
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					hud_x = 111
					hud_y = 402
					MouseMove(location,control,params)
						..()
						usr.info_box(src,"Chakras",params)
					MouseEntered()
						if(src.icon_state != "selected") src.icon_state = "hover"
						if(usr.info_box1)
							usr.client.screen += usr.info_box1
							usr.client.screen += usr.info_box2
							usr.client.screen += usr.info_box3
					MouseExited()
						if(src.icon_state != "selected") src.icon_state = "unselected"
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					New()
						var/obj/o = new
						o.icon = src.icon
						o.icon_state = "chakras"
						o.layer = 32
						o.plane = 22
						src.overlays = null
						src.overlays += o
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					Click()
						if(src.menu)
							var/obj/hud/menus/bodyparts_background/b = src.menu

							b.tab1.icon_state = "unselected"
							b.tab2.icon_state = "unselected"
						//	b.tab3.icon_state = "unselected"
						//	b.tab4.icon_state = "unselected"
						//	b.tab5.icon_state = "selected"

							b.selected = 5

							for(var/obj/o in b.body)
								b.vis_contents -= o

							b.vis_contents -= b.default_holder
							b.vis_contents += b.other_holder
							b.vis_contents += b.bar_o
							b.vis_contents += b.scroller_o

							usr.part_selected = null
							b.show_parts(usr)

							b.txt_tab.maptext = "[css_outline]<font size = 1><center>Chakras"
							b.txt_requirements.maptext = "[css_outline]<font size = 1><center>Requirements"

							b.bodypart_holder.vis_contents = null
							b.max_scroll_parts = 0

							var/yy = 385
							for(var/obj/body_related/bp in usr.chakras)
								if(bodypart_underlay)
									bp.underlays = null
									bodypart_underlay.icon_state = "menu"
									bp.underlays += bodypart_underlay

								var/matrix/mat = matrix()
								mat.Translate(200,yy)
								bp.transform = mat
								bp.hud_x = 200
								bp.hud_y = yy

								bp.maptext_width = 128
								bp.maptext_height = 16
								bp.maptext_x = 34
								bp.maptext_y = 4
								bp.maptext = "[css_outline]<font size = 1><left><font color = [bp.txt_col]>[bp.info_name]"

								bp.blend_mode = BLEND_INSET_OVERLAY
								bp.appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE

								b.bodypart_holder.vis_contents += bp

								b.max_scroll_parts += 30

								yy -= 34
				part_tab_txt
					icon = null
					layer = 32
					plane = 22
					maptext_width = 128
					maptext_height = 16
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					hud_x = 99
					hud_y = 406
					New()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
				part_title
					icon = null
					layer = 32
					plane = 22
					maptext_width = 128
					maptext_height = 16
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					hud_x = 146
					hud_y = 424
					New()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
				part_requirements
					icon = null
					layer = 32
					plane = 22
					maptext_width = 128
					maptext_height = 16
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					hud_x = 37
					hud_y = 386
					New()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
				part_psi_xp
					icon = 'bodypart_xp.dmi'
					layer = 34
					plane = 22
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE | RESET_ALPHA
					hud_x = 214
					hud_y = 400
					New()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
				part_hp_bar
					icon = 'new_hud_part_hp.dmi'
					layer = 33
					plane = 22
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					hud_x = 90
					hud_y = 170
					New()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
				part_xp_bar
					icon = 'new_hud_part_xp.dmi'
					layer = 33
					plane = 22
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					hud_x = 315
					hud_y = 170
					New()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
				part_overlays
					icon = 'new_hud_body4.dmi'
					icon_state = "overlays"
					layer = 34
					plane = 22
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					New()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
				part_icon
					icon = 'bodybits.dmi'
					icon_state = "menu"
					layer = 33
					plane = 22
					maptext_width = 128
					maptext_height = 16
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					hud_x = 16
					hud_y = 174
					New()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
				tab_bodyparts
					icon = 'new_hud_body4.dmi'
					icon_state = "holder"
					layer = 32
					plane = 22
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					New()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
				tab_other
					icon = 'new_hud_body4.dmi'
					icon_state = "holder other"
					layer = 32
					plane = 22
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					New()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/bodyparts_background/s = src.menu
						var/obj/sc = s.scroller_o
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-152)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/ratio = -1 + ((-152 + result) / -152)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(s.max_scroll_reqs*ratio)//760*ratio)

						for(var/obj/txt in s.other_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2
				parts_holder
					icon = 'new_hud_body4.dmi'
					icon_state = "parts holder"
					layer = 32
					plane = 22
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/bodyparts_background/s = src.menu
						var/obj/sc = s.scroller_p

						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-169)

						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result
						var/ratio = -1 + ((-169 + result) / -169)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(s.max_scroll_parts*ratio)//760*ratio)

						for(var/obj/txt in s.bodypart_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2
							txt.translated_y = result
						if(s.area_selected)
							s.area_selected.scroller_transform = m
							s.area_selected.scroller_translated = result
							s.area_selected.parts_transform = scroll_y
						return
					New()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
				parts_info
					icon = 'new_hud_body4.dmi'
					icon_state = "part info"
					layer = 32
					plane = 22
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/bodyparts_background/s = src.menu
						var/obj/sc = s.scroller_i
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-169)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/ratio = -1 + ((-169 + result) / -169)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(200*ratio)

						for(var/obj/txt in s.info_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.translated_y = scroll_y
							txt.transform = m2
						usr.body_exp_hp()
						return
					New()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
				bodypart
					icon = 'limbStats.dmi'
					icon_state = "1"
					layer = 32
					plane = 22
					screen_loc = "TOP+1:5 , RIGHT+8:10"

					var/scroller_transform //The y location of where the scrollbar was saved, so when switching between different bodyparts it doesn't just reset for each one.
					var/scroller_translated = 0
					var/parts_transform //The transform of the vis_contents inside parts_holder
					/*
					bodyparts list indexes are
					1 = head
					2 = torso
					3 = left arm
					4 = right arm
					5 = right leg
					6 = left leg
					*/
					MouseEntered(location,control,params)
						if(src.menu.area_selected != src)
							src.layer = 33
							src.filters += filter(type="outline",size=1, color=rgb(255,255,255))
						if(usr.info_box1)
							usr.client.screen += usr.info_box1
							usr.client.screen += usr.info_box2
							usr.client.screen += usr.info_box3
							usr.info_box(src,src.name,params)
					MouseExited(location,control,params)
						if(src.menu.area_selected != src)
							src.layer = 32
							src.filters -= filter(type="outline",size=1, color=rgb(255,255,255))
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseMove(location,control,params)
						..()
						usr.info_box(src,src.name,params)
					New()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					Click()
						src.layer = 32
						var/obj/hud/menus/bodyparts_background/h = src.menu
						h.area_selected = src
						for(var/obj/hud/menus/bodyparts_background/bodypart/p in h.vis_contents)
							//if(p != src)
							p.filters -= filter(type="outline",size=1, color=rgb(255,255,255))
							p.layer = 32

						h.bodypart_holder.vis_contents = null
						h.scroller_p.translated_y = src.scroller_translated
						h.scroller_p.transform = src.scroller_transform
						h.max_scroll_parts = 0

						//src.display_selected_part(src.bodypart_type,usr)
					proc
						display_selected_part(var/T,var/mob/m)
							var/obj/hud/menus/bodyparts_background/h = src.menu
							switch(T)
								if("head")
									var/yy = 385
									for(var/obj/body_related/b in m.bodyparts[1])
										if(bodypart_underlay)
											b.underlays = null
											bodypart_underlay.icon_state = "menu"
											b.underlays += bodypart_underlay
										if(b.cybernetics_created == 0)
											if(b.cybernetics == null)
												b.cybernetics = list()
												b.cybernetics.len = b.cybernetics_max
											var/N = b.cybernetics_max
											var/xx = 218+(14*N)
											while(N)
												var/obj/hud/buttons/cybernetic_slot/cs = new
												cs.loc = b
												cs.slot = N
												var/matrix/mat = matrix()
												mat.Translate(xx,yy+17)
												cs.transform = mat
												cs.hud_x = xx
												cs.hud_y = yy+17
												h.bodypart_holder.vis_contents += cs
												N -= 1
												xx -= 14
												//sleep(0.2)
											b.cybernetics_created = 1
										else
											for(var/obj/hud/buttons/cybernetic_slot/cs in b)
												h.bodypart_holder.vis_contents += cs

										b.hud_x = 200
										b.hud_y = yy

										b.maptext_width = 176
										b.maptext_height = 16
										b.maptext_x = 32
										b.maptext_y = 4
										b.maptext = "[css_outline]<font size = 1><left><font color = [b.txt_col]>[b.info_name]"

										b.blend_mode = BLEND_INSET_OVERLAY
										b.appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE

										h.bodypart_holder.vis_contents += b

										h.max_scroll_parts += 30

										yy -= 34

									//Next display the Meridians inside a limb
									for(var/obj/body_related/b in m.meridians)
										if(b.inside == m.bodyparts[1])
											if(bodypart_underlay)
												b.underlays = null
												bodypart_underlay.icon_state = "menu"
												b.underlays += bodypart_underlay
											b.hud_x = 200
											b.hud_y = yy
											b.maptext_width = 176
											b.maptext_height = 16
											b.maptext_x = 32
											b.maptext_y = 4
											b.maptext = "[css_outline]<font size = 1><left><font color = [b.txt_col]>[b.info_name]"
											b.blend_mode = BLEND_INSET_OVERLAY
											b.appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
											h.bodypart_holder.vis_contents += b
											yy -= 34
									m.body_exp_hp()
								if("torso")
									var/yy = 385
									for(var/obj/body_related/b in m.bodyparts[2])

										if(bodypart_underlay)
											b.underlays = null
											bodypart_underlay.icon_state = "menu"
											b.underlays += bodypart_underlay
										if(b.cybernetics_created == 0)
											if(b.cybernetics == null)
												b.cybernetics = list()
												b.cybernetics.len = b.cybernetics_max
											var/N = b.cybernetics_max
											var/xx = 218+(14*N)
											while(N)
												var/obj/hud/buttons/cybernetic_slot/cs = new
												cs.loc = b
												cs.slot = N
												var/matrix/mat = matrix()
												mat.Translate(xx,yy+17)
												cs.transform = mat
												cs.hud_x = xx
												cs.hud_y = yy+17
												h.bodypart_holder.vis_contents += cs
												N -= 1
												xx -= 14
												//sleep(0.2)
											b.cybernetics_created = 1
										else
											for(var/obj/hud/buttons/cybernetic_slot/cs in b)
												h.bodypart_holder.vis_contents += cs

										b.hud_x = 200
										b.hud_y = yy

										b.maptext_width = 176
										b.maptext_height = 16
										b.maptext_x = 32
										b.maptext_y = 4
										b.maptext = "[css_outline]<font size = 1><left><font color = [b.txt_col]>[b.info_name]"

										b.blend_mode = BLEND_INSET_OVERLAY
										b.appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE

										h.bodypart_holder.vis_contents += b

										h.max_scroll_parts += 30

										yy -= 34
									//Next display the Meridians inside a limb
									for(var/obj/body_related/b in m.meridians)
										if(b.inside == m.bodyparts[2])
											if(bodypart_underlay)
												b.underlays = null
												bodypart_underlay.icon_state = "menu"
												b.underlays += bodypart_underlay
											b.hud_x = 200
											b.hud_y = yy
											b.maptext_width = 176
											b.maptext_height = 16
											b.maptext_x = 32
											b.maptext_y = 4
											b.maptext = "[css_outline]<font size = 1><left><font color = [b.txt_col]>[b.info_name]"
											b.blend_mode = BLEND_INSET_OVERLAY
											b.appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
											h.bodypart_holder.vis_contents += b
											yy -= 34
									m.body_exp_hp()
								if("Left Arm","left arm")
									var/yy = 385
									for(var/obj/body_related/b in m.bodyparts[3])

										if(bodypart_underlay)
											b.underlays = null
											bodypart_underlay.icon_state = "menu"
											b.underlays += bodypart_underlay
										if(b.cybernetics_created == 0)
											if(b.cybernetics == null)
												b.cybernetics = list()
												b.cybernetics.len = b.cybernetics_max
											var/N = b.cybernetics_max
											var/xx = 218+(14*N)
											while(N)
												var/obj/hud/buttons/cybernetic_slot/cs = new
												cs.loc = b
												cs.slot = N
												var/matrix/mat = matrix()
												mat.Translate(xx,yy+17)
												cs.transform = mat
												cs.hud_x = xx
												cs.hud_y = yy+17
												h.bodypart_holder.vis_contents += cs
												N -= 1
												xx -= 14
											b.cybernetics_created = 1
										else
											for(var/obj/hud/buttons/cybernetic_slot/cs in b)
												h.bodypart_holder.vis_contents += cs

										b.hud_x = 200
										b.hud_y = yy

										b.maptext_width = 176
										b.maptext_height = 16
										b.maptext_x = 32
										b.maptext_y = 4
										b.maptext = "[css_outline]<font size = 1><left><font color = [b.txt_col]>[b.info_name]"

										b.blend_mode = BLEND_INSET_OVERLAY
										b.appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE

										h.bodypart_holder.vis_contents += b

										h.max_scroll_parts += 30

										yy -= 34
									//Next display the Meridians inside a limb
									for(var/obj/body_related/b in m.meridians)
										if(b.inside == m.bodyparts[3])
											if(bodypart_underlay)
												b.underlays = null
												bodypart_underlay.icon_state = "menu"
												b.underlays += bodypart_underlay
											b.hud_x = 200
											b.hud_y = yy
											b.maptext_width = 176
											b.maptext_height = 16
											b.maptext_x = 32
											b.maptext_y = 4
											b.maptext = "[css_outline]<font size = 1><left><font color = [b.txt_col]>[b.info_name]"
											b.blend_mode = BLEND_INSET_OVERLAY
											b.appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
											h.bodypart_holder.vis_contents += b
											yy -= 34
									m.body_exp_hp()
								if("right arm","Right Arm")
									var/yy = 385
									for(var/obj/body_related/b in m.bodyparts[4])

										if(bodypart_underlay)
											b.underlays = null
											bodypart_underlay.icon_state = "menu"
											b.underlays += bodypart_underlay
										if(b.cybernetics_created == 0)
											if(b.cybernetics == null)
												b.cybernetics = list()
												b.cybernetics.len = b.cybernetics_max
											var/N = b.cybernetics_max
											var/xx = 218+(14*N)
											while(N)
												var/obj/hud/buttons/cybernetic_slot/cs = new
												cs.loc = b
												cs.slot = N
												var/matrix/mat = matrix()
												mat.Translate(xx,yy+17)
												cs.transform = mat
												cs.hud_x = xx
												cs.hud_y = yy+17
												h.bodypart_holder.vis_contents += cs
												N -= 1
												xx -= 14
												//sleep(0.2)
											b.cybernetics_created = 1
										else
											for(var/obj/hud/buttons/cybernetic_slot/cs in b)
												h.bodypart_holder.vis_contents += cs

										b.hud_x = 200
										b.hud_y = yy

										b.maptext_width = 176
										b.maptext_height = 16
										b.maptext_x = 32
										b.maptext_y = 4
										b.maptext = "[css_outline]<font size = 1><left><font color = [b.txt_col]>[b.info_name]"

										b.blend_mode = BLEND_INSET_OVERLAY
										b.appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE

										h.bodypart_holder.vis_contents += b

										h.max_scroll_parts += 30

										yy -= 34
									//Next display the Meridians inside a limb
									for(var/obj/body_related/b in m.meridians)
										if(b.inside == m.bodyparts[4])
											if(bodypart_underlay)
												b.underlays = null
												bodypart_underlay.icon_state = "menu"
												b.underlays += bodypart_underlay
											b.hud_x = 200
											b.hud_y = yy
											b.maptext_width = 176
											b.maptext_height = 16
											b.maptext_x = 32
											b.maptext_y = 4
											b.maptext = "[css_outline]<font size = 1><left><font color = [b.txt_col]>[b.info_name]"
											b.blend_mode = BLEND_INSET_OVERLAY
											b.appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
											h.bodypart_holder.vis_contents += b
											yy -= 34
									m.body_exp_hp()
								if("right leg","Right Leg")
									var/yy = 385
									for(var/obj/body_related/b in m.bodyparts[5])

										if(bodypart_underlay)
											b.underlays = null
											bodypart_underlay.icon_state = "menu"
											b.underlays += bodypart_underlay
										if(b.cybernetics_created == 0)
											if(b.cybernetics == null)
												b.cybernetics = list()
												b.cybernetics.len = b.cybernetics_max
											var/N = b.cybernetics_max
											var/xx = 218+(14*N)
											while(N)
												var/obj/hud/buttons/cybernetic_slot/cs = new
												cs.loc = b
												cs.slot = N
												var/matrix/mat = matrix()
												mat.Translate(xx,yy+17)
												cs.transform = mat
												cs.hud_x = xx
												cs.hud_y = yy+17
												h.bodypart_holder.vis_contents += cs
												N -= 1
												xx -= 14
												//sleep(0.2)
											b.cybernetics_created = 1
										else
											for(var/obj/hud/buttons/cybernetic_slot/cs in b)
												h.bodypart_holder.vis_contents += cs

										b.hud_x = 200
										b.hud_y = yy

										b.maptext_width = 176
										b.maptext_height = 16
										b.maptext_x = 32
										b.maptext_y = 4
										b.maptext = "[css_outline]<font size = 1><left><font color = [b.txt_col]>[b.info_name]"

										b.blend_mode = BLEND_INSET_OVERLAY
										b.appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE

										h.bodypart_holder.vis_contents += b

										h.max_scroll_parts += 30

										yy -= 34
									//Next display the Meridians inside a limb
									for(var/obj/body_related/b in m.meridians)
										if(b.inside == m.bodyparts[5])
											if(bodypart_underlay)
												b.underlays = null
												bodypart_underlay.icon_state = "menu"
												b.underlays += bodypart_underlay
											b.hud_x = 200
											b.hud_y = yy
											b.maptext_width = 176
											b.maptext_height = 16
											b.maptext_x = 32
											b.maptext_y = 4
											b.maptext = "[css_outline]<font size = 1><left><font color = [b.txt_col]>[b.info_name]"
											b.blend_mode = BLEND_INSET_OVERLAY
											b.appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
											h.bodypart_holder.vis_contents += b
											yy -= 34
									m.body_exp_hp()
								if("left leg","Left Leg")
									var/yy = 385
									for(var/obj/body_related/b in m.bodyparts[6])

										if(bodypart_underlay)
											b.underlays = null
											bodypart_underlay.icon_state = "menu"
											b.underlays += bodypart_underlay
										if(b.cybernetics_created == 0)
											if(b.cybernetics == null)
												b.cybernetics = list()
												b.cybernetics.len = b.cybernetics_max
											var/N = b.cybernetics_max
											var/xx = 218+(14*N)
											while(N)
												var/obj/hud/buttons/cybernetic_slot/cs = new
												cs.loc = b
												cs.slot = N
												var/matrix/mat = matrix()
												mat.Translate(xx,yy+17)
												cs.transform = mat
												cs.hud_x = xx
												cs.hud_y = yy+17
												h.bodypart_holder.vis_contents += cs
												N -= 1
												xx -= 14
												//sleep(0.2)
											b.cybernetics_created = 1
										else
											for(var/obj/hud/buttons/cybernetic_slot/cs in b)
												h.bodypart_holder.vis_contents += cs

										b.hud_x = 200
										b.hud_y = yy

										b.maptext_width = 176
										b.maptext_height = 16
										b.maptext_x = 32
										b.maptext_y = 4
										b.maptext = "[css_outline]<font size = 1><left><font color = [b.txt_col]>[b.info_name]"

										b.blend_mode = BLEND_INSET_OVERLAY
										b.appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE

										h.bodypart_holder.vis_contents += b

										h.max_scroll_parts += 30

										yy -= 34
									//Next display the Meridians inside a limb
									for(var/obj/body_related/b in m.meridians)
										if(b.inside == m.bodyparts[6])
											if(bodypart_underlay)
												b.underlays = null
												bodypart_underlay.icon_state = "menu"
												b.underlays += bodypart_underlay
											b.hud_x = 200
											b.hud_y = yy
											b.maptext_width = 176
											b.maptext_height = 16
											b.maptext_x = 32
											b.maptext_y = 4
											b.maptext = "[css_outline]<font size = 1><left><font color = [b.txt_col]>[b.info_name]"
											b.blend_mode = BLEND_INSET_OVERLAY
											b.appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
											h.bodypart_holder.vis_contents += b
											yy -= 34
									m.body_exp_hp()
							if(m.part_focus)
								var/obj/b = m.part_focus
								b.underlays = null
								if(b == m.part_focus) bodypart_underlay.icon_state = "menu focus"
								else bodypart_underlay.icon_state = "menu"
								b.underlays += bodypart_underlay
							if(m.part_selected && m.part_selected != m.part_focus)
								var/obj/b = m.part_selected
								b.underlays = null
								if(b == m.part_selected) bodypart_underlay.icon_state = "menu selected"
								else bodypart_underlay.icon_state = "menu"
								b.underlays += bodypart_underlay
							for(var/obj/txt in h.bodypart_holder.vis_contents)
								var/matrix/m1 = matrix()
								m1.Translate(txt.hud_x,txt.hud_y+src.parts_transform)
								txt.transform = m1
								txt.translated_y = src.parts_transform
			tech_background
				icon = 'new_hud_tech.dmi'
				icon_state = "tabs"
				layer = 33
				screen_loc = "1,1"
				plane = 34
				translate_max = 800
				//Create a series of length 4 lists, one for each tech tab, plus the creation tab.
				var/list/bar_pos_y = list(0,0,0,0)
				var/list/bar_pos_x_hori = list(0,0,0,0)
				var/list/bar_pos_y_info = list(0,0,0,0)
				var/list/scrl_transform[4]
				var/list/scrl_transform_hori[4]

				var/selected = 1 //The currently selected tab, ranging from 1-4.
				/*
				1 - Tech creation
				2 - Engineering
				3 - Physics
				4 - Genetics
				*/

				//The tech_holder holds the tech_holder_special, which in turn holds all the tech tree info and buttons for that subwindow
				var/obj/tech_holder
				var/obj/tech_holder_special

				var/obj/hud/menus/tech_background/menu
				var/obj/tech_edge
				var/ww = 0
				var/hh = 0
				var/icon/I
				var/obj/txt_holder
				//var/obj/tech_display
				var/obj/tech_txt_scroller
				var/obj/hud/menus/tech_background/tech_scroller/tech_tree_scroller1
				var/obj/hud/menus/tech_background/tech_scroller_horizontal/tech_tree_scroller2
				var/obj/tech_txt_scrollbar
				var/obj/tech_tree_scrollbar1
				var/obj/tech_tree_scrollbar2
				var/obj/engineering
				var/obj/physics
				var/obj/genetics
				var/obj/rsc
				var/tmp/list/tree_engineering_list = list()
				var/tmp/list/tree_physics_list = list()
				var/tmp/list/tree_genetics_list = list()
				var/obj/txt
				var/num_to_make = 1
				var/lvl_to_make = 1
				var/obj/tech_num
				var/obj/tech_make
				var/obj/bar_tech_num
				var/obj/bar_tech_make
				var/list/engineering_list = list()
				var/list/physics_list = list()
				var/list/genetics_list = list()
				var/list/txt_list = list()
				var/obj/button_use
				var/obj/button_research
				var/txt_x
				var/txt_y
				//var/x_start = 0
				var/list/tabs = list()
				var/list/txt_tab1 = list()
				var/list/txt_tab2 = list()
				var/list/txt_tab3 = list()
				var/list/txt_tab4 = list()
				var/tmp/list/buttons = list()
				var/setup = 0
				var/obj/slider_lvl
				var/obj/slider_make
				var/tech_background_x = 300
				var/tech_background_y = 100
				var/obj/visual_tree_engineering
				var/obj/visual_tree_physics
				var/obj/visual_tree_genetics
				var/engineering_y_txt
				var/physics_y_txt
				var/genetics_y_txt
				var/size = 0
				var/size_build = 0
				var/engineering_y
				var/physics_y
				var/genetics_y
				var/tech_y
				New()
					return
				proc
					update_rsc(var/mob/m)
						//src.rsc.maptext = "[css_outline]<font size = 1><text align=left valign=top>Quality % Points: [Commas(m.intel_points)]"
						src.rsc.maptext = ""
					show_tech_costs(var/mob/m, var/obj/items/tech/w)
						var/efficiency = m.efficiency_skill
						var/stone = get_discounted_cost(w.stone_cost, efficiency)
						var/copper = get_discounted_cost(w.copper_cost, efficiency)
						var/coal = get_discounted_cost(w.coal_cost, efficiency)
						var/silver = get_discounted_cost(w.silver_cost, efficiency)
						var/gold = get_discounted_cost(w.gold_cost, efficiency)
						var/titanium = get_discounted_cost(w.titanium_cost, efficiency)
						var/mystille = get_discounted_cost(w.mystille_cost, efficiency)
						if(w.stone_cost<=0) stone = 0
						if(w.copper_cost<=0) copper = 0
						if(w.coal_cost<=0) coal = 0
						if(w.silver_cost<=0) silver = 0
						if(w.gold_cost<=0) gold=0
						if(w.titanium_cost<=0) titanium=0
						if(w.mystille_cost<=0) mystille=0
						var/obj/I = m.hud_tech.txt
						var/can_move = "Yes"
						if(w.bolted > 1) can_move = "No"
						if(!I)
							winset(m, "tech.label_cost",
								"text=\"Needed Minerals: <text align=right valign=top> Stone: [stone]\nCopper: [copper]\nCoal: [coal]\nSilver: [silver]\nGold: [gold]\nTitanium: [titanium]\nMystille: [mystille]\n\n<text align=left valign=top>\"")
						else
							I.maptext = "[css_outline]<font size = 1><text align=center valign=top>[w.name]<text align=left valign=top>\n\n<font color=grey>Stone:</font> [stone]\n<font color=#AB9143>Copper:</font> [copper]\n<font color=black>Coal:</font> [coal]\n<font color =#E1F1FB>Silver:</font> [silver]\n<font color =#FFCC00>Gold:</font> [gold]\n<font color =#D4D9E2>Titanium:</font> [titanium]\n<font color =#6699FF>Mystille:</font> [mystille]\n\n<text align=left valign=top>Tech Tree: [w.tech_tree]\n\nMoveable: [can_move]\n\n[w.desc]"

					set_tech_desc(var/mob/m,var/obj/items/itm)
						var/obj/I = m.hud_tech.txt
						var/can_move = "Yes"
						if(itm.bolted > 1) can_move = "No"
						I.maptext = "[css_outline]<font size = 1><text align=center valign=top>[itm.name]<text align=left valign=top>\n\nNeeded Minerals: <text align=right valign=top> Stone: [itm.stone_cost]\nCopper: [itm.copper_cost]\nCoal: [itm.coal_cost]\nSilver: [itm.silver_cost]\nGold: [itm.gold_cost]\nTitanium: [itm.titanium_cost]\nMystille: [itm.mystille_cost]\n\n<text align=left valign=top>Tech Tree: [itm.tech_tree]\n\nMoveable: [can_move]\n\n[itm.desc]"

					fix_tech_alignment(var/mob/m)
						//If the number of tech's available in the game changes, then the player needs their special lists re-aligned again, to avoid issues.
						if(m.tech_lvls.len != global.tech.len)
							var/list/copy_unlocked = m.tech_unlocked.Copy()
							var/list/copy_lvls = m.tech_lvls.Copy()
							var/list/copy_xp = m.tech_xp.Copy()

							m.tech_lvls = list()
							m.tech_unlocked = list()
							m.tech_xp = list()

							m.tech_lvls.len = global.tech.len
							m.tech_unlocked.len = global.tech.len
							m.tech_xp.len = global.tech.len

							for(var/obj/items/tech/t in global.tech)
								var/pos = copy_unlocked.Find(t.type)
								if(pos > 0)
									m.tech_unlocked[t.list_pos] = copy_unlocked[pos]
									m.tech_lvls[t.list_pos] = copy_lvls[pos]
									m.tech_xp[t.list_pos] = copy_xp[pos]
									if(t.type == /obj/items/tech/sub_tech/Engineering/Structural_Engineering) m.tech_pos_se = t.list_pos
							//world << "DEBUG - Had to fix the players tech alignment"
							return
					populate_tech_tree()
						//This is here now because the engineering, physics and genetics, ie. tree_engineering_list, are now tmp lists, so need to be filled when the menu is created

						for(var/obj/items/tech/t in global.tech)
							if(istype(t,/obj/items/tech/sub_tech/Engineering/))
								src.tree_engineering_list += t
							else if(istype(t,/obj/items/tech/sub_tech/Physics/))
								src.tree_physics_list += t
							else if(istype(t,/obj/items/tech/sub_tech/Genetics/))
								src.tree_genetics_list += t

					menu_create()
						if(src.setup)
							return
						else
							src.setup = 1

							if(ismob(src.loc))
								var/mob/m = src.loc
								m.tech_lvls.len = global.tech.len
								m.tech_unlocked.len = global.tech.len
								m.tech_xp.len = global.tech.len

							src.I = new(src.icon)
							src.ww = I.Width()
							src.hh = I.Height()

							var/matrix/m_main = matrix()
							m_main.Translate(300,100)
							src.transform = m_main

							var/obj/hud/buttons/close_menu/cm = new
							cm.plane = src.plane
							cm.closes = src
							var/matrix/close_m = matrix()
							close_m.Translate(ww-15,hh-15)
							cm.transform = close_m
							src.vis_contents += cm
							src.txt_tab1 += cm
							src.txt_tab2 += cm
							src.txt_tab3 += cm
							src.txt_tab4 += cm

							var/obj/title = new
							title.maptext_width = 400
							title.maptext_height = 16
							title.maptext = ""
							title.layer = 34
							title.plane = 34
							title.appearance_flags = PIXEL_SCALE
							var/matrix/m_rsc = matrix()
							m_rsc.Translate(350,18)
							title.transform = m_rsc
							title.screen_loc = src.screen_loc
						//	src.vis_contents += title
							src.rsc = title

							var/obj/hud/buttons/tabs/tech_build/tab1/tab_build_tech = new
							tab_build_tech.screen_loc = src.screen_loc
							src.vis_contents += tab_build_tech
							src.tabs += tab_build_tech
							src.txt_tab1 += tab_build_tech

							/*var/obj/hud/buttons/tabs/tech_build/tab2/tab_engineering = new
							tab_engineering.screen_loc = src.screen_loc
							src.vis_contents += tab_engineering
							src.tabs += tab_engineering
							src.txt_tab1 += tab_engineering

							var/obj/hud/buttons/tabs/tech_build/tab3/tab_physics = new
							tab_physics.screen_loc = src.screen_loc
							src.vis_contents += tab_physics
							src.tabs += tab_physics
							src.txt_tab1 += tab_physics

							var/obj/hud/buttons/tabs/tech_build/tab4/tab_genetics = new
							tab_genetics.screen_loc = src.screen_loc
							src.vis_contents += tab_genetics
							src.tabs += tab_genetics
							src.txt_tab1 += tab_genetics*/

							var/obj/hud/menus/tech_background/tech_txt_holder/txt1 = new
							src.vis_contents += txt1
							src.txt_holder = txt1
							src.txt_tab1 += txt1
							src.txt_tab2 += txt1
							src.txt_tab3 += txt1
							src.txt_tab4 += txt1

							var/obj/hud/menus/tech_background/tech_txt_desc/txt_actual = new
							txt_actual.maptext = "[css_outline]<font size = 1><text align=left valign=top>Tech"
							var/matrix/m_txt = matrix()
							txt_actual.hud_x = ww-170
							txt_actual.hud_y = -738
							m_txt.Translate(txt_actual.hud_x,txt_actual.hud_y)
							txt_actual.transform = m_txt
							txt1.vis_contents += txt_actual
							src.txt_list += txt_actual
							src.txt = txt_actual

							var/obj/hud/menus/tech_background/tech_holder/h1 = new
							src.vis_contents += h1
							src.tech_holder = h1
							//src.txt_tab1 += h1
							h1.menu = src

							var/obj/hud/menus/tech_background/tech_holder_special/h_spec = new
							var/matrix/m_spec = matrix()
							m_spec.Translate(h_spec.hud_x,h_spec.hud_y)
							h_spec.transform = m_spec
							h1.vis_contents += h_spec
							src.tech_holder_special = h_spec
							h_spec.menu = src

							var/obj/hud/buttons/expand_buttons/tech_expand_buttons/engineering/en = new
							en.hidden = 0
							en.maptext = "[css_outline]<font size = 2><text align=left valign=top>Engineering"
							var/matrix/m1 = matrix()
							en.hud_x = 4
							en.hud_y = 679//src.hh-69
							m1.Translate(en.hud_x,en.hud_y)
							en.transform = m1
							h_spec.vis_contents += en
							src.engineering = en
							src.engineering_list += en

							var/obj/hud/buttons/expand_buttons/tech_expand_buttons/physics/phy = new
							phy.hidden = 0
							phy.maptext = "[css_outline]<font size = 2><text align=left valign=top>Physics"
							var/matrix/m2 = matrix()
							phy.hud_x = 4
							phy.hud_y = 662//src.hh-86
							m2.Translate(phy.hud_x,phy.hud_y)
							phy.transform = m2
							h_spec.vis_contents += phy
							src.physics = phy
							src.physics_list += phy

							var/obj/hud/buttons/expand_buttons/tech_expand_buttons/genetics/gen = new
							gen.hidden = 0
							gen.maptext = "[css_outline]<font size = 2><text align=left valign=top>Genetics"
							var/matrix/m3 = matrix()
							gen.hud_x = 4
							gen.hud_y = 645//src.hh-103
							m3.Translate(gen.hud_x,gen.hud_y)
							gen.transform = m3
							h_spec.vis_contents += gen
							src.genetics = gen
							src.genetics_list += gen

							var/obj/hud/menus/tech_background/tech_create_number/tech_create = new
							src.vis_contents += tech_create
							src.bar_tech_make = tech_create
							src.txt_tab1 += tech_create

							var/obj/hud/menus/tech_background/tech_lvl_number/lvl_num = new
							src.vis_contents += lvl_num
							src.bar_tech_num = lvl_num
							src.txt_tab1 += lvl_num

							var/obj/hud/menus/tech_background/tech_lvl_box/lvl_box = new
							src.vis_contents += lvl_box
							src.txt_tab1 += lvl_box

							var/obj/hud/menus/tech_background/tech_num_box/num_box = new
							src.vis_contents += num_box
							src.txt_tab1 += num_box

							var/obj/hud/menus/tech_background/tech_slider_lvl/slider1 = new
							var/matrix/m9 = matrix()
							slider1.hud_x = 277
							slider1.hud_y = 39
							m9.Translate(277,39)
							slider1.transform = m9
							src.vis_contents += slider1
							src.slider_lvl = slider1
							src.txt_tab1 += slider1

							var/obj/hud/menus/tech_background/tech_slider_make/slider2 = new
							var/matrix/m10 = matrix()
							slider2.hud_x = 80
							slider2.hud_y = 15
							m10.Translate(80,15)
							slider2.transform = m10
							src.vis_contents += slider2
							src.slider_make = slider2
							src.txt_tab1 += slider2

							var/obj/hud/menus/tech_background/tech_button_build/but1 = new
							var/matrix/m5 = matrix()
							but1.hud_x = 328
							but1.hud_y = 18
							m5.Translate(328,18)
							but1.transform = m5
							src.vis_contents += but1
							src.button_use = but1
							src.txt_tab1 += but1

							var/obj/title1 = new
							title1.maptext_width = 64
							title1.maptext_height = 16
							title1.maptext = "[css_outline]<font size = 1><text align=right valign=top>Quality %:"
							title1.layer = 34
							title1.plane = 34
							title1.appearance_flags = PIXEL_SCALE
							var/matrix/m4 = matrix()
							m4.Translate(8,36)
							title1.transform = m4
							title1.screen_loc = src.screen_loc
							src.vis_contents += title1
							src.txt_tab1 += title1

							var/obj/title2 = new
							title2.maptext_width = 64
							title2.maptext_height = 16
							title2.maptext = "[css_outline]<font size = 1><text align=right valign=top>Repeat:"
							title2.layer = 34
							title2.plane = 34
							title2.appearance_flags = PIXEL_SCALE
							var/matrix/m6 = matrix()
							m6.Translate(8,12)
							title2.transform = m6
							title2.screen_loc = src.screen_loc
							src.vis_contents += title2
							src.txt_tab1 += title2

							var/obj/tech_num = new
							tech_num.maptext_width = 64
							tech_num.maptext_height = 16
							tech_num.maptext = "[css_outline]<font size = 1><center>1"
							tech_num.layer = 34
							tech_num.plane = 34
							tech_num.appearance_flags = PIXEL_SCALE
							var/matrix/m7 = matrix()
							m7.Translate(272,15)
							tech_num.transform = m7
							tech_num.screen_loc = src.screen_loc
							src.vis_contents += tech_num
							src.tech_make = tech_num
							src.txt_tab1 += tech_num

							var/obj/tech_lvl = new
							tech_lvl.maptext_width = 64
							tech_lvl.maptext_height = 16
							tech_lvl.maptext = "[css_outline]<font size = 1><center>0"
							tech_lvl.layer = 34
							tech_lvl.plane = 34
							tech_lvl.appearance_flags = PIXEL_SCALE
							var/matrix/m8 = matrix()
							m8.Translate(272,39)
							tech_lvl.transform = m8
							tech_lvl.screen_loc = src.screen_loc
							src.vis_contents += tech_lvl
							src.tech_num = tech_lvl
							src.txt_tab1 += tech_lvl

							var/obj/hud/menus/tech_background/tech_txt_scrollbar/tech_txt_bar = new
							src.txt_tab1 += tech_txt_bar
							src.txt_tab2 += tech_txt_bar
							src.txt_tab3 += tech_txt_bar
							src.txt_tab4 += tech_txt_bar
							src.tech_txt_scrollbar = tech_txt_bar
							src.vis_contents += tech_txt_bar

							var/obj/hud/menus/tech_background/tech_scroller_txt/tech_scroller3 = new
							src.vis_contents += tech_scroller3
							src.txt_tab1 += tech_scroller3
							src.txt_tab2 += tech_scroller3
							src.txt_tab3 += tech_scroller3
							src.txt_tab4 += tech_scroller3
							src.tech_txt_scroller = tech_scroller3

							var/obj/hud/menus/tech_background/tech_scrollbar/tech_tree_bar1 = new
							src.txt_tab1 += tech_tree_bar1
							src.txt_tab2 += tech_tree_bar1
							src.txt_tab3 += tech_tree_bar1
							src.txt_tab4 += tech_tree_bar1
							src.tech_tree_scrollbar1 = tech_tree_bar1
							src.vis_contents += tech_tree_bar1
							tech_tree_bar1.menu = src

							var/obj/hud/menus/tech_background/tech_scrollbar_horizontal/tech_tree_bar2 = new
							src.txt_tab2 += tech_tree_bar2
							src.txt_tab3 += tech_tree_bar2
							src.txt_tab4 += tech_tree_bar2
							src.tech_tree_scrollbar2 = tech_tree_bar2
							src.vis_contents += tech_tree_bar2
							tech_tree_bar2.menu = src

							var/obj/hud/menus/tech_background/tech_scroller/tech_scroller1 = new
							src.vis_contents += tech_scroller1
							src.txt_tab1 += tech_scroller1
							src.txt_tab2 += tech_scroller1
							src.txt_tab3 += tech_scroller1
							src.txt_tab4 += tech_scroller1
							src.tech_tree_scroller1 = tech_scroller1
							tech_scroller1.menu = src

							var/obj/hud/menus/tech_background/tech_scroller_horizontal/tech_scroller2 = new
							src.vis_contents += tech_scroller2
							src.txt_tab2 += tech_scroller2
							src.txt_tab3 += tech_scroller2
							src.txt_tab4 += tech_scroller2
							src.tech_tree_scroller2 = tech_scroller2
							tech_scroller2.menu = src

							/*var/obj/hud/menus/tech_background/tech_button_research/but2 = new
							var/matrix/mb = matrix()
							but2.hud_x = 358
							but2.hud_y = 37
							mb.Translate(358,37)
							but2.transform = mb
							src.button_research = but2
							src.txt_tab2 += but2
							src.txt_tab3 += but2
							src.txt_tab4 += but2*/

							//Create tech engineering display for player

							var/obj/hud/menus/tech_background/tech_edge/edge1 = new
							src.tech_edge = edge1
							edge1.menu = src
							src.vis_contents += edge1

							var/obj/hud/menus/tech_background/tech_tree_engineering/engineering_tree = new
							//src.tree_engineering_list += engineering_tree
							src.visual_tree_engineering = engineering_tree

							//Create tech physics display for player

							var/obj/hud/menus/tech_background/tech_edge/edge2 = new
							src.txt_tab3 += edge2

							var/obj/hud/menus/tech_background/tech_tree_physics/physics_tree = new
							//src.tree_physics_list += physics_tree
							src.visual_tree_physics = physics_tree

							//Create tech genetics display for player

							var/obj/hud/menus/tech_background/tech_edge/edge3 = new
							src.txt_tab4 += edge3

							var/obj/hud/menus/tech_background/tech_tree_genetics/genetics_tree = new
							//src.tree_genetics_list += genetics_tree
							src.visual_tree_genetics = genetics_tree

				MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
					params = params2list(params)
					var/icon_y = text2num(params["icon-y"])
					if(icon_y >= 350 || usr.mouse_down)
						usr.client.MousePosition(params)
						var/matrix/m = matrix()
						var/icon_x = text2num(params["icon-x"])
						if(usr.drag_icon_x == 0) usr.drag_icon_x = icon_x
						var/x_result = usr.client.client_mouse_x-usr.drag_icon_x
						var/y_result = usr.client.client_mouse_y-src.hh
						x_result = clamp(x_result,0,1023-src.ww)
						y_result = clamp(y_result,0,575-(src.hh/2))
						m.Translate(x_result,y_result)
						src.transform = m
						src.tech_background_x = x_result
						src.tech_background_y = y_result
						usr.mouse_down = src



						/*
						if(src.tech_tree_scroller1)
							usr.check_mouse_loc(params)
							src.tech_tree_scroller1.y_start = (usr.client.client_mouse_y-368)// minus basically the height of the menu, 368
							src.tech_tree_scroller1.y_start = clamp(src.tech_tree_scroller1.y_start,0,254) //Stops the mouse_y being too high or low and messing with numbers
							src.tech_tree_scroller1.transform = null
							src.tech_tree_scroller1.translated_y = 0
							src.tech_tree_scroller1.icon_y_saved = 270
							var/matrix/m1 = matrix()
							m1.Translate(src.tech_holder.hud_x,src.tech_holder.hud_y)

							if(src.tree_holder_engineering) src.tree_holder_engineering.transform = m1
							if(src.tree_holder_physics) src.tree_holder_physics.transform = m1
							if(src.tree_holder_genetics) src.tree_holder_genetics.transform = m1
						if(src.tech_tree_scroller2)
							usr.check_mouse_loc(params)
							src.tech_tree_scroller2.x_start = (usr.client.client_mouse_x-484)// minus basically the height of the menu, 368
							src.tech_tree_scroller2.x_start = clamp(src.tech_tree_scroller2.x_start,0,254) //Stops the mouse_y being too high or low and messing with numbers
							src.tech_tree_scroller2.transform = null
							src.tech_tree_scroller2.translated_x = 0
							src.tech_tree_scroller2.icon_x_saved = 83
							var/matrix/m1 = matrix()
							m1.Translate(src.tech_holder.hud_x,src.tech_holder.hud_y)

							if(src.tree_holder_engineering) src.tree_holder_engineering.transform = m1
							if(src.tree_holder_physics) src.tree_holder_physics.transform = m1
							if(src.tree_holder_genetics) src.tree_holder_genetics.transform = m1
						*/

				/*
				MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
					usr.client.MousePosition(params)
					var/matrix/m = matrix()
					var/x_result = usr.client.client_mouse_x-(src.ww/2)
					var/y_result = usr.client.client_mouse_y-src.hh
					params = params2list(params)
					var/icon_y = text2num(params["icon-y"])
					if(icon_y >= 350 || usr.mouse_down)
						x_result = clamp(x_result,0,1023-src.ww)
						y_result = clamp(y_result,0,575-(src.hh/2))
						m.Translate(x_result,y_result)
						src.transform = m
						src.tech_background_x = x_result
						src.tech_background_y = y_result
						usr.mouse_down = src

						if(src.tech_tree_scroller1)
							usr.check_mouse_loc(params)
							src.tech_tree_scroller1.y_start = (usr.client.client_mouse_y-368)// minus basically the height of the menu, 368
							src.tech_tree_scroller1.y_start = clamp(src.tech_tree_scroller1.y_start,0,254) //Stops the mouse_y being too high or low and messing with numbers
							src.tech_tree_scroller1.transform = null
							src.tech_tree_scroller1.translated_y = 0
							src.tech_tree_scroller1.icon_y_saved = 270
							var/matrix/m1 = matrix()
							m1.Translate(src.tech_holder.hud_x,src.tech_holder.hud_y)

							if(src.tree_holder_engineering) src.tree_holder_engineering.transform = m1
							if(src.tree_holder_physics) src.tree_holder_physics.transform = m1
							if(src.tree_holder_genetics) src.tree_holder_genetics.transform = m1
						if(src.tech_tree_scroller2)
							usr.check_mouse_loc(params)
							src.tech_tree_scroller2.x_start = (usr.client.client_mouse_x-484)// minus basically the height of the menu, 368
							src.tech_tree_scroller2.x_start = clamp(src.tech_tree_scroller2.x_start,0,254) //Stops the mouse_y being too high or low and messing with numbers
							src.tech_tree_scroller2.transform = null
							src.tech_tree_scroller2.translated_x = 0
							src.tech_tree_scroller2.icon_x_saved = 83
							var/matrix/m1 = matrix()
							m1.Translate(src.tech_holder.hud_x,src.tech_holder.hud_y)

							if(src.tree_holder_engineering) src.tree_holder_engineering.transform = m1
							if(src.tree_holder_physics) src.tree_holder_physics.transform = m1
							if(src.tree_holder_genetics) src.tree_holder_genetics.transform = m1
				*/
				tech_tree_engineering
					icon = 'tech_tree_engineering.dmi'
					layer = 34
					plane = 34
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					mouse_opacity = 0
					MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
						return
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
					MouseWheel()
						return
					Click()
						return
				tech_tree_physics
					icon = 'tech_tree_physics.dmi'
					layer = 34
					plane = 34
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					mouse_opacity = 0
					MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
						return
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
					MouseWheel()
						return
					Click()
						return
				tech_tree_genetics
					icon = 'tech_tree_genetics.dmi'
					layer = 34
					plane = 34
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					mouse_opacity = 0
					MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
						return
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
					MouseWheel()
						return
					Click()
						return
				tech_slider_lvl
					icon = 'new_hud_slider_leftright.dmi'
					layer = 34
					plane = 34
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE
					MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
						//if(usr.hud_tech && usr.hud_tech.slider_lvl && src == usr.hud_tech.slider_lvl)
							//if(usr.hud_tech.bar_tech_num)
						var/obj/hud/menus/tech_background/s = usr.hud_tech
						if(usr.build_tech_selected)
							var/obj/items/t = usr.build_tech_selected
							usr.check_mouse_loc(params)
							var/true_x = ((usr.mouse_x-1)*32)+usr.mouse_pix_x //The -1 accounts for Byonds fuckery with the x pos always starting at 1, which would be 32 pixels across, instead of 0.
							usr.mouse_x_true = true_x

							// Calculate slider position and clamp within the range
							var/result = usr.mouse_x_true-s.tech_background_x
							result = clamp(result,80,277)

							// Move the slider visually
							var/matrix/m = matrix()
							m.Translate(result,s.slider_lvl.hud_y)
							s.slider_lvl.transform = m


							// Determine tech level based on player's intelligence
							var/range = 277 - 80  // Total slider range
							var/per = ((result - 80) / range)  // Percentage of slider progression (0 to 1)

							 // Scale percentage to match intelligence (1% to usr.intelligence%)
							var/max_tech_level = max(1, (round(usr.intxp*10000,0.01))/round(10000,0.01))  // Ensure minimum of 1
							var/N = round(per * max_tech_level)  // Calculate tech level within player's range
							N = clamp(N, 1, max_tech_level)  // Ensure tech level stays within bounds
							if(t.tech_parent_path)
								//world << "DEBUG - found t = [t], with a tech_parent_path of [t.tech_parent_path]"
								for(var/obj/items/tech/t2 in global.tech)//usr.technology_researched)
									if(usr.tech_unlocked[t2.list_pos] == t2.type)
										if(t2.type == t.tech_parent_path)
											//if(t.name == "Sword"|| t.name == "Sword(Kid)")
											//	N = clamp(N, 1, 125)
											if(t.weapon == 1)
												N = clamp(N, 1, 125)
											if(istype(t,/obj/items/tech/armors/))
												N = clamp(N, 1, 100)
											//world << "DEBUG - found t2 = [t2]"
										//	var/range = 80-277

											//var/per = ((result - 80) / range) * 100
											per = abs(round(per))
											//var/N = round((per/100)*t2.tech_lvl)
											//N = clamp(N,1,t2.tech_lvl)
											//var/N = round(per * max_tech_level)  // Calculate tech level within player's range
											//N = clamp(N, 1, max_tech_level)  // Ensure tech level stays within bounds
											s.tech_num.maptext = "[css_outline]<font size = 1><center>[N]"
											s.lvl_to_make = N
											break
							else
								//world << "DEBUG - wasn't able to find a tech_parent_path for [t] "

								per = abs(round(per))
								//N = clamp(N, 1, max_tech_level)
								s.tech_num.maptext = "[css_outline]<font size = 1><center>[N]"
								s.lvl_to_make = N
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
					MouseWheel()
						return
					Click()
						return
				tech_slider_make
					icon = 'new_hud_slider_leftright.dmi'
					layer = 34
					plane = 34
					translate_max = 200
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE
					MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
						var/obj/hud/menus/tech_background/s = usr.hud_tech
						usr.check_mouse_loc(params)
						var/true_x = ((usr.mouse_x-1)*32)+usr.mouse_pix_x //The -1 accounts for Byonds fuckery with the x pos always starting at 1, which would be 32 pixels across, instead of 0.
						usr.mouse_x_true = true_x
						var/result = usr.mouse_x_true-s.tech_background_x
						result = clamp(result,80,277)
						var/matrix/m = matrix()
						m.Translate(result,src.hud_y)
						src.transform = m
						var/range = 80-277
						var/per = ((result - 80) / range) * 100
						s.num_to_make = abs(round(per))
						s.num_to_make = clamp(s.num_to_make,1,99)

						if(usr.build_tech_selected)
							var/obj/items/t = usr.build_tech_selected
							if(t.stacks > -1)
								//usr.hud_tech.set_tech_desc(usr,t)
								usr.hud_tech.show_tech_costs(usr,t)
								s.tech_make.maptext = "[css_outline]<font size = 1><center>[s.num_to_make]"
							else s.tech_make.maptext = "[css_outline]<font size = 1><center>1"
						else
							s.num_to_make = 1
							s.tech_make.maptext = "[css_outline]<font size = 1><center>1"
						//s.intel_make.maptext = "[css_outline]<font size = 1><center>[round(usr.intel_points,1)]"


						//s.tech_make.maptext = "[css_outline]<font size = 1><center>[s.num_to_make]"
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
					MouseWheel()
						return
					Click()
						return
				tech_button_build
					icon = 'new_hud_inv_buttons.dmi'
					icon_state = "exit"
					maptext_height = 16
					maptext_width = 52
					maptext_y = 3
					layer = 33
					plane = 34
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE
					MouseEntered(location,control,params)
						src.icon_state = "enter"
					MouseExited(location,control,params)
						src.icon_state = "exit"
					Click()
						if(usr.hud_tech && src == usr.hud_tech.button_use)
							usr.build_tech = usr.build_tech_selected
							if(usr.hud_tech) usr.client.screen -= usr.hud_tech
					MouseWheel()
						return
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						src.maptext = "[css_outline]<font size = 1><center>Build"
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				tech_button_research
					icon = 'new_hud_inv_buttons.dmi'
					icon_state = "exit"
					maptext_height = 16
					maptext_width = 52
					maptext_y = 3
					layer = 33
					plane = 34
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE
					MouseEntered(location,control,params)
						src.icon_state = "enter"
					MouseExited(location,control,params)
						src.icon_state = "exit"
					Click()
						if(usr.hud_tech && src == usr.hud_tech.button_research)
							//Clicked when the button says, for instance, "Pause"
							if(usr.tech_focus && usr.tech_display == usr.tech_focus)
								src.maptext = "[css_outline]<font size = 1><center>Research"
								usr.tech_focus = null
								return
							//Clicked when the button says "Research"
							else if(usr.tech_display)
								var/needed_p = 0
								var/has_p = 0
								var/obj/items/tech/tch = usr.tech_display
								needed_p = length(tch.tech_prerequisites)
								if(usr.key in StaffTeam)
									has_p = 99
								if(needed_p > 0)
									for(var/p in tch.tech_prerequisites)
										for(var/obj/items/tech/z in global.tech)//usr.technology_researched)
											if(usr.tech_unlocked[z.list_pos] == z.type)
												if(z.type == p)
													if(usr.intxp >= z.needed_qp)
														has_p += 1



													else
														usr.set_alert("Not intelligent enough to learn!",z.icon,z.icon_state)
													break

								if(needed_p == 0 || has_p >= needed_p)
									usr.tech_focus = usr.tech_display
									src.maptext = "[css_outline]<font size = 1><center>Pause"



								else
									usr.output_msg("Prerequisites not met.")
									usr.set_alert("Prerequisites not met",'alert.dmi',"alert")
									return
								if(usr.tech_focus)
									var/obj/items/tech/sub_tech/t = usr.tech_focus
									exp_loop
									if(usr.tech_xp[t.list_pos] < 100)
										usr.tech_xp[t.list_pos] += t.tech_exp_gain*usr.mod_tech_potential
										spawn(20)
											if(usr.tech_xp[t.list_pos] < 100 && usr.tech_focus)
												goto exp_loop
									if(usr.tech_xp[t.list_pos] >= 100)
										t.lvl_up_tech(usr)
										usr.check_quest("gen_lvl_research",1,0,1)

									usr.tech_xp_update()


					MouseWheel()
						return
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						src.maptext = "[css_outline]<font size = 1><center>Research"
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				tech_scroller_txt
					icon = 'new_hud_tech.dmi'
					icon_state = "txt scroller"
					layer = 33
					plane = 34
					appearance_flags = KEEP_TOGETHER
					var/build_transform
					var/engineering_transform
					var/physics_transform
					var/genetics_transform
					MouseWheel(delta_x,delta_y,location,control,params)
						/*
						.:NOTES:.
						- 256 in the default example is the bar length/height.
						- 256 (bar length/height) is fine to use in var/result
						- Bar length - scroller length/height (usually 27) is the smaller number, in this case 227, which is used for clamping result and ratio
						- After subtracting the scroller length/height (usually 27) from the scrollbar, use it in clamping result and ratio.
						- IMPORTANT - scroll_y's first number is the total height of the inside area we want the bar/scroller to let us move up and down inside of.
						*/
						if(usr.hud_tech)
							if(usr.hud_tech.tech_txt_scroller)
								if(src == usr.hud_tech.tech_txt_scroller)
									var/obj/hud/menus/tech_background/s = usr.hud_tech
									var/obj/hud/menus/tech_background/tech_scroller/sc = s.tech_txt_scroller
									s.buttons = list(s.txt)
									var/tab = null
									var/yy = 0
									for(var/obj/hud/buttons/tabs/t in s.tabs)
										if(t.clicked)
											yy = t.max_y_txt
											if(t.type == /obj/hud/buttons/tabs/tech_build/tab1)
												tab = "Build"
												break
											else if(t.type == /obj/hud/buttons/tabs/tech_build/tab2)
												tab = "Engineering"
												break
											else if(t.type == /obj/hud/buttons/tabs/tech_build/tab3)
												tab = "Physics"
												break
											else if(t.type == /obj/hud/buttons/tabs/tech_build/tab4)
												tab = "Genetics"
												break

									usr.check_mouse_loc(params)
									params = params2list(params)
									var/wheel_move = 0
									if(delta_y > 0) wheel_move = 16
									else if(delta_y < 0) wheel_move = -16
									var/result = sc.translated_y+wheel_move
									result = clamp(result,0,-245)
									var/matrix/m = matrix()
									m.Translate(0,result)
									sc.transform = m
									var/ratio = -1 + ((-245 + result) / -245)
									ratio = clamp(ratio,0,1)
									var/scroll_y = round(yy*ratio)
									if(tab == "Engineering")
										sc.engineering_transform = result
										sc.engineering_y_txt = scroll_y
									else if(tab == "Physics")
										sc.physics_transform = result
										sc.physics_y_txt = scroll_y
									else if(tab == "Genetics")
										sc.genetics_transform = result
										sc.genetics_y_txt = scroll_y
									else if(tab == "Build") sc.build_transform = result
									sc.translated_y = result

									for(var/obj/o in s.buttons)
										var/matrix/m2 = matrix()
										m2.Translate(o.hud_x,o.hud_y+scroll_y)
										o.transform = m2
										o.shift_y = scroll_y
					MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
						/*
						.:NOTES:.
						- 256 in the default example is the bar length/height.
						- 256 (bar length/height) is fine to use in var/result
						- Bar length - scroller length/height (usually 27) is the smaller number, in this case 227, which is used for clamping result and ratio
						- After subtracting the scroller length/height (usually 27) from the scrollbar, use it in clamping result and ratio.
						- IMPORTANT - scroll_y's first number is the total height of the inside area we want the bar/scroller to let us move up and down inside of.
						*/
						if(usr.hud_tech)
							if(usr.hud_tech.tech_txt_scroller)
								if(src == usr.hud_tech.tech_txt_scroller)
									var/obj/hud/menus/tech_background/s = usr.hud_tech
									var/obj/hud/menus/tech_background/tech_scroller/sc = s.tech_txt_scroller
									var/tab = null
									s.buttons = list(s.txt)
									var/yy = 0
									for(var/obj/hud/buttons/tabs/t in s.tabs)
										if(t.clicked)
											yy = t.max_y_txt
											if(t.type == /obj/hud/buttons/tabs/tech_build/tab1)
												tab = "Build"
												break
											else if(t.type == /obj/hud/buttons/tabs/tech_build/tab2)
												tab = "Engineering"
												break
											else if(t.type == /obj/hud/buttons/tabs/tech_build/tab3)
												tab = "Physics"
												break
											else if(t.type == /obj/hud/buttons/tabs/tech_build/tab4)
												tab = "Genetics"
												break

									usr.check_mouse_loc(params)
									var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
									usr.mouse_y_true = true_y
									var/result = -272 + ((usr.mouse_y_true-s.tech_background_y)-54) //54 is the size of the scroller x 2 (basically its height in pixels).
									result = clamp(result,0,-245)
									var/matrix/m = matrix()
									m.Translate(0,result)
									sc.transform = m
									var/ratio = -1 + ((-245 + result) / -245)
									ratio = clamp(ratio,0,1)
									var/scroll_y = round(yy*ratio)
									sc.translated_y = result
									if(tab == "Engineering")
										sc.engineering_transform = result
										sc.engineering_y_txt = scroll_y
									else if(tab == "Physics")
										sc.physics_transform = result
										sc.physics_y_txt = scroll_y
									else if(tab == "Genetics")
										sc.genetics_transform = result
										sc.genetics_y_txt = scroll_y
									else if(tab == "Build") sc.build_transform = result

									for(var/obj/o in s.buttons)
										var/matrix/m2 = matrix()
										m2.Translate(o.hud_x,o.hud_y+scroll_y)
										o.transform = m2
										o.shift_y = scroll_y

					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				tech_scroller
					icon = 'new_hud_tech.dmi'
					icon_state = "tech scroller"
					layer = 33
					plane = 34
					appearance_flags = KEEP_TOGETHER
					var/build_transform
					var/engineering_transform
					var/physics_transform
					var/genetics_transform
					MouseWheel(delta_x,delta_y,location,control,params)
						/*
						.:NOTES:.
						- 256 in the default example is the bar length/height.
						- 256 (bar length/height) is fine to use in var/result
						- Bar length - scroller length/height (usually 27) is the smaller number, in this case 227, which is used for clamping result and ratio
						- After subtracting the scroller length/height (usually 27) from the scrollbar, use it in clamping result and ratio.
						- IMPORTANT - scroll_y's first number is the total height of the inside area we want the bar/scroller to let us move up and down inside of.
						*/
						if(usr.hud_tech)
							if(usr.hud_tech.tech_tree_scroller1)
								if(src == usr.hud_tech.tech_tree_scroller1)
									var/obj/hud/menus/tech_background/s = src.menu
									var/obj/sc = s.tech_tree_scroller1
									usr.check_mouse_loc(params)
									var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
									usr.mouse_y_true = true_y
									var/wheel_move = 0
									if(delta_y > 0) wheel_move = 16
									else if(delta_y < 0) wheel_move = -16
									var/result = sc.translated_y+wheel_move
									result = clamp(result,0,-227)
									var/matrix/m = matrix()
									m.Translate(0,result)
									sc.transform = m
									sc.translated_y = result

									s.scrl_transform[s.selected] = m

									var/ratio = -1 + ((-227 + result) / -227)
									ratio = clamp(ratio,0,1)
									var/scroll_y = round(s.size*ratio)

									s.bar_pos_y[s.selected] = scroll_y

									if(s.selected == 1)
										for(var/obj/o in s.tech_holder_special.vis_contents)
											var/matrix/m2 = matrix()
											m2.Translate(o.hud_x-s.bar_pos_x_hori[s.selected],o.hud_y+s.bar_pos_y[s.selected])
											o.transform = m2
									else
										var/matrix/m2 = matrix()
										m2.Translate(s.tech_holder_special.hud_x-s.bar_pos_x_hori[s.selected],s.tech_holder_special.hud_y+s.bar_pos_y[s.selected])
										s.tech_holder_special.transform = m2
					MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
						/*
						.:NOTES:.
						- 256 in the default example is the bar length/height.
						- 256 (bar length/height) is fine to use in var/result
						- Bar length - scroller length/height (usually 27) is the smaller number, in this case 227, which is used for clamping result and ratio
						- After subtracting the scroller length/height (usually 27) from the scrollbar, use it in clamping result and ratio.
						- IMPORTANT - scroll_y's first number is the total height of the inside area we want the bar/scroller to let us move up and down inside of.
						*/
						if(usr.hud_tech)
							if(usr.hud_tech.tech_tree_scroller1)
								if(src == usr.hud_tech.tech_tree_scroller1)
									var/obj/hud/menus/tech_background/s = src.menu
									var/obj/sc = s.tech_tree_scroller1
									usr.check_mouse_loc(params)
									var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
									usr.mouse_y_true = true_y
									var/result = -256 + ((usr.mouse_y_true-s.tech_background_y)-54)
									result = clamp(result,0,-227)
									var/matrix/m = matrix()
									m.Translate(0,result)
									sc.transform = m
									sc.translated_y = result

									s.scrl_transform[s.selected] = m

									var/ratio = -1 + ((-227 + result) / -227)
									ratio = clamp(ratio,0,1)
									var/scroll_y = round(s.size*ratio)

									s.bar_pos_y[s.selected] = scroll_y

									if(s.selected == 1)
										for(var/obj/o in s.tech_holder_special.vis_contents)
											var/matrix/m2 = matrix()
											m2.Translate(o.hud_x-s.bar_pos_x_hori[s.selected],o.hud_y+s.bar_pos_y[s.selected])
											o.transform = m2
									else
										var/matrix/m2 = matrix()
										m2.Translate(s.tech_holder_special.hud_x-s.bar_pos_x_hori[s.selected],s.tech_holder_special.hud_y+s.bar_pos_y[s.selected])
										s.tech_holder_special.transform = m2

					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				tech_scroller_horizontal
					icon = 'new_hud_tech.dmi'
					icon_state = "tech scroller2"
					layer = 33
					plane = 34
					appearance_flags = KEEP_TOGETHER
					var/engineering_transform
					var/physics_transform
					var/genetics_transform
					var/engineering_x
					var/physics_x
					var/genetics_x
					MouseWheel()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
					MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
						/*
						.:NOTES:.
						- This one uses the x instead of the y.
						- IMPORTANT - scroll_x's first number is the total height of the inside area we want the bar/scroller to let us move up and down inside of.
						*/
						if(usr.hud_tech)
							if(src == usr.hud_tech.tech_tree_scroller2)
								var/obj/hud/menus/tech_background/s = usr.hud_tech
								var/obj/hud/menus/tech_background/tech_scroller_horizontal/sc = s.tech_tree_scroller2

								usr.check_mouse_loc(params)
								var/true_x = ((usr.mouse_x-1)*32)+usr.mouse_pix_x
								usr.mouse_x_true = true_x
								var/result = (usr.mouse_x_true-s.tech_background_x)-27
								result = clamp(result,0,237)
								var/matrix/m = matrix()
								m.Translate(result,0)
								sc.transform = m

								s.scrl_transform_hori[s.selected] = m

								var/ratio = 1 - ((235 - result) / 235)
								ratio = clamp(ratio,0,1)
								var/scroll_x = round(s.size*ratio)
								sc.translated_x = scroll_x

								s.bar_pos_x_hori[s.selected] = scroll_x

								if(s.selected == 1)
									for(var/obj/o in s.tech_holder_special.vis_contents)
										var/matrix/m2 = matrix()
										m2.Translate(o.hud_x-s.bar_pos_x_hori[s.selected],o.hud_y+s.bar_pos_y[s.selected])
										o.transform = m2
								else
									var/matrix/m2 = matrix()
									m2.Translate(s.tech_holder_special.hud_x-s.bar_pos_x_hori[s.selected],s.tech_holder_special.hud_y+s.bar_pos_y[s.selected])
									s.tech_holder_special.transform = m2

					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				tech_num_box
					icon = 'new_hud_tech.dmi'
					icon_state = "num"
					layer = 33
					plane = 34
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE
					mouse_opacity = 0
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
					MouseWheel()
						return
					Click()
						return
				tech_lvl_box
					icon = 'new_hud_tech.dmi'
					icon_state = "lvl"
					layer = 33
					plane = 34
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE
					mouse_opacity = 0
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
					MouseWheel()
						return
					Click()
						return
				tech_txt_scrollbar
					icon = 'new_hud_tech.dmi'
					icon_state = "txt scrollbar"
					layer = 33
					plane = 34
					appearance_flags = KEEP_TOGETHER
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
					MouseWheel(delta_x,delta_y,location,control,params)
						/*
						.:NOTES:.
						- 256 in the default example is the bar length/height.
						- 256 (bar length/height) is fine to use in var/result
						- Bar length - scroller length/height (usually 27) is the smaller number, in this case 227, which is used for clamping result and ratio
						- After subtracting the scroller length/height (usually 27) from the scrollbar, use it in clamping result and ratio.
						- IMPORTANT - scroll_y's first number is the total height of the inside area we want the bar/scroller to let us move up and down inside of.
						*/
						if(usr.hud_tech)
							if(usr.hud_tech.tech_txt_scrollbar)
								if(src == usr.hud_tech.tech_txt_scrollbar)
									var/obj/hud/menus/tech_background/s = usr.hud_tech
									var/obj/hud/menus/tech_background/tech_scroller/sc = s.tech_txt_scroller
									s.buttons = list(s.txt)
									var/tab = null
									var/yy = 0
									for(var/obj/hud/buttons/tabs/t in s.tabs)
										if(t.clicked)
											yy = t.max_y_txt
											if(t.type == /obj/hud/buttons/tabs/tech_build/tab1)
												tab = "Build"
												break
											else if(t.type == /obj/hud/buttons/tabs/tech_build/tab2)
												tab = "Engineering"
												break
											else if(t.type == /obj/hud/buttons/tabs/tech_build/tab3)
												tab = "Physics"
												break
											else if(t.type == /obj/hud/buttons/tabs/tech_build/tab4)
												tab = "Genetics"
												break

									usr.check_mouse_loc(params)
									params = params2list(params)
									var/wheel_move = 0
									if(delta_y > 0) wheel_move = 16
									else if(delta_y < 0) wheel_move = -16
									var/result = sc.translated_y+wheel_move
									result = clamp(result,0,-245)
									var/matrix/m = matrix()
									m.Translate(0,result)
									sc.transform = m
									var/ratio = -1 + ((-245 + result) / -245)
									ratio = clamp(ratio,0,1)
									var/scroll_y = round(yy*ratio)
									if(tab == "Engineering")
										sc.engineering_transform = result
										sc.engineering_y_txt = scroll_y
									else if(tab == "Physics")
										sc.physics_transform = result
										sc.physics_y_txt = scroll_y
									else if(tab == "Genetics")
										sc.genetics_transform = result
										sc.genetics_y_txt = scroll_y
									else if(tab == "Build") sc.build_transform = result
									sc.translated_y = result

									for(var/obj/o in s.buttons)
										var/matrix/m2 = matrix()
										m2.Translate(o.hud_x,o.hud_y+scroll_y)
										o.transform = m2
										o.shift_y = scroll_y
					Click(location,control,params)
						/*
						.:NOTES:.
						- 256 in the default example is the bar length/height.
						- 256 (bar length/height) is fine to use in var/result
						- Bar length - scroller length/height (usually 27) is the smaller number, in this case 227, which is used for clamping result and ratio
						- After subtracting the scroller length/height (usually 27) from the scrollbar, use it in clamping result and ratio.
						- IMPORTANT - scroll_y's first number is the total height of the inside area we want the bar/scroller to let us move up and down inside of.
						*/
						if(usr.hud_tech)
							if(usr.hud_tech.tech_txt_scrollbar)
								if(src == usr.hud_tech.tech_txt_scrollbar)
									var/obj/hud/menus/tech_background/s = usr.hud_tech
									var/obj/hud/menus/tech_background/tech_scroller/sc = s.tech_txt_scroller
									var/tab = null
									s.buttons = list(s.txt)
									var/yy = 0
									for(var/obj/hud/buttons/tabs/t in s.tabs)
										if(t.clicked)
											yy = t.max_y_txt
											if(t.type == /obj/hud/buttons/tabs/tech_build/tab1)
												tab = "Build"
												break
											else if(t.type == /obj/hud/buttons/tabs/tech_build/tab2)
												tab = "Engineering"
												break
											else if(t.type == /obj/hud/buttons/tabs/tech_build/tab3)
												tab = "Physics"
												break
											else if(t.type == /obj/hud/buttons/tabs/tech_build/tab4)
												tab = "Genetics"
												break

									usr.check_mouse_loc(params)
									var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
									usr.mouse_y_true = true_y
									var/result = -272 + ((usr.mouse_y_true-s.tech_background_y)-54) //54 is the size of the scroller x 2 (basically its height in pixels).
									result = clamp(result,0,-245)
									var/matrix/m = matrix()
									m.Translate(0,result)
									sc.transform = m
									var/ratio = -1 + ((-245 + result) / -245)
									ratio = clamp(ratio,0,1)
									var/scroll_y = round(yy*ratio)
									sc.translated_y = result
									if(tab == "Engineering")
										sc.engineering_transform = result
										sc.engineering_y_txt = scroll_y
									else if(tab == "Physics")
										sc.physics_transform = result
										sc.physics_y_txt = scroll_y
									else if(tab == "Genetics")
										sc.genetics_transform = result
										sc.genetics_y_txt = scroll_y
									else if(tab == "Build") sc.build_transform = result

									for(var/obj/o in s.buttons)
										var/matrix/m2 = matrix()
										m2.Translate(o.hud_x,o.hud_y+scroll_y)
										o.transform = m2
										o.shift_y = scroll_y
				tech_create_number
					icon = 'new_hud_tech.dmi'
					icon_state = "create number"
					layer = 33
					plane = 34
					appearance_flags = KEEP_TOGETHER
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
					MouseWheel()
						return
					Click(location,control,params)
						if(usr.hud_tech && usr.hud_tech.bar_tech_make && src == usr.hud_tech.bar_tech_make)
							if(usr.hud_tech.slider_make)
								usr.check_mouse_loc(params)
								usr.client.MousePosition(params)
								params = params2list(params)
								var/icon_x = text2num(params["icon-x"])
								usr.hud_tech.x_start = usr.client.client_mouse_x-icon_x

								var/obj/hud/menus/tech_background/s = usr.hud_tech
								var/matrix/m = matrix()
								icon_x = icon_x-2
								icon_x = clamp(icon_x,-2,277)
								m.Translate(icon_x,15)
								s.slider_make.transform = m
								s.num_to_make = round((icon_x/2)-39)
								if(usr.build_tech_selected)
									var/obj/items/t = usr.build_tech_selected
									if(t.stacks > -1)
										//usr.hud_tech.set_tech_desc(usr,t)
										usr.hud_tech.show_tech_costs(usr,t)
										s.tech_make.maptext = "[css_outline]<font size = 1><center>[s.num_to_make]"
									else s.tech_make.maptext = "[css_outline]<font size = 1><center>1"
								else
									s.tech_make.maptext = "[css_outline]<font size = 1><center>1"
									s.num_to_make = 1

								var/true_x = ((usr.mouse_x-1)*32)+usr.mouse_pix_x
								s.slider_make.x_start = true_x-icon_x
				tech_lvl_number
					icon = 'new_hud_tech.dmi'
					icon_state = "tech number"
					layer = 33
					plane = 34
					appearance_flags = KEEP_TOGETHER
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
					MouseWheel()
						return
					Click(location,control,params)
						if(usr.hud_tech && usr.hud_tech.bar_tech_num && src == usr.hud_tech.bar_tech_num)
							if(usr.hud_tech.slider_lvl)
								var/obj/hud/menus/tech_background/s = usr.hud_tech
								if(usr.build_tech_selected)
									var/obj/items/t = usr.build_tech_selected
									usr.check_mouse_loc(params)
									var/true_x = ((usr.mouse_x-1)*32)+usr.mouse_pix_x //The -1 accounts for Byonds fuckery with the x pos always starting at 1, which would be 32 pixels across, instead of 0.
									usr.mouse_x_true = true_x
									var/result = usr.mouse_x_true-s.tech_background_x
									result = clamp(result,80,277)
									var/matrix/m = matrix()
									m.Translate(result,s.slider_lvl.hud_y)
									s.slider_lvl.transform = m
									var/range = 277 - 80  // Total slider range
									var/per = ((result - 80) / range)  // Percentage of slider progression (0 to 1)
									var/max_tech_level = max(1, (round(usr.intxp*10000,0.01))/round(10000,0.01))  // Ensure minimum of 1
									var/N = round(per * max_tech_level)  // Calculate tech level within player's range

									if(t.tech_parent_path)
										//world << "DEBUG - found t = [t], with a tech_parent_path of [t.tech_parent_path]"
										for(var/obj/items/tech/t2 in global.tech)//usr.technology_researched)
											if(usr.tech_unlocked[t2.list_pos] == t2.type)
												if(t2.type == t.tech_parent_path)
													//world << "DEBUG - found t2 = [t2]"
												//	var/range = 80-277
												//	var/per = ((result - 80) / range) * 100
													per = abs(round(per))
												//	var/N = round((per/100)*t2.tech_lvl)
													N = clamp(N, 1, max_tech_level)
													s.tech_num.maptext = "[css_outline]<font size = 1><center>[N]"
													s.lvl_to_make = N
													break
									else
										//world << "DEBUG - wasn't able to find a tech_parent_path for [t] "

										per = abs(round(per))
										N = clamp(N, 1, max_tech_level)
										s.tech_num.maptext = "[css_outline]<font size = 1><center>[N]"
										s.lvl_to_make = N
				tech_scrollbar
					icon = 'new_hud_tech.dmi'
					icon_state = "tech scrollbar"
					layer = 33
					plane = 34
					appearance_flags = KEEP_TOGETHER
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
					MouseWheel(delta_x,delta_y,location,control,params)
						/*
						.:NOTES:.
						- 256 in the default example is the bar length/height.
						- 256 (bar length/height) is fine to use in var/result
						- Bar length - scroller length/height (usually 27) is the smaller number, in this case 227, which is used for clamping result and ratio
						- After subtracting the scroller length/height (usually 27) from the scrollbar, use it in clamping result and ratio.
						- IMPORTANT - scroll_y's first number is the total height of the inside area we want the bar/scroller to let us move up and down inside of.
						*/
						if(usr.hud_tech)
							if(usr.hud_tech.tech_tree_scrollbar1)
								if(src == usr.hud_tech.tech_tree_scrollbar1)
									//--------------------------------------------------------------------------------------------------------------------------------
									var/obj/hud/menus/tech_background/s = src.menu
									var/obj/sc = s.tech_tree_scroller1
									usr.check_mouse_loc(params)
									var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
									usr.mouse_y_true = true_y
									var/wheel_move = 0
									if(delta_y > 0) wheel_move = 16
									else if(delta_y < 0) wheel_move = -16
									var/result = sc.translated_y+wheel_move
									result = clamp(result,0,-227)
									var/matrix/m = matrix()
									m.Translate(0,result)
									sc.transform = m
									sc.translated_y = result

									s.scrl_transform[s.selected] = m

									var/ratio = -1 + ((-227 + result) / -227)
									ratio = clamp(ratio,0,1)
									var/scroll_y = round(s.size*ratio)

									s.bar_pos_y[s.selected] = scroll_y

									if(s.selected == 1)
										for(var/obj/o in s.tech_holder_special.vis_contents)
											var/matrix/m2 = matrix()
											m2.Translate(o.hud_x-s.bar_pos_x_hori[s.selected],o.hud_y+s.bar_pos_y[s.selected])
											o.transform = m2
									else
										var/matrix/m2 = matrix()
										m2.Translate(s.tech_holder_special.hud_x-s.bar_pos_x_hori[s.selected],s.tech_holder_special.hud_y+s.bar_pos_y[s.selected])
										s.tech_holder_special.transform = m2
					Click(location,control,params)
						/*
						.:NOTES:.
						- 256 in the default example is the bar length/height.
						- 256 (bar length/height) is fine to use in var/result
						- Bar length - scroller length/height (usually 27) is the smaller number, in this case 227, which is used for clamping result and ratio
						- After subtracting the scroller length/height (usually 27) from the scrollbar, use it in clamping result and ratio.
						- IMPORTANT - scroll_y's first number is the total height of the inside area we want the bar/scroller to let us move up and down inside of.
						*/
						if(usr.hud_tech)
							if(usr.hud_tech.tech_tree_scrollbar1)
								if(src == usr.hud_tech.tech_tree_scrollbar1)
									//--------------------------------------------------------------------------------
									var/obj/hud/menus/tech_background/s = src.menu
									var/obj/sc = s.tech_tree_scroller1
									usr.check_mouse_loc(params)
									var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
									usr.mouse_y_true = true_y
									var/result = -256 + ((usr.mouse_y_true-s.tech_background_y)-54)
									result = clamp(result,0,-227)
									var/matrix/m = matrix()
									m.Translate(0,result)
									sc.transform = m
									sc.translated_y = result

									s.scrl_transform[s.selected] = m

									var/ratio = -1 + ((-227 + result) / -227)
									ratio = clamp(ratio,0,1)
									var/scroll_y = round(s.size*ratio)

									s.bar_pos_y[s.selected] = scroll_y

									if(s.selected == 1)
										for(var/obj/o in s.tech_holder_special.vis_contents)
											var/matrix/m2 = matrix()
											m2.Translate(o.hud_x-s.bar_pos_x_hori[s.selected],o.hud_y+s.bar_pos_y[s.selected])
											o.transform = m2
									else
										var/matrix/m2 = matrix()
										m2.Translate(s.tech_holder_special.hud_x-s.bar_pos_x_hori[s.selected],s.tech_holder_special.hud_y+s.bar_pos_y[s.selected])
										s.tech_holder_special.transform = m2
				tech_edge
					icon = 'new_hud_tech.dmi'
					icon_state = "tech2 edge"
					layer = 33
					plane = 34
					appearance_flags = KEEP_TOGETHER
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
					MouseWheel()
						return
					Click()
						return
				tech_scrollbar_horizontal
					icon = 'new_hud_tech.dmi'
					icon_state = "tech scrollbar2"
					layer = 33
					plane = 34
					appearance_flags = KEEP_TOGETHER
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
					MouseWheel()
						return
					Click(location,control,params)
						/*
						.:NOTES:.
						- This one uses the x instead of the y.
						- IMPORTANT - scroll_x's first number is the total height of the inside area we want the bar/scroller to let us move up and down inside of.
						*/
						if(usr.hud_tech)
							if(src == usr.hud_tech.tech_tree_scrollbar2)
								var/obj/hud/menus/tech_background/s = usr.hud_tech
								var/obj/hud/menus/tech_background/tech_scroller_horizontal/sc = s.tech_tree_scroller2

								usr.check_mouse_loc(params)
								var/true_x = ((usr.mouse_x-1)*32)+usr.mouse_pix_x
								usr.mouse_x_true = true_x
								var/result = (usr.mouse_x_true-s.tech_background_x)-27
								result = clamp(result,0,237)
								var/matrix/m = matrix()
								m.Translate(result,0)
								sc.transform = m

								s.scrl_transform_hori[s.selected] = m

								var/ratio = 1 - ((235 - result) / 235)
								ratio = clamp(ratio,0,1)
								var/scroll_x = round(s.size*ratio)
								sc.translated_x = scroll_x

								s.bar_pos_x_hori[s.selected] = scroll_x

								if(s.selected == 1)
									for(var/obj/o in s.tech_holder_special.vis_contents)
										var/matrix/m2 = matrix()
										m2.Translate(o.hud_x-s.bar_pos_x_hori[s.selected],o.hud_y+s.bar_pos_y[s.selected])
										o.transform = m2
								else
									var/matrix/m2 = matrix()
									m2.Translate(s.tech_holder_special.hud_x-s.bar_pos_x_hori[s.selected],s.tech_holder_special.hud_y+s.bar_pos_y[s.selected])
									s.tech_holder_special.transform = m2
				tech_txt_holder
					icon = 'new_hud_tech.dmi'
					icon_state = "txt"
					layer = 33
					plane = 34
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE// | TILE_BOUND
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
					MouseWheel(delta_x,delta_y,location,control,params)
						/*
						.:NOTES:.
						- 256 in the default example is the bar length/height.
						- 256 (bar length/height) is fine to use in var/result
						- Bar length - scroller length/height (usually 27) is the smaller number, in this case 227, which is used for clamping result and ratio
						- After subtracting the scroller length/height (usually 27) from the scrollbar, use it in clamping result and ratio.
						- IMPORTANT - scroll_y's first number is the total height of the inside area we want the bar/scroller to let us move up and down inside of.
						*/
						if(usr.hud_tech)
							if(usr.hud_tech.txt_holder)
								if(src == usr.hud_tech.txt_holder)
									var/obj/hud/menus/tech_background/s = usr.hud_tech
									var/obj/hud/menus/tech_background/tech_scroller/sc = s.tech_txt_scroller
									s.buttons = list(s.txt)
									var/yy = 0
									for(var/obj/hud/buttons/tabs/t in s.tabs)
										if(t.clicked)
											yy = t.max_y_txt
											break

									usr.check_mouse_loc(params)
									params = params2list(params)
									var/wheel_move = 0
									if(delta_y > 0) wheel_move = 16
									else if(delta_y < 0) wheel_move = -16
									var/result = sc.translated_y+wheel_move
									result = clamp(result,0,-245)
									var/matrix/m = matrix()
									m.Translate(0,result)
									sc.transform = m
									var/ratio = -1 + ((-245 + result) / -245)
									ratio = clamp(ratio,0,1)
									var/scroll_y = round(yy*ratio)
									sc.translated_y = result

									for(var/obj/o in s.buttons)
										var/matrix/m2 = matrix()
										m2.Translate(o.hud_x,o.hud_y+scroll_y)
										o.transform = m2
										o.shift_y = scroll_y
				tech_txt_desc
					icon = null
					maptext_width = 144
					maptext_height = 1080
					plane = 34
					layer = 34
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				tech_holder_special
					icon = 'holder_skills.dmi'
					layer = 33
					plane = 34
					hud_x = 12
					hud_y = -374
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseWheel(delta_x,delta_y,location,control,params)
						/*
						.:NOTES:.
						- 256 in the default example is the bar length/height.
						- 256 (bar length/height) is fine to use in var/result
						- Bar length - scroller length/height (usually 27) is the smaller number, in this case 227, which is used for clamping result and ratio
						- After subtracting the scroller length/height (usually 27) from the scrollbar, use it in clamping result and ratio.
						- IMPORTANT - scroll_y's first number is the total height of the inside area we want the bar/scroller to let us move up and down inside of.
						*/
						if(usr.hud_tech)
							if(usr.hud_tech.tech_tree_scrollbar1)
								if(src == usr.hud_tech.tech_holder_special)
									//--------------------------------------------------------------------------------------------------------------------------------
									var/obj/hud/menus/tech_background/s = src.menu
									var/obj/sc = s.tech_tree_scroller1
									usr.check_mouse_loc(params)
									var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
									usr.mouse_y_true = true_y
									var/wheel_move = 0
									if(delta_y > 0) wheel_move = 16
									else if(delta_y < 0) wheel_move = -16
									var/result = sc.translated_y+wheel_move
									result = clamp(result,0,-227)
									var/matrix/m = matrix()
									m.Translate(0,result)
									sc.transform = m
									sc.translated_y = result

									s.scrl_transform[s.selected] = m

									var/ratio = -1 + ((-227 + result) / -227)
									ratio = clamp(ratio,0,1)
									var/scroll_y = round(s.size*ratio)

									s.bar_pos_y[s.selected] = scroll_y

									if(s.selected == 1)
										for(var/obj/o in s.tech_holder_special.vis_contents)
											var/matrix/m2 = matrix()
											m2.Translate(o.hud_x-s.bar_pos_x_hori[s.selected],o.hud_y+s.bar_pos_y[s.selected])
											o.transform = m2
									else
										var/matrix/m2 = matrix()
										m2.Translate(s.tech_holder_special.hud_x-s.bar_pos_x_hori[s.selected],s.tech_holder_special.hud_y+s.bar_pos_y[s.selected])
										s.tech_holder_special.transform = m2
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				tech_holder
					icon = 'new_hud_tech.dmi'
					icon_state = "tech"
					layer = 33
					plane = 34
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
			inventory_background
				icon = 'new_hud_inven.dmi'
				icon_state = "txt holder"
				layer = 33
				screen_loc = "1,1"
				plane = 30
				var/xx = 0
				var/ww = 0
				var/hh = 0
				var/icon/I
				var/obj/txt_holder = null
				var/obj/title = null
				var/obj/hud/menus/inventory_background/inv_button_drop_Zenni/rsc = null
				var/obj/rsc2 = null
				var/obj/rsc2num = null
				var/obj/item_name = null
				var/obj/item_desc = null
				var/obj/scrollbar = null
				var/obj/button_use = null
				var/obj/button_drop = null
				var/obj/stone_num
				var/obj/silver_num
				var/obj/copper_num
				var/obj/coal_num
				var/obj/gold_num
				var/obj/myst_num
				var/obj/titanium_num

				var/obj/hud/menus/inventory_background/inv_scroller/scroller = null
				//var/y_start = 0
				var/y_stop = 0
				var/setup = 0
				var/txt_x = 0
				var/txt_y = 0
				/*
				Need to change the scrollbar later to be more like the other menus
				Doesn't seem to have a inv_x/y var?
				MouseDrag() seems to relocate the scroller too?
				*/
				proc
					update_rsc(var/mob/m)
						src.rsc.maptext = "[css_outline]<font size = 1><text align=left valign=bottom>Zenni: ¥[CommasADV(m.resources)]"
						//src.rsc2.maptext = "[css_outline]<font size = 1><text align=left valign=top>Quality % Points: [Commas(m.intel_points)]"
					menu_create()
						if(src.setup) return
						src.I = new(src.icon)
						src.ww = I.Width()
						src.hh = I.Height()

						//src.xx = 10
						//src.yy = hh-72

						var/obj/hud/buttons/close_menu/cm = new
						cm.plane = src.plane
						cm.closes = src
						var/matrix/close_m = matrix()
						close_m.Translate(ww-15,hh-15)
						cm.transform = close_m
						src.vis_contents += cm

						var/obj/title1 = new
						title1.maptext_width = 320
						title1.maptext_height = 16
						title1.maptext = "[css_outline]<font size = 1><text align=left valign=top>Inventory"
						title1.layer = 34
						title1.plane = 30
						title1.appearance_flags = PIXEL_SCALE
						var/matrix/m2 = matrix()
						m2.Translate(round(8),hh-37)
						title1.transform = m2
						title1.screen_loc = src.screen_loc
						src.vis_contents += title1
						src.title = title1

						// ---- STONE ----
						var/obj/hud/mineral_icon/stone = new
						stone.icon = 'Mineral Rocks.dmi'
						stone.icon_state = "stone"
						stone.mineral_type = "stone"

						var/matrix/ms = matrix()
						ms.Translate(60, hh-30)

						stone.transform = ms
						stone.screen_loc = src.screen_loc
						src.vis_contents += stone

						var/obj/stone_num = new
						stone_num.layer = 34
						stone_num.plane = 30
						stone_num.tag = "stone_num"
						stone_num.maptext_width = 80
						stone_num.maptext_height = 16
						src.stone_num = stone_num
						stone_num.maptext = "[css_outline]<font size=1>0" //[usr.stone_count]"

						var/matrix/ms2 = matrix()
						ms2.Translate(80, hh-30)
						stone_num.transform = ms2
						stone_num.screen_loc = src.screen_loc
						src.vis_contents += stone_num


						// ---- SILVER ----
						var/obj/hud/mineral_icon/silver = new
						silver.icon = 'Mineral Rocks.dmi'
						silver.icon_state = "silver"
						silver.mineral_type = "silver"


						var/matrix/ms3 = matrix()
						ms3.Translate(110, hh-30)


						silver.transform = ms3
						silver.screen_loc = src.screen_loc
						src.vis_contents += silver

						var/obj/silver_num = new
						silver_num.layer = 34
						silver_num.plane = 30
						silver_num.tag = "silver_num"
						src.silver_num = silver_num
						silver_num.maptext_width = 80
						silver_num.maptext_height = 16
						silver_num.maptext = "[css_outline]<font size=1>0"//[usr.silver_count]"

						var/matrix/ms4 = matrix()
						ms4.Translate(125, hh-30)
						silver_num.transform = ms4
						silver_num.screen_loc = src.screen_loc
						src.vis_contents += silver_num


						// ---- COPPER ----
						var/obj/hud/mineral_icon/copper = new
						copper.icon = 'Mineral Rocks.dmi'
						copper.icon_state = "copper"
						copper.mineral_type = "copper"

						var/matrix/ms5 = matrix()
						ms5.Translate(160, hh-30)


						copper.transform = ms5
						copper.screen_loc = src.screen_loc
						src.vis_contents += copper

						var/obj/copper_num = new
						copper_num.layer = 34
						copper_num.plane = 30
						copper_num.maptext_width = 80
						copper_num.maptext_height = 16
						copper_num.tag = "copper_num"
						src.copper_num = copper_num
						copper_num.maptext = "[css_outline]<font size=1>0"//[usr.copper_count]"

						var/matrix/ms6 = matrix()
						ms6.Translate(170, hh-30)
						copper_num.transform = ms6
						copper_num.screen_loc = src.screen_loc
						src.vis_contents += copper_num


						// ---- COAL ----
						var/obj/hud/mineral_icon/coal = new
						coal.icon = 'Mineral Rocks.dmi'
						coal.icon_state = "coal"
						coal.mineral_type = "coal"

						var/matrix/ms7 = matrix()
						ms7.Translate(205, hh-30)


						coal.transform = ms7
						coal.screen_loc = src.screen_loc
						src.vis_contents += coal

						var/obj/coal_num = new
						coal_num.layer = 34
						coal_num.plane = 30
						coal_num.maptext_width = 80
						coal_num.maptext_height = 16
						coal_num.tag = "coal_num"
						src.coal_num = coal_num
						coal_num.maptext = "[css_outline]<font size=1>0"//[usr.coal_count]"

						var/matrix/ms8 = matrix()
						ms8.Translate(215, hh-30)
						coal_num.transform = ms8
						coal_num.screen_loc = src.screen_loc
						src.vis_contents += coal_num


						// ---- GOLD ----
						var/obj/hud/mineral_icon/gold = new
						gold.icon = 'Mineral Rocks.dmi'
						gold.icon_state = "gold"
						gold.mineral_type = "gold"

						var/matrix/ms9 = matrix()
						ms9.Translate(250, hh-30)


						gold.transform = ms9
						gold.screen_loc = src.screen_loc
						src.vis_contents += gold

						var/obj/gold_num = new
						gold_num.layer = 34
						gold_num.plane = 30
						gold_num.maptext_width = 80
						gold_num.maptext_height = 16
						gold_num.tag = "gold_num"
						src.gold_num = gold_num
						gold_num.maptext = "[css_outline]<font size=1>0"//[usr.gold_count]"

						var/matrix/ms10 = matrix()
						ms10.Translate(260, hh-30)
						gold_num.transform = ms10
						gold_num.screen_loc = src.screen_loc
						src.vis_contents += gold_num


						// ---- MYSTILLE ----
						var/obj/hud/mineral_icon/myst = new
						myst.icon = 'Mineral Rocks.dmi'
						myst.icon_state = "mystille"
						myst.mineral_type = "mystille"

						var/matrix/ms11 = matrix()
						ms11.Translate(295, hh-30)


						myst.transform = ms11
						myst.screen_loc = src.screen_loc
						src.vis_contents += myst

						var/obj/myst_num = new
						myst_num.layer = 34
						myst_num.plane = 30
						myst_num.maptext_width = 80
						myst_num.maptext_height = 16
						myst_num.tag = "myst_num"
						src.myst_num = myst_num
						myst_num.maptext = "[css_outline]<font size=1>0"//[usr.mystille_count]"

						var/matrix/ms12 = matrix()
						ms12.Translate(305, hh-30)
						myst_num.transform = ms12
						myst_num.screen_loc = src.screen_loc
						src.vis_contents += myst_num


						// ---- TITANIUM ----
						var/obj/hud/mineral_icon/titanium = new
						titanium.icon = 'Mineral Rocks.dmi'
						titanium.icon_state = "titanium"
						titanium.mineral_type = "titanium"

						var/matrix/ms13 = matrix()
						ms13.Translate(340, hh-30)


						titanium.transform = ms13
						titanium.screen_loc = src.screen_loc
						src.vis_contents += titanium

						var/obj/titanium_num = new
						titanium_num.layer = 34
						titanium_num.plane = 30
						titanium_num.maptext_width = 80
						titanium_num.maptext_height = 16
						titanium_num.tag = "titanium_num"
						src.titanium_num = titanium_num
						titanium_num.maptext = "[css_outline]<font size=1>0"//[usr.titanium_count]"

						var/matrix/ms14 = matrix()
						ms14.Translate(350, hh-30)
						titanium_num.transform = ms14
						titanium_num.screen_loc = src.screen_loc
						src.vis_contents += titanium_num

						var/obj/hud/menus/inventory_background/inv_button_drop_Zenni/title2 = new
						title2.maptext_width = 400
						title2.maptext_height = 16
						title2.maptext = "[css_outline]<font size = 1><text align=left valign=top>Zenni: 0"
						title2.layer = 34
						title2.plane = 30
						title2.appearance_flags = PIXEL_SCALE
						var/matrix/m_rsc = matrix()
						m_rsc.Translate(124,4)
						title2.transform = m_rsc
						title2.screen_loc = src.screen_loc
						src.vis_contents += title2
						src.rsc = title2

						/*var/obj/title2 = new
						title2.maptext_width = 400
						title2.maptext_height = 16
						title2.maptext = "[css_outline]<font size = 1><text align=left valign=top>Zenni: 0"
						title2.layer = 34
						title2.plane = 30
						title2.appearance_flags = PIXEL_SCALE
						var/matrix/m_rsc = matrix()
						m_rsc.Translate(124,4)
						title2.transform = m_rsc
						title2.screen_loc = src.screen_loc
						src.vis_contents += title2
						src.rsc = title2 */

						var/obj/hud/menus/inventory_background/inv_txt_holder/txt1 = new
						src.vis_contents += txt1
						src.txt_holder = txt1

						var/obj/hud/menus/inventory_background/inv_txt/txt_actual = new
						var/matrix/m4 = matrix()
						txt_actual.hud_x = round(ww-170)
						txt_actual.hud_y = -794
						//src.txt_x = round(ww-170)
						//src.txt_y = -794
						m4.Translate(txt_actual.hud_x,txt_actual.hud_y)
						txt_actual.transform = m4
						txt1.vis_contents += txt_actual
						src.item_desc = txt_actual

						var/obj/hud/menus/inventory_background/inv_scrollbar/bar1 = new
						src.vis_contents += bar1
						src.scrollbar = bar1

						var/obj/hud/menus/inventory_background/inv_scroller/bar2 = new
						src.vis_contents += bar2
						src.scroller = bar2

						var/obj/hud/menus/inventory_background/inv_button_use/but1 = new
						var/matrix/m5 = matrix()
						m5.Translate(9,3)
						but1.transform = m5
						src.vis_contents += but1
						src.button_use = but1

						var/obj/hud/menus/inventory_background/inv_button_drop/but2 = new
						var/matrix/m6 = matrix()
						m6.Translate(65,3)
						but2.transform = m6
						src.vis_contents += but2
						src.button_drop = but2
				MouseWheel(delta_x,delta_y,location,control,params)
					params = params2list(params)
					usr.text_y(usr.hud_inv.scroller.icon_y_saved,254,254,delta_y,"clicked",16,list(usr.hud_inv.item_desc),usr.hud_inv.scroller,270,usr.hud_inv.txt_x,usr.hud_inv.txt_y,27)
				MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
					params = params2list(params)
					var/icon_y = text2num(params["icon-y"])
					if(icon_y >= 314 || usr.mouse_down)
						usr.client.MousePosition(params)
						var/matrix/m = matrix()
						var/icon_x = text2num(params["icon-x"])
						if(usr.drag_icon_x == 0) usr.drag_icon_x = icon_x
						var/x_result = usr.client.client_mouse_x-usr.drag_icon_x
						var/y_result = usr.client.client_mouse_y-src.hh
						x_result = clamp(x_result,0,1023-src.ww)
						y_result = clamp(y_result,0,575-(src.hh/2))
						m.Translate(x_result,y_result)
						src.transform = m
						usr.mouse_down = src

						if(src.scroller)
							usr.check_mouse_loc(params)
							src.scroller.y_start = (usr.client.client_mouse_y-328)//328 derived from bar length(284) + excess pixels above 284 (44) (Basically the height of the menu, 328)
							src.scroller.y_start = clamp(src.scroller.y_start,0,254) //Stops the mouse_y being too high or low and messing with numbers
							src.scroller.transform = null
							src.scroller.translated_y = 0
							src.scroller.icon_y_saved = 270
							var/matrix/m1 = matrix()
							m1.Translate(src.item_desc.hud_x,src.item_desc.hud_y)
							src.item_desc.transform = m1
				/*
				MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
					usr.client.MousePosition(params)
					var/matrix/m = matrix()
					var/x_result = usr.client.client_mouse_x-(src.ww/2)
					var/y_result = usr.client.client_mouse_y-src.hh
					x_result = clamp(x_result,0,1023-src.ww)
					y_result = clamp(y_result,0,575-(src.hh/2))
					//src.xx = x_result
					//src.yy = y_result
					m.Translate(x_result,y_result)
					src.transform = m

					if(src.scroller)
						usr.check_mouse_loc(params)
						src.scroller.y_start = (usr.client.client_mouse_y-328)//328 derived from bar length(284) + excess pixels above 284 (44) (Basically the height of the menu, 328)
						src.scroller.y_start = clamp(src.scroller.y_start,0,254) //Stops the mouse_y being too high or low and messing with numbers
						src.scroller.transform = null
						src.scroller.translated_y = 0
						src.scroller.icon_y_saved = 270
						var/matrix/m1 = matrix()
						m1.Translate(src.item_desc.hud_x,src.item_desc.hud_y)
						src.item_desc.transform = m1
				*/
				inv_scrollbar
					icon = 'new_hud_inven.dmi'
					icon_state = "scrollbar"
					layer = 33
					plane = 30
					appearance_flags = KEEP_TOGETHER
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
					MouseWheel(delta_x,delta_y,location,control,params)
						params = params2list(params)
						usr.text_y(usr.hud_inv.scroller.icon_y_saved,254,254,delta_y,"clicked",16,list(usr.hud_inv.item_desc),usr.hud_inv.scroller,270,usr.hud_inv.txt_x,usr.hud_inv.txt_y,27)
					Click(location,control,params)
						if(usr.hud_inv)
							if(usr.hud_inv.scrollbar && src == usr.hud_inv.scrollbar)
								usr.check_mouse_loc(params)
								usr.client.MousePosition(params)
								params = params2list(params)
								var/icon_y = text2num(params["icon-y"])
								usr.hud_inv.y_start = usr.client.client_mouse_y-icon_y
								usr.text_y(icon_y,254,254,0,"clicked",16,list(usr.hud_inv.item_desc),usr.hud_inv.scroller,270,usr.hud_inv.txt_x,usr.hud_inv.txt_y,27)
								if(usr.hud_inv.scroller)
									var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y //The -1 accounts for Byonds fuckery with the y pos always starting at 1, which would be 32 pixels up, instead of 0.
									usr.hud_inv.scroller.y_start = true_y-icon_y
				inv_button_drop
					icon = 'new_hud_inv_buttons.dmi'
					icon_state = "exit"
					maptext_height = 16
					maptext_width = 52
					maptext_y = 3
					layer = 33
					plane = 30
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE
					MouseEntered(location,control,params)
						src.icon_state = "enter"
					MouseExited(location,control,params)
						src.icon_state = "exit"
					Click()
						if(usr.hud_inv && src == usr.hud_inv.button_drop)
							if(usr.item_selected)
								var/obj/I = usr.item_selected
								if(usr.accessing && I.loc == usr.accessing)
									//usr.accessing.drop(I)
									if(I.act_drop)
										call(I.act_drop)(usr,I)
									else usr.accessing.drop(I)
					MouseWheel()
						return
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						src.maptext = "[css_outline]<font size = 1><center>Drop"
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				inv_button_drop_Zenni
					icon = 'new_hud_drop_inv_button.dmi'
					icon_state = "exit"
					maptext_height = 16
					maptext_width = 65
					maptext_y = 1
					maptext_x = 4
					layer = 33
					plane = 30
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE
					MouseEntered(location,control,params)
						src.icon_state = "enter"
					MouseExited(location,control,params)
						src.icon_state = "exit"
					Click()
						usr.hud_inv.update_rsc(usr)
						usr.refresh_inv()
						if(usr.hud_inv && usr.resources > 0)
							var/Money = input("How much zenni are you dropping?") as num
							if(Money<0) return
							if(Money>usr.resources)
								usr<<"You do not have that amount."
								return
							if(Money>=1 && usr.resources>=Money)
								Money=round(Money)

								var/obj/items/Money/A=new
								A.stacks=Money
								A.name="¥[Commas(A.stacks)] Zenni"
								A.loc = usr.loc
								A.step_x = usr.step_x
								A.step_y = usr.step_y
								//A.set_shadow()
								view(usr)<<output("<font color=white>[usr] drops ¥[Commas(Money)] zenni.","actionoutput")
								usr.resources-=Money
								usr.refresh_inv()
								//usr.drop(A)
								if(A.stacks<100) A.icon_state="Zenni1"
								else if(A.stacks<200) A.icon_state="Zenni2"
								else if(A.stacks<500) A.icon_state="Zenni3"
								else if(A.stacks<1000) A.icon_state="Zenni4"
								else
									A.icon_state="Zenni4"
									var/Size=round(A.stacks/2000)
									var/Offset=10+round(A.stacks/8000)
									if(Size>50) Size=50
									if(Offset>30) Offset=30
									while(Size&&src)
										Size-=1
										var/image/I=image(icon='Misc.dmi',icon_state="Zenni4",pixel_y=rand(-Offset,Offset),pixel_x=rand(-Offset,Offset))
										if(A) A.underlays.Add(I)
										//sleep(1)





					MouseWheel()
						return
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						src.maptext = "[css_outline]<font size = 1><center>Zenni:"
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				inv_button_use
					icon = 'new_hud_inv_buttons.dmi'
					icon_state = "exit"
					maptext_height = 16
					maptext_width = 52
					maptext_y = 3
					layer = 33
					plane = 30
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE
					MouseEntered(location,control,params)
						src.icon_state = "enter"
					MouseExited(location,control,params)
						src.icon_state = "exit"
					Click()
						if(usr.hud_inv && src == usr.hud_inv.button_use)
							if(usr.item_selected)
								var/obj/I = usr.item_selected
								if(I.loc == usr)
									if(I.act)
										call(I.act)(usr,I)
					MouseWheel()
						return
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						src.maptext = "[css_outline]<font size = 1><center>Use"
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.

				inv_scroller
					icon = 'new_hud_inven.dmi'
					icon_state = "scroller"
					layer = 33
					plane = 30
					//mouse_opacity = 0
					appearance_flags = KEEP_TOGETHER
					MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y //The -1 accounts for Byonds fuckery with the y pos always starting at 1, which would be 32 pixels up, instead of 0.
						var/cut = true_y-src.y_start
						usr.text_y(cut,254,254,0,"clicked",16,list(usr.hud_inv.item_desc),usr.hud_inv.scroller,270,usr.hud_inv.txt_x,usr.hud_inv.txt_y,27)
						usr.mouse_y_true = true_y

					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				inv_txt_holder
					icon = 'new_hud_inven.dmi'
					icon_state = "txt"
					layer = 33
					plane = 30
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseWheel(delta_x,delta_y,location,control,params)
						params = params2list(params)
						usr.text_y(usr.hud_inv.scroller.icon_y_saved,254,254,delta_y,"clicked",16,list(usr.hud_inv.item_desc),usr.hud_inv.scroller,270,usr.hud_inv.txt_x,usr.hud_inv.txt_y,27)
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				inv_txt
					maptext_width = 144
					maptext_height = 1080
					plane = 30
					layer = 34
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.

			shopkeeper_inventory_background
				icon = 'new_hud_inven.dmi'
				icon_state = "txt holder"
				layer = 33
				screen_loc = "1,1"
				plane = 30
				var/xx = 0
				var/ww = 0
				var/hh = 0
				var/icon/I
				var/obj/txt_holder = null
				var/obj/title = null
				var/obj/hud/menus/shopkeeper_inventory_background/inv_button_drop_Zenni/rsc = null
				var/obj/rsc2 = null
				var/obj/rsc2num = null
				var/obj/item_name = null
				var/obj/item_desc = null
				var/obj/scrollbar = null
				var/obj/button_use = null
				var/obj/button_drop = null
				var/obj/hud/menus/shopkeeper_inventory_background/inv_scroller/scroller = null
				var/mob/shopper = null
				//var/y_start = 0
				var/y_stop = 0
				var/setup = 0
				var/txt_x = 0
				var/txt_y = 0
				/*
				Need to change the scrollbar later to be more like the other menus
				Doesn't seem to have a inv_x/y var?
				MouseDrag() seems to relocate the scroller too?
				*/
				proc
					update_rsc(var/mob/m)
						src.rsc.maptext = "[css_outline]<font size = 1><text align=left valign=bottom>Your Zenni: ¥[CommasADV(shopper.resources)]"
						//src.rsc2.maptext = "[css_outline]<font size = 1><text align=left valign=top>Quality % Points: [Commas(m.intel_points)]"
					menu_create()
						if(src.setup) return
						src.I = new(src.icon)
						src.ww = I.Width()
						src.hh = I.Height()

						//src.xx = 10
						//src.yy = hh-72

						var/obj/hud/buttons/close_menu/cm = new
						cm.plane = src.plane
						cm.closes = src

						var/matrix/close_m = matrix()
						close_m.Translate(ww-15,hh-15)
						cm.transform = close_m
						src.vis_contents += cm

						var/obj/title1 = new
						title1.maptext_width = 320
						title1.maptext_height = 16
						title1.maptext = "[css_outline]<font size = 1><text align=center valign=top>Local Shopkeeper"
						title1.layer = 34
						title1.plane = 30
						title1.appearance_flags = PIXEL_SCALE
						var/matrix/m2 = matrix()
						m2.Translate(round(8),hh-37)
						title1.transform = m2
						title1.screen_loc = src.screen_loc
						src.vis_contents += title1
						src.title = title1

						var/obj/hud/menus/shopkeeper_inventory_background/inv_button_drop_Zenni/title2 = new
						title2.maptext_width = 400
						title2.maptext_height = 16
						title2.maptext = "[css_outline]<font size = 1><text align=left valign=top>Your Zenni: 0"
						title2.layer = 34
						title2.plane = 30
						title2.appearance_flags = PIXEL_SCALE
						var/matrix/m_rsc = matrix()
						m_rsc.Translate(124,4)
						title2.transform = m_rsc
						title2.screen_loc = src.screen_loc
						src.vis_contents += title2
						src.rsc = title2

						/*var/obj/title2 = new
						title2.maptext_width = 400
						title2.maptext_height = 16
						title2.maptext = "[css_outline]<font size = 1><text align=left valign=top>Zenni: 0"
						title2.layer = 34
						title2.plane = 30
						title2.appearance_flags = PIXEL_SCALE
						var/matrix/m_rsc = matrix()
						m_rsc.Translate(124,4)
						title2.transform = m_rsc
						title2.screen_loc = src.screen_loc
						src.vis_contents += title2
						src.rsc = title2 */

						var/obj/hud/menus/shopkeeper_inventory_background/inv_txt_holder/txt1 = new
						src.vis_contents += txt1
						src.txt_holder = txt1

						var/obj/hud/menus/shopkeeper_inventory_background/inv_txt/txt_actual = new
						var/matrix/m4 = matrix()
						txt_actual.hud_x = round(ww-170)
						txt_actual.hud_y = -794
						//src.txt_x = round(ww-170)
						//src.txt_y = -794
						m4.Translate(txt_actual.hud_x,txt_actual.hud_y)
						txt_actual.transform = m4
						txt1.vis_contents += txt_actual
						src.item_desc = txt_actual

						var/obj/hud/menus/shopkeeper_inventory_background/inv_scrollbar/bar1 = new
						src.vis_contents += bar1
						src.scrollbar = bar1

						var/obj/hud/menus/shopkeeper_inventory_background/inv_scroller/bar2 = new
						src.vis_contents += bar2
						src.scroller = bar2

						var/obj/hud/menus/shopkeeper_inventory_background/inv_button_use/but1 = new
						var/matrix/m5 = matrix()
						m5.Translate(9,3)
						but1.transform = m5
						src.vis_contents += but1
						src.button_use = but1

				MouseWheel(delta_x,delta_y,location,control,params)
					params = params2list(params)
					usr.text_y(usr.hud_inv.scroller.icon_y_saved,254,254,delta_y,"clicked",16,list(usr.hud_inv.item_desc),usr.hud_inv.scroller,270,usr.hud_inv.txt_x,usr.hud_inv.txt_y,27)
				MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
					params = params2list(params)
					var/icon_y = text2num(params["icon-y"])
					if(icon_y >= 314 || usr.mouse_down)
						usr.client.MousePosition(params)
						var/matrix/m = matrix()
						var/icon_x = text2num(params["icon-x"])
						if(usr.drag_icon_x == 0) usr.drag_icon_x = icon_x
						var/x_result = usr.client.client_mouse_x-usr.drag_icon_x
						var/y_result = usr.client.client_mouse_y-src.hh
						x_result = clamp(x_result,0,1023-src.ww)
						y_result = clamp(y_result,0,575-(src.hh/2))
						m.Translate(x_result,y_result)
						src.transform = m
						usr.mouse_down = src

						if(src.scroller)
							usr.check_mouse_loc(params)
							src.scroller.y_start = (usr.client.client_mouse_y-328)//328 derived from bar length(284) + excess pixels above 284 (44) (Basically the height of the menu, 328)
							src.scroller.y_start = clamp(src.scroller.y_start,0,254) //Stops the mouse_y being too high or low and messing with numbers
							src.scroller.transform = null
							src.scroller.translated_y = 0
							src.scroller.icon_y_saved = 270
							var/matrix/m1 = matrix()
							m1.Translate(src.item_desc.hud_x,src.item_desc.hud_y)
							src.item_desc.transform = m1
				/*
				MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
					usr.client.MousePosition(params)
					var/matrix/m = matrix()
					var/x_result = usr.client.client_mouse_x-(src.ww/2)
					var/y_result = usr.client.client_mouse_y-src.hh
					x_result = clamp(x_result,0,1023-src.ww)
					y_result = clamp(y_result,0,575-(src.hh/2))
					//src.xx = x_result
					//src.yy = y_result
					m.Translate(x_result,y_result)
					src.transform = m

					if(src.scroller)
						usr.check_mouse_loc(params)
						src.scroller.y_start = (usr.client.client_mouse_y-328)//328 derived from bar length(284) + excess pixels above 284 (44) (Basically the height of the menu, 328)
						src.scroller.y_start = clamp(src.scroller.y_start,0,254) //Stops the mouse_y being too high or low and messing with numbers
						src.scroller.transform = null
						src.scroller.translated_y = 0
						src.scroller.icon_y_saved = 270
						var/matrix/m1 = matrix()
						m1.Translate(src.item_desc.hud_x,src.item_desc.hud_y)
						src.item_desc.transform = m1
				*/
				inv_scrollbar
					icon = 'new_hud_inven.dmi'
					icon_state = "scrollbar"
					layer = 33
					plane = 30
					appearance_flags = KEEP_TOGETHER
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
					MouseWheel(delta_x,delta_y,location,control,params)
						params = params2list(params)
						usr.text_y(usr.hud_inv.scroller.icon_y_saved,254,254,delta_y,"clicked",16,list(usr.hud_inv.item_desc),usr.hud_inv.scroller,270,usr.hud_inv.txt_x,usr.hud_inv.txt_y,27)
					Click(location,control,params)
						if(usr.hud_inv)
							if(usr.hud_inv.scrollbar && src == usr.hud_inv.scrollbar)
								usr.check_mouse_loc(params)
								usr.client.MousePosition(params)
								params = params2list(params)
								var/icon_y = text2num(params["icon-y"])
								usr.hud_inv.y_start = usr.client.client_mouse_y-icon_y
								usr.text_y(icon_y,254,254,0,"clicked",16,list(usr.hud_inv.item_desc),usr.hud_inv.scroller,270,usr.hud_inv.txt_x,usr.hud_inv.txt_y,27)
								if(usr.hud_inv.scroller)
									var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y //The -1 accounts for Byonds fuckery with the y pos always starting at 1, which would be 32 pixels up, instead of 0.
									usr.hud_inv.scroller.y_start = true_y-icon_y

				inv_button_drop_Zenni
					icon = 'new_hud_drop_inv_button.dmi'
					icon_state = "exit"
					maptext_height = 16
					maptext_width = 65
					maptext_y = 1
					maptext_x = 4
					layer = 33
					plane = 30
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE
					MouseEntered(location,control,params)
						src.icon_state = "enter"
					MouseExited(location,control,params)
						src.icon_state = "exit"
					Click()
						usr.hud_inv.update_rsc(usr)
						usr.refresh_inv()






					MouseWheel()
						return
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						src.maptext = "[css_outline]<font size = 1><center>Zenni:"
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				inv_button_use
					icon = 'new_hud_inv_buttons.dmi'
					icon_state = "exit"
					maptext_height = 16
					maptext_width = 52
					maptext_y = 3
					layer = 33
					plane = 30
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE
					MouseEntered(location,control,params)
						src.icon_state = "enter"
					MouseExited(location,control,params)
						src.icon_state = "exit"
					Click()
						if(usr.shop_opened)
							if(usr.item_selected)
								var/obj/I = usr.item_selected
								if(I.loc == usr.current_shop.loc)
									var/cost = I.value
									if(usr.resources >= cost)
										usr.resources -= cost
										var/obj/items/new_item = new I.type
										new_item.loc = usr
										new_item.name = I.name
										new_item.value = I.value
										usr.refresh_inv()
										usr << "You bought [I.name] for ¥[Commas(cost)]!"
									else
										usr << "You don't have enough Zenni!"
					MouseWheel()
						return
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						src.maptext = "[css_outline]<font size = 1><center>Buy"
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.

				inv_scroller
					icon = 'new_hud_inven.dmi'
					icon_state = "scroller"
					layer = 33
					plane = 30
					//mouse_opacity = 0
					appearance_flags = KEEP_TOGETHER
					MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y //The -1 accounts for Byonds fuckery with the y pos always starting at 1, which would be 32 pixels up, instead of 0.
						var/cut = true_y-src.y_start
						usr.text_y(cut,254,254,0,"clicked",16,list(usr.hud_inv.item_desc),usr.hud_inv.scroller,270,usr.hud_inv.txt_x,usr.hud_inv.txt_y,27)
						usr.mouse_y_true = true_y

					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				inv_txt_holder
					icon = 'new_hud_inven.dmi'
					icon_state = "txt"
					layer = 33
					plane = 30
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseWheel(delta_x,delta_y,location,control,params)
						params = params2list(params)
						usr.text_y(usr.hud_inv.scroller.icon_y_saved,254,254,delta_y,"clicked",16,list(usr.hud_inv.item_desc),usr.hud_inv.scroller,270,usr.hud_inv.txt_x,usr.hud_inv.txt_y,27)
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				inv_txt
					maptext_width = 144
					maptext_height = 1080
					plane = 30
					layer = 34
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.

			updates_background
				icon = 'new_hud_updates.dmi'
				icon_state = "main"
				layer = 32
				screen_loc = "1,1"
				plane = 30
				var/setup = 0
				var/ww = 0
				var/hh = 0
				var/xx = 0
				var/yy = 0
				var/obj/hud/menus/updates_background/menu
				var/obj/txt_raw
				var/obj/updates_holder
				var/obj/updates_scrollbar
				var/obj/updates_scroller
				var/updates_background_x = 342
				var/updates_background_y = 100
				var/obj/txt_title
				var/updates_y = 0
				var/updates_scrolled_y = 0
				var/list/version_notes
				New()
					spawn(30)
						if(src)
							if(ismob(src.loc)) src.refresh_notes(src.loc)
				proc
					refresh_notes(var/mob/m)
						if(src.updates_holder)
							src.updates_holder.vis_contents = null

							src.updates_holder.vis_contents += src.txt_title

							src.version_notes = null
							src.version_notes = list(new /:version_2300,new /:version_2298, new /:version_2297, new /:version_2296, new /:version_2294, new /:version_2293, new /:version_2292, new /:version_229, new /:version_228, new /:version_226, new /:version_225, new /:version_220, new /:version_204, new /:version_018, new /:version_017, new /:version_016)
							src.updates_y = 0

							var/yy = 352
							for(var/obj/hud/menus/updates_background/updates/u in src.version_notes)
								u.menu = src
								u.hud_x = 16
								u.hud_y = yy
								u.icon_state = "plus"
								src.updates_holder.vis_contents += u
								u.maptext_x = 2//-2
								u.maptext_y = 2

								if(m && m.client && u.opened)
									u.maptext = u.notes
									u.icon_state = "minus"
									var/L = m.client.MeasureText(u.maptext,width = 300)

									//Calculate how big the new entries maptext_width should be based on the x axis of the text and MeasureText()
									var/x_pos = findtext(L, "x")
									var/L_x = copytext(L, 1, x_pos)
									L_x = text2num(L_x)

									//Calculate how big the new entries maptext_height should be based on the y axis of the text and MeasureText()
									var/y_pos = findtext(L, "x")
									var/L_y = copytext(L, y_pos+1, 0)
									L_y = text2num(L_y)

									yy -= 4+L_y //Makes sure that the next version notes is offset correctly when the for() loops back around to the next item.

									u.maptext_y = 2-L_y
									src.updates_y += 4+L_y
									u.maptext_height = 16+L_y
								else
									u.maptext = u.notes_closed
									yy -= 17
									src.updates_y += 17

								var/matrix/mat = matrix()
								mat.Translate(u.hud_x,u.hud_y+src.updates_scrolled_y)
								u.transform = mat

					menu_create()
						spawn(10)
							if(src)
								if(src.setup)
									return
								else
									src.setup = 1
									var/icon/I = new(src.icon)
									src.ww = I.Width()
									src.hh = I.Height()

									var/matrix/m_main = matrix()
									m_main.Translate(342,100)
									src.transform = m_main

									var/obj/hud/buttons/close_menu/cm = new
									cm.plane = src.plane
									cm.closes = src
									var/matrix/close_m = matrix()
									close_m.Translate(ww-15,hh-15)
									cm.transform = close_m
									src.vis_contents += cm

									var/obj/hud/menus/updates_background/updates_holder/s1 = new
									s1.menu = src
									src.updates_holder = s1
									src.vis_contents += s1

									var/obj/hud/menus/updates_background/txt_raw/txt = new
									txt.hud_x = 286
									txt.hud_y = -354
									var/matrix/t_m1 = matrix()
									t_m1.Translate(txt.hud_x,txt.hud_y)
									txt.transform = t_m1
									txt.menu = src
									src.txt_raw = txt

									var/obj/hud/menus/updates_background/updates_scrollbar/sb1 = new
									sb1.menu = src
									src.updates_scrollbar = sb1
									src.vis_contents += sb1

									var/obj/hud/menus/updates_background/updates_scroller/sc1 = new
									sc1.menu = src
									src.updates_scroller = sc1
									src.vis_contents += sc1

									var/obj/hud/menus/updates_background/updates_title/st = new
									var/matrix/st_m1 = matrix()
									st_m1.Translate(st.hud_x,st.hud_y)
									st.transform = st_m1
									st.menu = src
									s1.vis_contents += st
									src.txt_title = st

									if(ismob(src.loc)) src.refresh_notes(src.loc)

				MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
					params = params2list(params)
					var/icon_y = text2num(params["icon-y"])
					if(icon_y >= 299 || usr.mouse_down)
						usr.client.MousePosition(params)
						var/matrix/m = matrix()
						var/icon_x = text2num(params["icon-x"])
						if(usr.drag_icon_x == 0) usr.drag_icon_x = icon_x
						var/x_result = usr.client.client_mouse_x-usr.drag_icon_x
						var/y_result = usr.client.client_mouse_y-src.hh
						x_result = clamp(x_result,0,1023-src.ww)
						y_result = clamp(y_result,0,575-(src.hh/2))
						m.Translate(x_result,y_result)
						src.transform = m
						src.updates_background_x = x_result
						src.updates_background_y = y_result
						usr.mouse_down = src
				updates_title
					icon = null
					icon_state = null
					layer = 32
					plane = 30
					maptext_width = 128
					maptext_height = 16
					hud_x = 106
					hud_y = 374
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					New()
						src.maptext = "[css_outline]<font size = 2><center><u>Version Notes</u>"
						return
					MouseDrag()
						return
				txt_raw
					icon = null
					icon_state = null
					maptext_width = 168
					maptext_height = 640
					plane = 30
					layer = 34
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						src.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Test</u>\n<text align=left valign=top>Testing"
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				updates_scroller
					icon_state = "scroller"
					layer = 32
					plane = 30
					MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
						var/obj/hud/menus/updates_background/s = src.menu

						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						//var/result = -218 + (usr.mouse_y_true-54) //54 is the size of the scroller x 2 (basically its height in pixels). -285 seems is how many pixels from bottom of menu.
						var/result = -322 + ((usr.mouse_y_true-s.updates_background_y)-54)
						result = clamp(result,0,-344)
						var/matrix/m = matrix()
						m.Translate(0,result)
						src.transform = m
						src.translated_y = result

						var/ratio = -1 + ((-344 + result) / -344)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(s.updates_y*ratio)

						s.updates_scrolled_y = scroll_y

						for(var/obj/txt in s.updates_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/updates_background/s = src.menu
						var/obj/sc = s.updates_scroller

						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-344)

						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result
						var/ratio = -1 + ((-344 + result) / -344)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(s.updates_y*ratio)

						s.updates_scrolled_y = scroll_y

						for(var/obj/txt in s.updates_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2
				updates_scrollbar
					icon_state = "scrollbar"
					layer = 32
					plane = 30
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/updates_background/s = src.menu
						var/obj/sc = s.updates_scroller
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-344)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/ratio = -1 + ((-344 + result) / -344)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(s.updates_y*ratio)

						s.updates_scrolled_y = scroll_y

						for(var/obj/txt in s.updates_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2
					Click(location,control,params)
						var/obj/hud/menus/updates_background/s = src.menu
						var/obj/sc = s.updates_scroller
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/result = -322 + ((usr.mouse_y_true-s.updates_background_y)-54)
						result = clamp(result,0,-344)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/ratio = -1 + ((-344 + result) / -344)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(s.updates_y*ratio)

						s.updates_scrolled_y = scroll_y

						for(var/obj/txt in s.updates_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2
					New()
						return
					MouseDrag()
						return
				updates
					var/version
					var/opened = 1
					var/notes
					var/notes_closed
					icon = 'tech_expand_buttons.dmi'
					icon_state = "expanded"
					maptext_width = 300
					maptext_height = 1200
					plane = 30
					layer = 34
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					New()
						return
					MouseDrag()
						return
					Click()
						var/obj/hud/menus/updates_background/h_menu = src.menu

						h_menu.updates_holder.vis_contents = null

						h_menu.updates_holder.vis_contents += h_menu.txt_title

						h_menu.updates_y = 0

						if(src.opened == 0)
							src.opened = 1
							src.icon_state = "minus"
							src.maptext = src.notes
						else
							src.opened = 0
							src.icon_state = "plus"
							src.maptext = src.notes_closed

						var/yy = 352
						for(var/obj/hud/menus/updates_background/updates/u in h_menu.version_notes)
							u.hud_x = 16
							u.hud_y = yy
							u.icon_state = "plus"
							h_menu.updates_holder.vis_contents += u
							u.maptext_x = 2//-2
							u.maptext_y = 2

							if(u.opened)
								u.maptext = u.notes
								u.icon_state = "minus"
								var/L = usr.client.MeasureText(u.maptext,width = 300)

								//Calculate how big the new entries maptext_width should be based on the x axis of the text and MeasureText()
								var/x_pos = findtext(L, "x")
								var/L_x = copytext(L, 1, x_pos)
								L_x = text2num(L_x)

								//Calculate how big the new entries maptext_height should be based on the y axis of the text and MeasureText()
								var/y_pos = findtext(L, "x")
								var/L_y = copytext(L, y_pos+1, 0)
								L_y = text2num(L_y)

								yy -= 4+L_y //Makes sure that the next version notes is offset correctly when the for() loops back around to the next item.

								u.maptext_y = 2-L_y
								h_menu.updates_y += 4+L_y
								u.maptext_height = 16+L_y
							else
								yy -= 17
								h_menu.updates_y += 17
								u.maptext = u.notes_closed

							var/matrix/mat = matrix()
							mat.Translate(u.hud_x,u.hud_y+h_menu.updates_scrolled_y)
							u.transform = mat
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/updates_background/s = usr.hud_updates
						var/obj/sc = s.updates_scroller

						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-344)

						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result
						var/ratio = -1 + ((-344 + result) / -344)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(s.updates_y*ratio)

						s.updates_scrolled_y = scroll_y

						for(var/obj/txt in s.updates_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2
					version_2300
						New()
							src.notes_closed = "[css_outline]<font size = 1><text align=left valign=bottom>      Version 2.30 - 07/01/2026"
							src.notes = "[css_outline]<font size = 1><text align=left valign=bottom>      Version 2.30 - 07/01/2026\n\n\
							---------------------------Roleplay Systems and Stability Update--------------------------- \n\n\
							Added Roleplay Shop\n\n\
							Roleplay Shop includes bonuses and unique items purchasable with RPPs\n\n\
							Roleplay Shop features daily RNG rotations\n\n\
							RPPs are now exclusively used for the Roleplay Shop\n\n\
							Finalized PoPs system (fully functional)\n\n\
							Fixed issue preventing more than one PoP from existing\n\n\
							Fixed PoPs self-destructing after five minutes\n\n\
							Fixed ship exit location inconsistencies\n\n\
							Fixed issues when looking outside of ships\n\n\
							Fixed ship items failing to save correctly\n\n\
							Fixed turret chase speed\n\n\
							Fixed turret blast damage not killing targets properly\n\n\
							Deluxe Ships added to Planet Icer Shopkeeper\n\n\
							Deluxe Ship prices now increase per purchase\n\n\
							Roleplay Rating now displayed as letter ranks (F through S)\n\n\
							Roleplay Rating now resets weekly\n\n\
							Weekly reset reduces rating by a calculated percentage\n\n\
							S-rank ratings reset to F rank by default\n\n\
							On special occasions, players exceeding the S-rank cap may reset to D rank instead\n\n\
							"

					version_2298
						New()
							src.notes_closed = "[css_outline]<font size = 1><text align=left valign=bottom>      Version 2.298 - 07/01/2026"
							src.notes = "[css_outline]<font size = 1><text align=left valign=bottom>      Version 2.298 - 07/01/2026\n\n\
							---------------------------Polish and Balance Update--------------------------- \n\n\
							Fixed Anger process\n\n\
							Fixed Weapon buff and debuff effects\n\n\
							Fixed Sense and Sense Planet skills\n\n\
							Fixed Cooking not deleting raw meat\n\n\
							Accelerated gains timer now displays on screen\n\n\
							Throw damage affects limbs and can now break them\n\n\
							Energy Deflection finalized\n\n\
							All passive skills finalized, balanced, and functional\n\n\
							CFT (Cycle Free Time) reinstalled and reworked\n\n\
							Same type seeds now stack in inventory\n\n\
							Fixed mineral pickup bug creating new stacks\n\n\
							Removed negative mutations from 1st gens\n\n\
							Hybrid 2nd gens now have a rare chance for negative mutations\n\n\
							Increased accelerated gain boost\n\n\
							Normalized and slightly nerfed movement speeds and step sizes\n\n\
							Fixed ranged skill collision with turfs causing lag/crashes\n\n\
							Finalized transformation effects per race's SF\n\n\
							Removed falling from clouds in afterlife\n\n\
							Fixed hell portal allowing demons to exit freely\n\n\
							Aura alignment is now completely hidden\n\n\
							Added new Checkpoint Guardian skill 'Judge' (sends souls to hell/heaven for X years)\n\n\
							Checkpoint Guardians granted Observe and Astral Projection\n\n\
							"

					version_2297
						New()
							src.notes_closed = "[css_outline]<font size = 1><text align=left valign=bottom>      Version 2.297 - 01/01/2026"
							src.notes = "[css_outline]<font size = 1><text align=left valign=bottom>      Version 2.297 - 01/01/2026\n\n\
							<center><b>HAPPY NEW YEAR!</b></center>\n\n\
							--------------------------------Reproduction & Genetics-------------------------------- \n\n\
							Adult selection locked at wipe start for Living Realm races\n\n\
							Fixed skill teaching requirements\n\n\
							Fixed conceiving offspring requirements (gender/race locks)\n\n\
							Changelings can now crossmate with Aliens only (Alien dominant)\n\n\
							Fixed speed gains\n\n\
							Mage pot creation now requires successful Month Save RNG to enter newborn list\n\n\
							Dokuro Shopkeepers added\n\n\
							Fixed collision issues from blasts and other skills causing freezes/lag\n\n\
							"
					version_2296
						New()
							src.notes_closed = "[css_outline]<font size = 1><text align=left valign=bottom>      Version 2.295-2.296 - 30/12/2025"
							src.notes = "[css_outline]<font size = 1><text align=left valign=bottom>      Version 2.295-2.296 - 30/12/2025\n\n\
							--------------------------------World Systems Finalization-------------------------------- \n\n\
							HBTC added and finalized\n\n\
							Space finalized\n\n\
							Ships completed and added\n\n\
							Korin Tower and Lookout accessible without EG (admin approval and RP required)\n\n\
							Toxicity system reworked\n\n\
							Buffed toxicity gain and increased duration\n\n\
							Stat visuals reworked (percentages and Average - Below Average labels)\n\n\
							Midget gene no longer boosts power level\n\n\
							Giant gene negative decline boosted to -30%\n\n\
							Items and skill descriptions tweaked/rewritten\n\n\
							Added /quit command for command input field\n\n\
							Fixed HBTC QP and ME gains\n\n\
							Fixed swimming in water dropping players into hell from CP\n\n\
							Fixed d/c and crashes from specific skills\n\n\
							"

					version_2294
						New()
							src.notes_closed = "[css_outline]<font size = 1><text align=left valign=bottom>      Version 2.294 - 18/12/2025"
							src.notes = "[css_outline]<font size = 1><text align=left valign=bottom>      Version 2.294 - 18/12/2025\n\n\
							--------------------------------Core Systems-------------------------------- \n\n\
							Finished mating and next-generation logic\n\n\
							Updated bio-reproduction tank mating\n\n\
							Updated hybrid reproduction logic\n\n\
							Tweaked human mods by size\n\n\
							Fixed and scaled startup PP for next generations\n\n\
							Added baby limb parts\n\n\
							Added second skillbar and skillbar swap button\n\n\
							Sleep skill now restores vitals and ki\n\n\
							"

					version_2293
						New()
							src.notes_closed = "[css_outline]<font size = 1><text align=left valign=bottom>      Version 2.293 - 11/12/2025"
							src.notes = "[css_outline]<font size = 1><text align=left valign=bottom>      Version 2.293 - 11/12/2025\n\n\
							--------------------------------Finalization-------------------------------- \n\n\
							Limbs fully finalized\n\n\
							Added RP modes (Full RP and Phase RP)\n\n\
							Gravity damage now applies to limb damage\n\n\
							Drinking from water pots removed\n\n\
							Added combat SFX for maims, breaks, crits, and weapons\n\n\
							AFK now halts standing gain accumulation\n\n\
							Fixed bleeding effect from laceration\n\n\
							"

					version_2292
						New()
							src.notes_closed = "[css_outline]<font size = 1><text align=left valign=bottom>      Version 2.292 - 08/12/2025"
							src.notes = "[css_outline]<font size = 1><text align=left valign=bottom>      Version 2.292 - 08/12/2025\n\n\
							--------------------------------Major Systems-------------------------------- \n\n\
							Added weapon stances\n\n\
							Added new weapons\n\n\
							Added makeup and lipstick (adults only)\n\n\
							Fixed HP depletion from oxygen and environment\n\n\
							Re-centered the sun\n\n\
							Fixed space pod speed\n\n\
							Fixed black hole spawns\n\n\
							Finalized laceration system\n\n\
							Replaced paperdoll with original\n\n\
							Delimbing completed\n\n\
							Body parts can now be buried, capsulated, or refrigerated\n\n\
							Medical packs can reattach or destroy limbs\n\n\
							"

					version_229
						New()
							src.notes_closed = "[css_outline]<font size = 1><text align=left valign=bottom>      Version 2.29 - 02/12/2025"
							src.notes = "[css_outline]<font size = 1><text align=left valign=bottom>      Version 2.29 - 02/12/2025\n\n\
							--------------------------------Changes-------------------------------- \n\n\
							Fixed Alien mod RNG for startup points\n\n\
							Reintroduced Bedrolls at Shopkeeper (20,000 zenni)\n\n\
							Hitting your RES now stops meditation and training\n\n\
							Fixed SSJ aura persisting after revert\n\n\
							Adjusted gains (Part 3)\n\n\
							Adjusted offline gain counter\n\n\
							Moved paper doll to top left to fix offset\n\n\
							Culled logout lag spike issue\n\n\
							Applied soft fix for screen offset after crashes\n\n\
							Fixed Water Purifier decay preventing creation\n\n\
							Added beards for select races\n\n\
							Added scissors option to shave\n\n\
							Fixed grab-snatch exploit\n\n\
						"

					version_228
						New()
							src.notes_closed = "[css_outline]<font size = 1><text align=left valign=bottom>      Version 2.28 - 28/11/2025"
							src.notes = "[css_outline]<font size = 1><text align=left valign=bottom>      Version 2.28 - 28/11/2025\n\n\
							--------------------------------Fixes-------------------------------- \n\n\
							Fixed food expiration\n\n\
							Water now turns into dirty water upon expiration\n\n\
							Dirty water can no longer be purified\n\n\
							Can only drink dirty or purified water\n\n\
							Medical packs now have two uses (revival chance and toxicity reduction)\n\n\
							Fixed Move Level gain and stat bar visuals\n\n\
							Fixed PP gain issues\n\n\
							Nerfed tree health\n\n\
							Made walls attackable for spar gains\n\n\
							Added sparring gloves to tech list\n\n\
							Hell’s Blood Fountain now supports drinking or water gathering\n\n\
							"

					version_226
						New()
							src.notes_closed = "[css_outline]<font size = 1><text align=left valign=bottom>      Version 2.26 - 18/11/2025"
							src.notes = "[css_outline]<font size = 1><text align=left valign=bottom>      Version 2.26 - 18/11/2025\n\n\
							--------------------------------Major Updates-------------------------------- \n\n\
							Finalized Super Forms for all races (boosts, effects, some grant +50% health)\n\n\
							Added battle music\n\n\
							Heaven map reworked\n\n\
							QoL adjustments to sound effects\n\n\
							-------------------------------------------Balance------------------------------------------- \n\n\
							Increased Spirit Doll energy modifier\n\n\
							Increased Kai and Demon energy modifiers\n\n\
							Soul Absorb capped at 2 uses with 20 year cooldown per use\n\n\
							Decline Absorb capped at 1 use with 5 year cooldown\n\n\
							Decline Absorb now kills if victim drops below decline age threshold\n\n\
							Demon revive now grants tainted aura\n\n\
							Kaio revive now grants honest aura with reduced drawback\n\n\
							Increased pull-through chance for Namekians and Bio-Androids\n\n\
							-------------------------------------------Reworks------------------------------------------- \n\n\
							Android rework (only Android PP required, Create Android unlocked at 5 PP)\n\n\
							Androids can be controlled as NPCs until occupied by a player\n\n\
							Cyborg rework (PP-based scaling, applies to self and others)\n\n\
							Sword rework (200% cap, choose offence or speed, not both)\n\n\
							Armor rework (100% cap, acts as fragile extra health bar)\n\n\
							Gravity inside caves nerfed per planet\n\n\
							Research and Harness skill rework (artifact-based QP/ME progression)\n\n\
							Changeling starting PL increased again\n\n\
							Armors and scouters are now base-colorable\n\n\
							-------------------------------------------Bug Fixes----------------------------------------- \n\n\
							Fixed eye pupil position for kids\n\n\
							Fixed max ki not increasing\n\n\
							Standing gains no longer accumulate while sleeping\n\n\
							"

					version_225
						New()
							src.notes_closed = "[css_outline]<font size = 1><text align=left valign=bottom>      Version 2.25 - 17/11/2025"
							src.notes = "[css_outline]<font size = 1><text align=left valign=bottom>      Version 2.25 - 17/11/2025\n\n\
							Welcome to version 2.25 of Sovereign!\n\n\
							--------------------------------Changes-------------------------------- \n\n\
							Redesigned interface for proper clarity (removed toggleable chat boxes on the bottom left corner)\n\n\
							Calibrated a smoother combat experience. Giant Mammoths are a slight exception\n\n\
							Added Ki Weapon Manipulation skill (dubbed from Divine Weapon skill) for Namekian and Kai races\n\n\
							Removed Bedrolls. Sleep Skill becomes the meta for raising tiredness (can sleep anywhere)\n\n\
							Replaced first tech (Bedrolls) with Water Purifier\n\n\
							Buffed start-up boost for Changelings\n\n\
							Recalibrated mouse-aiming system for blasts, throws, beams, etc\n\n\
							Nerfed explosion requirements (no more instant splodies from x10 charge blasts)\n\n\
							Ki attacks now deal limb damage and cause anger\n\n\
							Replaced cursor icon with a larger, cleaner version\n\n\
							Replaced roleplay alert icons with modern debug-style visuals\n\n\
							Nerfed blast cooldown to accommodate aiming inaccuracies\n\n\
							-------------------------------------------Bug Fixes----------------------------------------- \n\n\
							Fixed an issue with beams causing crashes\n\n\
							Fixed beam chants\n\n\
							Fixed adult and teen age selection being selectable before required years\n\n\
							Fixed Tuffles spawning outside of Vegeta\n\n\
							Fixed screen resolution issues causing map offset\n\n\
							Fixed eating or drinking consuming entire item stacks\n\n\
							Fixed inventory refresh issues\n\n\
							-------------------------------------------Balance------------------------------------------- \n\n\
							Namekian QP mod buffed to match Alien Techies\n\n\
							Namekian ME mod slightly nerfed\n\n\
							Oni QP mod buffed slightly\n\n\
							Oni combat mods slightly buffed (Endurance, Strength, Defence)\n\n\
							---------------------------------------World Additions-------------------------------------- \n\n\
							Added underground caves to Planet Vegeta\n\n\
							Added underground caves to Planet Namek\n\n\
							Adjusted water purifying speeds and timers\n\n\
							Sea water gathering now scales with Gather skill level\n\n\
							Admins are now anonymous\n\n\
							"

					version_220
						New()
							//6 spaces creates a gap needed within the maptext
							src.notes_closed = "[css_outline]<font size = 1><text align=left valign=bottom>      Version 2.2 - 28/03/2025"
							src.notes = "[css_outline]<font size = 1><text align=left valign=bottom>      Version 2.2 - 28/03/2025\n\n\
							Welcome to version 2.2 of Sovereign!\n\n\
							-------------------------------------LAUNCH DAY NOTICE!------------------------------------- \n\n\
							To make Sovereign we had a big helping hand with Ginseng's Psiforge, however it took some time to convert the game into the dbg-uni that we see today.\n\
							We only received the source in late December an started work in early January, but little and behold we manage to wip something up in no less than 2 months.\n\
							We want to thank you for your patience in prior downtimes leading up to this version of Sovereign and assure you that the game will continue to update and be better than it was\n\
							yesterday. Thank you and enjoy!\n\
							-------------------------------------------CHANGES------------------------------------------- \n\n\
							Bodyparts/Milestones locked behind a hidden requirement instead of perm-hud.\n\n\
							Spawn locations changed for all races.\n\n\
							Removed Half Gods from race selection.\n\n\
							Cleaned up Status Menus, removed un-wanted assets from Survivals tab.\n\n\
							Locked World Map behind the sense skill, and equipped scouters.\n\n\
							Nerfed the benefits of bodypart upgrading.\n\n\
							Locked technology behind needed quality percentages.\n\n\
							Reworked chatbox, space bar and enter key hides and un-hides the ooc and ic box.\n\n\
							Followers tab removed. \n\n\
							-------------------------------------------Bug fixes----------------------------------------- \n\n\
							Fixed an issue where boiling water would give null water in the inventory.\n\n\
							Fixed a bug where cooking stops movement.\n\n\
							Fixed a bug in some races starting off with negative energy.\n\n\
							Fixed an issue with relogs.\n\n\
							Fixed some icon issues with the body.\n\n\
							---------------------------------------Known issues-------------------------------------- \n\n\
							<font color = #DF7126>The new Chat menu doesn't receive all of the notifcations just yet, some important information might be lost or missing.<font color = white>\n\n\
							<font color = yellow>Contacts inside the new Contacts menu can't be assigned relations correctly yet.<font color = white>\n\n\
							<font color = yellow>Many of the descriptions for bodyparts are silly AI-generated placeholders.<font color = white>\n\n\
							<font color = #DF7126>There's only Soup available to make at the moment, more food options coming soon.<font color = white>\n\n\
							<font color = #DF7126>Some planets detailing are not 100% finished yet. (About 85%)<font color = white>\n\n\
							<font color = green>Languages are not fully implified yet. <font color = white>\n\n\
							<font color = red>Mating is not active at the moment. (Coming soon)<font color = white>\n\n\

							"
					version_204
						New()
							//6 spaces creates a gap needed within the maptext
							src.notes_closed = "[css_outline]<font size = 1><text align=left valign=bottom>      Version 2.04 - 25/01/2025"
							src.notes = "[css_outline]<font size = 1><text align=left valign=bottom>      Version 2.04 - 25/01/2025\n\n\
							Welcome to version 2.04 of Sovereign!\n\n\
							-------------------------------------------Changes------------------------------------------- \n\n\
							Eyes and Pupils corrected to the DBG's base.\n\n\
							Milestones locked behind a hidden requirement instead of perm-hud.\n\n\
							Spawn locations changed for all races.\n\n\
							Removed Half Gods from race selection.\n\n\
							New Angel Race added in conenction to Half Gods.\n\n\
							-------------------------------------------Bug fixes----------------------------------------- \n\n\
							Fixed an issue where boiling water would give null water in the inventory.\n\n\
							Fixed a bug where cooking stops movement.\n\n\
							Fixed a bug in some races starting off with negative energy.\n\n\
							Fixed an issue with relogs.\n\n\
							Fixed some icon issues with the body.\n\n\
							---------------------------------------Known issues-------------------------------------- \n\n\
							<font color = green>Selecting Engineering then clicking the Research button and using Meditate unlocks all the technology in the game for the moment.<font color = white>\n\n\
							<font color = #DF7126>The new Chat menu doesn't receive all of the notifcations just yet, some important information might be lost or missing.<font color = white>\n\n\
							<font color = red>The Followers tab in the new Contacts menu isn't finished yet, which means followers can't be issued commands in this version. For example, attack, dig, ect.<font color = white>\n\n\
							<font color = yellow>Contacts inside the new Contacts menu can't be assigned relations correctly yet.<font color = white>\n\n\
							<font color = yellow>Many of the descriptions for bodyparts are silly AI-generated placeholders.<font color = white>\n\n\
							<font color = #DF7126>The new Core Stats menu has two tabs that aren't finished, Masteries and Status Effects.<font color = white>\n\n\
							<font color = #DF7126>The Settings menu and Server Options menu are not finished yet.<font color = white>\n\n\
							"
					version_018
						New()
							//6 spaces creates a gap needed within the maptext
							src.notes_closed = "[css_outline]<font size = 1><text align=left valign=bottom>      Version 2.03 - 21/01/2025"
							src.notes = "[css_outline]<font size = 1><text align=left valign=bottom>      Version 2.03 - 21/01/2025\n\n\
							Welcome to version 2.03 of Sovereign!\n\n\
							Thank you for joining the Beta testing!\n\n\
							<font color = yellow>This version can't be used to join other players<font color = white>\n\n\
							-------------------------------------------Changes------------------------------------------- \n\n\
							Resources are no longer a seperate item and now function like Divine Energy and Dark Matter in terms of their representation as a number in game\n\n\
							Picking the same origin with different characters no longer locks that origin to one character\n\n\
							Items dropped by players and NPC's on death now bundle into a small bag/sack\n\n\
							Added horns as a body part for Yukopians\n\n\
							-------------------------------------------Bug fixes----------------------------------------- \n\n\
							Fixed an issue where the tech selection menu wasn't allowing vertical scrolling past a point\n\n\
							Fixed a bug where Drill Towers could give minus resources when clicked\n\n\
							Fixed a bug where getting above 200% toxicity didn't result in death\n\n\
							Fixed an issue where hunger, thirst and tiredness were not reset to 0 when a player died\n\n\
							Fixed a bug where Thousand Year Bone's didn't stack correctly\n\n\
							---------------------------------------Known issues-------------------------------------- \n\n\
							<font color = green>Selecting Engineering then clicking the Research button and using Meditate unlocks all the technology in the game for the moment.<font color = white>\n\n\
							<font color = #DF7126>The new Chat menu doesn't receive all of the notifcations just yet, some important information might be lost or missing.<font color = white>\n\n\
							<font color = red>The Followers tab in the new Contacts menu isn't finished yet, which means followers can't be issued commands in this version. For example, attack, dig, ect.<font color = white>\n\n\
							<font color = yellow>Contacts inside the new Contacts menu can't be assigned relations correctly yet.<font color = white>\n\n\
							<font color = yellow>Many of the descriptions for bodyparts are silly AI-generated placeholders.<font color = white>\n\n\
							<font color = #DF7126>The new Core Stats menu has two tabs that aren't finished, Masteries and Status Effects.<font color = white>\n\n\
							<font color = #DF7126>The Settings menu and Server Options menu are not finished yet.<font color = white>\n\n\
							"
					version_017
						New()
							//6 spaces creates a gap needed within the maptext
							opened = 0
							src.notes_closed = "[css_outline]<font size = 1><text align=left valign=bottom>      Version 0.17 - 13/01/2024"
							src.notes = "[css_outline]<font size = 1><text align=left valign=bottom>      Version 0.17 - 13/01/2024\n\n\
							Welcome to version 0.17 of Psiforged!\n\n\
							Thank you for joining the open testing.\n\n\
							It's been a year since Psiforged was last tested and players like yourself helped shape its future. This version in particular will have a lot of bugs and missing features, especially revolving around the new menus.\n\n\
							-------------------------------------------Changes------------------------------------------- \n\n\
							Every menu updated and changed\n\n\
							Disabled the Crane Breathing skill for the moment while a fix/re-design is worked on\n\n\
							The chat logs should now cull after 100 entries to help prevent buildup which would of contributed to lag/cpu delays\n\n\
							The chat logs in this version will reset when reloading a character\n\n\
							Disabled the Psi-Clone and Divine Weapon skills until their respected menus are finished\n\n\
							-------------------------------------------Bug fixes----------------------------------------- \n\n\
							<font color = red>Some of these fixes might require a new character.<font color = white>\n\n\
							Fixed a bug where the 0 - 9 numbers on the skillbar vanished\n\n\
							Fixed an issue where the Origin a player picked wasn't showing in their Core Stats menu\n\n\
							Fixed a bug where Traits and Stances didn't display correctly in the Unlocks menu\n\n\
							Fixed a bug where Remote Viewing wasn't working\n\n\
							The Relations tab of the Contacts menu should now scroll vertically correctly in relation to the number of contacts\n\n\
							Fixed an issue where the Celestial Origin Exalted lost its light when a player re-loaded\n\n\
							Fixed a bug where Remote Viewing wasn't working\n\n\
							Fixed a problem with text displayed when targetting someone\n\n\
							---------------------------------------Known issues-------------------------------------- \n\n\
							<font color = green>Selecting Engineering then clicking the Research button and using Meditate unlocks all the technology in the game for the moment.<font color = white>\n\n\
							<font color = #DF7126>The new Chat menu doesn't receive all of the notifcations just yet, some important information might be lost or missing.<font color = white>\n\n\
							<font color = red>The Followers tab in the new Contacts menu isn't finished yet, which means followers can't be issued commands in this version. For example, attack, dig, ect.<font color = white>\n\n\
							<font color = yellow>Contacts inside the new Contacts menu can't be assigned relations correctly yet.<font color = white>\n\n\
							<font color = yellow>Many of the descriptions for bodyparts are silly AI-generated placeholders.<font color = white>\n\n\
							<font color = #DF7126>The new Core Stats menu has two tabs that aren't finished, Masteries and Status Effects.<font color = white>\n\n\
							<font color = #DF7126>The Settings menu and Server Options menu are not finished yet.<font color = white>\n\n\
							N/A \n\n"
					version_016
						opened = 0
						icon_state = "plus"
						New()
							//6 spaces creates a gap needed within the maptext
							src.notes_closed = "[css_outline]<font size = 1><text align=left valign=bottom>      Version 0.16 - 13/01/2024"
							src.notes = "[css_outline]<font size = 1><text align=left valign=bottom>      Version 0.16 - 13/01/2024\n\n\
							Changes \n\n\
							N/A \n\n\
							Bug Fixes \n\n\
							N/A \n\n"
				updates_holder
					icon_state = "holder"
					layer = 32
					plane = 30
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/updates_background/s = src.menu
						var/obj/sc = s.updates_scroller

						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-344)

						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result
						var/ratio = -1 + ((-344 + result) / -344)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(s.updates_y*ratio)

						s.updates_scrolled_y = scroll_y

						for(var/obj/txt in s.updates_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2
					New()
						return
					MouseDrag()
						return
			help_background
				icon = 'new_hud_help.dmi'
				icon_state = "main"
				layer = 32
				screen_loc = "1,1"
				plane = 35
				var/setup = 0
				var/ww = 0
				var/hh = 0
				var/xx = 0
				var/yy = 0
				var/obj/hud/menus/help_background/menu
				var/obj/txt_holder
				var/obj/txt_scrollbar
				var/obj/txt_scroller
				var/obj/txt_raw
				var/obj/help_holder
				var/obj/help_scrollbar
				var/obj/help_scroller
				var/help_background_x = 300
				var/help_background_y = 100
				var/list/topics
				var/list/buttons
				var/topics_displayed = 0 //This is in pixels, so we can calculate how far to shift the menus
				var/obj/txt_title
				var/help_holder_y
				proc
					menu_create()
						spawn(30)
							if(src)
								if(src.setup)
									//spawn(30)
									//	if(src)
											//world << "DEBUG - Found menu already."
									return
								else
									src.setup = 1
									var/icon/I = new(src.icon)
									src.ww = I.Width()
									src.hh = I.Height()

									src.topics = list()
									src.buttons = list()

									var/list/help_creation = typesof(/obj/help_topics/)
									help_creation -= /obj/help_topics/
									help_creation -= /obj/help_topics/Alert_Misc
									for(var/x in help_creation)
										var/obj/o = new x()
										src.topics += o

									var/matrix/m_main = matrix()
									m_main.Translate(300,100)
									src.transform = m_main

									var/obj/hud/buttons/close_menu/cm = new
									cm.plane = src.plane
									cm.closes = src
									var/matrix/close_m = matrix()
									close_m.Translate(ww-15,hh-15)
									cm.transform = close_m
									src.vis_contents += cm

									var/obj/hud/menus/help_background/help_holder/s1 = new
									s1.menu = src
									src.help_holder = s1
									src.vis_contents += s1

									var/obj/hud/menus/help_background/txt_holder/s2 = new
									s2.menu = src
									src.txt_holder = s2
									src.vis_contents += s2


									var/obj/hud/menus/help_background/txt_raw/txt = new
									txt.hud_x = 286
									txt.hud_y = -354
									var/matrix/t_m1 = matrix()
									t_m1.Translate(txt.hud_x,txt.hud_y)
									txt.transform = t_m1
									txt.menu = src
									src.txt_raw = txt
									txt_holder.vis_contents += txt


									var/obj/hud/menus/help_background/help_scrollbar/sb1 = new
									sb1.menu = src
									src.help_scrollbar = sb1
									src.vis_contents += sb1

									var/obj/hud/menus/help_background/txt_scrollbar/sb2 = new
									sb2.menu = src
									src.txt_scrollbar = sb2
									src.vis_contents += sb2

									var/obj/hud/menus/help_background/help_scroller/sc1 = new
									sc1.menu = src
									src.help_scroller = sc1
									src.vis_contents += sc1

									var/obj/hud/menus/help_background/txt_scroller/sc2 = new
									sc2.menu = src
									src.txt_scroller = sc2
									src.vis_contents += sc2

									var/obj/hud/menus/help_background/help_title/st = new
									st.menu = src
									s1.vis_contents += st
									src.txt_title = st

									/*
									Categories
										- Combat
										- Training
										- Environmental
										- Lore
										- Gameplay
										- Misc

									*/
									var/list/topics = list("Rules","Gameplay","Combat","Training","Lore","FAQs")
									var/yy = 244
									for(var/t in topics)
										var/obj/hud/menus/help_background/button/b = new
										b.menu = src
										b.topic = t
										b.hud_x = 16
										b.hud_y = yy
										b.icon_state = "plus"
										var/matrix/but_m = matrix()
										but_m.Translate(b.hud_x,b.hud_y)
										b.transform = but_m
										help_holder.vis_contents += b
										yy -= 17
										b.maptext = "[css_outline]<font size = 2><text align=left valign=top>[t]"
										b.maptext_x = 16
										src.buttons += b

				MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
					params = params2list(params)
					var/icon_y = text2num(params["icon-y"])
					if(icon_y >= 299 || usr.mouse_down)
						usr.client.MousePosition(params)
						var/matrix/m = matrix()
						var/icon_x = text2num(params["icon-x"])
						if(usr.drag_icon_x == 0) usr.drag_icon_x = icon_x
						var/x_result = usr.client.client_mouse_x-usr.drag_icon_x
						var/y_result = usr.client.client_mouse_y-src.hh
						x_result = clamp(x_result,0,1023-src.ww)
						y_result = clamp(y_result,0,575-(src.hh/2))
						m.Translate(x_result,y_result)
						src.transform = m
						src.help_background_x = x_result
						src.help_background_y = y_result
						usr.mouse_down = src
				help_title
					icon = null
					layer = 32
					plane = 35
					maptext_width = 128
					maptext_height = 16
					maptext_x = 68
					maptext_y = 270
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					New()
						src.maptext = "[css_outline]<font size = 1><center><u>Knowledge & Guidelines</u>"
						return
					MouseDrag()
						return
				txt_raw
					icon = null
					icon_state = null
					maptext_width = 168
					maptext_height = 640
					plane = 35
					layer = 34
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						src.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Note:</u>\n<text align=left valign=top>Read up and learn some more about Sovereign here!"
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				help_scroller
					icon_state = "help scroller"
					layer = 32
					plane = 35
					MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
						var/obj/hud/menus/help_background/s = src.menu

						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						//var/result = -218 + (usr.mouse_y_true-54) //54 is the size of the scroller x 2 (basically its height in pixels). -285 seems is how many pixels from bottom of menu.
						var/result = -218 + ((usr.mouse_y_true-s.help_background_y)-54)
						result = clamp(result,0,-228)
						var/matrix/m = matrix()
						m.Translate(0,result)
						src.transform = m
						src.translated_y = result

						var/ratio = -1 + ((-228 + result) / -228)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(100*ratio)

						s.help_holder_y = scroll_y

						for(var/obj/txt in s.help_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/help_background/s = src.menu
						var/obj/sc = s.help_scroller

						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-228)

						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result
						var/ratio = -1 + ((-228 + result) / -228)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(100*ratio)

						s.help_holder_y = scroll_y

						for(var/obj/txt in s.help_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2
				help_scrollbar
					icon_state = "help scrollbar"
					layer = 32
					plane = 35
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/help_background/s = src.menu
						var/obj/sc = s.help_scroller
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-228)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/ratio = -1 + ((-228 + result) / -228)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(100*ratio)

						s.help_holder_y = scroll_y

						for(var/obj/txt in s.help_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2
					Click(location,control,params)
						var/obj/hud/menus/help_background/s = src.menu
						var/obj/sc = s.help_scroller
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/result = -218 + ((usr.mouse_y_true-s.help_background_y)-54)
						result = clamp(result,0,-228)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/ratio = -1 + ((-228 + result) / -228)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(100*ratio)

						s.help_holder_y = scroll_y

						for(var/obj/txt in s.help_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2
					New()
						return
					MouseDrag()
						return
				txt_scroller
					icon_state = "txt scroller"
					layer = 32
					plane = 35
					MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
						var/obj/hud/menus/help_background/s = src.menu

						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						//var/result = -218 + (usr.mouse_y_true-54) //54 is the size of the scroller x 2 (basically its height in pixels). -285 seems is how many pixels from bottom of menu.
						var/result = -218 + ((usr.mouse_y_true-s.help_background_y)-54)
						result = clamp(result,0,-245)
						var/matrix/m = matrix()
						m.Translate(0,result)
						src.transform = m
						src.translated_y = result

						var/ratio = -1 + ((-245 + result) / -245)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(700*ratio)

						for(var/obj/txt in s.txt_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2
							txt.translated_y = scroll_y
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/help_background/s = src.menu
						var/obj/sc = s.txt_scroller

						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-218)

						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result
						var/ratio = -1 + ((-218 + result) / -218)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(700*ratio)

						for(var/obj/txt in s.txt_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2
							txt.translated_y = scroll_y
				txt_scrollbar
					icon_state = "txt scrollbar"
					layer = 32
					plane = 35
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/help_background/s = src.menu
						var/obj/sc = s.txt_scroller
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-245)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/ratio = -1 + ((-245 + result) / -245)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(700*ratio)

						for(var/obj/txt in s.txt_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.translated_y = scroll_y
							txt.transform = m2
					Click(location,control,params)
						var/obj/hud/menus/help_background/s = src.menu
						var/obj/sc = s.txt_scroller
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/result = -218 + ((usr.mouse_y_true-s.help_background_y)-54)
						result = clamp(result,0,-245)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/ratio = -1 + ((-245 + result) / -245)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(700*ratio)

						for(var/obj/txt in s.txt_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.translated_y = scroll_y
							txt.transform = m2
					New()
						return
					MouseDrag()
						return
				button
					icon = 'help_expand_buttons.dmi'
					icon_state = "expanded"
					maptext_width = 320
					maptext_height = 16
					plane = 35
					layer = 34
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					var/topic //Used for the main topic buttons
					var/opened = 0
					/*
					Categories
						- Combat
						- Training
						- Environmental
						- Lore
						- Gameplay
						- Misc
					*/
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						src.maptext = "[css_outline]<font size = 1><text align=left valign=top>Text here"
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/help_background/s = usr.hud_help
						var/obj/sc = s.help_scroller

						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-218)

						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result
						var/ratio = -1 + ((-218 + result) / -218)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(200*ratio)

						s.help_holder_y = scroll_y

						for(var/obj/txt in s.help_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2
					Click()
						var/obj/hud/menus/help_background/h_menu = src.menu

						h_menu.help_holder.vis_contents = null

						h_menu.help_holder.vis_contents += h_menu.txt_title

						if(src.opened == 0)
							src.opened = 1
							src.icon_state = "minus"
						else
							src.opened = 0
							src.icon_state = "plus"

						var/yy = 261
						for(var/obj/hud/menus/help_background/button/b in h_menu.buttons)
							yy -= 17
							b.hud_y = yy
							var/matrix/m_t = matrix()
							m_t.Translate(b.hud_x,yy+h_menu.help_holder_y)
							b.transform = m_t
							h_menu.help_holder.vis_contents += b
							for(var/obj/help_topics/h in h_menu.topics)
								var/shift = 0
							//	if(h.category == "gui")
							//		if(b.topic == "GUI" && b.opened)
								//		shift = 1
								//if(h.category == "controls")
								//	if(b.topic == "Controls" && b.opened)
								//		shift = 1
							//	if(h.category == "misc")
								//	if(b.topic == "Misc" && b.opened)
								//		shift = 1
								if(h.category == "rules")
									if(b.topic == "Rules" && b.opened)
										shift = 1
								if(h.category == "gameplay")
									if(b.topic == "Gameplay" && b.opened)
										shift = 1
								if(h.category == "lore")
									if(b.topic == "Lore" && b.opened)
										shift = 1
							//	if(h.category == "environmental")
							//		if(b.topic == "Environmental" && b.opened)
								//		shift = 1
								if(h.category == "faqs")
									if(b.topic == "FAQS" && b.opened)
										shift = 1
								if(h.category == "training")
									if(b.topic == "Training" && b.opened)
										shift = 1
								if(h.category == "combat")
									if(b.topic == "Combat" && b.opened)
										shift = 1
							//	if(h.category == "stats")
								//	if(b.topic == "Stats" && b.opened)
								//		shift = 1
								//if(h.category == "skills")
								//	if(b.topic == "Skills" && b.opened)
								//		shift = 1
								if(shift)
									yy -= 17
									h.hud_x = b.hud_x+16
									h.hud_y = yy
									var/matrix/m = matrix()
									m.Translate(h.hud_x,h.hud_y+h_menu.help_holder_y)
									h.transform = m
									h_menu.help_holder.vis_contents += h
									h.maptext = "[css_outline]<font size = 2><text align=left valign=top>[h.name]"
									h.maptext_x = 16
				help_holder
					icon_state = "help holder"
					layer = 32
					plane = 35
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/help_background/s = src.menu
						var/obj/sc = s.help_scroller

						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-218)

						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result
						var/ratio = -1 + ((-218 + result) / -218)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(200*ratio)

						s.help_holder_y = scroll_y

						for(var/obj/txt in s.help_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2
					New()
						return
					MouseDrag()
						return
				txt_holder
					icon_state = "txt holder"
					layer = 32
					plane = 35
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/help_background/s = src.menu
						var/obj/sc = s.txt_scroller
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-245)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/ratio = -1 + ((-245 + result) / -245)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(700*ratio)

						for(var/obj/txt in s.txt_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2
							txt.translated_y = scroll_y
					New()
						return
					MouseDrag()
						return
			skills_background
				icon = 'new_hud_skills.dmi'
				icon_state = "main"
				layer = 32
				screen_loc = "1,1"
				plane = 32
				var/setup = 0
				var/ww = 0
				var/hh = 0
				var/xx = 0
				var/yy = 0
				var/obj/hud/menus/skills_background/menu
				var/obj/txt_holder
				var/obj/txt_scrollbar
				var/obj/txt_scroller
				var/obj/txt_raw
				var/obj/skills_holder
				var/obj/skills_scrollbar
				var/obj/skills_scroller
				var/skills_background_x = 300
				var/skills_background_y = 100
				var/skills_category = "All"
				var/obj/skills_name
				var/obj/skills_level
				var/obj/skills_portrait
				var/obj/bar_rating
				var/obj/bar_power
				var/obj/bar_speed
				var/obj/bar_energy
				var/obj/bar_mastery
				var/obj/bar_cooldown
				var/obj/hud/menus/skills_background/skills_exp_bar/skill_xp
				MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
					params = params2list(params)
					var/icon_y = text2num(params["icon-y"])
					if(icon_y >= 299 || usr.mouse_down)
						usr.client.MousePosition(params)
						var/matrix/m = matrix()
						var/icon_x = text2num(params["icon-x"])
						if(usr.drag_icon_x == 0) usr.drag_icon_x = icon_x
						var/x_result = usr.client.client_mouse_x-usr.drag_icon_x
						var/y_result = usr.client.client_mouse_y-src.hh
						x_result = clamp(x_result,0,1023-src.ww)
						y_result = clamp(y_result,0,575-(src.hh/2))
						m.Translate(x_result,y_result)
						src.transform = m
						src.skills_background_x = x_result
						src.skills_background_y = y_result
						usr.mouse_down = src
				proc
					skills()
						if(ismob(src.loc))
							var/mob/player = src.loc
							var/x_s = -16
							var/y_s = 232
							src.screen_loc = "1,1"
							for(var/obj/skills/s in player)
								if(s.type != /obj/skills/AA_Skill_Copy)
									x_s += 37
									if(x_s >= 278)
										x_s = 21
										y_s -= 37
									if(s.cloned == null)
										var/obj/skills/AA_Skill_Copy/sk = new
										sk.icon = s.icon
										sk.icon_state = s.icon_state
										sk.info_dmg = s.info_dmg
										sk.info_spd = s.info_spd
										sk.info_mastery = s.info_mastery
										sk.info_point_cost = s.info_point_cost
										sk.info_point_cost_type = s.info_point_cost_type
										sk.info_energy_cost = s.info_energy_cost
										sk.info_cd = s.info_cd
										sk.info_name = s.info_name
										sk.info_prerequisite = s.info_prerequisite
										sk.info_stats = s.info_stats
										sk.help_text = s.help_text
										sk.info = s.info
										sk.energy_skill = s.energy_skill
										sk.teach_energy = s.teach_energy
										sk.disabled_switch = s.disabled_switch
										sk.attack_state = s.attack_state
										sk.info_cd = s.info_cd
										sk.hud_x = x_s
										sk.hud_y = y_s
										sk.plane = 32
										sk.layer = 33
										sk.blend_mode = BLEND_INSET_OVERLAY
										sk.appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
										sk.name = s.name
										sk.cloned = "[s.name] aa_clone_aa"
										sk.loc = player
										sk.clone_of = s
										sk.cd_max = s.cd_max
										s.clone = sk
										s.cloned = "[s.name] aa_original_aa"
										var/matrix/m = matrix()
										m.Translate(x_s,y_s)
										sk.transform = m
										if(src.skills_holder)
											src.skills_holder.vis_contents -= sk
											src.skills_holder.vis_contents += sk
								else if(src.skills_holder)
									src.skills_holder.vis_contents -= s
									src.skills_holder.vis_contents += s
					menu_create()
						spawn(120)
							if(src)
								if(src.setup)
									spawn(120)
										if(src)
											world.log << "DEBUG - Found menu already."
									return
								else
									src.setup = 1
									var/icon/I = new(src.icon)
									src.ww = I.Width()
									src.hh = I.Height()

									var/matrix/m_main = matrix()
									m_main.Translate(300,100)
									src.transform = m_main

									var/obj/hud/buttons/close_menu/cm = new
									cm.plane = src.plane
									cm.closes = src
									var/matrix/close_m = matrix()
									close_m.Translate(ww-15,hh-15)
									cm.transform = close_m
									src.vis_contents += cm

									var/obj/hud/menus/skills_background/skills_holder/s1 = new
									s1.menu = src
									src.skills_holder = s1
									src.vis_contents += s1

									var/obj/hud/menus/skills_background/txt_holder/s2 = new
									s2.menu = src
									src.txt_holder = s2
									src.vis_contents += s2

									var/obj/hud/menus/skills_background/txt_raw/txt = new
									txt.hud_x = 312
									txt.hud_y = -476
									var/matrix/t_m1 = matrix()
									t_m1.Translate(txt.hud_x,txt.hud_y)
									txt.transform = t_m1
									txt.menu = src
									src.txt_raw = txt
									txt_holder.vis_contents += txt

									var/obj/hud/menus/skills_background/skills_scrollbar/sb1 = new
									sb1.menu = src
									src.skills_scrollbar = sb1
									src.vis_contents += sb1

									var/obj/hud/menus/skills_background/txt_scrollbar/sb2 = new
									sb2.menu = src
									src.txt_scrollbar = sb2
									src.vis_contents += sb2

									var/obj/hud/menus/skills_background/skills_scroller/sc1 = new
									sc1.menu = src
									src.skills_scroller = sc1
									src.vis_contents += sc1

									var/obj/hud/menus/skills_background/txt_scroller/sc2 = new
									sc2.menu = src
									src.txt_scroller = sc2
									src.vis_contents += sc2

									var/obj/hud/menus/skills_background/skills_title/st = new
									st.menu = src
									s1.vis_contents += st

									var/obj/hud/menus/skills_background/skills_overlays/overs = new
									overs.menu = src
									txt_holder.vis_contents += overs

									var/obj/hud/menus/skills_background/skills_portrait/port = new
									port.menu = src
									src.skills_portrait = port
									txt_holder.vis_contents += port

									var/obj/hud/menus/skills_background/skills_name/n = new
									var/matrix/n_m1 = matrix()
									n_m1.Translate(n.hud_x,n.hud_y)
									n.transform = n_m1
									n.menu = src
									src.skills_name = n
									txt_holder.vis_contents += n

									var/obj/hud/menus/skills_background/skills_level/lvl = new
									var/matrix/l_m1 = matrix()
									l_m1.Translate(lvl.hud_x,lvl.hud_y)
									lvl.transform = l_m1
									lvl.menu = src
									src.skills_level = lvl
									txt_holder.vis_contents += lvl

									var/obj/hud/menus/skills_background/skills_bar_power/bar1 = new
									var/matrix/b1 = matrix()
									b1.Translate(bar1.hud_x,bar1.hud_y)
									bar1.transform = b1
									bar1.menu = src
									txt_holder.vis_contents += bar1
									src.bar_power = bar1

									var/obj/hud/menus/skills_background/skills_bar_speed/bar2 = new
									var/matrix/b2 = matrix()
									b2.Translate(bar2.hud_x,bar2.hud_y)
									bar2.transform = b2
									bar2.menu = src
									txt_holder.vis_contents += bar2
									src.bar_speed = bar2

									var/obj/hud/menus/skills_background/skills_bar_energy/bar3 = new
									var/matrix/b3 = matrix()
									b3.Translate(bar3.hud_x,bar3.hud_y)
									bar3.transform = b3
									bar3.menu = src
									txt_holder.vis_contents += bar3
									src.bar_energy = bar3

									var/obj/hud/menus/skills_background/skills_bar_mastery/bar4 = new
									var/matrix/b4 = matrix()
									b4.Translate(bar4.hud_x,bar4.hud_y)
									bar4.transform = b4
									bar4.menu = src
									txt_holder.vis_contents += bar4
									src.bar_mastery = bar4

									var/obj/hud/menus/skills_background/skills_bar_cooldown/bar5 = new
									var/matrix/b5 = matrix()
									b5.Translate(bar5.hud_x,bar5.hud_y)
									bar5.transform = b5
									bar5.menu = src
									txt_holder.vis_contents += bar5
									src.bar_cooldown = bar5


									var/obj/hud/menus/skills_background/skills_icon_power/ic1 = new
									var/matrix/i1 = matrix()
									i1.Translate(ic1.hud_x,ic1.hud_y)
									ic1.transform = i1
									ic1.menu = src
									txt_holder.vis_contents += ic1

									var/obj/hud/menus/skills_background/skills_icon_speed/ic2 = new
									var/matrix/i2 = matrix()
									i2.Translate(ic2.hud_x,ic2.hud_y)
									ic2.transform = i2
									ic2.menu = src
									txt_holder.vis_contents += ic2

									var/obj/hud/menus/skills_background/skills_icon_energy/ic3 = new
									var/matrix/i3 = matrix()
									i3.Translate(ic3.hud_x,ic3.hud_y)
									ic3.transform = i3
									ic3.menu = src
									txt_holder.vis_contents += ic3

									var/obj/hud/menus/skills_background/skills_icon_mastery/ic4 = new
									var/matrix/i4 = matrix()
									i4.Translate(ic4.hud_x,ic4.hud_y)
									ic4.transform = i4
									ic4.menu = src
									txt_holder.vis_contents += ic4

									var/obj/hud/menus/skills_background/skills_icon_cooldown/ic5 = new
									var/matrix/i5 = matrix()
									i5.Translate(ic5.hud_x,ic5.hud_y)
									ic5.transform = i5
									ic5.menu = src
									txt_holder.vis_contents += ic5

									var/obj/hud/menus/skills_background/skills_exp_bar/xp = new
									var/matrix/x1 = matrix()
									x1.Translate(xp.hud_x,xp.hud_y)
									xp.transform = x1
									xp.menu = src
									txt_holder.vis_contents += xp
									src.skill_xp = xp

				skills_exp_bar
					icon = 'hud_skill_lvl_bar.dmi'
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					layer = 35
					plane = 32
					hud_x = 324
					hud_y = 193
					New()
						return
					MouseDrag()
						return
				skills_title
					icon = null
					layer = 32
					plane = 32
					maptext_width = 128
					maptext_height = 16
					maptext_x = 86
					maptext_y = 270
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					New()
						src.maptext = "[css_outline]<font size = 2><center><u>Skills</u>"
						return
					MouseDrag()
						return
				skills_icon_power
					icon = 'new_hud_skill_icons.dmi'
					icon_state = "dmg"
					layer = 33
					plane = 32
					hud_x = 387
					hud_y = 252
					box_x_scale = 128
					box_y_scale = 64
					box_x_shift = 64
					box_y_shift = 32
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseExited()
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseEntered()
						spawn(6)
							if(usr && usr.mouse_saved_loc == src)
								if(usr.info_box1)
									usr.client.screen += usr.info_box1
									usr.client.screen += usr.info_box2
									usr.client.screen += usr.info_box3
					MouseMove(location,control,params)
						..()
						usr.info_box(src,"This is the damage rating of the skill. The more bars, the higher the damage.",params)
					New()
						return
					MouseDrag()
						return
				skills_icon_speed
					icon = 'new_hud_skill_icons.dmi'
					icon_state = "spd"
					layer = 33
					plane = 32
					hud_x = 387
					hud_y = 232
					box_x_scale = 128
					box_y_scale = 50
					box_x_shift = 64
					box_y_shift = 25
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseExited()
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseEntered()
						spawn(6)
							if(usr && usr.mouse_saved_loc == src)
								if(usr.info_box1)
									usr.client.screen += usr.info_box1
									usr.client.screen += usr.info_box2
									usr.client.screen += usr.info_box3
					MouseMove(location,control,params)
						..()
						usr.info_box(src,"This is either how fast a skill projectile moves, or how fast a skill charges.",params)
					New()
						return
					MouseDrag()
						return
				skills_icon_energy
					icon = 'new_hud_skill_icons.dmi'
					icon_state = "eng"
					layer = 33
					plane = 32
					hud_x = 387
					hud_y = 212
					box_x_scale = 128
					box_y_scale = 64
					box_x_shift = 64
					box_y_shift = 32
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseExited()
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseEntered()
						spawn(6)
							if(usr && usr.mouse_saved_loc == src)
								if(usr.info_box1)
									usr.client.screen += usr.info_box1
									usr.client.screen += usr.info_box2
									usr.client.screen += usr.info_box3
					MouseMove(location,control,params)
						..()
						usr.info_box(src,"This is the energy usage of the skill. The more bars, the more energy is expended when used.",params)
					New()
						return
					MouseDrag()
						return
				skills_icon_mastery
					icon = 'new_hud_skill_icons.dmi'
					icon_state = "xp"
					layer = 33
					plane = 32
					hud_x = 387
					hud_y = 192
					box_x_scale = 152
					box_y_scale = 64
					box_x_shift = 76
					box_y_shift = 32
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseExited()
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseEntered()
						spawn(6)
							if(usr && usr.mouse_saved_loc == src)
								if(usr.info_box1)
									usr.client.screen += usr.info_box1
									usr.client.screen += usr.info_box2
									usr.client.screen += usr.info_box3
					MouseMove(location,control,params)
						..()
						usr.info_box(src,"Here you can see how quickly a skill is mastered. The more bars, the quicker it will level when used.",params)
					New()
						return
					MouseDrag()
						return
				skills_icon_cooldown
					icon = 'new_hud_skill_icons.dmi'
					icon_state = "cd"
					layer = 33
					plane = 32
					hud_x = 387
					hud_y = 172
					box_x_scale = 128
					box_y_scale = 84
					box_x_shift = 64
					box_y_shift = 42
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseExited()
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseEntered()
						spawn(6)
							if(usr && usr.mouse_saved_loc == src)
								if(usr.info_box1)
									usr.client.screen += usr.info_box1
									usr.client.screen += usr.info_box2
									usr.client.screen += usr.info_box3
					MouseMove(location,control,params)
						..()
						usr.info_box(src,"Skill cooldowns can be found here. More bars represent a higher cooldown on a skill. No bars means it has no cooldown at all.",params)
					New()
						return
					MouseDrag()
						return
				skills_bar_power
					icon = 'new_hud_skill_bars.dmi'
					icon_state = "1"
					layer = 33
					plane = 32
					hud_x = 406
					hud_y = 257
					box_x_scale = 128
					box_y_scale = 64
					box_x_shift = 64
					box_y_shift = 32
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseExited()
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseEntered()
						spawn(6)
							if(usr && usr.mouse_saved_loc == src)
								if(usr.info_box1)
									usr.client.screen += usr.info_box1
									usr.client.screen += usr.info_box2
									usr.client.screen += usr.info_box3
					MouseMove(location,control,params)
						..()
						usr.info_box(src,"This is the damage rating of the skill. The more bars, the higher the damage.",params)
					New()
						return
					MouseDrag()
						return
				skills_bar_speed
					icon = 'new_hud_skill_bars.dmi'
					icon_state = "1"
					layer = 33
					plane = 32
					hud_x = 406
					hud_y = 237
					box_x_scale = 128
					box_y_scale = 50
					box_x_shift = 64
					box_y_shift = 25
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseExited()
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseEntered()
						spawn(6)
							if(usr && usr.mouse_saved_loc == src)
								if(usr.info_box1)
									usr.client.screen += usr.info_box1
									usr.client.screen += usr.info_box2
									usr.client.screen += usr.info_box3
					MouseMove(location,control,params)
						..()
						usr.info_box(src,"This is either how fast a skill projectile moves, or how fast a skill charges.",params)
					New()
						return
					MouseDrag()
						return
				skills_bar_energy
					icon = 'new_hud_skill_bars.dmi'
					icon_state = "1"
					layer = 33
					plane = 32
					hud_x = 406
					hud_y = 217
					box_x_scale = 128
					box_y_scale = 64
					box_x_shift = 64
					box_y_shift = 32
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseExited()
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseEntered()
						spawn(6)
							if(usr && usr.mouse_saved_loc == src)
								if(usr.info_box1)
									usr.client.screen += usr.info_box1
									usr.client.screen += usr.info_box2
									usr.client.screen += usr.info_box3
					MouseMove(location,control,params)
						..()
						usr.info_box(src,"This is the energy usage of the skill. The more bars, the more energy is expended when used.",params)
					New()
						return
					MouseDrag()
						return
				skills_bar_mastery
					icon = 'new_hud_skill_bars.dmi'
					icon_state = "1"
					layer = 33
					plane = 32
					hud_x = 406
					hud_y = 197
					box_x_scale = 152
					box_y_scale = 64
					box_x_shift = 76
					box_y_shift = 32
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseExited()
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseEntered()
						spawn(6)
							if(usr && usr.mouse_saved_loc == src)
								if(usr.info_box1)
									usr.client.screen += usr.info_box1
									usr.client.screen += usr.info_box2
									usr.client.screen += usr.info_box3
					MouseMove(location,control,params)
						..()
						usr.info_box(src,"Here you can see how quickly a skill is mastered. The more bars, the quicker it will level when used.",params)
					New()
						return
					MouseDrag()
						return
				skills_bar_cooldown
					icon = 'new_hud_skill_bars.dmi'
					icon_state = "1"
					layer = 33
					plane = 32
					hud_x = 406
					hud_y = 177
					box_x_scale = 128
					box_y_scale = 84
					box_x_shift = 64
					box_y_shift = 42
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseExited()
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseEntered()
						spawn(6)
							if(usr && usr.mouse_saved_loc == src)
								if(usr.info_box1)
									usr.client.screen += usr.info_box1
									usr.client.screen += usr.info_box2
									usr.client.screen += usr.info_box3
					MouseMove(location,control,params)
						..()
						usr.info_box(src,"Skill cooldowns can be found here. More bars represent a higher cooldown on a skill. No bars means it has no cooldown at all.",params)
					New()
						return
					MouseDrag()
						return
				skills_name
					icon = null
					layer = 32
					plane = 32
					maptext_width = 128
					maptext_height = 34
					maptext_x = 322
					maptext_y = 272
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					New()
						src.maptext = "[css_outline]<font size = 1><center>Skill Name"
						return
					MouseDrag()
						return
				skills_level
					icon = null
					layer = 32
					plane = 32
					maptext_width = 128
					maptext_height = 34
					maptext_x = 285
					maptext_y = 177
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					New()
						src.maptext = "[css_outline]<font size = 1><center>Level: 100"
						return
					MouseDrag()
						return
				skills_portrait
					icon = 'new_hud_skills.dmi'
					icon_state = "skills portrait"
					layer = 32
					plane = 32
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					hud_x = 312
					hud_y = 222
					New()
						return
					MouseDrag()
						return
				skills_overlays
					icon = 'new_hud_skills.dmi'
					icon_state = "skills overlays"
					layer = 32
					plane = 32
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					New()
						return
					MouseDrag()
						return
				skills_holder
					icon = 'new_hud_skills.dmi'
					icon_state = "skills holder"
					layer = 32
					plane = 32
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/skills_background/s = src.menu
						var/obj/sc = s.skills_scroller

						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-218)

						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result
						var/ratio = -1 + ((-218 + result) / -218)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(200*ratio)

						for(var/obj/txt in s.skills_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2
					New()
						return
					MouseDrag()
						return
				txt_holder
					icon = 'new_hud_skills.dmi'
					icon_state = "txt holder"
					layer = 32
					plane = 32
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/skills_background/s = src.menu
						var/obj/sc = s.txt_scroller
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-245)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/ratio = -1 + ((-245 + result) / -245)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(700*ratio)

						for(var/obj/txt in s.txt_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2
							txt.translated_y = scroll_y
					New()
						return
					MouseDrag()
						return
				txt_raw
					icon = null
					icon_state = null
					maptext_width = 147
					maptext_height = 640
					plane = 32
					layer = 34
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				txt_scrollbar
					icon = 'new_hud_skills.dmi'
					icon_state = "txt scrollbar"
					layer = 32
					plane = 32
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/skills_background/s = src.menu
						var/obj/sc = s.txt_scroller
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-245)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/ratio = -1 + ((-245 + result) / -245)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(700*ratio)

						for(var/obj/txt in s.txt_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.translated_y = scroll_y
							txt.transform = m2
					Click(location,control,params)
						var/obj/hud/menus/skills_background/s = src.menu
						var/obj/sc = s.txt_scroller
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/result = -218 + ((usr.mouse_y_true-s.skills_background_y)-54)
						result = clamp(result,0,-245)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/ratio = -1 + ((-245 + result) / -245)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(700*ratio)

						for(var/obj/txt in s.txt_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.translated_y = scroll_y
							txt.transform = m2
					New()
						return
					MouseDrag()
						return
				skills_scrollbar
					icon = 'new_hud_skills.dmi'
					icon_state = "skills scrollbar"
					layer = 32
					plane = 32
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/skills_background/s = src.menu
						var/obj/sc = s.skills_scroller
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-245)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/ratio = -1 + ((-245 + result) / -245)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(200*ratio)

						for(var/obj/txt in s.skills_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2
					Click(location,control,params)
						var/obj/hud/menus/skills_background/s = src.menu
						var/obj/sc = s.skills_scroller
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/result = -218 + ((usr.mouse_y_true-s.skills_background_y)-54)
						result = clamp(result,0,-245)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/ratio = -1 + ((-245 + result) / -245)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(200*ratio)

						for(var/obj/txt in s.skills_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2
					New()
						return
					MouseDrag()
						return
				txt_scroller
					icon = 'new_hud_skills.dmi'
					icon_state = "txt scroller"
					layer = 32
					plane = 32
					MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
						var/obj/hud/menus/skills_background/s = src.menu

						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						//var/result = -218 + (usr.mouse_y_true-54) //54 is the size of the scroller x 2 (basically its height in pixels). -285 seems is how many pixels from bottom of menu.
						var/result = -218 + ((usr.mouse_y_true-s.skills_background_y)-54)
						result = clamp(result,0,-245)
						var/matrix/m = matrix()
						m.Translate(0,result)
						src.transform = m
						src.translated_y = result

						var/ratio = -1 + ((-245 + result) / -245)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(700*ratio)

						for(var/obj/txt in s.txt_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2
							txt.translated_y = scroll_y
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/skills_background/s = src.menu
						var/obj/sc = s.txt_scroller

						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-218)

						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result
						var/ratio = -1 + ((-218 + result) / -218)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(700*ratio)

						for(var/obj/txt in s.txt_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2
							txt.translated_y = scroll_y
				skills_scroller
					icon = 'new_hud_skills.dmi'
					icon_state = "skills scroller"
					layer = 32
					plane = 32
					MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
						var/obj/hud/menus/skills_background/s = src.menu

						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						//var/result = -218 + (usr.mouse_y_true-54) //54 is the size of the scroller x 2 (basically its height in pixels). -285 seems is how many pixels from bottom of menu.
						var/result = -218 + ((usr.mouse_y_true-s.skills_background_y)-54)
						result = clamp(result,0,-245)
						var/matrix/m = matrix()
						m.Translate(0,result)
						src.transform = m
						src.translated_y = result

						var/ratio = -1 + ((-245 + result) / -245)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(200*ratio)

						for(var/obj/txt in s.skills_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/skills_background/s = src.menu
						var/obj/sc = s.skills_scroller

						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-218)

						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result
						var/ratio = -1 + ((-218 + result) / -218)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(200*ratio)

						for(var/obj/txt in s.skills_holder.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2
			core_stats_background
				icon = 'new_hud_core_stats2.dmi'
				icon_state = "main no bar"
				layer = 33
				screen_loc = "1,1"
				plane = 24
				var/xx = 0
				var/yy = 0
				var/ww = 0
				var/hh = 0
				var/icon/I
				var/obj/pane_stats
				var/obj/pane_char
				var/obj/char_portrait
				var/setup = 0
				var/menu_x = 0
				var/menu_y = 0
				var/obj/bar_energy
				var/obj/bar_power
				var/obj/bar_rating
				var/obj/bar_strength
				var/obj/bar_endurance
				var/obj/bar_force
				var/obj/bar_resistance
				var/obj/bar_offence
				var/obj/bar_defence
				var/obj/bar_combat
				var/obj/bar_oxygen_shell
				var/obj/bar_hunger_shell
				var/obj/bar_thirst_shell
				var/obj/bar_tiredness_shell
				var/obj/bar_toxicity_shell
				var/obj/bar_oxygen
				var/obj/bar_hunger
				var/obj/bar_thirst
				var/obj/bar_tiredness
				var/obj/bar_toxicity
				var/obj/bar_heat
				var/obj/bar_cold
				var/obj/bar_gravity
				var/obj/bar_microwaves
				var/obj/bar_radiation
				var/obj/bar_toxins
				var/obj/bar_heat_negative
				var/obj/bar_cold_negative
				var/obj/bar_gravity_negative
				var/obj/bar_microwaves_negative
				var/obj/bar_radiation_negative
				var/obj/bar_toxins_negative
				var/obj/hud/menus/core_stats_background/stat_mod_txt/mod_energy
				var/obj/hud/menus/core_stats_background/stat_mod_txt/mod_rating
				var/obj/hud/menus/core_stats_background/stat_mod_txt/mod_power
				var/obj/hud/menus/core_stats_background/stat_mod_txt/mod_strength
				var/obj/hud/menus/core_stats_background/stat_mod_txt/mod_endurance
				var/obj/hud/menus/core_stats_background/stat_mod_txt/mod_force
				var/obj/hud/menus/core_stats_background/stat_mod_txt/mod_resistance
				var/obj/hud/menus/core_stats_background/stat_mod_txt/mod_offence
				var/obj/hud/menus/core_stats_background/stat_mod_txt/mod_defence
				var/obj/hud/menus/core_stats_background/stat_mod_txt/mod_regen
				var/obj/hud/menus/core_stats_background/stat_mod_txt/mod_recov
				var/obj/hud/menus/core_stats_background/stat_mod_txt/mod_agility
				var/obj/hud/menus/core_stats_background/stat_mod_txt/mod_divine
				var/obj/hud/menus/core_stats_background/stat_mod_txt/mod_dark
				var/obj/hud/menus/core_stats_background/stat_mod_txt/mod_tech
				var/obj/hud/menus/core_stats_background/stat_mod_txt/mod_combat
				var/obj/hud/menus/core_stats_background/stat_mod_txt/mod_arcane
				var/obj/hud/menus/core_stats_background/stat_mod_txt/text_mod_power
				var/obj/hud/menus/core_stats_background/stat_mod_txt/text_mod_strength
				var/obj/hud/menus/core_stats_background/stat_mod_txt/text_mod_endurance
				var/obj/hud/menus/core_stats_background/stat_mod_txt/text_mod_agility
				var/obj/hud/menus/core_stats_background/stat_mod_txt/text_mod_force
				var/obj/hud/menus/core_stats_background/stat_mod_txt/text_mod_resistance
				var/obj/hud/menus/core_stats_background/stat_mod_txt/text_mod_offence
				var/obj/hud/menus/core_stats_background/stat_mod_txt/text_mod_defence
				var/obj/name_info
				var/obj/race_info
				var/obj/origin_info
				var/obj/sex_info
				var/obj/age_physical_info
				var/obj/age_soul_info
				var/obj/class_info
			//	var/obj/age_old_info
				//var/obj/lifespan_info
				var/obj/occupation_info
				var/obj/vigour_info
				var/list/bars
				var/list/tabs
				var/list/tab1
				var/list/tab2
				var/list/tab3
				var/list/tab4
				var/vis_x = 111
				var/vis_y = 282
				var/obj/hud/menus/core_stats_background/menu
				var/obj/scroller_main
				var/obj/scrollbar_main
				var/power_info
				var/rating_info
				var/energy_info
				var/str_info
				var/end_info
				var/agility_info
				var/force_info
				var/res_info
				var/off_info
				var/def_info
				var/regen_info
				var/recov_info
				var/combat_info
				var/obj/mastered_grav
				var/obj/mastered_micro
				var/obj/hunger_info
				var/obj/thirst_info
				var/obj/tiredness_info
				var/obj/hud/menus/core_stats_background/stat_txt/oxygen_info
				var/obj/hud/menus/core_stats_background/stat_txt/heat_info
				var/obj/hud/menus/core_stats_background/stat_txt/cold_info
				var/obj/hud/menus/core_stats_background/stat_txt/gravity_info
				var/obj/hud/menus/core_stats_background/stat_txt/microwaves_info
				var/obj/hud/menus/core_stats_background/stat_txt/radiation_info
				var/obj/hud/menus/core_stats_background/stat_txt/toxins_info
				var/obj/hud/menus/core_stats_background/stat_txt/toxicity_info
				var/tab_selected = "stats"

				MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
					params = params2list(params)
					var/icon_y = text2num(params["icon-y"])
					if(icon_y >= 331 || usr.mouse_down)
						usr.client.MousePosition(params)
						var/matrix/m = matrix()
						var/icon_x = text2num(params["icon-x"])
						if(usr.drag_icon_x == 0) usr.drag_icon_x = icon_x
						var/x_result = usr.client.client_mouse_x-usr.drag_icon_x
						var/y_result = usr.client.client_mouse_y-src.hh
						x_result = clamp(x_result,0,1023-src.ww)
						y_result = clamp(y_result,0,575-(src.hh/2))
						m.Translate(x_result,y_result)
						src.transform = m
						src.menu_x = x_result
						src.menu_y = y_result
						usr.mouse_down = src






				proc
					portrait_look(var/mob/player)
						if(player.port)
							src.char_portrait.overlays = null
							var/obj/port_copy = new
							port_copy.icon = player.port.icon
							port_copy.icon_state = player.port.icon_state
							port_copy.plane = 24
							port_copy.layer = player.port.layer+32
							port_copy.appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
							port_copy.pixel_y = 1
							src.char_portrait.overlays += port_copy
							for(var/obj/portrait/p in player.port.vis_contents)
								var/obj/o = new
								o.icon = p.icon
								o.icon_state = p.icon_state
								o.plane = 24
								o.layer = p.layer+32
								o.appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
								o.pixel_y = 1
								src.char_portrait.overlays += o
					player_info(var/mob/player)
						//Place the players origin on the character screen, then update the mouse over info

						//Generic player info
						src.name_info.maptext = "[css_outline]<font size = 1><left>Name: [player.name]"
						src.sex_info.maptext = "[css_outline]<font size = 1><left>Sex: [player.gen]"
						src.race_info.maptext = "[css_outline]<font size = 1><left>Race: [player.race]"
						src.class_info.maptext = "[css_outline]<font size=1><left>Ki: [round(player.percent_energy)]%"
						src.vigour_info.maptext = "[css_outline]<font size=1><left>Health: [round(player.percent_health)]%"
						//Age related
						src.age_physical_info.maptext = "[css_outline]<font size = 1><left>Physical Age: [round(player.age,0.1)]"
						src.age_soul_info.maptext = "[css_outline]<font size = 1><left>True Age: [round(player.age_soul,0.1)]"
					//	src.age_old_info.maptext = "[css_outline]<font size = 1><left>Old Age: [round(player.oldage,0.1)]"
						src.occupation_info.maptext = "[css_outline]<font size = 1><left>Occupation: [player.occupation]"
						src.name_info.maptext_width = 1000
						src.occupation_info.maptext_width = 1000
						//if(src.offline_time) src.offlinetime_info.maptext = "[css_outline]<font size = 1><left>Occupation: [player.occupation]"
					mods(var/mob/player)
						spawn(3)
							if(src && src.loc)
								if(src.tab_selected == "stats")
									var/lift_raw = player.strength + (player.endurance * 4)
									var/lift_kg = round(4.5 + lift_raw * 0.45359237 * 0.01, 0.01)
									var/lift_lbs = round(4.5 + lift_raw * 0.01, 0.01)
									player.lift_raw = lift_raw
									player.lift_kg = lift_kg
									player.lift_lbs = lift_lbs

									var/display_kg = "[lift_kg]"
									var/display_lbs = "[lift_lbs]"

									if(!isnum(lift_kg) || !isnum(lift_lbs))
										display_kg = "???"
										display_lbs = "???"
									//var/lift_kg = round((player.strength + (player.endurance * 4)) * 0.45359237 * 0.01, 0.01)
									//var/lift_lbs = round((player.strength + (player.endurance * 4)) * 0.01, 0.01)
									mod_power.maptext = "[css_outline]<font size = 1><left>[css_psionic_power][Commas(player.rating)]"
									//src.mod_power.txt_info = "[src.power_info]\n\n<u>Sources</u><br>Training: <font color = green>+ [Commas(player.gains_trained_power*player.mod_psionic_power_base)]<font color = white>"
									mod_energy.maptext = "[css_outline]<font size = 1><left>[css_energy][Commas(player.energy)]<font color = white>+"
									//src.mod_energy.txt_info = "[src.energy_info]\n\n<u>Sources</u><br>Training: <font color = green>+ [Commas(player.gains_trained_energy*player.mod_energy_base)] ([player.gains_trained_energy_mod])<br><font color = white>Toning: <font color = green>+ [Commas(player.gains_psiforged_energy*player.mod_energy_base)] ([player.gains_psiforged_energy_mod])<br><font color = white>Items: <font color = green>+ [Commas(player.gains_items_energy*player.mod_energy_base)] ([player.gains_items_energy_mod])<font color = white><br>Temporary: [energy_temp]<font color = white><br>Injuries: [energy_injury]"
									mod_strength.maptext = "[css_outline]<font size = 1><left>[css_strength][(player.TextPercent(round(player.strength),1))]"
								//	src.mod_strength.txt_info = "[src.str_info]\n\n<u>Sources</u><br>Training: <font color = green>+ [Commas(player.gains_trained_strength*player.mod_strength_base)] ([player.gains_trained_strength_mod])<br><font color = white>Items: <font color = green>+ [Commas(player.gains_items_strength*player.mod_strength_base)] ([player.gains_items_strength_mod])<font color = white><br>Temporary: [strength_temp]<font color = white><br>Injuries: [strength_injury]"

									mod_endurance.maptext = "[css_outline]<font size = 1><left>[css_endurance][(player.TextPercent(round(player.endurance),1))]"
								//	src.mod_endurance.txt_info = "[src.end_info]\n\n<u>Sources</u><br>Training: <font color = green>+ [Commas(player.gains_trained_endurance*player.mod_endurance_base)] ([player.gains_trained_endurance_mod])<br><font color = white><br>Items: <font color = green>+ [Commas(player.gains_items_endurance*player.mod_endurance_base)] ([player.gains_items_endurance_mod])<font color = white><br>Temporary: [endurance_temp]<font color = white><br>Injuries: [endurance_injury]"

									mod_force.maptext = "[css_outline]<font size = 1><left>[css_force][(player.TextPercent(round(player.force),1))]"
								//	src.mod_force.txt_info = "[src.force_info]\n\n<u>Sources</u><br>Training: <font color = green>+ [Commas(player.gains_trained_force*player.mod_force_base)] ([player.gains_trained_force_mod])<br><font color = white> Items: <font color = green>+ [Commas(player.gains_items_force*player.mod_force_base)] ([player.gains_items_force_mod])<font color = white><br>Temporary: [force_temp]<font color = white><br>Injuries: [force_injury]"

									mod_resistance.maptext = "[css_outline]<font size = 1><left>[css_resistance][(player.TextPercent(round(player.resistance),1))]"
								//	src.mod_resistance.txt_info = "[src.res_info]\n\n<u>Sources</u><br>Training: <font color = green>+ [Commas(player.gains_trained_resistance*player.mod_resistance_base)] ([player.gains_trained_resistance_mod])<br><font color = white>Items: <font color = green>+ [Commas(player.gains_items_resistance*player.mod_resistance_base)] ([player.gains_items_resistance_mod])<font color = white><br>Temporary: [resistance_temp]<font color = white><br>Injuries: [resistance_injury]"

									mod_offence.maptext = "[css_outline]<font size = 1><left>[css_off][(player.TextPercent(round(player.offence),1))]"
								//	src.mod_offence.txt_info = "[src.off_info]\n\n<u>Sources</u><br>Training: <font color = green>+ [Commas(player.gains_trained_off*player.mod_offence_base)] ([player.gains_trained_off_mod])<br><font color = white>Items: <font color = green>+ [Commas(player.gains_items_off*player.mod_offence_base)] ([player.gains_items_off_mod])<font color = white><br>Temporary: [off_temp]<font color = white><br>Injuries: [off_injury]"

									mod_defence.maptext = "[css_outline]<font size = 1><left>[css_def][(player.TextPercent(round(player.defence),1))]"
								//	src.mod_defence.txt_info = "[src.def_info]\n\n<u>Sources</u><br>Training: <font color = green>+ [Commas(player.gains_trained_def*player.mod_defence_base)] ([player.gains_trained_def_mod])<br><font color = white>Items: <font color = green>+ [Commas(player.gains_items_def*player.mod_defence_base)] ([player.gains_items_def_mod])<font color = white><br>Temporary: [def_temp]<font color = white><br>Injuries: [def_injury]"
									//src.mod_agility.maptext = "[css_outline]<font size = 1><left>[css_lift][round((player.strength+player.endurance*4)*0.45359237)*0.01] kg ([round(player.strength+player.endurance*4)*0.01] lbs)"

									mod_agility.maptext = "[css_outline]<font size=1><left>[css_lift][display_kg] kg ([display_lbs] lbs)"
									//src.mod_agility.maptext = "[css_outline]<font size=1><left>[css_lift][lift_kg] kg ([lift_lbs] lbs)"

								//	src.mod_agility.maptext = "[css_outline]<font size=1><left>[css_lift][num2text((player.strength + player.endurance * 4) * 0.45359237) * 0.01] kg ([num2text((player.strength + player.endurance * 4) * 0.01)] lbs)"

									mod_agility.txt_info = "Can Lift: How much weight you can lift and carry.<font color = white>"
									var/display_num = (player.intxp * 10000)/10000
									//var/display_text = num2text(display_num, 0)  // force full integer string, no exponential
									//if(display_num >= 1000)
									mod_regen.maptext = "[css_outline]<font size=1><left>[css_int][FormatIntXP(display_num)]%"
								//	else
									//	src.mod_regen.maptext = "[css_outline]<font size=1><left>[css_int][num2text(display_num, 3)]%"
									//src.mod_regen.maptext = "[css_outline]<font size = 1><left>[css_int][(round(player.intxp*10000,0.01))/round(10000,0.1)]%"
									mod_regen.txt_info = "Quality Percentage: The quality of your intellecutual capabilities."
									mod_regen.maptext_width = 1000
									mod_recov.maptext = "[css_outline]<font size = 1><left>[css_magic][(round(player.magicxp*10000,0.01))/round(10000,0.1)]%"
									mod_recov.txt_info = "Magical Efficiency: The efficiency of your magical capabilities."

									mod_divine.maptext = "[css_outline]<font size = 1><left>[css_divine][Commas(player.divine_energy)] ([player.divine_energy_mod])"
									mod_dark.maptext = "[css_outline]<font size = 1><left>[css_dark][Commas(player.dark_matter)] ([player.dark_matter_mod])"
									mod_tech.maptext = "[css_outline]<font size = 1><left>[css_tech] ([player.mod_tech_potential])"
							// MOVE LEVEL STUFF
									mod_combat.maptext = "[css_outline]<font size = 1><left>[css_combat][player.move_lvl]"
									mod_rating.maptext = "[css_outline]<font size = 1><left>[css_rating][Commas(player.rating)]"
									mod_rating.txt_info = "[src.rating_info]\n\n<u>Sources</u><br>Training: <font color = green>+ ([round(player.gains_trained_rating_mod,0.01)])"
									mod_agility.maptext_width = 1000

					bars(var/mob/player)
						if(src && src.loc)
							if(stat_xp_bar && src.tab_selected == "stats")
								src.overlays = null
								var/list/stats = list(player.rating_exp, player.energy_exp, player.strength_exp, player.endurance_exp, player.force_exp, player.resistance_exp, player.offence_exp, player.defence_exp, player.movelvl_exp)
								var/n = 9
								while(n)
									var/obj/hud/menus/core_stats_background/stat_exp_bar_shell/shell = src.bars[n]
									var/s = stats[n]

									if(s <= 0)
										s = 1

									var/matrix/m = matrix()

									if(shell.icon_state == "bar combat")
										// clamp
										if(s > 1000) s = 1000

										// convert 0..1000 into 0..100 (because the bar art is 100px wide)
										var/pixels = s / 10

										// guarantee minimum 1 pixel
										if(pixels < 1) pixels = 1

										m.Scale(pixels, 1)
										m.Translate(shell.vis_x + round(pixels / 2), shell.vis_y)
									else
										// original logic
										if(s > 100) s = 100
										m.Scale(s, 1)
										m.Translate(shell.vis_x + round(s / 2), shell.vis_y)


									stat_xp_bar.transform = m
									src.overlays += stat_xp_bar
									n -= 1
									//sleep(0.1)

							src.mods(player)
							src.player_info(player)

							if(src.tab_selected == "survival")
								var/matrix/m_p = matrix()
								m_p.Scale((player.toxicity/200)*100,1)
								m_p.Translate(src.bar_toxicity.hud_x+round(((player.toxicity/200)*100)/2),src.bar_toxicity.hud_y)
								src.bar_toxicity.transform = m_p
								src.toxicity_info.maptext = "[css_outline]<font size = 1><left>[round(player.toxicity)]/200"

								if(player.need_o2 == "Yes")
									var/matrix/m_o = matrix()
									m_o.Scale((player.o2/player.o2_max)*100,1)
									m_o.Translate(src.bar_oxygen.hud_x+round(((player.o2/player.o2_max)*100)/2),src.bar_oxygen.hud_y)
									src.bar_oxygen.transform = m_o
									src.oxygen_info.maptext = "[css_outline]<font size = 1><left>[round(player.o2)]/[round(player.o2_max)]"
								else
									src.bar_oxygen_shell.icon_state = "N/A"
									src.bar_oxygen.icon = null

								if(player.need_food == "Yes")
									//var/matrix/m1 = matrix()
									//var/hunger_scale = player.hunger * 81 / 100 // Normalize scale (0 to 1)
								//	m1.Scale(hunger_scale,1)
								//	m1.Translate(src.bar_hunger.hud_x+round(player.hunger/2),src.bar_hunger.hud_y)
									//src.bar_hunger.transform = m1
									//src.hunger_info.maptext = "[css_outline]<font size = 1><left>([round(player.metabolic_rate,0.01)])"
									src.bar_hunger_shell.maptext = "[css_outline]<font size = 1><left>[round(player.hunger)]%"
									//src.hunger_info.maptext = "[css_outline]<font size = 1><left>[round(player.hunger)]%/100% ([round(player.metabolic_rate,0.01)])"
								else
									src.bar_hunger_shell.maptext = "[css_outline]<font size = 1><left>[round(player.hunger)]%"
								//	src.bar_hunger.icon = null

								if(player.need_water == "Yes")
									//src.thirst_info.maptext = "[css_outline]<font size = 1><left>([round(player.dehydration_rate,0.01)])"
									src.bar_thirst_shell.maptext = "[css_outline]<font size = 1><left>[round(player.thirst)]%"
									//src.thirst_info.maptext = "[css_outline]<font size = 1><left>[round(player.thirst)]%/100% ([round(player.dehydration_rate,0.01)])"
								else
									src.bar_thirst_shell.maptext = "[css_outline]<font size = 1><left>[round(player.thirst)]%"
									src.bar_thirst.icon = null

								if(player.need_sleep == "Yes")
									src.bar_tiredness_shell.maptext = "[css_outline]<font size = 1><left>[round(player.restedness)]%"

								else
									src.bar_tiredness_shell.icon_state = "[css_outline]<font size = 1><left>[round(player.restedness)]%"
									src.bar_tiredness.icon = null

								//Masteries
								var/col = "<font color = white>"
								if(player.grav >= (player.gravity_mastered*2)) col = "<font color = red>"
								else if(player.grav >= (player.gravity_mastered*1.6)) col = "<font color = #DF7126>"
								else if(player.grav >= (player.gravity_mastered*1.3)) col = "<font color = #DCD42F>"
								else if(player.grav > player.gravity_mastered) col = "<font color = green>"
								else if(player.grav <= player.gravity_mastered) col = "<font color = green>"
								src.mastered_grav.maptext = "[css_outline]<font size = 1><left>[col]x[player.grav]<font color = white> | x[round(player.gravity_mastered,0.1)]"

								/*col = "<font color = white>"
								if(player.microwaves >= (player.microwaves_mastered*2)) col = "<font color = red>"
								else if(player.microwaves >= (player.microwaves_mastered*1.6)) col = "<font color = #DF7126>"
								else if(player.microwaves >= (player.microwaves_mastered*1.3)) col = "<font color = #DCD42F>"
								else if(player.microwaves > player.microwaves_mastered) col = "<font color = green>"
								src.mastered_micro.maptext = "[css_outline]<font size = 1><left>[col][player.microwaves]<font color = white> | [round(player.microwaves_mastered,0.1)]"
								*/



								/*var/matrix/m00 = matrix()
								pix = player.toxicity
								if(pix > 100) pix = 100
								m00.Scale(pix,1)
								m00.Translate(src.bar_toxicity.hud_x+round(pix/2),src.bar_toxicity.hud_y)
								src.bar_toxicity.transform = m00
								src.toxicity_info.maptext = "[css_outline]<font size = 1><left>[round(player.toxicity)]%"*/

							/*	//Heat immunity bar
								if(player.mod_immune_heat < 0)
									pix_neg = round(100-(abs(player.mod_immune_heat)*50))
									if(pix_neg < 0) pix_neg = 0
									pix = 0
								else
									pix = round(player.mod_immune_heat*50)
									if(pix > 100) pix = 100
									pix_neg = 100

								var/matrix/m4_neg = matrix()
								m4_neg.Scale(pix_neg,1)
								m4_neg.Translate(src.bar_heat_negative.hud_x+round(pix_neg/2),src.bar_heat_negative.hud_y)
								src.bar_heat_negative.transform = m4_neg

								var/matrix/m4 = matrix()
								m4.Scale(pix,1)
								m4.Translate(src.bar_heat.hud_x+round(pix/2),src.bar_heat.hud_y)
								src.bar_heat.transform = m4
								src.heat_info.maptext = "[css_outline]<font size = 1><left>[round(player.mod_immune_heat*100,0.01)]%"

								//Cold immunity bar
								if(player.mod_immune_cold < 0)
									pix_neg = round(100-(abs(player.mod_immune_cold)*50))
									if(pix_neg < 0) pix_neg = 0
									pix = 0
								else
									pix = round(player.mod_immune_cold*50)
									if(pix > 100) pix = 100
									pix_neg = 100

								var/matrix/m5_neg = matrix()
								m5_neg.Scale(pix_neg,1)
								m5_neg.Translate(src.bar_cold_negative.hud_x+round(pix_neg/2),src.bar_cold_negative.hud_y)
								src.bar_cold_negative.transform = m5_neg

								var/matrix/m5 = matrix()
								m5.Scale(pix,1)
								m5.Translate(src.bar_cold.hud_x+round(pix/2),src.bar_cold.hud_y)
								src.bar_cold.transform = m5
								src.cold_info.maptext = "[css_outline]<font size = 1><left>[round(player.mod_immune_cold*100,0.01)]%"

								*/

								//Gravity immunity bar
								//if(player.mod_immune_gravity < 0)
								//	pix_neg = round(100-(abs(player.mod_immune_gravity)*50))
								//	if(pix_neg < 0) pix_neg = 0
								//	pix = 0
							//	else
								//	pix = round(player.mod_immune_gravity*50)
								//	if(pix > 100) pix = 100
								//	pix_neg = 100

							//	var/matrix/m6_neg = matrix()
							//	m6_neg.Scale(pix_neg,1)
							//	m6_neg.Translate(src.bar_gravity_negative.hud_x+round(pix_neg/2),src.bar_gravity_negative.hud_y)
								//src.bar_gravity_negative.transform = m6_neg

								//var/matrix/m6 = matrix()
							//	m6.Scale(pix,1)
							//	m6.Translate(src.bar_gravity.hud_x+round(pix/2),src.bar_gravity.hud_y)
							//	//src.bar_gravity.transform = m6
							//	src.gravity_info.maptext = "[css_outline]<font size = 1><left>[round(player.mod_immune_gravity*100,0.01)]%"

								//Microwaves immunity bar
							//	if(player.mod_immune_microwaves < 0)
								//	pix_neg = round(100-(abs(player.mod_immune_microwaves)*50))
								//	if(pix_neg < 0) pix_neg = 0
								//	pix = 0
								//else
								//	pix = round(player.mod_immune_microwaves*50)
								//	if(pix > 100) pix = 100
								//	pix_neg = 100

							//	var/matrix/m7_neg = matrix()
								//m7_neg.Scale(pix_neg,1)
							//	m7_neg.Translate(src.bar_microwaves_negative.hud_x+round(pix_neg/2),src.bar_microwaves_negative.hud_y)
							//	src.bar_microwaves_negative.transform = m7_neg

								//var/matrix/m7 = matrix()
								//m7.Scale(pix,1)
							//	m7.Translate(src.bar_microwaves.hud_x+round(pix/2),src.bar_microwaves.hud_y)
							//	src.bar_microwaves.transform = m7
							//	src.microwaves_info.maptext = "[css_outline]<font size = 1><left>[round(player.mod_immune_microwaves*100,0.01)]%"

							/*	//Radiation immunity bar
								if(player.mod_immune_rads < 0)
									pix_neg = round(100-(abs(player.mod_immune_rads)*50))
									if(pix_neg < 0) pix_neg = 0
									pix = 0
								else
									pix = round(player.mod_immune_rads*50)
									if(pix > 100) pix = 100
									pix_neg = 100

								var/matrix/m8_neg = matrix()
								m8_neg.Scale(pix_neg,1)
								m8_neg.Translate(src.bar_radiation_negative.hud_x+round(pix_neg/2),src.bar_radiation_negative.hud_y)
								src.bar_radiation_negative.transform = m8_neg

								var/matrix/m8 = matrix()
								m8.Scale(pix,1)
								m8.Translate(src.bar_radiation.hud_x+round(pix/2),src.bar_radiation.hud_y)
								src.bar_radiation.transform = m8
								src.radiation_info.maptext = "[css_outline]<font size = 1><left>[round(player.mod_immune_rads*100,0.01)]%"

								//Toxins immunity bar
								if(player.mod_immune_toxins < 0)
									pix_neg = round(100-(abs(player.mod_immune_toxins)*50))
									if(pix_neg < 0) pix_neg = 0
									pix = 0
								else
									pix = round(player.mod_immune_toxins*50)
									if(pix > 100) pix = 100
									pix_neg = 100

								var/matrix/m9_neg = matrix()
								m9_neg.Scale(pix_neg,1)
								m9_neg.Translate(src.bar_toxins_negative.hud_x+round(pix_neg/2),src.bar_toxins_negative.hud_y)
								src.bar_toxins_negative.transform = m9_neg

								var/matrix/m9 = matrix()
								m9.Scale(pix,1)
								m9.Translate(src.bar_toxins.hud_x+round(pix/2),src.bar_toxins.hud_y)
								src.bar_toxins.transform = m9
								src.toxins_info.maptext = "[css_outline]<font size = 1><left>[round(player.mod_immune_toxins*100,0.01)]%"
								*/


					menu_create()
						if(src.setup) return
						src.setup = 1
						src.rating_info = "Your Rating Points:\n\n<font color=white>A number that scales into multipliers for your core stats and offsprings."
						src.power_info = "Current (Ratings)\n\n<font color = white>\n\nMost of your core stats are scaled to your currently available [css_psionic_power]Rating Pts<font color = white>.\n\nWhen you gain [css_psionic_power]Rating<font color = white> from training, the amount you gain increases faster as you cycle."
					//	src.energy_info = "Current/Max (Mod)\n\n<font color = white>The first number is your currently available [css_energy]Energy<font color = white> and the second is your max [css_energy]Energy<font color = white>.\n\nThe number in parenthesis is your [css_energy]Energy<font color = white> mod.\n\nMany skills require [css_energy]Energy<font color = white> to use and maintain.\n\nWhen you gain [css_energy]Energy<font color = white> from training, the amount you gain is directly determined by the second number in parenthesis."
						src.energy_info = "\nEnergy"
						src.end_info = "\nEndurance"
						src.str_info = "\nStrength"
						src.force_info = "\nForce"
						src.res_info = "\nResistance"
						src.off_info = "\nOffence"
						src.def_info = "\nDefence"
						src.combat_info = "Move Lvl."
						src.regen_info = "Regeneration"
						src.recov_info = "Recovery"
						src.agility_info = "Agility"
						//src.end_info = "\n\n<font color = white>The first number is your current [css_endurance]Endurance<font color = white> and the second is your [css_endurance]Endurance<font color = white> mod.\n\nHow much damage you can take in melee combat is determined by [css_endurance]Endurance<font color = white> and is countered by [css_strength]Strength<font color = white>.\n\nWhen you gain [css_endurance]Endurance<font color = white> from training, the amount you gain is directly determined by the second number in parenthesis."
					//	src.str_info = "\n\n<font color = white>This is your current [css_strength]Strength<font color = white> and the second number is your [css_strength]Strength<font color = white> mod.\n\nHow hard you hit in melee is determined by your [css_strength]Strength<font color = white> and is countered by [css_endurance]Endurance<font color = white>.\n\nWhen you gain [css_strength]Strength<font color = white> from training, the amount you gain is directly determined by the second number in parenthesis."
						//src.force_info = "\n\n<font color = white>This is your current [css_force]Force<font color = white> and the second number is your [css_force]Force<font color = white> mod.\n\nHow much damage is done via energy-based skills is determined by [css_force]Force<font color = white> and is countered by [css_resistance]Resistance<font color = white>.\n\nWhen you gain [css_force]Force<font color = white> from training, the amount you gain is directly determined by the second number in parenthesis."
						//src.res_info = "\n\n<font color = white>The first number is your current [css_resistance]Resistance<font color = white> and the second is your [css_resistance]Resistance<font color = white> mod.\n\nHow much damage mitigated from energy-based skills is determined by [css_resistance]Resistance<font color = white> and is countered by [css_force]Force<font color = white>.\n\nWhen you gain [css_resistance]Resistance<font color = white> from training, the amount you gain is directly determined by the second number in parenthesis."
						//src.off_info = "\n\n<font color = white>This is your current [css_off]Offence<font color = white> statistic and the second number is your [css_off]Offence<font color = white> mod.\n\nThe chance to hit someone in melee and sometimes with energy-based skills is determined by [css_off]Offence<font color = white> and is countered by [css_def]Defence<font color = white>.\n\n20% of your [css_agility]Agility<font color = white> mod is added toward melee hit chance.\n\nWhen you gain [css_off]Offence<font color = white> from training, the amount you gain is directly determined by the second number in parenthesis."
						//src.def_info = "\n\n<font color = white>This is your current [css_def]Defence<font color = white> statistic and the second number is your [css_def]Defence<font color = white> mod.\n\nThe chance to dodge melee attacks and deflect energy-based skills is determined by [css_def]Defence<font color = white> and is countered by [css_off]Offence<font color = white>.\n\n20% of your [css_agility]Agility<font color = white> mod is added toward melee dodge chance and energy-based skill deflection.\n\nWhen you gain [css_def]Defence<font color = white> from training, the amount you gain is directly determined by the second number in parenthesis."
						//src.combat_info = "Level\n\n<font color = white>This is your [css_combat]Move Level<font color = white>, which takes all the time your spent training and your rating pts earned and adds them into a pool to get this number.\n\nEvery 10 levels grants a Trait Point that can be used to unlock Traits and customize Stances."
						//src.regen_info = "(Mod)\n\n<font color = white>This is your [css_regen]Regeneration<font color = white> mod, which determines how quickly your health bar and organic body parts heal.\n\nUnlike most other core stats, [css_regen]Regeneration<font color = white> is represented only as a mod and is hard to increase."
					//	src.recov_info = "(Mod)\n\n<font color = white>This is your [css_recov]Recovery<font color = white> mod, which determines how quickly your [css_energy]Energy<font color = white> replenishes.\n\nUnlike most other core stats, [css_recov]Recovery<font color = white> is represented only as a mod and is hard to increase.\n\n[css_recov]Recovery<font color = white> also has a big impact on the cooldown for some skills and how fast they charge."
						//src.agility_info = "(Mod)\n\n<font color = white>This is your [css_agility]Agility<font color = white> mod, which determines how fast you can attack in melee and also with some energy-based skills.\n\nUnlike most other core stats, [css_agility]Agility<font color = white> is represented only as a mod and is hard to increase.\n\n[css_agility]Agility<font color = white> also adds 20% of itself to your [css_off]Offence<font color = white> and [css_def]Defence<font color = white> mods."

						src.bars = list()
						src.tabs = list()
						src.tab1 = list()
						src.tab2 = list()
						//src.tab3 = list()
					//	src.tab4 = list()

					//	var/matrix/m_main = matrix()
					//	m_main.Translate(300,100)
					//	src.transform = m_main

						src.I = new(src.icon)
						src.ww = I.Width()
						src.hh = I.Height()

						var/obj/hud/buttons/close_menu/cm = new
						cm.plane = src.plane
						cm.closes = src
						var/matrix/close_m = matrix()
						close_m.Translate(ww-15,hh-15)
						cm.transform = close_m
						src.vis_contents += cm

						var/obj/hud/menus/core_stats_background/stat_pane/sp = new
						src.pane_stats = sp
						src.vis_contents += sp

						var/obj/hud/menus/core_stats_background/stat_tab/tab1 = new
						tab1.maptext = "[css_outline]<font size = 1><center>Stats"
						tab1.tab = "stats"
						tab1.menu = src
						tab1.icon_state = "selected"
						tab1.selected = 1
						tab1.hud_x = 8
						tab1.hud_y = 314
						var/matrix/m_tab1 = matrix()
						m_tab1.Translate(tab1.hud_x,tab1.hud_y)
						tab1.transform = m_tab1
						src.vis_contents += tab1
						src.tabs += tab1

						var/obj/hud/menus/core_stats_background/stat_tab/tab2 = new
						tab2.maptext = "[css_outline]<font size = 1><center>Survival"
						tab2.tab = "survival"
						tab2.menu = src
						tab2.hud_x = 159
						tab2.hud_y = 314
						var/matrix/m_tab2 = matrix()
						m_tab2.Translate(tab2.hud_x,tab2.hud_y)
						tab2.transform = m_tab2
						src.vis_contents += tab2
						src.tabs += tab2

						/*var/obj/hud/menus/core_stats_background/stat_tab/tab3 = new
						tab3.maptext = "[css_outline]<font size = 1><center>Masteries"
						tab3.tab = "masteries"
						tab3.menu = src
						tab3.hud_x = 158
						tab3.hud_y = 314
						var/matrix/m_tab3 = matrix()
						m_tab3.Translate(tab3.hud_x,tab3.hud_y)
						tab3.transform = m_tab3
						src.vis_contents += tab3
						src.tabs += tab3*/

					/*	var/obj/hud/menus/core_stats_background/stat_tab/tab4 = new
						tab4.maptext = "[css_outline]<font size = 1><center>Status Effects"
						tab4.tab = "effects"
						tab4.menu = src
						tab4.hud_x = 233
						tab4.hud_y = 314
						var/matrix/m_tab4 = matrix()
						m_tab4.Translate(tab4.hud_x,tab4.hud_y)
						tab4.transform = m_tab4
						src.vis_contents += tab4
						src.tabs += tab4*/

						var/obj/hud/menus/core_stats_background/stat_char_pane/scp = new
						src.pane_char = scp
						src.vis_contents += scp

						var/obj/hud/menus/core_stats_background/scrollbar_main/scrollbar1 = new
						scrollbar1.menu = src
						src.scrollbar_main = scrollbar1
						//src.vis_contents += scrollbar1

						var/obj/hud/menus/core_stats_background/scroller_main/scroller1 = new
						scroller1.menu = src
						src.scroller_main = scroller1
						//src.vis_contents += scroller1

						var/obj/hud/menus/core_stats_background/stat_portrait/port = new
						var/matrix/m_port = matrix()
						m_port.Translate(port.hud_x,port.hud_y)
						port.transform = m_port
						src.char_portrait = port
						scp.vis_contents += port
						port.menu = src

						var/obj/hud/menus/core_stats_background/stat_char_txt/txt_name = new
						txt_name.hud_x = 76
						txt_name.hud_y = 404
						txt_name.maptext_x = 2
						txt_name.maptext_y = 2
						txt_name.maptext = "[css_outline]<font size = 1><left>Name:"
						txt_name.menu = src
						var/matrix/t_m1 = matrix()
						t_m1.Translate(txt_name.hud_x,txt_name.hud_y)
						txt_name.transform = t_m1
						scp.vis_contents += txt_name
						src.name_info = txt_name

						var/obj/hud/menus/core_stats_background/stat_char_txt/txt_race = new
						txt_race.hud_x = 76
						txt_race.hud_y = 388
						txt_race.maptext_x = 2
						txt_race.maptext_y = 2
						txt_race.maptext = "[css_outline]<font size = 1><left>Race:"
						txt_race.menu = src
						var/matrix/t_m3 = matrix()
						t_m3.Translate(txt_race.hud_x,txt_race.hud_y)
						txt_race.transform = t_m3
						scp.vis_contents += txt_race
						src.race_info = txt_race

						var/obj/hud/menus/core_stats_background/stat_char_txt/txt_sex = new
						txt_sex.hud_x = 76
						txt_sex.hud_y = 372
						txt_sex.maptext_x = 2
						txt_sex.maptext_y = 2
						txt_sex.maptext = "[css_outline]<font size = 1><left>Sex:"
						txt_sex.menu = src
						var/matrix/t_m4 = matrix()
						t_m4.Translate(txt_sex.hud_x,txt_sex.hud_y)
						txt_sex.transform = t_m4
						scp.vis_contents += txt_sex
						src.sex_info = txt_sex

						var/obj/hud/menus/core_stats_background/stat_char_txt/txt_vigour = new
						txt_vigour.hud_x = 76
						txt_vigour.hud_y = 356
						txt_vigour.maptext_x = 2
						txt_vigour.maptext_y = 2
						txt_vigour.maptext = "[css_outline]<font size = 1><left>Health: 100%"
						txt_vigour.menu = src
						var/matrix/t_m9 = matrix()
						t_m9.Translate(txt_vigour.hud_x,txt_vigour.hud_y)
						txt_vigour.transform = t_m9
						scp.vis_contents += txt_vigour
						src.vigour_info = txt_vigour

						var/obj/hud/menus/core_stats_background/stat_char_txt/txt_origin = new
						txt_origin.hud_x = 76
						txt_origin.hud_y = 338
						txt_origin.maptext_x = 2
						txt_origin.maptext_y = 2
						txt_origin.maptext = "[css_outline]<font size = 1><left>Ki:100%"
						txt_origin.menu = src
						var/matrix/t_m5 = matrix()
						t_m5.Translate(txt_origin.hud_x,txt_origin.hud_y)
						txt_origin.transform = t_m5
						scp.vis_contents += txt_origin
						src.class_info = txt_origin

						var/obj/hud/menus/core_stats_background/stat_char_txt/txt_age_physical = new
						txt_age_physical.hud_x = 180
						txt_age_physical.hud_y = 388
						txt_age_physical.maptext_x = 2
						txt_age_physical.maptext_y = 2
						txt_age_physical.maptext = "[css_outline]<font size = 1><left>Physical Age:"
						txt_age_physical.menu = src
						var/matrix/t_m6 = matrix()
						t_m6.Translate(txt_age_physical.hud_x,txt_age_physical.hud_y)
						txt_age_physical.transform = t_m6
						scp.vis_contents += txt_age_physical
						src.age_physical_info = txt_age_physical

						var/obj/hud/menus/core_stats_background/stat_char_txt/txt_age_soul = new
						txt_age_soul.hud_x = 180
						txt_age_soul.hud_y = 372
						txt_age_soul.maptext_x = 2
						txt_age_soul.maptext_y = 2
						txt_age_soul.maptext = "[css_outline]<font size = 1><left>True Age:"
						txt_age_soul.menu = src
						var/matrix/t_m7 = matrix()
						t_m7.Translate(txt_age_soul.hud_x,txt_age_soul.hud_y)
						txt_age_soul.transform = t_m7
						scp.vis_contents += txt_age_soul
						src.age_soul_info = txt_age_soul

						/*var/obj/hud/menus/core_stats_background/stat_char_txt/txt_age_old = new
						txt_age_old.hud_x = 180
						txt_age_old.hud_y = 372
						txt_age_old.maptext_x = 2
						txt_age_old.maptext_y = 2
						txt_age_old.maptext = "[css_outline]<font size = 1><left>Old Age:"
						txt_age_old.menu = src
						var/matrix/t_m8 = matrix()
						t_m8.Translate(txt_age_old.hud_x,txt_age_old.hud_y)
						txt_age_old.transform = t_m8
						scp.vis_contents += txt_age_old
						src.age_old_info = txt_age_old*/

						var/obj/hud/menus/core_stats_background/stat_char_txt/txt_occupation_span = new
						txt_occupation_span.hud_x = 180
						txt_occupation_span.hud_y = 404
						txt_occupation_span.maptext_x = 2
						txt_occupation_span.maptext_y = 2
						txt_occupation_span.maptext = "[css_outline]<font size = 1><left>Occupation: N/A"
						txt_occupation_span.menu = src
						var/matrix/t_m10 = matrix()
						t_m10.Translate(txt_occupation_span.hud_x,txt_occupation_span.hud_y)
						txt_occupation_span.transform = t_m10
						scp.vis_contents += txt_occupation_span
						src.occupation_info = txt_occupation_span


						var/obj/hud/menus/core_stats_background/stat_txt/txt_title0 = new
						txt_title0.hud_x = 12
						txt_title0.hud_y = 293
						txt_title0.maptext_x = 2
						txt_title0.maptext_y = 2
						txt_title0.maptext = "[css_outline]<font size = 1><left><u>Stat Info"
						txt_title0.txt_info = "<font size = 1><text align=left valign=top>[tooltip_core_stats]"
						var/matrix/m_i0 = matrix()
						m_i0.Translate(txt_title0.hud_x,txt_title0.hud_y)
						txt_title0.transform = m_i0
						//src.vis_contents += txt_title0
						//src.tab1 += txt_title0

						var/obj/hud/menus/core_stats_background/stat_txt/txt1 = new
						txt1.hud_x = 12
						txt1.hud_y = 277
						txt1.maptext_x = 2
						txt1.maptext_y = 2
						txt1.maptext = "[css_outline]<font size = 1><left>[css_psionic_power]Ratings"
						txt1.txt_info = "[css_psionic_power]<font size = 1><text align=left valign=top>[tooltip_rating]"
						var/matrix/t1_m = matrix()
						t1_m.Translate(txt1.hud_x,txt1.hud_y)
						txt1.transform = t1_m
						src.vis_contents += txt1
						src.tab1 += txt1

						var/obj/hud/menus/core_stats_background/stat_mod_txt/mod_txt1 = new
						mod_txt1.hud_x = 192
						mod_txt1.hud_y = 277
						mod_txt1.maptext_x = 2
						mod_txt1.maptext_y = 2
						mod_txt1.maptext = "[css_outline]<font size = 1><left>[css_rating]1"
						mod_txt1.txt_info = "Current (Rating)\n\n<font color = white>Most of your core stats are handled by personal gains which [css_psionic_power]Rating Pts<font color = white> increases."
						var/matrix/mod1_m = matrix()
						mod1_m.Translate(mod_txt1.hud_x,mod_txt1.hud_y)
						mod_txt1.transform = mod1_m
						src.vis_contents += mod_txt1
						src.mod_power = mod_txt1
						src.mod_rating = mod_txt1
						src.tab1 += mod_txt1

						var/obj/hud/menus/core_stats_background/stat_exp_bar_shell/b1 = new
						b1.vis_x = 89
						b1.vis_y = 282
						b1.menu = src
						b1.icon_state = "bar power"
						src.vis_contents += b1
						src.bar_power = b1
						src.tab1 += b1

						var/obj/hud/menus/core_stats_background/stat_txt/txt2 = new
						txt2.hud_x = 12
						txt2.hud_y = 261
						txt2.maptext_x = 2
						txt2.maptext_y = 2
						txt2.maptext = "[css_outline]<font size = 1><left><u>Stat Info"
						txt2.txt_info = "<font size = 1><text align=left valign=top>[tooltip_core_stats]"
						var/matrix/t2_m = matrix()
						t2_m.Translate(txt2.hud_x,txt2.hud_y)
						txt2.transform = t2_m
						src.vis_contents += txt2
						src.tab1 += txt2

						var/obj/hud/menus/core_stats_background/stat_mod_txt/mod_txt2 = new
						mod_txt2.hud_x = 192
						mod_txt2.hud_y = 261
						mod_txt2.maptext_x = 2
						mod_txt2.maptext_y = 2
						mod_txt2.maptext = "[css_outline]<font size = 1><left>[css_energy]100 (2)"
						mod_txt2.txt_info = "Current (Mod)\n\n<font color = white>The first number is your currently available [css_energy]Energy<font color = white> and the second is your [css_energy]Energy<font color = white> mod.\n\nMany skills require [css_energy]Energy<font color = white> to use and maintain.\n\nWhen you gain [css_energy]Energy<font color = white> from training, the amount you gain is directly determined by the second number in parenthesis."
						var/matrix/mod2_m = matrix()
						mod2_m.Translate(mod_txt2.hud_x,mod_txt2.hud_y)
						mod_txt2.transform = mod2_m
					//	src.vis_contents += mod_txt2
						src.mod_energy = mod_txt2
					//	src.tab1 += mod_txt2

						var/obj/hud/menus/core_stats_background/stat_exp_bar_shell/b2 = new
						b2.vis_x = 0
						b2.vis_y = 0
						//b2.menu = src
						//b2.icon_state = "bar energy"
					//	src.vis_contents += b2
					//	src.bar_energy = b2
					//	src.tab1 += b2

						var/obj/hud/menus/core_stats_background/stat_txt/txt3 = new
						txt3.hud_x = 12
						txt3.hud_y = 245
						txt3.maptext_x = 2
						txt3.maptext_y = 2
						txt3.maptext = "[css_outline]<font size = 1><left>[css_strength]Strength"
						txt3.txt_info = "[css_strength]<font size = 1><text align=left valign=top>[tooltip_strength]"
						var/matrix/t3_m = matrix()
						t3_m.Translate(txt3.hud_x,txt3.hud_y)
						txt3.transform = t3_m
						src.vis_contents += txt3
						src.tab1 += txt3

						var/obj/hud/menus/core_stats_background/stat_mod_txt/mod_txt3 = new
						mod_txt3.hud_x = 192
						mod_txt3.hud_y = 245
						mod_txt3.maptext_x = 2
						mod_txt3.maptext_y = 2
						mod_txt3.maptext = "[css_outline]<font size = 1><left>[css_strength]Extremely Low"
						mod_txt3.txt_info = "Current (Mod)\n\n<font color = white>This is your current [css_strength]Strength<font color = white> and the second number is your [css_strength]Strength<font color = white> mod.\n\nHow hard you hit in melee is determined by your [css_strength]Strength<font color = white> and is countered by [css_endurance]Endurance<font color = white>.\n\nWhen you gain [css_strength]Strength<font color = white> from training, the amount you gain is directly determined by the second number in parenthesis."
						var/matrix/mod3_m = matrix()
						mod3_m.Translate(mod_txt3.hud_x,mod_txt3.hud_y)
						mod_txt3.transform = mod3_m
						src.vis_contents += mod_txt3
						src.mod_strength = mod_txt3
						src.tab1 += mod_txt3

						var/obj/hud/menus/core_stats_background/stat_exp_bar_shell/b3 = new
						b3.vis_x = 89
						b3.vis_y = 250
						b3.icon_state = "bar strength"
						src.vis_contents += b3
						src.bar_strength = b3
						src.tab1 += b3

						var/obj/hud/menus/core_stats_background/stat_txt/txt4 = new
						txt4.hud_x = 12
						txt4.hud_y = 229
						txt4.maptext_x = 2
						txt4.maptext_y = 2
						txt4.maptext = "[css_outline]<font size = 1><left>[css_endurance]Endurance"
						txt4.txt_info = "[css_endurance]<font size = 1><text align=left valign=top>[tooltip_endurance]"
						var/matrix/t4_m = matrix()
						t4_m.Translate(txt4.hud_x,txt4.hud_y)
						txt4.transform = t4_m
						src.vis_contents += txt4
						src.tab1 += txt4

						var/obj/hud/menus/core_stats_background/stat_mod_txt/mod_txt4 = new
						mod_txt4.hud_x = 192
						mod_txt4.hud_y = 229
						mod_txt4.maptext_x = 2
						mod_txt4.maptext_y = 2
						mod_txt4.maptext = "[css_outline]<font size = 1><left>[css_endurance]Extremely Low"
						mod_txt4.txt_info = "Current (Mod)\n\n<font color = white>The first number is your current [css_endurance]Endurance<font color = white> and the second is your [css_endurance]Endurance<font color = white> mod.\n\nHow much damage you can take in melee combat is determined by [css_endurance]Endurance<font color = white> and is countered by [css_strength]Strength<font color = white>.\n\nWhen you gain [css_endurance]Endurance<font color = white> from training, the amount you gain is directly determined by the second number in parenthesis."
						var/matrix/mod4_m = matrix()
						mod4_m.Translate(mod_txt4.hud_x,mod_txt4.hud_y)
						mod_txt4.transform = mod4_m
						src.vis_contents += mod_txt4
						src.mod_endurance = mod_txt4
						src.tab1 += mod_txt4

						var/obj/hud/menus/core_stats_background/stat_exp_bar_shell/b4 = new
						b4.vis_x = 89
						b4.vis_y = 234
						b4.icon_state = "bar endurance"
						src.vis_contents += b4
						src.bar_endurance = b4
						src.tab1 += b4

						var/obj/hud/menus/core_stats_background/stat_txt/txt5 = new
						txt5.hud_x = 12
						txt5.hud_y = 213//214
						txt5.maptext_x = 2
						txt5.maptext_y = 2
						txt5.maptext = "[css_outline]<font size = 1><left>[css_force]Force"
						txt5.txt_info = "[css_force]<font size = 1><text align=left valign=top>[tooltip_force]"
						var/matrix/t5_m = matrix()
						t5_m.Translate(txt5.hud_x,txt5.hud_y)
						txt5.transform = t5_m
						src.vis_contents += txt5
						src.tab1 += txt5

						var/obj/hud/menus/core_stats_background/stat_mod_txt/mod_txt5 = new
						mod_txt5.hud_x = 192
						mod_txt5.hud_y = 213
						mod_txt5.maptext_x = 2
						mod_txt5.maptext_y = 2
						mod_txt5.maptext = "[css_outline]<font size = 1><left>[css_force]Extremely Low"
						mod_txt5.txt_info = "Current (Mod)\n\n<font color = white>This is your current [css_force]Force<font color = white> and the second number is your [css_force]Force<font color = white> mod.\n\nHow much damage is done via energy-based skills is determined by [css_force]Force<font color = white> and is countered by [css_resistance]Resistance<font color = white>.\n\nWhen you gain [css_force]Force<font color = white> from training, the amount you gain is directly determined by the second number in parenthesis."
						var/matrix/mod5_m = matrix()
						mod5_m.Translate(mod_txt5.hud_x,mod_txt5.hud_y)
						mod_txt5.transform = mod5_m
						src.vis_contents += mod_txt5
						src.mod_force = mod_txt5
						src.tab1 += mod_txt5

						var/obj/hud/menus/core_stats_background/stat_exp_bar_shell/b5 = new
						b5.vis_x = 89
						b5.vis_y = 218
						b5.icon_state = "bar force"
						src.vis_contents += b5
						src.bar_force = b5
						src.tab1 += b5

						var/obj/hud/menus/core_stats_background/stat_txt/txt6 = new
						txt6.hud_x = 12
						txt6.hud_y = 197//230
						txt6.maptext_x = 2
						txt6.maptext_y = 2
						txt6.maptext = "[css_outline]<font size = 1><left>[css_resistance]Resistance"
						txt6.txt_info = "[css_resistance]<font size = 1><text align=left valign=top>[tooltip_resistance]"
						var/matrix/t6_m = matrix()
						t6_m.Translate(txt6.hud_x,txt6.hud_y)
						txt6.transform = t6_m
						src.vis_contents += txt6
						src.tab1 += txt6

						var/obj/hud/menus/core_stats_background/stat_mod_txt/mod_txt6 = new
						mod_txt6.hud_x = 192
						mod_txt6.hud_y = 197
						mod_txt6.maptext_x = 2
						mod_txt6.maptext_y = 2
						mod_txt6.maptext = "[css_outline]<font size = 1><left>[css_resistance]Extremely Low"
						mod_txt6.txt_info = "Current (Mod)\n\n<font color = white>The first number is your current [css_resistance]Resistance<font color = white> and the second is your [css_resistance]Resistance<font color = white> mod.\n\nHow much damage mitigated from energy-based skills is determined by [css_resistance]Resistance<font color = white> and is countered by [css_force]Force<font color = white>.\n\nWhen you gain [css_resistance]Resistance<font color = white> from training, the amount you gain is directly determined by the second number in parenthesis."
						var/matrix/mod6_m = matrix()
						mod6_m.Translate(mod_txt6.hud_x,mod_txt6.hud_y)
						mod_txt6.transform = mod6_m
						src.vis_contents += mod_txt6
						src.mod_resistance = mod_txt6
						src.tab1 += mod_txt6

						var/obj/hud/menus/core_stats_background/stat_exp_bar_shell/b6 = new
						b6.vis_x = 89
						b6.vis_y = 202
						b6.icon_state = "bar resistance"
						src.vis_contents += b6
						src.bar_resistance = b6
						src.tab1 += b6

						var/obj/hud/menus/core_stats_background/stat_txt/txt7 = new
						txt7.hud_x = 12
						txt7.hud_y = 181//198
						txt7.maptext_x = 2
						txt7.maptext_y = 2
						txt7.maptext = "[css_outline]<font size = 1><left>[css_off]Offence"
						txt7.txt_info = "[css_off]<font size = 1><text align=left valign=top>[tooltip_offence]"
						var/matrix/t7_m = matrix()
						t7_m.Translate(txt7.hud_x,txt7.hud_y)
						txt7.transform = t7_m
						src.vis_contents += txt7
						src.tab1 += txt7

						var/obj/hud/menus/core_stats_background/stat_mod_txt/mod_txt7 = new
						mod_txt7.hud_x = 192
						mod_txt7.hud_y = 181
						mod_txt7.maptext_x = 2
						mod_txt7.maptext_y = 2
						mod_txt7.maptext = "[css_outline]<font size = 1><left>[css_off]Extremely Low"
						mod_txt7.txt_info = "Current (Mod)\n\n<font color = white>This is your current [css_off]Offence<font color = white> statistic and the second number is your [css_off]Offence<font color = white> mod.\n\nThe chance to hit someone in melee and sometimes with energy-based skills is determined by [css_off]Offence<font color = white> and is countered by [css_def]Defence<font color = white>.\n\n20% of your [css_agility]Agility<font color = white> mod is added toward melee hit chance.\n\nWhen you gain [css_off]Offence<font color = white> from training, the amount you gain is directly determined by the second number in parenthesis."
						var/matrix/mod7_m = matrix()
						mod7_m.Translate(mod_txt7.hud_x,mod_txt7.hud_y)
						mod_txt7.transform = mod7_m
						src.vis_contents += mod_txt7
						src.mod_offence = mod_txt7
						src.tab1 += mod_txt7

						var/obj/hud/menus/core_stats_background/stat_exp_bar_shell/b7 = new
						b7.vis_x = 89
						b7.vis_y = 186
						b7.icon_state = "bar offence"
						src.vis_contents += b7
						src.bar_offence = b7
						src.tab1 += b7

						var/obj/hud/menus/core_stats_background/stat_txt/txt8 = new
						txt8.hud_x = 12
						txt8.hud_y = 165//182
						txt8.maptext_x = 2
						txt8.maptext_y = 2
						txt8.maptext = "[css_outline]<font size = 1><left>[css_def]Defence"
						txt8.txt_info = "[css_def]<font size = 1><text align=left valign=top>[tooltip_defence]"
						var/matrix/t8_m = matrix()
						t8_m.Translate(txt8.hud_x,txt8.hud_y)
						txt8.transform = t8_m
						src.vis_contents += txt8
						src.tab1 += txt8

						var/obj/hud/menus/core_stats_background/stat_mod_txt/mod_txt8 = new
						mod_txt8.hud_x = 192
						mod_txt8.hud_y = 165
						mod_txt8.maptext_x = 2
						mod_txt8.maptext_y = 2
						mod_txt8.maptext = "[css_outline]<font size = 1><left>[css_def]Extremely Low"
						mod_txt8.txt_info = "Current (Mod)\n\n<font color = white>This is your current [css_def]Defence<font color = white> statistic and the second number is your [css_def]Defence<font color = white> mod.\n\nThe chance to dodge melee attacks and deflect energy-based skills is determined by [css_def]Defence<font color = white> and is countered by [css_off]Offence<font color = white>.\n\n20% of your [css_agility]Agility<font color = white> mod is added toward melee dodge chance and energy-based skill deflection.\n\nWhen you gain [css_def]Defence<font color = white> from training, the amount you gain is directly determined by the second number in parenthesis."
						var/matrix/mod8_m = matrix()
						mod8_m.Translate(mod_txt8.hud_x,mod_txt8.hud_y)
						mod_txt8.transform = mod8_m
						src.vis_contents += mod_txt8
						src.mod_defence = mod_txt8
						src.tab1 += mod_txt8

						var/obj/hud/menus/core_stats_background/stat_exp_bar_shell/b8 = new
						b8.vis_x = 89
						b8.vis_y = 170
						b8.icon_state = "bar defence"
						src.vis_contents += b8
						src.bar_defence = b8
						src.tab1 += b8

						var/obj/hud/menus/core_stats_background/stat_txt/txt11 = new
						txt11.hud_x = 12
						txt11.hud_y = 149
						txt11.maptext_x = 2
						txt11.maptext_y = 2
						txt11.maptext = "[css_outline]<font size = 1><left>[css_combat]Move Level"
						txt11.txt_info = "[css_combat]<font size = 1><text align=left valign=top>[tooltip_combat_levels]"
						var/matrix/t11_m = matrix()
						t11_m.Translate(txt11.hud_x,txt11.hud_y)
						txt11.transform = t11_m
						src.vis_contents += txt11
						src.tab1 += txt11

						var/obj/hud/menus/core_stats_background/stat_mod_txt/mod_txt11 = new
						mod_txt11.hud_x = 192
						mod_txt11.hud_y = 149
						mod_txt11.maptext_x = 2
						mod_txt11.maptext_y = 2
						mod_txt11.maptext = "[css_outline]<font size = 1><left>[css_combat]1"
						mod_txt11.txt_info = "Move Level\n\n<font color=white>This is the relative overall level of your character based on the time you spent training scaled by your [css_psionic_power]Rating Pts<font color=white>\n\nEverytime you gain a [css_combat]Move Level<font color = white> chances of learning new abilities increases.<font color = white>.\n"
						var/matrix/mod11_m = matrix()
						mod11_m.Translate(mod_txt11.hud_x,mod_txt11.hud_y)
						mod_txt11.transform = mod11_m
						src.vis_contents += mod_txt11
						src.mod_combat = mod_txt11
						src.tab1 += mod_txt11

						var/obj/hud/menus/core_stats_background/stat_exp_bar_shell/b11 = new
						b11.vis_x = 89
						b11.vis_y = 154
						b11.icon_state = "bar combat"
						src.vis_contents += b11
						src.bar_combat = b11
						src.tab1 += b11

						var/obj/hud/menus/core_stats_background/stat_txt/txt9 = new
						txt9.hud_x = 12
						txt9.hud_y = 133
						txt9.maptext_x = 2
						txt9.maptext_y = 2
						txt9.maptext = "[css_outline]<font size = 1><left>[css_lift]Quality Percentage:"
						txt9.txt_info = "[css_regen]<font size = 1><text align=left valign=top>[tooltip_regen]"
						var/matrix/t9_m = matrix()
						t9_m.Translate(txt9.hud_x,txt9.hud_y)
						txt9.transform = t9_m
						src.vis_contents += txt9
						src.tab1 += txt9

						var/obj/hud/menus/core_stats_background/stat_mod_txt/mod_txt9 = new
						mod_txt9.hud_x = 192
						mod_txt9.hud_y = 133
						mod_txt9.maptext_x = 2
						mod_txt9.maptext_y = 2
						mod_txt9.maptext = "[css_outline]<font size = 1><left>[css_lift]8%"
						mod_txt9.txt_info = "(Mod)\n\n<font color = white>This is your [css_regen]Intelligence<font color = white>, which determines the quality of items you can create.\n\nHigher % unlocks more paths of technology, [css_regen]Quality Percentage<font color = white> is represented only as a % because and is quite difficult to increase for non intelligient species.\n"
						var/matrix/mod9_m = matrix()
						mod9_m.Translate(mod_txt9.hud_x,mod_txt9.hud_y)
						mod_txt9.transform = mod9_m
						src.vis_contents += mod_txt9
						src.mod_regen = mod_txt9
						src.tab1 += mod_txt9

						var/obj/hud/menus/core_stats_background/stat_txt/txt10 = new
						txt10.hud_x = 12
						txt10.hud_y = 117
						txt10.maptext_x = 2
						txt10.maptext_y = 2
						txt10.maptext = "[css_outline]<font size = 1><left>[css_lift]Magical Efficiency:"
						txt10.txt_info = "[css_recov]<font size = 1><text align=left valign=top>[tooltip_recovery]"
						var/matrix/t10_m = matrix()
						t10_m.Translate(txt10.hud_x,txt10.hud_y)
						txt10.transform = t10_m
						src.vis_contents += txt10
						src.tab1 += txt10

						var/obj/hud/menus/core_stats_background/stat_mod_txt/mod_txt10 = new
						mod_txt10.hud_x = 192
						mod_txt10.hud_y = 117
						mod_txt10.maptext_x = 2
						mod_txt10.maptext_y = 2
						mod_txt10.maptext = "[css_outline]<font size = 1><left>[css_recov]5%"
						mod_txt10.txt_info = "Can Lift\n\n<font color = white>This is your [css_recov]Lift<font color = white>, which determines how strong your attacks are, and how much weight you can wear \n\nUnlike most other core stats, [css_recov]Lift<font color = white> is represented and scaled by all physical stats into one.<font color = white>"
						var/matrix/mod10_m = matrix()
						mod10_m.Translate(mod_txt10.hud_x,mod_txt10.hud_y)
						mod_txt10.transform = mod10_m
						src.vis_contents += mod_txt10
						src.mod_recov = mod_txt10
						src.tab1 += mod_txt10

						var/obj/hud/menus/core_stats_background/stat_txt/txt0 = new
						txt0.hud_x = 12
						txt0.hud_y = 101
						txt0.maptext_x = 2
						txt0.maptext_y = 2
						txt0.maptext = "[css_outline]<font size = 1><left>[css_lift]Can Lift"
						txt0.txt_info = "[css_agility]<font size = 1><text align=left valign=top>[tooltip_agility]"
						var/matrix/t0_m = matrix()
						t0_m.Translate(txt0.hud_x,txt0.hud_y)
						txt0.transform = t0_m
						src.vis_contents += txt0
						src.tab1 += txt0

						var/obj/hud/menus/core_stats_background/stat_mod_txt/mod_txt0 = new
						mod_txt0.hud_x = 192
						mod_txt0.hud_y = 101
						mod_txt0.maptext_x = 1
						mod_txt0.maptext_y = 1
						mod_txt0.maptext_width = 256
						//mod_txt0.maptext_height = 32
						mod_txt0.maptext = "[css_outline]<font size = 1><left>[css_lift]0.01 kg (0.01 lbs)"
						//mod_txt0.txt_info = ""

						var/matrix/mod0_m = matrix()

						mod0_m.Translate(mod_txt0.hud_x,mod_txt0.hud_y)

						mod_txt0.transform = mod0_m
						src.vis_contents += mod_txt0
						src.mod_agility = mod_txt0
						src.tab1 += mod_txt0


						var/obj/hud/menus/core_stats_background/stat_txt/txt_title1 = new
						txt_title1.hud_x = 12
						txt_title1.hud_y = 85
						txt_title1.maptext_x = 2
						txt_title1.maptext_y = 2
						txt_title1.maptext = "[css_outline]<font size = 1><left><hr><u>________________________________________________________________________________________________________________________________________</u></hr>"
						txt_title1.txt_info = "<font size = 1><text align=left valign=top>[tooltip_secondary_stats]"
						var/matrix/m_i1 = matrix()
						m_i1.Translate(txt_title1.hud_x,txt_title1.hud_y)
						txt_title1.transform = m_i1
						src.vis_contents += txt_title1
						src.tab1 += txt_title1

						var/obj/hud/menus/core_stats_background/stat_txt/txt01 = new
						txt01.maptext_width = 128
						txt01.hud_x = 12
						txt01.hud_y = 69
						txt01.maptext_x = 2
						txt01.maptext_y = 2
						txt01.maptext = "[css_outline]<font size = 1><left>[css_divine]Divine Energy"
						txt01.txt_info = "[css_divine]<font size = 1><text align=left valign=top>Divine Energy\n\n<font color = white>[text_divine_energy]"
						var/matrix/t01_m = matrix()
						t01_m.Translate(txt01.hud_x,txt01.hud_y)
						txt01.transform = t01_m
						//src.vis_contents += txt01
						//src.tab1 += txt01

						var/obj/hud/menus/core_stats_background/stat_mod_txt/mod_txt01 = new
						mod_txt01.hud_x = 192
						mod_txt01.hud_y = 69
						mod_txt01.maptext_x = 2
						mod_txt01.maptext_y = 2
						mod_txt01.maptext = "[css_outline]<font size = 1><left>[css_divine]1000 (3)"
						mod_txt01.txt_info = "Current (Mod)\n\n<font color = white>This is how much [css_divine]Divine Energy<font color = white> you have stored inside your body and the second number is your [css_divine]Divine Energy<font color = white> mod."
						var/matrix/mod01_m = matrix()
						mod01_m.Translate(mod_txt01.hud_x,mod_txt01.hud_y)
						mod_txt01.transform = mod01_m
						//src.vis_contents += mod_txt01
						src.mod_divine = mod_txt01
						//src.tab1 += mod_txt01

						var/obj/hud/menus/core_stats_background/stat_txt/txt02 = new
						txt02.maptext_width = 128
						txt02.hud_x = 12
						txt02.hud_y = 53
						txt02.maptext_x = 2
						txt02.maptext_y = 2
						txt02.maptext = "[css_outline]<font size = 1><left>[css_dark]Dark Matter"
						txt02.txt_info = "[css_dark]<font size = 1><text align=left valign=top>Dark Matter\n\n<font color = white>[text_dark_matter]"
						var/matrix/t02_m = matrix()
						t02_m.Translate(txt02.hud_x,txt02.hud_y)
						txt02.transform = t02_m
					//	src.vis_contents += txt02
					//	src.tab1 += txt02

						var/obj/hud/menus/core_stats_background/stat_mod_txt/mod_txt02 = new
						mod_txt02.hud_x = 192
						mod_txt02.hud_y = 53
						mod_txt02.maptext_x = 2
						mod_txt02.maptext_y = 2
						mod_txt02.maptext = "[css_outline]<font size = 1><left>[css_dark]1000 (3)"
						mod_txt02.txt_info = "Current (Mod)\n\n<font color = white>This is how much [css_dark]Dark Matter<font color = white> you have stored inside your body and the second number is your [css_dark]Dark Matter<font color = white> mod."
						var/matrix/mod02_m = matrix()
						mod02_m.Translate(mod_txt02.hud_x,mod_txt02.hud_y)
						mod_txt02.transform = mod02_m
						//src.vis_contents += mod_txt02
						src.mod_dark = mod_txt02
					//	src.tab1 += mod_txt02

						var/obj/hud/menus/core_stats_background/stat_txt/txt03 = new
						txt03.maptext_width = 128
						txt03.hud_x = 12
						txt03.hud_y = 37
						txt03.maptext_x = 2
						txt03.maptext_y = 2
						txt03.maptext = "[css_outline]<font size = 1><left>[css_tech]Tech Potential"
						txt03.txt_info = "[css_tech]<font size = 1><text align=left valign=top>Tech Potential\n\n<font color = white>[tooltip_tech]"
						var/matrix/t03_m = matrix()
						t03_m.Translate(txt03.hud_x,txt03.hud_y)
						txt03.transform = t03_m
						//src.vis_contents += txt03
						//src.tab1 += txt03

						var/obj/hud/menus/core_stats_background/stat_mod_txt/mod_txt03 = new
						mod_txt03.hud_x = 192
						mod_txt03.hud_y = 37
						mod_txt03.maptext_x = 2
						mod_txt03.maptext_y = 2
						mod_txt03.maptext = "[css_outline]<font size = 1><left>[css_tech](0)"
						mod_txt03.txt_info = "(Divisor)\n\n<font color = white>This is how high your [css_tech]Tech Potential<font color = white> is. Research times and technology cost are divided by this number, reducing their time and cost to finish."
						var/matrix/mod03_m = matrix()
						mod03_m.Translate(mod_txt03.hud_x,mod_txt03.hud_y)
						mod_txt03.transform = mod03_m
						//src.vis_contents += mod_txt03
						src.mod_tech = mod_txt03
						//src.tab1 += mod_txt03

						var/obj/hud/menus/core_stats_background/stat_txt/txt04 = new
						txt04.maptext_width = 128
						txt04.hud_x = 12
						txt04.hud_y = 21
						txt04.maptext_x = 2
						txt04.maptext_y = 2
						txt04.maptext = "[css_outline]<font size = 1><left>[css_arcane]Arcane Potential"
						txt04.txt_info = "[css_arcane]<font size = 1><text align=left valign=top>Tech Potential\n\n<font color = white>[tooltip_tech]"
						var/matrix/t04_m = matrix()
						t04_m.Translate(txt04.hud_x,txt04.hud_y)
						txt04.transform = t04_m
						//src.vis_contents += txt04
						//src.tab1 += txt04

						var/obj/hud/menus/core_stats_background/stat_mod_txt/mod_txt04 = new
						mod_txt04.hud_x = 192
						mod_txt04.hud_y = 21
						mod_txt04.maptext_x = 2
						mod_txt04.maptext_y = 2
						mod_txt04.maptext = "[css_outline]<font size = 1><left>[css_arcane](0)"
						mod_txt04.txt_info = "(Divisor)\n\n<font color = white>This is how high your [css_arcane]Arcane Potential<font color = white> is. Study times and magic cost are divided by this number, reducing their time and expenses to finish."
						var/matrix/mod04_m = matrix()
						mod04_m.Translate(mod_txt04.hud_x,mod_txt04.hud_y)
						mod_txt04.transform = mod04_m
					//	src.vis_contents += mod_txt04
						src.mod_arcane = mod_txt03
					//	src.tab1 += mod_txt04

						src.bars = list(b1,b2,b3,b4,b5,b6,b7,b8,b11)

						var/obj/hud/menus/core_stats_background/stat_txt/txt_survival_txt1 = new
						txt_survival_txt1.hud_x = 46
						txt_survival_txt1.hud_y = 294
						txt_survival_txt1.maptext_x = 2
						txt_survival_txt1.maptext_y = 2
						txt_survival_txt1.maptext = "[css_outline]<font size = 1><left><u>Needs"
						txt_survival_txt1.txt_info = "<font size = 1><text align=left valign=top>[tooltip_needs]"
						var/matrix/m_sur_01 = matrix()
						m_sur_01.Translate(txt_survival_txt1.hud_x,txt_survival_txt1.hud_y)
						txt_survival_txt1.transform = m_sur_01
						src.tab2 += txt_survival_txt1

						var/obj/hud/menus/core_stats_background/stat_txt/txt_survival_txt2 = new
						txt_survival_txt2.hud_x = 46
						txt_survival_txt2.hud_y = 234//278
						txt_survival_txt2.maptext_x = 2
						txt_survival_txt2.maptext_y = 2
						txt_survival_txt2.maptext = "[css_outline]<font size = 1><left>Oxygen"
						txt_survival_txt2.txt_info = "<font size = 1><text align=left valign=top>[tooltip_oxygen]"
						var/matrix/m_sur_02 = matrix()
						m_sur_02.Translate(txt_survival_txt2.hud_x,txt_survival_txt2.hud_y)
						txt_survival_txt2.transform = m_sur_02
						src.tab2 += txt_survival_txt2

						var/obj/hud/menus/core_stats_background/stat_oxy_bar_shell/sur_bar1_shell = new
						sur_bar1_shell.hud_x = 108
						sur_bar1_shell.hud_y = 235
						sur_bar1_shell.maptext_x = 2
						sur_bar1_shell.maptext_y = 2
						sur_bar1_shell.txt_info = "<font size = 1><text align=left valign=top><u>Remaining Oxygen</u>\n\nOnce this bar is empty, you will try to resurface. Failing that, your oxygen will not refill until you enter an area abundant in oxygen.\n\nWhile this bar is empty, you will slowly take health damage every second."
						var/matrix/m_bar_sur_01_shell = matrix()
						m_bar_sur_01_shell.Translate(sur_bar1_shell.hud_x,sur_bar1_shell.hud_y)
						sur_bar1_shell.transform = m_bar_sur_01_shell
						src.tab2 += sur_bar1_shell
						src.bar_oxygen_shell = sur_bar1_shell

						var/obj/hud/menus/core_stats_background/stat_oxy_bar/sur_bar1 = new
						sur_bar1.hud_x = 109
						sur_bar1.hud_y = 236 //283
						sur_bar1.maptext_x = 2
						sur_bar1.maptext_y = 2
						sur_bar1.txt_info = "<font size = 1><text align=left valign=top><u>Remaining Oxygen</u>\n\nOnce this bar is empty, you will try to resurface. Failing that, your oxygen will not refill until you enter an area abundant in oxygen.\n\nWhile this bar is empty, you will slowly take health damage every second."
						var/matrix/m_bar_sur_01 = matrix()
						m_bar_sur_01.Translate(sur_bar1.hud_x,sur_bar1.hud_y)
						sur_bar1.transform = m_bar_sur_01
						src.tab2 += sur_bar1
						src.bar_oxygen = sur_bar1

						var/obj/hud/menus/core_stats_background/stat_txt/txt_survival_oxy = new
						txt_survival_oxy.hud_x = 216
						txt_survival_oxy.hud_y = 233//278
						txt_survival_oxy.maptext_x = 2
						txt_survival_oxy.maptext_y = 2
						txt_survival_oxy.maptext = "[css_outline]<font size = 1><left>100/100"
						txt_survival_oxy.txt_info = "<font size = 1><text align=left valign=top>[tooltip_core_stats]"
						var/matrix/m_sur_o2 = matrix()
						m_sur_o2.Translate(txt_survival_oxy.hud_x,txt_survival_oxy.hud_y)
						txt_survival_oxy.transform = m_sur_o2
						src.tab2 += txt_survival_oxy
						src.oxygen_info = txt_survival_oxy

						var/obj/hud/menus/core_stats_background/stat_txt/txt_survival_txt3 = new
						txt_survival_txt3.hud_x = 46
						txt_survival_txt3.hud_y = 278//262
						txt_survival_txt3.maptext_x = 2
						txt_survival_txt3.maptext_y = 2
						txt_survival_txt3.maptext = "[css_outline]<font size = 1><left>Hunger"
						txt_survival_txt3.txt_info = "<font size = 1><text align=left valign=top>[tooltip_hunger]"
						var/matrix/m_sur_03 = matrix()
						m_sur_03.Translate(txt_survival_txt3.hud_x,txt_survival_txt3.hud_y)
						txt_survival_txt3.transform = m_sur_03
						src.tab2 += txt_survival_txt3

						var/obj/hud/menus/core_stats_background/stat_hunger_bar_shell/sur_bar2_shell = new
						sur_bar2_shell.hud_x = 150
						sur_bar2_shell.hud_y = 278//266
						sur_bar2_shell.maptext_x = 2
						sur_bar2_shell.maptext_y = 2
						sur_bar2_shell.maptext = "[css_outline]<font size = 1><left>50%"
						sur_bar2_shell.txt_info = "<font size = 1><text align=left valign=top><u>Remaining Satiation</u>\n\nWhen this bar is empty, your character will start to starve. However, they automatically sustain themselves indefinitely via psionic power but at the cost of reduced core stats, thus avoiding death and permanent damage."
						sur_bar2_shell.txt_info = "<font size = 1><text align=left valign=top>[tooltip_hunger]"
						var/matrix/m_bar_sur_0322_shell = matrix()
						m_bar_sur_0322_shell.Translate(sur_bar2_shell.hud_x,sur_bar2_shell.hud_y)
						sur_bar2_shell.transform = m_bar_sur_0322_shell
						src.tab2 += sur_bar2_shell
						src.bar_hunger_shell = sur_bar2_shell
						/*var/matrix/m_bar_sur_02_shell = matrix()
						m_bar_sur_02_shell.Translate(sur_bar2_shell.hud_x,sur_bar2_shell.hud_y)
						sur_bar2_shell.transform = m_bar_sur_02_shell
						src.tab2 += sur_bar2_shell
						src.bar_hunger_shell = sur_bar2_shell
								*/

						var/obj/hud/menus/core_stats_background/stat_hunger_bar/sur_bar2 = new
						sur_bar2.hud_x = 109
						sur_bar2.hud_y = 278//267
						sur_bar2.maptext_x = 2
						sur_bar2.maptext_y = 2
						sur_bar2.txt_info = "<font size = 1><text align=left valign=top><u>Remaining Satiation</u>\n\nWhen this bar is empty, your character will start to starve. However, they automatically sustain themselves indefinitely via psionic power but at the cost of reduced core stats, thus avoiding death and permanent damage."
					//	var/matrix/m_bar_sur_02 = matrix()
						//m_bar_sur_02.Translate(sur_bar2.hud_x,sur_bar2.hud_y)
						//sur_bar2.transform = m_bar_sur_02
					//	src.tab2 += sur_bar2
						//src.bar_hunger = sur_bar2

						var/obj/hud/menus/core_stats_background/stat_txt/txt_survival_hunger = new
						txt_survival_hunger.hud_x = 216
						txt_survival_hunger.hud_y = 278//262
						txt_survival_hunger.maptext_x = 2
						txt_survival_hunger.maptext_y = 2
						txt_survival_hunger.maptext = "[css_outline]<font size = 1><left>100/100"
						txt_survival_hunger.txt_info = "<font size = 1><text align=left valign=top>(Mod)\n\nThe number in parenthesis is your hunger mod, how quickly you become hungry.\n\nYour hunger mod can vary based on race and also some skills and buffs currently in effect."
					//	var/matrix/m_sur_o3 = matrix()
					//	m_sur_o3.Translate(txt_survival_hunger.hud_x,txt_survival_hunger.hud_y)
					//	txt_survival_hunger.transform = m_sur_o3
					//	src.tab2 += txt_survival_hunger
						//src.hunger_info = txt_survival_hunger

						var/obj/hud/menus/core_stats_background/stat_txt/txt_survival_txt4 = new
						txt_survival_txt4.hud_x = 46
						txt_survival_txt4.hud_y = 266//246
						txt_survival_txt4.maptext_x = 2
						txt_survival_txt4.maptext_y = 2
						txt_survival_txt4.maptext = "[css_outline]<font size = 1><left>Thirst"
						txt_survival_txt4.txt_info = "<font size = 1><text align=left valign=top>[tooltip_thirst]"
						var/matrix/m_sur_04 = matrix()
						m_sur_04.Translate(txt_survival_txt4.hud_x,txt_survival_txt4.hud_y)
						txt_survival_txt4.transform = m_sur_04
						src.tab2 += txt_survival_txt4

						var/obj/hud/menus/core_stats_background/stat_thirst_bar_shell/sur_bar3_shell = new
						sur_bar3_shell.hud_x = 150
						sur_bar3_shell.hud_y = 266//250
						sur_bar3_shell.maptext_x = 2
						sur_bar3_shell.maptext_y = 2
						sur_bar3_shell.maptext = "[css_outline]<font size = 1><left>50%"
						sur_bar3_shell.txt_info = "<font size = 1><text align=left valign=top><u>Remaining Hydration</u>\n\nOnce this bar is empty, your character will begin to dehydrate. However, they automatically sustain themselves indefinitely via psionic power but at the cost of reduced core stats, thus avoiding death and permanent damage."
						var/matrix/m_sur_0444 = matrix()
						m_sur_0444.Translate(sur_bar3_shell.hud_x,sur_bar3_shell.hud_y)
						sur_bar3_shell.transform = m_sur_0444
						src.tab2 += sur_bar3_shell
						src.bar_thirst_shell = sur_bar3_shell

						/*var/matrix/m_bar_sur_03_shell = matrix()
						m_bar_sur_03_shell.Translate(sur_bar3_shell.hud_x,sur_bar3_shell.hud_y)
						sur_bar3_shell.transform = m_bar_sur_03_shell
						src.tab2 += sur_bar3_shell
						src.bar_thirst_shell = sur_bar3_shell
						*/

						var/obj/hud/menus/core_stats_background/stat_thirst_bar/sur_bar3 = new
						sur_bar3.hud_x = 109
						sur_bar3.hud_y = 267//251
						sur_bar3.maptext_x = 2
						sur_bar3.maptext_y = 2
						sur_bar3.txt_info = "<font size = 1><text align=left valign=top><u>Remaining Hydration</u>\n\nOnce this bar is empty, your character will begin to dehydrate. However, they automatically sustain themselves indefinitely via psionic power but at the cost of reduced core stats, thus avoiding death and permanent damage."
					//	var/matrix/m_bar_sur_03 = matrix()
					//	m_bar_sur_03.Translate(sur_bar3.hud_x,sur_bar3.hud_y)
						//sur_bar3.transform = m_bar_sur_03
						//src.tab2 += sur_bar3
						//src.bar_thirst = sur_bar3

						var/obj/hud/menus/core_stats_background/stat_txt/txt_survival_thirst = new
						txt_survival_thirst.hud_x = 216
						txt_survival_thirst.hud_y = 266//246
						txt_survival_thirst.maptext_x = 2
						txt_survival_thirst.maptext_y = 2
						txt_survival_thirst.maptext = "[css_outline]<font size = 1><left>100/100"
						txt_survival_thirst.txt_info = "<font size = 1><text align=left valign=top>(Mod)\n\nThe number in parenthesis is your thirst mod, how quickly you become dehydrated.\n\nYour thirst mod can vary based on race and also some skills and buffs currently in effect."
					//	var/matrix/m_sur_o4 = matrix()
						//m_sur_o4.Translate(txt_survival_thirst.hud_x,txt_survival_thirst.hud_y)
					//	txt_survival_thirst.transform = m_sur_o4
					//	src.tab2 += txt_survival_thirst
						//src.thirst_info = txt_survival_thirst

						var/obj/hud/menus/core_stats_background/stat_txt/txt_survival_txt5 = new
						txt_survival_txt5.hud_x = 46
						txt_survival_txt5.hud_y = 253//230
						txt_survival_txt5.maptext_x = 2
						txt_survival_txt5.maptext_y = 2
						txt_survival_txt5.maptext = "[css_outline]<font size = 1><left>Tiredness"
						txt_survival_txt5.txt_info = "<font size = 1><text align=left valign=top>[tooltip_sleep]"
						var/matrix/m_sur_05 = matrix()
						m_sur_05.Translate(txt_survival_txt5.hud_x,txt_survival_txt5.hud_y)
						txt_survival_txt5.transform = m_sur_05
						src.tab2 += txt_survival_txt5

						var/obj/hud/menus/core_stats_background/stat_tiredness_bar_shell/sur_bar4_shell = new
						sur_bar4_shell.hud_x = 150
						sur_bar4_shell.hud_y = 253//234
						sur_bar4_shell.maptext_x = 2
						sur_bar4_shell.maptext_y = 2
						sur_bar4_shell.maptext = "[css_outline]<font size = 1><left>50%"
						sur_bar4_shell.txt_info = "<font size = 1><text align=left valign=top><u>Remaining Rest</u>\n\nWhile this bar is empty, your character will become exhausted. However, they automatically sustain themselves indefinitely via psionic power but at the cost of reduced core stats, thus avoiding death and permanent damage.\n\nThe Sleep skill can be used to replenish rest and restore your tiredness bar to full."
						var/matrix/m_bar_sur_04_shell = matrix()
						m_bar_sur_04_shell.Translate(sur_bar4_shell.hud_x,sur_bar4_shell.hud_y)
						sur_bar4_shell.transform = m_bar_sur_04_shell
						src.tab2 += sur_bar4_shell
						src.bar_tiredness_shell = sur_bar4_shell

						var/obj/hud/menus/core_stats_background/stat_tiredness_bar/sur_bar4 = new
						sur_bar4.hud_x = 109
						sur_bar4.hud_y = 253//235
						sur_bar4.maptext_x = 2
						sur_bar4.maptext_y = 2
						sur_bar4.txt_info = "<font size = 1><text align=left valign=top><u>Remaining Rest</u>\n\nWhile this bar is empty, your character will become exhausted. However, they automatically sustain themselves indefinitely via psionic power but at the cost of reduced core stats, thus avoiding death and permanent damage.\n\nThe Sleep skill can be used to replenish rest and restore your tiredness bar to full."
						//var/matrix/m_bar_sur_04 = matrix()
						//m_bar_sur_04.Translate(sur_bar4.hud_x,sur_bar4.hud_y)
						//sur_bar4.transform = m_bar_sur_04
						//src.tab2 += sur_bar4
						//src.bar_tiredness = sur_bar4

						var/obj/hud/menus/core_stats_background/stat_txt/txt_survival_tiredness = new
						txt_survival_tiredness.hud_x = 216
						txt_survival_tiredness.hud_y = 248//230
						txt_survival_tiredness.maptext_x = 2
						txt_survival_tiredness.maptext_y = 2
						txt_survival_tiredness.maptext = "[css_outline]<font size = 1><left>100/100"
						txt_survival_tiredness.txt_info = "<font size = 1><text align=left valign=top>(Mod)\n\nThe number in parenthesis is your tiredness mod, how quickly you become exhausted.\n\nYour tiredness mod can vary based on race and also some skills and buffs currently in effect."
						//var/matrix/m_sur_o5 = matrix()
						//m_sur_o5.Translate(txt_survival_tiredness.hud_x,txt_survival_tiredness.hud_y)
						//txt_survival_tiredness.transform = m_sur_o5
						//src.tab2 += txt_survival_tiredness
						//src.tiredness_info = txt_survival_tiredness

						var/obj/hud/menus/core_stats_background/stat_txt/txt_survival_txt6 = new
						txt_survival_txt6.hud_x = 46
						txt_survival_txt6.hud_y = 218
						txt_survival_txt6.maptext_x = 2
						txt_survival_txt6.maptext_y = 2
						txt_survival_txt6.maptext = "[css_outline]<font size = 1><left>Toxicity"
						txt_survival_txt6.txt_info = "<font size = 1><text align=left valign=top>[tooltip_toxicity]"
						var/matrix/m_sur_06 = matrix()
						m_sur_06.Translate(txt_survival_txt6.hud_x,txt_survival_txt6.hud_y)
						txt_survival_txt6.transform = m_sur_06
						src.tab2 += txt_survival_txt6

						var/obj/hud/menus/core_stats_background/stat_toxicity_bar_shell/sur_bar5_shell = new
						sur_bar5_shell.hud_x = 108
						sur_bar5_shell.hud_y = 220
						sur_bar5_shell.maptext_x = 2
						sur_bar5_shell.maptext_y = 2
						sur_bar5_shell.txt_info = "<font size = 1><text align=left valign=top><u>Toxic Buildup</u>\n\nThe more filled up this bar is, the more toxic material is present in your system and the longer it will take to flush it.\n\nUnless you have a lot of toxin tolerance or want to gain double benefits from toxic items, it is best to keep this bar as low as possible.\n\n<font color = red>Getting to 200% Toxicity will result in death!"
						var/matrix/m_bar_sur_05_shell = matrix()
						m_bar_sur_05_shell.Translate(sur_bar5_shell.hud_x,sur_bar5_shell.hud_y)
						sur_bar5_shell.transform = m_bar_sur_05_shell
						src.tab2 += sur_bar5_shell
						src.bar_toxicity_shell = sur_bar5_shell

						var/obj/hud/menus/core_stats_background/stat_toxicity_bar/sur_bar5 = new
						sur_bar5.hud_x = 109
						sur_bar5.hud_y = 220
						sur_bar5.maptext_x = 2
						sur_bar5.maptext_y = 2
						sur_bar5.txt_info = "<font size = 1><text align=left valign=top><u>Toxic Buildup</u>\n\nThe more filled up this bar is, the more toxic material is present in your system and the longer it will take to flush.\n\nUnless you have a lot of toxin tolerance or want to gain double benefits from toxic items, it is best to keep this bar as low as possible.\n\n<font color = red>Getting to 200% Toxicity will result in death!"
						var/matrix/m_bar_sur_05 = matrix()
						m_bar_sur_05.Translate(sur_bar5.hud_x,sur_bar5.hud_y)
						sur_bar5.transform = m_bar_sur_05
						src.tab2 += sur_bar5
						src.bar_toxicity = sur_bar5

						var/obj/hud/menus/core_stats_background/stat_txt/txt_survival_tox = new
						txt_survival_tox.hud_x = 216
						txt_survival_tox.hud_y = 218
						txt_survival_tox.maptext_x = 2
						txt_survival_tox.maptext_y = 2
						txt_survival_tox.maptext = "[css_outline]<font size = 1><left>0%"
						txt_survival_tox.txt_info = "<font size = 1><text align=left valign=top>Current Buildup\n\nThis number is how much toxic buildup you currently have.\n\nThe rate you flush toxins from your system is based on your Toxin Tolerance and [css_regen]Regeneration<font color = white> mod."
						//txt_survival_tox.txt_info = "<font size = 1><text align=left valign=top>Current Buildup\n\nThis number is how much toxic buildup you currently have.\n\nThe rate you flush toxins from your system is based on your Toxin Tolerance and [css_regen]Regeneration<font color = white> mod.\n\nFlush rate: [(0.01*player.mod_regeneration)*(1+player.mod_immune_toxins)]% a second\n\n<font color = red>Getting to 200% Toxicity will result in death!"
						var/matrix/m_sur_o6 = matrix()
						m_sur_o6.Translate(txt_survival_tox.hud_x,txt_survival_tox.hud_y)
						txt_survival_tox.transform = m_sur_o6
						src.tab2 += txt_survival_tox
						src.toxicity_info = txt_survival_tox

						var/obj/hud/menus/core_stats_background/stat_txt/txt_survival_txt9 = new
						txt_survival_txt9.hud_x = 46
						txt_survival_txt9.hud_y = 192//144
						txt_survival_txt9.maptext_x = 2
						txt_survival_txt9.maptext_y = 2
						txt_survival_txt9.maptext = "[css_outline]<font size = 1><left><u>Tolerances"
						txt_survival_txt9.txt_info = "<font size = 1><text align=left valign=top>[tooltip_tolerances]"
						///var/matrix/m_sur_09 = matrix()
						//m_sur_09.Translate(txt_survival_txt9.hud_x,txt_survival_txt9.hud_y)
					//	txt_survival_txt9.transform = m_sur_09
						//src.tab2 += txt_survival_txt9

						var/obj/hud/menus/core_stats_background/stat_txt/txt_survival_txt10 = new
						txt_survival_txt10.hud_x = 46
						txt_survival_txt10.hud_y = 176
						txt_survival_txt10.maptext_x = 2
						txt_survival_txt10.maptext_y = 2
						txt_survival_txt10.maptext = "[css_outline]<font size = 1><left>Heat"
						txt_survival_txt10.txt_info = "<font size = 1><text align=left valign=top>[tooltip_heat]"
					//	var/matrix/m_sur_10 = matrix()
					//	m_sur_10.Translate(txt_survival_txt10.hud_x,txt_survival_txt10.hud_y)
					//	txt_survival_txt10.transform = m_sur_10
					//	src.tab2 += txt_survival_txt10


						var/obj/hud/menus/core_stats_background/stat_tolerance_shell/tol_shell_1 = new
						tol_shell_1.hud_x = 108
						tol_shell_1.hud_y = 180
						tol_shell_1.maptext_x = 2
						tol_shell_1.maptext_y = 2
						tol_shell_1.txt_info = "<font size = 1><text align=left valign=top><u>Heat Tolerance</u>\n\nThe more heat tolerance you gain, the more this bar will fill. If instead you have a weakness to heat or zero tolerance, the bar will turn black and reduce in size in relation to the weakness."
					//	var/matrix/m_tol_1 = matrix()
					//	m_tol_1.Translate(tol_shell_1.hud_x,tol_shell_1.hud_y)
					//	tol_shell_1.transform = m_tol_1
					//	src.tab2 += tol_shell_1

						var/obj/hud/menus/core_stats_background/stat_negative_bar/neg_bar_1 = new
						neg_bar_1.hud_x = 109
						neg_bar_1.hud_y = 181
						neg_bar_1.maptext_x = 2
						neg_bar_1.maptext_y = 2
						neg_bar_1.txt_info = "<font size = 1><text align=left valign=top><u>Heat Tolerance</u>\n\nThe more heat tolerance you gain, the more this bar will fill. If instead you have a weakness to heat or zero tolerance, the bar will turn black and reduce in size in relation to the weakness."
					//	var/matrix/m_neg_bar_1 = matrix()
					//	m_neg_bar_1.Translate(neg_bar_1.hud_x,neg_bar_1.hud_y)
					//	neg_bar_1.transform = m_neg_bar_1
					//	src.tab2 += neg_bar_1
					//	src.bar_heat_negative = neg_bar_1


						var/obj/hud/menus/core_stats_background/stat_tolerance_bar/tol_bar_1 = new
						tol_bar_1.hud_x = 109
						tol_bar_1.hud_y = 181
						tol_bar_1.maptext_x = 2
						tol_bar_1.maptext_y = 2
						tol_bar_1.txt_info = "<font size = 1><text align=left valign=top><u>Heat Tolerance</u>\n\nThe more heat tolerance you gain, the more this bar will fill. If instead you have a weakness to heat or zero tolerance, the bar will turn black and reduce in size in relation to the weakness."
					//	var/matrix/m_tol_bar_1 = matrix()
					//	m_tol_bar_1.Translate(tol_bar_1.hud_x,tol_bar_1.hud_y)
					//	tol_bar_1.transform = m_tol_bar_1
					//	src.tab2 += tol_bar_1
					//	src.bar_heat = tol_bar_1


						var/obj/hud/menus/core_stats_background/stat_txt/txt_percent_1 = new
						txt_percent_1.hud_x = 216
						txt_percent_1.hud_y = 176
						txt_percent_1.maptext_x = 2
						txt_percent_1.maptext_y = 2
						txt_percent_1.maptext = "[css_outline]<font size = 1><left>0% / 200%"
						txt_percent_1.txt_info = "<font size = 1><text align=left valign=top>[tooltip_core_stats]"
					//	var/matrix/m_per_1 = matrix()
					//	m_per_1.Translate(txt_percent_1.hud_x,txt_percent_1.hud_y)
						//txt_percent_1.transform = m_per_1
					//	src.tab2 += txt_percent_1
					//	src.heat_info = txt_percent_1


						var/obj/hud/menus/core_stats_background/stat_txt/txt_survival_txt11 = new
						txt_survival_txt11.hud_x = 46
						txt_survival_txt11.hud_y = 160
						txt_survival_txt11.maptext_x = 2
						txt_survival_txt11.maptext_y = 2
						txt_survival_txt11.maptext = "[css_outline]<font size = 1><left>Cold"
						txt_survival_txt11.txt_info = "<font size = 1><text align=left valign=top>[tooltip_cold]"
					//	var/matrix/m_sur_11 = matrix()
					//	m_sur_11.Translate(txt_survival_txt11.hud_x,txt_survival_txt11.hud_y)
					//	txt_survival_txt11.transform = m_sur_11
						//src.tab2 += txt_survival_txt11


						var/obj/hud/menus/core_stats_background/stat_tolerance_shell/tol_shell_2 = new
						tol_shell_2.hud_x = 108
						tol_shell_2.hud_y = 164
						tol_shell_2.maptext_x = 2
						tol_shell_2.maptext_y = 2
						tol_shell_2.txt_info = "<font size = 1><text align=left valign=top><u>Cold Tolerance</u>\n\nThe more cold tolerance you gain, the more this bar will fill. If instead you have a weakness to cold or zero tolerance, the bar will turn black and reduce in size in relation to the weakness."
					//	var/matrix/m_tol_2 = matrix()
					//	m_tol_2.Translate(tol_shell_2.hud_x,tol_shell_2.hud_y)
					//	tol_shell_2.transform = m_tol_2
					//	src.tab2 += tol_shell_2


						var/obj/hud/menus/core_stats_background/stat_negative_bar/neg_bar_2 = new
						neg_bar_2.hud_x = 109
						neg_bar_2.hud_y = 165
						neg_bar_2.maptext_x = 2
						neg_bar_2.maptext_y = 2
						neg_bar_2.txt_info = "<font size = 1><text align=left valign=top><u>Cold Tolerance</u>\n\nThe more cold tolerance you gain, the more this bar will fill. If instead you have a weakness to cold or zero tolerance, the bar will turn black and reduce in size in relation to the weakness."
						//var/matrix/m_neg_bar_2 = matrix()
					//	m_neg_bar_2.Translate(neg_bar_2.hud_x,neg_bar_2.hud_y)
						//neg_bar_2.transform = m_neg_bar_2
					//	src.tab2 += neg_bar_2
					//	src.bar_cold_negative = neg_bar_2


						var/obj/hud/menus/core_stats_background/stat_tolerance_bar/tol_bar_2 = new
						tol_bar_2.icon = 'tolerance_slice_cold.dmi'
						tol_bar_2.hud_x = 109
						tol_bar_2.hud_y = 165
						tol_bar_2.maptext_x = 2
						tol_bar_2.maptext_y = 2
						tol_bar_2.txt_info = "<font size = 1><text align=left valign=top><u>Cold Tolerance</u>\n\nThe more cold tolerance you gain, the more this bar will fill. If instead you have a weakness to cold or zero tolerance, the bar will turn black and reduce in size in relation to the weakness."
					//	var/matrix/m_tol_bar_2 = matrix()
					//	m_tol_bar_2.Translate(tol_bar_2.hud_x,tol_bar_2.hud_y)
						//tol_bar_2.transform = m_tol_bar_2
					//	src.tab2 += tol_bar_2
						//src.bar_cold = tol_bar_2


						var/obj/hud/menus/core_stats_background/stat_txt/txt_percent_2 = new
						txt_percent_2.hud_x = 216
						txt_percent_2.hud_y = 160
						txt_percent_2.maptext_x = 2
						txt_percent_2.maptext_y = 2
						txt_percent_2.maptext = "[css_outline]<font size = 1><left>0% / 200%"
						txt_percent_2.txt_info = "<font size = 1><text align=left valign=top>[tooltip_core_stats]"
					//	var/matrix/m_per_2 = matrix()
					//	m_per_2.Translate(txt_percent_2.hud_x,txt_percent_2.hud_y)
					//	txt_percent_2.transform = m_per_2
					//	src.tab2 += txt_percent_2
						//src.cold_info = txt_percent_2


						var/obj/hud/menus/core_stats_background/stat_txt/txt_survival_txt12 = new
						txt_survival_txt12.hud_x = 46
						txt_survival_txt12.hud_y = 144
						txt_survival_txt12.maptext_x = 2
						txt_survival_txt12.maptext_y = 2
						txt_survival_txt12.maptext = "[css_outline]<font size = 1><left>Gravity"
						txt_survival_txt12.txt_info = "<font size = 1><text align=left valign=top>[tooltip_gravity]"
					//	var/matrix/m_sur_12 = matrix()
					//	m_sur_12.Translate(txt_survival_txt12.hud_x,txt_survival_txt12.hud_y)
					//	txt_survival_txt12.transform = m_sur_12
						//src.tab2 += txt_survival_txt12


						var/obj/hud/menus/core_stats_background/stat_tolerance_shell/tol_shell_3 = new
						tol_shell_3.hud_x = 108
						tol_shell_3.hud_y = 148
						tol_shell_3.maptext_x = 2
						tol_shell_3.maptext_y = 2
						tol_shell_3.txt_info = "<font size = 1><text align=left valign=top><u>Gravity Tolerance</u>\n\nThe more gravity tolerance you gain, the more this bar will fill. If instead you have a weakness to gravity or zero tolerance, the bar will turn black and reduce in size in relation to the weakness."
					//	var/matrix/m_tol_3 = matrix()
					//	m_tol_3.Translate(tol_shell_3.hud_x,tol_shell_3.hud_y)
						//tol_shell_3.transform = m_tol_3
					//	src.tab2 += tol_shell_3


						var/obj/hud/menus/core_stats_background/stat_negative_bar/neg_bar_3 = new
						neg_bar_3.hud_x = 109
						neg_bar_3.hud_y = 149
						neg_bar_3.maptext_x = 2
						neg_bar_3.maptext_y = 2
						neg_bar_3.txt_info = "<font size = 1><text align=left valign=top><u>Gravity Tolerance</u>\n\nThe more gravity tolerance you gain, the more this bar will fill. If instead you have a weakness to gravity or zero tolerance, the bar will turn black and reduce in size in relation to the weakness."
					//	var/matrix/m_neg_bar_3 = matrix()
					//	m_neg_bar_3.Translate(neg_bar_3.hud_x,neg_bar_3.hud_y)
					//	neg_bar_3.transform = m_neg_bar_3
					//	src.tab2 += neg_bar_3
					//src.bar_gravity_negative = neg_bar_3


						var/obj/hud/menus/core_stats_background/stat_tolerance_bar/tol_bar_3 = new
						tol_bar_3.icon = 'tolerance_slice_gravity.dmi'
						tol_bar_3.hud_x = 109
						tol_bar_3.hud_y = 149
						tol_bar_3.maptext_x = 2
						tol_bar_3.maptext_y = 2
						tol_bar_3.txt_info = "<font size = 1><text align=left valign=top><u>Gravity Tolerance</u>\n\nThe more gravity tolerance you gain, the more this bar will fill. If instead you have a weakness to gravity or zero tolerance, the bar will turn black and reduce in size in relation to the weakness."
					///	var/matrix/m_tol_bar_3 = matrix()
					//	m_tol_bar_3.Translate(tol_bar_3.hud_x,tol_bar_3.hud_y)
					//	tol_bar_3.transform = m_tol_bar_3
					//	src.tab2 += tol_bar_3
					//	src.bar_gravity = tol_bar_3


						var/obj/hud/menus/core_stats_background/stat_txt/txt_percent_3 = new
						txt_percent_3.hud_x = 216
						txt_percent_3.hud_y = 144
						txt_percent_3.maptext_x = 2
						txt_percent_3.maptext_y = 2
						txt_percent_3.maptext = "[css_outline]<font size = 1><left>0% / 200%"
						txt_percent_3.txt_info = "<font size = 1><text align=left valign=top>[tooltip_core_stats]"
					//	var/matrix/m_per_3 = matrix()
					//	m_per_3.Translate(txt_percent_3.hud_x,txt_percent_3.hud_y)
					//	txt_percent_3.transform = m_per_3
					//	src.tab2 += txt_percent_3
					//	src.gravity_info = txt_percent_3


						var/obj/hud/menus/core_stats_background/stat_txt/txt_survival_txt13 = new
						txt_survival_txt13.hud_x = 46
						txt_survival_txt13.hud_y = 128
						txt_survival_txt13.maptext_x = 2
						txt_survival_txt13.maptext_y = 2
						txt_survival_txt13.maptext = "[css_outline]<font size = 1><left>Microwaves"
						txt_survival_txt13.txt_info = "<font size = 1><text align=left valign=top>[tooltip_microwaves]"
					//	var/matrix/m_sur_13 = matrix()
						//m_sur_13.Translate(txt_survival_txt13.hud_x,txt_survival_txt13.hud_y)
						//txt_survival_txt13.transform = m_sur_13
					//	src.tab2 += txt_survival_txt13

						var/obj/hud/menus/core_stats_background/stat_tolerance_shell/tol_shell_4 = new
						tol_shell_4.hud_x = 108
						tol_shell_4.hud_y = 132
						tol_shell_4.maptext_x = 2
						tol_shell_4.maptext_y = 2
						tol_shell_4.txt_info = "<font size = 1><text align=left valign=top><u>Microwave Tolerance</u>\n\nThe more microwave tolerance you gain, the more this bar will fill. If instead you have a weakness to microwaves or zero tolerance, the bar will turn black and reduce in size in relation to the weakness."
						//var/matrix/m_tol_4 = matrix()
						//m_tol_4.Translate(tol_shell_4.hud_x,tol_shell_4.hud_y)
						//tol_shell_4.transform = m_tol_4
						//src.tab2 += tol_shell_4

						var/obj/hud/menus/core_stats_background/stat_tolerance_bar/tol_bar_4 = new
						tol_bar_4.icon = 'tolerance_slice_microwaves.dmi'
						tol_bar_4.hud_x = 109
						tol_bar_4.hud_y = 133
						tol_bar_4.maptext_x = 2
						tol_bar_4.maptext_y = 2
						tol_bar_4.txt_info = "<font size = 1><text align=left valign=top><u>Microwave Tolerance</u>\n\nThe more microwave tolerance you gain, the more this bar will fill. If instead you have a weakness to microwaves or zero tolerance, the bar will turn black and reduce in size in relation to the weakness."
						//var/matrix/m_tol_bar_4 = matrix()
					//	m_tol_bar_4.Translate(tol_bar_4.hud_x,tol_bar_4.hud_y)
						//tol_bar_4.transform = m_tol_bar_4
					//	src.tab2 += tol_bar_4
					//	src.bar_microwaves = tol_bar_4

						var/obj/hud/menus/core_stats_background/stat_negative_bar/neg_bar_4 = new
						neg_bar_4.hud_x = 109
						neg_bar_4.hud_y = 133
						neg_bar_4.maptext_x = 2
						neg_bar_4.maptext_y = 2
						neg_bar_4.txt_info = "<font size = 1><text align=left valign=top><u>Microwave Tolerance</u>\n\nThe more microwave tolerance you gain, the more this bar will fill. If instead you have a weakness to microwaves or zero tolerance, the bar will turn black and reduce in size in relation to the weakness."
						//var/matrix/m_neg_bar_4 = matrix()
					//	m_neg_bar_4.Translate(neg_bar_4.hud_x,neg_bar_4.hud_y)
						//neg_bar_4.transform = m_neg_bar_4
						//src.tab2 += neg_bar_4
						//src.bar_microwaves_negative = neg_bar_4

						var/obj/hud/menus/core_stats_background/stat_txt/txt_percent_4 = new
						txt_percent_4.hud_x = 216
						txt_percent_4.hud_y = 128
						txt_percent_4.maptext_x = 2
						txt_percent_4.maptext_y = 2
						txt_percent_4.maptext = "[css_outline]<font size = 1><left>0% / 200%"
						txt_percent_4.txt_info = "<font size = 1><text align=left valign=top>[tooltip_core_stats]"
						//var/matrix/m_per_4 = matrix()
						//m_per_4.Translate(txt_percent_4.hud_x,txt_percent_4.hud_y)
						//txt_percent_4.transform = m_per_4
						//src.tab2 += txt_percent_4
						//src.microwaves_info = txt_percent_4

						var/obj/hud/menus/core_stats_background/stat_txt/txt_survival_txt14 = new
						txt_survival_txt14.hud_x = 46
						txt_survival_txt14.hud_y = 128//112
						txt_survival_txt14.maptext_x = 2
						txt_survival_txt14.maptext_y = 2
						txt_survival_txt14.maptext = "[css_outline]<font size = 1><left>Radiation"
						txt_survival_txt14.txt_info = "<font size = 1><text align=left valign=top>[tooltip_radiation]"
					//	var/matrix/m_sur_14 = matrix()
						//m_sur_14.Translate(txt_survival_txt14.hud_x,txt_survival_txt14.hud_y)
						//txt_survival_txt14.transform = m_sur_14
					//	src.tab2 += txt_survival_txt14


						var/obj/hud/menus/core_stats_background/stat_tolerance_shell/tol_shell_5 = new
						tol_shell_5.hud_x = 108
						tol_shell_5.hud_y = 132//116
						tol_shell_5.maptext_x = 2
						tol_shell_5.maptext_y = 2
						tol_shell_5.txt_info = "<font size = 1><text align=left valign=top><u>Radiation Tolerance</u>\n\nThe more radiation tolerance you gain, the more this bar will fill. If instead you have a weakness to radiation or zero tolerance, the bar will turn black and reduce in size in relation to the weakness."
					//	var/matrix/m_tol_5 = matrix()
					//	m_tol_5.Translate(tol_shell_5.hud_x,tol_shell_5.hud_y)
					//	tol_shell_5.transform = m_tol_5
					//	src.tab2 += tol_shell_5


						var/obj/hud/menus/core_stats_background/stat_negative_bar/neg_bar_5 = new
						neg_bar_5.hud_x = 109
						neg_bar_5.hud_y = 133//117
						neg_bar_5.maptext_x = 2
						neg_bar_5.maptext_y = 2
						neg_bar_5.txt_info = "<font size = 1><text align=left valign=top><u>Radiation Tolerance</u>\n\nThe more radiation tolerance you gain, the more this bar will fill. If instead you have a weakness to radiation or zero tolerance, the bar will turn black and reduce in size in relation to the weakness."
					//	var/matrix/m_neg_bar_5 = matrix()
					//	m_neg_bar_5.Translate(neg_bar_5.hud_x,neg_bar_5.hud_y)
					//	neg_bar_5.transform = m_neg_bar_5
					//	src.tab2 += neg_bar_5
						//src.bar_radiation_negative = neg_bar_5


						var/obj/hud/menus/core_stats_background/stat_tolerance_bar/tol_bar_5 = new
						tol_bar_5.icon = 'tolerance_slice_radiation.dmi'
						tol_bar_5.hud_x = 109
						tol_bar_5.hud_y = 133//117
						tol_bar_5.maptext_x = 2
						tol_bar_5.maptext_y = 2
						tol_bar_5.txt_info = "<font size = 1><text align=left valign=top><u>Radiation Tolerance</u>\n\nThe more radiation tolerance you gain, the more this bar will fill. If instead you have a weakness to radiation or zero tolerance, the bar will turn black and reduce in size in relation to the weakness."
					//	var/matrix/m_tol_bar_5 = matrix()
					//	m_tol_bar_5.Translate(tol_bar_5.hud_x,tol_bar_5.hud_y)
						//tol_bar_5.transform = m_tol_bar_5
					//	src.tab2 += tol_bar_5
						//src.bar_radiation = tol_bar_5


						var/obj/hud/menus/core_stats_background/stat_txt/txt_percent_5 = new
						txt_percent_5.hud_x = 216
						txt_percent_5.hud_y = 128//112
						txt_percent_5.maptext_x = 2
						txt_percent_5.maptext_y = 2
						txt_percent_5.maptext = "[css_outline]<font size = 1><left>0% / 200%"
						txt_percent_5.txt_info = "<font size = 1><text align=left valign=top>[tooltip_core_stats]"
					//	var/matrix/m_per_5 = matrix()
					//	m_per_5.Translate(txt_percent_5.hud_x,txt_percent_5.hud_y)
					//	txt_percent_5.transform = m_per_5
					//	src.tab2 += txt_percent_5
					//	src.radiation_info = txt_percent_5


						var/obj/hud/menus/core_stats_background/stat_txt/txt_survival_txt15 = new
						txt_survival_txt15.hud_x = 46
						txt_survival_txt15.hud_y = 112//96
						txt_survival_txt15.maptext_x = 2
						txt_survival_txt15.maptext_y = 2
						txt_survival_txt15.maptext = "[css_outline]<font size = 1><left>Toxins"
						txt_survival_txt15.txt_info = "<font size = 1><text align=left valign=top>[tooltip_toxins]"
					//	var/matrix/m_sur_15 = matrix()
					//	m_sur_15.Translate(txt_survival_txt15.hud_x,txt_survival_txt15.hud_y)
					//	txt_survival_txt15.transform = m_sur_15
					//	src.tab2 += txt_survival_txt15


						var/obj/hud/menus/core_stats_background/stat_tolerance_shell/tol_shell_6 = new
						tol_shell_6.hud_x = 108
						tol_shell_6.hud_y = 117//100
						tol_shell_6.maptext_x = 2
						tol_shell_6.maptext_y = 2
						tol_shell_6.txt_info = "<font size = 1><text align=left valign=top><u>Toxin Tolerance</u>\n\nThe more toxin tolerance you gain, the more this bar will fill. If instead you have a weakness to toxins or zero tolerance, the bar will turn black and reduce in size in relation to the weakness."
					//	var/matrix/m_tol_6 = matrix()
					//	m_tol_6.Translate(tol_shell_6.hud_x,tol_shell_6.hud_y)
					//	tol_shell_6.transform = m_tol_6
						//src.tab2 += tol_shell_6


						var/obj/hud/menus/core_stats_background/stat_negative_bar/neg_bar_6 = new
						neg_bar_6.hud_x = 109
						neg_bar_6.hud_y = 118//101
						neg_bar_6.maptext_x = 2
						neg_bar_6.maptext_y = 2
						neg_bar_6.txt_info = "<font size = 1><text align=left valign=top><u>Toxin Tolerance</u>\n\nThe more toxin tolerance you gain, the more this bar will fill. If instead you have a weakness to toxins or zero tolerance, the bar will turn black and reduce in size in relation to the weakness."
					//	var/matrix/m_neg_bar_6 = matrix()
					//	m_neg_bar_6.Translate(neg_bar_6.hud_x,neg_bar_6.hud_y)
					//	neg_bar_6.transform = m_neg_bar_6
					//	src.tab2 += neg_bar_6
						//src.bar_toxins_negative = neg_bar_6


						var/obj/hud/menus/core_stats_background/stat_tolerance_bar/tol_bar_6 = new
						tol_bar_6.icon = 'tolerance_slice_toxins.dmi'
						tol_bar_6.hud_x = 109
						tol_bar_6.hud_y = 118//101
						tol_bar_6.maptext_x = 2
						tol_bar_6.maptext_y = 2
						tol_bar_6.txt_info = "<font size = 1><text align=left valign=top><u>Toxin Tolerance</u>\n\nThe more toxin tolerance you gain, the more this bar will fill. If instead you have a weakness to toxins or zero tolerance, the bar will turn black and reduce in size in relation to the weakness."
					//	var/matrix/m_tol_bar_6 = matrix()
					//	m_tol_bar_6.Translate(tol_bar_6.hud_x,tol_bar_6.hud_y)
					//	tol_bar_6.transform = m_tol_bar_6
					//	src.tab2 += tol_bar_6
					//	src.bar_toxins = tol_bar_6


						var/obj/hud/menus/core_stats_background/stat_txt/txt_percent_6 = new
						txt_percent_6.hud_x = 216
						txt_percent_6.hud_y = 112//96
						txt_percent_6.maptext_x = 2
						txt_percent_6.maptext_y = 2
						txt_percent_6.maptext = "[css_outline]<font size = 1><left>0% / 200%"
						txt_percent_6.txt_info = "<font size = 1><text align=left valign=top>[tooltip_core_stats]"
					//	var/matrix/m_per_6 = matrix()
					//	m_per_6.Translate(txt_percent_6.hud_x,txt_percent_6.hud_y)
					//	txt_percent_6.transform = m_per_6
					//	src.tab2 += txt_percent_6
					//	src.toxins_info = txt_percent_6


						var/obj/hud/menus/core_stats_background/stat_txt/txt_survival_txt16 = new
						txt_survival_txt16.hud_x = 46
						txt_survival_txt16.hud_y = 192
						txt_survival_txt16.maptext_x = 2
						txt_survival_txt16.maptext_y = 2
						txt_survival_txt16.maptext = "[css_outline]<font size = 1><left><u>Adaptations"
						txt_survival_txt16.txt_info = "<font size = 1><text align=left valign=top>[tooltip_adaptations]"
						var/matrix/m_sur_16 = matrix()
						m_sur_16.Translate(txt_survival_txt16.hud_x,txt_survival_txt16.hud_y)
						txt_survival_txt16.transform = m_sur_16
						src.tab2 += txt_survival_txt16


						var/obj/hud/menus/core_stats_background/stat_txt/txt_survival_txt17 = new
						txt_survival_txt17.hud_x = 46
						txt_survival_txt17.hud_y = 174
						txt_survival_txt17.maptext_x = 2
						txt_survival_txt17.maptext_y = 2
						txt_survival_txt17.maptext = "[css_outline]<font size = 1><left>Gravity"
						txt_survival_txt17.txt_info = "<font size = 1><text align=left valign=top><u>Gravity Adaptation</u>\n\nThis is how much gravity your character has mastered and can withstand.\n\nWhen in high gravity, your muscles and bones will take the fault of damage, but also benefit from it all the same."
						var/matrix/m_sur_17 = matrix()
						m_sur_17.Translate(txt_survival_txt17.hud_x,txt_survival_txt17.hud_y)
						txt_survival_txt17.transform = m_sur_17
						src.tab2 += txt_survival_txt17

						var/obj/hud/menus/core_stats_background/stat_txt/txt_percent_7 = new
						txt_percent_7.hud_x = 216
						txt_percent_7.hud_y = 174
						txt_percent_7.maptext_x = 2
						txt_percent_7.maptext_y = 2
						txt_percent_7.maptext = "[css_outline]<font size = 1><left>x1"
						txt_percent_7.txt_info = "Current | Mastered\n\n<font color = white>The first number is how high the gravity is inside the area you're in. The second number is how much gravity you can take before taking damage.\n\nThe first number changes color to indicate the intensity of the current gravity compared to your mastered gravity.\n\nWhen inside higher gravity than what you've mastered, you will slowly adapt and be able to withstand higher settings."
						var/matrix/m_per_7 = matrix()
						m_per_7.Translate(txt_percent_7.hud_x,txt_percent_7.hud_y)
						txt_percent_7.transform = m_per_7
						src.tab2 += txt_percent_7
						src.mastered_grav = txt_percent_7

						var/obj/hud/menus/core_stats_background/stat_txt/txt_survival_txt18 = new
						txt_survival_txt18.hud_x = 46
						txt_survival_txt18.hud_y = 42
						txt_survival_txt18.maptext_x = 2
						txt_survival_txt18.maptext_y = 2
						txt_survival_txt18.maptext = "[css_outline]<font size = 1><left>Microwaves"
						txt_survival_txt18.txt_info = "<font size = 1><text align=left valign=top><u>Microwave Adaptation</u>\n\nThis is how much microwave radiation your character has mastered and can withstand.\n\nWhen in high microwave radiation, your organs will gain exp but also take damage."
						//var/matrix/m_sur_18 = matrix()
						//m_sur_18.Translate(txt_survival_txt18.hud_x,txt_survival_txt18.hud_y)
						//txt_survival_txt18.transform = m_sur_18
						//src.tab2 += txt_survival_txt18

						var/obj/hud/menus/core_stats_background/stat_txt/txt_percent_8 = new
						txt_percent_8.hud_x = 216
						txt_percent_8.hud_y = 42
						txt_percent_8.maptext_x = 2
						txt_percent_8.maptext_y = 2
						txt_percent_8.maptext = "[css_outline]<font size = 1><left>0 (1)"
						txt_percent_8.txt_info = "Current | Mastered (Mod)\n\n<font color = white>The first number is how high the microwave radiation is inside the area you're in. The second number is how much microwave radiation you can take before taking damage. The third number in parenthesis is your microwave mod.\n\nThe first number changes color to indicate the intensity of the current microwave radiation compared to your mastered microwave radiation.\n\nWhen inside higher microwave radiation than what you've mastered, you will slowly adapt and be able to withstand higher settings. The third number in parenthesis is how quickly this happens."
						//var/matrix/m_per_8 = matrix()
						//m_per_8.Translate(txt_percent_8.hud_x,txt_percent_8.hud_y)
						//txt_percent_8.transform = m_per_8
						//src.tab2 += txt_percent_8
						//src.mastered_micro = txt_percent_8
				scroller_main
					icon_state = "scroller main"
					layer = 33
					plane = 24
					appearance_flags = KEEP_TOGETHER
					MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
						//var/obj/hud/menus/core_stats_background/s = src.menu
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/result = -200 + (usr.mouse_y_true-54) //54 is the size of the scroller x 2 (basically its height in pixels).
						result = clamp(result,0,-121)
						var/matrix/m = matrix()
						m.Translate(0,result)
						src.transform = m
						src.translated_y = result

						/*
						var/obj/txt = s.lore_txt
						var/ratio = -1 + ((-121 + result) / -121)
						ratio = clamp(ratio,0,1)
						ratio = 1 - ratio
						var/scroll_y = round(txt.hud_y*ratio)
						var/matrix/m2 = matrix()
						m2.Translate(txt.hud_x,scroll_y)
						txt.transform = m2
						*/
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
					MouseWheel(delta_x,delta_y,location,control,params)
						//var/obj/hud/menus/core_stats_background/s = src.menu
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = src.translated_y+wheel_move
						result = clamp(result,0,-121)
						var/matrix/m = matrix()
						m.Translate(0,result)
						src.transform = m
						src.translated_y = result

						/*
						var/obj/txt = s.lore_txt
						var/ratio = -1 + ((-121 + result) / -121)
						ratio = clamp(ratio,0,1)
						ratio = 1 - ratio
						var/scroll_y = round(txt.hud_y*ratio)
						var/matrix/m2 = matrix()
						m2.Translate(txt.hud_x,scroll_y)
						txt.transform = m2
						*/
				scrollbar_main
					icon_state = "scrollbar main"
					layer = 33
					plane = 24
					appearance_flags = KEEP_TOGETHER
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
					MouseWheel(delta_x,delta_y,location,control,params)
						var/obj/hud/menus/core_stats_background/s = src.menu
						var/obj/sc = s.scroller_main
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-150)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/ratio = -1 + ((-150 + result) / -150)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(200*ratio)

						for(var/obj/txt in s.pane_stats.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
							txt.transform = m2
					Click(location,control,params)
						var/obj/hud/menus/core_stats_background/s = src.menu
						var/obj/sc = s.scroller_main
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						//var/result = -246 + (usr.mouse_y_true-54) //54 is the size of the scroller x 2 (basically its height in pixels).
						var/result = -246 + ((usr.mouse_y_true-s.menu_y)-54)
						result = clamp(result,0,-150)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						var/ratio = -1 + ((-150 + result) / -150)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(200*ratio)

						for(var/obj/o in s.pane_stats.vis_contents)
							var/matrix/m2 = matrix()
							m2.Translate(o.hud_x,o.hud_y+scroll_y)
							o.transform = m2

				stat_mod_txt
					icon = 'core_mods_txt.dmi'
					icon_state = "core"
					maptext_width = 96
					maptext_height = 18
					plane = 24
					layer = 34
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					var/txt_info
					MouseExited()
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseEntered(location,control,params)
						if(usr.info_box1)
							usr.stats_mods()
							usr.client.screen += usr.info_box1
							usr.client.screen += usr.info_box2
							usr.client.screen += usr.info_box3
							usr.info_box(src,src.txt_info,params)
					MouseMove(location,control,params)
						..()
						usr.info_box(src,src.txt_info,params)
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				stat_txt
					icon = 'core_stats_txt.dmi'
					icon_state = "core"//null
					maptext_width = 96
					maptext_height = 18
					plane = 24
					layer = 34
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					var/txt_info
					MouseExited()
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseEntered(location,control,params)
						if(usr.info_box1)
							usr.client.screen += usr.info_box1
							usr.client.screen += usr.info_box2
							usr.client.screen += usr.info_box3
							usr.info_box(src,src.txt_info,params)
					MouseMove(location,control,params)
						..()
						usr.info_box(src,src.txt_info,params)
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				stat_tabs
					icon_state = "tabs"
					plane = 24
					layer = 34
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				stat_tab
					icon = 'new_stat_tabs2.dmi' //stat_tabs.dmi
					icon_state = "unselected"
					plane = 24
					layer = 34
					maptext_width = 96
					maptext_height = 18
					maptext_x = -10
					maptext_y = 3
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					var/selected = 0
					var/tab
					Click()
						src.menu.overlays = null
						for(var/obj/hud/menus/core_stats_background/stat_tab/s in src.menu.tabs)
							s.selected = 0
							s.icon_state = "unselected"
						src.selected = 1
						src.icon_state = "selected"
						for(var/obj/o in src.menu.tab1)
							src.menu.vis_contents -= o
						for(var/obj/o in src.menu.tab2)
							src.menu.vis_contents -= o
						for(var/obj/o in src.menu.tab3)
							src.menu.vis_contents -= o
						for(var/obj/o in src.menu.tab4)
							src.menu.vis_contents -= o
						if(src.tab == "stats")
							src.menu.tab_selected = "stats"
							for(var/obj/o in src.menu.tab1)
								src.menu.vis_contents += o
						else if(src.tab == "survival")
							src.menu.tab_selected = "survival"
							for(var/obj/o in src.menu.tab2)
								src.menu.vis_contents += o
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
					MouseEntered()
						if(src.icon_state != "selected") src.icon_state = "hover"
					MouseExited()
						if(src.icon_state != "selected") src.icon_state = "unselected"
				stat_portrait
					icon = 'portrait_human_male.dmi'
					icon_state = "border2"
					plane = 24
					layer = 34
					hud_x = 11
					hud_y = 337
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				stat_char_txt
					icon = null
					maptext_width = 128
					maptext_height = 18
					plane = 24
					layer = 34
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					var/txt_info
					MouseExited()
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseEntered(location,control,params)
						if(src.txt_info)
							if(usr.info_box1)
								usr.client.screen += usr.info_box1
								usr.client.screen += usr.info_box2
								usr.client.screen += usr.info_box3
							usr.info_box(src,src.txt_info,params)
					MouseMove(location,control,params)
						..()
						if(src.txt_info) usr.info_box(src,src.txt_info,params)
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				stat_pane
					icon_state = "pane"
					plane = 24
					layer = 33
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				stat_char_pane
					icon_state = "char"
					plane = 24
					layer = 33
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				stat_exp_bar
					icon = 'core_stats_xp_slice.dmi'
					icon_state = "slice"
					layer = 40
					plane = 24
					var/txt_info
					MouseExited()
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseEntered(location,control,params)
						if(usr.info_box1)
							usr.client.screen += usr.info_box1
							usr.client.screen += usr.info_box2
							usr.client.screen += usr.info_box3
							usr.info_box(src,src.txt_info,params)
					MouseMove(location,control,params)
						..()
						usr.info_box(src,src.txt_info,params)
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						src.txt_info = "[css_outline]<font size = 1><text align=left valign=top>[tooltip_stat_xp_bar]"
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				stat_tolerance_shell
					icon = 'tolerance_shell.dmi'
					layer = 40
					plane = 24
					var/txt_info
					MouseExited()
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseEntered(location,control,params)
						if(usr.info_box1)
							usr.client.screen += usr.info_box1
							usr.client.screen += usr.info_box2
							usr.client.screen += usr.info_box3
							usr.info_box(src,src.txt_info,params)
					MouseMove(location,control,params)
						..()
						usr.info_box(src,src.txt_info,params)
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						src.txt_info = "[css_outline]<font size = 1><text align=left valign=top>[tooltip_stat_xp_bar]"
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				stat_negative_bar
					icon = 'tolerance_slice_negative.dmi'
					layer = 40
					plane = 24
					var/txt_info
					MouseExited()
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseEntered(location,control,params)
						if(usr.info_box1)
							usr.client.screen += usr.info_box1
							usr.client.screen += usr.info_box2
							usr.client.screen += usr.info_box3
							usr.info_box(src,src.txt_info,params)
					MouseMove(location,control,params)
						..()
						usr.info_box(src,src.txt_info,params)
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						src.txt_info = "[css_outline]<font size = 1><text align=left valign=top>[tooltip_stat_xp_bar]"
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				stat_tolerance_bar
					icon = 'tolerance_slice_heat.dmi'
					layer = 40
					plane = 24
					var/txt_info
					MouseExited()
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseEntered(location,control,params)
						if(usr.info_box1)
							usr.client.screen += usr.info_box1
							usr.client.screen += usr.info_box2
							usr.client.screen += usr.info_box3
							usr.info_box(src,src.txt_info,params)
					MouseMove(location,control,params)
						..()
						usr.info_box(src,src.txt_info,params)
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						src.txt_info = "[css_outline]<font size = 1><text align=left valign=top>[tooltip_stat_xp_bar]"
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				stat_thirst_bar_shell
					//icon = 'needs_shell.dmi'
					icon = null
					icon_state = null
					layer = 40
					plane = 24
					var/txt_info
					MouseExited()
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseEntered(location,control,params)
						if(usr.info_box1)
							usr.client.screen += usr.info_box1
							usr.client.screen += usr.info_box2
							usr.client.screen += usr.info_box3
							usr.info_box(src,src.txt_info,params)
					MouseMove(location,control,params)
						..()
						usr.info_box(src,src.txt_info,params)
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						src.txt_info = "[css_outline]<font size = 1><text align=left valign=top>[tooltip_stat_xp_bar]"
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				stat_toxicity_bar_shell
					icon = 'needs_shell.dmi'
					layer = 40
					plane = 24
					var/txt_info
					MouseExited()
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseEntered(location,control,params)
						if(usr.info_box1)
							usr.client.screen += usr.info_box1
							usr.client.screen += usr.info_box2
							usr.client.screen += usr.info_box3
							usr.info_box(src,src.txt_info,params)
					MouseMove(location,control,params)
						..()
						usr.info_box(src,src.txt_info,params)
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						src.txt_info = "[css_outline]<font size = 1><text align=left valign=top>[tooltip_stat_xp_bar]"
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				stat_tiredness_bar_shell
					icon = null
					icon_state = null
					layer = 40
					plane = 24
					var/txt_info
					MouseExited()
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseEntered(location,control,params)
						if(usr.info_box1)
							usr.client.screen += usr.info_box1
							usr.client.screen += usr.info_box2
							usr.client.screen += usr.info_box3
							usr.info_box(src,src.txt_info,params)
					MouseMove(location,control,params)
						..()
						usr.info_box(src,src.txt_info,params)
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						src.txt_info = "[css_outline]<font size = 1><text align=left valign=top>[tooltip_stat_xp_bar]"
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				stat_hunger_bar_shell
					icon = null
					icon_state = null
					layer = 40
					plane = 24
					var/txt_info
					MouseExited()
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseEntered(location,control,params)
						if(usr.info_box1)
							usr.client.screen += usr.info_box1
							usr.client.screen += usr.info_box2
							usr.client.screen += usr.info_box3
							usr.info_box(src,src.txt_info,params)
					MouseMove(location,control,params)
						..()
						usr.info_box(src,src.txt_info,params)
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						src.txt_info = "[css_outline]<font size = 1><text align=left valign=top>[tooltip_stat_xp_bar]"
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				stat_oxy_bar_shell
					icon = 'needs_shell.dmi'
					layer = 40
					plane = 24
					var/txt_info
					MouseExited()
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseEntered(location,control,params)
						if(usr.info_box1)
							usr.client.screen += usr.info_box1
							usr.client.screen += usr.info_box2
							usr.client.screen += usr.info_box3
							usr.info_box(src,src.txt_info,params)
					MouseMove(location,control,params)
						..()
						usr.info_box(src,src.txt_info,params)
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						src.txt_info = "[css_outline]<font size = 1><text align=left valign=top>[tooltip_stat_xp_bar]"
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				stat_thirst_bar
					icon = 'core_stats_thirst_slice.dmi'
					icon_state = "slice"
					layer = 40
					plane = 24
					var/txt_info
					MouseExited()
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseEntered(location,control,params)
						if(usr.info_box1)
							usr.client.screen += usr.info_box1
							usr.client.screen += usr.info_box2
							usr.client.screen += usr.info_box3
							usr.info_box(src,src.txt_info,params)
					MouseMove(location,control,params)
						..()
						usr.info_box(src,src.txt_info,params)
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						src.txt_info = "[css_outline]<font size = 1><text align=left valign=top>[tooltip_stat_xp_bar]"
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				stat_tiredness_bar
					icon = 'core_stats_tiredness_slice.dmi'
					icon_state = "slice"
					layer = 40
					plane = 24
					var/txt_info
					MouseExited()
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseEntered(location,control,params)
						if(usr.info_box1)
							usr.client.screen += usr.info_box1
							usr.client.screen += usr.info_box2
							usr.client.screen += usr.info_box3
							usr.info_box(src,src.txt_info,params)
					MouseMove(location,control,params)
						..()
						usr.info_box(src,src.txt_info,params)
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						src.txt_info = "[css_outline]<font size = 1><text align=left valign=top>[tooltip_stat_xp_bar]"
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				stat_toxicity_bar
					icon = 'core_stats_toxicity_slice.dmi'
					icon_state = "slice"
					layer = 40
					plane = 24
					var/txt_info
					MouseExited()
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseEntered(location,control,params)
						if(usr.info_box1)
							usr.client.screen += usr.info_box1
							usr.client.screen += usr.info_box2
							usr.client.screen += usr.info_box3
							usr.info_box(src,src.txt_info,params)
					MouseMove(location,control,params)
						..()
						usr.info_box(src,src.txt_info,params)
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						src.txt_info = "[css_outline]<font size = 1><text align=left valign=top>[tooltip_stat_xp_bar]"
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				stat_hunger_bar
					icon = 'core_stats_hunger_slice.dmi'
					icon_state = "slice"
					layer = 40
					plane = 24
					var/txt_info
					MouseExited()
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseEntered(location,control,params)
						if(usr.info_box1)
							usr.client.screen += usr.info_box1
							usr.client.screen += usr.info_box2
							usr.client.screen += usr.info_box3
							usr.info_box(src,src.txt_info,params)
					MouseMove(location,control,params)
						..()
						usr.info_box(src,src.txt_info,params)
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						src.txt_info = "[css_outline]<font size = 1><text align=left valign=top>[tooltip_stat_xp_bar]"
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				stat_oxy_bar
					icon = 'core_stats_oxygen_slice.dmi'
					icon_state = "slice"
					layer = 40
					plane = 24
					var/txt_info
					MouseExited()
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseEntered(location,control,params)
						if(usr.info_box1)
							usr.client.screen += usr.info_box1
							usr.client.screen += usr.info_box2
							usr.client.screen += usr.info_box3
							usr.info_box(src,src.txt_info,params)
					MouseMove(location,control,params)
						..()
						usr.info_box(src,src.txt_info,params)
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						src.txt_info = "[css_outline]<font size = 1><text align=left valign=top>[tooltip_stat_xp_bar]"
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
				stat_exp_bar_shell
					icon_state = "bar power"
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
					layer = 34
					plane = 24
					var/txt_info
					MouseExited()
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseEntered(location,control,params)
						if(usr.info_box1)
							usr.client.screen += usr.info_box1
							usr.client.screen += usr.info_box2
							usr.client.screen += usr.info_box3
							usr.info_box(src,src.txt_info,params)
					MouseMove(location,control,params)
						..()
						usr.info_box(src,src.txt_info,params)
					MouseDrag()
						return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
					New()
						src.txt_info = "[css_outline]<font size = 1><text align=left valign=top>[tooltip_stat_xp_bar]"
						return //This is here so its not called when its parent's New() is called, resulting in an ifinite loop and crash. DO NOT REMOVE.
			sense_box
				icon = 'sense_box.dmi'
				layer = 10
				screen_loc = "1:1,13"
			sense_button
				icon = 'sense_box_button.dmi'
				layer = 10
				screen_loc = "2:-12,13:-8"
				var/hidden = 0
				MouseEntered()
					src.icon_state = "mouse over"
				MouseExited()
					src.icon_state = ""
				Click()
					if(usr.sense_boxes && src in usr.sense_boxes)
						if(src.hidden == 0)
							src.hidden = 1
							for(var/obj/b in usr.sense_boxes)
								if(b.type == /obj/hud/menus/sense_box_advanced)
									usr.client.screen -= b
									for(var/obj/o in b)
										usr.client.screen -= o
							return
						else
							src.hidden = 0
							for(var/obj/b in usr.sense_boxes)
								if(b.type == /obj/hud/menus/sense_box_advanced)
									usr.client.screen += b
									for(var/obj/o in b)
										usr.client.screen += o
							return
			sense_box_advanced
				icon = 'sense_box_advanced.dmi'
				layer = 10
				screen_loc = "1:1,9:-8"
			info
				layer = 10
				mouse_opacity = 0
				screen_loc = "23:-5,2:-2"
				maptext_width = 320
				plane=22
				New()
					src.maptext = "<span style='-dm-text-outline: 1px #000000;text-align:right'>Wooden floor test</span>"
			cft_gains_txt
				layer = 100
				mouse_opacity = 0
				screen_loc = "1,TOP-7"
				maptext_width = 320
				plane = 22
				New()
					set background = 1
					..()
					if(!cycler || !cycler.client) return
					src.maptext = "<span style='-dm-text-outline: 1px #000000;text-align:left'><font color =#68D9FF><font size = 2>Cycle Free Time: 0 minute(s)</span>"
					spawn(10)
						while(src)
							if(src.cycler)
								src.maptext = "<span style='-dm-text-outline: 1px #000000;text-align:left'><font color =#68D9FF><font size = 2>Cycle Free Time: [round(cycler.cycle_free_time, 0.01)] minute(s)</span>"
								if(src.cycler.cycle_free_time<=0.01 || src.cycler == 0 )
									if(src.cycler.hud_cft) src.cycler.client.screen -= src.cycler.hud_cft
									else
										src.cycler.hud_cft = src
										src.cycler.client.screen -= src.cycler.hud_cft
									src.cycler.hud_cft = null
									src.cycler.rp_cycle_free_time = 0
									break
								sleep(10)
			accelerated_gains_txt
				layer = 100
				mouse_opacity = 0
				screen_loc = "1,TOP-5"
				maptext_width = 320
				plane = 22
				New()
					set background = 1
					..()
					src.maptext = "<span style='-dm-text-outline: 1px #000000;text-align:left'><font color =#91F46F><font size = 2>Accelerated Gains: 0 minute(s)</span>"
					spawn(10)
						while(src)
							if(src.accelerator)
								if(!src.accelerator.standing_gains_timer || src.accelerator.standing_gains_timer <=0 )
									src.maptext = "<span style='-dm-text-outline: 1px #000000;text-align:left'><font color =#91F46F><font size = 2>Accelerated Gains: [round(accelerator.offline_gains, 0.01)] minute(s)</span>"
									if(src.accelerator.offline_gains<=0.01 || src.accelerator == 0 )
										if(src.accelerator.hud_accelerator) src.accelerator.client.screen -= src.accelerator.hud_accelerator
										else
											src.accelerator.hud_accelerator = src
											src.accelerator.client.screen -= src.accelerator.hud_accelerator
										src.accelerator.hud_accelerator = null
										break
								else if(src.accelerator.standing_gains_timer)
									src.maptext = "<span style='-dm-text-outline: 1px #000000;text-align:left'><font color =#EF5555><font size = 2>(Paused)Accelerated Gains: [round(accelerator.offline_gains, 0.01)] minute(s)</span>"

								sleep(10)

			locator_coords
				layer = 10
				mouse_opacity = 0
				screen_loc = "23:-5,TOP"
				maptext_width = 320
				plane=22

				New()
					set background = 1
					..()
					src.maptext = "<span style='-dm-text-outline: 1px #000000;text-align:right'>Coordinates: 1,1</span>"
					spawn(10)
					while(src)
						if(src.coordinator)
							src.maptext = "<span style='-dm-text-outline: 1px #000000;text-align:right'>Coordinates: [coordinator.x],[coordinator.y]</span>"
							sleep(1)
			roleplay_rank_label
				layer = 1000
				mouse_opacity = 0
				screen_loc = "1:3,TOP-2:5"
				maptext_width = 100
				maptext_height = 320
				plane=35

				New()
					set background = 1
					..()
					src.maptext = "<span style='-dm-text-outline: 2px #000000;text-align:center'><b><font family = 'Gabriola'><font size =4>F</b></span>"
					spawn(10)
					while(src)
						if(src.rankist)
							src.maptext = "<span style='-dm-text-outline: 2px #000000;text-align:center'><b><font family = 'Gabriola'><font size =4>[rankist.roleplay_rank_letter]</span>"
							sleep(1)



		buttons
			close_menu
				var/obj/closes = null
				icon = 'new_hud_exit_button.dmi'
				icon_state = "exit"
				layer = 34
				plane = 22
				appearance_flags = KEEP_TOGETHER | PIXEL_SCALE
				MouseEntered(location,control,params)
					src.icon_state = "enter"
				MouseExited(location,control,params)
					src.icon_state = "exit"
				Click()
					if(src.closes)
						if(src.closes == usr.hud_stats)
							usr.open_stats = 0
							usr.client.screen -= usr.hud_stats

						else if(src.closes == usr.hud_inv)
							usr.open_inven = 0
							usr.client.screen -= usr.hud_inv

						else if(src.closes == usr.hud_tech)
							usr.open_tech = 0
							usr.client.screen -= usr.hud_tech

						else if(src.closes == usr.hud_skills)
							usr.open_skills = 0
							usr.client.screen -= usr.hud_skills

						else if(src.closes == usr.hud_body)
							usr.open_body = 0
							usr.client.screen -= usr.hud_body
							for(var/obj/hud/h in usr.milestone_hud)
								if(usr.client) usr.client.screen -= h
						else if(src.closes == usr.hud_unlocks)
							usr.client.screen -= usr.hud_unlocks
							usr.open_traits = 0
						else if(src.closes == usr.hud_contacts)
							usr.open_contacts = 0
							usr.client.screen -= usr.hud_contacts

						else if(src.closes == usr.hud_help)
							usr.open_help = 0
							usr.client.screen -= usr.hud_help

						else if(src.closes == usr.hud_updates)
							usr.open_updates = 0
							usr.client.screen -= usr.hud_updates

						else if(src.closes == usr.hud_build)
							usr.open_build = 0
							usr.client.screen -= usr.hud_build
						else if(usr.shop_opened)
							usr.shop_opened = 0
							usr.client.screen -= usr.current_shop

			cybernetic_slot
				icon = 'bodypart_cyber.dmi'
				icon_state = "empty"
				layer = 36
				plane = 22
				blend_mode = BLEND_INSET_OVERLAY
				var/selected = 0
				//var/slot = 0
				var/full = 0
				Click()
					..()
					if(usr.part_selected)
						var/obj/body_related/p = usr.part_selected
						p.underlays = null
						if(bodypart_underlay) bodypart_underlay.icon_state = "menu"
						p.underlays += bodypart_underlay
						usr.part_selected = null
					if(usr.cyber_selected)
						var/obj/hud/buttons/cybernetic_slot/cs = usr.cyber_selected
						cs.selected = 0
						if(cs.full == 0) cs.icon_state = "empty"
						else cs.icon_state = "full"
						usr.cyber_selected = null
					if(src.selected == 0)
						src.selected = 1
						if(src.full == 0) src.icon_state = "empty selected"
						else src.icon_state = "full selected"
						var/obj/body_related/b = src.loc
						if(b.cybernetics[src.slot] != null)
							var/obj/body_related/cyber = b.cybernetics[src.slot]
							cyber.select_part(usr,null)
						usr.cyber_selected = src
						return
				MouseEntered()
					..()
					if(src.loc)
						var/obj/body_related/bodyparts/b = src.loc
						if(usr.bodyparts.Find(b.loc,1,0))
							if(src.selected == 0)
								if(src.full == 0) src.icon_state = "empty hover"
								else src.icon_state = "full hover"
				MouseExited()
					..()
					if(src.loc)
						var/obj/body_related/bodyparts/b = src.loc
						if(usr.bodyparts.Find(b.loc,1,0))
							if(src.selected == 0)
								if(src.full == 0) src.icon_state = "empty"
								else src.icon_state = "full"
			expand_buttons
				layer = 33
				plane = 34
				icon = 'tech_expand_buttons.dmi'
				var/clicked = 0
				var/has_subtech = 0
				var/tmp/obj/tech_ref = null
				var/tech_path = null
				var/obj/hud/buttons/expand_buttons/parent = null
				var/hidden = 1
				var/obj/menu = null
				/*
				MouseWheel(delta_x,delta_y,location,control,params)
					params = params2list(params)
					var/list/buttons = list()
					buttons += usr.hud_tech.engineering_list
					buttons += usr.hud_tech.physics_list
					buttons += usr.hud_tech.genetics_list
					usr.text_y(usr.hud_tech.tech_tree_scroller1.icon_y_saved,254,254,delta_y,"clicked",16,buttons,usr.hud_tech.tech_tree_scroller1,308,usr.hud_tech.txt_x,usr.hud_tech.txt_y,27)
				*/
				proc
					create_expand_buttons(var/mob/m)
						if(m.hud_tech)
							var/all_buttons = list()
							var/list/L = null
							var/obj/tree_hud = null
							all_buttons += m.hud_tech.engineering_list
							all_buttons += m.hud_tech.physics_list
							all_buttons += m.hud_tech.genetics_list
							for(var/obj/items/tech/t in global.tech)
								if(istype(t,/obj/items/tech/sub_tech) == 0)
									if(usr.tech_unlocked[t.list_pos] == t.type)
										//Make sure to re-link special subtypes correctly, such as cybertech and drugs. Stops making copies of global objects which will duplicate if saved. Which is why tech_ref is set to /tmp
										if(t.type == /obj/items/tech/Cybertech)
											for(var/obj/hud/buttons/expand_buttons/expand_button/sub_b in all_buttons)
												if(ispath(sub_b.tech_path,/obj/body_related/) == 1) //Set to body_related because the actual cybernetic parts are located there in the code node tree
													for(var/obj/i in cybertech)
														if(i.type == sub_b.tech_path)
															sub_b.tech_ref = i
															break
										else if(t.type == /obj/items/tech/Drug_Synthesization)
											for(var/obj/hud/buttons/expand_buttons/expand_button/sub_b in all_buttons)
												if(ispath(sub_b.tech_path,/obj/items/drugs/) == 1)
													for(var/obj/i in drugs)
														if(i.type == sub_b.tech_path)
															sub_b.tech_ref = i
															break
										//Continue with normal techs/subtechs that have no extensive children
										if(t.tech_tree == "Engineering")
											L = m.hud_tech.engineering_list
											tree_hud = m.hud_tech.engineering
										else if(t.tech_tree == "Physics")
											L = m.hud_tech.physics_list
											tree_hud = m.hud_tech.physics
										else if(t.tech_tree == "Genetics")
											L = m.hud_tech.genetics_list
											tree_hud = m.hud_tech.genetics
										var/has_button = 0
										for(var/obj/hud/buttons/expand_buttons/expand_button/sub_b in all_buttons)
											if(sub_b.tech_ref == t)
												has_button = 1
												break
											else if(sub_b.tech_path == t.type)
												sub_b.tech_ref = t
												has_button = 1
												break
										if(has_button == 0)
											var/obj/hud/buttons/expand_buttons/expand_button/b = new
											b.maptext = "[css_outline]<font size = 1><text align=left valign=top>[t.name]"
											b.tech_ref = t
											b.tech_path = t.type
											b.parent = tree_hud
											if(t.has_subtech) b.has_subtech = 1
											b.hud_x = 20
											b.name = t.name
											L += b

											//Create buttons for any engineering tech that has a subtech, i.e Cybertech, Drug_Synthesization
											if(t.has_subtech)
												var/list/subtech = list()
												if(t.type == /obj/items/tech/Cybertech) subtech = cybertech
												else if(t.type == /obj/items/tech/Drug_Synthesization) subtech = drugs
												for(var/obj/i in subtech)
													var/obj/hud/buttons/expand_buttons/expand_button/sub_b = new
													sub_b.icon = 'tech_expand_buttons_large.dmi'
													sub_b.maptext = "[css_outline]<font size = 1><text align=left valign=top>[i.name]"
													sub_b.hud_x = 36
													sub_b.parent = b
													sub_b.tech_path = i.type
													sub_b.tech_ref = i
													sub_b.name = i.name
													L += sub_b
					expand_buttons(var/mob/m)
						var/yy = 0

						m.hud_tech.tech_holder_special.vis_contents = null
						m.hud_tech.tech_holder_special.vis_contents += m.hud_tech.engineering
						m.hud_tech.tech_holder_special.vis_contents += m.hud_tech.physics
						m.hud_tech.tech_holder_special.vis_contents += m.hud_tech.genetics
						m.hud_tech.size = 0
						m.hud_tech.size_build = 0

						var/obj/hud/menus/tech_background/s = m.hud_tech

						//Update engineering button positions
						for(var/obj/hud/buttons/expand_buttons/expand_button/b in m.hud_tech.engineering_list)
							if(b.parent && b.parent.hidden == 0 && b.parent.clicked)
								yy += 17
								m.hud_tech.size += 16
								m.hud_tech.size_build += 16
								b.hud_y = 679-yy
								var/matrix/mat = matrix()
								mat.Translate(b.hud_x,b.hud_y+m.hud_tech.bar_pos_y[m.hud_tech.selected])
								b.transform = mat
								if(b.has_subtech == 1)
									if(b.clicked)
										b.icon_state = "minus"
										b.maptext_x = 16
									else b.icon_state = "plus"
								s.tech_holder_special.vis_contents += b

						//Update physics button positions
						yy += 17
						m.hud_tech.size += 16
						m.hud_tech.size_build += 16
						s.physics.hud_y = 679-yy
						var/matrix/shift_p = matrix()
						shift_p.Translate(m.hud_tech.physics.hud_x,m.hud_tech.physics.hud_y+m.hud_tech.bar_pos_y[m.hud_tech.selected])
						s.physics.transform = shift_p
						for(var/obj/hud/buttons/expand_buttons/expand_button/b in m.hud_tech.physics_list)
							if(b.parent && b.parent.hidden == 0 && b.parent.clicked)
								yy += 17
								m.hud_tech.size += 16
								m.hud_tech.size_build += 16
								b.hud_y = 679-yy
								var/matrix/mat = matrix()
								mat.Translate(b.hud_x,b.hud_y+m.hud_tech.bar_pos_y[m.hud_tech.selected])
								b.transform = mat
								if(b.has_subtech == 1)
									if(b.clicked)
										b.icon_state = "minus"
										b.maptext_x = 16
									else b.icon_state = "plus"
								s.tech_holder_special.vis_contents += b

						//Update genetics button positions
						yy += 17
						m.hud_tech.size += 16
						m.hud_tech.size_build += 16
						s.genetics.hud_y = 679-yy
						var/matrix/shift_g = matrix()
						shift_g.Translate(m.hud_tech.genetics.hud_x,m.hud_tech.genetics.hud_y+m.hud_tech.bar_pos_y[m.hud_tech.selected])
						s.genetics.transform = shift_g
						for(var/obj/hud/buttons/expand_buttons/expand_button/b in m.hud_tech.genetics_list)
							if(b.parent && b.parent.hidden == 0 && b.parent.clicked)
								yy += 17
								m.hud_tech.size += 16
								m.hud_tech.size_build += 16
								b.hud_y = 679-yy
								var/matrix/mat = matrix()
								mat.Translate(b.hud_x,b.hud_y+m.hud_tech.bar_pos_y[m.hud_tech.selected])
								b.transform = mat
								if(b.has_subtech == 1)
									if(b.clicked)
										b.icon_state = "minus"
										b.maptext_x = 16
									else b.icon_state = "plus"
								s.tech_holder_special.vis_contents += b
				expand_button
					icon_state = "expanded"
					maptext_width = 320
					maptext_height = 16
					maptext_x = 16
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseEntered()
						if(src.icon_state == "expanded") src.icon_state = "expanded moused"
					MouseExited()
						if(src.icon_state == "expanded moused") src.icon_state = "expanded"
					MouseWheel(delta_x,delta_y,location,control,params)
						if(usr.hud_tech)
							var/obj/hud/menus/tech_background/s = usr.hud_tech
							var/obj/sc = s.tech_tree_scroller1
							usr.check_mouse_loc(params)
							var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
							usr.mouse_y_true = true_y
							var/wheel_move = 0
							if(delta_y > 0) wheel_move = 16
							else if(delta_y < 0) wheel_move = -16
							var/result = sc.translated_y+wheel_move
							result = clamp(result,0,-227)
							var/matrix/m = matrix()
							m.Translate(0,result)
							sc.transform = m
							sc.translated_y = result
							s.scrl_transform[s.selected] = m
							var/ratio = -1 + ((-227 + result) / -227)
							ratio = clamp(ratio,0,1)
							var/scroll_y = round(s.size*ratio)
							s.bar_pos_y[s.selected] = scroll_y
							for(var/obj/o in s.tech_holder_special.vis_contents)
								var/matrix/m2 = matrix()
								m2.Translate(o.hud_x-s.bar_pos_x_hori[s.selected],o.hud_y+s.bar_pos_y[s.selected])
								o.transform = m2
					Click()
						var/pass = 0
						var/list/L = list()
						if(usr.hud_tech)
							if(src in usr.hud_tech.engineering_list)
								pass = 1
								L = usr.hud_tech.engineering_list
							else if(src in usr.hud_tech.physics_list)
								pass = 1
								L = usr.hud_tech.physics_list
							else if(src in usr.hud_tech.genetics_list)
								pass = 1
								L = usr.hud_tech.genetics_list
							if(pass) //Make sure that anything in the lists above is only put there once researched, so players can't use .click to click on tech they don't know yet
								if(src.has_subtech)
									if(src.clicked)
										src.clicked = 0
										src.icon_state = "plus"
										for(var/obj/hud/buttons/expand_buttons/b in L)
											if(b.parent == src) b.hidden = 1
									else
										src.clicked = 1
										src.icon_state = "minus"
										for(var/obj/hud/buttons/expand_buttons/b in L)
											if(b.parent == src) b.hidden = 0
									src.expand_buttons(usr)
								else if(src.tech_ref)
									var/obj/items/itm = src.tech_ref
									//world << "DEBUG - clicked tech"
									if(itm.loc == null)
										//world << "DEBUG - tech loc is null"
										for(var/obj/t in global.tech)//usr.technology_researched)
											usr.client.images -= t.img_select
										if(usr.build_tech_selected)
											var/obj/t = usr.build_tech_selected
											t.filters -= filter(type="outline", size=4, color=rgb(255,255,255))
										usr.build_tech_selected = itm;
										itm.filters += filter(type="outline", size=4, color=rgb(255,255,255))
										if(istype(itm,/obj/items/tech/weights/)) itm.value = itm.weight*100
										var/icon/Icn = icon(itm.icon,itm.icon_state,SOUTH,1,0)
										Icn.Scale(itm.scale_x,itm.scale_y)
										if(usr.build_mouse)
											usr.build_mouse.loc = null
											usr.build_mouse = null

										//Setup and/or reset the settings related to the number of items to make and their tech lvls
										var/obj/hud/menus/tech_background/s = usr.hud_tech
										if(itm.stacks > -1)
										//	usr.hud_tech.set_tech_desc(usr,itm)
											usr.hud_tech.show_tech_costs(usr,itm)
											s.tech_make.maptext = "[css_outline]<font size = 1><center>[s.num_to_make]"
										else
											//usr.hud_tech.set_tech_desc(usr,itm)
											usr.hud_tech.show_tech_costs(usr,itm)
											s.tech_make.maptext = "[css_outline]<font size = 1><center>1"
											s.num_to_make = 1
											var/matrix/m = matrix()
											m.Translate(80,15)
											s.slider_make.transform = m

										var/matrix/m = matrix()
										m.Translate(277,39)
										s.slider_lvl.transform = m

										if(itm.tech_parent_path)
											//world << "DEBUG - found t = [t], with a tech_parent_path of [t.tech_parent_path]"
											var/found_match = 0
											for(var/obj/items/tech/t2 in global.tech)//usr.technology_researched)
												if(t2.type == itm.tech_parent_path)
													s.tech_num.maptext = "[css_outline]<font size = 1><center>[t2.tech_lvl]"
													s.lvl_to_make = t2.tech_lvl
													found_match = 1
													break
											if(found_match == 0)
												s.tech_num.maptext = "[css_outline]<font size = 1><center>1"
												s.lvl_to_make = 1
										else
											//world << "DEBUG - wasn't able to find a tech_parent_path for [t] "
											s.tech_num.maptext = "[css_outline]<font size = 1><center>[itm.tech_lvl]"
											s.lvl_to_make = 1
										//usr.hud_tech.set_tech_desc(usr,itm)
										usr.hud_tech.show_tech_costs(usr,itm)
									//	s.intel_make.maptext = "[css_outline]<font size = 1><center>[round(usr.intel_points,1)]"
				tech_expand_buttons
					icon_state = "plus"
					blend_mode = BLEND_INSET_OVERLAY
					appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
					MouseWheel(delta_x,delta_y,location,control,params)
						if(usr.hud_tech)
							var/obj/hud/menus/tech_background/s = usr.hud_tech
							var/obj/sc = s.tech_tree_scroller1
							usr.check_mouse_loc(params)
							var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
							usr.mouse_y_true = true_y
							var/wheel_move = 0
							if(delta_y > 0) wheel_move = 16
							else if(delta_y < 0) wheel_move = -16
							var/result = sc.translated_y+wheel_move
							result = clamp(result,0,-227)
							var/matrix/m = matrix()
							m.Translate(0,result)
							sc.transform = m
							sc.translated_y = result
							s.scrl_transform[s.selected] = m
							var/ratio = -1 + ((-227 + result) / -227)
							ratio = clamp(ratio,0,1)
							var/scroll_y = round(s.size*ratio)
							s.bar_pos_y[s.selected] = scroll_y
							for(var/obj/o in s.tech_holder_special.vis_contents)
								var/matrix/m2 = matrix()
								m2.Translate(o.hud_x-s.bar_pos_x_hori[s.selected],o.hud_y+s.bar_pos_y[s.selected])
								o.transform = m2
					genetics
						maptext_width = 320
						maptext_height = 16
						maptext_x = 16
						maptext_y = 1
						Click()
							if(usr.hud_tech && src in usr.hud_tech.genetics_list)
								src.create_expand_buttons(usr)
								if(src.clicked)
									src.icon_state = "plus"
									src.clicked = 0
									for(var/obj/hud/buttons/expand_buttons/b in usr.hud_tech.genetics_list)
										if(b != src)
											usr.hud_tech.tech_holder_special.vis_contents -= b
											b.hidden = 1
								else
									src.icon_state = "minus"
									src.clicked = 1
									for(var/obj/hud/buttons/expand_buttons/b in usr.hud_tech.genetics_list)
										if(b != src && b.parent && b.parent.hidden == 0 && b.parent.clicked) b.hidden = 0
								src.expand_buttons(usr)
					physics
						maptext_width = 320
						maptext_height = 16
						maptext_x = 16
						maptext_y = 1
						Click()
							if(usr.hud_tech && src in usr.hud_tech.physics_list)
								src.create_expand_buttons(usr)
								if(src.clicked)
									src.icon_state = "plus"
									src.clicked = 0
									for(var/obj/hud/buttons/expand_buttons/b in usr.hud_tech.physics_list)
										if(b != src)
											usr.hud_tech.tech_holder_special.vis_contents -= b
											b.hidden = 1
								else
									src.icon_state = "minus"
									src.clicked = 1
									for(var/obj/hud/buttons/expand_buttons/b in usr.hud_tech.physics_list)
										if(b != src && b.parent && b.parent.hidden == 0 && b.parent.clicked) b.hidden = 0
								src.expand_buttons(usr)
					engineering
						maptext_width = 320
						maptext_height = 16
						maptext_x = 16
						maptext_y = 1
						Click()
							if(usr.hud_tech && src in usr.hud_tech.engineering_list)
								src.create_expand_buttons(usr)
								if(src.clicked)
									src.icon_state = "plus"
									src.clicked = 0
									for(var/obj/hud/buttons/expand_buttons/b in usr.hud_tech.engineering_list)
										if(b != src)
											usr.hud_tech.tech_holder_special.vis_contents -= b
											b.hidden = 1
								else
									src.icon_state = "minus"
									src.clicked = 1
									for(var/obj/hud/buttons/expand_buttons/b in usr.hud_tech.engineering_list)
										if(b != src && b.parent && b.parent.hidden == 0 && b.parent.clicked) b.hidden = 0
								src.expand_buttons(usr)
			tabs
				icon = 'new_hud_tabs.dmi'
				var/clicked = 0
				plane = 34
				var/max_y = 500
				var/max_x = 120
				var/max_y_txt = 1000
				/*
				MouseEntered(location,control,params)
					if(src.clicked == 0) src.icon_state = "tab mouse over"
				MouseExited(location,control,params)
					if(src.clicked) src.icon_state = "tab selected"
					else src.icon_state = "tab not selected"
				*/
				tech_build
					icon = 'new_hud_tabs_tech.dmi'
					tab1
						icon_state = "tab selected"
						clicked = 1
						max_y = 1000
						max_x = 120
						Click()
							if(usr.hud_tech)
								var/obj/hud/menus/tech_background/s = usr.hud_tech
								var/obj/sc = s.tech_tree_scroller1
								if(s.selected == 2) s.engineering_y = sc.translated_y
								else if(s.selected == 3) s.physics_y = sc.translated_y
								else if(s.selected == 4) s.genetics_y = sc.translated_y
								if(src in usr.hud_tech.tabs)
									if(src.clicked == 0)
										s.selected = 1
										usr.hud_tech.vis_contents -= usr.hud_tech.button_research
										usr.hud_tech.vis_contents += usr.hud_tech.button_use
										s.tech_holder_special.vis_contents = null
										s.vis_contents -= s.rsc

										//s.vis_contents += s.rsc2num
										src.clicked = 1
										src.icon_state = "tab selected"
										sc.translated_y = s.tech_y
										for(var/obj/hud/buttons/tabs/t in s.tabs)
											if(t != src)
												t.clicked = 0
												t.icon_state = "tab not selected"
										if(s.tech_tree_scroller1) s.tech_tree_scroller1.transform = s.scrl_transform[s.selected]

										for(var/obj/hud/buttons/expand_buttons/tech_expand_buttons/b in s.engineering_list)
											b.expand_buttons(usr)
											break
										s.size = s.size_build
										if(s.size <= 200) s.bar_pos_y[s.selected] = 0
										/*
										for(var/obj/b in s.engineering_list)
											s.tech_holder_special.vis_contents += b
										for(var/obj/b in s.physics_list)
											s.tech_holder_special.vis_contents += b
										for(var/obj/b in s.genetics_list)
											s.tech_holder_special.vis_contents += b
										*/

										/*
										for(var/obj/o in s.tech_holder_special.vis_contents)
											var/matrix/m2 = matrix()
											m2.Translate(o.hud_x-s.bar_pos_x_hori[s.selected],o.hud_y+s.bar_pos_y[s.selected])
											o.transform = m2
										*/

										/*
										var/matrix/m2 = matrix()
										m2.Translate(s.tech_holder_special.hud_x-s.bar_pos_x_hori[s.selected],s.tech_holder_special.hud_y+s.bar_pos_y[s.selected])
										s.tech_holder_special.transform = m2
										*/

										s.tech_holder_special.overlays = null
										return
						New()
							src.maptext_width = 128
							src.maptext_height = 16
							src.maptext_x = 9
							src.maptext = "[css_outline]<font size = 1><text align=left valign=top>Build Tech"
							src.layer = 34
							src.appearance_flags = PIXEL_SCALE
							var/matrix/m = matrix()
							m.Translate(11,326)
							src.transform = m
					tab2
						icon_state = "tab not selected"
						max_y = 250
						max_x = 150
						Click()
							if(usr.hud_tech)
								var/obj/hud/menus/tech_background/s = usr.hud_tech
								var/obj/sc = s.tech_tree_scroller1
								if(s.selected == 1) s.tech_y = sc.translated_y
								else if(s.selected == 3) s.physics_y = sc.translated_y
								else if(s.selected == 4) s.genetics_y = sc.translated_y
								if(src in s.tabs)
									if(src.clicked == 0)
										s.size = 200
										s.selected = 2
										s.tech_holder_special.vis_contents = null
										s.tech_holder_special.vis_contents += s.visual_tree_engineering
										usr.hud_tech.vis_contents -= usr.hud_tech.button_use
										s.vis_contents += s.rsc
								//		s.vis_contents -= s.rsc2num
										s.vis_contents += s.tech_tree_scrollbar2
										s.vis_contents += s.tech_tree_scroller2
										s.vis_contents += s.tech_edge
										sc.translated_y = s.engineering_y
										src.clicked = 1
										src.icon_state = "tab selected"
										for(var/obj/o in s.tree_engineering_list)
											s.tech_holder_special.vis_contents += o
										for(var/obj/hud/buttons/tabs/t in s.tabs)
											if(t != src)
												t.clicked = 0
												t.icon_state = "tab not selected"
										if(s.tech_tree_scroller1) s.tech_tree_scroller1.transform = s.scrl_transform[s.selected]
										if(s.tech_tree_scroller2) s.tech_tree_scroller2.transform = s.scrl_transform_hori[s.selected]

										var/matrix/m2 = matrix()
										m2.Translate(s.tech_holder_special.hud_x-s.bar_pos_x_hori[s.selected],s.tech_holder_special.hud_y+s.bar_pos_y[s.selected])
										s.tech_holder_special.transform = m2

										usr.tech_xp_update()
						New()
							src.maptext_width = 128
							src.maptext_height = 16
							src.maptext_x = 7
							src.maptext = "[css_outline]<font size = 1><text align=left valign=top>Engineering"
							src.layer = 34
							src.appearance_flags = PIXEL_SCALE
							var/matrix/m = matrix()
							m.Translate(82,326)
							src.transform = m
					tab3
						icon_state = "tab not selected"
						max_y = 250
						max_x = 150
						Click()
							if(usr.hud_tech)
								var/obj/hud/menus/tech_background/s = usr.hud_tech
								var/obj/sc = s.tech_tree_scroller1
								if(s.selected == 1) s.tech_y = sc.translated_y
								else if(s.selected == 2) s.engineering_y = sc.translated_y
								else if(s.selected == 4) s.genetics_y = sc.translated_y
								if(src in usr.hud_tech.tabs)
									if(src.clicked == 0)
										s.selected = 3
										s.size = 200
										s.tech_holder_special.vis_contents = null
										s.tech_holder_special.vis_contents += s.visual_tree_physics
										usr.hud_tech.vis_contents -= usr.hud_tech.button_use
										s.vis_contents += s.tech_tree_scrollbar2
										s.vis_contents += s.tech_tree_scroller2
										s.vis_contents += s.tech_edge
										s.vis_contents += s.rsc
									//	s.vis_contents -= s.rsc2num
										sc.translated_y = s.physics_y
										src.clicked = 1
										src.icon_state = "tab selected"
										for(var/obj/o in s.tree_physics_list)
								//			if(usr.int_xp >= o:needed_int)
											s.tech_holder_special.vis_contents += o
										for(var/obj/hud/buttons/tabs/t in usr.hud_tech.tabs)
											if(t != src)
												t.clicked = 0
												t.icon_state = "tab not selected"
										if(s.tech_tree_scroller1) s.tech_tree_scroller1.transform = s.scrl_transform[s.selected]
										if(s.tech_tree_scroller2) s.tech_tree_scroller2.transform = s.scrl_transform_hori[s.selected]

										var/matrix/m2 = matrix()
										m2.Translate(s.tech_holder_special.hud_x-s.bar_pos_x_hori[s.selected],s.tech_holder_special.hud_y+s.bar_pos_y[s.selected])
										s.tech_holder_special.transform = m2

										usr.tech_xp_update()
						New()
							src.maptext_width = 128
							src.maptext_height = 16
							src.maptext_x = 16
							src.maptext = "[css_outline]<font size = 1><text align=left valign=top>Physics"
							src.layer = 34
							src.appearance_flags = PIXEL_SCALE
							var/matrix/m = matrix()
							m.Translate(153,326)
							src.transform = m
					tab4
						icon_state = "tab not selected"
						max_y = 250
						max_x = 150
						Click()
							if(usr.hud_tech)
								var/obj/hud/menus/tech_background/s = usr.hud_tech
								var/obj/sc = s.tech_tree_scroller1
								if(s.selected == 1) s.tech_y = sc.translated_y
								else if(s.selected == 2) s.engineering_y = sc.translated_y
								else if(s.selected == 3) s.physics_y = sc.translated_y
								if(src in usr.hud_tech.tabs)
									if(src.clicked == 0)
										s.selected = 4
										s.size = 200
										s.tech_holder_special.vis_contents = null
										s.tech_holder_special.vis_contents += s.visual_tree_genetics
										usr.hud_tech.vis_contents -= usr.hud_tech.button_use
										s.vis_contents += s.tech_tree_scrollbar2
										s.vis_contents += s.tech_tree_scroller2
										s.vis_contents += s.tech_edge
										s.vis_contents += s.rsc
									//	s.vis_contents -= s.rsc2num
										sc.translated_y = s.genetics_y
										src.clicked = 1
										src.icon_state = "tab selected"
										for(var/obj/o in s.tree_genetics_list)
											s.tech_holder_special.vis_contents += o
										for(var/obj/hud/buttons/tabs/t in usr.hud_tech.tabs)
											if(t != src)
												t.clicked = 0
												t.icon_state = "tab not selected"
										if(s.tech_tree_scroller1) s.tech_tree_scroller1.transform = s.scrl_transform[s.selected]
										if(s.tech_tree_scroller2) s.tech_tree_scroller2.transform = s.scrl_transform_hori[s.selected]

										var/matrix/m2 = matrix()
										m2.Translate(s.tech_holder_special.hud_x-s.bar_pos_x_hori[s.selected],s.tech_holder_special.hud_y+s.bar_pos_y[s.selected])
										s.tech_holder_special.transform = m2

										usr.tech_xp_update()
						New()
							src.maptext_width = 128
							src.maptext_height = 16
							src.maptext_x = 13
							src.maptext = "[css_outline]<font size = 1><text align=left valign=top>Genetics"
							src.layer = 34
							src.appearance_flags = PIXEL_SCALE
							var/matrix/m = matrix()
							m.Translate(224,326)
							src.transform = m
			load_delete_new
				icon = 'HUD_load_delete.dmi'
				icon_state = "none"
				var/sav_num = 1
				load
				delete
				new_char
				MouseEntered(location,control,params)
					..()
					src.icon_state = "active"
				MouseExited(location,control,params)
					..()
					src.icon_state = "none"
			skillbar
				icon = 'hud_skillbar_new.dmi'
				plane = 22
				skillbar_one
					icon_state = "1"
					screen_loc = "12:-14,1:3"
				skillbar_two
					icon_state = "2"
					screen_loc = "13:-13,1:3"
				skillbar_three
					icon_state = "3"
					screen_loc = "14:-12,1:3"
				skillbar_four
					icon_state = "4"
					screen_loc = "15:-11,1:3"
				skillbar_five
					icon_state = "5"
					screen_loc = "16:-10,1:3"
				skillbar_six
					icon_state = "6"
					screen_loc = "17:-9,1:3"
				skillbar_seven
					icon_state = "7"
					screen_loc = "18:-8,1:3"
				skillbar_eight
					icon_state = "8"
					screen_loc = "19:-7,1:3"
				skillbar_nine
					icon_state = "9"
					screen_loc = "20:-6,1:3"
				skillbar_zero
					icon_state = "0"
					screen_loc = "21:-5,1:3"
				skillbar_one_overlay
					icon_state = "1 overlay"
					screen_loc = "12:-14,1:3"
					layer = 38
					plane = 34
				skillbar_two_overlay
					icon_state = "2 overlay"
					screen_loc = "13:-13,1:3"
					layer = 38
					plane = 34
				skillbar_three_overlay
					icon_state = "3 overlay"
					screen_loc = "14:-12,1:3"
					layer = 38
					plane = 34
				skillbar_four_overlay
					icon_state = "4 overlay"
					screen_loc = "15:-11,1:3"
					layer = 38
					plane = 34
				skillbar_five_overlay
					icon_state = "5 overlay"
					screen_loc = "16:-10,1:3"
					layer = 38
					plane = 34
				skillbar_six_overlay
					icon_state = "6 overlay"
					screen_loc = "17:-9,1:3"
					layer = 38
					plane = 34
				skillbar_seven_overlay
					icon_state = "7 overlay"
					screen_loc = "18:-8,1:3"
					layer = 38
					plane = 34
				skillbar_eight_overlay
					icon_state = "8 overlay"
					screen_loc = "19:-7,1:3"
					layer = 38
					plane = 34
				skillbar_nine_overlay
					icon_state = "9 overlay"
					screen_loc = "20:-6,1:3"
					layer = 38
					plane = 34
				skillbar_zero_overlay
					icon_state = "0 overlay"
					screen_loc = "21:-5,1:3"
					layer = 38
					plane = 34
			main
				plane=29
				var
					tooltip_shift_x = -10
					tooltip_shift_y = 28
				toggle_skillbar_button
					icon = 'loadout_swap.dmi'
					icon_state = "1" // You can define this state in the icon
					screen_loc = "11:-14,BOTTOM" // Adjust position as needed

					MouseEntered(location, control, params)
						src.overlays -= /obj/hud/buttons/main/button_mouseover2
						src.overlays += /obj/hud/buttons/main/button_mouseover2
						if(usr.info_box1)
							usr.client.screen += usr.info_box1
							usr.client.screen += usr.info_box2
							usr.client.screen += usr.info_box3
							usr.info_box(src, "Swap Skillbar", params)

					MouseExited(location, control, params)
						src.overlays = null
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null

					MouseMove(location, control, params)
						..()
						usr.info_box(src, "Swap Skillbar", params)

					Click()
						if(!usr.started) return
						if(!usr.loadout_button) usr.loadout_button = src
						usr.clear_skillbar_screen()
						usr.active_skillbar = (usr.active_skillbar == "1") ? "2" : "1"
						usr.sync_active_skillbar()
						usr.skillbar()
						if(usr.active_skillbar == "1") src.icon_state = "1"
						if(usr.active_skillbar == "2") src.icon_state = "2"

				button_mouseover2
					icon = 'RPBoxes.dmi'
					icon_state ="mouse over"
				button_mouseover
					icon = 'hud_buttons_new.dmi'
					icon_state = "mouse over"
				button_options
					icon = 'hud_buttons_new.dmi'
					icon_state = "options"
					screen_loc = "32,BOTTOM"
					MouseEntered(location,control,params)
						src.overlays -= /obj/hud/buttons/main/button_mouseover
						src.overlays += /obj/hud/buttons/main/button_mouseover
						if(usr.info_box1)
							usr.client.screen += usr.info_box1
							usr.client.screen += usr.info_box2
							usr.client.screen += usr.info_box3
							usr.info_box(src,src.name,params)
					MouseExited(location,control,params)
						src.overlays = null
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseMove(location,control,params)
						..()
						usr.info_box(src,"Options",params)
					Click()
						if(usr.started == 0) return
						if(usr.open_options)
							//winshow(usr,"options",0)
							usr.client.screen -= usr.hud_opt
							usr.open_options = 0
							winshow(usr,"help",0)
							usr.open_help = 0
							usr.open_menus.Remove("open_options")
						else
							//winshow(usr,"options",1)
							usr.open_options = 1
							usr.client.screen += usr.hud_opt
							winset(usr,"options.label_version","text=\"Version - [game_version]\"")
							usr.open_menus.Add("open_options")
						winset(usr,"map.map","focus=true")
				/*button_emote
					icon = 'hud_buttons_new.dmi'
					icon_state = "emote"
					screen_loc = "1:2,5:16" // 31:1,1
					MouseEntered(location,control,params)
						src.overlays -= /obj/hud/buttons/main/button_mouseover
						src.overlays += /obj/hud/buttons/main/button_mouseover
						if(usr.info_box1)
							usr.client.screen += usr.info_box1
							usr.client.screen += usr.info_box2
							usr.client.screen += usr.info_box3
							usr.info_box(src,src.name,params)
					MouseExited(location,control,params)
						src.overlays = null
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseMove(location,control,params)
						..()
						usr.info_box(src,"Emote",params)
					Click()
						if(usr.open_emote == 0)
							winshow(usr,"emote",1)
							winset(usr,"emote.input_emote","focus=true")
							usr.open_emote = 1;
							usr.RP_open_time = world.time / 10
							usr.overlays -= 'Typing.dmi'
							usr.overlays += 'Typing.dmi'
							usr.open_menus.Add(".open_emote")
							while(usr.open_emote)
								var/T = winget(usr,"emote.input_emote","text")
								var/L = length(T)
								winset(usr,"emote.chars","text=\"Characters: [L]\"")
								var/RP = 0.001*L
								winset(usr,"emote.rpp","text=\"Estimated RPP reward: [RP]\"")
								sleep(10)
						else
							winshow(usr,"emote",0)
							usr.open_emote = 0
							overlays -= 'Typing.dmi'
							usr.open_menus.Remove(".open_emote")
							return
						//if(usr.started == 0) return
					//	if(usr.open_emote)
					//		winshow(usr,"emote",0)
					//		usr.open_emote = 0
						//	usr.open_menus.Remove(".open_emote")
					//	else
						//winshow(usr,"emote",1)
					//	usr.open_emote = 1
					//	usr.open_menus.Add(".open_emote")
						winset(usr,"map.map","focus=true")
						*/


				button_emote
					icon = 'hud_buttons_new.dmi'
					icon_state = "emote"
					screen_loc = "33,BOTTOM" //"1:2,8:12" // Adjust as needed
					MouseEntered(location, control, params)
						src.overlays -= /obj/hud/buttons/main/button_mouseover
						src.overlays += /obj/hud/buttons/main/button_mouseover
						if (usr.info_box1)
							usr.client.screen += usr.info_box1
							usr.client.screen += usr.info_box2
							usr.client.screen += usr.info_box3
						usr.info_box(src, src.name, params)
					MouseExited(location, control, params)
						src.overlays = null
						if (usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseMove(location, control, params)
						..()
						usr.info_box(src, "Emote", params)
					Click()
						usr.overlays -= 'roleplay_alert.dmi'
						usr.overlays += 'roleplay_alert.dmi'

						var/Secs_Open = world.time / 10

						var/msg = input("Emote") as message

						if(!msg)
							usr.overlays -= 'roleplay_alert.dmi'
							return

						//var/icon/I = usr.getIconImage()
						//var/Old_Sight=see_invisible
					//	see_invisible=101
						var/speaker_color = usr.text_color_ic ? usr.text_color_ic : "#FFFFFF"
						var/Secs_Close = world.time / 10
						Secs_Close -= Secs_Open
					//	src.RP_Actual = msg
						msg = quotify(msg,speaker_color)
					//	var/officialmsg
						var/icon/PI = usr.GetPortraitIcon()
						var/portrait_ref = null

						if(PI)
							portrait_ref = fcopy_rsc(PI)

						var/RP = rand(0.08,0.15)
						for(var/mob/M in hearers(20,usr))
							if(!M || !M.client) continue
							/*if(M.observed)
								for(var/mob/player/P in Players)
									if(P.observee==M)
										if(P.client)
											P<<output("<span class=\"emote\"><b><font size=[M.TextSize]><font color=yellow>*</font> (OBSERVE) | [usr.name] <font color='yellow'>[src.ICText(msg, M)]*</font></span>", "rpoutput")*/
							if(M.client)
								if(RP < 0.005)
									RP += 0.0005
								//	officialmsg = "<span class=\"emote\"><b><font color=yellow>*</font> [usr.name] <font color='yellow'>[usr.ICText(msg, M)]*</font> (" + roleplay_link + ")</span>"

								//M<<output("<span class=\"emote\"><b><font size=3<font color=yellow>*</font> <font color = [usr.text_color_ic]>[M.get_strangername(usr)]</font> <font color='yellow'>[usr.ICText(msg, usr)]","actionoutput")
								var/portrait_html = ""
								if(portrait_ref)
									portrait_html = "<img src='\ref[portrait_ref]' width=64 height=82 style='vertical-align:middle;'> "

								M << output("<span class=\"emote\"><b>[portrait_html]<font color=yellow>*</font> <font color=[usr.text_color_ic]>[M.get_strangername(usr)]</font> <font color='yellow'>[usr.ICText(msg, usr)]*</font></span>", "actionoutput")


								//officialmsg = "<span class=\"emote\"><b><font color=yellow>*</font> [usr.name] <font color='yellow'>[usr.ICText(msg, M)]*</font></span>"



						usr.Check_RP(msg,RP,Secs_Close,"Emote")
						world<<output("<font color=[speaker_color]>[usr]([usr.key]) RP: *[usr.ICText(msg, usr)]*</font>\n","rpspy.output2")
					//	see_invisible=Old_Sight
						//for(var/mob/player/MM in Players) if(MM.client.holder)	MM << output("<br> <span class=\"emote\">*[src] [msg]*</span>\n","rpspy.output1")
						RoleplaySpyLog(msg, TRUE)
						usr.overlays -= 'roleplay_alert.dmi'
						usr.Roleplay_Spark()
						usr.overlays.Remove('roleplay_alert.dmi')
						if(usr.rp_mode == "Phase" && usr.phase_ready && usr.phased)
							if(prob(75))
								usr.overlays -= usr.phase_icon
								usr.phased=0
								usr.phase_ready=0

					//	var/emote_logfile = "Data/Players/[usr.key]/Logs/Emote_[real_name].log"
					//	file(emote_logfile) << "Year - [Year], Time - [time2text(world.timeofday, "YYYY-MM-DDThh:mm:ss")] [usr.name] [msg]"

						/*if (!usr.open_emote)
							// Create the emote HUD dynamically
							if (!usr.open_emote_hud)
								var/obj/hud/emote_window/emote_hud = new
								emote_hud.screen_loc = "15,15"
								usr.open_emote_hud = emote_hud
							usr.client.screen += usr.open_emote_hud
							usr.open_emote = 1
							usr.RP_open_time = world.time / 10
							usr.overlays += 'Typing.dmi'

							while (usr.open_emote)
								var/T = usr.open_emote_hud.input_text
								var/L = length(T)
								usr.open_emote_hud.char_count = L
								usr.open_emote_hud.estimated_reward = 0.001 * L
								usr.open_emote_hud.display()
								sleep(10)
						else
							// Close the emote HUD
							if (usr.open_emote_hud)
								usr.client.screen -= usr.open_emote_hud
								del(usr.open_emote_hud)
								usr.open_emote_hud = null
							usr.open_emote = 0
							usr.overlays -= 'Typing.dmi'
						winset(usr,"map.map","focus=true")*/
				button_contacts
					icon = 'hud_buttons_new.dmi'
					icon_state = "contacts"
					screen_loc = "31:1,BOTTOM"
					MouseEntered(location,control,params)
						src.overlays -= /obj/hud/buttons/main/button_mouseover
						src.overlays += /obj/hud/buttons/main/button_mouseover
						if(usr.info_box1)
							usr.client.screen += usr.info_box1
							usr.client.screen += usr.info_box2
							usr.client.screen += usr.info_box3
							usr.info_box(src,src.name,params)
					MouseExited(location,control,params)
						src.overlays = null
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseMove(location,control,params)
						..()
						usr.info_box(src,"Relations & Questlog",params)
					Click()
						if(usr.started == 0) return
						if(usr.open_contacts)
							//winshow(usr,"contacts",0)
							usr.client.screen -= usr.hud_contacts
							usr.open_contacts = 0
							usr.open_menus.Remove(".open_contacts")
						else
							//winshow(usr,"contacts",1)
							usr.client.screen += usr.hud_contacts
							usr.open_contacts = 1
							usr.open_menus.Add(".open_contacts")
							if(usr.hud_contacts.selected == 1) usr.hud_contacts.players("Online")
							else if(usr.hud_contacts.selected == 2) usr.hud_contacts.display_contacts(usr,usr.player_contacts)
							else if(usr.hud_contacts.selected == 4) usr.hud_contacts.quests(usr)
						winset(usr,"map.map","focus=true")
				/*button_unlocks
					icon = 'hud_buttons_new.dmi'
					icon_state = "unlocks"
					screen_loc = "29:3,1"
					MouseEntered(location,control,params)
						src.overlays -= /obj/hud/buttons/main/button_mouseover
						src.overlays += /obj/hud/buttons/main/button_mouseover
						if(usr.info_box1)
							usr.client.screen += usr.info_box1
							usr.client.screen += usr.info_box2
							usr.client.screen += usr.info_box3
							usr.info_box(src,src.name,params)
					MouseExited(location,control,params)
						src.overlays = null
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseMove(location,control,params)
						..()
						usr.info_box(src,"Unlocks",params)
					Click()
						if(usr.started == 0) return
						if(usr.open_traits)
							usr.client.screen -= usr.hud_unlocks
							usr.open_traits = 0
							usr.open_menus.Remove(".open_traits")
						else
							usr.client.screen += usr.hud_unlocks
							usr.open_traits = 1
							usr.open_menus.Add(".open_traits")
						winset(usr,"map.map","focus=true") */
				button_inv
					icon = 'hud_buttons_new.dmi'
					icon_state = "inv"
					screen_loc = "31:1,BOTTOM" //screen_loc = "30:2,BOTTOM"
					MouseEntered(location,control,params)
						src.overlays -= /obj/hud/buttons/main/button_mouseover
						src.overlays += /obj/hud/buttons/main/button_mouseover
						if(usr.info_box1)
							usr.client.screen += usr.info_box1
							usr.client.screen += usr.info_box2
							usr.client.screen += usr.info_box3
							usr.info_box(src,src.name,params)
					MouseExited(location,control,params)
						src.overlays = null
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseMove(location,control,params)
						..()
						usr.info_box(src,"Inventory",params)
					Click()
						if(usr.started == 0) return
						if(usr.open_inven)
							//winshow(usr,"inven",0)
							usr.client.screen -= usr.hud_inv
							usr.open_inven = 0
							usr.open_menus.Remove(".open_inven")
						else
							usr.accessing = usr
							//winshow(usr,"inven",1)
							usr.client.screen += usr.hud_inv
							usr.open_inven = 1
							usr.open_menus.Add(".open_inven")
							usr.refresh_inv()
						winset(usr,"map.map","focus=true")
				button_skills
					icon = 'hud_buttons_new.dmi'
					icon_state = "skills"
					screen_loc = "30:2,BOTTOM"//screen_loc = "29:3,BOTTOM"
					MouseEntered(location,control,params)
						src.overlays -= /obj/hud/buttons/main/button_mouseover
						src.overlays += /obj/hud/buttons/main/button_mouseover
						if(usr.info_box1)
							usr.client.screen += usr.info_box1
							usr.client.screen += usr.info_box2
							usr.client.screen += usr.info_box3
							usr.info_box(src,src.name,params)
					MouseExited(location,control,params)
						src.overlays = null
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseMove(location,control,params)
						..()
						usr.info_box(src,"Skills",params)
					Click()
						if(usr.started == 0) return
						if(usr.open_skills)
							//winshow(usr,"skills",0)
							usr.client.screen -= usr.hud_skills
							usr.open_skills = 0
							usr.open_menus.Remove(".open_skills")
						else
							//winshow(usr,"skills",1)
							usr.hud_skills.skills()
							usr.client.screen += usr.hud_skills
							usr.open_skills = 1
							usr.open_menus.Add(".open_skills")
						winset(usr,"map.map","focus=true")
				button_build
					icon = 'hud_buttons_new.dmi'
					icon_state = "build"
					screen_loc = "29:3,BOTTOM"//screen_loc = "28:4,BOTTOM"
					MouseEntered(location,control,params)
						src.overlays -= /obj/hud/buttons/main/button_mouseover
						src.overlays += /obj/hud/buttons/main/button_mouseover
						if(usr.info_box1)
							usr.client.screen += usr.info_box1
							usr.client.screen += usr.info_box2
							usr.client.screen += usr.info_box3
							usr.info_box(src,src.name,params)
					MouseExited(location,control,params)
						src.overlays = null
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseMove(location,control,params)
						..()
						usr.info_box(src,"Construction",params)
					Click()
						//var/enable_build
						//return
						if(usr.started == 0) return
						if(usr.open_build)
							winshow(usr,"build_open",0)
							usr.open_build = 0
							if(usr.hud_build) usr.client.screen -= usr.hud_build
							usr.open_menus.Remove(".open_build")
						else
							//winshow(usr,"build_open",1)
							usr.open_build = 1
							if(usr.hud_build) usr.client.screen += usr.hud_build
							//usr.build_menu()
							usr.open_menus.Add(".open_build")
						winset(usr,"map.map","focus=true")
				button_tech
					icon = 'hud_buttons_new.dmi'
					icon_state = "tech"
					screen_loc = "28:4,BOTTOM"//screen_loc = "27:5,BOTTOM"
					MouseEntered(location,control,params)
						src.overlays -= /obj/hud/buttons/main/button_mouseover
						src.overlays += /obj/hud/buttons/main/button_mouseover
						if(usr.info_box1)
							usr.client.screen += usr.info_box1
							usr.client.screen += usr.info_box2
							usr.client.screen += usr.info_box3
							usr.info_box(src,src.name,params)
					MouseExited(location,control,params)
						src.overlays = null
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseMove(location,control,params)
						..()
						usr.info_box(src,"Technology",params)
					Click()
						if(usr.open_tech)
							//winshow(usr,"tech_panes",0)
							if(usr.hud_tech) usr.client.screen -= usr.hud_tech
							usr.open_tech = 0
							usr.open_menus.Remove(".open_tech")
							if(usr.build_mouse)
								usr.client.images -= usr.build_mouse
								del(usr.build_mouse)
							usr.build_tech = null
						else
							//winshow(usr,"tech_panes",1)
							//usr.hud_tech.ClearTechEntriesFull()
							if(usr.hud_tech) usr.client.screen += usr.hud_tech
							usr.open_tech = 1
							usr.open_menus.Add(".open_tech")
						winset(usr,"map.map","focus=true")
				button_admin
					icon = 'hudadmin.dmi'
					icon_state = ""
					screen_loc = "1,9:19"
				//	screen_loc = "26:6,1"
					MouseEntered(location,control,params)
						src.overlays -= /obj/hud/buttons/main/button_mouseover2
						src.overlays += /obj/hud/buttons/main/button_mouseover2
						if(usr.info_box1)
							usr.client.screen += usr.info_box1
							usr.client.screen += usr.info_box2
							usr.client.screen += usr.info_box3
							usr.info_box(src,src.name,params)
					MouseExited(location,control,params)
						src.overlays = null
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseMove(location,control,params)
						..()
						usr.info_box(src,"Admin Panel",params)
					Click()
						if(usr.started == 0) return
						if(usr.key in StaffTeam)
							if(usr.client.admin_mode_set!=1)
								switch(alert("Welcome to the Admin Team, you'll need to set up your anon profile before you can access any perms. Be mindful that this setup is permanent for your key so make sure you choose your selections wisely. ","","Continue","Maybe Later"))
									if("Continue")
										usr.admin_setup()
										if(usr.client.admin_setup_done)
											usr.client.admin_mode_set = 1
											usr << "Admin profile successfully created. Please press F3 to enter Admin Mode!"
											return
									if("Maybe Later")
										return
							else
								usr.show_admin_panel()
								/*var/list/race_mobs = list()
								for(var/mob/races/R in world)
									if(R.started || R.client || R.loc)
										race_mobs += R

								if(!race_mobs.len)
									return
								switch(input(usr,"Select a command.") in list ("Cancel", "Test Delimbing overlays","Export Limb Icon(DEBUG)","Admin Chat","Announce","Assess","Ban","Boot","Bring","Create Item","Create Custom Icon Object","Delete","Edit","Edit Age","Edit Roleplay Rank","Fix Icon","Fix Screen Offset","Force Transformation","General Fix","Give Roleplay Points","Give Skill","Give Zenni","Give Accelerated Gains","Goto","Grant CFT","Grant RPPs","Heal","Heal(Everything)","Kill","Knockout","Increase Stats","Increase HTT","Mute","Observe","Planet Teleport","Prison","Reboot","Remove Item","Remove Limb","Remove Rank","Remove Skill","Rename","Revive","Set Rank","Shutdown","Toggle Global OOC","View RP Spy"))
									if("Delete")
										var/mob/m = usr
										m.set_alert("Select something to delete",'alert.dmi',"alert")
										m<<"<b>ADMIN:</b> Select something to delete"
										m.left_click_function = "delete stuff"
									if("Grant RPPs")
										var/mob/choice = input("Select a player:") as null|mob in players
										var/amount = input ("How much RPPs are you giving them [choice]?") as num
										if(amount<=1) return
										choice.roleplay_points += amount
										choice<<"You were given [amount] RPPs from the admins for good roleplay!"
										return
									if("Edit Roleplay Rank")
										var/mob/choice = input("Select a player:") as null|mob in players
										var/amount = input ("What rank are you making them?\n\n1: Rank F\n2: Rank E\n3: Rank D\n4: Rank C\n5: Rank B\n6: Rank A\n7: Rank S") as num
										choice.give_roleplayrank(amount)
										choice<<"Your RP Rank was adjusted by admins!"
										return
									if("Test Delimbing overlays")
										var/mob/m = usr
										var/limb = input("Which Limb are u testing to delimb.") in list ("Head","Torso","Right Arm","Right Leg","Left Arm","Left Leg")
										apply_limb_mask_by_age(m, limb)
										m << "[limb] visually removed (render mask active"
									/*	var/icon/base = new(usr.icon, "")  // your body icon
										var/icon/mask = new('leftarm_adult.dmi')            // the white mask you showed

										// Convert white areas to transparent (so we can use it as a deletion map)
										mask.MapColors("#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF")  // normalize whites
										mask.MapColors("#FFFFFF", null)  // make white fully transparent

										// Invert that mask (so transparent becomes opaque)
										//mask.Negate()

										// Apply it: this removes any overlapping pixels
										//base.Blend(mask, ICON_AND)
										base.Blend(mask, ICON_SUBTRACT)

										// now base is your full body icon with that limb “cut out” visually
										var/tmpfile = browse_rsc(base, "result.dmi")
										usr << tmpfile
										usr<<"Blended and exported, CHECK!"
										var/f = file("limb_exports/result_1.dmi")
										f << base
										usr.icon = base
										usr<< "Icon applied!"*/

										//usr.overlays += image('leftarm_adult.dmi', layer=MOB_LAYER+1)
										//usr<<"Left arm hidden (allegedlly)."

									if("Export Limb Icon(DEBUG)")
										var/mob/choice = input("Select a player:") as null|obj|mob in players
										var/limb = input("Which Limb are u exporting.") in list ("Head","Torso","Right Arm","Right Leg","Left Arm","Left Leg")
										spawn() export_limb_icon(choice,limb)
									if("Restore Limb")
										var/mob/choice = input("Select a player:") as null|obj|mob in players
										var/option = input("Select the limb") in list("Cancel","Right Arm", "Right Leg", "Left Arm","Left Leg", "All")
										if(option == "Cancel") return

									if("Remove Limb")
										var/mob/choice = input("Select a player:") as null|obj|mob in players
										var/option = input("Select the limb") in list("Cancel","Right Arm", "Right Leg", "Left Arm","Left Leg", "All")
										if(option == "Cancel") return
										if(option == "All")
											for(var/obj/body_related/bodyparts/right_arm/limb in choice.bodyparts)
												check_maim_limb(src,limb,choice,1)

											for(var/obj/body_related/bodyparts/left_leg/limb in choice.bodyparts)
												check_maim_limb(src,limb,choice,1)
											for(var/obj/body_related/bodyparts/left_arm/limb in choice.bodyparts)
												check_maim_limb(src,limb,choice,1)
											for(var/obj/body_related/bodyparts/right_leg/limb in choice.bodyparts)
												check_maim_limb(src,limb,choice,1)
											return
										if(option == "Right Arm")
											for(var/obj/body_related/bodyparts/right_arm/limb in choice.bodyparts)
												check_maim_limb(src,limb,choice,1)
												//src<<"You tore off [choice]'s [limb]."
												//choice<<"Your Right arm was torn off."
												return
										if(option == "Left Arm")
											for(var/obj/body_related/bodyparts/left_arm/limb in choice.bodyparts)
												check_maim_limb(src,limb,choice,1)
												//src<<"You tore off [choice]'s [limb]."
												//choice<<"Your Left arm was torn off."
												return
										if(option == "Right Leg")
											for(var/obj/body_related/bodyparts/right_leg/limb in choice.bodyparts)
												check_maim_limb(src,limb,choice,1)
												//src<<"You tore off [choice]'s [limb]."
												//choice<<"Your Right leg was torn off."
												return
										if(option == "Left Leg")
											for(var/obj/body_related/bodyparts/left_leg/limb in choice.bodyparts)
												check_maim_limb(src,limb,choice,1)
												//src<<"You tore off [choice]'s [limb]."
												//choice<<"Your Left leg was torn off."
												return
									if("Create Custom Icon Object")
										var/obj/items/custom_icon_object/O = new/obj/items/custom_icon_object(usr.loc)
										usr << "Created a Custom Icon Object at your location. Right-click it while in your inventory to customize."
									if("Fix Screen Offset")
										var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
										var/option = input("Select their offset") in list("Auto", "Zero", "Custom","Client Custom")
										if(option == "Auto")
											choice.client.custom_view = 32
										if(option == "Zero")
											choice.client.custom_view = 0
										if(option == "Custom")
											var/newoption = input("Type your offset(eg. -32, 32, -16, 16)") as num
											choice.client.custom_view = newoption
										if(option == "Client Custom")
											var/clientx = input("Type the 'x' of the client view") as num
											var/clienty = input("Type the 'y' of the client view") as num
											var/pixelxoff = input("Type the 'pixel_x' number") as num
											var/pixelyoff = input("Type the 'pixel_y' number") as num
											switch(alert(usr,"Their client view will be '[clientx]x[clienty]' and their pixel offsets will be: px: [pixelxoff] py: [pixelyoff], do you confirm?","","Yes","Cancel"))
												if("Yes")
													choice.client.view = "[clientx]x[clienty]"
													choice.pixel_y = pixelyoff
													choice.pixel_x = pixelxoff
													choice<<"Your view was changed to [clientx]x[clienty] by an admin."
													return


										choice.client.setMap(choice.client) // Re-apply view
										choice<<"Your view was changed to [option] by an admin."
									if("Increase HTT")
										var/mob/choice = input("Select a player:") as null|obj|mob in players
										var/selection = input("Select a variable:") in list ("Cancel","Hunger","Thirst","Tiredness")
										switch(selection)
											if("Hunger")
												var/amount = input ("How much are you increasing their hunger by?") as num
												if(amount<=1) return
												choice.hunger += amount
												world<<output("<font color=yellow>(Admin Log): [usr] increased [choice] Hunger by [amount]!","rpspy.output2")
											if("Thirst")
												var/amount = input ("How much are you increasing their thirst by?") as num
												if(amount<=1) return
												choice.thirst += amount
												world<<output("<font color=yellow>(Admin Log): [usr] increased [choice] Thirst by [amount]!","rpspy.output2")
											if("Tiredness")
												var/amount = input ("How much are you increasing their tiredness by?") as num
												if(amount<=1) return
												choice.restedness += amount
												world<<output("<font color=yellow>(Admin Log): [usr] increased [choice] Tiredness by [amount]!","rpspy.output2")

									if("Edit Age")
										var/mob/choice = input("Select a player:") as null|obj|mob in players
										var/age = input ("Physical age?") as num
										var/soul = input ("Soul Age?") as num
										choice.age = age
										choice.age_soul = soul
										choice<<"Your age was changed by an admin."
										choice.update_body_age()
										choice.beard_checker()
										return
									if("Admin Chat")
										if(!usr.service_lvl)
											usr << "Only administrators may use this command."
											return
										var/msg=input("Admin Chat:") as text
										if(msg=="")
											return
										else
											for(var/mob/M in players)
												if(M.service_lvl)
													M << "<font size = 2><b><font color=#CB0739>(AdminChat)[usr.key]([usr.client.admin_name]):<font color=white>[msg]</font>"
													//M<<output("<font size = 2><b><font color=#CB0739>(AdminChat)[src.key]:<font color=white>[msg]</font>","actionoutput")
									if("View RP Spy")
										if(!usr.admin_spying)
											winset(usr,"rpspy","is-visible=true")
											usr.admin_spying=1
											return
										winset(usr,"rpspy","is-visible=false")
										usr.admin_spying=0
									if("Toggle Global OOC")
										if(global.ooc_on)
											world<<"<b>Global OOC: <font color=red>OFF</font></b>"
											global.ooc_on =0
										else
											world<<"<b>Global OOC: <font color=green>ON</font></b>"
											global.ooc_on=1
									if("Give Accelerated Gains")
										var/mob/choice = input("Select a player:") as null|mob in players
										var/amount = input ("How much accelerated gains are you giving them [choice]?") as num
										if(amount<=1) return
										choice.offline_gains += amount
										if(!choice.hud_accelerator)
											var/obj/hud/menus/accelerated_gains_txt/acceleration = new
											choice.hud_accelerator = acceleration
										choice.hud_accelerator.accelerator = choice
										choice.client.screen += choice.hud_accelerator
										world<<output("<font color=yellow>(Admin Log): [usr] gave [choice] [amount] acceleated gains","rpspy.output2")
									if("Give Zenni")
										var/mob/choice = input("Select a player:") as null|obj|mob in players
										var/amount = input ("How much are zenni are you giving them [choice]?") as num
										if(amount<=1) return
										choice.resources += amount
										choice.refresh_inv()
										world<<output("<font color=yellow>(Admin Log): [usr] gave [choice] [amount] Zenni","rpspy.output2")

									if("Add/Remove Tester")
										switch(input("Add or Remove a tester:") in list ("Add","Remove"))
											if("Add")
												var/testkey = input ("Type in the EXACT BYOND key:") as text
												if(!testkey || testkey == "") return
												Testers += testkey
												var/savefile/S = new("saves/Testers.sav")
												S["Testers"] << Testers
												usr<<"<b>[testkey] was added to the Testers List.</b>"
											if("Remove")
												var/mob/choice = input("Select a player:") as text|anything|obj in Testers
												var/xnm = "[choice.key]"
												Testers -= xnm
												var/savefile/S = new("saves/Testers.sav")
												S["Testers"] << Testers
									if("Ban")
										var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
										if(choice)
											usr.RunTimedBan(choice)
									if("Unban")
										usr.RunTimedUnban()



									if("Fix Icon")
										var/mob/choice = input("Select a player:") as null|obj|mob in players
										switch(alert(usr,"Are you sure you wish to fix [choice] icon?","","Yes","No"))
											if("Yes")
												choice.update_looks()
												choice.update_icon()
												usr<<"[choice] looks were updated!"
												choice<<"Your looks were updated(fixed)!"
									if("Create Item")
										var/typepath = input(
											usr,
											"Select an item to create:",
											"Admin Item Creation"
										) as null|anything in ALL_ITEM_TYPES

										if(!typepath)
											return

										var/obj/items/I = new typepath(usr.loc)

										// Optional polish
										I.alpha = 0
										I.pixel_z = 32
										I.level = usr.intxp
										I.tech_lvl = usr.intxp

										animate(
											I,
											alpha = 255,
											pixel_z = initial(I.pixel_z),
											time = 2,
											easing = BOUNCE_EASING
										)

										world.log << "(Admin Log): [usr.key] created [I]</font>"
										view(15,usr)<< output("([usr.client.admin_name]): Created [I]","actionoutput")


									/*if("Create Item")
										var/obj/o = input("Select an item to create:") as null|obj in items
										var/obj/item = new o.type(usr.loc)
										item.weight = o.weight
										item.alpha = 100
										item.pixel_z = 32
										item.level = usr.intxp
										item.tech_lvl = usr.intxp
										animate(item, pixel_z = initial(item.pixel_z), alpha = 255,time = 2, easing = BOUNCE_EASING)
									//	spawn(1)
										//	if(item) item.set_shadow()
										world<<output("<font color=yellow>(Admin Log): [usr] created an [item]","rpspy.output2")
										*/

									if("Rename")
										var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
										var/newname = input("What will be their new name?") as text
										switch(alert(usr,"Are you sure you wish rename [choice] to [newname]?","","Yes","No"))
											if("Yes")
												world.log << "(Admin Log):[choice] name was changed to [newname] by [usr.client.admin_name]"

												choice.fullname = newname
												choice.name = newname
												choice.real_name = newname

									if("Revive")
										var/mob/choice = input("Select a player:") as null|obj|mob in players
										switch(alert(usr,"Are you sure you wish to revive [choice]?","","Yes","No"))
											if("Yes")
												if(choice.dead)
													choice.Revive()
													choice.percent_health= 100
													choice.energy = choice.energy_max
													choice.thirst = 99
													choice.hunger = 99
													choice.toxicity = 0
													choice.restedness = 99
													choice.stunned = 0
													choice.stunned_pending = 0
													choice.moved=0
													choice.disable_skills()
													choice.check_glow_planes()
													/*for(var/obj/body_related/p in choice.hurt_limbs)
														if(p.disabled_perma == 0)
															p.hp = p.hp_max
															if(p.hp!= 100) p.hp = 100
															p.set_part_color()
															if(choice.hud_body) choice.hud_body.color_paperdoll(choice)
														//	if(src.hud_paperdoll) src.hud_paperdoll.color_paperdoll(src)
															if(p.damaged)
																choice.damage_part(p, 0)
																	//If its a bone, find all the parts connected to it and enable them also.
																if(p.bodypart_type == "Bone" && choice.has_body)
																	var/list/extensions = list()
																	for(var/obj/body_related/x in p.loc)
																		if(x.part_hierarchy < p.part_hierarchy)
																			extensions += x
																	choice.disable_parts(extensions,0,0)
															choice.hurt_limbs -= p*/
													world.log << "(Admin Log):[usr.client.admin_name] revived [choice]"


									if("Heal(Everything)")
										var/mob/choice = input("Select a player:") as null|obj|mob in players
										if(choice.koed||choice.koed==1||choice.icon_state=="KO")
											choice.KO(0,1)
										sleep(1)
										choice.percent_health= 100
										choice.energy = choice.energy_max
										choice.thirst = 99
										choice.hunger = 99
										choice.toxicity = 0
										choice.restedness = 99
										choice.stunned = 0
										choice.stunned_pending = 0
										for(var/obj/body_related/p in choice.hurt_limbs)
											if(p.disabled_perma == 0)
												p.hp = p.hp_max
												if(p.hp!= 100) p.hp = 100
												p.set_part_color()
												if(choice.hud_body) choice.hud_body.color_paperdoll(choice)
											//	if(src.hud_paperdoll) src.hud_paperdoll.color_paperdoll(src)
												if(p.damaged)
													choice.damage_part(p, 0)
														//If its a bone, find all the parts connected to it and enable them also.
													if(p.bodypart_type == "Bone" && choice.has_body)
														var/list/extensions = list()
														for(var/obj/body_related/x in p.loc)
															if(x.part_hierarchy < p.part_hierarchy)
																extensions += x
														choice.disable_parts(extensions,0,0)
												choice.hurt_limbs -= p
										world.log << "(Admin Log): [usr.client.admin_name] healed everything of [choice]"

									if("Goto")
										var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
										usr.projection.loc=locate(choice.x,choice.y+1,choice.z)
										//view(choice,5)<<output("An admin appeared!","actionoutput")
										usr.check_glow_planes()
										world.log << "(Admin Log): [usr.client.admin_name] used Goto on [choice]."

									if("Bring")
										var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
										choice.loc=locate(usr.projection.x,usr.projection.y-1,usr.projection.z)
										//choice<<output("An admin summoned you!","actionoutput")
										choice.check_glow_planes()
										world.log << "(Admin Log): [usr.client.admin_name] used Bring on [choice]."
									if("Give Roleplay Points")
										var/mob/choice = input("Select a player:") as null|obj|mob in players
										var/howmuch = input("How much roleplay points are you giving them?") as num
										if(howmuch)
											choice.roleplay_points += howmuch
										world.log << "(Admin Log): [usr.client.admin_name] gave [choice] [howmuch] Roleplay Points!"

									if("Grant CFT")
										var/mob/choice = input("Select a player:") as null|obj|mob in players
										switch(alert(usr,"[choice] currently has [choice.cycle_free_time] minutes of CFT, are you granting them CFT?(This will give them an extra 27 minutes.)","","Yes","No"))
											if("Yes")
												choice.cycle_free_time += 27
												choice.check_cft()
												world.log << "(Admin Log): [usr.client.admin_name] gave [choice] Cycle Free time!"
												//choice.client.screen += choice.hud_cft

									if("Increase Stats")
										var/mob/choice = input("Select a player:") as null|obj|mob in players
										switch(input("Which Stat to Increase:") in list ("Passive Points","Stance Points","Personal Growth","Rating", "Intelligence","Magic", "Energy", "Power Level", "Strength","Endurance", "Speed", "Force", "Resistance", "Offence", "Defence", "Recovery", "Regeneration", "Gravity"))
											if("Personal Growth")
												var/amount = input ("How much are you increasing by?(Becareful, these are mod levels(0.1-5.0+ prefered)") as num
												choice.PG += amount
												world.log << "(Admin Log): [usr.client.admin_name] increased [choice] PG by [amount]"
											if("Rating")
												var/amount = input ("How much are you increasing by?") as num
												choice.rating += amount
												world.log << "(Admin Log): [usr.client.admin_name] increased [choice] Ratings by [amount]"

											if("Power Level")
												var/amount = input ("How much are you increasing by?") as num
												choice.psionic_power_base += amount
												world.log << "(Admin Log): [usr.client.admin_name] [usr] increased [choice] PL by [amount]"

											if("Strength")
												var/amount = input ("How much are you increasing by?") as num
												choice.strength += amount
												world.log << "(Admin Log): [usr.client.admin_name] [usr] increased [choice] Strength by [amount]"

											if("Endurance")
												var/amount = input ("How much are you increasing by?") as num
												choice.endurance += amount
												world.log << "(Admin Log): [usr.client.admin_name] [usr] increased [choice] Endurance by [amount]"

											if("Energy")
												var/amount = input ("How much are you increasing by?") as num
												choice.gains_trained_energy += amount
												world.log << "(Admin Log): [usr.client.admin_name] [usr] increased [choice] Energy by [amount]"


											if("Recovery")
												var/amount = input ("How much are you increasing by?(Becareful, these are mod levels(0.1-5.0+ prefered)") as num
												choice.mod_recovery += amount
												world.log << "(Admin Log): [usr.client.admin_name] [usr] increased [choice] Recovery by [amount]"

											if("Regeneration")
												var/amount = input ("How much are you increasing by?(Becareful, these are mod levels(0.1-5.0+ prefered)") as num
												choice.mod_regeneration += amount
												world.log << "(Admin Log): [usr.client.admin_name] [usr] increased [choice] Regeneration by [amount]"

											if("Gravity")
												var/amount = input ("How much are you increasing by?") as num
												choice.gravity_mastered += amount
												world.log << "(Admin Log): [usr.client.admin_name] [usr] increased [choice] Gravity by [amount]"

											if("Speed")
												var/amount = input ("How much are you increasing by?(Becareful, these are mod levels(0.1-5.0+ prefered)") as num
												choice.mod_agility += amount
												world.log << "(Admin Log): [usr.client.admin_name] [usr] increased [choice] Speed by [amount]"

											if("Force")
												var/amount = input ("How much are you increasing by?") as num
												choice.force += amount
												world.log << "(Admin Log): [usr.client.admin_name] [usr] increased [choice] Force by [amount]"

											if("Resistance")
												var/amount = input ("How much are you increasing by?") as num
												choice.resistance += amount
												world.log << "(Admin Log): [usr.client.admin_name] [usr] increased [choice] Resistance by [amount]"

											if("Offence")
												var/amount = input ("How much are you increasing by?") as num
												choice.offence += amount
												world.log << "(Admin Log): [usr.client.admin_name] [usr] increased [choice] Offence by [amount]"

											if("Defence")
												var/amount = input ("How much are you increasing by?") as num
												choice.defence += amount
												world.log << "(Admin Log): [usr.client.admin_name] [usr] increased [choice] Defence by [amount]"
											if("Passive Points")
												var/amount = input ("How much are you increasing by?") as num
												choice.passive_points += amount
												world.log << "(Admin Log): [usr.client.admin_name] [usr] increased [choice] PPs by [amount]"
											if("Stance Points")
												var/amount = input ("How much are you increasing by?") as num
												choice.stance_points += amount
												world.log << "(Admin Log): [usr.client.admin_name] [usr] increased [choice] SPs by [amount]"
											if("Intelligence")
												var/amount = input ("How much are you increasing by?") as num
												choice.intxp += amount
												world.log << "(Admin Log): [usr.client.admin_name] [usr] increased [choice] QP% by [amount]"

											if("Magic")
												var/amount = input ("How much are you increasing by?") as num
												choice.magicxp += amount
												world.log << "(Admin Log): [usr.client.admin_name] [usr] increased [choice] Magic by [amount]"

									if("Test Create Android")
										switch(alert(usr,"Are you sure you wish to do this?","","Yes","No"))
											if("Yes")
												usr.create_android()
									if("Edit")
										var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
										var/D = null
										if(ismob(choice))
											D = choice.desc
											choice.desc = null
											usr.client<<link("?command=edit;target=\ref[choice];type=view;")
										if(D) if(ismob(choice))
											choice.desc = D
											world.log << "(Admin Log): [usr.client.admin_name] used Edit on [choice]"


									if("Assess")
										var/mob/choice = input("Select a player:") as null|mob in players
										//log_admin("[key_name(usr)] used assess on [M].")
										var/S = choice.bodysize
										if(S == 1)
											S = "Small"
										if(S == 2)
											S = "Medium"
										if(S == 3)
											S = "Large"
										var/A={"
										<html>
										<style type="text/css">
										<!--
										body {
										     color:#449999;
										     background-color:black;
										     font-size:12;
										 }
										table {
										     font-size:12;
										 }
										//-->
										</style>
										<body>
										[(choice)]<br>
										Current Anger: [choice.anger]%<br>
										<table cellspacing="6%" cellpadding="1%">
										<tr><td><font color=white><b>Compensation Minutes | Standing Minutes:</b></font></td><td>Comp. Gains: [choice.offline_gains] minutes | Standing Gains: [choice.standing_gains_timer] second</td></tr>
										<tr><td><font color=white><b>Current HTTG:</b></font></td><td>(H:[choice.hunger] T:[choice.thirst] T:[choice.restedness])</td></tr>
										<tr><td><font color=white><b>Resilliences:</b></font></td><td> (Training)[choice.trainres]--[choice.max_trainres]| (Meditation)[choice.medres]--[choice.max_medres]| (Sparring)[choice.sparres]/[choice.max_sparres]| (Blasting)[choice.blastres]/[choice.max_blastres]</td></tr>
										<tr><td><font color=white><b>Ratings:</b></font></td><td>[choice.rating]</td></tr>
										<tr><td><font color=white><b>Move Lv:</b></font></td><td>[choice.move_lvl] Exp:([choice.movelvl_exp]/1000)</td></tr>
										<hr>
										<tr><td><font color=white><b>Health:</b></font></td><td>[choice.hp]</td></tr>
										<hr>
										<tr><td>Race(s):</td><td>[choice.race] | [choice.recessive_race]</td></tr>
										<tr><td>Race Class:</td><td>[choice.race_class]</td></tr>
										<tr><td>Key:</td><td>[choice.key]</td></tr>
										<tr><td>Body Size:</td><td>[S]</td></tr>
										<tr><td>Age:</td><td>[choice.age] ([choice.age_soul] True Age)</td></tr>
										<tr><td>Generation:</td><td>[choice.generation_lvl]</td></tr>

										<tr><td>Body:</td><td>[choice.Body*100]% ([choice.oldage] Decline) - Prime Age: ([choice.prime]) </td></tr>
										<tr><td>Base:</td><td>[choice.psionic_power_base] ([choice.mod_psionic_power])</td></tr>
										<tr><td>Current PL:</td><td>[Commas(choice.psionic_power)]</td></tr>
										<tr><td>Lift:</td><td>[round((choice.strength+choice.endurance*4)*0.45359237)*0.01] kg ([round(choice.strength+choice.endurance*4)*0.01] lbs)</td></tr>
										<tr><td>Energy:</td><td>[choice.energy]/[round(choice.energy_max)] Mod.([choice.mod_energy])</td></tr>
										<tr><td>Strength:</td><td>[choice.strength] Mod.([choice.mod_strength]) </td></tr>
										<tr><td>Endurance:</td><td>[choice.endurance] Mod.([choice.mod_endurance])</td></tr>
										<tr><td>Speed:</td><td>x[choice.mod_agility]</td></tr>
										<tr><td>Force:</td><td>[choice.force] Mod.([choice.mod_force])</td></tr>
										<tr><td>Resistance:</td><td>[round(choice.resistance)] Mod.([choice.mod_resistance])</td></tr>
										<tr><td>Offense:</td><td>[choice.offence] Mod.([choice.mod_offence])</td></tr>
										<tr><td>Defense:</td><td>[choice.defence] Mod.([choice.mod_defence])</td></tr>
										<tr><td>Regeneration:</td><td>[choice.mod_regeneration]</td></tr>
										<tr><td>Recovery:</td><td>[choice.mod_recovery]</td></tr>
										<tr><td>Gravity:</td><td>x[round(choice.gravity_mastered)]</td></tr>
										<tr><td>Anger:</td><td>[choice.max_anger]%</td></tr>
										<tr><td>Intelligence:</td><td>([choice.intxp]%) Mod([choice.mod_tech_potential])</td></tr>
										<tr><td>Magic:</td><td>([choice.magicxp]%) Mod([choice.mod_arcane_potential])</td></tr>
										<tr><td>Energy Signature:</td><td>[choice.signature]</td></tr>
										<tr><td>PG/PG Mult: [choice.PG] - [round(choice.rating_mult)]x</td></tr>
										<tr><td>Cycle Free Time:[choice.cycle_free_time]</td></tr>
										<tr><td>Final Power Level Mod:[choice.final_powerlevel_mod]</td></tr>

										</table>"}



										A+="<br><font color=red><b><u>Mutations</b></u><br>"
										for(var/mutations/X in choice.mutations)
											A+="<font color=red>[X.info_name] - [X.info]<br>"
										usr<<"[A]"
										usr<<browse(A,"window=[(choice)];size=700x600")
										///obj/Traits/Tuffle/Super_Genius/GeniusBonus in M.contents
										world.log << "(Admin Log): [usr.client.admin_name] [usr] used ASSESS on [choice]"


									if("Boot")
										var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
										world<<"[choice] was booted."
										choice.client.images = null
										spawn(10) winset(choice, null, "command=.quit")
										choice.client.Del()
										world.log << "(Admin Log): [usr.client.admin_name] [usr] booted [choice]"


									if("Remove Rank")
										var/mob/choice = input("Select a player:") as null|mob in players
										if(choice.occupation)
											switch(alert(usr,"[choice.real_name]'s current rank is [choice.occupation], are you wishing to remove this?","","Yes","Cancel"))
												if("Yes")
													if(choice.owns_planets>=1)
														choice.occupation = "Planet Owner"
														choice.rank = 0
													else
														choice.occupation = "None"
														choice.rank = 0
													world.log << "(Admin Log): [usr.client.admin_name] [usr] removed [choice]'s rank"

									if("Set Rank")
										var/mob/choice = input("Select a player:") as null|mob in players
										switch(input(usr,"What planet is this rank for?") in list ("Earth","Namek","Vegeta","Icer","Space","Other Realm","Dark Realm","Hell"))
											if("Hell")
												switch(input("Which rank:") in list ("Demon Lord","Vice Demon Lord","Academy Master"))
													if("Demon Lord")
														choice.occupation = "Demon Lord"
														choice.rank = 4


													if("Vice Demon Lord")
														choice.occupation = "Vice Demon Lord"
														choice.rank = 3


													if("Academy Master")
														choice.occupation = "Acad. Master"
														choice.rank = 2
											if("Dark Realm")
												switch(input("Which rank:") in list ("Supreme Demon Lord","Vice Supreme Demon Lord","Academy Master"))
													if("Supreme Demon Lord")
														choice.occupation = "Spr.DemonLord"
														choice.rank = 4


													if("Vice Supreme Demon Lord")
														choice.occupation = "V.Spr.DemonLord"
														choice.rank = 3


													if("Academy Master")
														choice.occupation = "Acad. Master"
														choice.rank = 2
											if("Other Realm")
												switch(input("Which rank:") in list ("Supreme Kaioshin","North Kai","South Kai","East Kai","West Kai","Checkpoint Guardian"))
													if("Supreme Kaioshin")
														choice.occupation = "Supreme Kai"
														choice.rank = 4

													if("North Kai")
														choice.occupation = "North Kai"
														choice.rank = 4

													if("South Kai")
														choice.occupation = "South Kai"
														choice.rank = 4

													if("East Kai")
														choice.occupation = "East Kai"
														choice.rank = 4

													if("West Kai")
														choice.occupation = "West Kai"
														choice.rank = 4

													if("Checkpoint Guardian")
														choice.occupation = "Chpnt. Guardian"
														choice.rank = 3

											if("Space")
												switch(input("Which rank:") in list ("Space Pirate","Yardrat Master"))
													if("Space Pirate")
														choice.occupation = "Space Pirate"
														choice.rank = 3


													if("Yardrat Master")
														choice.occupation = "Yrdrt Master"
														choice.rank = 3


											if("Earth")
												switch(input("Which rank:") in list ("Earth Guardian","Crane Hermit","Turtle Hermit","Red Ribbon Army Leader","Academy Master"))
													if("Earth Guardian")
														choice.occupation = "Guardian"
														choice.rank = 4
														global.hbtc_time = 270
														choice<<output("The Hyperbolical Time Chamber has calmed down.","actionoutput")


													if("Crane Hermit")
														choice.occupation = "Hermit(C)"
														choice.rank = 4


													if("Turtle Hermit")
														choice.occupation = "Hermit(T)"
														choice.rank = 4


													if("Red Ribbon Army Leader")
														choice.occupation = "R.R.Leader"
														choice.rank = 3

													if("Academy Master")
														choice.occupation = "Acad. Master"
														choice.rank = 2



											if("Namek")
												switch(input("Which rank:") in list ("Namek Elder","Academy Master"))
													if("Namek Elder")
														choice.occupation = "Elder"
														choice.rank = 4


													if("Academy Master")
														choice.occupation = "Acad. Master"
														choice.rank = 2


											if("Vegeta")
												switch(input("Which rank:") in list ("King/Queen","General","Royalty","Academy Master"))
													if("King/Queen")
														if(choice.gen == "Female") choice.occupation = "Queen"
														if(choice.gen == "Male") choice.occupation = "King"
														choice.rank = 4

													if("General")
														choice.occupation = "Saiyan General"
														choice.rank = 3


													if("Royalty")
														choice.occupation = "Royalty"
														choice.rank = 2


													if("Academy Master")
														choice.occupation = "Acad. Master"
														choice.rank = 2
											if("Icer")
												switch(input("Which rank:") in list ("Icer Lord","General","Academy Master"))
													if("Icer Lord")
														choice.occupation = "Icer Lord"
														choice.rank = 4


													if("General")
														choice.occupation = "Icer General"
														choice.rank = 3


													if("Academy Master")
														choice.occupation = "Acad. Master"
														choice.rank = 2




										choice.percent_health= 100
										choice.percent_energy = 100
										world<<output("<font color=yellow>(Admin Log): [usr] gave [choice] a rank([choice.occupation])","rpspy.output2")

									if("Change Day/Night")
										usr.client.color=list(0.2,0.05,0.05, 0.1,0.3,0.2, 0.1,0.1,0.4)
									if("Shutdown")
										switch(alert(usr,"Really Shutdown the server?","","Yes","No"))
											if("Yes")

												world<<"Shutting Down Server in 10 seconds!"
												sleep(100)
												for(var/mob/m in players)
													m.Logout()
													sleep(0.1)
												sleep(10)
												world.Del()


									if("Heal")
										var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
										if(!choice) return
										if(choice.koed==1||choice.koed||choice.icon_state=="KO")
											choice.KO(0,1)
										sleep(1)
										choice.percent_health= 100
										choice.stunned = 0
										choice.stunned_pending = 0
										choice.refresh_vital_bars(TRUE)
										world.log << "(Admin Log): [usr.client.admin_name] [usr] healed [choice]"

									if("Observe")
										var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
										usr.client.perspective = EYE_PERSPECTIVE | EDGE_PERSPECTIVE
										usr.client.eye = choice
										world.log << "(Admin Log): [usr.client.admin_name] used Observe on [choice]"



									if("Knockout")
										var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
										choice.KO()
										world.log << "(Admin Log): [usr.client.admin_name] [usr] Admin KO'd [choice]"

									if("Kill")
										var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
										if(choice.dead==0)
											choice.KO()
											sleep(2)
											choice.Death("Admin Killed")
										else
											usr.set_alert("[choice] is already dead.",'alert.dmi',"alert")
										world.log << "(Admin Log): [usr.client.admin_name] [usr] Admin Killed [choice]"

									if("Announce")
										var/announce = input("What are you announcing?") as text

										world<<"<center>[usr.client.admin_name] announces:<br>----------------<br>[announce]<br>----------------</center></br>"
										world.log << "(Admin Log): [usr.client.admin_name] used Announce: [announce]"
									if("Force Transformation")
										var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
										choice.Transformation(1,1)
										usr<<"You successfully transformed [choice]."
										world.log << "(Admin Log): [usr.client.admin_name] transformed [choice]"

									if("Planet Teleport")
										switch(input("Where are you teleporting too?") in list ("Earth","Namek","Vegeta","Icer","Other Realm","Heaven","Hell","Dark Realm","Space"))
											if("Earth")
												usr.projection.loc=locate(rand(5,480),rand(5,480),1)
											if("Namek")
												usr.projection.loc=locate(rand(5,480),rand(5,480),4)
											if("Vegeta")
												usr.projection.loc=locate(rand(5,480),rand(5,480),10)
											if("Icer")
												usr.projection.loc=locate(rand(5,480),rand(5,480),9)
											if("Other Realm")
												usr.projection.loc=locate(rand(5,480),rand(5,480),2)
											if("Heaven")
												usr.projection.loc=locate(rand(5,480),rand(5,490),11)
											if("Hell")
												usr.projection.loc=locate(rand(5,480),rand(5,480),6)
											if("Dark Realm")
												usr.projection.loc=locate(rand(5,480),rand(5,480),12)
											if("Space")
												usr.projection.loc=locate(rand(5,480),rand(5,480),16)
										usr.check_glow_planes()
										world<<output("<font color=yellow>(Admin Log): [usr.client.admin_name] used Planet Teleport","rpspy.output2")

						winset(usr,"map.map","focus=true")
						*/
				button_body
					icon = 'RPBoxes.dmi'
					icon_state = "body"
					screen_loc = "1:1,14:13"
				//	screen_loc = "26:6,1"
					MouseEntered(location,control,params)
						src.overlays -= /obj/hud/buttons/main/button_mouseover2
						src.overlays += /obj/hud/buttons/main/button_mouseover2
						if(usr.info_box1)
							usr.client.screen += usr.info_box1
							usr.client.screen += usr.info_box2
							usr.client.screen += usr.info_box3
							usr.info_box(src,src.name,params)
					MouseExited(location,control,params)
						src.overlays = null
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseMove(location,control,params)
						..()
						usr.info_box(src,"Milestones",params)
					Click()
						if(usr.started == 0) return

						if(usr.open_body)
							//winshow(usr,"body",0)
							if(usr.hud_body) usr.client.screen -= usr.hud_body
							usr.open_body = 0
							usr.open_menus.Remove(".open_body")
							usr.upgrading = null
							if(usr.skill_divine_infusion && usr.skill_divine_infusion.active == 1) call(usr.skill_divine_infusion.act)(usr,usr.skill_divine_infusion)
						else
							if(usr.hud_body) usr.client.screen += usr.hud_body
							usr.open_body = 1
							usr.open_menus.Add(".open_body")
						winset(usr,"map.map","focus=true")


				button_map
					icon = 'hud_buttons_new.dmi'
					icon_state = "map"
					//screen_loc = "26:6,1"
					screen_loc = "25:7,1"
					MouseEntered(location,control,params)
						src.overlays -= /obj/hud/buttons/main/button_mouseover
						src.overlays += /obj/hud/buttons/main/button_mouseover
						if(usr.info_box1)
							usr.client.screen += usr.info_box1
							usr.client.screen += usr.info_box2
							usr.client.screen += usr.info_box3
							usr.info_box(src,src.name,params)
					MouseExited(location,control,params)
						src.overlays = null
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseMove(location,control,params)
						..()
						usr.info_box(src,"Map",params)
					Click()
						if(usr.started == 0) return
						if(usr.open_map)
							usr.map_proc(1)
							if(usr.skill_teleport && usr.skill_teleport.active) call(usr.skill_teleport.act)(usr,usr.skill_teleport)
							if(usr.skill_remote_viewing && usr.skill_remote_viewing.active && usr.client.eye == usr) call(usr.skill_remote_viewing.act)(usr,usr.skill_remote_viewing)
						else
							usr.map_proc(0)
				button_stats
					icon = 'hud_buttons_new.dmi'
					icon_state = "stats"
					screen_loc = "27:5,BOTTOM"//screen_loc = "26:6,BOTTOM"
					//screen_loc = "25:7,1"
					MouseEntered(location,control,params)
						src.overlays -= /obj/hud/buttons/main/button_mouseover
						src.overlays += /obj/hud/buttons/main/button_mouseover
						if(usr.info_box1)
							usr.client.screen += usr.info_box1
							usr.client.screen += usr.info_box2
							usr.client.screen += usr.info_box3
							usr.info_box(src,src.name,params)
					MouseExited(location,control,params)
						src.overlays = null
						if(usr.info_box1)
							usr.client.screen -= usr.info_box1
							usr.client.screen -= usr.info_box2
							usr.client.screen -= usr.info_box3
							usr.info_box3.maptext = null
					MouseMove(location,control,params)
						..()
						usr.info_box(src,"Character Info",params)
					Click()
						if(usr.started == 0) return
						if(usr.open_stats)
							//winshow(usr,"stats",0)
							usr.client.screen -= usr.hud_stats
							usr.open_stats = 0
							usr.open_menus.Remove(".open_stats")
						else
							//winshow(usr,"stats",1)
							usr.client.screen += usr.hud_stats
							usr.open_stats = 1
							usr.hud_stats.bars(usr)
							usr.hud_stats.portrait_look(usr)
							usr.open_menus.Add(".open_stats")
						winset(usr,"map.map","focus=true")
			popup_option
				maptext_x = 0;
				maptext_y = -8;
				maptext_width = 48;
				New()
					..()
					var/image/sel = image('spr_button_popup.dmi',src,"",1001)
					sel.maptext_x = src.maptext_x
					sel.maptext_y = src.maptext_y
					sel.maptext_width = src.maptext_width
					src.img_select = sel

					var/image/ov = image('spr_button_popup.dmi',src,"",1001)
					ov.maptext_x = src.maptext_x
					ov.maptext_y = src.maptext_y
					ov.maptext_width = src.maptext_width
					ov.alpha = 200
					src.img_over = ov
				proc
					follow_ref()
						if(src.ref)
							src.loc = locate(src.ref.x,src.ref.y,1)
							src.step_x = src.ref.step_x
							src.step_y = src.ref.step_y
						else
							src.loc = null
							return
						spawn(0.1)
							if(src) follow_ref()
				var
					mob/ref = null
					choice = null
				MouseEntered(location,control,params)
					if(src.ref || isturf(src.loc))
						usr.client.images -= src.img_select
						//src.img_select.alpha = 255
						usr.client.images += src.img_over
				MouseExited(location,control,params)
					if(src.ref || isturf(src.loc))
						usr.client.images -= src.img_over
						//src.img_select.alpha = 215
						usr.client.images += src.img_select
				//Del()
					//world << output("[src] was deleted","chat.world")
				Click()
					if(src.ref)
						//Psi clone options
						if(src.choice == "clone destroy")
							usr.rightclick_menu_open = null;
							for(var/obj/skills/Split_Form/c in usr)
								c.active_splits -= src.ref

							src.destroy()
							src.loc = null
							return
						if(src.choice == "clone stop")
							src.ref.target = null
							src.ref.target_follow = null
							src.ref.function = null
						if(src.choice == "clone follow")
							src.ref.target = null
							src.ref.target_follow = usr
							src.ref.function = "follow"
						if(src.choice == "clone attack")
							src.ref.function = "attack"
							usr.left_click_function = "clone attack"
							usr.left_click_ref = src.ref
							usr << output("Click a target for the attack.","chat.world")
							usr << output("Click a target for the attack.","chat.local")
							usr.client.mouse_pointer_icon = 'mouse_left_interact.dmi'
						for(var/obj/hud/buttons/popup_option/o in src.ref.options)
							o.ref = null
							o.loc = null
							o.pixel_x = 0;
							o.pixel_y = 0;
							usr.client.images -= o.img_select
							usr.client.images -= o.img_over
						usr.rightclick_menu_open = null;
		titles
			var/r = 0
			var/g = 0
			var/b = 0
			/*
			MouseEntered(location,control,params)
				src.filters = filter(type="outline", size=2, color=rgb(src.r,src.g,src.b))
			MouseExited(location,control,params)
				src.filters = null
			*/
			title
				icon = 'sovereigntitle.dmi'
				icon_state = "title"
				screen_loc = "TOP-9:-15,12"
				layer = 25
				New()
					src.filters += filter(type="outline",size=1, color=rgb(204,236,255))
					src.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=1, color=rgb(102,0,204))

					animate(src.filters[2], size = 4,offset = 2, time = 15, loop = -1)
					animate(size = 0,offset = 0, time = 15, loop = -1)
					//screen_loc = "CENTER-6,CENTER-3"
			copyright
				screen_loc = "CENTER-11:15,BOTTOM"
				maptext_width = 320
				maptext_height = 32
				New()
					src.maptext = "<span style='-dm-text-outline: 1px #000000;text-align:right'>Made in BYOND©([world.byond_version])</span>"

			version
				screen_loc = "1,BOTTOM"
				maptext_width = 320
				maptext_height = 32
				New()
					src.maptext = "<span style='-dm-text-outline: 1px #000000;text-align:left'>Patch [game_version]</span>"
			Exit
				icon = 'buttons_intro.dmi'
				icon_state = "exit"
				//screen_loc = "40,18"
				//screen_loc = "15,7"
				screen_loc = "CENTER-5,CENTER-4"
				layer = 26
				g = 255
				MouseEntered(location,control,params)
					src.filters += filter(type="outline",size=1, color=rgb(102,0,204))
					//src.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=1, color=rgb(102,0,204))
				MouseExited(location,control,params)
					src.filters = null
				New()
					var/obj/b = new
					b.icon = src.icon
					b.icon_state = "box"
					b.layer = 26
					src.underlays += b
				Click()
					winset(usr, null, "command=.quit")
					usr.Logout()
			Version_Notes
				icon = 'buttons_intro.dmi'
				icon_state = "updates"
				//screen_loc = "15,8"
				screen_loc = "CENTER-5,CENTER-3"
				layer = 26
				g = 255
				MouseEntered(location,control,params)
					src.filters += filter(type="outline",size=1, color=rgb(102,0,204))
					//src.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=1, color=rgb(102,0,204))
				MouseExited(location,control,params)
					src.filters = null
				New()
					var/obj/b = new
					b.icon = src.icon
					b.icon_state = "box"
					b.layer = 26
					src.underlays += b
				Click()
					/*
					if(usr.client) winset(usr,"login.tab_login","tabs=updates")
					if(usr.client) winset(usr,"updates.ver","text=\"Version [game_version]\"")
					if(usr.client) usr << output("[version_notes]","updates.log")
					if(usr.client) winshow(usr,"login",1)
					*/
					if(usr.hud_updates) usr.client.screen += usr.hud_updates
			Join_World
				icon = 'buttons_intro.dmi'
				icon_state = "join"
				//screen_loc = "40,18"
				//screen_loc = "15,9"
				screen_loc = "CENTER-5,CENTER-2"
				layer = 26
				g = 255
				MouseEntered(location,control,params)
					src.filters += filter(type="outline",size=1, color=rgb(102,0,204))
					//src.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=1, color=rgb(102,0,204))
				MouseExited(location,control,params)
					src.filters = null
				New()
					var/obj/b = new
					b.icon = src.icon
					b.icon_state = "box"
					b.layer = 26
					src.underlays += b
				Click()
					var/current_time = world.time
					if(current_time - usr.last_click_time < 10) // 10 = 1 second (BYOND uses 1/10th sec units)
						return
					usr.last_click_time = current_time
					winshow(usr,"loading",1)
					if(usr.hud_load) usr.client.screen += usr.hud_load
//HUD procs

mob
	proc
		change_planes(var/obj/hud/menus/menu)
		text_y(var/icon_y = 0,var/bar_height = 0,bar_limit_y = 0,var/delt_y = 0,var/function = null,var/spd = 16,var/list/obj_list,var/obj/txt_s,var/minus = 0,var/og_x = 0, var/og_y = 0,var/scroller_len = 0)

			if(function == "scrolled")
				if(delt_y > 0)
					txt_s.translated_y += spd
					txt_s.y_start += spd
				if(delt_y < 0)
					txt_s.translated_y -= spd
					txt_s.y_start -= spd
				txt_s.translated_y = clamp(txt_s.translated_y,(bar_height-(bar_height*2))+scroller_len,0)

			if(delt_y > 0)
				icon_y += spd
			if(delt_y < 0)
				icon_y -= spd
			icon_y = clamp(icon_y,0,minus)
			var/txt_scroller_y = txt_s.translated_y

			if(function == "clicked")
				txt_scroller_y = icon_y-minus
				txt_scroller_y = clamp(txt_scroller_y,(bar_height-(bar_height*2))+scroller_len,0)
				txt_s.translated_y = txt_scroller_y

			var/ratio = ((bar_limit_y + txt_scroller_y) / bar_height)
			ratio = clamp(ratio,0,1)

			var/matrix/m = matrix()
			m.Translate(0,txt_scroller_y)
			txt_s.transform = m
			txt_s.icon_y_saved = icon_y


			var/scroll_y = round(txt_s.translate_max-(txt_s.translate_max*ratio))

			for(var/obj/o in obj_list)
				var/matrix/m2 = matrix()
				m2.Translate(o.hud_x,o.hud_y+scroll_y)
				o.transform = m2
				o.shift_y = scroll_y
		text_x(var/icon_x = 0,var/bar_width = 0,bar_limit_x = 0,var/delt_y = 0,var/function = null,var/spd = 16,var/list/obj_list,var/obj/txt_s,var/minus = 0,var/og_x = 0, var/og_y = 0,var/scroller_len = 0)
			/*
			.:Notes:
			Minus seems to be where the bar starts? Also helps with limiting the range of movement.
			*/
			if(function == "scrolled")
				if(delt_y > 0)
					txt_s.translated_x += spd
					txt_s.x_start += spd
				if(delt_y < 0)
					txt_s.translated_x -= spd
					txt_s.x_start -= spd
				txt_s.translated_x = clamp(txt_s.translated_x,(bar_width-(bar_width*2))+scroller_len,0)

			if(delt_y > 0)
				icon_x += spd
			if(delt_y < 0)
				icon_x -= spd
			icon_x = clamp(icon_x,0,minus)
			var/txt_scroller_x = txt_s.translated_x

			if(function == "clicked")
				txt_scroller_x = icon_x-minus
				txt_scroller_x = clamp(txt_scroller_x,(bar_width-(bar_width*2))+scroller_len,0)
				txt_s.translated_x = txt_scroller_x

			var/ratio = ((bar_limit_x + txt_scroller_x) / bar_width)
			ratio = clamp(ratio,0,1)

			var/matrix/m = matrix()
			m.Translate(txt_scroller_x,txt_s.hud_y)
			txt_s.transform = m
			txt_s.icon_x_saved = icon_x


			var/scroll_x = round(txt_s.translate_max-(txt_s.translate_max*ratio))

			for(var/obj/o in obj_list)
				var/matrix/m2 = matrix()
				m2.Translate(o.hud_x+scroll_x,o.hud_y)
				o.transform = m2
				o.shift_x = scroll_x
		info_box(var/obj/hud/h,var/txt,var/params)
			var/L_txt = length_char(txt)
			var/wid = 300
			if(L_txt <= 30) wid = 0
			txt = "[css_outline]<font size = 1><text align=left valign=top>[txt]"
			var/L = src.client.MeasureText(txt,width=wid)
			var/x_pos = findtext(L, "x")
			var/L_x = text2num(copytext(L, 1, x_pos))
			var/L_y = text2num(copytext(L, x_pos+1, 0))

			var/obj/o1 = src.info_box1
			var/matrix/m1 = matrix()
			m1.Scale(L_x+6,L_y+6)
			m1.Translate((L_x+14)/2,L_y/2)
			o1.transform = m1
			o1.mouse_opacity = 0

			var/obj/o2 = src.info_box2
			var/matrix/m2 = matrix()
			m2.Scale(L_x+4,L_y+4)
			m2.Translate((L_x+14)/2,L_y/2)
			o2.transform = m2
			o2.mouse_opacity = 0

			var/obj/o3 = src.info_box3
			o3.maptext_width = L_x //txt_width
			o3.maptext_height = L_y //h.box_y_scale//txt_height
			//o3.maptext_x = 1
			o3.maptext = txt
			o3.mouse_opacity = 0

			src.check_mouse_loc(params)

			/*
			.:TOOLTIP SHIFT:.
				- Check to see if the thing we're mousing over is too close to one of the screen edges, in regards to the tooltip's extension from that thing.
			*/
			var/shift_x = round(L_x/32)
			var/shift_x_pix = round(L_x % 32)

			var/shift_y = round(L_y/32)
			var/shift_y_pix = round(L_y % 32)
			var/shift_ver = 18-shift_y

			var/tooltip_x = src.mouse_x
			var/tooltip_px = src.mouse_pix_x
			var/tooltip_y = src.mouse_y
			var/tooltip_py = src.mouse_pix_y
			var/tooltip_shift_x = 0
			var/tooltip_shift_y = 0
			if(istype(h, /obj/hud/buttons/main))
				var/obj/hud/buttons/main/hub_button = h
				// Keep docked hub button tooltips from sitting too low against the HUD bar.
				tooltip_shift_x = hub_button.tooltip_shift_x
				tooltip_shift_y = hub_button.tooltip_shift_y
			var/current_x = tooltip_x+shift_x
			var/current_y = tooltip_y+shift_y

			if(current_x >= 30 && current_y >= 18)
				tooltip_x = max(1, src.mouse_x-shift_x)
				tooltip_px = (src.mouse_pix_x-shift_x_pix)-8
				tooltip_y = max(1, shift_ver)
				tooltip_py = src.mouse_pix_y-shift_y_pix
			else if(current_x >= 30)
				tooltip_x = max(1, src.mouse_x-shift_x)
				tooltip_px = (src.mouse_pix_x-shift_x_pix)-8
			else if(current_y >= 18)
				tooltip_y = max(1, shift_ver)
				tooltip_py = src.mouse_pix_y-shift_y_pix
			tooltip_px += tooltip_shift_x
			tooltip_py += tooltip_shift_y

			src.mouse_screen_loc = BuildScreenLoc(tooltip_x, tooltip_px, tooltip_y, tooltip_py)

			src.info_box1.screen_loc = src.mouse_screen_loc
			src.info_box2.screen_loc = src.mouse_screen_loc
			src.info_box3.screen_loc = src.mouse_screen_loc
		set_skill_colors()
			var/txt = null
			for(var/obj/skills/s in src)
				if(txt == null) txt = "button_[s.info_name].background-color=#00FF00"
				else txt = "[txt];button_[s.info_name].background-color=#00FF00"
			winset(src,null,"[txt]")

			txt = null

			for(var/obj/traits/t in src)
				if(txt == null) txt = "button_[t.info_name].background-color=#00FF00"
				else txt = "[txt];button_[t.info_name].background-color=#00FF00"
			winset(src,null,"[txt]")

			txt = null

			for(var/obj/stances/st in src)
				if(txt == null) txt = "button_[st.info_name].background-color=#00FF00"
				else txt = "[txt];button_[st.info_name].background-color=#00FF00"
			winset(src,null,"[txt]")
		paper_doll()

			if(src.paperdoll_shown == 0)
			//	var/obj/hud/menus/limb_paperdoll/bodypart/h = new
			//	h = src.hud_paperdoll
			//,	src.client.screen += h
				src.paperdoll_shown = 1
			//	if(h.bodypart_icon && h.bodypart_icon.menu == h)
				//	var/obj/body_related/p = src.part_selected
				//	p.underlays = null
				//	if(bodypart_underlay) bodypart_underlay.icon_state = "menu"
				//	p.underlays += bodypart_underlay

			//	src.part_selected = src;
				//src.hud_paperdoll = h
			//	h.menu_create(src)
				var/obj/hud/menus/bodyparts_background/bp = new
				if(src.hud_body)
					bp = src.hud_body.body
				else
					src.hud_body = bp
					bp.loc = src
					bp.menu_create()
					for(var/obj/hud/menus/bodyparts_background/bodypart/lb in bp.body)
						src.client.screen += lb


				for(var/x in bp)
					src.client.screen +=x
					var/matrix/M = matrix()
					M.Scale(0.9,0.9)
					x:transform = M
			//	src.client.screen += bp

		title(var/delete = 0)
			if(delete == 0)
				var/obj/hud/titles/title/t = new
				//t.screen_loc = "1,1"
				src.client.screen += t

				var/obj/hud/titles/Join_World/j = new
				src.client.screen += j

				var/obj/hud/titles/Version_Notes/u = new
				src.client.screen += u

				var/obj/hud/titles/version/v = new
				src.client.screen += v

				var/obj/hud/titles/copyright/cr = new
				src.client.screen += cr

				var/obj/hud/titles/Exit/e = new
				src.client.screen += e
				//src.client.Rescale_TitleScreen()
			else
				for(var/obj/hud/titles/t in src.client.screen)
					if(t)
						src.client.screen -= t
						t.loc = null
						if(usr.race && !usr.offspring)
							usr.switch_race("Kai")
							txt.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Kais</u>\n<text align=left valign=top>[text_celestial]"
							usr.switch_race("Oni")
							txt.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Onis</u>\n<text align=left valign=top>[text_imp]"
							usr.switch_race("Saiyan")
							txt.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Saiyan</u>\n<text align=left valign=top>[text_saiyan]"
							usr.switch_race("Alien")
							txt.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Aliens</u>\n<text align=left valign=top>[text_cerebroid]"
							usr.switch_race("Namekian")
							txt.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Namekians</u>\n<text align=left valign=top>[text_yukopian]"
							usr.switch_race("Spirit Doll")
							txt.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Spirit Doll</u>\n<text align=left valign=top>[text_doll]"
							usr.switch_race("Makyo")
							txt.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Makyo</u>\n<text align=left valign=top>[text_doll]"
							usr.switch_race("Half God")
							txt.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Half God</u>\n<text align=left valign=top>[text_doll]"
							usr.switch_race("Changeling")
							txt.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Changeling</u>\n<text align=left valign=top>[text_doll]"
							usr.switch_race("Tuffle")
							txt.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>Tuffle</u>\n<text align=left valign=top>[text_doll]"

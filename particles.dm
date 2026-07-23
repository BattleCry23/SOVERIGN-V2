
particles/cloud_energy
    icon='cloudSmall.dmi'
    width = 1080 // Screen width for particle display
    height = 600 // Limited height for top screen clouds
    count = 500  // Reduced particle count to prevent flooding
    spawning = 3  // Minimal spawning rate to maintain slow appearance
    bound1 = list(-1080, -100, 0) // Bounding area at the top
    bound2 = list(1080,300, 800)  // Keep within upper screen space
    lifespan = 2000  // Longer lifespan before fading
    fade = 300  // Gradual fading over time
    position = generator("box", list(-740,-150,0), list(540,-150,50))
    gravity = list(0, 0)  // No gravity pull
    friction = 0.2  // Slight movement retention
    drift = generator("sphere", 0, 1)
    color = "white"
particles/hell_clouds
    icon='cloudSmall.dmi'
    width = 1080 // Screen width for particle display
    height = 600 // Limited height for top screen clouds
    count = 500  // Reduced particle count to prevent flooding
    spawning = 7  // Minimal spawning rate to maintain slow appearance
    bound1 = list(-1080, -100, 0) // Bounding area at the top
    bound2 = list(1080,300, 800)  // Keep within upper screen space
    lifespan = 2000  // Longer lifespan before fading
    fade = 300  // Gradual fading over time
    position = generator("box", list(-740,-150,0), list(540,-150,50))
    gravity = list(0, 0)  // No gravity pull
    friction = 0.2  // Slight movement retention
    drift = generator("sphere", 0, 1)
    color = "#B24319"


particles/dark_realm_clouds
    icon='cloudSmall.dmi'
    width = 1080 // Screen width for particle display
    height = 600 // Limited height for top screen clouds
    count = 500  // Reduced particle count to prevent flooding
    spawning = 7  // Minimal spawning rate to maintain slow appearance
    bound1 = list(-1080, -100, 0) // Bounding area at the top
    bound2 = list(1080,300, 800)  // Keep within upper screen space
    lifespan = 2000  // Longer lifespan before fading
    fade = 300  // Gradual fading over time
    position = generator("box", list(-740,-150,0), list(540,-150,50))
    gravity = list(0, 0)  // No gravity pull
    friction = 0.2  // Slight movement retention
    drift = generator("sphere", 0, 1)
    color = "#DDAEB5"
particles/afterlife_cloud
    icon='cloudSmall.dmi'
    width = 1080 // Screen width for particle display
    height = 600 // Limited height for top screen clouds
    count = 500  // Reduced particle count to prevent flooding
    spawning = 7  // Minimal spawning rate to maintain slow appearance
    bound1 = list(-1080, -100, 0) // Bounding area at the top
    bound2 = list(1080,300, 800)  // Keep within upper screen space
    lifespan = 2000  // Longer lifespan before fading
    fade = 300  // Gradual fading over time
    position = generator("box", list(-740,-150,0), list(540,-150,50))
    gravity = list(0, 0)  // No gravity pull
    friction = 0.2  // Slight movement retention
    drift = generator("sphere", 0, 1)
    color = "#F1D268"

particles/gravity_energy
    icon='gravStrain.dmi'
    width = 1080 // Screen width for particle display
    height = 600 // Limited height for top screen clouds
    count = 500  // Reduced particle count to prevent flooding
    spawning = 3  // Minimal spawning rate to maintain slow appearance
    bound1 = list(-1080, -100, 0) // Bounding area at the top
    bound2 = list(1080,300, 800)  // Keep within upper screen space
    lifespan = 300  // Longer lifespan before fading
    fade = 150  // Gradual fading over time
    position = generator("box", list(-740,-150,0), list(540,-150,50))
    gravity = list(0, 0)  // No gravity pull
    friction = 0.1  // Slight movement retention
    drift = generator("sphere", 0, 1)
    color = "black"

particles/world_tree_spores
    width = 2600
    height = 2000
    count = 2200    // 4000 particles
    spawning = 1    // 1 new particles per client tick
    bound1 = list(-1000, -2000, -1000)   // end particles at Y=-300
    bound2 = list(1000, 2000, 1000)   // end particles at Y=300
    lifespan = 1200  // last 600 client ticks max
    fade = 100       // fade out over the last 50 ticks if still on screen
    // spawn within a certain x,y,z space
    position = generator("box", list(-1000,0,0), list(1000,0,50))
    gravity = list(0, -0.33)
    friction = 0.4  // shed 20% of velocity and drift every client tick
    drift = generator("sphere", 0, 2)
    color = "white"

particles/divine_flecks
    width = 96
    height = 96
    count = 32    // 4000 particles
    spawning = 1    // 1 new particles per client tick
    bound1 = list(-48, -48, -10)   // end particles at Y=-300
    bound2 = list(48, 48, 10)   // end particles at Y=300
    lifespan = 600  // last 600 client ticks max
    fade = 50       // fade out over the last 50 ticks if still on screen
    // spawn within a certain x,y,z space
    position = generator("box", list(-48,-16,0), list(96,-16,50))
    gravity = list(0, 2)
    friction = 0.2  // shed 20% of velocity and drift every client tick
    drift = generator("sphere", 0, 2)
    color = "white"

particles/celestial_flecks
    width = 96
    height = 96
    count = 32    // 4000 particles
    spawning = 1    // 1 new particles per client tick
    bound1 = list(-48, -48, -10)   // end particles at Y=-300
    bound2 = list(48, 48, 10)   // end particles at Y=300
    lifespan = 600  // last 600 client ticks max
    fade = 50       // fade out over the last 50 ticks if still on screen
    // spawn within a certain x,y,z space
    position = generator("box", list(-48,-16,0), list(96,-16,50))
    gravity = list(0, 2)
    friction = 0.2  // shed 20% of velocity and drift every client tick
    drift = generator("sphere", 0, 2)
    color = "white"

particles/eye_flecks
    width = 8
    height = 16
    count = 32    // 4000 particles
    spawning = 1    // 1 new particles per client tick
    bound1 = list(-24, -24, -10)   // end particles at Y=-300
    bound2 = list(32, 32, 10)   // end particles at Y=300
    lifespan = 600  // last 600 client ticks max
    fade = 50       // fade out over the last 50 ticks if still on screen
    // spawn within a certain x,y,z space
    position = generator("box", list(8,-2,0), list(14,-2,50))
    gravity = list(0, 0.5)
    color = "white"

particles/dark_flecks
    width = 96
    height = 96
    count = 32    // 4000 particles
    spawning = 1    // 1 new particles per client tick
    bound1 = list(-24, -24, -10)   // end particles at Y=-300
    bound2 = list(24, 32, 10)   // end particles at Y=300
    lifespan = 600  // last 600 client ticks max
    fade = 50       // fade out over the last 50 ticks if still on screen
    // spawn within a certain x,y,z space
    position = generator("box", list(-24,-5,0), list(24,-5,50))
    gravity = list(0, 2)
    friction = 0.2  // shed 20% of velocity and drift every client tick
    drift = generator("sphere", 0, 2)
    color = "white"

particles/divine_flecks_weapon
    width = 64
    height = 128
    count = 15
    spawning = 0.5    // 1 new particles per client tick
    bound1 = list(-12, 2, -10)   // end particles at Y=-300
    bound2 = list(12, 60, 10)   // end particles at Y=300
    lifespan = 25  // last 600 client ticks max
    fade = 25       // fade out over the last 50 ticks if still on screen
    fadein = 5
    // spawn within a certain x,y,z space
    position = generator("box", list(-12,2,0), list(12,2,10))
    gravity = list(0, 1)
    friction = 0.2  // shed 20% of velocity and drift every client tick
    drift = generator("sphere", 0, 1)
    color = "white"

obj/effects/industrial_smoke
	invisibility = 1
	particles = new/particles/smoke
	pixel_x = 32
	pixel_y = 36
	layer = 10
	vis_flags = VIS_INHERIT_PLANE
obj/effects/SuperDrill_Dig
	icon = 'New_Drill_dig.dmi'
	pixel_y = -16
	appearance_flags = KEEP_APART
	layer = 10
	vis_flags = VIS_INHERIT_PLANE
obj/effects/HandDrill_Dig
	icon = 'mining_hand_drill_dig.dmi'
	pixel_y = -16
	appearance_flags = KEEP_APART
	layer = 10
	vis_flags = VIS_INHERIT_PLANE
obj/effects/Shovel_Dig
	icon = 'mining_shovel_dig.dmi'
	pixel_y = -16
	appearance_flags = KEEP_APART
	layer = 10
	vis_flags = VIS_INHERIT_PLANE
obj/effects/digging
	particles = new/particles/dust
	appearance_flags = KEEP_APART
	layer = 10
	vis_flags = VIS_INHERIT_PLANE
obj/effects/digging_ash
	particles = new/particles/dig_ash
	appearance_flags = KEEP_APART
	layer = 10
	vis_flags = VIS_INHERIT_PLANE
obj/effects/digging_snow
	particles = new/particles/dig_snow
	appearance_flags = KEEP_APART
	layer = 10
	vis_flags = VIS_INHERIT_PLANE

obj/effects/weapon_energy
	particles = new/particles/divine_flecks_weapon
	appearance_flags = KEEP_APART
	vis_flags = VIS_INHERIT_PLANE
	New()
		src.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
		//src.filters += filter(type="outline",size=1, color=rgb(204,236,255))
		src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(204,236,255))
obj/effects/soul_energy
	//particles = new/particles/soul_stream
	plane = 1;
	mouse_opacity = 0;
	vis_flags = VIS_INHERIT_PLANE
	/*
	New()
		src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(102,0,204))
		src.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
	*/
obj/effects/Space_Pod_Aura
	pixel_x = 16
	pixel_y = 16
	layer=34
	alpha=165
	icon = 'pod_aura.dmi'
	filters = filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(102,0,204))
//	filters = filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
	mouse_opacity=0
	//vis_flags = VIS_INHERIT_PLANE
	New()
		..()
		src.filters = filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(102,0,204))
	//	src.filters = filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
		var/randomcolor = rgb(rand(1,999),rand(1,999),rand(1,999))
		color = randomcolor
		var/matrix/M = matrix()
		M.Scale(2,2)
		animate(src,transform = M,time = 1)
obj/effects/Space_Ship_Aura
	pixel_x = 16
	pixel_y = 16
	layer=34
	alpha=165
	icon = 'pod_aura.dmi'
	filters = filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(102,0,204))
//	filters = filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
	mouse_opacity=0
	//vis_flags = VIS_INHERIT_PLANE
	New()
		..()
		src.filters = filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(102,0,204))
	//	src.filters = filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
		var/randomcolor = rgb(rand(1,999),rand(1,999),rand(1,999))
		color = randomcolor
		var/matrix/M = matrix()
		M.Scale(5,5)
		animate(src,transform = M,time = 1)
obj/effects/dark_realm_clouds
	screen_loc = "CENTER"
	particles = new/particles/dark_realm_clouds
	filters = filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(102,0,204))
	plane = -2;
	mouse_opacity = 0;
	invisibility = 1
	vis_flags = VIS_INHERIT_PLANE

obj/effects/hell_clouds
	screen_loc = "CENTER"
	particles = new/particles/hell_clouds
	filters = filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(102,0,204))
	plane = -2;
	mouse_opacity = 0;
	invisibility = 1
	vis_flags = VIS_INHERIT_PLANE
obj/effects/afterlife_energy
	screen_loc = "CENTER"
//	particles = new/particles/afterlife_energy
	filters = filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(102,0,204))
	plane = -2;
	mouse_opacity = 0;
	invisibility = 1
	vis_flags = VIS_INHERIT_PLANE
	//layer = 0.1
	//pixel_x = 596
	//pixel_y = 300

obj/effects/cloud_energy
    screen_loc = "CENTER"
    particles = new/particles/cloud_energy
    //icon = 'clouds.dmi'  // Set cloud sprite instead of blank dots
    filters = filter(type="bloom", threshold=rgb(255,255,255), size=2, offset=0, alpha=120)
    plane = -2
    mouse_opacity = 0
    invisibility = 1
    vis_flags = VIS_INHERIT_PLANE

    New()
        spawn(0)
            var/matrix/m = matrix()
            m.Scale(rand(1.9,2), rand(2.9,2.1)) // Random slight size variations
            particles.transform = m
            animate(src, pixel_x=rand(-25,25), loop=-1, time=200, easing=3) // Slow side-to-side drifting
            animate(alpha=0, time=2000, easing=0) // Gradual fade-out
obj/effects/afterlife_cloud
    screen_loc = "CENTER"
    particles = new/particles/afterlife_cloud
    //icon = 'clouds.dmi'  // Set cloud sprite instead of blank dots
    filters = filter(type="bloom", threshold=rgb(241,210,104), size=2, offset=0, alpha=120)
    plane = 35
    mouse_opacity = 0
    invisibility = 1
    vis_flags = VIS_INHERIT_PLANE

    New()
        spawn(0)
            var/matrix/m = matrix()
            m.Scale(rand(1.9,2), rand(2.9,2.1)) // Random slight size variations
            particles.transform = m
            animate(src, pixel_x=rand(-25,25), loop=-1, time=200, easing=3) // Slow side-to-side drifting
            animate(alpha=0, time=2000, easing=0) // Gradual fade-out

obj/effects/gravity_energy
	screen_loc = "CENTER"
	particles = new/particles/gravity_energy
	filters = filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(231,231,231))
	plane = 34;
	mouse_opacity = 0;
	invisibility = 1
	vis_flags = VIS_INHERIT_PLANE
obj/effects/space_energy
	screen_loc = "CENTER"
//	particles = new/particles/space_energy
	filters = filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(231,231,231))
	plane = -2;
	mouse_opacity = 0;
	invisibility = 1
	vis_flags = VIS_INHERIT_PLANE
	//layer = 0.1
	//pixel_x = 596
	//pixel_y = 300
obj/effects/divine_energy
    screen_loc = "CENTER"
    particles = new/particles/divine_flecks
    filters = filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(255,255,170))
    mouse_opacity = 0;
    appearance_flags = KEEP_APART
    vis_flags = VIS_INHERIT_PLANE


obj/effects/dark_matter_energy
    screen_loc = "CENTER"
    particles = new/particles/dark_flecks
    filters = filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(102,0,204))
    mouse_opacity = 0;
    layer = 10
    vis_flags = VIS_INHERIT_PLANE

obj/effects/celestial_energy
    screen_loc = "CENTER"
    particles = new/particles/celestial_flecks
    //filters = filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(102,204,170))
    mouse_opacity = 0;
    vis_flags = VIS_INHERIT_PLANE


obj/effects/Smoke1
	var/Smokes
	icon = 'smoke.dmi'
	icon_state = "1"
	can_pocket = 0
	bolted = 1
	layer = MOB_LAYER+100
	plane=34
	glide_size=32
	pixel_x = 16
	pixel_y = 16
	New()
		sleep(4)
		icon_state = "[rand(1,3)]"
		animate(src, transform = matrix()*1.5)
		animate(src, transform = matrix()*3.5, alpha = 0, time = 60)
		var/I = pick(1,2,3)
		src.icon_state = "[I]"
		src.Smoke()
		spawn(rand(20,25)) if(src) { src.destory ; src.loc=null }
	proc/Smoke()
		set waitfor = FALSE
		if(src)
			src.dir = pick(NORTH,SOUTH,EAST,WEST,SOUTHWEST,SOUTHEAST,NORTHWEST,NORTHEAST)
			step_rand(src)
			sleep(5)
			src.Smoke()
mob
	proc
		crash_landing(var/impact=0)
			spawn(1)
				var/obj/effects/craters/crater2_big/crater2 = null
				var/obj/effects/craters/crater2_small/crater1 = null
				src.apply_space_glow(0)
				// Impact 1: Crashing without a pod
				if(impact == 1)

					switch(rand(1,2))
						if(1)

							animate(src, pixel_z = rand(190,197), time = 2) // Initial drop
							animate(transform = turn(matrix(), 8), time = 4) // Small spin effect
							animate(pixel_z = 30, time = 10) // Mid-fall
							animate(transform = turn(matrix(), -8), time = 4) // Counter spin

							animate(pixel_z = 10, time = 2)  // First impact // Bounce before stopping
							animate(pixel_z = 5, time = 2)   // Small rebound
							animate(transform = turn(matrix(), 0), time = 4)
							animate(pixel_z = 2, time = 5)   // Minor rebound
							animate(pixel_z = 0, time = 2)   // Settling down
							sleep(25)
							src<<sound('earthquake.ogg', 25, 1) // Sound effect for the crash
							crater1 = new/obj/effects/craters/crater2_small(src.loc)

							crater1.alpha = 0
							animate(crater1, alpha = 255, time = 10) // Crater fade-in effect
							animate(crater1, icon_state = "cracks", time = 3)
							src.KO()
							crater1.icon_state = "cracks"
							sleep(10)
							src<<sound(null)
							return
						if(2)
							src.can_move = 0
							animate(src, pixel_z = rand(190,197), transform = turn(matrix(), 8), time = 1) // Initial drop
							animate(transform = turn(matrix(), 4), time = 2) // Small spin effect
							animate(transform = turn(matrix(), -8), time = 2)
							animate(pixel_z = 0, time = 3) // Mid-fall
							animate(transform = turn(matrix(), 0), time = 2)
							sleep(10)
							src<<sound('earthquake.ogg', 25, 1) // Sound effect for the crash
							crater1 = new/obj/effects/craters/crater2_small(src.loc)
							crater1.alpha = 0
							animate(crater1, alpha = 255, time = 5) // Crater fade-in effect
							animate(crater1, icon_state = "cracks", time = 3)
							src.KO()
							crater1.icon_state = "cracks"
							sleep(5)
							src<<sound(null)
							return
				// Impact 2: Crashing with a space pod
				else if(impact == 2)
					src.can_move = 0
					src.Pod.density = 1
					animate(src.Pod, pixel_z = rand(190,197), time = 1) // Higher drop for pod
					animate(transform = turn(matrix(), 20), time = 6)
					animate(pixel_z = 0, time = 10)
					animate(transform = turn(matrix(), 0), time = 6)
					sleep(10)
					src<<sound('earthquake.ogg', 25, 0)
					src<<sound('earthquakeshort.ogg', 15, 0) // Sound effect for the crash
					crater2= new/obj/effects/craters/crater2_big(src.Pod.loc)
					crater2.alpha = 0
					animate(crater2, alpha = 255, time = 5) // Crater fade-in effect
					animate(crater2, icon_state = "cracks", time = 3)
					crater2.icon_state = "cracks"
					sleep(10)
					src<<sound(null)
					src.can_move=1
					return
				// Impact 3: Crashing with a Ship
				else if(impact == 3)
					src.can_move = 0
					src.Ship.density = 1
					animate(src.Ship, pixel_z = rand(190,197), time = 1) // Higher drop for pod
					animate(transform = turn(matrix(), 20), time = 6)
					animate(pixel_z = 0, time = 10)
					animate(transform = turn(matrix(), 0), time = 6)
					sleep(10)
					src<<sound('earthquake.ogg', 25, 0)
					src<<sound('earthquakeshort.ogg', 15, 0) // Sound effect for the crash
					crater2= new/obj/effects/craters/crater2_big(src.Ship.loc)
					crater2.alpha = 0
					animate(crater2, alpha = 255, time = 5) // Crater fade-in effect
					animate(crater2, icon_state = "cracks", time = 3)
					crater2.icon_state = "cracks"
					sleep(10)
					src<<sound(null)
					src.can_move=1
					return
		/*slow_afterlife_glow()
			if(src && src.client && src.afterlife_effect)
				for(var/obj/effects/afterlife_energy/ae in world)
					src.client.screen -= ae
					world.log << "DEBUG - found [ae] in world"
				for(var/obj/effects/afterlife_energy/ae in src.client.screen)
					src.client.screen -= ae
					world.log << "DEBUG - found [ae] in players screen and removed it"
				src.afterlife_effect.particles.gravity = list(0,0.33)
				src.afterlife_effect.particles.spawning = 2
				world.log << "DEBUG - slowed particles"*/
		apply_hell_glow(var/add,var/time = 6)
			if(src.client)
				if(src.hell_effect == null) src.hell_effect = new/obj/effects/hell_clouds
				if(add)
					for(var/obj/effects/hell_clouds/ae in src.client.screen)
						src.client.screen -= ae
					src.client.screen += src.hell_effect
					src.client.screen -= hell_background
					src.client.screen += hell_background
				//	if(src.z == 16) src << sound('wind.mp3',1,0,8,40)
					spawn(time)
						if(src && src.client)
							src.hell_effect.particles.gravity = list(0,0.13)
							src.hell_effect.particles.spawning = 1
				else
					for(var/obj/effects/hell_clouds/ae in src.client.screen)
						src.client.screen -= ae
					//src.afterlife_effect.particles.gravity = list(0,100)
					//src.afterlife_effect.particles.spawning = 600
					src.client.screen -= hell_effect
					src << sound(null,channel = 8)
					src << sound(null,channel = 5)
		apply_demonrealm_glow(var/add,var/time = 6)

			if(src.client)
				if(src.drealm_effect == null) src.drealm_effect = new/obj/effects/dark_realm_clouds
				if(add)
					for(var/obj/effects/dark_realm_clouds/ae in src.client.screen)
						src.client.screen -= ae
					src.client.screen += src.drealm_effect
					src.client.screen -= drealm_background
					src.client.screen += drealm_background
				//	if(src.z == 16) src << sound('wind.mp3',1,0,8,40)
					spawn(time)
						if(src && src.client)
							src.drealm_effect.particles.gravity = list(0,0.13)
							src.drealm_effect.particles.spawning = 1
				else
					for(var/obj/effects/dark_realm_clouds/ae in src.client.screen)
						src.client.screen -= ae
					//src.afterlife_effect.particles.gravity = list(0,100)
					//src.afterlife_effect.particles.spawning = 600
					src.client.screen -= drealm_effect
					src << sound(null,channel = 8)
					src << sound(null,channel = 5)
		apply_afterlife_glow(var/add,var/time = 6)


			if(src.client)
				if(src.afterlife_effect == null) src.afterlife_effect = new/obj/effects/afterlife_cloud
				if(add)
					for(var/obj/effects/afterlife_cloud/ae in src.client.screen)
						src.client.screen -= ae
					src.client.screen += src.afterlife_effect
					src.client.screen -= afterlife_background
					src.client.screen += afterlife_background
				//	if(src.z == 16) src << sound('wind.mp3',1,0,8,40)
					spawn(time)
						if(src && src.client)
							src.afterlife_effect.particles.gravity = list(0,0.13)
							src.afterlife_effect.particles.spawning = 1
				else
					for(var/obj/effects/afterlife_cloud/ae in src.client.screen)
						src.client.screen -= ae
					//src.afterlife_effect.particles.gravity = list(0,100)
					//src.afterlife_effect.particles.spawning = 600
					src.client.screen -= afterlife_effect
					src << sound(null,channel = 8)
					src << sound(null,channel = 5)
		apply_loginnight_glow(var/add,var/time = 6)

			if(src.client)
				if(src.login2_effect == null) src.login2_effect = new/obj/effects/cloud_energy
				if(add)
					for(var/obj/effects/cloud_energy/ae in src.client.screen)
						src.client.screen -= ae
					src.client.screen += src.login2_effect
					src.client.screen -= login2_background
					src.client.screen += login2_background
				//	if(src.z == 16) src << sound('wind.mp3',1,0,8,40)
					spawn(time)
						if(src && src.client)
							if(src.space_effect && src.space_effect.particles)
								src.space_effect.particles.gravity = list(0,0.13)
								src.space_effect.particles.spawning = 1
				else
					for(var/obj/effects/cloud_energy/ae in src.client.screen)
						src.client.screen -= ae
					//src.afterlife_effect.particles.gravity = list(0,100)
					//src.afterlife_effect.particles.spawning = 600
					src.client.screen -= login2_background
					src << sound(null,channel = 8)
					src << sound(null,channel = 5)
		apply_korintower_glow(var/add,var/time = 6)

			if(src.client)
				if(add)
					for(var/obj/effects/cloud_energy/ae in src.client.screen)
						src.client.screen -= ae
					src.client.screen -= korintower_background
					src.client.screen += korintower_background
				//	if(src.z == 16) src << sound('wind.mp3',1,0,8,40)
				else

					for(var/obj/effects/cloud_energy/ae in src.client.screen)
						src.client.screen -= ae
					//src.afterlife_effect.particles.gravity = list(0,100)
					//src.afterlife_effect.particles.spawning = 600
					src.client.screen -= korintower_background
					src << sound(null,channel = 8)
					src << sound(null,channel = 5)
		apply_hbtc_glow(var/add,var/time = 6)

			if(src.client)
				if(add)
					for(var/obj/effects/cloud_energy/ae in src.client.screen)
						src.client.screen -= ae
					src.client.screen -= hbtc_background
					src.client.screen += hbtc_background
				//	if(src.z == 16) src << sound('wind.mp3',1,0,8,40)
				else

					for(var/obj/effects/cloud_energy/ae in src.client.screen)
						src.client.screen -= ae
					//src.afterlife_effect.particles.gravity = list(0,100)
					//src.afterlife_effect.particles.spawning = 600
					src.client.screen -= hbtc_background
					src << sound(null,channel = 8)
					src << sound(null,channel = 5)
		apply_loginday_glow(var/add,var/time = 6)
			if(src.client)
				if(src.login_effect == null) src.login_effect = new/obj/effects/cloud_energy
				if(add)
					for(var/obj/effects/cloud_energy/ae in src.client.screen)
						src.client.screen -= ae
					src.client.screen += src.login_effect
					src.client.screen -= login_background
					src.client.screen += login_background
				//	if(src.z == 16) src << sound('wind.mp3',1,0,8,40)
					spawn(time)
						if(src && src.client)
							if(src.login_effect && src.login_effect.particles)
								src.login_effect.particles.gravity = list(0,0.13)
								src.login_effect.particles.spawning = 1
				else
					for(var/obj/effects/cloud_energy/ae in src.client.screen)
						src.client.screen -= ae
					//src.afterlife_effect.particles.gravity = list(0,100)
					//src.afterlife_effect.particles.spawning = 600
					src.client.screen -= login_background
					src << sound(null,channel = 8)
					src << sound(null,channel = 5)
		strain(var/gravity)
			var/alpha = 10
			if (gravity > 10)
				alpha += min(100, ((gravity - 10) / 5) ** 2 * 5) // Gradual increase, capped at 125
			return round(alpha)

		apply_gravity_glow(var/add,var/gravity,var/time = 6)

			if(src.client)
				if(src.grav_effect == null) src.grav_effect = new/obj/effects/gravity_energy
				if(src.gravity_overlay == null) src.gravity_overlay = new/obj/hud/gravityoverlay
				if(src.gravity_overlay)
					src.client.screen -= gravity_overlay
					src.gravity_overlay = null
					src.gravity_overlay = new/obj/hud/gravityoverlay
				if(add && gravity)
					for(var/obj/effects/gravity_energy/ae in src.client.screen)
						src.client.screen -= ae
					src.gravity_overlay.alpha = strain(gravity)
					src.client.screen += src.grav_effect

					src.client.screen += gravity_overlay
				//	if(src.z == 16) src << sound('wind.mp3',1,0,8,40)
					spawn(time)
						if(src && src.client)
							src.grav_effect.particles.gravity = list(0,0.13)
							src.grav_effect.particles.spawning = 1
				else if(add==0||grav ==0)
					for(var/obj/effects/gravity_energy/ae in src.client.screen)
						src.client.screen -= ae
					//src.afterlife_effect.particles.gravity = list(0,100)
					//src.afterlife_effect.particles.spawning = 600
					src.client.screen -= gravity_overlay
					src << sound(null,channel = 8)
					src << sound(null,channel = 5)
		apply_space_glow(var/add,var/time = 6)
			if(src.client)
				if(src.space_effect == null) src.space_effect = new/obj/effects/space_energy
				if(add)
					//for(var/obj/effects/space_energy/ae in src.client.screen)
					//	src.client.screen -= ae
					src.client.screen += src.space_effect
					src.client.screen -= psi_realm_background
					src.client.screen += psi_realm_background
				//	if(src.z == 16) src << sound('wind.mp3',1,0,8,40)
					//spawn(time)
					//	if(src && src.client)
						//	src.space_effect.particles.gravity = list(0,0.13)
						///	src.space_effect.particles.spawning = 1
				else
					//for(var/obj/effects/space_energy/ae in src.client.screen)
					//	src.client.screen -= ae
					//src.afterlife_effect.particles.gravity = list(0,100)
					//src.afterlife_effect.particles.spawning = 600
					src.client.screen -= psi_realm_background
					src << sound(null,channel = 8)
					src << sound(null,channel = 5)
		/*apply_afterlife_glow(var/add,var/time = 6)
			if(src.client)
				if(src.afterlife_effect == null) src.afterlife_effect = new/obj/effects/afterlife_energy
				if(add)
					for(var/obj/effects/afterlife_energy/ae in src.client.screen)
						src.client.screen -= ae
					src.client.screen += src.afterlife_effect
					src.client.screen -= psi_realm_background
					src.client.screen += psi_realm_background
					//if(src.z == 2 || src.z == 6) src << sound('wind.mp3',1,0,8,40)
					spawn(time)
						if(src && src.client)
							src.afterlife_effect.particles.gravity = list(0,0.33)
							src.afterlife_effect.particles.spawning = 2
				else
					for(var/obj/effects/afterlife_energy/ae in src.client.screen)
						src.client.screen -= ae
					//src.afterlife_effect.particles.gravity = list(0,100)
					//src.afterlife_effect.particles.spawning = 600
					src.client.screen -= psi_realm_background
					src << sound(null,channel = 8)
					src << sound(null,channel = 5)
				*/




particles/fire
	width = 500
	height = 500
	count = 3000
	spawning = 60
	lifespan = 20
	fade = 10
	position = list(0,0)
	gravity = list(0,1.5)
	friction = 0.27
	drift = generator("circle", 0, 2)
	color = "white"
particles/fizzle
	width = 64
	height = 64
	count = 5000
	spawning = 60
	lifespan = 20
	fade = 10
	position = list(0,0)
	gravity = list(0,0)
	friction = 0.2
	drift = generator("circle", 0, 2)
	color = "white"
particles/smoke
	width = 500
	height = 1200
	count = 300
	spawning = 1
	lifespan = 60
	fade = 150
	position = generator("box", list(6,8,0), list(10,8,0))
	velocity = generator("box", list(-1,10,0), list(1,10,0))
	spin = 0.25
	friction = 0
	icon = 'fx_dust.dmi'
	icon_state = list("1","2","3","4","5","6","7","8")
particles/dust
	width = 500
	height = 800
	count = 300
	spawning = 0.5
	lifespan = 30
	fade = 40
	position = generator("box", list(4,8,0), list(8,8,0))
	velocity = generator("box", list(-1,6,0), list(1,6,0))
	spin = 0.25
	friction = 0
	gravity = 0
	icon = 'fx_dust_dirt.dmi'
	icon_state = list("1","2","3","4","5","6","7","8")
particles/dig_snow
	width = 500
	height = 800
	count = 300
	spawning = 0.5
	lifespan = 30
	fade = 40
	position = generator("box", list(4,8,0), list(8,8,0))
	velocity = generator("box", list(-1,6,0), list(1,6,0))
	spin = 0.25
	friction = 0
	gravity = 0
	icon = list('fx_dust_dirt.dmi','fx_dust.dmi')
	icon_state = list("1","2","3","4","5","6","7","8")
particles/dig_ash
	width = 500
	height = 800
	count = 300
	spawning = 0.5
	lifespan = 30
	fade = 40
	position = generator("box", list(4,8,0), list(8,8,0))
	velocity = generator("box", list(-1,6,0), list(1,6,0))
	spin = 0.25
	friction = 0
	gravity = 0
	icon = 'fx_ash.dmi'
	icon_state = list("1","2","3","4","5","6","7","8")
particles/fire_particles
	width = 1000
	height = 1000
	count = 100
	lifespan = 3
	fade = 2
	spawning = 100
	position = 0
	velocity = generator("circle",-70,70)
	icon = 'fx_dust_explosive.dmi'
	icon_state = list("1","2","3","4","5","6","7","8")
particles/fire_particles_small
	width = 1000
	height = 1000
	count = 50
	lifespan = 3
	fade = 2
	spawning = 50
	position = 0
	velocity = generator("circle",-70,70)
	icon = 'fx_dust_explosive.dmi'
	icon_state = list("1","2","3","4","5","6","7","8")
particles/explosion_dust_dirt
	width = 1000
	height = 1000
	count = 150
	lifespan = 10
	fade = 5
	spawning = 150
	position = 0
	velocity = generator("circle",-75,75)
	icon = 'fx_dust_dirt.dmi'
	icon_state = list("1","2","3","4","5","6","7","8")
particles/explosion_dust_dirt_small
	width = 1000
	height = 1000
	count = 75
	lifespan = 10
	fade = 5
	spawning = 75
	position = 0
	velocity = generator("circle",-30,30)
	icon = 'fx_dust_dirt.dmi'
	icon_state = list("1","2","3","4","5","6","7","8")
particles/explosion_dust_snow
	width = 1000
	height = 1000
	count = 150
	lifespan = 10
	fade = 5
	spawning = 150
	position = 0
	velocity = generator("circle",-75,75)
	icon = list('fx_dust.dmi','fx_dust_dirt.dmi')
	icon_state = list("1","2","3","4","5","6","7","8")
particles/explosion_ash
	width = 1000
	height = 1000
	count = 150
	lifespan = 10
	fade = 5
	spawning = 150
	position = 0
	velocity = generator("circle",-75,75)
	icon = 'fx_ash.dmi'
	icon_state = list("1","2","3","4","5","6","7","8")
particles/explosion_dust_snow_small
	width = 1000
	height = 1000
	count = 75
	lifespan = 10
	fade = 5
	spawning = 75
	position = 0
	velocity = generator("circle",-75,75)
	icon = list('fx_dust.dmi','fx_dust_dirt.dmi')
	icon_state = list("1","2","3","4","5","6","7","8")
particles/rain
	width = 1000
	height = 500
	count = 5500
	spawning = 15
	bound1 = list(-1000, -300, -1000)
	lifespan = 600
	fade = 50
	position = generator("box", list(-300,250,0), list(300,300,100))
	gravity = list(-4.3,-9.7)
	friction = 0.1
	drift = generator("vector", 0, 2)
	color = "#afc3cc"
/*
I use the following filters in conjunction with the fire particles on my fireball emitter. It makes a nice realistic fire effect.
 filters = list(filter(type = "blur", size = 2),
  filter(type = "outline", size = 1, color = "yellow"),
   filter(type = "outline", size = 1, color = "#FFA500"),
    filter(type = "outline", size = 1, color = "red"),
     filter(type = "bloom", rgb(0,0,0), size = 4, offset = 2, alpha = 255))
*/

turf
	/*
	Water overlay notes
	- Make the water edges overlays
	- Have the overlay drawn on the same plane as liquid, so it's animated
	- Make sure the overlay is offset by the correct pixel_x/pixel_y
	- For example, water tile detects beach south, creates overlay and sets its pixel_y = -32
	*/
	MouseEntered()
		usr.mouse_inside = src
		if(usr.mouse_over_visual) usr.mouse_over_visual.loc = src
		if(usr.toggled_info)
			usr.show_info(src)
		if(usr.hud_info) usr.hud_info.maptext = "<span style='-dm-text-outline: 1px #000000;text-align:right'>[src]</span>"
	MouseExited()
		if(usr.toggled_info)
			if(usr.mouse_over_tooltip && usr.client) usr.client.images -= usr.mouse_over_tooltip
			if(usr.mouse_over_visual && usr.client) usr.client.images -= usr.mouse_over_visual
	void
		icon = 'terrain.dmi'
		//icon_state = "lava cooling"
		icon_state = "blank darkness"
		alpha = 0;
		liquid = "psionic"
		fragile = 0
		tmp_dmg = -1
		layer = 1

	lava_cooling
		icon = 'terrain.dmi'
		icon_state = "lava cooling"
		tmp_dmg = 1
		//plane = 3
		layer = 2
	lava_cooled
		icon = 'terrain.dmi'
		icon_state = "lava cooled"
		//plane = 3
		layer = 2
	lava
		icon = 'terrain.dmi'
		icon_state = "lava"
		//plane = 3
		layer = 2
		tmp_dmg = 2
	lava_static
		icon = 'terrain.dmi'
		icon_state = "lava static"
		liquid = "lava"
		//plane = -1
		layer = 2
		tmp_dmg = 2
		fragile = 0
		//alpha = 0
	unpassable_solid_opaque
		fragile = 0
		icon = 'terrain.dmi'
		icon_state = "cross"
		density = 1
		density_factor = 2
		hp = 9999999
		immune_dmg = 1
		opacity = 1
		New()
			src.icon_state = "blank darkness"
	unpassable
		fragile = 0
		icon = 'terrain.dmi'
		icon_state = "cross"
		density = 1
		density_factor = 2
		hp = 9999999
		immune_dmg = 1
		//opacity = 1
		New()
			src.icon_state = "blank darkness"
	blank
		fragile = 0
		icon = 'terrain.dmi'
		icon_state = "blank"
	white
		fragile = 0
		icon = 'terrain.dmi'
		icon_state = "white"
	dirt_test
		icon = 'dirt_test.dmi'
		icon_state = "8"
		Click()
			var/turf/x = new /turf/grass_test (src)
			for(var/turf/grass_test/t in range(1,x))
				t.icon_state = "[\
					(get_step(t,NORTH)?.type == t.type ? 1 : 0) + \
					(get_step(t,SOUTH)?.type == t.type ? 2 : 0) + \
					(get_step(t,EAST)?.type == t.type ? 4 : 0) + \
					(get_step(t,WEST)?.type == t.type ? 8 : 0) + \
					(get_step(t,NORTHEAST)?.type == t.type ? 16 : 0) + \
					(get_step(t,NORTHWEST)?.type == t.type ? 32 : 0) + \
					(get_step(t,SOUTHEAST)?.type == t.type ? 64 : 0) + \
					(get_step(t,SOUTHWEST)?.type == t.type ? 128 : 0)]"
	grass_test
		icon = 'grass_test.dmi'
		icon_state = "255"
		New()
			spawn()
				src.icon_state = "[\
					(get_step(src,NORTH)?.type == src.type ? 1 : 0) + \
					(get_step(src,SOUTH)?.type == src.type ? 2 : 0) + \
					(get_step(src,EAST)?.type == src.type ? 4 : 0) + \
					(get_step(src,WEST)?.type == src.type ? 8 : 0) + \
					(get_step(src,NORTHEAST)?.type == src.type ? 16 : 0) + \
					(get_step(src,NORTHWEST)?.type == src.type ? 32 : 0) + \
					(get_step(src,SOUTHEAST)?.type == src.type ? 64 : 0) + \
					(get_step(src,SOUTHWEST)?.type == src.type ? 128 : 0)]"
	namekgrass
		icon = 'NewNamekTileset.dmi'
		icon_state="nbg1"
		weather_type = "storm"
	cracked_ground
		icon = 'tileset2.dmi'
		icon_state="crackedGround8"
	grass
		icon = 'terrain.dmi'
		icon_state = "grass"
		weather_type = "storm"

	ice
		icon = 'terrain.dmi'
		icon_state = "ice"
		weather_type = "snowstorm"

	cave_wall
		icon = 'terrain.dmi'
		icon_state = "cave wall"
		density = 1
		density_factor = 1
	stone_floor
		icon = 'terrain.dmi'
		icon_state = "cave floor"
	stone_roof
		icon = 'terrain.dmi'
		icon_state = "stone roof"
		density = 1
		density_factor = 2
		opacity = 1
	grass_crystal
		icon = 'terrain.dmi'
		icon_state = "crystal grass"
	resource_nodes
		is_node = 1
		resource_node_poor
			icon = 'terrain.dmi'
			icon_state = "stone wall"
	sowed_dirt
		icon = 'terrain.dmi'
		icon_state = "sowed dirt"
		weather_type = "storm"
	edges
		New()
			var/obj/r = new
			r.appearance = src
			r.plane = -1
			var/icon/I = new(src.icon)
			I.Flip(NORTH)
			r.icon = I
			r.icon += rgb(0,0,55)
			r.alpha = 200
			r.loc = src
		edge_grass
			icon = 'edges_grass.dmi'
			weather_type = "storm"
			New()
				for(var/turf/t in src)
					if(liquid) src.liquid = t.liquid
			e1
				icon_state = "1"
			e2
				icon_state = "2"
			e3
				icon_state = "3"
			e4
				icon_state = "4"
			e5
				icon_state = "5"
			e6
				icon_state = "6"
			e7
				icon_state = "7"
			e8
				icon_state = "8"
			e9
				icon_state = "9"
			e10
				icon_state = "10"
			e11
				icon_state = "11"
			e12
				icon_state = "12"
	dirts
		icon = 'dirt.dmi'
		weather_type = "storm"
		dirt0
		 icon_state = "0"
		dirt1
		 icon_state = "1"
		dirt2
		 icon_state = "2"
		dirt3
		 icon_state = "3"
		dirt4
		 icon_state = "4"
		dirt5
		 icon_state = "5"
		dirt6
		 icon_state = "6"
		dirt7
		 icon_state = "7"
		dirt8
		 icon_state = "8"
		dirt9
		 icon_state = "9"
		dirt10
		 icon_state = "10"
		dirt11
		 icon_state = "11"
		dirt12
		 icon_state = "12"
		dirt13
		 icon_state = "13"
		dirt14
		 icon_state = "14"

		d1
		 icon_state = "d1"
		d2
		 icon_state = "d2"
		d3
		 icon_state = "d3"
		d4
		 icon_state = "d4"
		d5
		 icon_state = "d5"
		d6
		 icon_state = "d6"
		d7
		 icon_state = "d7"
		d8
		 icon_state = "d8"
		d9
		 icon_state = "d9"
		d10
		 icon_state = "d10"
		d11
		 icon_state = "d11"
		d12
		 icon_state = "d12"
		d13
		 icon_state = "d13"
		d14
		 icon_state = "d14"
		d15
		 icon_state = "d15"
		d16
		 icon_state = "d16"
		d17
		 icon_state = "d17"
		d18
		 icon_state = "d18"
		d19
		 icon_state = "d19"
		d20
		 icon_state = "d20"
		d21
		 icon_state = "d21"
		d22
		 icon_state = "d22"
		d23
		 icon_state = "d23"
		d24
		 icon_state = "d24"
	beach_overlays
		icon = 'beach_overlays.dmi'
		plane = -1
		b1
			icon_state = "1"
		b2
			icon_state = "2"
		b3
			icon_state = "3"
		b4
			icon_state = "4"
		b5
			icon_state = "5"
		b6
			icon_state = "6"
		b7
			icon_state = "7"
		b8
			icon_state = "8"
		b9
			icon_state = "9"
		b10
			icon_state = "10"
		b11
			icon_state = "11"
		b12
			icon_state = "12"
		b13
			icon_state = "13"
		b14
			icon_state = "14"
		b15
			icon_state = "15"
			pixel_y = -32
		b16
			icon_state = "16"
		b17
			icon_state = "17"
	beach
		icon = 'beach.dmi'
		//plane = -1
		b1
			icon_state = "1"
		b2
			icon_state = "2"
		b3
			icon_state = "3"
		b4
			icon_state = "4"
		b5
			icon_state = "5"
		b6
			icon_state = "6"
		b7
			icon_state = "7"
		b8
			icon_state = "8"
		b9
			icon_state = "9"
		b10
			icon_state = "10"
		b11
			icon_state = "11"
		b12
			icon_state = "12"
		b13
			icon_state = "13"
		b14
			icon_state = "14"
		b15
			icon_state = "15"
		b16
			icon_state = "16"
	beach_deep
		icon = 'beach_deep.dmi'
		b1
			icon_state = "b1"
		b2
			icon_state = "b2"
		b3
			icon_state = "b3"
		b4
			icon_state = "b4"
		b5
			icon_state = "b5"
		b6
			icon_state = "b6"
		b7
			icon_state = "b7"
		b8
			icon_state = "b8"
		b9
			icon_state = "b9"
		b10
			icon_state = "b10"
		b11
			icon_state = "b11"
		b12
			icon_state = "b12"
		b13
			icon_state = "b13"
		b14
			icon_state = "b14"
		b15
			icon_state = "b15"
		b16
			icon_state = "b16"
		b17
			icon_state = "b17"
	sands
		icon = 'terrain.dmi'
		//weather_type = "sandstorm"
		//tmp_dmg = 1
		sand1
		 icon_state = "sand1"
		sand2
		 icon_state = "sand2"
		sand3
		 icon_state = "sand3"
		sand4
		 icon_state = "sand4"
		sand5
		 icon_state = "sand5"
		sand6
		 icon_state = "sand6"
		sand7
		 icon_state = "sand7"
		sand8
		 icon_state = "sand8"
		sand9
		 icon_state = "sand9"
	snows
		tmp_dmg = -1
		icon = 'terrain.dmi'
		weather_type = "snowstorm"
		Entered(var/mob/AZ)
			..()
			if(ismob(AZ) && AZ.npc_spawn_cd==1) return
			if(ismob(AZ) && AZ.hunting_enabled && AZ.npc_spawn_cd==0)
				AZ.npc_spawn_cd = 1  // Start the cooldown
				spawn_manager.SpawnNPCs(AZ, src)  // Trigger spawn when player enters the zone

			// Reset the cooldown after 5 seconds (adjust as needed)
				spawn(50)
					AZ.npc_spawn_cd = 0
		snow1
		 icon_state = "snow1"
		snow2
		 icon_state = "snow2"
		snow3
		 icon_state = "snow3"
		snow4
		 icon_state = "snow4"
		snow5
		 icon_state = "snow5"
		snow6
		 icon_state = "snow6"
		snow7
		 icon_state = "snow7"
		snow8
		 icon_state = "snow8"
		snow9
		 icon_state = "snow9"
	great_beyond_fabric
		icon = 'terrain.dmi'
		icon_state = "great beyond fabric"
		alpha = 100;
		plane = 3
	underwater
		icon = 'terrain.dmi'
		icon_state = "underwater"
		layer = 10000
		weather_type = "storm"
	water_transparent
		icon = 'terrain.dmi'
		transparent_water1
		 icon_state = "transparent water1"
		transparent_water2
		 icon_state = "transparent water2"
		transparent_water3
		 icon_state = "transparent water3"
		transparent_water4
		 icon_state = "transparent water4"
		transparent_water5
		 icon_state = "transparent water5"
		 liquid = "water"
		 fragile = 0
		transparent_water6
		 icon_state = "transparent water6"
		transparent_water7
		 icon_state = "transparent water7"
		transparent_water8
		 icon_state = "transparent water8"
		transparent_water9
		 icon_state = "transparent water9"
		transparent_water10
		 icon_state = "transparent water10"
		transparent_water11
		 icon_state = "transparent water11"
		transparent_water12
		 icon_state = "transparent water12"
		transparent_water13
		 icon_state = "transparent water13"
	water
		icon = 'terrain.dmi'
		weather_type = "storm"
		water1
		 icon_state = "lake1"
		water2
		 icon_state = "lake2"
		water3
		 icon_state = "lake3"
		water4
		 icon_state = "lake4"
		water5
			//vis_flags = VIS_INHERIT_PLANE
			icon_state = "lake5"
			liquid = "water"
			fragile = 0
			layer = 2
			//alpha = 0//100
			plane = 0
			/*
			New()
				src.set_area_water()
			*/
			//plane = -1
		 //plane = -1
		water_ocean
			icon_state = "lake5"
			liquid = "water"
			fragile = 0
			layer = 2
			plane = 0
		namek_water
			icon='LiquidTurfs.dmi'
			icon_state="Namekwater"
			liquid = "water"
			fragile = 0
			layer = 2
			plane = 0
		water_river
			icon_state = "lake5"
			liquid = "water"
			fragile = 0
			//plane = -1
		water_lake
		 icon_state = "lake5"
		 liquid = "water"
		 fragile = 0
		 //plane = -1
		water6
		 icon_state = "lake6"
		water7
		 icon_state = "lake7"
		water8
		 icon_state = "lake8"
		water9
		 icon_state = "lake9"
		water10
		 icon_state = "lake10"
		water11
		 icon_state = "lake11"
		water12
		 icon_state = "lake12"
		water13
		 icon_state = "lake13"
	buildables
		icon = 'terrain.dmi'
		New()
			spawn(10)
				if(src.builder == null && src.og_type == null)
					if(src.z == 3 || src.z == 6 || src.z == 7)
						src.og_type = /turf/stone_roof
						return
					src.og_type = /turf/dirts/dirt7
		floors
			stone_floor
				icon_state = "stone roof"
			cave_floor
				icon_state = "cave floor"
			Floor_01
				icon = 'floors_metal.dmi'
				icon_state = "1"
			Floor_02
				icon = 'floors_metal.dmi'
				icon_state = "2"
			Floor_03
				icon = 'floors_metal.dmi'
				icon_state = "3"
			Floor_04
				icon = 'floors_wood.dmi'
				icon_state = "1"
			Floor_05
				icon_state = "log floor"
			Floor_06
				icon_state = "tech floor"
			Floor_07
				icon = 'floors_metal.dmi'
				icon_state = "7"
		roofs
			icon = 'terrain.dmi'
			density_factor = 2
			layer = 4
			opacity = 1
			bolted = 2

			roof1
				name = "Roof"
				icon = 'tileset2.dmi'
				icon_state="roof1"
				bolted =2
				density_factor = 2
			roof2
				name = "Roof"
				icon = 'tileset2.dmi'
				icon_state="roof2"
			roof3
				name = "Roof"
				icon = 'tileset2.dmi'
				icon_state="roof3"
			roof4
				name = "Roof"
				icon = 'tileset2.dmi'
				icon_state="roof4"
			roof5
				name = "Roof"
				icon = 'tileset2.dmi'
				icon_state="roof5"
			roof6
				name = "Roof"
				icon = 'tileset2.dmi'
				icon_state="roof6"
			Brick_Roof
				icon_state = "brick roof"
			Metal_Roof
				icon_state = "tech roof"
			Wooden_Roof
				icon_state = "wood plank roof"
			Log_Roof_01
				icon_state = "log roof"
			Stone_Roof
				icon_state = "stone roof"
			Roof_01
				icon = 'roofs_metal.dmi'
				icon_state = "1"
				//opacity = 1
			Roof_02
				icon = 'roofs_metal.dmi'
				icon_state = "2"
				//opacity = 1
			Roof_03
				icon = 'roofs_metal.dmi'
				icon_state = "3"
				//opacity = 1
		walls
			icon = 'terrain.dmi'
			density_factor = 1
			//layer = 2
			techwall1
				icon = 'tileset2.dmi'
				icon_state="techwall1"
				bolted = 2
			stonewall1
				icon = 'tileset2.dmi'
				icon_state="stoneewall1"
				bolted = 2
			stonewall2
				icon = 'tileset2.dmi'
				icon_state="stoneewall2"
				bolted = 2
			stonewall3
				icon = 'tileset2.dmi'
				icon_state="stoneewall3"
				bolted = 2
			stonewall4
				icon = 'tileset2.dmi'
				icon_state="stoneewall4"
				bolted = 2
			stonewall5
				icon = 'tileset2.dmi'
				icon_state="stoneewall5"
				bolted = 2
			stonewall6
				icon = 'tileset2.dmi'
				icon_state="stoneewall6"
				bolted = 2
			Wooden_Wall_01
				icon_state = "wood plank wall"
				bolted = 2
			Wooden_Wall_02
				icon_state = "log wall"
				bolted = 2
			Stone_Wall

				icon_state = "stone wall"
				bolted = 2
			Brick_Wall
				icon_state = "brick wall"
				bolted = 2
			Wall_01
				icon_state = "tech wall"
				bolted = 2
			Wall_02
				icon = 'walls_metal.dmi'
				icon_state = "1"
				bolted = 2
			Wall_03
				icon = 'walls_metal.dmi'
				icon_state = "2"
				bolted = 2
			Wall_04
				icon = 'walls_metal.dmi'
				icon_state = "3"
				bolted = 2



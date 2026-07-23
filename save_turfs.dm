world
	proc
		Save_Map()
			set background = 1
			//world << "Saving map"
			var/map = 1
			var/n = 0
			var/current_map = list("Earth","OtherRealm","Earth Underground","Yukopia","Sionica","OtherRealm Underground","Yukopia Underground","Sionica Underground")
			var/map_num = 1
			var/savefile/mapss = new("saves/maps/[current_map[map_num]]/map[map].sav")

			//var/add_levels_here_next
			var/list/types = list()
			var/list/og_types = list()
			var/list/hps = list()
			var/list/hps_max = list()
			var/list/builders = list()
			var/list/xx = list()
			var/list/yy = list()
		//	world<<"<font color=green>Saving World..</font>"

			while(map_num < 9)
				mapss = new("saves/maps/[current_map[map_num]]/map[map].sav")
				for(var/turf/t in turfs[1][map_num])
					t.filters = null
					if(t.red > 0)
						t.icon -= rgb(t.red,0,0)
						t.red = 0
					types += t.type
					og_types += t.og_type
					xx += t.x
					yy += t.y
					hps += t.hp
					hps_max += t.hp_max
					builders += t.builder
					n += 1
					//If the map file is filled, save it now and move onto the next
					if(n >= 10000)
						map += 1
						mapss["types"] << types
						mapss["og_types"] << og_types
						mapss["xx"] << xx
						mapss["yy"] << yy
						mapss["hps"] << hps
						mapss["hps_max"] << hps_max
						mapss["builders"] << builders
						mapss = new("saves/maps/[current_map[map_num]]/map[map].sav")
						n = 0
						types = list()
						og_types = list()
						hps = list()
						hps_max = list()
						xx = list()
						yy = list()

				//Otherwise if it wasn't filled, just use/save this one
				if(n <= 9999)
					mapss["types"] << types
					mapss["og_types"] << og_types
					mapss["xx"] << xx
					mapss["yy"] << yy
					mapss["hps"] << hps
					mapss["hps_max"] << hps_max
					mapss["builders"] << builders
				map_num += 1
				types = list()
				og_types = list()
				hps = list()
				hps_max = list()
				builders = list()
				xx = list()
				yy = list()
				n = 0
				map = 1
				sleep(0.1)


		Load_Map2()
			set background = 1
			//world << ""
		//	sleep(0.1)
			//create_world_tree()
		//	world << "World Tree created..."
			sleep(0.1)
			create_water_edges()
		//	world << "Water Edges created..."
			sleep(0.1)
			create_beaches()
		//	world << "Beaches created..."
			sleep(0.1)
			create_grass_dirt_transition()
		//	world << "Grass and dirt converted..."
			sleep(0.1)
			create_plants()
		//	world << "Earth plants created..."
			create_hell_artifacts()
			sleep(0.1)
			create_hell_artifacts2()
			sleep(0.1)
			create_heaven_artifacts()
			sleep(0.1)
			create_vegeta_plants()
		//	world << "Vegeta plants created..."
			sleep(0.1)
			create_vegeta_terrains()
		//	world << "Vegeta terrains created..."
			sleep(0.1)
			create_icer_plants()
		//	world << "Icer plants created..."
			sleep(0.1)
			create_namek_plants()
		//	world << "Namek Plants created..."
			sleep(0.1)
			create_afterlife_plants()
			sleep(0.1)
			world.edges_afterlife()
		//	world << "Afterlife edges created..."
			sleep(0.1)
			world.create_dirt_sand_transition()
			//world << "Dirt and sand converted..."
			sleep(0.1)
			world.create_ash_cooled_lava_transition()
			//world << "Ash and lava converted..."
			sleep(0.1)
			world.create_lava_transition()
		//	world << "lava created..."
			sleep(0.1)
			world.create_snow_transition()
			//world << "snow created..."
			sleep(0.1)
			world.create_seeds()
			//world << "Seeds created..."
			sleep(0.1)

			create_map_new()
			world << "<font color=green><b>System Loading Completed!</font></b>"

		Load_Map()
		//	set background = 1

			if(turfs[1][1] == null)
				var/list/t_earth = list()
				turfs[1][1] = t_earth
			if(turfs[1][2] == null)
				var/list/t_psi = list()
				turfs[1][2] = t_psi
			if(turfs[1][3] == null)
				var/list/t_earth_u = list()
				turfs[1][3] = t_earth_u
			if(turfs[1][4] == null)
				var/list/t_yukopia = list()
				turfs[1][4] = t_yukopia
			if(turfs[1][10] == null)
				var/list/t_sionica = list()
				turfs[1][10] = t_sionica
			if(turfs[1][6] == null)
				var/list/t_psi_u = list()
				turfs[1][6] = t_psi_u
			if(turfs[1][7] == null)
				var/list/t_yukopia_u = list()
				turfs[1][7] = t_yukopia_u
			if(turfs[1][8] == null)
				var/list/t_sionica_u = list()
				turfs[1][8] = t_sionica_u

			var/map = 1
			var/current_map = list("Earth","OtherRealm","Earth Underground","Yukopia","Sionica","OtherRealm Underground","Yukopia Underground","Sionica Underground")
			var/map_num = 1

			while(map_num < 9)
				load
				if(map > 1)
					world << "Successfully jumped to next file."

				if(fexists("saves/maps/[current_map[map_num]]/map[map].sav"))
					world << "File found. (Map File [current_map[map_num]] [map])"

				else
					world << "No more files found. Done loading [current_map[map_num]] turfs."
					goto end

				var/savefile/F=new("saves/maps/[current_map[map_num]]/map[map].sav")
				var/list/types = F["types"]
				var/list/og_types = F["og_types"]
				var/list/xx = F["xx"]
				var/list/yy = F["yy"]
				var/list/hps = F["hps"]
				var/list/hps_max = F["hps_max"]
				var/list/builders = F["builders"]

				var/n = 0
				for(var/a in types)
					n += 1
					var/turf/t = new a(locate(xx[n],yy[n],map_num))
					t.og_type = og_types[n]
					t.hp = hps[n]
					t.hp_max = hps_max[n]
					t.builder = builders[n]
					turfs[1][map_num] += t
					sleep(0.1)


				world << "Done loading [current_map[map_num]] Map File [map]"

				map += 1
				sleep(0.1)
				goto load

				end
				map_num += 1
				map = 1
			//	if(map_num>=9) break
			world << "Creating enviornment..."
			sleep(0.1)
			//create_world_tree()
			world << "World Tree created..."
			sleep(0.1)
			world.yukopian_grass_populate()
			world << "Namek Grass population created..."
			sleep(0.1)
			create_water_edges()
			world << "Water Edges created..."
			sleep(0.1)
			create_beaches()
			world << "Beaches created..."
			sleep(0.1)
			create_grass_dirt_transition()
			world << "Grass and dirt converted..."
			sleep(0.1)
			world.create_hell_artifacts()
			sleep(0.1)
			world.create_plants()
			world << "Earth plants created..."
			sleep(0.1)
			world.create_vegeta_plants()
			world << "Vegeta plants created..."
			sleep(0.1)
			world.create_vegeta_terrains()
			world << "Vegeta terrains created..."
			sleep(0.1)
			world.create_icer_plants()
			world << "Icer plants created..."
			sleep(0.1)
			world.create_namek_plants()
			world << "Namek Plants created..."
		//	sleep(0.1)
			//world.create_seeds()
		//	world << "Seeds created..."
			sleep(0.1)
			world.edges_afterlife()
			world << "Afterlife edges created..."
			sleep(0.1)
			world.create_dirt_sand_transition()
			world << "Dirt and sand converted..."
			sleep(0.1)
			world.create_ash_cooled_lava_transition()
			world << "Ash and lava converted..."
			sleep(0.1)
			world.create_lava_transition()
			world << "lava created..."
			sleep(0.1)
			world.create_snow_transition()
			world << "snow created..."
			sleep(0.1)
			create_map_new()
			world << "Done creating enviornment"

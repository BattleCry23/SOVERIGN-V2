turf
	proc
		Autotile_World() //Supposed to be the fastest auto-tiler on byond
			for(var/turf/t in world)
				if(!t.autotile){continue}
				t.icon_state = "[initial(t.icon_state)] [\
					(get_step(t,NORTH)?.type == t.type ? 1 : 0) + \
					(get_step(t,SOUTH)?.type == t.type ? 2 : 0) + \
					(get_step(t,EAST)?.type == t.type ? 4 : 0) + \
					(get_step(t,WEST)?.type == t.type ? 8 : 0) + \
					(get_step(t,NORTHEAST)?.type == t.type ? 16 : 0) + \
					(get_step(t,NORTHWEST)?.type == t.type ? 32 : 0) + \
					(get_step(t,SOUTHEAST)?.type == t.type ? 64 : 0) + \
					(get_step(t,SOUTHWEST)?.type == t.type ? 128 : 0)]"
		worldmap_buildings(var/icon/I)
			if(istype(src,/turf/buildables/roofs/))
				I.DrawBox(rgb(63,63,63),src.x,src.y,src.x,src.y)
			else if(istype(src,/turf/buildables/walls/))
				I.DrawBox(rgb(127,127,127),src.x,src.y,src.x,src.y)
			else if(istype(src,/turf/buildables/floors/))
				I.DrawBox(rgb(191,191,191),src.x,src.y,src.x,src.y)
		create_worldmap_building()
			return
			if(maps_created)
				var/obj/hud/map/map_large/map_obj = maps[src.z]
				var/obj/map_o = map_obj.build_overlay
				if(!map_o || !map_o.icon) return
				var/icon/I_overlay = new(map_o.icon)
				map_obj.overlays -= map_o
				if(istype(src,/turf/buildables/roofs/))
					I_overlay.DrawBox(rgb(63,63,63),src.x,src.y,src.x,src.y)
				else if(istype(src,/turf/buildables/walls/))
					I_overlay.DrawBox(rgb(127,127,127),src.x,src.y,src.x,src.y)
				else if(istype(src,/turf/buildables/floors/))
					I_overlay.DrawBox(rgb(191,191,191),src.x,src.y,src.x,src.y)
				else if(istype(src,/turf/grass))
					var/icon/I = new(map_obj.icon)
					I.DrawBox(rgb(10,139,53),src.x,src.y,src.x,src.y)
					I_overlay.DrawBox(null,src.x,src.y,src.x,src.y)
					map_obj.icon = I
				else if(istype(src,/turf/dirts/))
					var/icon/I = new(map_obj.icon)
					I.DrawBox(rgb(153,102,51),src.x,src.y,src.x,src.y)
					I_overlay.DrawBox(null,src.x,src.y,src.x,src.y)
					map_obj.icon = I
				else if(istype(src,/turf/sands/))
					var/icon/I = new(map_obj.icon)
					I.DrawBox(rgb(239,199,79),src.x,src.y,src.x,src.y)
					I_overlay.DrawBox(null,src.x,src.y,src.x,src.y)
					map_obj.icon = I
				else if(istype(src,/turf/snows/))
					var/icon/I = new(map_obj.icon)
					I.DrawBox(rgb(234,234,234),src.x,src.y,src.x,src.y)
					I_overlay.DrawBox(null,src.x,src.y,src.x,src.y)
					map_obj.icon = I
				else if(istype(src,/turf/ice))
					var/icon/I = new(map_obj.icon)
					I.DrawBox(rgb(153,204,255),src.x,src.y,src.x,src.y)
					I_overlay.DrawBox(null,src.x,src.y,src.x,src.y)
					map_obj.icon = I
				map_o.icon = I_overlay
				map_obj.overlays += map_o
		remove_worldmap_building()
			if(maps_created)
				if(istype(src,/turf/buildables/))
					var/obj/hud/map/map_large/map_obj = maps[src.z]
					var/obj/map_o = map_obj.build_overlay
					if(map_o && map_o.icon)
						map_obj.overlays -= map_o
						var/icon/I = new(map_o.icon)
						I.DrawBox(null,src.x,src.y,src.x,src.y)
						map_o.icon = I
						map_obj.overlays += map_o
		storm_psionic()
			var/s = 100
			while(s)
				s -= 1
				for(var/turf/t in range(6,src))
					if(prob(2))
						var/obj/effects/lightning_bolt/b = new
						b.loc = t
				sleep(10)
		furrow_remove()
			spawn(1000)
				src.overlays = null
				src.furrowed = 0
		set_area_water()
			set background = 1
			new /area/water(src)
			//var/area/water=new(src)
		set_destroyed()
			src.vis_contents = null
			if(src.damage)
				src.damage.destroy()
				src.damage = null
			if(src.z == 3 || src.z == 6 || src.z == 7 || src.z == 8) //if(istype(src,/turf/stone_roof))
				new /turf/stone_floor (src)
				if(src.z == 3)
					if(prob(0.5))
						var/obj/items/misc/resource_cache/rsc = new
						rsc.loc = src
					else if(prob(0.1))
						var/obj/items/tech/Upgrade_Kit/muk = new
						muk.loc = src
				else if(src.z == 6)
					if(prob(0.5))
						var/obj/items/misc/resource_cache/rsc = new
						rsc.preset = 1
						rsc.icon_state = "resource cache3"
						rsc.loc = src
					else if(prob(0.5))
						var/obj/items/consumables/spirit_stone/st = new
						st.loc = src
			else
				src.icon = 'terrain.dmi'
				src.icon_state = "dirt5"
				src.density_factor = 0
				src.opacity = 0
				src.density = 0
				src.layer = 2
			if(turfs[1][src.z].Find(src) == 0) turfs[1][src.z] += src
		set_damage_glow()
			if(src.damaged) return
			else
				src.damaged = 1
				//Add a melting/warping effect to the turf being attacked by an energy attack
				if(length(src.filters) <= 0)
					var/start = src.filters.len
					var/i,f
					for(i=1, i<=WAVE_COUNT, ++i)
						src.filters += filter(type="wave", x=20, y=20, size=1, offset=1)
					for(i=1, i<=WAVE_COUNT, ++i)
						f = src.filters[start+i]
						animate(f, offset=f:offset, time=0, loop=-1, flags=ANIMATION_PARALLEL)
						animate(offset=f:offset-1, time=33)
				spawn()
					if(src.glow)
						while(src.red > 0)
							src.glow.icon -= rgb(1,0,0)
							if(prob(50)) src.glow.alpha -= 1
							src.red -= 1
							sleep(1)
						src.red = 0
						src.damaged = 0
						src.filters = null
					if(src.glow)
						src.glow.destroy()
						src.glow = null
					//world << "DEBUG - called destroy glow"

obj/Spawn_Manager
    var/list/current_npcs = list()
    var/max_npcs = 10  // Limit on total NPCs
    var/spawn_chance = 100  // Probability of spawning an NPC when triggered
    var/mob/Spawnz = list()
    proc/SpawnNPCs(mob/AZ, turf/spawn_location)
        if(current_npcs.len >= max_npcs) return  // Don’t spawn if max NPCs are reached
        if(!prob(spawn_chance)) return  // Random chance to spawn NPC

        // Pick a random NPC type to spawn
        src.Spawnz = list(/mob/NPC/Animals/Pig, /mob/NPC/Animals/Chicken, /mob/NPC/Animals/Dragon, /mob/NPC/Animals/Bat)
        var/mob/x = pick(src.Spawnz)
        var/mob/NPC/Animals/O =new

        //Set and secure the NPC Sync
        O.name = "[x.name]"
        O.icon = x.icon
        O.icon_state = x.icon_state
        O.race = x.race
        O.active = 0


        // Initialize NPC stats
        InitializeNPC(O)


        //Spawn the NPC
        O.loc = get_step(AZ,AZ.dir)
        O.dir = get_dir(O,AZ)

        //Check for Targets, then activate
        if(O.target == null && O.koed == 0)
            O.target = AZ
            spawn(5)
                O.activate()
        O.npc_ai()

        current_npcs += O
        switch(rand(1,25))
            if(2)
                max_npcs+=1
            if(22)
                max_npcs +=1

        // Notify the player
       // AZ.create_chat_entry("local","A wild [O] has appeared!",0,1)
        return
    proc/InitializeNPC(var/mob/NPC/O)
        var/scaling_factor = global.year * rand(1, 2)
        O.agressive = 1
        O.psionic_power += scaling_factor
        O.set_stats(scaling_factor,scaling_factor*2,scaling_factor,scaling_factor,scaling_factor,scaling_factor,scaling_factor,scaling_factor)
        return



turf/Spawnerz
    //layer=50
    name = ""

    var/tmp/spawn_cooldown = 0  // Cooldown for the spawn zone

    Entered(var/mob/AZ)
        ..()
        if(AZ.npc_spawn_cd==1) return
        if(ismob(AZ) && AZ.hunting_enabled && AZ.npc_spawn_cd==0)
            AZ.npc_spawn_cd = 1  // Start the cooldown
            spawn_manager.SpawnNPCs(AZ, src)  // Trigger spawn when player enters the zone

            // Reset the cooldown after 5 seconds (adjust as needed)
            spawn(50)
                AZ.npc_spawn_cd = 0




/*turf/
	var/Spawnz = list()

	Spawners
		name = ""
		Earth_3
			name=""
			Crossed(mob/AZ)
				..()
				if(!ismob(AZ)) return ..()
				if(AZ.hunting_enabled ==0) return ..()
				if(AZ.npc_spawn_cd==1)
					..()
					return
				if(AZ.hunting_enabled==0) return ..()
				Spawnz = list(/mob/NPC/Animals/Pig,/mob/NPC/Animals/Chicken,/mob/NPC/Animals/Dragon,/mob/NPC/Animals/Bat)
				if(istype(AZ,/mob))
					var/X = pick(src.Spawnz)
					var/mob/NPC/O = new X
					if(prob(O.Probability+AZ.discovery))
						if(prob(O.Probability+AZ.discovery))
							if(prob(O.Probability+AZ.discovery))
								var/i = rand(1,3)

								O.agressive = 1
								O.psionic_power+=rand(1,2)*(global.year*1.5)*i
								O.strength+=rand(1,2)*(global.year*2)*i
								O.endurance+=rand(1,2)*(global.year*2)*i
								O.resistance+=rand(1,2)*(global.year*2)*i
								O.mod_agility+=rand(2,4)*(global.year*2)*i
								O.offence=rand(2,4)*(global.year*2)*i
								O.defence=rand(1,4)*(global.year*2)*i

								O.dir=src.dir
								O.loc = src.loc
								AZ.npc_spawn_cd=1




								//O.showhpbars()
								sleep(50)
								AZ.npc_spawn_cd=0
		Earth_2
			name=""
			Crossed(mob/AZ)
				..()
				if(!ismob(AZ)) return ..()
				if(AZ.hunting_enabled ==0) return ..()
				if(AZ.npc_spawn_cd==1)
					..()
					return
				if(AZ.hunting_enabled==0) return ..()
				Spawnz = list(/mob/NPC/Animals/Sheep,/mob/NPC/Animals/Pig,/mob/NPC/Animals/Chicken,/mob/NPC/Animals/Dragon,/mob/NPC/Animals/Cow,/mob/NPC/Animals/Mammoth,/mob/NPC/Animals/Bat)
				if(istype(AZ,/mob))
					var/X = pick(src.Spawnz)
					var/mob/NPC/O = new X
					if(prob(O.Probability+AZ.discovery))
						if(prob(O.Probability+AZ.discovery))
							if(prob(O.Probability+AZ.discovery))
								var/i = rand(1,3)

								O.agressive = 1
								O.psionic_power+=rand(1,2)*(global.year*1.5)*i
								O.strength+=rand(1,2)*(global.year*2)*i
								O.endurance+=rand(1,2)*(global.year*2)*i
								O.resistance+=rand(1,2)*(global.year*2)*i
								O.mod_agility+=rand(2,4)*(global.year*2)*i
								O.offence=rand(2,4)*(global.year*2)*i
								O.defence=rand(1,4)*(global.year*2)*i

								O.dir=src.dir
								O.loc = src.loc
								AZ.npc_spawn_cd=1




								//O.showhpbars()
								sleep(50)
								AZ.npc_spawn_cd=0
		Earth_1
			name=""
			Crossed(mob/AZ)
				..()
				if(!ismob(AZ)) return ..()
				if(AZ.hunting_enabled ==0) return ..()
				if(AZ.npc_spawn_cd==1)
					..()
					return
				if(AZ.hunting_enabled==0) return ..()
				Spawnz = list(/mob/NPC/Animals/Sheep,/mob/NPC/Animals/Pig,/mob/NPC/Animals/Chicken,/mob/NPC/Animals/Dragon,/mob/NPC/Animals/Cow)
				if(istype(AZ,/mob))
					var/X = pick(src.Spawnz)
					var/mob/NPC/O = new X
					if(prob(O.Probability+AZ.discovery))
						if(prob(O.Probability+AZ.discovery))
							if(prob(O.Probability+AZ.discovery))
								var/i = rand(1,3)

								O.agressive = 1
								O.psionic_power+=rand(1,2)*(global.year*1.5)*i
								O.strength+=rand(1,2)*(global.year*2)*i
								O.endurance+=rand(1,2)*(global.year*2)*i
								O.resistance+=rand(1,2)*(global.year*2)*i
								O.mod_agility+=rand(2,4)*(global.year*2)*i
								O.offence=rand(2,4)*(global.year*2)*i
								O.defence=rand(1,4)*(global.year*2)*i

								O.dir=src.dir
								O.loc = src.loc
								AZ.npc_spawn_cd=1




								//O.showhpbars()
								sleep(50)
								AZ.npc_spawn_cd=0
		Water_1
			name=""
			Crossed(mob/AZ)
				if(!ismob(AZ)) return ..()
				if(AZ.hunting_enabled ==0) return ..()
				if(AZ.npc_spawn_cd==1)
					..()
					return
				if(AZ.hunting_enabled==0) return ..()
				Spawnz = list(/mob/NPC/Animals/Small_Fish)
				if(istype(AZ,/mob))
					var/X = pick(src.Spawnz)
					var/mob/NPC/O = new X
					if(prob(O.Probability+AZ.discovery))
						if(prob(O.Probability+AZ.discovery))
							if(prob(O.Probability+AZ.discovery))
								var/i = rand(1,3)

								O.agressive = 1
								O.psionic_power+=rand(1,2)*(global.year*1.5)*i
								O.strength+=rand(1,2)*(global.year*2)*i
								O.endurance+=rand(1,2)*(global.year*2)*i
								O.resistance+=rand(1,2)*(global.year*2)*i
								O.mod_agility+=rand(2,4)*(global.year*2)*i
								O.offence=rand(2,4)*(global.year*2)*i
								O.defence=rand(1,4)*(global.year*2)*i

								O.dir=src.dir
								O.loc = src.loc
								AZ.npc_spawn_cd=1




								//O.showhpbars()
								sleep(50)
								AZ.npc_spawn_cd=0
		Water_2
			name=""
			Crossed(mob/AZ)
				..()
				if(!ismob(AZ)) return ..()
				if(AZ.hunting_enabled ==0) return ..()
				if(AZ.npc_spawn_cd==1)
					..()
					return
				if(AZ.hunting_enabled==0) return ..()
				Spawnz = list(/mob/NPC/Animals/Small_Fish,/mob/NPC/Animals/Large_Fish)
				if(istype(AZ,/mob))
					var/X = pick(src.Spawnz)
					var/mob/NPC/O = new X
					if(prob(O.Probability+AZ.discovery))
						if(prob(O.Probability+AZ.discovery))
							if(prob(O.Probability+AZ.discovery))
								var/i = rand(1,3)

								O.agressive = 1
								O.psionic_power+=rand(1,2)*(global.year*1.5)*i
								O.strength+=rand(1,2)*(global.year*2)*i
								O.endurance+=rand(1,2)*(global.year*2)*i
								O.resistance+=rand(1,2)*(global.year*2)*i
								O.mod_agility+=rand(2,4)*(global.year*2)*i
								O.offence=rand(2,4)*(global.year*2)*i
								O.defence=rand(1,4)*(global.year*2)*i

								O.dir=src.dir
								O.loc = src.loc
								AZ.npc_spawn_cd=1




								//O.showhpbars()
								sleep(50)
								AZ.npc_spawn_cd=0

*/
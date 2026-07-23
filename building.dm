obj/buildables
	var
		ownedland=0
		unownedland=1
		ownerofland
		sovereignland=0
	Crossed(mob/player/M)
		if(!ismob(usr)) return
		if(!ismob(M)) return
		if(src.sovereignland==1&&M.inownedLand==0&&M.sovereignty==0||src.sovereignland==1&&M.inownedLand==1&&M.sovereignty==0)
			M<<"<b><center>You are now entering sovereign-land.</center></b>"
			M.sovereignty=1
		if(src.unownedland==0&&M.inownedLand==0)
			M<<"<b><center>You are now entering land owned by [src.ownerofland].</center></b>"
			M.inownedLand=1
			M.sovereignty=0
		if(src.sovereignland==0&&src.unownedland==1)
			if(M.sovereignty==1||M.inownedLand==1)
				M<<"<b><center>You are now entering un-owned land.</center></b>"
				M.inownedLand=0
				M.sovereignty=0
turf/buildables

	Crossed(mob/player/M)
		if(!ismob(usr)) return
		if(!ismob(M)) return
		if(src.sovereignland==1&&M.inownedLand==0&&M.sovereignty==0||src.sovereignland==1&&M.inownedLand==1&&M.sovereignty==0)
			M<<"<b><center>You are now entering sovereign-land.</center></b>"
			M.sovereignty=1
		if(src.unownedland==0&&M.inownedLand==0)
			M<<"<b><center>You are now entering land owned by [src.ownerofland].</center></b>"
			M.inownedLand=1
			M.sovereignty=0
		if(src.sovereignland==0&&src.unownedland==1)
			if(M.sovereignty==1||M.inownedLand==1)
				M<<"<b><center>You are now entering un-owned land.</center></b>"
				M.inownedLand=0
				M.sovereignty=0
obj
	buildings
		bolted = 1
		var/builds
		layer = 33
		plane = 23

		blend_mode = BLEND_INSET_OVERLAY
		appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
		MouseEntered(location,control,params)
			if(usr.info_box1)
				usr.client.screen += usr.info_box1
				usr.client.screen += usr.info_box2
				usr.client.screen += usr.info_box3
				usr.info_box(src,src.name,params)
		MouseExited(location,control,params)
			if(usr.info_box1)
				usr.client.screen -= usr.info_box1
				usr.client.screen -= usr.info_box2
				usr.client.screen -= usr.info_box3
				usr.info_box3.maptext = null
		MouseMove(location,control,params)
			..()
			usr.info_box(src,src.name,params)
		New(var/owner)
			var/image/sel = image('fx.dmi',src,"select item",100)
			src.img_select = sel
			//src.build = src.type
			if(owner)
				src.creator = owner
		Click(location,control,params)
			params = params2list(params)
			if(src.loc == null)
				usr.build_tech = src
				//winshow(usr,"build_open",0)
				if(usr.hud_build) usr.client.screen -= usr.hud_build
			else
				if(params["right"])
					if(usr.skill_remote_viewing && usr.skill_remote_viewing.active)
						call(usr.skill_remote_viewing.act)(usr,usr.skill_remote_viewing)
						usr.map_proc(1)
					if(usr.active_attack) usr.active_attack = null //Cancel the energy attack current being fired or charged.
					if(istype(usr.build_tech,/obj/items/tech/)) usr.cancel_tech()
					else if(istype(usr.build_tech,/obj/buildings/)) usr.cancel_build()
					if(src.creator == usr || owner == usr)
						switch(input(usr,"Do you wish to delete this building?") in list("Yes","No"))
							if("Yes")
								var/obj/effects/dust_medium/d = new
								d.SetCenter(src)
								//src.create_worldmap_building()
								//src.og_type = null
								src.destroy()
								return

		demolish
			icon = 'terrain.dmi'
			icon_state = "demolish"
			name = "Demolish"
		roofs
			icon = 'terrain.dmi'
			density_factor = 2
			//layer = 3.2
			opacity = 1
			Brick_Roof
				icon_state = "brick roof"
				value = 1000
				build = /turf/buildables/roofs/Brick_Roof
			Metal_Roof
				icon_state = "tech roof"
				value = 2000
				build = /turf/buildables/roofs/Metal_Roof
			Wooden_Roof
				icon_state = "wood plank roof"
				value = 1000
				build = /turf/buildables/roofs/Wooden_Roof
			Log_Roof
				icon_state = "log roof"
				build = /turf/buildables/roofs/Log_Roof_01
				value = 1000
			Stone_Roof
				icon_state = "stone roof"
				value = 1000
				build = /turf/buildables/roofs/Stone_Roof
			Metal_roof_01
				icon = 'roofs_metal.dmi'
				icon_state = "1"
				opacity = 1
				build = /turf/buildables/roofs/Roof_01
			Metal_roof_02
				icon = 'roofs_metal.dmi'
				icon_state = "2"
				opacity = 1
				build = /turf/buildables/roofs/Roof_02
		walls
			icon = 'terrain.dmi'
			density_factor = 1
			Wooden_Wall
				icon_state = "wood plank wall"
				value = 0
				build = /turf/buildables/walls/Wooden_Wall_01
			Log_Wall
				icon_state = "log wall"
				value = 0
				build = /turf/buildables/walls/Wooden_Wall_02
			Stone_Wall
				icon_state = "stone wall"
				value = 0
			Brick_Wall
				icon_state = "brick wall"
				build = /turf/buildables/walls/Brick_Wall
				value = 0
			Metal_wall_01
				icon_state = "tech wall"
				value = 0
				build = /turf/buildables/walls/Wall_01
			Metal_wall_02
				icon = 'walls_metal.dmi'
				icon_state = "1"
				value = 0
				build = /turf/buildables/walls/Wall_02
			Metal_wall_03
				icon = 'walls_metal.dmi'
				icon_state = "2"
				value = 0
				build = /turf/buildables/walls/Wall_03
		floors
			icon = 'terrain.dmi'
			density_factor = 0
			Grass
				icon_state = "grass"
				value = 0
				build = /turf/grass
				hud_x = 12
				hud_y = 234
			Wooden_Floor
				icon_state = "wood plank floor"
				value = 500
				build = /turf/buildables/floors/Floor_04
				hud_x = 58
				hud_y = 234
			Log_Floor
				icon_state = "log floor"
				value = 500
				build = /turf/buildables/floors/Floor_05
				hud_x = 104
				hud_y = 234
			Brick_Floor
				icon_state = "brick floor"
				value = 1000
				hud_x = 150
				hud_y = 234
			Metal_floor_01
				icon_state = "metal floor 1"
				build = /turf/buildables/floors/Floor_01
				hud_x = 196
				hud_y = 234
			Metal_floor_02
				icon_state = "metal floor 2"
				build = /turf/buildables/floors/Floor_02
				hud_x = 242
				hud_y = 234
			Metal_floor_03
				icon_state = "metal floor 3"
				build = /turf/buildables/floors/Floor_03
				hud_x = 12
				hud_y = 188
			Metal_floor_04
				icon_state = "tech floor"
				value = 1500
				build = /turf/buildables/floors/Floor_06
				hud_x = 58
				hud_y = 188
			Dirt
				icon_state = "dirt"
				value = 0
				build = /turf/dirts/dirt7
				hud_x = 104
				hud_y = 188
			Sand
				icon_state = "sand5"
				value = 0
				build = /turf/sands/sand5
				hud_x = 150
				hud_y = 188
			Snow
				icon_state = "snow5"
				value = 0
				build = /turf/snows/snow5
				hud_x = 196
				hud_y = 188
			Lava_Cooled
				icon_state = "lava cooled"
				value = 0
				build = /turf/lava_cooled
				hud_x = 242
				hud_y = 188
			Lava_Cooling
				icon_state = "lava cooling"
				value = 0
				build = /turf/lava_cooling
				hud_x = 12
				hud_y = 142
			Stone_Floor
				icon_state = "stone floor"
				value = 0
				build = /turf/stone_floor
				hud_x = 12
				hud_y = 142
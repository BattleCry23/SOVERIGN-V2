vegeta_location
					maptext_width = 128
					maptext_height = 64
					maptext_x = 46
					screen_loc = "25:9,16:18"
					layer = 101
					maptext = "<font size = 2><text align=middle valign=bottom>Vegeta"
					Click()
						if(maps_created)
							var/obj/m = usr.hud_map[10]
							m.maptext = "[css_outline]Vegeta: X - 0, Y - 0"
							if(usr.skill_sense && usr.skill_sense.active) usr.map_update_blip("both")
							if(usr.z != 1) usr.client.images -= usr.map_blip
							else usr.client.images += usr.map_blip
							/*
							for(var/mob/p in players)
								if(p.map_blip)
									if(p.loc && p.z == 1)
										if(p == usr || usr.skill_sense && usr.skill_sense.active && p.z == usr.z) usr.client.images += p.map_blip
									else usr.client.images -= p.map_blip
							*/
							sleep(0.1)
							for(var/obj/hud/map/map_large/x in maps)
								usr.client.screen -= x
								if(x.build_overlay) usr.client.screen -= x.build_overlay
							sleep(0.1)
							usr.client.screen += maps[10]
							sleep(0.1)
							if(usr.z == 1)
								var/obj/hud/map/map_large/x = maps[10]
								if(x.build_overlay) usr.client.screen += x.build_overlay
				vegeta_underground_location
					icon = 'map_location_vegeta.dmi'
					icon_state = "down"
					//filters = filter(type="outline", size=1, color=rgb(0,0,0))
					maptext_width = 128
					maptext_height = 64
					maptext_x = 46
					screen_loc = "28:12,16:18"
					layer = 101
					//maptext = "<font size = 2><text align=middle valign=bottom>Underground"
					Click()
						if(maps_created)
							var/obj/m = usr.hud_map[5]
							m.maptext = "[css_outline]Earth Underground: X - 0, Y - 0"
							if(usr.skill_sense && usr.skill_sense.active) usr.map_update_blip("both")
							if(usr.z != 3) usr.client.images -= usr.map_blip
							else usr.client.images += usr.map_blip
							sleep(0.1)
							for(var/obj/hud/map/map_large/x in maps)
								usr.client.screen -= x
								if(x.build_overlay) usr.client.screen -= x.build_overlay
							sleep(0.1)
							usr.client.screen += maps[10]
							sleep(0.1)
							if(usr.z == 3)
								var/obj/hud/map/map_large/x = maps[10]
								if(x.build_overlay) usr.client.screen += x.build_overlay









mob/var
	aged
obj
	ages
		icon = 'age_huds.dmi'
		icon_state = "adult"
		var/image/sel
		var/txt_info
		plane=24
		layer=34
		blend_mode = BLEND_INSET_OVERLAY
		appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
		maptext_width = 120
		maptext_height = 16
		maptext_y = 3

		MouseMove(location,control,params)
			..()
			usr.update_info_box(src,src.txt_info,params)

		MouseEntered(location,control,params)
			if(usr.started == 0)
				if(src.txt_info && usr.info_box1)
					usr.client.screen += usr.info_box1
					usr.client.screen += usr.info_box2
					usr.client.screen += usr.info_box3
					usr.update_info_box(src,src.txt_info,params)
		Click()
			if(usr.started == 0)
			//	if(usr.age_selected) usr.age_selected.icon_state = "[usr.age]"
			//	usr.age_selected = src
				src.icon_state = "[initial(src.icon_state)] selected"
				if(usr.hud_char)
					var/obj/txt = usr.hud_char.origins_desc_txt
					txt.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>[src.info_name]</u>\n<text align=left valign=top>[src.info]"
		baby
			act = /obj/ages/adult/proc/activate
			//banned_races = list("Namekian","Cerebroid","Android","Demon","Kai","Oni")
			info_name = "Baby"
			New()
				..()
				src.info = "Start Age: 0.1"
			proc
				activate(var/mob/m,var/obj/s)
					if(s.active == 0)
						m.aged = s
						s.active = 1
						m.age = 0.1
						m.age_soul = 0.1
						m.birth_year = year
						//give psionic_power boost of 10xs
						switch(m.race)
							if("Human")
								switch(m.gender)
									if("Male")
										icon='human_babymale.dmi'
									if("Female")
										icon='human_babyfemale.dmi'


							if("Demon")
								icon='alien_egg.dmi'

							if("Kai")
								switch(m.gender)
									if("Male")
										icon='human_babymale.dmi'
									if("Female")
										icon='human_babyfemale.dmi'


							if("Oni")
								icon='alien_egg.dmi'

							if("Saiyan")
								switch(m.gender)
									if("Male")
										icon='human_babymale.dmi'
									if("Female")
										icon='human_babyfemale.dmi'

							if("Namekian")

								icon='namekian_egg.dmi'

							if("Tuffle")
								switch(m.gender)
									if("Male")
										icon='human_babymale.dmi'
									if("Female")
										icon='human_babyfemale.dmi'

							if("Half God")
								switch(m.gender)
									if("Male")
										icon='human_babymale.dmi'
									if("Female")
										icon='human_babyfemale.dmi'
							if("Spirit Doll")
								icon='human_babymale.dmi'
							if("Changeling")
								icon='alien_egg.dmi'
		kid
			act = /obj/ages/adult/proc/activate
			//banned_races = list("Namekian","Cerebroid","Android","Demon","Kai","Oni")
			info_name = "Kid"
			New()
				..()
				src.info = "Start Age: 4"
			proc
				activate(var/mob/m,var/obj/s)
					if(s.active == 0)
						m.aged = s
						s.active = 1
						m.age = 4
						m.age_soul = 4
						m.birth_year = year-4
						//give psionic_power boost of 10xs
						switch(m.race)
							if("Human")
								switch(m.gender)
									if("Male")
										icon='human_male_white_kid.dmi'
									if("Female")
										icon='human_female_white_kid.dmi'


							if("Demon")
								switch(m.gender)
									if("Male")
										icon='humanoid_no_colour2_kid.dmi'
									if("Female")
										icon='humanoid_no_colour_female2_kid.dmi'

							if("Kai")
								switch(m.gender)
									if("Male")
										icon='elf_male_white_kid.dmi'
									if("Female")
										icon='elf_female_white_kid.dmi'


							if("Oni")
								icon='elf_male_white_kid.dmi'

							if("Saiyan")
								switch(m.gender)
									if("Male")
										icon='human_male_white_kid.dmi'
									if("Female")
										icon='human_female_white_kid.dmi'

							if("Namekian")

								icon='NewKidNamekian1.dmi'

							if("Tuffle")
								switch(m.gender)
									if("Male")
										icon='human_male_white_kid.dmi'
									if("Female")
										icon='human_female_white_kid.dmi'

							if("Half God")
								switch(m.gender)
									if("Male")
										icon='human_male_white_kid.dmi'
									if("Female")
										icon='human_female_white_kid.dmi'

							if("Spirit Doll")
								icon='spiritdoll_kid.dmi'
							if("Changeling")
								icon='Frieza_1st_form_kid.dmi'
		teen
			act = /obj/ages/adult/proc/activate
			//banned_races = list("Namekian","Cerebroid","Android","Demon","Kai","Oni")
			info_name = "Teen"
			New()
				..()
				src.info = "Start Age: 13"
			proc
				activate(var/mob/m,var/obj/s)
					if(s.active == 0)
						m.aged = s
						s.active = 1
						m.age = 13
						m.age_soul = 13
						m.birth_year = year-13
						//give psionic_power boost of 10xs
						switch(m.race)
							if("Human")
								switch(m.gender)
									if("Male")
										icon='NewMalesWhite.dmi'
									if("Female")
										icon='FemaleBaseWhite.dmi'


							if("Demon")
								switch(m.gender)
									if("Male")
										icon='demon_male.dmi'
									if("Female")
										icon='FemaleBaseWhite.dmi'

							if("Kai")
								switch(m.gender)
									if("Male")
										icon='elf_male_white.dmi'
									if("Female")
										icon='FemaleBaseWhite.dmi'


							if("Oni")
								icon='elf_male_white.dmi'

							if("Saiyan")
								switch(m.gender)
									if("Male")
										icon='NewMalesWhite.dmi'
									if("Female")
										icon='FemaleBaseWhite.dmi'

							if("Namekian")

								icon='NewNamekianAdult1.dmi'

							if("Tuffle")
								switch(m.gender)
									if("Male")
										icon='NewMalesWhite.dmi'
									if("Female")
										icon='FemaleBaseWhite.dmi'

							if("Half God")
								switch(m.gender)
									if("Male")
										icon='NewMalesWhite.dmi'
									if("Female")
										icon='FemaleBaseWhite.dmi'
							if("Spirit Doll")
								icon='spiritdoll.dmi'
							if("Changeling")
								icon='Frieza_1st_form.dmi'
		adult
			act = /obj/ages/adult/proc/activate
			//banned_races = list("Namekian","Cerebroid","Android","Demon","Kai","Oni")
			info_name = "Adult"
			New()
				..()
				src.info = "Start Age: 21"
			proc
				activate(var/mob/m,var/obj/s)
					if(s.active == 0)
						m.aged = s
						s.active = 1
						m.age = 21
						m.age_soul = 21
						m.birth_year = year-21
						//give psionic_power boost of 10xs
						switch(m.race)
							if("Human")
								switch(m.gender)
									if("Male")
										icon='NewMalesWhite.dmi'
									if("Female")
										icon='FemaleBaseWhite.dmi'


							if("Demon")
								switch(m.gender)
									if("Male")
										icon='demon_male.dmi'
									if("Female")
										icon='FemaleBaseWhite.dmi'

							if("Kai")
								switch(m.gender)
									if("Male")
										icon='elf_male_white.dmi'
									if("Female")
										icon='FemaleBaseWhite.dmi'


							if("Oni")
								icon='elf_male_white.dmi'

							if("Saiyan")
								switch(m.gender)
									if("Male")
										icon='NewMalesWhite.dmi'
									if("Female")
										icon='FemaleBaseWhite.dmi'

							if("Namekian")

								icon='NewNamekianAdult1.dmi'

							if("Tuffle")
								switch(m.gender)
									if("Male")
										icon='NewMalesWhite.dmi'
									if("Female")
										icon='FemaleBaseWhite.dmi'

							if("Half God")
								switch(m.gender)
									if("Male")
										icon='NewMalesWhite.dmi'
									if("Female")
										icon='FemaleBaseWhite.dmi'
							if("Spirit Doll")
								icon='spiritdoll.dmi'
							if("Changeling")
								icon='Frieza_1st_form.dmi'


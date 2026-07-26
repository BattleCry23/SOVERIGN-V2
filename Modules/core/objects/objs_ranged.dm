obj
	ranged
		plane=34 // 22
		var
			charge_lvl = 1
			spd = 12
			homing = 0
			size = 0.1
			pix_away = 18
			state_type = null
			animated = 0
			fired = 0
			expired = 0
			just_started = 1
			finishing = 0
			hit_solid = 0
			list/beam_list
			tmp/mob/origin
			tmp/num = 0
			tmp/ang = 0
			tmp/prev_x = 0;
			tmp/prev_y = 0;
		proc
			remove()
				src.loc = null
				if(istype(src,/obj/ranged/blast))
					src.alpha = 255
					src.icon = initial(src.icon)
				//if(istype(src,/obj/ranged/charge)) src.transform *= 0.1
		checker
			icon = 'eye_lasers_test.dmi'
			name = "beam checker"
		eye_laser
			icon = 'eye_lasers.dmi'
			icon_state = "all dir"
			plane = 1
			pix_away = 0
			explode_impact = 0
			density_factor = 1
			hasreflect = 0
			pixel_y = 3;
			KB = 1
			fired = 1
		beam
			icon = 'beam_body.dmi'
			//icon_state = "psionic"
			icon_state = "divine"
			appearance_flags = PIXEL_SCALE
			//bounds = "128,128 to 128,128"
			plane = 34
			//density = 1
			pixel_x = -48
			pixel_y = -48
			pix_away = 0
			explode_impact = 0
			density_factor = 1
			hasreflect = 0
			KB = 1
			fired = 1

		beam2
			icon = 'beam2_body.dmi'
			icon_state = ""
			//icon_state = "psionic"
			appearance_flags = PIXEL_SCALE
			//bounds = "128,128 to 128,128"
			plane = 34
			//density = 1
			pixel_x = -48
			pixel_y = -48
			pix_away = 0
			explode_impact = 0
			density_factor = 1
			hasreflect = 0
			KB = 1
			fired = 1

			/*
			Bump(atom/a)
				if(a && a.type != src.type && a != src.ki_owner)
					src.hit_solid = 1
			*/
		disk_charge
			icon = 'DestructoDisk.dmi'
			icon_state = "disk"
			pixel_x = -48
			pixel_y = -48
			density_factor = 0
			density = 0
			explode_impact = 0
			plane = 2
			state_type = "beam"
			hasreflect = 0
			layer = MOB_LAYER + 1
			bolted = 2
			//bounds = "1,1 to 32,32"
			New()

				src.transform *= 0.1
				src.beam_list = list()
				if(!src.icon_state)
					src.icon_state = "disk"
				spawn(1) src.spin()
			proc
				spin()
					animate(src, transform = matrix()*1.1, time = 20, loop = -1, flags = ANIMATION_PARALLEL)
					animate(transform = matrix()*1, time = 20)
					animate(transform = turn(matrix(), 120), time = 8,loop = -1, flags = ANIMATION_PARALLEL)
					animate(transform = turn(matrix(), 240), time = 8)
					animate(transform = null, time = 8)
					var/sound/S = sound('Kienzan_Charge.wav')
					S.channel = 5 // Any number from 1-99
					S.volume = 100
					S.repeat = 0
					view(8,src)<<S // Make sure it's not loopin
			proc
				go(var/obj/ray)
					if(src.loc && src.expired == 0)

						var/remove = 0
						if(src.homing == 0)
							src.MoveAngInstant(src.ang,src.spd,0,0,null)
						else if(src.ki_owner)
							if(src.ki_owner.target)
								var/atom/movable/a = src.ki_owner.target
								src.ang = src.GetAngleStep(a)
								src.MoveAngInstant(src.ang,src.spd,0,0,a)
							else remove = 1
						else remove = 1
						src.travel -= 1
						//n-=1
						if(src.travel <= 0 || src.explode_impact == 2)
							remove = 1
						if(src.finishing == 0 && remove)
							remove = 1
							var/matrix/M = matrix()
							M.Scale(0,0)
							animate(src,transform = M,time = 10)
							src.finishing = 1
							spawn(10)
								if(src) src.destroy() //del(src)
						spawn(0.1)
							if(src && src.loc) src.go()
					else
						src.destroy()
						return
		beam2_charge // Kaioenjin I think
			icon = 'beam2_charge.dmi'
			icon_state=""
			//icon_state = "psionic"
			//icon_state = "charge"
			pixel_x = -48
			pixel_y = -48
			density_factor = 0
			density = 0
			explode_impact = 0
			plane = 34
			state_type = "beam"
			hasreflect = 0
			layer = MOB_LAYER - 1
			bolted = 2
			//bounds = "1,1 to 32,32"
			New()
				src.transform *= 0.1
				src.beam_list = list()
			proc
				go(var/obj/ray)
					if(src.loc && src.expired == 0)
						var/remove = 0
						if(src.homing == 0)
							src.MoveAngInstant(src.ang,src.spd,0,0,null)
						else if(src.ki_owner)
							if(src.ki_owner.target)
								var/atom/movable/a = src.ki_owner.target
								src.ang = src.GetAngleStep(a)
								src.MoveAngInstant(src.ang,src.spd,0,0,a)
							else remove = 1
						else remove = 1
						src.travel -= 1
						//n-=1
						if(src.travel <= 0 || src.explode_impact == 2)
							remove = 1
						if(src.finishing == 0 && remove)
							remove = 1
							var/matrix/M = matrix()
							M.Scale(0,0)
							animate(src,transform = M,time = 10)
							src.finishing = 1
							spawn(10)
								if(src) src.destroy() //del(src)
						spawn(0.1)
							if(src && src.loc) src.go()
					else
						src.destroy()
						return
		beam_charge
			icon = 'beam_charge.dmi'
			//icon_state = "psionic"
			icon_state = "divine"
			//icon_state = "charge"
			pixel_x = -48
			pixel_y = -48
			density_factor = 0
			density = 0
			explode_impact = 0
			plane = 2
			state_type = "beam"
			hasreflect = 0
			layer = MOB_LAYER - 1
			bolted = 2
			//bounds = "1,1 to 32,32"
			New()
				src.transform *= 0.1
				src.beam_list = list()
				var/sound/S = sound('Charging.wav')
				S.channel = 5 // Any number from 1-99
				S.volume = 100
				S.repeat = 0
				view(8,src)<<S // Make sure it's not loopin
			proc
				go(var/obj/ray)
					if(src.loc && src.expired == 0)
						var/remove = 0
						if(src.homing == 0)
							src.MoveAngInstant(src.ang,src.spd,0,0,null)
						else if(src.ki_owner)
							if(src.ki_owner.target)
								var/atom/movable/a = src.ki_owner.target
								src.ang = src.GetAngleStep(a)
								src.MoveAngInstant(src.ang,src.spd,0,0,a)
							else remove = 1
						else remove = 1
						src.travel -= 1
						//n-=1
						if(src.travel <= 0 || src.explode_impact == 2)
							remove = 1
						if(src.finishing == 0 && remove)
							remove = 1
							var/matrix/M = matrix()
							M.Scale(0,0)
							animate(src,transform = M,time = 10)
							src.finishing = 1
							spawn(10)
								if(src) src.destroy() //del(src)
						spawn(0.1)
							if(src && src.loc) src.go()
					else
						src.destroy()
						return
		Blow
			icon = 'explode.dmi'
			layer=999
			luminosity=100
			density=0
			plane = 1

			New(turf/T)
				..()
				overlays+=image('explode.dmi')
				new/obj/DamagedTurf(src.loc)
				//for(var/mob/races/M in src.loc)
				//	M.ScreenShake(1,2)
					//src.doDamage(M)
				if(src)
					//src.invisibility=0

					spawn(rand(20,50))if(src) src.destroy()

			/* Crossed(mob/races/A)
				if(A)
					if(ismob(A))
						world.log<<"Finish explodie logic."

						//A.ScreenShake(rand(1,2))
						//src.doDamage(A)
					*/

		kaioryu_blast
			icon = 'BlastM.dmi'
			density_factor = 1
			density = 0
			explode_impact = 1
			plane = 1
			state_type = "blast"
			fired = 1;
			proc

				go()
					if(src.loc)
						src.MoveAngInstant(src.ang,src.spd,0,0,null)
						//src.Project(12, m.mouse_down)
						//src.Project(12, d)
						//if(prob(20)) src.dust_and_furrows(1)
						src.travel -= 1
						if(src.travel == 10) animate(src,alpha = 0, 3)
						if(src.travel <= 0 || src.explode_impact == 2)
							src.remove()
						spawn(0.1)
							if(src && src.loc) src.go()
					else return
			lvl1
				icon = 'BlastM.dmi'

			lvl2
				icon = 'BlastM.dmi'

			lvl3
				icon ='BlastM.dmi'

		blast
			icon = 'skills_ki.dmi'
			density_factor = 1
			density = 0
			explode_impact = 1
			plane = 1
			state_type = "blast"
			fired = 1;
			proc

				go()
					if(src.loc)
						src.MoveAngInstant(src.ang,src.spd,0,0,null)
						//src.Project(12, m.mouse_down)
						//src.Project(12, d)
						//if(prob(20)) src.dust_and_furrows(1)
						src.travel -= 1
						if(src.travel == 10) animate(src,alpha = 0, 3)
						if(src.travel <= 0 || src.explode_impact == 2)
							src.remove()
						spawn(0.1)
							if(src && src.loc) src.go()
					else return
			lvl1
				icon = 'blast1.dmi'
				state_type = ""
			lvl2
				icon = 'blast_blasts.dmi'
				icon_state = "24"
				state_type = "24"
			lvl3
				icon ='skills_ki.dmi'
				state_type = "blast"

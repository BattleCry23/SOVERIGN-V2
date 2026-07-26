obj/Limbs
	icon='limbStats.dmi'
	Del1
		icon_state="1N"
		screen_loc="TOP,RIGHT-2"
		plane=3
	Del2
		icon_state="2N"
		screen_loc="TOP,RIGHT-1"
		plane=3
		//screen_loc="25:22,26:-12"
	Del3
		icon_state="3N"
		screen_loc="TOP-1,RIGHT-2"
		plane=3
		//screen_loc="24:22,25:-12"
	Del4
		icon_state="4N"
		screen_loc="TOP-1,RIGHT-1"
		plane=3
	Normal1
		icon_state="1"
		screen_loc="TOP,RIGHT-2"
		plane=3
		//screen_loc="24:22,26:-12"
	Normal2
		icon_state="2"
		screen_loc="TOP,RIGHT-1"
		plane=3
		//screen_loc="25:22,26:-12"
	Normal3
		icon_state="3"
		screen_loc="TOP-1,RIGHT-2"
		plane=3
		//screen_loc="24:22,25:-12"
	Normal4
		icon_state="4"
		screen_loc="TOP-1,RIGHT-1"
		plane=3
	//	screen_loc="25:22,25:-12"
	Green1
		icon_state="1G"
		screen_loc="TOP,RIGHT-2"
		plane=3
	Green2
		icon_state="2G"
		screen_loc="TOP,RIGHT-1"
		plane=3
		//screen_loc="25:22,26:-12"
	Green3
		icon_state="3G"
		screen_loc="TOP-1,RIGHT-2"
		plane=3
		//screen_loc="24:22,25:-12"
	Green4
		icon_state="4G"
		screen_loc="TOP-1,RIGHT-1"
		plane=3
	Yel1
		icon_state="1Y"
		screen_loc="TOP,RIGHT-2"
		plane=3
	Yel2
		icon_state="2Y"
		screen_loc="TOP,RIGHT-1"
		plane=3
		//screen_loc="25:22,26:-12"
	Yel3
		icon_state="3Y"
		screen_loc="TOP-1,RIGHT-2"
		plane=3
		//screen_loc="24:22,25:-12"
	Yel4
		icon_state="4Y"
		screen_loc="TOP-1,RIGHT-1"
		plane=3
	Red1
		icon_state="1R"
		screen_loc="TOP,RIGHT-2"
		plane=3
	Red2
		icon_state="2R"
		screen_loc="TOP,RIGHT-1"
		plane=3
		//screen_loc="25:22,26:-12"
	Red3
		icon_state="3R"
		screen_loc="TOP-1,RIGHT-2"
		plane=3
		//screen_loc="24:22,25:-12"
	Red4
		icon_state="4R"
		screen_loc="TOP-1,RIGHT-1"
		plane=3
	Black1
		icon_state="1B"
		screen_loc="TOP,RIGHT-2"
		plane=3
	Black2
		icon_state="2B"
		screen_loc="TOP,RIGHT-1"
		plane=3
		//screen_loc="25:22,26:-12"
	Black3
		icon_state="3B"
		screen_loc="TOP-1,RIGHT-2"
		plane=3
		//screen_loc="24:22,25:-12"
	Black4
		icon_state="4B"
		screen_loc="TOP-1,RIGHT-1"
		plane=3
mob/proc/Injury_Healing()
	while(src)
		if(src.raceconfirmed==1&&src.statsconfirmed==1&&onCreation==0)
			//Blindness
			if(src.Blindness)
				src.client.screen -= src.Blindness
				var/obj/O = src.Blindness
				O.screen_loc = "1,1 to [src.client.view]"
				src.Blindness = O
				src.client.screen += src.Blindness
			//Healing
			var/Healing = 0.001
			if(src.icon_state == "Meditate")
				Healing += 0.001
			Healing += src.Regeneration / 20
			for(var/obj/items/tech/Bandages/B in src)
				if(B.suffix)
					Healing += (B.quality*0.000125) / 2
					var/L = list("All")
					src.Injure_Heal(Healing,L)
					src.Check_Injuries()
					break
			for(var/obj/items/tech/Rejuvination_Tank/R in range(0,src))
				if(!R) continue
				if(insideHBTC==0) Healing += (R.quality * 0.00025) / 2
				else Healing += R.quality * 0.00025
				var/L = list("All")
				src.Injure_Heal(Healing,L)
				src.Check_Injuries()
				break
			if(src.Regenerate)
				Healing += 0.01
			if(src.Senzu)
				Healing = Healing*2
			if(src.icon_state == "Train")
				Healing = 0.01
			var/L = list("All")
			src.Injure_Heal(Healing,L)
			src.Check_Injuries()
		sleep(50)

mob/proc
	Check_Injuries()


		for(var/obj/Limbs/L in src.client.screen)
			if(L.icon_state=="1"||L.icon_state=="1G"||L.icon_state=="1Y"||L.icon_state=="1R"||L.icon_state=="1B")
				if(Injury_Left_Arm<=24)
					L.icon_state="1"
				if(Injury_Left_Arm>=25)
					L.icon_state="1G"
				if(Injury_Left_Arm>=50)
					L.icon_state="1Y"
				if(Injury_Left_Arm>=75)
					L.icon_state="1R"
				if(Injury_Left_Arm>=round(95))
					L.icon_state="1B"
				if(src.CriticalMaim_Left_Arm ==1)
					src.client.screen-=L
					var/obj/Limbs/Del2/D=new/obj/Limbs/Del2
					src.client.screen+=D
					qdel(L)
			if(L.icon_state=="2"||L.icon_state=="2G"||L.icon_state=="2Y"||L.icon_state=="2R"||L.icon_state=="2B")
				if(Injury_Right_Arm<=24)
					L.icon_state="2"
				if(Injury_Right_Arm>=25)
					L.icon_state="2G"
				if(Injury_Right_Arm>=50)
					L.icon_state="2Y"
				if(Injury_Right_Arm>=75)
					L.icon_state="2R"
				if(Injury_Right_Arm>=round(95))
					L.icon_state="2B"
				if(src.CriticalMaim_Right_Arm ==1)
					src.client.screen-=L
					var/obj/Limbs/Del2/D=new/obj/Limbs/Del2
					src.client.screen+=D
					qdel(L)
			if(L.icon_state=="3"||L.icon_state=="3G"||L.icon_state=="3Y"||L.icon_state=="3R"||L.icon_state=="3B")
				if(Injury_Left_Leg<=24)
					L.icon_state="3"
				if(Injury_Left_Leg>=25)
					L.icon_state="3G"
				if(Injury_Left_Leg>=50)
					L.icon_state="3Y"
				if(Injury_Left_Leg>=75)
					L.icon_state="3R"
				if(Injury_Left_Leg>=round(95))
					L.icon_state="3B"
				if(src.CriticalMaim_Left_Leg ==1)
					src.client.screen-=L
					var/obj/Limbs/Del2/D=new/obj/Limbs/Del2
					src.client.screen+=D
					qdel(L)
			if(L.icon_state=="4"||L.icon_state=="4G"||L.icon_state=="4Y"||L.icon_state=="4R"||L.icon_state=="4B")
				if(Injury_Right_Leg<=24)
					L.icon_state="4"
				if(Injury_Right_Leg>=25)
					L.icon_state="4G"
				if(Injury_Right_Leg>=50)
					L.icon_state="4Y"
				if(Injury_Right_Leg>=75)
					L.icon_state="4R"
				if(Injury_Right_Leg>=round(95))
					L.icon_state="4B"
				if(src.CriticalMaim_Right_Leg ==1)
					src.client.screen-=L
					var/obj/Limbs/Del2/D=new/obj/Limbs/Del2
					src.client.screen+=D
					qdel(L)

		sleep(5)
		return



mob/proc/Check_Maim_Heal()
	if(locate(/obj/Limbs/Del2/) in src.client.screen)
		var/obj/Limbs/Normal2/N=new/obj/Limbs/Normal2
		src.client.screen+=N
		CriticalMaim_Left_Arm=0
	if(locate(/obj/Limbs/Del1/) in src.client.screen)
		var/obj/Limbs/Normal1/N=new/obj/Limbs/Normal1
		src.client.screen+=N
		CriticalMaim_Right_Arm=0
	if(locate(/obj/Limbs/Del4/) in src.client.screen)
		var/obj/Limbs/Normal4/N=new/obj/Limbs/Normal4
		src.client.screen+=N
		CriticalMaim_Left_Leg=0
	if(locate(/obj/Limbs/Del3/) in src.client.screen)
		var/obj/Limbs/Normal3/N=new/obj/Limbs/Normal3
		src.client.screen+=N
		CriticalMaim_Right_Leg=0
	Check_Injuries()
mob/proc
	BB_Injury(var/Percent,var/list/Limbs)
		if(typesof(src,/mob/monsters/)) return
		if(src.Limb_Res)
			var/RES = abs(src.Limb_Res)
			var/N = RES / 100 + 1
			if(src.Limb_Res > 0)
				Percent /= N
			else
				Percent *= N
			if(src.Limb_Res == 100)
				return
			if(Percent < 0)
				return
		var/list/Areas = list("Left Arm","Right Arm","Right Leg","Left Leg")
		if(src.Critical_Left_Arm == 100)
			Areas -= "Left Arm"
		if(src.Critical_Right_Arm == 100)
			Areas -= "Right Arm"
		if(src.Critical_Left_Leg == 100)
			Areas -= "Left Leg"
		if(src.Critical_Right_Leg == 100)
			Areas -= "Right Leg"
		if(!Limbs) Limbs = list()
		if(!Limbs.len)
			if(Areas.len)
				Limbs += pick(Areas)
		var/C = src.BBreakerskill*1.1
		if(prob(C))
			switch(src.MostInjuredLimb)
				/*if("Head")
					if(src.Injury_Head != 100)
						src.Injury_Head += Percent
						if(src.Injury_Head >= 100)
							src.Injury_Head = 100
							if(src.Critical_Head == 0)
								src.Critical_Head = 1
								src.Add/=2
								src.Magic_Potential/=2
								view(6,src) <<output("<font color = red>[src]'s head has been badly crushed!","rpoutput")
								src.saveToLog("| [src.client.address ? (src.client.address) : "IP not found"] | ([src.x], [src.y], [src.z]) | [key_name(src)] Head has been crushed.\n")
					if(src.Injury_Head > src.Injury_Right_Arm && src.Injury_Head > src.Injury_Left_Leg && src.Injury_Head > src.Injury_Right_Leg && src.Injury_Head > src.Injury_Left_Arm)
						src.MostInjuredLimb="Head"*/
				if("Left Leg")
					if(src.Injury_Left_Leg != 100)
						src.Injury_Left_Leg += Percent
						if(src.Injury_Left_Leg >= 100)
							src.Injury_Left_Leg = 100
							if(src.Critical_Left_Leg == 0)
								src.Critical_Left_Leg = 1
								src.StrMod/=Injury_Max
								src.Str/=Injury_Max
								src.PowMod/=Injury_Max
								src.Pow/=Injury_Max
								src.OffMod/=Injury_Max
								src.Off/=Injury_Max
								src.DefMod/=Injury_Max
								src.Def/=Injury_Max
								src.SpdMod/=Injury_Max
								view(6,src) <<output("[src]'s Left Leg is broken!","rpoutput")
								src.saveToLog("| [src.client.address ? (src.client.address) : "IP not found"] | ([src.x], [src.y], [src.z]) | [key_name(src)] Left Leg has been broken.\n")
								src.Check_Injuries()
					if(src.Injury_Left_Leg > src.Injury_Right_Arm && src.Injury_Left_Leg > src.Injury_Right_Leg && src.Injury_Left_Leg > src.Injury_Left_Arm && src.Injury_Left_Leg > src.Injury_Head)
						src.MostInjuredLimb="Left Leg"
				if("Right Leg")
					if(src.Injury_Right_Leg != 100)
						src.Injury_Right_Leg += Percent
						if(src.Injury_Right_Leg >= 100)
							src.Injury_Right_Leg = 100
							if(src.Critical_Right_Leg == 0)
								src.Critical_Right_Leg = 1
								src.StrMod/=Injury_Max
								src.Str/=Injury_Max
								src.PowMod/=Injury_Max
								src.Pow/=Injury_Max
								src.OffMod/=Injury_Max
								src.Off/=Injury_Max
								src.DefMod/=Injury_Max
								src.Def/=Injury_Max
								src.SpdMod/=Injury_Max
								view(6,src) <<output("[src]'s Right Leg is broken!","rpoutput")
								src.saveToLog("| [src.client.address ? (src.client.address) : "IP not found"] | ([src.x], [src.y], [src.z]) | [key_name(src)] Right Leg has been broken.\n")
								src.Check_Injuries()
					if(src.Injury_Right_Leg > src.Injury_Right_Arm && src.Injury_Right_Leg > src.Injury_Left_Leg && src.Injury_Right_Leg > src.Injury_Left_Arm && src.Injury_Right_Leg > src.Injury_Head)
						src.MostInjuredLimb="Right Leg"
				if("Left Arm")
					if(src.Injury_Left_Arm != 100)
						src.Injury_Left_Arm += Percent
						if(src.Injury_Left_Arm >= 100)
							src.Injury_Left_Arm = 100
							if(src.Critical_Left_Arm == 0)
								src.Critical_Left_Arm = 1
								src.StrMod/=Injury_Max
								src.Str/=Injury_Max
								src.PowMod/=Injury_Max
								src.Pow/=Injury_Max
								src.OffMod/=Injury_Max
								src.Off/=Injury_Max
								src.DefMod/=Injury_Max
								src.Def/=Injury_Max
								src.SpdMod/=Injury_Max
								view(6,src) <<output("[src]'s Left Arm is broken!","rpoutput")
								src.saveToLog("| [src.client.address ? (src.client.address) : "IP not found"] | ([src.x], [src.y], [src.z]) | [key_name(src)] Left Arm has been broken.\n")
								src.Check_Injuries()
					if(src.Injury_Left_Arm > src.Injury_Right_Arm && src.Injury_Left_Arm > src.Injury_Left_Leg && src.Injury_Left_Arm > src.Injury_Right_Leg && src.Injury_Left_Arm > src.Injury_Head)
						src.MostInjuredLimb="Left Arm"
				if("Right Arm")
					if(src.Injury_Right_Arm != 100)
						src.Injury_Right_Arm += Percent
						if(src.Injury_Right_Arm >= 100)
							src.Injury_Right_Arm = 100
							if(src.Critical_Right_Arm == 0)
								src.Critical_Right_Arm = 1
								src.StrMod/=Injury_Max
								src.Str/=Injury_Max
								src.PowMod/=Injury_Max
								src.Pow/=Injury_Max
								src.OffMod/=Injury_Max
								src.Off/=Injury_Max
								src.DefMod/=Injury_Max
								src.Def/=Injury_Max
								src.SpdMod/=Injury_Max
								view(6,src) <<output("[src]'s Right Arm is broken!","rpoutput")
								src.saveToLog("| [src.client.address ? (src.client.address) : "IP not found"] | ([src.x], [src.y], [src.z]) | [key_name(src)] Right Arm has been broken.\n")
								src.Check_Injuries()
					if(src.Injury_Right_Arm > src.Injury_Left_Arm && src.Injury_Right_Arm > src.Injury_Left_Leg && src.Injury_Right_Arm > src.Injury_Right_Leg && src.Injury_Right_Arm > src.Injury_Head)
						src.MostInjuredLimb="Right Arm"
		else
			if(Areas.len)
				var/L = pick(Areas)
				Limbs.Add(L)
				/*if(Limbs.Find("Head"))
					if(src.Injury_Head != 100)
						src.Injury_Head += Percent
						if(src.Injury_Head >= 100)
							src.Injury_Head = 100
							if(src.Critical_Head == 0)
								src.Critical_Head = 1
								src.Add/=2
								src.Magic_Potential/=2
								src << "Your head has been crushed badly, you have alot of trouble thinking straight..."
								if(M)
									view(6,src) << "<font color = red>[M] has severely crushed [src]'s head!"
								else
									view(6,src) << "<font color = red>[src]'s head has been badly crushed!"
								src.saveToLog("| [src.client.address ? (src.client.address) : "IP not found"] | ([src.x], [src.y], [src.z]) | [key_name(src)] Head has been crushed.\n")
					if(src.Injury_Head > src.Injury_Right_Arm && src.Injury_Head > src.Injury_Left_Leg && src.Injury_Head > src.Injury_Right_Leg && src.Injury_Head > src.Injury_Left_Arm)
						src.MostInjuredLimb="Head"*/
				if(Limbs.Find("Left Leg"))
					if(src.Injury_Left_Leg != 100)
						src.Injury_Left_Leg += Percent
						if(src.Injury_Left_Leg >= 100)
							src.Injury_Left_Leg = 100
							if(src.Critical_Left_Leg == 0)
								src.Critical_Left_Leg = 1
								src.StrMod/=Injury_Max
								src.Str/=Injury_Max
								src.PowMod/=Injury_Max
								src.Pow/=Injury_Max
								src.OffMod/=Injury_Max
								src.Off/=Injury_Max
								src.DefMod/=Injury_Max
								src.Def/=Injury_Max
								src.SpdMod/=Injury_Max
								view(6,src) <<output("[src]'s Left Leg is broken!","rpoutput")
								src.saveToLog("| [src.client.address ? (src.client.address) : "IP not found"] | ([src.x], [src.y], [src.z]) | [key_name(src)] Left Leg has been broken.\n")
								src.Check_Injuries()
					if(src.Injury_Left_Leg > src.Injury_Right_Arm && src.Injury_Left_Leg > src.Injury_Right_Leg && src.Injury_Left_Leg > src.Injury_Left_Arm && src.Injury_Left_Leg > src.Injury_Head)
						src.MostInjuredLimb="Left Leg"
				if(Limbs.Find("Right Leg"))
					if(src.Injury_Right_Leg != 100)
						src.Injury_Right_Leg += Percent
						if(src.Injury_Right_Leg >= 100)
							src.Injury_Right_Leg = 100
							if(src.Critical_Right_Leg == 0)
								src.Critical_Right_Leg = 1
								src.StrMod/=Injury_Max
								src.Str/=Injury_Max
								src.PowMod/=Injury_Max
								src.Pow/=Injury_Max
								src.OffMod/=Injury_Max
								src.Off/=Injury_Max
								src.DefMod/=Injury_Max
								src.Def/=Injury_Max
								src.SpdMod/=Injury_Max
								view(6,src) <<output("[src]'s Right Leg is broken!","rpoutput")
								src.saveToLog("| [src.client.address ? (src.client.address) : "IP not found"] | ([src.x], [src.y], [src.z]) | [key_name(src)] Right Leg has been broken.\n")
								src.Check_Injuries()
					if(src.Injury_Right_Leg > src.Injury_Right_Arm && src.Injury_Right_Leg > src.Injury_Left_Leg && src.Injury_Right_Leg > src.Injury_Left_Arm && src.Injury_Right_Leg > src.Injury_Head)
						src.MostInjuredLimb="Right Leg"
				if(Limbs.Find("Right Arm"))
					if(src.Injury_Right_Arm != 100)
						src.Injury_Right_Arm += Percent
						if(src.Injury_Right_Arm >= 100)
							src.Injury_Right_Arm = 100
							if(src.Critical_Right_Arm == 0)
								src.Critical_Right_Arm = 1
								src.StrMod/=Injury_Max
								src.Str/=Injury_Max
								src.PowMod/=Injury_Max
								src.Pow/=Injury_Max
								src.OffMod/=Injury_Max
								src.Off/=Injury_Max
								src.DefMod/=Injury_Max
								src.Def/=Injury_Max
								src.SpdMod/=Injury_Max
								view(6,src) <<output("[src]'s Right Arm is broken!","rpoutput")
								src.saveToLog("| [src.client.address ? (src.client.address) : "IP not found"] | ([src.x], [src.y], [src.z]) | [key_name(src)] Right Arm has been broken.\n")
								src.Check_Injuries()
					if(src.Injury_Right_Arm > src.Injury_Left_Arm && src.Injury_Right_Arm > src.Injury_Left_Leg && src.Injury_Right_Arm > src.Injury_Right_Leg && src.Injury_Right_Arm > src.Injury_Head)
						src.MostInjuredLimb="Right Arm"
				if(Limbs.Find("Left Arm"))
					if(src.Injury_Left_Arm != 100)
						src.Injury_Left_Arm += Percent
						if(src.Injury_Left_Arm >= 100)
							src.Injury_Left_Arm = 100
							if(src.Critical_Left_Arm == 0)
								src.Critical_Left_Arm = 1
								src.StrMod/=Injury_Max
								src.Str/=Injury_Max
								src.PowMod/=Injury_Max
								src.Pow/=Injury_Max
								src.OffMod/=Injury_Max
								src.Off/=Injury_Max
								src.DefMod/=Injury_Max
								src.Def/=Injury_Max
								src.SpdMod/=Injury_Max
								view(6,src) <<output("[src]'s Left Arm is broken!","rpoutput")
								src.saveToLog("| [src.client.address ? (src.client.address) : "IP not found"] | ([src.x], [src.y], [src.z]) | [key_name(src)] Left Arm has been broken.\n")
								src.Check_Injuries()
					if(src.Injury_Left_Arm > src.Injury_Right_Arm && src.Injury_Left_Arm > src.Injury_Left_Leg && src.Injury_Left_Arm > src.Injury_Right_Leg && src.Injury_Left_Arm > src.Injury_Head)
						src.MostInjuredLimb="Left Arm"
		//src.Check_Injuries()
		return

mob
	proc
		Injure_Hurt(var/Percent,var/list/Limbs)

			if(src.Limb_Res)
				var/RES = abs(src.Limb_Res)
				var/N = RES / 100 + 1
				if(src.Limb_Res > 0)
					Percent /= N
				else
					Percent *= N
				if(src.Limb_Res == 100)
					return
				if(Percent < 0)
					return
			var/list/Areas = list("Left Arm","Right Arm","Right Leg","Left Leg")
			if(src.Injury_Left_Arm == 100)
				Areas -= "Left Arm"
			if(src.Injury_Right_Arm == 100)
				Areas -= "Right Arm"
			if(src.Injury_Left_Leg == 100)
				Areas -= "Left Leg"
			if(src.Injury_Right_Leg == 100)
				Areas -= "Right Leg"
			if(Limbs.Find("All"))
				Areas += "Throat"
				Areas += "Hearing"
				Areas += "Mating Ability"
				Areas += "Sight"
				Limbs = Areas
			if(Limbs.Find("Random"))
				if(Areas.len)
					var/L = pick(Areas)
					Limbs.Add(L)
			if(Limbs == null)
				if(Areas.len)
					Limbs += pick(Areas)
			if(Limbs.Find("Tail"))
				if(src.Injury_Tail != 100)
					src.Injury_Tail += Percent
					if(src.Injury_Tail >= 100)
						src.Injury_Tail = 100
						if(src.Critical_Tail== 0)
							src.Critical_Tail = 1
							src.Tail = 0
							src.Tail_Remove()
							src << "Your tail has been removed!"
							view(6,src) <<output( "[src]'s tail was removed!","rpoutput")
							src.saveToLog("| [src.client.address ? (src.client.address) : "IP not found"] | ([src.x], [src.y], [src.z]) | [key_name(src)] Tail has been removed.\n")

			if(Limbs.Find("Sight"))
				if(src.Injury_Sight != 100)
					src.Injury_Sight += Percent
					if(src.Injury_Sight >= 100)
						src.Injury_Sight = 100
						if(src.Critical_Sight == 0)
							src.Critical_Sight = 1
							var/obj/Blindness/B = new
							B.screen_loc = "1,1 to 15,15"
							src.Blindness = B
							view(6,src) <<output("[src]'s ability to see has been severely damaged!","rpoutput")
							//src.sight = 1
							src.saveToLog("| [src.client.address ? (src.client.address) : "IP not found"] | ([src.x], [src.y], [src.z]) | [key_name(src)] Sight has been damaged.\n")
							return
			if(Limbs.Find("Mating Ability"))
				if(src.Injury_Mate != 100)
					src.Injury_Mate += Percent
					if(src.Injury_Mate >= 100)
						src.Injury_Mate = 100
						if(src.Critical_Mate == 0)
							src.Critical_Mate = 1
							view(6,src) <<output( "[src]'s ability to reproduce has been severely damaged!","rpoutput")
							src.saveToLog("| [src.client.address ? (src.client.address) : "IP not found"] | ([src.x], [src.y], [src.z]) | [key_name(src)] Mating has been damaged.\n")
			if(Limbs.Find("Throat"))
				if(src.Injury_Throat != 100)
					src.Injury_Throat += Percent
					if(src.Injury_Throat >= 100)
						src.Injury_Throat = 100
						if(src.Critical_Throat == 0)
							src.Critical_Throat = 1
							view(6,src) <<output("[src]'s ability to speak has been severely damaged!","rpoutput")
							src.saveToLog("| [src.client.address ? (src.client.address) : "IP not found"] | ([src.x], [src.y], [src.z]) | [key_name(src)] Throat has been damaged.\n")
			if(Limbs.Find("Hearing"))
				if(src.Injury_Hearing != 100)
					src.Injury_Hearing += Percent
					if(src.Injury_Hearing >= 100)
						src.Injury_Hearing = 100
						if(src.Critical_Hearing == 0)
							src.Critical_Hearing = 1
							view(6,src) <<output( "[src]'s ability to hear has been severely damaged!","rpoutput")
							src.saveToLog("| [src.client.address ? (src.client.address) : "IP not found"] | ([src.x], [src.y], [src.z]) | [key_name(src)] Hearing has been damaged.\n")

			if(Limbs.Find("Left Leg"))
				if(src.Injury_Left_Leg != 100)
					src.Injury_Left_Leg += Percent
					if(src.Injury_Left_Leg >= 100)
						src.Injury_Left_Leg = 100
						if(src.Critical_Left_Leg == 0)
							src.Critical_Left_Leg = 1
							src.StrMod/=Injury_Max
							src.Str/=Injury_Max
							src.PowMod/=Injury_Max
							src.Pow/=Injury_Max
							src.OffMod/=Injury_Max
							src.Off/=Injury_Max
							src.DefMod/=Injury_Max
							src.Def/=Injury_Max
							src.SpdMod/=Injury_Max
							view(6,src) << output("[src]'s Left Leg is broken!","rpoutput")
							src.saveToLog("| [src.client.address ? (src.client.address) : "IP not found"] | ([src.x], [src.y], [src.z]) | [key_name(src)] Left Leg has been broken.\n")
				src.Check_Injuries()
			if(Limbs.Find("Right Leg"))
				if(src.Injury_Right_Leg != 100)
					src.Injury_Right_Leg += Percent
					if(src.Injury_Right_Leg >= 100)
						src.Injury_Right_Leg = 100
						if(src.Critical_Right_Leg == 0)
							src.Critical_Right_Leg = 1
							src.StrMod/=Injury_Max
							src.Str/=Injury_Max
							src.PowMod/=Injury_Max
							src.Pow/=Injury_Max
							src.OffMod/=Injury_Max
							src.Off/=Injury_Max
							src.DefMod/=Injury_Max
							src.Def/=Injury_Max
							src.SpdMod/=Injury_Max
							view(6,src) << output("[src]'s Right Leg is broken!","rpoutput")
							src.saveToLog("| [src.client.address ? (src.client.address) : "IP not found"] | ([src.x], [src.y], [src.z]) | [key_name(src)] Right Leg has been broken.\n")
				src.Check_Injuries()
			if(Limbs.Find("Right Arm"))
				if(src.Injury_Right_Arm != 100)
					src.Injury_Right_Arm += Percent
					if(src.Injury_Right_Arm >= 100)
						src.Injury_Right_Arm = 100
						if(src.Critical_Right_Arm == 0)
							src.Critical_Right_Arm = 1
							src.StrMod/=Injury_Max
							src.Str/=Injury_Max
							src.PowMod/=Injury_Max
							src.Pow/=Injury_Max
							src.OffMod/=Injury_Max
							src.Off/=Injury_Max
							src.DefMod/=Injury_Max
							src.Def/=Injury_Max
							src.SpdMod/=Injury_Max
							view(6,src) << output("[src]'s Right Arm is broken!","rpoutput")
							src.saveToLog("| [src.client.address ? (src.client.address) : "IP not found"] | ([src.x], [src.y], [src.z]) | [key_name(src)] Right Arm has been broken.\n")
				src.Check_Injuries()
			if(Limbs.Find("Left Arm"))
				if(src.Injury_Left_Arm != 100)
					src.Injury_Left_Arm += Percent
					if(src.Injury_Left_Arm >= 100)
						src.Injury_Left_Arm = 100
						if(src.Critical_Left_Arm == 0)
							src.Critical_Left_Arm = 1
							src.StrMod/=Injury_Max
							src.Str/=Injury_Max
							src.PowMod/=Injury_Max
							src.Pow/=Injury_Max
							src.OffMod/=Injury_Max
							src.Off/=Injury_Max
							src.DefMod/=Injury_Max
							src.Def/=Injury_Max
							src.SpdMod/=Injury_Max
							view(6,src) << output("[src]'s Left Arm is broken!","rpoutput")
							src.saveToLog("| [src.client.address ? (src.client.address) : "IP not found"] | ([src.x], [src.y], [src.z]) | [key_name(src)] Left Arm has been broken.\n")
				src.Check_Injuries()
			//src.Check_Injuries()
			return

		Injure_Heal(var/Percent,var/list/Limbs)
			if(src.client)
				var/list/Areas = list("Head","Left Arm","Right Arm","Right Leg","Left Leg","Torso")
				if(Limbs.Find("All"))
					if(src.Race == "Saiyan")
						Areas += "Tail"
					Limbs = Areas
				if(Limbs.Find("Random"))
					if(src.Race == "Saiyan")
						Areas += "Tail"
				if(src.Race == "Saiyan") if(src.Injury_Tail == 0)
					Areas -= "Tail"
				if(src.Injury_Right_Arm == 0)
					Areas -= "Right Arm"
				if(src.Injury_Left_Arm == 0)
					Areas -= "Left Arm"
				if(src.Injury_Right_Leg == 0)
					Areas -= "Right Leg"
				if(src.Injury_Left_Leg == 0)
					Areas -= "Left Leg"
				if(Limbs.Find("Random"))
					if(Areas.len)
						var/L = pick(Areas)
						Limbs.Add(L)
				if(Limbs.Find("Tail"))
					//if(src.Injury_Tail > 0)
						//src.Base+=1*2*1*BPMod*Zenkai*Regeneration*(1+Senzu)*GG*Gain_Multiplier
					src.Injury_Tail -= Percent
					if(src.Injury_Tail <= 0)
						src.Injury_Tail = 0
						if(src.Critical_Tail)
							src.Critical_Tail = 0
							if(src.Age<12)
								src.Tail = 1
							src.Tail_Add()
						//	src << "The injury to your Tail seems to have completely healed now."
							src.saveToLog("| [src.client.address ? (src.client.address) : "IP not found"] | ([src.x], [src.y], [src.z]) | [key_name(src)] Tail injury has healed.\n")
				if(Limbs.Find("Left Leg"))
					//if(src.Injury_Left_Leg > 0)
						//src.Base+=1*2*1*BPMod*Zenkai*Regeneration*(1+Senzu)*GG*Gain_Multiplier
					src.Injury_Left_Leg -= Percent
					if(src.Injury_Left_Leg <= 0)
						src.Injury_Left_Leg = 0
						if(src.Critical_Left_Leg)
							src.Critical_Left_Leg = 0
							src.StrMod*=Injury_Max
							src.Str*=Injury_Max
							src.PowMod*=Injury_Max
							src.Pow*=Injury_Max
							src.OffMod*=Injury_Max
							src.Off*=Injury_Max
							src.DefMod*=Injury_Max
							src.Def*=Injury_Max
							src.SpdMod*=Injury_Max
						//	src << "The injury to your Left Leg seems to have completely healed now."
							src.saveToLog("| [src.client.address ? (src.client.address) : "IP not found"] | ([src.x], [src.y], [src.z]) | [key_name(src)] Left Leg injury has healed.\n")
				if(Limbs.Find("Right Leg"))
					//if(src.Injury_Right_Leg > 0)
						//src.Base+=1*2*1*BPMod*Zenkai*Regeneration*(1+Senzu)*GG*Gain_Multiplier
					src.Injury_Right_Leg -= Percent
					if(src.Injury_Right_Leg <= 0)
						src.Injury_Right_Leg = 0
						if(src.Critical_Right_Leg)
							src.Critical_Right_Leg = 0
							src.StrMod*=Injury_Max
							src.Str*=Injury_Max
							src.PowMod*=Injury_Max
							src.Pow*=Injury_Max
							src.OffMod*=Injury_Max
							src.Off*=Injury_Max
							src.DefMod*=Injury_Max
							src.Def*=Injury_Max
							src.SpdMod*=Injury_Max
						//	src << "The injury to your Right Leg seems to have completely healed now."
							src.saveToLog("| [src.client.address ? (src.client.address) : "IP not found"] | ([src.x], [src.y], [src.z]) | [key_name(src)] Right Leg injury has healed.\n")
				if(Limbs.Find("Right Arm"))
					//if(src.Injury_Right_Arm > 0)
						//src.Base+=1*2*1*BPMod*Zenkai*Regeneration*(1+Senzu)*GG*Gain_Multiplier
					src.Injury_Right_Arm -= Percent
					if(src.Injury_Right_Arm <= 0)
						src.Injury_Right_Arm = 0
						if(src.Critical_Right_Arm)
							src.Critical_Right_Arm = 0
							src.StrMod*=Injury_Max
							src.Str*=Injury_Max
							src.PowMod*=Injury_Max
							src.Pow*=Injury_Max
							src.OffMod*=Injury_Max
							src.Off*=Injury_Max
							src.DefMod*=Injury_Max
							src.Def*=Injury_Max
							src.SpdMod*=Injury_Max
						//	src << "The injury to your Right Arm seems to have completely healed now."
							src.saveToLog("| [src.client.address ? (src.client.address) : "IP not found"] | ([src.x], [src.y], [src.z]) | [key_name(src)] Right Arm injury has healed.\n")
				if(Limbs.Find("Left Arm"))
					//if(src.Injury_Left_Arm > 0)
						//src.Base+=1*2*1*BPMod*Zenkai*Regeneration*(1+Senzu)*GG*Gain_Multiplier
					src.Injury_Left_Arm -= Percent
					if(src.Injury_Left_Arm <= 0)
						src.Injury_Left_Arm = 0
						if(src.Critical_Left_Arm)
							src.Critical_Left_Arm = 0
							src.StrMod*=Injury_Max
							src.Str*=Injury_Max
							src.PowMod*=Injury_Max
							src.Pow*=Injury_Max
							src.OffMod*=Injury_Max
							src.Off*=Injury_Max
							src.DefMod*=Injury_Max
							src.Def*=Injury_Max
							src.SpdMod*=Injury_Max
						//	src << "The injury to your Left Arm seems to have completely healed now."
							src.saveToLog("| [src.client.address ? (src.client.address) : "IP not found"] | ([src.x], [src.y], [src.z]) | [key_name(src)] Left Arm injury has healed.\n")
			src.Check_Injuries()
			return
		Maim_Hurt(var/Percent,var/list/Limbs)
			if(src.Limb_Res)
				var/RES = abs(src.Limb_Res)
				var/N = RES / 100 + 1
				if(src.Limb_Res > 0)
					Percent /= N
				else
					Percent *= N
				if(src.Limb_Res == 100)
					return
				if(Percent < 0)
					return
			if(src.client)
				if(src.KeepsBody == 0) if(src.Dead)
					return
				var/list/Areas = list("Left Arm","Right Arm","Right Leg","Left Leg")
				if(src.Injury_Left_Arm == 100)
					Areas -= "Left Arm"
				if(src.Injury_Right_Arm == 100)
					Areas -= "Right Arm"
				if(src.Injury_Left_Leg == 100)
					Areas -= "Left Leg"
				if(src.Injury_Right_Leg == 100)
					Areas -= "Right Leg"
				if(Limbs.Find("All"))
					Areas += "Head"
					Limbs = Areas
				if(Limbs.Find("Random"))
					if(Areas.len)
						var/L = pick(Areas)
						Limbs.Add(L)
				if(Limbs == null)
					if(Areas.len)
						Limbs += pick(Areas)
				if(Limbs.Find("Tail"))
					if(src.Injury_Tail != 100)
						src.Injury_Tail += Percent
						if(src.Injury_Tail >= 100)
							src.Injury_Tail = 100
							if(src.Critical_Tail== 0)
								src.Critical_Tail = 1
								src.Tail = 0
								src.Tail_Remove()
								src << "Your tail has been removed!"
								view(6,src) <<output( "[src]'s tail! was removed!","rpoutput")
								src.saveToLog("| [src.client.address ? (src.client.address) : "IP not found"] | ([src.x], [src.y], [src.z]) | [key_name(src)] Tail has been removed.\n")
				if(Limbs.Find("Head"))
					if(src.Maim_Full==4)
						if(src.Injury_Head != 100)
							src.Injury_Head += Percent
							if(src.Injury_Head >= 100)
								src.Injury_Head = 100
								if(src.Critical_Head == 0)
									src.Critical_Head = 1
									src.Add/=2
									src.Magic_Potential/=2
									view(6,src) <<output("<font color = red>[src]'s head was torn off!","rpoutput")
									src.Death("decapitation")
									src.saveToLog("| [src.client.address ? (src.client.address) : "IP not found"] | ([src.x], [src.y], [src.z]) | [key_name(src)] Head has been torn off.\n")
				if(Limbs.Find("Left Leg"))
					if(src.Critical_Left_Leg == 1)
						if(src.Maim_Left_Leg != 100)
							src.Maim_Left_Leg += Percent
							if(src.Maim_Left_Leg >= 100)
								src.Maim_Left_Leg = 100
								if(src.CriticalMaim_Left_Leg == 0)
									src.CriticalMaim_Left_Leg = 1
									src.StrMod/=(Injury_Max*2)
									src.Str/=(Injury_Max*2)
									src.PowMod/=(Injury_Max*2)
									src.Pow/=(Injury_Max*2)
									src.OffMod/=(Injury_Max*2)
									src.Off/=(Injury_Max*2)
									src.DefMod/=(Injury_Max*2)
									src.Def/=(Injury_Max*2)
									src.SpdMod/=(Injury_Max*2)
									view(6,src) << output("[src]'s Left Leg was torn off!","rpoutput")
									if(src.Maim_Full<4)
										src.Maim_Full++
									if(src.Maim_Full>=4)
										src.Maim_Full=4
									src.saveToLog("| [src.client.address ? (src.client.address) : "IP not found"] | ([src.x], [src.y], [src.z]) | [key_name(src)] Left Leg was torn off.\n")
				if(Limbs.Find("Right Leg"))
					if(src.Critical_Right_Leg == 1)
						if(src.Maim_Right_Leg != 100)
							src.Maim_Right_Leg += Percent
							if(src.Maim_Right_Leg >= 100)
								src.Maim_Right_Leg = 100
								if(src.CriticalMaim_Right_Leg == 0)
									src.CriticalMaim_Right_Leg = 1
									src.StrMod/=(Injury_Max*2)
									src.Str/=(Injury_Max*2)
									src.PowMod/=(Injury_Max*2)
									src.Pow/=(Injury_Max*2)
									src.OffMod/=(Injury_Max*2)
									src.Off/=(Injury_Max*2)
									src.DefMod/=(Injury_Max*2)
									src.Def/=(Injury_Max*2)
									src.SpdMod/=(Injury_Max*2)
									view(6,src) << output("[src]'s Right Leg was torn off!","rpoutput")
									if(src.Maim_Full<4)
										src.Maim_Full++
									if(src.Maim_Full>=4)
										src.Maim_Full=4
									src.saveToLog("| [src.client.address ? (src.client.address) : "IP not found"] | ([src.x], [src.y], [src.z]) | [key_name(src)] Right Leg was torn off.\n")
				if(Limbs.Find("Right Arm"))
					if(src.Critical_Right_Arm == 1)
						if(src.Maim_Right_Arm != 100)
							src.Maim_Right_Arm += Percent
							if(src.Maim_Right_Arm >= 100)
								src.Maim_Right_Arm = 100
								if(src.CriticalMaim_Right_Arm == 0)
									src.CriticalMaim_Right_Arm = 1
									src.StrMod/=(Injury_Max*2)
									src.Str/=(Injury_Max*2)
									src.PowMod/=(Injury_Max*2)
									src.Pow/=(Injury_Max*2)
									src.OffMod/=(Injury_Max*2)
									src.Off/=(Injury_Max*2)
									src.DefMod/=(Injury_Max*2)
									src.Def/=(Injury_Max*2)
									src.SpdMod/=(Injury_Max*2)
									view(6,src) << output("[src]'s Right Arm was torn off!","rpoutput")
									if(src.Maim_Full<4)
										src.Maim_Full++
									if(src.Maim_Full>=4)
										src.Maim_Full=4
									src.saveToLog("| [src.client.address ? (src.client.address) : "IP not found"] | ([src.x], [src.y], [src.z]) | [key_name(src)] Right Arm was torn off.\n")
				if(Limbs.Find("Left Arm"))
					if(src.Critical_Left_Arm == 1)
						if(src.Maim_Left_Arm != 100)
							src.Maim_Left_Arm += Percent
							if(src.Maim_Left_Arm >= 100)
								src.Maim_Left_Arm = 100
								if(src.CriticalMaim_Left_Arm == 0)
									src.CriticalMaim_Left_Arm = 1
									src.StrMod/=(Injury_Max*2)
									src.Str/=(Injury_Max*2)
									src.PowMod/=(Injury_Max*2)
									src.Pow/=(Injury_Max*2)
									src.OffMod/=(Injury_Max*2)
									src.Off/=(Injury_Max*2)
									src.DefMod/=(Injury_Max*2)
									src.Def/=(Injury_Max*2)
									src.SpdMod/=(Injury_Max*2)
									view(6,src) << output("[src]'s Left Arm was torn off!","rpoutput")
									if(src.Maim_Full<4)
										src.Maim_Full++
									if(src.Maim_Full>=4)
										src.Maim_Full=4
									src.saveToLog("| [src.client.address ? (src.client.address) : "IP not found"] | ([src.x], [src.y], [src.z]) | [key_name(src)] Left Arm was torn off.\n")
			src.Check_Injuries()
			return
		Maim_Heal(var/Percent,var/list/Limbs)
			if(src.client)
				var/list/Areas = list("Head","Left Arm","Right Arm","Right Leg","Left Leg","Torso")
				if(Limbs.Find("All"))
					if(src.Race == "Saiyan")
						Areas += "Tail"
					Limbs = Areas
				if(Limbs.Find("Random"))
					if(src.Race == "Saiyan")
						Areas += "Tail"
				if(src.Race == "Saiyan") if(src.Injury_Tail == 0)
					Areas -= "Tail"
				if(src.Injury_Right_Arm == 0)
					Areas -= "Right Arm"
				if(src.Injury_Left_Arm == 0)
					Areas -= "Left Arm"
				if(src.Injury_Right_Leg == 0)
					Areas -= "Right Leg"
				if(src.Injury_Left_Leg == 0)
					Areas -= "Left Leg"
				if(Limbs.Find("Random"))
					if(Areas.len)
						var/L = pick(Areas)
						Limbs.Add(L)
				if(Limbs.Find("Tail"))
					//if(src.Injury_Tail > 0)
						//src.Base+=1*2*1*BPMod*Zenkai*Regeneration*(1+Senzu)*GG*Gain_Multiplier
					src.Injury_Tail -= Percent
					if(src.Injury_Tail <= 0)
						src.Injury_Tail = 0
						if(src.Critical_Tail)
							src.Critical_Tail = 0
							if(src.Age<12)
								src.Tail = 1
							src.Tail_Add()
						//	src << "The injury to your Tail seems to have completely healed now."
							src.saveToLog("| [src.client.address ? (src.client.address) : "IP not found"] | ([src.x], [src.y], [src.z]) | [key_name(src)] Tail injury has healed.\n")
				if(Limbs.Find("Left Leg"))
					//if(src.Injury_Left_Leg > 0)
						//src.Base+=1*2*1*BPMod*Zenkai*Regeneration*(1+Senzu)*GG*Gain_Multiplier
					src.Maim_Left_Leg -= Percent
					if(src.Maim_Left_Leg >= 100)
						src.Maim_Left_Leg = 100
						if(src.CriticalMaim_Left_Leg == 0)
							src.CriticalMaim_Left_Leg = 1
							src.StrMod*=(Injury_Max*2)
							src.Str*=(Injury_Max*2)
							src.PowMod*=(Injury_Max*2)
							src.Pow*=(Injury_Max*2)
							src.OffMod*=(Injury_Max*2)
							src.Off*=(Injury_Max*2)
							src.DefMod*=(Injury_Max*2)
							src.Def*=(Injury_Max*2)
							src.SpdMod*=(Injury_Max*2)
						//	src << "The injury to your Left Leg seems to have completely healed now."
							src.saveToLog("| [src.client.address ? (src.client.address) : "IP not found"] | ([src.x], [src.y], [src.z]) | [key_name(src)] Left Leg injury has healed.\n")
				if(Limbs.Find("Right Leg"))
					//if(src.Injury_Right_Leg > 0)
						//src.Base+=1*2*1*BPMod*Zenkai*Regeneration*(1+Senzu)*GG*Gain_Multiplier
					src.Maim_Right_Leg -= Percent
					if(src.Maim_Right_Leg >= 100)
						src.Maim_Right_Leg = 100
						if(src.CriticalMaim_Right_Leg == 0)
							src.CriticalMaim_Right_Leg = 1
							src.StrMod*=(Injury_Max*2)
							src.Str*=(Injury_Max*2)
							src.PowMod*=(Injury_Max*2)
							src.Pow*=(Injury_Max*2)
							src.OffMod*=(Injury_Max*2)
							src.Off*=(Injury_Max*2)
							src.DefMod*=(Injury_Max*2)
							src.Def*=(Injury_Max*2)
							src.SpdMod*=(Injury_Max*2)
						//	src << "The injury to your Right Leg seems to have completely healed now."
							src.saveToLog("| [src.client.address ? (src.client.address) : "IP not found"] | ([src.x], [src.y], [src.z]) | [key_name(src)] Right Leg injury has healed.\n")
				if(Limbs.Find("Right Arm"))
					//if(src.Injury_Right_Arm > 0)
						//src.Base+=1*2*1*BPMod*Zenkai*Regeneration*(1+Senzu)*GG*Gain_Multiplier
					src.Maim_Right_Arm -= Percent
					if(src.Maim_Right_Arm >= 100)
						src.Maim_Right_Arm = 100
						if(src.CriticalMaim_Right_Arm == 0)
							src.CriticalMaim_Right_Arm = 1
							src.StrMod*=(Injury_Max*2)
							src.Str*=(Injury_Max*2)
							src.PowMod*=(Injury_Max*2)
							src.Pow*=(Injury_Max*2)
							src.OffMod*=(Injury_Max*2)
							src.Off*=(Injury_Max*2)
							src.DefMod*=(Injury_Max*2)
							src.Def*=(Injury_Max*2)
							src.SpdMod*=(Injury_Max*2)
						//	src << "The injury to your Right Arm seems to have completely healed now."
							src.saveToLog("| [src.client.address ? (src.client.address) : "IP not found"] | ([src.x], [src.y], [src.z]) | [key_name(src)] Right Arm injury has healed.\n")
				if(Limbs.Find("Left Arm"))
					//if(src.Injury_Left_Arm > 0)
						//src.Base+=1*2*1*BPMod*Zenkai*Regeneration*(1+Senzu)*GG*Gain_Multiplier
					src.Maim_Left_Arm -= Percent
					if(src.Maim_Left_Arm >= 100)
						src.Maim_Left_Arm = 100
						if(src.CriticalMaim_Left_Arm == 0)
							src.CriticalMaim_Right_Leg = 1
							src.StrMod*=(Injury_Max*2)
							src.Str*=(Injury_Max*2)
							src.PowMod*=(Injury_Max*2)
							src.Pow*=(Injury_Max*2)
							src.OffMod*=(Injury_Max*2)
							src.Off*=(Injury_Max*2)
							src.DefMod*=(Injury_Max*2)
							src.Def*=(Injury_Max*2)
							src.SpdMod*=(Injury_Max*2)
						//	src << "The injury to your Left Arm seems to have completely healed now."
							src.saveToLog("| [src.client.address ? (src.client.address) : "IP not found"] | ([src.x], [src.y], [src.z]) | [key_name(src)] Left Arm injury has healed.\n")
			src.Check_Maim_Heal()
			return
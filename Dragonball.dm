obj/items/Namekian_Dragonball
	icon='dragonballs.dmi'
	desc="One of the seven magic balls. When all seven are gathered you will be granted a wish"
	hp=1.#INF
	can_pocket = 1
	stacks = -1
	mouse_over_pointer = MOUSE_ACTIVE_POINTER
	density_factor = 0
	weight = 1
	artifact = 1
	act = /obj/items/Namekian_Dragonball/proc/drop
	act_drop = /obj/items/Namekian_Dragonball/proc/drop
	appearance_flags = KEEP_TOGETHER
	var/WishPower
	proc/Active()
		overlays-='Dragon Ball Aura.dmi'
		//if(owner.setdbpass) passphrase="[owner.setdbpass]"
		if(name=="One Star Dragonball")
			icon_state="N1"

		//	pixel_x=0
		//	pixel_y=0
		if(name=="Two Star Dragonball")
			icon_state="N2"

		if(name=="Three Star Dragonball")
			icon_state="N3"
		if(name=="Four Star Dragonball")
			icon_state="N4"

		if(name=="Five Star Dragonball")
			icon_state="N5"

		if(name=="Six Star Dragonball")
			icon_state="N6"

		if(name=="Seven Star Dragonball")
			icon_state="N7"

	proc
		drop(var/mob/m,var/obj/items/i)
			if(i in m.accessing)
				m.drop(i)
	New()
		tag = name
		var/image/sel = image('fx.dmi',src,"select item",1000)
		src.img_select = sel

	Click(location,control,params)
		..()
		//Removes this item from the global Items list.
		if(items)
			if(src in items) items -= src
		params = params2list(params)
		if(params["left"])
			if(isturf(src.loc))
				usr.pickup(src)
				if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
			else if(ismob(src.loc))
				if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
				usr.item_selected = src
		else
			if(params["right"])
				if(!isturf(src.loc)) return // Only works if the ball is dropped (not held)

				var/list/nearby_balls = list()
				for(var/obj/items/Namekian_Dragonball/ball in range(2, src))
					if(ball == src) continue
					if(ball.icon_state != "sStone")
						nearby_balls += ball

				if(nearby_balls.len >= 6) // 6 others + src = 7 total
					view(5,usr) << output("<font color='yellow'>The Dragonballs begin to glow...</font>","actionoutput")
					spawn(10)
						src.Wish(usr)
				else
					usr <<output( "Not all Dragonballs are nearby or valid to wish with.","actionoutput")
	proc/Wish(mob/m)
		if(wishing) return
		if(icon_state == "sStone")
			m << "THE BALLS ARE INERT!"
			return
		if(!Home)
			m << "These Dragonballs cannot be wished with until scattered by the creator."
			return
		//if(passphrase && input("Speak the passphrase:") as text != passphrase)
		//	usr << "Incorrect passphrase."
		//	return
		wishing=1
		if(!passphrase && owner == m)
			var/pass = input("Set a passphrase for your Dragonballs:") as text
			passphrase = pass
			//usr.setdbpass = pass
			m <<output( "The passphrase '[pass]' has been set.\nSummoning Balls..","actionoutput")
		m.Summon_NDragon_Effects()
	proc/Scatter()
		overlays+='Dragon Ball Aura.dmi'
		walk_rand(src)
		step_size = 64
		spawn(10) z=Home
		sleep(100)
		walk(src,0)
		overlays-='Dragon Ball Aura.dmi'
obj/items/Earth_Dragonball
	icon='dragonballs.dmi'
	desc="One of the seven magic balls. When all seven are gathered you will be granted a wish"
	hp=1.#INF
	can_pocket = 1
	stacks = -1
	mouse_over_pointer = MOUSE_ACTIVE_POINTER
	density_factor = 0
	weight = 1
	artifact = 1
	act = /obj/items/Earth_Dragonball/proc/drop
	act_drop = /obj/items/Earth_Dragonball/proc/drop
	appearance_flags = KEEP_TOGETHER
	var/WishPower
	proc/Active()

		overlays-='Dragon Ball Aura.dmi'
		//if(owner.setdbpass) passphrase="[owner.setdbpass]"
		if(name=="One Star Dragonball")
			icon_state="E1"

		//	pixel_x=0
		//	pixel_y=0
		if(name=="Two Star Dragonball")
			icon_state="E2"

		if(name=="Three Star Dragonball")
			icon_state="E3"
		if(name=="Four Star Dragonball")
			icon_state="E4"

		if(name=="Five Star Dragonball")
			icon_state="E5"

		if(name=="Six Star Dragonball")
			icon_state="E6"

		if(name=="Seven Star Dragonball")
			icon_state="E7"

	proc
		drop(var/mob/m,var/obj/items/i)
			if(i in m.accessing)
				m.drop(i)
	New()
		tag = name
		var/image/sel = image('fx.dmi',src,"select item",1000)
		src.img_select = sel

	Click(location,control,params)
		..()
		//Removes this item from the global Items list.
		if(items)
			if(src in items) items -= src
		params = params2list(params)
		if(params["left"])
			if(isturf(src.loc))
				usr.pickup(src)
				if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
			else if(ismob(src.loc))
				if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
				usr.item_selected = src
		else
			if(params["right"])
				if(!isturf(src.loc)) return // Only works if the ball is dropped (not held)

				var/list/nearby_balls = list()
				for(var/obj/items/Earth_Dragonball/ball in range(2, src))
					if(ball == src) continue
					if(ball.icon_state != "sStone")
						nearby_balls += ball

				if(nearby_balls.len >= 6) // 6 others + src = 7 total
					view(5,usr) << output("<font color='yellow'>The Dragonballs begin to glow...</font>","actionoutput")
					spawn(10)
						src.Wish(usr)
				else
					usr <<output( "Not all Dragonballs are nearby or valid to wish with.","actionoutput")
	proc/Wish(mob/m)
		if(wishing) return
		if(icon_state == "sStone")
			m << "THE BALLS ARE INERT!"
			return
		if(!Home)
			m << "These Dragonballs cannot be wished with until scattered by the creator."
			return
		//if(passphrase && input("Speak the passphrase:") as text != passphrase)
		//	usr << "Incorrect passphrase."
		//	return
		wishing=1
		if(!passphrase && owner == m)
			var/pass = input("Set a passphrase for your Dragonballs:") as text
			passphrase = pass
			//usr.setdbpass = pass
			m <<output( "The passphrase '[pass]' has been set.\nSummoning Balls..","actionoutput")


		m.Summon_Dragon_Effects()
	proc/Scatter()
		overlays+='Dragon Ball Aura.dmi'
		walk_rand(src)
		step_size = 64
		spawn(10) z=Home
		sleep(100)
		walk(src,0)
		overlays-='Dragon Ball Aura.dmi'
/mob/proc/Summon_Dragon_Effects()
	can_move = 0
	spawn for(var/area/A in view(60,src)) A.Super_LSDarkness()

	spawn(30)
		//spawn() Super_DBLightning()
		var/obj/Quotations/B=new
		var/obj/C=new
		var/obj/effects/lightning_bolt/A=new
		spawn(1) A.loc=locate(src.x - 5, src.y + 3, src.z)
		spawn(5)
			var/obj/Dragon/Shenron/S = new(locate(src.x - 5, src.y + 3, src.z))
			S.wishes=1
			S.WishPower = src.energy_max
			S.owner = src
			C.icon='TextOptIcons.dmi'
			for(var/mob/M in view(10,usr))
				if(M.client)
					M << output("<BIG><IMG CLASS=image SRC=\ref[M.client.RenderIcon(S)] STYLE='width:64px; height:64px;' ICONSTATE='' ICONDIR=SOUTH ICONFRAME=1></BIG><font size=2 color=green>-Shenron <IMG CLASS=image SRC=\ref[B.icon] STYLE='width:32px; height:32px;' ICONSTATE='' ICONFRAME=1>says, \'Speak....your.....wish....!\'","actionoutput")

			//view(src) << "[src] has summoned Shenron!"

			S.start_wish_sequence(src)

/mob/proc/Summon_NDragon_Effects()
	can_move = 0
	spawn for(var/area/A in view(60,src)) A.Super_LSDarkness()

	spawn(30)
		var/obj/Quotations/B=new
		var/obj/C=new
		var/obj/effects/lightning_bolt/A=new
		spawn(1) A.loc=locate(src.x - 5, src.y + 3, src.z)
		spawn(5)
			var/obj/Dragon/Porunga/S = new(locate(src.x - 5, src.y + 3, src.z))
			S.wishes = 3
			S.WishPower = src.energy_max
			S.owner = src
			C.icon='TextOptIcons.dmi'
			for(var/mob/M in view(10,usr))
				if(M.client)
					M << output("<BIG><IMG CLASS=image SRC=\ref[M.client.RenderIcon(S)] STYLE='width:64px; height:64px;' ICONSTATE='' ICONDIR=SOUTH ICONFRAME=1></BIG><font size=2 color=green>-Porunga <IMG CLASS=image SRC=\ref[B.icon] STYLE='width:32px; height:32px;' ICONSTATE='' ICONFRAME=1>says, \'Speak....your.....wish....!\'","actionoutput")

			//view(src) << "[src] has summoned Shenron!"

			S.start_wish_sequence(src)
/obj/Dragon/Shenron
	icon = 'Shenron_Genesis (1).dmi'
	icon_state = "Animated"
	layer = 10000
	var/busy = 0
	var/WishPower

	proc/start_wish_sequence(mob/user)
		if(busy) return
		busy = 1
		wishing = 1

		var/list/Choices = list("Power For Someone","Increase in Strength","Increase in Endurance","Increase in Force","Increase in Resistance","Increase in Gravity","Increase in Passiveer","Increase in Intelligence","Increase in Magic","Revive", "Immortality", "Nothing")
		if(WishPower > 10000) Choices += "Restore Planet"
		top
		var/wish = input(user, "What is your wish?", "Shenron") in Choices
		switch(wish)
			if("Nothing")
				wishing = 0
				busy = 0
				user.can_move = 0
			if("Increase in Strength")
				var/mob/target = input(user, "Who shall gain this strength increase?") in players
				target.strength *= 3.50
				grant_wish_feedback(user,src)
				wishing = 0
				busy = 0
				user.can_move = 1
				scatter_all_dragonballs()
			if("Increase in Endurance")
				var/mob/target = input(user, "Who shall gain this endurance increase?") in players
				target.endurance *= 3.50
				grant_wish_feedback(user,src)
				wishing = 0
				busy = 0
				user.can_move = 1
				scatter_all_dragonballs()
			if("Increase in Force")
				var/mob/target = input(user, "Who shall gain this force increase?") in players
				target.force *= 3.50
				grant_wish_feedback(user,src)
				wishing = 0
				busy = 0
				user.can_move = 1
				scatter_all_dragonballs()
			if("Increase in Resistance")
				var/mob/target = input(user, "Who shall gain this resistance increase?") in players
				target.resistance *= 3.50
				grant_wish_feedback(user,src)
				wishing = 0
				busy = 0
				user.can_move = 1
				scatter_all_dragonballs()
			if("Increase in Passiveer")
				var/mob/target = input(user, "Who shall gain this passive point increase?") in players
				target.passive_points += 5
				grant_wish_feedback(user,src)
				wishing = 0
				busy = 0
				user.can_move = 1
				scatter_all_dragonballs()
			if("Increase in Intelligence")
				var/mob/target = input(user, "Who shall gain this intelligence increase?") in players
				target.intxp *= 2
				grant_wish_feedback(user,src)
				wishing = 0
				busy = 0
				user.can_move = 1
				scatter_all_dragonballs()
			if("Increase in Magic")
				var/mob/target = input(user, "Who shall gain this magic increase?") in players
				target.magicxp *= 2
				grant_wish_feedback(user,src)
				wishing = 0
				busy = 0
				user.can_move = 1
				scatter_all_dragonballs()
			if("Increase in Gravity")
				var/mob/target = input(user, "Who shall gain this gravity increase?") in players
				target.gravity_mastered *= 2
				grant_wish_feedback(user,src)
				wishing = 0
				busy = 0
				user.can_move = 1
				scatter_all_dragonballs()
			if("Power For Someone")
				var/mob/target = input(user, "Who shall gain power?") in players
				target.offence *= 1.25
				target.defence *= 1.25
				target.energy_max *= 1.5
				target.energy = target.energy_max
				target.psionic_power += WishPower
				grant_wish_feedback(user,src)
				wishing = 0
				busy = 0
				user.can_move = 1
				scatter_all_dragonballs()
			if("Immortality")
				user.immortal = !user.immortal
				//user.Regenerate += (user.Immortal ? 0.5 : -0.5)
				grant_wish_feedback(user,src)
				wishing = 0
				busy = 0
				user.can_move = 1
				scatter_all_dragonballs()
			if("Revive")
				var/list/dead = list()
				for(var/mob/player/p in players) if(p.dead) dead += p
				if(!dead.len)
					user << "There is no one to revive."
					goto top
				else
					var/mob/G = input("Choose who to revive.") in dead
					G.Revive()
					G.loc = user.loc
					grant_wish_feedback(user,src)
					wishing = 0
					busy = 0
					user.can_move = 1
					scatter_all_dragonballs()
			if("Restore Planet")
				var/list/destroyed = get_destroyed_planets()
				if(destroyed.len)
					var/planet = input("Which planet to restore?") in destroyed
					spawn Planet_Restore(get_planet_id(planet))
					//log_game("[key_name(user)] wished to restore [planet] with Shenron.")
					grant_wish_feedback(user,src)
					wishing = 0
					busy = 0
					user.can_move = 1
					scatter_all_dragonballs()


	proc/grant_wish_feedback(mob/user,obj/Dragon/Shenron/S)
		var/obj/Quotations/B=new
		var/obj/C=new
		C.icon='TextOptIcons.dmi'
		for(var/mob/M in view(60, user))
			if(M.client)
				M << output("<BIG><IMG CLASS=image SRC=\ref[M.client.RenderIcon(S)] STYLE='width:64px; height:64px;' ICONSTATE='' ICONDIR=SOUTH ICONFRAME=1></BIG><font size=2 color=green>-Porunga <IMG CLASS=image SRC=\ref[B.icon] STYLE='width:32px; height:32px;' ICONSTATE='' ICONFRAME=1>says, \'Your wish has been granted....\'","actionoutput")


	proc/scatter_all_dragonballs()
		for(var/obj/items/Earth_Dragonball/A) spawn A.Scatter()

/obj/Dragon/Porunga
	icon = 'Porunga_Genesis.dmi'
	icon_state = "Animated"
	layer = 10000
	var/busy = 0
	var/WishPower

	proc/start_wish_sequence(mob/user)
		if(busy) return
		busy = 1
		wishing = 1

		var/list/Choices = list("Power For Someone","Increase in Strength","Increase in Endurance","Increase in Force","Increase in Resistance","Increase in Gravity","Increase in Passiveer","Increase in Intelligence","Increase in Magic","Revive", "Immortality", "Nothing")
		if(WishPower > 10000) Choices += "Restore Planet"
		top
		var/wish = input(user, "What is your wish?", "Shenron") in Choices
		switch(wish)
			if("Nothing")
				wishing = 0
				busy = 0
				user.can_move = 0
			if("Increase in Strength")
				var/mob/target = input(user, "Who shall gain this strength increase?") in players
				target.strength *= 3.50
				grant_wish_feedback(user,src)
			if("Increase in Endurance")
				var/mob/target = input(user, "Who shall gain this endurance increase?") in players
				target.endurance *= 3.50
				grant_wish_feedback(user,src)
			if("Increase in Force")
				var/mob/target = input(user, "Who shall gain this force increase?") in players
				target.force *= 3.50
				grant_wish_feedback(user,src)
			if("Increase in Resistance")
				var/mob/target = input(user, "Who shall gain this resistance increase?") in players
				target.resistance *= 3.50
				grant_wish_feedback(user,src)
			if("Increase in Passiveer")
				var/mob/target = input(user, "Who shall gain this passive point increase?") in players
				target.passive_points += 5
				grant_wish_feedback(user,src)
			if("Increase in Intelligence")
				var/mob/target = input(user, "Who shall gain this intelligence increase?") in players
				target.intxp *= 2
				grant_wish_feedback(user,src)
			if("Increase in Magic")
				var/mob/target = input(user, "Who shall gain this magic increase?") in players
				target.magicxp *= 2
				grant_wish_feedback(user,src)
			if("Increase in Gravity")
				var/mob/target = input(user, "Who shall gain this gravity increase?") in players
				target.gravity_mastered *= 2
				grant_wish_feedback(user,src)
			if("Power For Someone")
				var/mob/target = input(user, "Who shall gain power?") in players
				target.offence *= 1.25
				target.defence *= 1.25
				target.energy_max *= 1.5
				target.energy = target.energy_max
				target.psionic_power += WishPower
				grant_wish_feedback(user,src)
				wishes-=1
			if("Immortality")
				user.immortal = !user.immortal
				//user.Regenerate += (user.Immortal ? 0.5 : -0.5)
				grant_wish_feedback(user,src)
				wishes-=1
			if("Revive")
				var/list/dead = list()
				for(var/mob/player/p in players) if(p.dead) dead += p
				if(!dead.len)
					user << "There is no one to revive."
				else
					var/mob/G = input("Choose who to revive.") in dead
					G.Revive()
					G.loc = user.loc
					grant_wish_feedback(user,src)
					wishes-=1
			if("Restore Planet")
				var/list/destroyed = get_destroyed_planets()
				if(destroyed.len)
					var/planet = input("Which planet to restore?") in destroyed
					spawn Planet_Restore(get_planet_id(planet))
					//log_game("[key_name(user)] wished to restore [planet] with Shenron.")
					grant_wish_feedback(user,src)
					wishes-=1
		if(wishes>0)
			goto top

		wishing = 0
		busy = 0
		user.can_move = 1
		scatter_all_dragonballs()

	proc/grant_wish_feedback(mob/user,obj/Dragon/Porunga/S)
		var/obj/Quotations/B=new
		var/obj/C=new
		C.icon='TextOptIcons.dmi'
		for(var/mob/M in view(60, user))
			if(M.client)
				M << output("<BIG><IMG CLASS=image SRC=\ref[M.client.RenderIcon(S)] STYLE='width:64px; height:64px;' ICONSTATE='' ICONDIR=SOUTH ICONFRAME=1></BIG><font size=2 color=green>-Porunga <IMG CLASS=image SRC=\ref[B.icon] STYLE='width:32px; height:32px;' ICONSTATE='' ICONFRAME=1>says, \'Your wish has been granted....\'","actionoutput")
		if(S.wishes<=0)
			for(var/mob/M in view(60, user))
				if(M.client)
					M << output("<BIG><IMG CLASS=image SRC=\ref[M.client.RenderIcon(S)] STYLE='width:64px; height:64px;' ICONSTATE='' ICONDIR=SOUTH ICONFRAME=1></BIG><font size=2 color=green>-Porunga <IMG CLASS=image SRC=\ref[B.icon] STYLE='width:32px; height:32px;' ICONSTATE='' ICONFRAME=1>says, \'Farewell.....\'","actionoutput")

	proc/scatter_all_dragonballs()
		for(var/obj/items/Earth_Dragonball/A) spawn A.Scatter()
/proc/get_destroyed_planets()
	var/list/planets = list()
	if(!Earth) planets += "Earth"
	if(!Namek) planets += "Namek"
	if(!Vegeta) planets += "Vegeta"
	if(!Arconia) planets += "Arconia"
	if(!Icer) planets += "Icer"
	return planets
/proc/get_planet_id(planet_name)
	switch(planet_name)
		if("Earth") return 1
		if("Namek") return 3
		if("Vegeta") return 4
		if("Arconia") return 8
		if("Icer") return 12
	return null

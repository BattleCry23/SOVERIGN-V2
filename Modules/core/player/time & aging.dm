world/proc/years()
    spawn(2700) // Wait 4.5 minutes between checks
        var/new_year = 0
        global.counter += 1


        if(global.counter >= 10)
            global.year += 0.1
            new_year = 1
        else
            global.psi_year += 0.1
        if(global.counter >=10) src << "<font color=white>Month saving in 10 seconds.</font>"
        spawn(100) // Small delay to not block the world
            if(prob(50)) spawn Respawn_Artifacts()
            for(var/mob/races/m in players)


                if(m && m.started && m.accelerated_aging == 0)
                    var/psi_realm = (m.z == 2 || m.z == 6 && global.counter < 10)
                    m.age_update(psi_realm, new_year)
                    sleep(world.tick_lag) // spreads load

        CheckClicks+=1
        if(global.counter >= 10)
            global.counter = 0
            world.Repop()
            spawn world.Save_All()

        else
            world.Save_Year()


        years() // Loop again
mob
    var/tmp/accelerated_aging = 0

    proc/accelerate_age()
        set background = 1
        if(accelerated_aging) return // already accelerating
        accelerated_aging = 1
        while(src && src.z == 23 && src.inside_hbtc) // define your HBTC z-level constant
            src.hbtc_age_alert_and_display()
            src.age_update_extra()
            src.beard_checker()
            sleep(global.hbtc_time) // 27 seconds = 10x faster than 2700
        accelerated_aging = 0

mob/proc/age_update_extra()
	set background=1
	set waitfor=0
	src.UpAge()
	if(src.aged.info_name == "Baby" && src.age >= 4)
		src.aged.info_name = "Kid"
		spawn(1) src.update_body_age()
	else if(src.aged.info_name == "Kid" && src.age_is_adult == 0 && src.age >= 13)
		src.aged.info_name = "Teen"
		spawn(1) src.update_body_age()
	else if(src.age >= 21 && src.aged.info_name != "Adult")
		src.aged.info_name = "Adult"
	LOYear=global.year
	if(occupation == "Trust Funded")
		var/monthly_income = 14 + round(year,1)
		if(rp_zenni_rate == 1)
			monthly_income = (monthly_income * 1.20)
		if(rp_zenni_rate == 2)
			monthly_income = (monthly_income * 1.40)
		if(rp_zenni_rate == 3)
			monthly_income = (monthly_income * 1.60)
		if(rp_zenni_rate == 4)
			monthly_income = (monthly_income * 1.80)
		resources += monthly_income
	else if(occupation == "Allowance")
		var/monthly_income = 7 + round(year,1)
		if(rp_zenni_rate == 1)
			monthly_income = (monthly_income * 1.20)
		if(rp_zenni_rate == 2)
			monthly_income = (monthly_income * 1.40)
		if(rp_zenni_rate == 3)
			monthly_income = (monthly_income * 1.60)
		if(rp_zenni_rate == 4)
			monthly_income = (monthly_income * 1.80)
		resources += monthly_income
	else if(occupation != "None" && occupation != "Allowance" && occupation != "Trust Funded")
		var/monthly_income = 21 + round(year,1)
		if(rp_zenni_rate == 1)
			monthly_income = (monthly_income * 1.20)
		if(rp_zenni_rate == 2)
			monthly_income = (monthly_income * 1.40)
		if(monthly_income == 3)
			monthly_income = (monthly_income * 1.60)
		if(rp_zenni_rate == 4)
			monthly_income = (monthly_income * 1.80)
		resources += monthly_income

	if(src.age >= src.oldage)
		if(!src.in_oldage)
			src.in_oldage = 1

		src.grey_hair = clamp(src.grey_hair + 1, 0, 100)
		if(src.hair)
			src.overlays -= src.hair
			src.hair.icon = src.hair_icon
			src.hair += rgb(src.grey_hair, src.grey_hair, src.grey_hair)
			spawn(1) src.redraw_appearance()
		//src<<"<span class=\"narrate\"><font color=green>Entering Month [Month*10] of Year [round(Year,0.1)]</span>"

 /*
 world/proc
	years()
		spawn(2700)
		//spawn(3600)
			var/new_year = 0
			global.counter += 1
			if(global.counter >= 10)
				global.year += 0.1
				new_year = 1
			else
				global.psi_year += 0.1



			spawn(1)
				for(var/mob/m in players)
					if(m.started)
						var/psi_realm = 0
						if(m.z == 2 || m.z == 6)
							if(global.counter < 10) psi_realm = 1
						m.age_update(psi_realm,new_year)
			if(global.counter >= 10)
				global.counter = 0
				world.Repop()
				world.Save_All()
			else world.Save_Year()
			//if(global.counter == 6)
			//	world.respawn_items()
		//	spawn(2700)//spawn(360)
			//spawn(3600)
			years()
			//spawn(1) orbit()
			*/
mob/proc/UpAge()
	if(src.has_body)
		src.age += 0.1
		if(src.in_oldage)
			src.vigour -= (src.lifespan - src.oldage) / 120
	src.age_soul += 0.1




mob
	proc
		age_update(var/psi_realm = 0, var/new_year = 0)
			set background=1
			if(new_year)
				spawn()

					age_alert_and_display()
					check_cycles +=1
					spawn src.AssignRps()
					if(judgement_bid)
						judgement_bid --

			/*if(src.has_body)
				src.age += 0.1
				if(src.in_oldage)
					src.vigour -= (src.lifespan - src.oldage) / 120
			src.age_soul += 0.1
			*/
					age_update_extra()
			src.beard_checker()
			if(src.looking_at_moon && new_year)
				spawn(1) src.oozaru_enable(src)

			// Age stage transitions


			// Old age effects


			// Resource growth from occupation
			if(src && src.occupation && new_year)
				src.resources += rand(5, 15)
				spawn(1) src.hud_inv.update_rsc(src)

			// Update year logs
			src.log_year = year
			src.log_psi_year = psi_year


	proc
		age_alert_and_display()
			set background=1
			// Only handles alert UI + animation
			var/month = round((year - round(year)) * 10)
			var/year_display = round(year)

			src.set_alert("Month [month], Year [year_display]", 'alert.dmi', "alert")
			src << "<font color=green>Entering Month [month] of Year [year_display]</font>"

			if(src.z != 2 && src.z != 6 && src.z != 12)
				src << "<font color=red>The Full moon appears!</font>"

			if(src.screen_text)
				src.screen_text.maptext = "<font size=5><center>Entering Month [month] of Year [year_display]</font>"
				animate(src.screen_text, alpha=255, time=60)
				animate(alpha=0, time=60)
	proc
		hbtc_age_alert_and_display()
			set background=1
			// Only handles alert UI + animation
			var/month = round((year - round(year)) * 10)
			var/year_display = round(year)

			src.set_alert("You grow older while inside the Hyperbolical Time Chamber.", 'alert.dmi', "alert")
			src << "You grow older while inside the Hyperbolical Time Chamber.<font color=green>(Month [month] of Year [year_display])</font>"


			if(src.screen_text)
				src.screen_text.maptext = "<font size=3><center>You grow older while inside the Hyperbolical Time Chamber.</font>"
				animate(src.screen_text, alpha=255, time=60)
				animate(alpha=0, time=60)

/*mob
	proc
		age_update(var/psi_realm = 0,var/new_year = 0)
			//set background = 1
			//set waitfor = 0
			//src.age_soul += year-src.log_year //This will be 0 if they log out straight after a month ticks over.
			//if(psi_realm) src.age_soul += psi_year-src.log_psi_year //This will be 0 if they log out straight after a month ticks over.

			if(new_year)
				src.set_alert("Month [round((year-round(year))*10)], Year [round(year)]",'alert.dmi',"alert")
				src<<"<font color=green>Entering Month [round((year-round(year))*10)], Year [round(year)]</font>"
				if(src.z != 2 && src.z != 6 && src.z != 12) src<<"<font color=red>The Full moon appears!</font>"
				if(src.screen_text)
					src.screen_text.maptext = "<font size = 5><center>Entering Month [round((year-round(year))*10)], Year [round(year)]"
					animate(src.screen_text,alpha = 255,time = 60)
					animate(alpha = 0,time = 60)

				if(src.has_body)
					src.age += 0.1

					if(src.in_oldage) src.vigour -= (src.lifespan-src.oldage)/120 //Put this one in the actual aging flow process
				src.age_soul += 0.1
				if(src.looking_at_moon)
					spawn src.oozaru_enable(src)

					//src.create_chat_entry("alerts","You are [round(src.age)] years and [round((src.age-round(src.age))*10)] months old.")
			if(src.aged.info_name == "Kid" && src.age >= 13)
				src.aged.info_name = "Teen"
				spawn src.update_body_age()
			if(src.aged.info_name == "Baby" && src.age >= 4)
				src.aged.info_name = "Kid"
				spawn src.update_body_age()
			if(src.age>=21 && src.aged.info_name != "adult") src.aged.info_name = "adult"
			if(src.age >= src.oldage)
				if(src.in_oldage == 0)
					//src << output("You are now old.","chat.system")
					src.in_oldage = 1
				src.grey_hair += 1
				src.grey_hair = clamp(src.grey_hair,0,100)
				if(src.hair)
					src.overlays -= src.hair
					src.hair.icon = src.hair_icon
					src.hair += rgb(src.grey_hair,src.grey_hair,src.grey_hair)
					spawn src.redraw_appearance()
			if(src.occupation)
				src.resources +=rand(5,15)
				spawn src.hud_inv.update_rsc(src)
			//src.check_quest_availability()
			//src << output("You are [round(src.age)] years and [round((src.age-round(src.age))*10)] months old.","chat.system")
			src.log_year = year
			src.log_psi_year = psi_year //This needs to be set too for when a player enters psi realm from mortal realms.
			//world << "Log year = [year]"
			//world << "Log psi year = [psi_year]"

			*/

		//Arrived at psi realm aged 20.5

		/*
		Logs off at year 10 in psi realms
		5 psi realm months pass
		Player logs on
		age + will be 0 for mortal world time, because they logged off between months, at log_year 10
		age + will be 5 months because they logged off at psi_year 0.5, and their log_psi_year was 0
		Player logs off
		Player logs on
		age + will be 0 for mortal world time, because they logged off between months, at log_year 10
		age + will be 0 months because they logged off at psi_year 0.5, and their log_psi_year was 0.5
		*/

		/*
		Logs off at year 10 in psi realms
		10 mortal realm years pass
		Player logs on
		age + will be 10 for mortal world time, because they logged off between months, at log_year 10
		age + will be 100 years because they logged off at psi_year 200, and their log_psi_year was 100
		Player logs off
		Player logs on
		age + will be 0 for mortal world time, because they logged off between months, at log_year 20
		age + will be 0 months because they logged off at psi_year 200, and their log_psi_year was 200
		*/

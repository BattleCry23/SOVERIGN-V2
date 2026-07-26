#define AUTOSAVE_INTERVAL 300 // Autosave interval in seconds (10 minutes)
#define AUTOSAVE_CHECK_INTERVAL 60 // Interval to check which players need to be saved (1 minute)
#define AUTOREBOOT_INTERVAL 288000 // 8 Hours


var
	AutoRebootOn = 1
	global/rebooting = 0
world/proc/Autoreboot_Procedure()
    if(AutoRebootOn==1) src<<"<b>Auto reboots activated. The server will restart itself every 8 hour(s).</b>"
    if(AutoRebootOn==0) src<<"<b>Auto reboots deactivated.</b>"
    while(1)
        sleep(AUTOREBOOT_INTERVAL) // Run continuously while the world is active
        if(AutoRebootOn==1)
            src << "<span class=\"announce\"><font color=green><b>(AUTO) Rebooting in 30 seconds!</b></font></span>"
            sleep(300)
            //world << "<span class=\"announce\"><font color=green><b><u>Saving and Rebooting World</u></b></font></span>"
              //  P.Save_Player_Data() // Save player data asynchronously
       //file("AdminLog.log")<<"[usr]([usr.key]) rebooted at [time2text(world.realtime,"Day DD hh:mm")] \n"
            rebooting = 1
            world.quick_save_players()
            sleep(1)
            Save_All()
            sleep(1)

            spawn(20)
                if(AutoRebootOn==1)


                    Reboot()
                else
                    src << "<span class=\"announce\"><font color=red><center>REBOOT STOPPED!</font></span>"
world/proc/quick_save_players()
	for(var/mob/races/m in players)
		if(m.client) if(m.can_save && m.started)
			m.Mob_Save(1)
			sleep(1)
			winset(m, null, "command=.quit")
			m.client.Del()
			sleep(world.tick_lag)

world/proc/Auto_Reboot()

	spawn() Autoreboot_Procedure()
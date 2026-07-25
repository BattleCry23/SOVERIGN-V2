
mob/var
    rp_cycle_free_time = 0
    rp_language_mastery = 0
    rp_prestige_reincarnation = 0
    rp_zenni_rate = 0         // 04
    rp_gift_discovery = 0
    rp_passive_pp_bonus = 0   // 0100 (%)

#define RP_DEFAULT 1
#define RP_RNG     2

var/global/list/IMMERSION_ITEMS = list(
    "cycle_free_time" = list(
        "name" = "Cycle Free Time",
        "cost" = 25,
        "type" = RP_DEFAULT,
        "desc" = "Removes resillience cooldowns between cycles."
    ),

    "zenni_1" = list(
        "name" = "Zenni Rate Increase I",
        "cost" = 5,
        "type" = RP_DEFAULT,
        "desc" = "+20% Zenni from monthly revenue."
    ),
    "zenni_2" = list(
        "name" = "Zenni Rate Increase II",
        "cost" = 8,
        "type" = RP_DEFAULT,
        "desc" = "+40% Zenni from monthly revenue."
    ),
    "zenni_3" = list(
        "name" = "Zenni Rate Increase III",
        "cost" = 11,
        "type" = RP_DEFAULT,
        "desc" = "+60% Zenni from monthly revenue."
    ),
    "zenni_4" = list(
        "name" = "Zenni Rate Increase IV",
        "cost" = 14,
        "type" = RP_DEFAULT,
        "desc" = "+80% Zenni from monthly revenue."
    ),
    "prestige_reincarnation" = list(
        "name" = "Prestige Reincarnation",
        "cost" = 250,
        "type" = RP_DEFAULT,
        "desc" = "Reincarnate with 50%  of your personal gains and 25%  of your stats."
    ),

    "passive_pp" = list(
        "name" = "Passive Point Increase",
        "cost" = 20,
        "type" = RP_RNG,
        "desc" = "+10% passive point gain (caps at 100%)."
    ),
    "gift_discovery" = list(
        "name" = "Gift of Discovery",
        "cost" = 15,
        "type" = RP_RNG,
        "desc" = "+5% chance to find chests while mining."
    )

)

var/global/list/IMMERSION_RNG_ACTIVE = list()

proc/roll_immersion_rng()
    set background = 1
    IMMERSION_RNG_ACTIVE.Cut()

    var/list/pool = list()
    var/random_number = rand(1,3)
    for(var/id in IMMERSION_ITEMS)
        if(IMMERSION_ITEMS[id]["type"] == RP_RNG)
            pool += id

    while(IMMERSION_RNG_ACTIVE.len < random_number && pool.len)
        var/pick_id = pick(pool)
        IMMERSION_RNG_ACTIVE += pick_id
        pool -= pick_id


    world.log << "Immersion Shop RNG rolled: [IMMERSION_RNG_ACTIVE]"



proc/immersion_item_card(mob/M, id)
    var/list/D = IMMERSION_ITEMS[id]

    return {"
    <div class='card' title='[D["desc"]]'>
        <div class='card-title'>[D["name"]]</div>
        <div class='card-cost'>Cost: [D["cost"]] RP</div>
        <a class='card-buy' href='?src=\ref[M];buy_rp=[id]'>Purchase</a>
    </div>
    "}

mob/proc/show_immersion_shop()
    var/html = {"
    <html><head>
    <style>
        body { background:#0d0d0d; color:#eee; font-family:Verdana; }
        h1 { text-align:center; color:#9ddcff; }
        .grid { display:flex; flex-wrap:wrap; justify-content:center; }
        .card {
            width:30%;
            background:#161616;
            border:2px solid #4fa3ff;
            border-radius:8px;
            padding:10px;
            margin:8px;
            text-align:center;
            transition:0.2s;
        }
        .card:hover { background:#1f1f1f; transform:scale(1.05); }
        .card-title { font-size:16px; font-weight:bold; }
        .card-cost { color:#88ffcc; margin:6px 0; }
        .card-buy {
            display:inline-block;
            padding:5px 10px;
            border:1px solid white;
            text-decoration:none;
            color:white;
        }
        .card-buy:hover { background:white; color:black; }
        .footer { text-align:center; margin-top:20px; }
        .shop-subtitle {
            text-align: center;
            margin-top: -3px;
            margin-bottom: 14px;
            font-size: 12px;
            font-style: italic;
            letter-spacing: 0.5px;
            color: rgba(255, 255, 255, 0.55);
        }
    </style>
    </head><body>

    <h1>Roleplay Shop</h1>
    <div class="shop-subtitle">*Options may vary per reboot*</div>
    <div class='grid'>
    "}

    // DEFAULT ITEMS
    for(var/id in IMMERSION_ITEMS)
        if(IMMERSION_ITEMS[id]["type"] == RP_DEFAULT)
            html += immersion_item_card(src, id)

    // RNG ITEMS
    for(var/id in IMMERSION_RNG_ACTIVE)
        html += immersion_item_card(src, id)

    html += {"
    </div>
    <div class='footer'>
        You have <b>[src.roleplay_points]</b> RP Points
    </div>
    </body></html>
    "}

    src << browse(html, "window=immersion_shop;size=720x600")


proc/grant_immersion_reward(mob/M, id)
    id = "[id]"  // force text normalization

    switch(alert(M,"Do you wish to purchase [IMMERSION_ITEMS[id]["name"]]?","","Yes","No"))
        if("Yes")
            switch(id)

                if("cycle_free_time")
                    if(M.rp_cycle_free_time) return 0
                    M.rp_cycle_free_time = 1
                    M.cycle_free_time = 25
                    M.check_cft()

                if("gift_gab")
                    if(M.rp_language_mastery) return 0
                    M.rp_language_mastery = 1

                if("prestige_reincarnation")
                    if(M.rp_prestige_reincarnation) return 0
                    M.rp_prestige_reincarnation = 1

                if("zenni_1","zenni_2","zenni_3","zenni_4")
                    var/tier = text2num(copytext(id, length(id)))
                    if(M.rp_zenni_rate >= tier) return 0
                    M.rp_zenni_rate = tier

                if("gift_discovery")
                    if(M.rp_gift_discovery) return 0
                    M.rp_gift_discovery = 1

                if("passive_pp")
                    if(M.rp_passive_pp_bonus >= 100) return 0
                    M.rp_passive_pp_bonus = min(100, M.rp_passive_pp_bonus + 10)
                    M.passive_points += M.rp_passive_pp_bonus

                else
                    world.log << "Invalid immersion id: [id]"
                    return 0

            return 1

    return 0




mob/proc/LoginAssignRps()
	set background = 1
	if(src.roleplay_rank <=1) return
	if(src.monthly_rps & src.roleplay_rank >1)
		if(CheckClicks>src.check_cycles)
			if(src<=4&&src.monthly_rps>0)
				var/bonusrps=rand(1,2)
				src<<"You have been given [bonusrps] bonus RPPs for keeping character!"
				src.roleplay_points+=bonusrps
				src.total_rpps_gained += bonusrps
				src.monthly_rps=null
				return
			if(src.monthly_rps<=10&&src.monthly_rps>4)
				var/bonusrps=rand(2,3)
				src<<"You have been given [bonusrps] bonus RPPs for keeping character!"
				src.roleplay_points+=bonusrps
				src.total_rpps_gained += bonusrps
				src.monthly_rps=null
				return
			if(src.monthly_rps<=25&&src.monthly_rps>10)
				var/bonusrps=rand(3,4)
				src<<"You have been given [bonusrps] bonus RPPs for keeping character!"
				src.roleplay_points+=bonusrps
				src.total_rpps_gained += bonusrps
				src.monthly_rps=null
				return
			if(src.monthly_rps<=45&&src.monthly_rps>25)
				var/bonusrps=rand(5,6)
				src<<"You have been given [bonusrps] bonus RPPs for keeping character!"
				src.roleplay_points+=bonusrps
				src.total_rpps_gained += bonusrps
				src.monthly_rps=null
				return
			if(src.monthly_rps<=60&&src.monthly_rps>45)
				var/bonusrps=rand(7,8)
				src<<"You have been given [bonusrps] bonus RPPs for keeping character!"
				src.roleplay_points+=bonusrps
				src.total_rpps_gained += bonusrps
				src.monthly_rps=null
				return
			if(src.monthly_rps<=75&&src.monthly_rps>60)
				var/bonusrps=rand(9,10)
				src<<"You have been given [bonusrps] bonus RPPs for keeping character!."
				src.roleplay_points+=bonusrps
				src.total_rpps_gained += bonusrps
				src.monthly_rps=null
				return
			if(src.monthly_rps<=115&&src.monthly_rps>75)
				var/bonusrps=rand(11,12)
				src<<"You have been given [bonusrps] bonus RPPs for your yearly check."
				src.roleplay_points+=bonusrps
				src.total_rpps_gained += bonusrps
				src.monthly_rps=null
				return
			if(src.monthly_rps<=130&&src.monthly_rps>115)
				var/bonusrps=rand(14,15)
				src<<"You have been given [bonusrps] bonus RPPs for keeping character!"
				src.roleplay_points+=bonusrps
				src.total_rpps_gained += bonusrps
				src.monthly_rps=null
				return
			if(src.monthly_rps<=150&&src.monthly_rps>130)
				var/bonusrps=rand(15,20)
				src<<"You have been given [bonusrps] bonus RPPs for keeping character!"
				src.roleplay_points+=bonusrps
				src.total_rpps_gained += bonusrps
				src.monthly_rps=null
				return
			if(src.monthly_rps<=200&&src.monthly_rps>150)
				var/bonusrps=rand(19,25)
				src<<"You have been given [bonusrps] bonus RPPs for keeping character!"
				src.roleplay_points+=bonusrps
				src.total_rpps_gained += bonusrps
				src.monthly_rps=null
				return
			if(src.monthly_rps<=300&&src.monthly_rps>200)
				var/bonusrps=rand(24,30)
				src<<"You have been given [bonusrps] bonus RPPs for keeping character!"
				src.roleplay_points+=bonusrps
				src.total_rpps_gained += bonusrps
				src.monthly_rps=null
				return
			if(src.monthly_rps<=300&&src.monthly_rps>200)
				var/bonusrps=rand(24,30)
				src<<"You have been given [bonusrps] bonus RPPs for keeping character!"
				src.roleplay_points+=bonusrps
				src.total_rpps_gained += bonusrps
				src.monthly_rps=null
				return
			if(src.monthly_rps<=500&&src.monthly_rps>300)
				var/bonusrps=rand(29,35)
				src<<"You have been given [bonusrps] bonus RPPs for keeping character!"
				src.roleplay_points+=bonusrps
				src.total_rpps_gained += bonusrps
				src.monthly_rps=null
				return
			if(src.monthly_rps<=750&&src.monthly_rps>500)
				var/bonusrps=rand(34,40)
				src<<"You have been given [bonusrps] bonus RPPs for keeping character!"
				src.roleplay_points+=bonusrps
				src.total_rpps_gained += bonusrps
				src.monthly_rps=null
				return
			if(src.monthly_rps<=1000&&src.monthly_rps>750)
				var/bonusrps=rand(39,45)
				src<<"You have been given [bonusrps] bonus RPPs for keeping character!."
				src.roleplay_points+=bonusrps
				src.total_rpps_gained += bonusrps
				src.monthly_rps=null
				return
			if(src.monthly_rps>=1001)
				var/bonusrps=rand(44,50)
				src<<"You have been given [bonusrps] bonus RPPs for keeping character!"
				src.roleplay_points+=bonusrps
				src.total_rpps_gained += bonusrps
				src.monthly_rps=null
				return


mob/proc/AssignRps()
	set background=1
	if(src.roleplay_rank <=1) return
	if(src.monthly_rps && src.roleplay_rank>1)
		if(src.monthly_rps<=4&&src.monthly_rps>0)
			var/bonusrps=rand(1,2)
			src<<"You have been given [bonusrps] bonus RPPs for keeping character!"
			src.roleplay_points+=bonusrps
			src.total_rpps_gained += bonusrps
			src.monthly_rps=null
			return
		if(src.monthly_rps<=10&&src.monthly_rps>4)
			var/bonusrps=rand(2,3)
			src<<"You have been given [bonusrps] bonus RPPs for keeping character!"
			src.roleplay_points+=bonusrps
			src.total_rpps_gained += bonusrps
			src.monthly_rps=null
			return
		if(src.monthly_rps<=25&&src.monthly_rps>10)
			var/bonusrps=rand(3,4)
			src<<"You have been given [bonusrps] bonus RPPs for keeping character!"
			src.roleplay_points+=bonusrps
			src.total_rpps_gained += bonusrps
			src.monthly_rps=null
			return
		if(src.monthly_rps<=45&&src.monthly_rps>25)
			var/bonusrps=rand(5,6)
			src<<"You have been given [bonusrps] bonus RPPs for keeping character!"
			src.roleplay_points+=bonusrps
			src.total_rpps_gained += bonusrps
			src.monthly_rps=null
			return
		if(src.monthly_rps<=60&&src.monthly_rps>45)
			var/bonusrps=rand(7,8)
			src<<"You have been given [bonusrps] bonus RPPs for keeping character!"
			src.roleplay_points+=bonusrps
			src.total_rpps_gained += bonusrps
			src.monthly_rps=null
			return
		if(src.monthly_rps<=75&&src.monthly_rps>60)
			var/bonusrps=rand(9,10)
			src<<"You have been given [bonusrps] bonus RPPs for keeping character!"
			src.roleplay_points+=bonusrps
			src.total_rpps_gained += bonusrps
			src.monthly_rps=null
			return
		if(src.monthly_rps<=115&&src.monthly_rps>75)
			var/bonusrps=rand(11,12)
			src<<"You have been given [bonusrps] bonus RPPs for keeping character!"
			src.roleplay_points+=bonusrps
			src.total_rpps_gained += bonusrps
			src.monthly_rps=null
			return
		if(src.monthly_rps<=130&&src.monthly_rps>115)
			var/bonusrps=rand(14,15)
			src<<"You have been given [bonusrps] bonus RPPs for keeping character!"
			src.roleplay_points+=bonusrps
			src.total_rpps_gained += bonusrps
			src.monthly_rps=null
			return
		if(src.monthly_rps<=150&&src.monthly_rps>130)
			var/bonusrps=rand(15,20)
			src<<"You have been given [bonusrps] bonus RPPs for keeping character!"
			src.roleplay_points+=bonusrps
			src.total_rpps_gained += bonusrps
			src.monthly_rps=null
			return
		if(src.monthly_rps<=200&&src.monthly_rps>150)
			var/bonusrps=rand(19,25)
			src<<"You have been given [bonusrps] bonus RPPs for keeping character!"
			src.roleplay_points+=bonusrps
			src.total_rpps_gained += bonusrps
			src.monthly_rps=null
			return
		if(src.monthly_rps<=300&&src.monthly_rps>200)
			var/bonusrps=rand(24,30)
			src<<"You have been given [bonusrps] bonus RPPs for keeping character!"
			src.roleplay_points+=bonusrps
			src.total_rpps_gained += bonusrps
			src.monthly_rps=null
			return
		if(src.monthly_rps<=300&&src.monthly_rps>200)
			var/bonusrps=rand(24,30)
			src<<"You have been given [bonusrps] bonus RPPs for keeping character!"
			src.roleplay_points+=bonusrps
			src.total_rpps_gained += bonusrps
			src.monthly_rps=null
			return
		if(src.monthly_rps<=500&&src.monthly_rps>300)
			var/bonusrps=rand(29,35)
			src<<"You have been given [bonusrps] bonus RPPs for keeping character!"
			src.roleplay_points+=bonusrps
			src.total_rpps_gained += bonusrps
			src.monthly_rps=null
			return
		if(src.monthly_rps<=750&&src.monthly_rps>500)
			var/bonusrps=rand(34,40)
			src<<"You have been given [bonusrps] bonus RPPs for keeping character!"
			src.roleplay_points+=bonusrps
			src.total_rpps_gained += bonusrps
			src.monthly_rps=null
			return
		if(src.monthly_rps<=1000&&src.monthly_rps>750)
			var/bonusrps=rand(39,45)
			src<<"You have been given [bonusrps] bonus RPPs for keeping character!"
			src.roleplay_points+=bonusrps
			src.total_rpps_gained += bonusrps
			src.monthly_rps=null
			return
		if(src.monthly_rps>=1001)
			var/bonusrps=rand(44,50)
			src<<"You have been given [bonusrps] bonus RPPs for keeping character!"
			src.roleplay_points+=bonusrps
			src.total_rpps_gained += bonusrps
			src.monthly_rps=null
			return
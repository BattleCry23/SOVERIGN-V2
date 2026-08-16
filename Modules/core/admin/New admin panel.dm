/*/mob/proc/show_admin_panel()
	var/html = {"
	<html>
	<head>
	<style>
		body {
			background: #0b0e14;
			color: #d6d6d6;
			font-family: Verdana;
		}
		h1 {
			text-align: center;
			color: #ff4444;
		}
		.section {
			border: 1px solid #333;
			border-radius: 6px;
			padding: 10px;
			margin-bottom: 12px;
			background: #141820;
		}
		.section-title {
			text-align: center;
			color: #ffaa00;
			font-weight: bold;
			margin-bottom: 8px;
		}
		.admin-btn {
			display: block;
			padding: 6px;
			margin: 4px 0;
			background: #222;
			border: 1px solid #555;
			color: white;
			text-decoration: none;
			text-align: center;
		}
		.admin-btn:hover {
			background: #444;
		}
	</style>
	</head>
	<body>

	<h1>ADMINISTRATIVE CONSOLE</h1>

	<div class='section'>
		<div class='section-title'>World Control</div>
		<a class='admin-btn' href='?src=\ref[src];admin_cmd=Announce'>Announce</a>
		<a class='admin-btn' href='?src=\ref[src];admin_cmd=Shutdown'>Shutdown</a>
	</div>

	<div class='section'>
		<div class='section-title'>Player Control</div>
		<a class='admin-btn' href='?src=\ref[src];admin_cmd=Heal'>Heal</a>
		<a class='admin-btn' href='?src=\ref[src];admin_cmd=Revive'>Revive</a>
		<a class='admin-btn' href='?src=\ref[src];admin_cmd=Kill'>Kill</a>
	</div>

	<div class='section'>
		<div class='section-title'>Items</div>
		<a class='admin-btn' href='?src=\ref[src];admin_cmd=Create_Item'>Create Item</a>
		<a class='admin-btn' href='?src=\ref[src];admin_cmd=Delete'>Delete Object</a>
	</div>

	</body>
	</html>
	"}

	src << browse(html, "window=admin_panel;size=520x600")
	*/
/mob/proc/DeleteExistingSkills()
    set background = 1
    //set waitfor = 0
    src.disable_skills()

    src.skill_wrestle = null
    src.skill_meditation = null
    src.skill_active_meditation = null
    src.skill_gather = null
    src.skill_hunt = null
    src.skill_attack = null
    src.skill_block = null
    src.skill_super_speed = null
    src.skill_remote_viewing = null
    src.skill_touch_of_death = null
    src.skill_psi_clone = null
    src.skill_mage_pot = null
    src.skill_divine_weapon = null
    src.skill_flight = null
    src.skill_shieldeyes = null
    src.skill_profusion = null
    src.skill_power_control = null
    src.skill_levitation = null
    src.skill_obfuscation = null
    src.skill_explosion = null

    src.skill_beam = null
    src.skill_stance = null
    src.skill_blast = null
    src.skill_run = null
    src.skill_charge = null
    src.skill_breathing = null
    src.skill_sense = null
    src.skill_ki_fist = null
    src.skill_ki_blade = null

    src.skill_control_oozaru = null
    src.skill_control_rampage = null

    src.skill_createdbs = null
    src.skill_sleep = null
    src.skill_study = null
    src.skill_hone = null
    src.skill_focus = null
    src.skill_invis = null
    src.skill_teleport = null
    src.skill_cyberize = null
    src.skill_lightning = null
    src.skill_lightning_storm = null

    src.skill_dig = null
    src.skill_divine_infusion = null
    src.skill_cleanse = null
    src.skill_dark_infusion = null
    src.skill_dark_petrifaction = null

    src.skill_telepathy = null
    src.skill_tk = null

    src.skill_restoration = null
    src.skill_reformation = null
    src.skill_revive = null

    src.skill_quicksilver = null
    src.skill_kaioken = null
    src.skill_kaioenjin = null

    src.skill_reprieve = null
    src.skill_majinize = null
    src.skill_mysticize = null
    // delete real skills
    for(var/obj/skills/S in src)

        qdel(S)
        sleep(world.tick_lag) // spreads load

    sleep(2) // let BYOND clean refs



    // rebuild HUD
    if(src.hud_skills)
        qdel(src.hud_skills)

        sleep(world.tick_lag) // spreads load
        var/obj/hud/menus/skills_background/skl = new
        src.hud_skills = skl
        skl.loc = src
        skl.menu_create()

    src << "Skills Deleted.(Please give it a few seconds for the hud to rebuild.)"

/mob/proc/RefreshExistingSkills()
    set background = 1
    //set waitfor = 0
    var/list/rebuild = list()
    src.disable_skills()
    // Save skill data
    for(var/obj/skills/S in src)

        if(S.type == /obj/skills/AA_Skill_Copy)
            continue

        var/list/d = list()
        d["type"] = S.type
        d["skill_lvl"] = S.skill_lvl
        d["skill_exp"] = S.skill_exp

        rebuild += list(d)

        // remove HUD clone safely
        if(S.clone)
            del(S.clone)
        sleep(world.tick_lag) // spreads load

    // delete real skills
    for(var/obj/skills/S in src)
        if(S.type != /obj/skills/AA_Skill_Copy)
            qdel(S)
            sleep(world.tick_lag) // spreads load

    sleep(2) // let BYOND clean refs

    // rebuild ONLY what player had
    for(var/list/d in rebuild)

        var/path = d["type"]

        var/obj/skills/N = new path(src)
        N.loc = src

        N.skill_lvl = d["skill_lvl"]
        N.skill_exp = d["skill_exp"]
        sleep(world.tick_lag) // spreads load

    // rebuild HUD
    if(src.hud_skills)
        qdel(src.hud_skills)

        sleep(world.tick_lag) // spreads load
        var/obj/hud/menus/skills_background/skl = new
        src.hud_skills = skl
        skl.loc = src
        skl.menu_create()

    src << "Skills refreshed.(Please give it a few seconds for the hud rebuild)"

/*mob/proc/RefreshExistingSkills()
    set background = 1
    set waitfor = 0   // critical

    var/list/rebuild = list()

    // save skills
    for(var/obj/skills/S in src)

        if(S.type == /obj/skills/AA_Skill_Copy)
            continue

        rebuild += list(list(
            "type" = S.type,
            "lvl" = S.skill_lvl,
            "exp" = S.skill_exp
        ))

        if(S.clone)
            del(S.clone)

        sleep(world.tick_lag) // spreads load

    // delete skills slowly
    for(var/obj/skills/S in src)

        if(S.type == /obj/skills/AA_Skill_Copy)
            continue

        del(S)

        sleep(world.tick_lag)

    sleep(2)

    // rebuild slowly
    for(var/list/d in rebuild)

        var/obj/skills/N = new d["type"](src)

        N.skill_lvl = d["lvl"]
        N.skill_exp = d["exp"]

        sleep(world.tick_lag)

    // rebuild HUD last
    if(src.hud_skills)

        del(src.hud_skills)

        sleep(1)

        var/obj/hud/menus/skills_background/skl = new

        src.hud_skills = skl

        skl.loc = src

        skl.menu_create()

    src << "Skills refreshed."*/
/proc/RoleplaySpyLog(message, is_emote = FALSE)
    for(var/client/C)
        if(!C) continue
        if(C.mob.key in StaffTeam)
            if(is_emote)
                C << output(message, "roleplay_spy.output_emotes")
                C << output(message, "roleplay_spy.output_general")
            else
                C << output(message, "roleplay_spy.output_general")

/mob/proc/show_admin_panel()
	var/level = src.client.admin_level
	var/html = ""

	html += {"
	<html>
	<head>
	<style>
		body { background:#0b0e14; color:#d6d6d6; font-family:Verdana; }
		h1 { text-align:center; color:#ff4444; }
		.section {
			border:1px solid #333;
			border-radius:6px;
			padding:10px;
			margin-bottom:12px;
			background:#141820;
		}
		.section-title {
			text-align:center;
			color:#ffaa00;
			font-weight:bold;
			margin-bottom:8px;
		}
		.admin-btn {
			display:block;
			padding:6px;
			margin:4px 0;
			background:#222;
			border:1px solid #555;
			color:white;
			text-decoration:none;
			text-align:center;
		}
		.admin-btn:hover { background:#444; }
	</style>
	</head>
	<body>
	<h1>ADMINISTRATIVE CONSOLE</h1>
	"}

	// =========================
	// WORLD CONTROL
	// =========================
	html += "<div class='section'><div class='section-title'>World Control</div>"
	if(level >= 1)
		var/list/world_cmds_l1 = list("Announce", "Spy_Roleplay", "Toggle_Global_OOC", "Check_CPU", "Purge_Lag")
		for(var/cmd in AdminSortCommandsByName(world_cmds_l1))
			html += AdminButton(cmd)

	if(level >= 2)
		var/list/world_cmds_l2 = list("Shutdown", "Reboot")
		for(var/cmd in AdminSortCommandsByName(world_cmds_l2))
			html += AdminButton(cmd)
	html += "</div>"

	// =========================
	// PLAYER CONTROL
	// =========================
	html += "<div class='section'><div class='section-title'>Player Control</div>"
	if(level >= 1)
		var/list/player_cmds_l1 = list(
			"Rename_Player",
			"Admin_Telepathy",
			"Heal",
			"Heal_Everything",
			"Revive",
			"Kill",
			"Knockout",
			"Observe",
			"Goto",
			"Bring",
			"Ban",
			"Unban",
			"Boot",
			"Damage_Limb",
			"Remove_Limb",
			"Restore_Limb",
			"Mute",
			"Send_To_Spawn",
			"Reset_Player_Technology",
			"Reset_Player_Inventory",
			"Refresh_Player_Skills",
			"Delete_Player_Skills",
			"Manage_Mutations",
			"Manage_Skills"
		)
		for(var/cmd in AdminSortCommandsByName(player_cmds_l1))
			html += AdminButton(cmd)


	if(level >= 2)
		var/list/player_cmds_l2 = list("Change_Icon", "Assess", "Edit_Age", "Debug_Player_Technology", "Planet_Teleport")
		for(var/cmd in AdminSortCommandsByName(player_cmds_l2))
			html += AdminButton(cmd)
	if(level >= 3)
		var/list/player_cmds_l3 = list("Manage_Technology", "Force_Transformation")
		for(var/cmd in AdminSortCommandsByName(player_cmds_l3))
			html += AdminButton(cmd)
	html += "</div>"
	// =========================
	// FIX/CLIENT
	// =========================
	html += "<div class='section'><div class='section-title'>Fixes</div>"
	if(level >= 1)
		var/list/fix_cmds_l1 = list("Clear_Known_Names", "Fix_Icon", "Fix_Screen_Offset", "Force_Resolution_Fix")
		for(var/cmd in AdminSortCommandsByName(fix_cmds_l1))
			html += AdminButton(cmd)
	if(level >=4)
		html += AdminButton("Clear_Tech_List")
	html += "</div>"


	// =========================
	// ITEMS
	// =========================
	html += "<div class='section'><div class='section-title'>Items</div>"
	if(level >= 1)
		html += AdminButton("Delete")
	if(level >= 3)
		html += AdminButton("Create_Item")
	if(level >= 4)
		html += AdminButton("Create_Custom_Icon_Object")
	html += "</div>"

	// =========================
	// ECONOMY / STATS
	// =========================
	html += "<div class='section'><div class='section-title'>Economy / Stats</div>"
	if(level >= 3)
		var/list/econ_cmds_l3 = list("Edit", "Global_CFT", "Give_RPPs", "Give_Zenni", "Increase_Stats", "Increase_HTT", "Restore_Artifacts")
		for(var/cmd in AdminSortCommandsByName(econ_cmds_l3))
			html += AdminButton(cmd)


	html += "</div>"

	// =========================
	// RANKS
	// =========================
	if(level >= 2)
		html += "<div class='section'><div class='section-title'>Ranks</div>"
		var/list/rank_cmds = list("Set_Rank", "Remove_Rank")
		if(level >= 3)
			rank_cmds += "Edit_Roleplay_Rank"
		for(var/cmd in AdminSortCommandsByName(rank_cmds))
			html += AdminButton(cmd)
		html += "</div>"

	// =========================
	// OWNER ONLY
	// =========================
	if(level >= 4)
		html += "<div class='section'><div class='section-title'>Owner</div>"
		var/list/owner_cmds = list(
			"Give_Dokuro_Coins",
			"Give_Accelerated_Gains",
			"World_Boss_Control",
			"Test_Loot_Roll",
			"Grant_Admin_Powers",
			"Remove_Admin_Powers",
			"Grant_Vote_Mute_Access",
			"Give_LSSJ",
			"Spawn_Player"
		)
		for(var/cmd in AdminSortCommandsByName(owner_cmds))
			html += AdminButton(cmd)
		html += "</div>"


	html += "</body></html>"

	src << browse(html, "window=admin_panel;size=520x720")


/proc/AdminCommandDisplayName(cmd)
	if(!cmd) return ""
	var/static/list/overrides = list(
		"Edit" = "Player Panel",
		"Spawn_Player" = "Spawn Player",
		"Check_CPU" = "Check CPU",
		"Debug_Player_Technology" = "Debug Player Tech",
		"Global_CFT" = "Global CFT",
		"Give_RPPs" = "Give RPPs",
		"Increase_HTT" = "Increase HTT",
		"Test_Loot_Roll" = "Loot Roll(TEST/DEBUG)",
		"World_Boss_Control" = "Spawn World Bosses",
		"Give_LSSJ" = "Give Legendary Gene"

	)
	if(overrides[cmd])
		return overrides[cmd]
	return replacetext("[cmd]", "_", " ")

/proc/AdminSortCommandsByName(list/L)
	if(!L || !L.len) return list()
	var/list/sorted = L.Copy()
	for(var/i = 1, i < sorted.len, i++)
		for(var/j = 1, j <= sorted.len - i, j++)
			var/a = lowertext(AdminCommandDisplayName("[sorted[j]]"))
			var/b = lowertext(AdminCommandDisplayName("[sorted[j + 1]]"))
			if(a > b)
				var/temp = sorted[j]
				sorted[j] = sorted[j + 1]
				sorted[j + 1] = temp
	return sorted

/mob/proc/AdminButton(cmd, label = null)
	if(!label || !length("[label]"))
		label = AdminCommandDisplayName(cmd)
	return "<a class='admin-btn' href='?src=\\ref[src];admin_cmd=[cmd]'>[label]</a>"

/proc/AdminSortTextAlpha(list/L)
	if(!L || !L.len) return list()
	var/list/sorted = L.Copy()
	for(var/i = 1, i < sorted.len, i++)
		for(var/j = 1, j <= sorted.len - i, j++)
			var/a = lowertext("[sorted[j]]")
			var/b = lowertext("[sorted[j + 1]]")
			if(a > b)
				var/temp = sorted[j]
				sorted[j] = sorted[j + 1]
				sorted[j + 1] = temp
	return sorted

/proc/AdminSortItemDisplayNames(list/raw_paths)
	if(!raw_paths || !raw_paths.len) return list()
	var/list/by_display_name = list()
	for(var/path in raw_paths)
		if(!path)
			continue
		var/atom/A = path
		var/display_name = initial(A.name)
		if(!display_name || !length(display_name))
			display_name = "[path]"
		if(by_display_name[display_name])
			display_name = "[display_name] ([path])"
		by_display_name[display_name] = path
	var/list/sorted_names = list()
	for(var/name in by_display_name)
		sorted_names += name
	sorted_names = AdminSortTextAlpha(sorted_names)
	var/list/sorted_choices = list()
	for(var/name in sorted_names)
		sorted_choices[name] = by_display_name[name]
	return sorted_choices

/proc/AdminGetSortedVarNames(datum/D)
	var/list/names = list()
	if(!D) return names
	for(var/v in D.vars)
		names += "[v]"
	return AdminSortTextAlpha(names)

/proc/AdminFormatVarPreview(value)
	if(isnull(value)) return "null"
	if(isnum(value) || istext(value))
		var/t = "[value]"
		if(length(t) > 64)
			t = "[copytext(t, 1, 65)]..."
		return html_encode(t)
	if(istype(value, /datum) || istype(value, /atom))
		return html_encode("[value]")
	if(islist(value))
		var/list/L = value
		return "list([L.len])"
	return html_encode("[value]")

/mob/proc/OpenAdminPlayerPanel(var/mob/choice)
	if(!src || !src.client || !choice) return
	var/level = src.client.admin_level

	var/html = ""
	html += {"
	<html>
	<head>
	<style>
		body { background:#0f131a; color:#d7dde8; font-family:Verdana; margin:8px; }
		h2 { color:#ffb347; margin:0 0 8px 0; }
		.section { border:1px solid #2c3340; border-radius:6px; padding:8px; margin-bottom:10px; background:#171d27; }
		.row { margin:4px 0; }
		.search {
			width:100%; box-sizing:border-box; margin:6px 0 8px 0; padding:6px 8px;
			border:1px solid #445065; border-radius:4px; background:#121a24; color:#d7dde8;
		}
		a.btn {
			display:inline-block; margin:2px 6px 2px 0; padding:5px 8px;
			border:1px solid #4a5568; border-radius:4px; text-decoration:none;
			color:#f3f6fb; background:#232b39;
		}
		a.btn:hover { background:#2d3748; }
		table { width:100%; border-collapse:collapse; font-size:11px; }
		th, td { border:1px solid #2b3442; padding:4px 6px; text-align:left; }
		th { background:#202938; color:#ffd27f; }
		.small { color:#9aa6ba; font-size:11px; }
	</style>
	<script type='text/javascript'>
		function filterVarRows(inputId, rowClass) {
			var input = document.getElementById(inputId);
			if(!input) return;
			var query = input.value.toLowerCase();
			var rows = document.getElementsByClassName(rowClass);
			for(var i = 0; i < rows.length; i++) {
				var row = rows.item(i);
				var name = row.getAttribute('data-var');
				if(!name) name = '';
				row.style.display = (query === '' || name.indexOf(query) !== -1) ? '' : 'none';
			}
		}
	</script>
	</head>
	<body>
	"}

	html += "<h2>Player Panel - [choice]</h2>"
	html += "<div class='small'>Key: [choice.key] | ckey: [choice.ckey] | admin level: [choice.client ? choice.client.admin_level : 0]</div>"

	html += "<div class='section'>"
	html += "<div class='row'><b>Quick Actions</b></div>"
	html += "<a class='btn' href='byond://?command=edit;target=\\ref[choice];type=view;'>Mob VV View</a>"
	html += "<a class='btn' href='byond://?command=edit;target=\\ref[choice];type=edit;'>Mob VV Edit</a>"
	if(level >= 1)
		html += "<a class='btn' href='byond://?src=\\ref[src];admin_panel_action=Rename_Player;target=\\ref[choice];target_ckey=[choice.ckey]'>Rename Player</a>"
		html += "<a class='btn' href='byond://?src=\\ref[src];admin_panel_action=Heal;target=\\ref[choice];target_ckey=[choice.ckey]'>Heal</a>"
		html += "<a class='btn' href='byond://?src=\\ref[src];admin_panel_action=Heal_Everything;target=\\ref[choice];target_ckey=[choice.ckey]'>Heal Everything</a>"
		html += "<a class='btn' href='byond://?src=\\ref[src];admin_panel_action=Revive;target=\\ref[choice];target_ckey=[choice.ckey]'>Revive</a>"
		html += "<a class='btn' href='byond://?src=\\ref[src];admin_panel_action=Kill;target=\\ref[choice];target_ckey=[choice.ckey]'>Kill</a>"
		html += "<a class='btn' href='byond://?src=\\ref[src];admin_panel_action=Knockout;target=\\ref[choice];target_ckey=[choice.ckey]'>Knockout</a>"
		html += "<a class='btn' href='byond://?src=\\ref[src];admin_panel_action=Observe;target=\\ref[choice];target_ckey=[choice.ckey]'>Observe</a>"
		html += "<a class='btn' href='byond://?src=\\ref[src];admin_panel_action=Send_To_Spawn;target=\\ref[choice];target_ckey=[choice.ckey]'>Send To Spawn</a>"
	if(level >= 2)
		html += "<a class='btn' href='byond://?src=\\ref[src];admin_panel_action=Change_Icon;target=\\ref[choice];target_ckey=[choice.ckey]'>Change Icon</a>"
	html += "<a class='btn' href='byond://?src=\\ref[src];admin_panel_action=Edit_Age;target=\\ref[choice];target_ckey=[choice.ckey]'>Edit Age</a>"
	html += "<a class='btn' href='byond://?src=\\ref[src];admin_panel_action=Edit_Roleplay_Rank;target=\\ref[choice];target_ckey=[choice.ckey]'>Edit RP Rank</a>"
	if(level >= 4)
		html += "<a class='btn' href='byond://?src=\\ref[src];admin_panel_action=Grant_Vote_Mute_Access;target=\\ref[choice];target_ckey=[choice.ckey]'>Grant Vote Mute Access</a>"
		html += "<a class='btn' href='byond://?src=\\ref[src];admin_panel_action=Grant_Admin_Powers;target=\\ref[choice];target_ckey=[choice.ckey]'>Grant Admin Powers</a>"
		html += "<a class='btn' href='byond://?src=\\ref[src];admin_panel_action=Remove_Admin_Powers;target=\\ref[choice];target_ckey=[choice.ckey]'>Remove Admin Powers</a>"
		html += "<a class='btn' href='byond://?src=\\ref[src];admin_panel_action=Give_LSSJ;target=\\ref[choice];target_ckey=[choice.ckey]'>Give Legendary Gene</a>"
	if(choice.client)
		html += "<a class='btn' href='byond://?command=edit;target=\\ref[choice.client];type=view;'>Client VV View</a>"
		html += "<a class='btn' href='byond://?command=edit;target=\\ref[choice.client];type=edit;'>Client VV Edit</a>"
	html += "</div>"

	var/list/mob_vars = AdminGetSortedVarNames(choice)
	html += "<div class='section'><div class='row'><b>Mob Vars (sorted)</b></div>"
	html += "<input id='mob_var_filter' class='search' type='text' placeholder='Search mob vars...' onkeyup=\"filterVarRows('mob_var_filter','mob-var-row')\">"
	html += "<table><tr><th>Var</th><th>Preview</th><th>Action</th></tr>"
	for(var/v in mob_vars)
		var/preview = AdminFormatVarPreview(choice.vars[v])
		var/encoded_var = url_encode("[v]")
		html += "<tr class='mob-var-row' data-var='[lowertext("[v]")]'><td>[v]</td><td>[preview]</td><td><a class='btn' href='byond://?src=\\ref[src];admin_panel_action=Edit_Specific_Var;target=\\ref[choice];var_name=[encoded_var]'>Edit Var</a></td></tr>"
	html += "</table></div>"

	if(choice.client)
		var/list/client_vars = AdminGetSortedVarNames(choice.client)
		html += "<div class='section'><div class='row'><b>Client Vars (sorted)</b></div>"
		html += "<input id='client_var_filter' class='search' type='text' placeholder='Search client vars...' onkeyup=\"filterVarRows('client_var_filter','client-var-row')\">"
		html += "<table><tr><th>Var</th><th>Preview</th><th>Action</th></tr>"
		for(var/v in client_vars)
			var/preview = AdminFormatVarPreview(choice.client.vars[v])
			var/encoded_var = url_encode("[v]")
			html += "<tr class='client-var-row' data-var='[lowertext("[v]")]'><td>[v]</td><td>[preview]</td><td><a class='btn' href='byond://?src=\\ref[src];admin_panel_action=Edit_Specific_Var;target=\\ref[choice.client];var_name=[encoded_var]'>Edit Var</a></td></tr>"
		html += "</table></div>"

	html += "</body></html>"
	src << browse(html, "window=admin_player_panel;size=980x700")

/mob/proc/AdminEditSpecificVar(var/datum/target, var/var_name)
	if(!target || !var_name)
		src << "Missing target or variable name."
		return 0
	var_name = "[var_name]"
	if(!(var_name in target.vars))
		for(var/v in target.vars)
			if(lowertext("[v]") == lowertext(var_name))
				var_name = "[v]"
				break
		if(!(var_name in target.vars))
			src << "That variable is no longer available."
			return 0

	var/current = target.vars[var_name]
	var/new_value = null

	if(isnum(current))
		new_value = input(src, "Set [var_name] on [target].", "Edit Var", current) as null|num
	else if(istext(current) || isnull(current))
		new_value = input(src, "Set [var_name] on [target].", "Edit Var", current) as null|text
	else if(isicon(current))
		new_value = input(src, "Set [var_name] on [target].", "Edit Var") as null|icon
	else if(isfile(current))
		new_value = input(src, "Set [var_name] on [target].", "Edit Var") as null|file
	else if(ispath(current))
		new_value = input(src, "Set [var_name] on [target].", "Edit Var", current) as null|text
		if(!isnull(new_value))
			new_value = text2path(new_value)
	else
		new_value = input(src, "Set [var_name] on [target].", "Edit Var", current) as null|text
		if(!isnull(new_value))
			if(isnum(text2num(new_value)))
				new_value = text2num(new_value)
			else if(istext(current) || isnull(current))
				new_value = "[new_value]"

	if(isnull(new_value))
		return 0

	target.vars[var_name] = new_value
	world.log << "(Admin Log): [src.client.admin_name] edited [var_name] on [target]"
	return 1

/mob/proc/RunAdminPanelAction(var/action, var/datum/target, var/var_name = null)
	if(!(src.key in StaffTeam))
		src << "Access denied."
		return
	if(!target) return
	var/level = src.client ? src.client.admin_level : 0
	var/mob/choice = ismob(target) ? target : null

	switch(action)
		if("Edit_Specific_Var")
			if(level < 2)
				src << "Access denied."
				return
			if(!src.AdminEditSpecificVar(target, var_name))
				return
			return

		if("Rename_Player")
			if(level < 1)
				src << "Access denied."
				return
			var/newname = input(src, "What will be their new name?", "Rename Player", choice.name) as null|text
			if(!newname) return
			if(alert(src, "Are you sure you wish rename [choice] to [newname]?", "Rename Player", "Yes", "No") != "Yes")
				return
			choice.fullname = newname
			choice.name = newname
			choice.real_name = newname
			world.log << "(Admin Log):[choice] name was changed to [newname] by [usr.client.admin_name]"
			return

		if("Boot")
			if(level < 1)
				src << "Access denied."
				return
			if(!choice || !choice.client)
				src << "That player is not currently connected."
				return
			world << "[choice] was booted."
			choice.client.images = null
			spawn(10) winset(choice, null, "command=.quit")
			choice.client.Del()
			world.log << "(Admin Log): [src.client.admin_name] [src] booted [choice]"
			return

		if("Heal")
			if(level < 1)
				src << "Access denied."
				return
			if(choice.percent_health <= 1 || choice.koed || choice.icon_state == "KO")
				choice.KO(0,1)
			sleep(1)
			choice.percent_health = 100
			choice.refresh_vital_bars(TRUE)
			choice.stunned = 0
			choice.stunned_pending = 0
			world.log << "(Admin Log): [src.client.admin_name] healed [choice]"
			return

		if("Heal_Everything")
			if(level < 1)
				src << "Access denied."
				return
			if(choice.koed || choice.icon_state == "KO" || choice.percent_health <= 1)
				choice.KO(0,1)
			sleep(1)
			choice.percent_health = 100
			choice.thirst = 99
			choice.hunger = 99
			choice.toxicity = 0
			choice.restedness = 99
			choice.stunned = 0
			choice.stunned_pending = 0
			choice.refresh_vital_bars(TRUE)
			if(choice.heal_all_limbs())
				choice << "Your [choice] has been fully healed by an admin."
			world.log << "(Admin Log): [src.client.admin_name] healed everything of [choice]"
			return

		if("Revive")
			if(level < 1)
				src << "Access denied."
				return
			if(!choice.dead) return
			choice.Revive()
			choice.percent_health = 100
			choice.energy = choice.energy_max
			choice.thirst = 99
			choice.hunger = 99
			choice.restedness = 99
			choice.toxicity = 0
			choice.disable_skills()
			choice.check_glow_planes()
			world.log << "(Admin Log): [src.client.admin_name] revived [choice]"
			return

		if("Kill")
			if(level < 1)
				src << "Access denied."
				return
			if(!choice.dead)
				choice.KO()
				sleep(2)
				choice.Death("Admin Killed")
			else
				src.set_alert("[choice] is already dead.",'alert.dmi',"alert")
			world.log << "(Admin Log): [src.client.admin_name] killed [choice]"
			return

		if("Knockout")
			if(level < 1)
				src << "Access denied."
				return
			choice.KO()
			world.log << "(Admin Log): [src.client.admin_name] KO'd [choice]"
			return

		if("Observe")
			if(level < 1)
				src << "Access denied."
				return
			src.client.perspective = EYE_PERSPECTIVE | EDGE_PERSPECTIVE
			src.client.eye = choice
			world.log << "(Admin Log): [src.client.admin_name] observed [choice]"
			return

		if("Send_To_Spawn")
			if(level < 1)
				src << "Access denied."
				return
			if(alert(src, "Are you sure you want to send them to their spawn point?", "", "Yes", "No") != "Yes")
				return
			switch(choice.home_planet)
				if("Icer")
					choice.loc = locate(450/rand(1,5),450/rand(1,5),9)
				if("Namek")
					choice.loc = locate(450/rand(1,5),450/rand(1,5),4)
				if("Vegeta")
					choice.loc = locate(450/rand(1,5),450/rand(1,5),10)
				if("Earth")
					choice.loc = locate(450/rand(1,5),450/rand(1,5),1)
				if("Hell")
					choice.loc = locate(450/rand(1,5),450/rand(1,5),6)
				if("Heaven")
					choice.loc = locate(450/rand(1,5),450/rand(1,5),11)
				if("Checkpoint")
					choice.loc = locate(130,449,2)
			src << "[choice] was sent to their home planet([choice.home_planet])"
			if(choice.in_space_ship) choice.in_space_ship = 0
			if(choice.in_space_pod) choice.in_space_pod = 0
			return

		if("Grant_Vote_Mute_Access")
			if(level < 4)
				src << "Only owner-level admins can grant vote mute access."
				return
			if(choice.has_vote_mute >= 1)
				src << "[choice] already has vote mute access!"
				return
			choice.has_vote_mute = 1
			choice << "<b>You were granted access to Vote Mute. (use /votem to  start a vote)</b>"
			src << "You granted them access to Vote Mute!"
			world.log << "(Admin Log): [src.client.admin_name] gave [choice] vote mute"
			return

		if("Grant_Admin_Powers")
			if(level < 4)
				src << "Only owner-level admins can grant admin powers."
				return
			if(!choice.client) return
			if(choice == src)
				src << "You cannot change your own admin powers with this command."
				return
			var/target_admin_level = choice.client.admin_level
			if(target_admin_level >= level)
				src << "You cannot modify an admin with an equal or higher level than yours."
				return
			var/list/level_options = list()
			for(var/i = 1, i < level, i++)
				level_options += i
			if(!level_options.len)
				src << "No grantable admin levels are available for your account."
				return
			var/selected_level = input(src, "Select admin level for [choice]:", "Grant Admin Powers") as null|anything in level_options
			if(isnull(selected_level)) return
			var/new_level = isnum(selected_level) ? round(selected_level) : round(text2num("[selected_level]"))
			if(new_level < 1 || new_level >= level)
				src << "Invalid admin level selected."
				return
			if(alert(src, "Grant admin level [new_level] to [choice]?", "Grant Admin Powers", "Yes", "No") != "Yes")
				return
			choice.client.admin_level = new_level
			choice.service_lvl = new_level
			if(!(choice.key in CodedStaff))
				CodedStaff += "[choice.key]"
			if(!(choice.key in StaffTeam))
				StaffTeam += "[choice.key]"
			if(!choice.client.admin_name || choice.client.admin_name == "Admin White")
				choice.client.admin_name = "[choice.key]"
			save_admin_profile(choice.client)
			choice << "Your admin powers were granted by [src.client.admin_name]. Level: [new_level]."
			src << "Granted admin powers to [choice] at level [new_level]."
			world << output("<font color=yellow>(Admin Log): [src] granted admin level [new_level] to [choice]</font>","rpspy.output2")
			world.log << "(Admin Log): [src.client.admin_name] granted admin level [new_level] to [choice]"
			return

		if("Remove_Admin_Powers")
			if(level < 4)
				src << "Only owner-level admins can remove admin powers."
				return
			if(!choice.client) return
			if(choice == src)
				src << "You cannot remove your own admin powers with this command."
				return
			var/target_admin_level = choice.client.admin_level
			if(target_admin_level >= level)
				src << "You cannot modify an admin with an equal or higher level than yours."
				return
			if(target_admin_level <= 0 && !(choice.key in CodedStaff) && !(choice.key in StaffTeam))
				src << "[choice] does not currently have admin powers."
				return
			if(alert(src, "Remove all admin powers from [choice]?", "Remove Admin Powers", "Yes", "No") != "Yes")
				return
			choice.client.admin_level = 0
			choice.service_lvl = 0
			StaffTeam -= "[choice.key]"
			CodedStaff -= "[choice.key]"
			save_admin_profile(choice.client)
			choice << "Your admin powers were removed by [src.client.admin_name]."
			src << "Removed admin powers from [choice]."
			world << output("<font color=yellow>(Admin Log): [src] removed admin powers from [choice]</font>","rpspy.output2")
			world.log << "(Admin Log): [src.client.admin_name] removed admin powers from [choice]"
			return

		if("Give_LSSJ")
			if(level < 4)
				src << "Only owner-level admins can give the Legendary Gene."
				return
			if(choice.race == "Saiyan" || istype(choice, /mob/races/Saiyan))
				choice.apply_A_type_mutation()
				choice << "You were transformed into a LSSJ spawn by [src.client.admin_name]."
				src << "You successfully transformed [choice] into a LSSJ spawn."
				world.log << "(Admin Log): [src.client.admin_name] transformed [choice] into LSSJ!"
			else
				src << "[choice] is not a Saiyan!"
			return

		if("Change_Icon")
			if(level < 2)
				src << "Access denied."
				return
			var/newicon = input(src, "Select icon file") as icon|null
			if(!newicon) return
			choice.icon = newicon
			world.log << "(Admin Log):[choice] icon was changed by [usr.client.admin_name]"
			return

		if("Edit_Age")
			if(level < 2)
				src << "Access denied."
				return
			var/age = input(src, "Physical age?", "Edit Age", choice.age) as null|num
			if(isnull(age)) return
			var/soul = input(src, "Soul age?", "Edit Age", choice.age_soul) as null|num
			if(isnull(soul)) return
			choice.age = age
			choice.age_soul = soul
			choice << "Your age was changed by an admin."
			choice.update_body_age()
			choice.beard_checker()
			world.log << "(Admin Log): [src.client.admin_name] edited age for [choice] -> age:[age], soul:[soul]"
			return

		if("Edit_Roleplay_Rank")
			if(level < 3)
				src << "Access denied."
				return
			var/amount = input(src, "What rank are you making them?\n\n1: Rank F\n2: Rank E\n3: Rank D\n4: Rank C\n5: Rank B\n6: Rank A\n7: Rank S\n8: Rank SS\n9: Rank SSS", "Edit RP Rank") as null|num
			if(isnull(amount)) return
			choice.give_roleplayrank(amount)
			choice << "Your RP Rank was adjusted by admins!"
			world.log << "(Admin Log): [src.client.admin_name] edited roleplay rank for [choice] -> [amount]"
			return

		if("Debug_Player_Technology")
			if(level < 2)
				src << "Access denied."
				return
			var/mob/races/M_debug = choice
			if(!M_debug)
				src << "This action requires a race player target."
				return
			src << "---- TECH DEBUG FOR [M_debug] ----"
			for(var/obj/items/tech/T_debug in global.tech)
				if(!T_debug) continue
				var/state_debug = "LOCKED"
				if(M_debug.tech_unlocked[T_debug.list_pos] == T_debug.type)
					state_debug = "UNLOCKED"
				src << "[T_debug.name] | Needed INTXP: [T_debug.needed_qp] | State: [state_debug]"
			return

		if("Manage_Technology")
			if(level < 3)
				src << "Access denied."
				return
			var/mob/races/M_tech = choice
			if(!M_tech)
				src << "This action requires a race player target."
				return
			var/list/options_tech = list()
			for(var/obj/items/tech/T_manage in global.tech)
				if(!T_manage) continue
				var/status_manage = "LOCKED"
				if(M_tech.tech_unlocked[T_manage.list_pos] == T_manage.type)
					status_manage = "UNLOCKED"
				options_tech["[T_manage.name] ([status_manage])"] = T_manage
			var/choice_tech = input(src, "Select a tech to manage for [M_tech].", "Tech Manager") as null|anything in options_tech
			if(!choice_tech) return
			var/obj/items/tech/T_selected = options_tech[choice_tech]
			if(!T_selected) return
			var/action_tech = input(src, "What do you want to do with [T_selected.name]?", "Tech Action") as null|anything in list("Add Tech", "Remove Tech", "Recheck Unlock Logic", "Cancel")
			if(!action_tech || action_tech == "Cancel") return
			if(action_tech == "Add Tech")
				M_tech.tech_unlocked[T_selected.list_pos] = T_selected.type
				T_selected.lvl_up_tech(M_tech)
				M_tech << "[src] ADMIN added tech [T_selected.name] to [M_tech]."
			if(action_tech == "Remove Tech")
				M_tech.tech_unlocked[T_selected.list_pos] = null
				M_tech << "[src] ADMIN removed tech [T_selected.name] from [M_tech]."
			if(action_tech == "Recheck Unlock Logic")
				T_selected.lvl_up_tech(M_tech)
				M_tech << "[src] ADMIN forced tech check for [T_selected.name] on [M_tech]."
			spawn()
				tech_unlocking(M_tech)
			return

		if("Reset_Player_Inventory")
			if(level < 1)
				src << "Access denied."
				return
			var/mob/races/M_inv = choice
			if(!M_inv)
				src << "This action requires a race player target."
				return
			if(alert(src, "Reset and rebuild [M_inv]'s inventory?", "Inventory Reset", "Yes", "No") != "Yes")
				return
			var/list/valid_items = list()
			for(var/obj/items/I in M_inv)
				if(I && I.can_pocket)
					valid_items += I
			for(var/i = 1, i <= 48, i++)
				M_inv.inv[i] = null
			var/slot = 1
			for(var/obj/I_valid in valid_items)
				if(slot > 48)
					break
				if(!I_valid) continue
				I_valid.slot = slot
				I_valid.loc = M_inv
				M_inv.inv[slot] = I_valid
				if(!(global.inv_slot in I_valid.vis_contents))
					I_valid.vis_contents += global.inv_slot
				slot++
			for(var/obj/items/I_orphan in M_inv)
				if(!(I_orphan in valid_items))
					del(I_orphan)
			M_inv.item_selected = null
			M_inv.mouse_down = null
			M_inv.mouse_over = null
			M_inv.refresh_inv()
			src << "[M_inv]'s inventory has been rebuilt."
			M_inv << "Your inventory has been rebuilt by an admin to fix corrupted slots."
			return

		if("Manage_Skills")
			if(level < 1)
				src << "Access denied."
				return
			var/action_skill = alert(src, "What action?", "Skill Manager", "Give", "Take", "Cancel")
			if(action_skill == "Cancel" || !action_skill) return
			var/list/skills_manage = list()
			if(action_skill == "Give")
				for(var/skill_type in typesof(/obj/skills))
					if(skill_type == /obj/skills || skill_type == /obj/skills/AA_Skill_Copy) continue
					var/info_name = initial(skill_type:info_name)
					if(!info_name || !length("[info_name]")) continue
					var/already_has = 0
					for(var/obj/skills/existing_skill in choice)
						if(existing_skill.type == skill_type)
							already_has = 1
							break
					if(!already_has)
						skills_manage["[info_name] ([skill_type])"] = skill_type
				skills_manage = sort_list(skills_manage)
				if(!skills_manage.len)
					src << "[choice] has no available skills to give."
					return
				var/skill_choice = input(src, "Select skill:", "Give Skill") as null|anything in skills_manage
				if(!skill_choice) return
				var/skill_type_choice = skills_manage[skill_choice]
				if(!skill_type_choice) return
				var/obj/skills/skill_add = new skill_type_choice(choice)
				if(!skill_add) return
				skill_add.loc = choice
				src << "Gave [skill_choice] to [choice]."
				choice << "Admin gave you skill: [skill_choice]"
			if(action_skill == "Take")
				for(var/obj/skills/skill_existing in choice)
					if(!skill_existing) continue
					if(skill_existing.type == /obj/skills/AA_Skill_Copy) continue
					if(!skill_existing.info_name || !length("[skill_existing.info_name]")) continue
					skills_manage["[skill_existing.info_name] ([skill_existing.type])"] = skill_existing
				if(!skills_manage.len)
					src << "[choice] has no removable skills."
					return
				skills_manage = sort_list(skills_manage)
				var/skill_choice_remove = input(src, "Select skill to remove:", "Remove Skill") as null|anything in skills_manage
				if(!skill_choice_remove) return
				var/obj/skills/skill_remove = skills_manage[skill_choice_remove]
				if(!skill_remove) return
				if(skill_remove.active)
					choice.mouse_dir = "left"
					skill_remove.Click()
					choice.mouse_dir = null
				if(choice.current_attack == skill_remove) choice.current_attack = null
				if(choice.active_attack == skill_remove) choice.active_attack = null
				for(var/v in choice.vars)
					if(choice.vars[v] == skill_remove)
						choice.vars[v] = null
				choice.contents -= skill_remove
				qdel(skill_remove)
				src << "Removed [skill_choice_remove] from [choice]."
				choice << "Admin removed your skill: [skill_choice_remove]"
			return

		if("Delete_Player_Skills")
			if(level < 1)
				src << "Access denied."
				return
			if(alert(src, "Delete all existing skills for [choice]?", "Skill Refresh", "Yes", "No") != "Yes")
				return
			choice.DeleteExistingSkills()
			src << "[choice]'s skills were deleted."
			return

		if("Refresh_Player_Skills")
			if(level < 1)
				src << "Access denied."
				return
			if(alert(src, "Refresh all existing skills for [choice]?", "Skill Refresh", "Yes", "No") != "Yes")
				return
			choice.RefreshExistingSkills()
			src << "[choice]'s skills were refreshed."
			return

		if("Manage_Mutations")
			if(level < 1)
				src << "Access denied."
				return
			var/action_mut = alert(src, "What action?", "Mutation Manager", "Give", "Take", "Cancel")
			if(action_mut == "Cancel" || !action_mut) return
			var/list/mutations_manage = list()
			if(action_mut == "Give")
				for(var/mut_type in typesof(/mutations/))
					if(mut_type == /mutations) continue
					var/mutations/mut_new = new mut_type()
					if(!mut_new || !mut_new.info_name) continue
					mutations_manage["[mut_new.info_name] ([mut_type])"] = mut_type
				mutations_manage = sort_list(mutations_manage)
				if(!mutations_manage.len)
					src << "[choice] has no available mutations to give."
					return
				var/mutation_choice = input(src, "Select mutation:", "Give Mutation") as null|anything in mutations_manage
				if(!mutation_choice) return
				var/mut_type_choice = mutations_manage[mutation_choice]
				if(!mut_type_choice) return
				var/mutations/mut_add = new mut_type_choice()
				if(!mut_add) return
				mut_add.activate(choice)
				choice.mutations += mut_add
				src << "Gave [mutation_choice] to [choice]."
				choice << "Admin gave you mutation: [mutation_choice]"
			if(action_mut == "Take")
				for(var/mutations/mut_existing in choice.mutations)
					if(!mut_existing) continue
					mutations_manage[mut_existing.info_name] = mut_existing
				if(!mutations_manage.len)
					src << "[choice] has no mutations."
					return
				mutations_manage = sort_list(mutations_manage)
				var/mutation_choice_remove = input(src, "Select mutation to remove:", "Remove Mutation") as null|anything in mutations_manage
				if(!mutation_choice_remove) return
				var/mutations/mut_remove = mutations_manage[mutation_choice_remove]
				if(!mut_remove) return
				choice.mutations -= mut_remove
				src << "Removed [mutation_choice_remove] from [choice]."
				choice << "Admin removed your mutation: [mutation_choice_remove]"
			return

		if("Reset_Player_Technology")
			if(level < 1)
				src << "Access denied."
				return
			var/mob/races/M_reset = choice
			if(!M_reset)
				src << "This action requires a race player target."
				return
			if(alert(src, "Reset ALL technology for [M_reset]? They will relearn everything based on their INTXP.", "Tech Reset", "Yes", "No") != "Yes")
				return
			var/saved_intxp = M_reset.intxp
			M_reset.intxp = 0
			M_reset.tech_unlocked = list()
			M_reset.tech_lvls = list()
			M_reset.tech_xp = list()
			M_reset.tech_unlocked.len = global.tech.len
			M_reset.tech_lvls.len = global.tech.len
			M_reset.tech_xp.len = global.tech.len
			if(M_reset.hud_tech)
				del(M_reset.hud_tech)
				M_reset.hud_tech = null
			M_reset.hud_tech = new /obj/hud/menus/tech_background
			M_reset.hud_tech.populate_tech_tree()
			M_reset.hud_tech.menu_create()
			M_reset.intxp = saved_intxp
			spawn()
				tech_unlocking(M_reset)
			src << "[M_reset]'s technology has been fully reset and rebuilt."
			M_reset << "Your technology has been reset by an admin. Your intelligence remains the same and technologies will be relearned automatically."
			return

		if("Clear_Tech_List")
			if(level < 4)
				src << "Access denied."
				return
			if(!choice.hud_tech)
				src << "[choice] has no tech HUD to clear."
				return
			if(alert(src, "Are you sure you wish to fix [choice] technology list? This will clear their inventory and you are expected to reset their QP from 0 to their current QP so they can relearn their tech.", "", "Yes", "No") != "Yes")
				return
			choice.hud_tech.ClearTechEntriesFull()
			src << "[choice] technology list was cleared!"
			choice << "Your technology list was cleared by an admin!"
			return

		else
			src << "Unknown admin panel action: [action]"
			return

/proc/BanDurationToDeciseconds(amount, unit)
	amount = round(amount)
	if(amount <= 0) return 0
	switch(unit)
		if("Minutes") return amount * 600
		if("Hours") return amount * 36000
		if("Days") return amount * 864000
	return 0

/proc/FormatBanTimeRemaining(remaining_ds)
	var/remaining_seconds = max(0, round(remaining_ds / 10))
	var/days = round(remaining_seconds / 86400)
	remaining_seconds -= days * 86400
	var/hours = round(remaining_seconds / 3600)
	remaining_seconds -= hours * 3600
	var/minutes = round(remaining_seconds / 60)
	remaining_seconds -= minutes * 60
	var/list/parts = list()
	if(days) parts += "[days] day[days == 1 ? "" : "s"]"
	if(hours) parts += "[hours] hour[hours == 1 ? "" : "s"]"
	if(minutes) parts += "[minutes] minute[minutes == 1 ? "" : "s"]"
	if(!parts.len && remaining_seconds)
		parts += "[remaining_seconds] second[remaining_seconds == 1 ? "" : "s"]"
	if(!parts.len)
		parts += "less than a minute"
	return jointext(parts, ", ")

/mob/proc/RunTimedBan(var/mob/races/choice)
	if(!choice || !choice.client || !choice.client.computer_id)
		src << "That player is missing a valid client/computer ID."
		return
	var/src_admin_level = src.client ? src.client.admin_level : 0
	var/target_admin_level = choice.client ? choice.client.admin_level : 0
	if(target_admin_level >= src_admin_level)
		src << "You cannot ban an admin with an equal or higher admin level than yours."
		return
	var/unit = input(src, "Ban duration unit for [choice]:", "Timed Ban") as null|anything in list("Minutes", "Hours", "Days")
	if(!unit) return
	var/amount = input(src, "How many [lowertext(unit)] should [choice] be banned for?", "Timed Ban", 1) as null|num
	if(isnull(amount) || amount <= 0) return
	amount = round(amount)
	var/duration_ds = BanDurationToDeciseconds(amount, unit)
	if(duration_ds <= 0) return
	if(alert(src, "Ban [choice] for [amount] [lowertext(unit)]?", "Timed Ban", "Yes", "No") != "Yes")
		return
	choice.ban_count += 1
	world.SetTimedBan(choice.client.computer_id, duration_ds, choice.ckey, choice.client.address)
	choice.client.screen += new /obj/bannedbackground
	world << "<font color=red><b>[choice.key] has been banned for [amount] [lowertext(unit)].</b></font>"
	world.log << "(Admin Log): [src.client.admin_name] banned [choice] for [amount] [unit] (Total Bans: [choice.ban_count])"
	world << output("<font color=yellow>(Admin Log): [src] banned [choice] for [amount] [unit]</font>","rpspy.output2")
	spawn(10)
		if(choice)
			choice.Logout()

/mob/proc/RunTimedUnban()
	world.PruneExpiredBans()
	if(!ban_list || !ban_list.len)
		src << "There are no active bans to remove."
		return
	var/list/ban_options = list()
	for(var/computer_id in ban_list)
		var/expires_at = world.GetBanExpiry(computer_id)
		if(isnull(expires_at))
			continue
		var/remaining_text = isnum(expires_at) && expires_at >= 0 ? FormatBanTimeRemaining(expires_at - world.realtime) : "permanent"
		var/ban_ckey = world.GetBanCkey(computer_id)
		var/ban_ip = world.GetBanIP(computer_id)
		if(!ban_ckey || !length("[ban_ckey]")) ban_ckey = "unknown"
		if(!ban_ip || !length("[ban_ip]")) ban_ip = "unknown"
		ban_options["[computer_id] | [ban_ckey] | [ban_ip] ([remaining_text])"] = "[computer_id]"
	if(!ban_options.len)
		src << "There are no active bans to remove."
		return
	var/selection = input(src, "Select a ban to remove:", "Timed Unban") as null|anything in ban_options
	if(!selection) return
	var/computer_id = ban_options[selection]
	if(!computer_id) return
	var/ban_ckey = world.GetBanCkey(computer_id)
	var/ban_ip = world.GetBanIP(computer_id)
	if(!ban_ckey || !length("[ban_ckey]")) ban_ckey = "unknown"
	if(!ban_ip || !length("[ban_ip]")) ban_ip = "unknown"
	if(alert(src, "Remove the ban for [computer_id]?\nckey: [ban_ckey]\nip: [ban_ip]", "Timed Unban", "Yes", "No") != "Yes")
		return
	if(world.RemoveTimedBan(computer_id))
		world << "<font color=green><b>Ban removed for [computer_id] ([ban_ckey] / [ban_ip]).</b></font>"
		world.log << "(Admin Log): [src.client.admin_name] removed ban for [computer_id] (ckey: [ban_ckey], ip: [ban_ip])"
		world << output("<font color=yellow>(Admin Log): [src] unbanned [computer_id] (ckey: [ban_ckey], ip: [ban_ip])</font>","rpspy.output2")
	else
		src << "That ban no longer exists."

/proc/AdminPickSpawnTurf(var/planet_name)
	var/z_level = 1
	switch(planet_name)
		if("Earth") z_level = 1
		if("Namek") z_level = 4
		if("Vegeta") z_level = 10
		if("Icer") z_level = 9
		if("Hell") z_level = 6
		if("Heaven") z_level = 11
		if("Checkpoint") z_level = 2
		if("Dark Realm") z_level = 12
		else z_level = 1

	for(var/i = 1, i <= 120, i++)
		var/turf/t = locate(rand(5, 480), rand(5, 480), z_level)
		if(!t || t.density) continue
		var/blocked = 0
		for(var/atom/movable/A in t)
			if(A.density)
				blocked = 1
				break
		if(!blocked) return t

	return locate(150, 150, z_level)

/mob/proc/RunAdminCommand(cmd)
	if(!(src.key in StaffTeam))
		src << "Access denied."
		return

	var/list/race_mobs = list()
	for(var/mob/races/R in world)
		if(R.started || R.client || R.loc)
			race_mobs += R
	if(!race_mobs.len) return

	switch(cmd)
	// =========================================================
	// BOOT / REBOOT / BAN // WORLD CONTROL
	// =========================================================
		if("Purge_Lag")
			switch(alert(src,"Are you purging specific mobs for lag or everything?","","Specific","Everything"))
				if("Specific")
					var/specific = input("Type the name of the mob exactly you wish to erase") as text
					world<<"<b>World Refreshing..</b>"
					var/list/race_placeholders = list(
						"Human",
						"Saiyan",
						"Yukopian",
						"Spiritdoll",
						"Makyo",
						"Imp",
						"Celestial",
						"Demon",
						"Changeling",
						"Tuffle",
						"Android",
						"Alien"
					)
					var/count = 0

					for(var/mob/m in world)
						if(!m) continue
						if(m.npc) continue
						if(m.client) continue
						if(m.name in race_placeholders) continue   // skip race preview mob

						if(m.name == "[specific]")
							count++
							world.log<<"[m] Deleted for Purge(LAG)"
							del(m)

					world << "<b>World Refreshed! ([count] misc. deleted)</b>"

				if("Everything")
					world<<"<b>World Refreshing..</b>"
					var/list/race_placeholders = list(
						"Human",
						"Saiyan",
						"Yukopian",
						"Spiritdoll",
						"Makyo",
						"Imp",
						"Celestial",
						"Demon",
						"Changeling",
						"Tuffle",
						"Android",
						"Alien"
					)

					var/count = 0
					for(var/mob/m in world)
						if(!m) continue
						if(m.npc) continue
						if(m.client) continue
						if(m.name in race_placeholders) continue   // skip race preview mob

						count++
						world.log<<"[m] Deleted for Purge(LAG)"
						del(m)
						sleep(1)
					world << "<b>World Refreshed! ([count] misc. deleted)</b>"



		if("Check_CPU")
			src << "CPU: [world.cpu] | Tick Usage: [world.tick_usage]"
			return
		if("Boot")
			var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
			if(!choice) return
			world << "[choice] was booted."
			choice.client.images = null
			spawn(10) winset(choice, null, "command=.quit")
			choice.client.Del()
			world.log << "(Admin Log): [src.client.admin_name] [src] booted [choice]"
			return
		if("Reboot")
			world << "<span class=\"announce\"><font color=green><b>(MANUAL) Rebooting in 30 seconds!</b></font></span>"
			sleep(300)
			//world << "<span class=\"announce\"><font color=green><b><u>Saving and Rebooting World</u></b></font></span>"
			//  P.Save_Player_Data() // Save player data asynchronously
			//file("AdminLog.log")<<"[usr]([usr.key]) rebooted at [time2text(world.realtime,"Day DD hh:mm")] \n"
			rebooting = 1
			world.quick_save_players()
			sleep(1)
			world.Save_All()
			sleep(1)

			spawn(20)
				world.Reboot()
			return
		if("Ban")
			var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
			if(!choice) return
			src.RunTimedBan(choice)
			return
		if("Unban")
			src.RunTimedUnban()
			return
	// =========================
	// CORE / SAFETY
	// =========================

		if("Delete")
			src.set_alert("Select something to delete",'alert.dmi',"alert")
			src << "<b>ADMIN:</b> Select something to delete"
			src.left_click_function = "delete stuff"
			return
		if("Create_Item")
			if(!ALL_ITEM_TYPES || !ALL_ITEM_TYPES.len)
				BuildItemTypeCache()
			var/list/item_choices = AdminSortItemDisplayNames(ALL_ITEM_TYPES)
			if(!item_choices || !item_choices.len)
				src << "No item types are available to create."
				return
			var/selected_item = input(src,"Select an item to create:","Admin Item Creation") as null|anything in item_choices
			if(!selected_item) return
			var/typepath = item_choices[selected_item]
			if(!typepath)
				typepath = selected_item
			if(!typepath) return
			var/obj/items/I = new typepath(src.loc)
			if(!I)
				src << "That item could not be created."
				return
			I.alpha = 0
			I.pixel_z = 32
			I.level = src.intxp
			I.tech_lvl = src.intxp
			animate(I, alpha = 255, pixel_z = initial(I.pixel_z), time = 2, easing = BOUNCE_EASING)
			world.log << "(Admin Log): [src.key] created [I]"
			return
	// =========================
	// COMMUNICATION
	// =========================

		if("Admin_Chat")
			if(!src.service_lvl)
				src << "Only administrators may use this command."
				return
			var/msg = input("Admin Chat:") as text
			if(!msg) return
			for(var/mob/M in players)
				if(M.service_lvl)
					M << "<font size=2><b><font color=#CB0739>(AdminChat)[src.key]([src.client.admin_name]):</font> <font color=white>[msg]</font>"
			return
		if("Announce")
			var/announce = input("What are you announcing?") as text
			if(!announce) return
			world << "<center>[src.client.admin_name] announces:<br>----------------<br>[announce]<br>----------------</center>"
			world.log << "(Admin Log): [src.client.admin_name] used Announce"
			return
	// =========================
	// PLAYER CONTROL
	// =========================

		if("Change_Icon")
			var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
			var/newicon = input(src, "Select icon file") as icon|null
			if(newicon) choice.icon = newicon
			world.log << "(Admin Log):[choice] icon was changed by [usr.client.admin_name]"

		if("Spawn_Player")
			var/fake_name = input("Enter fake player name:") as text
			if(!fake_name) return
			var/fake_age = input("Enter fake player age:", "Fake Player Age", 18) as num
			if(isnull(fake_age)) return
			if(fake_age < 1) fake_age = 1
			var/list/race_paths = list(
				"Human" = /mob/races/Human,
				"Saiyan" = /mob/races/Saiyan,
				"Namekian" = /mob/races/Yukopian,
				"Spirit Doll" = /mob/races/Spiritdoll,
				"Makyo" = /mob/races/Makyo,
				"Oni" = /mob/races/Imp,
				"Kai" = /mob/races/Celestial,
				"Demon" = /mob/races/Demon,
				"Changeling" = /mob/races/Changeling,
				"Tuffle" = /mob/races/Tuffle,
				"Android" = /mob/races/Android,
				"Alien" = /mob/races/Alien,
				"Half God" = /mob/races/HalfGod
			)
			var/race_choice = input("Select a race:") as null|anything in race_paths
			if(!race_choice) return
			var/path = race_paths[race_choice]
			if(!path) return
			var/mob/races/fake_player = new path()
			fake_player.name = fake_name
			fake_player.fullname = fake_name
			fake_player.real_name = fake_name
			fake_player.key = fake_name
			fake_player.race = "[race_choice]"
			fake_player.age = round(fake_age)
			fake_player.age_soul = round(fake_age)
			fake_player.update_body_age()

			// Randomized appearance pass.
			fake_player.gen = pick("Male", "Female")
			fake_player.gender = lowertext(fake_player.gen)
			if(fake_player.gen == "Male")
				fake_player.hair_pos = rand(1, 15)
			else
				fake_player.hair_pos = rand(1, 13)
			fake_player.hair_c = rgb(rand(0,255), rand(0,255), rand(0,255))
			fake_player.eye_c = rgb(rand(0,255), rand(0,255), rand(0,255))
			fake_player.update_looks()

			var/turf/spawn_turf = AdminPickSpawnTurf(fake_player.home_planet)
			if(!spawn_turf) spawn_turf = src.loc
			fake_player.loc = spawn_turf
			players += fake_player
			world.log << "(Admin Log): [src.client.admin_name] spawned fake player [fake_name] ([race_choice])"
			src << "Fake player '[fake_name]' spawned successfully as [race_choice]."
			return

		if("Rename_Player")
			var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
			var/newname = input("What will be their new name?") as text
			switch(alert(usr,"Are you sure you wish rename [choice] to [newname]?","","Yes","No"))
				if("Yes")
					world.log << "(Admin Log):[choice] name was changed to [newname] by [usr.client.admin_name]"

					choice.fullname = newname
					choice.name = newname
					choice.real_name = newname
		if("Admin_Telepathy")
			var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
			if(!choice) return
			var/msg = input ("Message to: [choice]:") as text
			if(msg)
				choice<<"<font color=##89A7E2><u>Admin Telepathy:</u> [msg]"
				for(var/mob/M in players)
					if(M.service_lvl)
						M<<"<font color=##89A7E2><u>([src.key]) Admin Telepathy to [choice]:</u> [msg]"
					return
		if("Send_To_Spawn")
			var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
			if(!choice) return
			switch(alert(src,"Are you sure you want to send them to their spawn point?","","Yes","No"))
				if("Yes")
					switch(choice.home_planet)
						if("Icer")
							choice.loc = locate(450/rand(1,5),450/rand(1,5),9)
						if("Namek")
							choice.loc = locate(450/rand(1,5),450/rand(1,5),4)
						if("Vegeta")
							choice.loc = locate(450/rand(1,5),450/rand(1,5),10)
						if("Earth")
							choice.loc = locate(450/rand(1,5),450/rand(1,5),1)
						if("Hell")
							choice.loc = locate(450/rand(1,5),450/rand(1,5),6)
						if("Heaven")
							choice.loc = locate(450/rand(1,5),450/rand(1,5),11)
						if("Checkpoint")
							choice.loc = locate(130,449,2)
					src<<"[choice] was sent to their home planet([choice.home_planet])"
					if(choice.in_space_ship) choice.in_space_ship = 0
					if(choice.in_space_pod) choice.in_space_pod = 0
			return
		if("Grant_Vote_Mute_Access")
			var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
			if(!choice) return
			if(choice.has_vote_mute>=1)
				src<<"[choice] already has vote mute access!"
				return
			choice.has_vote_mute = 1
			choice<<"<b>You were granted access to Vote Mute. (use /votem to  start a vote)</b>"
			src<<"You granted them access to Vote Mute!"
			world.log << "(Admin Log): [src.client.admin_name] gave [choice] vote mute"
			return
		if("Grant_Admin_Powers")
			if(!src.client || src.client.admin_level < 4)
				src << "Only owner-level admins can grant admin powers."
				return
			var/mob/choice = input("Select a player:") as null|mob in players
			if(!choice || !choice.client) return
			if(choice == src)
				src << "You cannot change your own admin powers with this command."
				return
			var/src_admin_level = src.client.admin_level
			var/target_admin_level = choice.client.admin_level
			if(target_admin_level >= src_admin_level)
				src << "You cannot modify an admin with an equal or higher level than yours."
				return
			var/list/level_options = list()
			for(var/i = 1, i < src_admin_level, i++)
				level_options += i
			if(!level_options.len)
				src << "No grantable admin levels are available for your account."
				return
			var/selected_level = input(src, "Select admin level for [choice]:", "Grant Admin Powers") as null|anything in level_options
			if(isnull(selected_level)) return
			var/new_level = isnum(selected_level) ? round(selected_level) : round(text2num("[selected_level]"))
			if(new_level < 1 || new_level >= src_admin_level)
				src << "Invalid admin level selected."
				return
			if(alert(src, "Grant admin level [new_level] to [choice]?", "Grant Admin Powers", "Yes", "No") != "Yes")
				return
			choice.client.admin_level = new_level
			choice.service_lvl = new_level
			if(!(choice.key in CodedStaff))
				CodedStaff += "[choice.key]"
			if(!(choice.key in StaffTeam))
				StaffTeam += "[choice.key]"
			if(!choice.client.admin_name || choice.client.admin_name == "Admin White")
				choice.client.admin_name = "[choice.key]"
			save_admin_profile(choice.client)
			//choice.show_admin_panel()
			choice << "Your admin powers were granted by [src.client.admin_name]. Level: [new_level]."
			src << "Granted admin powers to [choice] at level [new_level]."
			world << output("<font color=yellow>(Admin Log): [src] granted admin level [new_level] to [choice]</font>","rpspy.output2")
			world.log << "(Admin Log): [src.client.admin_name] granted admin level [new_level] to [choice]"
			return
		if("Remove_Admin_Powers")
			if(!src.client || src.client.admin_level < 4)
				src << "Only owner-level admins can remove admin powers."
				return
			var/mob/choice = input("Select a player:") as null|mob in players
			if(!choice || !choice.client) return
			if(choice == src)
				src << "You cannot remove your own admin powers with this command."
				return
			var/src_admin_level = src.client.admin_level
			var/target_admin_level = choice.client.admin_level
			if(target_admin_level >= src_admin_level)
				src << "You cannot modify an admin with an equal or higher level than yours."
				return
			if(target_admin_level <= 0 && !(choice.key in CodedStaff) && !(choice.key in StaffTeam))
				src << "[choice] does not currently have admin powers."
				return
			if(alert(src, "Remove all admin powers from [choice]?", "Remove Admin Powers", "Yes", "No") != "Yes")
				return
			choice.client.admin_level = 0
			choice.service_lvl = 0
			StaffTeam -= "[choice.key]"
			CodedStaff -= "[choice.key]"
			save_admin_profile(choice.client)
			//choice.show_admin_panel()
			choice << "Your admin powers were removed by [src.client.admin_name]."
			src << "Removed admin powers from [choice]."
			world << output("<font color=yellow>(Admin Log): [src] removed admin powers from [choice]</font>","rpspy.output2")
			world.log << "(Admin Log): [src.client.admin_name] removed admin powers from [choice]"
			return
		if("Heal")
			var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
			if(!choice) return
			if(choice.percent_health <=1 || choice.koed || choice.icon_state == "KO")
				choice.KO(0,1)
			sleep(1)
			choice.percent_health = 100
			choice.stunned = 0
			choice.stunned_pending = 0
			choice.refresh_vital_bars(TRUE)
			world.log << "(Admin Log): [src.client.admin_name] healed [choice]"

		if("Heal_Everything")
			var/mob/choice = input("Select a player:") as null|mob in race_mobs
			if(!choice) return
			if(choice.koed || choice.icon_state == "KO" || choice.percent_health <=1)
				choice.KO(0,1)
			sleep(1)
			choice.percent_health = 100
			choice.thirst = 99
			choice.hunger = 99
			choice.toxicity = 0
			choice.restedness = 99
			choice.stunned = 0
			choice.stunned_pending = 0
			choice.refresh_vital_bars(TRUE)
			if(choice.heal_all_limbs())
				choice << "Your [choice] has been fully healed by an admin."
			world.log << "(Admin Log): [src.client.admin_name] healed everything of [choice]"

		if("Revive")
			var/mob/choice = input("Select a player:") as null|mob in players
			if(!choice || !choice.dead) return
			choice.Revive()
			choice.percent_health = 100
			choice.energy = choice.energy_max
			choice.thirst = 99
			choice.hunger = 99
			choice.restedness = 99
			choice.toxicity = 0
			choice.disable_skills()
			choice.check_glow_planes()
			world.log << "(Admin Log): [src.client.admin_name] revived [choice]"

		if("Kill")
			var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
			if(!choice) return
			if(!choice.dead)
				choice.KO()
				sleep(2)
				choice.Death("Admin Killed")
			else
				src.set_alert("[choice] is already dead.",'alert.dmi',"alert")
			world.log << "(Admin Log): [src.client.admin_name] killed [choice]"

		if("Knockout")
			var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
			if(choice)
				choice.KO()
				world.log << "(Admin Log): [src.client.admin_name] KO'd [choice]"

		if("Observe")
			var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
			if(!choice) return
			src.client.perspective = EYE_PERSPECTIVE | EDGE_PERSPECTIVE
			src.client.eye = choice
			world.log << "(Admin Log): [src.client.admin_name] observed [choice]"

		if("Ban")
			var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
			if(!choice) return
			src.RunTimedBan(choice)

		if("Unban")
			src.RunTimedUnban()

		if("Mute")
			var/mob/races/choice = input("Select a player to mute/unmute:") as null|anything in race_mobs
			if(!choice) return

			if(choice.muted)
				switch(alert(src,"[choice] is currently muted.\nDo you want to unmute them?","","Unmute","Cancel"))
					if("Unmute")
						choice.muted = 0
						world << "<font color=yellow>[choice] has been unmuted by an administrator.</font>"
						world.log << "(Admin Log): [src.client.admin_name] unmuted [choice]"
			else
				switch(alert(src,"Mute [choice]?","","Yes","Cancel"))
					if("Yes")
						choice.muted = 1
						choice.mute_count += 1
						world << "<font color=orange>[choice] has been muted by an administrator.</font>"
						world.log << "(Admin Log): [src.client.admin_name] muted [choice] (Total Mutes: [choice.mute_count])"


	// =========================
	// TELEPORT
	// =========================

		if("Goto")
			var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
			if(!choice) return
			src.loc = locate(choice.x, choice.y+1, choice.z)
			src.check_glow_planes()
			world.log << "(Admin Log): Goto used on [choice]"

		if("Bring")
			var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
			if(!choice) return
			choice.loc = locate(src.x, src.y-1, src.z)
			choice.check_glow_planes()
			world.log << "(Admin Log): Bring used on [choice]"

	// =========================
	// ECONOMY / RP
	// =========================
		if("Restore_Artifacts")
			switch(alert(src,"Are you sure you wish to restore artifacts?\nNote: Please do not use this just because one planet is lacking, if there are abundant on another planet they are expected to wait for the monthly respawns.","","Yes","No"))
				if("Yes")
					world<<"Admin is restoring artifacts in 10 seconds."
					spawn(10)
						world.Respawn_Artifacts()

		if("Give_RPPs")
			var/mob/choice = input("Select a player:") as null|mob in players
			var/amount = input("How much RPPs?") as num
			if(amount > 0)
				choice.roleplay_points += amount
				choice.total_rpps_gained += amount
				choice << "You were given [amount] RPPs."

				world.log << "(Admin Log): Gave RPPs"

		if("Give_Zenni")
			var/mob/choice = input("Select a player:") as null|mob in players
			var/amount = input("How much Zenni?") as num
			if(amount > 0)
				choice.resources += amount
				choice.refresh_inv()

	// =========================
	// WORLD
	// =========================
		if("Global_CFT")
			if(!cftglobal)
				switch(alert(src,"Do you wish to unlock global CFT? This will give everyone an infinite amount of Cycle Free Time until it is toggled off.","","Yes","No"))
					if("Yes")
						cftglobal = 1
						for(var/mob/races/p in players)
							if(p)
								p.cycle_free_time = 25
								if(p.hud_cft == null)
									var/obj/hud/menus/cft_gains_txt/cftb = new
									p.hud_cft = cftb
									p.hud_cft.cycler = src
									if(p.cycle_free_time) p.client.screen += p.hud_cft
								else
									p.client.screen -= p.hud_cft
									p.client.screen += p.hud_cft
								p<<output("<b><font color=yellow>You were granted Cycle Free Time! <i>Note: Resilience is disabled during this time, offering you an opportunity to train stats without tire.</font></b>","actionoutput")
						world<<"<b><font color=#68D9FF>Global Cycle Free Time Activated!</b></font>"
						return
			else
				cftglobal = 0
				for(var/mob/races/p in players)
					if(p)
						p.cycle_free_time = 0
						if(p.hud_cft == null)
							var/obj/hud/menus/cft_gains_txt/cftb = new
							p.hud_cft = cftb
							p.hud_cft.cycler = src
							if(p.cycle_free_time) p.client.screen -= p.hud_cft
						else
							p.client.screen -= p.hud_cft
				world<<"<b><font color=#68D9FF>Global Cycle Free Time Deactivated!</b></font>"
				return

		if("Spy_Roleplay")
			winshow(src, "rpspy", TRUE)
		if("Toggle_Global_OOC")
			global.ooc_on = !global.ooc_on
			world << "<b>Global OOC: [global.ooc_on ? "<font color=green>ON</font>" : "<font color=red>OFF</font>"]</b>"

		if("Shutdown")
			if(alert(src,"Really Shutdown the server?","","Yes","No") == "Yes")
				world << "Shutting Down Server in 10 seconds!"
				sleep(100)
				for(var/mob/m in players)
					m.Logout()
				world.Del()

		// =========================================================
		// EDITING / VIEWING
		// =========================================================
		if("Assess")
			var/mob/choice = input("Select a player:") as null|mob in race_mobs
			if(!choice) return

			var/S = choice.bodysize
			if(S == 1) S = "Small"
			if(S == 2) S = "Medium"
			if(S == 3) S = "Large"

			var/A = {"
			<html>
			<style type="text/css">
			<!--
			body {
			     color:#449999;
			     background-color:black;
			     font-size:12;
			 }
			table {
			     font-size:12;
			 }
			//-->
			</style>
			<body>
			[(choice)]<br>
			Current Anger: [choice.anger]%<br>
			<table cellspacing="6%" cellpadding="1%">
			<tr><td><font color=white><b>Compensation Minutes | Standing Minutes:</b></font></td><td>Comp. Gains: [choice.offline_gains] minutes | Standing Gains: [choice.standing_gains_timer] second</td></tr>
			<tr><td><font color=white><b>Current HTTG:</b></font></td><td>(H:[choice.hunger] T:[choice.thirst] T:[choice.restedness])</td></tr>
			<tr><td><font color=white><b>Resilliences:</b></font></td><td> (Training)[choice.trainres]--[choice.max_trainres]| (Meditation)[choice.medres]--[choice.max_medres]| (Sparring)[choice.sparres]/[choice.max_sparres]| (Blasting)[choice.blastres]/[choice.max_blastres]</td></tr>
			<tr><td><font color=white><b>Ratings:</b></font></td><td>[choice.rating]</td></tr>
			<tr><td><font color=white><b>Move Lv:</b></font></td><td>[choice.move_lvl] Exp:([choice.movelvl_exp]/1000)</td></tr>
			<hr>
			<tr><td><font color=white><b>Health:</b></font></td><td>[choice.hp]</td></tr>
			<hr>
			<tr><td>Race(s):</td><td>[choice.race] | [choice.recessive_race]</td></tr>
			<tr><td>Race Class:</td><td>[choice.race_class]</td></tr>
			<tr><td>Key:</td><td>[choice.key]</td></tr>
			<tr><td>Body Size:</td><td>[S]</td></tr>
			<tr><td>Age:</td><td>[choice.age] ([choice.age_soul] True Age)</td></tr>
			<tr><td>Generation:</td><td>[choice.generation_lvl]</td></tr>

			<tr><td>Body:</td><td>[choice.Body*100]% ([choice.oldage] Decline) - Prime Age: ([choice.prime]) </td></tr>
			<tr><td>Base:</td><td>[choice.psionic_power_base] ([choice.mod_psionic_power])</td></tr>
			<tr><td>Current PL:</td><td>[Commas(choice.psionic_power)]</td></tr>
			<tr><td>Lift:</td><td>[round((choice.strength+choice.endurance*4)*0.45359237)*0.01] kg ([round(choice.strength+choice.endurance*4)*0.01] lbs)</td></tr>
			<tr><td>Energy:</td><td>[choice.energy]/[round(choice.energy_max)] Mod.([choice.mod_energy])</td></tr>
			<tr><td>Strength:</td><td>[choice.strength] Mod.([choice.mod_strength]) </td></tr>
			<tr><td>Endurance:</td><td>[choice.endurance] Mod.([choice.mod_endurance])</td></tr>
			<tr><td>Speed:</td><td>x[choice.mod_agility]</td></tr>
			<tr><td>Force:</td><td>[choice.force] Mod.([choice.mod_force])</td></tr>
			<tr><td>Resistance:</td><td>[round(choice.resistance)] Mod.([choice.mod_resistance])</td></tr>
			<tr><td>Offense:</td><td>[choice.offence] Mod.([choice.mod_offence])</td></tr>
			<tr><td>Defense:</td><td>[choice.defence] Mod.([choice.mod_defence])</td></tr>
			<tr><td>Regeneration:</td><td>[choice.mod_regeneration]</td></tr>
			<tr><td>Recovery:</td><td>[choice.mod_recovery]</td></tr>
			<tr><td>Gravity:</td><td>x[round(choice.gravity_mastered)]</td></tr>
			<tr><td>Anger:</td><td>[choice.max_anger]%</td></tr>
			<tr><td>Intelligence:</td><td>([choice.intxp]%) Mod([choice.mod_tech_potential])</td></tr>
			<tr><td>Magic:</td><td>([choice.magicxp]%) Mod([choice.mod_arcane_potential])</td></tr>
			<tr><td>Energy Signature:</td><td>[choice.signature]</td></tr>
			<tr><td>PG/PG Mult: [choice.PG] - [round(choice.rating_mult)]x</td></tr>
			<tr><td>Cycle Free Time:[choice.cycle_free_time]</td></tr>
			<tr><td>Final Power Level Mod:[choice.final_powerlevel_mod]</td></tr>
			</table>
			"}

			A += "<br><font color=red><b><u>Mutations</b></u><br>"
			for(var/mutations/X in choice.mutations)
				A += "<font color=red>[X.info_name] - [X.info]<br>"

			src << "[A]"
			src << browse(A, "window=[(choice)];size=700x600")
			world.log << "(Admin Log): [src.client.admin_name] [src] used ASSESS on [choice]"

		if("Edit")
			//var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
			var/mob/choice = input("Select a player:") as null|anything in race_mobs
			if(!choice) return
			src.OpenAdminPlayerPanel(choice)
			world.log << "(Admin Log): [src.client.admin_name] opened Player Panel on [choice]"

		if("Edit_Age")
			var/mob/choice = input("Select a player:") as null|obj|mob in players
			if(!choice) return
			var/age = input("Physical age?") as num
			var/soul = input("Soul Age?") as num
			choice.age = age
			choice.age_soul = soul
			choice << "Your age was changed by an admin."
			choice.update_body_age()
			choice.beard_checker()
			return

		if("Edit_Roleplay_Rank")
			var/mob/choice = input("Select a player:") as null|mob in players
			if(!choice) return
			var/amount = input("What rank are you making them?\n\n1: Rank F\n2: Rank E\n3: Rank D\n4: Rank C\n5: Rank B\n6: Rank A\n7: Rank S\n8: Rank SS\n9: Rank SSS") as num
			choice.give_roleplayrank(amount)
			choice << "Your RP Rank was adjusted by admins!"
			return

		// =========================================================
		// FIXES / CLIENT / ICONS
		// =========================================================
		if("Debug_Player_Technology")
			var/mob/races/M = input("Select a player:") as null|anything in race_mobs
			if(!M) return

			src << "---- TECH DEBUG FOR [M] ----"

			for(var/obj/items/tech/T in global.tech)
				var/state = "LOCKED"

				if(M.tech_unlocked[T.list_pos] == T.type)
					state = "UNLOCKED"

				src << "[T.name] | Needed INTXP: [T.needed_qp] | State: [state]"


		if("Manage_Technology")
			var/mob/races/M = input("Select a player:") as null|anything in race_mobs
			if(!M) return

			var/list/options = list()

			for(var/obj/items/tech/T in global.tech)
				if(!T) continue

				var/status = "LOCKED"
				if(M.tech_unlocked[T.list_pos] == T.type)
					status = "UNLOCKED"

				options["[T.name] ([status])"] = T

			var/choice = input(src, "Select a tech to manage for [M].", "Tech Manager") in options
			if(!choice) return

			var/obj/items/tech/T = options[choice]

			var/action = input(src, "What do you want to do with [T.name]?", "Tech Action") in list(
			"Add Tech",
			"Remove Tech",
			"Recheck Unlock Logic",
			"Cancel"
			)

			if(action == "Add Tech")
				M.tech_unlocked[T.list_pos] = T.type
				T.lvl_up_tech(M)
				M << "[src] ADMIN added tech [T.name] to [M]."

			if(action == "Remove Tech")
				M.tech_unlocked[T.list_pos] = null
				M << "[src] ADMIN removed tech [T.name] from [M]."

			if(action == "Recheck Unlock Logic")
				T.lvl_up_tech(M)
				M << "[src] ADMIN forced tech check for [T.name] on [M]."

			spawn()
				tech_unlocking(M)

		if("Reset_Player_Inventory")

			var/mob/races/M = input("Select a player:") as null|anything in race_mobs
			if(!M) return

			if(alert(src,"Reset and rebuild [M]'s inventory?","Inventory Reset","Yes","No") != "Yes")
				return

			var/list/valid_items = list()

			// Gather valid items
			for(var/obj/items/I in M)
				if(I && I.can_pocket)
					valid_items += I

			// Clear inventory slots
			for(var/i=1,i<=48,i++)
				M.inv[i] = null

			// Rebuild inventory
			var/slot = 1
			for(var/obj/I in valid_items)

				if(slot > 48)
					break

				if(!I) continue

				I.slot = slot
				I.loc = M
				M.inv[slot] = I

				if(!(global.inv_slot in I.vis_contents))
					I.vis_contents += global.inv_slot

				slot++

			// Remove any broken leftovers
			for(var/obj/items/I in M)
				if(!(I in valid_items))
					del(I)

			// Reset selection
			M.item_selected = null
			M.mouse_down = null
			M.mouse_over = null

			// Rebuild HUD
			M.refresh_inv()

			src << "[M]'s inventory has been rebuilt."
			M << "Your inventory has been rebuilt by an admin to fix corrupted slots."
		if("Delete_Player_Skills")
			var/mob/M = input("Select a player:") as null|anything in players
			if(!M) return

			if(alert(src, "Delete all existing skills for [M]?", "Skill Refresh", "Yes", "No") != "Yes")
				return

			M.DeleteExistingSkills()

			src << "[M]'s skills were deleted."
			//M << "Your skills were refreshed by an admin."

		if("Refresh_Player_Skills")
			var/mob/M = input("Select a player:") as null|anything in players
			if(!M) return

			if(alert(src, "Refresh all existing skills for [M]?", "Skill Refresh", "Yes", "No") != "Yes")
				return

			M.RefreshExistingSkills()

			src << "[M]'s skills were refreshed."
			//M << "Your skills were refreshed by an admin."

		if("Manage_Skills")
			var/mob/M = input("Select a player:") as null|anything in players
			if(!M) return

			var/action = alert(src, "What action?", "Skill Manager", "Give", "Take", "Cancel")
			if(action == "Cancel" || !action) return

			var/list/skills = list()
			if(action == "Give")
				for(var/skill_type in typesof(/obj/skills))
					if(skill_type == /obj/skills || skill_type == /obj/skills/AA_Skill_Copy) continue
					var/info_name = initial(skill_type:info_name)
					if(!info_name || !length("[info_name]")) continue
					var/already_has = 0
					for(var/obj/skills/existing_skill in M)
						if(existing_skill.type == skill_type)
							already_has = 1
							break
					if(!already_has)
						skills["[info_name] ([skill_type])"] = skill_type
				skills = sort_list(skills)
				if(!skills.len)
					src << "[M] has no available skills to give."
					return
				var/skill_choice = input("Select skill:", "Give Skill") as null|anything in skills
				if(!skill_choice) return
				var/skill_type = skills[skill_choice]
				if(!skill_type) return
				var/obj/skills/skill = new skill_type(M)
				if(!skill) return
				skill.loc = M
				src << "Gave [skill_choice] to [M]."
				M << "Admin gave you skill: [skill_choice]"
			if(action == "Take")
				for(var/obj/skills/skill in M)
					if(!skill) continue
					if(skill.type == /obj/skills/AA_Skill_Copy) continue
					if(!skill.info_name || !length("[skill.info_name]")) continue
					skills["[skill.info_name] ([skill.type])"] = skill
				if(!skills.len)
					src << "[M] has no removable skills."
					return
				skills = sort_list(skills)
				var/skill_choice = input("Select skill to remove:", "Remove Skill") as null|anything in skills
				if(!skill_choice) return
				var/obj/skills/skill = skills[skill_choice]
				if(!skill) return
				if(skill.active)
					M.mouse_dir = "left"
					skill.Click()
					M.mouse_dir = null
				if(M.current_attack == skill) M.current_attack = null
				if(M.active_attack == skill) M.active_attack = null
				for(var/v in M.vars)
					if(M.vars[v] == skill)
						M.vars[v] = null
				M.contents -= skill
				qdel(skill)
				src << "Removed [skill_choice] from [M]."
				M << "Admin removed your skill: [skill_choice]"

		
		if("Manage_Mutations")
			var/mob/M = input("Select a player:") as null|anything in players
			if(!M) return

			var/action = alert(src, "What action?", "Mutation Manager", "Give", "Take", "Cancel")
			if(action == "Cancel" || !action) return

			var/list/mutations = list()
			if(action == "Give")
				// Get every concrete mutation type defined in the game
				for(var/mut_type in typesof(/mutations/))
					if(mut_type == /mutations) continue
					var/mutations/mut = new mut_type()
					if(!mut || !mut.info_name) continue
					mutations["[mut.info_name] ([mut_type])"] = mut_type
				mutations = sort_list(mutations)
				if(!mutations.len)
					src << "[M] has no available mutations to give."
					return
				var/mutation_choice = input("Select mutation:", "Give Mutation") as null|anything in mutations
				if(!mutation_choice) return
				var/mut_type = mutations[mutation_choice]
				if(!mut_type) return
				var/mutations/mut = new mut_type()
				if(!mut) return
				mut.activate(M)
				M.mutations += mut
				src << "Gave [mutation_choice] to [M]."
				M << "Admin gave you mutation: [mutation_choice]"
			if(action == "Take")
				// Get current mutations sorted by name
				for(var/mutations/mut in M.mutations)
					if(!mut) continue
					mutations[mut.info_name] = mut
				if(!mutations.len)
					src << "[M] has no mutations."
					return
				mutations = sort_list(mutations)
				var/mutation_choice = input("Select mutation to remove:", "Remove Mutation") as null|anything in mutations
				if(!mutation_choice) return
				var/mutations/mut = mutations[mutation_choice]
				if(!mut) return
				M.mutations -= mut
				src << "Removed [mutation_choice] from [M]."
				M << "Admin removed your mutation: [mutation_choice]"

		if("Reset_Player_Technology")
			var/mob/races/M = input("Select a player:") as null|anything in race_mobs
			if(!M) return

			if(alert(src,"Reset ALL technology for [M]? They will relearn everything based on their INTXP.","Tech Reset","Yes","No") != "Yes")
				return

			// Save current intelligence XP
			var/saved_intxp = M.intxp

			// Reset player INTXP temporarily
			M.intxp = 0

			// Reset tech data
			M.tech_unlocked = list()
			M.tech_lvls = list()
			M.tech_xp = list()

			M.tech_unlocked.len = global.tech.len
			M.tech_lvls.len = global.tech.len
			M.tech_xp.len = global.tech.len

			/// Delete old tech HUD
			if(M.hud_tech)
				del(M.hud_tech)
				M.hud_tech = null

			// Recreate it clean
			M.hud_tech = new /obj/hud/menus/tech_background
			M.hud_tech.populate_tech_tree()
			M.hud_tech.menu_create()

			// Restore INTXP
			M.intxp = saved_intxp

			// Re-run tech unlocking logic
			spawn()
				tech_unlocking(M)

			src << "[M]'s technology has been fully reset and rebuilt."
			M << "Your technology has been reset by an admin. Your intelligence remains the same and technologies will be relearned automatically."
		if("Clear_Tech_List")
			var/mob/choice = input("Select a player:") as null|obj|mob in players
			if(!choice) return
			switch(alert(src,"Are you sure you wish to fix [choice] technology list? This will clear their inventory and you are expected to reset their QP from 0 to their current QP so they can relearn their tech.","","Yes","No"))
				if("Yes")
					choice.hud_tech.ClearTechEntriesFull()
					src << "[choice] technology list was cleared!"
					choice << "Your technology list was cleared by an admin!"
					return

		if("Clear_Known_Names")
			var/mob/choice = input("Select a player:") as null|obj|mob in players
			if(!choice) return
			switch(alert(src,"Are you sure you wish to fix [choice] name list?","","Yes","No"))
				if("Yes")
					choice.known_people = list()
					src << "[choice] name list was defaulted!"
					choice << "Your name list was defaulted by an admin!"
					return
		if("Fix_Icon")
			var/mob/choice = input("Select a player:") as null|obj|mob in players
			if(!choice) return
			switch(alert(src,"Are you sure you wish to fix [choice] icon?","","Yes","No"))
				if("Yes")
					choice.update_looks()
					choice.update_icon()
					src << "[choice] looks were updated!"
					choice << "Your looks were updated(fixed)!"
		if("Force_Resolution_Fix")
			var/mob/races/M = input(src, "Select player") as mob in players
			if(!M || !M.client) return

			var/w = input(src, "Enter Width (example 1360):") as num
			var/h = input(src, "Enter Height (example 760):") as num

			if(!w || !h)
				src << "Invalid resolution."
				return

			M.client.ApplyResolutionScale(w, h)

			src << "Forced resolution [w]x[h] applied to [M]."
		if("Fix_Screen_Offset")
			var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
			if(!choice) return
			var/option = input("Select their offset") in list("Auto","Zero","Custom","Client Custom")

			if(option == "Auto")
				choice.client.custom_view = 32
			if(option == "Zero")
				choice.client.custom_view = 0
			if(option == "Custom")
				var/newoption = input("Type your offset(eg. -32, 32, -16, 16)") as num
				choice.client.custom_view = newoption
			if(option == "Client Custom")
				var/clientx = input("Type the 'x' of the client view") as num
				var/clienty = input("Type the 'y' of the client view") as num
				var/pixelxoff = input("Type the 'pixel_x' number") as num
				var/pixelyoff = input("Type the 'pixel_y' number") as num
				switch(alert(src,"Their client view will be '[clientx]x[clienty]' and their pixel offsets will be: px: [pixelxoff] py: [pixelyoff], do you confirm?","","Yes","Cancel"))
					if("Yes")
						choice.client.view = "[clientx]x[clienty]"
						choice.pixel_y = pixelyoff
						choice.pixel_x = pixelxoff
						choice << "Your view was changed to [clientx]x[clienty] by an admin."
						return

			choice.client.setMap(choice.client)
			choice << "Your view was changed to [option] by an admin."
		// =========================================================
		// ECONOMY / POINTS
		// =========================================================
		if("Give_Zenni")
			var/mob/choice = input("Select a player:") as null|obj|mob in players
			if(!choice) return
			var/amount = input("How much are zenni are you giving them [choice]?") as num
			if(amount <= 1) return
			choice.resources += amount
			choice.refresh_inv()
			world << output("<font color=yellow>(Admin Log): [src] gave [choice] [amount] Zenni","rpspy.output2")
		if("Give_Dokuro_Coins")
			var/mob/choice = input("Select a player:") as null|mob in players
			if(!choice) return
			var/amount = input("How much dokuro coins are you giving them [choice]?") as num
			if(amount < 1) return
			choice.client.dokuro_points += amount
			choice<<"You were gifted <b><font color=yellow>[amount]</font></b> Dokuro coins!"
			choice.set_alert("You were gifted [amount] Dokuro coins!",'alert.dmi',"alert")
			world.log << "(Admin Log): [src.client.admin_name]/[src] gave [choice] [amount] acceleated gains"
		if("Give_Accelerated_Gains")
			var/mob/choice = input("Select a player:") as null|mob in players
			if(!choice) return
			var/amount = input("How much accelerated gains are you giving them [choice]?") as num
			if(amount <= 1) return
			choice.offline_gains += amount
			if(!choice.hud_accelerator)
				var/obj/hud/menus/accelerated_gains_txt/acceleration = new
				choice.hud_accelerator = acceleration
			choice.hud_accelerator.accelerator = choice
			choice.client.screen += choice.hud_accelerator
			choice<<"You were gifted <b><font color=yellow>[amount]</b></font> minute(s) of accelerated gains!"
			choice.set_alert("You were gifted [amount] minute(s) of accelerated gains!",'alert.dmi',"alert")
			world.log << "(Admin Log): [src.client.admin_name]/[src] gave [choice] [amount] accelerated gains"

		// =========================================================
		// STATS / HTT
		// =========================================================
		if("Increase_Stats")
			var/mob/choice = input("Select a player:") as null|obj|mob in players
			if(!choice) return

			switch(input("Which Stat to Increase:") in list("Passive Points","Stance Points","Personal Growth","Rating","Intelligence","Magic","Energy","Power Level","Strength","Endurance","Speed","Force","Resistance","Offence","Defence","Recovery","Regeneration","Gravity"))

				if("Personal Growth")
					var/amount = input("How much are you increasing by?(Becareful, these are mod levels(0.1-5.0+ prefered)") as num
					choice.PG += amount
					world.log << "(Admin Log): [src.client.admin_name] increased [choice] PG by [amount]"

				if("Rating")
					var/amount = input("How much are you increasing by?") as num
					choice.rating += amount
					world.log << "(Admin Log): [src.client.admin_name] increased [choice] Ratings by [amount]"

				if("Power Level")
					var/amount = input("How much are you increasing by?") as num
					choice.psionic_power_base += amount
					world.log << "(Admin Log): [src.client.admin_name] [src] increased [choice] PL by [amount]"

				if("Strength")
					var/amount = input("How much are you increasing by?") as num
					choice.strength += amount
					world.log << "(Admin Log): [src.client.admin_name] [src] increased [choice] Strength by [amount]"

				if("Endurance")
					var/amount = input("How much are you increasing by?") as num
					choice.endurance += amount
					world.log << "(Admin Log): [src.client.admin_name] [src] increased [choice] Endurance by [amount]"

				if("Energy")
					var/amount = input("How much are you increasing by?") as num
					choice.gains_trained_energy += amount
					world.log << "(Admin Log): [src.client.admin_name] [src] increased [choice] Energy by [amount]"

				if("Recovery")
					var/amount = input("How much are you increasing by?(Becareful, these are mod levels(0.1-5.0+ prefered)") as num
					choice.mod_recovery += amount
					world.log << "(Admin Log): [src.client.admin_name] [src] increased [choice] Recovery by [amount]"

				if("Regeneration")
					var/amount = input("How much are you increasing by?(Becareful, these are mod levels(0.1-5.0+ prefered)") as num
					choice.mod_regeneration += amount
					world.log << "(Admin Log): [src.client.admin_name] [src] increased [choice] Regeneration by [amount]"

				if("Gravity")
					var/amount = input("How much are you increasing by?") as num
					choice.gravity_mastered += amount
					world.log << "(Admin Log): [src.client.admin_name] [src] increased [choice] Gravity by [amount]"

				if("Speed")
					var/amount = input("How much are you increasing by?(Becareful, these are mod levels(0.1-5.0+ prefered)") as num
					choice.mod_agility += amount
					world.log << "(Admin Log): [src.client.admin_name] [src] increased [choice] Speed by [amount]"

				if("Force")
					var/amount = input("How much are you increasing by?") as num
					choice.force += amount
					world.log << "(Admin Log): [src.client.admin_name] [src] increased [choice] Force by [amount]"

				if("Resistance")
					var/amount = input("How much are you increasing by?") as num
					choice.resistance += amount
					world.log << "(Admin Log): [src.client.admin_name] [src] increased [choice] Resistance by [amount]"

				if("Offence")
					var/amount = input("How much are you increasing by?") as num
					choice.offence += amount
					world.log << "(Admin Log): [src.client.admin_name] [src] increased [choice] Offence by [amount]"

				if("Defence")
					var/amount = input("How much are you increasing by?") as num
					choice.defence += amount
					world.log << "(Admin Log): [src.client.admin_name] [src] increased [choice] Defence by [amount]"

				if("Passive Points")
					var/amount = input("How much are you increasing by?") as num
					choice.passive_points += amount
					world.log << "(Admin Log): [src.client.admin_name] [src] increased [choice] PPs by [amount]"

				if("Stance Points")
					var/amount = input("How much are you increasing by?") as num
					choice.stance_points += amount
					world.log << "(Admin Log): [src.client.admin_name] [src] increased [choice] SPs by [amount]"

				if("Intelligence")
					var/amount = input("How much are you increasing by?") as num
					choice.intxp += amount
					world.log << "(Admin Log): [src.client.admin_name] [src] increased [choice] QP% by [amount]"

				if("Magic")
					var/amount = input("How much are you increasing by?") as num
					choice.magicxp += amount
					world.log << "(Admin Log): [src.client.admin_name] [src] increased [choice] Magic by [amount]"

		if("Increase_HTT")
			var/mob/choice = input("Select a player:") as null|obj|mob in players
			if(!choice) return
			var/selection = input("Select a variable:") in list("Cancel","Hunger","Thirst","Tiredness")
			switch(selection)
				if("Hunger")
					var/amount = input("How much are you increasing their hunger by?") as num
					if(amount <= 1) return
					choice.hunger += amount
					world << output("<font color=yellow>(Admin Log): [src] increased [choice] Hunger by [amount]!","rpspy.output2")
				if("Thirst")
					var/amount = input("How much are you increasing their thirst by?") as num
					if(amount <= 1) return
					choice.thirst += amount
					world << output("<font color=yellow>(Admin Log): [src] increased [choice] Thirst by [amount]!","rpspy.output2")
				if("Tiredness")
					var/amount = input("How much are you increasing their tiredness by?") as num
					if(amount <= 1) return
					choice.restedness += amount
					world << output("<font color=yellow>(Admin Log): [src] increased [choice] Tiredness by [amount]!","rpspy.output2")

		// =========================================================
		// TRANSFORMATION
		// =========================================================
		if("Force_Transformation")
			var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
			if(!choice) return
			choice.Transformation(1,1)
			src << "You successfully transformed [choice]."
			world.log << "(Admin Log): [src.client.admin_name] transformed [choice]"
		if("Give_LSSJ")
			var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
			if(!choice) return

			if("Saiyan")
				choice.apply_A_type_mutation()
				choice << "You successfully transformed [choice] into a LSSJ spawn."
				world.log << "(Admin Log): [src.client.admin_name] transformed [choice] into LSSJ!"
			else
				src<< "[choice] is not a Saiyan!"
				return


		// =========================================================
		// RANKS
		// =========================================================
		if("Remove_Rank")
			var/mob/choice = input("Select a player:") as null|mob in players
			if(!choice) return
			if(choice.occupation)
				switch(alert(src,"[choice.real_name]'s current rank is [choice.occupation], are you wishing to remove this?","","Yes","Cancel"))
					if("Yes")
						if(choice.owns_planets >= 1)
							choice.occupation = "Planet Owner"
							choice.rank = 0
						else
							choice.occupation = "None"
							choice.rank = 0
						world.log << "(Admin Log): [src.client.admin_name] [src] removed [choice]'s rank"

		if("Set_Rank")
			var/mob/choice = input("Select a player:") as null|mob in players
			if(!choice) return

			switch(input(src,"What planet is this rank for?") in list("Earth","Namek","Vegeta","Icer","Space","Other Realm","Dark Realm","Hell"))

				if("Hell")
					switch(input("Which rank:") in list("Demon Lord","Vice Demon Lord","Academy Master"))
						if("Demon Lord")
							choice.occupation = "Demon Lord"
							choice.rank = 4
						if("Vice Demon Lord")
							choice.occupation = "Vice Demon Lord"
							choice.rank = 3
						if("Academy Master")
							choice.occupation = "Acad. Master"
							choice.rank = 2

				if("Dark Realm")
					switch(input("Which rank:") in list("Supreme Demon Lord","Vice Supreme Demon Lord","Academy Master"))
						if("Supreme Demon Lord")
							choice.occupation = "Spr.DemonLord"
							choice.rank = 4
						if("Vice Supreme Demon Lord")
							choice.occupation = "V.Spr.DemonLord"
							choice.rank = 3
						if("Academy Master")
							choice.occupation = "Acad. Master"
							choice.rank = 2

				if("Other Realm")
					switch(input("Which rank:") in list("Supreme Kaioshin","North Kai","South Kai","East Kai","West Kai","Checkpoint Guardian"))
						if("Supreme Kaioshin")
							choice.occupation = "Supreme Kai"
							choice.rank = 4
						if("North Kai")
							choice.occupation = "North Kai"
							choice.rank = 4
						if("South Kai")
							choice.occupation = "South Kai"
							choice.rank = 4
						if("East Kai")
							choice.occupation = "East Kai"
							choice.rank = 4
						if("West Kai")
							choice.occupation = "West Kai"
							choice.rank = 4
						if("Checkpoint Guardian")
							choice.occupation = "Chpnt. Guardian"
							choice.rank = 3

				if("Space")
					switch(input("Which rank:") in list("Space Pirate","Yardrat Master"))
						if("Space Pirate")
							choice.occupation = "Space Pirate"
							choice.rank = 3
						if("Yardrat Master")
							choice.occupation = "Yrdrt Master"
							choice.rank = 3

				if("Earth")
					switch(input("Which rank:") in list("Earth Guardian","Crane Hermit","Turtle Hermit","Red Ribbon Army Leader","Academy Master"))
						if("Earth Guardian")
							choice.occupation = "Guardian"
							choice.rank = 4
							global.hbtc_time = 270
							choice.kept_body = 1
							choice << output("The Hyperbolical Time Chamber has calmed down.","actionoutput")
						if("Crane Hermit")
							choice.occupation = "Hermit(C)"
							choice.rank = 4
						if("Turtle Hermit")
							choice.occupation = "Hermit(T)"
							choice.rank = 4
						if("Red Ribbon Army Leader")
							choice.occupation = "R.R.Leader"
							choice.rank = 3
						if("Academy Master")
							choice.occupation = "Acad. Master"
							choice.rank = 2

				if("Namek")
					switch(input("Which rank:") in list("Namek Elder","Academy Master"))
						if("Namek Elder")
							choice.occupation = "Elder"
							choice.rank = 4
						if("Academy Master")
							choice.occupation = "Acad. Master"
							choice.rank = 2

				if("Vegeta")
					switch(input("Which rank:") in list("King/Queen","General","Royalty","Academy Master"))
						if("King/Queen")
							if(choice.gen == "Female") choice.occupation = "Queen"
							if(choice.gen == "Male") choice.occupation = "King"
							choice.rank = 4
						if("General")
							choice.occupation = "Saiyan General"
							choice.rank = 3
						if("Royalty")
							choice.occupation = "Royalty"
							choice.rank = 2
						if("Academy Master")
							choice.occupation = "Acad. Master"
							choice.rank = 2

				if("Icer")
					switch(input("Which rank:") in list("Icer Lord","General","Academy Master"))
						if("Icer Lord")
							choice.occupation = "Icer Lord"
							choice.rank = 4
						if("General")
							choice.occupation = "Icer General"
							choice.rank = 3
						if("Academy Master")
							choice.occupation = "Acad. Master"
							choice.rank = 2

			choice.percent_health = 100
			choice.percent_energy = 100
			world << output("<font color=yellow>(Admin Log): [src] gave [choice] a rank([choice.occupation])","rpspy.output2")

		// =========================================================
		// OBJECTS / CREATION
		// =========================================================
		if("Create_Custom_Icon_Object")
			new /obj/items/custom_icon_object(src.loc)
			src << "Created a Custom Icon Object at your location. Right-click it while in your inventory to customize."


		// =========================================================
		// LIMBS
		// =========================================================
		if("Damage_Limb")
			var/mob/races/choice = input("Select a player:") as null|obj|mob in players
			if(!choice) return
			var/option = input("Select the limb") in list("Cancel","Right Arm","Right Leg","Left Arm","Left Leg","All")
			var/damage = input("How much are you damaging this by?\nTip: 0-100%") as num
			if(option == "Cancel") return
			if(damage<=0) return
			if(option == "All")
				for(var/obj/body_related/bodyparts/p in choice.body)
					if(p)
						choice.damage_limb(src,0, 1, damage,p)
						src<<"You damaged [choice]'s [option] by [damage]."
			else
				for(var/obj/body_related/bodyparts/p in choice.body)
					if(p)
						if(p.name == option || p.name == "[option]")
							choice.damage_limb(src,0, 1, damage,p)
							src<<"You damaged [choice]'s [option] by [damage]."



			// NOTE: your snippet shows only the menu for Restore Limb, not the actual restore logic.
			// If you have a restore proc (common names: restore_limb(), regrow_limb(), etc.),
			// call it here EXACTLY as your codebase does.
			// Placeholder message to avoid breaking compile if no proc is known:
		//	src << "Restore Limb: logic not present in the provided snippet. Hook your existing restore proc here."
		if("Restore_Limb")
			var/mob/choice = input("Select a player:") as null|obj|mob in players
			if(!choice) return
			var/option = input("Select the limb") in list("Cancel","Right Arm","Right Leg","Left Arm","Left Leg","All")
			if(option == "Cancel") return
			// NOTE: your snippet shows only the menu for Restore Limb, not the actual restore logic.
			// If you have a restore proc (common names: restore_limb(), regrow_limb(), etc.),
			// call it here EXACTLY as your codebase does.
			// Placeholder message to avoid breaking compile if no proc is known:
			src << "Restore Limb: logic not present in the provided snippet. Hook your existing restore proc here."

		if("Remove_Limb")
			var/mob/choice = input("Select a player:") as null|obj|mob in players
			if(!choice) return
			var/option = input("Select the limb") in list("Cancel","Right Arm","Right Leg","Left Arm","Left Leg","All")
			if(option == "Cancel") return

			if(option == "All")
				for(var/obj/body_related/bodyparts/right_arm/limb in choice.bodyparts)
					check_maim_limb(src, limb, choice, 1)

				for(var/obj/body_related/bodyparts/left_leg/limb in choice.bodyparts)
					check_maim_limb(src, limb, choice, 1)
				for(var/obj/body_related/bodyparts/left_arm/limb in choice.bodyparts)
					check_maim_limb(src, limb, choice, 1)
				for(var/obj/body_related/bodyparts/right_leg/limb in choice.bodyparts)
					check_maim_limb(src, limb, choice, 1)
				return

			if(option == "Right Arm")
				for(var/obj/body_related/bodyparts/right_arm/limb in choice.bodyparts)
					check_maim_limb(src, limb, choice, 1)
					return

			if(option == "Left Arm")
				for(var/obj/body_related/bodyparts/left_arm/limb in choice.bodyparts)
					check_maim_limb(src, limb, choice, 1)
					return

			if(option == "Right Leg")
				for(var/obj/body_related/bodyparts/right_leg/limb in choice.bodyparts)
					check_maim_limb(src, limb, choice, 1)
					return

			if(option == "Left Leg")
				for(var/obj/body_related/bodyparts/left_leg/limb in choice.bodyparts)
					check_maim_limb(src, limb, choice, 1)
					return

		// =========================================================
		// PLANET TELEPORT
		// =========================================================

		if("Planet_Teleport")
			var/planets = list("Earth"=1, "Namek"=4, "Vegeta"=10, "Icer"=9, "Other Realm"=2, "Heaven"=11, "Hell"=6, "Dark Realm"=12, "Space"=16)
			var/planet = input("Where are you teleporting too?") in planets
			if(planet)
				var/z_level = planets[planet]
				var/y_rand = (planet == "Heaven") ? rand(5,490) : rand(5,480)
				src.loc = locate(rand(5,480), y_rand, z_level)
				src.check_glow_planes()
				world.log << "(Admin Log): [src.client.admin_name] used Planet Teleport"

		// =========================================================
		// WORLD BOSS CONTROL & LOOT TESTING
		// =========================================================
		if("Test_Loot_Roll")
			BuildTechItemCache()

			if(!TECH_ITEM_TYPES.len)
				src << "No tech items cached."
				return

			// Pick random tech item
			var/path = pick(TECH_ITEM_TYPES)
			var/obj/items/tech/I = new path(src.loc)

			// Gather real nearby players
			var/list/eligible = list()
			for(var/mob/M in view(10, src))
				if(M.client)
					eligible += M

			// Create loot roll
			var/datum/loot_roll/L = new(I, eligible)

			// If too few players, inject fake ones
			if(eligible.len < 2)
				L.fake_ckeys = GenerateFakeRollers(rand(2,4))
				usr << "Loot Test: Injected fake players."

			usr << "<b>Loot Test Started:</b> [I.name]"

		if("World_Boss_Control")

			var/status = GetWorldBossStatusText()

			var/choice = alert(
				src,
				"[status]\n\nDo you want to FORCE SPAWN all World Bosses now?\n(This does NOT cancel the official weekend timer.)",
				"World Boss Control",
				"Force Spawn",
				"Cancel"
			)

			if(choice != "Force Spawn")
				return

			switch(alert(src,"Are you absolutely sure?","","Yes","No"))
				if("No") return

			// Force start for today
			for(var/datum/worldboss_controller/C in WORLD_BOSS_CONTROLLERS)
				C.StartDay()

			world << "<b><font color=#ff9933>WORLD BOSS EVENT:</font> <font color=white>World Bosses have been manually summoned by an administrator.</font></b>"
			world.log << "(Admin Log): [src.client.admin_name] force-spawned World Bosses"

/// Sorts a list by its keys
/proc/sort_list(list/L)
	if(!L || !L.len) return L
	var/list/sorted = list()
	var/list/keys = L.Copy()
	sort_text(keys) 
	for(var/key in keys)
		sorted[key] = L[key]
	return sorted

/// Sorts a list of text values alphabetically
/proc/sort_text(list/src)
	for(var/i = 1, i < length(src), i++)
		for(var/j = 1, j <= length(src) - i, j++)
			if(text2num(src[j]) > text2num(src[j+1]))
				var/temp = src[j]
				src[j] = src[j+1]
				src[j+1] = temp
	return src

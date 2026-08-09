var/regex/quote = new/regex("(?:\\x22)(\[^\\x22]*)(?:\\x22|$)","g")

proc
	quotify(msg,color)
		return quote.Replace(msg,{""<font color=[color]>$1</font>""})

proc/Send_OOC_To_Discord(name, msg)
	var/data = json_encode(list(
		"username" = name,
		"message" = msg
	))

	var/result = world.Export("http://localhost:61121/ooc", data, "application/json")

	if(islist(result))
		var/status = result["status"]
		world.log << "✅ Relay responded with HTTP status: [status]"
	else
		world.log << "❌ Failed to reach local relay server."


/*
proc/Send_OOC_To_Discord(name, msg)
	var/webhook_url = "https://discord.com/api/webhooks/1463164884765118616/S4LzVhvnjjcEIaoeKccxyvOXsnpgGlK-Vx8Iy1n1IEvIhVmCDGubLQHvA-NnVjTQYenZ" // your full working webhook

	var/json = json_encode(list(
		"username" = name,
		"content" = msg
	))

	var/result = world.Export(list(
		"url" = webhook_url,
		"body" = json,
		"headers" = list("Content-Type" = "application/json")
	))

	if(islist(result))
		var/status = result["status"]
		var/response = result["body"]
		world.log << "HTTP status: [status]"
		world.log << "Response body: [response]"
	else
		world.log << "No result returned from Export()"

*/
mob/proc/save_portrait_icon()
	if(!src.port) return
	for(var/atom/movable/A in src.port.vis_contents)
		if(A.icon)
			src.portrait_contents += A
mob/proc/GetPortraitIcon()
	if(!src.port || !src.port.icon) return null

	var/icon/I = icon(src.port.icon, src.port.icon_state)
	if(!I) return null

	// Blend vis_contents overlays
	for(var/atom/movable/A in src.port.vis_contents)
		if(A.icon)
			var/icon/O = icon(A.icon, A.icon_state)
			if(O)
				I.Blend(O, ICON_OVERLAY)

	I.Scale(64,82) // Or 48x48 if you want slightly bigger

	return I


mob/proc/format_message(var/mob/M, message, text_color)
	var/formatted_name="<font color=[src.text_color_ic]>[src.name]</font>"
	var/formatted_message="<font color=yellow>[message]</font>"
	var/regex/quote_regex = new/regex(".*")             //@{"(["'])(?:(?=(\\?))\2.)*?\1"}) //""([^"]*)""})
	var/quote_match= quote_regex.Find(message)
	while(quote_match)
		var/quote=quote_regex.group[1]
		var/colored_quote="<font color=[src.text_color_ic]>[quote]</font>"
		formatted_message=replacetext(formatted_message,@{"[quote]"},colored_quote)
		quote_match=quote_regex.Find(message,quote_match+1)
		sleep(0.1)
	return "[formatted_name]:[formatted_message]"
mob/proc/save_chat_log(message, is_ooc = 0)
	/*if(!key || !message) return

	var/log_folder = "saves/players/[key]/Logs/"
	log_folder += (is_ooc) ? "OOC/" : "IC/"
	var/date = time2text(world.realtime, "YYYY-MM-DD")
	var/full_path = "[log_folder][date].txt"

	var/timestamp = time2text(world.realtime, "hh:mm:ss")
	var/entry = "[timestamp] - [name]: [message]\\n"

	text2file(entry, full_path, -1)
	*/
	return
client
	var
		tmp/say_type=0
mob/var/say=1
mob/var/shout = 0
client/verb
	toggleSay()
		set hidden=1
		if(!mob:shout)
			say_type=1
			usr.say=0
			usr.shout=1
			winset(src,"chat.toggleChat","text=Shout")
		else
			say_type=0
			usr.say=1
			usr.shout=0
			winset(src,"chat.toggleChat","text=Say")


	checkSay()
		set hidden=1
		if(!istype(mob,/mob/player))return
		switch(usr.say)
			if(0)
				say_type=1
				usr.say=1
				winset(src,"chat.toggleChat","text=Shout")
			if(5)
				say_type=2
				usr.say=2
				winset(src,"chat.toggleChat","text=Emote")

			if(1)
				say_type=0
				usr.say=0
				winset(src,"chat.toggleChat","text=Say")

/proc/stars(n, pr)	//Use if someone can't understand what's being said

	if (pr == null)
		pr = 25
	if (pr <= 0)
		return null
	else
		if (pr >= 100)
			return n
	var/te = n
	var/t = ""
	n = length(n)
	var/p = null
	p = 1
	while(p <= n)
		if ((copytext(te, p, p + 1) == " " || prob(pr)))
			t = text("[][]", t, copytext(te, p, p + 1))
		else
			t = text("[]*", t)
		p++
		//sleep(0.2)
	return t
/proc/cough(n)
	var/te = html_decode(n)
	var/t = ""
	n = length(n)
	var/p = null
	p = 1
	while(p <= n)
		var/n_letter = copytext(te, p, p + 1)
		if (prob(5))
			if (prob(!50))
				n_letter = text("*cough*-*cough*")
			else
				if (prob(1))
					n_letter = text("*cough*-*groan*-*cough*")
				else
					if (prob(3))
						n_letter = null
					else
						n_letter = text("[n_letter]-*cough*")
		t = text("[t][n_letter]")
		p++

	return copytext(sanitize(t),1,MAX_MESSAGE_LEN)
/proc/stutter(n)	//Returns a staggered version of input
	var/te = html_decode(n)
	var/t = ""
	n = length(n)
	var/p = null
	p = 1
	while(p <= n)
		var/n_letter = copytext(te, p, p + 1)
		if (prob(40))
			if (prob(10))
				n_letter = text("[n_letter][n_letter]-[n_letter]")
			else
				if (prob(20))
					n_letter = text("[n_letter]-*cough*-[n_letter]")
				else
					if (prob(5))
						n_letter = null
					else
						n_letter = text("[n_letter]-*cough*")
		t = text("[t][n_letter]")
		p++

	return copytext(sanitize(t),1,MAX_MESSAGE_LEN)

mob/proc/ICText(A as text,mob/M)
	var/remainingtext=A
	var/output
	loop
	if(findtext(remainingtext,"&#34;"))
		var/speaker_color = M.text_color_ic ? M.text_color_ic : "#FFFFFF"
		output+=copytext(remainingtext,1,findtext(remainingtext,"&#34;"))
		output+="<font color=[speaker_color]>\[[M.lan]\] &#34;"
		remainingtext=copytext(remainingtext,findtext(remainingtext,"&#34;")+5,0)
		if(findtext(remainingtext,"&#34;"))
			output+=M.LanguageSay(copytext(remainingtext,1,findtext(remainingtext,"&#34;")),src.lan,src.lan.Mastery,src)
		//	if(findtext(copytext(remainingtext,1,findtext(remainingtext,"&#34;")),M.name))
			output+="&#34;<span class=\"emote\">"
			remainingtext=copytext(remainingtext,findtext(remainingtext,"&#34;")+5,0)
			goto loop
		else output+=M.LanguageSay(remainingtext,src.lan,src.lan.Mastery,src)
	else output+=remainingtext
	return output
proc
	say_quote(var/text)
		var/ending = copytext(text, length(text))

		if (ending == "?")
			return "asks, '[text]'";
		else if (ending == "!")
			return "exclaims, '[text]'";
		else if (ending == ")" || ending == "]" || ending == "}")
			return "oocly says, '[text]'";

		return "says, '[text]'";
	sanitize(var/t)
		var/index = findtext(t, "\n")
		while(index)
			t = copytext(t, 1, index) + "#" + copytext(t, index+1)
			index = findtext(t, "\n")


		index = findtext(t, "\t")
		while(index)
			t = copytext(t, 1, index) + "#" + copytext(t, index+1)
			index = findtext(t, "\t")


		return html_encode(t)
	replace_quotations(text, open, close)
		if(!text || !open || !close) return
		var/quotation = "\""
		var/is_open = FALSE
		var/position = 0
		var/last_start
		var/result = ""
		for()
			last_start = position + 1
			position = findtext(text, quotation, last_start)
			if(!position)
				return "[result][copytext(text, last_start)]"
			else if(copytext(text, position - 1, position) == "\\")
				result = "[result][copytext(text, last_start, position + 1)]"
			else
				is_open = !is_open
				result = "[result][copytext(text, last_start, position)][is_open ? open : close]"
var/mob/say_spark
obj/Quotations
	layer=1000
	icon='TextOptIcons.dmi'

obj/SubQuotes
	layer=1000
	icon='starsubicons.dmi'
	icon_state="1"
obj/SaySpark
	layer=1000
	icon='saybubble.dmi'
	plane=32
obj/SaySpark2
	layer=1000
	plane=32
	icon='say_alert.dmi'

obj/ShoutSpark
	layer=1000
	plane=0
	icon='shoutbubble.dmi'
obj/RoleplaySpark
	layer=1000
	plane=0
	icon='roleplayalertD.dmi'
mob/proc/Roleplay_Spark()
	var/obj/RoleplaySpark/A=new
	var/icon/RP=new(A.icon)
	RP.Blend((TextColor),ICON_MULTIPLY)
	A.icon=RP.icon
	A.pixel_y+=10
	src.overlays.Add(A)
	say_spark = A
	spawn(20) if(src) src.overlays.Remove(A)

mob/proc/get_strangername(var/mob/m, var/placeholder_name)

    //if(!m)
       // return placeholder_name ? placeholder_name : "Unknown"


    if(m.real_name in src.known_people)
        if(m.fullname != null|| m.fullname == "") return "[m.real_name]"
        else return "[m.fullname]"
    else if(m.npc)
        return"[m.real_name]"

    // If I'm looking at myself
    else if(src == m)
        return "[m.real_name]"


    // Otherwise
    else return "Unknown"
mob
	proc
		/*get_strangername(var/mob/m,var/placeholder_name)
			if(m.npc == 1) return "[m.fullname]"

			if(m)
				if(m.fullname in src.known_people || m.fullname == src.fullname || m.real_name in src.known_people)
					if(m.fullname != null|| m.fullname == "") return "[m.real_name]"
					else return "[m.fullname]"
				else return "Unknown"
			else if(placeholder_name)
				if(placeholder_name in src.known_people || placeholder_name == src.fullname)
					return "[placeholder_name]"*/


		create_chat_entry(var/chosen_tab,var/text,var/emote=0,var/plain=0)
			if(src.client == null) return
			var/obj/hud/menus/chat_background/c = src.hud_chat
			var/raw_string = null
			var/speaker = null


			if(chosen_tab == "local")
				if(emote==1)
					speaker ="<b><font color = yellow>*[src.real_name]"
				else if(emote ==0 && plain ==0)
					speaker = "<b><font color = [src.text_color_ic]>[src.real_name]</b> says, "
				else if(plain ==1)
					speaker = ""

			else if(chosen_tab == "world")
				speaker = "<b><font size=0.3><font color = [src.auracolor]>[src.key]</b>: "
			else if(chosen_tab == "alerts")
				speaker = "<b>Alert</b>: "
			else if(chosen_tab == "system")
				speaker = "<b>System</b>: "

			var/obj/hud/o = src.typing
			if(o == null) o = c.input

			if(text == null)
				raw_string = c.input.string_full
			else raw_string = text

			if(o == c.input)
				//If the length of the text the player sends is too large, prevent it from happening. Should help stop lag from huge spam/posts.
				if(length(raw_string) >= 9999)
					src.set_alert("Message too long",'alert.dmi',"alert")
					//src.create_chat_entry("alerts","Message too long.")
					return
				var/string = "[css_outline]<font size = 0.5><left>[speaker]'[raw_string]'"
				var/L = src.client.MeasureText(string,width = 300)

				//Calculate how big the new entries maptext_width should be based on the x axis of the text and MeasureText()
				var/x_pos = findtext(L, "x")
				var/L_x = copytext(L, 1, x_pos)
				L_x = text2num(L_x)
				if(L_x <= 0)
					return

				//Calculate how big the new entries maptext_height should be based on the y axis of the text and MeasureText()
				var/y_pos = findtext(L, "x")
				var/L_y = copytext(L, y_pos+1, 0)
				L_y = text2num(L_y)
				if(L_y <= 0)
					return

				//Adjust the local text
				if(chosen_tab == "local")
					if(emote==1)
						string = "[css_outline]<b><font color = yellow><left>[speaker] [raw_string]*</font></b>"
					else if(emote==0)
						string = "[css_outline]<font color = white><font size = 1><left>[speaker]'[raw_string]'"
					else if(plain==1)
						string = "[css_outline]<font color = white><font size=0.5><left>[raw_string]"
					for(var/mob/m in view(18,src))
						if(m.client && m.hud_chat)
							var/obj/hud/menus/chat_background/h_chat = m.hud_chat
							var/obj/hud/menus/chat_background/scroller = h_chat.scroller_local
							var/obj/hud/menus/chat_background/chat_entry/entry = h_chat.entry_local
							h_chat.local_size += (L_y+13)
							entry.maptext_height += (L_y+13)
							entry.maptext_y -= (L_y+13)
							entry.maptext += "\n\n[string]"
							if(scroller && h_chat.local_size > 0)
								if(scroller.translated_y == -62)
									//If the player is already scrolled down to the bottom of the chat, make sure to keep moving the chat/scroller down for them.
									var/matrix/m_scroller = matrix()
									m_scroller.Translate(0,scroller.translated_y)
									scroller.transform = m_scroller
									scroller.local_scroll_y = h_chat.local_size

									var/matrix/mat_local = matrix()
									mat_local.Translate(entry.hud_x,entry.hud_y+h_chat.local_size)
									entry.translated_y = scroller.local_scroll_y
									entry.transform = mat_local
					if(emote) emote=0
				//Adjust the world/global text
				else if(chosen_tab == "world")
					string = "[css_outline]<font size = 1><left>[speaker][raw_string]"
					for(var/mob/m in players)
						if(m.hud_chat)
							var/obj/hud/menus/chat_background/h_chat = m.hud_chat
							var/obj/hud/menus/chat_background/scroller = h_chat.scroller_global
							var/obj/hud/menus/chat_background/chat_entry/entry = h_chat.entry_global
							h_chat.global_size += (L_y+13)
							entry.maptext_height += (L_y+13)
							entry.maptext_y -= (L_y+13)
							entry.maptext += "\n\n[string]"
							if(scroller && h_chat.global_size > 0)
								if(scroller.translated_y == -62)
									//If the player is already scrolled down to the bottom of the chat, make sure to keep moving the chat/scroller down for them.
									var/matrix/m_scroller = matrix()
									m_scroller.Translate(0,scroller.translated_y)
									scroller.transform = m_scroller
									scroller.global_scroll_y = h_chat.global_size

									var/matrix/mat_global = matrix()
									mat_global.Translate(entry.hud_x,entry.hud_y+h_chat.global_size)
									entry.translated_y = scroller.global_scroll_y
									entry.transform = mat_global
				//Adjust the alerts text
				else if(chosen_tab == "alerts")
					string ="[css_outline]<font size = 1><left>[speaker][raw_string]"
					var/mob/m = src
					if(m.hud_chat)
						var/obj/hud/menus/chat_background/h_chat = m.hud_chat
						var/obj/hud/menus/chat_background/scroller = h_chat.scroller_alerts
						var/obj/hud/menus/chat_background/chat_entry/entry = h_chat.entry_alerts
						h_chat.alerts_size += (L_y+13)
						entry.maptext_height += (L_y+13)
						entry.maptext_y -= (L_y+13)
						entry.maptext += "\n\n[string]"
						if(scroller && h_chat.alerts_size > 0)
							if(scroller.translated_y == -62)
								//If the player is already scrolled down to the bottom of the chat, make sure to keep moving the chat/scroller down for them.
								var/matrix/m_scroller = matrix()
								m_scroller.Translate(0,scroller.translated_y)
								scroller.transform = m_scroller
								scroller.alerts_scroll_y = h_chat.alerts_size

								var/matrix/mat_alerts = matrix()
								mat_alerts.Translate(entry.hud_x,entry.hud_y+h_chat.alerts_size)
								entry.translated_y = scroller.alerts_scroll_y
								entry.transform = mat_alerts
				//Adjust the system text
				else if(chosen_tab == "system")
					string = "[css_outline]<font size = 1><left>[speaker][raw_string]"
					var/mob/m = src
					if(m.hud_chat)
						var/obj/hud/menus/chat_background/h_chat = m.hud_chat
						var/obj/hud/menus/chat_background/scroller = h_chat.scroller_system
						var/obj/hud/menus/chat_background/chat_entry/entry = h_chat.entry_system
						h_chat.system_size += (L_y+13)
						entry.maptext_height += (L_y+13)
						entry.maptext_y -= (L_y+13)
						entry.maptext += "\n\n[string]"
						if(scroller && h_chat.system_size > 0)
							if(scroller.translated_y == -62)
								//If the player is already scrolled down to the bottom of the chat, make sure to keep moving the chat/scroller down for them.
								var/matrix/m_scroller = matrix()
								m_scroller.Translate(0,scroller.translated_y)
								scroller.transform = m_scroller
								scroller.system_scroll_y = h_chat.system_size

								var/matrix/mat_system = matrix()
								mat_system.Translate(entry.hud_x,entry.hud_y+h_chat.system_size)
								entry.translated_y = scroller.system_scroll_y
								entry.transform = mat_system

		/*
		create_chat_entry(var/chosen_tab,var/text)
			if(src.client == null) return
			var/obj/hud/menus/chat_background/c = src.hud_chat
			var/obj/hud/menus/chat_background/tab = null
			var/raw_string = null
			var/speaker = null

			if(chosen_tab == "local")
				tab = c.tab_local
				speaker = "<b>[src.real_name]</b>: "
			else if(chosen_tab == "world")
				tab = c.tab_global
				speaker = "<b>[src.key]</b>: "
			else if(chosen_tab == "alerts")
				tab = c.tab_alerts
				speaker = "<b>Alert</b>: "
			else if(chosen_tab == "system")
				tab = c.tab_system
				speaker = "<b>System</b>: "

			var/obj/hud/o = src.typing
			if(o == null) o = c.input

			if(text == null)
				raw_string = c.input.string_full
			else raw_string = text

			if(o == c.input)
				//If the length of the text the player sends is too large, prevent it from happening. Should help stop lag from huge spam/posts.
				if(length(raw_string) >= 1000)
					src.set_alert("Message too long",'alert.dmi',"alert")
					src.create_chat_entry("alerts","Message too long.")
					return
				var/scroll_y = 0
				var/entry_x = 0
				var/entry_y = 0
				var/string = "[css_outline]<font size = 1><left>[speaker][raw_string]"
				var/L = src.client.MeasureText(string,width = 300)

				//Calculate how big the new entries maptext_width should be based on the x axis of the text and MeasureText()
				var/x_pos = findtext(L, "x")
				var/L_x = copytext(L, 1, x_pos)
				L_x = text2num(L_x)
				if(L_x <= 0)
					return

				//Calculate how big the new entries maptext_height should be based on the y axis of the text and MeasureText()
				var/y_pos = findtext(L, "x")
				var/L_y = copytext(L, y_pos+1, 0)
				L_y = text2num(L_y)
				if(L_y <= 0)
					return

				//Adjust the local text
				if(tab == c.tab_local)
					for(var/mob/m in view(18,src))
						if(m.client && m.hud_chat)
							var/obj/hud/menus/chat_background/h_chat = m.hud_chat
							var/obj/hud/menus/chat_background/scroller = h_chat.scroller_local
							entry_x = h_chat.local_x
							entry_y = h_chat.local_y
							scroll_y = h_chat.local_scroll_y
							h_chat.local_y -= (L_y+6)
							h_chat.local_size += (L_y+6)
							//Create an chat entry for every player nearby and give them a copy
							var/obj/hud/menus/chat_background/chat_entry/entry = new
							entry.hud_x = entry_x
							entry.hud_y = entry_y
							entry.entry_size_y = L_y
							var/matrix/mat = matrix()
							mat.Translate(entry.hud_x,entry.hud_y+scroll_y)
							entry.transform = mat
							entry.maptext_height = L_y
							entry.maptext_y -= (L_y+6)
							entry.maptext = string
							//Display text to all players nearby, then put the entry into the holders entries list so it can be reloaded.
							if(h_chat.txt_display_local)
								h_chat.txt_display_local.vis_contents += entry
								h_chat.txt_display_local.entries_local += entry
							if(scroller && h_chat.local_size > 0)
								if(scroller.translated_y == -62)
									//If the player is already scrolled down to the bottom of the chat, make sure to keep moving the chat/scroller down for them.
									var/matrix/m_scroller = matrix()
									m_scroller.Translate(0,scroller.translated_y)
									scroller.transform = m_scroller
									scroller.local_scroll_y = h_chat.local_size
									//Move all the text down too, if the scroller is set to track the chat.
									for(var/obj/txt in h_chat.txt_display_local.vis_contents)
										var/matrix/mat_local = matrix()
										mat_local.Translate(txt.hud_x,txt.hud_y+h_chat.local_size)
										txt.translated_y = scroller.local_scroll_y
										txt.transform = mat_local
				//Adjust the world/global text
				else if(tab == c.tab_global)
					for(var/mob/m in players)
						if(m.hud_chat)
							var/obj/hud/menus/chat_background/h_chat = m.hud_chat
							var/obj/hud/menus/chat_background/scroller = h_chat.scroller_global
							entry_x = h_chat.global_x
							entry_y = h_chat.global_y
							scroll_y = h_chat.global_scroll_y
							h_chat.global_y -= (L_y+6)
							h_chat.global_size += (L_y+6)
							//Create an chat entry for every player nearby and give them a copy
							var/obj/hud/menus/chat_background/chat_entry/entry = new
							entry.hud_x = entry_x
							entry.hud_y = entry_y
							entry.entry_size_y = L_y
							var/matrix/mat = matrix()
							mat.Translate(entry.hud_x,entry.hud_y+scroll_y)
							entry.transform = mat
							entry.maptext_height = L_y
							entry.maptext_y -= (L_y+6)
							entry.maptext = string
							//Display text to all players nearby, then put the entry into the holders entries list so it can be reloaded.
							if(h_chat.txt_display_global)
								h_chat.txt_display_global.vis_contents += entry
								h_chat.txt_display_global.entries_global += entry
							if(scroller && h_chat.global_size > 0)
								if(scroller.translated_y == -62)
									//If the player is already scrolled down to the bottom of the chat, make sure to keep moving the chat/scroller down for them.
									var/matrix/m_scroller = matrix()
									m_scroller.Translate(0,scroller.translated_y)
									scroller.transform = m_scroller
									scroller.global_scroll_y = h_chat.global_size
									//Move all the text down too, if the scroller is set to track the chat.
									for(var/obj/txt in h_chat.txt_display_global.vis_contents)
										var/matrix/mat_global = matrix()
										mat_global.Translate(txt.hud_x,txt.hud_y+h_chat.global_size)
										txt.translated_y = scroller.global_scroll_y
										txt.transform = mat_global
				//Adjust the alerts text
				else if(tab == c.tab_alerts)
					var/mob/m = src
					if(m.hud_chat)
						var/obj/hud/menus/chat_background/h_chat = m.hud_chat
						var/obj/hud/menus/chat_background/scroller = h_chat.scroller_alerts
						entry_x = h_chat.alerts_x
						entry_y = h_chat.alerts_y
						scroll_y = h_chat.alerts_scroll_y
						h_chat.alerts_y -= (L_y+6)
						h_chat.alerts_size += (L_y+6)
						//Create an chat entry for every player nearby and give them a copy
						var/obj/hud/menus/chat_background/chat_entry/entry = new
						entry.hud_x = entry_x
						entry.hud_y = entry_y
						entry.entry_size_y = L_y
						var/matrix/mat = matrix()
						mat.Translate(entry.hud_x,entry.hud_y+scroll_y)
						entry.transform = mat
						entry.maptext_height = L_y
						entry.maptext_y -= (L_y+6)
						entry.maptext = string
						//Display text to player, then put the entry into the holders entries list so it can be reloaded.
						if(h_chat.txt_display_alerts)
							h_chat.txt_display_alerts.vis_contents += entry
							h_chat.txt_display_alerts.entries_alerts += entry
						if(scroller && c.alerts_size > 0)
							if(scroller.translated_y == -62)
								//If the player is already scrolled down to the bottom of the chat, make sure to keep moving the chat/scroller down for them.
								var/matrix/m_scroller = matrix()
								m_scroller.Translate(0,scroller.translated_y)
								scroller.transform = m_scroller
								scroller.alerts_scroll_y = c.alerts_size
								//Move all the text down too, if the scroller is set to track the chat.
								for(var/obj/txt in c.txt_display_alerts.vis_contents)
									var/matrix/mat_alerts = matrix()
									mat_alerts.Translate(txt.hud_x,txt.hud_y+c.alerts_size)
									txt.translated_y = scroller.alerts_scroll_y
									txt.transform = mat_alerts
				//Adjust the system text
				else if(tab == c.tab_system)
					var/mob/m = src
					if(m.hud_chat)
						var/obj/hud/menus/chat_background/h_chat = m.hud_chat
						var/obj/hud/menus/chat_background/scroller = h_chat.scroller_system
						entry_x = h_chat.system_x
						entry_y = h_chat.system_y
						scroll_y = h_chat.system_scroll_y
						h_chat.system_y -= (L_y+6)
						h_chat.system_size += (L_y+6)
						//Create an chat entry for every player nearby and give them a copy
						var/obj/hud/menus/chat_background/chat_entry/entry = new
						entry.hud_x = entry_x
						entry.hud_y = entry_y
						entry.entry_size_y = L_y
						var/matrix/mat = matrix()
						mat.Translate(entry.hud_x,entry.hud_y+scroll_y)
						entry.transform = mat
						entry.maptext_height = L_y
						entry.maptext_y -= (L_y+6)
						entry.maptext = string
						//Display text to player, then put the entry into the holders entries list so it can be reloaded.
						if(h_chat.txt_display_system)
							h_chat.txt_display_system.vis_contents += entry
							h_chat.txt_display_system.entries_system += entry
						if(scroller && c.system_size > 0)
							if(scroller.translated_y == -62)
								//If the player is already scrolled down to the bottom of the chat, make sure to keep moving the chat/scroller down for them.
								var/matrix/m_scroller = matrix()
								m_scroller.Translate(0,scroller.translated_y)
								scroller.transform = m_scroller
								scroller.system_scroll_y = c.system_size
								//Move all the text down too, if the scroller is set to track the chat.
								for(var/obj/txt in c.txt_display_alerts.vis_contents)
									var/matrix/mat_system = matrix()
									mat_system.Translate(txt.hud_x,txt.hud_y+c.system_size)
									txt.translated_y = scroller.system_scroll_y
									txt.transform = mat_system
				c.cull_entries()
			*/
		save_alert_history(var/text)
			if(!(text || src))
				return
			var/logfile = "saves/players/[src.client.key]/Logs/[src.real_name]_alert_history.log"
			file(logfile) << "Year: [round(year)], Month: [round((year-round(year))*10)] - [text] <p>"
			//src << output("Year [round(year)], Month [round((year-round(year))*10)]: [text] <p>","chat.output_alerts")
		saveToLog(var/text)
			if(!(text || src))
				return
			var/logfile = "saves/players/[src.client.key]/Logs/[usr.real_name].log"
			file(logfile) << "Year - [round(year)], Time - [time2text(world.timeofday, "YYYY-MM-DDThh:mm:ss")] [text]"
		setup_alert_history()
			if(src.client)
				var/logfile = "saves/players/[src.client.key]/Logs/[src.real_name]_alert_history.log"
				var/siz = File_Size(file(logfile))
				if(siz == "MB") fdel("saves/players/[src.client.key]/Logs/[src.real_name]_alert_history.log")
				else src << output(file2text(logfile),"chat.output_alerts")
		Say_Spark()
			var/image/A=image(icon='say_alert.dmi')
		//	A.icon-=rgb(255,255,255)
		//	A.icon+=rgb(100,200,250)
			overlays+=A
			spawn(20) if(src) overlays-=A
		set_roleplayrank(var/ranknum)
			if(!ranknum) ranknum = src.roleplay_rank
			if(ranknum)
				if(ranknum <8)
					if(src.hud_roleplayrank.filters ) src.hud_roleplayrank.filters = null
				if(ranknum == 9)
					src.roleplay_rank_letter = "<font color =#6CA6FD>SSS</font>"
					src.hud_roleplayrank.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(194,133,255))

				else if(ranknum == 8)
					src.roleplay_rank_letter = "<font color =#6CA6FD>SS</font>"
					src.hud_roleplayrank.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(205,204,255))

				else if(ranknum == 7)
					src.roleplay_rank_letter = "<font color =#6CA6FD>S</font>"
				else if(ranknum == 6)
					src.roleplay_rank_letter = "<font color =#FF00D6>A</font>"
				else if(ranknum == 5)
					src.roleplay_rank_letter = "<font color =#F4FF00>B</font>"
				else if(ranknum == 4)
					src.roleplay_rank_letter = "<font color =#7BF5F6>C</font>"
				else if(ranknum == 3)
					src.roleplay_rank_letter = "<font color =#E7AC4A>D</font>"
				else if(ranknum == 2)
					src.roleplay_rank_letter = "<font color =#5CFF84>E</font>"
				else if(ranknum == 1)
					src.roleplay_rank_letter = "<font color =#D86060>F</font>"

		give_roleplayrank(var/ranknum)
			if(ranknum)
				if(ranknum <8)
					if(src.hud_roleplayrank.filters ) src.hud_roleplayrank.filters = null
				if(ranknum == 9)
					src.roleplay_rank_letter = "<font color =#6CA6FD>SSS</font>"
					src.hud_roleplayrank.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(194,133,255))

				else if(ranknum == 8)
					src.roleplay_rank_letter = "<font color =#6CA6FD>SS</font>"
					src.hud_roleplayrank.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(205,204,255))

				else if(ranknum == 7)
					src.roleplay_rank_letter = "<font color =#6CA6FD>S</font>"
				else if(ranknum == 6)
					src.roleplay_rank_letter = "<font color =#FF00D6>A</font>"
				else if(ranknum == 5)
					src.roleplay_rank_letter = "<font color =#F4FF00>B</font>"
				else if(ranknum == 4)
					src.roleplay_rank_letter = "<font color =#7BF5F6>C</font>"
				else if(ranknum == 3)
					src.roleplay_rank_letter = "<font color =#E7AC4A>D</font>"
				else if(ranknum == 2)
					src.roleplay_rank_letter = "<font color =#5CFF84>E</font>"
				else if(ranknum == 1)
					src.roleplay_rank_letter = "<font color =#D86060>F</font>"
				src << sound('Modules/core/sound/sound files/rp rank up ding.ogg', volume=30)
				if(src.screen_text)
					src.screen_text.screen_loc = "LEFT+8,CENTER"
					src.screen_text.maptext = "<font size=10><text align = center valign =right>RP Rank<font color=green>+</font>"
					animate(src.screen_text, alpha=255, time=5)
					animate(alpha=0, time=60)
			//	src.check_roleplayrank(xp)
				//src.roleplay_rank_label.refresh_rank()


		check_roleplayrank(var/xp)
			if(xp)

				if(prob(pick(50,75)))
					if(xp>10)
						src.rp_rankxp += xp
						if(src.rp_rankxp >= src.rp_rankmaxxp)
							src.rp_rankxp = 0
							if(src.roleplay_rank <8)
								if(src.hud_roleplayrank.filters ) src.hud_roleplayrank.filters = null
							if(src.roleplay_rank >=6 && src.roleplay_rank <10 )
								src.roleplay_rank += 1
								src.rp_rankmaxxp += (src.rp_rankmaxxp * 0.82)
							else if(src.roleplay_rank <10)
								src.roleplay_rank += 1
								src.rp_rankmaxxp += (src.rp_rankmaxxp * 0.32)

							if(src.roleplay_rank == 9)
								src.roleplay_rank_letter = "<font color =#6CA6FD>SSS</font>"
								src.hud_roleplayrank.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(194,133,255))

							else if(src.roleplay_rank == 8)
								src.roleplay_rank_letter = "<font color =#6CA6FD>SS</font>"
								src.hud_roleplayrank.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(205,204,255))
							else if(src.roleplay_rank == 7)
								src.roleplay_rank_letter = "<font color =#6CA6FD>S</font>"
							else if(src.roleplay_rank == 6)
								src.roleplay_rank_letter = "<font color =#FF00D6>A</font>"
							else if(src.roleplay_rank == 5)
								src.roleplay_rank_letter = "<font color =#F4FF00>B</font>"
							else if(src.roleplay_rank == 4)
								src.roleplay_rank_letter = "<font color =#7BF5F6>C</font>"
							else if(src.roleplay_rank == 3)
								src.roleplay_rank_letter = "<font color =#E7AC4A>D</font>"
							else if(src.roleplay_rank == 2)
								src.roleplay_rank_letter = "<font color =#5CFF84>E</font>"
							else if(src.roleplay_rank == 1)
								src.roleplay_rank_letter = "<font color =#D86060>F</font>"
							src << sound('Modules/core/sound/sound files/rp rank up ding.ogg', volume=30)
							if(src.screen_text)
								src.screen_text.screen_loc = "LEFT+8,CENTER"
								src.screen_text.maptext = "<font size=10><text align = center valign =right>RP Rank<font color=green>+</font>"
								animate(src.screen_text, alpha=255, time=5)
								animate(alpha=0, time=60)


							//src.check_roleplayrank(xp)
							//src.roleplay_rank_label.refresh_rank()


				else
					src.rp_rankxp += xp
					if(src.rp_rankxp >= src.rp_rankmaxxp)
						src.rp_rankxp = 0
						if(src.roleplay_rank <8)
							if(src.hud_roleplayrank.filters ) src.hud_roleplayrank.filters = null
						if(src.roleplay_rank >=6 && src.roleplay_rank <10 )
							src.roleplay_rank += 1
							src.rp_rankmaxxp += (src.rp_rankmaxxp * 0.82)
						else if(src.roleplay_rank <10)
							src.roleplay_rank += 1
							src.rp_rankmaxxp += (src.rp_rankmaxxp * 0.32)

						if(src.roleplay_rank == 9)
							src.roleplay_rank_letter = "<font color =#6CA6FD>SSS</font>"
							src.hud_roleplayrank.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(194,133,255))
						else if(src.roleplay_rank == 8)
							src.roleplay_rank_letter = "<font color =#6CA6FD>SS</font>"
							src.hud_roleplayrank.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(205,204,255))
						else if(src.roleplay_rank == 7)
							src.roleplay_rank_letter = "<font color =#6CA6FD>S</font>"
						else if(src.roleplay_rank == 6)
							src.roleplay_rank_letter = "<font color =#FF00D6>A</font>"
						else if(src.roleplay_rank == 5)
							src.roleplay_rank_letter = "<font color =#F4FF00>B</font>"
						else if(src.roleplay_rank == 4)
							src.roleplay_rank_letter = "<font color =#7BF5F6>C</font>"
						else if(src.roleplay_rank == 3)
							src.roleplay_rank_letter = "<font color =#E7AC4A>D</font>"
						else if(src.roleplay_rank == 2)
							src.roleplay_rank_letter = "<font color =#5CFF84>E</font>"
						else if(src.roleplay_rank == 1)
							src.roleplay_rank_letter = "<font color =#D86060>F</font>"
						src << sound('Modules/core/sound/sound files/rp rank up ding.ogg', volume=30)
						if(src.screen_text)
							src.screen_text.screen_loc = "LEFT+8,CENTER"
							src.screen_text.maptext = "<font size=10><text align = center valign =right>RP Rank<font color=green>+</font>"
							animate(src.screen_text, alpha=255, time=5)
							animate(alpha=0, time=60)
						//src.check_roleplayrank(xp)
						//src.roleplay_rank_label.refresh_rank()




		calculate_rpps(var/calculation)
			if(src.roleplay_rank >1)
				//RANK SSS
				if(src.roleplay_rank == 9)
					src.roleplay_points += 8
				//RANK SS
				else if(src.roleplay_rank == 8)
					src.roleplay_points += 7
				//RANK S
				else if(src.roleplay_rank == 7)
					src.roleplay_points += 6
				//RANK A
				else if(src.roleplay_rank == 6)
					src.roleplay_points += 5
				//RANK B
				else if(src.roleplay_rank == 5)
					src.roleplay_points += 4
				//RANK C
				else if(src.roleplay_rank == 4)
					src.roleplay_points += 3
				//RANK D
				else if(src.roleplay_rank == 3)
					src.roleplay_points += 2
				//RANK E
				else if(src.roleplay_rank == 2)
					src.roleplay_points += 1
			src.check_roleplayrank(calculation)


		Check_RP(var/msg,var/num,var/seconds,var/type)
			if(msg) if(!findtext(msg,"oocly says")||!findtext(msg,"(")||!findtext(msg,")"))

				/*
				//Give a rp bonus if this emote and the previous were an hour apart.
				var/T = world.timeofday
				T = time2text(T,"hh")
				var/RP = text2num(T) //Current hour in the day rp was written
				var/Player_RP = text2num(src.RP_Last) //Hour in the day previous rp was written
				if(!src.RP_Last)
					src.RP_Last = T
				if(Player_RP != RP) //Compar the time the current and previous rp were written, if not the same, give bonus rp.
					if(src.RP_Earned < 0)
						src.RP_Points += num*10
						src.RP_Earned += num*10
						src.RP_Total += num*10
				src.RP_Last = T
				*/
				//if(!CheckAntiRPT(msg, src))
				//	src << "Your emote has been flagged as potentially AI-generated. Please ensure your emotes are original."
					//return
				var/TextLength = length(msg)
				src.RP_Length = TextLength
				var/divide = pick(10,5,10)
				var/MinTime = TextLength / 15
				if(seconds) if(MinTime >= seconds)
					src << "Possible pre-typed RP detected. If you are typing your emote elsewhere and pasting it here, please make sure to leave the emote window open while you do so."
					world<<output("<font color=[src.text_color_ic]><b><font color=red> </font>[src.key]</b> has created a possible pre-typed Emote.</font>","rpspy.output2")

					return
				src.RPs += 1
				var/Bonus = 0.001
				var/speaker = src
				if(src.projection) speaker = src.projection
				for(var/mob/races/p in oview(7,speaker))
					if(p.afk == 0 && p.client) Bonus += 0.1
				if(RP_Length>=200 && RP_Length <500)
					src.monthly_rps += 0.5
				if(RP_Length>=500)
					src.monthly_rps += 1
			//	if(src.first_cft)
				//	src.cycle_free_time += (TextLength/divide)*0.25
			//	else if(prob(85))src.cycle_free_time += (num + Bonus)*(TextLength/divide)*0.25
				//src.check_cft()
				src.rp_total += 1
				var/rpxp = (TextLength/divide)*0.32 + Bonus
				src.check_roleplayrank(rpxp)

				/*
				while(TextLength)
					TextLength -= 1
					if(src.RP_Earned < 0)
						var/Rested = 0
						if(src.RP_Rested > 0)
							Rested = src.RP_Rested/10000
							src.RP_Rested -= Rested
						src.RP_Points += num + Rested + Bonus
						src.RP_Earned += num + Rested + Bonus
						src.RP_Total += num + Rested + Bonus
				*/
	verb




		resize_window(var/t as text)
			set hidden = 1
			set name = ".resize"
			if(winget(usr,"[t].resize","is-checked") == "true") winset(usr,"[t]","can-resize=true")
			else winset(usr,"[t]","can-resize=false")
		Alpha_Change(var/t as text)
			set hidden = 1
			set name = ".alpha"
			if(usr.typing) return
			var/v = winget(usr,"[t].alpha","value")
			v = text2num(v)
			v = 255-v
			winset(usr,"[t]","alpha=[v]")
		open_emote()
			set name = ".open_emote"
			set hidden = 1
			//if(usr.typing) return
			alert("Test")
			if(usr.open_emote == 0)
				winshow(usr,"emote",1)
				winset(usr,"emote.input_emote","focus=true")
				usr.open_emote = 1;
				usr.RP_open_time = world.time / 10
				usr.overlays -= 'Typing.dmi'
				usr.overlays += 'Typing.dmi'
				usr.open_menus.Add(".open_emote")
				while(usr.open_emote)
					var/T = winget(usr,"emote.input_emote","text")
					var/L = length(T)
					winset(usr,"emote.chars","text=\"Characters: [L]\"")
					var/RP = 0.001*L
					winset(usr,"emote.rpp","text=\"Estimated RPP reward: [RP]\"")
					sleep(10)
			else
				winshow(usr,"emote",0)
				usr.open_emote = 0
				usr.overlays -= 'Typing.dmi'
				usr.open_menus.Remove(".open_emote")
				return
		emote()
			set hidden = 1
			set name = ".emote"
			if(usr.typing) return
			var/msg = winget(usr,"emote.input_emote","text")
			var/raw_runechat_msg = msg
			var/mob/speaker = usr
			if(usr.projection) speaker = usr.projection
			for(var/mob/M in hearers(ViewX,speaker))
				if(M.client)
					M.saveToLog("<br> | [M.client.address ? (M.client.address) : "IP not found"] | ([M.x], [M.y], [M.z]) | [M.client.key] ::<br> *[usr] starts typing an emote.\n")
			if(!msg)
				usr.overlays -= 'Typing.dmi'
				for(var/mob/M in hearers(ViewX,speaker))
					if(M.client)
						M.saveToLog("<br> | [M.client.address ? (M.client.address) : "IP not found"] | ([M.x], [M.y], [M.z]) | [M.client.key] ::<br> *[usr] cancels their emote.*\n")
				return
			var/Old_Sight=see_invisible
			see_invisible=101
			usr.RP_close_time = world.time / 10
			//var/Secs_Close = usr.RP_close_time - usr.RP_open_time
			usr.RP_copy = msg
			var/RP = rand(0.08,0.15)

			msg = replace_quotations(msg, "\"<font color=[usr.text_color_ic]>", "</font>\"")
			if(length(raw_runechat_msg))
				var/list/runechat_viewers = hearers(ViewX, speaker)
				if(!(usr in runechat_viewers))
					runechat_viewers += usr
				speaker.show_runechat("*[raw_runechat_msg]*", usr.text_color_ic ? usr.text_color_ic : "#FFFFFF", 1, runechat_viewers)
			for(var/mob/M in hearers(ViewX,speaker))
				if(M.ref && ismob(M.ref))
					var/mob/x = M.ref
					M = x
				if(M.client)
					if(RP < 0.005)
						RP += 0.0005
					M << output("<font color = yellow><BIG>\icon[usr.icon]</BIG><font size=[M.text_size]>*[usr] [msg]*","actionoutput")
					spawn(1)
						if(M && M.client && M.chat != "local" && M.show_flash_local)
							if(M.client) winset(M,"main","flash=10")
							var/times = 6
							while(times)
								times -= 1
								if(M && M.client) winset(M,"chat.button_local","background-color=#FFFF00")
								sleep(2)
								if(M && M.client) winset(M,"chat.button_local","background-color=#000000")
								sleep(2)
					M.saveToLog("<br> | [M.client.address ? (M.client.address) : "IP not found"] | ([M.x], [M.y], [M.z]) | [M.client.key]:<br> *[usr] [msg]*\n")
			//First check if any common English words were found.
			//if(usr.common_word_count > 0)
				//Then make sure they're not the same rp's being pasted and spammed in a row.
				//if(usr.check_rp_spam(msg) == 0)
					//If everything seems fine, start to process the emote for rp points.
					//usr.Check_RP(msg,RP,Secs_Close,"Emote")
				//else usr << "Possible copy and paste of previous emote detected."
			//else usr << "Possible nonsensical emote detected, or lack of English."
			usr.see_invisible=Old_Sight
			src.Check_RP(msg,RP,RP_close_time,"Emote")

			usr.overlays -= 'Typing.dmi'
			winshow(usr,"emote",0)
			winset(usr,"emote.input_emote","text=")
			usr.open_emote = 0
			if(length(usr.RP_last) > 10) usr.RP_last = list()
			if(length(usr.RP_word_count) > 10) usr.RP_word_count = list()
			//world << "DEBUG - found [usr.check_rp_matches(msg)]% matches from last 10 rp's and last 100 words."
			usr.RP_last += msg
			usr.RP_word_count += length(msg)
			usr.rp_total +=1
			//usr.save_chat_log(msg, 1)


		emote_cancel()
			set name = ".emote_cancel"
			set hidden = 1
			if(usr.typing) return
			if(usr.started == 0) return
			winset(usr,"map.map","focus=true")
			winset(usr,"emote.input_emote","text=")
			winshow(usr,"emote",0)
			usr.open_emote = 0
			usr.overlays -= 'Typing.dmi'
			for(var/mob/M in hearers(ViewX,usr))
				if(M.client)
					M.saveToLog("<br> | [M.client.address ? (M.client.address) : "IP not found"] | ([M.x], [M.y], [M.z]) | [M.client.key] ::<br>*[usr] cancels their emote.*\n")
			return
		ooc(var/msg as text)
			set hidden = 1
			if(usr.started == 0)
				usr << "You are not authorized to communicate over these channels."
				return
			if(!msg || !global.ooc_on)
				usr << "Global OOC is <font color=red>OFF</font>"
				return
			if(!usr.listen_ooc && !findtext(msg, "/ooc"))
				usr << "You have OOC disabled, you'll have to enable it to speak."
				return
			if(world.time < src.next_ooc_allowed)
				src << "You're sending messages too quickly. Please wait a moment."
				return
			if(findtext(msg, "byond://"))
				usr << "<b>Advertising other servers is not allowed.</b>"
				return
			if(usr.muted || !ooc_allowed)
				usr<<"<font color=red>You are muted.</font>"
				return

			// Message sanitization
			msg = copytext(msg, 1, 400)
			msg = html_encode(msg)
			if(process_chat_command(msg)) return
			var/auracolor = usr.auracolor
			if(!auracolor) auracolor = "white"

			var/output_msg = "(<font color=[auracolor]>[usr.key]</font>): [msg]"

			var/list/ooc_listeners = list()
			for(var/mob/p in players)
				if(p && p.client && p.listen_ooc)
					ooc_listeners += p

			spawn()
				for(var/mob/p in ooc_listeners)
					p << output_msg

			//spawn() usr.save_chat_log(output_msg, 1)
		//	spawn() Send_OOC_To_Discord(usr.key, msg)
			src.next_ooc_allowed = world.time + 20

		/*ooc(msg as text)
			set hidden = 1
			//set instant = 1
			if (usr.started == 0)
				usr << "You are not authorized to communicate over these channels."
				return
			if (global.ooc_on == 0)
				usr << "Global OOC is <font color=red>OFF</font>"
				return
			if (!usr.listen_ooc)
				usr << "You have OOC disabled, you'll have to enable it to speak."
				return
			if (world.time < src.next_ooc_allowed)
				src << "You're sending messages too quickly. Please wait a moment."
				return



			// Process the message
			// msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
		//	if (usr.Crazy) msg = Crazy(msg)
			//msg = gSpamFilter.sf_Filter(usr, msg)
			if (!msg) return
			else if (!usr.listen_ooc) return
			else if (!ooc_allowed) return
			else if (usr.muted) return
			else if (findtext(msg, "byond://"))
				usr << "<B>Advertising other servers is not allowed.</B>"
				return

		//	log_ooc("[usr.name]/[usr.key] : [msg]")

			var/output_msg
			output_msg = "(<font color=[usr.auracolor]>[usr.key]</font>):[msg]"
			for(var/mob/p in players)
				if(p.client && p.listen_ooc==1)
					p << output_msg
			usr.save_chat_log(output_msg, 1)
			src.next_say_allowed = world.time + 30
			return

			*/

	/*	Say(var/msg as text)
			set hidden = 1
			//if(usr.key in StaffTeam) usr.admin_cmd_check(msg)
			if (world.time < src.next_say_allowed)
				src << "You're sending messages too quickly. Please wait a moment."
				return
			if (msg == src.last_message)
				src << "Please avoid repeating the same message."
				return
			src.last_message = msg
			msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
			if(!msg)	return

		//	var/Old_Sight=see_invisible
			//see_invisible=101

			//world << "DEBUG words = [count_words(msg,"\"<font color=[usr.text_color_ic]>", "</font>\"")]"
			//usr.count_words(msg,"\"<font color=[usr.text_color_ic]>", "</font>\"")
			//usr.RP_word_count += length(msg)
			/*
			for(var/i = 1,i < usr.RP_last_100.len + 1,i++)
				//world << "DEBUG - found [usr.RP_last_100[i]]"
			for(var/i = 1,i < usr.RP_word_count.len + 1,i++)
				//world << "DEBUG - found last rp word count lengths [usr.RP_word_count[i]]"
			*/

			msg=say_quote(msg)	//Moved to after stutter

			if(!findtext(msg,"oocly")) if(usr.critical_throat)
				msg = "*Mumbles incoherently*..."
			var/learned_name=0
			if(findtext(msg,"[usr.fullname]"))
				learned_name =1
			var/speaker = usr
			if(usr.projection) speaker = usr.projection
			//msg = FilterString(msg)
			//usr.ai_previous_msg = "[usr.name]: [msg]"
			src.next_say_allowed = world.time + 15
			//PLAYER AND ADMIN COMMANDS
			if(findtext(msg,"/cd")) // to start countdowns
				var/choice = input(src, "Choose countdown type:") in list("Preset Time", "Custom Time (max 3600 seconds)")
				var/total_time

				if(choice == "Preset Time")
					var/preset = input(src, "Pick a preset duration.") in list("30", "60", "90")
					if(preset == "30")total_time = 300
					if(preset == "60") total_time = 600
					if(preset == "90") total_time = 900
					var/show_final_countdown = input(src, "Show final 10-second countdown visually?") in list("Yes", "No")

					// Notify everyone nearby
					for(var/mob/M in range(20, src))
						M << output("([src] begins counting down from [total_time*0.1] seconds.)", "actionoutput")


					if(show_final_countdown == "Yes" && total_time > 10)
						spawn(total_time-10)
							FinalCountdown(10)
					else
						spawn(total_time)
							FinishCountdown(src, total_time)
					return

				else
					total_time = input(src, "Enter your custom countdown duration (seconds, max 3600):") as num
					if(total_time > 3600)
						src << "Maximum allowed time is 3600 seconds (1 hour). Countdown cancelled."
						return

					var/show_final_countdown = input(src, "Show final 10-second countdown visually?") in list("Yes", "No")

					// Notify everyone nearby
					for(var/mob/M in range(20, src))
						M << output("([src] begins counting down from [total_time] seconds.)", "actionoutput")


					if(show_final_countdown == "Yes" && total_time > 10)
						spawn(total_time - 10)
							FinalCountdown(10)
					else
						spawn(total_time)
							FinishCountdown(src, total_time)

					return

			if(findtext(msg,"/lethal")) // to change lethality settings
				if(spar_mode&&!srs_mode)
					spar_mode = 1
					srs_mode = 1
					lethal_mode=0
					usr << "<b>You have enabled serious mode. You will inflict limb damage, but cannot rip limbs</b>"
					view(6,usr) <<output("[usr] is showing<font color = yellow> SERIOUS</font> intentions.","actionoutput")
					return
				if(srs_mode&&spar_mode)
					spar_mode = 0
					srs_mode = 0
					lethal_mode = 1
					usr << "<font color=red><b>You have enabled lethal mode. Only use this if you intend to maim or kill your opponent.</font></b>"
					view(6,usr) <<output("[usr] is showing<font color = red> LETHAL</font> intentions.","actionoutput")
					return
				if(lethal_mode==1)
					spar_mode = 1
					srs_mode=0
					lethal_mode=0
					usr << "You have enabled spar mode."
					view(6,usr) <<output( "[usr] is showing<font color=green> CASUAL</font> intentions.","actionoutput")
					return
			if(findtext(msg,"/adminmode"))
				if(usr.key in StaffTeam)
					world<<output("<font color=yellow>(Admin Log):[usr.key] went off duty.</font>","rpspy.output2")

					if(usr.service_lvl) usr.service_lvl=0
					StaffTeam -= "[usr.key]"
					sleep(0.1)
					usr.show_adminpanel()
					return
				else
					if(usr.key in CodedStaff)
						StaffTeam += "[usr.key]"
						usr.service_lvl=1
						sleep(0.1)
						show_adminpanel()
						world<<output("<font color=yellow>(Admin Log):[usr.key] is on duty.</font>","rpspy.output2")

						return

			if(findtext(msg,"/ranks"))
				usr<<browse(Ranks,"window= ;size=700x600")
				return
			if(findtext(msg,"/story"))
				usr<<browse(Story,"window= ;size=700x600")
				return

			if(findtext(msg,"/ahc"))
				var/ahcmsg = input("How can we help you?") as text
				ahcmsg = copytext(sanitize(ahcmsg), 1, MAX_MESSAGE_LEN)


				if (!ahcmsg)
					return


				for (var/mob/M in players)
					if (M.client && M.key in StaffTeam)
						M << "<b><u><font size=2><font color=red>ADMIN HELP CHANNEL:</u></b> </font>[usr.key]([usr.fullname]):</b> [ahcmsg]</font>"
				usr <<"<b><u><font size=2><font color=red>AHC:</b></font></u>\n[ahcmsg]\nhas been broadcast to the administrators."
				return
			if(findtext(msg,"/resize"))
				usr.resize_window()
				usr<<"Drag to resize"
				return
			if(findtext(msg,"/ooc"))
				if(usr.listen_ooc == 1)
					usr<<"You toggle your OOC: <font color=red>OFF</font>"
					usr.listen_ooc=0
					return
				else
					usr<<"You toggle your OOC:<font color=green>ON</font>"
					usr.listen_ooc=1
			if(findtext(msg,"/rps")) // rock paper scissors
				var/mob/choice = input("Select a player:") as null|obj|mob in oview(5,usr)

				var/yourselection
				var/theirselection
				if(choice.client)
					switch(alert(choice,"[usr] wishes to play Rock Paper Scissors with you, do you accept?","","Yes","No"))
						if("Yes")
							switch(input(choice,"Make your selection.") in list ("Rock","Paper","Scissors"))
								if("Rock")
									theirselection="Rock"
								if("Paper")
									theirselection="Paper"
								if("Scissors")
									theirselection="Scissors"
							switch(input(usr,"Make your selection.") in list ("Rock","Paper","Scissors"))
								if("Rock")
									yourselection="Rock"
								if("Paper")
									yourselection="Paper"
								if("Scissors")
									yourselection="Scissors"
							if(yourselection=="Rock"&&theirselection=="Paper")
								view(src)<<output("[usr] uses Rock. [choice] uses Paper. [choice] wins.","actionoutput")
							if(yourselection=="Paper"&&theirselection=="Rock")
								view(src)<<output("[usr] uses Paper. [choice] uses Rock. [usr] wins.","actionoutput")
							if(yourselection=="Rock"&&theirselection=="Scissors")
								view(src)<<output("[usr] uses Rock. [choice] uses Scissors. [usr] wins.","actionoutput")
							if(yourselection=="Rock"&&theirselection=="Rock")
								view(src)<<output("[usr] uses Rock. [choice] uses Rock. It is a draw.","actionoutput")
							if(yourselection=="Paper"&&theirselection=="Scissors")
								view(src)<<output("[usr] uses Paper. [choice] uses Scissors. [choice] wins.","actionoutput")
							if(yourselection=="Paper"&&theirselection=="Paper")
								view(src)<<output("[usr] uses Paper. [choice] uses Paper. It is a draw.","actionoutput")
							if(yourselection=="Scissors"&&theirselection=="Paper")
								view(src)<<output("[usr] uses Scissors. [choice] uses Paper. [usr] wins.","actionoutput")
							if(yourselection=="Scissors"&&theirselection=="Rock")
								view(src)<<output("[usr] uses Scissors. [choice] uses Rock. [choice] wins.","actionoutput")
							if(yourselection=="Scissors"&&theirselection=="Scissors")
								view(src)<<output("[usr] uses Scissors. [choice] uses Scissors. It is a draw.","actionoutput")
				return
			if(findtext(msg,"/help")) // quick list of /commands
				usr<<"[Help]"
				return
			if(findtext(msg,"/spy"))
				if(!usr.service_lvl)
					usr << "Only administrators may use this command."
					return
				if(!usr.admin_spying)
					winset(usr,"rpspy","is-visible=true")
					usr.admin_spying=1
					return
				winset(usr,"rpspy","is-visible=false")
				usr.admin_spying=0
				return
			if(findtext(msg,"/ac"))
				if(!usr.service_lvl)
					usr << "Only administrators may use this command."
					return
				var/msg2 = input ("Admin Chat:") as text
				if(msg2=="")
					return
				else
					for(var/mob/M in players)
						if(M.service_lvl)
							M << "<font size = 2><b><font color=#CB0739>(AdminChat)[usr.key]:<font color=white>[msg2]</font>"
				return
			if(findtext(msg,"/gf"))
				usr.check_glow_planes()
				usr.reset_ui_proc()
				usr.redraw_appearance()
				update_rating(usr)
				update_qp(usr)
				if(usr.moved==1) usr.moved=0
				view(5,usr)<<output("[usr] Generally fixed themselves.","actionoutput")
				return
			if(findtext(msg,"/settings")) // generalfix
				switch(input(usr,"Settings:")in list("Change IC Color", "General Fix", "Toggle Battle Text", "Toggle Anger Text"))
					if("Change IC Color")
						var/new_c = input("New color for IC:") as color
						usr.text_color_ic = new_c
					if("Toggle Battle Text")
						if(usr.battle_text == 1)
							usr.battle_text = 0
							usr<<"You toggle Battle Text: <font color=red>OFF</font>"
							return
						else
							usr.battle_text =1
							usr<<"You toggle Battle Text: <font color=green>ON</font>"
							return
					if("Toggle Anger Text")
						if(usr.anger_text == 1)
							usr.anger_text = 0
							usr<<"You toggle Anger Text: <font color=red>OFF</font>"
							return
						else
							usr.anger_text =1
							usr<<"You toggle Anger Text: <font color=green>ON</font>"
							return
					if("General Fix")
						//src.dimiss_all_alerts()

						usr.particles = null //Keep this for a while, I think saving them makes the player crash.

						var/list/screen_mobs = list()
						if(usr && usr.client)
							for(var/mob/m in src.client.screen)
								usr.client.screen -= m
								screen_mobs += m




						for(var/mob/m in screen_mobs)
							if(src.client) src.client.screen += m
						if(src.skill_divine_weapon)
							for(var/mob/s in src.skill_divine_weapon.active_splits)
								s.filters += filter(type="outline",size=1, color=rgb(204,236,255))
								s.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(204,236,255))
								s.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
								if(s.shadow) s.shadow.vis_contents += new/obj/effects/weapon_energy



						usr.check_glow_planes()
						usr.reset_ui_proc()
						usr.redraw_appearance()
						update_rating(usr)
						update_qp(usr)

						if(usr.moved) usr.moved=0
						if(usr.KB & usr.loc) usr.KB=0
						view(5,usr)<<output("[usr] Generally fixed themselves.","actionoutput")
						return
			if(findtext(msg,"/mate")) // mating command
				if(usr.children<=0&&usr.client.max_childslots==0||usr.children<=0&&usr.client.childslots<usr.client.max_childslots) {usr<<"You do not have anymore child slots.";return}
				if(usr.age < 21&&usr.rating<500)
					usr<<"You haven't played this character enough, or you are not old enough."
					return
				if(usr.age < 21)
					usr<<"Your character is not old enough."
					return
				if(usr.rating<500)
					usr<<"You haven't played your character long enough."
					return

				if(usr.oozaru_form==1) return
				if(usr.icon_state=="KO"||usr.koed==1) return
				if(!usr.in_BioRegenTank&&!usr.in_DeluxeTank)
					for(var/mob/A in get_step(usr,usr.dir))
						if(A.client)
							if(A&&!A.asexual)
								if(A.age < 21&&A.rating<500)
									A<<"You haven't played this character enough, or you are not old enough."
									return

								if(A.age < 21)
									usr<<"[A] character is not old enough."
									return
								if(A.rating<500)
									usr<<"[A] hasn't played their character long enough."
									return



				return


			for(var/mob/M in hearers(14,speaker))
				if(M.ref && ismob(M.ref))
					var/mob/x = M.ref
					M = x
				if(M.client)
					var/Hear = 1
					if(M.critical_hearing)
						Hear = 0
					if(findtext(msg,"(")||findtext(msg,"("))
						Hear = 1
					if(learned_name == 1 && !usr.fullname in M.known_people)
						M.known_people += "[usr.fullname]"
					if(Hear)
						M << output("<BIG><IMG CLASS=image SRC=\ref[client.RenderIcon(usr)] STYLE='width:34px; height:34px;' ICONSTATE='' ICONDIR=SOUTH ICONFRAME=1></BIG><font color=[usr.text_color_ic]>[usr.get_strangername(usr)] [msg]","actionoutput")
						M.saveToLog("[usr]([key]): [msg]\n")
					/*	spawn(1)
							if(M && M.client && M != usr && M.show_flash_local && M.show_flash_local_say)
								winset(M,"main","flash=10")
								var/times = 6
								while(times)
									times -= 1
									if(M && M.client) winset(M,"chat.button_local","background-color=#FFFF00")
									sleep(2)
									if(M && M.client) winset(M,"chat.button_local","background-color=#000000")
									sleep(2)*/
					else
						M << output("<i>You hear a distant noise...</i>","chat.local")
				//else
					//spawn(10)
						//if(M && usr) M.ai(msg,usr)
					/*
					if(usr.skill_psi_clone)
						if(M.owner == usr.real_name && findtext(msg,M.ai_name))
							spawn(6)
								if(M && usr) M.command_ai("[msg]",usr)
							break
					*/
			usr.save_chat_log(msg, 0)
			for(var/mob/MM in players) if(MM.service_lvl) MM <<output("[usr]([usr.key]) says: [msg]\n","rpspy.output2")
			/*
			if(usr.common_word_count > 0)
				if(usr.check_rp_spam(msg) == 0) usr.Check_RP(msg,0.00005*length(msg),Secs_Close,"Say")
				else usr << "Possible copy and paste of previous emote detected."
			*/
			usr.Say_Spark()
			//see_invisible=Old_Sight
			winset(usr,"map.map","focus=true")
			//world << "DEBUG - words common found [usr.common_word_count]"
            */
		Say(var/msg as text)
			set hidden = 1
			if(started == 0)
				usr<< "You are not allowed to speak in this channel at the moment."
				return

			if(world.time < usr.next_say_allowed)
				usr << "You're sending messages too quickly. Please wait a moment."
				return

			if(msg == usr.last_message && copytext(msg, 1, 2) != "/")
				usr << "Please avoid repeating the same message."
				return

			//msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
			if(!msg) return
			if(TryWhisper(msg)) return
			var/obj/Quotations/B=new
			var/raw_runechat_msg = msg

			usr.last_message = msg
			var/learned_name=0
			if(findtext(msg,"[usr.fullname]"))
				learned_name =1
				//world<< "[learned_name] - Learned Name Integer"
			usr.next_say_allowed = world.time + 15

			// Process speaker info
			msg = say_quote(msg)
			//msg = html_encode(msg)
			msg = html_safe(msg)

			if(process_chat_command(msg)) return

			var/mob/speaker = usr.projection ? usr.projection : usr
			if(usr.SendInlineEmote(raw_runechat_msg, speaker))
				return
			if(!findtext(msg,"oocly") && usr.critical_throat)
				raw_runechat_msg = "..."
				msg = "*Mumbles incoherently*..."

			// Pre-cache visuals
		//	var/speaker_icon = speaker.client ? speaker.client.RenderIcon(speaker) : null
			var/speaker_avatar = get_chatbox_render(speaker, speaker.client)

			//var/speaker_name = speaker.get_strangername(speaker)
			var/speaker_color = usr.text_color_ic ? usr.text_color_ic : "#FFFFFF"
			var/runechat_color = usr.text_color_ic ? usr.text_color_ic : "#FFFFFF"
			if(usr.projection && usr.client.admin_mode)
				speaker_color = lowertext(usr.client.admin_color)
			//spawn() usr.save_chat_log(msg, 0)

			// Admin echo
			world<<output("<font color=[speaker_color]>[usr]([usr.key]) says: [msg]</font>\n", "rpspy.output2")


			usr.Say_Spark()

			// Process /commands


			// Output to nearby players
			if(usr.projection && usr.client.admin_mode)
				//usr<<"Spoken.[usr.client.admin_color]"
				var/list/hearing = hearers(14, usr.projection)
				if (!(usr in hearing))
					hearing += usr
				if(length(raw_runechat_msg))
					speaker.show_runechat(raw_runechat_msg, runechat_color, FALSE, hearing, TRUE)

				for (var/mob/M in hearing)
					M << output("<IMG CLASS=image SRC=\ref[speaker_avatar] STYLE='width:34px; height:34px;'><font color=[lowertext(usr.client.admin_color)]>[usr.client.admin_name]<IMG CLASS=image SRC=\ref[B.icon] STYLE='width:32px; height:32px;' ICONSTATE='' ICONFRAME=1> [msg]", "actionoutput")
					spawn(1) M.saveToLog("[usr]([key]): [msg]\n")

				/*for(var/mob/M in hearers(14, usr.projection))
					//if(!M || !M.client) continue
					var/html = "<font size=2.5><font color=[usr.admin_color]>[usr.admin_name] [msg]"
					M << output("<BIG><IMG CLASS=image SRC=\ref[speaker_icon] STYLE='width:34px; height:34px;' ICONSTATE='' ICONDIR=SOUTH ICONFRAME=1></BIG><font color=[usr.admin_color]>[usr.admin_name] <IMG CLASS=image SRC=\ref[B.icon] STYLE='width:32px; height:32px;' ICONSTATE='' ICONFRAME=1> [msg]","actionoutput")
					usr << output("TESTTTT --- <BIG><IMG CLASS=image SRC=\ref[speaker_icon] STYLE='width:34px; height:34px;' ICONSTATE='' ICONDIR=SOUTH ICONFRAME=1></BIG><font color=[usr.admin_color]>[usr.admin_name] <IMG CLASS=image SRC=\ref[B.icon] STYLE='width:32px; height:32px;' ICONSTATE='' ICONFRAME=1> [msg]","actionoutput")

						//M << output(html, "actionoutput")
					spawn(1) M.saveToLog("[usr]([key]): [msg]\n")*/

			else
				var/list/runechat_viewers = hearers(14, speaker)
				if(!(usr in runechat_viewers))
					runechat_viewers += usr
				if(length(raw_runechat_msg))
					speaker.show_runechat(raw_runechat_msg, runechat_color, FALSE, runechat_viewers, TRUE)
				for(var/mob/M in hearers(14, speaker))
					if(!M || M.npc || M.boss) continue

					var/Hear = 1
					if(M.critical_hearing) Hear = 0
					if(findtext(msg,"(")) Hear = 1
					//if(M.key == "VOXTECH") M.known_people -= M.fullname
					if(learned_name && !(speaker.real_name in M.known_people))
						M.known_people += speaker.real_name
						M << "<i>You've learned the name of [usr].</i>"

					if(Hear)
						if(M.client.admin_mode)
							M << output("<IMG CLASS=image SRC=\ref[speaker_avatar] STYLE='width:32px; height:32px;'>(A.M)<font color=[speaker_color]>[M.get_strangername(speaker)] [msg]","actionoutput")
						else
							M << output("<IMG CLASS=image SRC=\ref[speaker_avatar] STYLE='width:32px; height:32px;' ICONSTATE='' ICONDIR=SOUTH ICONFRAME=2'><font color=[speaker_color]>[M.get_strangername(usr)] [usr.ICText(msg, usr)]","actionoutput")

						//M << output(html, "actionoutput")
						spawn(1) M.saveToLog("[usr]([key]): [msg]\n")
					else
						M << output("<i>You hear a distant noise...</i>", "actionoutput")
			RoleplaySpyLog(msg, FALSE)

			//winset(usr, "map.map", "focus=true")
mob/proc/TryWhisper(var/msg)
	if(!msg) return FALSE

	// Check command prefix
	if(copytext(msg,1,4) == "/w ")
		msg = copytext(msg,4)
	else if(copytext(msg,1,10) == "/whisper ")
		msg = copytext(msg,10)
	else
		return FALSE

	msg = msg
	if(!msg) return TRUE

	// Get nearby players (3 tile radius)
	var/list/targets = hearers(3, src)
	if(!(src in targets))
		targets += src
	if(src.SendInlineEmote(msg, src, targets))
		return TRUE
	var/speaker_avatar = get_chatbox_render(src, src.client)
	var/speaker_color = src.text_color_ic ? src.text_color_ic : "#FFFFFF"
	src.show_runechat(msg, speaker_color, 1, targets, TRUE)

	for(var/mob/M in targets)
		if(!M.client) continue

		M << output(
			"<IMG CLASS=image SRC=\ref[speaker_avatar] STYLE='width:32px; height:32px;'><font color=[speaker_color]>[src] <i>whispers,'[msg]'</font></i>",
			"actionoutput"
		)

	return TRUE
/// Returns a static icon snapshot of the given mob for chatbox display.
/// Must be called from a valid client context (e.g. usr.client)
proc/get_chatbox_render(mob/source_mob, client/C)
	if(!C) return null

	var/mob/temp = new()
	temp.icon = source_mob.icon
	temp.icon_state = source_mob.icon_state
	temp.dir = SOUTH

	// Copy overlays (hair/tail/etc.)
	for(var/overlay in source_mob.overlays)
		if(isobj(overlay))
			var/obj/O = overlay
			var/obj/O_copy = new O.type
			O_copy.icon_state = O.icon_state
			O_copy.icon = O.icon
			O_copy.pixel_x = O.pixel_x
			O_copy.pixel_y = O.pixel_y
			O_copy.layer = O.layer
			O_copy.dir = SOUTH
			temp.overlays += O_copy
		else
			temp.overlays += overlay

	return C.RenderIcon(temp)

mob/proc/SendAdminChat(var/message)
	if(!message || message == "") return

	for(var/mob/M in players)
		if(M.client && M.client.admin_level > 0)
			M << "<font color=#ff4da6><b>[src.key]</b> (Admin): [message]</font>"
// Modular sub-proc for command parsing
/proc/extract_inline_emote(t as text)
	t = t
	if(!t || length(t) < 2)
		return null
	var/inner = null
	if(length(t) >= 5 && copytext(t, 1, 3) == "**" && copytext(t, length(t) - 1, length(t) + 1) == "**")
		inner = copytext(t, 3, length(t) - 1)
	else if(copytext(t, 1, 2) == "*")
		inner = copytext(t, 2)
	if(!length(inner))
		return null
	return inner
mob/proc/SendInlineEmote(var/message, var/mob/speaker_override = null, var/list/viewers = null)
	var/emote_text = extract_inline_emote(message)
	if(!emote_text)
		return FALSE

	var/mob/speaker = speaker_override ? speaker_override : (src.projection ? src.projection : src)
	if(!viewers)
		viewers = hearers(ViewX, speaker)
		if(!(src in viewers))
			viewers += src

	var/display_msg = replace_quotations(emote_text, "\"<font color=[src.text_color_ic]>", "</font>\"")
	speaker.show_runechat("*[emote_text]*", src.text_color_ic ? src.text_color_ic : "#FFFFFF", 1, viewers)

	for(var/mob/M in viewers)
		if(M.ref && ismob(M.ref))
			var/mob/x = M.ref
			M = x
		if(!M || !M.client)
			continue

		M << output("<font color = yellow><BIG>\icon[src.icon]</BIG><font size=[M.text_size]>*[src] [display_msg]*", "actionoutput")
		spawn(1)
			M.saveToLog("[src]([key]): *[display_msg]*\n")

	return TRUE
mob/proc/refresh_runechat(var/mob/viewer)
	if(!viewer || !viewer.client || !src.runechat_entries || !length(src.runechat_entries))
		return

	var/offset_y = 36
	for(var/i = length(src.runechat_entries), i >= 1, i--)
		var/obj/effects/txt/runechat/entry = src.runechat_entries[i]
		if(!entry || entry.viewer != viewer || !entry.display_image)
			continue

		animate(entry.display_image, pixel_y = offset_y, time = 2)
		offset_y += max(entry.maptext_height, 18) + 2

mob/proc/remove_runechat(var/obj/effects/txt/runechat/entry, var/fade_time = 6)
	if(!entry || entry.fading)
		return

	entry.fading = 1
	if(src.runechat_entries && entry in src.runechat_entries)
		src.runechat_entries -= entry
		if(entry.viewer)
			src.refresh_runechat(entry.viewer)

	if(entry.display_image)
		animate(entry.display_image, alpha = 0, pixel_z = 8, time = fade_time)
	spawn(fade_time)
		if(entry.viewer && entry.display_image)
			var/mob/v = entry.viewer
			if(v && v.client)
				v.client.images -= entry.display_image
		if(entry)
			del(entry)

mob/proc/show_runechat(var/message, var/text_color = "#FFFFFF", var/is_emote = 0, var/list/viewers = null, var/use_language_barrier = FALSE)
	if(!src || !src.loc || !message)
		return

	message = "[message]"
	if(!length(message))
		return

	var/auto_caps = findtext(message, "!!") ? TRUE : FALSE

	if(length(message) > 140)
		message = "[copytext(message, 1, 138)]..."

	if(!src.runechat_entries)
		src.runechat_entries = list()

	if(!viewers)
		viewers = view(8, src)
		if(!(src in viewers))
			viewers += src

	for(var/mob/viewer in viewers)
		if(!viewer || !viewer.client)
			continue

		var/rendered_message = message
		if(use_language_barrier && !is_emote && viewer.lan)
			rendered_message = src.LanguageSay(rendered_message, viewer.lan, viewer.lan.Mastery, viewer)
		rendered_message = rendered_message
		if(auto_caps)
			rendered_message = uppertext(rendered_message)
		if(!length(rendered_message))
			continue

		var/obj/effects/txt/runechat/entry = new
		entry.viewer = viewer

		var/safe_message = html_safe(rendered_message)
		var/font_wrapper_open = ""
		var/font_wrapper_close = ""
		if(auto_caps)
			font_wrapper_open += "<b>"
			font_wrapper_close = "</b>[font_wrapper_close]"
		if(is_emote)
			font_wrapper_open += "<i>"
			font_wrapper_close = "</i>[font_wrapper_close]"
		var/rendered = "[css_outline]<font face='Verdana' size = 1><center><font color=[text_color]>[font_wrapper_open][safe_message][font_wrapper_close]</font>"

		entry.maptext = rendered

		var/text_width = entry.maptext_width
		var/text_height = entry.maptext_height
		var/measure = viewer.client.MeasureText(rendered, width = 160)
		var/x_pos = findtext(measure, "x")
		if(x_pos)
			var/measured_width = text2num(copytext(measure, 1, x_pos))
			var/measured_height = text2num(copytext(measure, x_pos + 1, 0))
			if(measured_width > 0)
				text_width = min(max(measured_width + 4, 72), 180)
			if(measured_height > 0)
				text_height = min(max(measured_height + 2, 16), 72)
		else
			text_width = min(max(length(rendered_message) * 6, 72), 180)
			text_height = min(max(16 + round(length(rendered_message) / 28) * 12, 16), 72)

		entry.maptext_width = text_width
		entry.maptext_height = text_height
		entry.maptext_x = -round((text_width - 32) / 2)

		var/image/display = image(entry, src)
		display.alpha = 0
		display.pixel_z = -8
		display.pixel_y = 36
		entry.display_image = display

		src.runechat_entries += entry
		viewer.client.images += display

		var/list/viewer_entries = list()
		for(var/obj/effects/txt/runechat/existing in src.runechat_entries)
			if(existing && existing.viewer == viewer)
				viewer_entries += existing

		while(length(viewer_entries) > 3)
			var/obj/effects/txt/runechat/oldest = viewer_entries[1]
			viewer_entries.Cut(1, 2)
			src.remove_runechat(oldest, 2)

		src.refresh_runechat(viewer)
		animate(display, alpha = 255, pixel_z = 0, time = 2)

		var/lifetime = 26 + min(length(rendered_message), 36)
		spawn(lifetime)
			if(src && entry)
				src.remove_runechat(entry)
mob/proc/process_chat_command(var/msg)
	// -----------------------------
	// ADMIN CHAT VIA //
	// -----------------------------
	if(copytext(msg, 1, 3) == "//")
		if(!src.client || src.client.admin_level <= 0)
			return 1 // silently block non-admins

		var/text = copytext(msg, 3) // everything after //

		// If they only typed "//"
		if(!text || text == "" || text == " ")
			text = input(src, "Enter Admin Message:", "Admin Say") as text|null
			if(!text || text == "")
				return 1

		SendAdminChat(text)
		return 1
	if(findtext(msg, "/sc")) return scouter_speak(msg)
	if(findtext(msg, "/cd")) return handle_countdown()
	if(findtext(msg, "/lethal")) return toggle_lethality()
	if(findtext(msg, "/adminmode")) return toggle_adminmode()
	if(findtext(msg, "/ranks")) { usr << browse(Ranks, "window= ;size=700x600"); return 1 }
	if(findtext(msg, "/story")) { usr << browse(Story, "window= ;size=700x600"); return 1 }
	if(findtext(msg, "/rules"))
		if(!usr.open_menus) usr.open_menus = list()
		if(usr.open_help)
			usr.open_help = 0
			usr.open_menus.Remove(".open_help")
			usr.client.screen -= usr.hud_help
		else
			usr.open_help = 1
			usr.open_menus.Add(".open_help")
			usr.client.screen += usr.hud_help
			usr.client.screen -= usr.hud_opt
			usr.open_options = 0
			usr.open_menus.Remove("open_options")
		winset(usr,"map.map","focus=true")
		return 1
	//{ usr << browse(Story, "window= ;size=700x600"); return 1 }
	if(findtext(msg, "/ahc")) return handle_ahc()
	if(findtext(msg, "/resize")) { usr.resize_window(); usr << "Drag to resize"; return 1 }
	if(findtext(msg, "/ooc")) { toggle_ooc(); return 1 }
	if(findtext(msg, "/rps")){ handle_rps() ; return 1 }
	if(findtext(msg, "/save")) { save_self(); return 1}
	if(findtext(msg, "/screenfix")) return FixScreenOffset()
	if(findtext(msg, "/streamermode")) return Battle_Music_Mute()
	if(findtext(msg, "/music")) return Battle_Music()
	if(findtext(msg, "/rpm")) return rp_mode()
	if(findtext(msg, "/help")) { usr << Help; return 1 }
	if(findtext(msg, "/spy")) return toggle_spy()
	if(findtext(msg, "/ac")) return handle_admin_chat()
	if(findtext(msg, "/gf")) return general_fix()
	if(findtext(msg, "/settings")) return open_settings()
	if(findtext(msg, "/mate")) return handle_mating()
	if(findtext(msg, "/votem")) return handle_vote_mute()
	if(findtext(msg, "/y")) return handle_vote_response("yes")
	if(findtext(msg, "/n")) return handle_vote_response("no")
	if(findtext(msg, "/rp")) return emote_button_click()


	if(findtext(msg, "/quit"))
		usr.client.images = null
		usr.client.Del()
		return 1
	return 0
	/*if(findtext(msg, "/reconnect"))

		usr.client.images = null
	//	var/map_size=winget(src,"map.map","size")
		usr.pixel_x = 0
		usr.pixel_y = 0


		// Ensure eye is set immediately to avoid BYOND viewport bugs
		usr.client.eye = usr.client.mob
		usr.client.perspective = EYE_PERSPECTIVE

		// Force refresh for reconnects
		winset(usr, "map.map", "size=1x1") // force redraw
		//winset(usr, "map.map", "size=900x480")
		sleep(1)
		load_map_screen(usr.client)
		//winset(usr, "map.map", "size=[map_size]") // restore auto


		usr.client << link("byond://[world.address]:[world.port]")  // Reconnects cleanly
		//usr.Logout()
		//winset(usr, null, "command=.reconnect")
		return 1 */

mob/proc/scouter_speak(var/msg)
	var/text = copytext(msg, 4) // everything after /sc

	if(!src.current_scouter)
		src << output("You are not wearing a scouter!", "actionoutput")
		return

	var/channel = src.current_scouter.Channel
	var/message = "<font color=[src.text_color_ic]>--Scouter Channel#[channel]-- [src.get_strangername(src)] speaks '[text]'"

	for(var/mob/races/m in players)
		if(m.client && m.scouter_on && m.current_scouter && m.current_scouter.Channel == channel)
			m << output(message, "actionoutput")
			sleep(world.tick_lag)

// Admin command stubs
mob/proc/handle_countdown()
	var/total_time

	var/preset = input(src, "Pick a preset duration.") in list("30", "60", "90")
	if(preset == "30")total_time = 300
	if(preset == "60") total_time = 600
	if(preset == "90") total_time = 900
	var/show_final_countdown = input(src, "Show final 10-second countdown visually?") in list("Yes", "No")

	// Notify everyone nearby
	for(var/mob/M in range(20, src))
		M << output("([src] begins counting down from [total_time*0.1] seconds.)", "actionoutput")


	if(show_final_countdown == "Yes" && total_time > 10)
		spawn(total_time-10)
			FinalCountdown(10)
	else
		spawn(total_time)
			FinishCountdown(src, total_time)
	return 1

	/*else
		total_time = input(src, "Enter your custom countdown duration (seconds, max 3600):") as num
		if(total_time > 3600)
			src << "Maximum allowed time is 3600 seconds (1 hour). Countdown cancelled."
			return 1

		var/show_final_countdown = input(src, "Show final 10-second countdown visually?") in list("Yes", "No")

		// Notify everyone nearby
		for(var/mob/M in range(20, src))
			M << output("([src] begins counting down from [total_time] seconds.)", "actionoutput")


		if(show_final_countdown == "Yes" && total_time > 10)
			spawn(total_time - 10)
				FinalCountdown(10)
		else
			spawn(total_time)
				FinishCountdown(src, total_time)
		return 1
		*/

mob/proc/toggle_lethality()
	if(spar_mode&&!srs_mode)
		spar_mode = 1
		srs_mode = 1
		lethal_mode=0
		src << "<b>You have enabled serious mode. You will inflict limb damage, but cannot rip limbs</b>"
		view(6,src) <<output("[src] is showing<font color = yellow> SERIOUS</font> intentions.","actionoutput")
		return 1
	if(srs_mode&&spar_mode)
		spar_mode = 0
		srs_mode = 0
		lethal_mode = 1
		usr << "<font color=red><b>You have enabled lethal mode. Only use this if you intend to maim or kill your opponent.</font></b>"
		view(6,src) <<output("[src] is showing<font color = red> LETHAL</font> intentions.","actionoutput")
		return 1
	if(lethal_mode==1)
		spar_mode = 1
		srs_mode=0
		lethal_mode=0
		src << "You have enabled spar mode."
		view(6,src) <<output( "[src] is showing<font color=green> CASUAL</font> intentions.","actionoutput")
		return 1
	return 1

mob/proc/toggle_adminmode()
	if(src.key in StaffTeam)
		world<<output("<font color=yellow>(Admin Log):[src.key] went off duty.</font>","rpspy.output2")

		if(src.service_lvl) src.service_lvl=0
		StaffTeam -= "[src.key]"
		sleep(0.1)
		src.show_adminpanel()
		return
	else
		if(src.key in CodedStaff)
			StaffTeam += "[src.key]"
			src.service_lvl=1
			sleep(0.1)
			show_adminpanel()
			world<<output("<font color=yellow>(Admin Log):[src.key] is on duty.</font>","rpspy.output2")
	return 1

mob/proc/handle_ahc()
    var/msg = input("How can we help you?") as text
    msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)

    if(!msg)
        return

    for(var/mob/M in players)
        if(!M || !M.client) continue
        if(M.key in StaffTeam)
            M << "<b><font color=#89A7E2>ADMIN HELP:</font></b> \
            <a href='?ahc_reply=\ref[src]'>[src.key] ([src.fullname])</a>: [msg]"

    src << "<b><font color=#89A7E2>AHC sent to online administrators.</font></b>"
    return 1
mob/proc/save_self()
	if(src.client)
		if(src.can_save && src.started)
			src.Mob_Save(0)
			src<<"<font color=green><b>Saved game.</b></font>"
	return 1
mob/proc/toggle_ooc()
	if(src.listen_ooc == 1)
		src<<"You toggle your OOC: <font color=red>OFF</font>"
		src.listen_ooc=0
		return
	else
		src<<"You toggle your OOC:<font color=green>ON</font>"
		src.listen_ooc=1
	return 1
mob/proc/rp_mode()
	if(src.rp_mode == null||!src.rp_mode)
		view(10,src)<<output("<b>[src] has entered Roleplay Mode.</b>","actionoutput")
		src.rp_mode = "Roleplay"
		src.overlays +=  src.roleplaymode_icon
		return 1
	if(src.rp_mode == "Roleplay")
		view(10,src)<<output("<b>[src] has entered Phase Mode.</b>","actionoutput")
		src.rp_mode = "Phase"
		var/approval = 0
		var/people =0
		src.overlays +=  src.phase_icon
		for(var/mob/races/p in oview(25,src))
			people ++
			if(p.rp_mode=="Phase")
				switch(alert(p,"[src] wishes to join the Phase, do you accept?","","Yes","No"))
					if("Yes")
						approval ++

				if(approval >= people)
					p<<output("[src] joined the phase!","actionoutput")
					src<<output("[src] joined the phase!","actionoutput")

				else
					p<<output("[src] was not allowed into the phase!","actionoutput")
					src<<output("You were not allowed into the phase.","actionoutput")

		return 1
	if(src.rp_mode == "Phase")
		view(10,src)<<output("[src] turned off their roleplay mode.","actionoutput")
		src.rp_mode = null
		src.overlays -= src.roleplaymode_icon
		src.overlays -=  src.phase_icon
		return 1
mob/proc/handle_rps()
	var/mob/choice = input("Select a player:") as null|obj|mob in oview(5,usr)
	var/yourselection
	var/theirselection
	if(choice.client)
		switch(alert(choice,"[src] wishes to play Rock Paper Scissors with you, do you accept?","","Yes","No"))
			if("Yes")
				switch(input(choice,"Make your selection.") in list ("Rock","Paper","Scissors"))
					if("Rock")
						theirselection="Rock"
					if("Paper")
						theirselection="Paper"
					if("Scissors")
						theirselection="Scissors"
				switch(input(src,"Make your selection.") in list ("Rock","Paper","Scissors"))
					if("Rock")
						yourselection="Rock"
					if("Paper")
						yourselection="Paper"
					if("Scissors")
						yourselection="Scissors"
				if(yourselection=="Rock"&&theirselection=="Paper")
					view(src)<<output("[src] uses Rock. [choice] uses Paper. [choice] wins.","actionoutput")
				if(yourselection=="Paper"&&theirselection=="Rock")
					view(src)<<output("[src] uses Paper. [choice] uses Rock. [src] wins.","actionoutput")
				if(yourselection=="Rock"&&theirselection=="Scissors")
					view(src)<<output("[src] uses Rock. [choice] uses Scissors. [src] wins.","actionoutput")
				if(yourselection=="Rock"&&theirselection=="Rock")
					view(src)<<output("[src] uses Rock. [choice] uses Rock. It is a draw.","actionoutput")
				if(yourselection=="Paper"&&theirselection=="Scissors")
					view(src)<<output("[src] uses Paper. [choice] uses Scissors. [choice] wins.","actionoutput")
				if(yourselection=="Paper"&&theirselection=="Paper")
					view(src)<<output("[src] uses Paper. [choice] uses Paper. It is a draw.","actionoutput")
				if(yourselection=="Scissors"&&theirselection=="Paper")
					view(src)<<output("[usr] uses Scissors. [choice] uses Paper. [src] wins.","actionoutput")
				if(yourselection=="Scissors"&&theirselection=="Rock")
					view(src)<<output("[src] uses Scissors. [choice] uses Rock. [choice] wins.","actionoutput")
				if(yourselection=="Scissors"&&theirselection=="Scissors")
					view(src)<<output("[src] uses Scissors. [choice] uses Scissors. It is a draw.","actionoutput")
	return 1

mob/proc/toggle_spy()
	usr.admin_spying = !usr.admin_spying
	winset(usr, "rpspy", "is-visible=[usr.admin_spying ? "true" : "false"]")
	return 1

mob/proc/handle_admin_chat()
	var/msg2 = input("Admin Chat:") as text
	if(!msg2) return 1
	for(var/mob/M in players)
		if(M.service_lvl)
			M << "<font size=2><b><font color=#CB0739>(AdminChat)[usr.key]: <font color=white>[msg2]</font>"
	return 1

mob/proc/general_fix()
	src.particles = null //Keep this for a while, I think saving them makes the player crash.

	var/list/screen_mobs = list()
	if(src && src.client)
		for(var/mob/m in src.client.screen)
			src.client.screen -= m
			screen_mobs += m
	//if(src.filters) src.filters = null
	src.rebuild_menus()
	src.hud_char.update_portrait_transform()
	if(client.custom_view)
		if(client.custom_view == "Auto")

			client.pixel_x = 32
			client.pixel_y = 32
		else if(client.custom_view == "Zero")
			client.pixel_x = 0
			client.pixel_y = 0
		else if(client.custom_view != "Auto" && client.custom_view != "Zero" )
			client.pixel_x = client.custom_view
			client.pixel_y = client.custom_view
	else
		client.pixel_x = 0
		client.pixel_y = 0
	src.check_glow_planes()
	src.reset_ui_proc()
	winset(src, null, "refresh=1")

	// ---- INVENTORY SANITIZER ----
	for(var/sl = 1, sl < 49, sl++)
		var/obj/items/I = src.inv[sl]

		if(!I)
			src.inv[sl] = null
			continue

		// Deleted object
		if(!I || !I.icon && I.loc != src)
			src.inv[sl] = null
			continue

		// Item not actually inside player
		if(I.loc != src)
			src.inv[sl] = null
			continue

		// Slot mismatch
		if(I.slot != sl)
			I.slot = sl

		// Invisible or broken icon repair
		if(!I.icon && I.loc == src)
			I.icon = initial(I.icon)

		if(!I.icon_state && I.loc == src)
			I.icon_state = initial(I.icon_state)

	src.refresh_inv()
//	src.redraw_appearance()
	//update_rating(src)
	//update_qp(src)
	if(src.moved==1) src.moved=0
	for(var/obj/effects/after_image/af in src.afterimages)
		af.in_use = 0
		af.loc = null
		af.alpha = 130
		af.pixel_z = 0
	//General_Portrait_Fix(src)
	src.update_icon(src)
	if(src.port == null || src.port.vis_contents == null || !src.port)
		if(src.port == null || !src.port)
			src.port = new /obj/portrait/body
			src.port.plane = 25
			src.port.overlays += /obj/portrait/border
			src.port.underlays += /obj/portrait/background


		for(var/atom/movable/A in src.portrait_contents)
			if(A.icon)
				src.port.vis_contents += A.icon
	view(5,src)<<output("[src] Generally fixed themselves.","actionoutput")
	return 1


mob/proc/open_settings()
	// Settings menu placeholder
	switch(input(src,"Settings:")in list("Change IC Color", "General Fix", "Toggle Battle Text", "Toggle Anger Text"))
		if("Change IC Color")
			var/new_c = input("New color for IC:") as color
			src.text_color_ic = new_c
		if("Toggle Battle Text")
			if(src.battle_text == 1)
				src.battle_text = 0
				src<<"You toggle Battle Text: <font color=red>OFF</font>"
				return 1
			else
				src.battle_text =1
				src<<"You toggle Battle Text: <font color=green>ON</font>"
				return 1
		if("Toggle Anger Text")
			if(src.anger_text == 1)
				src.anger_text = 0
				src<<"You toggle Anger Text: <font color=red>OFF</font>"
				return 1
			else
				src.anger_text =1
				src<<"You toggle Anger Text: <font color=green>ON</font>"
				return 1
		if("General Fix")
			//src.dimiss_all_alerts()

			src.particles = null //Keep this for a while, I think saving them makes the player crash.
			src.hud_char.update_portrait_transform()
			var/list/screen_mobs = list()
			if(src && src.client)
				for(var/mob/m in src.client.screen)
					src.client.screen -= m
					screen_mobs += m
		//	if(src.filters) src.filters = null

			if(client.custom_view)
				if(client.custom_view == "Auto")

					client.pixel_x = 32
					client.pixel_y = 32
				else if(client.custom_view == "Zero")
					client.pixel_x = 0
					client.pixel_y = 0
				else if(client.custom_view != "Auto" && client.custom_view != "Zero" )
					client.pixel_x = client.custom_view
					client.pixel_y = client.custom_view
			else
				client.pixel_x = 0
				client.pixel_y = 0

			for(var/mob/m in screen_mobs)
				if(src.client) src.client.screen += m
			if(src.skill_divine_weapon)
				for(var/mob/s in src.skill_divine_weapon.active_splits)
					s.filters += filter(type="outline",size=1, color=rgb(204,236,255))
					s.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(204,236,255))
					s.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
					if(s.shadow) s.shadow.vis_contents += new/obj/effects/weapon_energy



			src.check_glow_planes()
			src.reset_ui_proc()
			winset(usr, null, "refresh=1")
			//src.redraw_appearance()
			//update_rating(src)
			//update_qp(src)

			if(usr.moved) usr.moved=0
			//General_Portrait_Fix(usr)
			usr.update_icon(usr)
			usr.update_looks(usr)
			view(5,usr)<<output("[usr] Generally fixed themselves.","actionoutput")
			return 1
	return 1

mob/proc/handle_mating()
	if(src.children<=0&&src.client.max_childslots==0||src.children<=0&&src.client.childslots<src.client.max_childslots) {src<<"You do not have anymore child slots.";return}
	if(src.age < 21&&src.rating<500)
		usr<<"You haven't played this character enough, or you are not old enough."
		return
	if(src.age < 21)
		usr<<"Your character is not old enough."
		return
	if(src.rating<500)
		usr<<"You haven't played your character long enough."
		return

	if(src.oozaru_form==1) return
	if(src.lssj_form ==1) return
	if(src.icon_state=="KO"||src.koed==1) return
	if(!src.in_BioRegenTank&&!src.in_DeluxeTank)
		for(var/mob/A in get_step(src,src.dir))
			if(A.client)
				if(A&&!A.asexual)
					if(A.age < 21&&A.rating<500)
						A<<"You haven't played this character enough, or you are not old enough."
						return

					if(A.age < 21)
						src<<"[A] character is not old enough."
						return
					if(A.rating<500)
						src<<"[A] hasn't played their character long enough."
						return



	return 1

mob/var/tmp/next_say_allowed = 0
mob/var/tmp/last_message = ""
mob/var/tmp/next_ooc_allowed = 0


proc/html_safe(t as text)
    t = replacetext(t, "&", "&amp;")
    t = replacetext(t, "<", "&lt;")
    t = replacetext(t, ">", "&gt;")
    return t
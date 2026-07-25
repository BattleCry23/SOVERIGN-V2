//Used to catch local/distant html/javascript/href calls and process their contents.
/*mob/Topic(href,href_list)
	/*
	src<<href_list["minutes"]
	src<<href_list["os"]
	src<<href_list["agent"]
	src<<href_list["resx"] + "x" + href_list["resy"]
	src<<href_list["hours"] + ":" + href_list["minutes"]
	src<<href_list["os"]
	src<<href_list["clip"]
	*/
	src.clipboard = href_list["clip"]
	/*
	if(src.typing)
		var/obj/i = src.typing
		i.caret_pos = length(i.string_full)+1
	*/
	//var/set_focus_back_later_below
	//winset(src,"map.map","focus=true")
	src << browse(null)
	winshow(src,"browser",0) */

mob/var/tmp
	SayUp=1
	chatbox=1
mob
	verb
		Winsay()
			set hidden=1
			if(usr.SayUp)
				usr.SayUp=0
				winset(usr, null, {"
				ActionOutputChild.focus      = "false";
				ActionOutputChild.is-visible      = "false";
				sayinput.is-visible = "false";
				"})

				winset(usr, null, {"
				map.map.focus      = "true";
				"})
				if(usr.chatbox==1)
					winset(usr, null, {"
						ChatOut.size      = "568,422";
						worldinput.pos = "0,1061";
						"})

				return

			usr.SayUp=1
			winset(usr, null, {"
				ActionOutputChild.focus      = "true";
				ActionOutputChild.is-visible      = "true";
				sayinput.is-visible = "true";
			"})
			if(usr.chatbox==0)
				winset(usr, null, {"
					ActionOutputChild.size      = "568,418";
					ActionOutputChild.pos       = "0,645":
					sayinput.pos = "0,1061";
					"})

			else if(usr.chatbox == 1)
				winset(usr, null, {"
				ChatOut.size      = "568,189";
				worldinput.pos = "0,826";
				"})



		//	usr.overlays += 'MouthSpeak.dmi'

		ChatBox()
			set hidden=1
			if(usr.chatbox)
				usr.chatbox=0
				winset(usr, null, {"
					ChatOut.focus      = "false";
					ChatOut.is-visible      = "false";

					worldinput.is-visible = "false";
				"})
				if(SayUp==1)
					winset(usr, null, {"
						ActionOutputChild.size      = "568,418";
						ActionOutputChild.pos       = "0,645":
						sayinput.pos = "0,1061";
						"})
				return

			usr.chatbox=1
			winset(usr, null, {"
				ChatOut.focus      = "true";
				ChatOut.is-visible      = "true";

				worldinput.is-visible = "true";
			"})

			if(usr.SayUp==0)
				/*winset(usr, null, {"
				ChatOut.size      = "568,189";
				worldinput.pos = "0,825";
				"})*/
				winset(usr, null, {"
					ChatOut.size      = "568,422";
					worldinput.pos = "0,1061";
					"})
			else if(usr.SayUp==1)
				winset(usr, null, {"
				ActionOutputChild.size      = "568,217";
				ActionOutputChild.pos      = "0,843";
				sayinput.pos = "0,1061";
				"})
			usr.chatbox=1

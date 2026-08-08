#define LOWER_ASCII_MIN 97
#define LOWER_ASCII_MAX 122
#define UPPER_ASCII_MIN 65
#define UPPER_ASCII_MAX 90
#define NUMBER_ASCII_MIN 60
#define NUMBER_ASCII_MAX 71
#define IN_BOUNDS( X, A, B ) ( X >= A && X <= B )
#define IS_LOWERCASE(X) IN_BOUNDS( X, LOWER_ASCII_MIN, LOWER_ASCII_MAX )
#define IS_UPPERCASE(X) IN_BOUNDS( X, UPPER_ASCII_MIN, UPPER_ASCII_MAX )
#define IS_NUMBER(X) IN_BOUNDS( X, NUMBER_ASCII_MIN, NUMBER_ASCII_MAX )
mob/var
	CurrentLanguage=""
	CommonLanguage=0
	SaiyanLanguage=0
	ChangelingLanguage=0
	AlienLanguage=0
	DemonLanguage=0
	KaiLanguage=0
	NewbornLanguage=0
	NamekianLanguage=0

proc/LanguageOutput(mob/M,var/phrase)
	var/leng=length(phrase)
	var/counter=length(phrase)
	var/newphrase="",newletter=""
	switch(M.CurrentLanguage)
		if("Newborn")
			for(var/mob/MM in view(M,15))
				if(MM.NewbornLanguage==100)
					return phrase
				if(MM.NewbornLanguage<99&&MM.NewbornLanguage>=80)
					while(counter>=1)
						newletter="[copytext(phrase,(leng-counter)+1,(leng-counter)+2)]"
						if(rand(1,9)==9)
							if(lowertext(newletter)=="o")	newletter="u"
							if(lowertext(newletter)=="s")	newletter="ch"
							if(lowertext(newletter)=="a")	newletter="ah"
							if(lowertext(newletter)=="c")	newletter="k"
							if(lowertext(newletter)=="d")	newletter="b"
							if(lowertext(newletter)=="g")	newletter="je"
							if(lowertext(newletter)=="r")	newletter="ar"
							if(lowertext(newletter)=="q")	newletter="khu"
						switch(rand(1,17))
							if(1,3,5)	newletter="<small>[newletter]</small>"
							if(2,4,6,15)	newletter="<big>[newletter]</big>"
							if(7)	newletter="[uppertext(newletter)]"
							if(8)	newletter+="'"
							if(9,10)	newletter="[newletter]-ss"
							if(11,12)	newletter="<big>[newletter]</big>"
							if(13)	newletter="<i>[newletter]</i>"
							if(16)	newletter="<big>uhk'</big>"
							if(17)	newletter="-w"
						newphrase+="[newletter]";counter-=1
						if(prob(30))
							MM.NewbornLanguage++
							if(MM.NewbornLanguage>100)
								MM.NewbornLanguage=100

					phrase=newphrase


				if(MM.NewbornLanguage<80&&MM.NewbornLanguage>=69)
					while(counter>=1)
						newletter="[copytext(phrase,(leng-counter)+1,(leng-counter)+2)]"
						if(rand(1,12)==12)
							if(lowertext(newletter)=="o")	newletter="yu"
							if(lowertext(newletter)=="s")	newletter="xh"
							if(lowertext(newletter)=="a")	newletter="ehh"
							if(lowertext(newletter)=="c")	newletter="k"
							if(lowertext(newletter)=="d")	newletter="b"
							if(lowertext(newletter)=="g")	newletter="xe"
							if(lowertext(newletter)=="r")	newletter="ar"
							if(lowertext(newletter)=="q")	newletter="keyh"
							if(lowertext(newletter)=="w")	newletter="wuah"
							if(lowertext(newletter)=="n")	newletter="nv"
							if(lowertext(newletter)=="h")	newletter="jau"
						switch(rand(1,17))
							if(1,3,5)	newletter="<small>[newletter]</small>"
							if(2,4,6,15)	newletter="<big>[newletter]</big>"
							if(7)	newletter="[uppertext(newletter)]"
							if(8)	newletter+="'"
							if(9,10)	newletter="[newletter]-ss"
							if(11,12)	newletter="<big>[newletter]</big>"
							if(13)	newletter="<i>[newletter]</i>"
							if(16)	newletter="<big>uhk'</big>"
							if(17)	newletter="-w"
						newphrase+="[newletter]";counter-=1
						if(prob(40))
							MM.NewbornLanguage++
							if(MM.NewbornLanguage>100)
								MM.NewbornLanguage=100
						//sleep(0.2)
					phrase=newphrase



				if(MM.NewbornLanguage<69&&MM.NewbornLanguage>=30)
					while(counter>=1)
						newletter="[copytext(phrase,(leng-counter)+1,(leng-counter)+2)]"
						if(rand(1,12)==12)
							if(lowertext(newletter)=="o")	newletter="io"
							if(lowertext(newletter)=="s")	newletter="x"
							if(lowertext(newletter)=="a")	newletter="h"
							if(lowertext(newletter)=="c")	newletter="hk"
							if(lowertext(newletter)=="d")	newletter="di"
							if(lowertext(newletter)=="g")	newletter="hej"
							if(lowertext(newletter)=="r")	newletter="uar"
							if(lowertext(newletter)=="q")	newletter="hkew"
							if(lowertext(newletter)=="w")	newletter="huaw"
							if(lowertext(newletter)=="n")	newletter="nhv"
							if(lowertext(newletter)=="h")	newletter="uaj"
						switch(rand(1,17))
							if(1,3,5)	newletter="<small>[newletter]</small>"
							if(2,4,6,15)	newletter="<big>[newletter]</big>"
							if(7)	newletter="[uppertext(newletter)]"
							if(8)	newletter+="'"
							if(9,10)	newletter="[newletter]-ss"
							if(11,12)	newletter="<big>[newletter]</big>"
							if(13)	newletter="<i>[newletter]</i>"
							if(16)	newletter="<big>uhk'</big>"
							if(17)	newletter="-w"
						newphrase+="[newletter]";counter-=1
						if(prob(40))
							MM.NewbornLanguage++
							if(MM.NewbornLanguage>100)
								MM.NewbornLanguage=100
						sleep(0.2)
					phrase=newphrase



				if(MM.NewbornLanguage<30&&MM.NewbornLanguage>=15)
					while(counter>=1)
						newletter="[copytext(phrase,(leng-counter)+1,(leng-counter)+2)]"
						if(rand(1,14)==14)
							if(lowertext(newletter)=="o")	newletter="io"
							if(lowertext(newletter)=="s")	newletter="x"
							if(lowertext(newletter)=="a")	newletter="h"
							if(lowertext(newletter)=="c")	newletter="h"
							if(lowertext(newletter)=="d")	newletter="i"
							if(lowertext(newletter)=="g")	newletter="ej"
							if(lowertext(newletter)=="r")	newletter="ur"
							if(lowertext(newletter)=="q")	newletter="hew"
							if(lowertext(newletter)=="w")	newletter="uaw"
							if(lowertext(newletter)=="n")	newletter="hv"
							if(lowertext(newletter)=="h")	newletter="aj"
							if(lowertext(newletter)=="f")	newletter="hu"
							if(lowertext(newletter)=="t")	newletter="f"
							if(lowertext(newletter)=="m")	newletter="f"

						switch(rand(1,17))
							if(1,3,5)	newletter="<small>[newletter]</small>"
							if(2,4,6,15)	newletter="<big>[newletter]</big>"
							if(7)	newletter="[uppertext(newletter)]"
							if(8)	newletter+="'"
							if(9,10)	newletter="[newletter]-ss"
							if(11,12)	newletter="<big>[newletter]</big>"
							if(13)	newletter="<i>[newletter]</i>"
							if(16)	newletter="<big>uhk'</big>"
							if(17)	newletter="-w"
						newphrase+="[newletter]";counter-=1
						if(prob(40))
							MM.NewbornLanguage++
							if(MM.NewbornLanguage>100)
								MM.NewbornLanguage=100
					//	sleep(0.2)
					phrase=newphrase



				if(MM.NewbornLanguage<15&&MM.NewbornLanguage>=0)
					while(counter>=1)
						newletter="[copytext(phrase,(leng-counter)+1,(leng-counter)+2)]"
						if(rand(1,17)==17)
							if(lowertext(newletter)=="o")	newletter="aq"
							if(lowertext(newletter)=="s")	newletter="xz"
							if(lowertext(newletter)=="a")	newletter="hjc"
							if(lowertext(newletter)=="c")	newletter="q"
							if(lowertext(newletter)=="d")	newletter="c"
							if(lowertext(newletter)=="g")	newletter="ji"
							if(lowertext(newletter)=="r")	newletter="ura"
							if(lowertext(newletter)=="q")	newletter="hewk"
							if(lowertext(newletter)=="w")	newletter="ua"
							if(lowertext(newletter)=="n")	newletter="zv"
							if(lowertext(newletter)=="h")	newletter="auj"
							if(lowertext(newletter)=="f")	newletter="hs"
							if(lowertext(newletter)=="t")	newletter="fe"
							if(lowertext(newletter)=="x")	newletter="shk"
							if(lowertext(newletter)=="z")	newletter="yi"
							if(lowertext(newletter)=="y")	newletter="ihy"
						switch(rand(1,17))
							if(1,3,5)	newletter="<small>[newletter]</small>"
							if(2,4,6,15)	newletter="<big>[newletter]</big>"
							if(7)	newletter="[uppertext(newletter)]"
							if(8)	newletter+="'"
							if(9,10)	newletter="[newletter]-ss"
							if(11,12)	newletter="<big>[newletter]</big>"
							if(13)	newletter="<i>[newletter]</i>"
							if(16)	newletter="<big>uhk'</big>"
							if(17)	newletter="-w"
						newphrase+="[newletter]";counter-=1
						if(prob(50))
							MM.NewbornLanguage++
							if(MM.NewbornLanguage>100)
								MM.NewbornLanguage=100
						//sleep(0.2)
					phrase=newphrase


		if("Saiyan")
			for(var/mob/MM in view(M,15))
				if(MM.SaiyanLanguage==100)
					return phrase
				if(MM.SaiyanLanguage<99&&MM.SaiyanLanguage>=80)
					while(counter>=1)
						newletter="[copytext(phrase,(leng-counter)+1,(leng-counter)+2)]"
						if(rand(1,9)==9)
							if(lowertext(newletter)=="o")	newletter="u"
							if(lowertext(newletter)=="s")	newletter="ch"
							if(lowertext(newletter)=="a")	newletter="ah"
							if(lowertext(newletter)=="c")	newletter="k"
							if(lowertext(newletter)=="d")	newletter="b"
							if(lowertext(newletter)=="g")	newletter="je"
							if(lowertext(newletter)=="r")	newletter="ar"
							if(lowertext(newletter)=="q")	newletter="khu"
						switch(rand(1,17))
							if(1,3,5)	newletter="<small>[newletter]</small>"
							if(2,4,6,15)	newletter="<big>[newletter]</big>"
							if(7)	newletter="[uppertext(newletter)]"
							if(8)	newletter+="'"
							if(9,10)	newletter="[newletter]-ss"
							if(11,12)	newletter="<big>[newletter]</big>"
							if(13)	newletter="<i>[newletter]</i>"
							if(16)	newletter="<big>uhk'</big>"
							if(17)	newletter="-w"
						newphrase+="[newletter]";counter-=1
						if(prob(50))
							MM.SaiyanLanguage+=rand(2,4.5)
							if(MM.SaiyanLanguage>100)
								MM.SaiyanLanguage=100
					//	sleep(0.2)
					phrase=newphrase


				if(MM.SaiyanLanguage<80&&MM.SaiyanLanguage>=69)
					while(counter>=1)
						newletter="[copytext(phrase,(leng-counter)+1,(leng-counter)+2)]"
						if(rand(1,12)==12)
							if(lowertext(newletter)=="o")	newletter="yu"
							if(lowertext(newletter)=="s")	newletter="xh"
							if(lowertext(newletter)=="a")	newletter="ehh"
							if(lowertext(newletter)=="c")	newletter="k"
							if(lowertext(newletter)=="d")	newletter="b"
							if(lowertext(newletter)=="g")	newletter="xe"
							if(lowertext(newletter)=="r")	newletter="ar"
							if(lowertext(newletter)=="q")	newletter="keyh"
							if(lowertext(newletter)=="w")	newletter="wuah"
							if(lowertext(newletter)=="n")	newletter="nv"
							if(lowertext(newletter)=="h")	newletter="jau"
						switch(rand(1,17))
							if(1,3,5)	newletter="<small>[newletter]</small>"
							if(2,4,6,15)	newletter="<big>[newletter]</big>"
							if(7)	newletter="[uppertext(newletter)]"
							if(8)	newletter+="'"
							if(9,10)	newletter="[newletter]-ss"
							if(11,12)	newletter="<big>[newletter]</big>"
							if(13)	newletter="<i>[newletter]</i>"
							if(16)	newletter="<big>uhk'</big>"
							if(17)	newletter="-w"
						newphrase+="[newletter]";counter-=1
						if(prob(50))
							MM.SaiyanLanguage+=rand(1,5.5)
							if(MM.SaiyanLanguage>100)
								MM.SaiyanLanguage=100
						sleep(0.2)
					phrase=newphrase



				if(MM.SaiyanLanguage<69&&MM.SaiyanLanguage>=30)
					while(counter>=1)
						newletter="[copytext(phrase,(leng-counter)+1,(leng-counter)+2)]"
						if(rand(1,12)==12)
							if(lowertext(newletter)=="o")	newletter="io"
							if(lowertext(newletter)=="s")	newletter="x"
							if(lowertext(newletter)=="a")	newletter="h"
							if(lowertext(newletter)=="c")	newletter="hk"
							if(lowertext(newletter)=="d")	newletter="di"
							if(lowertext(newletter)=="g")	newletter="hej"
							if(lowertext(newletter)=="r")	newletter="uar"
							if(lowertext(newletter)=="q")	newletter="hkew"
							if(lowertext(newletter)=="w")	newletter="huaw"
							if(lowertext(newletter)=="n")	newletter="nhv"
							if(lowertext(newletter)=="h")	newletter="uaj"
						switch(rand(1,17))
							if(1,3,5)	newletter="<small>[newletter]</small>"
							if(2,4,6,15)	newletter="<big>[newletter]</big>"
							if(7)	newletter="[uppertext(newletter)]"
							if(8)	newletter+="'"
							if(9,10)	newletter="[newletter]-ss"
							if(11,12)	newletter="<big>[newletter]</big>"
							if(13)	newletter="<i>[newletter]</i>"
							if(16)	newletter="<big>uhk'</big>"
							if(17)	newletter="-w"
						newphrase+="[newletter]";counter-=1
						if(prob(50))
							MM.SaiyanLanguage+=rand(1,5.5)
							if(MM.SaiyanLanguage>100)
								MM.SaiyanLanguage=100
					//	sleep(0.2)
					phrase=newphrase



				if(MM.SaiyanLanguage<30&&MM.SaiyanLanguage>=15)
					while(counter>=1)
						newletter="[copytext(phrase,(leng-counter)+1,(leng-counter)+2)]"
						if(rand(1,14)==14)
							if(lowertext(newletter)=="o")	newletter="io"
							if(lowertext(newletter)=="s")	newletter="x"
							if(lowertext(newletter)=="a")	newletter="h"
							if(lowertext(newletter)=="c")	newletter="h"
							if(lowertext(newletter)=="d")	newletter="i"
							if(lowertext(newletter)=="g")	newletter="ej"
							if(lowertext(newletter)=="r")	newletter="ur"
							if(lowertext(newletter)=="q")	newletter="hew"
							if(lowertext(newletter)=="w")	newletter="uaw"
							if(lowertext(newletter)=="n")	newletter="hv"
							if(lowertext(newletter)=="h")	newletter="aj"
							if(lowertext(newletter)=="f")	newletter="hu"
							if(lowertext(newletter)=="t")	newletter="f"
							if(lowertext(newletter)=="m")	newletter="f"

						switch(rand(1,17))
							if(1,3,5)	newletter="<small>[newletter]</small>"
							if(2,4,6,15)	newletter="<big>[newletter]</big>"
							if(7)	newletter="[uppertext(newletter)]"
							if(8)	newletter+="'"
							if(9,10)	newletter="[newletter]-ss"
							if(11,12)	newletter="<big>[newletter]</big>"
							if(13)	newletter="<i>[newletter]</i>"
							if(16)	newletter="<big>uhk'</big>"
							if(17)	newletter="-w"
						newphrase+="[newletter]";counter-=1
						if(prob(50))
							MM.SaiyanLanguage+=rand(1,6.5)
							if(MM.SaiyanLanguage>100)
								MM.SaiyanLanguage=100
						sleep(0.2)
					phrase=newphrase



				if(MM.SaiyanLanguage<15&&MM.SaiyanLanguage>=0)
					while(counter>=1)
						newletter="[copytext(phrase,(leng-counter)+1,(leng-counter)+2)]"
						if(rand(1,17)==17)
							if(lowertext(newletter)=="o")	newletter="aq"
							if(lowertext(newletter)=="s")	newletter="xz"
							if(lowertext(newletter)=="a")	newletter="hjc"
							if(lowertext(newletter)=="c")	newletter="q"
							if(lowertext(newletter)=="d")	newletter="c"
							if(lowertext(newletter)=="g")	newletter="ji"
							if(lowertext(newletter)=="r")	newletter="ura"
							if(lowertext(newletter)=="q")	newletter="hewk"
							if(lowertext(newletter)=="w")	newletter="ua"
							if(lowertext(newletter)=="n")	newletter="zv"
							if(lowertext(newletter)=="h")	newletter="auj"
							if(lowertext(newletter)=="f")	newletter="hs"
							if(lowertext(newletter)=="t")	newletter="fe"
							if(lowertext(newletter)=="x")	newletter="shk"
							if(lowertext(newletter)=="z")	newletter="yi"
							if(lowertext(newletter)=="y")	newletter="ihy"
						switch(rand(1,17))
							if(1,3,5)	newletter="<small>[newletter]</small>"
							if(2,4,6,15)	newletter="<big>[newletter]</big>"
							if(7)	newletter="[uppertext(newletter)]"
							if(8)	newletter+="'"
							if(9,10)	newletter="[newletter]-ss"
							if(11,12)	newletter="<big>[newletter]</big>"
							if(13)	newletter="<i>[newletter]</i>"
							if(16)	newletter="<big>uhk'</big>"
							if(17)	newletter="-w"
						newphrase+="[newletter]";counter-=1
						if(prob(50))
							MM.SaiyanLanguage+=rand(2,7.5)
							if(MM.SaiyanLanguage>100)
								MM.SaiyanLanguage=100
						sleep(0.2)
					phrase=newphrase


		if("Changeling")
			for(var/mob/MM in view(M,15))
				if(MM.ChangelingLanguage==100)
					return phrase
				if(MM.ChangelingLanguage<99&&MM.ChangelingLanguage>=80)
					while(counter>=1)
						newletter="[copytext(phrase,(leng-counter)+1,(leng-counter)+2)]"
						if(rand(1,9)==9)
							if(lowertext(newletter)=="o")	newletter="u"
							if(lowertext(newletter)=="s")	newletter="ch"
							if(lowertext(newletter)=="a")	newletter="ah"
							if(lowertext(newletter)=="c")	newletter="k"
							if(lowertext(newletter)=="d")	newletter="b"
							if(lowertext(newletter)=="g")	newletter="je"
							if(lowertext(newletter)=="r")	newletter="ar"
							if(lowertext(newletter)=="q")	newletter="khu"
						switch(rand(1,17))
							if(1,3,5)	newletter="<small>[newletter]</small>"
							if(2,4,6,15)	newletter="<big>[newletter]</big>"
							if(7)	newletter="[uppertext(newletter)]"
							if(8)	newletter+="'"
							if(9,10)	newletter="[newletter]-ss"
							if(11,12)	newletter="<big>[newletter]</big>"
							if(13)	newletter="<i>[newletter]</i>"
							if(16)	newletter="<big>uhk'</big>"
							if(17)	newletter="-w"
						newphrase+="[newletter]";counter-=1
						if(prob(50))
							MM.ChangelingLanguage+=rand(2,4.5)
							if(MM.ChangelingLanguage>100)
								MM.ChangelingLanguage=100
						sleep(0.2)
					phrase=newphrase


				if(MM.ChangelingLanguage<80&&MM.ChangelingLanguage>=69)
					while(counter>=1)
						newletter="[copytext(phrase,(leng-counter)+1,(leng-counter)+2)]"
						if(rand(1,12)==12)
							if(lowertext(newletter)=="o")	newletter="yu"
							if(lowertext(newletter)=="s")	newletter="xh"
							if(lowertext(newletter)=="a")	newletter="ehh"
							if(lowertext(newletter)=="c")	newletter="k"
							if(lowertext(newletter)=="d")	newletter="b"
							if(lowertext(newletter)=="g")	newletter="xe"
							if(lowertext(newletter)=="r")	newletter="ar"
							if(lowertext(newletter)=="q")	newletter="keyh"
							if(lowertext(newletter)=="w")	newletter="wuah"
							if(lowertext(newletter)=="n")	newletter="nv"
							if(lowertext(newletter)=="h")	newletter="jau"
						switch(rand(1,17))
							if(1,3,5)	newletter="<small>[newletter]</small>"
							if(2,4,6,15)	newletter="<big>[newletter]</big>"
							if(7)	newletter="[uppertext(newletter)]"
							if(8)	newletter+="'"
							if(9,10)	newletter="[newletter]-ss"
							if(11,12)	newletter="<big>[newletter]</big>"
							if(13)	newletter="<i>[newletter]</i>"
							if(16)	newletter="<big>uhk'</big>"
							if(17)	newletter="-w"
						newphrase+="[newletter]";counter-=1
						if(prob(50))
							MM.ChangelingLanguage+=rand(1,5.5)
							if(MM.ChangelingLanguage>100)
								MM.ChangelingLanguage=100
						sleep(0.2)
					phrase=newphrase



				if(MM.ChangelingLanguage<69&&MM.ChangelingLanguage>=30)
					while(counter>=1)
						newletter="[copytext(phrase,(leng-counter)+1,(leng-counter)+2)]"
						if(rand(1,12)==12)
							if(lowertext(newletter)=="o")	newletter="io"
							if(lowertext(newletter)=="s")	newletter="x"
							if(lowertext(newletter)=="a")	newletter="h"
							if(lowertext(newletter)=="c")	newletter="hk"
							if(lowertext(newletter)=="d")	newletter="di"
							if(lowertext(newletter)=="g")	newletter="hej"
							if(lowertext(newletter)=="r")	newletter="uar"
							if(lowertext(newletter)=="q")	newletter="hkew"
							if(lowertext(newletter)=="w")	newletter="huaw"
							if(lowertext(newletter)=="n")	newletter="nhv"
							if(lowertext(newletter)=="h")	newletter="uaj"
						switch(rand(1,17))
							if(1,3,5)	newletter="<small>[newletter]</small>"
							if(2,4,6,15)	newletter="<big>[newletter]</big>"
							if(7)	newletter="[uppertext(newletter)]"
							if(8)	newletter+="'"
							if(9,10)	newletter="[newletter]-ss"
							if(11,12)	newletter="<big>[newletter]</big>"
							if(13)	newletter="<i>[newletter]</i>"
							if(16)	newletter="<big>uhk'</big>"
							if(17)	newletter="-w"
						newphrase+="[newletter]";counter-=1
						if(prob(50))
							MM.ChangelingLanguage+=rand(1,5.5)
							if(MM.ChangelingLanguage>100)
								MM.ChangelingLanguage=100
						sleep(0.2)
					phrase=newphrase



				if(MM.ChangelingLanguage<30&&MM.ChangelingLanguage>=15)
					while(counter>=1)
						newletter="[copytext(phrase,(leng-counter)+1,(leng-counter)+2)]"
						if(rand(1,14)==14)
							if(lowertext(newletter)=="o")	newletter="io"
							if(lowertext(newletter)=="s")	newletter="x"
							if(lowertext(newletter)=="a")	newletter="h"
							if(lowertext(newletter)=="c")	newletter="h"
							if(lowertext(newletter)=="d")	newletter="i"
							if(lowertext(newletter)=="g")	newletter="ej"
							if(lowertext(newletter)=="r")	newletter="ur"
							if(lowertext(newletter)=="q")	newletter="hew"
							if(lowertext(newletter)=="w")	newletter="uaw"
							if(lowertext(newletter)=="n")	newletter="hv"
							if(lowertext(newletter)=="h")	newletter="aj"
							if(lowertext(newletter)=="f")	newletter="hu"
							if(lowertext(newletter)=="t")	newletter="f"
							if(lowertext(newletter)=="m")	newletter="f"

						switch(rand(1,17))
							if(1,3,5)	newletter="<small>[newletter]</small>"
							if(2,4,6,15)	newletter="<big>[newletter]</big>"
							if(7)	newletter="[uppertext(newletter)]"
							if(8)	newletter+="'"
							if(9,10)	newletter="[newletter]-ss"
							if(11,12)	newletter="<big>[newletter]</big>"
							if(13)	newletter="<i>[newletter]</i>"
							if(16)	newletter="<big>uhk'</big>"
							if(17)	newletter="-w"
						newphrase+="[newletter]";counter-=1
						if(prob(50))
							MM.ChangelingLanguage+=rand(1,6.5)
							if(MM.ChangelingLanguage>100)
								MM.ChangelingLanguage=100
						//sleep(0.2)
					phrase=newphrase



				if(MM.ChangelingLanguage<15&&MM.ChangelingLanguage>=0)
					while(counter>=1)
						newletter="[copytext(phrase,(leng-counter)+1,(leng-counter)+2)]"
						if(rand(1,17)==17)
							if(lowertext(newletter)=="o")	newletter="aq"
							if(lowertext(newletter)=="s")	newletter="xz"
							if(lowertext(newletter)=="a")	newletter="hjc"
							if(lowertext(newletter)=="c")	newletter="q"
							if(lowertext(newletter)=="d")	newletter="c"
							if(lowertext(newletter)=="g")	newletter="ji"
							if(lowertext(newletter)=="r")	newletter="ura"
							if(lowertext(newletter)=="q")	newletter="hewk"
							if(lowertext(newletter)=="w")	newletter="ua"
							if(lowertext(newletter)=="n")	newletter="zv"
							if(lowertext(newletter)=="h")	newletter="auj"
							if(lowertext(newletter)=="f")	newletter="hs"
							if(lowertext(newletter)=="t")	newletter="fe"
							if(lowertext(newletter)=="x")	newletter="shk"
							if(lowertext(newletter)=="z")	newletter="yi"
							if(lowertext(newletter)=="y")	newletter="ihy"
						switch(rand(1,17))
							if(1,3,5)	newletter="<small>[newletter]</small>"
							if(2,4,6,15)	newletter="<big>[newletter]</big>"
							if(7)	newletter="[uppertext(newletter)]"
							if(8)	newletter+="'"
							if(9,10)	newletter="[newletter]-ss"
							if(11,12)	newletter="<big>[newletter]</big>"
							if(13)	newletter="<i>[newletter]</i>"
							if(16)	newletter="<big>uhk'</big>"
							if(17)	newletter="-w"
						newphrase+="[newletter]";counter-=1
						if(prob(50))
							MM.ChangelingLanguage+=rand(2,7.5)
							if(MM.ChangelingLanguage>100)
								MM.ChangelingLanguage=100
					//	sleep(0.2)
					phrase=newphrase


		if("Kai")
			for(var/mob/MM in view(M,15))
				if(MM.KaiLanguage==100)
					return phrase
				if(MM.KaiLanguage<99&&MM.KaiLanguage>=80)
					while(counter>=1)
						newletter="[copytext(phrase,(leng-counter)+1,(leng-counter)+2)]"
						if(rand(1,9)==9)
							if(lowertext(newletter)=="o")	newletter="u"
							if(lowertext(newletter)=="s")	newletter="ch"
							if(lowertext(newletter)=="a")	newletter="ah"
							if(lowertext(newletter)=="c")	newletter="k"
							if(lowertext(newletter)=="d")	newletter="b"
							if(lowertext(newletter)=="g")	newletter="je"
							if(lowertext(newletter)=="r")	newletter="ar"
							if(lowertext(newletter)=="q")	newletter="khu"
						switch(rand(1,17))
							if(1,3,5)	newletter="<small>[newletter]</small>"
							if(2,4,6,15)	newletter="<big>[newletter]</big>"
							if(7)	newletter="[uppertext(newletter)]"
							if(8)	newletter+="'"
							if(9,10)	newletter="[newletter]-ss"
							if(11,12)	newletter="<big>[newletter]</big>"
							if(13)	newletter="<i>[newletter]</i>"
							if(16)	newletter="<big>uhk'</big>"
							if(17)	newletter="-w"
						newphrase+="[newletter]";counter-=1
						if(prob(50))
							MM.KaiLanguage+=rand(1,3.5)
							if(MM.KaiLanguage>100)
								MM.KaiLanguage=100
					phrase=newphrase


				if(MM.KaiLanguage<80&&MM.KaiLanguage>=69)
					while(counter>=1)
						newletter="[copytext(phrase,(leng-counter)+1,(leng-counter)+2)]"
						if(rand(1,12)==12)
							if(lowertext(newletter)=="o")	newletter="yu"
							if(lowertext(newletter)=="s")	newletter="xh"
							if(lowertext(newletter)=="a")	newletter="ehh"
							if(lowertext(newletter)=="c")	newletter="k"
							if(lowertext(newletter)=="d")	newletter="b"
							if(lowertext(newletter)=="g")	newletter="xe"
							if(lowertext(newletter)=="r")	newletter="ar"
							if(lowertext(newletter)=="q")	newletter="keyh"
							if(lowertext(newletter)=="w")	newletter="wuah"
							if(lowertext(newletter)=="n")	newletter="nv"
							if(lowertext(newletter)=="h")	newletter="jau"
						switch(rand(1,17))
							if(1,3,5)	newletter="<small>[newletter]</small>"
							if(2,4,6,15)	newletter="<big>[newletter]</big>"
							if(7)	newletter="[uppertext(newletter)]"
							if(8)	newletter+="'"
							if(9,10)	newletter="[newletter]-ss"
							if(11,12)	newletter="<big>[newletter]</big>"
							if(13)	newletter="<i>[newletter]</i>"
							if(16)	newletter="<big>uhk'</big>"
							if(17)	newletter="-w"
						newphrase+="[newletter]";counter-=1
						if(prob(50))
							MM.KaiLanguage+=rand(1,4.5)
							if(MM.KaiLanguage>100)
								MM.KaiLanguage=100
					phrase=newphrase



				if(MM.KaiLanguage<69&&MM.KaiLanguage>=30)
					while(counter>=1)
						newletter="[copytext(phrase,(leng-counter)+1,(leng-counter)+2)]"
						if(rand(1,12)==12)
							if(lowertext(newletter)=="o")	newletter="io"
							if(lowertext(newletter)=="s")	newletter="x"
							if(lowertext(newletter)=="a")	newletter="h"
							if(lowertext(newletter)=="c")	newletter="hk"
							if(lowertext(newletter)=="d")	newletter="di"
							if(lowertext(newletter)=="g")	newletter="hej"
							if(lowertext(newletter)=="r")	newletter="uar"
							if(lowertext(newletter)=="q")	newletter="hkew"
							if(lowertext(newletter)=="w")	newletter="huaw"
							if(lowertext(newletter)=="n")	newletter="nhv"
							if(lowertext(newletter)=="h")	newletter="uaj"
						switch(rand(1,17))
							if(1,3,5)	newletter="<small>[newletter]</small>"
							if(2,4,6,15)	newletter="<big>[newletter]</big>"
							if(7)	newletter="[uppertext(newletter)]"
							if(8)	newletter+="'"
							if(9,10)	newletter="[newletter]-ss"
							if(11,12)	newletter="<big>[newletter]</big>"
							if(13)	newletter="<i>[newletter]</i>"
							if(16)	newletter="<big>uhk'</big>"
							if(17)	newletter="-w"
						newphrase+="[newletter]";counter-=1
						if(prob(50))
							MM.KaiLanguage+=rand(1,4.5)
							if(MM.KaiLanguage>100)
								MM.KaiLanguage=100
					phrase=newphrase



				if(MM.KaiLanguage<30&&MM.KaiLanguage>=15)
					while(counter>=1)
						newletter="[copytext(phrase,(leng-counter)+1,(leng-counter)+2)]"
						if(rand(1,14)==14)
							if(lowertext(newletter)=="o")	newletter="io"
							if(lowertext(newletter)=="s")	newletter="x"
							if(lowertext(newletter)=="a")	newletter="h"
							if(lowertext(newletter)=="c")	newletter="h"
							if(lowertext(newletter)=="d")	newletter="i"
							if(lowertext(newletter)=="g")	newletter="ej"
							if(lowertext(newletter)=="r")	newletter="ur"
							if(lowertext(newletter)=="q")	newletter="hew"
							if(lowertext(newletter)=="w")	newletter="uaw"
							if(lowertext(newletter)=="n")	newletter="hv"
							if(lowertext(newletter)=="h")	newletter="aj"
							if(lowertext(newletter)=="f")	newletter="hu"
							if(lowertext(newletter)=="t")	newletter="f"
							if(lowertext(newletter)=="m")	newletter="f"

						switch(rand(1,17))
							if(1,3,5)	newletter="<small>[newletter]</small>"
							if(2,4,6,15)	newletter="<big>[newletter]</big>"
							if(7)	newletter="[uppertext(newletter)]"
							if(8)	newletter+="'"
							if(9,10)	newletter="[newletter]-ss"
							if(11,12)	newletter="<big>[newletter]</big>"
							if(13)	newletter="<i>[newletter]</i>"
							if(16)	newletter="<big>uhk'</big>"
							if(17)	newletter="-w"
						newphrase+="[newletter]";counter-=1
						if(prob(50))
							MM.KaiLanguage+=rand(1,5.5)
							if(MM.KaiLanguage>100)
								MM.KaiLanguage=100
					phrase=newphrase



				if(MM.KaiLanguage<15&&MM.KaiLanguage>=0)
					while(counter>=1)
						newletter="[copytext(phrase,(leng-counter)+1,(leng-counter)+2)]"
						if(rand(1,17)==17)
							if(lowertext(newletter)=="o")	newletter="aq"
							if(lowertext(newletter)=="s")	newletter="xz"
							if(lowertext(newletter)=="a")	newletter="hjc"
							if(lowertext(newletter)=="c")	newletter="q"
							if(lowertext(newletter)=="d")	newletter="c"
							if(lowertext(newletter)=="g")	newletter="ji"
							if(lowertext(newletter)=="r")	newletter="ura"
							if(lowertext(newletter)=="q")	newletter="hewk"
							if(lowertext(newletter)=="w")	newletter="ua"
							if(lowertext(newletter)=="n")	newletter="zv"
							if(lowertext(newletter)=="h")	newletter="auj"
							if(lowertext(newletter)=="f")	newletter="hs"
							if(lowertext(newletter)=="t")	newletter="fe"
							if(lowertext(newletter)=="x")	newletter="shk"
							if(lowertext(newletter)=="z")	newletter="yi"
							if(lowertext(newletter)=="y")	newletter="ihy"
						switch(rand(1,17))
							if(1,3,5)	newletter="<small>[newletter]</small>"
							if(2,4,6,15)	newletter="<big>[newletter]</big>"
							if(7)	newletter="[uppertext(newletter)]"
							if(8)	newletter+="'"
							if(9,10)	newletter="[newletter]-ss"
							if(11,12)	newletter="<big>[newletter]</big>"
							if(13)	newletter="<i>[newletter]</i>"
							if(16)	newletter="<big>uhk'</big>"
							if(17)	newletter="-w"
						newphrase+="[newletter]";counter-=1
						if(prob(50))
							MM.KaiLanguage+=rand(1,6.5)
							if(MM.KaiLanguage>100)
								MM.KaiLanguage=100
					phrase=newphrase



		if("Demon")
			for(var/mob/MM in view(M,15))
				if(MM.DemonLanguage==100)
					return phrase
				if(MM.DemonLanguage<99&&MM.DemonLanguage>=80)
					while(counter>=1)
						newletter="[copytext(phrase,(leng-counter)+1,(leng-counter)+2)]"
						if(rand(1,9)==9)
							if(lowertext(newletter)=="o")	newletter="u"
							if(lowertext(newletter)=="s")	newletter="ch"
							if(lowertext(newletter)=="a")	newletter="ah"
							if(lowertext(newletter)=="c")	newletter="k"
							if(lowertext(newletter)=="d")	newletter="b"
							if(lowertext(newletter)=="g")	newletter="je"
							if(lowertext(newletter)=="r")	newletter="ar"
							if(lowertext(newletter)=="q")	newletter="khu"
						switch(rand(1,17))
							if(1,3,5)	newletter="<small>[newletter]</small>"
							if(2,4,6,15)	newletter="<big>[newletter]</big>"
							if(7)	newletter="[uppertext(newletter)]"
							if(8)	newletter+="'"
							if(9,10)	newletter="[newletter]-ss"
							if(11,12)	newletter="<big>[newletter]</big>"
							if(13)	newletter="<i>[newletter]</i>"
							if(16)	newletter="<big>uhk'</big>"
							if(17)	newletter="-w"
						newphrase+="[newletter]";counter-=1
						if(prob(50))
							MM.DemonLanguage+=rand(1,3.5)
							if(MM.DemonLanguage>100)
								MM.DemonLanguage=100
					phrase=newphrase


				if(MM.DemonLanguage<80&&MM.DemonLanguage>=69)
					while(counter>=1)
						newletter="[copytext(phrase,(leng-counter)+1,(leng-counter)+2)]"
						if(rand(1,12)==12)
							if(lowertext(newletter)=="o")	newletter="yu"
							if(lowertext(newletter)=="s")	newletter="xh"
							if(lowertext(newletter)=="a")	newletter="ehh"
							if(lowertext(newletter)=="c")	newletter="k"
							if(lowertext(newletter)=="d")	newletter="b"
							if(lowertext(newletter)=="g")	newletter="xe"
							if(lowertext(newletter)=="r")	newletter="ar"
							if(lowertext(newletter)=="q")	newletter="keyh"
							if(lowertext(newletter)=="w")	newletter="wuah"
							if(lowertext(newletter)=="n")	newletter="nv"
							if(lowertext(newletter)=="h")	newletter="jau"
						switch(rand(1,17))
							if(1,3,5)	newletter="<small>[newletter]</small>"
							if(2,4,6,15)	newletter="<big>[newletter]</big>"
							if(7)	newletter="[uppertext(newletter)]"
							if(8)	newletter+="'"
							if(9,10)	newletter="[newletter]-ss"
							if(11,12)	newletter="<big>[newletter]</big>"
							if(13)	newletter="<i>[newletter]</i>"
							if(16)	newletter="<big>uhk'</big>"
							if(17)	newletter="-w"
						newphrase+="[newletter]";counter-=1
						if(prob(50))
							MM.DemonLanguage+=rand(1,4.5)
							if(MM.DemonLanguage>100)
								MM.DemonLanguage=100
					phrase=newphrase



				if(MM.DemonLanguage<69&&MM.DemonLanguage>=30)
					while(counter>=1)
						newletter="[copytext(phrase,(leng-counter)+1,(leng-counter)+2)]"
						if(rand(1,12)==12)
							if(lowertext(newletter)=="o")	newletter="io"
							if(lowertext(newletter)=="s")	newletter="x"
							if(lowertext(newletter)=="a")	newletter="h"
							if(lowertext(newletter)=="c")	newletter="hk"
							if(lowertext(newletter)=="d")	newletter="di"
							if(lowertext(newletter)=="g")	newletter="hej"
							if(lowertext(newletter)=="r")	newletter="uar"
							if(lowertext(newletter)=="q")	newletter="hkew"
							if(lowertext(newletter)=="w")	newletter="huaw"
							if(lowertext(newletter)=="n")	newletter="nhv"
							if(lowertext(newletter)=="h")	newletter="uaj"
						switch(rand(1,17))
							if(1,3,5)	newletter="<small>[newletter]</small>"
							if(2,4,6,15)	newletter="<big>[newletter]</big>"
							if(7)	newletter="[uppertext(newletter)]"
							if(8)	newletter+="'"
							if(9,10)	newletter="[newletter]-ss"
							if(11,12)	newletter="<big>[newletter]</big>"
							if(13)	newletter="<i>[newletter]</i>"
							if(16)	newletter="<big>uhk'</big>"
							if(17)	newletter="-w"
						newphrase+="[newletter]";counter-=1
						if(prob(50))
							MM.DemonLanguage+=rand(1,4.5)
							if(MM.DemonLanguage>100)
								MM.DemonLanguage=100
					phrase=newphrase



				if(MM.DemonLanguage<30&&MM.DemonLanguage>=15)
					while(counter>=1)
						newletter="[copytext(phrase,(leng-counter)+1,(leng-counter)+2)]"
						if(rand(1,14)==14)
							if(lowertext(newletter)=="o")	newletter="io"
							if(lowertext(newletter)=="s")	newletter="x"
							if(lowertext(newletter)=="a")	newletter="h"
							if(lowertext(newletter)=="c")	newletter="h"
							if(lowertext(newletter)=="d")	newletter="i"
							if(lowertext(newletter)=="g")	newletter="ej"
							if(lowertext(newletter)=="r")	newletter="ur"
							if(lowertext(newletter)=="q")	newletter="hew"
							if(lowertext(newletter)=="w")	newletter="uaw"
							if(lowertext(newletter)=="n")	newletter="hv"
							if(lowertext(newletter)=="h")	newletter="aj"
							if(lowertext(newletter)=="f")	newletter="hu"
							if(lowertext(newletter)=="t")	newletter="f"
							if(lowertext(newletter)=="m")	newletter="f"

						switch(rand(1,17))
							if(1,3,5)	newletter="<small>[newletter]</small>"
							if(2,4,6,15)	newletter="<big>[newletter]</big>"
							if(7)	newletter="[uppertext(newletter)]"
							if(8)	newletter+="'"
							if(9,10)	newletter="[newletter]-ss"
							if(11,12)	newletter="<big>[newletter]</big>"
							if(13)	newletter="<i>[newletter]</i>"
							if(16)	newletter="<big>uhk'</big>"
							if(17)	newletter="-w"
						newphrase+="[newletter]";counter-=1
						if(prob(50))
							MM.DemonLanguage+=rand(1,5.5)
							if(MM.DemonLanguage>100)
								MM.DemonLanguage=100
					phrase=newphrase



				if(MM.DemonLanguage<15&&MM.DemonLanguage>=0)
					while(counter>=1)
						newletter="[copytext(phrase,(leng-counter)+1,(leng-counter)+2)]"
						if(rand(1,17)==17)
							if(lowertext(newletter)=="o")	newletter="aq"
							if(lowertext(newletter)=="s")	newletter="xz"
							if(lowertext(newletter)=="a")	newletter="hjc"
							if(lowertext(newletter)=="c")	newletter="q"
							if(lowertext(newletter)=="d")	newletter="c"
							if(lowertext(newletter)=="g")	newletter="ji"
							if(lowertext(newletter)=="r")	newletter="ura"
							if(lowertext(newletter)=="q")	newletter="hewk"
							if(lowertext(newletter)=="w")	newletter="ua"
							if(lowertext(newletter)=="n")	newletter="zv"
							if(lowertext(newletter)=="h")	newletter="auj"
							if(lowertext(newletter)=="f")	newletter="hs"
							if(lowertext(newletter)=="t")	newletter="fe"
							if(lowertext(newletter)=="x")	newletter="shk"
							if(lowertext(newletter)=="z")	newletter="yi"
							if(lowertext(newletter)=="y")	newletter="ihy"
						switch(rand(1,17))
							if(1,3,5)	newletter="<small>[newletter]</small>"
							if(2,4,6,15)	newletter="<big>[newletter]</big>"
							if(7)	newletter="[uppertext(newletter)]"
							if(8)	newletter+="'"
							if(9,10)	newletter="[newletter]-ss"
							if(11,12)	newletter="<big>[newletter]</big>"
							if(13)	newletter="<i>[newletter]</i>"
							if(16)	newletter="<big>uhk'</big>"
							if(17)	newletter="-w"
						newphrase+="[newletter]";counter-=1
						if(prob(50))
							MM.DemonLanguage+=rand(1,6.5)
							if(MM.DemonLanguage>100)
								MM.DemonLanguage=100
					phrase=newphrase



		if("Alien")
			for(var/mob/MM in view(M,15))
				if(MM.AlienLanguage==100)
					return phrase
				if(MM.AlienLanguage<99&&MM.AlienLanguage>=80)
					while(counter>=1)
						newletter="[copytext(phrase,(leng-counter)+1,(leng-counter)+2)]"
						if(rand(1,9)==9)
							if(lowertext(newletter)=="o")	newletter="u"
							if(lowertext(newletter)=="s")	newletter="ch"
							if(lowertext(newletter)=="a")	newletter="ah"
							if(lowertext(newletter)=="c")	newletter="k"
							if(lowertext(newletter)=="d")	newletter="b"
							if(lowertext(newletter)=="g")	newletter="je"
							if(lowertext(newletter)=="r")	newletter="ar"
							if(lowertext(newletter)=="q")	newletter="khu"
						switch(rand(1,17))
							if(1,3,5)	newletter="<small>[newletter]</small>"
							if(2,4,6,15)	newletter="<big>[newletter]</big>"
							if(7)	newletter="[uppertext(newletter)]"
							if(8)	newletter+="'"
							if(9,10)	newletter="[newletter]-ss"
							if(11,12)	newletter="<big>[newletter]</big>"
							if(13)	newletter="<i>[newletter]</i>"
							if(16)	newletter="<big>uhk'</big>"
							if(17)	newletter="-w"
						newphrase+="[newletter]";counter-=1
						if(prob(50))
							MM.AlienLanguage+=rand(2,4.5)
							if(MM.AlienLanguage>100)
								MM.AlienLanguage=100
					phrase=newphrase


				if(MM.AlienLanguage<80&&MM.AlienLanguage>=69)
					while(counter>=1)
						newletter="[copytext(phrase,(leng-counter)+1,(leng-counter)+2)]"
						if(rand(1,12)==12)
							if(lowertext(newletter)=="o")	newletter="yu"
							if(lowertext(newletter)=="s")	newletter="xh"
							if(lowertext(newletter)=="a")	newletter="ehh"
							if(lowertext(newletter)=="c")	newletter="k"
							if(lowertext(newletter)=="d")	newletter="b"
							if(lowertext(newletter)=="g")	newletter="xe"
							if(lowertext(newletter)=="r")	newletter="ar"
							if(lowertext(newletter)=="q")	newletter="keyh"
							if(lowertext(newletter)=="w")	newletter="wuah"
							if(lowertext(newletter)=="n")	newletter="nv"
							if(lowertext(newletter)=="h")	newletter="jau"
						switch(rand(1,17))
							if(1,3,5)	newletter="<small>[newletter]</small>"
							if(2,4,6,15)	newletter="<big>[newletter]</big>"
							if(7)	newletter="[uppertext(newletter)]"
							if(8)	newletter+="'"
							if(9,10)	newletter="[newletter]-ss"
							if(11,12)	newletter="<big>[newletter]</big>"
							if(13)	newletter="<i>[newletter]</i>"
							if(16)	newletter="<big>uhk'</big>"
							if(17)	newletter="-w"
						newphrase+="[newletter]";counter-=1
						if(prob(50))
							MM.AlienLanguage+=rand(1,5.5)
							if(MM.AlienLanguage>100)
								MM.AlienLanguage=100
					phrase=newphrase



				if(MM.AlienLanguage<69&&MM.AlienLanguage>=30)
					while(counter>=1)
						newletter="[copytext(phrase,(leng-counter)+1,(leng-counter)+2)]"
						if(rand(1,12)==12)
							if(lowertext(newletter)=="o")	newletter="io"
							if(lowertext(newletter)=="s")	newletter="x"
							if(lowertext(newletter)=="a")	newletter="h"
							if(lowertext(newletter)=="c")	newletter="hk"
							if(lowertext(newletter)=="d")	newletter="di"
							if(lowertext(newletter)=="g")	newletter="hej"
							if(lowertext(newletter)=="r")	newletter="uar"
							if(lowertext(newletter)=="q")	newletter="hkew"
							if(lowertext(newletter)=="w")	newletter="huaw"
							if(lowertext(newletter)=="n")	newletter="nhv"
							if(lowertext(newletter)=="h")	newletter="uaj"
						switch(rand(1,17))
							if(1,3,5)	newletter="<small>[newletter]</small>"
							if(2,4,6,15)	newletter="<big>[newletter]</big>"
							if(7)	newletter="[uppertext(newletter)]"
							if(8)	newletter+="'"
							if(9,10)	newletter="[newletter]-ss"
							if(11,12)	newletter="<big>[newletter]</big>"
							if(13)	newletter="<i>[newletter]</i>"
							if(16)	newletter="<big>uhk'</big>"
							if(17)	newletter="-w"
						newphrase+="[newletter]";counter-=1
						if(prob(50))
							MM.AlienLanguage+=rand(1,5.5)
							if(MM.AlienLanguage>100)
								MM.AlienLanguage=100
					phrase=newphrase



				if(MM.AlienLanguage<30&&MM.AlienLanguage>=15)
					while(counter>=1)
						newletter="[copytext(phrase,(leng-counter)+1,(leng-counter)+2)]"
						if(rand(1,14)==14)
							if(lowertext(newletter)=="o")	newletter="io"
							if(lowertext(newletter)=="s")	newletter="x"
							if(lowertext(newletter)=="a")	newletter="h"
							if(lowertext(newletter)=="c")	newletter="h"
							if(lowertext(newletter)=="d")	newletter="i"
							if(lowertext(newletter)=="g")	newletter="ej"
							if(lowertext(newletter)=="r")	newletter="ur"
							if(lowertext(newletter)=="q")	newletter="hew"
							if(lowertext(newletter)=="w")	newletter="uaw"
							if(lowertext(newletter)=="n")	newletter="hv"
							if(lowertext(newletter)=="h")	newletter="aj"
							if(lowertext(newletter)=="f")	newletter="hu"
							if(lowertext(newletter)=="t")	newletter="f"
							if(lowertext(newletter)=="m")	newletter="f"

						switch(rand(1,17))
							if(1,3,5)	newletter="<small>[newletter]</small>"
							if(2,4,6,15)	newletter="<big>[newletter]</big>"
							if(7)	newletter="[uppertext(newletter)]"
							if(8)	newletter+="'"
							if(9,10)	newletter="[newletter]-ss"
							if(11,12)	newletter="<big>[newletter]</big>"
							if(13)	newletter="<i>[newletter]</i>"
							if(16)	newletter="<big>uhk'</big>"
							if(17)	newletter="-w"
						newphrase+="[newletter]";counter-=1
						if(prob(50))
							MM.AlienLanguage+=rand(1,6.5)
							if(MM.AlienLanguage>100)
								MM.AlienLanguage=100
					phrase=newphrase



				if(MM.AlienLanguage<15&&MM.AlienLanguage>=0)
					while(counter>=1)
						newletter="[copytext(phrase,(leng-counter)+1,(leng-counter)+2)]"
						if(rand(1,17)==17)
							if(lowertext(newletter)=="o")	newletter="aq"
							if(lowertext(newletter)=="s")	newletter="xz"
							if(lowertext(newletter)=="a")	newletter="hjc"
							if(lowertext(newletter)=="c")	newletter="q"
							if(lowertext(newletter)=="d")	newletter="c"
							if(lowertext(newletter)=="g")	newletter="ji"
							if(lowertext(newletter)=="r")	newletter="ura"
							if(lowertext(newletter)=="q")	newletter="hewk"
							if(lowertext(newletter)=="w")	newletter="ua"
							if(lowertext(newletter)=="n")	newletter="zv"
							if(lowertext(newletter)=="h")	newletter="auj"
							if(lowertext(newletter)=="f")	newletter="hs"
							if(lowertext(newletter)=="t")	newletter="fe"
							if(lowertext(newletter)=="x")	newletter="shk"
							if(lowertext(newletter)=="z")	newletter="yi"
							if(lowertext(newletter)=="y")	newletter="ihy"
						switch(rand(1,17))
							if(1,3,5)	newletter="<small>[newletter]</small>"
							if(2,4,6,15)	newletter="<big>[newletter]</big>"
							if(7)	newletter="[uppertext(newletter)]"
							if(8)	newletter+="'"
							if(9,10)	newletter="[newletter]-ss"
							if(11,12)	newletter="<big>[newletter]</big>"
							if(13)	newletter="<i>[newletter]</i>"
							if(16)	newletter="<big>uhk'</big>"
							if(17)	newletter="-w"
						newphrase+="[newletter]";counter-=1
						if(prob(50))
							MM.AlienLanguage+=rand(2,7.5)
							if(MM.AlienLanguage>100)
								MM.AlienLanguage=100
					phrase=newphrase


		if("Namekian")
			for(var/mob/MM in view(M,15))
				if(MM.NamekianLanguage==100)
					return phrase
				if(MM.NamekianLanguage<99&&MM.NamekianLanguage>=80)
					while(counter>=1)
						newletter="[copytext(phrase,(leng-counter)+1,(leng-counter)+2)]"
						if(rand(1,9)==9)
							if(lowertext(newletter)=="o")	newletter="u"
							if(lowertext(newletter)=="s")	newletter="ch"
							if(lowertext(newletter)=="a")	newletter="ah"
							if(lowertext(newletter)=="c")	newletter="k"
							if(lowertext(newletter)=="d")	newletter="b"
							if(lowertext(newletter)=="g")	newletter="je"
							if(lowertext(newletter)=="r")	newletter="ar"
							if(lowertext(newletter)=="q")	newletter="khu"
						switch(rand(1,17))
							if(1,3,5)	newletter="<small>[newletter]</small>"
							if(2,4,6,15)	newletter="<big>[newletter]</big>"
							if(7)	newletter="[uppertext(newletter)]"
							if(8)	newletter+="'"
							if(9,10)	newletter="[newletter]-ss"
							if(11,12)	newletter="<big>[newletter]</big>"
							if(13)	newletter="<i>[newletter]</i>"
							if(16)	newletter="<big>uhk'</big>"
							if(17)	newletter="-w"
						newphrase+="[newletter]";counter-=1
						if(prob(50))
							MM.NamekianLanguage+=rand(2,4.5)
							if(MM.NamekianLanguage>100)
								MM.NamekianLanguage=100
					phrase=newphrase


				if(MM.NamekianLanguage<80&&MM.NamekianLanguage>=69)
					while(counter>=1)
						newletter="[copytext(phrase,(leng-counter)+1,(leng-counter)+2)]"
						if(rand(1,12)==12)
							if(lowertext(newletter)=="o")	newletter="yu"
							if(lowertext(newletter)=="s")	newletter="xh"
							if(lowertext(newletter)=="a")	newletter="ehh"
							if(lowertext(newletter)=="c")	newletter="k"
							if(lowertext(newletter)=="d")	newletter="b"
							if(lowertext(newletter)=="g")	newletter="xe"
							if(lowertext(newletter)=="r")	newletter="ar"
							if(lowertext(newletter)=="q")	newletter="keyh"
							if(lowertext(newletter)=="w")	newletter="wuah"
							if(lowertext(newletter)=="n")	newletter="nv"
							if(lowertext(newletter)=="h")	newletter="jau"
						switch(rand(1,17))
							if(1,3,5)	newletter="<small>[newletter]</small>"
							if(2,4,6,15)	newletter="<big>[newletter]</big>"
							if(7)	newletter="[uppertext(newletter)]"
							if(8)	newletter+="'"
							if(9,10)	newletter="[newletter]-ss"
							if(11,12)	newletter="<big>[newletter]</big>"
							if(13)	newletter="<i>[newletter]</i>"
							if(16)	newletter="<big>uhk'</big>"
							if(17)	newletter="-w"
						newphrase+="[newletter]";counter-=1
						if(prob(50))
							MM.NamekianLanguage+=rand(1,5.5)
							if(MM.NamekianLanguage>100)
								MM.NamekianLanguage=100
					phrase=newphrase



				if(MM.NamekianLanguage<69&&MM.NamekianLanguage>=30)
					while(counter>=1)
						newletter="[copytext(phrase,(leng-counter)+1,(leng-counter)+2)]"
						if(rand(1,12)==12)
							if(lowertext(newletter)=="o")	newletter="io"
							if(lowertext(newletter)=="s")	newletter="x"
							if(lowertext(newletter)=="a")	newletter="h"
							if(lowertext(newletter)=="c")	newletter="hk"
							if(lowertext(newletter)=="d")	newletter="di"
							if(lowertext(newletter)=="g")	newletter="hej"
							if(lowertext(newletter)=="r")	newletter="uar"
							if(lowertext(newletter)=="q")	newletter="hkew"
							if(lowertext(newletter)=="w")	newletter="huaw"
							if(lowertext(newletter)=="n")	newletter="nhv"
							if(lowertext(newletter)=="h")	newletter="uaj"
						switch(rand(1,17))
							if(1,3,5)	newletter="<small>[newletter]</small>"
							if(2,4,6,15)	newletter="<big>[newletter]</big>"
							if(7)	newletter="[uppertext(newletter)]"
							if(8)	newletter+="'"
							if(9,10)	newletter="[newletter]-ss"
							if(11,12)	newletter="<big>[newletter]</big>"
							if(13)	newletter="<i>[newletter]</i>"
							if(16)	newletter="<big>uhk'</big>"
							if(17)	newletter="-w"
						newphrase+="[newletter]";counter-=1
						if(prob(50))
							MM.NamekianLanguage+=rand(1,6.5)
							if(MM.NamekianLanguage>100)
								MM.NamekianLanguage=100
					phrase=newphrase



				if(MM.NamekianLanguage<30&&MM.NamekianLanguage>=15)
					while(counter>=1)
						newletter="[copytext(phrase,(leng-counter)+1,(leng-counter)+2)]"
						if(rand(1,14)==14)
							if(lowertext(newletter)=="o")	newletter="io"
							if(lowertext(newletter)=="s")	newletter="x"
							if(lowertext(newletter)=="a")	newletter="h"
							if(lowertext(newletter)=="c")	newletter="h"
							if(lowertext(newletter)=="d")	newletter="i"
							if(lowertext(newletter)=="g")	newletter="ej"
							if(lowertext(newletter)=="r")	newletter="ur"
							if(lowertext(newletter)=="q")	newletter="hew"
							if(lowertext(newletter)=="w")	newletter="uaw"
							if(lowertext(newletter)=="n")	newletter="hv"
							if(lowertext(newletter)=="h")	newletter="aj"
							if(lowertext(newletter)=="f")	newletter="hu"
							if(lowertext(newletter)=="t")	newletter="f"
							if(lowertext(newletter)=="m")	newletter="f"

						switch(rand(1,17))
							if(1,3,5)	newletter="<small>[newletter]</small>"
							if(2,4,6,15)	newletter="<big>[newletter]</big>"
							if(7)	newletter="[uppertext(newletter)]"
							if(8)	newletter+="'"
							if(9,10)	newletter="[newletter]-ss"
							if(11,12)	newletter="<big>[newletter]</big>"
							if(13)	newletter="<i>[newletter]</i>"
							if(16)	newletter="<big>uhk'</big>"
							if(17)	newletter="-w"
						newphrase+="[newletter]";counter-=1
						if(prob(50))
							MM.NamekianLanguage+=rand(1,6.5)
							if(MM.NamekianLanguage>100)
								MM.NamekianLanguage=100
					phrase=newphrase



				if(MM.NamekianLanguage<15&&MM.NamekianLanguage>=0)
					while(counter>=1)
						newletter="[copytext(phrase,(leng-counter)+1,(leng-counter)+2)]"
						if(rand(1,17)==17)
							if(lowertext(newletter)=="o")	newletter="aq"
							if(lowertext(newletter)=="s")	newletter="xz"
							if(lowertext(newletter)=="a")	newletter="hjc"
							if(lowertext(newletter)=="c")	newletter="q"
							if(lowertext(newletter)=="d")	newletter="c"
							if(lowertext(newletter)=="g")	newletter="ji"
							if(lowertext(newletter)=="r")	newletter="ura"
							if(lowertext(newletter)=="q")	newletter="hewk"
							if(lowertext(newletter)=="w")	newletter="ua"
							if(lowertext(newletter)=="n")	newletter="zv"
							if(lowertext(newletter)=="h")	newletter="auj"
							if(lowertext(newletter)=="f")	newletter="hs"
							if(lowertext(newletter)=="t")	newletter="fe"
							if(lowertext(newletter)=="x")	newletter="shk"
							if(lowertext(newletter)=="z")	newletter="yi"
							if(lowertext(newletter)=="y")	newletter="ihy"
						switch(rand(1,17))
							if(1,3,5)	newletter="<small>[newletter]</small>"
							if(2,4,6,15)	newletter="<big>[newletter]</big>"
							if(7)	newletter="[uppertext(newletter)]"
							if(8)	newletter+="'"
							if(9,10)	newletter="[newletter]-ss"
							if(11,12)	newletter="<big>[newletter]</big>"
							if(13)	newletter="<i>[newletter]</i>"
							if(16)	newletter="<big>uhk'</big>"
							if(17)	newletter="-w"
						newphrase+="[newletter]";counter-=1
						if(prob(50))
							MM.NamekianLanguage+=rand(2,7.5)
							if(MM.NamekianLanguage>100)
								MM.NamekianLanguage=100
					phrase=newphrase


		if("Common")
			for(var/mob/MM in view(M,15))
				if(MM.CommonLanguage==100)
					return phrase
				if(MM.CommonLanguage<99&&MM.CommonLanguage>=80)
					while(counter>=1)
						newletter="[copytext(phrase,(leng-counter)+1,(leng-counter)+2)]"
						if(rand(1,9)==9)
							if(lowertext(newletter)=="o")	newletter="u"
							if(lowertext(newletter)=="s")	newletter="ch"
							if(lowertext(newletter)=="a")	newletter="ah"
							if(lowertext(newletter)=="c")	newletter="k"
							if(lowertext(newletter)=="d")	newletter="b"
							if(lowertext(newletter)=="g")	newletter="je"
							if(lowertext(newletter)=="r")	newletter="ar"
							if(lowertext(newletter)=="q")	newletter="khu"
						switch(rand(1,17))
							if(1,3,5)	newletter="<small>[newletter]</small>"
							if(2,4,6,15)	newletter="<big>[newletter]</big>"
							if(7)	newletter="[uppertext(newletter)]"
							if(8)	newletter+="'"
							if(9,10)	newletter="[newletter]-ss"
							if(11,12)	newletter="<big>[newletter]</big>"
							if(13)	newletter="<i>[newletter]</i>"
							if(16)	newletter="<big>uhk'</big>"
							if(17)	newletter="-w"
						newphrase+="[newletter]";counter-=1
						if(prob(50))
							MM.CommonLanguage+=rand(2,4.5)
							if(MM.CommonLanguage>100)
								MM.CommonLanguage=100
						//sleep(0.2)
					phrase=newphrase


				if(MM.CommonLanguage<80&&MM.CommonLanguage>=69)
					while(counter>=1)
						newletter="[copytext(phrase,(leng-counter)+1,(leng-counter)+2)]"
						if(rand(1,12)==12)
							if(lowertext(newletter)=="o")	newletter="yu"
							if(lowertext(newletter)=="s")	newletter="xh"
							if(lowertext(newletter)=="a")	newletter="ehh"
							if(lowertext(newletter)=="c")	newletter="k"
							if(lowertext(newletter)=="d")	newletter="b"
							if(lowertext(newletter)=="g")	newletter="xe"
							if(lowertext(newletter)=="r")	newletter="ar"
							if(lowertext(newletter)=="q")	newletter="keyh"
							if(lowertext(newletter)=="w")	newletter="wuah"
							if(lowertext(newletter)=="n")	newletter="nv"
							if(lowertext(newletter)=="h")	newletter="jau"
						switch(rand(1,17))
							if(1,3,5)	newletter="<small>[newletter]</small>"
							if(2,4,6,15)	newletter="<big>[newletter]</big>"
							if(7)	newletter="[uppertext(newletter)]"
							if(8)	newletter+="'"
							if(9,10)	newletter="[newletter]-ss"
							if(11,12)	newletter="<big>[newletter]</big>"
							if(13)	newletter="<i>[newletter]</i>"
							if(16)	newletter="<big>uhk'</big>"
							if(17)	newletter="-w"
						newphrase+="[newletter]";counter-=1
						if(prob(50))
							MM.CommonLanguage+=rand(1,5.5)
							if(MM.CommonLanguage>100)
								MM.CommonLanguage=100
						//sleep(0.2)
					phrase=newphrase



				if(MM.CommonLanguage<69&&MM.CommonLanguage>=30)
					while(counter>=1)
						newletter="[copytext(phrase,(leng-counter)+1,(leng-counter)+2)]"
						if(rand(1,12)==12)
							if(lowertext(newletter)=="o")	newletter="io"
							if(lowertext(newletter)=="s")	newletter="x"
							if(lowertext(newletter)=="a")	newletter="h"
							if(lowertext(newletter)=="c")	newletter="hk"
							if(lowertext(newletter)=="d")	newletter="di"
							if(lowertext(newletter)=="g")	newletter="hej"
							if(lowertext(newletter)=="r")	newletter="uar"
							if(lowertext(newletter)=="q")	newletter="hkew"
							if(lowertext(newletter)=="w")	newletter="huaw"
							if(lowertext(newletter)=="n")	newletter="nhv"
							if(lowertext(newletter)=="h")	newletter="uaj"
						switch(rand(1,17))
							if(1,3,5)	newletter="<small>[newletter]</small>"
							if(2,4,6,15)	newletter="<big>[newletter]</big>"
							if(7)	newletter="[uppertext(newletter)]"
							if(8)	newletter+="'"
							if(9,10)	newletter="[newletter]-ss"
							if(11,12)	newletter="<big>[newletter]</big>"
							if(13)	newletter="<i>[newletter]</i>"
							if(16)	newletter="<big>uhk'</big>"
							if(17)	newletter="-w"
						newphrase+="[newletter]";counter-=1
						if(prob(50))
							MM.CommonLanguage+=rand(1,5.5)
							if(MM.CommonLanguage>100)
								MM.CommonLanguage=100
						//sleep(0.2)
					phrase=newphrase



				if(MM.CommonLanguage<30&&MM.CommonLanguage>=15)
					while(counter>=1)
						newletter="[copytext(phrase,(leng-counter)+1,(leng-counter)+2)]"
						if(rand(1,14)==14)
							if(lowertext(newletter)=="o")	newletter="io"
							if(lowertext(newletter)=="s")	newletter="x"
							if(lowertext(newletter)=="a")	newletter="h"
							if(lowertext(newletter)=="c")	newletter="h"
							if(lowertext(newletter)=="d")	newletter="i"
							if(lowertext(newletter)=="g")	newletter="ej"
							if(lowertext(newletter)=="r")	newletter="ur"
							if(lowertext(newletter)=="q")	newletter="hew"
							if(lowertext(newletter)=="w")	newletter="uaw"
							if(lowertext(newletter)=="n")	newletter="hv"
							if(lowertext(newletter)=="h")	newletter="aj"
							if(lowertext(newletter)=="f")	newletter="hu"
							if(lowertext(newletter)=="t")	newletter="f"
							if(lowertext(newletter)=="m")	newletter="f"

						switch(rand(1,17))
							if(1,3,5)	newletter="<small>[newletter]</small>"
							if(2,4,6,15)	newletter="<big>[newletter]</big>"
							if(7)	newletter="[uppertext(newletter)]"
							if(8)	newletter+="'"
							if(9,10)	newletter="[newletter]-ss"
							if(11,12)	newletter="<big>[newletter]</big>"
							if(13)	newletter="<i>[newletter]</i>"
							if(16)	newletter="<big>uhk'</big>"
							if(17)	newletter="-w"
						newphrase+="[newletter]";counter-=1
						if(prob(50))
							MM.CommonLanguage+=rand(1,6.5)
							if(MM.CommonLanguage>100)
								MM.CommonLanguage=100
						//sleep(0.2)
					phrase=newphrase



				if(MM.CommonLanguage<15&&MM.CommonLanguage>=0)
					while(counter>=1)
						newletter="[copytext(phrase,(leng-counter)+1,(leng-counter)+2)]"
						if(rand(1,17)==17)
							if(lowertext(newletter)=="o")	newletter="aq"
							if(lowertext(newletter)=="s")	newletter="xz"
							if(lowertext(newletter)=="a")	newletter="hjc"
							if(lowertext(newletter)=="c")	newletter="q"
							if(lowertext(newletter)=="d")	newletter="c"
							if(lowertext(newletter)=="g")	newletter="ji"
							if(lowertext(newletter)=="r")	newletter="ura"
							if(lowertext(newletter)=="q")	newletter="hewk"
							if(lowertext(newletter)=="w")	newletter="ua"
							if(lowertext(newletter)=="n")	newletter="zv"
							if(lowertext(newletter)=="h")	newletter="auj"
							if(lowertext(newletter)=="f")	newletter="hs"
							if(lowertext(newletter)=="t")	newletter="fe"
							if(lowertext(newletter)=="x")	newletter="shk"
							if(lowertext(newletter)=="z")	newletter="yi"
							if(lowertext(newletter)=="y")	newletter="ihy"
						switch(rand(1,17))
							if(1,3,5)	newletter="<small>[newletter]</small>"
							if(2,4,6,15)	newletter="<big>[newletter]</big>"
							if(7)	newletter="[uppertext(newletter)]"
							if(8)	newletter+="'"
							if(9,10)	newletter="[newletter]-ss"
							if(11,12)	newletter="<big>[newletter]</big>"
							if(13)	newletter="<i>[newletter]</i>"
							if(16)	newletter="<big>uhk'</big>"
							if(17)	newletter="-w"
						newphrase+="[newletter]";counter-=1
						if(prob(50))
							MM.CommonLanguage+=rand(2,7.5)
							if(MM.CommonLanguage>100)
								MM.CommonLanguage=100
						//sleep(0.2)
					phrase=newphrase

	return phrase	//This will alter the value of the message sent




mob/var/Language/lan
mob/var/TeachLangCD=-1

Language
	parent_type=/obj
	var
		Mastery=1
		LearnType

		//Teach=1
		Difficulty=1
		ID=0
	Saiyan
		Difficulty=1
	English
		Difficulty=1.5
	Namekian
		Difficulty=3
	Demon
		Difficulty=6
	Tuffle
		Difficulty=2
	Old_Tongue
		Difficulty=15
	Kai
		Difficulty=6
	Changeling
		Difficulty=3
	Alien
		Difficulty=2
	Heran
		Difficulty=2
	Kanassan
		Difficulty=3
	Common
		Difficulty=1
	Machine
		Difficulty=100
	CustomLanguage
		Difficulty=10
	Newborn
		Difficulty=100
	New(percent,mob/B)
		//if(!B) return
		if(istype(src,/Language/CustomLanguage)&&!ID) ID=rand(1,100000)
		LearnType=src.type
		Mastery=percent
		//owner=B
		if(B) if(ismob(B))
			if(!B.lan) B.lan=src
			for(var/Language/L in B) if(L.name==src) src.loc=null//No doubles
	//	..()

	verb/Teach()
		set hidden=1
		if(istype(src,/Language/Newborn)) return
		var/list/Targs=list()
		for(var/mob/T in oview(5,usr)) Targs+=T
		Targs+="Cancel"
		var/mob/targ=input(usr,"Teach [src] to whom?") in Targs
		if(targ!="Cancel")
			usr<<"You teach [targ] some [src]."
			targ<<"[usr] teaches you some [src]."
			targ.improve_language(src, 50)


	verb/Select_Language()
		set hidden=1
		if(src in usr)
			usr.lan=src
			usr<<"You are now speaking: <b>[usr.lan]([src.Mastery]%)</b>"


mob/proc/improve_language(Language/l, percent as num)
	if(!src) return
	if(istype(l,/Language/Newborn)) return
	if(ismob(src))
		if(!percent||percent<=0) percent = 2
		var/found=0
		if(istype(l,/Language/CustomLanguage))
			for(var/Language/L in src) if(L.ID==l.ID||L.name==l.name)
				found=1
				if(L.Mastery+percent <=100)
					L.Mastery += percent/l.Difficulty
					if(src.race=="Android") L.Mastery += (percent/l.Difficulty)*4
				else L.Mastery=100
		else
			for(var/Language/L in src) if(L.type==l.LearnType)
				found=1
				if(L.Mastery+percent <=100)
					L.Mastery += percent/l.Difficulty
					if(src.race=="Android") L.Mastery += (percent/l.Difficulty)*4
				else L.Mastery=100
			/*for(var/Activity/A in src) if(A.Subtype=="Language")
				if(!A.TT) A.TT=L.name
				if(L.name==A.TT) A.CheckProgress(L.Mastery,L.name,src)*/
		if(!found)

			if(istype(l,/Language/CustomLanguage))
				var/Language/CustomLanguage/CL=new
				CL.name=l.name
				CL.ID=l.ID
				CL.Mastery=5
				src.contents+=CL
				src<<"You're beginning to understand a new language!"
			else
				if(!src.contents.Find(l)) src.contents+=new l(5,src)
			//src.contents+=new l(2,src)



mob/proc/LanguageSay(msg as text, Language/language, skill as num, mob/M as mob)
    var/Understanding = 0

    // Check if the player's name is mentioned in the message
    //if (findtext(msg, name) && (M != src)) {
      //  M.MakeContact(src, 1)


    // Loop through the languages and improve the listener's understanding
    for (var/Language/L in M) {
        if (istype(L, language)) {
            Understanding = L.Mastery
        }
    }

    // Improve the player's language skill
    if (Understanding < 100) {
        M.improve_language(language, M.intxp*0.0125)
    }

    // Apply language skill modifiers
    if (!prob(skill)) {
        msg = Language_Shift(msg, skill)
    }

    // Shift the message if language understanding is not perfect
    msg = Language_Shift(msg, Understanding)

    return msg

proc/CheckText(var/T, var/pos)
	var/txt = lowertext(T)
	var/Choose = rand(1,3)
	if(txt == "a")
		if(Choose == 1) txt = "e"
		if(Choose == 2) txt = "i"
		if(Choose == 3) txt = "c"
	if(txt == "b")
		Choose = rand(1,3)
		if(Choose == 1) txt = "d"
		if(Choose == 2) txt = "p"
		if(Choose == 3) txt = "p"
	if(txt == "c")
		Choose = rand(1,3)
		if(Choose == 1) txt = "e"
		if(Choose == 2) txt = "s"
		if(Choose == 3) txt = "k"
	if(txt == "d")
		Choose = rand(1,3)
		if(Choose == 1) txt = "e"
		if(Choose == 2) txt = "b"
		if(Choose == 3) txt = "g"
	if(txt == "e")
		Choose = rand(1,3)
		if(Choose == 1) txt = "a"
		if(Choose == 2) txt = "t"
		if(Choose == 3) txt = "i"
	if(txt == "f")
		Choose = rand(1,3)
		if(Choose == 1) txt = "s"
		if(Choose == 2) txt = "r"
		if(Choose == 3) txt = "m"
	if(txt == "g")
		Choose = rand(1,3)
		if(Choose == 1) txt = "d"
		if(Choose == 2) txt = "e"
		if(Choose == 3) txt = "d"
	if(txt == "h")
		Choose = rand(1,3)
		if(Choose == 1) txt = "f"
		if(Choose == 2) txt = "a"
		if(Choose == 3) txt = "n"
	if(txt == "i")
		Choose = rand(1,3)
		if(Choose == 1) txt = "y"
		if(Choose == 2) txt = "u"
		if(Choose == 3) txt = "h"
	if(txt == "j")
		Choose = rand(1,3)
		if(Choose == 1) txt = "p"
		if(Choose == 2) txt = "g"
		if(Choose == 3) txt = "i"
	if(txt == "k")
		Choose = rand(1,3)
		if(Choose == 1) txt = "d"
		if(Choose == 2) txt = "v"
		if(Choose == 3) txt = "c"
	if(txt == "l")
		Choose = rand(1,3)
		if(Choose == 1) txt = "i"
		if(Choose == 2) txt = "u"
		if(Choose == 3) txt = "j"
	if(txt == "m")
		Choose = rand(1,3)
		if(Choose == 1) txt = "n"
		if(Choose == 2) txt = "h"
		if(Choose == 3) txt = "q"
	if(txt == "n")
		Choose = rand(1,3)
		if(Choose == 1) txt = "h"
		if(Choose == 2) txt = "m"
		if(Choose == 3) txt = "q"
	if(txt == "o")
		Choose = rand(1,3)
		if(Choose == 1) txt = "u"
		if(Choose == 2) txt = "s"
		if(Choose == 3) txt = "i"
	if(txt == "p")
		Choose = rand(1,3)
		if(Choose == 1) txt = "d"
		if(Choose == 2) txt = "b"
		if(Choose == 3) txt = "p"
	if(txt == "q")
		Choose = rand(1,3)
		if(Choose == 1) txt = "e"
		if(Choose == 2) txt = "i"
		if(Choose == 3) txt = "c"
	if(txt == "r")
		Choose = rand(1,3)
		if(Choose == 1) txt = "w"
		if(Choose == 2) txt = "a"
		if(Choose == 3) txt = "b"
	if(txt == "s")
		Choose = rand(1,3)
		if(Choose == 1) txt = "h"
		if(Choose == 2) txt = "c"
		if(Choose == 3) txt = "e"
	if(txt == "t")
		Choose = rand(1,3)
		if(Choose == 1) txt = "e"
		if(Choose == 2) txt = "u"
		if(Choose == 3) txt = "w"
	if(txt == "u")
		Choose = rand(1,3)
		if(Choose == 1) txt = "o"
		if(Choose == 2) txt = "e"
		if(Choose == 3) txt = "y"
	if(txt == "v")
		Choose = rand(1,3)
		if(Choose == 1) txt = "w"
		if(Choose == 2) txt = "a"
		if(Choose == 3) txt = "m"
	if(txt == "w")
		Choose = rand(1,3)
		if(Choose == 1) txt = "m"
		if(Choose == 2) txt = "w"
		if(Choose == 3) txt = "h"
	if(txt == "x")
		Choose = rand(1,3)
		if(Choose == 1) txt = "s"
		if(Choose == 2) txt = "e"
		if(Choose == 3) txt = "c"
	if(txt == "y")
		Choose = rand(1,3)
		if(Choose == 1) txt = "i"
		if(Choose == 2) txt = "r"
		if(Choose == 3) txt = "u"
	if(txt == "z")
		Choose = rand(1,3)
		if(Choose == 1) txt = "s"
		if(Choose == 2) txt = "g"
		if(Choose == 3) txt = "b"
	if(pos == 1) txt = uppertext(txt)
	return txt
proc/Language_Shift( w, p)
	var/NewText = null
	var/Text = null
	var/TextLength = length(w)
	while(TextLength >= 1)
		Text ="[copytext(w,(length(w)-TextLength)+1,(length(w)-TextLength)+2)]"
		var/Change = 0
		Change = prob(100 - p)
		if(Change)
			NewText+="[CheckText(Text,TextLength)]"
		if(Change == 0)
			NewText+="[copytext(w,(length(w)-TextLength)+1,(length(w)-TextLength)+2)]"
		TextLength--
		sleep(0.2)
	return NewText
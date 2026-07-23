		stove
			icon_state="stove"
			density=1
			var/beingcooked=0
			verb
				Cook()
					set src in oview(1)
					set category = "Skills"
					if(usr.agetype=="baby")
						usr<<"You are too young to do that."
						return
					if(!usr.cooking)
						var/list/food = list()
						for(var/obj/items/Food/Cookable/I in usr)
							food+=I
							if(I.name=="Cookable"||I.Cooked==1)
								food-=I
						if(!food||food==null||food=="")
							usr <<  "You don't have any food to cook!"
							usr.waiting=0
							return
						var /obj/items/Food/Cookable/Choice = input(usr,"Select a food choice?","Cooking") as anything in food
						if(Choice==null||!Choice) {usr <<  "You don't have any food to cook!";return}
						usr.cooking=1
						src.beingcooked=1
						view(usr)<<output("[usr] is cooking a [Choice]","rpoutput")
						sleep(30)
						usr.cooking=0
						src.beingcooked=0
						if(prob(55-usr.Chef_XP))
							Choice.Amount-=1
							for(var/mob/player/P in view(10,usr))
								P<<output("[P.getStrangerName(usr)] ruined the [Choice]!","rpoutput")
								usr.cooking=0
								src.beingcooked=0
								usr.waiting=0
								if(Choice.Amount<=0||Choice.Amount<=-0)
									del(Choice)
							var/CEGain=0
							if(prob(5))
								usr.CEAdd += usr.ratingmultiplier*0.002
								CEGain=1*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
								usr.Chef_XP+=CEGain
							else
								usr.CEAdd += usr.ratingmultiplier*0.002
								CEGain=0.60*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
								usr.Chef_XP+=CEGain
						else
							if(!Choice) return
							Choice.Amount-=1
							for(var/mob/player/P in view(10,usr))
								P<<output("[P.getStrangerName(usr)] has cooked a [Choice].","rpoutput")
								usr.cooking=0
								src.beingcooked=0
								usr.waiting=0

							var /obj/items/Food/Cookable/F = new(Choice)
							F.Amount=1
							if(Choice.name=="Apple Pie")
								F.icon='Manyfoods.dmi'
								F.icon_state="cpie"
								F.hungerpts=145
								F.hungerr=1
								F.endbuff=0.05+(usr.Chef_XP*0.001)
								F.forcebuff=0.05+(usr.Chef_XP*0.001)
								F.name="Cooked Apple Pie"
							if(Choice.name=="Raw Fish")
								F.icon='Small_Fish.dmi'
								F.icon_state="Cooked"
								F.hungerpts=155
								F.hungerr=1
								F.endbuff=0.07+(usr.Chef_XP*0.001)
								F.name="Cooked Fish"
							if(Choice.name=="Raw Steak")

								F.icon='Manyfoods.dmi'
								F.icon_state="cRawSteak"
								F.hungerpts=150
								F.hungerr=1
								F.strbuff=0.05+(usr.Chef_XP*0.001)
								F.name="Cooked Steak"
							if(Choice.name=="Special Raw Steak")
								F.icon='Manyfoods.dmi'
								F.icon_state="cRawSteak"
								F.hungerpts=150
								F.hungerr=1
								F.strbuff=0.08+(usr.Chef_XP*0.001)
								F.name="Special Cooked Steak"
							if(Choice.name=="Rare Raw Steak")
								F.icon='Manyfoods.dmi'
								F.icon_state="cRawSteak"
								F.hungerpts=150
								F.hungerr=1
								F.strbuff=0.1+(usr.Chef_XP*0.001)
								F.name="Rare Cooked Steak"
							if(Choice.name=="Raw Leg Meat")
								F.icon='Manyfoods.dmi'
								F.icon_state="cRawLeg"
								F.hungerpts=150
								F.hungerr=1
								F.strbuff=0.05+(usr.Chef_XP*0.001)
								F.name="Cooked Leg Meat"
							if(Choice.name=="Special Raw Leg Meat")
								F.icon='Manyfoods.dmi'
								F.icon_state="cRawLeg"
								F.hungerpts=150
								F.hungerr=1
								F.strbuff=0.08+(usr.Chef_XP*0.001)
								F.name="Special Cooked Leg Meat"
							if(Choice.name=="Rare Raw Leg Meat")
								F.icon='Manyfoods.dmi'
								F.icon_state="cRawLeg"
								F.hungerpts=150
								F.hungerr=1
								F.strbuff=0.1+(usr.Chef_XP*0.003)
								F.name="Rare Cooked Leg Meat"
							if(Choice.name=="Raw Soup")
								F.icon='Manyfoods.dmi'
								F.icon_state="cRawSoup"
								F.hungerpts=250
								F.thirstpts+=50
								F.hungerr=1
								F.endbuff+=0.05+(usr.Chef_XP*0.001)
								F.speedbuff+=0.05+(usr.Chef_XP*0.001)
								F.forcebuff+=0.05+(usr.Chef_XP*0.001)
								F.resbuff+=0.05+(usr.Chef_XP*0.001)
								F.name="Cooked Soup"
							if(Choice.name=="Raw Meat Soup")
								F.icon='Manyfoods.dmi'
								F.icon_state="cRawSoup"
								F.hungerpts=210
								F.thirstpts=90
								F.hungerr=1
								F.strbuff+=0.05+(usr.Chef_XP*0.001)
								F.endbuff+=0.05+(usr.Chef_XP*0.001)
								F.resbuff+=0.05+(usr.Chef_XP*0.001)
								F.forcebuff+=0.05+(usr.Chef_XP*0.001)
								F.name="Chooked Meat Soup"
							if(Choice.name=="Raw Fish Soup")
								F.icon='Manyfoods.dmi'
								F.icon_state="cRawSoup"
								F.hungerpts=205
								F.thirstpts=95
								F.hungerr=1
								F.speedbuff+=0.05+(usr.Chef_XP*0.001)
								F.endbuff+=0.05+(usr.Chef_XP*0.001)
								F.resbuff+=0.05+(usr.Chef_XP*0.001)
								F.name="Cooked Fish Soup"
							if(Choice.name=="Egg")
								F.icon='foods.dmi'
								F.icon_state="scrambled egg"
								F.hungerpts=70
								F.hungerr=1
								F.strbuff+=0.02+(usr.Chef_XP*0.001)
								F.endbuff+=0.02+(usr.Chef_XP*0.001)
								F.name="Scrambled Egg"
							if(Choice.name=="Salad")
								F.icon='foods.dmi'
								F.icon_state="csalad"
								F.hungerpts=150
								F.hungerr=1
								F.strbuff=0.08+(usr.Chef_XP*0.001)
								F.name="Steamed Salad"
							if(Choice.name=="Raw Small Fish")
								F.icon='Small_Fish.dmi'
								F.icon_state="Cooked"
								F.hungerpts=110
								F.hungerr=1
								F.resbuff=0.08+(usr.Chef_XP*0.001)
								F.defbuff=0.08+(usr.Chef_XP*0.001)
								F.name="Cooked Small Fish"
							if(Choice.name=="Raw Large Fish")
								F.icon='Large_Fish.dmi'
								F.icon_state="KO2"
								F.hungerpts=130
								F.hungerr=1
								F.forcebuff=0.08+(usr.Chef_XP*0.001)
								F.defbuff=0.08+(usr.Chef_XP*0.001)
								F.name="Cooked Large Fish"
							F.Cooked=1
							F.Move(usr)
							if(Choice.Amount<=0)
								del(Choice)

							if(prob(90))
								usr.Chef_XP+=0.8*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
							else
								usr.CEAdd += usr.ratingmultiplier*0.002
								usr.Chef_XP+=0.6*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
							usr.waiting=0
					else
						usr<<"You are already cooking."



		bench
			icon_state="bench"
			density=1
			verb
				Prepare_Food()
					set src in oview(1)
					set category = "Skills"
					if(usr.Chef_XP>=1&&usr.Chef_XP<9)
						switch(input("What type of food would you like to prepare?") in list ("Seasoned Steak(Raw Steak(1), Pepper(2))","Seasoned Leg Meat(Raw Leg Meat(1), Pepper(2))","Salad(Celery(2),Carrot(1)","Scrambled Egg(Egg(2)"))
							if("Seasoned Steak(Raw Steak(1), Pepper(2))")
								usr<<"Seasoned Steak - Raw Steak(1), Pepper(2)"
								var/list/items=list()
								for(var/obj/items/Food/Cookable/Raw_Steak/R in usr)
									items+=R.type
									if(R.type in items)
										if(R.Amount>=1)
											for(var/obj/items/Food/Cookable/Pepper/P in usr)
												items+=P.type
												if(P.type in items)
													if(P.Amount>=2)
														var/obj/items/Food/Cookable/Raw_Seasoned_Steak/SS=new
														R.Amount-=1
														if(R.Amount<=0) del(R)
														P.Amount-=2
														if(P.Amount<=0) del(P)
														usr.contents+=SS
														if(prob(!50))
															usr.CEAdd += usr.ratingmultiplier*0.002
															usr.Chef_XP+=0.05*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
														else
															usr.Chef_XP+=0.09*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting

													else
														usr<<"Not enough Pepper."
														return
												else
													usr<<"Missing Ingredients."
													return
										else
											usr<<"Not enough Steak."
											return
									else
										usr<<"Missing Ingredients."
										return
							if("Seasoned Leg Meat(Raw Leg Meat(1), Pepper(2))")
								usr<<"Seasoned Leg Meat - Raw Leg Meat(1), Pepper(2)"
								var/list/items=list()
								for(var/obj/items/Food/Cookable/Raw_Leg_Meat/R in usr)
									items+=R.type
									if(R.type in items)
										if(R.Amount>=1)
											for(var/obj/items/Food/Cookable/Pepper/P in usr)
												items+=P.type
												if(P.type in items)
													if(P.Amount>=2)
														var/obj/items/Food/Cookable/Raw_Seasoned_Leg_Meat/SS=new
														R.Amount-=1
														if(R.Amount<=0) del(R)
														P.Amount-=2
														if(P.Amount<=0) del(P)
														usr.contents+=SS
														if(prob(!50))
															usr.CEAdd += usr.ratingmultiplier*0.002
															usr.Chef_XP+=0.05*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
														else
															usr.Chef_XP+=0.09*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting

													else
														usr<<"Not enough Pepper."
														return
												else
													usr<<"Missing Ingredients."
													return
										else
											usr<<"Not enough Steak."
											return
									else
										usr<<"Missing Ingredients."
										return
							if("Salad(Celery(2),Carrot(1)")
								usr<<"Salad - Celery(2),Carrot(1)"
								var/list/items=list()
								for(var/obj/items/Food/Eatable/Celery/R in usr)
									items+=R.type
									if(R.type in items)
										if(R.Amount>=2)
											for(var/obj/items/Food/Eatable/Carrot/P in usr)
												items+=P.type
												if(P.type in items)
													if(P.Amount>=1)
														var/obj/items/Food/Eatable/Salad/SS=new
														R.Amount-=2
														if(R.Amount<=0) del(R)
														P.Amount-=1
														if(P.Amount<=0) del(P)
														usr.contents+=SS
														if(prob(!50))
															usr.CEAdd += usr.ratingmultiplier*0.002
															usr.Chef_XP+=0.06*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
														else
															usr.Chef_XP+=0.09*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting

													else
														usr<<"Not enough Carrot."
														return
												else
													usr<<"Missing Ingredients."
													return
										else
											usr<<"Not enough Celery."
											return
									else
										usr<<"Missing Ingredients."
										return
							if("Scrambled Egg(Egg(2)")
								usr<<"Scrambled Egg - Egg(2)"
								var/list/items=list()
								for(var/obj/items/Food/Cookable/Egg/R in usr)
									items+=R.type
									if(R.type in items)
										if(R.Amount>=2)
											var/obj/items/Food/Eatable/Scrambled_Egg/SS=new
											R.Amount-=2
											if(R.Amount<=0) del(R)
											usr.contents+=SS
											if(prob(!50))
												usr.CEAdd += usr.ratingmultiplier*0.002
												usr.Chef_XP+=0.007*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
											else
												usr.Chef_XP+=0.01*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting

										else
											usr<<"Not enough Eggs."
											return
									else
										usr<<"Missing Ingredients."
										return
					if(usr.Chef_XP>=75)
						switch(input("What type of food would you like to prepare?") in list ("Seasoned Steak(Raw Steak(1), Pepper(2))","Seasoned Leg Meat(Raw Leg Meat(1), Pepper(2))","Salad(Celery(2),Carrot(1)","Fruit Salad(Celery(1),Carrot(1),Apple(2)orBanana(2)","Scrambled Egg(Egg(2)","Pizza(Milk(1), Egg(2), Wheat(2)","Soup(Celery(2), Carrot(2), Potato(2), Water(4)","Cookie(Wheat(4), Milk(1)","Meat Soup(Raw Leg Meat(1), Celery(2), Carrot(2), Potatos(2), Water(4)","French Fries(Potatos(4)","Cream Puffs(Wheat(4), Milk(2), Egg(1)","Fish Soup(Raw Fish(1), Celery(2), Carrot(2), Potatos(2), Water(4)","Apple Pie(Apples(2), Wheat(2), Milk(4)"))
							if("Apple Pie(Apples(2), Wheat(1), Milk(4), Egg(1)")
								usr<<"Apple Pie - Apples(2), Wheat(1), Milk(4), Egg(1)"
								var/list/items=list()
								for(var/obj/items/Food/Eatable/Apple/R in usr)
									items+=R.type
									if(R.type in items)
										if(R.Amount>=2)
											for(var/obj/items/Food/Eatable/Wheat/P in usr)
												items+=P.type
												if(P.type in items)
													if(P.Amount>=1)
														for(var/obj/items/Food/Eatable/Milk/W in usr)
															items+=W.type
															if(W.type in items)
																if(W.Amount>=4)
																	for(var/obj/items/Food/Cookable/Egg/E in usr)
																		items+=E.type
																		if(E.type in items)
																			if(E.Amount>=4)
																				var/obj/items/Food/Cookable/Apple_Pie/SS=new
																				R.Amount-=2
																				if(R.Amount<=0) del(R)
																				P.Amount-=1
																				if(P.Amount<=0) del(P)
																				W.Amount-=4
																				if(W.Amount<=0) del(W)
																				E.Amount-=4
																				if(E.Amount<=0) del(E)
																				usr.contents+=SS
																				if(prob(!50))
																					usr.CEAdd += usr.ratingmultiplier*0.002
																					usr.Chef_XP+=0.05*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
																				else
																					usr.Chef_XP+=0.09*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
																			else
																				usr<<"Not enough Eggs."
																				return
																		else
																			usr<<"Missing Ingredients."
																			return
																else
																	usr<<"Not enough Milk."
																	return
															else
																usr<<"Missing Ingredients."
																return
													else
														usr<<"Not enough Wheat.."
														return
												else
													usr<<"Missing Ingredients."
													return
										else
											usr<<"Not enough Apples."
											return
									else
										usr<<"Missing Ingredients."
										return
							if("Fish Soup(Raw Small Fish(1), Celery(2), Carrot(2), Potatos(2), Water(4)")
								usr<<"Fish Soup - Raw Small Fish(1), Celery(2), Carrot(2), Potato(2), Water(4)"
								var/list/items=list()
								for(var/obj/items/Food/Eatable/Celery/R in usr)
									items+=R.type
									if(R.type in items)
										if(R.Amount>=2)
											for(var/obj/items/Food/Eatable/Carrot/P in usr)
												items+=P.type
												if(P.type in items)
													if(P.Amount>=2)
														for(var/obj/items/Food/Eatable/Potato/W in usr)
															items+=W.type
															if(W.type in items)
																if(W.Amount>=2)
																	for(var/obj/items/Food/Eatable/Purified_Water/WW in usr)
																		items+=WW.type
																		if(WW.type in items)
																			if(usr.purifiedwaters>=4)
																				for(var/obj/items/Food/Cookable/Raw_Small_Fish/RR in usr)
																					items+=RR.type
																					if(RR.type in items)
																						if(RR.Amount>=1)
																							var/obj/items/Food/Cookable/Raw_Fish_Soup/SS=new
																							R.Amount-=2
																							if(R.Amount<=0) del(R)
																							P.Amount-=2
																							if(P.Amount<=0) del(P)
																							W.Amount-=2
																							if(W.Amount<=0) del(W)
																							usr.purifiedwaters-=4
																							if(usr.purifiedwaters<=0) del(WW)
																							RR.Amount-=1
																							if(RR.Amount<=0) del(RR)
																							usr.contents+=SS
																							if(prob(!50))
																								usr.CEAdd += usr.ratingmultiplier*0.002
																								usr.Chef_XP+=0.06*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
																							else
																								usr.Chef_XP+=0.09*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
																						else
																							usr<<"Not enough Fish."
																							return
																					else
																						usr<<"Mising Ingrendients."
																						return
																			else
																				usr<<"Not enough Water."
																				return
																		else
																			usr<<"Missing Ingredients."
																			return
																else
																	usr<<"Not enough Potatos."
																	return
															else
																usr<<"Missing Ingredients."
																return
													else
														usr<<"Not enough Carrots.."
														return
												else
													usr<<"Missing Ingredients."
													return
										else
											usr<<"Not enough Celery."
											return
									else
										usr<<"Missing Ingredients."
										return
							if("Cream Puffs(Wheat(4), Milk(2), Egg(1)")
								usr<<"Cream Puffs - Wheat(4), Milk(2), Egg(1)"
								var/list/items=list()
								for(var/obj/items/Food/Eatable/Wheat/R in usr)
									items+=R.type
									if(R.type in items)
										if(R.Amount>=4)
											for(var/obj/items/Food/Eatable/Milk/P in usr)
												items+=P.type
												if(P.type in items)
													if(P.Amount>=2)
														for(var/obj/items/Food/Cookable/Egg/W in usr)
															items+=W.type
															if(W.type in items)
																if(W.Amount>=1)
																	var/obj/items/Food/Cookable/Raw_Meat_Soup/SS=new
																	R.Amount-=4
																	if(R.Amount<=0) del(R)
																	P.Amount-=2
																	if(P.Amount<=0) del(P)
																	W.Amount-=1
																	if(W.Amount<=0) del(W)
																	usr.contents+=SS
																	if(prob(!50))
																		usr.CEAdd += usr.ratingmultiplier*0.002
																		usr.Chef_XP+=0.06*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
																	else
																		usr.Chef_XP+=0.095*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
																else
																	usr<<"Not enough Eggs."
																	return
															else
																usr<<"Missing Ingredients."
																return
													else
														usr<<"Not enough Milk.."
														return
												else
													usr<<"Missing Ingredients."
													return
										else
											usr<<"Not enough Wheat."
											return
									else
										usr<<"Missing Ingredients."
										return
							if("French Fries(Potatos(4)")
								usr<<"French Fries(Potatos(4)"
								var/list/items=list()
								for(var/obj/items/Food/Eatable/Potato/R in usr)
									items+=R.type
									if(R.type in items)
										if(R.Amount>=2)
											var/obj/items/Food/Eatable/French_Fries/SS=new
											R.Amount-=2
											if(R.Amount<=0) del(R)
											usr.contents+=SS
											if(prob(!50))
												usr.CEAdd += usr.ratingmultiplier*0.002
												usr.Chef_XP+=0.008*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
											else
												usr.Chef_XP+=0.01*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting

										else
											usr<<"Not enough Potatos."
											return
									else
										usr<<"Missing Ingredients."
										return
							if("Meat Soup(Raw Leg Meat(1), Celery(2), Carrot(2), Potatos(2), Water(4)")
								usr<<"Meat Soup - Raw Leg Meat(1), Celery(2), Carrot(2), Potato(2), Water(4)"
								var/list/items=list()
								for(var/obj/items/Food/Eatable/Celery/R in usr)
									items+=R.type
									if(R.type in items)
										if(R.Amount>=2)
											for(var/obj/items/Food/Eatable/Carrot/P in usr)
												items+=P.type
												if(P.type in items)
													if(P.Amount>=2)
														for(var/obj/items/Food/Eatable/Potato/W in usr)
															items+=W.type
															if(W.type in items)
																if(W.Amount>=2)
																	for(var/obj/items/Food/Eatable/Purified_Water/WW in usr)
																		items+=WW.type
																		if(usr.purifiedwaters>=4)
																			for(var/obj/items/Food/Cookable/Raw_Leg_Meat/RR in usr)
																				items+=RR.type
																				if(RR.type in items)
																					if(RR.Amount>=1)
																						var/obj/items/Food/Cookable/Raw_Meat_Soup/SS=new
																						R.Amount-=2
																						if(R.Amount<=0) del(R)
																						P.Amount-=2
																						if(P.Amount<=0) del(P)
																						W.Amount-=2
																						if(W.Amount<=0) del(W)
																						usr.purifiedwaters-=4
																						if(usr.purifiedwaters<=0) del(WW)
																						RR.Amount-=1
																						if(RR.Amount<=0) del(RR)
																						usr.contents+=SS
																						if(prob(!50))
																							usr.CEAdd += usr.ratingmultiplier*0.002
																							usr.Chef_XP+=0.05*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
																						else
																							usr.Chef_XP+=0.09*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting

																					else
																						usr<<"Not enough Meat."
																						return
																				else
																					usr<<"Mising Ingrendients."
																					return
																		else
																			usr<<"Not enough Water."
																			return
																else
																	usr<<"Not enough Potatos."
																	return
															else
																usr<<"Missing Ingredients."
																return
													else
														usr<<"Not enough Carrots.."
														return
												else
													usr<<"Missing Ingredients."
													return
										else
											usr<<"Not enough Celery."
											return
									else
										usr<<"Missing Ingredients."
										return
							if("Soup(Celery(2), Carrot(2), Potato(2), Water(4)")
								usr<<"Soup - Celery(2), Carrot(2), Potato(2), Water(4)"
								var/list/items=list()
								for(var/obj/items/Food/Eatable/Celery/R in usr)
									items+=R.type
									if(R.type in items)
										if(R.Amount>=2)
											for(var/obj/items/Food/Eatable/Carrot/P in usr)
												items+=P.type
												if(P.type in items)
													if(P.Amount>=2)
														for(var/obj/items/Food/Eatable/Potato/W in usr)
															items+=W.type
															if(W.type in items)
																if(W.Amount>=2)
																	for(var/obj/items/Food/Eatable/Purified_Water/WW in usr)
																		items+=WW.type
																		if(WW.type in items)
																			if(usr.purifiedwaters>=4)
																				var/obj/items/Food/Cookable/Raw_Soup/SS=new
																				R.Amount-=2
																				if(R.Amount<=0) del(R)
																				P.Amount-=2
																				if(P.Amount<=0) del(P)
																				W.Amount-=2
																				if(W.Amount<=0) del(W)
																				usr.purifiedwaters-=4
																				if(usr.purifiedwaters<=0) del(WW)

																				usr.contents+=SS
																				if(prob(!50))
																					usr.CEAdd += usr.ratingmultiplier*0.002
																					usr.Chef_XP+=0.05*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
																				else
																					usr.Chef_XP+=0.09*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
																			else
																				usr<<"Not enough Water."
																				return
																		else
																			usr<<"Missing Ingredients."
																			return
																else
																	usr<<"Not enough Potatos."
																	return
															else
																usr<<"Missing Ingredients."
																return
													else
														usr<<"Not enough Carrots.."
														return
												else
													usr<<"Missing Ingredients."
													return
										else
											usr<<"Not enough Celery."
											return
									else
										usr<<"Missing Ingredients."
										return
							if("Pizza(Milk(1), Egg(2), Wheat(2)")
								usr<<"Pizza - Milk(1), Egg(2), Wheat(2)"
								var/list/items=list()
								for(var/obj/items/Food/Eatable/Milk/R in usr)
									items+=R.type
									if(R.type in items)
										if(R.Amount>=1)
											for(var/obj/items/Food/Cookable/Egg/P in usr)
												items+=P.type
												if(P.type in items)
													if(P.Amount>=2)
														for(var/obj/items/Food/Eatable/Wheat/W in usr)
															items+=W.type
															if(W.type in items)
																if(W.Amount>=2)
																	var/obj/items/Food/Cookable/Pizza/SS=new
																	R.Amount-=1
																	if(R.Amount<=0) del(R)
																	P.Amount-=2
																	if(P.Amount<=0) del(P)
																	W.Amount-=2
																	if(W.Amount<=0) del(W)
																	usr.contents+=SS
																	if(prob(!50))
																		usr.CEAdd += usr.ratingmultiplier*0.002
																		usr.Chef_XP+=0.007*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
																	else
																		usr.Chef_XP+=0.009*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
																else
																	usr<<"Not enough Wheat."
																	return
															else
																usr<<"Missing Ingredients."
																return
													else
														usr<<"Not enough Eggs."
														return
												else
													usr<<"Missing Ingredients."
													return
										else
											usr<<"Not enough Milk."
											return
									else
										usr<<"Missing Ingredients."
										return
							if("Seasoned Steak(Raw Steak(1), Pepper(2))")
								usr<<"Seasoned Steak - Raw Steak(1), Pepper(2)"
								var/list/items=list()
								for(var/obj/items/Food/Cookable/Raw_Steak/R in usr)
									items+=R.type
									if(R.type in items)
										if(R.Amount>=1)
											for(var/obj/items/Food/Cookable/Pepper/P in usr)
												items+=P.type
												if(P.type in items)
													if(P.Amount>=2)
														var/obj/items/Food/Cookable/Raw_Seasoned_Steak/SS=new
														R.Amount-=1
														if(R.Amount<=0) del(R)
														P.Amount-=2
														if(P.Amount<=0) del(P)
														usr.contents+=SS
														if(prob(!50))
															usr.CEAdd += usr.ratingmultiplier*0.002
															usr.Chef_XP+=0.01*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
														else
															usr.Chef_XP+=0.07*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting

													else
														usr<<"Not enough Pepper."
														return
												else
													usr<<"Missing Ingredients."
													return
										else
											usr<<"Not enough Steak."
											return
									else
										usr<<"Missing Ingredients."
										return
							if("Seasoned Leg Meat(Raw Leg Meat(1), Pepper(2))")
								usr<<"Seasoned Leg Meat - Raw Leg Meat(1), Pepper(2)"
								var/list/items=list()
								for(var/obj/items/Food/Cookable/Raw_Leg_Meat/R in usr)
									items+=R.type
									if(R.type in items)
										if(R.Amount>=1)
											for(var/obj/items/Food/Cookable/Pepper/P in usr)
												items+=P.type
												if(P.type in items)
													if(P.Amount>=2)
														var/obj/items/Food/Cookable/Raw_Seasoned_Leg_Meat/SS=new
														R.Amount-=1
														if(R.Amount<=0) del(R)
														P.Amount-=2
														if(P.Amount<=0) del(P)
														usr.contents+=SS
														if(prob(!50))
															usr.CEAdd += usr.ratingmultiplier*0.002
															usr.Chef_XP+=0.01*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
														else
															usr.Chef_XP+=0.07*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting

													else
														usr<<"Not enough Pepper."
														return
												else
													usr<<"Missing Ingredients."
													return
										else
											usr<<"Not enough Steak."
											return
									else
										usr<<"Missing Ingredients."
										return
							if("Salad(Celery(2),Carrot(1)")
								usr<<"Salad - Celery(2),Carrot(1)"
								var/list/items=list()
								for(var/obj/items/Food/Eatable/Celery/R in usr)
									items+=R.type
									if(R.type in items)
										if(R.Amount>=2)
											for(var/obj/items/Food/Eatable/Carrot/P in usr)
												items+=P.type
												if(P.type in items)
													if(P.Amount>=1)
														var/obj/items/Food/Eatable/Salad/SS=new
														R.Amount-=2
														if(R.Amount<=0) del(R)
														P.Amount-=1
														if(P.Amount<=0) del(P)
														usr.contents+=SS
														if(prob(!50))
															usr.CEAdd += usr.ratingmultiplier*0.002
															usr.Chef_XP+=0.01*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
														else
															usr.Chef_XP+=0.07*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting

													else
														usr<<"Not enough Carrot."
														return
												else
													usr<<"Missing Ingredients."
													return
										else
											usr<<"Not enough Celery."
											return
									else
										usr<<"Missing Ingredients."
										return
							if("Fruit Salad(Celery(1),Carrot(1),Apple(2)orBanana(2)")
								usr<<"Fruit Salad - Celery(1),Carrot(1),Apple(2) or Banana(2)"
								var/list/items=list()
								for(var/obj/items/Food/Eatable/Celery/R in usr)
									items+=R.type
									if(R.type in items)
										if(R.Amount>=1)
											for(var/obj/items/Food/Eatable/Carrot/P in usr)
												items+=P.type
												if(P.type in items)
													if(P.Amount>=1)
														for(var/obj/items/Food/Eatable/Apple/A in usr)
															items+=A.type
															if(A.type in items)
																if(A.Amount>=2)
																	for(var/obj/items/Food/Eatable/Banana/B in usr)
																		items+=B.type
																		if(B.type in items)
																			if(B.Amount>=2)
																				var/obj/items/Food/Eatable/Salad/SS=new
																				R.Amount-=1
																				if(R.Amount<=0) del(R)
																				P.Amount-=1
																				if(P.Amount<=0) del(P)
																				A.Amount-=2
																				if(A.Amount<=0) del(A)
																				B.Amount-=2
																				if(B.Amount<=0) del(B)
																				usr.contents+=SS
																				if(prob(!50))
																					usr.CEAdd += usr.ratingmultiplier*0.002
																					usr.Chef_XP+=0.02*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
																				else
																					usr.Chef_XP+=0.08*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting

																			else
																				usr<<"Not enough Bananas."
																				return
																		else
																			usr<<"Missing Ingredients."
																			return
																else
																	usr<<"Not enough Apples."
																	return
															else
																usr<<"Missing Ingredients."
																return
													else
														usr<<"Not enough Carrot."
														return
												else
													usr<<"Missing Ingredients."
													return
										else
											usr<<"Not enough Celery."
											return
									else
										usr<<"Missing Ingredients."
										return
							if("Scrambled Egg(Egg(2)")
								usr<<"Scrambled Egg - Egg(2)"
								var/list/items=list()
								for(var/obj/items/Food/Cookable/Egg/R in usr)
									items+=R.type
									if(R.type in items)
										if(R.Amount>=2)
											var/obj/items/Food/Eatable/Scrambled_Egg/SS=new
											R.Amount-=2
											if(R.Amount<=0) del(R)
											usr.contents+=SS
											if(prob(!50))
												usr.CEAdd += usr.ratingmultiplier*0.002
												usr.Chef_XP+=0.004*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
											else
												usr.Chef_XP+=0.007*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting

										else
											usr<<"Not enough Eggs."
											return
									else
										usr<<"Missing Ingredients"
										return
					if(usr.Chef_XP>=50&&usr.Chef_XP<75)
						switch(input("What type of food would you like to prepare?") in list ("Seasoned Steak(Raw Steak(1), Pepper(2))","Seasoned Leg Meat(Raw Leg Meat(1), Pepper(2))","Salad(Celery(2),Carrot(1)","Fruit Salad(Celery(1),Carrot(1),Apple(2)orBanana(2)","Scrambled Egg(Egg(2)","Pizza(Milk(1), Egg(2), Wheat(2)","Soup(Celery(2), Carrot(2), Potato(2), Water(4)","Cookie(Wheat(4), Milk(1)","Meat Soup(Raw Leg Meat(1), Celery(2), Carrot(2), Potatos(2), Water(4)","French Fries(Potatos(4)","Cream Puffs(Wheat(4), Milk(2), Egg(1)"))
							if("Cream Puffs(Wheat(4), Milk(2), Egg(1)")
								usr<<"Cream Puffs - Wheat(4), Milk(2), Egg(1)"
								var/list/items=list()
								for(var/obj/items/Food/Eatable/Wheat/R in usr)
									items+=R.type
									if(R.type in items)
										if(R.Amount>=4)
											for(var/obj/items/Food/Eatable/Milk/P in usr)
												items+=P.type
												if(P.type in items)
													if(P.Amount>=2)
														for(var/obj/items/Food/Cookable/Egg/W in usr)
															items+=W.type
															if(W.type in items)
																if(W.Amount>=1)
																	var/obj/items/Food/Cookable/Raw_Meat_Soup/SS=new
																	R.Amount-=4
																	if(R.Amount<=0) del(R)
																	P.Amount-=2
																	if(P.Amount<=0) del(P)
																	W.Amount-=1
																	if(W.Amount<=0) del(W)
																	usr.contents+=SS
																	if(prob(!50))
																		usr.CEAdd += usr.ratingmultiplier*0.002
																		usr.Chef_XP+=0.01*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
																	else
																		usr.Chef_XP+=0.07*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
																else
																	usr<<"Not enough Eggs."
																	return
															else
																usr<<"Missing Ingredients."
																return
													else
														usr<<"Not enough Milk.."
														return
												else
													usr<<"Missing Ingredients."
													return
										else
											usr<<"Not enough Wheat."
											return
									else
										usr<<"Missing Ingredients."
										return
							if("French Fries(Potatos(4)")
								usr<<"French Fries(Potatos(4)"
								var/list/items=list()
								for(var/obj/items/Food/Eatable/Potato/R in usr)
									items+=R.type
									if(R.type in items)
										if(R.Amount>=2)
											var/obj/items/Food/Eatable/French_Fries/SS=new
											R.Amount-=2
											if(R.Amount<=0) del(R)
											usr.contents+=SS
											if(prob(!50))
												usr.CEAdd += usr.ratingmultiplier*0.002
												usr.Chef_XP+=0.003*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
											else
												usr.Chef_XP+=0.007*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting

										else
											usr<<"Not enough Potatos."
											return
									else
										usr<<"Missing Ingredients."
										return
							if("Meat Soup(Raw Leg Meat(1), Celery(2), Carrot(2), Potatos(2), Water(4)")
								usr<<"Meat Soup - Raw Leg Meat(1), Celery(2), Carrot(2), Potato(2), Water(4)"
								var/list/items=list()
								for(var/obj/items/Food/Eatable/Celery/R in usr)
									items+=R.type
									if(R.type in items)
										if(R.Amount>=2)
											for(var/obj/items/Food/Eatable/Carrot/P in usr)
												items+=P.type
												if(P.type in items)
													if(P.Amount>=2)
														for(var/obj/items/Food/Eatable/Potato/W in usr)
															items+=W.type
															if(W.type in items)
																if(W.Amount>=2)
																	for(var/obj/items/Food/Eatable/Purified_Water/WW in usr)
																		items+=WW.type
																		if(WW.type in items)
																			if(usr.purifiedwaters>=4)
																				for(var/obj/items/Food/Cookable/Raw_Leg_Meat/RR in usr)
																					items+=RR.type
																					if(RR.type in items)
																						if(RR.Amount>=1)
																							var/obj/items/Food/Cookable/Raw_Meat_Soup/SS=new
																							R.Amount-=2
																							if(R.Amount<=0) del(R)
																							P.Amount-=2
																							if(P.Amount<=0) del(P)
																							W.Amount-=2
																							if(W.Amount<=0) del(W)
																							usr.purifiedwaters-=4
																							if(usr.purifiedwaters<=0) del(WW)
																							RR.Amount-=1
																							if(RR.Amount<=0) del(RR)
																							usr.contents+=SS
																							if(prob(!50))
																								usr.CEAdd += usr.ratingmultiplier*0.002
																								usr.Chef_XP+=0.02*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
																							else
																								usr.Chef_XP+=0.08*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
																						else
																							usr<<"Not enough Meat."
																							return
																					else
																						usr<<"Mising Ingrendients."
																						return
																			else
																				usr<<"Not enough Water."
																				return
																		else
																			usr<<"Missing Ingredients."
																			return
																else
																	usr<<"Not enough Potatos."
																	return
															else
																usr<<"Missing Ingredients."
																return
													else
														usr<<"Not enough Carrots.."
														return
												else
													usr<<"Missing Ingredients."
													return
										else
											usr<<"Not enough Celery."
											return
									else
										usr<<"Missing Ingredients."
										return
							if("Soup(Celery(2), Carrot(2), Potato(2), Water(4)")
								usr<<"Soup - Celery(2), Carrot(2), Potato(2), Water(4)"
								var/list/items=list()
								for(var/obj/items/Food/Eatable/Celery/R in usr)
									items+=R.type
									if(R.type in items)
										if(R.Amount>=2)
											for(var/obj/items/Food/Eatable/Carrot/P in usr)
												items+=P.type
												if(P.type in items)
													if(P.Amount>=2)
														for(var/obj/items/Food/Eatable/Potato/W in usr)
															items+=W.type
															if(W.type in items)
																if(W.Amount>=2)
																	for(var/obj/items/Food/Eatable/Purified_Water/WW in usr)
																		items+=WW.type
																		if(WW.type in items)
																			if(usr.purifiedwaters>=4)
																				var/obj/items/Food/Cookable/Raw_Soup/SS=new
																				R.Amount-=2
																				if(R.Amount<=0) del(R)
																				P.Amount-=2
																				if(P.Amount<=0) del(P)
																				W.Amount-=2
																				if(W.Amount<=0) del(W)
																				usr.purifiedwaters-=4
																				if(usr.purifiedwaters<=0) del(WW)
																				usr.contents+=SS
																				if(prob(!50))
																					usr.CEAdd += usr.ratingmultiplier*0.002
																					usr.Chef_XP+=0.03*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
																				else
																					usr.Chef_XP+=0.08*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
																			else
																				usr<<"Not enough Water."
																				return
																		else
																			usr<<"Missing Ingredients."
																			return
																else
																	usr<<"Not enough Potatos."
																	return
															else
																usr<<"Missing Ingredients."
																return
													else
														usr<<"Not enough Carrots.."
														return
												else
													usr<<"Missing Ingredients."
													return
										else
											usr<<"Not enough Celery."
											return
									else
										usr<<"Missing Ingredients."
										return
							if("Pizza(Milk(1), Egg(2), Wheat(2)")
								usr<<"Pizza - Milk(1), Egg(2), Wheat(2)"
								var/list/items=list()
								for(var/obj/items/Food/Eatable/Milk/R in usr)
									items+=R.type
									if(R.type in items)
										if(R.Amount>=1)
											for(var/obj/items/Food/Cookable/Egg/P in usr)
												items+=P.type
												if(P.type in items)
													if(P.Amount>=2)
														for(var/obj/items/Food/Eatable/Wheat/W in usr)
															items+=W.type
															if(W.type in items)
																if(W.Amount>=2)
																	var/obj/items/Food/Cookable/Pizza/SS=new
																	R.Amount-=1
																	if(R.Amount<=0) del(R)
																	P.Amount-=2
																	if(P.Amount<=0) del(P)
																	W.Amount-=2
																	if(W.Amount<=0) del(W)
																	usr.contents+=SS
																	if(prob(!50))
																		usr.CEAdd += usr.ratingmultiplier*0.002
																		usr.Chef_XP+=0.002*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
																	else
																		usr.Chef_XP+=0.007*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
																else
																	usr<<"Not enough Wheat."
																	return
															else
																usr<<"Missing Ingredients."
																return
													else
														usr<<"Not enough Eggs."
														return
												else
													usr<<"Missing Ingredients."
													return
										else
											usr<<"Not enough Milk."
											return
									else
										usr<<"Missing Ingredients."
										return
							if("Seasoned Steak(Raw Steak(1), Pepper(2))")
								usr<<"Seasoned Steak - Raw Steak(1), Pepper(2)"
								var/list/items=list()
								for(var/obj/items/Food/Cookable/Raw_Steak/R in usr)
									items+=R.type
									if(R.type in items)
										if(R.Amount>=1)
											for(var/obj/items/Food/Cookable/Pepper/P in usr)
												items+=P.type
												if(P.type in items)
													if(P.Amount>=2)
														var/obj/items/Food/Cookable/Raw_Seasoned_Steak/SS=new
														R.Amount-=1
														if(R.Amount<=0) del(R)
														P.Amount-=2
														if(P.Amount<=0) del(P)
														usr.contents+=SS
														if(prob(!50))
															usr.CEAdd += usr.ratingmultiplier*0.002
															usr.Chef_XP+=0.01*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
														else
															usr.Chef_XP+=0.07*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting

													else
														usr<<"Not enough Pepper."
														return
												else
													usr<<"Missing Ingredients."
													return
										else
											usr<<"Not enough Steak."
											return
									else
										usr<<"Missing Ingredients."
										return
							if("Seasoned Leg Meat(Raw Leg Meat(1), Pepper(2))")
								usr<<"Seasoned Leg Meat - Raw Leg Meat(1), Pepper(2)"
								var/list/items=list()
								for(var/obj/items/Food/Cookable/Raw_Leg_Meat/R in usr)
									items+=R.type
									if(R.type in items)
										if(R.Amount>=1)
											for(var/obj/items/Food/Cookable/Pepper/P in usr)
												items+=P.type
												if(P.type in items)
													if(P.Amount>=2)
														var/obj/items/Food/Cookable/Raw_Seasoned_Leg_Meat/SS=new
														R.Amount-=1
														if(R.Amount<=0) del(R)
														P.Amount-=2
														if(P.Amount<=0) del(P)
														usr.contents+=SS
														if(prob(!50))
															usr.CEAdd += usr.ratingmultiplier*0.002
															usr.Chef_XP+=0.01*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
														else
															usr.Chef_XP+=0.07*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting

													else
														usr<<"Not enough Pepper."
														return
												else
													usr<<"Missing Ingredients."
													return
										else
											usr<<"Not enough Steak."
											return
									else
										usr<<"Missing Ingredients."
										return
							if("Salad(Celery(2),Carrot(1)")
								usr<<"Salad - Celery(2),Carrot(1)"
								var/list/items=list()
								for(var/obj/items/Food/Eatable/Celery/R in usr)
									items+=R.type
									if(R.type in items)
										if(R.Amount>=2)
											for(var/obj/items/Food/Eatable/Carrot/P in usr)
												items+=P.type
												if(P.type in items)
													if(P.Amount>=1)
														var/obj/items/Food/Eatable/Salad/SS=new
														R.Amount-=2
														if(R.Amount<=0) del(R)
														P.Amount-=1
														if(P.Amount<=0) del(P)
														usr.contents+=SS
														if(prob(!50))
															usr.CEAdd += usr.ratingmultiplier*0.002
															usr.Chef_XP+=0.01*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
														else
															usr.Chef_XP+=0.07*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting

													else
														usr<<"Not enough Carrot."
														return
												else
													usr<<"Missing Ingredients."
													return
										else
											usr<<"Not enough Celery."
											return
									else
										usr<<"Missing Ingredients."
										return
							if("Fruit Salad(Celery(1),Carrot(1),Apple(2)orBanana(2)")
								usr<<"Fruit Salad - Celery(1),Carrot(1),Apple(2) or Banana(2)"
								var/list/items=list()
								for(var/obj/items/Food/Eatable/Celery/R in usr)
									items+=R.type
									if(R.type in items)
										if(R.Amount>=1)
											for(var/obj/items/Food/Eatable/Carrot/P in usr)
												items+=P.type
												if(P.type in items)
													if(P.Amount>=1)
														for(var/obj/items/Food/Eatable/Apple/A in usr)
															items+=A.type
															for(var/obj/items/Food/Eatable/Banana/B in usr)
																items+=B.type
																if(A.type in items||B.type in items)
																	if(A.Amount>=2||B.Amount>=2)
																		var/obj/items/Food/Eatable/Salad/SS=new
																		R.Amount-=1
																		if(R.Amount<=0) del(R)
																		P.Amount-=1
																		if(P.Amount<=0) del(P)
																		A.Amount-=2
																		if(A.Amount<=0) del(A)
																		B.Amount-=2
																		if(B.Amount<=0) del(B)
																		usr.contents+=SS
																		if(prob(!50))
																			usr.CEAdd += usr.ratingmultiplier*0.002
																			usr.Chef_XP+=0.02*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
																		else
																			usr.Chef_XP+=0.08*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting

																	else
																		usr<<"Not enough Fruits."
																		return
																else
																	usr<<"Missing Ingredients."
																	return
													else
														usr<<"Not enough Carrot."
														return
												else
													usr<<"Missing Ingredients."
													return
										else
											usr<<"Not enough Celery."
											return
									else
										usr<<"Missing Ingredients."
										return
							if("Scrambled Egg(Egg(2)")
								usr<<"Scrambled Egg - Egg(2)"
								var/list/items=list()
								for(var/obj/items/Food/Cookable/Egg/R in usr)
									items+=R.type
									if(R.type in items)
										if(R.Amount>=2)
											var/obj/items/Food/Eatable/Scrambled_Egg/SS=new
											R.Amount-=2
											if(R.Amount<=0) del(R)
											usr.contents+=SS
											if(prob(!50))
												usr.CEAdd += usr.ratingmultiplier*0.002
												usr.Chef_XP+=0.002*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
											else
												usr.Chef_XP+=0.007*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting

										else
											usr<<"Not enough Eggs."
											return
									else
										usr<<"Missing Ingredients"
										return
					if(usr.Chef_XP>=25&&usr.Chef_XP<50)
						switch(input("What type of food would you like to prepare?") in list ("Seasoned Steak(Raw Steak(1), Pepper(2))","Seasoned Leg Meat(Raw Leg Meat(1), Pepper(2))","Salad(Celery(2),Carrot(1)","Fruit Salad(Celery(1),Carrot(1),Apple(2)orBanana(2)","Scrambled Egg(Egg(2)","Pizza(Milk(1), Egg(2), Wheat(2)","Soup(Celery(2), Carrot(2), Potato(2), Water(4)","Cookie(Wheat(4), Milk(1)"))
							if("Soup(Celery(2), Carrot(2), Potato(2), Water(4)")
								usr<<"Soup - Celery(2), Carrot(2), Potato(2), Water(4)"
								var/list/items=list()
								for(var/obj/items/Food/Eatable/Celery/R in usr)
									items+=R.type
									if(R.type in items)
										if(R.Amount>=2)
											for(var/obj/items/Food/Eatable/Carrot/P in usr)
												items+=P.type
												if(P.type in items)
													if(P.Amount>=2)
														for(var/obj/items/Food/Eatable/Potato/W in usr)
															items+=W.type
															if(W.type in items)
																if(W.Amount>=2)
																	for(var/obj/items/Food/Eatable/Purified_Water/WW in usr)
																		items+=WW.type
																		if(WW.type in items)
																			if(usr.purifiedwaters>=4)
																				var/obj/items/Food/Cookable/Raw_Soup/SS=new
																				R.Amount-=2
																				if(R.Amount<=0) del(R)
																				P.Amount-=2
																				if(P.Amount<=0) del(P)
																				W.Amount-=2
																				if(W.Amount<=0) del(W)
																				usr.purifiedwaters-=4
																				if(usr.purifiedwaters<=0) del(WW)
																				usr.contents+=SS
																				if(prob(!50))
																					usr.CEAdd += usr.ratingmultiplier*0.002
																					usr.Chef_XP+=0.01*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
																				else
																					usr.Chef_XP+=0.07*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
																			else
																				usr<<"Not enough Water."
																				return
																		else
																			usr<<"Missing Ingredients."
																			return
																else
																	usr<<"Not enough Potatos."
																	return
															else
																usr<<"Missing Ingredients."
																return
													else
														usr<<"Not enough Carrots.."
														return
												else
													usr<<"Missing Ingredients."
													return
										else
											usr<<"Not enough Celery."
											return
									else
										usr<<"Missing Ingredients."
										return
							if("Pizza(Milk(1), Egg(2), Wheat(2)")
								usr<<"Pizza - Milk(1), Egg(2), Wheat(2)"
								var/list/items=list()
								for(var/obj/items/Food/Eatable/Milk/R in usr)
									items+=R.type
									if(R.type in items)
										if(R.Amount>=1)
											for(var/obj/items/Food/Cookable/Egg/P in usr)
												items+=P.type
												if(P.type in items)
													if(P.Amount>=2)
														for(var/obj/items/Food/Eatable/Wheat/W in usr)
															items+=W.type
															if(W.type in items)
																if(W.Amount>=2)
																	var/obj/items/Food/Cookable/Pizza/SS=new
																	R.Amount-=1
																	if(R.Amount<=0) del(R)
																	P.Amount-=2
																	if(P.Amount<=0) del(P)
																	W.Amount-=2
																	if(W.Amount<=0) del(W)
																	usr.contents+=SS
																	if(prob(!50))
																		usr.CEAdd += usr.ratingmultiplier*0.002
																		usr.Chef_XP+=0.002*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
																	else
																		usr.Chef_XP+=0.008*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
																else
																	usr<<"Not enough Wheat."
																	return
															else
																usr<<"Missing Ingredients."
																return
													else
														usr<<"Not enough Eggs."
														return
												else
													usr<<"Missing Ingredients."
													return
										else
											usr<<"Not enough Milk."
											return
									else
										usr<<"Missing Ingredients."
										return
							if("Seasoned Steak(Raw Steak(1), Pepper(2))")
								usr<<"Seasoned Steak - Raw Steak(1), Pepper(2)"
								var/list/items=list()
								for(var/obj/items/Food/Cookable/Raw_Steak/R in usr)
									items+=R.type
									if(R.type in items)
										if(R.Amount>=1)
											for(var/obj/items/Food/Cookable/Pepper/P in usr)
												items+=P.type
												if(P.type in items)
													if(P.Amount>=2)
														var/obj/items/Food/Cookable/Raw_Seasoned_Steak/SS=new
														R.Amount-=1
														if(R.Amount<=0) del(R)
														P.Amount-=2
														if(P.Amount<=0) del(P)
														usr.contents+=SS
														if(prob(!50))
															usr.CEAdd += usr.ratingmultiplier*0.002
															usr.Chef_XP+=0.02*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
														else
															usr.Chef_XP+=0.08*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting

													else
														usr<<"Not enough Pepper."
														return
												else
													usr<<"Missing Ingredients."
													return
										else
											usr<<"Not enough Steak."
											return
									else
										usr<<"Missing Ingredients."
										return
							if("Seasoned Leg Meat(Raw Leg Meat(1), Pepper(2))")
								usr<<"Seasoned Leg Meat - Raw Leg Meat(1), Pepper(2)"
								var/list/items=list()
								for(var/obj/items/Food/Cookable/Raw_Leg_Meat/R in usr)
									items+=R.type
									if(R.type in items)
										if(R.Amount>=1)
											for(var/obj/items/Food/Cookable/Pepper/P in usr)
												items+=P.type
												if(P.type in items)
													if(P.Amount>=2)
														var/obj/items/Food/Cookable/Raw_Seasoned_Leg_Meat/SS=new
														R.Amount-=1
														if(R.Amount<=0) del(R)
														P.Amount-=2
														if(P.Amount<=0) del(P)
														usr.contents+=SS
														if(prob(!50))
															usr.CEAdd += usr.ratingmultiplier*0.002
															usr.Chef_XP+=0.02*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
														else
															usr.Chef_XP+=0.08*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting

													else
														usr<<"Not enough Pepper."
														return
												else
													usr<<"Missing Ingredients."
													return
										else
											usr<<"Not enough Steak."
											return
									else
										usr<<"Missing Ingredients."
										return
							if("Salad(Celery(2),Carrot(1)")
								usr<<"Salad - Celery(2),Carrot(1)"
								var/list/items=list()
								for(var/obj/items/Food/Eatable/Celery/R in usr)
									items+=R.type
									if(R.type in items)
										if(R.Amount>=2)
											for(var/obj/items/Food/Eatable/Carrot/P in usr)
												items+=P.type
												if(P.type in items)
													if(P.Amount>=1)
														var/obj/items/Food/Eatable/Salad/SS=new
														R.Amount-=2
														if(R.Amount<=0) del(R)
														P.Amount-=1
														if(P.Amount<=0) del(P)
														usr.contents+=SS
														if(prob(!50))
															usr.CEAdd += usr.ratingmultiplier*0.002
															usr.Chef_XP+=0.02*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
														else
															usr.Chef_XP+=0.08*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting

													else
														usr<<"Not enough Carrot."
														return
												else
													usr<<"Missing Ingredients."
													return
										else
											usr<<"Not enough Celery."
											return
									else
										usr<<"Missing Ingredients."
										return
							if("Fruit Salad(Celery(1),Carrot(1),Apple(2)orBanana(2)")
								usr<<"Fruit Salad - Celery(1),Carrot(1),Apple(2) or Banana(2)"
								var/list/items=list()
								for(var/obj/items/Food/Eatable/Celery/R in usr)
									items+=R.type
									if(R.type in items)
										if(R.Amount>=1)
											for(var/obj/items/Food/Eatable/Carrot/P in usr)
												items+=P.type
												if(P.type in items)
													if(P.Amount>=1)
														for(var/obj/items/Food/Eatable/Apple/A in usr)
															items+=A.type
															if(A.type in items)
																if(A.Amount>=2)
																	for(var/obj/items/Food/Eatable/Banana/B in usr)
																		items+=B.type
																		if(B.type in items)
																			if(B.Amount>=2)
																				var/obj/items/Food/Eatable/Salad/SS=new
																				R.Amount-=1
																				if(R.Amount<=0) del(R)
																				P.Amount-=1
																				if(P.Amount<=0) del(P)
																				A.Amount-=2
																				if(A.Amount<=0) del(A)
																				B.Amount-=2
																				if(B.Amount<=0) del(B)
																				usr.contents+=SS
																				if(prob(!50))
																					usr.CEAdd += usr.ratingmultiplier*0.002
																					usr.Chef_XP+=0.02*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
																				else
																					usr.Chef_XP+=0.08*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting

																			else
																				usr<<"Not enough Bananas."
																				return
																		else
																			usr<<"Missing Ingredients."
																			return
																else
																	usr<<"Not enough Apples."
																	return
															else
																usr<<"Missing Ingredients."
																return
													else
														usr<<"Not enough Carrot."
														return
												else
													usr<<"Missing Ingredients."
													return
										else
											usr<<"Not enough Celery."
											return
									else
										usr<<"Missing Ingredients."
										return
							if("Scrambled Egg(Egg(2)")
								usr<<"Scrambled Egg - Egg(2)"
								var/list/items=list()
								for(var/obj/items/Food/Cookable/Egg/R in usr)
									items+=R.type
									if(R.type in items)
										if(R.Amount>=2)
											var/obj/items/Food/Eatable/Scrambled_Egg/SS=new
											R.Amount-=2
											if(R.Amount<=0) del(R)
											usr.contents+=SS
											if(prob(!50))
												usr.CEAdd += usr.ratingmultiplier*0.002
												usr.Chef_XP+=0.002*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
											else
												usr.Chef_XP+=0.008*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting

										else
											usr<<"Not enough Eggs."
											return
									else
										usr<<"Missing Ingredients"
										return
					if(usr.Chef_XP>=9&&usr.Chef_XP<25)
						switch(input("What type of food would you like to prepare?") in list ("Seasoned Steak(Raw Steak(1), Pepper(2))","Seasoned Leg Meat(Raw Leg Meat(1), Pepper(2))","Salad(Celery(2),Carrot(1)","Fruit Salad(Celery(1),Carrot(1),Apple(2)orBanana(2)","Scrambled Egg(Egg(2)","Pizza(Milk(1), Egg(2), Wheat(2)"))
							if("Pizza(Milk(1), Egg(2), Wheat(2)")
								usr<<"Pizza - Milk(1), Egg(2), Wheat(2)"
								var/list/items=list()
								for(var/obj/items/Food/Eatable/Milk/R in usr)
									items+=R.type
									if(R.type in items)
										if(R.Amount>=1)
											for(var/obj/items/Food/Cookable/Egg/P in usr)
												items+=P.type
												if(P.type in items)
													if(P.Amount>=2)
														for(var/obj/items/Food/Eatable/Wheat/W in usr)
															items+=W.type
															if(W.type in items)
																if(W.Amount>=2)
																	var/obj/items/Food/Cookable/Pizza/SS=new
																	R.Amount-=1
																	if(R.Amount<=0) del(R)
																	P.Amount-=2
																	if(P.Amount<=0) del(P)
																	W.Amount-=2
																	if(W.Amount<=0) del(W)
																	usr.contents+=SS
																	if(prob(!50))
																		usr.CEAdd += usr.ratingmultiplier*0.002
																		usr.Chef_XP+=0.01*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
																	else
																		usr.Chef_XP+=0.07*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
																else
																	usr<<"Not enough Wheat."
																	return
															else
																usr<<"Missing Ingredients."
																return
													else
														usr<<"Not enough Eggs."
														return
												else
													usr<<"Missing Ingredients."
													return
										else
											usr<<"Not enough Milk."
											return
									else
										usr<<"Missing Ingredients."
										return
							if("Seasoned Steak(Raw Steak(1), Pepper(2))")
								usr<<"Seasoned Steak - Raw Steak(1), Pepper(2)"
								var/list/items=list()
								for(var/obj/items/Food/Cookable/Raw_Steak/R in usr)
									items+=R.type
									if(R.type in items)
										if(R.Amount>=1)
											for(var/obj/items/Food/Cookable/Pepper/P in usr)
												items+=P.type
												if(P.type in items)
													if(P.Amount>=2)
														var/obj/items/Food/Cookable/Raw_Seasoned_Steak/SS=new
														R.Amount-=1
														if(R.Amount<=0) del(R)
														P.Amount-=2
														if(P.Amount<=0) del(P)
														usr.contents+=SS
														if(prob(!50))
															usr.CEAdd += usr.ratingmultiplier*0.002
															usr.Chef_XP+=0.01*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
														else
															usr.Chef_XP+=0.07*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting

													else
														usr<<"Not enough Pepper."
														return
												else
													usr<<"Missing Ingredients."
													return
										else
											usr<<"Not enough Steak."
											return
									else
										usr<<"Missing Ingredients."
										return
							if("Seasoned Leg Meat(Raw Leg Meat(1), Pepper(2))")
								usr<<"Seasoned Leg Meat - Raw Leg Meat(1), Pepper(2)"
								var/list/items=list()
								for(var/obj/items/Food/Cookable/Raw_Leg_Meat/R in usr)
									items+=R.type
									if(R.type in items)
										if(R.Amount>=1)
											for(var/obj/items/Food/Cookable/Pepper/P in usr)
												items+=P.type
												if(P.type in items)
													if(P.Amount>=2)
														var/obj/items/Food/Cookable/Raw_Seasoned_Leg_Meat/SS=new
														R.Amount-=1
														if(R.Amount<=0) del(R)
														P.Amount-=2
														if(P.Amount<=0) del(P)
														usr.contents+=SS
														if(prob(!50))
															usr.CEAdd += usr.ratingmultiplier*0.002
															usr.Chef_XP+=0.01*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
														else
															usr.Chef_XP+=0.07*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting

													else
														usr<<"Not enough Pepper."
														return
												else
													usr<<"Missing Ingredients."
													return
										else
											usr<<"Not enough Steak."
											return
									else
										usr<<"Missing Ingredients."
										return
							if("Salad(Celery(2),Carrot(1)")
								usr<<"Salad - Celery(2),Carrot(1)"
								var/list/items=list()
								for(var/obj/items/Food/Eatable/Celery/R in usr)
									items+=R.type
									if(R.type in items)
										if(R.Amount>=2)
											for(var/obj/items/Food/Eatable/Carrot/P in usr)
												items+=P.type
												if(P.type in items)
													if(P.Amount>=1)
														var/obj/items/Food/Eatable/Salad/SS=new
														R.Amount-=2
														if(R.Amount<=0) del(R)
														P.Amount-=1
														if(P.Amount<=0) del(P)
														usr.contents+=SS
														if(prob(!50))
															usr.CEAdd += usr.ratingmultiplier*0.002
															usr.Chef_XP+=0.02*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
														else
															usr.Chef_XP+=0.08*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting

													else
														usr<<"Not enough Carrot."
														return
												else
													usr<<"Missing Ingredients."
													return
										else
											usr<<"Not enough Celery."
											return
									else
										usr<<"Missing Ingredients."
										return
							if("Fruit Salad(Celery(1),Carrot(1),Apple(2)orBanana(2)")
								usr<<"Fruit Salad - Celery(1),Carrot(1),Apple(2) or Banana(2)"
								var/list/items=list()
								for(var/obj/items/Food/Eatable/Celery/R in usr)
									items+=R.type
									if(R.type in items)
										if(R.Amount>=1)
											for(var/obj/items/Food/Eatable/Carrot/P in usr)
												items+=P.type
												if(P.type in items)
													if(P.Amount>=1)
														for(var/obj/items/Food/Eatable/Apple/A in usr)
															items+=A.type
															if(A.type in items)
																if(A.Amount>=2)
																	for(var/obj/items/Food/Eatable/Banana/B in usr)
																		items+=B.type
																		if(B.type in items)
																			if(B.Amount>=2)
																				var/obj/items/Food/Eatable/Salad/SS=new
																				R.Amount-=1
																				if(R.Amount<=0) del(R)
																				P.Amount-=1
																				if(P.Amount<=0) del(P)
																				A.Amount-=2
																				if(A.Amount<=0) del(A)
																				B.Amount-=2
																				if(B.Amount<=0) del(B)
																				usr.contents+=SS
																				if(prob(!50))
																					usr.CEAdd += usr.ratingmultiplier*0.002
																					usr.Chef_XP+=0.02*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
																				else
																					usr.Chef_XP+=0.08*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting

																			else
																				usr<<"Not enough Bananas."
																				return
																		else
																			usr<<"Missing Ingredients."
																			return
																else
																	usr<<"Not enough Apples."
																	return
															else
																usr<<"Missing Ingredients."
																return
													else
														usr<<"Not enough Carrot."
														return
												else
													usr<<"Missing Ingredients."
													return
										else
											usr<<"Not enough Celery."
											return
									else
										usr<<"Missing Ingredients."
										return
							if("Scrambled Egg(Egg(2)")
								usr<<"Scrambled Egg - Egg(2)"
								var/list/items=list()
								for(var/obj/items/Food/Cookable/Egg/R in usr)
									items+=R.type
									if(R.type in items)
										if(R.Amount>=2)
											var/obj/items/Food/Eatable/Scrambled_Egg/SS=new
											R.Amount-=2
											if(R.Amount<=0) del(R)
											usr.contents+=SS
											if(prob(!50))
												usr.CEAdd += usr.ratingmultiplier*0.002
												usr.Chef_XP+=0.001*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting
											else
												usr.Chef_XP+=0.007*0.80*usr.ratingmultiplier*usr.CEAdd*Admin_Int_Setting

										else
											usr<<"Not enough Eggs."
											return
									else
										usr<<"Missing Ingredients"
										return


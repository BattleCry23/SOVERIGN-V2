//this essentials handles how hair overlays work, the previous version handled hair overlays as a single overlay that changed its icon and color, but this version handles each hair as a separate overlay, which allows for more customization and less issues with things like the ssj hair not updating properly when changing colors or something like that. It also allows for things like the ssj2 hair to be added without needing to change the ssj1 hair's icon or color, which is something that was an issue with the previous version. It also allows for things like the ssj3 hair to be added without needing to change the ssj1 or ssj2 hair's icon or color, which is something that was an issue with the previous version. It also allows for things like the ssj4 hair to be added without needing to change the ssj1, ssj2, or ssj3 hair's icon or color, which is something that was an issue with the previous version. It also allows for things like the lssj hair to be added without needing to change the ssj1, ssj2, ssj3, or ssj4 hair's icon or color, which is something that was an issue with the previous version. It also allows for things like the rlssj hair to be added without needing to change the ssj1, ssj2, ssj3, ssj4, or lssj hair's icon or color, which is something that was an issue with the previous version. It also allows for things like the ussj hair to be added without needing to change the ssj1, ssj2, ssj3, ssj4, lssj, or rlssj hair's icon or color, which is something that was an issue with the previous version. It also allows for things like the mastered ssj1 hair to be added without needing to change the ssj1, ssj2, ssj3, ssj4, lssj, rlssj, or ussj hair's icon or color, which is something that was an issue with the previous version.
obj/overlay/hairs
	//plane = HAIR_LAYER
	layer = HAIR_LAYER
	appearance_flags = PIXEL_SCALE
	vis_flags = VIS_INHERIT_PLANE | VIS_INHERIT_LAYER
	name = "hair"
	transform = null
	ID = 3

	normal
		density_factor = 0
		//appearance_flags = KEEP_TOGETHER
		eye_brows
			icon = 'eyebrows.dmi'
			name = "Eyebrows"
		female
			Hair1_female
				icon = 'Kale_Hair.dmi'
				name = "Hair1"
			Hair2_female
				icon = 'hair_female2.dmi'
				name = "Hair2"
			Hair3_female
				icon = 'hair_female1.dmi'
				name = "Hair3"
			Hair4_female
				icon = 'hair_04_female.dmi'
				name = "Hair4"
			Hair5_female
				icon = 'hair_long.dmi'
				name = "Hair5"
			Hair6_female
				icon = 'hair_06_female.dmi'
				name = "Hair6"
			Hair7_female
				icon = 'hair_07_female.dmi'
				name = "Hair7"
			Hair8_female
				icon = 'hair_08_female.dmi'
				name = "Hair8"
			Hair9_female
				icon = 'NewCauliflaHair.dmi'
				name ="Hair9"
			Hair10_female
				icon = 'Android17h.dmi'
				name ="Hair10"

			Hair11_female
				icon = 'Android_18.dmi'
				name ="Hair11"
		female_kid
			Hair1_female_kid
				icon = 'Kale_Hair_kid.dmi'
				name = "Hair1"
			Hair2_female_kid
				icon = 'hair_female2_kid.dmi'
				name = "Hair2"
			Hair3_female_kid
				icon = 'hair_female1_kid.dmi'
				name = "Hair3"
			Hair4_female_kid
				icon = 'hair_04_female.dmi'
				name = "Hair4"
			Hair5_female_kid
				icon = 'hair_long.dmi'
				name = "Hair5"
			Hair6_female_kid
				icon = 'hair_06_female.dmi'
				name = "Hair6"
			Hair7_female_kid
				icon = 'hair_07_female.dmi'
				name = "Hair7"
			Hair8_female_kid
				icon = 'hair_08_female.dmi'
				name = "Hair8"
			Hair9_female_kid
				icon = 'NewCauliflaHairKid.dmi'
				name ="Hair9"
			Hair10_female_kid
				icon = 'Android17hKid.dmi'
				name ="Hair10"
			Hair11_female_kid
				icon = 'Android_18_kid.dmi'
				name ="Hair11"
		male

			Hair1
				icon = 'GokuRHair.dmi'
			Hair2
				icon = 'hair_vegeta.dmi'
			Hair3
				icon = 'hair_yamcha.dmi'
			Hair4
				icon = 'UubHair.dmi'
			Hair5
				icon = 'hair_long.dmi'
			Hair6
				icon = 'hair_afro.dmi'
			Hair7
				icon = 'hair_kidd.dmi'
			Hair8
				icon = 'hair_raditz.dmi'
			Hair9
				icon = 'hair_muse.dmi'
			Hair10
				icon = 'hair_goten.dmi'
			Hair11
				icon = 'hair_short.dmi'
			Hair12
				icon = 'hair_vegetajr.dmi'
			Hair13
				icon = 'hair_strange.dmi'
			Hair13
				icon = 'hair_lan.dmi'
			Hair14
				icon = 'hair_kidgohan.dmi'
			Hair15
				icon = 'hair_trunks.dmi'
			Hair16
				icon = 'hair_futuregohan.dmi'
			Hair17
				icon = 'hair_adultgohan.dmi'
			Hair18
				icon = 'FT_Trunks_Hair.dmi'
			Hair19
				icon = 'GranolaHair.dmi'
			Hair20
				icon = 'Shallot_Hair.dmi'
			Hair21
				icon = 'TeenGohanHair (1).dmi'
			Hair22
				icon = 'YamchaGT.dmi'
			Hair23
				icon = 'YamchaS.dmi'
			Hair24
				icon = 'NewSpikeyH1.dmi'
			Hair25
				icon = 'nach_hair.dmi'
			Hair26
				icon = 'Stylish_Long_Hair.dmi'
			Hair27
				icon = 'VomiHair.dmi'


			None
		male_kid
			Hair1_kid
				name = "Hair1"
				icon = 'GokuRkidhair.dmi'
			Hair2_kid
				icon = 'hair_vegeta_kid.dmi'
			Hair3_kid
				icon = 'hair_yamcha_kid.dmi'
			Hair4_kid
				icon = 'UubHairkid.dmi'
			Hair5_kid
				icon = 'hair_long_kid.dmi'
			Hair6_kid
				icon = 'hair_afro_kid.dmi'
			Hair7_kid
				icon = 'hair_kidd_kid.dmi'
			Hair8_kid
				icon = 'hair_raditz_kid.dmi'
			Hair9_kid
				icon = 'hair_muse_kid.dmi'
			Hair10_kid
				icon = 'hair_goten_kid.dmi'
			Hair11_kid
				icon = 'hair_short_kid.dmi'
			Hair12_kid
				icon = 'hair_vegetajr_kid.dmi'
			Hair13_kid
				icon = 'hair_strange_kid.dmi'
			Hair13_kid
				icon = 'hair_lan_kid.dmi'
			Hair14_kid
				icon = 'hair_kidgohan_kid.dmi'
			Hair15_kid
				icon = 'hair_trunks_kid.dmi'
			Hair16_kid
				icon = 'hair_futuregohan_kid.dmi'
			Hair17_kid
				icon = 'hair_adultgohan_kid.dmi'
			Hair18_kid
				icon = 'FT_Trunks_Hair_Kid.dmi'
			Hair19_kid
				icon = 'GranolaKid.dmi'
			Hair20_kid
				icon = 'Shallot_Hair_Kid.dmi'
			Hair21_kid
				icon = 'KidTeenGohanHair.dmi'
			Hair22_kid
				icon = 'YamchaGTKid.dmi'
			Hair23_kid
				icon = 'YamchaSKid.dmi'
			Hair24_kid
				icon = 'NewSpikeyH1Kid.dmi'
			Hair25_kid
				icon = 'nach_hair.dmi'
				New()
					pixel_y=-5
			Hair26_kid
				icon = 'Stylish_Long_Hair_Kid.dmi'

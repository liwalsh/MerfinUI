local addonName, Private = ...
local E, L, V, P, G = unpack(ElvUI)
local L = Private.L

function Private.ImportSkada(layout)
	layout = layout or 'Normal'

	if not IsAddOnLoaded('Skada') then
		Private:Print(string.format(L['You need to enable %s.'], 'Skada'))
		return
	end

	local profileName = 'MerfinUI v' .. '(' .. layout .. ')' .. Private.Version

	SkadaDB = SkadaDB or {}
	SkadaDB.profiles = SkadaDB.profiles or {}
	SkadaDB['profiles'][profileName] = {
		['scroll'] = {
			['speed'] = 2,
			['icon'] = true,
			['button'] = 'MiddleButton',
		},
		['namedisplay'] = 1,
		['modules'] = {
			['deathlogevents'] = 15,
			['threat'] = {
				['soundfile'] = 'Fel Nova',
				['flash'] = true,
				['message'] = false,
				['notankwarnings'] = true,
				['output'] = 1,
				['shake'] = false,
				['threshold'] = 90,
				['sound'] = false,
				['frequency'] = 2,
			},
			['failschannel'] = 'AUTO',
			['deathannounce'] = false,
			['deathchannel'] = 'AUTO',
			['interruptchannel'] = 'SAY',
			['parrychannel'] = 'AUTO',
			['deathlogthreshold'] = 2000,
		},
		['prepotion'] = true,
		['windows'] = {
			{
				['barheight'] = 21,
				['barslocked'] = true,
				['modeincombat'] = 'Damage',
				['numfont'] = Private.GetProfileFont(),
				['combattimer'] = false,
				['y'] = -392,
				['barfont'] = Private.GetProfileFont(),
				['name'] = 'Main',
				['background'] = {
					['height'] = 239,
					['color'] = {
						['a'] = 0.5,
					},
				},
				['point'] = 'BOTTOMRIGHT',
				['showself'] = true,
				['barcolor'] = {
					['a'] = 0.85,
				},
				['mode'] = 'Damage',
				['childmode'] = 0,
				['spark'] = false,
				['bartexture'] = Private.GetProfileTexture(),
				['barwidth'] = 232,
				['barspacing'] = 1,
				['smoothing'] = true,
				['title'] = {
					['toolbaropacity'] = 0.9,
					['textcolor'] = {
						['b'] = 1,
						['g'] = 1,
						['r'] = 1,
					},
					['color'] = {
						['a'] = 0.7100000083446503,
						['b'] = 0,
						['g'] = 0,
						['r'] = 0,
					},
					['toolbar'] = 3,
					['font'] = Private.GetProfileFont(),
					['borderthickness'] = 0,
					['height'] = 19,
					['texture'] = Private.GetProfileTexture(),
				},
				['sticky'] = false,
				['x'] = 840,
				['enablebackground'] = true,
			}, -- [1]
			{
				['titleset'] = true,
				['barheight'] = 21,
				['color'] = {
					['a'] = 0.6,
					['b'] = 0.3,
					['g'] = 0.3,
					['r'] = 0.3,
				},
				['classicons'] = true,
				['barslocked'] = true,
				['useframe'] = true,
				['enabletitle'] = true,
				['wipemode'] = '',
				['numfont'] = Private.GetProfileFont(),
				['set'] = 'current',
				['child'] = '',
				['clamped'] = true,
				['y'] = -197,
				['barfont'] = Private.GetProfileFont(),
				['name'] = 'Healing',
				['x'] = 840,
				['display'] = 'bar',
				['showself'] = true,
				['barfontflags'] = '',
				['isusingelvuiskin'] = true,
				['numfontflags'] = '',
				['strata'] = 'LOW',
				['classcolortext'] = false,
				['spellschoolcolors'] = true,
				['barbgcolor'] = {
					['a'] = 0.6,
					['b'] = 0.3,
					['g'] = 0.3,
					['r'] = 0.3,
				},
				['barcolor'] = {
					['a'] = 0.85,
					['b'] = 0.8,
					['g'] = 0.3,
					['r'] = 0.3,
				},
				['numfontsize'] = 13,
				['barfontsize'] = 13,
				['tooltippos'] = 'NONE',
				['hideauto'] = 1,
				['title'] = {
					['textcolor'] = {
						['a'] = 1,
						['r'] = 1,
						['g'] = 1,
						['b'] = 1,
					},
					['color'] = {
						['a'] = 0.7100000083446503,
						['b'] = 0,
						['g'] = 0,
						['r'] = 0,
					},
					['bordertexture'] = 'None',
					['toolbar'] = 1,
					['height'] = 19,
					['borderinsets'] = 0,
					['font'] = Private.GetProfileFont(),
					['borderthickness'] = 0,
					['spacing'] = 1,
					['fontflags'] = '',
					['fontsize'] = 13,
					['bordercolor'] = {
						['a'] = 1,
						['b'] = 0,
						['g'] = 0,
						['r'] = 0,
					},
					['texture'] = Private.GetProfileTexture(),
				},
				['height'] = 30,
				['barorientation'] = 1,
				['mode'] = 'Absorbs and Healing',
				['buttons'] = {
					['segment'] = true,
					['menu'] = true,
					['mode'] = true,
					['report'] = true,
					['reset'] = true,
				},
				['width'] = 600,
				['specicons'] = true,
				['textcolor'] = {
					['b'] = 0.9,
					['g'] = 0.9,
					['r'] = 0.9,
				},
				['spark'] = false,
				['bartexture'] = Private.GetProfileTexture(),
				['barwidth'] = 232,
				['barspacing'] = 1,
				['enablebackground'] = true,
				['smoothing'] = true,
				['baroffset'] = 0,
				['modeincombat'] = 'Absorbs and Healing',
				['scale'] = 1,
				['classcolorbars'] = true,
				['isusingclasscolors'] = true,
				['sticky'] = false,
				['background'] = {
					['tile'] = false,
					['color'] = {
						['a'] = 0.5,
						['b'] = 0,
						['g'] = 0,
						['r'] = 0,
					},
					['bordercolor'] = {
						['a'] = 0.5,
						['b'] = 0,
						['g'] = 0,
						['r'] = 0,
					},
					['borderinsets'] = 0,
					['borderthickness'] = 1,
					['height'] = 150,
					['bordertexture'] = 'None',
					['tilesize'] = 0,
					['texture'] = 'Solid',
				},
				['combattimer'] = false,
			}, -- [2]
		},
		['report'] = {
			['channel'] = 'raid',
		},
		['combatlogfix'] = true,
		['smartwait'] = 5,
		['smartstop'] = false,
		['firsthit'] = false,
		['spamage'] = false,
		['modulesBlocked'] = {
			['Debuffs'] = true,
			['Activity'] = true,
			['Sunder Counter'] = true,
			['Absorbs'] = false,
			['Interrupts'] = true,
			['Resources'] = true,
			['CC Breakers'] = true,
			['Friendly Fire'] = true,
			['Damage Taken By Spell'] = true,
			['CC Done'] = true,
			['CC Taken'] = true,
		},
		['columns'] = {
			['Skada_Absorbs_Percent'] = false,
			['Skada_Dispels_sPercent'] = false,
			['Activity_Percent'] = true,
			['Absorbs_Percent'] = false,
			['Death log_Change'] = true,
			['Skada_Absorbs and Healing_Percent'] = false,
			['Skada_Damage_Percent'] = false,
			['Skada_Damage_Comparison_Percent'] = false,
			['Damage_Percent'] = false,
			['Skada_Healing_Percent'] = false,
			['Skada_DPS_Percent'] = false,
			['Skada_Damage_Comparison_DPS'] = true,
			['Absorbs and healing_Percent'] = false,
			['Skada_Enemy Damage Done_Percent'] = false,
			['Death log_Health'] = false,
			['Skada_Damage Taken_Percent'] = false,
			['Skada_Enemy Damage Taken_Percent'] = false,
			['Death log_Percent'] = false,
			['Skada_Deaths_Death log_Percent'] = false,
			['Skada_Threat_Percent'] = true,
			['Skada_Buffs_Percent'] = false,
		},
		['updatefrequency'] = 1.5,
		['absdamage'] = true,
		['moduleicons'] = true,
		['fofrostmourne'] = true,
	}

	local window = SkadaDB['profiles'][profileName]['windows']
	if Private.GetProfileResolution() == 'QUAD_HD' then
		for i = 1, #window do
			window[i]['barheight'] = 24
			window[i]['barwidth'] = 250
			window[i]['barfontsize'] = 14
			window[i]['numfontsize'] = 14
			window[i]['title']['fontsize'] = 14
			window[i]['title']['height'] = 21

			if i == 1 then
				window[1]['x'] = 1151
				window[1]['y'] = -566
				window[1]['background']['height'] = 245
			elseif i == 2 then
				window[2]['x'] = 1151
				window[2]['y'] = -371
				window[2]['background']['height'] = 146
			end
		end
	elseif Private.GetProfileResolution() == 'FULL_HD' then
		for i = 1, #window do
			window[i]['barheight'] = 21
			window[i]['barwidth'] = 230
			window[i]['barfontsize'] = 13
			window[i]['numfontsize'] = 13
			window[i]['title']['fontsize'] = 13
			window[i]['title']['height'] = 19

			if i == 1 then
				window[1]['x'] = 840
				window[1]['y'] = -405
				window[1]['background']['height'] = 209
			elseif i == 2 then
				window[2]['x'] = 840
				window[2]['y'] = -238
				window[2]['background']['height'] = 125
			end
		end
	end

	if layout == 'Dark' then
		local color, backdrop = Private.GetDarkThemeColors()
		for i = 1, #window do
			window[i]['classcolortext'] = true
			window[i]['classcolorbars'] = false
			window[i]['enablebackground'] = true
			window[i]['barcolor'] = window[i]['barcolor'] or {}
			window[i]['barcolor']['b'] = color.b
			window[i]['barcolor']['g'] = color.g
			window[i]['barcolor']['r'] = color.r
			window[i]['barbgcolor'] = window[i]['barbgcolor'] or {}
			window[i]['barbgcolor']['r'] = backdrop.r
			window[i]['barbgcolor']['g'] = backdrop.g
			window[i]['barbgcolor']['b'] = backdrop.b
			window[i]['barbgcolor']['a'] = backdrop.a
		end
	end

	SkadaDB['profileKeys'] = SkadaDB['profileKeys'] or {}
	SkadaDB['profileKeys'][Private.AceProfileName] = profileName

	Private:PluginInstallStepComplete(profileName)
end

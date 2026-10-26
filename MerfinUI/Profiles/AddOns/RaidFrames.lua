local addonName, Private = ...
local L = Private.L

local E = unpack(ElvUI)
local UF = E:GetModule('UnitFrames')

local ElvUiFramesVisibility = function(show)
	E.db.unitframe.units = E.db.unitframe.units or {}

	for _, unit in ipairs({ 'party', 'raid', 'raid40' }) do
		if E.db.unitframe.units[unit] then
			E.db.unitframe.units[unit].enable = show
		end
	end
end

local reso

local GetCellLayoutProfile = function(layout)
	return (layout == 'Healer-H' or layout == 'Healer-V') and 'Healer' or layout
end

local GetCellPartyScenario = function(layout)
	return (layout == 'Healer' or layout == 'Healer-H') and 'Raid10-25' or 'Party'
end

local GetLayoutName = function(layout, scenario)
	return string.format('%s: %s || %s', GetCellLayoutProfile(layout), scenario, reso)
end

function Private.ApplyCellColorTheme(theme)
	if not E:IsAddOnEnabled('Cell') then
		Private:Print(string.format(L['You need to enable %s.'], 'Cell'))
		return
	end

	CellDB = CellDB or {}
	CellDB.layouts = CellDB.layouts or {}

	local ChangeIndicatorNameColor = function(theme)
		for _, layout in pairs(CellDB.layouts) do
			if layout.indicators then
				for i = 1, #layout.indicators do
					local indicator = layout.indicators[i]
					if indicator.indicatorName == 'nameText' then
						indicator.color = theme == 'DARK' and { 'class_color', { 1, 1, 1 } } or { 'custom_color', { 1, 1, 1 } }
					elseif indicator.indicatorName == 'roleIcon' and type(indicator.roleTexture) == 'table' then
						indicator.roleTexture = theme == 'DARK'
						and {
							'mattui',
							'Interface\\AddOns\\ElvUI\\Core\\Media\\Textures\\Tank.tga',
							'Interface\\AddOns\\ElvUI\\Core\\Media\\Textures\\Healer.tga',
							'Interface\\AddOns\\ElvUI\\Core\\Media\\Textures\\DPS.tga',
						}
						or {
							'blizzard3',
							'Interface\\AddOns\\ElvUI\\Core\\Media\\Textures\\Tank.tga',
							'Interface\\AddOns\\ElvUI\\Core\\Media\\Textures\\Healer.tga',
							'Interface\\AddOns\\ElvUI\\Core\\Media\\Textures\\DPS.tga',
						}
					end
				end
			end
		end
	end

	CellDB.appearance = CellDB.appearance or {}
	CellDB.appearance.lossColor = CellDB.appearance.lossColor or {}
	CellDB.appearance.barColor = CellDB.appearance.barColor or {}

	if theme == 'NORMAL' then
		CellDB.appearance.barAlpha = 1
		CellDB.appearance.bgAlpha = 0.5
		CellDB.appearance.lossAlpha = 0.8

		CellDB.appearance.barColor[1] = 'class_color'
		CellDB.appearance.barColor[2] = { 0.8200000077486038, 0.6794286782569355, 0.6794286782569355 }

		CellDB.appearance.lossColor[1] = 'custom'
		CellDB.appearance.lossColor[2] = { 0.1899999976158142, 0.1574285924106084, 0.1574285924106084 }

		ChangeIndicatorNameColor('NORMAL')
	else
		CellDB.appearance.barAlpha = 0.8
		CellDB.appearance.bgAlpha = 0.5
		CellDB.appearance.lossAlpha = 0.8

		CellDB.appearance.barColor[1] = 'custom'
		CellDB.appearance.barColor[2] = { 0.1803921568627451, 0.1607843137254902, 0.1607843137254902 }

		CellDB.appearance.lossColor[1] = 'custom'
		CellDB.appearance.lossColor[2] = { 0.8200000077486038, 0.6794286782569355, 0.6794286782569355 }

		-- Changing color of Name
		ChangeIndicatorNameColor('DARK')
	end

	if Cell and Cell.loaded then
		Cell.Fire('UpdateAppearance', 'color')
		local currentLayout = CellDB.layouts[Cell.vars.currentLayout]
		if currentLayout and currentLayout.indicators then
			for _, indicator in ipairs(currentLayout.indicators) do
				if indicator.indicatorName == 'nameText' then
					Cell.Fire('UpdateIndicators', Cell.vars.currentLayout, 'nameText', 'color', indicator.color)
				elseif indicator.indicatorName == 'roleIcon' and type(indicator.roleTexture) == 'table' then
					Cell.Fire('UpdateIndicators', Cell.vars.currentLayout, 'roleIcon', 'roleTexture', indicator.roleTexture)
				end
			end
		end
	end
end

function Private.ApplyRaidFramePowerBar(enabled)
	if InCombatLockdown() then
		return false
	end

	for _, unit in ipairs({ 'party', 'raid', 'raid40' }) do
		local settings = E.db.unitframe.units[unit]
		if settings and settings.power then
			settings.power.enable = enabled
		end
	end
	UF:Update_AllFrames()

	if IsAddOnLoaded('Cell') and Cell and CellDB and CellDB.layouts then
		for name, layout in pairs(CellDB.layouts) do
			if name ~= 'default' and layout.main then
				layout.main.powerSize = enabled and 2 or 0
				Cell.Fire('UpdateLayout', name, 'main-power')
			end
		end
	end
	return true
end

local ImportCell = function(layout)
	if not E:IsAddOnEnabled('Cell') then
		Private:Print(string.format(L['You need to enable %s.'], 'Cell'))
		return false
	end

	reso = (Private.GetProfileResolution() == 'QUAD_HD' and 'Quad HD')
		or (Private.GetProfileResolution() == 'FULL_HD' and 'Full HD')

	local profileString = ''

	if Private.GetProfileResolution() == 'QUAD_HD' then
		profileString = '!CELL:335:ALL!T3xd8XrXvEQMb9tJKtITSSWswYrTKDmwdw2wYwYGaVkZOz0h2sAugn2obWrDpZ0J6XU10nD3JSLjqYk2L1HBVSbTGZcx2eIcjh5w29afoULqiWQLqUWU3DLfeJ4wUSlcwcWMq2ZBG9J7YY9Ev19m9mJ(yK)Gpwy(bY9uDv17vVQQx9))RRPAUtUr9rKskPlQCg94IXKcMYuqBDYjIjfwvvXmHMrVj7uD0iIMYZmQuYudQAKWmHAYPmv1goIQPP6OtyQlM0qjHPSw5IkhtCCJdOft0uYBkDrdzT1yAvr2f9ANYxWWHd2FFb6kSUFP4IPum1dhCq87C1PTEu4(usCItiQhlKyIy9lMuCejDbTYDENbf1nhxy246IJknOEcv9eMJ7XJV(ftKuWZKdPPAQKyezt5ikQrpQumOrLYqQtfPu9ijQykZurDq9YvCcZlLumIs62VWzJLWqtsXNIy0JQKWWSmDfXXvtzAmMwvyLjP3opvB4)CFo(pvkXy894)utLizSerfnv1nUNT8W6SQmMGpZX1KMisQekMnLi5uuTVpPXKuCfkQQIQUNPJQiAymm9lT7YLlTkgtsorufPbW2PLf0tlG5IZxC1KM7BMoLuu4TmJ1Pd9Fkjskj7ljK)jXcXhw64MtOzB8J0zGbchi0KYuZGprDYLZXnBATflXeyzXsDwdz1J1TUAkTbsnAeWAnPjK6HseZu2ZuAs6rLsAcDnU(2KQfiBGudP29sQFFKgQHSjzYMNEitrZugu5t2s7ry96C6hjLHzI4JtACkdAgW7ppkjFGbEeqAjJjhHAamoLEWU6QVEhiW(Cn4LUZT38vX(RRqD3tWHcNtIt4pqNyE9NB6E7SZadggsNMqlUS(hF(d4nV86puVdS)EhOBR8I)DpT6YvOUc0B3dSpx2LvFWad4hZw6uAXBx7pNkBsSrfoXOWy3BLuTm1cT5PzJ)SSkxlHpsKuWSOKq3GsrGnH1VG3nsCv9rfn7sNLuZTr2ONzIcgp1rZm(G4vRCP4XLIAMymPHT6tyZu6nEGr1mhpOExPuuKTQLw6cQfsNSI6lPAsPjJjPKy0eWKH1YtciRBiNqsjMrBS8X5IJ4L0nPN1EftJ1G3igQ6rSVRlo772eTJVsFda1OaP2IFy7gCTfNrG0Sq2VazZtnO6XK0TnctZgAeQ3U7jmPds)CLqACsnmh0m4nss6Wpsab94WmhjDJxjsphahglOFiVHc1BWqBr3V3(92nKIVWEhy)c6d6TpVqpuBKHeiHfI0taV9H3eZJG(bd0tVD2xaHidgQ3adfElyMoOqKH6bQJbS(20WWJW9S)bqLAlSAbfwFb7C)cTmWGDk0YGbcleYFOd0RFlPaLYx)bhy)z(AOqb7(abeINU7xRC7(FzDjy8byPjncoHy96PtBkZ0xUbp4WPD16(aJTRjnbNbhnPKHHRXSN0LEIwVrHHr4qkWgYZDnfLEgg9g1wPpJeNqYtJnEkOKtJJq8lok6zvMu7QiBEYqQksPRJvb1XQGE3gNqhsgtDA8cS)iLU0(IadmntLqBx9Me6oIlgv669glwWKgxFaLXoqVxFNQ6sxF)sXsiE9wfX46dlM8OB3CerTwxbfI5GLwSwwbfZ)GdHLHAFK9uxDomw9jblZPNDd119Jglf6DWBmdD(J1cFc0AWXmywYPRH(XHSL2hwdrP3bVHwLQjvgpa1T)aQMzQlWul7P(6ZOqARjei3X57uwk6rTRuF4IHq9E89cDbZRJzGEFwp5pgQIgB8wZufRfx4Iww(TQbRojP3yMbcWKP5zjI5IvdRkKOIMSi192EGABtBkt7lRAZueWhyMP2(5fHvhlvhvh5ZLUQ24ghlDvnR3rah68BncSM0rPvYXXgfoUAkr8w(WBqQD152jzxorwdP00JgzLcw1QwxOrO0mZSM3UmQ6XW2FJtZYl9RePIj1wYPs7uAvKncUU5CbEIgI6VJhRZT8LiLwcP0s5wfiQjzocH01Qa7lhcCMhCmjB)JYrKLqagLMPsBKSzFdEO2hc14lhhu85kA1Kgpl1r2Ha1GjPPSQ3X7xsiKHSOMuKOj0Hv4PDQzApt7vnapo8prYrqZLQK9x2i4mLJCYkpZ0JOa6KgUUUHhY(PRzDvTM5V7QfxZGRb5hqIHzcMOxjw5tdOLWLUX0MvhBfnzQ2KIuCZzXS7nzIrP3tGuVNBJ0W6HLZNaqCq9pxSl0vUvQK(lU2IOU2Hrnboom9mPOcFNaYPyQhlPbyicz7u)Ru8QahDLlzLP05PfW3EXyJw2t1nEgYxErAhKB3w5jtolQPOgtvDYD4qnj35IQFvayKKsAaltMLcYgrUTIqTBTXSZsMCCxRqLJC3fQcDz2gmd(RGpTYzK2LcoEFgrffh6YQWziYEAQPhonIR6idg3cHQc6SHoUs3FcdjrdyaMpfja2zOotPJFRFXrsefw1tnHb272OoRGgKnJLGEvAPx6KjG52dzoomYS7zLbtnfqDyaa7SJOlgdhb1KSOsCOn)7JgOQFlYxxMCxLGZUavtB9mqVPXndtG0nJMYugnOfUDcOiejv84g2(bk1vPOIZsCAkelgsDzSBq2JNAQbCN9kObc67GjLGUeH5uOyYTlqLmvS1yl2E64xCt0pU4GKRlBXpd1zOTo8hld(v0HuCOu4uDad9zTDsewvRByEjQlT26tLUJsI8Numt4GqQ2rtMS5ZgM6pvkg)qy3OrwlaB5SvkM19UlxSjPkkSeydiY4fQo0)WGUaeO0)qbDrBtBEEMyGH)PWvsZScbm2FwMuSV1GT1Igq8a(JMaGi3mMQQUCM2sLyBPXzJQRESyDcSqaObgOrvRwkBeYxN8d4p9Tq((KFa5rp9Vd5bipg5p90FPS7NF0C6NNVtS24txD22G6GvwrZg0zs7FBSXdMEDcDVrPo)GbeISRcbJILI5kZQzZ2FcddWRjVp7(lRH3WKRrz3IDhCum0WKzaKKT702iDc)vUBkM(2y)f7Y8NqxIksEV6GI7yGa0LfZ(M07npoYaiMfmEiXKJiHDyE92fScJi4x(qIMrTu1PqgZ8SeQw2XcYxgcDI3lfJpF)apUrOUNtBIQeKP26mHmXYJJSayV)4TJADlTcRzqbF04h9KRBPCLfjQOHPVXByujygkLddGVm6rf0n0eJcMlp1weU(DAkJnthas7tcHUmmaXmb20qxf(WPjOJl6uU6YEMo9RxE6raZ2jY9LFR9lEev26(3j06UtWIc9ntBcDXh134ibvHPGfngusVpGPlGKbJZWR7UHxn2oDFlVK7hRn3N(Q30d529uFZx(AC)lvDFAXQ4k(iU)ReDN0CPB5KN5eUF6xZ9JDC3DmAvCR7UG)309v)2U)EFrYDitEAbYFrUT9wOaEyJh)VJM3)hK)NOlWcWVw6wBIKwT2DaT2DWvmDK4PfiZwc5hdDcNCnlUkVbFjSWFHYfAaybaOdu)88DPcSfjpZgC)tgJ5R9nOkXQi35hT4v7Q8fuTGgzA3cz1s3fQswR(SuQ0TlBRoBGCgu4pfpwP)y2WPcXWm5btmscfXKrLwevz3ouL3AjmoG8rvjcBTcSeG6SHFRvGUSOwJwX25MN5qsIhvkj42wnLYk3Ym4lTsTmOCmmbk2lIA1MdlZ0AymPyU8ruLZBaZCgcya61adsMm5VOeYw859aHdYOAJ3QyOKh(WtJbHrRlkt7BtqM9X3OqHELjS8b8zQTiiR(xZ42j8PRTO5tLmHPbmTStvLuJMCvtzaR37BCKwPWm0QCiwE5MAuXJZYKr5tI0kdIRo3ojm5GKHIa98asbWZ2wANSk)B9AAWQIUwODdahMaWGBcnxfYlXnbYtBijL4YtAyhXVNc9B(kLq(zLeIQqLr2szKxuG8liR6Sy2heWJiHmRrIVts(LAvIggWrn6BEuaudZ(iqEj0A8BF4zOwNUSI7a5tjqczfoaYbYq0NCibYNwG8zScEa5ATV46SZ81lqoSa5Zkqg2rPeCCTOW8aFNGzGM7zkWoK4eWcIIkYTKul6dt(vcqtBcdjOVv0eSg)SsW2f2IFrezZVeBRw6DlAsMNzAdvf1awbFKzvW64L4MHo6i9DErzSEMLMOFjWDVSumzRkKI3XkN4cWFLpLwna)6DGlk1opcpA370zOpjvDpBjd(uxSLGWXV15bgV6apc5tWw1CRSvnjEixHmzBEinHaxA9BNEryNbvKSDCyXo48HCaGY0mPfzYUofz35e7nsR5MqB5MWEYjEGKRm3CCv5efqs7zI3h5QDC91KBj3RJi(r(nSNTYcXh5tsGv)91MJaXr8tcit6YzS5OrvddihP38dfhzFlwa4WORTSrFJ0xgCqaDEYaqDeKeqGm4RKz8A6r5I5n4254(pvbmY2EYqgYTKiGyJsILvWTisocQfjE2HYImcdD2N4tGHVIKGgjLntoswyLjhLOSpYOKKevIMvWFw)6ZepcYnKDiFi6ek(51VEhDxMzhuhskYyodBJD2Ya5739sqrpolUm1xVJQ6ezffgYnMBKsCK1Bk7qSqU5fpQkKpF2n6Valakz1q)nZkSjKjYpEjKBbs)3AXdmc53o74HqUvYVJm5KzhVdYxm7GDqUnY)obYVl5FFobZG8LG797LjYf4nCsA(3p9kGRo7vaxD2RasofkVVID8ei)biTGfDfxzpLxtEI6Ulur9Fi7Odq(QfISeCiRfnVfOc8hMvOaiFnegnQ)Yaf3h2bFVbJt(6cK7rG8neitjq(McK7f42t(wqv8TDs45)i4O4(iFhh81R2MVoO0)NKr67foVCYFuwmYj3psoMnLBHOGJmgDY(E9lm77AYri)NPuUbgKo4x9GYu)afe1AY0zpx57c8NjpKaDgvHWzM8FjlAYKhgOgt(Vkt(tfipsEeIjFpAB7rxAIUaT4cHBlWzUrG)8J76uKV8rcnyIJlPq9swoBnMsDzl5ntEISO1s(ZO9W0OwvtnfaxwYmzXEL8NtEY0Cuj)qlT5PYIsk5hLf5tY)TZfIMPH(MHzf5VCbjuzrFSYShqwz20hjKCOmsjrTkYZ8ok3qYZcTGkQyrOeUmZ4)jzObwso0alaIoK)QfHJZsk1C44qMJsTH8)M6IyjjFAlwhmpjpxo8nxDE8nxAP))kndMLw4fczQLXy)tZwYVW5QKxacUlJKF(SL8FTdjt(BOlA(Im6zK5zO5p8HjV8Tjy9H83(kKxHY)6X7M8ZGlEvCzH)rexCPL(KRL83vo5NBXLca1xk515iVHm51qu)K)EzYBEXfJh5)tgcyKZsjF9pWysW4GrPFWyOqElpK)rzY)Yzi)FLDWnPyY)pz7m)RTjHq(xLzL5FYIee5FEjz)aekP7icKns9llBekO4fJnsEBVH1ZYVftKqSNcXhsf5cgvKMSOIuGuTfxjKSViqfXc38sZfjHSncDHlCureYJkcxUmreU4Wery5zIiKptKAl6DtQiclgveHfHkYYG)DfsfbFaI5iQcgQ9kLkcvwYNBY6pmhz91wwzL9dJCb4IGg1C5ImreR9ChLscYwjNhHiJss1cx4PK4chVaCrai722McPYZNksjmQin10kLksFfvAAUiY58iNEpnxehEuwqshu)IVBt6OIcN0bNnNJAQjhe7fYtMMT5KmYq7GbAhORG0oEAN0oaEdzZ84PFTcfQxjqQHR4wq0oasVxtgb0LngpwOYVJn9r4rKEiqiguVCGIbGKaasy2TqK5ak2BEXD5wlOE)tpSLcLb8gOd5bEJcjuiBiHciwqAtTmB0Kwqc12qMOrN3(W98iy0uSFaiWfE3TAd)JStBOF7vOWq)Dnxer)LlYYlaq)GKq0Ffk0paMNn6U3XJc9NLoCCfd9tYvoO)wEOFSnr5sa9d3pBiOVmqaxEOFo3KHoG(rRXLc53XT3OG2i)CU3axgKFo34FR8yqZ2nFBROmq)QPMfg63she6Alba)vGi)ozPa4VZNGqFYkzG)YbI0YgT2Zb4GwrATXlWIAbHdYImCEOmpFL1Ihe6S3fA0GxSabDgnbicpm4Zle4W8q8H1NduCfmYpk4S7NQBvVG7dSmi(GSUc2byaWVSqQ8auz8Gl4(7cb1TCbHgl9drHHwOBCRfd43JGy)ENli0ZXX9bKiqBTDMYpc0l9gy69qrG(CCtj5mc0fFbmc0RKDzJZiqV07OMckc0RWD8KJiqFXE78S4rG(I9wSAXJanmYFXOLKdOCa9nduUf2DeBouiG5bUfrSdsnWcXke149FnHSyUqljDt(uBdiZfGydT4(xZ45svWIUIvyHDqv4nV4cw0I4somPa(t)kbR9veQzOozRqVC6TmL2hp7TjtZ7SPwA9ci5e62KzbiOS(SiOmhxrFidLp4XqzzdonnMhjewrmuoNdonfSALVdfCA5ZPGt)VbyOur2o9RyPyOqduvXuIkYEQCtxGfv2muSqxIevSKLWfqzT4mu20MUOXqbOqCUetAuVqwklhdfhOHxzmv(JLTKXdWyO0yJNNmuQRUpKHY7bzOuxDlcdLfA047jzOS(1VimuwMP7xKyOSKsDjyOuxDN3muQipgkvuGmuwAHximuwgJ9IYqzfk5fGHYYi5fLHcmYFXyOuOCgwaUjLs3cnojNaCvy7Cg79vdLAYJ3DU7xfKhKCU8GY8GvwqMdzEsm0hwtwBhMl2eASE6si)KQTp(sUGUj(ZHAYsSj()qQjFWLAI8kLAYhK3c)lZgN59fKtkpB)9LxWp(KY34fyrTep(eQSE3yp8tjNSq7tM54U007qM3DF(jxe2e)BAtNNSto)2e)VdYoXHBI37UXzoNyIK3oN5dI7w)lKmrwsVxxC3T(LNhtKYlqMi1uZ5ltKLXP9IYezfk5fGjYYi5fLjcmYFPEwj5XriZoxYARTVe8rwGNvcDh(VJVAf3B1oFwjdwCZTCvBV1HEF9dmX6JwTojKCH8XLKZpSyHcItYhUx(VW9Zk(I5pB(3v(zfN1gD6IYE5pFojVp65L8U0pR4c4e6c5wy75V6S98xDb8atyHmUPcuuF1cvul4dmjTSEh65LuF9l7w5VG(zf78yaJUj(zulwjurqfYblMB)DQNxYkFV8NZpR46R)9pBL))nkJK6Rpx88L((SNns(CQEx9zJSK(Uwcgj1x)5nJKQZJrs1fiJKLw4fcJKLXL9IYizfk5fGrYYi5fLrcmYFz(rLillN53pSf3HBjNFfXmog5(tmj)FgXxmX0TW)2vqQd)dYVd(Zi(SSZoS0NHLBWn)TovKeJyD8pwM(OjWdlvTTmL1fdQA0ZNuB6B8jU9I(w(WJBkzY3BltelHb94tQSiSZV7YMWizcnnjtJpwB6IPmv1tLuapkGzhl2(e157KEaO7lQAmPJFjNqrnQOcFx87LhpGf3E8ujJAuglXXe1nSt3QwpiKuzw3MDqQdz4glJh(CD78W417KFh8T0ARBJV5w3t6lVQwzxEtBdYytnXJh8(TZ3vx7CNxL)o3fR47Iw8w2PJsDL2xELokpu8ajL0hzCSc6SRoBR1wzvqB5i)90S9LTSZRkB5hkvsj6HVftj86ZFZLDtLvg2G3UQEIrsKuub1rQrJAV437sEx4)6A7DlzMjPYklNeaLdnU4XV1wXJpSgPAnZuQVn(r2gFKTXZoAYhxtcY9siV8QGOwsG1NCDPRMdtZtI4wzWuwkjnf8JUKzk9KS7CDnF4TzDvlPVAxh2HcrlMuYyL5OO5R2LH5Om6iMUsOlT1gSEHnaJDe1XdEVg2gFd0AVHg52YCCRvyoU1D8lD9qFI94w(OIj5JiXhhpU(5fn5Lnn1mAFh7yKeMYPIS9OQJUdqks6jLoQ6oqrTdtDjPDmQOHPK(oShPAuguNPmK4ByhWua6Gy)(UUl3(Ux(HHXR7nzcf(qskQIXoqVBTXg4nvHMMHKjyOsyyRrLH1uuRJkxEd8yRfuoDE8asCh0xce8zELmWV1goyGqH7TtV9Hn1oXd19gASSod0xFd3zWG95p4Hgy4Hc)z6la0BzDBQaWxrg8QPm5XUwE2j3p2XjRXBD27Z)BWVv2XvF787SPMTQ0U86pWWbpq4HXZH(W9m8GbcHVhgGAhAC0AwmwmEJuJokwF4HOj2kDCUUNr5Xt4AvfjXKBd7GfbBdE8IAjNHoq)9hCGH7TZGdm0WbgWRV(c4hhslQyivMTT2(4JJ)y4BYbErOdKDwwtnympuoKhtDSLQLGcfOZWEhO7d0N3qd35bgkCW(hU3b8dg0WbdXeFwI9aGytINC9IJkzWhxheGFQYBupp7uONVFjyGHJg3aq2dlostnV9DYRKiIUOUDJCGE7C)H929c2(0LgvDmjE8iRdANMP04JXKdtOWulER3hj8QXPFLE((A1tMtJmmmuiCVdcn2(dEWadhYBV(hEOaHpWGd7pqyV92x2Tr2zmmF6tO)2ZAqcALtqps1zJoSeHVGH8hi0Wd171Id1AM1h5OywvkZXWwVX0ZLfbNK5pmZQ26myFbdrDZUnE2)18nrRz8WCLzBGzm8WefOQXUe68b6RebC6WaE7h)xyKP9OQEcEOH7ouqOHpyGWddtoaHG5In(L8dUNlZJ7QgZZA9c8TE(7c)8h4IZJ7zVdpn0zZT7QNoEHx4fQt4TBUNoEKQXpvb37oTV3V8TF7FYlpUCpD8m0p)epUVVPzvL2AA)ko199f6PJ)M1S6)(B8OBSNoEPN5z3AzVyXqXVeAX54aXCFpyUsUkUsMAzRIt)wlBwuhA5YciPVrETB1G5Nu0m67P)Nz3(fQDJ3F939Fosr9Md8fUMt3th)Th4Gx(p9TcbzFaA27PJ34Zo8o)zV9NUNo(Rhw8s1)gd1thV(g2WT8zF9jH8CDlBEEiSdyxiQrpUR(5SY(p9JVXB7X(rL0thV8Z(ST9l(Qv3thV2Z)8F5g)tc6X9pYdKNwWQ8MV56EIFV7RNoE1p9H0EIF166PJNn8qNAUX(oECVTVGN16hYYlE73Ei5U)J6PJhS8pwn1F3G4F1Qw)JCTn61ZL(klxoCFMxGPy90X8V1h7tENVrB90Xto0v)CV5h7jbl6h5tK(MN9SF3F83z1Wnxh9Zm0J58qs3qkjdtmGD6Mjgvc8hx5mWkcAGFkjC9nakDeAon8CRaq8qA4HN1jObGIJRcgjZYXahCgDA26nM7lVVjty4dFV80BsHjoQ04hdM4zmpdpwVjJNYaqeqpr0PlTZcM1zQ6sQWveejiTgqznhxnNyFCGbphbnhxTUVH3yoUnclL(XNS3KWmVXaxWZXXtZnTQ0MJREitALBilQlrF1kyD4(FeFrKen3dWrVFoUZE0KWmx2H)DqW1VWSrPVAiIh44acvdHz1L0ug3(uJxqBnXHfET)kRaSJ9Dl7iLv(9x2CCvv5CCv3IOIc5Rlmn(M(Xs6NyTDcTxxU8cGKxvTfTkYg8H3fTSgYjskDK95IddWXUPnAme7fRTM0RFmOU0yjKo2wczaqGKkr36Wlh0ROY4rUQI6igheYGuSz0BzpT0KUKcE01RT2Sp3ZXJuD6(7Cb4uL2spP9Rxada1YQHM0AEA3Kx19JFC3ZpayzD)R3VFVU)IL4E((HUl3)6t6(iR1Dvp9uIPb(CYA1QuL1Q7snPjEM4geW5lzYfXWewZuSL(cEOZIN40o6DoO26Iz9gwGo4W(Ss9S2P6xkkWnqHBsr73ScHsknMKE6mecrrDan55ZQEmAhdopouJAuXGzxIEKr8sFZDGPeH9QKWJa29q7bM2(yCNogfCP(CLTxTV5ZN(cUjJNcFJcGVQPKBhlslz(ZzvtFgL71(TdYUBfmiPFRxec1AdPUsOOipvMKzkGRzIiQN(Dhbz)6MS3glAv0VKE8ejTHZGSBAEoUD4AE8TEdm8agOGLODb50TJZsxWlZ7dNJGpscwS02dhvV3dyva9BNwJeeMFuvaBdQt2tqP5U1mV5cWotxtQOAyWA)WOdWj1RVxT7ROIkc89(yVyBn85pu6lMaAnoZ4pA90pGVO7a)CNPVyAqUDdlIIdyeO1F6EORCQyW8w5027IbfA3TYXnTyueRilD8Hy1thNU86(i7(p77qB9AvM5vTuVjXZ7yAoL1QihZsFGWwEtZuzQnpGjotajDHTrhkRwAQlEMMET17zkALM5pARZEkIUJxkzTt4)(R6NxrieELr85JiAAQifsYG(cWc6BlJCjcttnhHawD6MEKRCA01zy8CDxs)ALj3T3YEkF9RAEiHg86tW3qr17L(3(fAzWd1LqddnOCl(uhsOb)djax0p9MhcVK(N9leAur9JASpz5irunLhwUSzOV5C8Mm2GWO(9jtDQnmdzf0REjRUSPs)g)iThJ7UkUk(xRIBDbG))XC)C)c4FKDFFFe33xDUFGB29Npg5hc5CdLra1pZ7KL0LUSiXvehtvp0XGjYYKh4GF(lJWDzvXDh)LTfIcLZ1KGJJyul2gi7FsRt1(E9lywrx(BClvX9yNST540Cnh3na3FooDziPWysfNjPxERqv(ixDozKWfhY71HP(rDw8F1RIjvQZK((BatQKSs6XXKwvwf8EZrUvX9O1MJqV0gbv5rFZCs93mDRoR0fEYk2cHdAKpOrEnY3UXCe2LEfTvf3mJMNIoJyEA1mxxovxSvhNWnwvCp0pmpRXt8iz3ofQI77(65Pnp0JKNn7X3rEQYtC)ysRoRCT3C0UDJDQp0QZtcF3)LCYOjAjFSXYjJ3rJL9KEWE7CnX3lwVZCQ8R3xm76vWkgwiWi6C7XUK2wBeU1oc3A1Pt7j3d77uxpS0AJ8nABT6UyP1YAJWs7EZKp4UCKPGV7kD90g5BY(U19PfL0D2YAEg7s73txLPTgfrdZdclKGl6HWy2Q8neKpcIzWqYN(U2vR5ceOp8vW4eXtOBygkvs5))d'
	elseif Private.GetProfileResolution() == 'FULL_HD' then
		profileString = '!CELL:335:ALL!T33c4Xr1vAQIg9P2TdylllKLTvuzzJWDJFjzlzSaJs)spSLuRTvB7Wdhvv3D1Qk7svvuv1YwMhjrK4qyNntqdXjKHzcOKzwydB2GGHziecefczGKz2RviGyhimwqiaBEmJ3e25vcZ5CRQR(HE7haM4(dAv9TU3Z5Cp3Z9Cp)N66BXCBvP3NGIGoV8ZRNIpPqK0MCAlxukPqmvvztjnJ2vcQ2FCEtXX6xqjD3QgsMsQkJyQQ1BCvtt1(1wQPDvZCZRDKarIflsNDeULy6HesXNw2upwKUXFZuTwP8YhIFqJ9OLK3uWFADEdXXtPZ3Vq36sQ6sMd6ZxGo5Lu48nCpAQMYs9jAkQvbkubKLoYr41tgLxkzN8k89jOZPvAU3PBEDZb5gYuNxXqwYumUSAIdkKuuB5PnecklKUnbEztrlMRlQT0cjl3Kck8XLD6)CNmPKHMGCaz(ehuwYW0JUm)GQPnngqB1iXe0BIfByDBzJ13a7nDtSTKwwMTTqhBejLKsj4nv1nUNAFeDlYMKlG5GAcdfpTKS5gLugH2Z7qyabzxrtOkRQ7B0eY8gg9s)rtUC5AytHdBUpPKMI(grtqpHGIj0X7(c3YM2EdbsPQyURXckaS0wtxLomiklPiigqbi9WDbFXgdiXqAzgFIhmCxXchDyrQUiaVo5Yyyg3rCXwme2wSvN0qu9qTQRMwRR09hhvzLnGGOuczbSAzgY9vpm(Y8xsQKByS(XK6hgziRENK1SlsnvqwRyCA3X4y6rAPLoAVRW7Yf2bQBhwF7Ai)bdgU7yHdTlAb17Y(p17VLDxqvJ2ABr6jwHTpu4GizdnLYJ2Ex7U9UA1MUwAnxUI2s42BTRD5kdF07oCxHWQ5usGqH9xi1i12uCltBMaYcPmjEhXWK3mTbQOMe74baJK(aLLssrY6gTh6nPkFYkjR6OKkfPkKYd0LQIaOFkMu71s2y84PHjskWGGCrajTgvWgfpLQE)8MTOBvuDnsQY3yjsBaZ6YAEq8RvQqQucjmLgqOxBdeRjfTNkC)AMdgrhnjfTPs9TauHe0QPbuabz4KcYs9lbZhwgljS4Oy98h3qvpUrJ21LHH4N0kPTLTrDdrjb5KzUdJRm35YHoS1KlNo8JGDy4Vyh1HNufa5Q5iRBKUvpKGUvTR9Ah1sZgT9wBlgPzsNmLq8oSgwdAf8hxHA)rcZPNcM7iOB86XBBpODmN((8hnA7rIwREi)D6VvOKaX831U5IgnsR7jmxaSmo99gUT2d2ryU4DhT9W9eRwspCXBlS)oqc0T)o8dJ)ncLrIXrUgUrHH)yTT7UqPPwRsrU0rKG7MR(U6oix9Dhogx0qr3t7HY2QaDgPRDN9NX7PnqE6I2(RHlvgTX60knJIsuxamBa1jXl4kYAG3PSHnH5zhurWWW1iMoLUsFO14wByxWGIRbGzCwA4YPMsGIBJmxvrogMTNaSRCmeXFfWq6ic(QU6J50Yftw3WrvLfO3gPYIaQSiye37q6qXyPJIxGddP1f2vCWK0mTK2wBxbgfsXNq469NmzefJRpS8a7P9RpOQUW13Pqsj(R3UjgxFmELdUjZ(41Ayb0ilVR0Mv)cOzH6UhSnJIZacX3pDrcIOVYl3rzTUr7qawStp)ESR7g1BY07G3ym6ui7L)qkSkRzW2knOzDI2PlQdSzjO1YwDB1ek11kxvrEWWuF)DPAMl5wZAYo69ma5cGRpcu8qLdQ(j1b5yWGIcjoOfr1wAuSewArwcosIJMZWOJbamZzsnyvkbDCHj72Vm8AAdzxV1n9gLxwtKN6tC7a1QQQc6FuQ9lkcjNjpeOG5mqoRB6LCt5qQbCi1sYZMAe((ahKWkUkhKSUX9J)GD9XXF6fAxfvKvN4cBxjo2IwTdwRADJMPv86yB8UiNzwRge1rTQOQommsw3KzQl93Ejjl(y50hRc83Z4c8e1d1Pgls(A)CKskHuYIywmtCrbm4JfboIS86b3xRmCaThWxFKbeY4mumlr9swxGU3xt9Gc)LH2h3urlH49Kuhz7declonIn9gStbUOgI8AcXtiPdlQI9hVz9umQF1WS48ajL(ivb(pzihTCujQkyx6ZpAFYGSOHRcB4JC10f62rdz)ERWQOGRZIrxein9clxCyyYKcVCqigNKQhsXyCCTl)ksWmBGmCK1472j1ugSS9qWY6upYf7cDEBxkPZIxDruN5GDqyBIX6qnORhnJB8Jv8IhfcQdJzbj946OcDJMQBex)CmKTHGiaXBjIDAyA6AFEYNFg6hK7iNEXYskKsqXaw0llJ)tSfDmIdYD6iZvuGmxwOmnnpHMCiC23gkAXKV44O4HIjvEj3LTWvP3zt4wKJWngVS8cwQUKmAsd2lN1rcnCC0aZc(IK7MklO7JkR8rCMQunP7u2XPkJEAO2v6HKme4nadmiyfiWZObtRJ)Qt((KsaRcQkzaJ1dlbtH7XCqW0RvY6W2aejhMUOXfbvani8yqGRJ3NoFsC4CJI8YPiE1tA3GVi5lrfQ3g1u3rj4Slq00QWkSxNONHjo6MjsBkI9dO1cXtNk18vfbGjSQUTJHsCTiuLmknKtR41fjFfCGc8v7BTR91rfeAZ4LCxCXTCbumvJ9)u0IFLNHFT18V8MPFCXafxz(8DmQVUCyooX(YqVsJQd3jZnar5KzCoetvRvyEjklRDTpTZaLa5BagkqqqzMjz3xjR7KXOorfsY2dokAKNttB3VcjTUN10vzzRFXrnlqDFwVqvJol62fe1k9lAqxvJ8BDtAXhWWpnUKA2fnwmX74wSjZT6UX61Gy9HWzntQQQlc)sJ7PZjIJVrXqBsOREOKbbyiqmcgOwvB1u4iKVc57WE8BL8TjFhYJD8pd5BsECYFZX)C5pc)yfmcpzqKASoKlJsOAyrwSxcdM3Li1h5EDwmx3FcQZpWCI36QOGjPqsxzxnR8CSNHzN9lzyaUodqh1w34DA9t2a2JIFj6A9zvMcW6e4K8RyBuCanA9noMfssxGYsw)6GGNNPXKjZCt69MeTmaKzrsfLxPpbCgSF)TaRSWd()2hVzcBp(JGiIzTkOsXJMnMXlbJHI1pnmF2obux9rDB6OIWOg0wUjujR6KtvGyV)WnHsD9nalGaZmbf4fDBlFMDLDxIrrXY4TCxZBKClUV1x19J3O7JFLR9HD7EKV6RDvU)1QUpo)kyk(aU)h4DRyctFPW(GWmtCqoDdn(eG(03QlcxV3bwzDJald1TGEha20ftNzcomx8qiJqplbWjrXtWBygyWA6xWA(zP57pG(ZlZXAz8Gisz213j)buH12bnXDcAI7K6O8lnQjyoCWadIWuT8xswzu0zNXS3ZjpZrC)SVP7h)WUBU)vWS87c(Ft3x574(B9zj)jIKNLJ8dlSJvp5VReA)H617VN8)MqC6alj)oWsY3C3PdiPy3b2b0b2btXuRWXTcBfg))XV9SkXixJB5kLSYayF0scEMv6ELFkhFRLLVOuWc5JTpb(dkOaUFutlN1RqED0TIDF7fFUTLoNIeOiwj5fSeL1nkDzh2wub8ROG9tgy(jyahNEHzBO(5uuygg7KamAfQoQ7x90uuA40ru2RuFsY8kjOIYtZEAkknMJOmQgMmml)9yiLtAatf6bG)53aZVMi5hwcP2a(3tSiw4SXBvm0Y9V)jHqRJKnQnFJaRAlDeWPmVSyG(H2(6dzpj)AwDrdH4K6rqoLyMc)ORUOjtRizAaZ2dQkNUFLfpIbSUFGbrCMCXHElqqYIgPF(dBDFJshgHygbxHUjsmY1q6bMc8ZgdZLIwpwuLXMgxlmSjsQTjYo(fx8tvg5vzar(zegLw1wOzg425WpIIIdBKjbIpTw5yVhCfJEF7h6zwkboYpVeYBwsuQ465KyxPBiwfbeQTGonSVta6ApKFb4L9loeeYVjOOLjVkQO(07FmQIRf78rq(VWrIANTaYE4i7LJSpoYh1g)p5AZMzaY1LPAxphz)CKpghP3CUlxoxZB386v0sqtOYpVKHmeGHwEtqn8MLKr4obghWBt()XLr2QxtW85XFt7HJAOkRAHdnPiuLXOghofaTgiY40cdja(XfXsrcwRhAqoo1ejT2kbq2BgxqQjwAgxZnVNKvCp1(i5GIJU6dA0wTpcRv(FQIgkc5sTwWC9wlys8rUCrYg8bM0yIejBYjbIRcR(MpgzlfMpU6kiDHK6lSgBTWc2wHf0qbPgK0y2Kas2EoxFftnBGGRA9dK2Wuk1GG8FLKRc7v7m)C9HP6YorF0qdWC8r(ieyT)anMtM4iHiHfjTKBY5OPvdZihP9PMhoYUMUmWr298iVBKoYgoeayM0f0(iKWCKUp7AbNfwljoW2eKKUicZV0zrsbnQpAGF5L4kIuEXjtoa5G7Iit6NOqujACzYeHDKIKBiBYEEaKQ6edSovx9mMyhIj0S0KbMUe2yHxCNiFpmuRbPI3mLqgYrGQCJ5KIK1U2zmBlKBgQ7TmBPtHYzAp(Jdv9tKF6TkiZjKpjuLHMAIsi3ku(NAgYic5tNBIqihfcBM8zi3w(j6G8zZplhKBN8FLJ8hr(VvqwmiFUCYDb5pE(bWNmSZsHLN)sHLNFKlKVakfhZkzd0aNYaxVIlDEYQV88eak5pn)0eydhFHKAaYF28Lx)5ZeYFVEZh5p5RWrUhoY9YrgHJ8v5iFnoYFbcMN8xMlSN)7K7d4(9pda1j)pSqKt(6ZxX7bkafoIPEMWEJifZf2DLtpS7QkGf)VYdqfGGezZdI8OU6YdtDXzWuxrEyQjJMV3HhI8Wzalt9JmNGLj)v5HpM8iaMyYFTi5VrK8Otbjm5Br7Cp2SJWfWdpFa1cGL9caNFcxhJ85pq0ULoSGm1dzPwl(Sixz486iF38a3sEs6im1MCEbILmw(A5Vh5PCaNs((2sZtNhwuYpipuNK)2tfeMKNz(JUmhyxKFe5VZc94INkARQY3KTQ8HlsoEbqeTqy51lIW6mdOqYZnlybNd3y)KPf)3Qw18d)h55ZcQiFCFZbBNipKeKx0bJNxVluSmK)pfGSBwzDbyyi)doqxof48lvaqUfeNF5tho)tla32cIZVsoCM8psxX8ew4YitAfh)(3p518r(zIKx)1j)8vxe5nGy(H)8wlM8)LgYo5xwk5xLfY0Bt(1mK)jk8Of9CvE9l3cE0dFXQK)5BhreHFiN8PDGfq(nEi)2cH5auXgdb5))z3qcj)l2qAi)RZkwgY)wwKmK)DoSx9FWHQkS2)Umavi)E0R3TUtafjDRqGqrwZCafPARqINVqrQaR(7tHIe16HvCUnqe2ZraICPx6ceisopAZzeisfvCQbej7Q3zaImZpz4PaezwESVtpqeUP7566aezMFeUVhceH7mdqK5iK4Pfic3Cco4mhqKfeVwyarMbqpZnsKHIBV76EFbGextpGK5G05aePK8bISXno9arQ8dKarMGH5CpuiLn7b2)S5IcbcWpFGip7B6a)Gz6rFmFEU1w7KjJSWpkHQEOrqMje)5r4FLqJ(RK5tWF7OJs)uvAf8xSYUvm4p7pFqi4VIPb)XnDb)9P3VwL5URC32wM3PM2kQRSjCE2dku8CK8ttA68zM(9NbeM7gs8mDaHhkZ(i0jGqAoUplfqO4ChqO4hmZm9fLVF)lA(Mz6lQ83FMzAXtVmtxE5NRNz6sN(mtx(8oZ0vw58z3EnlbewE5NJeq4mT9QGy)WWbxa7JQ37sb98mRU)OzjRUloFJXfpVYQ7swY8jNZNAji)5MLeKpDBhP5mb5Z3TG0mNc65Wn5mMc6Yk70of0ZkRN5uqxE5N2PGEbX5x(0HZfMc6feNFLC48zKuq)ZYbfso7qND(bjqiIuqiIZmiKvKbeY7cBpMkFFm8Jjyk684po3DNXml)tEAbUZyU0l987mMZVZyo)oJ587mMZJ)48BbMtHTaZ7UBgLx89STesUBdM3922pV8PZ2(50AZ3CwDlW8Av9Tl)pi3cmARk7o0)u)5Gu15FoiNhhYz7NdsPL(U5ZbH(Wno)Zb5mmoK5ijONZ9Cq4EV)5GuE5Nt)CqQQQtZNdsfvC(ngZ5F2iVl(SrM9)TMpdiNQOIt3NnYCOJoB(SrMvwpZ4sof4CHiewqC(LpD4CHyXwqC(vYHZNsytkzMF2iLSOUlU(g3XMUcl8j37Fy98r(W5dpzkhEINbrOK)23)8iu(dEekfC439E7w3FQiuoBU19fp3BR7FgcHY0T6(8bHsPv9(fekfFMeHs1vFU(tkPIPhHYQM3iuMPZLRYNViuYn(9ZJq5dep9KP7q3zoXay)8jo7)0tMdFytpCkiY1ttekZbBNrekRAvN2iuMvwpZiuof4CHiuwqC(LpD4CHiuwqC(vYHZNTqOSvBekTMbHYheEakZfcLtADEQ5CWv2KB2J6(e3O7tCtJexQp7J8rp69lHNAQA1oI9fDRA02hrB0B8jVJI(lcGNMuIKVvTdLuYGE6j5jU1P3TNHmuK00emnU4g15tBQQNwHdpJFTorSdWRZgKEEPhiHAsHdFbhrwnbVmBlS7KfpBf3uQ0kjm8yv4a86gzk3MQ7fkYJ9TTo31HkCJEyHpx3w2pE9wy3mB9n0WgyRRHT7C5oAW6YBEdqf34gzXty)MyBPLTSLDek4wTA(wPnV(TKtRUImxEf50EO5Hve07BqKabBjyJn0GfbASa(V96YCz9Bzh5Z)OPveONVwwcH)aHQZZn7Xd2H3KQUuFsk8YOmsvAu9f7oN17c)xlBQvbZSf5XtbfachQCXt9S1JNjyEPsTLQuFdS9Tb24BG16ujFqnbO2Zc)McbsyZbRXKRZHm7NwhPu2vWuuqHwc(rxWmTUI1DUU62)gSVQENR26(ZrGOntqjPNCA6ufBpyn8qTyArsxy91y)UyaSD41XJIUA2aBnuQxJxMANGzzCtWS8dFHvaJjzSBztWRWgxGnfEw3ZYBYkAAQz00M3CFsMIPJVPeQ9VzGlc6kchuDZiR2SPUGWM7N3WuqFZzSun8a0mTHaBnBgMcqnIdf46USm39Y2pyVUtfjz2OcYQ8j3t7R3BnSMQqxZqWeuusgzKipiLsyFM7YAGhOTGWPZINgIBM(wGGn77Jb21xZEdhnw7b93b2vdIhR7141tWWD0rVbJePJqr2xx92tSRPJWWOL9TPmaFhzWQM2KfhAzTo3(Xbornw7tEF2RMD9wNu9nXULnwNnrBXFOW9gzpX6fpW5J1wVDhok(oyaOo05OuMpzswJ093psp8qQe7L5CSTNv4XZYAvzbELnGdW8GUbpzrT5tp7PZoJ0vVThmsx90B4U8hOJWHqtAEzdbpz01zo94ype(sLGLhgaToORPkmlpu5WplXjdxTzu0WbJ5VRw3th(J2BW90tSiD2B7DfcuOXIe1I95X29aSvbpm757xWGnLoWGquH3ynSwNr7SDkagg5056cQEm((2yDBAlSYsX151Z0j7Q9G7oM)wN2(NUq)QdiWINyDq)0mTgBsl(yXuyQfR9RRew1u0FspBFThjlOtgdmfI1E3qNTZi7nCVr93EOE7jCS90DVHchZF7DKFF068fM15q7VP8msqTSe90s3Y6WMfbIenu4O92t7xlAQvN1yuonZMOwogw)n6mxMhCsovZmBQfmshrIsDZUbwR)RUBMsz8qA1s3aZyyHjkaPXHe68b6BhbC6qx(7e)lyzMXQQTi7R3wJgb64DhowVWKdGjyTSSFjFN75s85Efd4Bz(bWyV4DHF(sUy85E870xnbRRjxT18l9sVu1CVtDT18Jwj(zfW9(czU3V(DENFYRnOyBn)JPF(j(CFFJArkTL20LFS77t0wZ)JlDj)t34bRQTMF1F8ZTEpNOyO5xaT5mmaBUVhSqoVcMsgzojXXF75SkQ9mxvb409oL(TAKPwuISY7X)xTU9lT6QEG18L)Ei(1Bj8N4QoEBn)Z2ZEVSF6BhfQEx0Q3wZ)QpwVB5N)oF02A(v6L)c1V3EAR53ALR8w)yV1WqDUU5SopmoaSvmWrFUR8fSR(p9dx1T)4)GsAR5x75EUg)L3DLT18B(IV4N373iIp3)aFqDQhj5TClv)K)X3xBn)gF09P9K)ML3wZpxSEo2edC)(CVHpHVLfcQYjUJ7iQyRF92A(bl9Ix1A(Ya7FJvuXJETE977cF95QgUF(xYsWAR5jF7l(J8f(vn2wZpvpx5l8BV4Nc0OFOl15MN8Kp0ZC)lbU5YPFgJEcNhv4gslyyIqt1nL6xa8hx(yWkcAGFkbC9niU640AA47OqW4r1WJpRJqZkfdtzwOmlfZMWlOtRw7jDFzDmSKra8LYt7kCdDqHbpemXZysR4XAxjvAdiIG4yqF0ktEHvCbL5IE2PtxQNsBKxtWSQJSlgqHxaJMGz1UVHF1emvblL(HhUDfyM3aGl4jyyHIPutBcM1qBPwPgI86c0x0c2NR)hiqCbEZTdG07KH5KhubM5AD2FhbC9ZnEc6RjIuHpmeNQb346cAYdM54NNtBPPGfEZ8tRgyDOTBRhpkM7NVUNjywr5tWuz98YYGIDu8LoKn3pYY8d9pxU8dXjVOvx0IrvQHOKIWb2LlgmDhBJ2BHlAa6RbWwQTuN1p6wxyajHdvBudieibx62ND5GCLqeplwLv7ZyVqfesoME9BV(nQliJNA9All)Z8C80uNMeJPbxLJME4mVzdmGOww6Z6M8gUFId7EYUaDS7F3Ud539NTe3t2jm(5(3DBUpWYCVINDcML4zeENaFUTvRvUQvVUfvft8eXnceNVGjtCdtynt(67iY(ojEKvNZOZE1wEs7xIbuJHmhvQNmtPHesaydKzgMpZRyHOkcdiOpzEnZOjmp8OLevvIzRPehsefJZApAI6X7Zp9L2bwLjy2SRrZCMTtTcbNOVGNDQ9vFrNlygovA8Lra(MLsSjSz1N9RtQ6CGK7pZRcKT1aOcCE1wefLtdHwKKLfhjBX(4OweJfNx351gb5Q1nTEhSOvwNc6PKuYeadINPU452sQvZWYQggwsgmAbomERDQDFfvurGFWh)enwZhFFoxCs66FzFZ4Ca8PyyLVTTZq7uBh0AGWVfBddUHajlxs)dQG(b8KCN4NVGZfzF9gGd2UMeFj8aMSGXl2NAIt0rCNSFvi6juhKzkpT8ggfkTvyru0GHJ2NCgHUIrscZBfD0(fdvFBnWWmkFcmwrRYXhSvBnF8sR(dTTV79t5Kw5zFfm1UcEMdtRPOwzfOh6ay2CRlgjl18bDNSzP0fQLYry1CGU4Bu612VLPOen7xAlpZue9CEfG1ezJ3nZVWtum8kJutgN30uwiQGb9DbgOh9qUaUrPQJOaQoDtFILpk6pngEmTlOFTIK72VNNoqNQM7JRg)b4c0tc92PF3jx9buHc7PB8IE4Qjup4fDsV5(4QV791c(7DZfTFE9dASlrX4Xvnf7v0Zy03Io(vs2nmhyxwo161kYkWU4cGP(oVerOEm(YRGPSF)kywEy4)FC3VWVe(JO777d5((Q2938wC)XtIEliFFOMR0dbe)SVfwOT2dE74PK5hqvp6HG5TIKV5E)4xcH5swbZD(JAmknuoxddooss1yRKC1dBFi13EioZYA51wpuZh9kBCcgnxtWCdW9NGrxmK3AxbZJhdlT4SLcfDBfuXl0l08h73wqPeMuqDVoS0lk3M)BEdSOfLBrF7vIfvsEf9eyrlo3IESvxahaA91kq6(Ko968Qk3tvwTx4L34kygJFkDNXUUPq2X6Va5HWaQIh0ykv8D8wa5sUKuBdvBp0)2u4ZdVKcA(xJwXtKFf5aUFScQOjQFF8bkO070RNNYhoUnvf)aa3((trX)KpA(QuGvp0BnLU0d)Otz45j28ugEEIDoL(3t(ayrljBr2zYcdmIo3EGlOXLfNzz9XSmD60EY9y9BQRhRYAKCVqz0RSkV(LP7ImcuMlN21i5RLTDnUmDgYx16(2)M2msR5ZRjTqxM5D1LhTLkZByUxyzfCvqmmM1lEdryJJXmyieqFRBTHcdeOd8DW4qPK0nmJMwr8)8'					
	end

	local profileName = 'MerfinUI (' .. Private.ScreenHeight .. ') v' .. Private.Version

	Private.ApplyCellColorTheme('DARK')
	Cell.ImportProfile(profileString, profileName)

	-- Layout Auto Switch
	CellCharacterDB = CellCharacterDB or {}
	CellCharacterDB['layoutAutoSwitch'] = {
		[1] = {
			['battleground40'] = GetLayoutName(layout, 'Raid40'),
			['party'] = GetLayoutName(layout, GetCellPartyScenario(layout)),
			['solo'] = 'hide',
			['battleground15'] = GetLayoutName(layout, 'Raid10-25'),
			['raid25'] = GetLayoutName(layout, 'Raid10-25'),
			['arena'] = GetLayoutName(layout, 'Party'),
			['raid10'] = GetLayoutName(layout, 'Raid10-25'),
			['raid_outdoor'] = GetLayoutName(layout, 'Raid40'),
		},
		[2] = {
			['battleground40'] = GetLayoutName(layout, 'Raid40'),
			['party'] = GetLayoutName(layout, GetCellPartyScenario(layout)),
			['solo'] = 'hide',
			['battleground15'] = GetLayoutName(layout, 'Raid10-25'),
			['raid25'] = GetLayoutName(layout, 'Raid10-25'),
			['arena'] = GetLayoutName(layout, 'Party'),
			['raid10'] = GetLayoutName(layout, 'Raid10-25'),
			['raid_outdoor'] = GetLayoutName(layout, 'Raid40'),
		},
	}
	-- trackByName for Class (Major)
	local layouts = {
		GetLayoutName('DPS/Tank', 'Raid40'),
		GetLayoutName('DPS/Tank', 'Party'),
		GetLayoutName('DPS/Tank', 'Raid10-25'),
		GetLayoutName('Healer', 'Party'),
		GetLayoutName('Healer', 'Raid40'),
		GetLayoutName('Healer', 'Raid10-25'),
	}
	for _, layoutz in ipairs(layouts) do
		if CellDB.layouts[layoutz] then
			local layoutOpt = CellDB.layouts[layoutz]
			for _, options in ipairs(layoutOpt.indicators) do
				if options.name == 'Class (Major)' then
					options.trackByName = true
				end
			end
		end
	end

	if Cell.funcs and Cell.vars.layoutGroupType then
		Cell.funcs.UpdateLayout(Cell.vars.layoutGroupType)
	end

	return true
end

function Private.ApplyRaidFrameAddOnSelection(frames)
	if frames == 'Cell' then
		DisableAddOn('Clique')
	elseif frames == 'ElvUI' then
		DisableAddOn('Cell')
		EnableAddOn('Clique')
	end
end

function Private.ImportRaidFrames(frames, layout, deferSelection)
	if frames == 'Cell' and not ImportCell(layout) then
		return false
	end

	ElvUiFramesVisibility(frames == 'ElvUI')
	UF:Update_AllFrames()

	if not deferSelection then
		Private.ApplyRaidFrameAddOnSelection(frames)
	end

	Private:PluginInstallStepComplete(frames)
	return true
end
local addonName, Private = ...
local E = unpack(ElvUI)
local L = Private.L

local profileName = string.format('%s - %s', UnitName('player'), GetRealmName('player'))

function Private.LoadPlugins()
	local plugins = {
		['AddOnSkins'] = IsAddOnLoaded('ElvUI_AddOnSkins'),
	}

	if plugins['AddOnSkins'] then
		E.db.addOnSkins.dbmTemplate = 'Transparent'
		E.db.addOnSkins.dbmFontOutline = 'NONE'
		E.db.addOnSkins.dbmFont = Private.GetProfileFont()
		E.db.addOnSkins.skadaTitleTemplate = 'Transparent'
		E.db.addOnSkins.skadaTemplate = 'Transparent'
		E.db.addOnSkins.omenTemplateGloss = true
		E.db.addOnSkins.embed.rightWindow = 'Omen'
		E.db.addOnSkins.embed.leftWindow = 'Skada'
		E.db.addOnSkins.skadaTemplateGloss = true

		if Private.GetProfileResolution() == 'QUAD_HD' then
			E.db.addOnSkins.dbmBarHeight = 27
			E.db.addOnSkins.dbmFontSize = 12
			E.db.addOnSkins.embed.leftWindowWidth = 190
		elseif Private.GetProfileResolution() == 'FULL_HD' then
			E.db.addOnSkins.dbmBarHeight = 27
			E.db.addOnSkins.dbmFontSize = 12
			E.db.addOnSkins.embed.leftWindowWidth = 190
		end
	end

	local chat_error_msg = false
	for pluginName, enabled in pairs(plugins) do
		if not enabled then
			if not chat_error_msg then
				chat_error_msg = string.format(L["Couldn't find next plugins: |cff00c3ff%s|r"], pluginName)
			else
				chat_error_msg = string.format('%s, |cff00c3ff%s|r', chat_error_msg, pluginName)
			end
		end
	end

	if chat_error_msg then
		chat_error_msg = string.format(
			L['%s. Please, download and enable them in-game. After that re-install the layout again to get all the features!'],
			chat_error_msg
		)
		DEFAULT_CHAT_FRAME:AddMessage(L['|cffff0000MerfinUI Installation:|r'])
		DEFAULT_CHAT_FRAME:AddMessage(chat_error_msg)
	end
end

local addonName, Private = ...
local stformat = string.format

local E = unpack(ElvUI)
local L = Private.L
local ACH = E.Libs.ACH
local optionsFrameWidth = 1150
local optionsFrameHeight = 800
local optionsFrameHorizontalMargin = 50
local optionsFrameVerticalMargin = 50
local optionsFrameResizeHooked
local linksMediaPath = 'Interface\\AddOns\\' .. addonName .. '\\Media\\Icons\\Links\\'
local linksWidgetData = {
	socials = {
		heading = Private.L['Socials'],
		links = {
			{
				name = 'Discord',
				icon = linksMediaPath .. 'discord',
				url = 'https://discord.gg/merfin',
			},
			{
				name = 'Patreon',
				badge = Private.L['SUB CONTENT'],
				badgeFontSize = 9,
				icon = linksMediaPath .. 'patreon',
				url = 'https://patreon.com/MerfinUI',
			},
			{
				name = 'Twitch',
				icon = linksMediaPath .. 'twitch',
				url = 'https://twitch.tv/merfin',
			},
			{
				name = 'Boosty',
				badge = Private.L['SUB CONTENT'],
				badgeFontSize = 9,
				icon = linksMediaPath .. 'boosty',
				url = 'https://boosty.to/merfin',
			},
		},
	},
	addons = {
		heading = Private.L['AddOns'],
		links = {
			{
				name = 'MerfinUI',
				badge = Private.L['SUB CONTENT'],
				icon = linksMediaPath .. 'merfinui',
				url = 'https://discord.gg/merfin',
				spinOnHover = true,
				spinInterval = 0.7,
			},
			{
				name = 'MerfinPlus',
				icon = linksMediaPath .. 'merfinui',
				url = 'https://www.curseforge.com/wow/addons/merfinplus',
				spinOnHover = true,
				spinInterval = 0.7,
			},
		},
	},
	weakAuras = {
		heading = 'WeakAuras',
		title = Private.L['WeakAuras Package'],
		description = Private.L['Class Auras, General Auras, Raid Packs, and more.'],
		badge = Private.L['SUB CONTENT'],
		icon = linksMediaPath .. 'weakauras',
	},
}

local function ensureOptionsFrameSize(rootFrame)
	local frame = rootFrame and rootFrame.frame
	local uiParent = E.UIParent or UIParent

	if not frame or not uiParent then
		return
	end

	local uiWidth, uiHeight = uiParent:GetWidth(), uiParent:GetHeight()
	local currentWidth, currentHeight = frame:GetWidth(), frame:GetHeight()
	local targetWidth = math.min(optionsFrameWidth, uiWidth - (optionsFrameHorizontalMargin * 2))
	local targetHeight = math.min(optionsFrameHeight, uiHeight - (optionsFrameVerticalMargin * 2))
	local newWidth = math.max(currentWidth or 0, targetWidth)
	local newHeight = math.max(currentHeight or 0, targetHeight)

	if newWidth == currentWidth and newHeight == currentHeight then
		return
	end

	if rootFrame.status and rootFrame.ApplyStatus then
		rootFrame.status.width = newWidth
		rootFrame.status.height = newHeight
		rootFrame:ApplyStatus()
	else
		rootFrame:SetWidth(newWidth)
		rootFrame:SetHeight(newHeight)
	end
end

local function hookOptionsFrameResize()
	if optionsFrameResizeHooked then
		return
	end

	hooksecurefunc(
		E.Libs.AceConfigDialog,
		'FeedGroup',
		function(aceConfigDialog, appName, options, container, rootFrame, path)
			if appName == 'ElvUI' and path and path[1] == 'MUI' then
				ensureOptionsFrameSize(rootFrame)
			end
		end
	)

	optionsFrameResizeHooked = true
end

function Private.OptionsTable()
	E.Options.name = stformat('%s + %s v%s', E.Options.name, Private.Name, Private.Version)

	hookOptionsFrameResize()
	Private.RegisterSpacerWidget()

	-- Main Options
	E.Options.childGroups = 'ElvUI_HiddenTree'
	Private.Options = ACH:Group(Private.Name, nil, 20, 'MerfinUI_InnerTree')

	-- Install Section
	Private.Options.args.installer = ACH:Execute(L['UI Install'], L['Re-run the installation process.'], 1, function()
		Private.QueueInstaller(Private.InstallerData, true)
	end)
	Private.Options.args.quickInstaller = ACH:Execute(
		L['UI Quick Install'],
		L['Re-run the installation process.'],
		2,
		function()
			Private.QueueInstaller(Private.InstallerQuick, true)
		end
	)
	Private.Options.args.installPadding = Private.AceGUISpacer(3, 0)

	-- General
	Private.Options.args.settings = ACH:Group(L['General'], nil, 4, nil, function(info)
		return E.private.MUI.general.profileSettings[info[#info]]
	end, function(info, value)
		E.private.MUI.general.profileSettings[info[#info]] = value
	end)
	local settings = Private.Options.args.settings.args
	settings.media = ACH:Group('', nil, 1, nil, function(info)
		return E.private.MUI.general.profileSettings.media[info[#info]]
	end, function(info, value)
		E.private.MUI.general.profileSettings.media[info[#info]] = value
	end)
	settings.media.inline = true
	settings.media.args.resolution = ACH:Select(L['Resolution'], nil, 1, Private.resolutions)
	settings.media.args.texture =
		ACH:SharedMediaStatusbar(L['Default Texture'], L['Texture that core of the UI will use.'], 2)
	settings.gameMenu = ACH:Group(L['Game Menu'], nil, 3, nil, function(info)
		return E.private.MUI.general.profileSettings.gameMenu[info[#info]]
	end, function(info, value)
		E.private.MUI.general.profileSettings.gameMenu[info[#info]] = value
		E:StaticPopup_Show('MUI_RELOAD')
	end)
	settings.gameMenu.inline = true
	settings.gameMenu.args.show =
		ACH:Toggle(L['Show MerfinUI Button'], L['Shows the MerfinUI button in the Game Menu.'], 1)
	settings.layout = ACH:Group(L['Color Theme'], nil, 4)
	settings.layout.inline = true
	settings.layout.args.setNormalTheme = ACH:Execute(L['Class Theme'], nil, 1, function()
		Private.ChangeTheme('Normal')
		E:StaticPopup_Show('MUI_RELOAD')
	end)
	settings.layout.args.setDarkTheme = ACH:Execute(L['Dark Theme'], nil, 2, function()
		Private.ChangeTheme('Dark')
		E:StaticPopup_Show('MUI_RELOAD')
	end)
	settings.blacklist = ACH:Group(L['Ignore Modules'], nil, 9, nil, function(info)
		return E.private.MUI.general.profileSettings.blacklist[info[#info]]
	end, function(info, value)
		E.private.MUI.general.profileSettings.blacklist[info[#info]] = value
	end)
	settings.blacklist.inline = true
	settings.blacklist.args.movers = ACH:Toggle(L['Movers'], L['Movers'], 1)
	settings.blacklist.args.actionBars = ACH:Toggle(L['Action Bars'], L['Action Bars'], 2)
	settings.easyDelete = ACH:Group(L['Easy Delete'], nil, 10)
	settings.easyDelete.inline = true
	settings.easyDelete.args.enable = ACH:Toggle(
		L['Easy Delete'],
		L['Automatically fill out the confirmation text to delete items.'],
		1,
		nil,
		nil,
		nil,
		function()
			return E.private.MUI.automatation.deleteFill
		end,
		function(_, value)
			E.private.MUI.automatation.deleteFill = value
		end
	)
	settings.setDefaults = ACH:Execute(
		L['Reset to Defaults'],
		L['Set Default MerfinUI settings'],
		11,
		function()
			Private.SetDefaults()
		end
	)
	settings.setActualVersion = ACH:Execute(
		L['Set Actual Version'],
		L['Actualize Profile Version'],
		12,
		function()
			Private.SetActualVersion()
		end
	)

	-- Nameplates (Health Indicators)
	Private.Options.args.nameplates = ACH:Group(L['Nameplates'], nil, 5)
	Private.Options.args.nameplates.args.content = ACH:Group(L['Nameplates'], nil, 1, nil, function(info)
		return E.private.MUI.general.profileSettings.nameplates[info[#info]]
	end, function(info, value)
		E.private.MUI.general.profileSettings.nameplates[info[#info]] = value
		Private.ApplyNameplateStyle()
	end)
	Private.Options.args.nameplates.args.content.inline = true
	Private.Options.args.nameplates.args.content.args.desc = ACH:Description(
		L['Choose the design of the nameplates above the heads of units.'],
		1,
		'medium'
	)
	Private.Options.args.nameplates.args.content.args.classic = ACH:Execute(
		L['Classic'],
		L['Choose the design of the nameplates above the heads of units. Classic: text above the health bar, side auras (default look).'],
		2,
		function()
			E.private.MUI.general.profileSettings.nameplates.style = 'Classic'
			Private.ApplyNameplateStyle()
		end
	)
	Private.Options.args.nameplates.args.content.args.modern = ACH:Execute(
		L['Modern'],
		L['Choose the design of the nameplates above the heads of units. Modern: compact bar, text inside the health bar, buffs below and debuffs above.'],
		3,
		function()
			E.private.MUI.general.profileSettings.nameplates.style = 'Modern'
			Private.ApplyNameplateStyle()
		end
	)

	-- Action Bars (Command Panels)
	Private.Options.args.actionbars = ACH:Group(L['Action Bars'], nil, 6)
	Private.Options.args.actionbars.args.content = ACH:Group(L['Action Bars'], nil, 1, nil, function(info)
		return E.private.MUI.general.profileSettings.actionbars[info[#info]]
	end, function(info, value)
		E.private.MUI.general.profileSettings.actionbars[info[#info]] = value
		Private.ActionBarsSettings()
	end)
	Private.Options.args.actionbars.args.content.inline = true
	Private.Options.args.actionbars.args.content.args.desc =
		ACH:Description(L['Set your action bars to always show or appear on mouseover.'], 1, 'medium')
	Private.Options.args.actionbars.args.content.args.showAlways = ACH:Execute(L['Show Always'], nil, 2, function()
		Private.ActionBarsVisibility(true)
	end)
	Private.Options.args.actionbars.args.content.args.showMouseover = ACH:Execute(L['Show Mouseover'], nil, 3, function()
		Private.ActionBarsVisibility(false)
	end)
	Private.Options.args.actionbars.args.content.args.showGrid = ACH:Toggle(L['Show Grid'], L['Show Empty cells'], 4)

	-- Unit Frames
	Private.Options.args.unitFrames = ACH:Group(L['Unit Frames'], nil, 7)
	local unitFrames = Private.Options.args.unitFrames.args
	unitFrames.unitFrames = ACH:Group(L['Unit Frames'], nil, 1)
	unitFrames.unitFrames.inline = true
	unitFrames.unitFrames.args.old = ACH:Execute(L['Classic'], L['Enable the classic unit frames text style.'], 1, function()
		local customTexts = E.db.unitframe.units.player.customTexts
		customTexts.UnitHealth.enable = true
		customTexts.UnitHealthNew.enable = false
		customTexts.UnitName.enable = false
		customTexts.UnitPower.enable = false
		E:UpdateAll(true)
	end)
	unitFrames.unitFrames.args.new = ACH:Execute(L['Modern'], L['Enable the modern unit frames text style.'], 2, function()
		local customTexts = E.db.unitframe.units.player.customTexts
		customTexts.UnitHealthNew.enable = true
		customTexts.UnitName.enable = true
		customTexts.UnitPower.enable = true
		customTexts.UnitHealth.enable = false
		E:UpdateAll(true)
	end)
	unitFrames.unitFrames.args.powerBar = ACH:Toggle(
		L['Show Resource Bar'],
		L['Show the player resource (power) bar.'],
		3,
		nil,
		nil,
		nil,
		function()
			return E.db.unitframe.units.player.power.enable
		end,
		function(_, value)
			E.db.unitframe.units.player.power.enable = value
			E:UpdateAll(true)
		end
	)
	unitFrames.Portrait = ACH:Group(L['Portraits'], nil, 2, nil, function(info)
		return E.private.MUI.general.profileSettings.Portrait[info[#info]]
	end, function(info, value)
		E.private.MUI.general.profileSettings.Portrait[info[#info]] = value
		Private.UnitFramesSettings()
	end)
	unitFrames.Portrait.inline = true
	unitFrames.Portrait.args.playerPortrait =
		ACH:Toggle(L['Player Portrait'], L['Show the Player Portrait provided by ElvUI.'], 1)
	unitFrames.Portrait.args.targetPortrait =
		ACH:Toggle(L['Target Portrait'], L['Show the Target Portrait provided by ElvUI.'], 2)
	unitFrames.Pets = ACH:Group(L['Pets'], nil, 3, nil, function(info)
		return E.private.MUI.general.profileSettings.Pets[info[#info]]
	end, function(info, value)
		E.private.MUI.general.profileSettings.Pets[info[#info]] = value
		Private.UnitFramesSettings()
	end)
	unitFrames.Pets.inline = true
	unitFrames.Pets.args.partyPets =
		ACH:Toggle(L['Party Pets'], L['Show the Party Pets provided by ElvUI.'], 1)
	unitFrames.Pets.args.raidPets =
		ACH:Toggle(L['Raid Pets'], L['Show the Raid Pets provided by ElvUI.'], 2)
	unitFrames.CastBar = ACH:Group(L['Cast Bars'], nil, 4, nil, function(info)
		return E.private.MUI.general.profileSettings.CastBar[info[#info]]
	end, function(info, value)
		E.private.MUI.general.profileSettings.CastBar[info[#info]] = value
		Private.UnitFramesSettings()
	end)
	unitFrames.CastBar.inline = true
	unitFrames.CastBar.args.playerCastBar =
		ACH:Toggle(L['Player Castbar'], L['Show the Player Cast Bar provided by ElvUI.'], 1)
	unitFrames.CastBar.args.petCastBar =
		ACH:Toggle(L['Pet Castbar'], L['Show the Pet Cast Bar provided by ElvUI.'], 2)
	unitFrames.CastBar.args.targetCastBar =
		ACH:Toggle(L['Target Castbar'], L['Show the Target Cast Bar provided by ElvUI.'], 3)
	unitFrames.CastBar.args.focusCastBar =
		ACH:Toggle(L['Focus Castbar'], L['Show the Focus Cast Bar provided by ElvUI.'], 4)

	-- Profiles
	Private.Options.args.profiles = ACH:Group(L['Profiles'], nil, 9)
	local profileImports = Private.Options.args.profiles.args
	profileImports.header = ACH:Header(L['Profiles'], 1)
	profileImports.desc =
		ACH:Description(L['You can install the profile from this section as an alternative to the installer.'], 2, 'large')
	profileImports.spacer1 = ACH:Spacer(3, 'full')

	profileImports.accountSettings = ACH:Group(L['Account Settings'], nil, 4)
	profileImports.accountSettings.inline = true
	profileImports.accountSettings.args.desc = ACH:Description(
		L['Set important game and addon CVars to recommended values for better visuals, performance, and usability.'],
		1,
		'medium'
	)
	profileImports.accountSettings.args.spacer1 = ACH:Spacer(2, 'full')
	profileImports.accountSettings.args.apply = ACH:Execute(L['Load CVars'], nil, 3, function()
		Private.Set_CVars()
	end)

	profileImports.chatSettings = ACH:Group(L['Chat Settings'], nil, 5)
	profileImports.chatSettings.inline = true
	profileImports.chatSettings.args.desc = ACH:Description(
		L['Set up your chat windows with preconfigured tabs for general, combat log, whispers, and group content.'],
		1,
		'medium'
	)
	profileImports.chatSettings.args.spacer1 = ACH:Spacer(2, 'full')
	profileImports.chatSettings.args.apply = ACH:Execute(L['Setup Chat'], nil, 3, function()
		Private.SetupChat()
	end)

	profileImports.elvuiProfiles = ACH:Group(L['Profiles (ElvUI)'], nil, 6)
	profileImports.elvuiProfiles.inline = true
	profileImports.elvuiProfiles.args.desc = ACH:Description(
		L['Apply my ElvUI layouts for DPS/Tank or Healer roles. Includes both horizontal and vertical layouts for party frames.'],
		1,
		'medium'
	)
	profileImports.elvuiProfiles.args.spacer1 = ACH:Spacer(2, 'full')
	profileImports.elvuiProfiles.args.dpsTank = ACH:Execute('DPS/Tank', nil, 3, function()
		Private.ImportElvUI('DPS/Tank')
	end)
	profileImports.elvuiProfiles.args.healerH = ACH:Execute('Healer-H', nil, 4, function()
		Private.ImportElvUI('Healer-H')
	end)
	profileImports.elvuiProfiles.args.healerV = ACH:Execute('Healer-V', nil, 5, function()
		Private.ImportElvUI('Healer-V')
	end)

	profileImports.raidFrames = ACH:Group(L['Raid Frames'], nil, 7)
	profileImports.raidFrames.inline = true
	profileImports.raidFrames.args.desc = ACH:Description(
		L['Choose between Cell or ElvUI raid frames and apply optimized layouts for raids and dungeons.'],
		1,
		'medium'
	)
	profileImports.raidFrames.args.spacer1 = ACH:Spacer(2, 'full')
	profileImports.raidFrames.args.cellDPSTank = ACH:Execute('Cell (DPS/Tank)', nil, 3, function()
		Private.ImportRaidFrames('Cell', 'DPS/Tank')
		E:StaticPopup_Show('MUI_RELOAD')
	end)
	profileImports.raidFrames.args.cellHealerH = ACH:Execute('Cell (Healer-H)', nil, 4, function()
		Private.ImportRaidFrames('Cell', 'Healer-H')
		E:StaticPopup_Show('MUI_RELOAD')
	end)
	profileImports.raidFrames.args.cellHealerV = ACH:Execute('Cell (Healer-V)', nil, 5, function()
		Private.ImportRaidFrames('Cell', 'Healer-V')
		E:StaticPopup_Show('MUI_RELOAD')
	end)
	profileImports.raidFrames.args.elvui = ACH:Execute(L['ElvUI Frames'], nil, 6, function()
		Private.ImportRaidFrames('ElvUI')
		E:StaticPopup_Show('MUI_RELOAD')
	end)

	profileImports.damageMeter = ACH:Group(L['Damage Meter'], nil, 8)
	profileImports.damageMeter.inline = true
	profileImports.damageMeter.args.desc = ACH:Description(
		L['Apply a clean and minimalistic profile for tracking damage, healing, and more.'],
		1,
		'medium'
	)
	profileImports.damageMeter.args.spacer1 = ACH:Spacer(2, 'full')
	profileImports.damageMeter.args.skada = ACH:Execute('Skada', nil, 3, function()
		Private.ImportSkada('Dark')
	end)
	profileImports.damageMeter.args.detailsButton = ACH:Execute(L['Details'], nil, 4, function()
		Private.ImportDetails('DARK')
	end)

	profileImports.bossMods = ACH:Group(L['Boss Mods'], nil, 10)
	profileImports.bossMods.inline = true
	profileImports.bossMods.args.desc = ACH:Description(
		L['Apply my DBM profiles made for raiding. Recommended if not using my Raid Auras.'],
		1,
		'medium'
	)
	profileImports.bossMods.args.spacer1 = ACH:Spacer(2, 'full')
	profileImports.bossMods.args.dbmDpsTank = ACH:Execute('DBM DPS/Tank', nil, 3, function()
		Private.ImportDBM('DPS/Tank')
		E:StaticPopup_Show('MUI_RELOAD')
	end)
	profileImports.bossMods.args.dbmHealer = ACH:Execute('DBM Healer', nil, 4, function()
		Private.ImportDBM('Healer')
		E:StaticPopup_Show('MUI_RELOAD')
	end)

	profileImports.combatText = ACH:Group(L['Combat Text'], nil, 11)
	profileImports.combatText.inline = true
	profileImports.combatText.args.desc =
		ACH:Description(L['Choose Blizzard default combat text or xCT profiles for more compact and customizable numbers.'], 1, 'medium')
	profileImports.combatText.args.spacer1 = ACH:Spacer(2, 'full')
	profileImports.combatText.args.blizzard = ACH:Execute('Blizzard', nil, 3, function()
		if Private.Import_xCT('Blizzard') then
			DisableAddOn('xCT+')
			E:StaticPopup_Show('MUI_RELOAD')
		end
	end)
	profileImports.combatText.args.xctDpsTank = ACH:Execute('xCT+ DPS/Tank', nil, 4, function()
		if Private.Import_xCT('DPS/Tank') then
			EnableAddOn('xCT+')
			E:StaticPopup_Show('MUI_RELOAD')
		end
	end)
	profileImports.combatText.args.xctHealer = ACH:Execute('xCT+ Healer', nil, 5, function()
		if Private.Import_xCT('Healer') then
			EnableAddOn('xCT+')
			E:StaticPopup_Show('MUI_RELOAD')
		end
	end)

	-- Links
	Private.Options.args.links = ACH:Group(L['Links'], nil, 10)
	Private.RegisterLinksWidget(linksWidgetData)
	Private.Options.args.links.args.content = {
		type = 'description',
		name = '',
		order = 1,
		width = 'full',
		dialogControl = 'MerfinUILinks',
	}

	E.Options.args.MUI = Private.Options
end

--[[
	ACH:Color(name, desc, order, alpha, width, get, set, disabled, hidden)
	ACH:Description(name, order, fontSize, image, imageCoords, imageWidth, imageHeight, width, hidden)
	ACH:Execute(name, desc, order, func, image, confirm, width, get, set, disabled, hidden)
	ACH:Group(name, desc, order, childGroups, get, set, disabled, hidden, func)
	ACH:Header(name, order, get, set, hidden)
	ACH:Input(name, desc, order, multiline, width, get, set, disabled, hidden, validate)
	ACH:MultiSelect(name, desc, order, values, confirm, width, get, set, disabled, hidden)
	ACH:Range(name, desc, order, values, width, get, set, disabled, hidden)
	ACH:Select(name, desc, order, values, confirm, width, get, set, disabled, hidden)
	ACH:Spacer(order, width, hidden)
	ACH:Toggle(name, desc, order, tristate, confirm, width, get, set, disabled, hidden)
]]

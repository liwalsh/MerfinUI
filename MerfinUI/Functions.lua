local addonName, Private = ...
local E, L, V, P, G = unpack(ElvUI)
local LSM = LibStub:GetLibrary('LibSharedMedia-3.0')
local UF = E:GetModule('UnitFrames')
local individualUnits = { 'player', 'pet', 'pettarget', 'target', 'targettarget', 'targettargettarget', 'focus', 'focustarget' }
local groupUnits = { 'party', 'raid1', 'raid2', 'raid3' }
local customTexts = { 'UnitHealth', 'UnitName', 'UnitPower', 'DeadGhostStatus', 'OfflineStatus' }

-- @returns mouseover, showGrid bool
function Private.GetActionBarsSettings()
	local mouseover = E.private.MUI.general.profileSettings.actionbars.showMouseover
	local showGrid = E.private.MUI.general.profileSettings.actionbars.showGrid
	return mouseover, showGrid
end

-- @returns preferable resolution (default otherwise)
function Private.GetProfileResolution()
	local profileResolution = E.private.MUI.general.profileSettings.media.resolution
	return profileResolution or Private.Resolution
end

-- @returns main db font (default otherwise)
function Private.GetProfileFont()
	return Private.Font
end

-- @returns main db texture (default otherwise)
function Private.GetProfileTexture()
	local profileTexture = E.private.MUI.general.profileSettings.media.texture
	return profileTexture or Private.Texture
end

-- @returns currently selected nameplate style (default otherwise)
function Private.GetNameplateStyle()
	local profileStyle = E.private.MUI.general.profileSettings.nameplates.style
	return profileStyle or 'Classic'
end

-- @returns dark main color, dark backdrop color
function Private.GetDarkThemeColors()
	local color = E.private.MUI.general.layout.dark.color
	local backdropColor = E.private.MUI.general.layout.dark.backdrop
	local dead = E.private.MUI.general.layout.dark.dead
	return color, backdropColor, dead
end

-- @returns player cast bar isEnabled
function Private.GetPlayerCastBar()
	return E.private.MUI.general.profileSettings.CastBar.playerCastBar
end

-- @returns pet cast bar isEnabled
function Private.GetPetCastBar()
	return E.private.MUI.general.profileSettings.CastBar.petCastBar
end

-- @returns target cast bar isEnabled
function Private.GetTargetCastBar()
	return E.private.MUI.general.profileSettings.CastBar.targetCastBar
end

-- @returns focus cast bar isEnabled
function Private.GetFocusCastBar()
	return E.private.MUI.general.profileSettings.CastBar.focusCastBar
end

-- @returns player portrait isEnabled
function Private.GetPlayerPortrait()
	return E.private.MUI.general.profileSettings.Portrait.playerPortrait
end

-- @returns target portrait isEnabled
function Private.GetTargetPortrait()
	return E.private.MUI.general.profileSettings.Portrait.targetPortrait
end

-- @returns party pets isEnabled
function Private.GetPartyPets()
	return E.private.MUI.general.profileSettings.Pets.partyPets
end

-- @returns raid pets isEnabled
function Private.GetRaidPets()
	return E.private.MUI.general.profileSettings.Pets.raidPets
end

-- Apply unit frames settings from profileSettings to ElvUI DB and update frames.
function Private.UnitFramesSettings()
	E.db.unitframe = E.db.unitframe or {}
	E.db.unitframe.units = E.db.unitframe.units or {}

	local castBars = {
		player = Private.GetPlayerCastBar,
		pet = Private.GetPetCastBar,
		target = Private.GetTargetCastBar,
		focus = Private.GetFocusCastBar,
	}

	for unit, getter in pairs(castBars) do
		E.db.unitframe.units[unit] = E.db.unitframe.units[unit] or {}
		E.db.unitframe.units[unit].castbar = E.db.unitframe.units[unit].castbar or {}
		E.db.unitframe.units[unit].castbar.enable = getter()
	end

	local portraits = {
		player = Private.GetPlayerPortrait,
		target = Private.GetTargetPortrait,
	}

	for unit, getter in pairs(portraits) do
		E.db.unitframe.units[unit] = E.db.unitframe.units[unit] or {}
		E.db.unitframe.units[unit].portrait = E.db.unitframe.units[unit].portrait or {}
		E.db.unitframe.units[unit].portrait.enable = getter()
		E.db.unitframe.units[unit].portrait.overlay = true
	end

	E.db.unitframe.units.party = E.db.unitframe.units.party or {}
	E.db.unitframe.units.party.petsGroup = E.db.unitframe.units.party.petsGroup or {}
	E.db.unitframe.units.party.petsGroup.enable = Private.GetPartyPets()

	E.db.unitframe.units.raidpet = E.db.unitframe.units.raidpet or {}
	E.db.unitframe.units.raidpet.enable = Private.GetRaidPets()

	E:UpdateAll(true)
end

function Private.GetBlacklist(info)
	return E.private.MUI.general.profileSettings.blacklist[info]
end

-- @return path for media file
function Private.GetMediaPath(mediaType, key)
	local hashTable = LSM:HashTable(mediaType)
	if not hashTable then
		return ''
	end
	return hashTable[key]
end

function Private.ActionBarsSettings()
	local mouseover, showGrid = Private.GetActionBarsSettings()

	for i = 1, 10 do
		E.db.actionbar['bar' .. i].mouseover = mouseover
		E.db.actionbar['bar' .. i].showGrid = showGrid
	end

	E.db.actionbar.barPet.mouseover = mouseover
	E.db.actionbar.microbar.mouseover = mouseover
	E.db.actionbar.stanceBar.mouseover = mouseover
	E.db.actionbar.totemBar.mouseover = mouseover

	E.db.actionbar.barPet.showGrid = showGrid
	E.db.actionbar.microbar.showGrid = showGrid
	E.db.actionbar.stanceBar.showGrid = showGrid

	E:UpdateAll(true)
end

function Private.ActionBarsVisibility(isAlways)
	local mouseover = not isAlways

	E.private.MUI.general.profileSettings.actionbars.showMouseover = mouseover

	for i = 1, 10 do
		E.db.actionbar['bar' .. i].mouseover = mouseover
	end

	E.db.actionbar.barPet.mouseover = mouseover
	E.db.actionbar.microbar.mouseover = mouseover
	E.db.actionbar.stanceBar.mouseover = mouseover
	E.db.actionbar.totemBar.mouseover = mouseover

	E:UpdateAll(true)
end

function Private.ChangeTheme(theme)
	theme = string.upper(theme or 'NORMAL')

	if theme == 'DARK' then
		for unitFrame in pairs(E.db.unitframe.units) do
			E.db.unitframe.units[unitFrame].colorOverride = 'FORCE_OFF'
		end

		E.db.unitframe.colors.useDeadBackdrop = true
		E.db.unitframe.colors.transparentHealth = true

		local color, backdropColor, dead = Private.GetDarkThemeColors()

		E.db.unitframe.colors.health.b = color.b
		E.db.unitframe.colors.health.g = color.g
		E.db.unitframe.colors.health.r = color.r
		E.db.unitframe.colors.health_backdrop.b = backdropColor.b
		E.db.unitframe.colors.health_backdrop.g = backdropColor.g
		E.db.unitframe.colors.health_backdrop.r = backdropColor.r
		E.db.unitframe.colors.health_backdrop_dead.b = dead.b
		E.db.unitframe.colors.health_backdrop_dead.g = dead.g
		E.db.unitframe.colors.health_backdrop_dead.r = dead.r
		E.db.unitframe.units['player'].customTexts.UnitName.text_format = '[namecolor][name:abbrev:short]'
		E.db.unitframe.units['target'].customTexts.UnitName.text_format = '[namecolor][name:abbrev:short]'
		E.db.unitframe.units['targettarget'].customTexts.UnitName.text_format = '[namecolor][name:abbrev:short]'
		E.db.unitframe.units['focus'].customTexts.UnitName.text_format = '[namecolor][name:abbrev:short]'
		E.db.unitframe.units['boss'].customTexts.UnitName.text_format = '[namecolor][name:abbrev:short]'
		E.db.unitframe.units['arena'].customTexts.UnitName.text_format = '[namecolor][name:abbrev:short]'
		E.db.unitframe.units['party'].customTexts.UnitName.text_format = '[namecolor][name:abbrev:short]'
		E.db.unitframe.units['raid'].customTexts.UnitName.text_format = '[namecolor][name:abbrev:short]'
		E.db.unitframe.units['raid40'].customTexts.UnitName.text_format = '[namecolor][name:abbrev:short]'

		if E:IsAddOnEnabled('Skada') then
			Private.ImportSkada('Dark')
		end
		if E:IsAddOnEnabled('Details') then
			Private.ImportDetails('Dark')
		end
		if E:IsAddOnEnabled('Cell') then
			Private.ApplyCellColorTheme('DARK')
		end
	elseif theme == 'NORMAL' then
		for unitFrame in pairs(E.db.unitframe.units) do
			E.db.unitframe.units[unitFrame].colorOverride = 'FORCE_ON'
		end

		E.db.unitframe.colors.useDeadBackdrop = false
		E.db.unitframe.colors.transparentHealth = false

		E.db.unitframe.colors.health.b = 0.17254901960784
		E.db.unitframe.colors.health.g = 0.17254901960784
		E.db.unitframe.colors.health.r = 0.1921568627451
		E.db.unitframe.colors.health_backdrop.b = 0.23137254901961
		E.db.unitframe.colors.health_backdrop.g = 0.23137254901961
		E.db.unitframe.colors.health_backdrop.r = 0.27058823529412
		E.db.unitframe.colors.health_backdrop_dead.b = 0.46274509803922
		E.db.unitframe.colors.health_backdrop_dead.g = 0.46274509803922
		E.db.unitframe.colors.health_backdrop_dead.r = 0.51764705882353

		E.db.unitframe.units['player'].customTexts.UnitName.text_format = '[name:abbrev:short]'
		E.db.unitframe.units['target'].customTexts.UnitName.text_format = '[name:abbrev:short]'
		E.db.unitframe.units['targettarget'].customTexts.UnitName.text_format = '[name:abbrev:short]'
		E.db.unitframe.units['focus'].customTexts.UnitName.text_format = '[name:abbrev:short]'
		E.db.unitframe.units['boss'].customTexts.UnitName.text_format = '[name:abbrev:short]'
		E.db.unitframe.units['arena'].customTexts.UnitName.text_format = '[name:abbrev:short]'
		E.db.unitframe.units['party'].customTexts.UnitName.text_format = '[name:abbrev:short]'
		E.db.unitframe.units['raid'].customTexts.UnitName.text_format = '[name:abbrev:short]'
		E.db.unitframe.units['raid40'].customTexts.UnitName.text_format = '[name:abbrev:short]'

		if E:IsAddOnEnabled('Skada') then
			Private.ImportSkada('Normal')
		end
		if E:IsAddOnEnabled('Details') then
			Private.ImportDetails('NORMAL')
		end
		if E:IsAddOnEnabled('Cell') then
			Private.ApplyCellColorTheme('NORMAL')
		end
	end

	UF:Update_AllFrames()
	Private:PluginInstallStepComplete((theme == 'DARK' and 'Dark' or 'Normal') .. ' Theme')
end

function Private.SetDefaultLayout()
	E.private.MUI.general.layout.dark.color = { r = 0.25098039215686, g = 0.22352941176471, b = 0.22352941176471, a = 1 }
	E.private.MUI.general.layout.dark.backdrop = { r = 0.83137254901961, g = 0.69803921568627, b = 0.69803921568627, a = 1 }
	E.private.MUI.general.layout.dark.dead = { r = 1, g = 0.25098039215686, b = 0.25098039215686, a = 1 }
end

function Private.SetDefaults()
	E.private.MUI.general.profileSettings.media.resolution = Private.Resolution
	E.private.MUI.general.profileSettings.media.texture = Private.Texture
	E.private.MUI.general.profileSettings.gameMenu.show = true
	E.private.MUI.general.profileSettings.actionbars.showMouseover = true
	E.private.MUI.general.profileSettings.actionbars.showGrid = false
	E.private.MUI.general.profileSettings.blacklist.movers = false
	E.private.MUI.general.profileSettings.blacklist.actionBars = false
	E.private.MUI.general.profileSettings.nameplates.style = 'Classic'
	Private.ActionBarsSettings()
end

function Private.SetActualVersion()
	local Version = GetAddOnMetadata(addonName, 'Version')
	E.global.MUI.install_version = Version
	E.private.MUI.install_version = Version
	DEFAULT_CHAT_FRAME:AddMessage(format(Private.L['|cffffff00MerfinUI:|r profile version was changed to recent v%s'], Version))
end

local fontSizeAdd = {}
function Private.SetFontSize(default)
	local font = Private.GetProfileFont()
	local add = fontSizeAdd[font]
	if add then
		return default + add
	end
	return default
end

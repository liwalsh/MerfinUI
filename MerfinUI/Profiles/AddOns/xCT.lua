local addonName, Private = ...
local L = Private.L

local E = unpack(ElvUI)

function Private.Import_xCT(layout)
	if layout == 'Blizzard' then
		SetCVar('CombatDamage', 1)
		SetCVar('CombatLogPeriodicSpells', 1)
		SetCVar('PetMeleeDamage', 1)
		SetCVar('CombatHealing', 1)
		--SetCVar('enableCombatText', 1)
		--_G['SHOW_COMBAT_TEXT'] = '1'
		SetCVar('fctCombatState', 1)
		_G['COMBAT_TEXT_SHOW_COMBAT_STATE'] = '1'
		SetCVar('fctDodgeParryMiss', 1)
		_G['COMBAT_TEXT_SHOW_DODGE_PARRY_MISS'] = '1'
		SetCVar('fctDamageReduction', 1)
		_G['COMBAT_TEXT_SHOW_RESISTANCES'] = '1'
		SetCVar('fctFriendlyHealers', 1)
		_G['COMBAT_TEXT_SHOW_FRIENDLY_NAMES'] = '1'

		Private:PluginInstallStepComplete(L['Blizzard Combat Text'])

		return true
	end

	if not IsAddOnLoaded('xCT+') then
		Private:Print(string.format(L['You need to enable %s.'], 'xCT+'))
		return
	end

	local mainFont = Private.GetProfileFont()

	xCTSavedDB['profiles'] = xCTSavedDB['profiles'] or {}
	xCTSavedDB['profileKeys'] = xCTSavedDB['profileKeys'] or {}

	local profileName = 'MerfinUI (' .. layout .. ') (' .. Private.ScreenHeight .. ') v' .. Private.Version

	-- Only MerfinUI overrides: AceDB fills every missing key from xCT+ defaults on profile load.
	xCTSavedDB['profiles'][profileName] = {
		['megaDamage'] = {
			['thousandSymbol'] = '|cffFF8000K|r ',
			['millionSymbol'] = '|cffFF0000M|r ',
		},
		['frames'] = {
			['general'] = {
				['font'] = mainFont,
				['showInterrupts'] = false,
				['showDispells'] = false,
				['showPartyKills'] = false,
				['showBuffs'] = false,
				['showDebuffs'] = false,
				['showLowManaHealth'] = false,
				['showRepChanges'] = false,
				['showHonorGains'] = false,
			},
			['outgoing'] = {
				['enabledFrame'] = false,
				['insertText'] = 'top',
				['font'] = mainFont,
				['enableOutHeal'] = false,
				['enableHots'] = false,
			},
			['critical'] = {
				['enabledFrame'] = false,
				['secondaryFrame'] = 2,
			},
			['damage'] = {
				['enabledFrame'] = false,
				['font'] = mainFont,
				['fontSize'] = 15,
				['X'] = -412,
				['Y'] = -417,
			},
			['healing'] = {
				['enabledFrame'] = false,
				['font'] = mainFont,
				['fontSize'] = 13,
				['enableRealmNames'] = false,
				['X'] = -403,
				['Y'] = 213,
			},
			['class'] = {
				['enabledFrame'] = false,
			},
			['power'] = {
				['enabledFrame'] = false,
			},
			['procs'] = {
				['enabledFrame'] = false,
				['font'] = mainFont,
				['X'] = 8,
				['Y'] = 71,
			},
			['loot'] = {
				['enabledFrame'] = false,
				['font'] = mainFont,
				['X'] = 5,
				['Y'] = 226,
			},
		},
		['spells'] = {
			['mergeDontMergeCriticals'] = false,
			['merge'] = {
				[980] = {
					['enabled'] = false,
					['class'] = 'WARLOCK',
				},
				[20153] = {
					['enabled'] = false,
					['class'] = 'WARLOCK',
				},
				[172] = {
					['enabled'] = false,
					['class'] = 'WARLOCK',
				},
				[348] = {
					['enabled'] = false,
					['class'] = 'WARLOCK',
				},
			},
		},
	}

	if Private.GetProfileResolution() == 'QUAD_HD' then
		xCTSavedDB.profiles[profileName].frames.general.Y = 400
		xCTSavedDB.profiles[profileName].frames.general.X = 0
		xCTSavedDB.profiles[profileName].frames.general.fontSize = 16
		xCTSavedDB.profiles[profileName].frames.outgoing.Width = 169
		xCTSavedDB.profiles[profileName].frames.outgoing.Height = 120
		xCTSavedDB.profiles[profileName].frames.outgoing.fontSize = 16
		xCTSavedDB.profiles[profileName].frames.outgoing.iconsSize = 24
		xCTSavedDB.profiles[profileName].frames.critical.iconsSize = 24

		if layout == 'DPS/Tank' then
			xCTSavedDB.profiles[profileName].frames.outgoing.Y = -427
			xCTSavedDB.profiles[profileName].frames.outgoing.X = 340
			xCTSavedDB.profiles[profileName].frames.outgoing.enableOutHeal = false
		elseif layout == 'Healer' then
			xCTSavedDB.profiles[profileName].frames.outgoing.Y = -473
			xCTSavedDB.profiles[profileName].frames.outgoing.X = 868
			xCTSavedDB.profiles[profileName].frames.outgoing.enableOutHeal = true
		end
	elseif Private.GetProfileResolution() == 'FULL_HD' then
		xCTSavedDB.profiles[profileName].frames.general.Y = 300
		xCTSavedDB.profiles[profileName].frames.general.X = 0
		xCTSavedDB.profiles[profileName].frames.general.fontSize = 14
		xCTSavedDB.profiles[profileName].frames.outgoing.Width = 167
		xCTSavedDB.profiles[profileName].frames.outgoing.Height = 128
		xCTSavedDB.profiles[profileName].frames.outgoing.fontSize = 14
		xCTSavedDB.profiles[profileName].frames.outgoing.iconsSize = 20
		xCTSavedDB.profiles[profileName].frames.critical.iconsSize = 20

		if layout == 'DPS/Tank' then
			xCTSavedDB.profiles[profileName].frames.outgoing.Y = -361
			xCTSavedDB.profiles[profileName].frames.outgoing.X = 299
			xCTSavedDB.profiles[profileName].frames.outgoing.enableOutHeal = false
		elseif layout == 'Healer' then
			xCTSavedDB.profiles[profileName].frames.outgoing.Y = -448
			xCTSavedDB.profiles[profileName].frames.outgoing.X = 587
			xCTSavedDB.profiles[profileName].frames.outgoing.enableOutHeal = true
		end
	end

	xCTSavedDB['profileKeys'][Private.AceProfileName] = profileName

	Private:PluginInstallStepComplete('xCT+')
	return true
end

local addonName, Private = ...
local E, L, V, P, G = unpack(ElvUI)

local profileName = string.format('%s - %s', UnitName('player'), GetRealmName('player'))
local db = {}

local function CopyDBValue(value)
	if type(value) ~= 'table' then
		return value
	end

	local copy = {}
	for key, childValue in pairs(value) do
		copy[key] = CopyDBValue(childValue)
	end

	return copy
end

local function RestoreDBValues(target, snapshot)
	if type(target) ~= 'table' or type(snapshot) ~= 'table' then
		return
	end

	for key, value in pairs(snapshot) do
		target[key] = CopyDBValue(value)
	end
end

-- Sections of E.db.actionbar that db.actionbars() actually overwrites. Backing
-- up only these keys avoids deep-copying the whole (huge) actionbar database.
local actionBarSections = {
	'bar1', 'bar2', 'bar3', 'bar4', 'bar5', 'bar6', 'bar7', 'bar8', 'bar9', 'bar10',
	'barPet', 'microbar', 'stanceBar', 'totemBar', 'extraActionButton',
	'vehicleExitButton', 'cooldown', 'noRangeColor',
	'keyDown', 'desaturateOnCooldown', 'flashAnimation', 'font', 'fontOutline',
	'macroTextPosition', 'fontSize',
}

local function CopyDBActionBarSections(source)
	if not source then
		return {}
	end

	local copy = {}

	for _, key in ipairs(actionBarSections) do
		local value = source[key]
		if value ~= nil then
			copy[key] = CopyDBValue(value)
		end
	end

	return copy
end

db.movers = function(layout, force)
	if Private.GetBlacklist('movers') and not force then
		return
	end

	E.db.movers = E.db.movers or {}
	E.db.movers.DTPanelCustomPanel_LeftMover = 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,4'
	E.db.movers.DTPanelCustomPanel_RightMover = 'BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-4,4'
	E.db.movers.PvPMover = 'TOP,ElvUIParent,TOP,0,-30'
	E.db.movers.ElvUF_PlayerCastbarMover = 'BOTTOM,ElvUF_Player,BOTTOM,0,-21'
	E.db.movers.ElvUF_PetCastbarMover = 'BOTTOM,ElvUF_Pet,BOTTOM,0,-21'
	E.db.movers.ElvUF_TargetCastbarMover = 'BOTTOM,ElvUF_Target,BOTTOM,0,-21'
	E.db.movers.ElvUF_FocusCastbarMover = 'BOTTOM,ElvUF_Focus,BOTTOM,0,-21'

	if Private.GetProfileResolution() == 'QUAD_HD' then
		E.db.movers.AlertFrameMover = 'TOP,ElvUIParent,TOP,293,-469'
		E.db.movers.BNETMover = 'TOPLEFT,UIParent,TOPLEFT,662,-4'
		E.db.movers.BagsMover = 'BOTTOMRIGHT,UIParent,BOTTOMRIGHT,-763,4'
		E.db.movers.BossButton = 'TOP,UIParent,TOP,-241,-694'
		E.db.movers.ClassBarMover = 'BOTTOMLEFT,UIParent,BOTTOMLEFT,4,491'
		E.db.movers.ElvUIBagMover = 'BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-4,29'
		E.db.movers.ElvUIBankMover = 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,313'
		E.db.movers.ExperienceBarMover = 'TOP,UIParent,TOP,0,-4'
		E.db.movers.GMMover = 'TOPLEFT,UIParent,TOPLEFT,413,-4'
		E.db.movers.HonorBarMover = 'TOPLEFT,ElvUIParent,TOPLEFT,528,-338'
		E.db.movers.LeftChatMover = 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,29'
		E.db.movers.LootFrameMover = 'TOP,UIParent,TOP,0,-218'
		E.db.movers.MinimapButtonGrabberMover = 'TOPRIGHT,ElvUIParent,TOPRIGHT,-3,-230'
		E.db.movers.ObjectiveFrameMover = 'TOPRIGHT,ElvUIParent,TOPRIGHT,-100,-360'
		E.db.movers.RightChatMover = 'BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-4,29'
		E.db.movers.TotemBarMover = 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,499'
		E.db.movers.TotemTrackerMover = 'BOTTOMLEFT,UIParent,BOTTOMLEFT,662,4'
		E.db.movers.TimeManagerFrameMover = 'TOPRIGHT,ElvUIParent,TOPRIGHT,-4,-592'
		E.db.movers.PetExperienceBarMover = 'TOP,ElvUIParent,TOP,0,-30'
		E.db.movers.VehicleLeaveButton = 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,480,137'
		E.db.movers.VehicleSeatMover = 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,480,4'
		E.db.movers.SocialToastMover = 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,314'

		-- Action Bars
		if not Private.GetBlacklist('actionBars') then
			E.db.movers.ElvAB_1 = 'BOTTOM,ElvUIParent,BOTTOM,-210,4'
			E.db.movers.ElvAB_2 = 'BOTTOM,ElvUIParent,BOTTOM,0,109'
			E.db.movers.ElvAB_3 = 'BOTTOM,ElvUIParent,BOTTOM,210,4'
			E.db.movers.ElvAB_4 = 'BOTTOM,ElvUIParent,BOTTOM,-210,39'
			E.db.movers.ElvAB_5 = 'BOTTOM,ElvUIParent,BOTTOM,210,39'
			E.db.movers.ElvAB_6 = 'BOTTOM,ElvUIParent,BOTTOM,0,70'
			E.db.movers.ShiftAB = 'BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-475,3'
			E.db.movers.MicrobarMover = 'BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-257,4'
		end

		if layout == 'DPS/Tank' then
			-- Individual Units
			E.db.movers.ElvUF_PlayerMover = 'BOTTOM,ElvUIParent,BOTTOM,-295,390'
			E.db.movers.ElvUF_PetMover = 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,720,390'
			E.db.movers.ElvUF_TargetMover = 'BOTTOM,ElvUIParent,BOTTOM,295,390'
			E.db.movers.ElvUF_FocusMover = 'BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-497,390'
			E.db.movers.ElvUF_TargetTargetMover = 'BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-726,390'

			-- Group Elements
			E.db.movers.ElvUF_PartyMover = 'TOPLEFT,ElvUIParent,TOPLEFT,644,-523'
			E.db.movers.ElvUF_RaidMover = 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,314'
			E.db.movers.ElvUF_Raid40Mover = 'BOTTOMLEFT,UIParent,BOTTOMLEFT,4,314'
			E.db.movers.ElvUF_RaidpetMover = 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,570'
			E.db.movers.ArenaHeaderMover = 'TOPRIGHT,ElvUIParent,TOPRIGHT,-626,-519'
			E.db.movers.BossHeaderMover = 'TOPRIGHT,ElvUIParent,TOPRIGHT,-626,-560'
			E.db.movers.ElvUF_TankMover = 'BOTTOM,ElvUIParent,BOTTOM,-303,49'

			-- Action Bars
			if not Private.GetBlacklist('actionBars') then
				E.db.movers.PetAB = "BOTTOM,ElvUIParent,BOTTOM,245,74"
				E.db.movers.ShiftAB = 'TOPLEFT,ElvUIParent,BOTTOMLEFT,860,110'
				E.db.movers.TotemBarMover = 'BOTTOM,ElvUIParent,BOTTOM,-315,74'
			end
		elseif layout == 'Healer-H' or layout == 'Healer-V' then
			-- Individual Units
			E.db.movers.ElvUF_PlayerMover = 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,699,355'
			E.db.movers.ElvUF_PetMover = 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,565,355'
			E.db.movers.ElvUF_TargetMover = 'BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-699,355'
			E.db.movers.ElvUF_FocusMover = 'BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-326,355'
			E.db.movers.ElvUF_TargetTargetMover = 'BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-565,355'

			-- Group Elements
			E.db.movers.ElvUF_PartyMover = 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,699,540'
			E.db.movers.ElvUF_RaidMover = 'TOPLEFT,ElvUIParent,BOTTOMLEFT,957,406'
			E.db.movers.ElvUF_Raid40Mover = 'TOPLEFT,ElvUIParent,BOTTOMLEFT,957,406'
			E.db.movers.ElvUF_RaidpetMover = 'TOPLEFT,ElvUIParent,BOTTOMLEFT,1602,324'
			E.db.movers.ArenaHeaderMover = 'TOPRIGHT,ElvUIParent,TOPRIGHT,-463,-519'
			E.db.movers.BossHeaderMover = 'TOPRIGHT,ElvUIParent,TOPRIGHT,-463,-560'
			E.db.movers.ElvUF_TankMover = 'BOTTOM,ElvUIParent,BOTTOM,-303,49'

			-- Action Bars
			if not Private.GetBlacklist('actionBars') then
				E.db.movers.PetAB = 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,353'
				E.db.movers.ShiftAB = 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,314'
				E.db.movers.TotemBarMover = 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,314'
			end
		end

		if layout == 'Healer-H' then
			E.db.movers.ElvUF_PartyMover = 'BOTTOM,ElvUIParent,BOTTOM,0,341'
		elseif layout == 'Healer-V' then
			E.db.movers.ElvUF_PartyMover = 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,699,544'
		end
	elseif Private.GetProfileResolution() == 'FULL_HD' then
		E.db.movers.AlertFrameMover = 'TOP,ElvUIParent,TOP,288,-322'
		E.db.movers.BNETMover = 'TOPLEFT,UIParent,TOPLEFT,496,-4'
		E.db.movers.BagsMover = 'BOTTOMRIGHT,UIParent,BOTTOMRIGHT,-763,4'
		E.db.movers.BossButton = 'BOTTOM,ElvUIParent,BOTTOM,-200,514'
		E.db.movers.ClassBarMover = 'BOTTOMLEFT,UIParent,BOTTOMLEFT,4,491'
		E.db.movers.ElvUIBagMover = 'BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-4,29'
		E.db.movers.ElvUIBankMover = 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,280'
		E.db.movers.ExperienceBarMover = 'TOP,UIParent,TOP,0,-4'
		E.db.movers.GMMover = 'TOPLEFT,UIParent,TOPLEFT,284,-4'
		E.db.movers.HonorBarMover = 'TOPLEFT,ElvUIParent,TOPLEFT,528,-338'
		E.db.movers.LeftChatMover = 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,29'
		E.db.movers.LootFrameMover = 'TOP,UIParent,TOP,0,-218'
		E.db.movers.MinimapButtonGrabberMover = 'TOPRIGHT,ElvUIParent,TOPRIGHT,-4,-182'
		E.db.movers.ObjectiveFrameMover = 'TOPRIGHT,ElvUIParent,TOPRIGHT,-90,-280'
		E.db.movers.RightChatMover = 'BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-4,29'
		E.db.movers.TotemBarMover = 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,499'
		E.db.movers.TotemTrackerMover = 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,404,4'
		E.db.movers.TimeManagerFrameMover = 'TOPRIGHT,ElvUIParent,TOPRIGHT,-4,-412'
		E.db.movers.VehicleLeaveButton = 'BOTTOMLEFT,UIParent,BOTTOMLEFT,404,134'
		E.db.movers.VehicleSeatMover = 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,404,4'
		E.db.movers.PetExperienceBarMover = 'TOP,ElvUIParent,TOP,0,-30'
		E.db.movers.SocialToastMover = 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,281'

		-- Action Bars
		if not Private.GetBlacklist('actionBars') then
			E.db.movers.ElvAB_1 = 'BOTTOM,ElvUIParent,BOTTOM,-186,4'
			E.db.movers.ElvAB_2 = 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,316'
			E.db.movers.ElvAB_3 = 'BOTTOM,ElvUIParent,BOTTOM,186,4'
			E.db.movers.ElvAB_4 = 'BOTTOM,ElvUIParent,BOTTOM,-186,35'
			E.db.movers.ElvAB_5 = 'BOTTOM,ElvUIParent,BOTTOM,186,35'
			E.db.movers.ElvAB_6 = 'BOTTOMLEFT,UIParent,BOTTOMLEFT,424,551'
			E.db.movers.MicrobarMover = 'BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-240,4'
		end

		if layout == 'DPS/Tank' then
			-- Individual Elements:
			E.db.movers.ElvUF_PlayerMover = 'BOTTOM,ElvUIParent,BOTTOM,-267,280'
			E.db.movers.ElvUF_PetMover = 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,447,280'
			E.db.movers.ElvUF_TargetMover = 'BOTTOM,ElvUIParent,BOTTOM,267,280'
			E.db.movers.ElvUF_TargetTargetMover = 'BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-447,280'
			E.db.movers.ElvUF_FocusMover = 'BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-256,280'

			-- Group Elements
			E.db.movers.ElvUF_PartyMover = 'TOPLEFT,ElvUIParent,TOPLEFT,418,-361'
			E.db.movers.ElvUF_RaidMover = 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,281'
			E.db.movers.ElvUF_Raid40Mover = 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,281'
			E.db.movers.ElvUF_RaidpetMover = 'TOPLEFT,ElvUIParent,TOPLEFT,4,-403'
			E.db.movers.ArenaHeaderMover = 'TOPRIGHT,UIParent,TOPRIGHT,-387,-344'
			E.db.movers.BossHeaderMover = 'TOPRIGHT,ElvUIParent,TOPRIGHT,-387,-370'
			E.db.movers.ElvUF_TankMover = 'BOTTOM,ElvUIParent,BOTTOM,-303,49'

			-- Action Bars
			if not Private.GetBlacklist('actionBars') then
				E.db.movers.PetAB = 'BOTTOM,ElvUIParent,BOTTOM,217,66'
				E.db.movers.ShiftAB = 'TOPLEFT,ElvUIParent,BOTTOMLEFT,587,98'
				E.db.movers.TotemBarMover = 'BOTTOM,ElvUIParent,BOTTOM,-279,66'
			end
		elseif layout == 'Healer-H' or layout == 'Healer-V' then
			-- Individual Units
			E.db.movers.ElvUF_PlayerMover = 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,478,268'
			E.db.movers.ElvUF_PetMover = 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,478,167'
			E.db.movers.ElvUF_TargetMover = 'BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-478,268'
			E.db.movers.ElvUF_FocusMover = 'BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-288,196'
			E.db.movers.ElvUF_TargetTargetMover = 'BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-348,268'

			-- Group Elements
			E.db.movers.ElvUF_PartyMover = 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,478,426'
			E.db.movers.ElvUF_RaidMover = 'TOPLEFT,ElvUIParent,BOTTOMLEFT,712,312'
			E.db.movers.ElvUF_Raid40Mover = 'TOPLEFT,ElvUIParent,BOTTOMLEFT,712,312'
			E.db.movers.ElvUF_RaidpetMover = 'TOPLEFT,ElvUIParent,BOTTOMLEFT,1207,250'
			E.db.movers.ArenaHeaderMover = 'TOPRIGHT,ElvUIParent,TOPRIGHT,-289,-331'
			E.db.movers.BossHeaderMover = 'TOPRIGHT,ElvUIParent,TOPRIGHT,-289,-306'
			E.db.movers.ElvUF_TankMover = 'BOTTOM,ElvUIParent,BOTTOM,-303,49'

			-- Action Bars
			if not Private.GetBlacklist('actionBars') then
				E.db.movers.PetAB = 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,318'
				E.db.movers.ShiftAB = 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,283'
				E.db.movers.TotemBarMover = 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,283'
			end
		end

		if layout == 'Healer-H' then
			E.db.movers.ElvUF_PartyMover = 'BOTTOM,ElvUIParent,BOTTOM,0,257'
		elseif layout == 'Healer-V' then
			E.db.movers.ElvUF_PartyMover = 'TOPLEFT,ElvUIParent,TOPLEFT,478,-361'
		end
	end
end

db.general = function()
	E.db.general.tagUpdateRate = 0.5

	E.db.general.guildBank = E.db.general.guildBank or {}
	E.db.general.guildBank.countFont = Private.GetProfileFont()
	E.db.general.guildBank.countFontOutline = 'OUTLINE'
	E.db.general.guildBank.itemLevelFont = Private.GetProfileFont()
	E.db.general.guildBank.itemLevelFontOutline = 'OUTLINE'

	E.db.general.afk = false
	E.db.general.autoAcceptInvite = false
	E.db.general.autoRepair = 'PLAYER'
	E.db.general.bottomPanel = false
	E.db.general.font = Private.GetProfileFont()

	E.db.general.lootRoll.nameFont = Private.GetProfileFont()
	E.db.general.lootRoll.statusBarTexture = Private.GetProfileTexture()

	E.db.general.minimap.clusterBackdrop = false
	E.db.general.minimap.locationFont = Private.GetProfileFont()
	E.db.general.minimap.timeFont = Private.GetProfileFont()
	E.db.general.minimap.icons = E.db.general.minimap.icons or {}
	E.db.general.minimap.icons.battlefield = E.db.general.minimap.icons.battlefield or {}
	E.db.general.minimap.icons.mail.position = 'TOPLEFT'
	E.db.general.minimap.icons.mail.xOffset = 3
	E.db.general.minimap.icons.mail.yOffset = -3

	E.db.general.valuecolor.b = 0
	E.db.general.valuecolor.g = 0.42352941176471
	E.db.general.valuecolor.r = 1

	E.db.general.backdropfadecolor = E.db.general.backdropfadecolor or {}
	E.db.general.backdropfadecolor.a = 0.8

	E.db.general.minimapButtonGrabber.growFrom = 'TOPRIGHT'
	E.db.general.minimapButtonGrabber.buttonsPerRow = 12
	E.db.general.minimapButtonGrabber.insideMinimap.enable = false
	E.db.general.minimapButtonGrabber.buttonSpacing = -1

	E.db.general.totems = E.db.general.totems or {}
	E.db.general.totems.enable = false
	E.db.general.totems.font = Private.GetProfileFont()
	E.db.general.totems.mouseover = true
	E.db.general.totems.growthDirection = 'HORIZONTAL'
	E.db.general.totems.spacing = 1

	E.db.general.queueStatus.font = Private.GetProfileFont()
	E.db.general.queueStatus.position = 'CENTER'
	E.db.general.queueStatus.xOffset = 0
	E.db.general.queueStatus.yOffset = 0

	local profileFont = Private.GetProfileFont()
	local generalFonts = {
		cooldown = false,
		worldzone = false,
		worldsubzone = false,
		pvpzone = false,
		pvpsubzone = false,
		objective = false,
		errortext = true,
		mailbody = false,
		questtitle = false,
		questtext = false,
		questsmall = false,
	}

	for fontName, enable in pairs(generalFonts) do
		E.db.general.fonts[fontName] = E.db.general.fonts[fontName] or {}
		E.db.general.fonts[fontName].enable = enable
		E.db.general.fonts[fontName].font = profileFont
	end

	if Private.GetProfileResolution() == 'QUAD_HD' then
		E.db.general.fontSize = 14
		E.db.general.fonts.errortext.size = 14
		E.db.general.lootRoll.nameFontSize = 14
		E.db.general.minimap.size = 226
		E.db.general.minimap.locationFontSize = 14
		E.db.general.minimap.timeFontSize = 14
		E.db.general.totems.fontSize = 14
		E.db.general.totems.size = 32
		E.db.general.guildBank.countFontSize = 14
		E.db.general.guildBank.itemLevelFontSize = 14
		E.db.general.queueStatus.fontSize = 14
		E.db.general.objectiveFrameHeight = 600
	elseif Private.GetProfileResolution() == 'FULL_HD' then
		E.db.general.fontSize = 13
		E.db.general.fonts.errortext.size = 13
		E.db.general.lootRoll.nameFontSize = 13
		E.db.general.minimap.size = 178
		E.db.general.minimap.locationFontSize = 13
		E.db.general.minimap.timeFontSize = 13
		E.db.general.totems.fontSize = 13
		E.db.general.totems.size = 32
		E.db.general.guildBank.countFontSize = 13
		E.db.general.guildBank.itemLevelFontSize = 13
		E.db.general.queueStatus.fontSize = 13
		E.db.general.objectiveFrameHeight = 400
		E.db.general.minimapButtonGrabber.buttonsPerRow = 12
	end
end

db.auras = function()
	E.db.auras.buffs.countFont = Private.GetProfileFont()
	E.db.auras.buffs.countFontOutline = 'OUTLINE'
	E.db.auras.buffs.timeFont = Private.GetProfileFont()
	E.db.auras.buffs.timeFontOutline = 'OUTLINE'
	E.db.auras.buffs.barTexture = Private.GetProfileTexture()
	E.db.auras.debuffs.countFont = Private.GetProfileFont()
	E.db.auras.debuffs.countFontOutline = 'OUTLINE'
	E.db.auras.debuffs.timeFont = Private.GetProfileFont()
	E.db.auras.debuffs.timeFontOutline = 'OUTLINE'
	E.db.auras.debuffs.barTexture = Private.GetProfileTexture()

	if Private.GetProfileResolution() == 'QUAD_HD' then
		E.db.auras.buffs.countFontSize = 14
		E.db.auras.buffs.horizontalSpacing = 3
		E.db.auras.buffs.size = 36
		E.db.auras.buffs.timeFontSize = 14
		E.db.auras.buffs.wrapAfter = 16
		E.db.auras.debuffs.countFontSize = 14
		E.db.auras.debuffs.horizontalSpacing = 3
		E.db.auras.debuffs.size = 36
		E.db.auras.debuffs.timeFontSize = 14
		E.db.auras.debuffs.wrapAfter = 14
	elseif Private.GetProfileResolution() == 'FULL_HD' then
		E.db.auras.buffs.countFontSize = 13
		E.db.auras.buffs.horizontalSpacing = 3
		E.db.auras.buffs.size = 34
		E.db.auras.buffs.timeFontSize = 13
		E.db.auras.buffs.wrapAfter = 14
		E.db.auras.debuffs.countFontSize = 13
		E.db.auras.debuffs.horizontalSpacing = 3
		E.db.auras.debuffs.size = 34
		E.db.auras.debuffs.timeFontSize = 13
		E.db.auras.debuffs.wrapAfter = 14
	end
end

db.bags = function()
	E.db.bags.autoToggle.trade = true
	E.db.bags.bagBar.growthDirection = 'HORIZONTAL'
	E.db.bags.bagBar.justBackpack = true
	E.db.bags.bagBar.mouseover = true
	E.db.bags.bagBar.spacing = -1
	E.db.bags.bagBar.font = Private.GetProfileFont()
	E.db.bags.bagButtonSpacing = 0
	E.db.bags.clearSearchOnClose = true
	E.db.bags.countFont = Private.GetProfileFont()
	E.db.bags.countFontOutline = 'OUTLINE'
	E.db.bags.countxOffset = -2
	E.db.bags.countyOffset = 3
	E.db.bags.itemInfoFont = Private.GetProfileFont()
	E.db.bags.itemInfoFontOutline = 'OUTLINE'
	E.db.bags.itemLevelFontOutline = 'OUTLINE'
	E.db.bags.moneyCoins = false
	E.db.bags.moneyFormat = 'CONDENSED'
	E.db.bags.split.bagSpacing = 2
	E.db.bags.itemLevelxOffset = -2
	E.db.bags.itemLevelyOffset = 3
	E.db.bags.itemLevelFont = Private.GetProfileFont()
	E.db.bags.cooldown.fonts.enable = true
	E.db.bags.cooldown.fonts.font = Private.GetProfileFont()
	if Private.GetProfileResolution() == 'QUAD_HD' then
		E.db.bags.bagBar.size = 40
		E.db.bags.bagSize = 43
		E.db.bags.bagWidth = 525
		E.db.bags.bagButtonSpacing = 3
		E.db.bags.bankSize = 42
		E.db.bags.bankWidth = 471
		E.db.bags.bankButtonSpacing = 3
		E.db.bags.countFontSize = 16
		E.db.bags.itemInfoFontSize = 16
		E.db.bags.itemLevelFontSize = 16
		E.db.bags.cooldown.fonts.fontSize = 14
	elseif Private.GetProfileResolution() == 'FULL_HD' then
		E.db.bags.bagBar.size = 40
		E.db.bags.bagSize = 40
		E.db.bags.bagWidth = 495
		E.db.bags.bagButtonSpacing = 3
		E.db.bags.bankSize = 40
		E.db.bags.bankWidth = 396
		E.db.bags.bankButtonSpacing = 3
		E.db.bags.countFontSize = 14
		E.db.bags.itemInfoFontSize = 14
		E.db.bags.itemLevelFontSize = 14
		E.db.bags.cooldown.fonts.fontSize = 13
	end
end

db.chat = function()
	E.db.chat.editBoxPosition = 'ABOVE_CHAT_INSIDE'
	E.db.chat.font = Private.GetProfileFont()
	E.db.chat.panelBackdrop = 'LEFT'
	E.db.chat.panelBackdropNameLeft = ''
	E.db.chat.panelColor.a = 0.55000001192093
	E.db.chat.panelColor.b = 0.05882353335619
	E.db.chat.panelColor.g = 0.05882353335619
	E.db.chat.panelColor.r = 0.05882353335619
	E.db.chat.panelTabBackdrop = false
	E.db.chat.panelTabTransparency = true
	E.db.chat.separateSizes = true
	E.db.chat.showHistory.CHANNEL = false
	E.db.chat.showHistory.EMOTE = false
	E.db.chat.showHistory.INSTANCE = false
	E.db.chat.tabFont = Private.GetProfileFont()
	E.db.chat.tabSelector = 'NONE'
	E.db.chat.timeStampLocalTime = true
	E.db.chat.timeStampFormat = '%H:%M:%S '

	if Private.GetProfileResolution() == 'QUAD_HD' then
		E.db.chat.panelHeight = 282
		E.db.chat.panelWidth = 471
		E.db.chat.panelHeightRight = 400
		E.db.chat.panelWidthRight = 250
		E.db.chat.tabFontSize = 15
	elseif Private.GetProfileResolution() == 'FULL_HD' then
		E.db.chat.panelHeight = 250
		E.db.chat.panelWidth = 396
		E.db.chat.panelHeightRight = 340
		E.db.chat.panelWidthRight = 230
		E.db.chat.tabFontSize = 13
	end
end

db.databars = function()

	E.db.databars.customTexture = false
	E.db.databars.statusbar = Private.GetProfileTexture()
	E.db.databars.experience.font = Private.GetProfileFont()
	E.db.databars.experience.fontOutline = 'OUTLINE'
	E.db.databars.experience.showLevel = true
	E.db.databars.experience.showQuestXP = true
	E.db.databars.experience.textFormat = 'REM'
	E.db.databars.experience.orientation = 'HORIZONTAL'
	E.db.databars.petExperience.font = Private.GetProfileFont()
	E.db.databars.petExperience.textFormat = 'REM'
	E.db.databars.petExperience.hideAtMaxLevel = true
	E.db.databars.petExperience.enable = false
	E.db.databars.reputation.enable = false
	E.db.databars.reputation.orientation = 'HORIZONTAL'
	E.db.databars.reputation.font = Private.GetProfileFont()
	E.db.databars.reputation.fontOutline = 'OUTLINE'
	E.db.databars.honor.enable = false
	E.db.databars.honor.orientation = 'HORIZONTAL'
	E.db.databars.honor.font = Private.GetProfileFont()
	E.db.databars.honor.fontOutline = 'OUTLINE'
	E.db.databars.threat.enable = false
	E.db.databars.threat.orientation = 'HORIZONTAL'
	E.db.databars.threat.font = Private.GetProfileFont()
	E.db.databars.threat.fontOutline = 'OUTLINE'

	if Private.GetProfileResolution() == 'QUAD_HD' then
		E.db.databars.experience.textSize = 14
		E.db.databars.experience.height = 30
		E.db.databars.experience.width = 450
		E.db.databars.petExperience.textSize = 14
		E.db.databars.petExperience.height = 25
		E.db.databars.petExperience.width = 350
		E.db.databars.reputation.fontSize = 14
		E.db.databars.reputation.height = 10
		E.db.databars.reputation.width = 350
		E.db.databars.honor.fontSize = 14
		E.db.databars.honor.height = 10
		E.db.databars.honor.width = 350
		E.db.databars.threat.fontSize = 14
		E.db.databars.threat.height = 10
		E.db.databars.threat.width = 350
	elseif Private.GetProfileResolution() == 'FULL_HD' then
		E.db.databars.experience.textSize = 13
		E.db.databars.experience.height = 27
		E.db.databars.experience.width = 396
		E.db.databars.petExperience.textSize = 13
		E.db.databars.petExperience.height = 20
		E.db.databars.petExperience.width = 300
		E.db.databars.reputation.fontSize = 13
		E.db.databars.reputation.height = 10
		E.db.databars.reputation.width = 201
		E.db.databars.honor.fontSize = 13
		E.db.databars.honor.height = 10
		E.db.databars.honor.width = 201
		E.db.databars.threat.fontSize = 13
		E.db.databars.threat.height = 10
		E.db.databars.threat.width = 201
	end

end

db.datatext = function()
	E.db.datatexts.panels.CustomPanel_Left = E.db.datatexts.panels.CustomPanel_Left or {}
	E.db.datatexts.panels.CustomPanel_Right = E.db.datatexts.panels.CustomPanel_Right or {}
	E.db.datatexts.panels.LeftChatDataPanel = E.db.datatexts.panels.LeftChatDataPanel or {}

	E.db.datatexts.font = Private.GetProfileFont()
	E.db.datatexts.panels.CustomPanel_Left[1] = 'System'
	E.db.datatexts.panels.CustomPanel_Left[2] = 'Time'
	E.db.datatexts.panels.CustomPanel_Left.battleground = false
	E.db.datatexts.panels.CustomPanel_Left.enable = true
	E.db.datatexts.panels.CustomPanel_Right[1] = 'Durability'
	E.db.datatexts.panels.CustomPanel_Right[2] = 'Gold'
	E.db.datatexts.panels.CustomPanel_Right.battleground = false
	E.db.datatexts.panels.CustomPanel_Right.enable = true
	E.db.datatexts.panels.LeftChatDataPanel[2] = ''
	E.db.datatexts.panels.LeftChatDataPanel[3] = 'Durability'
	E.db.datatexts.panels.LeftChatDataPanel.enable = false
	E.db.datatexts.panels.MinimapPanel[1] = 'Time'
	E.db.datatexts.panels.MinimapPanel[2] = 'Time'
	E.db.datatexts.panels.MinimapPanel.enable = false
	E.db.datatexts.panels.MinimapPanel.numPoints = 1
	E.db.datatexts.panels.RightChatDataPanel.enable = false

	if Private.GetProfileResolution() == 'QUAD_HD' then
		E.db.datatexts.fontSize = 14
	elseif Private.GetProfileResolution() == 'FULL_HD' then
		E.db.datatexts.fontSize = 13
	end
end

db.tooltip = function()
	E.db.tooltip.font = Private.GetProfileFont()
	E.db.tooltip.fontOutline = 'OUTLINE'
	E.db.tooltip.headerFont = Private.GetProfileFont()
	E.db.tooltip.headerFontOutline = 'OUTLINE'
	E.db.tooltip.healthBar.font = Private.GetProfileFont()
	E.db.tooltip.healthBar.text = false
	E.db.tooltip.cursorAnchor = false
	E.db.tooltip.healthBar.height = 2
	E.db.tooltip.healthBar.statusPosition = 'Disabled'

	if Private.GetProfileResolution() == 'QUAD_HD' then
		E.db.tooltip.headerFontSize = 14
		E.db.tooltip.healthBar.fontSize = 13
		E.db.tooltip.smallTextFontSize = 13
		E.db.tooltip.textFontSize = 13
	elseif Private.GetProfileResolution() == 'FULL_HD' then
		E.db.tooltip.headerFontSize = 13
		E.db.tooltip.healthBar.fontSize = 12
		E.db.tooltip.smallTextFontSize = 12
		E.db.tooltip.textFontSize = 12
	end
end

db.actionbars = function(force)
	if Private.GetBlacklist('actionBars') and not force then
		return
	end

	E.db.cooldown = E.db.cooldown or {}
	E.db.cooldown.targetaura = E.db.cooldown.targetaura or {}
	E.db.cooldown.targetaura.enable = false

	E.db.actionbar.cooldown.fonts.enable = true
	E.db.actionbar.cooldown.fonts.font = Private.GetProfileFont()
	E.db.actionbar.desaturateOnCooldown = true

	E.db.cooldown.fonts = E.db.cooldown.fonts or {}
	E.db.cooldown.fonts.enable = false
	E.db.cooldown.fonts.font = Private.GetProfileFont()
	E.db.cooldown.fonts.fontOutline = 'OUTLINE'

	E.db.WeakAuras = E.db.WeakAuras or {}
	E.db.WeakAuras.cooldown = E.db.WeakAuras.cooldown or {}
	E.db.WeakAuras.cooldown.fonts = E.db.WeakAuras.cooldown.fonts or {}
	E.db.WeakAuras.cooldown.fonts.enable = false
	E.db.WeakAuras.cooldown.fonts.font = Private.GetProfileFont()
	E.db.WeakAuras.cooldown.fonts.fontOutline = 'OUTLINE'

	E.db.actionbar.keyDown = true
	E.db.actionbar.desaturateOnCooldown = true
	E.db.actionbar.flashAnimation = true
	E.db.actionbar.font = Private.GetProfileFont()
	E.db.actionbar.fontOutline = 'OUTLINE'
	E.db.actionbar.macroTextPosition = 'BOTTOMLEFT'
	E.db.actionbar.noRangeColor.b = 0.10196078431373
	E.db.actionbar.noRangeColor.g = 0.10196078431373

	E.db.actionbar.barPet.showGrid = false
	E.db.actionbar.barPet.mouseover = true
	E.db.actionbar.barPet.alpha = 0.85
	E.db.actionbar.barPet.backdrop = false
	E.db.actionbar.barPet.buttonSpacing = -1
	E.db.actionbar.barPet.buttonsPerRow = 10
	E.db.actionbar.barPet.countFont = Private.GetProfileFont()
	E.db.actionbar.barPet.countFontOutline = 'OUTLINE'
	E.db.actionbar.barPet.hotkeyFont = Private.GetProfileFont()
	E.db.actionbar.barPet.hotkeyFontOutline = 'OUTLINE'
	E.db.actionbar.barPet.hotkeyTextXOffset = 1
	E.db.actionbar.barPet.point = 'TOPLEFT'

	E.db.actionbar.extraActionButton.clean = true
	E.db.actionbar.extraActionButton.hotkeyFont = Private.GetProfileFont()
	E.db.actionbar.extraActionButton.hotkeyFontOutline = 'OUTLINE'

	E.db.actionbar.microbar.alpha = 0.85
	E.db.actionbar.microbar.backdropSpacing = 0
	E.db.actionbar.microbar.buttonSpacing = 1
	E.db.actionbar.microbar.enabled = true
	E.db.actionbar.microbar.mouseover = true
	E.db.actionbar.microbar.useIcons = false

	E.db.actionbar.stanceBar.alpha = 0.85
	E.db.actionbar.stanceBar.buttonSpacing = -1
	E.db.actionbar.stanceBar.hotkeyFont = Private.GetProfileFont()
	E.db.actionbar.stanceBar.hotkeyFontOutline = 'OUTLINE'
	E.db.actionbar.stanceBar.mouseover = true
	E.db.actionbar.stanceBar.style = 'classic'

	E.db.actionbar.totemBar.font = Private.GetProfileFont()

	E.db.actionbar.bar1.enabled = true
	E.db.actionbar.bar2.enabled = false
	E.db.actionbar.bar3.enabled = true
	E.db.actionbar.bar4.enabled = true
	E.db.actionbar.bar5.enabled = true
	E.db.actionbar.bar6.enabled = false

	local showMouseover, showGrid = Private.GetActionBarsSettings()
	for i = 1, 10 do
		E.db.actionbar['bar' .. i].buttons = 12
		E.db.actionbar['bar' .. i].buttonsPerRow = 12
		E.db.actionbar['bar' .. i].mouseover = showMouseover
		E.db.actionbar['bar' .. i].showGrid = showGrid
		E.db.actionbar['bar' .. i].backdrop = false
		E.db.actionbar['bar' .. i].alpha = 0.85
		E.db.actionbar['bar' .. i].buttonSpacing = -1
		E.db.actionbar['bar' .. i].countFont = Private.GetProfileFont()
		E.db.actionbar['bar' .. i].countFontOutline = 'OUTLINE'
		E.db.actionbar['bar' .. i].hotkeyFont = Private.GetProfileFont()
		E.db.actionbar['bar' .. i].hotkeyFontOutline = 'OUTLINE'
		E.db.actionbar['bar' .. i].macroFont = Private.GetProfileFont()
		E.db.actionbar['bar' .. i].macroFontOutline = 'OUTLINE'
		E.db.actionbar['bar' .. i].macroTextPosition = 'BOTTOM'
		E.db.actionbar['bar' .. i].macroTextYOffset = 2
		E.db.actionbar['bar' .. i].macrotext = true
		E.db.actionbar['bar' .. i].visibility = ''
		E.db.actionbar['bar' .. i].point = 'BOTTOMLEFT'
	end

	if Private.GetProfileResolution() == 'QUAD_HD' then
		E.db.actionbar.fontSize = 12
		E.db.actionbar.extraActionButton.hotkeyFontSize = 14

		for i = 1, 10 do
			E.db.actionbar['bar' .. i].buttonSize = 36
			E.db.actionbar['bar' .. i].hotkeyFontSize = 14
			E.db.actionbar['bar' .. i].countFontSize = 14
			E.db.actionbar['bar' .. i].macroFontSize = 13
		end

		E.db.actionbar.vehicleExitButton = E.db.actionbar.vehicleExitButton or {}
		E.db.actionbar.vehicleExitButton.buttonSize = 36
		E.db.actionbar.vehicleExitButton.hotkeyFontSize = 14
		E.db.actionbar.stanceBar = E.db.actionbar.stanceBar or {}
		E.db.actionbar.stanceBar.buttonSize = 36
		E.db.actionbar.stanceBar.hotkeyFontSize = 14
		E.db.actionbar.microbar = E.db.actionbar.microbar or {}
		E.db.actionbar.microbar.buttonHeight = 23
		E.db.actionbar.microbar.buttonSize = 20
		E.db.actionbar.barPet = E.db.actionbar.barPet or {}
		E.db.actionbar.barPet.buttonSize = 36
		E.db.actionbar.barPet.countFontSize = 14
		E.db.actionbar.barPet.hotkeyFontSize = 14
		E.db.actionbar.totemBar = E.db.actionbar.totemBar or {}
		E.db.actionbar.totemBar.buttonSize = 36
		E.db.actionbar.totemBar.flyoutSize = 36
		E.db.actionbar.totemBar.spacing = -1
		E.db.actionbar.totemBar.fontSize = 14
		E.db.actionbar.cooldown.fonts.fontSize = 14
	elseif Private.GetProfileResolution() == 'FULL_HD' then
		E.db.actionbar.fontSize = 13
		E.db.actionbar.extraActionButton.hotkeyFontSize = 13

		for i = 1, 10 do
			E.db.actionbar['bar' .. i].buttonSize = 32
			E.db.actionbar['bar' .. i].hotkeyFontSize = 13
			E.db.actionbar['bar' .. i].countFontSize = 13
			E.db.actionbar['bar' .. i].macroFontSize = 13
		end

		E.db.actionbar.vehicleExitButton = E.db.actionbar.vehicleExitButton or {}
		E.db.actionbar.vehicleExitButton.buttonSize = 34
		E.db.actionbar.vehicleExitButton.hotkeyFontSize = 13
		E.db.actionbar.stanceBar = E.db.actionbar.stanceBar or {}
		E.db.actionbar.stanceBar.buttonSize = 32
		E.db.actionbar.stanceBar.hotkeyFontSize = 13
		E.db.actionbar.microbar = E.db.actionbar.microbar or {}
		E.db.actionbar.microbar.buttonHeight = 21
		E.db.actionbar.microbar.buttonSize = 19
		E.db.actionbar.barPet = E.db.actionbar.barPet or {}
		E.db.actionbar.barPet.buttonSize = 32
		E.db.actionbar.barPet.countFontSize = 13
		E.db.actionbar.barPet.hotkeyFontSize = 13
		E.db.actionbar.totemBar = E.db.actionbar.totemBar or {}
		E.db.actionbar.totemBar.buttonSize = 32
		E.db.actionbar.totemBar.flyoutSize = 32
		E.db.actionbar.totemBar.spacing = -1
		E.db.actionbar.totemBar.fontSize = 13
		E.db.actionbar.cooldown.fonts.fontSize = 13
	end
end

db.unitframes = function(layout)

	E.db.unitframe = E.db.unitframe or {}
	E.db.unitframe.units = E.db.unitframe.units or {}
	E.db.unitframe.units.raid = E.db.unitframe.units.raid or {}
	E.db.unitframe.units.raid40 = E.db.unitframe.units.raid40 or {}
	E.db.unitframe.units.party = E.db.unitframe.units.party or {}

	E.db.unitframe.smartRaidFilter = false

	E.db.unitframe.auraBlacklistModifier = 'NONE'

	-- UF custom texts
	E.db.unitframe.units.arena.customTexts = E.db.unitframe.units.arena.customTexts or {}
	E.db.unitframe.units.arena.customTexts.UnitHealth = E.db.unitframe.units.arena.customTexts.UnitHealth or {}
	E.db.unitframe.units.arena.customTexts.UnitName = E.db.unitframe.units.arena.customTexts.UnitName or {}
	E.db.unitframe.units.arena.customTexts.UnitPower = E.db.unitframe.units.arena.customTexts.UnitPower or {}

	E.db.unitframe.units.focus.customTexts = E.db.unitframe.units.focus.customTexts or {}
	E.db.unitframe.units.focus.customTexts.UnitName = E.db.unitframe.units.focus.customTexts.UnitName or {}
	E.db.unitframe.units.focus.customTexts.UnitPower = E.db.unitframe.units.focus.customTexts.UnitPower or {}
	E.db.unitframe.units.focus.customTexts.UnitHealth = E.db.unitframe.units.focus.customTexts.UnitHealth or {}

	E.db.unitframe.units.party.customTexts = E.db.unitframe.units.party.customTexts or {}
	E.db.unitframe.units.party.customTexts.DeadGhostStatus = E.db.unitframe.units.party.customTexts.DeadGhostStatus or {}
	E.db.unitframe.units.party.customTexts.UnitName = E.db.unitframe.units.party.customTexts.UnitName or {}
	E.db.unitframe.units.party.customTexts.OfflineStatus = E.db.unitframe.units.party.customTexts.OfflineStatus or {}
	E.db.unitframe.units.party.customTexts.UnitHealth = E.db.unitframe.units.party.customTexts.UnitHealth or {}

	E.db.unitframe.units.pet.customTexts = E.db.unitframe.units.pet.customTexts or {}
	E.db.unitframe.units.pet.customTexts.UnitHealth = E.db.unitframe.units.pet.customTexts.UnitHealth or {}
	E.db.unitframe.units.pet.customTexts.UnitName = E.db.unitframe.units.pet.customTexts.UnitName or {}
	E.db.unitframe.units.pet.customTexts.UnitPower = E.db.unitframe.units.pet.customTexts.UnitPower or {}

	E.db.unitframe.units.player.customTexts = E.db.unitframe.units.player.customTexts or {}
	E.db.unitframe.units.player.customTexts.UnitName = E.db.unitframe.units.player.customTexts.UnitName or {}
	E.db.unitframe.units.player.customTexts.UnitPower = E.db.unitframe.units.player.customTexts.UnitPower or {}
	E.db.unitframe.units.player.customTexts.UnitHealth = E.db.unitframe.units.player.customTexts.UnitHealth or {}
	E.db.unitframe.units.player.customTexts.UnitHealthNew = E.db.unitframe.units.player.customTexts.UnitHealthNew or {}

	E.db.unitframe.units.raid.customTexts = E.db.unitframe.units.raid.customTexts or {}
	E.db.unitframe.units.raid.customTexts.DeadGhostStatus = E.db.unitframe.units.raid.customTexts.DeadGhostStatus or {}
	E.db.unitframe.units.raid.customTexts.UnitName = E.db.unitframe.units.raid.customTexts.UnitName or {}

	E.db.unitframe.units.raid40.customTexts = E.db.unitframe.units.raid40.customTexts or {}
	E.db.unitframe.units.raid40.customTexts.DeadGhostStatus = E.db.unitframe.units.raid40.customTexts.DeadGhostStatus
		or {}
	E.db.unitframe.units.raid40.customTexts.UnitName = E.db.unitframe.units.raid40.customTexts.UnitName or {}

	E.db.unitframe.units.raidpet.customTexts = E.db.unitframe.units.raidpet.customTexts or {}
	E.db.unitframe.units.raidpet.customTexts.UnitName = E.db.unitframe.units.raidpet.customTexts.UnitName or {}

	E.db.unitframe.units.target.customTexts = E.db.unitframe.units.target.customTexts or {}
	E.db.unitframe.units.target.customTexts.UnitName = E.db.unitframe.units.target.customTexts.UnitName or {}
	E.db.unitframe.units.target.customTexts.UnitPower = E.db.unitframe.units.target.customTexts.UnitPower or {}
	E.db.unitframe.units.target.customTexts.UnitHealth = E.db.unitframe.units.target.customTexts.UnitHealth or {}

	E.db.unitframe.units.targettarget.customTexts = E.db.unitframe.units.targettarget.customTexts or {}
	E.db.unitframe.units.targettarget.customTexts.UnitName = E.db.unitframe.units.targettarget.customTexts.UnitName or {}

	E.db.unitframe.units.boss.customTexts = E.db.unitframe.units.boss.customTexts or {}
	E.db.unitframe.units.boss.customTexts.UnitName = E.db.unitframe.units.boss.customTexts.UnitName or {}
	E.db.unitframe.units.boss.customTexts.UnitPower = E.db.unitframe.units.boss.customTexts.UnitPower or {}
	E.db.unitframe.units.boss.customTexts.UnitHealth = E.db.unitframe.units.boss.customTexts.UnitHealth or {}

	local unitFrames = { 'party', 'raid', 'raid40', 'raidpet' }

	for _, unitFrame in ipairs(unitFrames) do
		E.db.unitframe.units[unitFrame] = E.db.unitframe.units[unitFrame] or {}
		E.db.unitframe.units[unitFrame].buffIndicator = E.db.unitframe.units[unitFrame].buffIndicator or {}
		E.db.unitframe.units[unitFrame].debuffs = E.db.unitframe.units[unitFrame].debuffs or {}
		E.db.unitframe.units[unitFrame].buffs = E.db.unitframe.units[unitFrame].buffs or {}
		E.db.unitframe.units[unitFrame].rdebuffs = E.db.unitframe.units[unitFrame].rdebuffs or {}

		E.db.unitframe.units[unitFrame].buffIndicator.enable = true
		E.db.unitframe.units[unitFrame].debuffs.enable = true
		E.db.unitframe.units[unitFrame].buffs.enable = unitFrame ~= 'raidpet'
		E.db.unitframe.units[unitFrame].rdebuffs.enable = unitFrame ~= 'raidpet' and unitFrame ~= 'party'
		-- Load Raid Debuffs Indicator on everything but raidpet (we modified filters for raidpet)
	end

	-- Threat Style
	E.db.unitframe.units.raid.threatStyle = 'ICONLEFT'
	E.db.unitframe.units.raid40.threatStyle = 'ICONLEFT'
	E.db.unitframe.units.party.threatStyle = 'ICONLEFT'

	-- Colors
	E.db.unitframe.colors.castColor.b = 0
	E.db.unitframe.colors.castColor.g = 0.67843137254902
	E.db.unitframe.colors.castColor.r = 1
	E.db.unitframe.colors.castNoInterrupt.b = 0.25098039215686
	E.db.unitframe.colors.castNoInterrupt.g = 0.25098039215686
	E.db.unitframe.colors.castNoInterrupt.r = 0.78039215686275
	E.db.unitframe.colors.castbar_backdrop.b = 0.10588235294118
	E.db.unitframe.colors.castbar_backdrop.g = 0.10588235294118
	E.db.unitframe.colors.castbar_backdrop.r = 0.2078431372549
	E.db.unitframe.colors.colorhealthbyvalue = false
	E.db.unitframe.colors.customcastbarbackdrop = true
	E.db.unitframe.colors.customhealthbackdrop = true
	E.db.unitframe.colors.debuffHighlight.blendMode = 'ALPHAKEY'
	E.db.unitframe.colors.frameGlow.mouseoverGlow.enable = false
	E.db.unitframe.colors.frameGlow.mouseoverGlow.texture = Private.GetProfileTexture()
	E.db.unitframe.colors.frameGlow.targetGlow.enable = false
	E.db.unitframe.colors.health.b = 0.17254901960784
	E.db.unitframe.colors.health.g = 0.17254901960784
	E.db.unitframe.colors.health.r = 0.1921568627451
	E.db.unitframe.colors.health_backdrop.b = 0.23137254901961
	E.db.unitframe.colors.health_backdrop.g = 0.23137254901961
	E.db.unitframe.colors.health_backdrop.r = 0.27058823529412
	E.db.unitframe.colors.health_backdrop_dead.b = 0.46274509803922
	E.db.unitframe.colors.health_backdrop_dead.g = 0.46274509803922
	E.db.unitframe.colors.health_backdrop_dead.r = 0.51764705882353
	E.db.unitframe.colors.healthclass = true
	E.db.unitframe.colors.transparentHealth = E.private.MUI.general.profileSettings.unitframes.transparentHealth
	E.db.unitframe.colors.power.MANA.b = 1
	E.db.unitframe.colors.power.MANA.g = 0.86274509803922
	E.db.unitframe.colors.power.MANA.r = 0.019607843137255

	-- Cooldown
	E.db.unitframe.cooldown.fonts.enable = true
	E.db.unitframe.cooldown.fonts.font = Private.GetProfileFont()

	E.db.unitframe.font = Private.GetProfileFont()
	E.db.unitframe.fontOutline = 'OUTLINE'
	E.db.unitframe.statusbar = Private.GetProfileTexture()

	-- UF: Player
	E.db.unitframe.units.player.RestIcon.enable = false
	E.db.unitframe.units.player.aurabar.enable = false
	E.db.unitframe.units.player.buffs.anchorPoint = 'TOPRIGHT'
	E.db.unitframe.units.player.buffs.countFont = Private.GetProfileFont()
	E.db.unitframe.units.player.castbar.enable = Private.GetPlayerCastBar()
	E.db.unitframe.units.player.castbar.tickWidth = 1
	E.db.unitframe.units.player.castbar.format = 'CURRENTMAX'
	E.db.unitframe.units.player.castbar.spark = false
	E.db.unitframe.units.player.classbar.enable = false
	E.db.unitframe.units.player.colorOverride = 'FORCE_ON'
	E.db.unitframe.units.player.customTexts.UnitPower.attachTextTo = 'Health'
	E.db.unitframe.units.player.customTexts.UnitPower.enable = false
	E.db.unitframe.units.player.customTexts.UnitPower.font = Private.GetProfileFont()
	E.db.unitframe.units.player.customTexts.UnitPower.fontOutline = 'OUTLINE'
	E.db.unitframe.units.player.customTexts.UnitPower.justifyH = 'LEFT'
	E.db.unitframe.units.player.customTexts.UnitPower.text_format = '[power:current]'
	E.db.unitframe.units.player.customTexts.UnitHealth.attachTextTo = 'Health'
	E.db.unitframe.units.player.customTexts.UnitHealth.enable = true
	E.db.unitframe.units.player.customTexts.UnitHealth.font = Private.GetProfileFont()
	E.db.unitframe.units.player.customTexts.UnitHealth.fontOutline = 'OUTLINE'
	E.db.unitframe.units.player.customTexts.UnitHealth.justifyH = 'RIGHT'
	E.db.unitframe.units.player.customTexts.UnitHealth.text_format = '[health:current:shortvalue]'
	E.db.unitframe.units.player.customTexts.UnitHealth.xOffset = -2
	E.db.unitframe.units.player.customTexts.UnitHealth.yOffset = 0
	E.db.unitframe.units.player.customTexts.UnitHealthNew.attachTextTo = 'Health'
	E.db.unitframe.units.player.customTexts.UnitHealthNew.enable = false
	E.db.unitframe.units.player.customTexts.UnitHealthNew.font = Private.GetProfileFont()
	E.db.unitframe.units.player.customTexts.UnitHealthNew.fontOutline = 'OUTLINE'
	E.db.unitframe.units.player.customTexts.UnitHealthNew.justifyH = 'RIGHT'
	E.db.unitframe.units.player.customTexts.UnitHealthNew.text_format = '[health:current] || [health:percent]'
	E.db.unitframe.units.player.customTexts.UnitName.attachTextTo = 'Health'
	E.db.unitframe.units.player.customTexts.UnitName.enable = false
	E.db.unitframe.units.player.customTexts.UnitName.font = Private.GetProfileFont()
	E.db.unitframe.units.player.customTexts.UnitName.fontOutline = 'OUTLINE'
	E.db.unitframe.units.player.customTexts.UnitName.justifyH = 'RIGHT'
	E.db.unitframe.units.player.customTexts.UnitName.text_format = '[name:abbrev:short]'
	E.db.unitframe.units.player.debuffs.anchorPoint = 'TOPRIGHT'
	E.db.unitframe.units.player.debuffs.enable = false
	E.db.unitframe.units.player.healPrediction.enable = true
	E.db.unitframe.units.player.health.text_format = ''
	E.db.unitframe.units.player.power.enable = false
	E.db.unitframe.units.player.power.text_format = ''
	E.db.unitframe.units.player.pvp.text_format = ''
	E.db.unitframe.units.player.raidRoleIcons.enable = false
	E.db.unitframe.units.player.threatStyle = 'NONE'
	E.db.unitframe.units.player.raidicon.attachTo = 'LEFT'
	E.db.unitframe.units.player.raidicon.attachToObject = 'Health'
	E.db.unitframe.units.player.raidicon.xOffset = 5
	E.db.unitframe.units.player.raidicon.yOffset = 0
	E.db.unitframe.units.player.portrait.enable = Private.GetPlayerPortrait()
	E.db.unitframe.units.player.portrait.overlay = true

	-- UF: Target
	E.db.unitframe.units.target.combobar.enable = false
	E.db.unitframe.units.target.aurabar.enable = false
	E.db.unitframe.units.target.buffs.attachTo = 'DEBUFFS'
	E.db.unitframe.units.target.buffs.countFont = Private.GetProfileFont()
	E.db.unitframe.units.target.buffs.spacing = -1
	E.db.unitframe.units.target.buffs.yOffset = -1
	E.db.unitframe.units.target.buffs.priority = 'Blacklist,Personal,Friendly:nonPersonal'
	E.db.unitframe.units.target.castbar.enable = Private.GetTargetCastBar()
	E.db.unitframe.units.target.castbar.spark = false
	E.db.unitframe.units.target.castbar.strataAndLevel.useCustomLevel = true
	E.db.unitframe.units.target.colorOverride = 'FORCE_ON'

	E.db.unitframe.units.target.customTexts.UnitPower.attachTextTo = 'Health'
	E.db.unitframe.units.target.customTexts.UnitPower.enable = true
	E.db.unitframe.units.target.customTexts.UnitPower.font = Private.GetProfileFont()
	E.db.unitframe.units.target.customTexts.UnitPower.fontOutline = 'OUTLINE'
	E.db.unitframe.units.target.customTexts.UnitPower.justifyH = 'RIGHT'
	E.db.unitframe.units.target.customTexts.UnitPower.text_format = '[power:current:shortvalue]'

	E.db.unitframe.units.target.customTexts.UnitHealth.attachTextTo = 'Health'
	E.db.unitframe.units.target.customTexts.UnitHealth.enable = true
	E.db.unitframe.units.target.customTexts.UnitHealth.font = Private.GetProfileFont()
	E.db.unitframe.units.target.customTexts.UnitHealth.fontOutline = 'OUTLINE'
	E.db.unitframe.units.target.customTexts.UnitHealth.justifyH = 'LEFT'
	E.db.unitframe.units.target.customTexts.UnitHealth.text_format = '[health:percent] || [health:current:shortvalue]'

	E.db.unitframe.units.target.customTexts.UnitName.attachTextTo = 'Health'
	E.db.unitframe.units.target.customTexts.UnitName.enable = true
	E.db.unitframe.units.target.customTexts.UnitName.font = Private.GetProfileFont()
	E.db.unitframe.units.target.customTexts.UnitName.fontOutline = 'OUTLINE'
	E.db.unitframe.units.target.customTexts.UnitName.justifyH = 'LEFT'
	E.db.unitframe.units.target.customTexts.UnitName.text_format = '[name:abbrev:short]'

	E.db.unitframe.units.target.debuffs.attachTo = 'FRAME'
	E.db.unitframe.units.target.debuffs.countFont = Private.GetProfileFont()
	E.db.unitframe.units.target.debuffs.spacing = -1
	E.db.unitframe.units.target.debuffs.yOffset = -1
	E.db.unitframe.units.target.debuffs.priority = 'Blacklist,Personal,RaidDebuffs,CCDebuffs,Friendly:Dispellable,Friendly:notCastByUnit,Friendly:CastByNPC'
	E.db.unitframe.units.target.fader.enable = false
	E.db.unitframe.units.target.fader.range = false
	E.db.unitframe.units.target.healPrediction.enable = true
	E.db.unitframe.units.target.health.text_format = ''
	E.db.unitframe.units.target.name.text_format = ''
	E.db.unitframe.units.target.power.text_format = ''
	E.db.unitframe.units.target.raidicon.attachTo = 'CENTER'
	E.db.unitframe.units.target.raidicon.attachToObject = 'Health'
	E.db.unitframe.units.target.raidicon.yOffset = 0
	E.db.unitframe.units.target.smartAuraPosition = 'FLUID_BUFFS_ON_DEBUFFS'
	E.db.unitframe.units.target.threatStyle = 'NONE'
	E.db.unitframe.units.target.portrait.enable = Private.GetTargetPortrait()
	E.db.unitframe.units.target.portrait.overlay = true

	E.db.unitframe.units.targettarget.debuffs.enable = false
	E.db.unitframe.units.targettarget.debuffs.yOffset = -2
	E.db.unitframe.units.targettarget.customTexts.UnitName.attachTextTo = 'Health'
	E.db.unitframe.units.targettarget.customTexts.UnitName.enable = true
	E.db.unitframe.units.targettarget.customTexts.UnitName.text_format = '[name:abbrev:short]'
	E.db.unitframe.units.targettarget.customTexts.UnitName.yOffset = 0
	E.db.unitframe.units.targettarget.customTexts.UnitName.font = Private.GetProfileFont()
	E.db.unitframe.units.targettarget.customTexts.UnitName.justifyH = 'CENTER'
	E.db.unitframe.units.targettarget.customTexts.UnitName.fontOutline = 'OUTLINE'
	E.db.unitframe.units.targettarget.customTexts.UnitName.xOffset = 0
	E.db.unitframe.units.targettarget.colorOverride = 'FORCE_ON'
	E.db.unitframe.units.targettarget.fader.enable = false
	E.db.unitframe.units.targettarget.health.frequentUpdates = true
	E.db.unitframe.units.targettarget.name.text_format = ''
	E.db.unitframe.units.targettarget.buffs.anchorPoint = 'TOPRIGHT'
	E.db.unitframe.units.targettarget.buffs.countFont = Private.GetProfileFont()
	E.db.unitframe.units.targettarget.buffs.maxDuration = 0
	E.db.unitframe.units.targettarget.buffs.yOffset = -2
	E.db.unitframe.units.targettarget.orientation = 'RIGHT'

	-- UF: Pet
	E.db.unitframe.units.pet.buffs.priority = 'Blacklist,Personal,PlayerBuffs,Dispellable'
	E.db.unitframe.units.pet.debuffs.attachTo = 'BUFFS'
	E.db.unitframe.units.pet.debuffs.priority = 'Blacklist,Personal,Boss,RaidDebuffs,CCDebuffs,Dispellable,Whitelist'
	E.db.unitframe.units.pet.fader.enable = false
	E.db.unitframe.units.pet.healPrediction.enable = false
	E.db.unitframe.units.pet.name.text_format = ''
	E.db.unitframe.units.pet.power.attachTextTo = 'Frame'
	E.db.unitframe.units.pet.power.height = 6
	E.db.unitframe.units.pet.power.xOffset = 0
	E.db.unitframe.units.pet.threatStyle = 'NONE'
	E.db.unitframe.units.pet.castbar.enable = Private.GetPetCastBar()
	E.db.unitframe.units.pet.colorOverride = 'FORCE_ON'
	E.db.unitframe.units.pet.customTexts.UnitPower.attachTextTo = 'Power'
	E.db.unitframe.units.pet.customTexts.UnitPower.enable = true
	E.db.unitframe.units.pet.customTexts.UnitPower.font = Private.GetProfileFont()
	E.db.unitframe.units.pet.customTexts.UnitPower.fontOutline = 'OUTLINE'
	E.db.unitframe.units.pet.customTexts.UnitPower.justifyH = 'CENTER'
	E.db.unitframe.units.pet.customTexts.UnitPower.text_format = '[power:current:shortvalue]'
	E.db.unitframe.units.pet.customTexts.UnitPower.xOffset = 0
	E.db.unitframe.units.pet.customTexts.UnitPower.yOffset = 0
	E.db.unitframe.units.pet.customTexts.UnitHealth.attachTextTo = 'Health'
	E.db.unitframe.units.pet.customTexts.UnitHealth.enable = true
	E.db.unitframe.units.pet.customTexts.UnitHealth.font = Private.GetProfileFont()
	E.db.unitframe.units.pet.customTexts.UnitHealth.fontOutline = 'OUTLINE'
	E.db.unitframe.units.pet.customTexts.UnitHealth.justifyH = 'CENTER'
	E.db.unitframe.units.pet.customTexts.UnitHealth.text_format = '[health:current:shortvalue] - [health:max:shortvalue]'
	E.db.unitframe.units.pet.customTexts.UnitHealth.xOffset = 0
	E.db.unitframe.units.pet.customTexts.UnitHealth.yOffset = 0
	E.db.unitframe.units.pet.customTexts.UnitName.attachTextTo = 'Health'
	E.db.unitframe.units.pet.customTexts.UnitName.enable = false
	E.db.unitframe.units.pet.customTexts.UnitName.font = Private.GetProfileFont()
	E.db.unitframe.units.pet.customTexts.UnitName.fontOutline = 'OUTLINE'
	E.db.unitframe.units.pet.customTexts.UnitName.justifyH = 'CENTER'
	E.db.unitframe.units.pet.customTexts.UnitName.text_format = '[name:abbrev:short]'
	E.db.unitframe.units.pet.customTexts.UnitName.xOffset = 0
	E.db.unitframe.units.pet.customTexts.UnitName.yOffset = 0

	-- UF: Focus
	E.db.unitframe.units.focus.colorOverride = 'FORCE_ON'
	E.db.unitframe.units.focus.disableTargetGlow = true
	E.db.unitframe.units.focus.fader.enable = false
	E.db.unitframe.units.focus.healPrediction.enable = false
	E.db.unitframe.units.focus.name.text_format = ''
	E.db.unitframe.units.focus.orientation = 'RIGHT'
	E.db.unitframe.units.focus.power.attachTextTo = 'Power'
	E.db.unitframe.units.focus.power.height = 6
	E.db.unitframe.units.focus.power.position = 'CENTER'
	E.db.unitframe.units.focus.threatStyle = 'NONE'

	E.db.unitframe.units.focus.buffs.anchorPoint = 'TOPRIGHT'
	E.db.unitframe.units.focus.buffs.countFont = Private.GetProfileFont()
	E.db.unitframe.units.focus.buffs.enable = false
	E.db.unitframe.units.focus.buffs.growthX = 'LEFT'
	E.db.unitframe.units.focus.buffs.maxDuration = 0
	E.db.unitframe.units.focus.buffs.priority = 'Blacklist,Personal,nonPersonal'
	E.db.unitframe.units.focus.buffs.spacing = -1
	E.db.unitframe.units.focus.buffs.yOffset = -2

	E.db.unitframe.units.focus.debuffs.anchorPoint = 'LEFT'
	E.db.unitframe.units.focus.debuffs.countFont = Private.GetProfileFont()
	E.db.unitframe.units.focus.debuffs.enable = false
	E.db.unitframe.units.focus.debuffs.perrow = 6
	E.db.unitframe.units.focus.debuffs.priority = 'Blacklist,Personal,RaidDebuffs,CCDebuffs,Friendly:Dispellable'
	E.db.unitframe.units.focus.debuffs.spacing = -1
	E.db.unitframe.units.focus.debuffs.xOffset = -7
	E.db.unitframe.units.focus.debuffs.yOffset = -2

	E.db.unitframe.units.focus.castbar.enable = Private.GetFocusCastBar()
	E.db.unitframe.units.focus.castbar.spark = false
	E.db.unitframe.units.focus.castbar.strataAndLevel.frameStrata = 'BACKGROUND'
	E.db.unitframe.units.focus.castbar.strataAndLevel.useCustomStrata = true

	E.db.unitframe.units.focus.customTexts.UnitPower.attachTextTo = 'Health'
	E.db.unitframe.units.focus.customTexts.UnitPower.enable = true
	E.db.unitframe.units.focus.customTexts.UnitPower.font = Private.GetProfileFont()
	E.db.unitframe.units.focus.customTexts.UnitPower.fontOutline = 'OUTLINE'
	E.db.unitframe.units.focus.customTexts.UnitPower.justifyH = 'RIGHT'
	E.db.unitframe.units.focus.customTexts.UnitPower.text_format = '[power:current:shortvalue]'

	E.db.unitframe.units.focus.customTexts.UnitHealth.attachTextTo = 'Health'
	E.db.unitframe.units.focus.customTexts.UnitHealth.enable = true
	E.db.unitframe.units.focus.customTexts.UnitHealth.font = Private.GetProfileFont()
	E.db.unitframe.units.focus.customTexts.UnitHealth.fontOutline = 'OUTLINE'
	E.db.unitframe.units.focus.customTexts.UnitHealth.justifyH = 'LEFT'
	E.db.unitframe.units.focus.customTexts.UnitHealth.text_format = '[health:percent] || [health:current:shortvalue]'

	E.db.unitframe.units.focus.customTexts.UnitName.attachTextTo = 'Health'
	E.db.unitframe.units.focus.customTexts.UnitName.enable = true
	E.db.unitframe.units.focus.customTexts.UnitName.font = Private.GetProfileFont()
	E.db.unitframe.units.focus.customTexts.UnitName.fontOutline = 'OUTLINE'
	E.db.unitframe.units.focus.customTexts.UnitName.justifyH = 'LEFT'
	E.db.unitframe.units.focus.customTexts.UnitName.text_format = '[name:abbrev:short]'

	-- UF: Arena
	E.db.unitframe.units.arena.buffs.countFont = Private.GetProfileFont()
	E.db.unitframe.units.arena.buffs.enable = false
	E.db.unitframe.units.arena.buffs.maxDuration = 0
	E.db.unitframe.units.arena.buffs.priority = 'Blacklist,CastByUnit,Dispellable,Whitelist,RaidBuffsElvUI'
	E.db.unitframe.units.arena.colorOverride = 'FORCE_ON'

	E.db.unitframe.units.arena.customTexts.UnitPower.attachTextTo = 'Health'
	E.db.unitframe.units.arena.customTexts.UnitPower.enable = true
	E.db.unitframe.units.arena.customTexts.UnitPower.font = Private.GetProfileFont()
	E.db.unitframe.units.arena.customTexts.UnitPower.fontOutline = 'OUTLINE'
	E.db.unitframe.units.arena.customTexts.UnitPower.justifyH = 'RIGHT'
	E.db.unitframe.units.arena.customTexts.UnitPower.text_format = '[power:current:shortvalue]'

	E.db.unitframe.units.arena.customTexts.UnitHealth.attachTextTo = 'Health'
	E.db.unitframe.units.arena.customTexts.UnitHealth.enable = true
	E.db.unitframe.units.arena.customTexts.UnitHealth.font = Private.GetProfileFont()
	E.db.unitframe.units.arena.customTexts.UnitHealth.fontOutline = 'OUTLINE'
	E.db.unitframe.units.arena.customTexts.UnitHealth.justifyH = 'LEFT'
	E.db.unitframe.units.arena.customTexts.UnitHealth.text_format = '[health:percent]'

	E.db.unitframe.units.arena.customTexts.UnitName.attachTextTo = 'Health'
	E.db.unitframe.units.arena.customTexts.UnitName.enable = true
	E.db.unitframe.units.arena.customTexts.UnitName.font = Private.GetProfileFont()
	E.db.unitframe.units.arena.customTexts.UnitName.fontOutline = 'OUTLINE'
	E.db.unitframe.units.arena.customTexts.UnitName.justifyH = 'LEFT'
	E.db.unitframe.units.arena.customTexts.UnitName.text_format = '[name:abbrev:short]'

	E.db.unitframe.units.arena.debuffs.countFont = Private.GetProfileFont()
	E.db.unitframe.units.arena.debuffs.desaturate = true
	E.db.unitframe.units.arena.debuffs.enable = false
	E.db.unitframe.units.arena.debuffs.maxDuration = 0
	E.db.unitframe.units.arena.debuffs.priority = 'Blacklist,Boss,Personal,RaidDebuffs,CastByUnit,Whitelist'
	E.db.unitframe.units.arena.debuffs.yOffset = -3
	E.db.unitframe.units.arena.growthDirection = 'UP'
	E.db.unitframe.units.arena.healPrediction.enable = false
	E.db.unitframe.units.arena.health.text_format = ''
	E.db.unitframe.units.arena.name.text_format = ''
	E.db.unitframe.units.arena.power.text_format = ''
	E.db.unitframe.units.arena.spacing = 3

	-- UF: Assist
	E.db.unitframe.units.assist.enable = false

	-- UF: Boss
	E.db.unitframe.units.boss.buffs.countFont = Private.GetProfileFont()
	E.db.unitframe.units.boss.buffs.enable = true
	E.db.unitframe.units.boss.buffs.anchorPoint = 'RIGHT'
	E.db.unitframe.units.boss.buffs.numrows = 2
	E.db.unitframe.units.boss.colorOverride = 'FORCE_ON'

	E.db.unitframe.units.boss.customTexts.UnitPower.attachTextTo = 'Health'
	E.db.unitframe.units.boss.customTexts.UnitPower.enable = true
	E.db.unitframe.units.boss.customTexts.UnitPower.font = Private.GetProfileFont()
	E.db.unitframe.units.boss.customTexts.UnitPower.fontOutline = 'OUTLINE'
	E.db.unitframe.units.boss.customTexts.UnitPower.justifyH = 'RIGHT'
	E.db.unitframe.units.boss.customTexts.UnitPower.text_format = '[power:current:shortvalue]'

	E.db.unitframe.units.boss.customTexts.UnitHealth.attachTextTo = 'Health'
	E.db.unitframe.units.boss.customTexts.UnitHealth.enable = true
	E.db.unitframe.units.boss.customTexts.UnitHealth.font = Private.GetProfileFont()
	E.db.unitframe.units.boss.customTexts.UnitHealth.fontOutline = 'OUTLINE'
	E.db.unitframe.units.boss.customTexts.UnitHealth.justifyH = 'LEFT'
	E.db.unitframe.units.boss.customTexts.UnitHealth.text_format = '[health:percent]'

	E.db.unitframe.units.boss.customTexts.UnitName.attachTextTo = 'Health'
	E.db.unitframe.units.boss.customTexts.UnitName.enable = true
	E.db.unitframe.units.boss.customTexts.UnitName.font = Private.GetProfileFont()
	E.db.unitframe.units.boss.customTexts.UnitName.fontOutline = 'OUTLINE'
	E.db.unitframe.units.boss.customTexts.UnitName.justifyH = 'LEFT'
	E.db.unitframe.units.boss.customTexts.UnitName.text_format = '[name:abbrev:short]'

	E.db.unitframe.units.boss.castbar.enable = false

	E.db.unitframe.units.boss.debuffs.enable = true
	E.db.unitframe.units.boss.debuffs.numrows = 1
	E.db.unitframe.units.boss.debuffs.perrow = 6
	E.db.unitframe.units.boss.debuffs.countFont = Private.GetProfileFont()
	E.db.unitframe.units.boss.debuffs.yOffset = 0

	E.db.unitframe.units.boss.growthDirection = 'UP'
	E.db.unitframe.units.boss.health.text_format = ''
	E.db.unitframe.units.boss.name.text_format = ''
	E.db.unitframe.units.boss.power.height = 6
	E.db.unitframe.units.boss.power.text_format = ''

	-- UF: Tank
	E.db.unitframe.units.tank.buffIndicator.enable = true
	E.db.unitframe.units.tank.debuffs.countFont = Private.GetProfileFont()
	E.db.unitframe.units.tank.enable = false
	E.db.unitframe.units.tank.name.text_format = '[name:medium]'
	E.db.unitframe.units.tank.rdebuffs.enable = false
	E.db.unitframe.units.tank.rdebuffs.font = Private.GetProfileFont()
	E.db.unitframe.units.tank.targetsGroup.enable = false
	E.db.unitframe.units.tank.threatStyle = 'NONE'
	E.db.unitframe.units.tank.verticalSpacing = 1

	-- UF: Party
	E.db.unitframe.units.party.buffs.enable = true
	E.db.unitframe.units.party.buffs.anchorPoint = 'BOTTOMLEFT'
	E.db.unitframe.units.party.buffs.attachTo = 'HEALTH'
	E.db.unitframe.units.party.buffs.countFont = Private.GetProfileFont()
	E.db.unitframe.units.party.buffs.perrow = 3
	E.db.unitframe.units.party.buffs.spacing = -1
	E.db.unitframe.units.party.colorOverride = 'FORCE_ON'
	E.db.unitframe.units.party.customTexts.DeadGhostStatus.attachTextTo = 'Health'
	E.db.unitframe.units.party.customTexts.DeadGhostStatus.enable = true
	E.db.unitframe.units.party.customTexts.DeadGhostStatus.font = Private.GetProfileFont()
	E.db.unitframe.units.party.customTexts.DeadGhostStatus.fontOutline = 'OUTLINE'
	E.db.unitframe.units.party.customTexts.DeadGhostStatus.justifyH = 'CENTER'
	E.db.unitframe.units.party.customTexts.DeadGhostStatus.text_format = '[namecolor][dead]'
	E.db.unitframe.units.party.customTexts.DeadGhostStatus.xOffset = 0
	E.db.unitframe.units.party.customTexts.OfflineStatus.attachTextTo = 'Health'
	E.db.unitframe.units.party.customTexts.OfflineStatus.enable = false
	E.db.unitframe.units.party.customTexts.OfflineStatus.font = Private.GetProfileFont()
	E.db.unitframe.units.party.customTexts.OfflineStatus.fontOutline = 'OUTLINE'
	E.db.unitframe.units.party.customTexts.OfflineStatus.justifyH = 'CENTER'
	E.db.unitframe.units.party.customTexts.OfflineStatus.text_format = '[namecolor][offline]'
	E.db.unitframe.units.party.customTexts.OfflineStatus.xOffset = 0
	E.db.unitframe.units.party.customTexts.UnitHealth.attachTextTo = 'Health'
	E.db.unitframe.units.party.customTexts.UnitHealth.enable = false
	E.db.unitframe.units.party.customTexts.UnitHealth.font = Private.GetProfileFont()
	E.db.unitframe.units.party.customTexts.UnitHealth.fontOutline = 'OUTLINE'
	E.db.unitframe.units.party.customTexts.UnitHealth.justifyH = 'RIGHT'
	E.db.unitframe.units.party.customTexts.UnitHealth.text_format = '[health:current:shortvalue]'
	E.db.unitframe.units.party.customTexts.UnitHealth.xOffset = -5
	E.db.unitframe.units.party.customTexts.UnitHealth.yOffset = 0
	E.db.unitframe.units.party.customTexts.UnitName.attachTextTo = 'Health'
	E.db.unitframe.units.party.customTexts.UnitName.enable = true
	E.db.unitframe.units.party.customTexts.UnitName.font = Private.GetProfileFont()
	E.db.unitframe.units.party.customTexts.UnitName.fontOutline = 'OUTLINE'
	E.db.unitframe.units.party.customTexts.UnitName.justifyH = 'CENTER'
	E.db.unitframe.units.party.customTexts.UnitName.xOffset = 0
	E.db.unitframe.units.party.customTexts.UnitName.yOffset = 0
	E.db.unitframe.units.party.debuffs.countFont = Private.GetProfileFont()
	E.db.unitframe.units.party.debuffs.perrow = 3
	E.db.unitframe.units.party.groupBy = 'ROLE'
	E.db.unitframe.units.party.healPrediction.enable = true
	E.db.unitframe.units.party.health.text_format = ''
	E.db.unitframe.units.party.name.text_format = ''
	E.db.unitframe.units.party.petsGroup.anchorPoint = 'LEFT'
	E.db.unitframe.units.party.petsGroup.enable = Private.GetPartyPets()
	E.db.unitframe.units.party.petsGroup.name.text_format = '[health:current:shortvalue]'
	E.db.unitframe.units.party.power.enable = false
	E.db.unitframe.units.party.power.text_format = ''
	E.db.unitframe.units.party.rdebuffs.font = Private.GetProfileFont()
	E.db.unitframe.units.party.rdebuffs.fontOutline = 'OUTLINE'
	E.db.unitframe.units.party.readycheckIcon.attachTo = 'CENTER'
	E.db.unitframe.units.party.readycheckIcon.yOffset = 13
	E.db.unitframe.units.party.roleIcon.enable = true
	E.db.unitframe.units.party.sortDir = 'DESC'
	E.db.unitframe.units.party.verticalSpacing = -1
	E.db.unitframe.units.party.horizontalSpacing = -1

	-- DPS/TANK UF: Raid 1
	E.db.unitframe.units.raid.colorOverride = 'FORCE_ON'
	E.db.unitframe.units.raid.customTexts.DeadGhostStatus.attachTextTo = 'Health'
	E.db.unitframe.units.raid.customTexts.DeadGhostStatus.enable = true
	E.db.unitframe.units.raid.customTexts.DeadGhostStatus.font = Private.GetProfileFont()
	E.db.unitframe.units.raid.customTexts.DeadGhostStatus.fontOutline = 'OUTLINE'
	E.db.unitframe.units.raid.customTexts.DeadGhostStatus.justifyH = 'CENTER'
	E.db.unitframe.units.raid.customTexts.DeadGhostStatus.text_format = '[namecolor][dead]'

	E.db.unitframe.units.raid.customTexts.UnitName.attachTextTo = 'Health'
	E.db.unitframe.units.raid.customTexts.UnitName.enable = true
	E.db.unitframe.units.raid.customTexts.UnitName.font = Private.GetProfileFont()
	E.db.unitframe.units.raid.customTexts.UnitName.fontOutline = 'OUTLINE'
	E.db.unitframe.units.raid.customTexts.UnitName.justifyH = 'CENTER'
	E.db.unitframe.units.raid.customTexts.UnitName.text_format = '[name:abbrev:short]'

	E.db.unitframe.units.raid.groupBy = 'ROLE'
	E.db.unitframe.units.raid.horizontalSpacing = -1
	E.db.unitframe.units.raid.name.text_format = ''
	E.db.unitframe.units.raid.numGroups = 5
	E.db.unitframe.units.raid.groupsPerRowCol = 1
	E.db.unitframe.units.raid.orientation = 'LEFT'
	E.db.unitframe.units.raid.power.enable = false
	E.db.unitframe.units.raid.power.height = 4
	E.db.unitframe.units.raid.power.position = 'RIGHT'
	E.db.unitframe.units.raid.power.yOffset = 0
	E.db.unitframe.units.raid.raidRoleIcons.enable = false
	E.db.unitframe.units.raid.raidRoleIcons.yOffset = 3
	E.db.unitframe.units.raid.readycheckIcon.attachTo = 'CENTER'
	E.db.unitframe.units.raid.readycheckIcon.yOffset = 13

	if E.db.unitframe.units.raid.roleIcon then
		E.db.unitframe.units.raid.roleIcon.damager = false
		E.db.unitframe.units.raid.roleIcon.enable = false
		E.db.unitframe.units.raid.roleIcon.healer = false
	end

	E.db.unitframe.units.raid.verticalSpacing = -1
	E.db.unitframe.units.raid.health.text_format = ''
	E.db.unitframe.units.raid.healPrediction.enable = true

	E.db.unitframe.units.raid.buffs.countFont = Private.GetProfileFont()
	E.db.unitframe.units.raid.buffs.anchorPoint = 'BOTTOMLEFT'
	E.db.unitframe.units.raid.buffs.attachTo = 'HEALTH'
	E.db.unitframe.units.raid.debuffs.countFont = Private.GetProfileFont()
	E.db.unitframe.units.raid.debuffs.anchorPoint = 'TOPLEFT'
	E.db.unitframe.units.raid.rdebuffs.font = Private.GetProfileFont()
	E.db.unitframe.units.raid.rdebuffs.fontOutline = 'OUTLINE'

	-- DPS/TANK UF: Raid 40
	E.db.unitframe.units.raid40.colorOverride = 'FORCE_ON'
	E.db.unitframe.units.raid40.customTexts.DeadGhostStatus.attachTextTo = 'Health'
	E.db.unitframe.units.raid40.customTexts.DeadGhostStatus.enable = true
	E.db.unitframe.units.raid40.customTexts.DeadGhostStatus.font = Private.GetProfileFont()
	E.db.unitframe.units.raid40.customTexts.DeadGhostStatus.fontOutline = 'OUTLINE'
	E.db.unitframe.units.raid40.customTexts.DeadGhostStatus.justifyH = 'CENTER'
	E.db.unitframe.units.raid40.customTexts.DeadGhostStatus.text_format = '[namecolor][dead]'

	E.db.unitframe.units.raid40.customTexts.UnitName.attachTextTo = 'Health'
	E.db.unitframe.units.raid40.customTexts.UnitName.enable = true
	E.db.unitframe.units.raid40.customTexts.UnitName.font = Private.GetProfileFont()
	E.db.unitframe.units.raid40.customTexts.UnitName.fontOutline = 'OUTLINE'
	E.db.unitframe.units.raid40.customTexts.UnitName.justifyH = 'CENTER'
	E.db.unitframe.units.raid40.customTexts.UnitName.text_format = '[name:abbrev:short]'

	E.db.unitframe.units.raid40.groupBy = 'ROLE'
	E.db.unitframe.units.raid40.health.yOffset = 0
	E.db.unitframe.units.raid40.horizontalSpacing = -1
	E.db.unitframe.units.raid40.name.text_format = ''
	E.db.unitframe.units.raid40.orientation = 'LEFT'
	E.db.unitframe.units.raid40.power.height = 4
	E.db.unitframe.units.raid40.power.position = 'RIGHT'
	E.db.unitframe.units.raid40.power.yOffset = 0
	E.db.unitframe.units.raid40.raidRoleIcons.enable = false
	E.db.unitframe.units.raid40.raidRoleIcons.yOffset = 3
	E.db.unitframe.units.raid40.readycheckIcon.attachTo = 'CENTER'
	E.db.unitframe.units.raid40.readycheckIcon.yOffset = 13
	E.db.unitframe.units.raid40.verticalSpacing = -1
	E.db.unitframe.units.raid40.numGroups = 8
	E.db.unitframe.units.raid40.health.text_format = ''
	E.db.unitframe.units.raid40.healPrediction.enable = true

	E.db.unitframe.units.raid40.buffs.countFont = Private.GetProfileFont()
	E.db.unitframe.units.raid40.buffs.anchorPoint = 'BOTTOMLEFT'
	E.db.unitframe.units.raid40.buffs.attachTo = 'HEALTH'
	E.db.unitframe.units.raid40.debuffs.countFont = Private.GetProfileFont()
	E.db.unitframe.units.raid40.debuffs.anchorPoint = 'TOPLEFT'
	E.db.unitframe.units.raid40.rdebuffs.font = Private.GetProfileFont()
	E.db.unitframe.units.raid40.rdebuffs.fontOutline = 'OUTLINE'

	-- UF: Raid Pet
	E.db.unitframe.units.raidpet.health.text_format = ''
	E.db.unitframe.units.raidpet.horizontalSpacing = -1
	E.db.unitframe.units.raidpet.name.text_format = ''
	E.db.unitframe.units.raidpet.numGroups = 3
	E.db.unitframe.units.raidpet.orientation = 'LEFT'
	E.db.unitframe.units.raidpet.verticalSpacing = -1
	E.db.unitframe.units.raidpet.debuffs.countFont = Private.GetProfileFont()
	E.db.unitframe.units.raidpet.debuffs.anchorPoint = 'TOPLEFT'
	E.db.unitframe.units.raidpet.customTexts.UnitName.attachTextTo = 'Health'
	E.db.unitframe.units.raidpet.customTexts.UnitName.enable = true
	E.db.unitframe.units.raidpet.customTexts.UnitName.font = Private.GetProfileFont()
	E.db.unitframe.units.raidpet.customTexts.UnitName.fontOutline = 'OUTLINE'
	E.db.unitframe.units.raidpet.customTexts.UnitName.justifyH = 'CENTER'
	E.db.unitframe.units.raidpet.customTexts.UnitName.text_format = '[name:abbrev:short]'
	E.db.unitframe.units.raidpet.customTexts.UnitName.xOffset = 0
	E.db.unitframe.units.raidpet.customTexts.UnitName.yOffset = 0

	if layout == 'DPS/Tank' then
		E.db.unitframe.units.party.customTexts.UnitName.text_format = '[name:abbrev:short]'
		E.db.unitframe.units.raidpet.enable = Private.GetRaidPets()
		E.db.unitframe.units.player.castbar.displayTarget = false
		E.db.unitframe.units.party.debuffs.xOffset = 2
		E.db.unitframe.units.party.debuffs.numrows = 2
		E.db.unitframe.units.raid.growthDirection = 'RIGHT_UP'
		E.db.unitframe.units.raid40.growthDirection = 'RIGHT_UP'
		E.db.unitframe.units.party.petsGroup.xOffset = -3
		E.db.unitframe.units.party.petsGroup.yOffset = 0
	elseif layout == 'Healer-H' or layout == 'Healer-V' then
		if layout == 'Healer-H' then
			E.db.unitframe.units.party.debuffs.anchorPoint = 'TOPLEFT'
			E.db.unitframe.units.party.debuffs.xOffset = 0
			E.db.unitframe.units.party.debuffs.numrows = 1
			E.db.unitframe.units.party.growthDirection = 'RIGHT_DOWN'
			E.db.unitframe.units.party.customTexts.UnitName.text_format = '[name:abbrev:short]'
		elseif layout == 'Healer-V' then
			E.db.unitframe.units.party.debuffs.xOffset = 2
			E.db.unitframe.units.party.debuffs.numrows = 2
			E.db.unitframe.units.party.customTexts.UnitName.text_format = '[name:abbrev:short]'
		end
		E.db.unitframe.units.party.petsGroup.xOffset = 0
		E.db.unitframe.units.party.petsGroup.yOffset = -3
		E.db.unitframe.units.raidpet.enable = Private.GetRaidPets()
		E.db.unitframe.units.player.castbar.displayTarget = true
		E.db.unitframe.units.raid.growthDirection = 'RIGHT_DOWN'
		E.db.unitframe.units.raid40.growthDirection = 'RIGHT_DOWN'
	end

	-- SIZE RESOLUTION CHANGES
	if Private.GetProfileResolution() == 'QUAD_HD' then
		E.db.unitframe.cooldown.fonts.fontSize = 20
		E.db.unitframe.fontSize = 16

		E.db.unitframe.units.player.CombatIcon.size = 23
		E.db.unitframe.units.player.customTexts.UnitPower.size = 14
		E.db.unitframe.units.player.customTexts.UnitPower.xOffset = 3
		E.db.unitframe.units.player.customTexts.UnitPower.yOffset = 0
		E.db.unitframe.units.player.customTexts.UnitHealth.size = 14
		E.db.unitframe.units.player.customTexts.UnitHealthNew.size = 14
		E.db.unitframe.units.player.customTexts.UnitHealthNew.xOffset = -3
		E.db.unitframe.units.player.customTexts.UnitHealthNew.yOffset = 10
		E.db.unitframe.units.player.customTexts.UnitName.xOffset = -3
		E.db.unitframe.units.player.customTexts.UnitName.yOffset = -10
		E.db.unitframe.units.player.customTexts.UnitName.size = 14
		E.db.unitframe.units.player.customTexts.UnitName.xOffset = -3
		E.db.unitframe.units.player.customTexts.UnitName.yOffset = 10
		E.db.unitframe.units.player.height = 51
		E.db.unitframe.units.player.power.height = 6
		E.db.unitframe.units.player.width = 259
		E.db.unitframe.units.player.raidicon.size = 25
		E.db.unitframe.units.player.castbar.height = 22
		E.db.unitframe.units.player.castbar.width = 259
		E.db.unitframe.units.player.castbar.font = Private.GetProfileFont()
		E.db.unitframe.units.player.castbar.fontSize = 13

		E.db.unitframe.units.pet.height = 51
		E.db.unitframe.units.pet.width = 125
		E.db.unitframe.units.pet.castbar.height = 22
		E.db.unitframe.units.pet.castbar.width = 125
		E.db.unitframe.units.pet.castbar.font = Private.GetProfileFont()
		E.db.unitframe.units.pet.castbar.fontSize = 13
		E.db.unitframe.units.pet.customTexts.UnitPower.size = 14
		E.db.unitframe.units.pet.customTexts.UnitHealth.size = 14
		E.db.unitframe.units.pet.customTexts.UnitName.size = 14

		E.db.unitframe.units.target.width = 259
		E.db.unitframe.units.target.height = 51
		E.db.unitframe.units.target.power.height = 6
		E.db.unitframe.units.target.buffs.countFontSize = 14
		E.db.unitframe.units.target.buffs.perrow = 8
		E.db.unitframe.units.target.buffs.sizeOverride = 27
		E.db.unitframe.units.target.debuffs.countFontSize = 14
		E.db.unitframe.units.target.debuffs.perrow = 8
		E.db.unitframe.units.target.debuffs.sizeOverride = 27

		E.db.unitframe.units.target.castbar.height = 22
		E.db.unitframe.units.target.castbar.width = 259
		E.db.unitframe.units.target.castbar.font = Private.GetProfileFont()
		E.db.unitframe.units.target.castbar.fontSize = 13
		E.db.unitframe.units.target.customTexts.UnitPower.size = 14
		E.db.unitframe.units.target.customTexts.UnitHealth.size = 14
		E.db.unitframe.units.target.customTexts.UnitName.size = 14
		E.db.unitframe.units.target.customTexts.UnitPower.xOffset = -3
		E.db.unitframe.units.target.customTexts.UnitPower.yOffset = 0
		E.db.unitframe.units.target.customTexts.UnitHealth.xOffset = 3
		E.db.unitframe.units.target.customTexts.UnitHealth.yOffset = -10
		E.db.unitframe.units.target.customTexts.UnitName.xOffset = 3
		E.db.unitframe.units.target.customTexts.UnitName.yOffset = 10
		E.db.unitframe.units.target.raidicon.size = 23

		E.db.unitframe.units.targettarget.width = 120
		E.db.unitframe.units.targettarget.height = 51
		E.db.unitframe.units.targettarget.debuffs.countFontSize = 14
		E.db.unitframe.units.targettarget.debuffs.sizeOverride = 37
		E.db.unitframe.units.targettarget.customTexts.UnitName.size = 14
		E.db.unitframe.units.targettarget.buffs.countFontSize = 14

		E.db.unitframe.units.focus.height = 51
		E.db.unitframe.units.focus.width = 220
		E.db.unitframe.units.focus.castbar.height = 22
		E.db.unitframe.units.focus.castbar.width = 220
		E.db.unitframe.units.focus.castbar.font = Private.GetProfileFont()
		E.db.unitframe.units.focus.castbar.fontSize = 13
		E.db.unitframe.units.focus.buffs.countFontSize = 14
		E.db.unitframe.units.focus.debuffs.countFontSize = 14
		E.db.unitframe.units.focus.debuffs.sizeOverride = 37
		E.db.unitframe.units.focus.customTexts.UnitPower.size = 14
		E.db.unitframe.units.focus.customTexts.UnitHealth.size = 14
		E.db.unitframe.units.focus.customTexts.UnitName.size = 14
		E.db.unitframe.units.focus.customTexts.UnitPower.xOffset = -3
		E.db.unitframe.units.focus.customTexts.UnitPower.yOffset = 0
		E.db.unitframe.units.focus.customTexts.UnitHealth.xOffset = 3
		E.db.unitframe.units.focus.customTexts.UnitHealth.yOffset = -10
		E.db.unitframe.units.focus.customTexts.UnitName.xOffset = 3
		E.db.unitframe.units.focus.customTexts.UnitName.yOffset = 10

		E.db.unitframe.units.arena.height = 51
		E.db.unitframe.units.arena.width = 220
		E.db.unitframe.units.arena.power.height = 6
		E.db.unitframe.units.arena.buffs.countFontSize = 14
		E.db.unitframe.units.arena.buffs.sizeOverride = 22
		E.db.unitframe.units.arena.buffs.yOffset = 20
		E.db.unitframe.units.arena.debuffs.countFontSize = 14
		E.db.unitframe.units.arena.debuffs.sizeOverride = 22
		E.db.unitframe.units.arena.customTexts.UnitPower.size = 14
		E.db.unitframe.units.arena.customTexts.UnitHealth.size = 14
		E.db.unitframe.units.arena.customTexts.UnitName.size = 14
		E.db.unitframe.units.arena.customTexts.UnitPower.xOffset = -3
		E.db.unitframe.units.arena.customTexts.UnitPower.yOffset = 0
		E.db.unitframe.units.arena.customTexts.UnitHealth.xOffset = 3
		E.db.unitframe.units.arena.customTexts.UnitHealth.yOffset = -10
		E.db.unitframe.units.arena.customTexts.UnitName.xOffset = 3
		E.db.unitframe.units.arena.customTexts.UnitName.yOffset = 10

		E.db.unitframe.units.arena.pvpTrinket.size = 55

		E.db.unitframe.units.boss.height = 50
		E.db.unitframe.units.boss.width = 220
		E.db.unitframe.units.boss.spacing = 3
		E.db.unitframe.units.boss.debuffs.countFontSize = 13
		E.db.unitframe.units.boss.buffs.sizeOverride = 23
		E.db.unitframe.units.boss.buffs.countFontSize = 13
		E.db.unitframe.units.boss.buffs.xOffset = 3
		E.db.unitframe.units.boss.buffs.yOffset = 12
		E.db.unitframe.units.boss.customTexts.UnitPower.size = 14
		E.db.unitframe.units.boss.customTexts.UnitHealth.size = 14
		E.db.unitframe.units.boss.customTexts.UnitName.size = 14
		E.db.unitframe.units.boss.customTexts.UnitPower.xOffset = -3
		E.db.unitframe.units.boss.customTexts.UnitPower.yOffset = 0
		E.db.unitframe.units.boss.customTexts.UnitHealth.xOffset = 3
		E.db.unitframe.units.boss.customTexts.UnitHealth.yOffset = -10
		E.db.unitframe.units.boss.customTexts.UnitName.xOffset = 3
		E.db.unitframe.units.boss.customTexts.UnitName.yOffset = 10

		E.db.unitframe.units.party.customTexts.DeadGhostStatus.size = 13
		E.db.unitframe.units.party.customTexts.OfflineStatus.size = 13
		E.db.unitframe.units.party.customTexts.UnitHealth.size = 14
		E.db.unitframe.units.party.customTexts.UnitName.size = 14
		E.db.unitframe.units.party.customTexts.DeadGhostStatus.yOffset = 15
		E.db.unitframe.units.party.customTexts.OfflineStatus.yOffset = 15
		E.db.unitframe.units.raidpet.debuffs.countFontSize = 13
		E.db.unitframe.units.raidpet.debuffs.sizeOverride = 20
		E.db.unitframe.units.raidpet.debuffs.yOffset = -20
		E.db.unitframe.units.raidpet.rdebuffs.fontSize = 12
		E.db.unitframe.units.raidpet.customTexts.UnitName.size = 14

		E.db.unitframe.units.tank.height = 45
		E.db.unitframe.units.tank.width = 100
		E.db.unitframe.units.tank.debuffs.countFontSize = 14

		E.db.unitframe.units.party.buffIndicator.countFontSize = 14
		E.db.unitframe.units.raid.buffIndicator.countFontSize = 14
		E.db.unitframe.units.raid40.buffIndicator.countFontSize = 14

		E.db.unitframe.units.raid.customTexts.UnitName.size = 14
		E.db.unitframe.units.raid.customTexts.DeadGhostStatus.size = 13

		E.db.unitframe.units.raid40.customTexts.UnitName.size = 14
		E.db.unitframe.units.raid40.customTexts.DeadGhostStatus.size = 13

		if layout == 'DPS/Tank' then

			E.db.unitframe.units.party.height = 60
			E.db.unitframe.units.party.width = 200
			E.db.unitframe.units.party.power.height = 6
			E.db.unitframe.units.party.readycheckIcon.size = 20

			E.db.unitframe.units.party.debuffs.sizeOverride = 28
			E.db.unitframe.units.party.debuffs.countFontSize = 13
			E.db.unitframe.units.party.debuffs.yOffset = 15

			E.db.unitframe.units.party.buffs.countFontSize = 13
			E.db.unitframe.units.party.buffs.sizeOverride = 23
			E.db.unitframe.units.party.buffs.yOffset = 23

			E.db.unitframe.units.party.rdebuffs.size = 35
			E.db.unitframe.units.party.rdebuffs.fontSize = 13
			E.db.unitframe.units.party.rdebuffs.yOffset = 15

			E.db.unitframe.units.party.buffIndicator.countFontSize = 15
			E.db.unitframe.units.party.petsGroup.height = 40
			E.db.unitframe.units.party.petsGroup.width = 100

			E.db.unitframe.units.raid.width = 95
			E.db.unitframe.units.raid.height = 35
			E.db.unitframe.units.raid.customTexts.DeadGhostStatus.xOffset = 0
			E.db.unitframe.units.raid.customTexts.DeadGhostStatus.yOffset = 15
			E.db.unitframe.units.raid.customTexts.UnitName.xOffset = 0
			E.db.unitframe.units.raid.customTexts.UnitName.yOffset = 0
			E.db.unitframe.units.raid.readycheckIcon.size = 20

			E.db.unitframe.units.raid.buffs.countFontSize = 11
			E.db.unitframe.units.raid.buffs.sizeOverride = 18
			E.db.unitframe.units.raid.buffs.yOffset = 18

			E.db.unitframe.units.raid.debuffs.countFontSize = 13
			E.db.unitframe.units.raid.debuffs.sizeOverride = 18
			E.db.unitframe.units.raid.debuffs.yOffset = -18

			E.db.unitframe.units.raid.rdebuffs.size = 27
			E.db.unitframe.units.raid.rdebuffs.fontSize = 13
			E.db.unitframe.units.raid.rdebuffs.yOffset = 10

			E.db.unitframe.units.raid40.width = 95
			E.db.unitframe.units.raid40.height = 35

			E.db.unitframe.units.raid40.customTexts.DeadGhostStatus.xOffset = 0
			E.db.unitframe.units.raid40.customTexts.DeadGhostStatus.yOffset = 15
			E.db.unitframe.units.raid40.customTexts.UnitName.xOffset = 0
			E.db.unitframe.units.raid40.customTexts.UnitName.yOffset = 0
			E.db.unitframe.units.raid40.readycheckIcon.size = 20

			E.db.unitframe.units.raid40.buffs.countFontSize = 11
			E.db.unitframe.units.raid40.buffs.sizeOverride = 18
			E.db.unitframe.units.raid40.buffs.yOffset = 18

			E.db.unitframe.units.raid40.debuffs.countFontSize = 13
			E.db.unitframe.units.raid40.debuffs.sizeOverride = 18
			E.db.unitframe.units.raid40.debuffs.yOffset = -18

			E.db.unitframe.units.raid40.rdebuffs.size = 27
			E.db.unitframe.units.raid40.rdebuffs.fontSize = 13
			E.db.unitframe.units.raid40.rdebuffs.yOffset = 10

			E.db.unitframe.units.raidpet.height = 45
			E.db.unitframe.units.raidpet.width = 65
		elseif layout == 'Healer-H' or layout == 'Healer-V' then
			if layout == 'Healer-H' then
				E.db.unitframe.units.party.height = 65
				E.db.unitframe.units.party.width = 130
				E.db.unitframe.units.party.power.height = 6
				E.db.unitframe.units.party.readycheckIcon.size = 20

				E.db.unitframe.units.party.debuffs.sizeOverride = 18
				E.db.unitframe.units.party.debuffs.countFontSize = 13
				E.db.unitframe.units.party.debuffs.yOffset = -18

				E.db.unitframe.units.party.buffs.countFontSize = 13
				E.db.unitframe.units.party.buffs.sizeOverride = 18
				E.db.unitframe.units.party.buffs.yOffset = 18

				E.db.unitframe.units.party.rdebuffs.size = 25
				E.db.unitframe.units.party.rdebuffs.fontSize = 13
				E.db.unitframe.units.party.rdebuffs.yOffset = 19

				E.db.unitframe.units.party.buffIndicator.countFontSize = 14
				E.db.unitframe.units.party.petsGroup.height = 25
				E.db.unitframe.units.party.petsGroup.width = 100
				E.db.unitframe.units.party.petsGroup.anchorPoint = 'BOTTOM'
			elseif layout == 'Healer-V' then
				E.db.unitframe.units.party.height = 60
				E.db.unitframe.units.party.width = 200
				E.db.unitframe.units.party.power.height = 6
				E.db.unitframe.units.party.readycheckIcon.size = 20

				E.db.unitframe.units.party.debuffs.sizeOverride = 28
				E.db.unitframe.units.party.debuffs.countFontSize = 13
				E.db.unitframe.units.party.debuffs.yOffset = 15

				E.db.unitframe.units.party.buffs.countFontSize = 13
				E.db.unitframe.units.party.buffs.sizeOverride = 23
				E.db.unitframe.units.party.buffs.yOffset = 23

				E.db.unitframe.units.party.rdebuffs.size = 35
				E.db.unitframe.units.party.rdebuffs.fontSize = 13
				E.db.unitframe.units.party.rdebuffs.yOffset = 15

				E.db.unitframe.units.party.buffIndicator.countFontSize = 14
				E.db.unitframe.units.party.petsGroup.height = 40
				E.db.unitframe.units.party.petsGroup.width = 100
			end

			E.db.unitframe.units.raid.width = 130
			E.db.unitframe.units.raid.height = 65
			E.db.unitframe.units.raid.customTexts.DeadGhostStatus.xOffset = 0
			E.db.unitframe.units.raid.customTexts.DeadGhostStatus.yOffset = 15
			E.db.unitframe.units.raid.customTexts.UnitName.xOffset = 0
			E.db.unitframe.units.raid.customTexts.UnitName.yOffset = 0
			E.db.unitframe.units.raid.readycheckIcon.size = 20

			E.db.unitframe.units.raid.buffs.countFontSize = 13
			E.db.unitframe.units.raid.buffs.sizeOverride = 20
			E.db.unitframe.units.raid.buffs.yOffset = 20

			E.db.unitframe.units.raid.debuffs.countFontSize = 13
			E.db.unitframe.units.raid.debuffs.sizeOverride = 20
			E.db.unitframe.units.raid.debuffs.yOffset = -20

			E.db.unitframe.units.raid.rdebuffs.size = 27
			E.db.unitframe.units.raid.rdebuffs.fontSize = 13
			E.db.unitframe.units.raid.rdebuffs.yOffset = 4

			E.db.unitframe.units.raid40.width = 130
			E.db.unitframe.units.raid40.height = 41
			E.db.unitframe.units.raid40.customTexts.DeadGhostStatus.xOffset = 0
			E.db.unitframe.units.raid40.customTexts.DeadGhostStatus.yOffset = 15
			E.db.unitframe.units.raid40.customTexts.UnitName.xOffset = 0
			E.db.unitframe.units.raid40.customTexts.UnitName.yOffset = 0
			E.db.unitframe.units.raid40.readycheckIcon.size = 20

			E.db.unitframe.units.raid40.buffs.countFontSize = 13
			E.db.unitframe.units.raid40.buffs.sizeOverride = 20
			E.db.unitframe.units.raid40.buffs.yOffset = 20

			E.db.unitframe.units.raid40.debuffs.countFontSize = 13
			E.db.unitframe.units.raid40.debuffs.sizeOverride = 20
			E.db.unitframe.units.raid40.debuffs.yOffset = -20

			E.db.unitframe.units.raid40.rdebuffs.size = 30
			E.db.unitframe.units.raid40.rdebuffs.fontSize = 13
			E.db.unitframe.units.raid40.rdebuffs.yOffset = 4

			E.db.unitframe.units.raidpet.height = 47
			E.db.unitframe.units.raidpet.width = 84
		end
	elseif Private.GetProfileResolution() == 'FULL_HD' then
		E.db.unitframe.cooldown.fonts.fontSize = 20
		E.db.unitframe.fontSize = 14

		E.db.unitframe.units.player.CombatIcon.size = 23
		E.db.unitframe.units.player.customTexts.UnitPower.size = 13
		E.db.unitframe.units.player.customTexts.UnitPower.xOffset = 2
		E.db.unitframe.units.player.customTexts.UnitPower.yOffset = 0
		E.db.unitframe.units.player.customTexts.UnitHealth.size = 13
		E.db.unitframe.units.player.customTexts.UnitHealthNew.size = 13
		E.db.unitframe.units.player.customTexts.UnitHealthNew.xOffset = -2
		E.db.unitframe.units.player.customTexts.UnitHealthNew.yOffset = -8
		E.db.unitframe.units.player.customTexts.UnitName.size = 13
		E.db.unitframe.units.player.customTexts.UnitName.xOffset = -2
		E.db.unitframe.units.player.customTexts.UnitName.yOffset = 8
		E.db.unitframe.units.player.height = 44
		E.db.unitframe.units.player.power.height = 6
		E.db.unitframe.units.player.width = 235
		E.db.unitframe.units.player.raidicon.size = 23
		E.db.unitframe.units.player.castbar.height = 22
		E.db.unitframe.units.player.castbar.width = 235
		E.db.unitframe.units.player.castbar.font = Private.GetProfileFont()
		E.db.unitframe.units.player.castbar.fontSize = 13

		E.db.unitframe.units.pet.height = 44
		E.db.unitframe.units.pet.width = 120
		E.db.unitframe.units.pet.castbar.height = 22
		E.db.unitframe.units.pet.castbar.width = 120
		E.db.unitframe.units.pet.castbar.font = Private.GetProfileFont()
		E.db.unitframe.units.pet.castbar.fontSize = 13
		E.db.unitframe.units.pet.customTexts.UnitPower.size = 13
		E.db.unitframe.units.pet.customTexts.UnitHealth.size = 13
		E.db.unitframe.units.pet.customTexts.UnitName.size = 13

		E.db.unitframe.units.target.width = 235
		E.db.unitframe.units.target.height = 44
		E.db.unitframe.units.target.power.height = 6
		E.db.unitframe.units.target.buffs.countFontSize = 13
		E.db.unitframe.units.target.buffs.perrow = 8
		E.db.unitframe.units.target.buffs.sizeOverride = 23
		E.db.unitframe.units.target.debuffs.countFontSize = 13
		E.db.unitframe.units.target.debuffs.perrow = 8
		E.db.unitframe.units.target.debuffs.sizeOverride = 23
		E.db.unitframe.units.target.castbar.height = 22
		E.db.unitframe.units.target.castbar.width = 235
		E.db.unitframe.units.target.castbar.font = Private.GetProfileFont()
		E.db.unitframe.units.target.castbar.fontSize = 13
		E.db.unitframe.units.target.customTexts.UnitPower.size = 13
		E.db.unitframe.units.target.customTexts.UnitHealth.size = 13
		E.db.unitframe.units.target.customTexts.UnitName.size = 13
		E.db.unitframe.units.target.customTexts.UnitPower.xOffset = -2
		E.db.unitframe.units.target.customTexts.UnitPower.yOffset = 0
		E.db.unitframe.units.target.customTexts.UnitHealth.xOffset = 2
		E.db.unitframe.units.target.customTexts.UnitHealth.yOffset = -8
		E.db.unitframe.units.target.customTexts.UnitName.xOffset = 2
		E.db.unitframe.units.target.customTexts.UnitName.yOffset = 8
		E.db.unitframe.units.target.raidicon.size = 23

		E.db.unitframe.units.targettarget.width = 120
		E.db.unitframe.units.targettarget.height = 44
		E.db.unitframe.units.targettarget.debuffs.countFontSize = 13
		E.db.unitframe.units.targettarget.debuffs.sizeOverride = 37
		E.db.unitframe.units.targettarget.customTexts.UnitName.size = 13
		E.db.unitframe.units.targettarget.buffs.countFontSize = 13

		E.db.unitframe.units.focus.height = 44
		E.db.unitframe.units.focus.width = 180
		E.db.unitframe.units.focus.castbar.height = 22
		E.db.unitframe.units.focus.castbar.width = 180
		E.db.unitframe.units.focus.castbar.font = Private.GetProfileFont()
		E.db.unitframe.units.focus.castbar.fontSize = 13
		E.db.unitframe.units.focus.buffs.countFontSize = 13
		E.db.unitframe.units.focus.debuffs.countFontSize = 13
		E.db.unitframe.units.focus.debuffs.sizeOverride = 37
		E.db.unitframe.units.focus.customTexts.UnitPower.size = 13
		E.db.unitframe.units.focus.customTexts.UnitHealth.size = 13
		E.db.unitframe.units.focus.customTexts.UnitName.size = 13
		E.db.unitframe.units.focus.customTexts.UnitPower.xOffset = -3
		E.db.unitframe.units.focus.customTexts.UnitPower.yOffset = 0
		E.db.unitframe.units.focus.customTexts.UnitHealth.xOffset = 2
		E.db.unitframe.units.focus.customTexts.UnitHealth.yOffset = -8
		E.db.unitframe.units.focus.customTexts.UnitName.xOffset = 2
		E.db.unitframe.units.focus.customTexts.UnitName.yOffset = 8

		E.db.unitframe.units.arena.height = 46
		E.db.unitframe.units.arena.width = 180
		E.db.unitframe.units.arena.power.height = 6
		E.db.unitframe.units.arena.buffs.countFontSize = 13
		E.db.unitframe.units.arena.buffs.sizeOverride = 22
		E.db.unitframe.units.arena.buffs.yOffset = 20
		E.db.unitframe.units.arena.debuffs.countFontSize = 13
		E.db.unitframe.units.arena.debuffs.sizeOverride = 22
		E.db.unitframe.units.arena.customTexts.UnitPower.size = 13
		E.db.unitframe.units.arena.customTexts.UnitHealth.size = 13
		E.db.unitframe.units.arena.customTexts.UnitName.size = 13
		E.db.unitframe.units.arena.customTexts.UnitPower.xOffset = -2
		E.db.unitframe.units.arena.customTexts.UnitPower.yOffset = 0
		E.db.unitframe.units.arena.customTexts.UnitHealth.xOffset = 2
		E.db.unitframe.units.arena.customTexts.UnitHealth.yOffset = -8
		E.db.unitframe.units.arena.customTexts.UnitName.xOffset = 2
		E.db.unitframe.units.arena.customTexts.UnitName.yOffset = 8

		E.db.unitframe.units.arena.pvpTrinket.size = 44

		E.db.unitframe.units.boss.height = 44
		E.db.unitframe.units.boss.width = 180
		E.db.unitframe.units.boss.spacing = 3
		E.db.unitframe.units.boss.debuffs.countFontSize = 13
		E.db.unitframe.units.boss.buffs.sizeOverride = 20
		E.db.unitframe.units.boss.buffs.countFontSize = 11
		E.db.unitframe.units.boss.buffs.xOffset = 3
		E.db.unitframe.units.boss.buffs.yOffset = 10
		E.db.unitframe.units.boss.customTexts.UnitPower.size = 13
		E.db.unitframe.units.boss.customTexts.UnitHealth.size = 13
		E.db.unitframe.units.boss.customTexts.UnitName.size = 13
		E.db.unitframe.units.boss.customTexts.UnitPower.xOffset = -2
		E.db.unitframe.units.boss.customTexts.UnitPower.yOffset = 0
		E.db.unitframe.units.boss.customTexts.UnitHealth.xOffset = 2
		E.db.unitframe.units.boss.customTexts.UnitHealth.yOffset = -8
		E.db.unitframe.units.boss.customTexts.UnitName.xOffset = 2
		E.db.unitframe.units.boss.customTexts.UnitName.yOffset = 8

		E.db.unitframe.units.party.customTexts.DeadGhostStatus.size = 12
		E.db.unitframe.units.party.customTexts.OfflineStatus.size = 12
		E.db.unitframe.units.party.customTexts.UnitHealth.size = 13
		E.db.unitframe.units.party.customTexts.UnitName.size = 13
		E.db.unitframe.units.party.customTexts.DeadGhostStatus.yOffset = 14
		E.db.unitframe.units.party.customTexts.OfflineStatus.yOffset = 14

		E.db.unitframe.units.raidpet.height = 35
		E.db.unitframe.units.raidpet.width = 70
		E.db.unitframe.units.raidpet.debuffs.countFontSize = 11
		E.db.unitframe.units.raidpet.debuffs.sizeOverride = 17
		E.db.unitframe.units.raidpet.debuffs.yOffset = -17
		E.db.unitframe.units.raidpet.rdebuffs.fontSize = 12
		E.db.unitframe.units.raidpet.customTexts.UnitName.size = 13

		E.db.unitframe.units.tank.height = 45
		E.db.unitframe.units.tank.width = 100
		E.db.unitframe.units.tank.debuffs.countFontSize = 13

		E.db.unitframe.units.party.buffIndicator.countFontSize = 13
		E.db.unitframe.units.raid.buffIndicator.countFontSize = 13
		E.db.unitframe.units.raid40.buffIndicator.countFontSize = 13

		E.db.unitframe.units.raid.customTexts.UnitName.size = 13
		E.db.unitframe.units.raid.customTexts.DeadGhostStatus.size = 12

		E.db.unitframe.units.raid40.customTexts.UnitName.size = 13
		E.db.unitframe.units.raid40.customTexts.DeadGhostStatus.size = 12

		if layout == 'DPS/Tank' then

			E.db.unitframe.units.party.customTexts.UnitName.text_format = '[name:abbrev:short]'
			E.db.unitframe.units.party.height = 55
			E.db.unitframe.units.party.width = 200
			E.db.unitframe.units.party.power.height = 6
			E.db.unitframe.units.party.readycheckIcon.size = 20

			E.db.unitframe.units.party.debuffs.sizeOverride = 25
			E.db.unitframe.units.party.debuffs.countFontSize = 12
			E.db.unitframe.units.party.debuffs.yOffset = 13

			E.db.unitframe.units.party.buffs.countFontSize = 12
			E.db.unitframe.units.party.buffs.sizeOverride = 20
			E.db.unitframe.units.party.buffs.yOffset = 20

			E.db.unitframe.units.party.rdebuffs.size = 30
			E.db.unitframe.units.party.rdebuffs.fontSize = 12
			E.db.unitframe.units.party.rdebuffs.yOffset = 10

			E.db.unitframe.units.party.petsGroup.height = 35
			E.db.unitframe.units.party.petsGroup.width = 90

			E.db.unitframe.units.raid.width = 80
			E.db.unitframe.units.raid.height = 35
			E.db.unitframe.units.raid.customTexts.DeadGhostStatus.xOffset = 0
			E.db.unitframe.units.raid.customTexts.DeadGhostStatus.yOffset = 15
			E.db.unitframe.units.raid.customTexts.UnitName.xOffset = 0
			E.db.unitframe.units.raid.customTexts.UnitName.yOffset = 0
			E.db.unitframe.units.raid.readycheckIcon.size = 20

			E.db.unitframe.units.raid.buffs.countFontSize = 12
			E.db.unitframe.units.raid.buffs.sizeOverride = 16
			E.db.unitframe.units.raid.buffs.yOffset = 16

			E.db.unitframe.units.raid.debuffs.countFontSize = 12
			E.db.unitframe.units.raid.debuffs.sizeOverride = 16
			E.db.unitframe.units.raid.debuffs.yOffset = -16

			E.db.unitframe.units.raid.rdebuffs.size = 26
			E.db.unitframe.units.raid.rdebuffs.fontSize = 12
			E.db.unitframe.units.raid.rdebuffs.yOffset = 4

			E.db.unitframe.units.raid40.width = 80
			E.db.unitframe.units.raid40.height = 30
			E.db.unitframe.units.raid40.customTexts.DeadGhostStatus.xOffset = 0
			E.db.unitframe.units.raid40.customTexts.DeadGhostStatus.yOffset = 15
			E.db.unitframe.units.raid40.customTexts.UnitName.xOffset = 0
			E.db.unitframe.units.raid40.customTexts.UnitName.yOffset = 0
			E.db.unitframe.units.raid40.readycheckIcon.size = 20

			E.db.unitframe.units.raid40.buffs.countFontSize = 12
			E.db.unitframe.units.raid40.buffs.sizeOverride = 16
			E.db.unitframe.units.raid40.buffs.yOffset = 16

			E.db.unitframe.units.raid40.debuffs.countFontSize = 12
			E.db.unitframe.units.raid40.debuffs.sizeOverride = 16
			E.db.unitframe.units.raid40.debuffs.yOffset = -16

			E.db.unitframe.units.raid40.rdebuffs.size = 26
			E.db.unitframe.units.raid40.rdebuffs.fontSize = 12
			E.db.unitframe.units.raid40.rdebuffs.yOffset = 2

			E.db.unitframe.units.raidpet.height = 35
			E.db.unitframe.units.raidpet.width = 47
		elseif layout == 'Healer-H' or layout == 'Healer-V' then
			if layout == 'Healer-H' then
				E.db.unitframe.units.party.customTexts.UnitName.text_format = '[name:abbrev:short]'
				E.db.unitframe.units.party.height = 55
				E.db.unitframe.units.party.width = 100
				E.db.unitframe.units.party.power.height = 6
				E.db.unitframe.units.party.readycheckIcon.size = 16

				E.db.unitframe.units.party.debuffs.sizeOverride = 18
				E.db.unitframe.units.party.debuffs.countFontSize = 12
				E.db.unitframe.units.party.debuffs.yOffset = -18

				E.db.unitframe.units.party.buffs.countFontSize = 12
				E.db.unitframe.units.party.buffs.sizeOverride = 18
				E.db.unitframe.units.party.buffs.yOffset = 18

				E.db.unitframe.units.party.rdebuffs.size = 25
				E.db.unitframe.units.party.rdebuffs.fontSize = 12
				E.db.unitframe.units.party.rdebuffs.yOffset = 14

				E.db.unitframe.units.party.petsGroup.height = 25
				E.db.unitframe.units.party.petsGroup.width = 100
				E.db.unitframe.units.party.petsGroup.anchorPoint = 'BOTTOM'
			elseif layout == 'Healer-V' then
				E.db.unitframe.units.party.customTexts.UnitName.text_format = '[name:abbrev:short]'
				E.db.unitframe.units.party.height = 55
				E.db.unitframe.units.party.width = 200
				E.db.unitframe.units.party.power.height = 6
				E.db.unitframe.units.party.readycheckIcon.size = 20

				E.db.unitframe.units.party.debuffs.sizeOverride = 25
				E.db.unitframe.units.party.debuffs.countFontSize = 13
				E.db.unitframe.units.party.debuffs.yOffset = 13

				E.db.unitframe.units.party.buffs.countFontSize = 12
				E.db.unitframe.units.party.buffs.sizeOverride = 20
				E.db.unitframe.units.party.buffs.yOffset = 20

				E.db.unitframe.units.party.rdebuffs.size = 30
				E.db.unitframe.units.party.rdebuffs.fontSize = 12
				E.db.unitframe.units.party.rdebuffs.yOffset = 10

				E.db.unitframe.units.party.petsGroup.height = 35
				E.db.unitframe.units.party.petsGroup.width = 90
			end

			E.db.unitframe.units.raid.width = 100
			E.db.unitframe.units.raid.height = 50
			E.db.unitframe.units.raid.customTexts.DeadGhostStatus.xOffset = 0
			E.db.unitframe.units.raid.customTexts.DeadGhostStatus.yOffset = 15
			E.db.unitframe.units.raid.customTexts.UnitName.xOffset = 0
			E.db.unitframe.units.raid.customTexts.UnitName.yOffset = 0
			E.db.unitframe.units.raid.readycheckIcon.size = 20

			E.db.unitframe.units.raid.buffs.countFontSize = 12
			E.db.unitframe.units.raid.buffs.sizeOverride = 18
			E.db.unitframe.units.raid.buffs.yOffset = 18

			E.db.unitframe.units.raid.debuffs.countFontSize = 12
			E.db.unitframe.units.raid.debuffs.sizeOverride = 18
			E.db.unitframe.units.raid.debuffs.yOffset = -18

			E.db.unitframe.units.raid.rdebuffs.size = 30
			E.db.unitframe.units.raid.rdebuffs.fontSize = 13
			E.db.unitframe.units.raid.rdebuffs.yOffset = 15

			E.db.unitframe.units.raid40.width = 100
			E.db.unitframe.units.raid40.height = 30
			E.db.unitframe.units.raid40.customTexts.DeadGhostStatus.xOffset = 0
			E.db.unitframe.units.raid40.customTexts.DeadGhostStatus.yOffset = 15
			E.db.unitframe.units.raid40.customTexts.UnitName.xOffset = 0
			E.db.unitframe.units.raid40.customTexts.UnitName.yOffset = 0
			E.db.unitframe.units.raid40.readycheckIcon.size = 20

			E.db.unitframe.units.raid40.buffs.countFontSize = 12
			E.db.unitframe.units.raid40.buffs.sizeOverride = 18
			E.db.unitframe.units.raid40.buffs.yOffset = 18

			E.db.unitframe.units.raid40.debuffs.countFontSize = 12
			E.db.unitframe.units.raid40.debuffs.sizeOverride = 18
			E.db.unitframe.units.raid40.debuffs.yOffset = -18

			E.db.unitframe.units.raid40.rdebuffs.size = 27
			E.db.unitframe.units.raid40.rdebuffs.fontSize = 13
			E.db.unitframe.units.raid40.rdebuffs.yOffset = 12
		end
	end
end

db.filters = function()
	local indicatorSize = Private.GetProfileResolution() == 'FULL_HD' and 15 or 17

	local GetSpellInfo = GetSpellInfo
	local pairs = pairs

	local tinyDebuffs = {}

	tinyDebuffs['VOA'] = {
		72004,
		67332,
		72121,
		66684,
		72098,
		72120,
	}

	tinyDebuffs['OS'] = {
		58936, -- Rain of Fire
		60708, -- Fade Armor
		57491, -- Flame Tsunami
	}

	tinyDebuffs['NAXX'] = {
		27819, -- Detonate Mana
		28410, -- Chains of Kel'thuzad
		28522, -- Icebolt
		28622, -- Web Wrap
		29204, -- Inevitable Doom
		29212, -- Cripple
		29213, -- Curse of the Plaguebringer
		29214, -- Wrath of the Plaguebringer
		29232, -- Fungal Creep
		29306, -- Infected Wound
		29310, -- Spell Disruption
		29865, -- Deathbloom
		54022, -- Locust Swarm
		54098, -- Poison Bolt Volley
		54378, -- Mortal Wound
		55011, -- Decrepit Fever
		55053, -- Deathbloom
		55604, -- Death Plague
		55665, -- Life Drain
		56538, -- Plague Splash
		27825, -- Shadow Mark
		55699, -- Chill
		56674, -- Poison Charge
		56605, -- Virulent Poison
		29848, -- Polymorph
		29849, -- Frost Nova
		54709, -- Flesh Rot
	}

	tinyDebuffs['EOE'] = {
		56272,
		60072,
		57407,
		60936,
	}

	tinyDebuffs['ULDUAR'] = {
		62469,
		64386,
		64771,
		64152,
		64156,
		64668,
		63549,
		62418,
		62680,
		62469,
		62865,
		63355,
		63978,
		62038,
		63830,
		63138,
		63802,
		64412,
		43622,
		62269,
		61990,
		64153,
		64157,
		62526,
		63673,
		62042,
		62602,
		62928,
		62055,
		64375,
		63476,
		63322,
		64374,
		63615,
		62532,
		63042,
		64706,
		63247,
		63551,
	}

	tinyDebuffs['TOGC'] = {
		66406,
		66819,
		66821,
		66823,
		66770,
		66689,
		66683,
		66242,
		66197,
		66283,
		66209,
		66211,
		66333,
		65812,
		65960,
		65801,
		65543,
		66054,
		65809,
		66075,
		66069,
		67721,
		66012,
		65775,
		66320,
	}

	tinyDebuffs['ICC'] = {
		70450,
		71089,
		71163,
		71127,
		70435,
		70671,
		70432,
		71257,
		69146,
		61603,
		71204,
		55095,
		70659,
		72408,
		72769,
		69290,
		72219,
		69789,
		69508,
		69774,
		72295,
		72454,
		70341,
		72999,
		71807,
		70838,
		71623,
		70949,
		72151,
		70877,
		70923,
		70873,
		70744,
		70751,
		70633,
		71941,
		70766,
		70107,
		70106,
		69766,
		71665,
		72133,
		68981,
		70541,
		68980,
		72385,
		69762,
		72884,
		70127,
	}

	tinyDebuffs['RS'] = {
		74630,
		74802,
	}

	local bigDebuffs = {}

	bigDebuffs['OS'] = {
		39647,
	}

	bigDebuffs['NAXX'] = {
		54121,
		55550,
		29998,
		27808,
		28169,
		55314,
	}

	bigDebuffs['EOE'] = {
		61079,
	}

	bigDebuffs['ULDUAR'] = {
		65121,
		62589,
		63025,
		63276,
		62374,
		61888,
		67237,
		62997,
		63666,
		64125,
		64290,
		63666,
		63477,
		13704,
		63134,
		62283,
		63493,
		64698,
		64970,
	}

	bigDebuffs['TOGC'] = {
		66869,
		66331,
		66532,
		66237,
		65950,
		66001,
		66013,
		67574,
	}

	bigDebuffs['ICC'] = {
		70980,
		69483,
		69065,
		71289,
		71237,
		69651,
		69248,
		69278,
		69674,
		70215,
		70911,
		69774,
		71340,
		72985,
		70126,
		70157,
		69242,
		69409,
		70337,
		72865,
		72446,
	}

	bigDebuffs['RS'] = {
		74562,
		74792,
		74453,
	}

	local blacklist = {
		22790,
		25771,
		42859,
	}

	local turtle = {
		47883,
		29166,
	}

	-- Aura Filters
	E.global['unitframe']['aurafilters'] = E.global['unitframe']['aurafilters'] or {}

	local AddSpellId = function(spellId, filter, type)
		if not spellId or not filter then
			return
		end

		local spellName = GetSpellInfo(spellId)

		if not spellName then
			return
		end

		if not E.global.unitframe.aurafilters[filter] then
			E.global.unitframe.aurafilters[filter] = {
				type = type,
				spells = {},
			}
		end

		if E.global.unitframe.aurafilters[filter].spells[spellName] then
			return
		end

		E.global.unitframe.aurafilters[filter].spells[spellName] = {
			['enable'] = true,
			['priority'] = 0,
			['stackThreshold'] = 0,
		}
	end

	AddSpellId(53227, 'CCDebuffs')

	for _, spellId in pairs(turtle) do
		AddSpellId(spellId, 'TurtleBuffs', 'Whitelist')
	end

	for _, spellId in pairs(blacklist) do
		AddSpellId(spellId, 'Blacklist', 'Whitelist')
	end

	for _, spellId in pairs(tinyDebuffs['VOA']) do
		AddSpellId(spellId, 'RaidDebuffs_VoA', 'Whitelist')
	end

	for _, spellId in pairs(tinyDebuffs['OS']) do
		AddSpellId(spellId, 'RaidDebuffs_OS', 'Whitelist')
	end

	for _, spellId in pairs(tinyDebuffs['NAXX']) do
		AddSpellId(spellId, 'RaidDebuffs_Naxx', 'Whitelist')
	end

	for _, spellId in pairs(tinyDebuffs['EOE']) do
		AddSpellId(spellId, 'RaidDebuffs_EoE', 'Whitelist')
	end

	for _, spellId in pairs(tinyDebuffs['ULDUAR']) do
		AddSpellId(spellId, 'RaidDebuffs_Ulduar', 'Whitelist')
	end

	for _, spellId in pairs(tinyDebuffs['TOGC']) do
		AddSpellId(spellId, 'RaidDebuffs_ToGC', 'Whitelist')
	end

	for _, spellId in pairs(tinyDebuffs['ICC']) do
		AddSpellId(spellId, 'RaidDebuffs_ICC', 'Whitelist')
	end

	for _, spellId in pairs(tinyDebuffs['RS']) do
		AddSpellId(spellId, 'RaidDebuffs_RS', 'Whitelist')
	end

	for _, filterName in pairs({ 'OS', 'NAXX', 'EOE', 'ULDUAR', 'TOGC', 'ICC', 'RS' }) do
		for _, spellId in pairs(bigDebuffs[filterName]) do
			AddSpellId(spellId, 'Debuff Indicators', 'Whitelist')
			AddSpellId(spellId, 'BLACKLIST: Debuff Indicators', 'Blacklist')
		end
	end

	E.global['unitframe']['buffwatch'] = E.global['unitframe']['buffwatch'] or {}

	E.global['unitframe']['buffwatch']['MAGE'] = {
		[54646] = {
			['sizeOverride'] = 15,
			['point'] = 'TOPLEFT',
			['style'] = 'texturedIcon',
			['onlyShowMissing'] = false,
		},
		[48066] = {
			['enabled'] = true,
			['sizeOverride'] = 10,
			['point'] = 'TOP',
			['xOffset'] = 0,
			['yOffset'] = 0,
			['style'] = 'texturedIcon',
			['id'] = 48066,
			['color'] = {
				['r'] = 1,
				['g'] = 0,
				['b'] = 0,
			},
			['anyUnit'] = true,
			['onlyShowMissing'] = false,
		},
	}

	E.global['unitframe']['buffwatch']['WARLOCK'] = {
		[47883] = {
			['enabled'] = true,
			['anyUnit'] = true,
			['point'] = 'TOPLEFT',
			['xOffset'] = 0,
			['displayText'] = false,
			['textThreshold'] = -1,
			['yOffset'] = 0,
			['style'] = 'texturedIcon',
			['sizeOverride'] = 15,
			['color'] = {
				['b'] = 1,
				['g'] = 0.41960784313725,
				['r'] = 0,
			},
			['id'] = 47883,
		},
		[48066] = {
			['enabled'] = true,
			['sizeOverride'] = 10,
			['point'] = 'TOP',
			['xOffset'] = 0,
			['yOffset'] = 0,
			['style'] = 'texturedIcon',
			['id'] = 48066,
			['color'] = {
				['r'] = 1,
				['g'] = 0,
				['b'] = 0,
			},
			['anyUnit'] = true,
			['onlyShowMissing'] = false,
		},
	}

	E.global['unitframe']['buffwatch']['PRIEST'] = {
		-- Power Infusion
		[10060] = {
			['enabled'] = false,
		},
		-- PoM
		[48111] = {
			['sizeOverride'] = indicatorSize,
			['style'] = 'texturedIcon',
			['point'] = 'TOPRIGHT',
			['xOffset'] = -(indicatorSize + 1),
			['decimalThreshold'] = -1,
		},
		-- Weakened Soul
		[6788] = {
			['sizeOverride'] = 13,
			['point'] = 'TOP',
			['style'] = 'texturedIcon',
		},
		-- Power Word: Shield
		[48066] = {
			['anyUnit'] = false,
			['point'] = 'TOPRIGHT',
			['color'] = {
				['b'] = 0,
				['g'] = 0,
				['r'] = 1,
			},
			['sizeOverride'] = indicatorSize,
			['style'] = 'texturedIcon',
			['onlyShowMissing'] = false,
		},
		-- Renew
		[48068] = {
			['sizeOverride'] = indicatorSize,
			['style'] = 'texturedIcon',
			['decimalThreshold'] = -1,
			['point'] = 'BOTTOMRIGHT',
		},
	}

	E.global['unitframe']['buffwatch']['PALADIN'] = {
		[6940] = {
			['enabled'] = false,
			['sizeOverride'] = 13,
			['point'] = 'BOTTOMLEFT',
			['style'] = 'texturedIcon',
			['yOffset'] = -2,
		},
		[10278] = {
			['enabled'] = false,
			['sizeOverride'] = 13,
			['point'] = 'BOTTOMLEFT',
			['style'] = 'texturedIcon',
			['yOffset'] = -2,
		},
		[48066] = {
			['enabled'] = true,
			['anyUnit'] = true,
			['point'] = 'TOP',
			['xOffset'] = 0,
			['yOffset'] = 0,
			['style'] = 'texturedIcon',
			['id'] = 48066,
			['color'] = {
				['r'] = 1,
				['g'] = 0,
				['b'] = 0,
			},
			['sizeOverride'] = 10,
			['onlyShowMissing'] = false,
		},
		[1038] = {
			['enabled'] = false,
			['sizeOverride'] = 13,
			['point'] = 'BOTTOMLEFT',
			['style'] = 'texturedIcon',
			['yOffset'] = -2,
		},
		[1044] = {
			['enabled'] = false,
			['sizeOverride'] = 13,
			['point'] = 'BOTTOMLEFT',
			['style'] = 'texturedIcon',
			['yOffset'] = -3,
		},
		[53563] = {
			['anyUnit'] = false,
			['style'] = 'texturedIcon',
			['point'] = 'BOTTOMRIGHT',
			['color'] = {
				['r'] = 1,
				['g'] = 0,
				['b'] = 0,
			},
			['sizeOverride'] = indicatorSize,
			['decimalThreshold'] = -1,
		},
		[53601] = {
			['sizeOverride'] = indicatorSize,
			['point'] = 'TOPRIGHT',
			['decimalThreshold'] = -1,
			['anyUnit'] = false,
			['style'] = 'texturedIcon',
			['onlyShowMissing'] = false,
		},
	}

	E.global['unitframe']['buffwatch']['SHAMAN'] = {
		-- Riptide
		[61301] = {
			['sizeOverride'] = indicatorSize,
			['style'] = 'texturedIcon',
			['decimalThreshold'] = 1,
			['point'] = 'TOPRIGHT',
		},
		-- Power Word: Shield
		[48066] = {
			['enabled'] = true,
			['sizeOverride'] = 10,
			['point'] = 'TOP',
			['xOffset'] = 0,
			['yOffset'] = 0,
			['style'] = 'texturedIcon',
			['id'] = 48066,
			['color'] = {
				['r'] = 1,
				['g'] = 0,
				['b'] = 0,
			},
			['anyUnit'] = true,
			['onlyShowMissing'] = false,
		},
		-- Earthliving
		[52000] = {
			['sizeOverride'] = indicatorSize,
			['style'] = 'texturedIcon',
			['xOffset'] = -(indicatorSize + 1),
			['decimalThreshold'] = 1,
			['point'] = 'TOPRIGHT',
			['onlyShowMissing'] = false,
		},
		-- Ancestral Fortitude
    --[[[16237] = {
            ["enabled"] = false,
            ["anyUnit"] = true,
            ["point"] = "TOPRIGHT",
            ["xOffset"] = -19,
            ["displayText"] = true,
            ["style"] = "texturedIcon",
            ["decimalThreshold"] = 1,
            ["color"] = {
                ["r"] = 1,
                ["g"] = 0.86274509803922,
                ["b"] = 0,
            },
            ["sizeOverride"] = 15,
            ["onlyShowMissing"] = false,
        },]]
		--
		-- Earth Shield
		[49284] = {
			['sizeOverride'] = indicatorSize,
			['point'] = 'BOTTOMRIGHT',
			['decimalThreshold'] = 1,
			['color'] = {
				['r'] = 1,
				['g'] = 1,
				['b'] = 1,
			},
			['anyUnit'] = false,
			['style'] = 'texturedIcon',
			['onlyShowMissing'] = false,
		},
	}

	E.global['unitframe']['buffwatch']['DRUID'] = {
		-- Wild Growth
		[53251] = {
			['sizeOverride'] = indicatorSize,
			['style'] = 'texturedIcon',
			['color'] = {
				['b'] = 0.72549019607843,
				['g'] = 0,
				['r'] = 1,
			},
			['point'] = 'BOTTOMRIGHT',
			['xOffset'] = -(indicatorSize + 1),
			['textColor'] = {
				['g'] = 0.90196078431373,
				['b'] = 0,
			},
		},
		-- Lifebloom
		[48451] = {
			['sizeOverride'] = indicatorSize,
			['style'] = 'texturedIcon',
			['decimalThreshold'] = 0,
			['color'] = {
				['b'] = 0,
				['g'] = 0,
				['r'] = 1,
			},
			['anyUnit'] = false,
			['textColor'] = {
				['g'] = 0.90196078431373,
				['b'] = 0,
			},
			['point'] = 'TOPRIGHT',
		},
		-- Rejuvenation
		[48441] = {
			['sizeOverride'] = 15,
			['style'] = 'texturedIcon',
			['textColor'] = {
				['g'] = 0.90196078431373,
				['b'] = 0,
			},
			['color'] = {
				['b'] = 1,
				['g'] = 0.75686274509804,
				['r'] = 0,
			},
			['decimalThreshold'] = -1,
			['point'] = 'BOTTOMRIGHT',
			['onlyShowMissing'] = false,
		},
		-- Regrowth
		[48443] = {
			['sizeOverride'] = indicatorSize,
			['style'] = 'texturedIcon',
			['point'] = 'TOPRIGHT',
			['xOffset'] = -(indicatorSize + 1),
			['decimalThreshold'] = -1,
			['textColor'] = {
				['g'] = 0.90196078431373,
				['b'] = 0,
			},
		},
		-- Shield
		[48066] = {
			['enabled'] = true,
			['anyUnit'] = true,
			['point'] = 'TOP',
			['xOffset'] = 0,
			['yOffset'] = 0,
			['style'] = 'texturedIcon',
			['id'] = 48066,
			['sizeOverride'] = 10,
			['color'] = {
				['b'] = 0,
				['g'] = 0,
				['r'] = 1,
			},
			['onlyShowMissing'] = false,
		},
	}

	E.db.unitframe.units.raid.debuffs.priority =
		'Blacklist,BLACKLIST: Debuff Indicators,RaidDebuffs_VoA,RaidDebuffs_OS,RaidDebuffs_Naxx,RaidDebuffs_EoE,RaidDebuffs_Ulduar,RaidDebuffs_ToGC,RaidDebuffs_ICC,RaidDebuffs_RS,Dispellable'
	E.db.unitframe.units.raid40.debuffs.priority =
		'Blacklist,BLACKLIST: Debuff Indicators,RaidDebuffs_VoA,RaidDebuffs_OS,RaidDebuffs_Naxx,RaidDebuffs_EoE,RaidDebuffs_Ulduar,RaidDebuffs_ToGC,RaidDebuffs_ICC,RaidDebuffs_RS,Dispellable'
	E.db.unitframe.units.party.debuffs.priority =
		'Blacklist,RaidDebuffs_VoA,RaidDebuffs_OS,RaidDebuffs_Naxx,RaidDebuffs_EoE,RaidDebuffs_Ulduar,RaidDebuffs_ToGC,RaidDebuffs_ICC,RaidDebuffs_RS,Dispellable'
	E.db.unitframe.units.raidpet.debuffs.priority =
		'Blacklist,RaidDebuffs_VoA,RaidDebuffs_OS,RaidDebuffs_Naxx,RaidDebuffs_EoE,RaidDebuffs_Ulduar,RaidDebuffs_ToGC,RaidDebuffs_ICC,RaidDebuffs_RS,Dispellable'
end

function Private.ImportElvUI(layout)
	local profileName = 'MerfinUI (' .. layout .. ') (' .. Private.ScreenHeight .. ') v' .. Private.Version
	local keepMovers = Private.GetBlacklist('movers')
	local keepActionBars = Private.GetBlacklist('actionBars')
	local currentMovers = keepMovers and CopyDBValue(E.db.movers)
	local currentActionBars = keepActionBars and CopyDBActionBarSections(E.db.actionbar)

	E.data:SetProfile(profileName)

	Private.GlobalDB()
	Private.PrivateDB()
	Private.LoadPlugins()

	db.movers(layout, keepMovers)
	db.general()
	db.auras()
	db.bags()
	db.chat()
	db.databars()
	db.datatext()
	db.tooltip()
	db.actionbars(keepActionBars)
	RestoreDBValues(E.db.movers, currentMovers)
	RestoreDBValues(E.db.actionbar, currentActionBars)
	db.unitframes(layout)
	Private.NameplatesDB()
	db.filters()

	Private.ChangeTheme('DARK')

	if E.StaggeredUpdateAll then
		E:StaggeredUpdateAll()
	end
	E:UpdateAll(true)

	Private:PluginInstallStepComplete('ElvUI ' .. profileName)
end

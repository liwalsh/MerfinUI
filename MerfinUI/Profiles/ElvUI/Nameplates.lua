local addonName, Private = ...
local E, L, V, P, G = unpack(ElvUI)

local plates = { 'FRIENDLY_PLAYER', 'FRIENDLY_NPC', 'ENEMY_PLAYER', 'ENEMY_NPC' }
local enemies = { ENEMY_PLAYER = true, ENEMY_NPC = true }
local friendlies = { FRIENDLY_PLAYER = true, FRIENDLY_NPC = true }

-- Base settings shared by every nameplate style.
local function ApplyNameplateBase()
	E.private.nameplates.enable = true
	E.db.nameplates.threat.useThreatColor = true
	E.db.nameplates.threat.badScale = 1
	E.db.nameplates.threat.goodScale = 1
	E.db.nameplates.nonTargetTransparency = 1
	E.db.nameplates.cooldown.fonts.enable = false
	E.db.nameplates.cooldown.fonts.font = Private.GetProfileFont()

	E.db.nameplates.statusbar = Private.GetProfileTexture()
	E.db.nameplates.useTargetScale = false
	E.db.nameplates.targetScale = 1
	E.db.nameplates.fadeIn = false
	E.db.nameplates.alwaysShowTargetHealth = false
	E.db.nameplates.clickThrough.friendly = true
	E.db.nameplates.loadDistance = 61

	E.db.nameplates.units.TARGET.glowStyle = 'style1'
	E.db.nameplates.units.TARGET.arrow = 'Arrow11'
	E.db.nameplates.units.TARGET.comboPoints.enable = false

	E.db.nameplates.plateSize.friendlyHeight = 18
	E.db.nameplates.plateSize.friendlyWidth = 155
	E.db.nameplates.plateSize.enemyWidth = 155
	E.db.nameplates.plateSize.enemyHeight = 18
end

-- Style "Classic": text above the health bar, side auras (default look).
function Private.ApplyNameplateStyleClassic()
	for _, nameplateType in ipairs(plates) do
		local health = E.db.nameplates.units[nameplateType].health
		health.text.font = Private.GetProfileFont()
		health.text.enable = true
		health.height = 18
		health.width = 155
		health.text.position = 'BOTTOMRIGHT'
		health.text.xOffset = -2
		health.text.yOffset = 14
		health.text.fontSize = 9

		local castbar = E.db.nameplates.units[nameplateType].castbar
		castbar.iconSize = 15
		castbar.iconPosition = "LEFT"
		castbar.height = 15
		castbar.width = 140
		castbar.fontSize = 9
		castbar.iconOffsetX = 1
		castbar.yOffset = -1
		castbar.xOffset = 7
		castbar.font = Private.GetProfileFont()
		castbar.textPosition = 'ONBAR'

		local buffs = E.db.nameplates.units[nameplateType].buffs
		buffs.enable = true
		buffs.size = 18
		buffs.perrow = 7
		buffs.numrows = 1
		buffs.spacing = 1
		buffs.attachTo = 'FRAME'
		buffs.anchorPoint = 'LEFT'
		buffs.growthX = 'LEFT'
		buffs.growthY = 'UP'
		buffs.xOffset = -3
		buffs.yOffset = 0
		buffs.useSirusPosition = false
		buffs.useSirusSize = false
		buffs.cooldownOrientation = 'VERTICAL'
		buffs.reverseCooldown = false
		buffs.countFont = Private.GetProfileFont()
		buffs.countFontOutline = 'OUTLINE'
		buffs.countFontSize = 10
		buffs.countPosition = 'BOTTOM'
		buffs.countXOffset = 0
		buffs.countYOffset = -5
		buffs.durationFont = Private.GetProfileFont()
		buffs.durationFontOutline = 'OUTLINE'
		buffs.durationFontSize = 10
		buffs.durationPosition = 'CENTER'
		buffs.durationXOffset = 0
		buffs.durationYOffset = 0
		buffs.filters = {
			minDuration = 0,
			maxDuration = 0,
			priority = 'Blacklist,Personal',
		}

		local debuffs = E.db.nameplates.units[nameplateType].debuffs
		debuffs.enable = true
		debuffs.size = 18
		debuffs.perrow = 7
		debuffs.numrows = 1
		debuffs.spacing = 0
		debuffs.attachTo = 'FRAME'
		debuffs.anchorPoint = 'TOP'
		debuffs.growthX = 'RIGHT'
		debuffs.growthY = 'UP'
		debuffs.xOffset = 0
		debuffs.yOffset = 3
		debuffs.useSirusPosition = false
		debuffs.useSirusSize = false
		debuffs.cooldownOrientation = 'VERTICAL'
		debuffs.reverseCooldown = false
		debuffs.countFont = Private.GetProfileFont()
		debuffs.countFontOutline = 'OUTLINE'
		debuffs.countFontSize = 10
		debuffs.countPosition = 'TOP'
		debuffs.countXOffset = 0
		debuffs.countYOffset = 5
		debuffs.durationFont = Private.GetProfileFont()
		debuffs.durationFontOutline = 'OUTLINE'
		debuffs.durationFontSize = 10
		debuffs.durationPosition = 'CENTER'
		debuffs.durationXOffset = 0
		debuffs.durationYOffset = 0
		debuffs.filters = {
			minDuration = 0,
			maxDuration = 0,
			priority = 'Blacklist,Personal,CCDebuffs',
		}

		local crowdcontrol = E.db.nameplates.units[nameplateType].crowdcontrol
		crowdcontrol.enable = true
		crowdcontrol.size = 18
		crowdcontrol.perrow = 7
		crowdcontrol.numrows = 1
		crowdcontrol.spacing = 1
		crowdcontrol.attachTo = 'FRAME'
		crowdcontrol.anchorPoint = 'RIGHT'
		crowdcontrol.growthX = 'RIGHT'
		crowdcontrol.growthY = 'UP'
		crowdcontrol.xOffset = 3
		crowdcontrol.yOffset = 0
		crowdcontrol.useSirusPosition = false
		crowdcontrol.useSirusSize = false
		crowdcontrol.cooldownOrientation = 'VERTICAL'
		crowdcontrol.reverseCooldown = false
		crowdcontrol.countFont = Private.GetProfileFont()
		crowdcontrol.countFontOutline = 'OUTLINE'
		crowdcontrol.countFontSize = 10
		crowdcontrol.countPosition = 'BOTTOM'
		crowdcontrol.countXOffset = 0
		crowdcontrol.countYOffset = -5
		crowdcontrol.durationFont = Private.GetProfileFont()
		crowdcontrol.durationFontOutline = 'OUTLINE'
		crowdcontrol.durationFontSize = 10
		crowdcontrol.durationPosition = 'CENTER'
		crowdcontrol.durationXOffset = 0
		crowdcontrol.durationYOffset = 0
		crowdcontrol.filters = {
			minDuration = 0,
			maxDuration = 0,
			priority = 'Blacklist,CCDebuffs',
		}

		E.db.nameplates.units[nameplateType].level.enable = false
		E.db.nameplates.units[nameplateType].level.font = Private.GetProfileFont()

		local name = E.db.nameplates.units[nameplateType].name
		name.position = 'BOTTOMLEFT'
		name.xOffset = 2
		name.yOffset = 14
		name.fontSize = 9
		name.abbrev = true
		name.font = Private.GetProfileFont()

		local raidTargetIndicator = E.db.nameplates.units[nameplateType].raidTargetIndicator
		raidTargetIndicator.position = "CENTER"
		raidTargetIndicator.size = 30
		raidTargetIndicator.xOffset = 0
		raidTargetIndicator.yOffset = 0

		if enemies[nameplateType] then
			health.text.format = 'CURRENT_PERCENT'
			health.text.parent = 'Health'
		end

		if friendlies[nameplateType] then
			health.enable = false
		end

		for nameplateType in pairs(enemies) do
		E.db.nameplates.units[nameplateType].customTexts.NPTarget = {
			enable = true,
			text_format = '[target:abbrev]',
			font = Private.GetProfileFont(),
			size = 9,
			fontOutline = 'OUTLINE',
			attachTextTo = 'Health',
			position = 'RIGHT',
			justifyH = 'RIGHT',
			xOffset = 0,
			yOffset = -9,
			layer = 'OVERLAY',
		}
	end
	end
end

-- Style "Modern": compact bar, text inside the health bar, buffs below and debuffs above.
function Private.ApplyNameplateStyleModern()
	for _, nameplateType in ipairs(plates) do
		local health = E.db.nameplates.units[nameplateType].health
		health.text.font = Private.GetProfileFont()
		health.text.enable = true
		health.height = 18
		health.width = 155
		health.text.position = 'CENTER'
		health.text.xOffset = 0
		health.text.yOffset = 0
		health.text.fontSize = 9

		local castbar = E.db.nameplates.units[nameplateType].castbar
		castbar.iconSize = 15
		castbar.iconPosition = "LEFT"
		castbar.height = 15
		castbar.width = 140
		castbar.fontSize = 9
		castbar.iconOffsetX = 1
		castbar.yOffset = -1
		castbar.xOffset = 7
		castbar.font = Private.GetProfileFont()
		castbar.textPosition = 'ONBAR'

		local buffs = E.db.nameplates.units[nameplateType].buffs
		buffs.enable = true
		buffs.size = 18
		buffs.perrow = 7
		buffs.numrows = 1
		buffs.spacing = 1
		buffs.attachTo = 'FRAME'
		buffs.anchorPoint = 'LEFT'
		buffs.growthX = 'LEFT'
		buffs.growthY = 'UP'
		buffs.xOffset = -3
		buffs.yOffset = 0
		buffs.useSirusPosition = false
		buffs.useSirusSize = false
		buffs.cooldownOrientation = 'VERTICAL'
		buffs.reverseCooldown = false
		buffs.countFont = Private.GetProfileFont()
		buffs.countFontOutline = 'OUTLINE'
		buffs.countFontSize = 10
		buffs.countPosition = 'BOTTOM'
		buffs.countXOffset = 0
		buffs.countYOffset = -5
		buffs.durationFont = Private.GetProfileFont()
		buffs.durationFontOutline = 'OUTLINE'
		buffs.durationFontSize = 10
		buffs.durationPosition = 'CENTER'
		buffs.durationXOffset = 0
		buffs.durationYOffset = 0
		buffs.filters = {
			minDuration = 0,
			maxDuration = 0,
			priority = 'Blacklist,Personal',
		}

		local debuffs = E.db.nameplates.units[nameplateType].debuffs
		debuffs.enable = true
		debuffs.size = 18
		debuffs.perrow = 7
		debuffs.numrows = 1
		debuffs.spacing = 0
		debuffs.attachTo = 'FRAME'
		debuffs.anchorPoint = 'TOP'
		debuffs.growthX = 'RIGHT'
		debuffs.growthY = 'UP'
		debuffs.xOffset = 0
		debuffs.yOffset = 10
		debuffs.useSirusPosition = false
		debuffs.useSirusSize = false
		debuffs.cooldownOrientation = 'VERTICAL'
		debuffs.reverseCooldown = false
		debuffs.countFont = Private.GetProfileFont()
		debuffs.countFontOutline = 'OUTLINE'
		debuffs.countFontSize = 10
		debuffs.countPosition = 'TOP'
		debuffs.countXOffset = 0
		debuffs.countYOffset = 5
		debuffs.durationFont = Private.GetProfileFont()
		debuffs.durationFontOutline = 'OUTLINE'
		debuffs.durationFontSize = 10
		debuffs.durationPosition = 'CENTER'
		debuffs.durationXOffset = 0
		debuffs.durationYOffset = 0
		debuffs.filters = {
			minDuration = 0,
			maxDuration = 0,
			priority = 'Blacklist,Personal,CCDebuffs',
		}

		local crowdcontrol = E.db.nameplates.units[nameplateType].crowdcontrol
		crowdcontrol.enable = true
		crowdcontrol.size = 18
		crowdcontrol.perrow = 7
		crowdcontrol.numrows = 1
		crowdcontrol.spacing = 1
		crowdcontrol.attachTo = 'FRAME'
		crowdcontrol.anchorPoint = 'RIGHT'
		crowdcontrol.growthX = 'RIGHT'
		crowdcontrol.growthY = 'UP'
		crowdcontrol.xOffset = 3
		crowdcontrol.yOffset = 0
		crowdcontrol.useSirusPosition = false
		crowdcontrol.useSirusSize = false
		crowdcontrol.cooldownOrientation = 'VERTICAL'
		crowdcontrol.reverseCooldown = false
		crowdcontrol.countFont = Private.GetProfileFont()
		crowdcontrol.countFontOutline = 'OUTLINE'
		crowdcontrol.countFontSize = 10
		crowdcontrol.countPosition = 'BOTTOM'
		crowdcontrol.countXOffset = 0
		crowdcontrol.countYOffset = -5
		crowdcontrol.durationFont = Private.GetProfileFont()
		crowdcontrol.durationFontOutline = 'OUTLINE'
		crowdcontrol.durationFontSize = 10
		crowdcontrol.durationPosition = 'CENTER'
		crowdcontrol.durationXOffset = 0
		crowdcontrol.durationYOffset = 0
		crowdcontrol.filters = {
			minDuration = 0,
			maxDuration = 0,
			priority = 'Blacklist,CCDebuffs',
		}

		if nameplateType == 'ENEMY_NPC' then
			local eliteIcon = E.db.nameplates.units[nameplateType].eliteIcon
			eliteIcon.enable = false
			eliteIcon.position = 'RIGHT'
			eliteIcon.size = 15
			eliteIcon.xOffset = -2
			eliteIcon.yOffset = 0
		end
		
		local level = E.db.nameplates.units[nameplateType].level
		level.enable = false
		level.position = 'BOTTOMLEFT'
		level.xOffset = 2
		level.yOffset = 14
		level.fontSize = 9
		level.font = Private.GetProfileFont()

		local name = E.db.nameplates.units[nameplateType].name
		name.position = 'CENTER'
		name.xOffset = 0
		name.yOffset = 9
		name.fontSize = 9
		name.abbrev = true
		name.font = Private.GetProfileFont()

		local raidTargetIndicator = E.db.nameplates.units[nameplateType].raidTargetIndicator
		raidTargetIndicator.position = "RIGHT"
		raidTargetIndicator.size = 18
		raidTargetIndicator.xOffset = -10
		raidTargetIndicator.yOffset = 10

		if enemies[nameplateType] then
			health.text.format = 'CURRENT_PERCENT'
			health.text.parent = 'Health'
		end

		if friendlies[nameplateType] then
			health.enable = false
		end

		for nameplateType in pairs(enemies) do
		E.db.nameplates.units[nameplateType].customTexts.NPTarget = {
			enable = true,
			text_format = '[target:abbrev]',
			font = Private.GetProfileFont(),
			size = 9,
			fontOutline = 'OUTLINE',
			attachTextTo = 'Health',
			position = 'CENTER',
			justifyH = 'CENTER',
			xOffset = 0,
			yOffset = -9,
			layer = 'OVERLAY',
		}
	end
	end
end

-- Applies the base settings and the currently selected nameplate style.
function Private.NameplatesDB()
	ApplyNameplateBase()

	local style = Private.GetNameplateStyle()
	if style == 'Modern' then
		Private.ApplyNameplateStyleModern()
	else
		Private.ApplyNameplateStyleClassic()
	end

	E.db.nameplates.units['FRIENDLY_PLAYER'].name.useClassColor = true
	E.db.nameplates.units['ENEMY_PLAYER'].name.useClassColor = false
end

-- Applies the currently selected style without re-running the whole installer.
function Private.ApplyNameplateStyle()
	Private.NameplatesDB()

	if E.StaggeredUpdateAll then
		E:StaggeredUpdateAll()
	end
	E:UpdateAll(true)
end

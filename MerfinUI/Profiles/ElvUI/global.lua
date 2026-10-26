local addonName, Private = ...
local E, L, V, P, G = unpack(ElvUI)
local DT = E:GetModule('DataTexts')

function Private.GlobalDB()
	ElvDB.global = ElvDB.global or {}
	ElvDB.global.general = ElvDB.global.general or {}

	E.global.unitframe.raidDebuffIndicator = E.global.unitframe.raidDebuffIndicator or {}
	E.global.unitframe.raidDebuffIndicator.otherFilter = 'Debuff Indicators'
	E.global.unitframe.raidDebuffIndicator.instanceFilter = 'Debuff Indicators'

	DT:BuildPanelFrame('CustomPanel_Left')
	DT:BuildPanelFrame('CustomPanel_Right')

	E.global.datatexts.customPanels = E.global.datatexts.customPanels or {}
	E.global.datatexts.customPanels.CustomPanel_Left = E.global.datatexts.customPanels.CustomPanel_Left or {}
	E.global.datatexts.customPanels.CustomPanel_Left.backdrop = true
	E.global.datatexts.customPanels.CustomPanel_Left.benikuiStyle = true
	E.global.datatexts.customPanels.CustomPanel_Left.border = true
	E.global.datatexts.customPanels.CustomPanel_Left.enable = false
	E.global.datatexts.customPanels.CustomPanel_Left.fonts = E.global.datatexts.customPanels.CustomPanel_Left.fonts or {}
	E.global.datatexts.customPanels.CustomPanel_Left.fonts.enable = true
	E.global.datatexts.customPanels.CustomPanel_Left.fonts.font = Private.GetProfileFont()
	E.global.datatexts.customPanels.CustomPanel_Left.fonts.fontOutline = 'OUTLINE'
	E.global.datatexts.customPanels.CustomPanel_Left.frameLevel = 1
	E.global.datatexts.customPanels.CustomPanel_Left.frameStrata = 'LOW'
	E.global.datatexts.customPanels.CustomPanel_Left.growth = 'HORIZONTAL'
	E.global.datatexts.customPanels.CustomPanel_Left.mouseover = false
	E.global.datatexts.customPanels.CustomPanel_Left.name = 'CustomPanel_Left'
	E.global.datatexts.customPanels.CustomPanel_Left.numPoints = 2
	E.global.datatexts.customPanels.CustomPanel_Left.panelTransparency = true
	E.global.datatexts.customPanels.CustomPanel_Left.textJustify = 'CENTER'
	E.global.datatexts.customPanels.CustomPanel_Left.tooltipAnchor = 'ANCHOR_TOPLEFT'
	E.global.datatexts.customPanels.CustomPanel_Left.tooltipXOffset = -17
	E.global.datatexts.customPanels.CustomPanel_Left.tooltipYOffset = 4
	E.global.datatexts.customPanels.CustomPanel_Left.visibility = ''
	E.global.datatexts.customPanels.CustomPanel_Right = E.global.datatexts.customPanels.CustomPanel_Right or {}
	E.global.datatexts.customPanels.CustomPanel_Right.backdrop = true
	E.global.datatexts.customPanels.CustomPanel_Right.benikuiStyle = true
	E.global.datatexts.customPanels.CustomPanel_Right.border = true
	E.global.datatexts.customPanels.CustomPanel_Right.enable = false
	E.global.datatexts.customPanels.CustomPanel_Right.fonts = E.global.datatexts.customPanels.CustomPanel_Right.fonts or {}
	E.global.datatexts.customPanels.CustomPanel_Right.fonts.enable = true
	E.global.datatexts.customPanels.CustomPanel_Right.fonts.font = Private.GetProfileFont()
	E.global.datatexts.customPanels.CustomPanel_Right.fonts.fontOutline = 'OUTLINE'
	E.global.datatexts.customPanels.CustomPanel_Right.frameLevel = 1
	E.global.datatexts.customPanels.CustomPanel_Right.frameStrata = 'LOW'
	E.global.datatexts.customPanels.CustomPanel_Right.growth = 'HORIZONTAL'
	E.global.datatexts.customPanels.CustomPanel_Right.mouseover = false
	E.global.datatexts.customPanels.CustomPanel_Right.name = 'CustomPanel_Right'
	E.global.datatexts.customPanels.CustomPanel_Right.numPoints = 2
	E.global.datatexts.customPanels.CustomPanel_Right.panelTransparency = true
	E.global.datatexts.customPanels.CustomPanel_Right.textJustify = 'CENTER'
	E.global.datatexts.customPanels.CustomPanel_Right.tooltipAnchor = 'ANCHOR_TOPLEFT'
	E.global.datatexts.customPanels.CustomPanel_Right.tooltipXOffset = -17
	E.global.datatexts.customPanels.CustomPanel_Right.tooltipYOffset = 4
	E.global.datatexts.customPanels.CustomPanel_Right.visibility = ''

	if Private.GetProfileResolution() == 'QUAD_HD' then
		ElvDB.global.general.UIScale = 0.53333333333333
		E.global.datatexts.customPanels.CustomPanel_Left.fonts.fontSize = 14
		E.global.datatexts.customPanels.CustomPanel_Left.height = 23
		E.global.datatexts.customPanels.CustomPanel_Left.width = 471
		E.global.datatexts.customPanels.CustomPanel_Right.fonts.fontSize = 14
		E.global.datatexts.customPanels.CustomPanel_Right.height = 23
		E.global.datatexts.customPanels.CustomPanel_Right.width = 250
	elseif Private.GetProfileResolution() == 'FULL_HD' then
		ElvDB.global.general.UIScale = 0.71111111111111
		E.global.datatexts.customPanels.CustomPanel_Left.fonts.fontSize = 13
		E.global.datatexts.customPanels.CustomPanel_Left.height = 21
		E.global.datatexts.customPanels.CustomPanel_Left.width = 396
		E.global.datatexts.customPanels.CustomPanel_Right.fonts.fontSize = 13
		E.global.datatexts.customPanels.CustomPanel_Right.height = 21
		E.global.datatexts.customPanels.CustomPanel_Right.width = 230
	end

	E.global.datatexts.settings.Gold.goldFormat = 'CONDENSED'
	E.global.general.fadeMapWhenMoving = false
end

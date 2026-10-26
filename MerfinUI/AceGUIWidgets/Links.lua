local _, Private = ...

local E = unpack(ElvUI)

local CreateFrame = CreateFrame
local GameTooltip = GameTooltip
local mathRandom = math.random
local max = math.max
local unpack = unpack

local widgetType = 'MerfinUILinks'
local widgetVersion = 1
local widgetHeight = 392
local backdropTemplate = BackdropTemplateMixin and 'BackdropTemplate' or nil

local function SetFont(fontString, size)
	fontString:SetFont(E.media.normFont or STANDARD_TEXT_FONT, size, 'OUTLINE')
end

local function CreateHeading(parent, text)
	local frame = CreateFrame('Frame', nil, parent)
	frame:SetHeight(20)

	local title = frame:CreateFontString(nil, 'OVERLAY')
	SetFont(title, 14)
	title:SetTextColor(1, 0.82, 0)
	title:SetText(text)
	title:SetPoint('CENTER')

	local left = frame:CreateTexture(nil, 'ARTWORK')
	left:SetTexture(E.media.blankTex)
	left:SetVertexColor(0.35, 0.35, 0.35, 1)
	left:SetHeight(1)
	left:SetPoint('LEFT', frame, 'LEFT')
	left:SetPoint('RIGHT', title, 'LEFT', -10, 0)

	local right = frame:CreateTexture(nil, 'ARTWORK')
	right:SetTexture(E.media.blankTex)
	right:SetVertexColor(0.35, 0.35, 0.35, 1)
	right:SetHeight(1)
	right:SetPoint('LEFT', title, 'RIGHT', 10, 0)
	right:SetPoint('RIGHT', frame, 'RIGHT')

	return frame
end

local function ResetHover(button)
	button:SetBackdropColor(0, 0, 0, 0)
	button:SetBackdropBorderColor(0, 0, 0, 0)
end

local function CreateIconButton(parent, iconPath, title, url)
	local button = CreateFrame('Button', nil, parent, backdropTemplate)
	button:SetSize(46, 46)
	button:SetBackdrop({
		bgFile = E.media.blankTex,
		edgeFile = E.media.blankTex,
		edgeSize = 1,
	})
	ResetHover(button)

	local icon = button:CreateTexture(nil, 'ARTWORK')
	icon:SetPoint('TOPLEFT', 5, -5)
	icon:SetPoint('BOTTOMRIGHT', -5, 5)
	icon:SetTexture(iconPath)
	button.icon = icon

	button:SetScript('OnEnter', function(self)
		local r, g, b = unpack(E.media.rgbvaluecolor)
		self:SetBackdropColor(0.08, 0.08, 0.08, 0.9)
		self:SetBackdropBorderColor(r, g, b, 1)

		GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
		GameTooltip:ClearLines()
		GameTooltip:AddLine(title, 1, 0.82, 0)
		GameTooltip:AddLine(url, 1, 1, 1)
		GameTooltip:Show()
	end)
	button:SetScript('OnLeave', function(self)
		ResetHover(self)
		GameTooltip:Hide()
	end)

	return button
end

local function CreateLinkBox(parent, url)
	local editBox = CreateFrame('EditBox', nil, parent, backdropTemplate)
	editBox:SetHeight(26)
	editBox:SetAutoFocus(false)
	editBox:SetFont(E.media.normFont or STANDARD_TEXT_FONT, 14, 'OUTLINE')
	editBox:SetTextColor(1, 1, 1)
	editBox:SetTextInsets(7, 7, 0, 0)
	editBox:SetMaxLetters(2048)
	editBox:SetBackdrop({
		bgFile = E.media.blankTex,
		edgeFile = E.media.blankTex,
		edgeSize = 1,
	})
	editBox:SetBackdropColor(0.04, 0.04, 0.04, 0.9)
	editBox:SetBackdropBorderColor(unpack(E.media.bordercolor))
	editBox.url = url
	editBox:SetText(url)

	editBox:SetScript('OnEditFocusGained', function(self)
		self:HighlightText()
		self:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor))
	end)
	editBox:SetScript('OnEditFocusLost', function(self)
		self:SetText(self.url)
		self:SetBackdropBorderColor(unpack(E.media.bordercolor))
	end)
	editBox:SetScript('OnTextChanged', function(self)
		if self:GetText() ~= self.url then
			self:SetText(self.url)
			self:HighlightText()
		end
	end)
	editBox:SetScript('OnEscapePressed', function(self)
		self:ClearFocus()
	end)
	editBox:SetScript('OnEnterPressed', function(self)
		self:HighlightText()
	end)
	editBox:SetScript('OnMouseDown', function(self)
		self:SetFocus()
		self:HighlightText()
	end)

	return editBox
end

local function CreateLinkEntry(parent, data)
	local frame = CreateFrame('Frame', nil, parent)
	frame:SetHeight(48)

	local button = CreateIconButton(frame, data.icon, data.name, data.url)
	button:SetPoint('LEFT', frame, 'LEFT')

	local label = frame:CreateFontString(nil, 'OVERLAY')
	SetFont(label, 15)
	label:SetTextColor(1, 0.82, 0)
	label:SetText(data.name)
	label:SetPoint('TOPLEFT', button, 'TOPRIGHT', 9, -1)

	if data.badge then
		local badge = frame:CreateFontString(nil, 'OVERLAY')
		SetFont(badge, data.badgeFontSize or 12)
		badge:SetTextColor(0.55, 0.55, 0.55)
		badge:SetText(data.badge)
		badge:SetPoint('LEFT', label, 'RIGHT', 8, 0)
		frame.badge = badge
	end

	local editBox = CreateLinkBox(frame, data.url)
	editBox:SetPoint('BOTTOMLEFT', button, 'BOTTOMRIGHT', 9, 1)
	editBox:SetPoint('RIGHT', frame, 'RIGHT')

	button:SetScript('OnClick', function()
		editBox:SetFocus()
		editBox:HighlightText()
	end)

	if data.spinOnHover then
		local animation = button.icon:CreateAnimationGroup()
		local rotation = animation:CreateAnimation('Rotation')
		rotation:SetDegrees(-360)
		rotation:SetDuration(0.75)
		rotation:SetOrder(1)
		if rotation.SetSmoothing then
			rotation:SetSmoothing('OUT')
		end
		frame.rotationAnimation = animation

		local onEnter = button:GetScript('OnEnter')
		button:SetScript('OnEnter', function(self)
			onEnter(self)
			self.spinElapsed = 0
			animation:Stop()
			animation:Play()
			self:SetScript('OnUpdate', function(spinButton, elapsed)
				spinButton.spinElapsed = spinButton.spinElapsed + elapsed
				if spinButton.spinElapsed >= data.spinInterval then
					spinButton.spinElapsed = spinButton.spinElapsed - data.spinInterval
					animation:Stop()
					animation:Play()
				end
			end)
		end)

		local onLeave = button:GetScript('OnLeave')
		button:SetScript('OnLeave', function(self)
			onLeave(self)
			self:SetScript('OnUpdate', nil)
			self.spinElapsed = 0
		end)
	end

	frame.iconButton = button
	frame.editBox = editBox
	return frame
end

local function CreateWeakAurasEntry(parent, data)
	local frame = CreateFrame('Frame', nil, parent)
	frame:SetHeight(60)

	local icon = frame:CreateTexture(nil, 'ARTWORK')
	icon:SetSize(64, 64)
	icon:SetPoint('LEFT', frame, 'LEFT', 0, 0)
	icon:SetTexture(data.icon)
	frame.icon = icon

	local title = frame:CreateFontString(nil, 'OVERLAY')
	SetFont(title, 14)
	title:SetTextColor(0.25, 0.78, 0.92)
	title:SetText(data.title)
	title:SetPoint('TOPLEFT', icon, 'TOPRIGHT', 10, -5)

	local description = frame:CreateFontString(nil, 'OVERLAY')
	SetFont(description, 12)
	description:SetTextColor(0.92, 0.92, 0.92)
	description:SetText(data.description)
	description:SetPoint('TOPLEFT', title, 'BOTTOMLEFT', 0, -7)
	description:SetPoint('RIGHT', frame, 'RIGHT')
	description:SetJustifyH('LEFT')

	local badge = frame:CreateFontString(nil, 'OVERLAY')
	SetFont(badge, 12)
	badge:SetTextColor(0.55, 0.55, 0.55)
	badge:SetText(data.badge)
	badge:SetPoint('TOPLEFT', description, 'BOTTOMLEFT', 0, -6)

	return frame
end

local methods = {}

function methods:OnAcquire()
	self:SetHeight(widgetHeight)
	self:OnWidthSet(max(self.frame:GetWidth(), 540))
end

function methods:OnRelease()
	self.frame:SetScript('OnUpdate', nil)

	for _, entry in ipairs(self.linkEntries) do
		entry.editBox:ClearFocus()
		entry.editBox:SetText(entry.editBox.url)
		ResetHover(entry.iconButton)
		entry.iconButton:SetScript('OnUpdate', nil)

		if entry.rotationAnimation then
			entry.rotationAnimation:Stop()
		end
	end

	self.weakAuras.icon:SetVertexColor(1, 1, 1)
end

function methods:SetText() end

function methods:SetFontObject() end

function methods:SetImage() end

function methods:SetImageSize() end

function methods:OnWidthSet(width)
	width = max(width or 0, 540)
	local gap = 28
	local columnWidth = (width - gap) / 2

	self.socialsHeading:ClearAllPoints()
	self.socialsHeading:SetPoint('TOPLEFT', self.frame, 'TOPLEFT', 0, -3)
	self.socialsHeading:SetPoint('TOPRIGHT', self.frame, 'TOPRIGHT', 0, -3)

	local socialPositions = {
		{ 0, -32 },
		{ columnWidth + gap, -32 },
		{ 0, -88 },
		{ columnWidth + gap, -88 },
	}

	for index, entry in ipairs(self.socialEntries) do
		entry:ClearAllPoints()
		entry:SetPoint('TOPLEFT', self.frame, 'TOPLEFT', socialPositions[index][1], socialPositions[index][2])
		entry:SetWidth(columnWidth)
	end

	self.addonsHeading:ClearAllPoints()
	self.addonsHeading:SetPoint('TOPLEFT', self.frame, 'TOPLEFT', 0, -148)
	self.addonsHeading:SetPoint('TOPRIGHT', self.frame, 'TOPRIGHT', 0, -148)

	for index, entry in ipairs(self.addonEntries) do
		entry:ClearAllPoints()
		entry:SetPoint('TOPLEFT', self.frame, 'TOPLEFT', 0, -177 - ((index - 1) * 56))
		entry:SetWidth(width)
	end

	self.weakAurasHeading:ClearAllPoints()
	self.weakAurasHeading:SetPoint('TOPLEFT', self.frame, 'TOPLEFT', 0, -292)
	self.weakAurasHeading:SetPoint('TOPRIGHT', self.frame, 'TOPRIGHT', 0, -292)

	self.weakAuras:ClearAllPoints()
	self.weakAuras:SetPoint('TOPLEFT', self.frame, 'TOPLEFT', 0, -321)
	self.weakAuras:SetWidth(width)
end

function methods:StartAnimations()
	self.waColor = {
		elapsed = 0,
		duration = 2,
		fromR = 0.6,
		fromG = 0,
		fromB = 1,
		toR = 0,
		toG = 1,
		toB = 1,
	}

	self.frame:SetScript('OnUpdate', function(_, elapsed)
		self:UpdateWeakAurasColor(elapsed)
	end)
end

function methods:UpdateWeakAurasColor(elapsed)
	local color = self.waColor
	color.elapsed = color.elapsed + elapsed

	if color.elapsed >= color.duration then
		color.elapsed = color.elapsed - color.duration
		color.fromR, color.fromG, color.fromB = color.toR, color.toG, color.toB

		repeat
			color.toR = mathRandom(0, 1)
			color.toG = mathRandom(0, 1)
			color.toB = mathRandom(0, 1)
		until color.toR + color.toG + color.toB > 0
	end

	local progress = color.elapsed / color.duration
	local r = color.fromR + ((color.toR - color.fromR) * progress)
	local g = color.fromG + ((color.toG - color.fromG) * progress)
	local b = color.fromB + ((color.toB - color.fromB) * progress)
	self.weakAuras.icon:SetVertexColor(r, g, b)
end

local function Constructor(AceGUI, data)
	local frame = CreateFrame('Frame', nil, UIParent)
	frame:SetHeight(widgetHeight)
	frame:Hide()

	local widget = {
		type = widgetType,
		frame = frame,
		socialEntries = {},
		addonEntries = {},
		linkEntries = {},
	}

	for method, func in pairs(methods) do
		widget[method] = func
	end

	widget.socialsHeading = CreateHeading(frame, data.socials.heading)
	for index, linkData in ipairs(data.socials.links) do
		local entry = CreateLinkEntry(frame, linkData)
		widget.socialEntries[index] = entry
		widget.linkEntries[#widget.linkEntries + 1] = entry
	end

	widget.addonsHeading = CreateHeading(frame, data.addons.heading)
	for index, linkData in ipairs(data.addons.links) do
		local entry = CreateLinkEntry(frame, linkData)
		widget.addonEntries[index] = entry
		widget.linkEntries[#widget.linkEntries + 1] = entry
	end

	widget.weakAurasHeading = CreateHeading(frame, data.weakAuras.heading)
	widget.weakAuras = CreateWeakAurasEntry(frame, data.weakAuras)

	frame:SetScript('OnShow', function(self)
		if self.obj then
			self.obj:StartAnimations()
		end
	end)
	frame:SetScript('OnHide', function(self)
		self:SetScript('OnUpdate', nil)
		if self.obj then
			for _, entry in ipairs(self.obj.addonEntries) do
				entry.iconButton:SetScript('OnUpdate', nil)
				entry.iconButton.spinElapsed = 0
				if entry.rotationAnimation then
					entry.rotationAnimation:Stop()
				end
			end
		end
	end)

	return AceGUI:RegisterAsWidget(widget)
end

function Private.RegisterLinksWidget(data)
	local AceGUI = LibStub and LibStub('AceGUI-3.0', true)
	if not AceGUI then
		return false
	end

	if (AceGUI:GetWidgetVersion(widgetType) or 0) < widgetVersion then
		AceGUI:RegisterWidgetType(widgetType, function()
			return Constructor(AceGUI, data)
		end, widgetVersion)
	end

	return true
end

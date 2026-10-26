local _, Private = ...

local CreateFrame = CreateFrame
local tonumber = tonumber
local tostring = tostring

local widgetType = 'MerfinUISpacer'
local widgetVersion = 1

local methods = {
	OnAcquire = function(self)
		self:SetWidth(1)
		self:SetText('0')
	end,

	SetText = function(self, height)
		self:SetHeight(tonumber(height) or 0)
	end,

	SetFontObject = function() end,
}

local function Constructor(AceGUI)
	local frame = CreateFrame('Frame')
	local widget = {
		frame = frame,
		type = widgetType,
	}

	for method, func in pairs(methods) do
		widget[method] = func
	end

	return AceGUI:RegisterAsWidget(widget)
end

function Private.RegisterSpacerWidget()
	local AceGUI = LibStub and LibStub('AceGUI-3.0', true)

	if not AceGUI then
		return false
	end

	if (AceGUI:GetWidgetVersion(widgetType) or 0) < widgetVersion then
		AceGUI:RegisterWidgetType(widgetType, function()
			return Constructor(AceGUI)
		end, widgetVersion)
	end

	return true
end

function Private.AceGUISpacer(order, height)
	return {
		type = 'description',
		name = tostring(height or 0),
		order = order,
		width = 'full',
		dialogControl = widgetType,
	}
end

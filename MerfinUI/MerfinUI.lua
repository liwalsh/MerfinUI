local E = unpack(ElvUI)
local EP = LibStub('LibElvUIPlugin-1.0')
local PI = E:GetModule('PluginInstaller')

local print = print
local ReloadUI = ReloadUI
local stformat = string.format
local CreateFrame = CreateFrame
local GameMenuButtonLogout = GameMenuButtonLogout
local GameMenuFrame = GameMenuFrame
local EscapeMenu = EscapeMenu
local EscapeMenuSection = EscapeMenuSection
local HideUIPanel = HideUIPanel
local InCombatLockdown = InCombatLockdown
local addonName, Private = ...
local L = Private.L

local resolution = ({ GetScreenResolutions() })[GetCurrentResolution()] or '2560x1440'
local screenWidth, screenHeight = strsplit('x', resolution)
screenWidth, screenHeight = tonumber(screenWidth) or 2560, tonumber(screenHeight) or 1440

Private.Locale = GAME_LOCALE or GetLocale()
Private.Name = '|cff40c7ebMerfinUI|r'
Private.Version = GetAddOnMetadata(addonName, 'Version') or '0'
Private.Resolution = screenWidth >= 2530 and 'QUAD_HD' or 'FULL_HD'
Private.ScreenHeight = screenHeight
Private.Font = 'Merfin Font 1'
Private.Texture = 'Merfin Main Texture'
Private.AceProfileName = string.format('%s - %s', UnitName('player'), GetRealmName('player'))
Private.MerfinProfileName = 'MerfinUI (' .. Private.ScreenHeight .. ') v' .. Private.Version
Private.BuildInfo = select(4, GetBuildInfo())

local MUI = E:NewModule(addonName, 'AceConsole-3.0', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0')

function Private:Print(msg)
	print(stformat('%s: %s', Private.Name, msg))
end

E.PopupDialogs.MUI_RELOAD = {
	text = L['Reload required. Continue?'],
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = ReloadUI,
	whileDead = 1,
	hideOnEscape = 0,
}

local function GetAceConfigDialog()
	local dialog = E.Libs.AceConfigDialog

	if dialog then
		return dialog
	end

	if not IsAddOnLoaded('ElvUI_Options') then
		local _, _, _, _, _, reason = GetAddOnInfo('ElvUI_Options')

		if reason ~= 'MISSING' then
			EnableAddOn('ElvUI_Options')
			LoadAddOn('ElvUI_Options')
		end
	end

	return E.Libs.AceConfigDialog
end

function Private.OpenOptions()
	E:ToggleOptions()

	local dialog = GetAceConfigDialog()
	if dialog then
		dialog:SelectGroup('ElvUI', 'MUI')
	end
end

local function SetupPluginInstallerFrame()
	local frame = _G.PluginInstallFrame
	local closeButton = _G.PluginInstallCloseButton
	local nextButton = _G.PluginInstallNextButton
	local stepComplete = _G.PluginInstallStepComplete

	if frame and not frame.MerfinUIMovable then
		frame:SetMovable(true)
		frame:EnableMouse(true)
		frame:RegisterForDrag('LeftButton')
		frame:SetClampedToScreen(true)
		frame:SetScript('OnDragStart', function(self)
			self:StartMoving()
		end)
		frame:SetScript('OnDragStop', function(self)
			self:StopMovingOrSizing()
		end)
		frame.MerfinUIMovable = true
	end

	if closeButton and not closeButton.MerfinUIOptionsHooked then
		closeButton:HookScript('OnClick', function()
			Private.PendingCombatTextLayout = nil
			Private.PendingRaidFrameSelection = nil

			if not Private.ReopenOptionsAfterInstaller then
				return
			end

			Private.ReopenOptionsAfterInstaller = nil
			Private.OpenOptions()
		end)
		closeButton.MerfinUIOptionsHooked = true
	end

	if nextButton and not nextButton.MerfinUIContinueHooked then
		local nextOnClick = nextButton:GetScript('OnClick')
		nextButton:SetScript('OnClick', function(self, ...)
			if Private.CommitRaidFrameSelection then
				Private.CommitRaidFrameSelection()
			end

			if Private.CommitCombatTextSelection then
				Private.CommitCombatTextSelection()
			end

			nextOnClick(self, ...)
		end)
		nextButton.MerfinUIContinueHooked = true
	end

	if stepComplete and not stepComplete.MerfinUISoundDisabled then
		stepComplete:SetScript('OnShow', function(self)
			if not self.message then
				self:Hide()
				return
			end

			self.text:SetText(self.message)
			UIFrameFadeOut(self, 3.5, 1, 0)
			E:Delay(4, self.Hide, self)
			self.message = nil
		end)
		stepComplete.MerfinUISoundDisabled = true
	end
end

function Private.QueueInstaller(installerData, reopenOptions)
	SetupPluginInstallerFrame()
	Private.ReopenOptionsAfterInstaller = reopenOptions or nil

	if reopenOptions then
		local dialog = GetAceConfigDialog()
		if dialog then
			dialog:Close('ElvUI')
		end
	end

	PI:Queue(installerData)
end

local function ClickGameMenu()
	Private.OpenOptions()

	local menu = EscapeMenu or GameMenuFrame
	if menu and not InCombatLockdown() then
		HideUIPanel(menu)
	end
end

local function SkinGameMenuButton(button)
	local S = E:GetModule('Skins', true)

	if S and E.private.skins.blizzard.enable and E.private.skins.blizzard.misc and not button.isSkinned then
		S:HandleButton(button, nil, nil, nil, true)
		if button.backdrop then
			button.backdrop:SetInside(nil, 1, 1)
		end
	end
end

local gameMenuLogoutPoint

local function RestoreGameMenuLogout()
	if not gameMenuLogoutPoint then
		return
	end

	GameMenuButtonLogout:ClearAllPoints()
	GameMenuButtonLogout:SetPoint(
		gameMenuLogoutPoint.point,
		gameMenuLogoutPoint.relativeTo,
		gameMenuLogoutPoint.relativePoint,
		gameMenuLogoutPoint.xOfs,
		gameMenuLogoutPoint.yOfs
	)
end

local function PositionGameMenuButton()
	local button = GameMenuFrame.MerfinUI
	local anchor = GameMenuFrame.ElvUI
	if not button or not anchor then
		return
	end

	button:ClearAllPoints()
	button:SetPoint('TOPLEFT', anchor, 'BOTTOMLEFT', 0, -1)

	local point, relativeTo, relativePoint, xOfs, yOfs = GameMenuButtonLogout:GetPoint()
	if relativeTo ~= button then
		gameMenuLogoutPoint =
			{ point = point, relativeTo = relativeTo, relativePoint = relativePoint, xOfs = xOfs, yOfs = yOfs }

		GameMenuButtonLogout:ClearAllPoints()
		GameMenuButtonLogout:SetPoint('TOPLEFT', button, 'BOTTOMLEFT', 0, yOfs or -16)
	end

	if not button.MerfinUIHeightAdjusted then
		GameMenuFrame:SetHeight(GameMenuFrame:GetHeight() + GameMenuButtonLogout:GetHeight() - 4)
		button.MerfinUIHeightAdjusted = true
	end
end

local function SetupGameMenuButton()
	if not E.private.MUI.general.profileSettings.gameMenu.show then
		return
	end

	if EscapeMenu and EscapeMenu.AddButton and EscapeMenuSection and EscapeMenuSection.AddOns then
		if EscapeMenu.MerfinUI then
			return
		end

		local button = EscapeMenu:AddButton(Private.Name, EscapeMenuSection.AddOns, ClickGameMenu, nil, true)
		EscapeMenu.MerfinUI = button or true

		if button then
			SkinGameMenuButton(button)
		end

		return
	end

	if not GameMenuFrame or not GameMenuButtonLogout or GameMenuFrame.MerfinUI then
		return
	end

	local button = CreateFrame('Button', 'MerfinUI_GameMenuButton', GameMenuFrame, 'GameMenuButtonTemplate')
	button:SetText(Private.Name)
	button:SetSize(GameMenuButtonLogout:GetSize())
	button:SetScript('OnClick', ClickGameMenu)
	GameMenuFrame.MerfinUI = button

	SkinGameMenuButton(button)
	GameMenuFrame:HookScript('OnShow', PositionGameMenuButton)
	GameMenuFrame:HookScript('OnHide', RestoreGameMenuLogout)

	if E and E.PositionGameMenuButton then
		E.PositionGameMenuButton = function()
			local elvuiButton = GameMenuFrame.ElvUI
			if elvuiButton then
				elvuiButton:SetFormattedText('%sElvUI|r', E.media.hexvaluecolor)
			end
		end
	end
end

local function DeleteModified()
	if not E.private.MUI.automatation.deleteFill then
		return
	end

	local dialog = StaticPopupDialogs.DELETE_GOOD_ITEM
	if not dialog or dialog.MerfinUIHooked then
		return
	end

	hooksecurefunc(dialog, 'OnShow', function(frame)
		if E.private.MUI.automatation.deleteFill then
			frame.editBox:SetText(DELETE_ITEM_CONFIRM_STRING)
		end
	end)
	dialog.MerfinUIHooked = true
end

function MUI:PLAYER_ENTERING_WORLD(_, isInitial, isReload)
	DeleteModified()
end

function MUI:RegisterEvents()
	MUI:RegisterEvent('PLAYER_ENTERING_WORLD')
end

function MUI:Toggles(msg)
	msg = strtrim(msg or ''):lower()

	if msg == '' or msg == 'install' then
		Private.QueueInstaller(Private.InstallerData)
	elseif msg == 'qinstall' then
		Private.QueueInstaller(Private.InstallerQuick)
	elseif msg == 'config' then
		Private.OpenOptions()
	end
end

function MUI:RegisterCommands()
	self:RegisterChatCommand('merfin', 'Toggles')
	self:RegisterChatCommand('merfinui', 'Toggles')
	self:RegisterChatCommand('mui', 'Toggles')
end

local Initialize = function()
	Private.EnsureDefaults()

	if E.private.MUI.install_version == nil then
		Private.QueueInstaller(Private.InstallerData)
	end

	EP:RegisterPlugin(addonName, Private.OptionsTable)
	MUI:RegisterCommands()
	MUI:RegisterEvents()
	SetupGameMenuButton()
end

local loader = CreateFrame('Frame')
loader:RegisterEvent('ADDON_LOADED')
loader:SetScript('OnEvent', function(self, _, loadedAddon)
	if loadedAddon ~= addonName then
		return
	end

	self:UnregisterEvent('ADDON_LOADED')
	E:RegisterModule(addonName, Initialize)
end)
local Private = select(2, ...)
local L = Private.L
local E = unpack(ElvUI)
local Version = tostring(Private.Version)

local ReloadUI = ReloadUI
local format = string.format
local StopMusic = StopMusic

function Private:PluginInstallStepComplete(plugin)
	PluginInstallStepComplete:Hide()
	PluginInstallStepComplete.message = format(L['%s installed.'], plugin)
	PluginInstallStepComplete:Show()
end

function Private:InstallComplete()
	if GetCVarBool('Sound_EnableMusic') then
		StopMusic()
	end

	E.global.MUI.install_version = Version
	E.private.MUI.install_version = Version

	ReloadUI()
end

local function SelectCombatText(layout)
	if Private.Import_xCT(layout) then
		Private.PendingCombatTextLayout = layout
	end
end

local function SelectRaidFrames(frames, layout)
	Private.PendingRaidFrameSelection = nil

	if Private.ImportRaidFrames(frames, layout, true) then
		Private.PendingRaidFrameSelection = frames
	end
end

function Private.CommitRaidFrameSelection()
	local frames = Private.PendingRaidFrameSelection
	if not frames or not PluginInstallFrame or PluginInstallFrame.CurrentPage ~= 5 then
		return
	end

	Private.ApplyRaidFrameAddOnSelection(frames)
	Private.PendingRaidFrameSelection = nil
end

function Private.CommitCombatTextSelection()
	local layout = Private.PendingCombatTextLayout
	if not layout or not PluginInstallFrame or PluginInstallFrame.CurrentPage ~= 8 then
		return
	end

	if layout == 'Blizzard' then
		DisableAddOn('xCT+')
	else
		EnableAddOn('xCT+')
	end

	Private.PendingCombatTextLayout = nil
end

Private.InstallerData = {

	Title = format('|cff4beb2c%s %s|r', Private.Name, L['Installation']),
	Name = Private.Name,
	tutorialImage = 'Interface\\AddOns\\MerfinUI\\Media\\Textures\\logo_wotlk1.blp',

	Pages = {
		[1] = function()
			PluginInstallFrame.SubTitle:SetFormattedText(
				L['Welcome to the installation for %s.'],
				Private.Name .. ' ' .. Version
			)
			PluginInstallFrame.Desc1:SetText(L['This installer contains profiles for various addons in MerfinUI.'])
			PluginInstallFrame.Desc2:SetText(
				L['Before starting the installation process, I highly recommend backing up your current WTF folder to preserve your existing settings, just in case.']
			)
			PluginInstallFrame.Desc3:SetText(
				L["Don't forget to click Finished in the final step. This will reload your UI and apply all the settings."]
			)
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript('OnClick', Private.InstallComplete)
			PluginInstallFrame.Option1:SetText(L['Skip Process'])
		end,

		[2] = function()
			PluginInstallFrame.SubTitle:SetText(L['Account Settings'])
			PluginInstallFrame.Desc1:SetText(
				L['The World of Warcraft game client stores all its configurations in console variables (CVars). These variables control various aspects of the game, including graphics, sound, and the user interface.']
			)
			PluginInstallFrame.Desc3:SetText(L['Importance: |cff4beb2cOptional|r'])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript('OnClick', function()
				Private.Set_CVars()
			end)
			PluginInstallFrame.Option1:SetText(L['Load CVars'])
		end,

		[3] = function()
			PluginInstallFrame.SubTitle:SetText(L['Chat Settings'])
			PluginInstallFrame.Desc1:SetText(
				L['This will set up the chat windows to look like this:\n\nGNL - CL - LT - GLD - GRP - PM.']
			)
			PluginInstallFrame.Desc2:SetText(L['Importance: |cff4beb2cOptional|r'])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript('OnClick', function()
				Private.SetupChat()
			end)
			PluginInstallFrame.Option1:SetText(L['Setup Chat'])
		end,

		[4] = function()
			PluginInstallFrame.SubTitle:SetText(L['Profiles (ElvUI)'])
			PluginInstallFrame.Desc1:SetText(
				L["Click the button below to apply the layout of your choice, depending on your role: DPS/Tank or Healer. Use Healer-H if you prefer horizontal party frames (similar to your raid frames). Choose Healer-V if you'd like your party frames to grow vertically. I personally prefer the vertical layout, but it's up to you!"]
			)
			PluginInstallFrame.Desc2:SetText(L['Importance: |cff4beb2cHigh|r'])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript('OnClick', function()
				Private.ImportElvUI('DPS/Tank')
			end)
			PluginInstallFrame.Option1:SetText('DPS/Tank')
			PluginInstallFrame.Option2:Show()
			PluginInstallFrame.Option2:SetScript('OnClick', function()
				Private.ImportElvUI('Healer-H')
			end)
			PluginInstallFrame.Option2:SetText('Healer-H')
			PluginInstallFrame.Option3:Show()
			PluginInstallFrame.Option3:SetScript('OnClick', function()
				Private.ImportElvUI('Healer-V')
			end)
			PluginInstallFrame.Option3:SetText('Healer-V')
		end,

		[5] = function()
			PluginInstallFrame.SubTitle:SetText(L['Raid Frames'])
			PluginInstallFrame.Desc1:SetText(
				L['Cell is a standalone addon included in my AddOns pack. It is a powerful raid frame addon inspired by CompactRaid, Grid2, Aptechka, and VuhDo. With its user-friendly interface, Cell offers a smooth and intuitive experience.']
			)
			PluginInstallFrame.Desc2:SetText(L['Importance: |cff4beb2cHigh|r'])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript('OnClick', function()
				SelectRaidFrames('Cell', 'DPS/Tank')
			end)
			PluginInstallFrame.Option1:SetText('Cell (DPS/Tank)')
			PluginInstallFrame.Option2:Show()
			PluginInstallFrame.Option2:SetScript('OnClick', function()
				SelectRaidFrames('Cell', 'Healer-H')
			end)
			PluginInstallFrame.Option2:SetText('Cell (Healer-H)')
			PluginInstallFrame.Option3:Show()
			PluginInstallFrame.Option3:SetScript('OnClick', function()
				SelectRaidFrames('Cell', 'Healer-V')
			end)
			PluginInstallFrame.Option3:SetText('Cell (Healer-V)')
			PluginInstallFrame.Option4:Show()
			PluginInstallFrame.Option4:SetScript('OnClick', function()
				SelectRaidFrames('ElvUI')
			end)
			PluginInstallFrame.Option4:SetText(L['ElvUI Frames'])
		end,

		[6] = function()
			PluginInstallFrame.SubTitle:SetText(L['Color Theme'])
			PluginInstallFrame.Desc1:SetText(L['Click on the button to set color theme.'])
			PluginInstallFrame.Desc3:SetText(L['Importance: |cff4beb2cOptional|r'])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript('OnClick', function()
				Private.ChangeTheme('Dark')
			end)
			PluginInstallFrame.Option1:SetText(L['Dark Theme'])
			PluginInstallFrame.Option2:Show()
			PluginInstallFrame.Option2:SetScript('OnClick', function()
				Private.ChangeTheme('Normal')
			end)
			PluginInstallFrame.Option2:SetText(L['Class Theme'])
		end,

		[7] = function()
			PluginInstallFrame.SubTitle:SetText(L['Action Bar Settings'])
			PluginInstallFrame.Desc1:SetText(L['Click on the button to set action bars visibility.'])
			PluginInstallFrame.Desc3:SetText(L['Importance: |cff4beb2cOptional|r'])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript('OnClick', function()
				Private.ActionBarsVisibility(true)
			end)
			PluginInstallFrame.Option1:SetText(L['Show Always'])
			PluginInstallFrame.Option2:Show()
			PluginInstallFrame.Option2:SetScript('OnClick', function()
				Private.ActionBarsVisibility(false)
			end)
			PluginInstallFrame.Option2:SetText(L['Show Mouseover'])
		end,

		[8] = function()
			PluginInstallFrame.SubTitle:SetText(L['Combat Text'])
			PluginInstallFrame.Desc1:SetText(
				L['Here you can choose how to display Combat Text (damage, healing numbers, etc.). If you prefer the normal numbers above the mobs, click on Blizzard. If you prefer damage numbers to be stacked in one place, use xCT — either xCT DPS/Tank or xCT Healer, depending on your spec.']
			)
			PluginInstallFrame.Desc2:SetText(L['Importance: |cff4beb2cHigh|r'])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript('OnClick', function()
				SelectCombatText('Blizzard')
			end)
			PluginInstallFrame.Option1:SetText('Blizzard CText')
			PluginInstallFrame.Option2:Show()
			PluginInstallFrame.Option2:SetScript('OnClick', function()
				SelectCombatText('DPS/Tank')
			end)
			PluginInstallFrame.Option2:SetText('xCT+ DPS/Tank')
			PluginInstallFrame.Option3:Show()
			PluginInstallFrame.Option3:SetScript('OnClick', function()
				SelectCombatText('Healer')
			end)
			PluginInstallFrame.Option3:SetText('xCT+ Healer')
		end,

		[9] = function()
			PluginInstallFrame.SubTitle:SetText(L['Deadly Boss Mods'])
			PluginInstallFrame.Desc1:SetText(L['Click on the button to adjust settings.'])
			PluginInstallFrame.Desc2:SetText(L['Importance: |cff4beb2cHigh|r'])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript('OnClick', function()
				Private.ImportDBM('DPS/Tank')
			end)
			PluginInstallFrame.Option1:SetText('DPS/Tank')
			PluginInstallFrame.Option2:Show()
			PluginInstallFrame.Option2:SetScript('OnClick', function()
				Private.ImportDBM('Healer')
			end)
			PluginInstallFrame.Option2:SetText('Healer')
		end,

		[10] = function()
			PluginInstallFrame.SubTitle:SetText(L['Damage Meter'])
			PluginInstallFrame.Desc1:SetText(L['Click on the button to adjust settings.'])
			PluginInstallFrame.Desc3:SetText(L['Importance: |cff4beb2cHigh|r'])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript('OnClick', function()
				Private.ImportSkada('Normal')
			end)
			PluginInstallFrame.Option1:SetText(L['Skada'])
			PluginInstallFrame.Option2:Show()
			PluginInstallFrame.Option2:SetScript('OnClick', function()
				Private.ImportDetails('Normal')
			end)
			PluginInstallFrame.Option2:SetText(L['Details'])
		end,

		[11] = function()
			PluginInstallFrame.SubTitle:SetText(L['Installation Complete'])
			PluginInstallFrame.Desc1:SetText(L['You have completed the installation process.'])
			PluginInstallFrame.Desc2:SetText(
				L['You must click the button below to finalize the process and automatically reload your UI.']
			)
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript('OnClick', Private.InstallComplete)
			PluginInstallFrame.Option1:SetText(L['Finished'])
		end,
	},

	StepTitles = {
		[1] = L['Welcome'],
		[2] = L['Account Settings'],
		[3] = L['Chat Settings'],
		[4] = L['Profiles (ElvUI)'],
		[5] = L['Raid Frames'],
		[6] = L['Color Theme'],
		[7] = L['Action Bar Settings'],
		[8] = L['Combat Text'],
		[9] = L['Deadly Boss Mods'],
		[10] = L['Damage Meter'],
		[11] = L['Installation Complete'],
	},

	StepTitlesColor = { 1, 1, 1 },
	StepTitlesColorSelected = { 0, 179 / 255, 1 },
	StepTitleWidth = 230,
	StepTitleButtonWidth = 210,
	StepTitleTextJustification = 'RIGHT',
}

Private.QuickInstall = function(layout, theme)
	local roleLayout = (layout == 'Healer-H' or layout == 'Healer-V' or layout == 'Healer') and 'Healer' or 'DPS/Tank'
	local frameLayout = layout == 'Healer' and 'Healer-H' or layout

	Private.Set_CVars()
	Private.SetupChat()
	Private.ImportElvUI(frameLayout)
	Private.Import_xCT(roleLayout)
	Private.ImportDBM(roleLayout)

	if E:IsAddOnEnabled('Cell') then
		Private.ImportRaidFrames('Cell', frameLayout)
	else
		Private.ImportRaidFrames('ElvUI')
	end

	Private.ChangeTheme(theme or 'Dark')

	Private:InstallComplete()
end

Private.InstallerQuick = {

	Title = format('|cff4beb2c%s %s|r', Private.Name, 'Installation'),
	Name = Private.Name,
	tutorialImage = 'Interface\\AddOns\\MerfinUI\\Media\\Textures\\logo_wotlk1.blp',

	Pages = {
		[1] = function()
			PluginInstallFrame.SubTitle:SetFormattedText(
				L['Welcome to the Quick installation for %s.'],
				Private.Name .. ' ' .. Version
			)
			PluginInstallFrame.Desc1:SetText(
				L["This installer will quickly set up all addons and profiles (except for WeakAuras, as neither the full installer currently handles WeakAuras). With just one click, everything will be configured, followed by a reload at the end. If you're unsure, consider using the standard installer instead."]
			)
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript('OnClick', function()
				Private.QuickInstall('DPS/Tank', 'Dark')
			end)
			PluginInstallFrame.Option1:SetText(L['DPS/Tank'] .. ' ' .. L['Dark'])
			PluginInstallFrame.Option2:Show()
			PluginInstallFrame.Option2:SetScript('OnClick', function()
				Private.QuickInstall('Healer', 'Dark')
			end)
			PluginInstallFrame.Option2:SetText(L['Healer'] .. ' ' .. L['Dark'])
			PluginInstallFrame.Option3:Show()
			PluginInstallFrame.Option3:SetScript('OnClick', function()
				Private.QuickInstall('DPS/Tank', 'Normal')
			end)
			PluginInstallFrame.Option3:SetText(L['DPS/Tank'] .. ' ' .. L['Class'])
			PluginInstallFrame.Option4:Show()
			PluginInstallFrame.Option4:SetScript('OnClick', function()
				Private.QuickInstall('Healer', 'Normal')
			end)
			PluginInstallFrame.Option4:SetText(L['Healer'] .. ' ' .. L['Class'])
		end,
	},

	StepTitles = {
		[1] = L['Quick Install'],
	},

	StepTitlesColor = { 1, 1, 1 },
	StepTitlesColorSelected = { 0, 179 / 255, 1 },
	StepTitleWidth = 230,
	StepTitleButtonWidth = 210,
	StepTitleTextJustification = 'RIGHT',
}

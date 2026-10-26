local addonName, Private = ...
local E, L, V, P, G = unpack(ElvUI)
local CH = E:GetModule('Chat')

local _G = _G
local ipairs = ipairs
local SetCVar = SetCVar

local FCF_SetWindowName = FCF_SetWindowName
local FCF_OpenNewWindow = FCF_OpenNewWindow
local FCF_ResetChatWindows = FCF_ResetChatWindows
local FCFDock_SelectWindow = FCFDock_SelectWindow
local FCF_SetChatWindowFontSize = FCF_SetChatWindowFontSize

local ChatFrame_AddMessageGroup = ChatFrame_AddMessageGroup
local ChatFrame_RemoveMessageGroup = ChatFrame_RemoveMessageGroup
local ChatFrame_RemoveAllMessageGroups = ChatFrame_RemoveAllMessageGroups

local JoinChannelByName = JoinChannelByName
local ChatFrame_RemoveChannel = ChatFrame_RemoveChannel
local ChatFrame_AddChannel = ChatFrame_AddChannel

function Private.SetupChat()
	-- Reset to default
	FCF_ResetChatWindows()

	-- Create new windows
	FCF_OpenNewWindow() -- id 3
	FCF_OpenNewWindow() -- id 4
	FCF_OpenNewWindow() -- id 5
	FCF_OpenNewWindow() -- id 6

	local fontSize = 15

	-- Rename all windows
	for _, name in ipairs(_G.CHAT_FRAMES) do
		local frame = _G[name]
		local id = frame:GetID()

		-- Update tab colors
		if E.private.chat.enable then
			CH:UpdateChatTabs()
			--CH:FCFTab_UpdateColors(CH:GetTab(_G[name]))
		end

		-- Set font size
		FCF_SetChatWindowFontSize(nil, frame, fontSize)

		if id == 1 then
			FCF_SetWindowName(frame, 'GNL')
		elseif id == 2 then
			FCF_SetWindowName(frame, 'CL')
		elseif id == 3 then
			FCF_SetWindowName(frame, 'LT')
		elseif id == 4 then
			FCF_SetWindowName(frame, 'GLD')
		elseif id == 5 then
			FCF_SetWindowName(frame, 'GRP')
		elseif id == 6 then
			FCF_SetWindowName(frame, 'PM')
		end
	end


	local chatGroup = {"SAY", "EMOTE", "YELL", "WHISPER", "PARTY", "PARTY_LEADER", "RAID", "RAID_LEADER", "RAID_WARNING", "BATTLEGROUND", "BATTLEGROUND_LEADER", "GUILD", "OFFICER", "ACHIEVEMENT", "GUILD_ACHIEVEMENT"}
	for i = 1, MAX_WOW_CHAT_CHANNELS do
		tinsert(chatGroup, "CHANNEL"..i)
	end
	for _, v in ipairs(chatGroup) do
		ToggleChatColorNamesByClassGroup(true, v)
	end

	-- Tab setup: GNL (General)
	local chats = { 'SYSTEM', 'CHANNEL', 'SAY', 'EMOTE', 'YELL', 'MONSTER_SAY', 'MONSTER_YELL', 'MONSTER_EMOTE', 'MONSTER_WHISPER', 'MONSTER_BOSS_EMOTE', 'MONSTER_BOSS_WHISPER', 'ERRORS', 'AFK', 'DND', 'IGNORED', 'BG_HORDE', 'BG_ALLIANCE', 'BG_NEUTRAL', 'ACHIEVEMENT' }
	for i = 1, MAX_WOW_CHAT_CHANNELS do
		tinsert(chats, "CHANNEL"..i)
	end
	ChatFrame_RemoveAllMessageGroups(_G.ChatFrame1)
	for _, k in ipairs(chats) do
		ChatFrame_AddMessageGroup(_G.ChatFrame1, k)
	end

	-- Tab setup: CL (Combat Log)
	local chats = { 'COMBAT_LOG_EVENT' }
	ChatFrame_RemoveAllMessageGroups(_G.ChatFrame2)
	for _, k in ipairs(chats) do
		ChatFrame_AddMessageGroup(_G.ChatFrame2, k)
	end

	-- Tab setup: LT (Loot)
	local chats = { 'COMBAT_XP_GAIN', 'COMBAT_HONOR_GAIN', 'COMBAT_FACTION_CHANGE', 'SKILL', 'LOOT', 'MONEY' }
	ChatFrame_RemoveAllMessageGroups(_G.ChatFrame3)
	for _, k in ipairs(chats) do
		ChatFrame_AddMessageGroup(_G.ChatFrame3, k)
	end

	-- Tab setup: GLD (Guild)
	local chats = { 'GUILD', 'GUILD_ACHIEVEMENT', 'OFFICER' }
	ChatFrame_RemoveAllMessageGroups(_G.ChatFrame4)
	for _, k in ipairs(chats) do
		ChatFrame_AddMessageGroup(_G.ChatFrame4, k)
	end

	-- Tab setup: RAID
	local chats = { 'PARTY', 'PARTY_LEADER', 'RAID', 'RAID_LEADER', 'RAID_WARNING', 'INSTANCE_CHAT', 'INSTANCE_CHAT_LEADER',  'BATTLEGROUND', 'BATTLEGROUND_LEADER' }
	ChatFrame_RemoveAllMessageGroups(_G.ChatFrame5)
	for _, k in ipairs(chats) do
		ChatFrame_AddMessageGroup(_G.ChatFrame5, k)
	end

	-- Tab setup: /W (Whisper)
	local chats = { 'WHISPER', 'WHISPER_INFORM' , 'BN_WHISPER', 'BN_CONVERSATION', 'BN_INLINE_TOAST_ALERT' }
	ChatFrame_RemoveAllMessageGroups(_G.ChatFrame6)
	for _, k in ipairs(chats) do
		ChatFrame_AddMessageGroup(_G.ChatFrame6, k)
	end

	-- Jump back to General tab
	FCFDock_SelectWindow(_G.GENERAL_CHAT_DOCK, _G.ChatFrame1)

	Private:PluginInstallStepComplete('Chat Settings')
end

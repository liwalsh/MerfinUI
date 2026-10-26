local addonName, Private = ...
local E, L, V, P, G = unpack(ElvUI)

function Private.PrivateDB()
	E.private.general.chatBubbleFont = Private.Font
	E.private.general.chatBubbleFontSize = 10
	E.private.general.chatBubbleName = false
	E.private.general.chatBubbles = 'backdrop'
	E.private.general.dmgfont = Private.Font
	E.private.general.glossTex = Private.GetProfileTexture()
	E.private.general.namefont = Private.Font
	E.private.general.nameplateFont = Private.Font
	E.private.general.normTex = Private.GetProfileTexture()
	E.private.general.totemBar = false
	E.private.general.totemTracker = false
	E.private.general.selectQuestReward = true
	E.private.general.replaceNameplateFont = false

	if Private.GetProfileResolution() == 'QUAD_HD' then
		E.private.general.nameplateFontSize = 11
	elseif Private.GetProfileResolution() == 'FULL_HD' then
		E.private.general.nameplateFontSize = 10
	end

	E.private.bags.enable = true
	E.private.bags.bagBar = false
end

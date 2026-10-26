local E, L, V, P, G = unpack(ElvUI)
local addonName, Private = ...

Private.resolutions = {
	FULL_HD = 'Full HD (1920-1080px)',
	QUAD_HD = 'Quad HD (2560-1440px)',
}

Private.nameplateStyles = {
	Classic = Private.L['Classic'],
	Modern = Private.L['Modern'],
}

G.MUI = {
	install_version = nil,
}

-- E.private.MUI
V.MUI = {
	general = {
		profileSettings = {
			media = {
				resolution = Private.Resolution,
				texture = Private.Texture,
			},
			editmode = {
				show = false,
			},
			cooldownManager = {
				show = false,
			},
			gameMenu = {
				show = true,
			},
			actionbars = {
				showGrid = false,
				showMouseover = true,
			},
			unitframes = {
				transparentHealth = false,
			},
			Portrait = {
				playerPortrait = false,
				targetPortrait = false,
			},
			Pets = {
				partyPets = false,
				raidPets = false,
			},
			CastBar = {
				playerCastBar = false,
				petCastBar = false,
				targetCastBar = false,
				focusCastBar = false,
			},
			blacklist = {
				movers = false,
				actionBars = false,
			},
			nameplates = {
				style = 'Classic',
			},
		},
		layout = {
			dark = {
				color = { r = 0.1803921568627451, g = 0.1607843137254902, b = 0.1607843137254902, a = 1 },
				backdrop = { r = 0.5490196078431373, g = 0.4549019607843137, b = 0.4549019607843137, a = 1 },
				dead = { r = 1, g = 0.25098039215686, b = 0.25098039215686, a = 1 },
			},
		},
	},
	automatation = {
		deleteFill = true,
	},
}

-- E.global
G.MUI = {}

local function CopyDefaults(dest, src)
	for key, value in pairs(src) do
		if type(value) == 'table' then
			if type(dest[key]) ~= 'table' then
				dest[key] = {}
			end

			CopyDefaults(dest[key], value)
		elseif dest[key] == nil then
			dest[key] = value
		end
	end
end

function Private.EnsureDefaults()
	E.private.MUI = E.private.MUI or {}
	CopyDefaults(E.private.MUI, V.MUI)
	E.private.MUI.general.profileSettings.media.font = nil
end

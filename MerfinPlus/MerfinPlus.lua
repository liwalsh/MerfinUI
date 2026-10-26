local _, MerfinPlus = ...
MerfinPlus = LibStub("AceAddon-3.0"):NewAddon(MerfinPlus, "MerfinPlus", "AceEvent-3.0")

MerfinPlus.BuildInfo = select(4, GetBuildInfo())

function MerfinPlus:OnInitialize()
  self.db = LibStub("AceDB-3.0"):New("MerfinPlusSaved", MerfinPlus.defaults, true)
  self:RegisterCustomFonts()
  self:RegisterCustomBars()
  self:RegisterMediaAliasesFromCallback()
  self:RegisterFonts()
  self:RegisterBars()
  self:SetupOptions()
end

function MerfinPlus:OnEnable()
  self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function MerfinPlus:PLAYER_ENTERING_WORLD()
  self:UnregisterEvent("PLAYER_ENTERING_WORLD")

  local E = ElvUI and unpack(ElvUI)
  if E then
    local version = tostring(E.version or GetAddOnMetadata("ElvUI", "Version") or "")
    local majorVersion = tonumber(version:match("(%d+)"))

    if majorVersion and majorVersion < 7 then
      E.recievedOutOfDateMessage = true
      E.pluginRecievedOutOfDateMessage = true
    end
  end
end

Merfin = Merfin or {}

Merfin.L = GetLocale()
Merfin.ForcedSoundLoc = false

local supportedLoc = {
  ["ruRU"] = true,
  ["enUS"] = true,
  ["zhCN"] = true,
}

Merfin.GetLocale = function()
  if Merfin.ForcedSoundLoc then
    return Merfin.ForcedSoundLoc
  elseif not supportedLoc[Merfin.L] then
    return "enUS"
  else
    return Merfin.L
  end
end

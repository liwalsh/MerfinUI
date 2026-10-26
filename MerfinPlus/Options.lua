-- MerfinPlus Options & Media Registration
-- Comments in English as requested.

local _, MerfinPlus = ...

local AceDBOptions = LibStub("AceDBOptions-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")
local AceConsole = LibStub("AceConsole-3.0")
local LSM = LibStub("LibSharedMedia-3.0")
local Locale = GetLocale()
local L = MerfinPlus.L

MerfinPlus.GetDefaultFont = function(type)
  local toc = select(4, GetBuildInfo())
  return (Locale == "zhTW" or Locale == "zhCN" or toc == 38000) and "CN Merged (SF-Yahee)"
    or (type == "bold" and "SFUIDisplayCondensed-Bold" or "SFUIDisplayCondensed-Semibold")
end

MerfinPlus.GetDefaultRaidFont = function(type)
  local toc = select(4, GetBuildInfo())
  return (Locale == "zhTW" or Locale == "zhCN" or toc == 38000) and "CN Merged (SF-Yahee)"
    or (type == "bold" and "PT Sans Narrow Bold" or "PT Sans Narrow")
end

Merfin.GetDefaultFont = MerfinPlus.GetDefaultFont
Merfin.GetDefaultRaidFont = MerfinPlus.GetDefaultRaidFont

MerfinPlus.defaults = {
  profile = {
    pullStartTime = 0,
    pullExpTime = 0,
    pullTotalTime = 0,
    pullSenderName = "Unknown",
    breakStartTime = 0,
    breakExpTime = 0,
    breakTotalTime = 0,
    breakSenderName = "Unknown",
    lfgStartTimer = 0,
    lfgExpTimer = 0,

    font1 = MerfinPlus.GetDefaultFont(),
    font2 = MerfinPlus.GetDefaultFont("bold"),
    font3 = MerfinPlus.GetDefaultRaidFont(),
    font4 = MerfinPlus.GetDefaultRaidFont("bold"),
    bar1 = "MerfinMainDark",
    bar2 = "MerfinMain",
    bar3 = "MerfinMainDark",
  },
}

-- Helper to access the active profile table safely
function MerfinPlus:GetDB()
  return (self.db and self.db.profile) or MerfinPlus.defaults.profile
end

-- Build and register all options (Blizzard panels + standalone window + slash commands)
function MerfinPlus:SetupOptions()
  local version = GetAddOnMetadata("MerfinPlus", "Version") or "?"

  -- ==== Media lists (LSM) ====
  local function GetFontList()
    local fonts = {}
    local excluded = {
      ["Merfin Font 1"] = true,
      ["Merfin Font 2"] = true,
      ["Merfin Raid Font"] = true,
      ["Merfin Raid Font (Bold)"] = true,
    }
    for name in pairs(LSM:HashTable("font")) do
      if not excluded[name] then
        fonts[name] = name
      end
    end
    return fonts
  end

  local function GetStatusBarList()
    local bars = {}
    local excluded = {
      ["Merfin Status Bar 1"] = true,
      ["Merfin Status Bar 2"] = true,
      ["Merfin Raid Status Bar"] = true,
    }
    for name in pairs(LSM:HashTable("statusbar")) do
      if not excluded[name] then
        bars[name] = name
      end
    end
    return bars
  end

  -- ==== UI reload popup ====
  local function ConfirmReload()
    StaticPopupDialogs["MERFINPLUS_RELOAD_UI"] = {
      text = L["A reload of the interface is required for this change to take effect.\n\nReload now?"],
      button1 = YES,
      button2 = NO,
      OnAccept = function()
        ReloadUI()
      end,
      timeout = 0,
      whileDead = true,
      hideOnEscape = true,
      preferredIndex = 3,
    }
    StaticPopup_Show("MERFINPLUS_RELOAD_UI")
  end

  -- ==== Root (Blizzard top-level) ====
  local mainOptions = {
    type = "group",
    name = "MerfinPlus v" .. version,
    args = {
      version = {
        type = "description",
        name = "|cff00ccff" .. L["Version:"] .. "|r" .. version,
        fontSize = "medium",
        order = 1,
      },
      author = {
        type = "description",
        name = L["Author: "] .. "Merfin",
        fontSize = "medium",
        order = 2,
      },
      spacer = { type = "description", name = " ", order = 3 },
      description = {
        type = "description",
        name = L["MerfinPlus provides custom fonts, textures, and utilities that enhance or support WeakAuras and other Merfin UI components."],
        fontSize = "large",
        order = 4,
      },
      spacer2 = { type = "description", name = " ", order = 5 },
    },
  }

  -- ==== Media ====
  local mediaOptions = {
    type = "group",
    name = L["Media"],
    args = {
      description = {
        type = "description",
        name = L["Change primary fonts and status bar textures used by Merfin features. A UI reload is required."],
        fontSize = "medium",
        order = 0,
      },
    },
  }

  local fontNames = { "Merfin Font 1", "Merfin Font 2", "Merfin Raid Font", "Merfin Raid Font (Bold)" }
  local barNames = { "Merfin Status Bar 1", "Merfin Status Bar 2", "Merfin Raid Status Bar" }

  for i = 1, #fontNames do
    mediaOptions.args["font" .. i] = {
      type = "select",
      name = fontNames[i],
      desc = L["Select font for element "] .. i,
      values = GetFontList,
      get = function()
        return self.db.profile["font" .. i]
      end,
      set = function(_, v)
        self.db.profile["font" .. i] = v
        ConfirmReload()
      end,
      dialogControl = "LSM30_Font",
      order = i + 1,
    }
  end
  for i = 1, #barNames do
    mediaOptions.args["bar" .. i] = {
      type = "select",
      name = barNames[i],
      desc = L["Select status bar texture for element "] .. i,
      values = GetStatusBarList,
      get = function()
        return self.db.profile["bar" .. i]
      end,
      set = function(_, v)
        self.db.profile["bar" .. i] = v
        ConfirmReload()
      end,
      dialogControl = "LSM30_Statusbar",
      order = i + 10,
    }
  end

  -- ==== Profiles (AceDB) ====
  local profilesOptions = AceDBOptions:GetOptionsTable(self.db)
  profilesOptions.name = L["Profiles"] or "Profiles" -- ensure the node has a name

  -- ==== Register Blizzard panels (left AddOns pane) ====
  AceConfigRegistry:RegisterOptionsTable("MerfinPlus", mainOptions)
  self.optionsFrame = AceConfigDialog:AddToBlizOptions("MerfinPlus", "MerfinPlus v" .. version)

  AceConfigRegistry:RegisterOptionsTable("MerfinPlus_Media", mediaOptions)
  AceConfigDialog:AddToBlizOptions("MerfinPlus_Media", "Media", "MerfinPlus v" .. version)

  AceConfigRegistry:RegisterOptionsTable("MerfinPlus_Profiles", profilesOptions)
  AceConfigDialog:AddToBlizOptions("MerfinPlus_Profiles", "Profiles", "MerfinPlus v" .. version)

  -- ==== Standalone window (own AceConfigDialog frame) ====
  -- IMPORTANT: include whole profilesOptions object, not just .args, to keep its handler intact.
  local standaloneOptions = {
    type = "group",
    name = "MerfinPlus v" .. version,
    childGroups = "tree",
    args = {
      media = (function()
        mediaOptions.order = 10
        mediaOptions.childGroups = nil
        return mediaOptions
      end)(),
      profiles = (function()
        profilesOptions.order = 100
        return profilesOptions
      end)(),
    },
  }

  AceConfigRegistry:RegisterOptionsTable("MerfinPlus_Standalone", standaloneOptions)
  AceConfigDialog:SetDefaultSize("MerfinPlus_Standalone", 700, 500)

  -- Toggle standalone and optionally preselect section/subtab
  function MerfinPlus:ToggleStandalone(which, sub)
    local ACD = AceConfigDialog
    if ACD.OpenFrames and ACD.OpenFrames["MerfinPlus_Standalone"] then
      ACD:Close("MerfinPlus_Standalone")
    else
      ACD:Open("MerfinPlus_Standalone")
    end
    if which == "media" or which == "raid" or which == "profiles" then
      if which == "raid" and sub then
        ACD:SelectGroup("MerfinPlus_Standalone", "raid", sub)
      else
        ACD:SelectGroup("MerfinPlus_Standalone", which)
      end
    end

    if which == "media" or which == "profiles" then
      ACD:SelectGroup("MerfinPlus_Standalone", which)
    end
  end

  -- ==== Slash commands ====
  local function _norm(msg)
    return strlower(strtrim(msg or ""))
  end

  -- /merfinplus [media|profiles]
  AceConsole:RegisterChatCommand("merfinplus", function(msg)
    msg = _norm(msg)
    local which, sub = strmatch(msg, "^(%S+)%s+(%S+)$")
    which = which or msg
    if which == "media" or which == "profiles" then
      MerfinPlus:ToggleStandalone(which)
    else
      MerfinPlus:ToggleStandalone(nil)
    end
  end)

  AceConsole:RegisterChatCommand("mp", function(msg)
    msg = _norm(msg)
    local which, sub = strmatch(msg, "^(%S+)%s+(%S+)$")
    which = which or msg
    if which == "media" or which == "profiles" then
      MerfinPlus:ToggleStandalone(which)
    else
      MerfinPlus:ToggleStandalone(nil)
    end
  end)
end

-- ==== Media registration ====
function MerfinPlus:RegisterCustomFonts()
  local db = self:GetDB()
  local fonts = {
    { key = "font1", name = "Merfin Font 1" },
    { key = "font2", name = "Merfin Font 2" },
    { key = "font3", name = "Merfin Raid Font" },
    { key = "font4", name = "Merfin Raid Font (Bold)" },
  }
  for _, f in ipairs(fonts) do
    local path = LSM:Fetch("font", db[f.key], true)
    if path then
      LSM:Register(
        "font",
        f.name,
        path,
        LSM.LOCALE_BIT_western + LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_koKR + LSM.LOCALE_BIT_zhCN + LSM.LOCALE_BIT_zhTW
      )
    else
      -- print(string.format("|cffff0000[MerfinPlus]|r Failed to register %s - invalid font path", f.name))
    end
  end
end

function MerfinPlus:RegisterCustomBars()
  local db = self:GetDB()
  local bars = {
    { key = "bar1", name = "Merfin Status Bar 1" },
    { key = "bar2", name = "Merfin Status Bar 2" },
    { key = "bar3", name = "Merfin Raid Status Bar" },
  }
  for _, b in ipairs(bars) do
    local path = LSM:Fetch("statusbar", db[b.key], true)
    if path then
      LSM:Register("statusbar", b.name, path)
    else
      -- print(string.format("|cffff0000[MerfinPlus]|r Failed to register %s - invalid status bar path", b.name))
    end
  end
end

-- Mirror current selection under alias names for other addons/WA to consume
function MerfinPlus:RegisterMediaAliasesFromCallback()
  local db = self:GetDB()

  local fontMap = {
    { key = db.font1, alias = "Merfin Font 1" },
    { key = db.font2, alias = "Merfin Font 2" },
    { key = db.font3, alias = "Merfin Raid Font" },
    { key = db.font4, alias = "Merfin Raid Font (Bold)" },
  }
  local barMap = {
    { key = db.bar1, alias = "Merfin Status Bar 1" },
    { key = db.bar2, alias = "Merfin Status Bar 2" },
    { key = db.bar3, alias = "Merfin Raid Status Bar" },
  }

  LSM.RegisterCallback(self, "LibSharedMedia_Registered", function(_, mediatype, key)
    if mediatype == "font" then
      for _, e in ipairs(fontMap) do
        if e.key == key then
          local path = LSM:Fetch("font", e.key)
          if path then
            LSM:Register(
              "font",
              e.alias,
              path,
              LSM.LOCALE_BIT_western
                + LSM.LOCALE_BIT_ruRU
                + LSM.LOCALE_BIT_koKR
                + LSM.LOCALE_BIT_zhCN
                + LSM.LOCALE_BIT_zhTW
            )
          end
        end
      end
    elseif mediatype == "statusbar" or mediatype == "statusbar_atlas" then
      for _, e in ipairs(barMap) do
        if e.key == key then
          local path = LSM:Fetch("statusbar", e.key)
          if path then
            LSM:Register("statusbar", e.alias, path)
          end
        end
      end
    end
  end)
end

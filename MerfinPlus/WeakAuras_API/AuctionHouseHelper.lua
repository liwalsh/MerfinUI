Merfin = Merfin or {}

local AH = _G.MerfinAuctionHelperTBC or {}
_G.MerfinAuctionHelperTBC = AH

AH.version = 1

local DEFAULT_BUTTON_OPTIONS = {
  borderColor = { 0.15, 0.65, 1, 1 },
  pressedBorderColor = { 0.05, 0.45, 1, 1 },
  borderSize = 2,
}

local function AddMessage(message, r, g, b)
  if UIErrorsFrame and UIErrorsFrame.AddMessage then
    UIErrorsFrame:AddMessage(message, r or 1, g or 0.1, b or 0.1, 1)
  else
    --print(message)
  end
end

local function CopyColor(color, fallback)
  if type(color) ~= "table" then
    color = fallback
  end

  return {
    color[1] or fallback[1] or 1,
    color[2] or fallback[2] or 1,
    color[3] or fallback[3] or 1,
    color[4] or fallback[4] or 1,
  }
end

local function CreateBorderTexture(parent)
  local texture = parent:CreateTexture(nil, "OVERLAY")
  texture:SetTexture("Interface\\Buttons\\WHITE8x8")
  return texture
end

local function UpdateBorder(env, state)
  local region = env and env.region
  if not region then
    return nil
  end

  if not state.border then
    local border = CreateFrame("Frame", nil, region)
    state.border = border
    border:EnableMouse(false)
    border.top = CreateBorderTexture(border)
    border.bottom = CreateBorderTexture(border)
    border.left = CreateBorderTexture(border)
    border.right = CreateBorderTexture(border)
    border:Hide()
  end

  local border = state.border
  local size = state.borderSize or DEFAULT_BUTTON_OPTIONS.borderSize

  border:SetParent(region)
  border:ClearAllPoints()
  border:SetAllPoints(region)

  if region.GetFrameStrata then
    border:SetFrameStrata(region:GetFrameStrata())
  end

  if region.GetFrameLevel then
    border:SetFrameLevel(region:GetFrameLevel() + 11)
  end

  border.top:ClearAllPoints()
  border.top:SetPoint("TOPLEFT", border, "TOPLEFT", 0, 0)
  border.top:SetPoint("TOPRIGHT", border, "TOPRIGHT", 0, 0)
  border.top:SetHeight(size)

  border.bottom:ClearAllPoints()
  border.bottom:SetPoint("BOTTOMLEFT", border, "BOTTOMLEFT", 0, 0)
  border.bottom:SetPoint("BOTTOMRIGHT", border, "BOTTOMRIGHT", 0, 0)
  border.bottom:SetHeight(size)

  border.left:ClearAllPoints()
  border.left:SetPoint("TOPLEFT", border, "TOPLEFT", 0, -size)
  border.left:SetPoint("BOTTOMLEFT", border, "BOTTOMLEFT", 0, size)
  border.left:SetWidth(size)

  border.right:ClearAllPoints()
  border.right:SetPoint("TOPRIGHT", border, "TOPRIGHT", 0, -size)
  border.right:SetPoint("BOTTOMRIGHT", border, "BOTTOMRIGHT", 0, size)
  border.right:SetWidth(size)

  return border
end

local function ApplyButtonVisual(env, state)
  if not state then
    return
  end

  local border = UpdateBorder(env, state)
  if not border then
    return
  end

  if state.hover or state.pressed then
    local color = state.pressed and state.pressedBorderColor or state.borderColor
    border.top:SetVertexColor(color[1], color[2], color[3], color[4])
    border.bottom:SetVertexColor(color[1], color[2], color[3], color[4])
    border.left:SetVertexColor(color[1], color[2], color[3], color[4])
    border.right:SetVertexColor(color[1], color[2], color[3], color[4])
    border:Show()
  else
    border:Hide()
  end
end

local function ApplyVisual(env)
  ApplyButtonVisual(env, env and env.MerfinAuctionHouseHelper)
end

function Merfin.SetItemTooltip(tooltip, item)
  if not tooltip or not item then
    return false
  end

  if tooltip.SetItemByID and tooltip.SetItemByID ~= Merfin.GameTooltipSetItemByID then
    tooltip:SetItemByID(item)
    return true
  end

  local itemID = tonumber(item)
  local itemLink

  if itemID and GetItemInfo then
    _, itemLink = GetItemInfo(itemID)
  elseif type(item) == "string" then
    itemLink = item
  end

  if tooltip.SetHyperlink then
    if itemLink then
      tooltip:SetHyperlink(itemLink)
      return true
    end

    if itemID then
      tooltip:SetHyperlink("item:" .. tostring(itemID))
      return true
    end
  end

  return false
end

Merfin.GameTooltipSetItemByID = function(self, item)
  return Merfin.SetItemTooltip(self, item)
end

if GameTooltip and not GameTooltip.SetItemByID then
  GameTooltip.SetItemByID = Merfin.GameTooltipSetItemByID
end

local function IsAuctionatorLoaded()
  return IsAddOnLoaded and IsAddOnLoaded("Auctionator") and true or false
end

local function IsAuctionOpen()
  return AuctionFrame and AuctionFrame.IsShown and AuctionFrame:IsShown()
end

local function GetAuctionatorSearchBox()
  return _G.Atr_Search_Box
end

local function GetAuctionatorSearchButton()
  return _G.Atr_Search_Button
end

local function GetAuctionatorTab()
  for i = 1, 8 do
    local tab = _G["AuctionFrameTab" .. i]
    local text = tab and tab.GetText and tab:GetText()

    if type(text) == "string" and string.find(text, "Auctionator") then
      return tab
    end
  end

  return _G.AuctionatorTab or _G.Atr_Buy_Tab
end

local function OpenAuctionatorTab()
  if Atr_SelectPane then
    Atr_SelectPane(3)
    return true
  end

  local tab = GetAuctionatorTab()
  if tab and tab.Click then
    tab:Click()
    return true
  end

  return false
end

local function SetButtonEnabled(button, enabled)
  if not button then
    return
  end

  if enabled and button.Enable then
    button:Enable()
  elseif not enabled and button.Disable then
    button:Disable()
  end
end

local function PressAuctionatorSearch(searchBox)
  local currentPane = Atr_GetCurrentPane and Atr_GetCurrentPane()
  if not currentPane or not currentPane.DoSearch then
    return false
  end

  local searchText = searchBox and searchBox.GetText and searchBox:GetText()
  if not searchText or searchText == "" then
    return false
  end

  SetButtonEnabled(_G.Atr_Search_Button, false)
  SetButtonEnabled(_G.Atr_Adv_Search_Button, false)
  SetButtonEnabled(_G.Atr_Buy1_Button, false)
  SetButtonEnabled(_G.Atr_AddToSListButton, false)
  SetButtonEnabled(_G.Atr_RemFromSListButton, false)

  if Atr_ClearAll then
    Atr_ClearAll()
  end

  currentPane:DoSearch(searchText)

  if Atr_Process_Historydata then
    Atr_Process_Historydata()
  end

  return true
end

local function SearchAuctionator(itemName)
  if not IsAuctionatorLoaded() then
    AddMessage("Auctionator is not loaded.")
    return false
  end

  if not IsAuctionOpen() then
    return false
  end

  OpenAuctionatorTab()

  WeakAuras.timer:ScheduleTimer(function()
    local searchBox = GetAuctionatorSearchBox()
    if not searchBox then
      AddMessage("Auctionator search box not found.")
      return
    end

    if searchBox.SetFocus then
      searchBox:SetFocus()
    end

    if searchBox.SetText then
      searchBox:SetText("")
      searchBox:SetText(itemName)
    end

    if searchBox.HighlightText then
      searchBox:HighlightText(0, -1)
    end

    if not PressAuctionatorSearch(searchBox) then
      AddMessage("Auctionator search trigger not found.")
    end
  end, 0.05)

  return true
end

local function GetItemNameAndLink(item, fallbackName)
  if not item then
    return fallbackName, nil
  end

  local itemID = tonumber(item)

  if itemID then
    local name, link = GetItemInfo(itemID)
    return name or fallbackName, link
  end

  if type(item) == "string" then
    local name, link = GetItemInfo(item)
    return name or fallbackName or item, link
  end

  return fallbackName, nil
end

local function SearchAuctionItem(item, fallbackName)
  if not IsAuctionOpen() then
    return false
  end

  local itemName = GetItemNameAndLink(item, fallbackName)

  if not itemName then
    AddMessage("Item info is not loaded yet.")
    return false
  end

  return SearchAuctionator(itemName)
end

local function SearchItem(env)
  local state = env and env.MerfinAuctionHouseHelper
  if not state then
    return false
  end

  return SearchAuctionItem(state.itemID, state.itemName)
end

local function GetButton(env)
  local state = env and env.MerfinAuctionHouseHelper
  local region = env and env.region
  if not state or not region then
    return nil
  end

  if state.button then
    return state.button
  end

  local button = CreateFrame("Button", nil, region)
  state.button = button

  button:RegisterForClicks("LeftButtonUp")
  button:EnableMouse(true)

  button:SetScript("OnClick", function()
    SearchItem(env)
  end)

  button:SetScript("OnEnter", function(self)
    state.hover = true
    ApplyVisual(env)

    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")

    Merfin.SetItemTooltip(GameTooltip, state.itemID)
    GameTooltip:Show()
  end)

  button:SetScript("OnLeave", function()
    state.hover = false
    state.pressed = false
    ApplyVisual(env)
    GameTooltip:Hide()
  end)

  button:SetScript("OnMouseDown", function()
    state.pressed = true
    ApplyVisual(env)
  end)

  button:SetScript("OnMouseUp", function()
    state.pressed = false
    ApplyVisual(env)
  end)

  return button
end

function Merfin.AuctionHouseHelperInit(env, options)
  if type(env) ~= "table" then
    return
  end

  if type(options) == "number" then
    options = { itemID = options }
  elseif type(options) ~= "table" then
    options = {}
  end

  local state = env.MerfinAuctionHouseHelper or {}
  env.MerfinAuctionHouseHelper = state

  state.itemID = options.itemID or options.itemId or env.itemID or env.itemId
  state.itemName = options.itemName or env.itemName
  state.hover = false
  state.pressed = false
  state.borderColor = CopyColor(options.borderColor, DEFAULT_BUTTON_OPTIONS.borderColor)
  state.pressedBorderColor = CopyColor(options.pressedBorderColor, DEFAULT_BUTTON_OPTIONS.pressedBorderColor)
  state.borderSize = options.borderSize or DEFAULT_BUTTON_OPTIONS.borderSize

  if not state.itemID then
    AddMessage("Merfin AuctionHouseHelper: itemID is missing.")
  end

  ApplyVisual(env)
end

function Merfin.AuctionHouseHelperShow(env)
  local state = env and env.MerfinAuctionHouseHelper
  local region = env and env.region
  local button = GetButton(env)

  if not state or not region or not button then
    return
  end

  button:SetParent(region)
  button:ClearAllPoints()
  button:SetAllPoints(region)

  if region.GetFrameStrata then
    button:SetFrameStrata(region:GetFrameStrata())
  end

  if region.GetFrameLevel then
    button:SetFrameLevel(region:GetFrameLevel() + 10)
  end

  button:Show()
  ApplyVisual(env)
end

function Merfin.AuctionHouseHelperHide(env)
  local state = env and env.MerfinAuctionHouseHelper
  if not state then
    return
  end

  if state.button then
    state.button:Hide()
    state.button:ClearAllPoints()
  end

  state.hover = false
  state.pressed = false
  ApplyVisual(env)
  GameTooltip:Hide()
end

AH.IsAuctionOpen = IsAuctionOpen
AH.HasSupportedAddon = IsAuctionatorLoaded
AH.SearchItem = SearchAuctionItem
AH.SetItemTooltip = Merfin.SetItemTooltip

Merfin.SearchAuctionItem = function(item, fallbackName)
  return SearchAuctionItem(item, fallbackName)
end

function AH.Attach(env, options)
  if type(env) ~= "table" or env.MerfinAuctionHelperAttached then
    return
  end

  env.MerfinAuctionHelperAttached = true

  if type(options) ~= "table" then
    options = {}
  end

  local itemID = options.itemID or options.itemId or env.itemID or env.itemId
  local itemName = options.itemName or env.itemName
  local oldHasSupportedAddon = env.HasSupportedAddon
  local oldSearchItem = env.SearchItem

  env.IsAuctionOpen = IsAuctionOpen

  env.HasSupportedAddon = function()
    if IsAuctionatorLoaded() then
      return true
    end

    if oldHasSupportedAddon then
      return oldHasSupportedAddon()
    end

    return false
  end

  env.SearchItem = function()
    if SearchAuctionItem(itemID, itemName) then
      return true
    end

    if oldSearchItem then
      return oldSearchItem()
    end

    return false
  end

  if not itemID then
    return
  end

  Merfin.AuctionHouseHelperInit(env, {
    itemID = itemID,
    itemName = itemName,
    borderColor = options.borderColor,
    pressedBorderColor = options.pressedBorderColor,
    borderSize = options.borderSize,
  })

  env.ShowButton = function()
    Merfin.AuctionHouseHelperShow(env)
  end

  env.HideButton = function()
    Merfin.AuctionHouseHelperHide(env)
  end

  env.ShowButton()
end

function Merfin.AuctionHouseHelperToggleSection(sectionType)
  WeakAuras.ScanEvents("AUC_SECTION_TOGGLE", sectionType)
end

local function ApplySectionToggleVisual(env)
  ApplyButtonVisual(env, env and env.MerfinAuctionHouseHelperSectionToggle)
end

local function GetSectionToggleButton(env)
  local state = env and env.MerfinAuctionHouseHelperSectionToggle
  local region = env and env.region
  if not state or not region then
    return nil
  end

  if state.button then
    return state.button
  end

  local button = CreateFrame("Button", nil, region)
  state.button = button

  button:RegisterForClicks("LeftButtonUp")
  button:EnableMouse(true)

  button:SetScript("OnClick", function()
    Merfin.AuctionHouseHelperToggleSection(state.sectionType)
  end)

  button:SetScript("OnEnter", function()
    state.hover = true
    ApplySectionToggleVisual(env)
  end)

  button:SetScript("OnLeave", function()
    state.hover = false
    state.pressed = false
    ApplySectionToggleVisual(env)
  end)

  button:SetScript("OnMouseDown", function()
    state.pressed = true
    ApplySectionToggleVisual(env)
  end)

  button:SetScript("OnMouseUp", function()
    state.pressed = false
    ApplySectionToggleVisual(env)
  end)

  return button
end

function Merfin.AuctionHouseHelperInitSectionToggle(env, options)
  if type(env) ~= "table" then
    return
  end

  if type(options) == "string" then
    options = { sectionType = options }
  elseif type(options) ~= "table" then
    options = {}
  end

  local state = env.MerfinAuctionHouseHelperSectionToggle or {}
  env.MerfinAuctionHouseHelperSectionToggle = state

  state.sectionType = options.sectionType or env.sectionType
  state.hover = false
  state.pressed = false
  state.borderColor = CopyColor(options.borderColor, DEFAULT_BUTTON_OPTIONS.borderColor)
  state.pressedBorderColor = CopyColor(options.pressedBorderColor, DEFAULT_BUTTON_OPTIONS.pressedBorderColor)
  state.borderSize = options.borderSize or DEFAULT_BUTTON_OPTIONS.borderSize

  ApplySectionToggleVisual(env)
end

function Merfin.AuctionHouseHelperShowSectionToggle(env)
  local state = env and env.MerfinAuctionHouseHelperSectionToggle
  local region = env and env.region
  local button = GetSectionToggleButton(env)

  if not state or not region or not button then
    return
  end

  button:SetParent(region)
  button:ClearAllPoints()
  button:SetAllPoints(region)

  if region.GetFrameStrata then
    button:SetFrameStrata(region:GetFrameStrata())
  end

  if region.GetFrameLevel then
    button:SetFrameLevel(region:GetFrameLevel() + 10)
  end

  button:Show()
  ApplySectionToggleVisual(env)
end

function Merfin.AuctionHouseHelperHideSectionToggle(env)
  local state = env and env.MerfinAuctionHouseHelperSectionToggle
  if not state then
    return
  end

  if state.button then
    state.button:Hide()
    state.button:ClearAllPoints()
  end

  state.hover = false
  state.pressed = false
  ApplySectionToggleVisual(env)
end

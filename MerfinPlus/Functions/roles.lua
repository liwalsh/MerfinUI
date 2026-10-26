Merfin.GetMyRole = function()
  return Merfin.myRole or "UNKNOWN"
end

local SendRoleInfo = function(newRole)
  WeakAuras.ScanEvents("WA_MERFIN_BACKEND", "ROLE_CHANGE", newRole)
end

local SaveRoleInfo = function(newRole)
  Merfin.myRole = newRole
end

local function CheckUnitRole(unitID)
  local roleName = Merfin.libGT ~= nil and Merfin.libGT:GetUnitRole(unitID)
  return roleName or UNKNOWNOBJECT
end

local function OnRoleChange(unitId, newRole)
  if UnitIsUnit(unitId, "player") then
    local myRole = CheckUnitRole("player")

    SaveRoleInfo(myRole)
    SendRoleInfo(myRole)
  end
end

local function LibGroupTalents_Init()
  Merfin.libGT = LibStub:GetLibrary("LibGroupTalents-1.0", true)

  if not Merfin.libGT then
    local loaded, reason = LoadAddOn("LibGroupTalents-1.0")
    Merfin.libGT = LibStub:GetLibrary("LibGroupTalents-1.0", true)
  end

  if Merfin.libGT then
    function Merfin:LibGroupTalents_RoleChange(e, guid, unitID, newRole, oldRole)
      WeakAuras.timer:ScheduleTimer(OnRoleChange, 0.5, unitID, newRole)
    end

    Merfin.libGT.RegisterCallback(Merfin, "LibGroupTalents_RoleChange")

    return true
  else
    DEFAULT_CHAT_FRAME:AddMessage(
      "[Merfin Core]: Couldn't find LibGroupTalents-1.0. Download the lib to display talent required cooldowns."
    )
  end
end

LibGroupTalents_Init()

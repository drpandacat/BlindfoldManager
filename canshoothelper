--[[
    Can Shoot Helper by Kerkel
    Version 1.0
]]

local VERSION = 1

if CanShootHelper then
    if CanShootHelper.Internal.VERSION > VERSION then
        return
    end
    for _, v in ipairs(CanShootHelper.Internal.CallbackEntries) do
        CanShootHelper:RemoveCallback(v.ID, v.Fn)
    end
end

CanShootHelper = RegisterMod("Can Shoot Helper", 1)
CanShootHelper.Internal = {}
CanShootHelper.Internal.VERSION = VERSION
CanShootHelper.Internal.CallbackEntries = {}

---@param ID ModCallbacks
---@param fn function
---@param filter any
---@param priority? CallbackPriority
function CanShootHelper.Internal:AddCallback(ID, fn, filter, priority)
    CanShootHelper.Internal.CallbackEntries[#CanShootHelper.Internal.CallbackEntries + 1] = {
        ID = ID,
        Fn = fn,
        Filter = filter,
        Priority = priority
    }
end

---@param entity Entity
function CanShootHelper.Internal:GetData(entity)
    local data = entity:GetData()

    data.___SHOOT_HELPER = data.___SHOOT_HELPER or {}

    return data.___SHOOT_HELPER
end

---@param player EntityPlayer
---@param disable boolean
---@param identfier string
function CanShootHelper:Set(player, disable, identfier)
    local data = CanShootHelper.Internal:GetData(player)

    data.ShootTracker = data.ShootTracker or {}
    data.ShootTracker[identfier] = disable

    if not disable then
        for _, v in pairs(data.ShootTracker) do
            if v then
                return
            end
        end

        player:UpdateCanShoot()
    end
end

---@param player EntityPlayer
CanShootHelper.Internal:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function (_, player)
    local data = CanShootHelper.Internal:GetData(player)

    if not data.ShootTracker then
        return
    end

    for _, v in pairs(data.ShootTracker) do
        if v then
            player:SetCanShoot(false)
            return
        end
    end
end, nil, CallbackPriority.LATE)

for _, v in ipairs(CanShootHelper.Internal.CallbackEntries) do
    if v.Priority then
        CanShootHelper:AddPriorityCallback(v.ID, v.Priority, v.Fn, v.Filter)
    else
        CanShootHelper:AddCallback(v.ID, v.Fn, v.FIlter)
    end
end

--[[
    CanShoot Helper by Kerkel
    Version 1.0
]]

local VERSION = 1

if CanShootHelper then
    if CanShootHelper.Internal.VERSION > VERSION then return end
    for _, v in ipairs(CanShootHelper.Internal.CallbackEntries) do
        CanShootHelper:RemoveCallback(v[1], v[3])
    end
end

CanShootHelper = RegisterMod("CanShoot Helper", 1)
CanShootHelper.Internal = {}
CanShootHelper.Internal.VERSION = VERSION
CanShootHelper.Internal.CallbackEntries = {
    {
        ModCallbacks.MC_POST_PLAYER_UPDATE,
        CallbackPriority.LATE,
        ---@param player EntityPlayer
        function (_, player)
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
        end,
        0
    }
}

for _, v in ipairs(CanShootHelper.Internal.CallbackEntries) do
    CanShootHelper:AddPriorityCallback(v[1], v[2], v[3], v[4])
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

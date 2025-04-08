--[[
    Blindfold Manager by Kerkel
    Version 1.0
]]

local VERSION = 1

if BlindfoldManager then
    if BlindfoldManager.Internal.VERSION > VERSION then return end
    for _, v in ipairs(BlindfoldManager.Internal.CallbackEntries) do
        BlindfoldManager:RemoveCallback(v[1], v[3])
    end
end

BlindfoldManager = RegisterMod("Blindfold Manager", 1)
BlindfoldManager.Internal = {}
BlindfoldManager.Internal.VERSION = VERSION
BlindfoldManager.Internal.CallbackEntries = {
    {
        ModCallbacks.MC_POST_PLAYER_UPDATE,
        CallbackPriority.LATE,
        ---@param player EntityPlayer
        function (_, player)
            local data = player:GetData() if not data.__BLINDFOLD_MANAGER then return end

            for _, v in pairs(data.__BLINDFOLD_MANAGER) do
                if v then
                    player:SetCanShoot(false)
                    return
                end
            end
        end
    }
}

for _, v in ipairs(BlindfoldManager.Internal.CallbackEntries) do
    BlindfoldManager:AddPriorityCallback(v[1], v[2], v[3], v[4])
end

---@param player EntityPlayer
---@param canShoot boolean
---@param identifier string
function BlindfoldManager:SetCanShoot(player, canShoot, identifier)
    local data = BlindfoldManager.Internal:GetData(player)

    data.__BLINDFOLD_MANAGER = data.__BLINDFOLD_MANAGER or {}
    data.__BLINDFOLD_MANAGER[identifier] = canShoot

    if not canShoot then return end

    for _, v in pairs(data.__BLINDFOLD_MANAGER) do
        if v then
            return
        end
    end

    data.__BLINDFOLD_MANAGER = nil
    player:UpdateCanShoot()
end

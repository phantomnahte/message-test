local DataStoreService = game:GetService("DataStoreService")
local ServerScriptService = game:GetService("ServerScriptService")

local Permission = require(ServerScriptService.Server:WaitForChild('Permission'))

local DataManager = {
    clients = {}
}

DataManager.DataStore = DataStoreService:GetDataStore('PlayerData')
DataManager.PermissionStore = DataStoreService:GetDataStore('PermissionStore')

function DataManager:setPermission(player_id, perm_id)
    self.PermissionStore:SetAsync(player_id, perm_id)
end

function DataManager:getPermission(player_id)
    return self.PermissionStore:GetAsync(player_id)
end

function DataManager:initPlayerData(player: Player)
    if not self.DataStore:GetAsync(player.UserID) then
        self.DataStore:SetAsync(player.UserID, {
            _id = player.UserID,
            balance = 0,
            inventory = { }
        })
        return self:getPlayerData(player.UserID)
    end
end

function DataManager:getPlayerData(player_id: string)
    return self.DataStore:GetAsync(player_id)
end

function DataManager:formatBalance(bal)
    return '$' .. ('%.2f'):format(bal)
end

return DataManager

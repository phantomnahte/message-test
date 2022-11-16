print('Starting server')

local ServerScriptService = game:GetService("ServerScriptService")
local HttpService = game:GetService('HttpService')
local Workspace = game:GetService("Workspace")
local ServerClient = require(ServerScriptService.Server:WaitForChild('ServerClient'))
local DataManager = require(ServerScriptService.Server:WaitForChild('DataManager'))
local Permission = require(ServerScriptService.Server:WaitForChild('Permission'))
local ChatCommands = require(ServerScriptService.Server:WaitForChild('ChatCommands'))
local ReplicatedStorage = game:GetService('ReplicatedStorage')

local startEvent = Instance.new('RemoteEvent', ReplicatedStorage)
startEvent.Name = 'startEvent'
startEvent.OnServerEvent:Connect(function(player)
    if not player.Character then
        player:LoadCharacter()
    end
end)

local clientEvent = Instance.new('RemoteEvent', ReplicatedStorage)
clientEvent.Name = 'clientEvent'
clientEvent.OnServerEvent:Connect(function(player, msgs)
    pcall(function()
        local hasPlayer = false
        local client

        for _,cl in DataManager.clients do
            if cl.player then
                if player.UserId == cl.player.UserId then
                    hasPlayer = true
                    client = cl
                end
            end
        end

        if not hasPlayer then
            client = ServerClient:new(nil, player, clientEvent)
            table.insert(DataManager.clients, client)
        end

        client.player = player

        for _,msg in pairs(msgs) do
            client:emit(msg.m, msg)
        end
    end)
end)

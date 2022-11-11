local ServerScriptService = game:GetService("ServerScriptService")
-- print("Hello world, from server!")

local spawnCharacterEvent = Instance.new('RemoteEvent', game:WaitForChild('ReplicatedStorage'))
spawnCharacterEvent.Name = 'spawnCharacterEvent'
spawnCharacterEvent.OnServerEvent:Connect(function(player)
    if not player.Character then
        player:LoadCharacter()

        player.CharacterAdded:Connect(function (char)
            local hum = char:WaitForChild('Humanoid')
            hum.Died:Connect(function()
                print("server: dead character")
                hum:Destroy()
            end)
        end)
    end
end)

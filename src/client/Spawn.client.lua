local Players = game:WaitForChild('Players')
local SpawnAnimation = require(game.ReplicatedStorage.Common:WaitForChild('SpawnAnimation'))

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(c)
        local hum = c:WaitForChild("Humanoid")
        SpawnAnimation(hum)
        hum:emit('startAnimation')
    end)
end)
return function(hum: Humanoid)
    local EventEmitter = require(game.ReplicatedStorage.Common.EventEmitter)
    hum = EventEmitter:new(hum)
    
    hum:on('startAnimation', function()
        Instance.new('Part', hum)
    end)
end

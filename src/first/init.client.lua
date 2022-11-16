print('Starting client')

-- local ClientEventReplicator = require(game.ReplicatedStorage.Common:WaitForChild('ClientEventReplicator'))
local ClientEventReplicator = require(game:GetService('ReplicatedFirst').load:WaitForChild('ClientEventReplicator'))

local client = ClientEventReplicator:new()
-- client:sendArray({{ m = 'hi' }})

-- local spinny = game.Workspace:WaitForChild('SpinnyThing')

-- print('i have spinny')

-- client:on('spinny', function(msg)
--     print('setting cframe')
--     spinny.CFrame = msg.cframe
-- end)

local ReplicatedFirst = game:GetService('ReplicatedFirst')

local Interface = require(ReplicatedFirst.load:WaitForChild('Interface'))
Interface:load(client)

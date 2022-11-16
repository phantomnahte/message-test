local EventEmitter = require(game:GetService('ReplicatedStorage'):WaitForChild('Common'):WaitForChild('EventEmitter'))
local clientEvent: RemoteEvent = game.ReplicatedStorage:WaitForChild('clientEvent')

local ClientEventReplicator = EventEmitter:new()
ClientEventReplicator.__index = ClientEventReplicator

function ClientEventReplicator:new(o)
    o = o or {}
    setmetatable(o, self)

    self:on('hi', function(msg)
        -- print('received hi from server')

        if self.desiredChannelId then
            self:setChannel()
        end
    end)

    self:on('a', function(msg)
        if not msg.p then
            msg.p = {
                name = 'System',
                color = '#ffffff'
            }
        end
        game.StarterGui:SetCore( "ChatMakeSystemMessage",  { Text = "[" .. msg.p.name .. "]: " .. msg.a, Color = Color3.fromHex(msg.p.color), Font = Enum.Font.SourceSansBold, FontSize = Enum.FontSize.Size18 } )
        -- self:emit('notification', { m = 'notification', title = msg.p.name, text = msg.a })
    end)

    self:on('notification', function(msg)
        game.StarterGui:SetCore( "SendNotification",  { Title = msg.title, Text = msg.text } )
    end)

    clientEvent.OnClientEvent:Connect(function(msgs)
        pcall(function()
            for _,msg in pairs(msgs) do
                self:emit(msg.m, msg)
            end
        end)
    end)

    return o
end

function ClientEventReplicator:sendArray(msgs)
    pcall(function()
        clientEvent:FireServer(msgs)
    end)
end

function ClientEventReplicator:setChannel(channel: string, set: table)
    self.desiredChannelId = channel or self.desiredChannelId or "lobby"
    self.desiredChannelSettings = set or self.desiredChannelSettings or nil
    self:sendArray({{m = 'ch', _id = self.desiredChannelId, set = self.desiredChannelSettings }})
end

function ClientEventReplicator:sendChat(text: string)
    self:sendArray({{
        m = 'a',
        message = text
    }})
end

return ClientEventReplicator

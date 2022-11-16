local EventEmitter = require(game:GetService('ReplicatedStorage').Common:WaitForChild('EventEmitter'))
local ChatCommands = require(game:GetService('ServerScriptService').Server:WaitForChild('ChatCommands'))

local ServerClient = EventEmitter:new()
ServerClient.__index = ServerClient

function ServerClient:new(o, player, revt: RemoteEvent)
    o = o or {}
    setmetatable(o, self)
    self.player = player
    self._event = revt

    self:on('hi', function(msg)
        -- print("received hi from client " .. self.player.Name .. ", sending hi back")
        self:sendArray({{ m = 'hi' }})
        self:sendChat("Use " .. ChatCommands.prefixes[1] .."help to view commands");
    end)

    return o
end

function ServerClient:sendArray(msgs)
    pcall(function()
        self._event:FireClient(self.player, msgs)
    end)
end

function ServerClient:sendChat(msg)
    self:sendArray({{
        m = 'a',
        a = utf8.char(0x034f) .. msg
    }})
end

return ServerClient

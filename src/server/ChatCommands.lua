local ServerScriptService = game:GetService("ServerScriptService")
local DataManager = require(ServerScriptService.Server:WaitForChild('DataManager'))
local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')

-- stolen code from roblox chat module
local NAME_COLORS = {
    Color3.new(253/255, 41/255, 67/255), -- BrickColor.new("Bright red").Color,
    Color3.new(1/255, 162/255, 255/255), -- BrickColor.new("Bright blue").Color,
    Color3.new(2/255, 184/255, 87/255), -- BrickColor.new("Earth green").Color,
    BrickColor.new("Bright violet").Color,
    BrickColor.new("Bright orange").Color,
    BrickColor.new("Bright yellow").Color,
    BrickColor.new("Light reddish violet").Color,
    BrickColor.new("Brick yellow").Color,
}

local function GetNameValue(pName)
    local value = 0
    for index = 1, #pName do
        local cValue = string.byte(string.sub(pName, index, index))
        local reverseIndex = #pName - index + 1
        if #pName%2 == 1 then
            reverseIndex = reverseIndex - 1
        end
        if reverseIndex%4 >= 2 then
            cValue = -cValue
        end
        value = value + cValue
    end
    return value
end

local color_offset = 0
local function ComputeNameColor(pName)
    return NAME_COLORS[((GetNameValue(pName) + color_offset) % #NAME_COLORS) + 1]
end
-- end stolen code

local DefaultChatSystemChatEvents = ReplicatedStorage:WaitForChild('DefaultChatSystemChatEvents')

local ChatCommands = {
    commands = {},
    prefixes = {}
}

DefaultChatSystemChatEvents.SayMessageRequest.OnServerEvent:Connect(function(player, msg, channel)
    task.wait(0.001)
    ChatCommands:handleMessage(player, msg, channel)
end)

function ChatCommands:handleMessage(player: Player, message: string, channel)
    local hasPlayer = false
    local cl
    
    for _,c in pairs(DataManager.clients) do
        if c.player.UserId == player.UserId then
            hasPlayer = true
            cl = c
            break
        end
    end
    
    if not hasPlayer then
        return
    end
    
    local msg = {
        m = 'a',
        message = message,
        p = {
            _id = player.UserId,
            name = player.DisplayName,
            color = ComputeNameColor(player.DisplayName):ToHex()
        }
    }

    local hasPrefix = false

    for _,pref in pairs(ChatCommands.prefixes) do
        if msg.message:sub(1, pref:len()) == pref then
            hasPrefix = true
            msg.prefix = pref
        end
    end

    if not hasPrefix then
        return
    end

    msg.args = msg.message:split(' ')
    msg.argcat = msg.message:sub(msg.args[1]:len() + 1, -1)
    msg.cmd = msg.args[1]:sub(msg.prefix:len() + 1, -1)

    for _,cmd in pairs(self.commands) do
        local isCommand = false

        for _,a in cmd.accessors do
            if msg.cmd == a then
                isCommand = true
            end
        end
        
        if not isCommand then
            continue
        end

        -- msg.permission = DataManager:GetPermission(msg.p._id)

        if not pcall(function()
            local out = cmd.callback(msg, cl)
            if not out then
                return
            end
            ChatCommands:sendChat(out)
        end) then
            ChatCommands:sendChat('An error has occurred.')
        end
    end
end

function ChatCommands:sendChat(msg)
    for _,cl in DataManager.clients do
        cl:sendChat(msg)
    end
end

function ChatCommands:addCommand(cmd)
    table.insert(self.commands, cmd)
end

function ChatCommands:getUsage(str)
    return str
end

local Command = {}

function Command:new(id: string, accessors: table, usage: string, description: string, callback: (msg: table, cl: table) -> string, permissionGroups: table, visible: boolean)
    local o = {
        id = id,
        accessors = accessors or { id },
        usage = usage,
        description = description,
        callback = callback,
        visible = visible or false
    }

    setmetatable(o, self)
    self.__index = self

    return o
end

ChatCommands:addCommand(Command:new(
    'help',
    { 'help', 'h', 'cmds', 'cmd', 'cmnds', 'cmnd' },
    '%PREFIX%help [cmd]',
    'Get a list or description of commands.',
    function(msg, cl)
        if not msg.args[2] then
            local out: string = 'Commands:'
            for _,cmd in pairs(ChatCommands.commands) do
                if not cmd.visible then
                    continue
                end
                out = out .. (' %PREFIX%%COMMAND% | '):gsub('(%%PREFIX%%)', msg.prefix):gsub('(%%COMMAND%%)', cmd.accessors[1])
            end
            out = out:sub(1, out:len() - 2)
            return out
        else
            local c
            for _,cmd in pairs(ChatCommands.commands) do
                for _,a in pairs(cmd.accessors) do
                    if msg.args[2] == a then
                        c = cmd
                    end
                end
            end

            if not c then
                return "Command '" .. msg.args[2] .. "' not found."
            end

            local desc = c.description or 'No description.'
            local usage = 'No usage.'

            if c.usage then
                usage = c.usage:gsub('(%%PREFIX%%)', msg.prefix)
            end

            return "Description: " .. desc .. " | Usage: " .. usage
        end
    end,
    { 'default' },
    true
))

ChatCommands:addCommand(Command:new(
    'about',
    { 'about', 'a' },
    '%PREFIX%about',
    'What the heck is this!?',
    function(msg, cl)
        return "This experience is chat-only. It is a test of a chat command system that I programmed. I might use it in a future project."
    end,
    { 'default' },
    true
))

ChatCommands:addCommand(Command:new(
    '8ball',
    { '8ball', '8b', 'magic8ball' },
    '%PREFIX%8ball <polar question>',
    'Ask the magic 8 ball a question',
    function(msg, cl)
        if not msg.args[2] then
            return 'Ask a question.'
        end
        local answers = {
            "It is certain",
            "It is decidedly so",
            "Without a doubt",
            "Yes - definitely",
            "You may rely on it",
            "As I see it, yes",
            "Most likely",
            "Outlook good",
            "Yes",
            "Signs point to yes",
            
            "Reply hazy, try again",
            "Ask again later",
            "Better not tell you now",
            "Cannot predict now",
            "Concentrate and ask again",
            
            "Don't count on it",
            "My reply is no",
            "My sources say no",
            "Outlook not so good",
            "Very doubtful"
        }

        return answers[math.floor(math.random(1, #answers + 1))] .. ', ' .. msg.p.name .. '.'
    end,
    { 'default' },
    true
))

ChatCommands:addCommand(Command:new(
    'balance',
    { 'balance', 'bal' },
    '%PREFIX%balance',
    'Get your balance.',
    function(msg, cl)
        local balance = DataManager.getBalance(msg.p._id)
        return "Balance: " .. DataManager:formatBalance(balance)
    end,
    { 'default' },
    true
))

function ChatCommands:addPrefix(prefix)
    table.insert(self.prefixes, prefix)
end

ChatCommands:addPrefix('!')
ChatCommands:addPrefix('.')
ChatCommands:addPrefix('?')

return ChatCommands

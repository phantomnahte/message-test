local Roact = require(game.ReplicatedStorage.Common:WaitForChild("Roact"))
local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local StarterGui = game:GetService("StarterGui")
-- local Chat = game:GetService("Chat")
local EventEmitter = require(game:GetService('ReplicatedStorage'):WaitForChild('Common'):WaitForChild('EventEmitter'))

local Interface = EventEmitter:new()

function removeDefaultMessages()
    local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    --you may need to wait for any of the objects in the path
    local messages = PlayerGui.Chat.Frame.ChatChannelParentFrame.Frame_MessageLogDisplay.Scroller 

    --chat messages have a huge amount of spaces at the start(for some reason)
    local function removeSpaces(message)
        local result = message
        local length = message:len()
        for i = 1, length do
            if result:sub(1, 1) == " " then
                result = result:sub(2, length)
            else
                break
            end
        end
        return result
    end

    for i, message in pairs(messages:GetChildren()) do --loop through current messages
        if not message:IsA("Frame") then continue end
        if not message:FindFirstChild("TextLabel") then continue end

        local Button = message.TextLabel:FindFirstChild("TextButton")
        if Button then
            -- print("actual chat message")
            local text = Button.Text
            local username = text:sub(2, text:len()-2) --cut out "[" and "]:
            -- print("user:", username)
        else 
            -- print("Probably a system message")
        end 

        local messageText = removeSpaces(message.TextLabel.Text)
        -- print("the message:", messageText)

        --actually "delete" the message(it will be done client-side other users will still be able to see it)
        message:Destroy()
    end
end

local MainMenu = Roact.Component:extend("MainMenu")

local ReplicatedStorage = game:WaitForChild('ReplicatedStorage')
local startEvent: RemoteEvent = ReplicatedStorage:WaitForChild('startEvent')

local font = Font.fromName('Roboto', Enum.FontWeight.Regular, Enum.FontStyle.Normal)

function MainMenu:render()
    return Roact.createElement("ScreenGui", {
        Name = "Interface";
        IgnoreGuiInset = true;
    }, {
        Interface = Roact.createElement("Frame", {
            Size = UDim2.new(1, 0, 1, 0);
            Position = UDim2.new(0, 0, 0, 0);
            BackgroundColor3 = Color3.new(0x12 / 0xff, 0x12 / 0xff, 0x12 / 0xff);
        }, {
            StartButton = Roact.createElement("TextButton", {
                Name = "StartButton";
                Text = "Start";
                TextColor3 = Color3.new(0xff / 0xff, 0xff / 0xff, 0xff / 0xff);
                Size = UDim2.new(0, 450, 0, 35);
                BackgroundColor3 = Color3.new(0xff / 0xff, 0xff / 0xff, 0xff / 0xff);
                BackgroundTransparency = 0.8;
                AnchorPoint = Vector2.new(0.5, 0.5);
                Position = UDim2.new(0.5, 0, 0.5, 0);
                FontFace = font;
                TextSize = 20; -- pt
                TextStrokeColor3 = Color3.new(0xff / 0xff, 0xff / 0xff, 0xff / 0xff);
                -- Visible = false;

                [Roact.Event.MouseButton1Click] = function(rbx)
                    -- rbx.Parent.Parent.Enabled = false
                    rbx.Visible = false
                    startEvent:FireServer()
                    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
                    StarterGui:SetCore('ChatWindowSize', UDim2.new(1, 0, 1, 0))
                    removeDefaultMessages()

                    -- can't get text channels??? come on roblox...
                    -- local currentChannel = Chat.
                    -- if (currentChannel) then
                    --     currentChannel:ClearMessageLog()
                    -- end

                    Interface:emit('start_clicked')
                end
            })
        });
    })
end


function Interface:load(client)
    self:once('start_clicked', function()
        client:sendArray({{
            m = 'hi'
        }})
    end)

    local interface = Roact.createElement("ScreenGui", {
        Name = "TopMenu";
    }, {
        MainMenu = Roact.createElement(MainMenu, {
            name = "MainMenu";
        })
    })
    
    Roact.mount(interface, playerGui)
end

return Interface

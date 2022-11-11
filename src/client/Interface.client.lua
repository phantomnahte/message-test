local Roact = require(game.ReplicatedStorage.Common:WaitForChild("Roact"))
local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local MainMenu = Roact.Component:extend("MainMenu")

local ReplicatedStorage = game:WaitForChild('ReplicatedStorage')
local spawnEvent: RemoteEvent = ReplicatedStorage:WaitForChild('spawnCharacterEvent')

function MainMenu:render()
    return Roact.createElement("ScreenGui", {
        Name = "Interface";
        IgnoreGuiInset = true;
    }, {
        Interface = Roact.createElement("Frame", {
            Size = UDim2.new(1, 0, 1, 0);
            Position = UDim2.new(0, 0, 0, 0);
            BackgroundColor3 = Color3.new(0, 0, 0);
        }, {
            StartButton = Roact.createElement("TextButton", {
                Name = "StartButton";
                Text = "Start";
                TextColor3 = Color3.new(0xff, 0xff, 0xff);
                Size = UDim2.new(0, 450, 0, 35);
                BackgroundColor3 = Color3.new(0xff, 0xff, 0xff);
                BackgroundTransparency = 0.8;
                AnchorPoint = Vector2.new(0.5, 0.5);
                Position = UDim2.new(0.5, 0, 0.5, 0);

                [Roact.Event.MouseButton1Click] = function(rbx)
                    rbx.Parent.Parent.Enabled = false
                    spawnEvent:FireServer()
                end
            })
        });
    })
end

local interface = Roact.createElement("ScreenGui", {
    Name = "MainMenu";
}, {
    MainMenu = Roact.createElement(MainMenu, {
        name = "MainMenu";
    })
})

Roact.mount(interface, playerGui)

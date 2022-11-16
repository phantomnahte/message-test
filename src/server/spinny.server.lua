-- local part = Instance.new('Part', game:WaitForChild('Workspace'))
-- part.Name = 'SpinnyThing'
-- part.Anchored = true
-- part.Position = Vector3.new(0, 5, 0)
-- part.Color = Color3.new(1, 0, 0)

-- while true do
--     part.CFrame = part.CFrame * CFrame.Angles(0, math.rad(0.5), 0)

--     if _G.clients then
--         for _,cl in pairs(_G.clients) do
--             print('sending spinny to ' .. cl.player.Name)
--             cl.sendArray({{ m = "spinny", cframe = part.CFrame }})
--         end
--     end
--     task.wait(1 / 144)
-- end

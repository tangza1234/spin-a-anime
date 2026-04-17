-- [[ CONFIGURATION ]]
local slotsToStep = {1, 2, 3, 4, 5, 7, 8, 9}
local potionsToBuy = {
    "Greed", "Fairy", "Evil", "Bank", "Angelic", 
    "Clover", "Super Lucky", "Super Yen", "Mutation", "Lucky", "Yen"
}

_G.AutoFarm = false 
_G.AutoPotions = false -- สถานะเริ่มต้นการซื้อโพชั่น

-- [[ GUI CREATION ]]
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ToggleFarm = Instance.new("TextButton")
local TogglePotions = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "UltraFarmGui"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 180, 0, 130) 
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = UICorner:Clone()
MainCorner.Parent = MainFrame


ToggleFarm.Name = "ToggleFarm"
ToggleFarm.Parent = MainFrame
ToggleFarm.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleFarm.Position = UDim2.new(0.05, 0, 0.1, 0)
ToggleFarm.Size = UDim2.new(0.9, 0, 0.35, 0)
ToggleFarm.Font = Enum.Font.GothamBold
ToggleFarm.Text = "AUTO FARM: OFF"
ToggleFarm.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleFarm.TextSize = 14
local Corner1 = UICorner:Clone()
Corner1.Parent = ToggleFarm

-- ปุ่ม Auto Potions
TogglePotions.Name = "TogglePotions"
TogglePotions.Parent = MainFrame
TogglePotions.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
TogglePotions.Position = UDim2.new(0.05, 0, 0.55, 0)
TogglePotions.Size = UDim2.new(0.9, 0, 0.35, 0)
TogglePotions.Font = Enum.Font.GothamBold
TogglePotions.Text = "AUTO POTIONS: OFF"
TogglePotions.TextColor3 = Color3.fromRGB(255, 255, 255)
TogglePotions.TextSize = 14
local Corner2 = UICorner:Clone()
Corner2.Parent = TogglePotions

-- [[ FUNCTIONALITY ]]
ToggleFarm.MouseButton1Click:Connect(function()
    _G.AutoFarm = not _G.AutoFarm
    ToggleFarm.Text = _G.AutoFarm and "AUTO FARM: ON" or "AUTO FARM: OFF"
    ToggleFarm.BackgroundColor3 = _G.AutoFarm and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
end)

TogglePotions.MouseButton1Click:Connect(function()
    _G.AutoPotions = not _G.AutoPotions
    TogglePotions.Text = _G.AutoPotions and "AUTO POTIONS: ON" or "AUTO POTIONS: OFF"
    TogglePotions.BackgroundColor3 = _G.AutoPotions and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
end)

-- [[ LOOP LOGIC: AUTO STEP ]]
task.spawn(function()
    while true do
        if _G.AutoFarm then
            local lp = game.Players.LocalPlayer
            local plots = game:GetService("Workspace"):FindFirstChild("Plots")
            local myPlot = plots and plots:FindFirstChild("Plot1")
            
            if myPlot and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                for _, slotNumber in ipairs(slotsToStep) do
                    if not _G.AutoFarm then break end
                    local slotFolder = myPlot.Slots:FindFirstChild(tostring(slotNumber))
                    if slotFolder and slotFolder:FindFirstChild("Button") then
                        firetouchinterest(lp.Character.HumanoidRootPart, slotFolder.Button, 0)
                        task.wait(0.05)
                        firetouchinterest(lp.Character.HumanoidRootPart, slotFolder.Button, 1)
                    end
                end
            end
        end
        task.wait(0.5)
    end
end)

-- [[ LOOP LOGIC: AUTO BUY POTIONS ]]
task.spawn(function()
    local potionRemote = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Potion"):WaitForChild("purchase")
    while true do
        if _G.AutoPotions then
            for _, potionName in ipairs(potionsToBuy) do
                if not _G.AutoPotions then break end
                potionRemote:FireServer(potionName, 10)
                task.wait(0.1) 
            end
        end
        task.wait(5) 
    end
end)

-- [[ ANTI-AFK ]]
local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

print("Full Script Loaded: Auto Step + Auto Potion + Anti-AFK")

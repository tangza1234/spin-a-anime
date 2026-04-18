-- ================================================
-- 🌀 Spin a Anime - [V3.9 PLOT NAME FIX]
-- ================================================

local lp = game.Players.LocalPlayer

-- SETTINGS
local slotsToStep = {1,2,3,4,5,6,7,8,9,10,11,12}

local cratesToBuy = {
    "Royal",
    "Samurai",
    "Magma",
    "Manga",
    "Construction",
    "Red Moon",
    "Celestial",
    "Haunted",
    "Abandoned",
    "Ghost",
    "Vortex"
}

local potionsToBuy = {
    "Greed","Fairy","Evil","Bank","Angelic",
    "Clover","Super Lucky","Super Yen",
    "Mutation","Lucky","Yen","Rich"
}

_G.AutoFarm = false
_G.AutoPotions = false
_G.AutoCrates = false

-- ================================================
-- 📍 FIND PLOT (BY DISTANCE)
-- ================================================

local function getMyPlot()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end

    local closestPlot = nil
    local shortestDist = math.huge

    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        local myPos = lp.Character.HumanoidRootPart.Position

        for _, plot in ipairs(plots:GetChildren()) do
            local plotPos

            if plot:IsA("Model") then
                plotPos = plot:GetModelCFrame().Position
            elseif plot:IsA("BasePart") then
                plotPos = plot.Position
            end

            if plotPos then
                local dist = (plotPos - myPos).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    closestPlot = plot
                end
            end
        end
    end

    return closestPlot
end

-- ================================================
-- 🎨 GUI
-- ================================================

local ScreenGui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
ScreenGui.Name = "SpinAnimeV3_9"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,35)
MainFrame.Position = UDim2.new(0.05,0,0.4,0)
MainFrame.Size = UDim2.new(0,190,0,215)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,10)

local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Size = UDim2.new(1,0,0,32)
TitleBar.BackgroundColor3 = Color3.fromRGB(140,80,255)

local TitleLabel = Instance.new("TextLabel", TitleBar)
TitleLabel.Size = UDim2.new(1,0,1,0)
TitleLabel.Text = "🌀 Spin a Anime v3.9"
TitleLabel.TextColor3 = Color3.new(1,1,1)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.BackgroundTransparency = 1

local function createButton(name, text, yPos)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Name = name
    btn.BackgroundColor3 = Color3.fromRGB(200,50,50)
    btn.Position = UDim2.new(0.05,0,0,yPos)
    btn.Size = UDim2.new(0.9,0,0,42)
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
    return btn
end

local ToggleFarm     = createButton("ToggleFarm", "⚡ FARM: OFF", 45)
local TogglePotions  = createButton("TogglePotions", "🧪 POTIONS: OFF", 98)
local ToggleCrates   = createButton("ToggleCrates", "🎁 CRATES: OFF", 151)

-- ================================================
-- ⚡ AUTO FARM
-- ================================================

task.spawn(function()
    while true do
        if _G.AutoFarm then
            local myPlot = getMyPlot()

            if myPlot then
                local slots = myPlot:FindFirstChild("Slots")

                if slots then
                    for _, num in ipairs(slotsToStep) do
                        if not _G.AutoFarm then break end

                        local slotFolder = slots:FindFirstChild(tostring(num))
                        local button = slotFolder and slotFolder:FindFirstChild("Button")

                        if button then
                            pcall(function()
                                firetouchinterest(lp.Character.HumanoidRootPart, button, 0)
                                firetouchinterest(lp.Character.HumanoidRootPart, button, 1)
                            end)
                        end
                    end
                end
            end

            task.wait(600) -- 10 นาที
        else
            task.wait(0.2)
        end
    end
end)

-- ================================================
-- 🎁 AUTO CRATES
-- ================================================

task.spawn(function()
    local crateRemote = game:GetService("ReplicatedStorage")
        :WaitForChild("Events")
        :WaitForChild("Crate")
        :WaitForChild("purchase")

    while true do
        if _G.AutoCrates then
            for _, crateName in ipairs(cratesToBuy) do
                if not _G.AutoCrates then break end

                pcall(function()
                    crateRemote:FireServer(crateName, 10)
                end)

                task.wait(0.15)
            end
        end

        task.wait(0.2)
    end
end)

-- ================================================
-- 🧪 AUTO POTIONS
-- ================================================

task.spawn(function()
    local pr = game:GetService("ReplicatedStorage")
        :WaitForChild("Events")
        :WaitForChild("Potion")
        :WaitForChild("purchase")

    while true do
        if _G.AutoPotions then
            for _, p in ipairs(potionsToBuy) do
                if not _G.AutoPotions then break end

                pcall(function()
                    pr:FireServer(p, 10)
                end)

                task.wait(0.1)
            end
        end

        task.wait(5)
    end
end)

-- ================================================
-- 🖱️ BUTTONS
-- ================================================

ToggleFarm.MouseButton1Click:Connect(function()
    _G.AutoFarm = not _G.AutoFarm
    ToggleFarm.Text = _G.AutoFarm and "⚡ FARM: ON" or "⚡ FARM: OFF"
    ToggleFarm.BackgroundColor3 = _G.AutoFarm and Color3.fromRGB(50,200,50) or Color3.fromRGB(200,50,50)
end)

TogglePotions.MouseButton1Click:Connect(function()
    _G.AutoPotions = not _G.AutoPotions
    TogglePotions.Text = _G.AutoPotions and "🧪 POTIONS: ON" or "🧪 POTIONS: OFF"
    TogglePotions.BackgroundColor3 = _G.AutoPotions and Color3.fromRGB(50,200,50) or Color3.fromRGB(200,50,50)
end)

ToggleCrates.MouseButton1Click:Connect(function()
    _G.AutoCrates = not _G.AutoCrates
    ToggleCrates.Text = _G.AutoCrates and "🎁 CRATES: ON" or "🎁 CRATES: OFF"
    ToggleCrates.BackgroundColor3 = _G.AutoCrates and Color3.fromRGB(50,200,50) or Color3.fromRGB(200,50,50)
end)

-- ================================================
-- 💤 ANTI AFK
-- ================================================

local vu = game:GetService("VirtualUser")
lp.Idled:Connect(function()
    vu:CaptureController()
    vu:ClickButton2(Vector2.new())
end)

print("✅ v3.9 Hybrid (Plot Fix) Loaded!")

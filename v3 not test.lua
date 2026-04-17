-- ================================================
--   🌀 Spin a Anime - Fixed & Improved Version
--   แก้ไขโดย: Claude | github: tangza1234
--   เพิ่มระบบ: Auto Buy Crate (Royal)
-- ================================================

-- [[ CONFIGURATION ]]
local lp = game.Players.LocalPlayer
local slotsToStep = {1, 2, 3, 4, 5, 7, 8, 9, 10}
local potionsToBuy = {
    "Greed", "Fairy", "Evil", "Bank", "Angelic",
    "Clover", "Super Lucky", "Super Yen", "Mutation", "Lucky", "Yen"
}

_G.AutoFarm = false
_G.AutoPotions = false
_G.AutoCrates = false -- เพิ่มตัวแปรสำหรับเปิดกล่อง

-- [[ FUNCTION: AUTO DETECT MY PLOT ]]
local function getMyPlot()
    local plotsFolder = game:GetService("Workspace"):FindFirstChild("Plots")
    if not plotsFolder then return nil end

    local namedPlot = plotsFolder:FindFirstChild(lp.Name)
    if namedPlot then return namedPlot end

    local closestPlot = nil
    local shortestDist = math.huge

    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        for _, plot in ipairs(plotsFolder:GetChildren()) do
            local plotPos = nil
            if plot:IsA("Model") then
                plotPos = plot:GetModelCFrame().Position
            elseif plot:IsA("BasePart") then
                plotPos = plot.Position
            end

            if plotPos then
                local dist = (plotPos - lp.Character.HumanoidRootPart.Position).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    closestPlot = plot
                end
            end
        end
    end
    return closestPlot
end

-- [[ GUI CREATION ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpinAnimeGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = lp:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 190, 0, 215)  -- ✅ แก้: ขยายความสูงรองรับปุ่มที่ 3
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(140, 80, 255)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 32)
TitleBar.BackgroundColor3 = Color3.fromRGB(140, 80, 255)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0.5, 0)
TitleFix.Position = UDim2.new(0, 0, 0.5, 0)
TitleFix.BackgroundColor3 = Color3.fromRGB(140, 80, 255)
TitleFix.BorderSizePixel = 0
TitleFix.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🌀  Spin a Anime"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 14
TitleLabel.Parent = TitleBar

local function createButton(name, text, yPos)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Parent = MainFrame
    btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.Size = UDim2.new(0.9, 0, 0, 42)
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.BorderSizePixel = 0
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn
    return btn
end

local ToggleFarm     = createButton("ToggleFarm",     "⚡  AUTO FARM: OFF",    45)
local TogglePotions  = createButton("TogglePotions",  "🧪  AUTO POTIONS: OFF", 98)
local ToggleCrates   = createButton("ToggleCrates",   "🎁  AUTO CRATE: OFF",   151) -- ปุ่มใหม่

-- [[ FUNCTIONALITY ]]
ToggleFarm.MouseButton1Click:Connect(function()
    _G.AutoFarm = not _G.AutoFarm
    ToggleFarm.Text = _G.AutoFarm and "⚡  AUTO FARM: ON" or "⚡  AUTO FARM: OFF"
    ToggleFarm.BackgroundColor3 = _G.AutoFarm and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
end)

TogglePotions.MouseButton1Click:Connect(function()
    _G.AutoPotions = not _G.AutoPotions
    TogglePotions.Text = _G.AutoPotions and "🧪  AUTO POTIONS: ON" or "🧪  AUTO POTIONS: OFF"
    TogglePotions.BackgroundColor3 = _G.AutoPotions and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
end)

ToggleCrates.MouseButton1Click:Connect(function()
    _G.AutoCrates = not _G.AutoCrates
    ToggleCrates.Text = _G.AutoCrates and "🎁  AUTO CRATE: ON" or "🎁  AUTO CRATE: OFF"
    ToggleCrates.BackgroundColor3 = _G.AutoCrates and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
end)

-- [[ LOOP: AUTO STEP ]]
task.spawn(function()
    while true do
        if _G.AutoFarm then
            local myPlot = getMyPlot()
            if myPlot and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                local slotsFolder = myPlot:FindFirstChild("Slots")
                if slotsFolder then
                    for _, slotNumber in ipairs(slotsToStep) do
                        if not _G.AutoFarm then break end
                        local slotFolder = slotsFolder:FindFirstChild(tostring(slotNumber))
                        if slotFolder and slotFolder:FindFirstChild("Button") then
                            local button = slotFolder.Button
                            pcall(function()
                                firetouchinterest(lp.Character.HumanoidRootPart, button, 0)
                                task.wait(0.02) -- เร็วขึ้นนิดหน่อย
                                firetouchinterest(lp.Character.HumanoidRootPart, button, 1)
                            end)
                        end
                    end
                end
            end
        end
        task.wait(0.1) -- ลดดีเลย์จาก 0.5 เพื่อให้ฟาร์มไวขึ้น
    end
end)

-- [[ LOOP: AUTO BUY POTIONS ]]
task.spawn(function()
    local potionRemote
    pcall(function()
        potionRemote = game:GetService("ReplicatedStorage")
            :WaitForChild("Events", 10)
            :WaitForChild("Potion", 10)
            :WaitForChild("purchase", 10)
    end)

    while true do
        if _G.AutoPotions and potionRemote then
            for _, potionName in ipairs(potionsToBuy) do
                if not _G.AutoPotions then break end
                pcall(function()
                    potionRemote:FireServer(potionName, 10)
                end)
                task.wait(0.1)
            end
        end
        task.wait(5)
    end
end)

-- [[ LOOP: AUTO BUY CRATES (Royal) ]]
task.spawn(function()
    local crateRemote
    pcall(function()
        crateRemote = game:GetService("ReplicatedStorage")
            :WaitForChild("Events", 10)
            :WaitForChild("Crate", 10)
            :WaitForChild("purchase", 10)
    end)

    while true do
        if _G.AutoCrates and crateRemote then
            pcall(function()
                -- ซื้อกล่อง Royal ทีละ 10 กล่อง
                crateRemote:FireServer("Royal", 10)
            end)
            task.wait(0.3) -- หน่วงเวลาป้องกันเกมค้าง
        else
            task.wait(1)
        end
    end
end)

-- [[ ANTI-AFK ]]
local VirtualUser = game:GetService("VirtualUser")
lp.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

print("✅ Spin a Anime (Full v3 Hybrid) โหลดสำเร็จ!")

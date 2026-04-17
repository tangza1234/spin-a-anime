-- ================================================
--   🌀 Spin a Anime - [V3.7 ALL CRATES]
--   แก้ไขโดย: tangza1234
--   รายการกล่อง: Royal, Samurai, Magma, Manga, Construction
-- ================================================

-- [[ CONFIGURATION ]]
local lp = game.Players.LocalPlayer
local slotsToStep = {1, 2, 3, 4, 5, 7, 8, 9, 10}

-- รายชื่อกล่องทั้งหมดที่ต้องการซื้อ (วนซื้อทีละกล่อง)
local cratesToBuy = {"Royal", "Samurai", "Magma", "Manga", "Construction"} 

local potionsToBuy = {
    "Greed", "Fairy", "Evil", "Bank", "Angelic",
    "Clover", "Super Lucky", "Super Yen", "Mutation", "Lucky", "Yen"
}

_G.AutoFarm = false
_G.AutoPotions = false
_G.AutoCrates = false

-- [[ FUNCTION: AUTO DETECT MY PLOT ]]
local function getMyPlot()
    local plotsFolder = game:GetService("Workspace"):FindFirstChild("Plots")
    if not plotsFolder then return nil end
    return plotsFolder:FindFirstChild(lp.Name) or nil
end

-- [[ GUI CREATION ]]
local ScreenGui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
ScreenGui.Name = "SpinAnimeGuiV3_7"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 190, 0, 215)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Size = UDim2.new(1, 0, 0, 32)
TitleBar.BackgroundColor3 = Color3.fromRGB(140, 80, 255)
local TitleLabel = Instance.new("TextLabel", TitleBar)
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.Text = "🌀  Spin a Anime v3.7"
TitleLabel.TextColor3 = Color3.new(1,1,1)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.BackgroundTransparency = 1

local function createButton(name, text, yPos)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Name = name
    btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.Size = UDim2.new(0.9, 0, 0, 42)
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    return btn
end

local ToggleFarm = createButton("ToggleFarm", "⚡  AUTO FARM: OFF", 45)
local TogglePotions = createButton("TogglePotions", "🧪  AUTO POTIONS: OFF", 98)
local ToggleCrates = createButton("ToggleCrates", "🎁  AUTO CRATE: OFF", 151)

-- [[ LOGIC: AUTO BUY CRATES (5 Types) ]]
task.spawn(function()
    local crateRemote = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Crate"):WaitForChild("purchase")
    while true do
        if _G.AutoCrates then
            for _, crateName in ipairs(cratesToBuy) do
                if not _G.AutoCrates then break end
                pcall(function()
                    -- ซื้อทีละ 10 กล่องตามรายชื่อใน List
                    crateRemote:FireServer(crateName, 10)
                end)
                task.wait(0.15) -- ปรับดีเลย์เล็กน้อยเพื่อให้เซิร์ฟเวอร์ประมวลผลทัน
            end
        end
        task.wait(0.2)
    end
end)

-- [[ LOGIC: AUTO FARM ]]
task.spawn(function()
    while true do
        if _G.AutoFarm then
            local myPlot = getMyPlot()
            if myPlot and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                local slots = myPlot:FindFirstChild("Slots")
                if slots then
                    for _, num in ipairs(slotsToStep) do
                        if not _G.AutoFarm then break end
                        local s = slots:FindFirstChild(tostring(num))
                        if s and s:FindFirstChild("Button") then
                            pcall(function()
                                firetouchinterest(lp.Character.HumanoidRootPart, s.Button, 0)
                                task.wait(0.02)
                                firetouchinterest(lp.Character.HumanoidRootPart, s.Button, 1)
                            end)
                        end
                    end
                end
            end
        end
        task.wait(0.1)
    end
end)

-- [[ LOGIC: AUTO POTIONS ]]
task.spawn(function()
    local potionRemote = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Potion"):WaitForChild("purchase")
    while true do
        if _G.AutoPotions then
            for _, pName in ipairs(potionsToBuy) do
                if not _G.AutoPotions then break end
                pcall(function() potionRemote:FireServer(pName, 10) end)
                task.wait(0.1)
            end
        end
        task.wait(5)
    end
end)

-- [[ CONNECT BUTTONS ]]
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

-- Anti-AFK
local vu = game:GetService("VirtualUser")
lp.Idled:Connect(function() vu:CaptureController() vu:ClickButton2(Vector2.new()) end)

print("🚀 v3.7 Loaded: 5 Crate Types Ready!")

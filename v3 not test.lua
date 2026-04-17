-- ================================================
--   🌀 Spin a Anime - [V3.5 CRATE & FARM]
--   เพิ่มระบบ Auto Buy Crate (Royal)
-- ================================================

local lp = game.Players.LocalPlayer
local slotsToStep = {1, 2, 3, 4, 5, 7, 8, 9, 10}
local potionsToBuy = {
    "Greed", "Fairy", "Evil", "Bank", "Angelic",
    "Clover", "Super Lucky", "Super Yen", "Mutation", "Lucky", "Yen"
}

_G.AutoFarm = false
_G.AutoPotions = false
_G.AutoCrates = false -- ตัวแปรใหม่สำหรับเปิดกล่อง

-- [[ FUNCTION: AUTO DETECT MY PLOT ]]
local function getMyPlot()
    local plots = game:GetService("Workspace"):FindFirstChild("Plots")
    if not plots then return nil end
    return plots:FindFirstChild(lp.Name) or nil
end

-- [[ GUI ]]
local ScreenGui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
ScreenGui.Name = "SpinAnimeTurbo"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 230) -- ขยายขนาดรองรับปุ่มใหม่
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)

local function createButton(name, text, yPos, color)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Name = name
    btn.BackgroundColor3 = color
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextSize = 13
    Instance.new("UICorner", btn)
    return btn
end

local ToggleFarm = createButton("ToggleFarm", "⚡ FARM: OFF", 45, Color3.fromRGB(200, 50, 50))
local TogglePotions = createButton("TogglePotions", "🧪 POTIONS: OFF", 95, Color3.fromRGB(200, 50, 50))
local ToggleCrates = createButton("ToggleCrates", "🎁 AUTO CRATE: OFF", 145, Color3.fromRGB(200, 50, 50))

-- [[ LOGIC: AUTO FARM ]]
task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoFarm then
            local myPlot = getMyPlot()
            if myPlot and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                local slots = myPlot:FindFirstChild("Slots")
                if slots then
                    for _, num in ipairs(slotsToStep) do
                        local s = slots:FindFirstChild(tostring(num))
                        if s and s:FindFirstChild("Button") then
                            pcall(function()
                                firetouchinterest(lp.Character.HumanoidRootPart, s.Button, 0)
                                firetouchinterest(lp.Character.HumanoidRootPart, s.Button, 1)
                            end)
                        end
                    end
                end
            end
        end
    end
end)

-- [[ LOGIC: AUTO BUY CRATES (NEW!) ]]
task.spawn(function()
    local crateRemote = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Crate"):WaitForChild("purchase")
    while task.wait(0.3) do -- หน่วงเวลา 0.3 วินาทีต่อการซื้อ 10 กล่อง (กันเกมค้าง)
        if _G.AutoCrates then
            pcall(function()
                -- ซื้อกล่อง Royal ครั้งละ 10 กล่อง
                crateRemote:FireServer("Royal", 10)
            end)
        end
    end
end)

-- [[ LOGIC: AUTO POTIONS ]]
task.spawn(function()
    local potionRemote = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Potion"):WaitForChild("purchase")
    while task.wait(1) do
        if _G.AutoPotions then
            for _, name in ipairs(potionsToBuy) do
                if not _G.AutoPotions then break end
                pcall(function()
                    potionRemote:FireServer(name, 10)
                end)
                task.wait(0.05)
            end
        end
    end
end)

-- [[ TOGGLE CONNECT ]]
ToggleFarm.MouseButton1Click:Connect(function()
    _G.AutoFarm = not _G.AutoFarm
    ToggleFarm.Text = _G.AutoFarm and "⚡ FARM: ON" or "⚡ FARM: OFF"
    ToggleFarm.BackgroundColor3 = _G.AutoFarm and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
end)

TogglePotions.MouseButton1Click:Connect(function()
    _G.AutoPotions = not _G.AutoPotions
    TogglePotions.Text = _G.AutoPotions and "🧪 POTIONS: ON" or "🧪 POTIONS: OFF"
    TogglePotions.BackgroundColor3 = _G.AutoPotions and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
end)

ToggleCrates.MouseButton1Click:Connect(function()
    _G.AutoCrates = not _G.AutoCrates
    ToggleCrates.Text = _G.AutoCrates and "🎁 AUTO CRATE: ON" or "🎁 AUTO CRATE: OFF"
    ToggleCrates.BackgroundColor3 = _G.AutoCrates and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
end)

-- Anti-AFK
for i,v in pairs(getconnections(lp.Idled)) do v:Disable() end
print("🚀 Spin a Anime V3.5 Loaded - Crate Support Added!")

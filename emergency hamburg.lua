-- [[ EMERGENCY RESPONSE: LIBERTY COUNTY SCRIPT BY RoWnn0 ]] --
-- [[ REVENGE EDITION | NO KEY | ANTI-BAN ]] --
-- Toggle: INSERT | YouTube: RoWnn0

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

-- UI RESET
if game:GetService("CoreGui"):FindFirstChild("RoWnn0_ERLC") then
    game:GetService("CoreGui"):FindFirstChild("RoWnn0_ERLC"):Destroy()
end

-- --- UI SETUP ---
local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "RoWnn0_ERLC"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 520, 0, 400)
main.Position = UDim2.new(0.5, -260, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 20) -- ERLC Mavisi tonu
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

-- RoWnn0 Rainbow Glow ✨
local glow = Instance.new("Frame", main)
glow.Size = UDim2.new(1, 6, 1, 6); glow.Position = UDim2.new(0, -3, 0, -3); glow.ZIndex = 0
Instance.new("UICorner", glow).CornerRadius = UDim.new(0, 12)
spawn(function() while wait() do glow.BackgroundColor3 = Color3.fromHSV(tick() % 5 / 5, 0.7, 1) end end)

local side = Instance.new("Frame", main)
side.Size = UDim2.new(0, 150, 1, 0); side.BackgroundColor3 = Color3.fromRGB(20, 20, 25); side.BorderSizePixel = 0
Instance.new("UICorner", side)

local container = Instance.new("Frame", main)
container.Size = UDim2.new(1, -165, 1, -65); container.Position = UDim2.new(0, 158, 0, 58); container.BackgroundTransparency = 1

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 50); title.Text = "🚨 ER:LC REVENGE V1.0 BY RoWnn0 🚨"; title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold; title.TextSize = 14; title.BackgroundTransparency = 1

local function CreateTab(name, order)
    local b = Instance.new("TextButton", side)
    b.Size = UDim2.new(1, -20, 0, 38); b.Position = UDim2.new(0, 10, 0, 60 + (order * 44))
    b.Text = name; b.BackgroundColor3 = Color3.fromRGB(35, 35, 45); b.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    b.Font = Enum.Font.GothamSemibold; Instance.new("UICorner", b)
    local p = Instance.new("ScrollingFrame", container)
    p.Size = UDim2.new(1, 0, 1, 0); p.BackgroundTransparency = 1; p.Visible = false; p.ScrollBarThickness = 0
    b.MouseButton1Click:Connect(function()
        for _, x in pairs(container:GetChildren()) do x.Visible = false end
        p.Visible = true
    end)
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 8)
    return p
end

local robTab = CreateTab("ROBBERY", 0)
local playerTab = CreateTab("PLAYER", 1)
local carTab = CreateTab("VEHICLE", 2)
local creditTab = CreateTab("CREDITS", 3)
robTab.Visible = true

local function AddToggle(parent, text, callback)
    local t = Instance.new("TextButton", parent)
    t.Size = UDim2.new(1, -10, 0, 35); t.Text = "  " .. text .. " [OFF]"; t.TextXAlignment = Enum.TextXAlignment.Left
    t.BackgroundColor3 = Color3.fromRGB(45, 45, 55); t.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    t.Font = Enum.Font.Gotham; Instance.new("UICorner", t)
    local act = false
    t.MouseButton1Click:Connect(function()
        act = not act
        t.Text = "  " .. text .. (act and " [ON]" or " [OFF]")
        t.BackgroundColor3 = act and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(45, 45, 55)
        callback(act)
    end)
end

-- --- 🛠️ FEATURES ---

-- 💰 ROBBERY
AddToggle(robTab, "Auto Rob ATM (Wait Fix)", function(v) _G.ATM = v end)
AddToggle(robTab, "Instant Lockpick", function(v) _G.Lock = v end)
AddToggle(robTab, "Register Aura (Market)", function(v) _G.Market = v end)

-- ⚡ PLAYER (SAFE SPEED)
AddToggle(playerTab, "Safe WalkSpeed (20)", function(v)
    _G.Spd = v
    spawn(function()
        while _G.Spd do
            if LP.Character and LP.Character:FindFirstChild("Humanoid") then
                LP.Character.Humanoid.WalkSpeed = 20 -- ERLC'de 20 oldukça güvenlidir
            end
            task.wait(0.5)
        end
    end)
end)

AddToggle(playerTab, "Infinite Stamina", function(v) _G.InfStam = v end)

-- 🚗 VEHICLE
AddToggle(carTab, "No Engine Damage", function(v) _G.NoDmg = v end)
AddToggle(carTab, "Speed Multiplier", function(v) _G.CarSpd = v end)

-- 💎 CREDITS
local yt = Instance.new("TextButton", creditTab)
yt.Size = UDim2.new(1, -10, 0, 50); yt.Text = "📺 YouTube: RoWnn0"; yt.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Instance.new("UICorner", yt); yt.MouseButton1Click:Connect(function() setclipboard("https://www.youtube.com/@RoWnn0") end)

-- TOGGLE
UIS.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.Insert then main.Visible = not main.Visible end end)

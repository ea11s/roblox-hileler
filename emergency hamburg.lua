-- [[ EMERGENCY HAMBURG MASTER SCRIPT BY RoWnn0 ]] --
-- [[ NO KEY | EVERYTHING WORKING | FINAL VERSION ]] --
-- Toggle: INSERT | YouTube: RoWnn0

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

-- UI RESET (Eskileri Temizle)
local old = game:GetService("CoreGui"):FindFirstChild("RoWnn0_Hamburg_Master")
if old then old:Destroy() end

-- --- UI SETUP ---
local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "RoWnn0_Hamburg_Master"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 520, 0, 400)
main.Position = UDim2.new(0.5, -260, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

-- Rainbow Glow (RoWnn Signature ✨)
local glow = Instance.new("Frame", main)
glow.Size = UDim2.new(1, 6, 1, 6); glow.Position = UDim2.new(0, -3, 0, -3); glow.ZIndex = 0
Instance.new("UICorner", glow).CornerRadius = UDim.new(0, 12)
spawn(function() while wait() do glow.BackgroundColor3 = Color3.fromHSV(tick() % 5 / 5, 0.6, 1) end end)

local side = Instance.new("Frame", main)
side.Size = UDim2.new(0, 150, 1, 0); side.BackgroundColor3 = Color3.fromRGB(20, 20, 20); side.BorderSizePixel = 0
Instance.new("UICorner", side)

local container = Instance.new("Frame", main)
container.Size = UDim2.new(1, -165, 1, -65); container.Position = UDim2.new(0, 158, 0, 58); container.BackgroundTransparency = 1

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 50); title.Text = "💎 RoWnn0 MASTER V1.0 💎"; title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold; title.TextSize = 14; title.BackgroundTransparency = 1

local function CreateTab(name, order)
    local b = Instance.new("TextButton", side)
    b.Size = UDim2.new(1, -20, 0, 38); b.Position = UDim2.new(0, 10, 0, 60 + (order * 44))
    b.Text = name; b.BackgroundColor3 = Color3.fromRGB(35, 35, 35); b.TextColor3 = Color3.new(0.8, 0.8, 0.8)
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

local mainTab = CreateTab("MAIN", 0)
local carTab = CreateTab("VEHICLE", 1)
local miscTab = CreateTab("MISC", 2)
local creditTab = CreateTab("CREDITS", 3)
mainTab.Visible = true

local function AddToggle(parent, text, callback)
    local t = Instance.new("TextButton", parent)
    t.Size = UDim2.new(1, -10, 0, 35); t.Text = "  " .. text .. " [OFF]"; t.TextXAlignment = Enum.TextXAlignment.Left
    t.BackgroundColor3 = Color3.fromRGB(40, 40, 40); t.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    t.Font = Enum.Font.Gotham; Instance.new("UICorner", t)
    local act = false
    t.MouseButton1Click:Connect(function()
        act = not act
        t.Text = "  " .. text .. (act and " [ON]" or " [OFF]")
        t.BackgroundColor3 = act and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(40, 40, 40)
        callback(act)
    end)
end

-- --- 🚀 MASTER FEATURES ---

-- 📦 MAIN (Kargo & Karakter)
AddToggle(mainTab, "Auto Interaction (E)", function(v)
    _G.AutoE = v
    spawn(function()
        while _G.AutoE do
            game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
            task.wait(0.2)
        end
    end)
end)

AddToggle(mainTab, "Walk Speed (Safe)", function(v)
    _G.Spd = v
    spawn(function()
        while _G.Spd do
            if LP.Character and LP.Character:FindFirstChild("Humanoid") then
                LP.Character.Humanoid.WalkSpeed = 28
            end
            task.wait(0.1)
        end
    end)
end)

AddToggle(mainTab, "Infinite Jump", function(v)
    _G.Jump = v
    UIS.JumpRequest:Connect(function()
        if _G.Jump and LP.Character then LP.Character.Humanoid:ChangeState(3) end
    end)
end)

-- 🚗 VEHICLE (Hamburg Sokakları)
AddToggle(carTab, "Extreme Car Speed", function(v)
    _G.CarSpeed = v
    RS.Stepped:Connect(function()
        if _G.CarSpeed and LP.Character and LP.Character.Humanoid.SeatPart then
            local seat = LP.Character.Humanoid.SeatPart
            if seat:IsA("VehicleSeat") then
                seat.MaxSpeed = 300
                if seat.Throttle == 1 then
                    seat.Velocity = seat.CFrame.LookVector * 120
                end
            end
        end
    end)
end)

AddToggle(carTab, "No Car Collision", function(v)
    _G.NoClipCar = v
    RS.Stepped:Connect(function()
        if _G.NoClipCar and LP.Character and LP.Character.Humanoid.SeatPart then
            local car = LP.Character.Humanoid.SeatPart.Parent
            for _, p in pairs(car:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end)
end)

-- 🌍 MISC
AddToggle(miscTab, "Full Bright & Day", function(v)
    if v then
        Lighting.ClockTime = 14
        Lighting.Brightness = 2
        Lighting.GlobalShadows = false
    else
        Lighting.GlobalShadows = true
    end
end)

AddToggle(miscTab, "Noclip (V)", function(v)
    _G.Noc = v
    RS.Stepped:Connect(function()
        if _G.Noc and LP.Character then
            for _, part in pairs(LP.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)
end)

-- 💎 CREDITS (RoWnn Signature)
local yt = Instance.new("TextButton", creditTab)
yt.Size = UDim2.new(1, -10, 0, 50); yt.Text = "📺 YouTube: RoWnn0"; yt.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Instance.new("UICorner", yt); yt.MouseButton1Click:Connect(function() setclipboard("https://www.youtube.com/@RoWnn0") end)

local info = Instance.new("TextLabel", creditTab)
info.Size = UDim2.new(1,-10,0,100); info.Text = "Emergency Hamburg\nMaster Script\nRoWnn0 Scripts 2026"; info.TextColor3 = Color3.new(1,1,1); info.BackgroundTransparency = 1; info.Font = Enum.Font.Gotham

-- TOGGLE
UIS.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.Insert then main.Visible = not main.Visible end end)

-- [[ ER:LC GOD MODE V6.5 BY RoWnn0 ]] --
-- [[ AIM + FOV + SPEED + DASH + INF AMMO + VISUALS ]] --

for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
    if v.Name:find("RoWnn0") then v:Destroy() end
end

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Mouse = LP:GetMouse()
local Camera = workspace.CurrentCamera

-- --- AYARLAR ---
_G.SilentAim = false
_G.FOVSize = 120
_G.SpeedEnabled = false
_G.SpeedValue = 0.4
_G.DashEnabled = false
_G.InfAmmo = false
_G.CarTurbo = 0
_G.NoFall = false
_G.ESP_Enabled = false

-- FOV ÇEMBERİ
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(0, 255, 255)
FOVCircle.Transparency = 1
FOVCircle.Filled = false
FOVCircle.Visible = false

-- --- UI SETUP ---
local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "RoWnn0_V65_Final"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 520, 0, 580)
main.Position = UDim2.new(0.5, -260, 0.5, -290)
main.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)

-- Glow
local glow = Instance.new("Frame", main)
glow.Size = UDim2.new(1, 6, 1, 6); glow.Position = UDim2.new(0, -3, 0, -3); glow.ZIndex = 0
Instance.new("UICorner", glow).CornerRadius = UDim.new(0, 16)
spawn(function() while wait() do glow.BackgroundColor3 = Color3.fromHSV(tick() % 5 / 5, 0.8, 1) end end)

local container = Instance.new("ScrollingFrame", main)
container.Size = UDim2.new(1, -20, 1, -80); container.Position = UDim2.new(0, 10, 0, 70)
container.BackgroundTransparency = 1; container.ScrollBarThickness = 0
Instance.new("UIListLayout", container).Padding = UDim.new(0, 8)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 60); title.Text = "🚨 RoWnn0 V6.5: VISUAL & AMMO FIX 🚨"
title.TextColor3 = Color3.new(1, 1, 1); title.Font = Enum.Font.GothamBold; title.BackgroundTransparency = 1

local function AddToggle(text, callback)
    local b = Instance.new("TextButton", container)
    b.Size = UDim2.new(1, 0, 0, 38); b.Text = "  " .. text .. " [OFF]"
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 30); b.TextColor3 = Color3.new(1,1,1); b.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", b); local act = false
    b.MouseButton1Click:Connect(function()
        act = not act
        b.Text = "  " .. text .. (act and " [ON]" or " [OFF]")
        b.BackgroundColor3 = act and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(25, 25, 30)
        callback(act)
    end)
end

local function AddSlider(text, min, max, callback)
    local b = Instance.new("TextButton", container)
    b.Size = UDim2.new(1, 0, 0, 38); b.Text = "  " .. text .. " (+)"
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 45); b.TextColor3 = Color3.new(1,1,1); b.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", b); local val = min
    b.MouseButton1Click:Connect(function()
        val = val + ((max-min)/10); if val > max then val = min end
        b.Text = "  " .. text .. ": " .. math.floor(val); callback(val)
    end)
end

-- --- 🛠️ MASTER FEATURES ---

-- VISUALS (YENİ!)
AddToggle("Visuals (Box ESP / Info)", function(v) _G.ESP_Enabled = v end)

-- COMBAT
AddToggle("Infinite Ammo (Hard Fix)", function(v) _G.InfAmmo = v end)
AddToggle("Silent Aim (FOV)", function(v) _G.SilentAim = v; FOVCircle.Visible = v end)
AddSlider("FOV Boyutu", 50, 600, function(v) _G.FOVSize = v end)

-- MOVEMENT
AddToggle("Bypass Speed (Velocity)", function(v) _G.SpeedEnabled = v end)
AddToggle("Q Dash (Teleport)", function(v) _G.DashEnabled = v end)
AddToggle("No Fall Damage", function(v) _G.NoFall = v end)
AddToggle("Infinite Jump", function(v) _G.InfJump = v end)

-- VEHICLE
AddSlider("Araba Turbo Speed", 0, 450, function(v) _G.CarTurbo = v end)

-- --- ⚙️ ENGINE ---

-- 🎯 INF AMMO FIX (Yeni Metot)
spawn(function()
    while task.wait() do
        if _G.InfAmmo then
            pcall(function()
                local char = LP.Character
                local tool = char and char:FindFirstChildOfClass("Tool")
                if tool then
                    -- ER:LC mermi kontrolü hem Value hem de Attributes üzerinden olabilir
                    if tool:FindFirstChild("Ammo") then tool.Ammo.Value = 999 end
                    if tool:FindFirstChild("MaxAmmo") then tool.MaxAmmo.Value = 999 end
                    tool:SetAttribute("Ammo", 999)
                end
            end)
        end
    end
end)

-- 👁️ VISUALS (ESP) ENGINE
local function CreateESP(ply)
    local box = Instance.new("BoxHandleAdornment", game:GetService("CoreGui"))
    box.Name = ply.Name .. "_ESP"
    box.AlwaysOnTop = true; box.ZIndex = 10; box.Transparency = 0.5
    box.Color3 = (ply.Team and ply.Team.Name:find("Police")) and Color3.new(1,0,0) or Color3.new(1,1,1)
    
    RS.RenderStepped:Connect(function()
        if _G.ESP_Enabled and ply.Character and ply.Character:FindFirstChild("HumanoidRootPart") then
            box.Adornee = ply.Character; box.Size = ply.Character:GetExtentsSize()
            box.Visible = true
        else
            box.Visible = false
        end
    end)
end

Players.PlayerAdded:Connect(CreateESP)
for _, p in pairs(Players:GetPlayers()) do if p ~= LP then CreateESP(p) end end

-- ⚙️ CORE UPDATES
RS.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
    FOVCircle.Radius = _G.FOVSize
    
    if _G.SpeedEnabled and LP.Character and LP.Character:FindFirstChild("Humanoid") then
        local hum = LP.Character.Humanoid
        if hum.MoveDirection.Magnitude > 0 then
            LP.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame + (hum.MoveDirection * _G.SpeedValue)
        end
    end
    
    if _G.CarTurbo > 0 and LP.Character and LP.Character.Humanoid.SeatPart then
        local seat = LP.Character.Humanoid.SeatPart
        if seat:IsA("VehicleSeat") then
            seat.MaxSpeed = _G.CarTurbo
            if seat.Throttle == 1 then seat.Velocity = seat.CFrame.LookVector * (_G.CarTurbo * 0.6) end
        end
    end
end)

-- Q DASH & JUMP & TOGGLE
UIS.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.Q and _G.DashEnabled then
        local hum = LP.Character:FindFirstChild("Humanoid")
        if hum then LP.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame + (hum.MoveDirection * 35) end
    end
    if not g and i.KeyCode == Enum.KeyCode.Insert then main.Visible = not main.Visible end
end)

UIS.JumpRequest:Connect(function() if _G.InfJump then LP.Character.Humanoid:ChangeState(3) end end)

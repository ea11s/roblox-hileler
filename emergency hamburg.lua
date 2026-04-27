-- [[ ER:LC ULTIMATE GOD MODE V6.0 BY RoWnn0 ]] --
-- [[ SILENT AIM + FOV + SPEED + DASH + INF AMMO ]] --

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

-- FOV ÇEMBERİ
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(0, 255, 255)
FOVCircle.Transparency = 1
FOVCircle.Filled = false
FOVCircle.Visible = false

-- --- UI ---
local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "RoWnn0_V6_Final"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 520, 0, 550)
main.Position = UDim2.new(0.5, -260, 0.5, -275)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)

-- Neon Glow ✨
local glow = Instance.new("Frame", main)
glow.Size = UDim2.new(1, 6, 1, 6); glow.Position = UDim2.new(0, -3, 0, -3); glow.ZIndex = 0
Instance.new("UICorner", glow).CornerRadius = UDim.new(0, 16)
spawn(function() while wait() do glow.BackgroundColor3 = Color3.fromHSV(tick() % 5 / 5, 0.7, 1) end end)

local container = Instance.new("ScrollingFrame", main)
container.Size = UDim2.new(1, -20, 1, -80); container.Position = UDim2.new(0, 10, 0, 70)
container.BackgroundTransparency = 1; container.ScrollBarThickness = 0
Instance.new("UIListLayout", container).Padding = UDim.new(0, 8)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 60); title.Text = "🚨 RoWnn0 V6.0 MASTER (EVERYTHING) 🚨"
title.TextColor3 = Color3.new(1, 1, 1); title.Font = Enum.Font.GothamBold; title.BackgroundTransparency = 1

local function AddToggle(text, callback)
    local b = Instance.new("TextButton", container)
    b.Size = UDim2.new(1, 0, 0, 38); b.Text = text .. " [KAPALI]"
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
    local act = false
    b.MouseButton1Click:Connect(function()
        act = not act
        b.Text = text .. (act and " [AÇIK]" or " [KAPALI]")
        b.BackgroundColor3 = act and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(30, 30, 30)
        callback(act)
    end)
end

local function AddSlider(text, min, max, callback)
    local b = Instance.new("TextButton", container)
    b.Size = UDim2.new(1, 0, 0, 38); b.Text = text .. " Ayarla (+)"
    b.BackgroundColor3 = Color3.fromRGB(45, 45, 45); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
    local val = min
    b.MouseButton1Click:Connect(function()
        val = val + ((max-min)/8)
        if val > max then val = min end
        b.Text = text .. ": " .. math.floor(val)
        callback(val)
    end)
end

-- --- 🛠️ MASTER FEATURES ---

-- COMBAT
AddToggle("Silent Aim (Headshot)", function(v) _G.SilentAim = v; FOVCircle.Visible = v end)
AddSlider("FOV Boyutu", 50, 600, function(v) _G.FOVSize = v end)
AddToggle("Sınırsız Mermi (Full)", function(v) _G.InfAmmo = v end)

-- MOVEMENT
AddToggle("Bypass Speed (Safe)", function(v) _G.SpeedEnabled = v end)
AddToggle("Q Dash (Teleport Dash)", function(v) _G.DashEnabled = v end)
AddToggle("No Fall Damage", function(v) _G.NoFall = v end)
AddToggle("Infinite Jump", function(v) _G.InfJump = v end)

-- VEHICLE
AddSlider("Araba Turbo Speed", 0, 500, function(v) _G.CarTurbo = v end)

-- --- ⚙️ ENGINE ---

-- 🎯 SILENT AIM LOGIC
local function GetClosestPlayer()
    local closest, dist = nil, _G.FOVSize
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LP and v.Character and v.Character:FindFirstChild("Head") then
            local pos, vis = Camera:WorldToViewportPoint(v.Character.Head.Position)
            local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
            if mag < dist and vis then
                closest = v
                dist = mag
            end
        end
    end
    return closest
end

-- 🔫 INF AMMO HOOK
spawn(function()
    while task.wait(0.2) do
        if _G.InfAmmo then
            pcall(function()
                local tool = LP.Character:FindFirstChildOfClass("Tool")
                if tool and tool:FindFirstChild("Ammo") then tool.Ammo.Value = 999 end
            end)
        end
    end
end)

-- ⚙️ CORE UPDATES
RS.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
    FOVCircle.Radius = _G.FOVSize
    
    -- Speed Bypass
    if _G.SpeedEnabled and LP.Character and LP.Character:FindFirstChild("Humanoid") then
        local hum = LP.Character.Humanoid
        if hum.MoveDirection.Magnitude > 0 then
            LP.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame + (hum.MoveDirection * _G.SpeedValue)
        end
    end
    
    -- Smart Car
    if _G.CarTurbo > 0 and LP.Character and LP.Character.Humanoid.SeatPart then
        local seat = LP.Character.Humanoid.SeatPart
        if seat:IsA("VehicleSeat") then
            seat.MaxSpeed = _G.CarTurbo
            if seat.Throttle == 1 then seat.Velocity = seat.CFrame.LookVector * (_G.CarTurbo * 0.6) end
        end
    end
end)

-- Q DASH
UIS.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.Q and _G.DashEnabled then
        local hum = LP.Character:FindFirstChild("Humanoid")
        if hum then LP.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame + (hum.MoveDirection * 30) end
    end
    if not g and i.KeyCode == Enum.KeyCode.Insert then main.Visible = not main.Visible end
end)

-- INF JUMP
UIS.JumpRequest:Connect(function() if _G.InfJump then LP.Character.Humanoid:ChangeState(3) end end)

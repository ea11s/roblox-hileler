-- [[ ER:LC GOD MODE V7.0 BY RoWnn0 ]] --
-- [[ AMMO FIX + TRACERS + DISTANCE + NO CAR DMG ]] --

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
_G.Visuals = false
_G.InfAmmo = false
_G.NoCarDmg = false
_G.SilentAim = false
_G.FOVSize = 120
_G.SpeedEnabled = false
_G.SpeedValue = 0.4
_G.CarTurbo = 0

-- FOV & TRACERS SETUP
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2; FOVCircle.Color = Color3.new(0, 1, 1); FOVCircle.Visible = false

-- --- UI SETUP ---
local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "RoWnn0_V7_Final"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 520, 0, 600)
main.Position = UDim2.new(0.5, -260, 0.5, -300)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Instance.new("UICorner", main)

local container = Instance.new("ScrollingFrame", main)
container.Size = UDim2.new(1, -20, 1, -100); container.Position = UDim2.new(0, 10, 0, 70)
container.BackgroundTransparency = 1; container.ScrollBarThickness = 0
Instance.new("UIListLayout", container).Padding = UDim.new(0, 8)

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

-- --- 🛠️ FEATURES ---
AddToggle("Visuals (Tracers/Dist/Box)", function(v) _G.Visuals = v end)
AddToggle("Infinite Ammo (Mega Fix)", function(v) _G.InfAmmo = v end)
AddToggle("No Vehicle Damage", function(v) _G.NoCarDmg = v end)
AddToggle("Silent Aim (FOV)", function(v) _G.SilentAim = v; FOVCircle.Visible = v end)
AddToggle("Bypass Speed (Velocity)", function(v) _G.SpeedEnabled = v end)
AddToggle("Q Dash (35 Studs)", function(v) _G.Dash = v end)

-- --- ⚙️ ENGINE ---

-- 🎯 INF AMMO MEGA FIX (Remote Spy Bypass)
spawn(function()
    while task.wait() do
        if _G.InfAmmo then
            pcall(function()
                local tool = LP.Character:FindFirstChildOfClass("Tool")
                if tool and tool:FindFirstChild("Ammo") then
                    if tool.Ammo.Value < 10 then tool.Ammo.Value = 30 end
                end
                -- ER:LC Attribute bypass
                if tool then tool:SetAttribute("Ammo", 30) end
            end)
        end
    end
end)

-- 👁️ VISUALS ENGINE (Box, Tracer, Distance)
local function CreateESP(p)
    local Line = Drawing.new("Line")
    local Text = Drawing.new("Text")
    
    RS.RenderStepped:Connect(function()
        if _G.Visuals and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p ~= LP then
            local pos, vis = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if vis then
                local dist = math.floor((LP.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude)
                
                Line.Visible = true
                Line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                Line.To = Vector2.new(pos.X, pos.Y)
                Line.Color = (p.Team and p.Team.Name:find("Police")) and Color3.new(1,0,0) or Color3.new(1,1,1)
                
                Text.Visible = true
                Text.Position = Vector2.new(pos.X, pos.Y - 40)
                Text.Text = "[" .. p.Name .. "] " .. dist .. "m"
                Text.Color = Color3.new(1,1,1); Text.Center = true; Text.Size = 14
            else Line.Visible = false; Text.Visible = false end
        else Line.Visible = false; Text.Visible = false end
    end)
end
Players.PlayerAdded:Connect(CreateESP)
for _, p in pairs(Players:GetPlayers()) do CreateESP(p) end

-- 🚗 VEHICLE NO DAMAGE & TURBO
RS.Heartbeat:Connect(function()
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        local seat = LP.Character.Humanoid.SeatPart
        if seat and seat:IsA("VehicleSeat") and seat.Parent then
            if _G.NoCarDmg then
                pcall(function()
                    if seat.Parent:FindFirstChild("Health") then seat.Parent.Health.Value = 100 end
                    for _, v in pairs(seat.Parent:GetDescendants()) do
                        if v.Name == "Damage" or v.Name == "EngineHealth" then v.Value = 100 end
                    end
                end)
            end
        end
    end
end)

-- ⚙️ CORE UPDATES
RS.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36); FOVCircle.Radius = _G.FOVSize
    if _G.SpeedEnabled and LP.Character and LP.Character:FindFirstChild("Humanoid") then
        if LP.Character.Humanoid.MoveDirection.Magnitude > 0 then
            LP.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame + (LP.Character.Humanoid.MoveDirection * _G.SpeedValue)
        end
    end
end)

UIS.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.Q and _G.Dash then
        LP.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame + (LP.Character.Humanoid.MoveDirection * 35)
    end
    if not g and i.KeyCode == Enum.KeyCode.Insert then main.Visible = not main.Visible end
end)

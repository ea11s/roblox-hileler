-- [[ ER:LC GOD MODE V7.0 - BYPASS & VISUALS ]] --
-- [[ RE-IDENTITY: RoWnn0_FINAL_V7 ]] --

-- [[ 1. TÜM ESKİ MENÜLERİ VE KALINTILARI SİL ]] --
local CoreGui = game:GetService("CoreGui")
for _, child in pairs(CoreGui:GetChildren()) do
    if child:IsA("ScreenGui") and (child.Name:find("RoWnn0") or child.Name:find("Ultimate") or child.Name:find("Final")) then
        child:Destroy()
    end
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
_G.Dash = false

-- DRAWING SETUP
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2; FOVCircle.Color = Color3.new(0, 1, 1); FOVCircle.Visible = false

-- --- UI SETUP (NEW IDENTITY) ---
local sg = Instance.new("ScreenGui", CoreGui)
sg.Name = "RoWnn0_REVENGE_V7_ACTUAL" -- Kesinlikle farklı isim

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 520, 0, 600)
main.Position = UDim2.new(0.5, -260, 0.5, -300)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Instance.new("UICorner", main)

-- Glow ✨
local glow = Instance.new("Frame", main)
glow.Size = UDim2.new(1, 6, 1, 6); glow.Position = UDim2.new(0, -3, 0, -3); glow.ZIndex = 0
Instance.new("UICorner", glow).CornerRadius = UDim.new(0, 16)
spawn(function() while wait() do glow.BackgroundColor3 = Color3.fromHSV(tick() % 5 / 5, 0.8, 1) end end)

local container = Instance.new("ScrollingFrame", main)
container.Size = UDim2.new(1, -20, 1, -100); container.Position = UDim2.new(0, 10, 0, 70)
container.BackgroundTransparency = 1; container.ScrollBarThickness = 0
Instance.new("UIListLayout", container).Padding = UDim.new(0, 8)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 60); title.Text = "🚨 RoWnn0 V7.0: ULTIMATE REVENGE 🚨"
title.TextColor3 = Color3.new(1, 1, 1); title.Font = Enum.Font.GothamBold; title.BackgroundTransparency = 1

local function AddToggle(text, callback)
    local b = Instance.new("TextButton", container)
    b.Size = UDim2.new(1, 0, 0, 38); b.Text = "  " .. text .. " [OFF]"; b.TextXAlignment = Enum.TextXAlignment.Left
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 30); b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", b); local act = false
    b.MouseButton1Click:Connect(function()
        act = not act
        b.Text = "  " .. text .. (act and " [ON]" or " [OFF]")
        b.BackgroundColor3 = act and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(25, 25, 30)
        callback(act)
    end)
end

-- --- 🛠️ MASTER FEATURES ---
AddToggle("Visuals (Tracers & Dist)", function(v) _G.Visuals = v end)
AddToggle("Infinite Ammo (No Reload)", function(v) _G.InfAmmo = v end)
AddToggle("No Vehicle Damage", function(v) _G.NoCarDmg = v end)
AddToggle("Silent Aim (FOV)", function(v) _G.SilentAim = v; FOVCircle.Visible = v end)
AddToggle("Bypass Speed (Velocity)", function(v) _G.SpeedEnabled = v end)
AddToggle("Q Dash (Teleport)", function(v) _G.Dash = v end)

-- --- ⚙️ ENGINE ---

-- 🔫 AMMO ENGINE (Daha Sert Metot)
spawn(function()
    while task.wait(0.1) do
        if _G.InfAmmo then
            pcall(function()
                local tool = LP.Character:FindFirstChildOfClass("Tool")
                if tool then
                    if tool:FindFirstChild("Ammo") then tool.Ammo.Value = 99 end
                    tool:SetAttribute("Ammo", 99)
                    tool:SetAttribute("MaxAmmo", 99)
                end
            end)
        end
    end
end)

-- 👁️ VISUALS (TRACERS & DISTANCE)
local function ApplyESP(p)
    local line = Drawing.new("Line")
    local text = Drawing.new("Text")
    
    RS.RenderStepped:Connect(function()
        if _G.Visuals and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p ~= LP then
            local pos, vis = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if vis then
                local d = math.floor((LP.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude)
                line.Visible = true; line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y); line.To = Vector2.new(pos.X, pos.Y)
                line.Color = (p.Team and p.Team.Name:find("Pol")) and Color3.new(1,0,0) or Color3.new(1,1,1)
                text.Visible = true; text.Position = Vector2.new(pos.X, pos.Y - 40); text.Text = p.Name .. " [" .. d .. "m]"; text.Center = true; text.Size = 14; text.Outline = true
            else line.Visible = false; text.Visible = false end
        else line.Visible = false; text.Visible = false end
    end)
end
Players.PlayerAdded:Connect(ApplyESP)
for _, p in pairs(Players:GetPlayers()) do ApplyESP(p) end

-- 🚗 NO DAMAGE
RS.Heartbeat:Connect(function()
    if _G.NoCarDmg and LP.Character and LP.Character.Humanoid.SeatPart then
        local car = LP.Character.Humanoid.SeatPart.Parent
        pcall(function()
            if car:FindFirstChild("Health") then car.Health.Value = 100 end
            for _, v in pairs(car:GetDescendants()) do if v.Name == "EngineHealth" then v.Value = 100 end end
        end)
    end
end)

-- CORE UPDATES
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

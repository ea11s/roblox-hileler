-- [[ RoWnn0 STEEL TITANS MASTER V7.0 ]] --
-- [[ HER ŞEY TEK MENÜDE - FULL SİSTEM ]] --

for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
    if v.Name:find("RoWnn0") then v:Destroy() end
end

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Mouse = LP:GetMouse()
local Camera = workspace.CurrentCamera

-- --- DEĞİŞKENLER ---
_G.Aimbot = false
_G.FOVSize = 150
_G.GlowESP = false
_G.Tracers = false
_G.FlyEnabled = false
_G.FlySpeed = 60
_G.TankSpeed = false
_G.QuickTurn = false

local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2; FOVCircle.Color = Color3.new(1, 0, 0); FOVCircle.Visible = false

-- --- UI TASARIMI (ESKİ SİSTEM) ---
local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "RoWnn0_Master_V7"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 520, 0, 420); main.Position = UDim2.new(0.5, -260, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); main.BorderSizePixel = 0
Instance.new("UICorner", main)

-- Neon Glow Şerit
local line = Instance.new("Frame", main)
line.Size = UDim2.new(1, 0, 0, 2); line.Position = UDim2.new(0, 0, 0, 40)
line.BackgroundColor3 = Color3.fromRGB(0, 255, 150); line.BorderSizePixel = 0

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40); title.Text = "RoWnn0 MASTER V7.0 - STEEL TITANS"; title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold; title.TextSize = 16; title.BackgroundTransparency = 1

local side = Instance.new("Frame", main)
side.Size = UDim2.new(0, 140, 1, -45); side.Position = UDim2.new(0, 5, 0, 45); side.BackgroundTransparency = 1

local container = Instance.new("Frame", main)
container.Size = UDim2.new(1, -160, 1, -60); container.Position = UDim2.new(0, 150, 0, 50); container.BackgroundTransparency = 1

local function CreateTab(name, order)
    local b = Instance.new("TextButton", side)
    b.Size = UDim2.new(1, -10, 0, 35); b.Position = UDim2.new(0, 5, 0, (order * 40))
    b.Text = name; b.BackgroundColor3 = Color3.fromRGB(25, 25, 25); b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold; b.TextSize = 10; Instance.new("UICorner", b)
    
    local p = Instance.new("ScrollingFrame", container)
    p.Size = UDim2.new(1, 0, 1, 0); p.Visible = (order == 0); p.BackgroundTransparency = 1; p.ScrollBarThickness = 0
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 8)
    
    b.MouseButton1Click:Connect(function()
        for _, x in pairs(container:GetChildren()) do if x:IsA("ScrollingFrame") then x.Visible = false end end
        p.Visible = true
    end)
    return p
end

local combatTab = CreateTab("SAVAŞ", 0)
local tankTab = CreateTab("TANK / FLY", 1)
local visualTab = CreateTab("GÖRSEL", 2)

local function AddToggle(parent, text, callback)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, -10, 0, 40); b.Text = text .. " [KAPALI]"; b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.TextColor3 = Color3.new(0.8, 0.8, 0.8); b.Font = Enum.Font.Gotham; Instance.new("UICorner", b)
    local act = false
    b.MouseButton1Click:Connect(function()
        act = not act; b.Text = text .. (act and " [AÇIK]" or " [KAPALI]")
        b.BackgroundColor3 = act and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(30, 30, 30)
        callback(act)
    end)
end

-- --- ✈️ FLY SİSTEMİ ---
local bv = Instance.new("BodyVelocity")
local bg = Instance.new("BodyGyro")
bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)

RS.RenderStepped:Connect(function()
    if _G.FlyEnabled then
        local target = (LP.Character and LP.Character:FindFirstChild("Humanoid") and LP.Character.Humanoid.SeatPart) or (LP.Character and LP.Character:FindFirstChild("HumanoidRootPart"))
        if target then
            bv.Parent = target; bg.Parent = target; bg.CFrame = Camera.CFrame
            local dir = Vector3.new(0,0,0)
            if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0,1,0) end
            bv.Velocity = dir * _G.FlySpeed
        end
    else
        bv.Parent = nil; bg.Parent = nil
    end
end)

-- --- 🎯 AIMBOT ---
RS.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36); FOVCircle.Radius = _G.FOVSize
    if _G.Aimbot and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local t = nil; local dist = _G.FOVSize
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local pos, vis = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                if vis then
                    local m = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if m < dist then t = v; dist = m end
                end
            end
        end
        if t then Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Character.HumanoidRootPart.Position) end
    end
end)

-- --- 👁️ ESP ---
local function ApplyESP(v)
    local l = Drawing.new("Line")
    RS.RenderStepped:Connect(function()
        if v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v ~= LP then
            local pos, vis = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            l.Visible = _G.Tracers and vis
            if l.Visible then
                l.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y); l.To = Vector2.new(pos.X, pos.Y); l.Color = Color3.new(1,0,0)
            end
            local h = v.Character:FindFirstChild("RoWnnGlow")
            if _G.GlowESP then
                if not h then h = Instance.new("Highlight", v.Character); h.Name = "RoWnnGlow" end
                h.Enabled = true; h.FillColor = Color3.new(1,0,0)
            elseif h then h.Enabled = false end
        else l.Visible = false end
    end)
end
for _, v in pairs(Players:GetPlayers()) do ApplyESP(v) end
Players.PlayerAdded:Connect(ApplyESP)

-- --- ⚙️ TANK AYARLARI ---
RS.Heartbeat:Connect(function()
    if _G.TankSpeed or _G.QuickTurn then
        pcall(function()
            local seat = LP.Character.Humanoid.SeatPart
            if seat and seat:IsA("VehicleSeat") then
                if _G.TankSpeed then seat.MaxSpeed = 150; seat.Torque = 1e6 end
                if _G.QuickTurn then
                    for _, val in pairs(seat.Parent:GetDescendants()) do
                        if val.Name:find("Turn") or val.Name:find("Speed") then val.Value = 100 end
                    end
                end
            end
        end)
    end
end)

-- --- BUTONLAR ---
AddToggle(combatTab, "Aimbot (Sağ Tık)", function(v) _G.Aimbot = v; FOVCircle.Visible = v end)
AddToggle(tankTab, "Uçma Modu (E)", function(v) _G.FlyEnabled = v end)
AddToggle(tankTab, "Süper Tank Hızı", function(v) _G.TankSpeed = v end)
AddToggle(tankTab, "Hızlı Kule Dönüşü", function(v) _G.QuickTurn = v end)
AddToggle(visualTab, "Glow ESP", function(v) _G.GlowESP = v end)
AddToggle(visualTab, "Çizgiler (Tracers)", function(v) _G.Tracers = v end)

-- Kısayollar
UIS.InputBegan:Connect(function(i, g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.Insert then main.Visible = not main.Visible end
    if i.KeyCode == Enum.KeyCode.E then _G.FlyEnabled = not _G.FlyEnabled end
end)

print("RoWnn0 MASTER V7.0 YÜKLENDİ - INSERT: Menü | E: Fly")

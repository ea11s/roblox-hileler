-- [[ STEEL TITANS V4.0 - FLYING PANZER EDITION ]] --
-- [[ FLY + TANK PHYSICS + AIMBOT + GLOW ESP ]] --

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
_G.Aimbot = false
_G.FOVSize = 150
_G.GlowESP = false
_G.Tracers = false
_G.FlyEnabled = false
_G.FlySpeed = 50
_G.TankSpeed = false
_G.QuickTurn = false
_G.InfJump = false

local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2; FOVCircle.Color = Color3.new(1, 1, 0); FOVCircle.Visible = false

-- --- UI SETUP ---
local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "RoWnn0_Titan_V4"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 520, 0, 420); main.Position = UDim2.new(0.5, -260, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 20); main.BorderSizePixel = 0
Instance.new("UICorner", main)

local side = Instance.new("Frame", main)
side.Size = UDim2.new(0, 140, 1, 0); side.BackgroundColor3 = Color3.fromRGB(20, 20, 25); side.BorderSizePixel = 0
Instance.new("UICorner", side)

local container = Instance.new("Frame", main)
container.Size = UDim2.new(1, -150, 1, -20); container.Position = UDim2.new(0, 145, 0, 10); container.BackgroundTransparency = 1

local function CreateTab(name, order)
    local b = Instance.new("TextButton", side)
    b.Size = UDim2.new(1, -10, 0, 35); b.Position = UDim2.new(0, 5, 0, 20 + (order * 40))
    b.Text = name; b.BackgroundColor3 = Color3.fromRGB(35, 35, 45); b.TextColor3 = Color3.new(1, 1, 1)
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
local flyTab = CreateTab("UÇMA MODU", 1)
local tankTab = CreateTab("TANK FİZİĞİ", 2)
local visualTab = CreateTab("GÖRSEL", 3)

local function AddToggle(parent, text, callback)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, -10, 0, 38); b.Text = text .. " [OFF]"; b.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    b.TextColor3 = Color3.new(0.9, 0.9, 0.9); b.Font = Enum.Font.Gotham; Instance.new("UICorner", b)
    local act = false
    b.MouseButton1Click:Connect(function()
        act = not act; b.Text = text .. (act and " [ON]" or " [OFF]")
        b.BackgroundColor3 = act and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(40, 40, 50)
        callback(act)
    end)
end

-- --- ✈️ FLY ENGINE (TANK & PLAYER) ---
local BV = Instance.new("BodyVelocity")
local BG = Instance.new("BodyGyro")
BV.MaxForce = Vector3.new(1e8, 1e8, 1e8)
BG.MaxTorque = Vector3.new(1e8, 1e8, 1e8)

RS.RenderStepped:Connect(function()
    local target = (LP.Character and LP.Character:FindFirstChild("Humanoid") and LP.Character.Humanoid.SeatPart) or (LP.Character and LP.Character:FindFirstChild("HumanoidRootPart"))
    
    if _G.FlyEnabled and target then
        BV.Parent = target
        BG.Parent = target
        BG.CFrame = Camera.CFrame
        
        local direction = Vector3.new(0,0,0)
        if UIS:IsKeyDown(Enum.KeyCode.W) then direction = direction + Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then direction = direction - Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then direction = direction - Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then direction = direction + Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then direction = direction + Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then direction = direction - Vector3.new(0,1,0) end
        
        BV.Velocity = direction * _G.FlySpeed
    else
        BV.Parent = nil
        BG.Parent = nil
    end
end)

-- --- ⚙️ DİĞER MOTORLAR ---
RS.Heartbeat:Connect(function()
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        local seat = LP.Character.Humanoid.SeatPart
        if seat and seat:IsA("VehicleSeat") then
            if _G.TankSpeed then seat.MaxSpeed = 150; seat.Torque = 60000 end
            if _G.QuickTurn then
                for _, v in pairs(seat.Parent:GetDescendants()) do
                    if v.Name:find("Speed") then v.Value = 60 end
                end
            end
        end
    end
end)

-- Aimbot & FOV
RS.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36); FOVCircle.Radius = _G.FOVSize
    if _G.Aimbot and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local t = nil; local dist = _G.FOVSize
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local pos, vis = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if mag < dist and vis then t = p; dist = mag end
            end
        end
        if t then Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Character.HumanoidRootPart.Position) end
    end
end)

-- --- BUTONLAR ---
AddToggle(combatTab, "Tank Aimbot", function(v) _G.Aimbot = v; FOVCircle.Visible = v end)
AddToggle(flyTab, "Uçma Modu (E Tuşu)", function(v) _G.FlyEnabled = v end)
AddToggle(tankTab, "Süper Tank Hızı", function(v) _G.TankSpeed = v end)
AddToggle(tankTab, "Hızlı Kule Dönüşü", function(v) _G.QuickTurn = v end)
AddToggle(visualTab, "Glow ESP", function(v) _G.GlowESP = v end)
AddToggle(visualTab, "Çizgiler", function(v) _G.Tracers = v end)

-- Uçma Tuş Ataması
UIS.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.E then _G.FlyEnabled = not _G.FlyEnabled end
    if not g and i.KeyCode == Enum.KeyCode.Insert then main.Visible = not main.Visible end
end)

-- ESP Engine
local function ESP(p)
    local l = Drawing.new("Line")
    RS.RenderStepped:Connect(function()
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p ~= LP then
            local pos, vis = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            l.Visible = _G.Tracers and vis
            if vis then
                l.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y); l.To = Vector2.new(pos.X, pos.Y); l.Color = Color3.new(1,0,0)
            end
            local hl = p.Character:FindFirstChild("TankHighlight")
            if _G.GlowESP then
                if not hl then hl = Instance.new("Highlight", p.Character); hl.Name = "TankHighlight" end
                hl.Enabled = true; hl.FillColor = Color3.new(1,0,0)
            elseif hl then hl.Enabled = false end
        else l.Visible = false end
    end)
end
for _, p in pairs(Players:GetPlayers()) do ESP(p) end
Players.PlayerAdded:Connect(ESP)

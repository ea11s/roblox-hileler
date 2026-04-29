-- [[ RoWnn0 STEEL TITANS V8.0 - FORCED UI ]] --
-- Menü gelmezse diye her şey en güvenli yere (PlayerGui) kuruldu.

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local Mouse = LP:GetMouse()

-- Eski her şeyi temizle
for _, v in pairs(LP.PlayerGui:GetChildren()) do if v.Name == "RoWnn0_Titan_V8" then v:Destroy() end end

-- --- AYARLAR ---
_G.Aimbot = false
_G.Fly = false
_G.Glow = false
_G.Tracers = false
_G.FlySpeed = 60
_G.TankSpeed = false

-- --- UI START ---
local sg = Instance.new("ScreenGui", LP.PlayerGui)
sg.Name = "RoWnn0_Titan_V8"
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 400, 0, 300); main.Position = UDim2.new(0.5, -200, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 25); main.Active = true; main.Draggable = true
Instance.new("UICorner", main)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 35); title.Text = "RoWnn0 V8.0 - INSERT"; title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 40); title.Font = Enum.Font.GothamBold

local container = Instance.new("ScrollingFrame", main)
container.Size = UDim2.new(1, -20, 1, -50); container.Position = UDim2.new(0, 10, 0, 40)
container.BackgroundTransparency = 1; container.ScrollBarThickness = 0
local list = Instance.new("UIListLayout", container); list.Padding = UDim.new(0, 5)

local function AddToggle(name, callback)
    local b = Instance.new("TextButton", container)
    b.Size = UDim2.new(1, 0, 0, 35); b.Text = name .. " [OFF]"; b.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.Gotham; Instance.new("UICorner", b)
    local state = false
    b.MouseButton1Click:Connect(function()
        state = not state; b.Text = name .. (state and " [ON]" or " [OFF]")
        b.BackgroundColor3 = state and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(40, 40, 50)
        callback(state)
    end)
end

-- --- ÖZELLİKLER ---

-- FLY (E Tuşu)
local bv = Instance.new("BodyVelocity"); local bg = Instance.new("BodyGyro")
bv.MaxForce = Vector3.new(1e9, 1e9, 1e9); bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)

RS.RenderStepped:Connect(function()
    if _G.Fly then
        local t = (LP.Character and LP.Character:FindFirstChild("Humanoid") and LP.Character.Humanoid.SeatPart) or (LP.Character and LP.Character:FindFirstChild("HumanoidRootPart"))
        if t then
            bv.Parent = t; bg.Parent = t; bg.CFrame = Camera.CFrame
            local d = Vector3.new(0,0,0)
            if UIS:IsKeyDown("W") then d = d + Camera.CFrame.LookVector end
            if UIS:IsKeyDown("S") then d = d - Camera.CFrame.LookVector end
            if UIS:IsKeyDown("A") then d = d - Camera.CFrame.RightVector end
            if UIS:IsKeyDown("D") then d = d + Camera.CFrame.RightVector end
            bv.Velocity = d * _G.FlySpeed
        end
    else
        bv.Parent = nil; bg.Parent = nil
    end
end)

-- AIMBOT
RS.RenderStepped:Connect(function()
    if _G.Aimbot and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = nil; local dist = 200
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local pos, vis = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                if vis then
                    local m = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if m < dist then target = v; dist = m end
                end
            end
        end
        if target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position) end
    end
end)

-- ESP & GLOW
local function ApplyESP(v)
    RS.RenderStepped:Connect(function()
        if v.Character and v ~= LP then
            local h = v.Character:FindFirstChild("GlowV8")
            if _G.Glow then
                if not h then h = Instance.new("Highlight", v.Character); h.Name = "GlowV8" end
                h.Enabled = true; h.FillColor = Color3.new(1,0,0)
            elseif h then h.Enabled = false end
        end
    end)
end
for _, v in pairs(Players:GetPlayers()) do ApplyESP(v) end
Players.PlayerAdded:Connect(ApplyESP)

-- --- TOGGLES ---
AddToggle("Aimbot (Sağ Tık)", function(v) _G.Aimbot = v end)
AddToggle("Uçma (E)", function(v) _G.Fly = v end)
AddToggle("Glow ESP", function(v) _G.Glow = v end)
AddToggle("Süper Tank Hızı", function(v) _G.TankSpeed = v end)

-- Keybinds
UIS.InputBegan:Connect(function(i, g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.Insert then main.Visible = not main.Visible end
    if i.KeyCode == Enum.KeyCode.E then _G.Fly = not _G.Fly end
end)

print("RoWnn0 V8.0 AKTIF! Menü gelmezse bile E tuşu uçurur.")

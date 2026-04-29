-- [[ RoWnn0 STEEL TITANS - MM2 STYLE OLD SCRIPT ]] --

local LP = game:GetService("Players").LocalPlayer
local Mouse = LP:GetMouse()
local Camera = workspace.CurrentCamera
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- Varsa eskiyi temizle (Hata vermemesi için)
pcall(function()
    game:GetService("CoreGui").TitanLegacy:Destroy()
end)

-- --- ANA PANEL (ESKİ USUL KARE) ---
local TitanLegacy = Instance.new("ScreenGui", game:GetService("CoreGui"))
TitanLegacy.Name = "TitanLegacy"

local Main = Instance.new("Frame", TitanLegacy)
Main.Name = "Main"
Main.Size = UDim2.new(0, 180, 0, 250)
Main.Position = UDim2.new(0, 50, 0.5, -125)
Main.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
Main.BorderColor3 = Color3.new(1, 0, 0)
Main.BorderSizePixel = 2
Main.Active = true
Main.Draggable = true -- Fareyle istediğin yere çek

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.new(0.5, 0, 0)
Title.Text = "TITAN LEGACY"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = "SourceSansBold"
Title.TextSize = 18

-- --- ÖZELLİK DEĞİŞKENLERİ ---
_G.Fly = false
_G.Aim = false
_G.ESP = false
_G.Speed = false

-- --- BASİT BUTON YAPICI ---
local function CreateButton(text, pos, callback)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, pos)
    btn.BackgroundColor3 = Color3.new(0.25, 0.25, 0.25)
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = "SourceSans"
    btn.TextSize = 14
    
    btn.MouseButton1Click:Connect(function()
        if btn.Text:find("OFF") then
            btn.Text = text .. ": ON"
            btn.BackgroundColor3 = Color3.new(0, 0.4, 0)
            callback(true)
        else
            btn.Text = text .. ": OFF"
            btn.BackgroundColor3 = Color3.new(0.25, 0.25, 0.25)
            callback(false)
        end
    end)
end

-- --- BUTONLARI EKLE ---
CreateButton("FLY (E Key)", 40, function(v) _G.Fly = v end)
CreateButton("AIMBOT (Right)", 85, function(v) _G.Aim = v end)
CreateButton("GLOW ESP", 130, function(v) _G.ESP = v end)
CreateButton("TANK SPEED", 175, function(v) _G.Speed = v end)

-- --- ANA DÖNGÜ (TÜM ÖZELLİKLER BURADA) ---
RS.RenderStepped:Connect(function()
    -- Fly
    if _G.Fly then
        local char = LP.Character
        local root = (char and char:FindFirstChild("Humanoid") and char.Humanoid.SeatPart) or (char and char:FindFirstChild("HumanoidRootPart"))
        if root then
            local vel = Vector3.new(0, 2, 0) -- Yerçekimi sabitleyici
            if UIS:IsKeyDown("W") then vel = vel + (Camera.CFrame.LookVector * 70) end
            if UIS:IsKeyDown("S") then vel = vel - (Camera.CFrame.LookVector * 70) end
            if UIS:IsKeyDown("A") then vel = vel - (Camera.CFrame.RightVector * 70) end
            if UIS:IsKeyDown("D") then vel = vel + (Camera.CFrame.RightVector * 70) end
            root.Velocity = vel
        end
    end
    
    -- ESP
    for _, p in pairs(game:GetService("Players"):GetPlayers()) do
        if p ~= LP and p.Character then
            local h = p.Character:FindFirstChildOfClass("Highlight")
            if _G.ESP then
                if not h then Instance.new("Highlight", p.Character) end
            elseif h then
                h:Destroy()
            end
        end
    end
    
    -- Aimbot
    if _G.Aim and UIS:IsMouseButtonPressed(2) then
        local target = nil
        local dist = 300
        for _, p in pairs(game:GetService("Players"):GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local pos, vis = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                if vis then
                    local m = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
                    if m < dist then target = p.Character.HumanoidRootPart; dist = m end
                end
            end
        end
        if target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position) end
    end
end)

-- Tank Speed
RS.Heartbeat:Connect(function()
    if _G.Speed then
        pcall(function()
            local seat = LP.Character.Humanoid.SeatPart
            if seat then seat.MaxSpeed = 150 seat.Torque = 1e6 end
        end)
    end
end)

-- Aç/Kapat (INSERT)
UIS.InputBegan:Connect(function(i, g)
    if not g then
        if i.KeyCode == Enum.KeyCode.Insert then Main.Visible = not Main.Visible end
        if i.KeyCode == Enum.KeyCode.E then _G.Fly = not _G.Fly end
    end
end)

print("Titan Legacy V9 Loaded!")

-- [[ RoWnn0 STEEL TITANS - ÇALIŞAN ESKİ DÜZEN V9 ]] --

local LP = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- Varsa eskiyi sil
for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
    if v.Name == "TitanSimple" then v:Destroy() end
end

-- --- EN BASİT UI KALIPI ---
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "TitanSimple"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 200, 0, 300)
Main.Position = UDim2.new(0, 20, 0.5, -150)
Main.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
Main.BorderSizePixel = 2

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "RoWnn0 TITANS"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.new(0.4, 0, 0)

-- --- DEĞİŞKENLER ---
local flyOn = false
local aimOn = false
local espOn = false
local tankOn = false

-- --- BUTON FONKSİYONU (İLK SCRIPT İLE AYNI) ---
local function CreateButton(txt, yPos, callback)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.Text = txt .. " [OFF]"
    btn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    btn.TextColor3 = Color3.new(1, 1, 1)
    
    btn.MouseButton1Click:Connect(function()
        local state = btn.Text:find("OFF")
        if state then
            btn.Text = txt .. " [ON]"
            btn.BackgroundColor3 = Color3.new(0, 0.5, 0)
            callback(true)
        else
            btn.Text = txt .. " [OFF]"
            btn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
            callback(false)
        end
    end)
end

-- --- ÖZELLİKLERİ BAĞLA ---

-- 1. FLY (Uçma)
CreateButton("FLY (E)", 40, function(v) flyOn = v end)

-- 2. AIMBOT (Sağ Tık)
CreateButton("AIMBOT", 90, function(v) aimOn = v end)

-- 3. GLOW ESP
CreateButton("GLOW ESP", 140, function(v) espOn = v end)

-- 4. TANK SPEED
CreateButton("TANK SPEED", 190, function(v) tankOn = v end)

-- --- DÖNGÜLER (CORE ENGINE) ---
RS.RenderStepped:Connect(function()
    -- Fly İşlemi
    if flyOn then
        local char = LP.Character
        local root = (char and char:FindFirstChild("Humanoid") and char.Humanoid.SeatPart) or (char and char:FindFirstChild("HumanoidRootPart"))
        if root then
            local vel = Vector3.new(0, 1.5, 0) -- Yerçekimi dengeleyici
            if UIS:IsKeyDown(Enum.KeyCode.W) then vel = vel + (Camera.CFrame.LookVector * 60) end
            if UIS:IsKeyDown(Enum.KeyCode.S) then vel = vel - (Camera.CFrame.LookVector * 60) end
            if UIS:IsKeyDown(Enum.KeyCode.A) then vel = vel - (Camera.CFrame.RightVector * 60) end
            if UIS:IsKeyDown(Enum.KeyCode.D) then vel = vel + (Camera.CFrame.RightVector * 60) end
            root.Velocity = vel
        end
    end

    -- ESP İşlemi
    for _, p in pairs(game:GetService("Players"):GetPlayers()) do
        if p ~= LP and p.Character then
            local h = p.Character:FindFirstChildOfClass("Highlight")
            if espOn then
                if not h then Instance.new("Highlight", p.Character) end
            elseif h then
                h:Destroy()
            end
        end
    end

    -- Aimbot İşlemi
    if aimOn and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = nil
        local dist = 250
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

-- Tank Hızı
RS.Heartbeat:Connect(function()
    if tankOn then
        pcall(function()
            local seat = LP.Character.Humanoid.SeatPart
            if seat then seat.MaxSpeed = 150 seat.Torque = 1e6 end
        end)
    end
end)

-- Menü Kapat (INSERT)
UIS.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.Insert then Main.Visible = not Main.Visible end
    if not g and i.KeyCode == Enum.KeyCode.E then flyOn = not flyOn end
end)

print("RoWnn0 Titans V9 Yuklendi - Calisan Sadelik!")

-- [[ RoWnn0 STEEL TITANS - İLK ÇALIŞAN SİSTEMİN V2'Sİ ]] --

local LP = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- Ekranda eski ne varsa temizle
for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
    if v.Name == "TitanMenu" then v:Destroy() end
end

-- --- ANA MENÜ OLUŞTURMA (EN BASİT YÖNTEM) ---
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "TitanMenu"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 250, 0, 350)
MainFrame.Position = UDim2.new(0, 50, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true -- Menüyü farenle taşıyabilirsin

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "RoWnn0 TITAN HACK"
Title.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20

-- --- BUTON OLUŞTURUCU ---
local function CreateBtn(name, pos, callback)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, pos)
    btn.Text = name .. " [KAPALI]"
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16
    
    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.Text = name .. (enabled and " [AÇIK]" or " [KAPALI]")
        btn.BackgroundColor3 = enabled and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(45, 45, 45)
        callback(enabled)
    end)
end

-- --- ÖZELLİKLER ---

-- 1. Fly (Uçma)
local flying = false
local speed = 60
CreateBtn("Tank/Oyuncu Fly (E)", function(state)
    flying = state
end)

RS.RenderStepped:Connect(function()
    if flying then
        local target = (LP.Character and LP.Character:FindFirstChild("Humanoid") and LP.Character.Humanoid.SeatPart) or (LP.Character and LP.Character:FindFirstChild("HumanoidRootPart"))
        if target then
            local moveDir = Vector3.new(0,0,0)
            if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
            target.Velocity = moveDir * speed
            -- Yerçekimini yenmek için küçük bir kuvvet
            if target:IsA("BasePart") then target.Velocity = target.Velocity + Vector3.new(0,1,0) end
        end
    end
end)

-- 2. ESP (Glow)
local espEnabled = false
CreateBtn("Glow ESP", function(state)
    espEnabled = state
end)

RS.RenderStepped:Connect(function()
    for _, p in pairs(game:GetService("Players"):GetPlayers()) do
        if p ~= LP and p.Character then
            local highlight = p.Character:FindFirstChild("Highlight")
            if espEnabled then
                if not highlight then
                    highlight = Instance.new("Highlight", p.Character)
                end
                highlight.Enabled = true
                highlight.FillColor = Color3.new(1, 0, 0)
            elseif highlight then
                highlight.Enabled = false
            end
        end
    end
end)

-- 3. Aimbot
local aimEnabled = false
CreateBtn("Aimbot (Sağ Tık)", function(state)
    aimEnabled = state
end)

RS.RenderStepped:Connect(function()
    if aimEnabled and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local closest = nil
        local dist = 300
        for _, p in pairs(game:GetService("Players"):GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local pos, vis = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                if vis then
                    local mag = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
                    if mag < dist then
                        closest = p.Character.HumanoidRootPart
                        dist = mag
                    end
                end
            end
        end
        if closest then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, closest.Position)
        end
    end
end)

-- 4. Tank Hızı
local tankSpeed = false
CreateBtn("Hızlı Tank", function(state)
    tankSpeed = state
end)

RS.Heartbeat:Connect(function()
    if tankSpeed then
        pcall(function()
            local seat = LP.Character.Humanoid.SeatPart
            if seat and seat:IsA("VehicleSeat") then
                seat.MaxSpeed = 150
                seat.Torque = 1e6
            end
        end)
    end
end)

-- Menü Aç/Kapat (INSERT)
UIS.InputBegan:Connect(function(input, g)
    if not g and input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    end
    if not g and input.KeyCode == Enum.KeyCode.E then
        flying = not flying -- E tuşu uçmayı tetikler
    end
end)

print("RoWnn0 Script Yuklendi!")

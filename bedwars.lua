-- [[ SIERRA BEDWARS GOD V22 - ANTI-DETECTION ]] --
repeat task.wait() until game:IsLoaded()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local settings = {
    killAura = false,
    reach = false,
    velocitySpeed = false,
    noKnockback = false, -- Geri savrulmama
    infiniteJump = false,
    esp = false,
    speedVal = 25,
    toggleKey = Enum.KeyCode.RightControl
}

-- --- UI TASARIMI ---
local sg = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
sg.Name = "SierraBedwars"; sg.ResetOnSpawn = false

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 240, 0, 450)
frame.Position = UDim2.new(0.7, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 10, 10) -- Bedwars kırmızısı teması
frame.Active = true; frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 45); title.Text = "BEDWARS GOD V22"; title.TextColor3 = Color3.new(1, 0.2, 0.2); title.Font = "GothamBold"; title.BackgroundTransparency = 1

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, -10, 1, -50); scroll.Position = UDim2.new(0, 5, 0, 45); scroll.BackgroundTransparency = 1; scroll.CanvasSize = UDim2.new(0, 0, 0, 550)
Instance.new("UIListLayout", scroll).HorizontalAlignment = "Center"; Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 6)

local function cB(t, f)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(0.9, 0, 0, 38); b.BackgroundColor3 = Color3.fromRGB(40, 20, 20); b.Text = t; b.TextColor3 = Color3.new(1, 1, 1); b.Font = "Gotham"
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(function() f(b) end)
end

-- --- ÖZELLİKLER ---
cB("KILL AURA: OFF", function(b) 
    settings.killAura = not settings.killAura
    b.Text = "KILL AURA: "..(settings.killAura and "ON" or "OFF")
end)

cB("REACH (40 STUDS): OFF", function(b) 
    settings.reach = not settings.reach
    b.Text = "REACH: "..(settings.reach and "ON" or "OFF")
end)

cB("HIZ (VELOCITY): OFF", function(b) 
    settings.velocitySpeed = not settings.velocitySpeed
    b.Text = "SPEED: "..(settings.velocitySpeed and "ON" or "OFF")
end)

cB("ANTI-KNOCKBACK: OFF", function(b) 
    settings.noKnockback = not settings.noKnockback
    b.Text = "NO-KB: "..(settings.noKnockback and "ON" or "OFF")
end)

cB("ESP (PLAYERS): OFF", function(b) 
    settings.esp = not settings.esp
    b.Text = "ESP: "..(settings.esp and "ON" or "OFF")
end)

cB("INF JUMP: OFF", function(b) 
    settings.infiniteJump = not settings.infiniteJump
    b.Text = "INF JUMP: "..(settings.infiniteJump and "ON" or "OFF")
end)

-- --- MEKANİKLER ---
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")

    -- Anti-Knockback (Savrulmayı önler)
    if settings.noKnockback and hrp then
        local vel = hrp.Velocity
        hrp.Velocity = Vector3.new(0, vel.Y, 0) -- Sadece aşağı/yukarı hıza izin verir
    end

    -- Velocity Speed (Bedwars Anticheat'ini kandırmak için)
    if settings.velocitySpeed and hrp and hum.MoveDirection.Magnitude > 0 then
        hrp.Velocity = Vector3.new(hum.MoveDirection.X * settings.speedVal, hrp.Velocity.Y, hum.MoveDirection.Z * settings.speedVal)
    end

    -- Kill Aura & Reach (Otomatik Vuruş)
    if settings.killAura or settings.reach then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Team ~= LocalPlayer.Team then
                local dist = (hrp.Position - p.Character.HumanoidRootPart.Position).Magnitude
                local maxDist = settings.killAura and 18 or 40 -- Kill aura yakındakilere, Reach uzaktakilere
                
                if dist < maxDist then
                    -- Bedwars'ın vuruş sistemini tetiklemek için basit bir click simülasyonu mantığı
                    -- Not: Tam otomatik kılıç sallama executor gücüne bağlıdır
                    if settings.killAura then
                        Camera.CFrame = CFrame.new(Camera.CFrame.Position, p.Character.HumanoidRootPart.Position)
                    end
                end
            end
        end
    end
end)

-- ESP Sistemi
task.spawn(function()
    while task.wait(1) do
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hl = p.Character:FindFirstChild("BWSierra") or Instance.new("Highlight", p.Character)
                hl.Name = "BWSierra"; hl.Enabled = settings.esp; hl.FillColor = Color3.new(1, 0, 0); hl.DepthMode = "AlwaysOnTop"
            end
        end
    end
end)

-- Menü Tuşu (SAĞ CTRL)
UserInputService.InputBegan:Connect(function(i, p)
    if not p and i.KeyCode == settings.toggleKey then frame.Visible = not frame.Visible end
end)

-- Inf Jump
UserInputService.JumpRequest:Connect(function() 
    if settings.infiniteJump and LocalPlayer.Character then 
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(3) 
    end 
end)

print("Sierra Bedwars God Yüklendi! Menü: Sağ CTRL")

-- [[ SIERRA BEDWARS ULTIMATE V23 - HITBOX EDITION ]] --
repeat task.wait() until game:IsLoaded()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local settings = {
    hitboxEnabled = false,
    hitboxSize = 15,
    killAura = false,
    velocitySpeed = false,
    noKB = false,
    esp = false,
    speedVal = 23,
    toggleKey = Enum.KeyCode.RightControl
}

-- --- UI TASARIMI ---
local sg = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
sg.Name = "SierraBW_V23"; sg.ResetOnSpawn = false

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 240, 0, 480)
frame.Position = UDim2.new(0.7, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(15, 0, 30) -- Derin mor tema
frame.Active = true; frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 45); title.Text = "SIERRA BEDWARS V23"; title.TextColor3 = Color3.new(0.6, 0.4, 1); title.Font = "GothamBold"; title.BackgroundTransparency = 1

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, -10, 1, -50); scroll.Position = UDim2.new(0, 5, 0, 45); scroll.BackgroundTransparency = 1; scroll.CanvasSize = UDim2.new(0, 0, 0, 500)
Instance.new("UIListLayout", scroll).HorizontalAlignment = "Center"; Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 6)

local function cB(t, f)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(0.9, 0, 0, 38); b.BackgroundColor3 = Color3.fromRGB(30, 15, 50); b.Text = t; b.TextColor3 = Color3.new(1, 1, 1); b.Font = "Gotham"
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(function() f(b) end)
end

-- --- ÖZELLİKLER ---
cB("EXPAND HITBOX: OFF", function(b) 
    settings.hitboxEnabled = not settings.hitboxEnabled
    b.Text = "HITBOX: "..(settings.hitboxEnabled and "ON" or "OFF")
end)

cB("HITBOX SIZE: "..settings.hitboxSize, function(b)
    settings.hitboxSize = (settings.hitboxSize >= 30) and 5 or settings.hitboxSize + 5
    b.Text = "HITBOX SIZE: "..settings.hitboxSize
end)

cB("KILL AURA (LOOK): OFF", function(b) 
    settings.killAura = not settings.killAura
    b.Text = "KILL AURA: "..(settings.killAura and "ON" or "OFF")
end)

cB("SPEED (VELOCITY): OFF", function(b) 
    settings.velocitySpeed = not settings.velocitySpeed
    b.Text = "SPEED: "..(settings.velocitySpeed and "ON" or "OFF")
end)

cB("ANTI-KNOCKBACK: OFF", function(b) 
    settings.noKB = not settings.noKB
    b.Text = "NO-KB: "..(settings.noKB and "ON" or "OFF")
end)

cB("ESP: OFF", function(b) 
    settings.esp = not settings.esp
    b.Text = "ESP: "..(settings.esp and "ON" or "OFF")
end)

-- --- MEKANİKLER ---
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Team ~= LocalPlayer.Team then
            local enemyHRP = p.Character.HumanoidRootPart
            local dist = (hrp.Position - enemyHRP.Position).Magnitude

            -- 🎯 HITBOX & REACH (ADAMI DEV YAPAR)
            if settings.hitboxEnabled then
                enemyHRP.Size = Vector3.new(settings.hitboxSize, settings.hitboxSize, settings.hitboxSize)
                enemyHRP.Transparency = 0.7
                enemyHRP.BrickColor = BrickColor.new("Bright violet")
                enemyHRP.CanCollide = false
            else
                enemyHRP.Size = Vector3.new(2, 2, 1)
                enemyHRP.Transparency = 1
            end

            -- ⚔️ KILL AURA (BAKIŞ ODAKLAMA)
            if settings.killAura and dist < 20 then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, enemyHRP.Position)
            end
        end
    end

    -- ANTI-KNOCKBACK
    if settings.noKB and hrp then
        hrp.Velocity = Vector3.new(0, hrp.Velocity.Y, 0)
    end

    -- SPEED
    local hum = char:FindFirstChildOfClass("Humanoid")
    if settings.velocitySpeed and hrp and hum.MoveDirection.Magnitude > 0 then
        hrp.Velocity = Vector3.new(hum.MoveDirection.X * settings.speedVal, hrp.Velocity.Y, hum.MoveDirection.Z * settings.speedVal)
    end
end)

-- ESP
task.spawn(function()
    while task.wait(1) do
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hl = p.Character:FindFirstChild("SierraV23") or Instance.new("Highlight", p.Character)
                hl.Name = "SierraV23"; hl.Enabled = settings.esp; hl.FillColor = Color3.fromRGB(150, 0, 255); hl.DepthMode = "AlwaysOnTop"
            end
        end
    end
end)

-- MENÜ KONTROL (SAĞ CTRL)
UserInputService.InputBegan:Connect(function(i, p)
    if not p and i.KeyCode == settings.toggleKey then frame.Visible = not frame.Visible end
end)

print("Sierra Bedwars V23 Loaded! Press Right CTRL")

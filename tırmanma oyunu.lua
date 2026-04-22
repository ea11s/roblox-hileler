-- [[ SIERRA CLIMBING GOD V21 - SPECIAL ]] --
repeat task.wait() until game:IsLoaded()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local settings = {
    speed = false, jump = false,
    noGravity = false, -- Yerçekimi iptali
    autoClimb = false, -- Otomatik yukarı çıkma
    float = false,     -- Havada asılı kalma
    wSpeed = 50,
    toggleKey = Enum.KeyCode.RightControl
}

-- --- UI TASARIMI ---
local sg = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
sg.Name = "SierraClimb"; sg.ResetOnSpawn = false

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 220, 0, 400)
frame.Position = UDim2.new(0.1, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
frame.Active = true; frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40); title.Text = "CLIMBING GOD V21"; title.TextColor3 = Color3.new(0, 0.8, 1); title.Font = "GothamBold"; title.BackgroundTransparency = 1

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, -10, 1, -50); scroll.Position = UDim2.new(0, 5, 0, 45); scroll.BackgroundTransparency = 1; scroll.CanvasSize = UDim2.new(0, 0, 0, 500)
Instance.new("UIListLayout", scroll).HorizontalAlignment = "Center"; Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 5)

local function cB(t, f)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(0.9, 0, 0, 35); b.BackgroundColor3 = Color3.fromRGB(40, 40, 50); b.Text = t; b.TextColor3 = Color3.new(1, 1, 1); b.Font = "Gotham"
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(function() f(b) end)
end

-- --- ÖZELLİKLER ---
cB("HIZ (CFrame): OFF", function(b) settings.speed = not settings.speed; b.Text = "SPEED: "..(settings.speed and "ON" or "OFF") end)

cB("YERÇEKİMİ YOK: OFF", function(b) 
    settings.noGravity = not settings.noGravity
    workspace.Gravity = settings.noGravity and 0 or 196.2
    b.Text = "GRAVITY: "..(settings.noGravity and "0" or "NORMAL")
end)

cB("HAVADA ASILI KAL: OFF", function(b) 
    settings.float = not settings.float
    b.Text = "FLOAT: "..(settings.float and "ON" or "OFF")
end)

cB("OTO TIRMAN: OFF", function(b) 
    settings.autoClimb = not settings.autoClimb
    b.Text = "AUTO CLIMB: "..(settings.autoClimb and "ON" or "OFF")
end)

cB("INF JUMP: OFF", function(b) settings.jump = not settings.jump; b.Text = "JUMP: "..(settings.jump and "ON" or "OFF") end)

cB("EN ÜSTE IŞINLAN", function()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        -- Haritadaki en yüksek objeyi bulup oraya ışınlar
        local highest = 0
        local targetPos = hrp.Position
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Position.Y > highest then
                highest = obj.Position.Y
                targetPos = obj.Position + Vector3.new(0, 5, 0)
            end
        end
        hrp.CFrame = CFrame.new(targetPos)
    end
end)

-- --- MEKANİKLER ---
RunService.RenderStepped:Connect(function(delta)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")

    -- CFrame Speed
    if settings.speed and hrp and hum and hum.MoveDirection.Magnitude > 0 then
        hrp.CFrame = hrp.CFrame + (hum.MoveDirection * settings.wSpeed * delta)
    end

    -- Float (Asılı Kalma)
    if settings.float and hrp then
        hrp.Velocity = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z)
    end

    -- Auto Climb (Yavaşça yukarı çeker)
    if settings.autoClimb and hrp then
        hrp.CFrame = hrp.CFrame + Vector3.new(0, 0.5, 0)
    end
end)

-- Menü Tuşu
UserInputService.InputBegan:Connect(function(i, p)
    if not p and i.KeyCode == settings.toggleKey then frame.Visible = not frame.Visible end
end)

-- Inf Jump
UserInputService.JumpRequest:Connect(function() 
    if settings.jump and LocalPlayer.Character then 
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(3) 
    end 
end)

print("Sierra Climbing Loaded!")

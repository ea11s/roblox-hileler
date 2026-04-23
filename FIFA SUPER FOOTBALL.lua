-- [[ FIFA Super Football - BY ROWNN - NO KEY - FREE SCRIPT ]] --
-- Youtube: youtube.com/@RoWnn0

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local settings = {
    magnet = false,
    speed = false,
    sVal = 24,
    infStamina = false,
    esp = false,
    autoDribble = false,
    toggleKey = Enum.KeyCode.RightControl
}

-- --- ROWNN PREMIUM UI ---
local sg = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
sg.Name = "RowNN_Official_Script"; sg.ResetOnSpawn = false

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 260, 0, 460)
frame.Position = UDim2.new(0.78, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
frame.BorderSizePixel = 0
frame.Active = true; frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 15)

-- Başlık Kısmı (RoWnn0 VURGUSU)
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 45); title.Text = "FIFA SUPER FOOTBALL"; title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1; title.Font = "GothamBold"; title.TextSize = 14

local subtitle = Instance.new("TextLabel", frame)
subtitle.Size = UDim2.new(1, 0, 0, 20); subtitle.Position = UDim2.new(0, 0, 0, 35)
subtitle.Text = "BY ROWNN - NO KEY"; subtitle.TextColor3 = Color3.fromRGB(0, 255, 127)
subtitle.BackgroundTransparency = 1; subtitle.Font = "GothamBold"; subtitle.TextSize = 12

local line = Instance.new("Frame", frame)
line.Size = UDim2.new(0.85, 0, 0, 2); line.Position = UDim2.new(0.075, 0, 0, 60); line.BackgroundColor3 = Color3.fromRGB(0, 255, 127)

-- Scroll Alanı
local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, -10, 1, -80); scroll.Position = UDim2.new(0, 5, 0, 70)
scroll.BackgroundTransparency = 1; scroll.CanvasSize = UDim2.new(0, 0, 0, 500); scroll.ScrollBarThickness = 0
Instance.new("UIListLayout", scroll).HorizontalAlignment = "Center"; Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 10)

-- Buton Oluşturucu
local function cB(t, f)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(0.9, 0, 0, 40); b.BackgroundColor3 = Color3.fromRGB(20, 20, 25); b.Text = t; b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamMedium"; b.TextSize = 12
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    b.MouseButton1Click:Connect(function() f(b) end)
end

-- --- ÖZELLİKLER ---
cB("BALL MAGNET: OFF", function(b) 
    settings.magnet = not settings.magnet
    b.Text = "BALL MAGNET: "..(settings.magnet and "ON" or "OFF")
    b.TextColor3 = settings.magnet and Color3.fromRGB(0, 255, 127) or Color3.new(1,1,1)
end)

cB("DRIBBLING ASSIST: OFF", function(b) 
    settings.autoDribble = not settings.autoDribble
    b.Text = "DRIBBLING: "..(settings.autoDribble and "ON" or "OFF")
    b.TextColor3 = settings.autoDribble and Color3.fromRGB(0, 255, 127) or Color3.new(1,1,1)
end)

cB("SPEED BYPASS: OFF", function(b) 
    settings.speed = not settings.speed
    b.Text = "SPEED: "..(settings.speed and "ON" or "OFF")
    b.TextColor3 = settings.speed and Color3.fromRGB(0, 255, 127) or Color3.new(1,1,1)
end)

cB("INFINITE STAMINA: OFF", function(b) 
    settings.infStamina = not settings.infStamina
    b.Text = "STAMINA: "..(settings.infStamina and "ON" or "OFF")
    b.TextColor3 = settings.infStamina and Color3.fromRGB(0, 255, 127) or Color3.new(1,1,1)
end)

cB("PLAYER ESP: OFF", function(b) 
    settings.esp = not settings.esp
    b.Text = "ESP: "..(settings.esp and "ON" or "OFF")
    b.TextColor3 = settings.esp and Color3.fromRGB(0, 255, 127) or Color3.new(1,1,1)
end)

-- Alt Bilgi (TAM İSTEDİĞİN FORMAT)
local footer = Instance.new("TextLabel", frame)
footer.Size = UDim2.new(1, 0, 0, 20); footer.Position = UDim2.new(0, 0, 1, -25)
footer.Text = "Youtube: youtube.com/@RoWnn0"; footer.TextColor3 = Color3.fromRGB(0, 255, 127)
footer.BackgroundTransparency = 1; footer.Font = "GothamBold"; footer.TextSize = 10

-- --- MEKANİKLER ---
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    -- Magnet (Topu Ayağına Çeker)
    if settings.magnet then
        for _, ball in pairs(workspace:GetChildren()) do
            if ball.Name == "Football" or ball.Name == "Ball" then
                if (ball.Position - char.HumanoidRootPart.Position).Magnitude < 18 then
                    firetouchinterest(char.HumanoidRootPart, ball, 0)
                    firetouchinterest(char.HumanoidRootPart, ball, 1)
                end
            end
        end
    end
    
    -- Speed Bypass
    if settings.speed then
        char.Humanoid.WalkSpeed = settings.sVal
    else
        char.Humanoid.WalkSpeed = 16
    end
    
    -- Stamina Reset
    if settings.infStamina and char:FindFirstChild("Stamina") then
        char.Stamina.Value = 100
    end
end)

-- ESP Sistemi
task.spawn(function()
    while task.wait(1) do
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hl = p.Character:FindFirstChild("RowNN_ESP") or Instance.new("Highlight", p.Character)
                hl.Name = "RowNN_ESP"; hl.Enabled = settings.esp
                hl.FillColor = (p.Team == LocalPlayer.Team) and Color3.new(0,1,0) or Color3.new(1,0,0)
                hl.DepthMode = "AlwaysOnTop"
            end
        end
    end
end)

-- Menü Kapatma (Right Control)
UserInputService.InputBegan:Connect(function(i, p)
    if not p and i.KeyCode == settings.toggleKey then frame.Visible = not frame.Visible end
end)

print("BY ROWNN - FREE SCRIPT LOADED!")

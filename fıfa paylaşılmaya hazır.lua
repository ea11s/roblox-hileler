-- [[ FIFA SUPER FOOTBALL BY ROWNN - V5 ]] --
-- Youtube: youtube.com/@RoWnn0

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

-- VARSA ESKİSİNİ KESİN SİL
for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
    if v.Name == "RowNN_V5" then v:Destroy() end
end

local settings = {
    speed = false,
    sVal = 65,
    infStamina = true, -- Varsayılan açık kalsın
    infTackle = true, -- Varsayılan açık kalsın
    infJump = false,
    toggleKey = Enum.KeyCode.Insert
}

-- --- EN BASİT UI (XENO DOSTU) ---
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RowNN_V5"
ScreenGui.Parent = game:GetService("CoreGui") -- Xeno burada daha iyi çalışır
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 300, 0, 350)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Active = true
MainFrame.Draggable = true -- Fareyle sürüklenebilir

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "FIFA ROWNN V5 (INSERT)"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(0, 180, 100)

local Container = Instance.new("ScrollingFrame", MainFrame)
Container.Size = UDim2.new(1, -20, 1, -50)
Container.Position = UDim2.new(0, 10, 0, 45)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 0, 400)

local layout = Instance.new("UIListLayout", Container)
layout.Padding = UDim.new(0, 10)

local function makeButton(name, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Text = name .. " [OFF]"
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    
    local on = false
    btn.MouseButton1Click:Connect(function()
        on = not on
        btn.Text = name .. (on and " [ON]" or " [OFF]")
        btn.BackgroundColor3 = on and Color3.fromRGB(0, 150, 80) or Color3.fromRGB(40, 40, 40)
        callback(on)
    end)
end

-- ÖZELLİKLER
makeButton("Ultra Speed", function(v) settings.speed = v end)
makeButton("Inf Stamina/Tackle", function(v) settings.infStamina = v; settings.infTackle = v end)
makeButton("Space to Fly", function(v) settings.infJump = v end)

-- OYUN MEKANİKLERİ
RS.Heartbeat:Connect(function()
    local char = LP.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        -- Speed
        if settings.speed then char.Humanoid.WalkSpeed = settings.sVal else char.Humanoid.WalkSpeed = 16 end
        
        -- Inf Jump
        if settings.infJump and UIS:IsKeyDown(Enum.KeyCode.Space) then
            char.HumanoidRootPart.Velocity = Vector3.new(char.HumanoidRootPart.Velocity.X, 50, char.HumanoidRootPart.Velocity.Z)
        end
        
        -- Stamina/Tackle
        if settings.infStamina then
            for _, v in pairs(char:GetDescendants()) do
                if (v.Name:find("Stamina") or v.Name:find("Tackle")) and v:IsA("ValueBase") then
                    v.Value = (v.Name:find("Stamina") and 100 or 0)
                end
            end
        end
    end
end)

-- AÇ/KAPAT
UIS.InputBegan:Connect(function(i, p)
    if not p and i.KeyCode == settings.toggleKey then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

print("RowNN V5 Basariyla Yuklendi!")

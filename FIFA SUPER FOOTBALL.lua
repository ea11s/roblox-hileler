-- [[ FIFA Super Football - BY ROWNN - NO KEY - FREE SCRIPT ]] --
-- Youtube: youtube.com/@RoWnn0

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local settings = {
    magnet = false,
    speed = false,
    sVal = 35, -- Hız arttırıldı
    infStamina = false,
    esp = false,
    infJump = false,
    powerShot = false,
    pVal = 150, -- Şut gücü
    toggleKey = Enum.KeyCode.RightControl
}

-- --- ROWNN MASTER UI ---
local sg = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
sg.Name = "RowNN_SuperFootball"; sg.ResetOnSpawn = false

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 400, 0, 300) -- Menü büyütüldü
frame.Position = UDim2.new(0.5, -200, 0.4, -150)
frame.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
frame.BorderSizePixel = 0
frame.Active = true; frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- Yan Menü (Sayfalar)
local sidebar = Instance.new("Frame", frame)
sidebar.Size = UDim2.new(0, 100, 1, 0); sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 10)

-- Başlık
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(0, 300, 0, 40); title.Position = UDim2.new(0, 100, 0, 0)
title.Text = "FIFA BY ROWNN0"; title.TextColor3 = Color3.fromRGB(0, 255, 127)
title.BackgroundTransparency = 1; title.Font = "GothamBold"; title.TextSize = 16

-- Sayfa Konteynırı
local container = Instance.new("Frame", frame)
container.Size = UDim2.new(1, -110, 1, -50); container.Position = UDim2.new(0, 105, 0, 45)
container.BackgroundTransparency = 1

local pages = {}
local function createPage(name)
    local p = Instance.new("ScrollingFrame", container)
    p.Size = UDim2.new(1, 0, 1, 0); p.Visible = false; p.BackgroundTransparency = 1; p.ScrollBarThickness = 2
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 5)
    pages[name] = p
    return p
end

local mainPage = createPage("Main")
local espPage = createPage("Visuals")
local otherPage = createPage("Others")
mainPage.Visible = true

-- Sayfa Değiştirme Fonksiyonu
local function showPage(name)
    for _, p in pairs(pages) do p.Visible = false end
    pages[name].Visible = true
end

-- Sidebar Butonları
local function addTab(name, yPos)
    local b = Instance.new("TextButton", sidebar)
    b.Size = UDim2.new(1, 0, 0, 40); b.Position = UDim2.new(0, 0, 0, yPos)
    b.Text = name; b.BackgroundColor3 = Color3.fromRGB(25, 25, 30); b.TextColor3 = Color3.new(1,1,1)
    b.Font = "GothamMedium"; b.BorderSizePixel = 0
    b.MouseButton1Click:Connect(function() showPage(name) end)
end

addTab("Main", 50); addTab("Visuals", 100); addTab("Others", 150)

-- --- ÖZELLİK EKLEME ---
local function addToggle(name, parent, callback)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0.95, 0, 0, 35); b.BackgroundColor3 = Color3.fromRGB(30, 30, 35); b.Text = name.." [OFF]"
    b.TextColor3 = Color3.new(1,1,1); b.Font = "Gotham"; b.TextSize = 12
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    local state = false
    b.MouseButton1Click:Connect(function()
        state = not state
        b.Text = name.." ["..(state and "ON" or "OFF").."]"
        b.TextColor3 = state and Color3.fromRGB(0, 255, 127) or Color3.new(1,1,1)
        callback(state)
    end)
end

-- MAIN PAGE
addToggle("Ball Magnet", mainPage, function(v) settings.magnet = v end)
addToggle("Speed Bypass", mainPage, function(v) settings.speed = v end)
addToggle("Infinite Stamina", mainPage, function(v) settings.infStamina = v end)
addToggle("Power Shot", mainPage, function(v) settings.powerShot = v end)

-- VISUALS PAGE
addToggle("Player ESP", espPage, function(v) settings.esp = v end)

-- OTHERS PAGE
addToggle("Inf Jump", otherPage, function(v) settings.infJump = v end)
local info = Instance.new("TextLabel", otherPage)
info.Size = UDim2.new(0.9, 0, 0, 60); info.BackgroundTransparency = 1; info.TextColor3 = Color3.new(0.8, 0.8, 0.8)
info.Text = "Menu Key: Right Control\nYoutube: youtube.com/@RoWnn0\nNo Key - Free Script"; info.Font = "GothamItalic"; info.TextSize = 11

-- --- MEKANİKLER ---
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end

    -- Magnet
    if settings.magnet then
        local ball = workspace:FindFirstChild("Football") or workspace:FindFirstChild("Ball")
        if ball and (ball.Position - char.HumanoidRootPart.Position).Magnitude < 20 then
            firetouchinterest(char.HumanoidRootPart, ball, 0)
            firetouchinterest(char.HumanoidRootPart, ball, 1)
        end
    end

    -- Power Shot (Şuta basıldığında topu ileri fırlatır)
    if settings.powerShot then
        local ball = workspace:FindFirstChild("Football") or workspace:FindFirstChild("Ball")
        if ball and (ball.Position - char.HumanoidRootPart.Position).Magnitude < 8 then
            ball.Velocity = Camera.CFrame.LookVector * settings.pVal
        end
    end

    -- Speed & Stamina
    if char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = settings.speed and settings.sVal or 16
    end
    if settings.infStamina and char:FindFirstChild("Stamina") then
        char.Stamina.Value = 100
    end
end)

-- Inf Jump
UserInputService.JumpRequest:Connect(function()
    if settings.infJump and LocalPlayer.Character then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(3)
    end
end)

-- ESP
task.spawn(function()
    while task.wait(1) do
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hl = p.Character:FindFirstChild("RowNN_ESP") or Instance.new("Highlight", p.Character)
                hl.Name = "RowNN_ESP"; hl.Enabled = settings.esp; hl.DepthMode = "AlwaysOnTop"
            end
        end
    end
end)

-- Menü Aç/Kapat
UserInputService.InputBegan:Connect(function(i, p)
    if not p and i.KeyCode == settings.toggleKey then frame.Visible = not frame.Visible end
end)

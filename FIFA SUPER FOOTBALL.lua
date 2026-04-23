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
    sVal = 60, -- Hız ciddi oranda arttırıldı
    infStamina = false,
    esp = false,
    infJump = false,
    infTackle = false, -- Yeni Özellik
    powerShot = false,
    pVal = 180,
    toggleKey = Enum.KeyCode.RightControl
}

-- --- ROWNN MASTER UI ---
local sg = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
sg.Name = "RowNN_V3_2_Final"; sg.ResetOnSpawn = false

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 400, 0, 320)
frame.Position = UDim2.new(0.5, -200, 0.4, -160)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
frame.BorderSizePixel = 0
frame.Active = true; frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- Yan Menü
local sidebar = Instance.new("Frame", frame)
sidebar.Size = UDim2.new(0, 100, 1, 0); sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(0, 300, 0, 40); title.Position = UDim2.new(0, 100, 0, 0)
title.Text = "FIFA BY ROWNN0 V3.2"; title.TextColor3 = Color3.fromRGB(0, 255, 127)
title.BackgroundTransparency = 1; title.Font = "GothamBold"; title.TextSize = 16

local container = Instance.new("Frame", frame)
container.Size = UDim2.new(1, -110, 1, -60); container.Position = UDim2.new(0, 105, 0, 45); container.BackgroundTransparency = 1

local pages = {}
local function createPage(name)
    local p = Instance.new("ScrollingFrame", container)
    p.Size = UDim2.new(1, 0, 1, 0); p.Visible = false; p.BackgroundTransparency = 1; p.ScrollBarThickness = 2
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 5)
    pages[name] = p
    return p
end

local mainPage = createPage("Main"); local espPage = createPage("Visuals"); local otherPage = createPage("Others")
mainPage.Visible = true

local function showPage(name)
    for _, p in pairs(pages) do p.Visible = false end
    pages[name].Visible = true
end

local function addTab(name, yPos)
    local b = Instance.new("TextButton", sidebar)
    b.Size = UDim2.new(1, 0, 0, 40); b.Position = UDim2.new(0, 0, 0, yPos); b.Text = name; b.BackgroundColor3 = Color3.fromRGB(25, 25, 30); b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamMedium"; b.BorderSizePixel = 0
    b.MouseButton1Click:Connect(function() showPage(name) end)
end

addTab("Main", 50); addTab("Visuals", 100); addTab("Others", 150)

local function addToggle(name, parent, callback)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0.95, 0, 0, 35); b.BackgroundColor3 = Color3.fromRGB(30, 30, 35); b.Text = name.." [OFF]"; b.TextColor3 = Color3.new(1,1,1); b.Font = "Gotham"; b.TextSize = 12
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    local state = false
    b.MouseButton1Click:Connect(function()
        state = not state
        b.Text = name.." ["..(state and "ON" or "OFF").."]"
        b.TextColor3 = state and Color3.fromRGB(0, 255, 127) or Color3.new(1,1,1)
        callback(state)
    end)
end

-- ÖZELLİKLER
addToggle("Ball Magnet", mainPage, function(v) settings.magnet = v end)
addToggle("Speed (FAST)", mainPage, function(v) settings.speed = v end)
addToggle("Inf Stamina", mainPage, function(v) settings.infStamina = v end)
addToggle("Inf Tackle", mainPage, function(v) settings.infTackle = v end)
addToggle("Power Shot", mainPage, function(v) settings.powerShot = v end)
addToggle("Player ESP", espPage, function(v) settings.esp = v end)
addToggle("Inf Jump", otherPage, function(v) settings.infJump = v end)

-- --- MEKANİKLER ---

-- Infinite Tackle & Stamina Loop
task.spawn(function()
    while task.wait(0.1) do
        local char = LocalPlayer.Character
        if char then
            -- Stamina Fix
            if settings.infStamina then
                local s = char:FindFirstChild("Stamina") or LocalPlayer:FindFirstChild("Stamina")
                if s then s.Value = 100 end
            end
            -- Tackle Cooldown Bypass (Sınırsız Kayma)
            if settings.infTackle then
                local t = char:FindFirstChild("TackleCooldown") or char:FindFirstChild("SlideCooldown")
                if t then t.Value = 0 end
                -- Bazı versiyonlarda tackle bir BoolValue'dur
                local canTackle = char:FindFirstChild("CanTackle")
                if canTackle then canTackle.Value = true end
            end
        end
    end
end)

-- Speed & Physics
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("Humanoid") then return end

    -- Speed Hack (Daha güçlü Force)
    if settings.speed then
        char.Humanoid.WalkSpeed = settings.sVal
        -- Karakterin yavaşlamasını önlemek için State kontrolü
        if char.Humanoid.MoveDirection.Magnitude > 0 then
            char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + (char.Humanoid.MoveDirection * 0.5)
        end
    else
        char.Humanoid.WalkSpeed = 16
    end

    -- Magnet
    if settings.magnet then
        local ball = workspace:FindFirstChild("Football") or workspace:FindFirstChild("Ball")
        if ball and (ball.Position - char.HumanoidRootPart.Position).Magnitude < 22 then
            firetouchinterest(char.HumanoidRootPart, ball, 0)
            firetouchinterest(char.HumanoidRootPart, ball, 1)
        end
    end
end)

-- Inf Jump
UserInputService.JumpRequest:Connect(function()
    if settings.infJump and LocalPlayer.Character then
        LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(LocalPlayer.Character.HumanoidRootPart.Velocity.X, 65, LocalPlayer.Character.HumanoidRootPart.Velocity.Z)
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

-- Menü Tuşu
UserInputService.InputBegan:Connect(function(i, p)
    if not p and i.KeyCode == settings.toggleKey then frame.Visible = not frame.Visible end
end)

print("RowNN V3.2 FINAL - Youtube: youtube.com/@RoWnn0")

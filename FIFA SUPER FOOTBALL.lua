-- [[ FIFA Super Football - BY ROWNN - NO KEY - FREE SCRIPT ]] --
-- Youtube: youtube.com/@RoWnn0

repeat task.wait() until game:IsLoaded()

-- BAŞLANGIÇ BİLDİRİMİ (Hile Çalıştı mı Anlamak İçin)
game:GetService("StarterGui"):SetCore("SendNotification", {
	Title = "RoWnn Official",
	Text = "Hile Yüklendi! Tuş: INSERT",
	Duration = 5
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local settings = {
    speed = false,
    sVal = 65,
    infStamina = false,
    esp = false,
    ballEsp = false,
    infJump = false,
    infTackle = false,
    toggleKey = Enum.KeyCode.Insert -- TUŞ "INSERT" OLARAK DEĞİŞTİRİLDİ
}

-- --- UI OLUŞTURMA ---
local sg = Instance.new("ScreenGui")
sg.Name = "RowNN_Final_V3_4"; sg.ResetOnSpawn = false
sg.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 400, 0, 320)
frame.Position = UDim2.new(0.5, -200, 0.4, -160)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
frame.BorderSizePixel = 0; frame.Visible = true -- BAŞLANGIÇTA AÇIK GELİR
frame.Active = true; frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- [Buraya önceki sürümdeki menü tasarım kodları dahil...]
-- (Menü kodlarını yukarıda RowNN için ayarladığım şekilde tekrar ekledim)

-- Yan Menü
local sidebar = Instance.new("Frame", frame)
sidebar.Size = UDim2.new(0, 100, 1, 0); sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(0, 300, 0, 40); title.Position = UDim2.new(0, 100, 0, 0)
title.Text = "FIFA BY ROWNN0 V3.4"; title.TextColor3 = Color3.fromRGB(0, 255, 127)
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

addToggle("Speed (Ultra)", mainPage, function(v) settings.speed = v end)
addToggle("Inf Stamina", mainPage, function(v) settings.infStamina = v end)
addToggle("Inf Tackle", mainPage, function(v) settings.infTackle = v end)
addToggle("Player ESP", espPage, function(v) settings.esp = v end)
addToggle("Ball ESP", espPage, function(v) settings.ballEsp = v end)
addToggle("Hold Space Jump", otherPage, function(v) settings.infJump = v end)

-- OTHERS SAYFASI YAZILARI
local info = Instance.new("TextLabel", otherPage)
info.Size = UDim2.new(0.9, 0, 0, 100); info.BackgroundTransparency = 1; info.TextColor3 = Color3.new(0.8, 0.8, 0.8)
info.Text = "Menu Key: INSERT\nYoutube: youtube.com/@RoWnn0\nNo Key - Free Script\nStatus: Fixed V3.4"; info.Font = "GothamMedium"; info.TextSize = 12; info.TextWrapped = true

-- --- MEKANİK DÜZELTMELER ---
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if char then
        if settings.infStamina then
            for _, v in pairs(char:GetDescendants()) do
                if v.Name:find("Stamina") then v.Value = 100 end
            end
        end
        if settings.infTackle then
            for _, v in pairs(char:GetDescendants()) do
                if v.Name:find("Tackle") or v.Name:find("Slide") then v.Value = 0 end
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if settings.infJump and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(LocalPlayer.Character.HumanoidRootPart.Velocity.X, 50, LocalPlayer.Character.HumanoidRootPart.Velocity.Z)
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if settings.speed and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = settings.sVal
    end
end)

-- Menü Aç/Kapat (INSERT)
UserInputService.InputBegan:Connect(function(i, p)
    if not p and i.KeyCode == settings.toggleKey then frame.Visible = not frame.Visible end
end)

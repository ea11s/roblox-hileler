-- [[ THE WALKING DEAD - ULTIMATE HELPER ]]
-- [[ Menü Aç/Kapa: INSERT ]]
-- [[ Aimbot: SAĞ TIK BASILI TUTUNCA ]]
-- [[ Uçma: SPACE BASILI TUTUNCA ]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local LP = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ==========================================
-- 🧹 1. SIFIRLAMA VE TEMİZLİK
-- ==========================================
_G.TWDCoreRun = false

if _G.TWDCore then
    for k, _ in pairs(_G.TWDCore) do
        _G.TWDCore[k] = false
    end
end

for _, obj in pairs(Workspace:GetDescendants()) do
    if obj.Name == "TWD_ESP_OBJ" then
        obj:Destroy()
    end
end

for _, menuName in pairs({"TWDCoreMenu", "FutbolCoreMenu", "TWDCrosshair"}) do
    local oldMenu = CoreGui:FindFirstChild(menuName)
    if oldMenu then
        oldMenu:Destroy()
    end
end

task.wait(0.1)
_G.TWDCoreRun = true

-- ==========================================
-- ⚙️ 2. AYARLAR & HASSASİYET
-- ==========================================
_G.TWDCore = {
    SprintSpeed = false,
    FullBright  = false,
    ZombieESP   = false,
    PlayerESP   = false,
    LootESP     = false,
    FlyMode     = false,
    NoFog       = false,
    Aimbot      = false
}

local Smoothness = 0.12     -- Soft Aimbot yumuşaklığı
local TargetFOV = 200       -- Aimbot menzili (piksel)
local StepMultiplier = 0.10 -- Hız artırma adımı
local FlySpeed = 25         -- Uçma hızı

-- GUI Tasarımı
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TWDCoreMenu"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 270, 0, 370)
MainFrame.Position = UDim2.new(0.05, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(255, 60, 60)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(25, 20, 20)
Title.BorderSizePixel = 0
Title.Text = "⚡ TWD ULTIMATE HELPER ⚡"
Title.TextColor3 = Color3.fromRGB(255, 60, 60)
Title.Font = Enum.Font.Code
Title.TextSize = 11
Title.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Parent = MainFrame
Layout.Padding = UDim.new(0, 5)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.SortOrder = Enum.SortOrder.LayoutOrder

local Padding = Instance.new("UIPadding")
Padding.PaddingTop = UDim.new(0, 40)
Padding.Parent = MainFrame

local function CreateButton(id, text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.92, 0, 0, 32)
    Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Btn.BorderSizePixel = 1
    Btn.BorderColor3 = Color3.fromRGB(50, 50, 50)
    Btn.Text = text .. ": KAPALI"
    Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    Btn.Font = Enum.Font.Code
    Btn.TextSize = 11
    Btn.Parent = MainFrame

    Btn.MouseButton1Click:Connect(function()
        _G.TWDCore[id] = not _G.TWDCore[id]
        local state = _G.TWDCore[id]

        Btn.Text = text .. (state and ": AÇIK" or ": KAPALI")
        Btn.TextColor3 = state and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(150, 150, 150)
        Btn.BorderColor3 = state and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(50, 50, 50)
        Btn.BackgroundColor3 = state and Color3.fromRGB(35, 15, 15) or Color3.fromRGB(25, 25, 25)

        if callback then callback(state) end
    end)
end

-- ==========================================
-- 🛠️ 3. MENÜ BUTONLARI
-- ==========================================
CreateButton("Aimbot", "SOFT AIMBOT (SAĞ TIK)", function(v) end)
CreateButton("SprintSpeed", "STABİL HIZ (TAKILMASIZ)", function(v) end)
CreateButton("FlyMode", "UÇMA (SPACE BASILI TUT)", function(v) end)

CreateButton("ZombieESP", "ZOMBİ ESP (KIRMIZI)", function(v)
    if not v then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name == "TWD_ESP_OBJ" and obj:GetAttribute("ESPType") == "Zombie" then
                obj:Destroy()
            end
        end
    end
end)

CreateButton("PlayerESP", "OYUNCU ESP (MAVİ)", function(v)
    if not v then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name == "TWD_ESP_OBJ" and obj:GetAttribute("ESPType") == "Player" then
                obj:Destroy()
            end
        end
    end
end)

CreateButton("LootESP", "EŞYA / LOOT ESP (YEŞİL)", function(v)
    if not v then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name == "TWD_ESP_OBJ" and obj:GetAttribute("ESPType") == "Loot" then
                obj:Destroy()
            end
        end
    end
end)

CreateButton("FullBright", "FULLBRIGHT (TAM AYDINLATMA)", function(v)
    if v then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 2
        Lighting.GlobalShadows = false
    else
        Lighting.Ambient = Color3.fromRGB(127, 127, 127)
        Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
    end
end)

CreateButton("NoFog", "SİS KALDIR", function(v)
    Lighting.FogEnd = v and 100000 or 1000
end)

-- ==========================================
-- 🎯 4. AIMBOT TARGETING
-- ==========================================
local function GetClosestTarget()
    local closest = nil
    local shortest = TargetFOV
    local mousePos = UIS:GetMouseLocation()

    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChild("Head") then
            local hum = obj:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 and obj ~= LP.Character then
                local pos, onScreen = Camera:WorldToViewportPoint(obj.Head.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                    if dist < shortest then
                        shortest = dist
                        closest = obj.Head
                    end
                end
            end
        end
    end
    return closest
end

-- ==========================================
-- 🔄 5. HAREKET VE AIMBOT DÖNGÜSÜ
-- ==========================================
RS.RenderStepped:Connect(function()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")

    -- Stabil Hız Artışı
    if _G.TWDCore.SprintSpeed and hum and hrp then
        if hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * StepMultiplier)
        end
    end

    -- Uçma Modu
    if _G.TWDCore.FlyMode and hrp then
        if UIS:IsKeyDown(Enum.KeyCode.Space) then
            hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, FlySpeed, hrp.AssemblyLinearVelocity.Z)
        else
            -- Boş bırakılırsa düşmeye izin ver (doğal fizik)
            if math.abs(hrp.AssemblyLinearVelocity.Y - FlySpeed) < 0.1 then
                hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 0, hrp.AssemblyLinearVelocity.Z)
            end
        end
    end

    -- Soft Aimbot (Sağ tık basılıyken)
    if _G.TWDCore.Aimbot and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = GetClosestTarget()
        if target then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Position), Smoothness)
        end
    end
end)

-- ==========================================
-- 🔄 6. ARKA PLAN ESP DÖNGÜSÜ
-- ==========================================
task.spawn(function()
    while _G.TWDCoreRun do
        task.wait(0.5)

        if _G.TWDCore.ZombieESP then
            for _, obj in pairs(Workspace:GetChildren()) do
                if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and not Players:GetPlayerFromCharacter(obj) then
                    if not obj:FindFirstChild("TWD_ESP_OBJ") then
                        local h = Instance.new("Highlight")
                        h.Name = "TWD_ESP_OBJ"
                        h:SetAttribute("ESPType", "Zombie")
                        h.FillColor = Color3.fromRGB(255, 30, 30)
                        h.FillTransparency = 0.5
                        h.Adornee = obj
                        h.Parent = obj
                    end
                end
            end
        end

        if _G.TWDCore.PlayerESP then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LP and player.Character and not player.Character:FindFirstChild("TWD_ESP_OBJ") then
                    local h = Instance.new("Highlight")
                    h.Name = "TWD_ESP_OBJ"
                    h:SetAttribute("ESPType", "Player")
                    h.FillColor = Color3.fromRGB(0, 150, 255)
                    h.FillTransparency = 0.5
                    h.Adornee = player.Character
                    h.Parent = player.Character
                end
            end
        end

        if _G.TWDCore.LootESP then
            for _, obj in pairs(Workspace:GetChildren()) do
                local nameLower = obj.Name:lower()
                if (obj:IsA("Tool") or nameLower:find("loot") or nameLower:find("item")) and not obj:FindFirstChild("TWD_ESP_OBJ") then
                    local h = Instance.new("Highlight")
                    h.Name = "TWD_ESP_OBJ"
                    h:SetAttribute("ESPType", "Loot")
                    h.FillColor = Color3.fromRGB(0, 255, 100)
                    h.FillTransparency = 0.5
                    h.Adornee = obj
                    h.Parent = obj
                end
            end
        end
    end
end)

-- Menü Kısayolu (INSERT)
UIS.InputBegan:Connect(function(input, gpe)
    if input.KeyCode == Enum.KeyCode.Insert and not gpe then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

print("⚡ TWD ULTIMATE SCRIPT DÜZELTİLDİ VE ÇALIŞMAYA HAZIR!")

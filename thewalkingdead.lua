-- [[ THE WALKING DEAD ULTIMATE HELPER - FIXED & SOFT AIMBOT ]] --
-- [[ Menü Aç/Kapa: INSERT ]] --

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local LP = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ==========================================
-- 🧹 1. ESKİ MENÜ VE KALINTILARI TEMİZLEME
-- ==========================================
if _G.TWDCore then
    _G.TWDCore.SprintSpeed = false
    _G.TWDCore.FullBright  = false
    _G.TWDCore.ZombieESP   = false
    _G.TWDCore.PlayerESP   = false
    _G.TWDCore.LootESP     = false
    _G.TWDCore.HighJump    = false
    _G.TWDCore.NoFog       = false
    _G.TWDCore.Aimbot      = false
end

for _, obj in pairs(Workspace:GetDescendants()) do
    if obj:FindFirstChild("TWDESP") or obj:FindFirstChild("TWDLootESP") then
        obj:Destroy()
    end
end

if CoreGui:FindFirstChild("TWDCoreMenu") then
    CoreGui.TWDCoreMenu:Destroy()
end

-- ==========================================
-- ⚙️ 2. DEĞİŞKENLER VE AYARLAR
-- ==========================================
_G.TWDCore = {
    SprintSpeed = false,
    FullBright  = false,
    ZombieESP   = false,
    PlayerESP   = false,
    LootESP     = false,
    HighJump    = false,
    NoFog       = false,
    Aimbot      = false
}

local Smoothness = 0.15 -- Aimbot kayma hızı (Daha küçük değer = daha yavaş/doğal kayma)
local FOV = 250 -- Aimbot arama alanı genişliği

-- --- ARAYÜZ TASARIMI ---
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TWDCoreMenu"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 380)
MainFrame.Position = UDim2.new(0.05, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 15, 15)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(255, 60, 60)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(28, 20, 20)
Title.BorderSizePixel = 0
Title.Text = "🧟 TWD ULTIMATE HELPER + AIMBOT 🧟"
Title.TextColor3 = Color3.fromRGB(255, 60, 60)
Title.Font = Enum.Font.Code
Title.TextSize = 12
Title.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Parent = MainFrame
Layout.Padding = UDim.new(0, 6)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.SortOrder = Enum.SortOrder.LayoutOrder

local Padding = Instance.new("UIPadding")
Padding.PaddingTop = UDim.new(0, 42)
Padding.Parent = MainFrame

local function CreateButton(id, text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.92, 0, 0, 32)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 25, 25)
    Btn.BorderSizePixel = 1
    Btn.BorderColor3 = Color3.fromRGB(60, 50, 50)
    Btn.Text = text .. ": KAPALI"
    Btn.TextColor3 = Color3.fromRGB(160, 160, 160)
    Btn.Font = Enum.Font.Code
    Btn.TextSize = 11
    Btn.Parent = MainFrame

    Btn.MouseButton1Click:Connect(function()
        _G.TWDCore[id] = not _G.TWDCore[id]
        local state = _G.TWDCore[id]

        Btn.Text = text .. (state and ": AÇIK" or ": KAPALI")
        Btn.TextColor3 = state and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(160, 160, 160)
        Btn.BorderColor3 = state and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(60, 50, 50)
        Btn.BackgroundColor3 = state and Color3.fromRGB(45, 15, 15) or Color3.fromRGB(30, 25, 25)

        if callback then callback(state) end
    end)
end

-- ==========================================
-- 🛠️ 3. ÖZELLİKLER VE BUTONLAR
-- ==========================================

CreateButton("Aimbot", "SOFT AIMBOT (ATEŞ EDİNCE)", function(v) end)

CreateButton("SprintSpeed", "HIZLI KOŞMA (30 HIZ)", function(v)
    if not v and LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.WalkSpeed = 16
    end
end)

CreateButton("HighJump", "YÜKSEK ZIPLAMA", function(v)
    if not v and LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.JumpPower = 50
        LP.Character.Humanoid.JumpHeight = 7.2
    end
end)

CreateButton("ZombieESP", "ZOMBİ ESP (KIRMIZI)", function(v)
    if not v then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name == "TWDZombieESP" then
                obj:Destroy()
            end
        end
    end
end)

CreateButton("PlayerESP", "OYUNCU ESP (MAVİ)", function(v)
    if not v then
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                local esp = player.Character:FindFirstChild("TWDPlayerESP")
                if esp then esp:Destroy() end
            end
        end
    end
end)

CreateButton("LootESP", "EŞYA / LOOT ESP (YEŞİL)", function(v)
    if not v then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name == "TWDLootESP" then
                obj:Destroy()
            end
        end
    end
end)

CreateButton("FullBright", "GECE / GECE GÖRÜŞÜ AÇ", function(v)
    if v then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
    else
        Lighting.Ambient = Color3.fromRGB(128, 128, 128)
        Lighting.Brightness = 1
    end
end)

CreateButton("NoFog", "SİS VE KARANLIĞI SİL", function(v)
    Lighting.FogEnd = v and 100000 or 1000
end)

-- ==========================================
-- 🎯 4. AIMBOT YARDIMCI FONKSİYONU
-- ==========================================
local function GetClosestTarget()
    local closestTarget = nil
    local shortestDistance = FOV

    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("Head") then
            -- Zombi veya Düşman kontrolü
            if not Players:GetPlayerFromCharacter(obj) and obj.Humanoid.Health > 0 then
                local head = obj.Head
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local mousePos = UIS:GetMouseLocation()
                    local distance = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestTarget = head
                    end
                end
            end
        end
    end
    return closestTarget
end

-- ==========================================
-- 🔄 5. DÖNGÜ MOTORU
-- ==========================================
RS.RenderStepped:Connect(function()
    -- 30 YÜRÜME HIZI
    if _G.TWDCore.SprintSpeed and LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.WalkSpeed = 30
    end

    -- ZIPLAMA DÜZELTME (Hem JumpPower hem JumpHeight zorlanır)
    if _G.TWDCore.HighJump and LP.Character and LP.Character:FindFirstChild("Humanoid") then
        local hum = LP.Character.Humanoid
        hum.UseJumpPower = true
        hum.JumpPower = 100
        hum.JumpHeight = 25
    end

    -- SADECE ATEŞ EDERKEN (SOL TIK BASILIYKEN) ÇALIŞAN SOFT AIMBOT
    if _G.TWDCore.Aimbot and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        local targetHead = GetClosestTarget()
        if targetHead then
            local targetCFrame = CFrame.new(Camera.CFrame.Position, targetHead.Position)
            Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, Smoothness)
        end
    end

    -- ZOMBİ / DÜŞMAN ESP (Tüm workspace taraması)
    if _G.TWDCore.ZombieESP then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(obj) then
                if obj.Humanoid.Health > 0 and not obj:FindFirstChild("TWDZombieESP") then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "TWDZombieESP"
                    highlight.FillColor = Color3.fromRGB(255, 30, 30)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.4
                    highlight.Adornee = obj
                    highlight.Parent = obj
                end
            end
        end
    end

    -- OYUNCU ESP
    if _G.TWDCore.PlayerESP then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LP and player.Character and player.Character:FindFirstChild("Humanoid") then
                if player.Character.Humanoid.Health > 0 and not player.Character:FindFirstChild("TWDPlayerESP") then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "TWDPlayerESP"
                    highlight.FillColor = Color3.fromRGB(0, 150, 255)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.4
                    highlight.Adornee = player.Character
                    highlight.Parent = player.Character
                end
            end
        end
    end

    -- LOOT / EŞYA ESP
    if _G.TWDCore.LootESP then
        for _, obj in pairs(Workspace:GetChildren()) do
            if (obj:IsA("Tool") or obj.Name:lower():find("loot") or obj.Name:lower():find("item") or obj.Name:lower():find("chest") or obj.Name:lower():find("crate")) then
                if not obj:FindFirstChild("TWDLootESP") then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "TWDLootESP"
                    highlight.FillColor = Color3.fromRGB(0, 255, 100)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.4
                    highlight.Adornee = obj
                    highlight.Parent = obj
                end
            end
        end
    end
end)

-- ==========================================
-- ⌨️ 6. KLAVYE DİNLENMESİ
-- ==========================================
UIS.InputBegan:Connect(function(input, gpe)
    if input.KeyCode == Enum.KeyCode.Insert and not gpe then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

print("🧟 TWD HELPER + SOFT AIMBOT YÜKLENDİ! MENÜ: INSERT")

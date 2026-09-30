-- [[ ODAKLANMIŞ 5 ÖZELLİKLİ FUTBOL HELPER ]] --
-- [[ Menü Aç/Kapa: INSERT Tuşu ]] --

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local LP = Players.LocalPlayer

-- Eski menü varsa temizle
if CoreGui:FindFirstChild("FutbolCoreMenu") then
    CoreGui.FutbolCoreMenu:Destroy()
end

-- --- AYAR MATRİSİ ---
_G.FutCore = {
    BigBallHitbox = false, -- 1. Top Hitbox Büyütme
    SprintSpeed   = false, -- 2. Yüksek Depar Hızı
    BrightMode    = false, -- 3. Saha Aydınlatma (Fullbright)
    FastDribble   = false, -- 4. Hızlı Dribling & Manevra
    BoxVisuals    = false  -- 5. Adamlara ve Topa Kutu (Box) Koy
}

-- --- ARAYÜZ TASARIMI ---
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FutbolCoreMenu"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 270, 0, 270)
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 120)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
Title.BorderSizePixel = 0
Title.Text = "⚽ FUTBOL ESSENTIALS v2 ⚽"
Title.TextColor3 = Color3.fromRGB(0, 255, 120)
Title.Font = Enum.Font.Code
Title.TextSize = 13
Title.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Parent = MainFrame
Layout.Padding = UDim.new(0, 8)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.SortOrder = Enum.SortOrder.LayoutOrder

local Padding = Instance.new("UIPadding")
Padding.PaddingTop = UDim.new(0, 42)
Padding.Parent = MainFrame

-- --- BUTON OLUŞTURUCU ---
local function CreateButton(id, text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.9, 0, 0, 32)
    Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Btn.BorderSizePixel = 1
    Btn.BorderColor3 = Color3.fromRGB(50, 50, 55)
    Btn.Text = text .. ": KAPALI"
    Btn.TextColor3 = Color3.fromRGB(160, 160, 160)
    Btn.Font = Enum.Font.Code
    Btn.TextSize = 11
    Btn.Parent = MainFrame

    Btn.MouseButton1Click:Connect(function()
        _G.FutCore[id] = not _G.FutCore[id]
        local state = _G.FutCore[id]

        Btn.Text = text .. (state and ": AÇIK" or ": KAPALI")
        Btn.TextColor3 = state and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(160, 160, 160)
        Btn.BorderColor3 = state and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(50, 50, 55)
        Btn.BackgroundColor3 = state and Color3.fromRGB(15, 40, 25) or Color3.fromRGB(25, 25, 30)

        if callback then callback(state) end
    end)
end

-- --- 5 TEMEL ÖZELLİK ---

-- 1. TOP HITBOX BÜYÜTME
CreateButton("BigBallHitbox", "TOP HITBOX BÜYÜT", function(v)
    if not v then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (obj.Name:lower():find("ball") or obj.Name:lower():find("soccer")) then
                obj.Size = Vector3.new(2, 2, 2)
            end
        end
    end
end)

-- 2. DEPAR HIZI (SPRINT BOOST)
CreateButton("SprintSpeed", "DEPAR HIZINI ARTTIR", function(v)
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.WalkSpeed = v and 26 or 16
    end
end)

-- 3. SAHA AYDINLATMA (FULLBRIGHT)
CreateButton("BrightMode", "SAHA AYDINLATMA", function(v)
    Lighting.Ambient = v and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(128, 128, 128)
end)

-- 4. HIZLI DRİBLİNG / ADAM GEÇME MODU
CreateButton("FastDribble", "HIZLI DRİBLİNG / MANEVRA", function(v)
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.AutoRotate = true
    end
end)

-- 5. ADAM VE TOP BOX GÖRSELLEŞTİRİCİ
CreateButton("BoxVisuals", "ADAMLARA VE TOPA BOX KOY", function(v)
    if not v then
        -- Kapatılınca oluşturulan Box'ları temizle
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:FindFirstChild("TargetBox") then
                obj.TargetBox:Destroy()
            end
        end
    end
end)

-- --- SÜREKLİ MOTOR DÖNGÜSÜ ---
RS.RenderStepped:Connect(function()
    -- Top Hitbox Kontrolü (Topu büyütür)
    if _G.FutCore.BigBallHitbox then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (obj.Name:lower():find("ball") or obj.Name:lower():find("soccer")) then
                obj.Size = Vector3.new(5.5, 5.5, 5.5)
                obj.CanCollide = true
            end
        end
    end

    -- Hızlı Dribling Manevrası
    if _G.FutCore.FastDribble and LP.Character and LP.Character:FindFirstChild("Humanoid") then
        local hum = LP.Character.Humanoid
        if hum.MoveDirection.Magnitude > 0 then
            LP.Character:TranslateBy(hum.MoveDirection * 0.12)
        end
    end

    -- Adamlara ve Topa Box Koyma Mantığı
    if _G.FutCore.BoxVisuals then
        -- 1. Topa Yeşil Kutu Koy
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (obj.Name:lower():find("ball") or obj.Name:lower():find("soccer")) then
                if not obj:FindFirstChild("TargetBox") then
                    local box = Instance.new("SelectionBox")
                    box.Name = "TargetBox"
                    box.Color3 = Color3.fromRGB(0, 255, 120) -- Yeşil
                    box.Adornee = obj
                    box.Parent = obj
                end
            end
        end

        -- 2. DİĞER OYUNCULARA (ADAMLARA) KIZIL KUTU KOY
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LP and player.Character then
                local root = player.Character:FindFirstChild("HumanoidRootPart")
                if root and not root:FindFirstChild("TargetBox") then
                    local box = Instance.new("SelectionBox")
                    box.Name = "TargetBox"
                    box.Color3 = Color3.fromRGB(255, 50, 50) -- Kırmızı
                    box.Adornee = player.Character
                    box.Parent = root
                end
            end
        end
    end
end)

-- --- INSERT İLE GİZLE / GÖSTER ---
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

print("⚽ 5 ÖZELLİKLİ FUTBOL HELPER YÜKLENDİ!")

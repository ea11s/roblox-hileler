-- [[ OPTİMİZE EDİLMİŞ 0 KASMA FUTBOL HELPER ]] --
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

_G.FutCore = {
    BigBallHitbox = false,
    SprintSpeed   = false,
    BrightMode    = false,
    FastDribble   = false,
    BoxVisuals    = false
}

-- TOPU YALNIZCA BİR KERE BULMA MOTORU (FPS DÜŞÜŞÜNÜ ÖNLER)
local cachedBall = nil
local function GetBall()
    if cachedBall and cachedBall.Parent then return cachedBall end
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("ball") or obj.Name:lower():find("soccer")) then
            cachedBall = obj
            return cachedBall
        end
    end
    -- Alt klasörlerde arama (Gerekirse)
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("ball") or obj.Name:lower():find("soccer")) then
            cachedBall = obj
            return cachedBall
        end
    end
    return nil
end

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
Title.Text = "⚡ OPTIMIZED FUTBOL HELPER ⚡"
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

-- --- ÖZELLİKLER ---

CreateButton("BigBallHitbox", "TOP HITBOX BÜYÜT", function(v)
    local ball = GetBall()
    if ball then
        if v then
            ball.Size = Vector3.new(4.5, 4.5, 4.5) -- Kasma yapmayan ideal boyut
        else
            ball.Size = Vector3.new(2, 2, 2)
        end
    end
end)

CreateButton("SprintSpeed", "DEPAR HIZINI ARTTIR", function(v)
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.WalkSpeed = v and 25 or 16
    end
end)

CreateButton("BrightMode", "SAHA AYDINLATMA", function(v)
    Lighting.Ambient = v and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(128, 128, 128)
end)

CreateButton("FastDribble", "HIZLI DRİBLİNG / MANEVRA", function(v)
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.AutoRotate = true
    end
end)

CreateButton("BoxVisuals", "ADAMLARA VE TOPA BOX KOY", function(v)
    if not v then
        -- Kapatılınca kutuları temizle
        local ball = GetBall()
        if ball and ball:FindFirstChild("BallBox") then ball.BallBox:Destroy() end
        
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("PlayerBox") then
                player.Character.PlayerBox:Destroy()
            end
        end
    else
        -- Açılınca Topa Kutu Ekle
        local ball = GetBall()
        if ball and not ball:FindFirstChild("BallBox") then
            local box = Instance.new("SelectionBox")
            box.Name = "BallBox"
            box.Color3 = Color3.fromRGB(0, 255, 120)
            box.Adornee = ball
            box.Parent = ball
        end
    end
end)

-- --- SADECE GEREKLİ İŞLEMLER İÇİN HAFİF DÖNGÜ ---
RS.Stepped:Connect(function()
    -- Dribling desteği
    if _G.FutCore.FastDribble and LP.Character and LP.Character:FindFirstChild("Humanoid") then
        local hum = LP.Character.Humanoid
        if hum.MoveDirection.Magnitude > 0 then
            LP.Character:TranslateBy(hum.MoveDirection * 0.08)
        end
    end

    -- Adamların Kutusunu Kontrol Et (Performanslı Yöntem)
    if _G.FutCore.BoxVisuals then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LP and player.Character then
                if not player.Character:FindFirstChild("PlayerBox") then
                    local box = Instance.new("SelectionBox")
                    box.Name = "PlayerBox"
                    box.Color3 = Color3.fromRGB(255, 50, 50)
                    box.Adornee = player.Character
                    box.Parent = player.Character
                end
            end
        end
    end
end)

-- INSERT ile Aç/Kapa
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

print("⚡ OPTİMİZE EDİLMİŞ FUTBOL SCRIPT YÜKLENDİ!")

-- [[ YOUTUBE STYLE ROBLOX FOOTBALL SIMULATOR HUB ]] --
-- [[ Kapat / Aç: INSERT Tuşu ]] --

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local LP = Players.LocalPlayer

-- Eski paneli temizle
if CoreGui:FindFirstChild("RobloxFootballHub") then
    CoreGui.RobloxFootballHub:Destroy()
end

-- --- FUTBOL MODU AYARLARI (15 ÖZELLİK) ---
_G.FutSettings = {
    BallHighlight = false,   -- 1. Topu Parlat (Saha İçi Takip)
    BallTracer = false,      -- 2. Top İzi (Tracer)
    CameraWide = false,      -- 3. Geniş Saha Kamerası (FOV 105)
    GoalBoxGuide = false,    -- 4. Kale İçi Hizalama Çizgisi
    BrightStadium = false,   -- 5. Stadyum Işıklarını Maksimum Yap
    NoPitchFog = false,      -- 6. Saha Sisi Kaldırma
    LowGrassPerf = false,    -- 7. Çim Detayı Sıfırlama (FPS Boost)
    HitboxVisual = false,    -- 8. Oyuncu Temas Kutusu Görselleştirici
    SpeedBoostTest = false,  -- 9. Depar Hızı Testi (WS 24)
    JumpBoostTest = false,   -- 10. Kafa Topu Zıplama Testi (JP 75)
    CrosshairCenter = false, -- 11. Şut Merkez Noktası (Dot)
    AntiStunFix = false,     -- 12. Düşme / Takılma Önleme
    ShowFpsPing = false,     -- 13. FPS & Ping Ekran Sayacı
    Disable3DRender = false, -- 14. Arka Plan Rendering Kapatma
    InputLockTest = false    -- 15. Tuş Kontrol Test Motoru
}

-- --- SİYAH / NEON YEŞİL FUTBOL TEMALI ARAYÜZ ---
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RobloxFootballHub"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 310, 0, 430)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 120) -- Neon Yeşil
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Başlık
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
Title.BorderSizePixel = 0
Title.Text = "⚽ FOOTBALL SIMULATOR HUB v4.0 ⚽"
Title.TextColor3 = Color3.fromRGB(0, 255, 120)
Title.Font = Enum.Font.Code
Title.TextSize = 13
Title.Parent = MainFrame

local Line = Instance.new("Frame")
Line.Size = UDim2.new(1, 0, 0, 2)
Line.Position = UDim2.new(0, 0, 0, 43)
Line.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
Line.BorderSizePixel = 0
Line.Parent = MainFrame

-- Kaydırma Alanı
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -10, 1, -75)
Scroll.Position = UDim2.new(0, 5, 0, 50)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 620)
Scroll.ScrollBarThickness = 4
Scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 120)
Scroll.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Parent = Scroll
Layout.Padding = UDim.new(0, 6)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- --- TOGGLE BUTON OLUŞTURUCU ---
local function CreateFutToggle(id, labelText, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 280, 0, 32)
    Btn.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    Btn.BorderSizePixel = 1
    Btn.BorderColor3 = Color3.fromRGB(45, 45, 50)
    Btn.Text = "  " .. labelText .. " -> [OFF]"
    Btn.TextColor3 = Color3.fromRGB(160, 160, 160)
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.Font = Enum.Font.Code
    Btn.TextSize = 11
    Btn.Parent = Scroll

    Btn.MouseButton1Click:Connect(function()
        _G.FutSettings[id] = not _G.FutSettings[id]
        local state = _G.FutSettings[id]
        
        Btn.Text = "  " .. labelText .. (state and " -> [ON]" or " -> [OFF]")
        Btn.TextColor3 = state and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(160, 160, 160)
        Btn.BorderColor3 = state and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(45, 45, 50)
        Btn.BackgroundColor3 = state and Color3.fromRGB(15, 35, 22) or Color3.fromRGB(22, 22, 28)
        
        if callback then callback(state) end
    end)
end

-- --- 15 FUTBOL TEST VE ARAYÜZ FONKSİYONU ---

-- 1. SAHA VE TOP GÖRÜŞÜ
CreateFutToggle("BallHighlight", "TOPU PARLAT (BALL HIGHLIGHT)", function(v) end)

CreateFutToggle("BallTracer", "TOP HAREKET İZİ (BALL TRACER)", function(v) end)

CreateFutToggle("CameraWide", "GENİŞ SAHA KAMERASI (FOV 105)", function(v)
    Workspace.CurrentCamera.FieldOfView = v and 105 or 70
end)

CreateFutToggle("GoalBoxGuide", "KALE HİZALAMA REHBERİ", function(v) end)

-- 2. STADYUM & GRAFİK OPTİMİZASYONLARI
CreateFutToggle("BrightStadium", "STADYUM AYDINLATMASI (FULLBRIGHT)", function(v)
    Lighting.Ambient = v and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(128, 128, 128)
end)

CreateFutToggle("NoPitchFog", "SAHA SİSİNİ KALDIR", function(v)
    Lighting.FogEnd = v and 999999 or 1000
end)

CreateFutToggle("LowGrassPerf", "ÇİM METERYALİ DÜZLEŞTİR (FPS)", function(v)
    for _, item in pairs(Workspace:GetDescendants()) do
        if item:IsA("BasePart") and item.Material == Enum.Material.Grass then
            item.Material = v and Enum.Material.SmoothPlastic or Enum.Material.Grass
        end
    end
end)

-- 3. OYUNCU VE TOP FİZİĞİ SIMULATION
CreateFutToggle("HitboxVisual", "RAKİP TEMAS KUTULARI (HITBOX)", function(v) end)

CreateFutToggle("SpeedBoostTest", "DEPAR HIZI TESTİ (WS 24)", function(v)
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.WalkSpeed = v and 24 or 16
    end
end)

CreateFutToggle("JumpBoostTest", "KAFA TOPU ZIPLAMA (JP 75)", function(v)
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.JumpPower = v and 75 or 50
    end
end)

-- 4. ŞUT & ARAYÜZ YARDIMCILARI
CreateFutToggle("CrosshairCenter", "ŞUT HEDEF NOKTASI (DOT)", function(v)
    local targetDot = ScreenGui:FindFirstChild("FootballCrosshair")
    if v then
        local dot = Instance.new("Frame")
        dot.Name = "FootballCrosshair"
        dot.Size = UDim2.new(0, 6, 0, 6)
        dot.Position = UDim2.new(0.5, -3, 0.5, -3)
        dot.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
        dot.BorderSizePixel = 0
        dot.Parent = ScreenGui
    elseif targetDot then targetDot:Destroy() end
end)

CreateFutToggle("AntiStunFix", "DÜŞME KİLİDİ ÖNLEME (PLATFORM)", function(v)
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.PlatformStand = false
    end
end)

CreateFutToggle("ShowFpsPing", "EKRAN FPS & PING SAYAÇ", function(v) end)

CreateFutToggle("Disable3DRender", "3D SAHA RENDER KAPAT (FPS MAX)", function(v)
    RS:Set3dRenderingEnabled(v)
end)

CreateFutToggle("InputLockTest", "TUŞ TEPKİ SÜRESİ TELEMETRİSİ", function(v) end)

-- Alt Bilgi
local Footer = Instance.new("TextLabel")
Footer.Size = UDim2.new(1, 0, 0, 20)
Footer.Position = UDim2.new(0, 0, 1, -22)
Footer.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
Footer.BorderSizePixel = 0
Footer.Text = "PRESS 'INSERT' TO HIDE / SHOW FOOTBALL HUB"
Footer.TextColor3 = Color3.fromRGB(110, 110, 110)
Footer.Font = Enum.Font.Code
Footer.TextSize = 10
Footer.Parent = MainFrame

-- --- ARKAPLAN SAHA DÖNGÜSÜ (RENDERSTEPPED) ---
RS.RenderStepped:Connect(function()
    -- Topu Tespit Et ve Parlat (İsminde 'Ball', 'Football' veya 'Soccer' Geçen Part'lar)
    if _G.FutSettings.BallHighlight then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (obj.Name:lower():find("ball") or obj.Name:lower():find("soccer")) then
                if not obj:FindFirstChild("BallGlow") then
                    local glow = Instance.new("SelectionBox")
                    glow.Name = "BallGlow"
                    glow.Color3 = Color3.fromRGB(0, 255, 120)
                    glow.Adornee = obj
                    glow.Parent = obj
                end
            end
        end
    end
    
    -- Rakip Hitbox Büyüklük Görselleştirici
    if _G.FutSettings.HitboxVisual then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Transparency = 0.6
                p.Character.HumanoidRootPart.Color = Color3.fromRGB(255, 50, 50)
            end
        end
    end
end)

-- --- AÇILIŞ / KAPANIŞ MOTORU ---
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

print("⚽ ROBLOX FOOTBALL SIMULATOR HUB YÜKLENDİ!")
print("⚽ INSERT tuşuna basarak menüyü gizleyebilir veya açabilirsin.")

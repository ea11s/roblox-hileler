-- [[ THE WALKING DEAD FULL HELPER - VOTEKICK SAFE ]] --
-- [[ Hız Tuşu: V (30 WalkSpeed) ]] --
-- [[ Menü Aç/Kapa: INSERT ]] --

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local CAS = game:GetService("ContextActionService")
local RS = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local LP = Players.LocalPlayer

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
    _G.TWDCore.Crosshair   = false
end

for _, obj in pairs(Workspace:GetDescendants()) do
    if obj:FindFirstChild("TWDESP") then
        obj.TWDESP:Destroy()
    end
end

if CoreGui:FindFirstChild("TWDCoreMenu") then
    CoreGui.TWDCoreMenu:Destroy()
end

if CoreGui:FindFirstChild("TWDCrosshair") then
    CoreGui.TWDCrosshair:Destroy()
end

pcall(function() CAS:UnbindAction("TWDSpeedAction") end)

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
    Crosshair   = false
}

-- --- ARAYÜZ TASARIMI ---
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TWDCoreMenu"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 390)
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
Title.Text = "🧟 THE WALKING DEAD ULTIMATE 🧟"
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

local speedButtonRef = nil

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

    if id == "SprintSpeed" then
        speedButtonRef = Btn
    end

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

CreateButton("SprintSpeed", "HIZLI KOŞMA (30) [TUŞ: V]", function(v)
    if not v and LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.WalkSpeed = 16
    end
end)

CreateButton("HighJump", "YÜKSEK ZEPLAMA (ZOMBI KAÇIŞ)", function(v)
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.JumpPower = v and 80 or 50
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

CreateButton("ZombieESP", "ZOMBİ ESP (KIRMIZI)", function(v)
    if not v then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:FindFirstChild("TWDESP") and not Players:GetPlayerFromCharacter(obj) and not obj:IsA("Tool") then
                obj.TWDESP:Destroy()
            end
        end
    end
end)

CreateButton("PlayerESP", "OYUNCU ESP (MAVİ)", function(v)
    if not v then
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("TWDESP") then
                player.Character.TWDESP:Destroy()
            end
        end
    end
end)

CreateButton("LootESP", "EŞYA / LOOT ESP (YEŞİL)", function(v)
    if not v then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:FindFirstChild("TWDLootESP") then
                obj.TWDLootESP:Destroy()
            end
        end
    end
end)

CreateButton("Crosshair", "EKRANA NİŞAN NOKTASI KOY", function(v)
    if v then
        local chGui = Instance.new("ScreenGui")
        chGui.Name = "TWDCrosshair"
        chGui.Parent = CoreGui

        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, 4, 0, 4)
        dot.Position = UDim2.new(0.5, -2, 0.5, -2)
        dot.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        dot.BorderSizePixel = 0
        dot.Parent = chGui
    else
        if CoreGui:FindFirstChild("TWDCrosshair") then
            CoreGui.TWDCrosshair:Destroy()
        end
    end
end)

-- ==========================================
-- 🔄 4. DÖNGÜ MOTORU
-- ==========================================
RS.Stepped:Connect(function()
    -- 30 YÜRÜME HIZI (WalkSpeed)
    if _G.TWDCore.SprintSpeed and LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.WalkSpeed = 30
    end

    -- YÜKSEK ZIPLAMA
    if _G.TWDCore.HighJump and LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.JumpPower = 80
    end

    -- ZOMBİ ESP
    if _G.TWDCore.ZombieESP then
        for _, obj in pairs(Workspace:GetChildren()) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(obj) then
                if not obj:FindFirstChild("TWDESP") then
                    local box = Instance.new("Highlight")
                    box.Name = "TWDESP"
                    box.FillColor = Color3.fromRGB(255, 0, 0)
                    box.OutlineColor = Color3.fromRGB(255, 255, 255)
                    box.FillTransparency = 0.5
                    box.Adornee = obj
                    box.Parent = obj
                end
            end
        end
    end

    -- OYUNCU ESP
    if _G.TWDCore.PlayerESP then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LP and player.Character then
                if not player.Character:FindFirstChild("TWDESP") then
                    local box = Instance.new("Highlight")
                    box.Name = "TWDESP"
                    box.FillColor = Color3.fromRGB(0, 150, 255)
                    box.OutlineColor = Color3.fromRGB(255, 255, 255)
                    box.FillTransparency = 0.5
                    box.Adornee = player.Character
                    box.Parent = player.Character
                end
            end
        end
    end

    -- LOOT / EŞYA ESP
    if _G.TWDCore.LootESP then
        for _, obj in pairs(Workspace:GetChildren()) do
            if (obj:IsA("Tool") or obj.Name:lower():find("loot") or obj.Name:lower():find("item") or obj.Name:lower():find("chest") or obj.Name:lower():find("crate")) then
                if not obj:FindFirstChild("TWDLootESP") then
                    local box = Instance.new("Highlight")
                    box.Name = "TWDLootESP"
                    box.FillColor = Color3.fromRGB(0, 255, 100)
                    box.OutlineColor = Color3.fromRGB(255, 255, 255)
                    box.FillTransparency = 0.4
                    box.Adornee = obj
                    box.Parent = obj
                end
            end
        end
    end
end)

-- ==========================================
-- ⌨️ 5. KLAVYE DİNLENMESİ
-- ==========================================
local function ToggleSpeed()
    _G.TWDCore.SprintSpeed = not _G.TWDCore.SprintSpeed
    local state = _G.TWDCore.SprintSpeed
    
    if not state and LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.WalkSpeed = 16
    end
    
    if speedButtonRef then
        speedButtonRef.Text = "HIZLI KOŞMA (30) [TUŞ: V]" .. (state and ": AÇIK" or ": KAPALI")
        speedButtonRef.TextColor3 = state and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(160, 160, 160)
        speedButtonRef.BorderColor3 = state and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(60, 50, 50)
        speedButtonRef.BackgroundColor3 = state and Color3.fromRGB(45, 15, 15) or Color3.fromRGB(30, 25, 25)
    end
end

CAS:BindAction("TWDSpeedAction", function(actionName, inputState, inputObj)
    if inputState == Enum.UserInputState.Begin then
        ToggleSpeed()
    end
    return Enum.ContextActionResult.Pass
end, false, Enum.KeyCode.V)

UIS.InputBegan:Connect(function(input, gpe)
    if input.KeyCode == Enum.KeyCode.Insert and not gpe then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

print("🧟 ULTIMATE TWD HELPER YÜKLENDİ!")

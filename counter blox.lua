-- [[ SIERRA MASTER V25 - UNIVERSAL EXPLOIT ]] --
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- // OYUN AYARLARI (Senin Kodunla Aynı Mantık)
local settings = {
    silentAim = false,
    esp = false,
    noRecoil = false,
    speed = false,
    infJump = false,
    hitbox = false,
    hSize = 12,
    sVal = 0.35, -- Speed bypass değeri
    toggleKey = Enum.KeyCode.RightControl
}

-- // --- UI SİSTEMİ (TAM İSTEDİĞİN GİBİ) ---
local sg = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
sg.Name = "SierraV25_Master"; sg.ResetOnSpawn = false

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 230, 0, 480)
frame.Position = UDim2.new(0.7, 0, 0.2, 0) -- Sağ tarafta sabit
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 15) -- Siyah-Lacivert Sierra teması
frame.Active = true; frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- Başlık
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40); title.Text = "SIERRA V25 MASTER"; title.TextColor3 = Color3.fromRGB(0, 255, 127)
title.BackgroundTransparency = 1; title.Font = "GothamBold"; title.TextSize = 14

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, -10, 1, -50); scroll.Position = UDim2.new(0, 5, 0, 45)
scroll.BackgroundTransparency = 1; scroll.CanvasSize = UDim2.new(0, 0, 0, 600)
scroll.ScrollBarThickness = 2
Instance.new("UIListLayout", scroll).HorizontalAlignment = "Center"; Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 5)

-- // BUTON OLUŞTURMA FONKSİYONU
local function cB(t, f)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(0.9, 0, 0, 38)
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    b.Text = t; b.TextColor3 = Color3.new(1,1,1); b.Font = "Gotham"
    b.TextSize = 12
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(function() f(b) end)
end

-- // --- BUTONLAR VE AKSİYONLAR ---
cB("SILENT AIM: OFF", function(b) settings.silentAim = not settings.silentAim; b.Text = "SILENT AIM: "..(settings.silentAim and "ON" or "OFF") end)
cB("NO-RECOIL: OFF", function(b) settings.noRecoil = not settings.noRecoil; b.Text = "NO-RECOIL: "..(settings.noRecoil and "ON" or "OFF") end)
cB("HITBOX: OFF", function(b) settings.hitbox = not settings.hitbox; b.Text = "HITBOX: "..(settings.hitbox and "ON" or "OFF") end)
cB("SPEED BYPASS: OFF", function(b) settings.speed = not settings.speed; b.Text = "SPEED: "..(settings.speed and "ON" or "OFF") end)
cB("ESP: OFF", function(b) settings.esp = not settings.esp; b.Text = "ESP: "..(settings.esp and "ON" or "OFF") end)
cB("INF JUMP: OFF", function(b) settings.infJump = not settings.infJump; b.Text = "JUMP: "..(settings.infJump and "ON" or "OFF") end)

-- // --- MEKANİK DÖNGÜLER ---
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local hum = char:FindFirstChildOfClass("Humanoid")

    -- 1. SPEED BYPASS (CFrame Yöntemi)
    if settings.speed and hum.MoveDirection.Magnitude > 0 then
        hrp.CFrame = hrp.CFrame + (hum.MoveDirection * settings.sVal)
    end

    -- 2. HITBOX EXPAND
    if settings.hitbox then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Team ~= LocalPlayer.Team and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local eHRP = p.Character.HumanoidRootPart
                eHRP.Size = Vector3.new(settings.hSize, settings.hSize, settings.hSize)
                eHRP.Transparency = 0.7; eHRP.CanCollide = false
            end
        end
    end

    -- 3. SILENT AIM (Sağ Tık Basılıyken)
    if settings.silentAim and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = nil
        local dist = 300
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Team ~= LocalPlayer.Team and v.Character and v.Character:FindFirstChild("Head") then
                local pos, vis = Camera:WorldToViewportPoint(v.Character.Head.Position)
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if vis and mag < dist then
                    dist = mag; target = v
                end
            end
        end
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
        end
    end
end)

-- NO RECOIL (CB & Blox Strike Tipi Oyunlar İçin)
task.spawn(function()
    while task.wait(1) do
        if settings.noRecoil then
            for _, v in pairs(getgc(true)) do
                if type(v) == "table" and rawget(v, "Recoil") then
                    v.Recoil = 0; v.MaxRecoil = 0; v.Spread = 0
                end
            end
        end
    end
end)

-- INF JUMP
UserInputService.JumpRequest:Connect(function()
    if settings.infJump and LocalPlayer.Character then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(3)
    end
end)

-- ESP SİSTEMİ
task.spawn(function()
    while task.wait(1) do
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hl = p.Character:FindFirstChild("SierraESP") or Instance.new("Highlight", p.Character)
                hl.Name = "SierraESP"; hl.Enabled = settings.esp
                hl.FillColor = (p.Team == LocalPlayer.Team) and Color3.new(0,1,0) or Color3.new(1,0,0)
                hl.DepthMode = "AlwaysOnTop"
            end
        end
    end
end)

-- MENÜ TUŞU (Sağ Control)
UserInputService.InputBegan:Connect(function(i, p)
    if not p and i.KeyCode == settings.toggleKey then frame.Visible = not frame.Visible end
end)

print("Sierra V25 Master Loaded!")

-- [[ SIERRA V24 - COUNTER BLOX & BLOX STRIKE EDITION ]] --
-- Bu kodu Executor'ına (Xeno vb.) yapıştır ve Execute et.

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = game:GetService("Workspace").CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- // AYARLAR (Buradan Değiştirebilirsin)
local Settings = {
    Aimbot = true,
    AimPart = "Head", -- Kafaya kilitlenir
    AimRadius = 150,  -- FOV Dairesi büyüklüğü
    ESP = true,
    NoRecoil = true,
    Bhop = true,
    WalkSpeed = 22    -- Normalden biraz daha hızlı (Abartma ban yeme)
}

-- // FOV DAİRESİ (Görsel)
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.NumSides = 60
FOVCircle.Radius = Settings.AimRadius
FOVCircle.Filled = false
FOVCircle.Visible = true
FOVCircle.Color = Color3.fromRGB(0, 255, 127)

-- // EN YAKIN DÜŞMANI BULMA
local function GetClosestPlayer()
    local Target = nil
    local MaxDist = Settings.AimRadius

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Team ~= LocalPlayer.Team and v.Character and v.Character:FindFirstChild(Settings.AimPart) then
            local Pos, OnScreen = Camera:WorldToViewportPoint(v.Character[Settings.AimPart].Position)
            local Dist = (Vector2.new(Pos.X, Pos.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude

            if OnScreen and Dist < MaxDist then
                MaxDist = Dist
                Target = v
            end
        end
    end
    return Target
end

-- // ANA DÖNGÜ (RenderStepped)
RunService.RenderStepped:Connect(function()
    -- 1. FOV Dairesini Güncelle
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    -- 2. SILENT AIM (Sağ Tık Basılıyken)
    if Settings.Aimbot and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local Target = GetClosestPlayer()
        if Target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Character[Settings.AimPart].Position)
        end
    end

    -- 3. BHOP
    if Settings.Bhop and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.Jump = true
        end
    end

    -- 4. HIZ HİLESİ
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Settings.WalkSpeed
    end
end)

-- // NO RECOIL & SPREAD (Silah Sekmesini Silme)
-- Counter Blox için özel modül taraması
task.spawn(function()
    while task.wait(1) do
        if Settings.NoRecoil then
            for _, v in pairs(getgc(true)) do
                if type(v) == "table" and rawget(v, "Recoil") then
                    v.Recoil = 0
                    v.MaxRecoil = 0
                    v.Spread = 0
                end
            end
        end
    end
end)

-- // ESP (BOX & NAME)
local function AddESP(Player)
    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Color = Color3.fromRGB(255, 0, 0)
    Box.Thickness = 1
    Box.Filled = false

    RunService.RenderStepped:Connect(function()
        if Settings.ESP and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local RootPart = Player.Character.HumanoidRootPart
            local Pos, OnScreen = Camera:WorldToViewportPoint(RootPart.Position)

            if OnScreen then
                Box.Size = Vector2.new(2000 / Pos.Z, 2500 / Pos.Z)
                Box.Position = Vector2.new(Pos.X - Box.Size.X / 2, Pos.Y - Box.Size.Y / 2)
                Box.Visible = true
            else
                Box.Visible = false
            end
        else
            Box.Visible = false
        end
    end)
end

for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then AddESP(p) end
end
Players.PlayerAdded:Connect(AddESP)

print("--- SIERRA V24 LOADED SUCCESSFULLY ---")

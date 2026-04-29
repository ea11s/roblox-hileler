-- [[ STEEL TITANS V5.0 - REPAIR BY RoWnn0 ]] --
-- [[ HER ŞEY SIFIRLANDI VE GÜÇLENDİRİLDİ ]] --

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- Önceki sürümleri temizle
for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
    if v.Name:find("RoWnn0") then v:Destroy() end
end

-- --- CORE SETTINGS ---
_G.Aimbot = true -- Direkt açık başlar
_G.Fly = false
_G.ESP = true -- Direkt açık başlar
_G.FlySpeed = 60

-- --- SIMPLE FORCE FLY ---
local bv, bg
local function toggleFly()
    if _G.Fly then
        local target = (LP.Character and LP.Character:FindFirstChild("Humanoid") and LP.Character.Humanoid.SeatPart) or (LP.Character and LP.Character:FindFirstChild("HumanoidRootPart"))
        if target then
            bv = Instance.new("BodyVelocity", target)
            bg = Instance.new("BodyGyro", target)
            bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
            
            while _G.Fly and target.Parent do
                bg.CFrame = Camera.CFrame
                local dir = Vector3.new(0,0,0)
                if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
                bv.Velocity = dir * _G.FlySpeed
                task.wait()
            end
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
        end
    end
end

-- --- SIMPLE FORCE ESP ---
local function applyGlow(p)
    p.CharacterAdded:Connect(function(char)
        task.wait(1)
        if _G.ESP and p ~= LP then
            local hl = Instance.new("Highlight", char)
            hl.FillColor = Color3.new(1, 0, 0)
            hl.OutlineColor = Color3.new(1, 1, 1)
        end
    end)
    if p.Character and p ~= LP then
        local hl = Instance.new("Highlight", p.Character)
        hl.FillColor = Color3.new(1, 0, 0)
    end
end

-- --- KEYBINDS ---
UIS.InputBegan:Connect(function(i, g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.E then
        _G.Fly = not _G.Fly
        if _G.Fly then task.spawn(toggleFly) end
    end
end)

-- --- AIMBOT (RIGHT CLICK) ---
RS.RenderStepped:Connect(function()
    if _G.Aimbot and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = nil
        local dist = math.huge
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local pos, vis = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                if vis then
                    local m = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
                    if m < dist then target = p; dist = m end
                end
            end
        end
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
        end
    end
end)

-- Start
for _, p in pairs(Players:GetPlayers()) do applyGlow(p) end
Players.PlayerAdded:Connect(applyGlow)

print("RoWnn0 V5.0 AKTIF - E: Fly | Sag Tik: Aim | ESP: Auto")

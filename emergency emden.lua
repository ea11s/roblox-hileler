-- [[ RoWnn0 EMDEN ULTIMATE V10.0 ]] --
-- [[ FULL POWER - NO RESTRICTIONS ]] --

local LP = game:GetService("Players").LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local Mouse = LP:GetMouse()

-- Eski her şeyi temizle
pcall(function() game:GetService("CoreGui").EmdenUltimate:Destroy() end)

-- --- AYARLAR ---
_G.Aimbot = false
_G.ESP = false
_G.Fly = false
_G.Speed = 16
_G.InfJump = false
_G.NoRecoil = false
_G.InfAmmo = false
_G.InfStamina = false

-- --- UI ---
local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "EmdenUltimate"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 220, 0, 420); main.Position = UDim2.new(0, 20, 0.5, -210)
main.BackgroundColor3 = Color3.new(0.1, 0.1, 0.15); main.BorderSizePixel = 2; main.Draggable = true; main.Active = true

local t = Instance.new("TextLabel", main)
t.Size = UDim2.new(1, 0, 0, 30); t.Text = "EMDEN ULTIMATE V10"; t.TextColor3 = Color3.new(1,1,1)
t.BackgroundColor3 = Color3.new(0.6, 0, 0)

-- --- BUTON MOTORU ---
local function AddToggle(text, pos, callback)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(0.9, 0, 0, 35); b.Position = UDim2.new(0.05, 0, 0, pos)
    b.Text = text .. ": OFF"; b.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2); b.TextColor3 = Color3.new(1,1,1)
    local s = false
    b.MouseButton1Click:Connect(function()
        s = not s; b.Text = text .. (s and ": ON" or ": OFF")
        b.BackgroundColor3 = s and Color3.new(0, 0.5, 0) or Color3.new(0.2, 0.2, 0.2)
        callback(s)
    end)
end

-- --- FONKSİYONLAR ---

-- 1. Arabayı Yanına Getir (Car Bring)
local function BringVehicle()
    pcall(function()
        local vehicles = workspace:FindFirstChild("Vehicles") or workspace:FindFirstChild("Cars")
        for _, v in pairs(vehicles:GetChildren()) do
            if v:FindFirstChild("Owner") and v.Owner.Value == LP.Name then
                v:SetPrimaryPartCFrame(LP.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -10))
            end
        end
    end)
end

local bBtn = Instance.new("TextButton", main)
bBtn.Size = UDim2.new(0.9, 0, 0, 35); bBtn.Position = UDim2.new(0.05, 0, 0, 40)
bBtn.Text = "ARABAYI GETIR"; bBtn.BackgroundColor3 = Color3.new(0.4, 0.4, 0); bBtn.TextColor3 = Color3.new(1,1,1)
bBtn.MouseButton1Click:Connect(BringVehicle)

-- --- TOGGLES ---
AddToggle("FLY (E)", 80, function(v) _G.Fly = v end)
AddToggle("FAST SPEED", 120, function(v) _G.Speed = v and 100 or 16 end)
AddToggle("INF JUMP", 160, function(v) _G.InfJump = v end)
AddToggle("GLOW ESP", 200, function(v) _G.ESP = v end)
AddToggle("AIMBOT (Right)", 240, function(v) _G.Aimbot = v end)
AddToggle("NO RECOIL", 280, function(v) _G.NoRecoil = v end)
AddToggle("INF AMMO", 320, function(v) _G.InfAmmo = v end)
AddToggle("INF STAMINA", 360, function(v) _G.InfStamina = v end)

-- --- CORE ENGINE (LOOP) ---
RS.RenderStepped:Connect(function()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")

    if hum then hum.WalkSpeed = _G.Speed end

    -- Inf Stamina (Basit çözüm)
    if _G.InfStamina and char:FindFirstChild("Stamina") then
        char.Stamina.Value = 100
    end

    -- Fly
    if _G.Fly and root then
        local v = Vector3.new(0, 1.3, 0)
        if UIS:IsKeyDown("W") then v = v + (Camera.CFrame.LookVector * 80) end
        if UIS:IsKeyDown("S") then v = v - (Camera.CFrame.LookVector * 80) end
        root.Velocity = v
    end

    -- Inf Ammo & No Recoil (Tool-based)
    if _G.InfAmmo or _G.NoRecoil then
        local tool = char:FindFirstChildOfClass("Tool")
        if tool and tool:FindFirstChild("Stats") then -- Emden silah yapısı
            if _G.InfAmmo and tool.Stats:FindFirstChild("Ammo") then tool.Stats.Ammo.Value = 999 end
            if _G.NoRecoil and tool.Stats:FindFirstChild("Recoil") then tool.Stats.Recoil.Value = 0 end
        end
    end

    -- ESP
    for _, p in pairs(game:GetService("Players"):GetPlayers()) do
        if p ~= LP and p.Character then
            local h = p.Character:FindFirstChildOfClass("Highlight")
            if _G.ESP then
                if not h then Instance.new("Highlight", p.Character) end
            elseif h then h:Destroy() end
        end
    end

    -- Aimbot
    if _G.Aimbot and UIS:IsMouseButtonPressed(2) then
        local t = nil; local d = 250
        for _, p in pairs(game:GetService("Players"):GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local pos, vis = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                if vis then
                    local m = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
                    if m < d then t = p.Character.HumanoidRootPart; d = m end
                end
            end
        end
        if t then Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Position) end
    end
end)

-- Inf Jump
UIS.JumpRequest:Connect(function()
    if _G.InfJump and LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
        LP.Character:FindFirstChildOfClass("Humanoid"):ChangeState(3)
    end
end)

-- Keybinds
UIS.InputBegan:Connect(function(i, g)
    if not g then
        if i.KeyCode == Enum.KeyCode.Insert then main.Visible = not main.Visible end
        if i.KeyCode == Enum.KeyCode.E then _G.Fly = not _G.Fly end
    end
end)

print("Emden Ultimate V10 Loaded! - INSERT: Menu")

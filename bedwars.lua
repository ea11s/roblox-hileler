-- [[ SIERRA BEDWARS V24 - TEAM CHECK & INF JUMP ]] --
repeat task.wait() until game:IsLoaded()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local settings = {
    hitbox = false,
    hSize = 12,
    killAura = false,
    infJump = false,
    speed = false,
    noKB = false,
    esp = false,
    sVal = 23,
    toggleKey = Enum.KeyCode.RightControl
}

-- --- UI ---
local sg = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
sg.Name = "SierraV24"; sg.ResetOnSpawn = false

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 230, 0, 500)
frame.Position = UDim2.new(0.7, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(10, 20, 10)
frame.Active = true; frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, -10, 1, -50); scroll.Position = UDim2.new(0, 5, 0, 45); scroll.BackgroundTransparency = 1; scroll.CanvasSize = UDim2.new(0, 0, 0, 600)
Instance.new("UIListLayout", scroll).HorizontalAlignment = "Center"; Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 5)

local function cB(t, f)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(0.9, 0, 0, 35); b.BackgroundColor3 = Color3.fromRGB(20, 40, 20); b.Text = t; b.TextColor3 = Color3.new(1,1,1); b.Font = "Gotham"
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    b.MouseButton1Click:Connect(function() f(b) end)
end

-- --- BUTONLAR ---
cB("HITBOX (DÜŞMAN): OFF", function(b) settings.hitbox = not settings.hitbox; b.Text = "HITBOX: "..(settings.hitbox and "ON" or "OFF") end)
cB("HITBOX BOYUT: "..settings.hSize, function(b) settings.hSize = (settings.hSize >= 25) and 5 or settings.hSize + 5; b.Text = "SIZE: "..settings.hSize end)
cB("KILL AURA: OFF", function(b) settings.killAura = not settings.killAura; b.Text = "AURA: "..(settings.killAura and "ON" or "OFF") end)
cB("INF JUMP: OFF", function(b) settings.infJump = not settings.infJump; b.Text = "JUMP: "..(settings.infJump and "ON" or "OFF") end)
cB("SPEED (VELO): OFF", function(b) settings.speed = not settings.speed; b.Text = "SPEED: "..(settings.speed and "ON" or "OFF") end)
cB("NO KNOCKBACK: OFF", function(b) settings.noKB = not settings.noKB; b.Text = "NO-KB: "..(settings.noKB and "ON" or "OFF") end)
cB("ESP: OFF", function(b) settings.esp = not settings.esp; b.Text = "ESP: "..(settings.esp and "ON" or "OFF") end)

-- --- MEKANİKLER ---
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local hum = char:FindFirstChildOfClass("Humanoid")

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            -- TAKIM KONTROLÜ (Sadece düşmanlara çalışır)
            if p.Team ~= LocalPlayer.Team then
                local eHRP = p.Character.HumanoidRootPart
                local dist = (hrp.Position - eHRP.Position).Magnitude

                -- Gelişmiş Hitbox (Sadece Düşman)
                if settings.hitbox then
                    eHRP.Size = Vector3.new(settings.hSize, settings.hSize, settings.hSize)
                    eHRP.Transparency = 0.8
                    eHRP.CanCollide = false
                else
                    eHRP.Size = Vector3.new(2, 2, 1)
                    eHRP.Transparency = 1
                end

                -- Kill Aura (Mesafe Kontrollü)
                if settings.killAura and dist < 22 then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, eHRP.Position)
                end
            end
        end
    end

    -- Speed & NoKB
    if settings.speed and hum.MoveDirection.Magnitude > 0 then
        hrp.Velocity = Vector3.new(hum.MoveDirection.X * settings.sVal, hrp.Velocity.Y, hum.MoveDirection.Z * settings.sVal)
    end
    if settings.noKB then hrp.Velocity = Vector3.new(0, hrp.Velocity.Y, 0) end
end)

-- Sınırsız Zıplama (Inf Jump)
UserInputService.JumpRequest:Connect(function()
    if settings.infJump and LocalPlayer.Character then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(3)
    end
end)

-- ESP
task.spawn(function()
    while task.wait(1) do
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hl = p.Character:FindFirstChild("S24") or Instance.new("Highlight", p.Character)
                hl.Name = "S24"; hl.Enabled = settings.esp; hl.FillColor = (p.Team == LocalPlayer.Team) and Color3.new(0,1,0) or Color3.new(1,0,0); hl.DepthMode = "AlwaysOnTop"
            end
        end
    end
end)

-- Menü Kapat Aç (Sağ CTRL)
UserInputService.InputBegan:Connect(function(i, p)
    if not p and i.KeyCode == settings.toggleKey then frame.Visible = not frame.Visible end
end)

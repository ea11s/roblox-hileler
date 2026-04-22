-- [[ SIERRA BEDWARS V26 - ULTIMATE BYPASS ]] --
repeat task.wait() until game:IsLoaded()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local settings = {
    reach = false,
    killAura = false,
    speed = false,
    noKB = false,
    noFall = false,
    infJump = false,
    esp = false,
    rSize = 15, -- Reach Mesafesi
    sPower = 24, -- Speed Gücü
    toggleKey = Enum.KeyCode.RightControl
}

-- --- UI TASARIMI ---
local sg = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
sg.Name = "SierraV26"; sg.ResetOnSpawn = false

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 240, 0, 520)
frame.Position = UDim2.new(0.7, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
frame.Active = true; frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, -10, 1, -50); scroll.Position = UDim2.new(0, 5, 0, 45); scroll.BackgroundTransparency = 1; scroll.CanvasSize = UDim2.new(0, 0, 0, 650)
Instance.new("UIListLayout", scroll).HorizontalAlignment = "Center"; Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 6)

local function cB(t, f)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(0.9, 0, 0, 35); b.BackgroundColor3 = Color3.fromRGB(20, 25, 40); b.Text = t; b.TextColor3 = Color3.new(1, 1, 1); b.Font = "Gotham"
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(function() f(b) end)
end

-- --- ÖZELLİKLER ---
cB("REACH & HITBOX: OFF", function(b) settings.reach = not settings.reach; b.Text = "REACH: "..(settings.reach and "ON" or "OFF") end)
cB("KILL AURA: OFF", function(b) settings.killAura = not settings.killAura; b.Text = "AURA: "..(settings.killAura and "ON" or "OFF") end)
cB("SPEED (BYPASS): OFF", function(b) settings.speed = not settings.speed; b.Text = "SPEED: "..(settings.speed and "ON" or "OFF") end)
cB("NO KNOCKBACK: OFF", function(b) settings.noKB = not settings.noKB; b.Text = "NO-KB: "..(settings.noKB and "ON" or "OFF") end)
cB("NO FALL DAMAGE: OFF", function(b) settings.noFall = not settings.noFall; b.Text = "NO FALL: "..(settings.noFall and "ON" or "OFF") end)
cB("INF JUMP: OFF", function(b) settings.infJump = not settings.infJump; b.Text = "JUMP: "..(settings.infJump and "ON" or "OFF") end)
cB("ESP (TEAMS): OFF", function(b) settings.esp = not settings.esp; b.Text = "ESP: "..(settings.esp and "ON" or "OFF") end)

-- --- ANA DÖNGÜ ---
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local hum = char:FindFirstChildOfClass("Humanoid")

    -- 1. NO FALL DAMAGE (Sürekli hızı kontrol eder)
    if settings.noFall and hrp.Velocity.Y < -30 then
        hrp.Velocity = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z)
    end

    -- 2. BYPASS SPEED (Anti-Cheat'e takılmayan ivme)
    if settings.speed and hum.MoveDirection.Magnitude > 0 then
        hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (settings.sPower/100))
    end

    -- 3. NO KNOCKBACK (Sabitleyici)
    if settings.noKB then
        hrp.Velocity = Vector3.new(0, hrp.Velocity.Y, 0)
    end

    -- 4. REACH & KILL AURA & TEAM CHECK
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Team ~= LocalPlayer.Team then
            local eHRP = p.Character.HumanoidRootPart
            local dist = (hrp.Position - eHRP.Position).Magnitude

            -- Reach & Hitbox Expand (Sadece düşmana)
            if settings.reach then
                eHRP.Size = Vector3.new(settings.rSize, settings.rSize, settings.rSize)
                eHRP.Transparency = 0.7
                eHRP.CanCollide = false
            else
                eHRP.Size = Vector3.new(2, 2, 1)
                eHRP.Transparency = 1
            end

            -- Kill Aura (Menzildeyse kamerayı kilitler)
            if settings.killAura and dist < 25 then
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, eHRP.Position), 0.2)
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

-- ESP
task.spawn(function()
    while task.wait(1) do
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hl = p.Character:FindFirstChild("S26") or Instance.new("Highlight", p.Character)
                hl.Name = "S26"; hl.Enabled = settings.esp; 
                hl.FillColor = (p.Team == LocalPlayer.Team) and Color3.new(0,1,0) or Color3.new(1,0,0);
                hl.DepthMode = "AlwaysOnTop"
            end
        end
    end
end)

-- MENÜ KONTROL (SAĞ CTRL)
UserInputService.InputBegan:Connect(function(i, p)
    if not p and i.KeyCode == settings.toggleKey then frame.Visible = not frame.Visible end
end)

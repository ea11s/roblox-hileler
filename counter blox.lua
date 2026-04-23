-- [[ SIERRA V25.1 - STATE OF ANARCHY FINAL ]] --
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local settings = {
    silentAim = false,
    noRecoil = false,
    esp = false,
    itemEsp = false,
    speed = false,
    infJump = false,
    hitbox = false,
    hSize = 10,
    sVal = 0.4, 
    toggleKey = Enum.KeyCode.RightControl
}

-- --- UI ---
local sg = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
sg.Name = "SierraSOA_V25"; sg.ResetOnSpawn = false

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 230, 0, 480)
frame.Position = UDim2.new(0.75, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
frame.Active = true; frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40); title.Text = "SIERRA V25.1 - SOA"; title.TextColor3 = Color3.fromRGB(255, 170, 0)
title.BackgroundTransparency = 1; title.Font = "GothamBold"; title.TextSize = 14

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, -10, 1, -50); scroll.Position = UDim2.new(0, 5, 0, 45)
scroll.BackgroundTransparency = 1; scroll.CanvasSize = UDim2.new(0, 0, 0, 500); scroll.ScrollBarThickness = 2
Instance.new("UIListLayout", scroll).HorizontalAlignment = "Center"; Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 5)

local function cB(t, f)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(0.9, 0, 0, 35); b.BackgroundColor3 = Color3.fromRGB(30, 30, 40); b.Text = t; b.TextColor3 = Color3.new(1,1,1); b.Font = "Gotham"
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    b.MouseButton1Click:Connect(function() f(b) end)
end

-- --- BUTONLAR ---
cB("SILENT AIM: OFF", function(b) settings.silentAim = not settings.silentAim; b.Text = "SILENT AIM: "..(settings.silentAim and "ON" or "OFF") end)
cB("NO-RECOIL: OFF", function(b) settings.noRecoil = not settings.noRecoil; b.Text = "NO-RECOIL: "..(settings.noRecoil and "ON" or "OFF") end)
cB("PLAYER ESP: OFF", function(b) settings.esp = not settings.esp; b.Text = "PLAYER ESP: "..(settings.esp and "ON" or "OFF") end)
cB("ITEM ESP: OFF", function(b) settings.itemEsp = not settings.itemEsp; b.Text = "ITEM ESP: "..(settings.itemEsp and "ON" or "OFF") end)
cB("HITBOX: OFF", function(b) settings.hitbox = not settings.hitbox; b.Text = "HITBOX: "..(settings.hitbox and "ON" or "OFF") end)
cB("SPEED: OFF", function(b) settings.speed = not settings.speed; b.Text = "SPEED: "..(settings.speed and "ON" or "OFF") end)
cB("INF JUMP: OFF", function(b) settings.infJump = not settings.infJump; b.Text = "INF JUMP: "..(settings.infJump and "ON" or "OFF") end)

-- --- MEKANİKLER ---
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local hum = char:FindFirstChildOfClass("Humanoid")

    -- SPEED
    if settings.speed and hum.MoveDirection.Magnitude > 0 then
        hrp.CFrame = hrp.CFrame + (hum.MoveDirection * settings.sVal)
    end

    -- SILENT AIM
    if settings.silentAim and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = nil
        local dist = 400
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
                local pos, vis = Camera:WorldToViewportPoint(v.Character.Head.Position)
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if vis and mag < dist then dist = mag; target = v end
            end
        end
        if target then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Character.Head.Position), 0.2)
        end
    end
end)

-- FIXED INF JUMP (Artık Menüyle Tam Entegre)
UserInputService.JumpRequest:Connect(function()
    if settings.infJump then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.Velocity = Vector3.new(char.HumanoidRootPart.Velocity.X, 50, char.HumanoidRootPart.Velocity.Z)
        end
    end
end)

-- NO RECOIL LOOP
task.spawn(function()
    while task.wait(1) do
        if settings.noRecoil then
            for _, v in pairs(getgc(true)) do
                if type(v) == "table" and (rawget(v, "Recoil") or rawget(v, "Spread")) then
                    v.Recoil = 0; v.MaxRecoil = 0; v.Spread = 0
                end
            end
        end
    end
end)

-- ESP & HITBOX LOOP
task.spawn(function()
    while task.wait(1) do
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                -- ESP
                local hl = p.Character:FindFirstChild("SierraESP") or Instance.new("Highlight", p.Character)
                hl.Name = "SierraESP"; hl.Enabled = settings.esp; hl.DepthMode = "AlwaysOnTop"
                -- HITBOX
                if settings.hitbox then
                    p.Character.HumanoidRootPart.Size = Vector3.new(settings.hSize, settings.hSize, settings.hSize)
                    p.Character.HumanoidRootPart.Transparency = 0.8; p.Character.HumanoidRootPart.CanCollide = false
                else
                    p.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1); p.Character.HumanoidRootPart.Transparency = 1
                end
            end
        end
    end
end)

-- ITEM ESP
task.spawn(function()
    while task.wait(2) do
        if settings.itemEsp then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Model") and (v:FindFirstChild("Handle") or v.Name:find("Case") or v.Name:find("Box")) then
                    if not v:FindFirstChild("SierraItem") then
                        local b = Instance.new("BillboardGui", v); b.Name = "SierraItem"; b.AlwaysOnTop = true; b.Size = UDim2.new(0, 100, 0, 50)
                        local t = Instance.new("TextLabel", b); t.Size = UDim2.new(1, 0, 1, 0); t.BackgroundTransparency = 1; t.Text = v.Name; t.TextColor3 = Color3.new(0, 1, 1); t.TextSize = 10
                    end
                    v.SierraItem.Enabled = true
                end
            end
        else
            for _, v in pairs(workspace:GetDescendants()) do
                if v.Name == "SierraItem" then v.Enabled = false end
            end
        end
    end
end)

-- TOGGLE MENU
UserInputService.InputBegan:Connect(function(i, p)
    if not p and i.KeyCode == settings.toggleKey then frame.Visible = not frame.Visible end
end)

print("Sierra V25.1 Ready!")

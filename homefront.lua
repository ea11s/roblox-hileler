-- [[ HOMEFRONT & SIERRA - UNIVERSAL ULTIMATE V20 ]] --
repeat task.wait() until game:IsLoaded()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- --- AYARLAR ---
local settings = {
    esp = false, aim = false, jump = false, 
    speed = false, carFly = false, recoil = false,
    cross = false, noFall = false,
    wSpeed = 40, cFlySpeed = 100, fov = 150,
    toggleKey = Enum.KeyCode.RightControl
}
local isBinding = false

-- --- ÇİZİMLER (FOV & CROSSHAIR) ---
local fCircle = Drawing.new("Circle")
fCircle.Thickness = 2; fCircle.Color = Color3.fromRGB(0, 255, 150); fCircle.Visible = false

local cLines = {H1 = Drawing.new("Line"), H2 = Drawing.new("Line"), V1 = Drawing.new("Line"), V2 = Drawing.new("Line")}
for _, l in pairs(cLines) do l.Thickness = 2; l.Color = Color3.new(1,1,1); l.Visible = false end

-- --- UI TASARIMI ---
local sg = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
sg.Name = "UniversalV20"; sg.ResetOnSpawn = false

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 230, 0, 480)
frame.Position = UDim2.new(0, 50, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
frame.Active = true; frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40); title.Text = "HOMEFRONT V20"; title.TextColor3 = Color3.new(0, 1, 0.5); title.Font = "GothamBold"; title.BackgroundTransparency = 1

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, -10, 1, -50); scroll.Position = UDim2.new(0, 5, 0, 45); scroll.BackgroundTransparency = 1; scroll.CanvasSize = UDim2.new(0, 0, 0, 650); scroll.ScrollBarThickness = 2
Instance.new("UIListLayout", scroll).HorizontalAlignment = "Center"; Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 5)

-- --- BUTON YAPICI ---
local function cB(t, f)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(0.9, 0, 0, 35); b.BackgroundColor3 = Color3.fromRGB(30, 30, 30); b.Text = t; b.TextColor3 = Color3.new(1, 1, 1); b.Font = "Gotham"
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(function() f(b) end)
end

-- --- BUTONLAR ---
cB("ESP: OFF", function(b) settings.esp = not settings.esp; b.Text = "ESP: "..(settings.esp and "ON" or "OFF") end)
cB("AIMBOT: OFF", function(b) settings.aim = not settings.aim; b.Text = "AIM: "..(settings.aim and "ON" or "OFF") end)
cB("NO FALL DMG: OFF", function(b) settings.noFall = not settings.noFall; b.Text = "FALL: "..(settings.noFall and "ON" or "OFF") end)
cB("NO RECOIL: OFF", function(b) settings.recoil = not settings.recoil; b.Text = "RECOIL: "..(settings.recoil and "ON" or "OFF") end)
cB("SPEED: OFF", function(b) settings.speed = not settings.speed; b.Text = "SPEED: "..(settings.speed and "ON" or "OFF") end)
cB("SPD ARTIR (+20)", function(b) settings.wSpeed = (settings.wSpeed > 150) and 20 or settings.wSpeed + 20; b.Text = "SPD: "..settings.wSpeed end)
cB("CAR FLY: OFF", function(b) settings.carFly = not settings.carFly; b.Text = "CAR FLY: "..(settings.carFly and "ON" or "OFF") end)
cB("INF JUMP: OFF", function(b) settings.jump = not settings.jump; b.Text = "JUMP: "..(settings.jump and "ON" or "OFF") end)
cB("CROSSHAIR: OFF", function(b) settings.cross = not settings.cross; b.Text = "CROSS: "..(settings.cross and "ON" or "OFF") end)
cB("FOV: "..settings.fov, function(b) settings.fov = (settings.fov >= 500) and 50 or settings.fov + 50; b.Text = "FOV: "..settings.fov end)
local bindB = cB("BIND: CTRL", function(b) isBinding = true; b.Text = "...BAS..." end)

-- --- MEKANİKLER ---
RunService.RenderStepped:Connect(function(delta)
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local mLoc = UserInputService:GetMouseLocation()

    -- Crosshair & FOV
    fCircle.Position = mLoc; fCircle.Radius = settings.fov; fCircle.Visible = settings.aim
    if settings.cross and not frame.Visible then
        local s, g = 10, 5
        cLines.H1.From = Vector2.new(mLoc.X-g-s, mLoc.Y); cLines.H1.To = Vector2.new(mLoc.X-g, mLoc.Y)
        cLines.H2.From = Vector2.new(mLoc.X+g, mLoc.Y); cLines.H2.To = Vector2.new(mLoc.X+g+s, mLoc.Y)
        cLines.V1.From = Vector2.new(mLoc.X, mLoc.Y-g-s); cLines.V1.To = Vector2.new(mLoc.X, mLoc.Y-g)
        cLines.V2.From = Vector2.new(mLoc.X, mLoc.Y+g); cLines.V2.To = Vector2.new(mLoc.X, mLoc.Y+g+s)
        for _,l in pairs(cLines) do l.Visible = true end
    else for _,l in pairs(cLines) do l.Visible = false end end

    -- Speed Hack (CFrame - AntiCheat Safe)
    if settings.speed and hrp and hum and hum.MoveDirection.Magnitude > 0 then
        hrp.CFrame = hrp.CFrame + (hum.MoveDirection * settings.wSpeed * delta)
    end

    -- No Fall Damage (Homefront uyumlu hız freni)
    if settings.noFall and hrp and hrp.Velocity.Y < -35 then
        hrp.Velocity = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z)
    end

    -- Aimbot & No Recoil
    if settings.aim or settings.recoil then
        local target = nil
        local dist = settings.fov
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local pos, vis = Camera:WorldToScreenPoint(p.Character.Head.Position)
                local mag = (Vector2.new(pos.X, pos.Y) - mLoc).Magnitude
                if vis and mag < dist then dist = mag; target = p.Character.Head.Position end
            end
        end
        if target and settings.aim then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target), 0.15)
        end
        if settings.recoil then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, Mouse.Hit.Position), 0.05)
        end
    end

    -- Car Fly (Homefront Araç Sistemine Uygun)
    if settings.carFly and hum and hum.SeatPart then
        local root = hum.SeatPart.Parent:FindFirstChildWhichIsA("BasePart", true)
        if root then
            local v = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then v = v + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then v = v - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then v = v + Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then v = v - Vector3.new(0,1,0) end
            root.Velocity = v * settings.cFlySpeed; root.RotVelocity = Vector3.new(0,0,0)
        end
    end
end)

-- --- ESP SİSTEMİ (TAGS + DISTANCE) ---
task.spawn(function()
    while task.wait(0.5) do
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                -- Highlight
                local hl = p.Character:FindFirstChild("UniversalHL") or Instance.new("Highlight", p.Character)
                hl.Name = "UniversalHL"; hl.Enabled = settings.esp; hl.FillColor = Color3.new(1,0.2,0.2); hl.DepthMode = "AlwaysOnTop"
                
                -- Distance Tag
                local tag = p.Character:FindFirstChild("UniversalTag") or Instance.new("BillboardGui", p.Character)
                if tag.Name ~= "UniversalTag" then
                    tag.Name = "UniversalTag"; tag.Size = UDim2.new(0,100,0,40); tag.AlwaysOnTop = true; tag.Adornee = p.Character:FindFirstChild("Head")
                    local lbl = Instance.new("TextLabel", tag)
                    lbl.Size = UDim2.new(1,0,1,0); lbl.BackgroundTransparency = 1; lbl.TextColor3 = Color3.new(1,1,1); lbl.Font = "GothamBold"; lbl.TextSize = 10
                end
                tag.Enabled = settings.esp
                if settings.esp and p.Character:FindFirstChild("HumanoidRootPart") then
                    local d = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude)
                    tag.TextLabel.Text = p.Name .. "\n[" .. d .. "m]"
                end
            end
        end
    end
end)

-- --- TUŞ KONTROLLERİ ---
UserInputService.InputBegan:Connect(function(i, p)
    if isBinding then 
        settings.toggleKey = i.KeyCode; isBinding = false; bindB.Text = "BIND: "..i.KeyCode.Name
    elseif not p and i.KeyCode == settings.toggleKey then 
        frame.Visible = not frame.Visible 
    end
end)
UserInputService.JumpRequest:Connect(function() 
    if settings.jump and LocalPlayer.Character then 
        local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h:ChangeState(3) end 
    end 
end)

print("UNIVERSAL V20 - HOMEFRONT & SIERRA LOADED")

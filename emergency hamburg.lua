-- [[ ER:LC ULTIMATE MASTER V8.0 BY RoWnn0 ]] --
-- [[ AIMBOT + ESP + TABBED UI + FULL BYPASS ]] --

-- ESKİ MENÜLERİ İMHA ET
for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
    if v.Name:find("RoWnn0") or v.Name:find("REVENGE") then v:Destroy() end
end

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Mouse = LP:GetMouse()
local Camera = workspace.CurrentCamera

-- --- SETTINGS ---
_G.Aimbot = false
_G.AimPart = "Head"
_G.WallCheck = false
_G.AimDist = 500
_G.FOVSize = 150
_G.ESP = false
_G.Tracers = false
_G.InfJump = false
_G.Speed = 0.4
_G.SpeedEnabled = false

-- FOV ÇEMBERİ
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2; FOVCircle.Color = Color3.new(1, 0, 0); FOVCircle.Visible = false

-- --- UI SETUP ---
local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "RoWnn0_V8_Master"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 550, 0, 400); main.Position = UDim2.new(0.5, -275, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 18); main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

-- Rainbow Glow
local glow = Instance.new("Frame", main)
glow.Size = UDim2.new(1, 6, 1, 6); glow.Position = UDim2.new(0, -3, 0, -3); glow.ZIndex = 0
Instance.new("UICorner", glow).CornerRadius = UDim.new(0, 12)
spawn(function() while wait() do glow.BackgroundColor3 = Color3.fromHSV(tick() % 5 / 5, 0.7, 1) end end)

-- Sidebar
local side = Instance.new("Frame", main)
side.Size = UDim2.new(0, 140, 1, 0); side.BackgroundColor3 = Color3.fromRGB(20, 20, 25); side.BorderSizePixel = 0
Instance.new("UICorner", side)

local container = Instance.new("Frame", main)
container.Size = UDim2.new(1, -150, 1, -20); container.Position = UDim2.new(0, 145, 0, 10); container.BackgroundTransparency = 1

local function CreateTab(name, order)
    local b = Instance.new("TextButton", side)
    b.Size = UDim2.new(1, -20, 0, 35); b.Position = UDim2.new(0, 10, 0, 20 + (order * 40))
    b.Text = name; b.BackgroundColor3 = Color3.fromRGB(30, 30, 35); b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold; b.TextSize = 12; Instance.new("UICorner", b)
    
    local p = Instance.new("ScrollingFrame", container)
    p.Size = UDim2.new(1, 0, 1, 0); p.Visible = (order == 0); p.BackgroundTransparency = 1; p.ScrollBarThickness = 0
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 8)
    
    b.MouseButton1Click:Connect(function()
        for _, x in pairs(container:GetChildren()) do if x:IsA("ScrollingFrame") then x.Visible = false end end
        p.Visible = true
    end)
    return p
end

local aimTab = CreateTab("AIMBOT", 0)
local espTab = CreateTab("VISUALS", 1)
local miscTab = CreateTab("MISC", 2)
local credTab = CreateTab("CREDITS", 3)

-- --- UI COMPONENTS ---
local function AddToggle(parent, text, callback)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, -10, 0, 35); b.Text = text .. " [OFF]"; b.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    b.TextColor3 = Color3.new(0.8, 0.8, 0.8); b.Font = Enum.Font.Gotham; Instance.new("UICorner", b)
    local act = false
    b.MouseButton1Click:Connect(function()
        act = not act; b.Text = text .. (act and " [ON]" or " [OFF]")
        b.BackgroundColor3 = act and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(35, 35, 40)
        callback(act)
    end)
end

-- --- 🛠️ AIMBOT LOGIC ---
local function GetClosest()
    local target, lowestDist = nil, _G.FOVSize
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild(_G.AimPart) then
            local pos, vis = Camera:WorldToViewportPoint(p.Character[_G.AimPart].Position)
            local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
            if mag < lowestDist and vis then
                if _G.WallCheck then
                    local ray = Camera:ViewportPointToRay(pos.X, pos.Y)
                    local part = workspace:FindPartOnRayWithIgnoreList(Ray.new(ray.Origin, ray.Direction * _G.AimDist), {LP.Character, p.Character})
                    if not part then target = p; lowestDist = mag end
                else
                    target = p; lowestDist = mag
                end
            end
        end
    end
    return target
end

RS.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36); FOVCircle.Radius = _G.FOVSize
    if _G.Aimbot and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local t = GetClosest()
        if t then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Character[_G.AimPart].Position)
        end
    end
end)

-- --- 🛠️ FEATURES ---
AddToggle(aimTab, "Aimbot (Right Click)", function(v) _G.Aimbot = v; FOVCircle.Visible = v end)
AddToggle(aimTab, "Wall Check", function(v) _G.WallCheck = v end)

AddToggle(espTab, "Box ESP", function(v) _G.ESP = v end)
AddToggle(espTab, "Tracers", function(v) _G.Tracers = v end)

AddToggle(miscTab, "Bypass Speed (Safe)", function(v) _G.SpeedEnabled = v end)
AddToggle(miscTab, "Infinite Jump", function(v) _G.InfJump = v end)

-- CREDITS
local c = Instance.new("TextLabel", credTab)
c.Size = UDim2.new(1, 0, 0, 100); c.Text = "RoWnn0 YouTube\n\nBu hile Hamburg banından\nsonra intikam için yapıldı."; c.TextColor3 = Color3.new(1,1,1); c.BackgroundTransparency = 1; c.Font = Enum.Font.GothamBold

-- --- ⚙️ MOTORLAR ---
RS.RenderStepped:Connect(function()
    if _G.SpeedEnabled and LP.Character and LP.Character:FindFirstChild("Humanoid") then
        if LP.Character.Humanoid.MoveDirection.Magnitude > 0 then
            LP.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame + (LP.Character.Humanoid.MoveDirection * _G.Speed)
        end
    end
end)

UIS.JumpRequest:Connect(function() if _G.InfJump then LP.Character.Humanoid:ChangeState(3) end end)

-- ESP & TRACERS ENGINE
local function HandleESP(p)
    local l = Drawing.new("Line"); local t = Drawing.new("Text")
    RS.RenderStepped:Connect(function()
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p ~= LP then
            local pos, vis = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            l.Visible = _G.Tracers and vis; t.Visible = _G.ESP and vis
            if vis then
                l.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y); l.To = Vector2.new(pos.X, pos.Y); l.Color = Color3.new(1,1,1)
                t.Position = Vector2.new(pos.X, pos.Y - 20); t.Text = p.Name .. " [" .. math.floor((LP.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude) .. "m]"; t.Center = true; t.Size = 14; t.Color = Color3.new(1,1,1); t.Outline = true
            end
        else l.Visible = false; t.Visible = false end
    end)
end
for _, p in pairs(Players:GetPlayers()) do HandleESP(p) end
Players.PlayerAdded:Connect(HandleESP)

-- TOGGLE
UIS.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.Insert then main.Visible = not main.Visible end end)

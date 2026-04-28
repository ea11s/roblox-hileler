-- [[ ER:LC ULTIMATE CLEAN BY RoWnn0 ]] --
-- [[ AIMBOT + NAME ESP + TRACERS + INF JUMP ]] --

for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
    if v.Name:find("RoWnn0") then v:Destroy() end
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
_G.FOVSize = 150
_G.ESP = false
_G.Tracers = false
_G.InfJump = false
_G.SpeedValue = 0.4
_G.SpeedEnabled = false

local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2; FOVCircle.Color = Color3.new(1, 0, 0); FOVCircle.Visible = false

-- --- UI SETUP ---
local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "RoWnn0_Clean_V85"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 500, 0, 350); main.Position = UDim2.new(0.5, -250, 0.5, -175)
main.BackgroundColor3 = Color3.fromRGB(12, 12, 15); main.BorderSizePixel = 0
Instance.new("UICorner", main)

local side = Instance.new("Frame", main)
side.Size = UDim2.new(0, 130, 1, 0); side.BackgroundColor3 = Color3.fromRGB(18, 18, 22); side.BorderSizePixel = 0
Instance.new("UICorner", side)

local container = Instance.new("Frame", main)
container.Size = UDim2.new(1, -140, 1, -20); container.Position = UDim2.new(0, 135, 0, 10); container.BackgroundTransparency = 1

local function CreateTab(name, order)
    local b = Instance.new("TextButton", side)
    b.Size = UDim2.new(1, -16, 0, 32); b.Position = UDim2.new(0, 8, 0, 15 + (order * 38))
    b.Text = name; b.BackgroundColor3 = Color3.fromRGB(30, 30, 35); b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold; b.TextSize = 11; Instance.new("UICorner", b)
    local p = Instance.new("ScrollingFrame", container)
    p.Size = UDim2.new(1, 0, 1, 0); p.Visible = (order == 0); p.BackgroundTransparency = 1; p.ScrollBarThickness = 0
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 6)
    b.MouseButton1Click:Connect(function()
        for _, x in pairs(container:GetChildren()) do if x:IsA("ScrollingFrame") then x.Visible = false end end
        p.Visible = true
    end)
    return p
end

local aimTab = CreateTab("AIMBOT", 0)
local espTab = CreateTab("ESP", 1)
local miscTab = CreateTab("MISC", 2)
local credTab = CreateTab("SOCIAL", 3)

local function AddToggle(parent, text, callback)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, -10, 0, 35); b.Text = text .. " [OFF]"; b.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    b.TextColor3 = Color3.new(0.8, 0.8, 0.8); b.Font = Enum.Font.Gotham; Instance.new("UICorner", b)
    local act = false
    b.MouseButton1Click:Connect(function()
        act = not act; b.Text = text .. (act and " [ON]" or " [OFF]")
        b.BackgroundColor3 = act and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(35, 35, 40)
        callback(act)
    end)
end

-- --- 🛠️ LOGIC ---
local function GetClosest()
    local target, lowestDist = nil, _G.FOVSize
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("Head") then
            local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
            local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
            if mag < lowestDist and vis then target = p; lowestDist = mag end
        end
    end
    return target
end

RS.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36); FOVCircle.Radius = _G.FOVSize
    if _G.Aimbot and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local t = GetClosest()
        if t then Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Character.Head.Position) end
    end
    if _G.SpeedEnabled and LP.Character and LP.Character:FindFirstChild("Humanoid") then
        if LP.Character.Humanoid.MoveDirection.Magnitude > 0 then
            LP.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame + (LP.Character.Humanoid.MoveDirection * _G.SpeedValue)
        end
    end
end)

-- --- ⚙️ ESP ENGINE ---
local function ApplyESP(p)
    local line = Drawing.new("Line"); local text = Drawing.new("Text")
    RS.RenderStepped:Connect(function()
        if p.Character and p.Character:FindFirstChild("Head") and p ~= LP then
            local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
            line.Visible = _G.Tracers and vis; text.Visible = _G.ESP and vis
            if vis then
                line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y); line.To = Vector2.new(pos.X, pos.Y)
                line.Color = (p.Team and p.Team.Name:find("Pol")) and Color3.new(1,0,0) or Color3.new(1,1,1)
                text.Position = Vector2.new(pos.X, pos.Y - 25); text.Text = p.Name; text.Center = true; text.Size = 14; text.Color = line.Color; text.Outline = true
            end
        else line.Visible = false; text.Visible = false end
    end)
end
for _, p in pairs(Players:GetPlayers()) do ApplyESP(p) end
Players.PlayerAdded:Connect(ApplyESP)

-- --- FEATURES ---
AddToggle(aimTab, "Aimbot (Right Click)", function(v) _G.Aimbot = v; FOVCircle.Visible = v end)
AddToggle(espTab, "Name ESP", function(v) _G.ESP = v end)
AddToggle(espTab, "Tracers", function(v) _G.Tracers = v end)
AddToggle(miscTab, "Safe Speed", function(v) _G.SpeedEnabled = v end)
AddToggle(miscTab, "Inf Jump", function(v) _G.InfJump = v end)

-- SOCIAL TAB
local yt = Instance.new("TextButton", credTab)
yt.Size = UDim2.new(1, -10, 0, 45); yt.Text = "YouTube: RoWnn0"; yt.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
yt.TextColor3 = Color3.new(1, 1, 1); yt.Font = Enum.Font.GothamBold; Instance.new("UICorner", yt)
yt.MouseButton1Click:Connect(function() setclipboard("https://www.youtube.com/@RoWnn0") end)

UIS.JumpRequest:Connect(function() if _G.InfJump then LP.Character.Humanoid:ChangeState(3) end end)
UIS.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.Insert then main.Visible = not main.Visible end end)

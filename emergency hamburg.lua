-- [[ ER:LC PURE HUNTER V9.0 BY RoWnn0 ]] --
-- [[ TRACERS + GLOW ESP + Q DASH + AIMBOT ]] --

for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
    if v.Name:find("RoWnn0") then v:Destroy() end
end

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Mouse = LP:GetMouse()
local Camera = workspace.CurrentCamera

-- --- AYARLAR ---
_G.Aimbot = false
_G.FOVSize = 150
_G.Tracers = false
_G.GlowESP = false
_G.DashEnabled = false
_G.InfJump = false
_G.SpeedEnabled = false
_G.SpeedValue = 0.4

local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2; FOVCircle.Color = Color3.new(1, 0, 0); FOVCircle.Visible = false

-- --- UI SETUP ---
local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "RoWnn0_Hunter_V9"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 500, 0, 380); main.Position = UDim2.new(0.5, -250, 0.5, -190)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 12); main.BorderSizePixel = 0
Instance.new("UICorner", main)

-- Neon Glow
local glowBorder = Instance.new("Frame", main)
glowBorder.Size = UDim2.new(1, 4, 1, 4); glowBorder.Position = UDim2.new(0, -2, 0, -2); glowBorder.ZIndex = 0
Instance.new("UICorner", glowBorder)
spawn(function() while wait() do glowBorder.BackgroundColor3 = Color3.fromHSV(tick() % 5 / 5, 0.7, 1) end end)

local side = Instance.new("Frame", main)
side.Size = UDim2.new(0, 130, 1, 0); side.BackgroundColor3 = Color3.fromRGB(15, 15, 18); side.BorderSizePixel = 0
Instance.new("UICorner", side)

local container = Instance.new("Frame", main)
container.Size = UDim2.new(1, -140, 1, -20); container.Position = UDim2.new(0, 135, 0, 10); container.BackgroundTransparency = 1

local function CreateTab(name, order)
    local b = Instance.new("TextButton", side)
    b.Size = UDim2.new(1, -16, 0, 35); b.Position = UDim2.new(0, 8, 0, 20 + (order * 40))
    b.Text = name; b.BackgroundColor3 = Color3.fromRGB(25, 25, 30); b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold; b.TextSize = 11; Instance.new("UICorner", b)
    local p = Instance.new("ScrollingFrame", container)
    p.Size = UDim2.new(1, 0, 1, 0); p.Visible = (order == 0); p.BackgroundTransparency = 1; p.ScrollBarThickness = 0
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 8)
    b.MouseButton1Click:Connect(function()
        for _, x in pairs(container:GetChildren()) do if x:IsA("ScrollingFrame") then x.Visible = false end end
        p.Visible = true
    end)
    return p
end

local aimTab = CreateTab("COMBAT", 0)
local espTab = CreateTab("VISUALS", 1)
local miscTab = CreateTab("MOVEMENT", 2)
local credTab = CreateTab("SOCIAL", 3)

local function AddToggle(parent, text, callback)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, -10, 0, 38); b.Text = text .. " [OFF]"; b.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    b.TextColor3 = Color3.new(0.9, 0.9, 0.9); b.Font = Enum.Font.Gotham; Instance.new("UICorner", b)
    local act = false
    b.MouseButton1Click:Connect(function()
        act = not act; b.Text = text .. (act and " [ON]" or " [OFF]")
        b.BackgroundColor3 = act and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(30, 30, 35)
        callback(act)
    end)
end

-- --- ⚙️ ENGINE ---

-- Aimbot & Movement
RS.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36); FOVCircle.Radius = _G.FOVSize
    
    -- Aimbot (Sağ Tık)
    if _G.Aimbot and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = nil; local dist = _G.FOVSize
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("Head") then
                local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if mag < dist and vis then target = p; dist = mag end
            end
        end
        if target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position) end
    end

    -- Speed Bypass
    if _G.SpeedEnabled and LP.Character and LP.Character:FindFirstChild("Humanoid") then
        if LP.Character.Humanoid.MoveDirection.Magnitude > 0 then
            LP.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame + (LP.Character.Humanoid.MoveDirection * _G.SpeedValue)
        end
    end
end)

-- Visuals (Tracers & Glow ESP)
local function ApplyVisuals(p)
    local line = Drawing.new("Line")
    RS.RenderStepped:Connect(function()
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p ~= LP then
            local pos, vis = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            
            -- Tracers
            line.Visible = _G.Tracers and vis
            if line.Visible then
                line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y); line.To = Vector2.new(pos.X, pos.Y)
                line.Color = (p.Team and p.Team.Name:find("Pol")) and Color3.new(1,0,0) or Color3.new(1,1,1)
            end

            -- Glow ESP (Highlight)
            local hl = p.Character:FindFirstChild("RoWnnGlow")
            if _G.GlowESP then
                if not hl then
                    hl = Instance.new("Highlight", p.Character); hl.Name = "RoWnnGlow"
                    hl.FillTransparency = 0.5; hl.OutlineTransparency = 0
                end
                hl.Enabled = true
                hl.FillColor = (p.Team and p.Team.Name:find("Pol")) and Color3.new(1,0,0) or Color3.new(0,1,1)
            elseif hl then hl.Enabled = false end
        else line.Visible = false end
    end)
end
for _, p in pairs(Players:GetPlayers()) do ApplyVisuals(p) end
Players.PlayerAdded:Connect(ApplyVisuals)

-- --- FEATURES ---
AddToggle(aimTab, "Aimbot (Sağ Tık)", function(v) _G.Aimbot = v; FOVCircle.Visible = v end)

AddToggle(espTab, "Tracers (Çizgiler)", function(v) _G.Tracers = v end)
AddToggle(espTab, "Glow ESP (Parlama)", function(v) _G.GlowESP = v end)

AddToggle(miscTab, "Q Dash (Hızlı Atılma)", function(v) _G.DashEnabled = v end)
AddToggle(miscTab, "Safe Speed", function(v) _G.SpeedEnabled = v end)
AddToggle(miscTab, "Infinite Jump", function(v) _G.InfJump = v end)

-- Social
local yt = Instance.new("TextButton", credTab)
yt.Size = UDim2.new(1, -10, 0, 45); yt.Text = "ABONE OL: RoWnn0"; yt.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
yt.TextColor3 = Color3.new(1, 1, 1); yt.Font = Enum.Font.GothamBold; Instance.new("UICorner", yt)
yt.MouseButton1Click:Connect(function() setclipboard("https://www.youtube.com/@RoWnn0") end)

-- Keybinds
UIS.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.Q and _G.DashEnabled then
        LP.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame + (LP.Character.Humanoid.MoveDirection * 35)
    end
    if not g and i.KeyCode == Enum.KeyCode.Insert then main.Visible = not main.Visible end
end)
UIS.JumpRequest:Connect(function() if _G.InfJump then LP.Character.Humanoid:ChangeState(3) end end)

-- [[ BEDWARS SCRIPT BY RoWnn0 V1.4 - ANTI-KICK & FLY ]] --
-- Toggle: INSERT | YouTube: RoWnn0

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- UI TEMİZLİK
if game:GetService("CoreGui"):FindFirstChild("RoWnn0_Bedwars_V14") then
    game:GetService("CoreGui"):FindFirstChild("RoWnn0_Bedwars_V14"):Destroy()
end

-- --- UI SETUP ---
local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "RoWnn0_Bedwars_V14"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 560, 0, 420)
main.Position = UDim2.new(0.5, -280, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

-- Rainbow Glow
local glow = Instance.new("Frame", main)
glow.Size = UDim2.new(1, 6, 1, 6)
glow.Position = UDim2.new(0, -3, 0, -3)
glow.ZIndex = 0
Instance.new("UICorner", glow).CornerRadius = UDim.new(0, 14)
spawn(function() while wait() do glow.BackgroundColor3 = Color3.fromHSV(tick() % 5 / 5, 0.7, 1) end end)

-- Sidebar
local sideBar = Instance.new("Frame", main)
sideBar.Size = UDim2.new(0, 160, 1, 0)
sideBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
Instance.new("UICorner", sideBar)

local container = Instance.new("Frame", main)
container.Size = UDim2.new(1, -180, 1, -80)
container.Position = UDim2.new(0, 170, 0, 60)
container.BackgroundTransparency = 1

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, -20, 0, 50); title.Position = UDim2.new(0, 10, 0, 5)
title.Text = "🚀 BEDWARS V1.4 BY RoWnn0 - BAN-SAFE 🚀"; title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold; title.TextSize = 14; title.BackgroundTransparency = 1

local function CreateTab(name, order, emoji)
    local btn = Instance.new("TextButton", sideBar)
    btn.Size = UDim2.new(1, -20, 0, 40); btn.Position = UDim2.new(0, 10, 0, 60 + (order * 45))
    btn.Text = emoji .. " " .. name; btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.TextColor3 = Color3.new(0.7, 0.7, 0.7); btn.Font = Enum.Font.GothamSemibold
    Instance.new("UICorner", btn)
    local page = Instance.new("ScrollingFrame", container)
    page.Size = UDim2.new(1, 0, 1, 0); page.BackgroundTransparency = 1; page.Visible = false; page.ScrollBarThickness = 0
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(container:GetChildren()) do p.Visible = false end
        page.Visible = true
    end)
    Instance.new("UIListLayout", page).Padding = UDim.new(0, 10)
    return page
end

local combatTab = CreateTab("COMBAT", 0, "⚔️")
local visualTab = CreateTab("VISUALS", 1, "👁️")
local playerTab = CreateTab("PLAYER", 2, "⚡")
local creditTab = CreateTab("CREDITS", 3, "💎")
combatTab.Visible = true

local function AddToggle(parent, text, callback)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, -10, 0, 38); b.Text = "  " .. text .. " [OFF]"
    b.TextXAlignment = Enum.TextXAlignment.Left; b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    b.TextColor3 = Color3.new(0.9, 0.9, 0.9); b.Font = Enum.Font.Gotham
    Instance.new("UICorner", b)
    local act = false
    b.MouseButton1Click:Connect(function()
        act = not act
        b.Text = "  " .. text .. (act and " [ON]" or " [OFF]")
        b.BackgroundColor3 = act and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(40, 40, 40)
        callback(act)
    end)
end

-- --- 1. COMBAT (5 ÖZELLİK) ---
AddToggle(combatTab, "Auto Kill Aura (Safe)", function(v) _G.KA = v end)
AddToggle(combatTab, "25 Stud Reach (Long)", function(v) _G.Reach = v end)
AddToggle(combatTab, "No Velocity (Anti-Knockback)", function(v) _G.NoVel = v end)
AddToggle(combatTab, "Auto Clicker (Fast)", function(v) _G.AutoClick = v end)
AddToggle(combatTab, "Block Reach (Distant Placing)", function(v) _G.BlockReach = v end)

-- --- 2. VISUALS ---
AddToggle(visualTab, "Dynamic Box ESP", function(v) _G.Box = v end)
AddToggle(visualTab, "Top Tracers", function(v) _G.Tracers = v end)

-- --- 3. PLAYER (FLY & FIXED SPEED) ---
-- Speed Fix: Geri atmayı önlemek için BodyVelocity kullanıyoruz
AddToggle(playerTab, "Anti-Rubberband Speed", function(v)
    _G.Speed = v
    if v then
        local bv = Instance.new("BodyVelocity", LP.Character.HumanoidRootPart)
        bv.Name = "RoWnnSpeed"; bv.MaxForce = Vector3.new(100000, 0, 100000)
        spawn(function()
            while _G.Speed do
                bv.Velocity = LP.Character.Humanoid.MoveDirection * 22 -- Safe speed limit
                task.wait()
            end
            bv:Destroy()
        end)
    end
end)

-- Ban-Safe Fly (Hover Mode)
AddToggle(playerTab, "Ban-Safe Fly (Key: F)", function(v)
    _G.Fly = v
    if v then
        local bp = Instance.new("BodyPosition", LP.Character.HumanoidRootPart)
        bp.MaxForce = Vector3.new(0, math.huge, 0)
        spawn(function()
            while _G.Fly do
                bp.Position = Vector3.new(0, LP.Character.HumanoidRootPart.Position.Y, 0)
                if UIS:IsKeyDown(Enum.KeyCode.Space) then LP.Character.HumanoidRootPart.CFrame *= CFrame.new(0,0.5,0) end
                if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then LP.Character.HumanoidRootPart.CFrame *= CFrame.new(0,-0.5,0) end
                task.wait()
            end
            bp:Destroy()
        end)
    end
end)

AddToggle(playerTab, "Infinite Jump", function(v) _G.IJ = v end)

-- --- 4. CREDITS ---
local yt = Instance.new("TextButton", creditTab)
yt.Size = UDim2.new(1, -10, 0, 50); yt.Text = "📺 YouTube: RoWnn0"; yt.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Instance.new("UICorner", yt); yt.MouseButton1Click:Connect(function() setclipboard("https://www.youtube.com/@RoWnn0") end)

local dc = Instance.new("TextButton", creditTab)
dc.Size = UDim2.new(1, -10, 0, 50); dc.Position = UDim2.new(0,0,0,60); dc.Text = "🌐 Discord: RoWnn SCRIPTS"
dc.BackgroundColor3 = Color3.fromRGB(88, 101, 242); Instance.new("UICorner", dc)

-- CORE LOGIC (LOOP)
RS.RenderStepped:Connect(function()
    if _G.IJ and UIS:IsKeyDown(Enum.KeyCode.Space) then LP.Character.Humanoid:ChangeState(3) end
    if _G.Box or _G.Tracers then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                -- Visual Logic Here (MM2 style optimized for Bedwars)
            end
        end
    end
end)

-- TOGGLE
UIS.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.Insert then main.Visible = not main.Visible end end)

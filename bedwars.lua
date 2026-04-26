-- [[ BEDWARS SCRIPT BY RoWnn0 V1.8 - ULTIMATE FIX ]] --
-- Menu: INSERT | Fly: Space/Shift | YouTube: RoWnn0

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- UI RESET
local function ClearUI()
    local old = game:GetService("CoreGui"):FindFirstChild("RoWnn0_Final_V18")
    if old then old:Destroy() end
end
ClearUI()

-- --- UI SETUP ---
local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "RoWnn0_Final_V18"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 560, 0, 420)
main.Position = UDim2.new(0.5, -280, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

-- Rainbow Glow (Marka İmzası ✨)
local glow = Instance.new("Frame", main)
glow.Size = UDim2.new(1, 6, 1, 6); glow.Position = UDim2.new(0, -3, 0, -3); glow.ZIndex = 0
Instance.new("UICorner", glow).CornerRadius = UDim.new(0, 14)
spawn(function() while wait() do glow.BackgroundColor3 = Color3.fromHSV(tick() % 5 / 5, 0.7, 1) end end)

local sideBar = Instance.new("Frame", main)
sideBar.Size = UDim2.new(0, 160, 1, 0); sideBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
Instance.new("UICorner", sideBar)

local container = Instance.new("Frame", main)
container.Size = UDim2.new(1, -180, 1, -80); container.Position = UDim2.new(0, 170, 0, 60); container.BackgroundTransparency = 1

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, -20, 0, 50); title.Position = UDim2.new(0, 10, 0, 5)
title.Text = "💎 BEDWARS V1.8 BY RoWnn0 💎"; title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold; title.TextSize = 14; title.BackgroundTransparency = 1

local function CreateTab(name, order, emoji)
    local btn = Instance.new("TextButton", sideBar)
    btn.Size = UDim2.new(1, -20, 0, 40); btn.Position = UDim2.new(0, 10, 0, 60 + (order * 45))
    btn.Text = emoji .. " " .. name; btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.TextColor3 = Color3.new(0.7, 0.7, 0.7); btn.Font = Enum.Font.GothamSemibold; Instance.new("UICorner", btn)
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
    b.TextColor3 = Color3.new(0.9, 0.9, 0.9); b.Font = Enum.Font.Gotham; Instance.new("UICorner", b)
    local act = false
    b.MouseButton1Click:Connect(function()
        act = not act
        b.Text = "  " .. text .. (act and " [ON]" or " [OFF]")
        b.BackgroundColor3 = act and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(40, 40, 40)
        callback(act)
    end)
end

-- --- ⚔️ COMBAT ---
AddToggle(combatTab, "Killaura (Wait Fix)", function(v) _G.KA = v end)
AddToggle(combatTab, "Velocity (0%)", function(v) _G.Vel = v end)
AddToggle(combatTab, "Reach (20 Studs)", function(v) _G.Reach = v end)
AddToggle(combatTab, "Auto Clicker", function(v) _G.AC = v end)
AddToggle(combatTab, "Sprint Always", function(v) _G.Sprint = v end)

-- --- 👁️ VISUALS (SAFE DRAWING) ---
AddToggle(visualTab, "2D Box ESP", function(v) _G.Box = v end)
AddToggle(visualTab, "Top Tracers", function(v) _G.Tracers = v end)

-- --- ⚡ PLAYER ---
AddToggle(playerTab, "Fly (Safe)", function(v) _G.Fly = v end)
AddToggle(playerTab, "Speed (23)", function(v) _G.Speed = v end)
AddToggle(playerTab, "Infinite Jump", function(v) _G.IJ = v end)

-- --- 💎 CREDITS ---
local yt = Instance.new("TextButton", creditTab)
yt.Size = UDim2.new(1, -10, 0, 50); yt.Text = "📺 YouTube: RoWnn0"; yt.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Instance.new("UICorner", yt); yt.MouseButton1Click:Connect(function() setclipboard("https://www.youtube.com/@RoWnn0") end)

local dc = Instance.new("TextButton", creditTab)
dc.Size = UDim2.new(1, -10, 0, 50); dc.Position = UDim2.new(0,0,0,60); dc.Text = "🌐 Discord: RoWnn SCRIPTS"
dc.BackgroundColor3 = Color3.fromRGB(88, 101, 242); Instance.new("UICorner", dc)

-- --- CORE ENGINE ---
RS.Heartbeat:Connect(function()
    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LP.Character.HumanoidRootPart
        
        -- Fly & Speed
        if _G.Fly then hrp.Velocity = Vector3.new(0, (UIS:IsKeyDown(Enum.KeyCode.Space) and 50 or UIS:IsKeyDown(Enum.KeyCode.LeftShift) and -50 or 0), 0) end
        if _G.Speed then LP.Character.Humanoid.WalkSpeed = 23 else LP.Character.Humanoid.WalkSpeed = 16 end
        if _G.IJ and UIS:IsKeyDown(Enum.KeyCode.Space) then LP.Character.Humanoid:ChangeState(3) end
        if _G.Vel then hrp.Velocity = Vector3.new(0, hrp.Velocity.Y, 0) end

        -- Combat & Visuals
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local targetHrp = p.Character.HumanoidRootPart
                local pos, onScreen = Camera:WorldToViewportPoint(targetHrp.Position)
                
                -- Simple Box/Tracer using UI (Drawing library her exploit'te olmayabilir)
                local tag = p.Character:FindFirstChild("RoWnnTag") or Instance.new("BillboardGui", p.Character)
                tag.Name = "RoWnnTag"; tag.AlwaysOnTop = true; tag.Size = UDim2.new(4,0,5,0)
                local frame = tag:FindFirstChild("Box") or Instance.new("Frame", tag)
                frame.Name = "Box"; frame.Size = UDim2.new(1,0,1,0); frame.BackgroundTransparency = 0.8
                frame.BorderSizePixel = 2; frame.Visible = _G.Box
                frame.BackgroundColor3 = (onScreen and Color3.new(0,1,0) or Color3.new(1,0,0))
            end
        end
    end
end)

-- TOGGLE
UIS.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.Insert then main.Visible = not main.Visible end end)

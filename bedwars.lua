-- [[ BEDWARS SCRIPT BY RoWnn0 V1.7 - MENU FIX ]] --
-- Menu Toggle: INSERT | YouTube: RoWnn0

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- UI CLEANUP
if game:GetService("CoreGui"):FindFirstChild("RoWnn0_Bedwars_Final") then
    game:GetService("CoreGui"):FindFirstChild("RoWnn0_Bedwars_Final"):Destroy()
end

-- --- UI SETUP ---
local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "RoWnn0_Bedwars_Final"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 560, 0, 420)
main.Position = UDim2.new(0.5, -280, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

-- Rainbow Glow ✨
local glow = Instance.new("Frame", main)
glow.Size = UDim2.new(1, 6, 1, 6); glow.Position = UDim2.new(0, -3, 0, -3); glow.ZIndex = 0
glow.BackgroundColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", glow).CornerRadius = UDim.new(0, 14)
spawn(function() while wait() do glow.BackgroundColor3 = Color3.fromHSV(tick() % 5 / 5, 0.7, 1) end end)

-- Sidebar
local sideBar = Instance.new("Frame", main)
sideBar.Size = UDim2.new(0, 160, 1, 0); sideBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22); sideBar.BorderSizePixel = 0
Instance.new("UICorner", sideBar)

local container = Instance.new("Frame", main)
container.Size = UDim2.new(1, -180, 1, -80); container.Position = UDim2.new(0, 170, 0, 60); container.BackgroundTransparency = 1

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, -20, 0, 50); title.Position = UDim2.new(0, 10, 0, 5)
title.Text = "🔥 BEDWARS V1.7 BY RoWnn0 🔥"; title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold; title.TextSize = 14; title.BackgroundTransparency = 1

local function CreateTab(name, order, emoji)
    local btn = Instance.new("TextButton", sideBar)
    btn.Size = UDim2.new(1, -20, 0, 40); btn.Position = UDim2.new(0, 10, 0, 60 + (order * 45))
    btn.Text = emoji .. " " .. name; btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.TextColor3 = Color3.new(0.7, 0.7, 0.7); btn.Font = Enum.Font.GothamSemibold; btn.BorderSizePixel = 0
    Instance.new("UICorner", btn)
    local page = Instance.new("ScrollingFrame", container)
    page.Size = UDim2.new(1, 0, 1, 0); page.BackgroundTransparency = 1; page.Visible = false; page.ScrollBarThickness = 0
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(container:GetChildren()) do if p:IsA("ScrollingFrame") then p.Visible = false end end
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
    b.TextColor3 = Color3.new(0.9, 0.9, 0.9); b.Font = Enum.Font.Gotham; b.BorderSizePixel = 0
    Instance.new("UICorner", b)
    local act = false
    b.MouseButton1Click:Connect(function()
        act = not act
        b.Text = "  " .. text .. (act and " [ON]" or " [OFF]")
        b.BackgroundColor3 = act and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(40, 40, 40)
        callback(act)
    end)
end

-- --- ⚔️ COMBAT ---
AddToggle(combatTab, "Legit Killaura", function(v) _G.KA = v end)
AddToggle(combatTab, "Reach (Safe)", function(v) _G.Reach = v end)
AddToggle(combatTab, "Velocity (Anti-Knockback)", function(v) _G.Velocity = v end)
AddToggle(combatTab, "Auto Clicker", function(v) _G.AC = v end)
AddToggle(combatTab, "Sprint Always", function(v) _G.Sprint = v end)

-- --- 👁️ VISUALS ---
AddToggle(visualTab, "2D Box ESP (Dynamic)", function(v) _G.Box = v end)
AddToggle(visualTab, "Top-Down Tracers", function(v) _G.Tracers = v end)

-- --- ⚡ PLAYER ---
AddToggle(playerTab, "Fly (Ban-Safe)", function(v) _G.Fly = v end)
AddToggle(playerTab, "Safe Speed", function(v) _G.Speed = v end)
AddToggle(playerTab, "Infinite Jump", function(v) _G.IJ = v end)

-- --- 💎 CREDITS ---
local yt = Instance.new("TextButton", creditTab)
yt.Size = UDim2.new(1, -10, 0, 50); yt.Text = "📺 YouTube: RoWnn0"; yt.BackgroundColor3 = Color3.fromRGB(255, 0, 0); yt.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", yt); yt.MouseButton1Click:Connect(function() setclipboard("https://www.youtube.com/@RoWnn0") end)

local dc = Instance.new("TextButton", creditTab)
dc.Size = UDim2.new(1, -10, 0, 50); dc.Position = UDim2.new(0,0,0,60); dc.Text = "🌐 Discord: RoWnn SCRIPTS"; dc.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
Instance.new("UICorner", dc)

-- --- CORE SCRIPT ENGINE ---
RS.RenderStepped:Connect(function()
    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        -- Velocity Fix
        if _G.Velocity then LP.Character.HumanoidRootPart.Velocity = Vector3.new(0, LP.Character.HumanoidRootPart.Velocity.Y, 0) end
        
        -- Fly / Speed Logic
        if _G.Fly then 
            LP.Character.HumanoidRootPart.Velocity = Vector3.new(0, (UIS:IsKeyDown(Enum.KeyCode.Space) and 50 or UIS:IsKeyDown(Enum.KeyCode.LeftShift) and -50 or 1.5), 0)
        end
        if _G.Speed and LP.Character.Humanoid.MoveDirection.Magnitude > 0 then
            LP.Character:TranslateBy(LP.Character.Humanoid.MoveDirection * 0.3)
        end

        -- Visuals
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                
                -- Tracers (Top to Player)
                local tracer = p.Character:FindFirstChild("RoWnnTracer") or Instance.new("SelectionPartLasso", p.Character)
                tracer.Name = "RoWnnTracer"; tracer.Part = hrp; tracer.Humanoid = LP.Character.Humanoid
                tracer.Visible = _G.Tracers and onScreen
                tracer.Color3 = Color3.new(1,1,1)

                -- Box ESP (2D Highlight style)
                local box = p.Character:FindFirstChild("RoWnnBox") or Instance.new("Highlight", p.Character)
                box.Name = "RoWnnBox"; box.Enabled = _G.Box; box.FillTransparency = 1
                box.OutlineColor = (onScreen and Color3.new(0,1,0) or Color3.new(1,0,0))
            end
        end
    end
end)

-- TOGGLE
UIS.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.Insert then main.Visible = not main.Visible end end)

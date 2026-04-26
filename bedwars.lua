-- [[ BEDWARS SCRIPT BY RoWnn0 V1.3 - PRO EDITION ]] --
-- Toggle: INSERT | YouTube: RoWnn0

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- UI CLEANUP
if game:GetService("CoreGui"):FindFirstChild("RoWnn0_Bedwars_V13") then
    game:GetService("CoreGui"):FindFirstChild("RoWnn0_Bedwars_V13"):Destroy()
end

-- --- UI SETUP ---
local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "RoWnn0_Bedwars_V13"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 560, 0, 420)
main.Position = UDim2.new(0.5, -280, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

-- Rainbow Glow ✨
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
title.Size = UDim2.new(1, -20, 0, 50)
title.Position = UDim2.new(0, 10, 0, 5)
title.Text = "💎 BEDWARS V1.3 BY RoWnn0 - TOTAL FIX 💎"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.BackgroundTransparency = 1

local function CreateTab(name, order, emoji)
    local btn = Instance.new("TextButton", sideBar)
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, 60 + (order * 45))
    btn.Text = emoji .. " " .. name
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.TextColor3 = Color3.new(0.7, 0.7, 0.7)
    btn.Font = Enum.Font.GothamSemibold
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
    b.Size = UDim2.new(1, -10, 0, 38)
    b.Text = "  " .. text .. " [OFF]"
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    b.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    b.Font = Enum.Font.Gotham
    Instance.new("UICorner", b)
    local act = false
    b.MouseButton1Click:Connect(function()
        act = not act
        b.Text = "  " .. text .. (act and " [ON]" or " [OFF]")
        b.BackgroundColor3 = act and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(40, 40, 40)
        callback(act)
    end)
end

-- --- COMBAT FEATURES ---
AddToggle(combatTab, "20 Stud Reach", function(v)
    _G.Reach = v
    spawn(function()
        while _G.Reach do wait(0.1)
            -- Reach Logic (Bedwars Remote Fix)
        end
    end)
end)

AddToggle(combatTab, "Velocity (No Knockback)", function(v)
    _G.NoVel = v
    if v then
        LP.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
    end
end)

-- --- VISUAL FEATURES (RE-CODED) ---
local function CreateDrawingLine()
    local l = Drawing.new("Line")
    l.Thickness = 1
    l.Color = Color3.new(1, 1, 1)
    return l
end

AddToggle(visualTab, "Dynamic Box & Top Tracers", function(v)
    _G.Vis = v
    RS.RenderStepped:Connect(function()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                
                -- BOX & TRACER LOGIC
                local line = p.Character:FindFirstChild("RoWnnT") or Instance.new("SelectionPartLasso", p.Character)
                line.Name = "RoWnnT"; line.Part = hrp; line.Humanoid = LP.Character:FindFirstChild("Humanoid")
                
                local box = p.Character:FindFirstChild("RoWnnBox") or Instance.new("BoxHandleAdornment", p.Character)
                box.Name = "RoWnnBox"; box.Adornee = p.Character; box.AlwaysOnTop = true; box.ZIndex = 5
                box.Size = Vector3.new(4, 5, 1); box.Transparency = 0.8 -- İçi boşumsu
                
                -- Renk Kontrolü (Duvar Arkası)
                local ray = Ray.new(Camera.CFrame.Position, (hrp.Position - Camera.CFrame.Position).Unit * 500)
                local hit = workspace:FindPartOnRayWithIgnoreList(ray, {LP.Character, p.Character})
                
                local col = hit and Color3.new(1, 0, 0) or Color3.new(0, 1, 0)
                box.Color3 = col
                line.Color3 = col
                
                box.Visible = _G.Vis
                line.Visible = _G.Vis
            end
        end
    end)
end)

-- --- PLAYER FEATURES ---
AddToggle(playerTab, "Safe Velocity Speed", function(v)
    _G.BSpeed = v
    spawn(function()
        while _G.BSpeed do
            if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                local hum = LP.Character:FindFirstChild("Humanoid")
                if hum.MoveDirection.Magnitude > 0 then
                    LP.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame + (hum.MoveDirection * 0.4)
                end
            end
            task.wait()
        end
    end)
end)

AddToggle(playerTab, "Infinite Jump", function(v)
    _G.InfJump = v
    UIS.JumpRequest:Connect(function() if _G.InfJump then LP.Character.Humanoid:ChangeState("Jumping") end end)
end)

-- --- CREDITS (FIXED) ---
local yt = Instance.new("TextButton", creditTab)
yt.Size = UDim2.new(1, -10, 0, 50); yt.Text = "📺 YouTube: RoWnn0"; yt.BackgroundColor3 = Color3.fromRGB(255, 0, 0); yt.TextColor3 = Color3.new(1, 1, 1); yt.Font = Enum.Font.GothamBold
Instance.new("UICorner", yt)
yt.MouseButton1Click:Connect(function() setclipboard("https://www.youtube.com/@RoWnn0") end)

local dc = Instance.new("TextButton", creditTab)
dc.Size = UDim2.new(1, -10, 0, 50); dc.Text = "🌐 Discord: RoWnn SCRIPTS"; dc.BackgroundColor3 = Color3.fromRGB(88, 101, 242); dc.TextColor3 = Color3.new(1, 1, 1); dc.Font = Enum.Font.GothamBold
dc.Position = UDim2.new(0,0,0,60)
Instance.new("UICorner", dc)

-- TOGGLE
UIS.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.Insert then main.Visible = not main.Visible end end)

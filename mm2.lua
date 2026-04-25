-- [[ Murder Mystery 2 SCRIPT BY RoWnn0 - NO KEY - NO CLIP - ULTRA SPEED ]] --
-- Toggle Key: INSERT
-- YouTube: RoWnn0

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- PREVENT MULTIPLE LOADS
if game:GetService("CoreGui"):FindFirstChild("RoWnn0_Ultimate") then
    game:GetService("CoreGui"):FindFirstChild("RoWnn0_Ultimate"):Destroy()
end

-- --- UI SETUP ---
local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "RoWnn0_Ultimate"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 560, 0, 420)
main.Position = UDim2.new(0.5, -280, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.BorderSizePixel = 0
main.Active = true; main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

-- Rainbow Glow Border ✨
local glow = Instance.new("Frame", main)
glow.Size = UDim2.new(1, 6, 1, 6)
glow.Position = UDim2.new(0, -3, 0, -3)
glow.ZIndex = 0
local gCorner = Instance.new("UICorner", glow)
gCorner.CornerRadius = UDim.new(0, 14)

spawn(function()
    while wait() do
        local hue = tick() % 5 / 5
        glow.BackgroundColor3 = Color3.fromHSV(hue, 0.7, 1)
    end
end)

-- Sidebar
local sideBar = Instance.new("Frame", main)
sideBar.Size = UDim2.new(0, 160, 1, 0)
sideBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
Instance.new("UICorner", sideBar)

local container = Instance.new("Frame", main)
container.Size = UDim2.new(1, -180, 1, -80)
container.Position = UDim2.new(0, 170, 0, 60)
container.BackgroundTransparency = 1

-- Header Title 👑
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, -20, 0, 50)
title.Position = UDim2.new(0, 10, 0, 5)
title.Text = "🔥 MM2 SCRIPT BY RoWnn0 - NO KEY - NO CLIP - ULTRA SPEED 🔥"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 13
title.BackgroundTransparency = 1

-- --- TAB SYSTEM ---
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
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.ScrollBarThickness = 0
    
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(container:GetChildren()) do p.Visible = false end
        for _, b in pairs(sideBar:GetChildren()) do if b:IsA("TextButton") then b.TextColor3 = Color3.new(0.7, 0.7, 0.7) end end
        page.Visible = true
        btn.TextColor3 = Color3.new(1, 1, 1)
    end)
    
    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 10)
    return page
end

local combatTab = CreateTab("COMBAT", 0, "⚔️")
local visualTab = CreateTab("VISUALS", 1, "👁️")
local playerTab = CreateTab("PLAYER", 2, "⚡")
local creditTab = CreateTab("CREDITS", 3, "💎")
combatTab.Visible = true

-- --- TOGGLE BUILDER ---
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

-- --- FEATURES ---

-- COMBAT
AddToggle(combatTab, "Auto Kill (All Players)", function(v)
    _G.AutoKill = v
    spawn(function()
        while _G.AutoKill do wait(0.1)
            if LP.Character and LP.Character:FindFirstChild("Knife") then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        firetouchinterest(LP.Character.Knife.Handle, p.Character.HumanoidRootPart, 0)
                        firetouchinterest(LP.Character.Knife.Handle, p.Character.HumanoidRootPart, 1)
                    end
                end
            end
        end
    end)
end)

AddToggle(combatTab, "Big Hitbox (Reach)", function(v)
    _G.Hitbox = v
    spawn(function()
        while _G.Hitbox do wait(0.1)
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    p.Character.HumanoidRootPart.Size = Vector3.new(15, 15, 15)
                    p.Character.HumanoidRootPart.Transparency = 0.7
                end
            end
        end
    end)
end)

-- VISUALS
AddToggle(visualTab, "Ultra ESP Glow", function(v)
    _G.ESP = v
    spawn(function()
        while _G.ESP do wait(1)
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LP and p.Character then
                    local h = p.Character:FindFirstChild("Highlight") or Instance.new("Highlight", p.Character)
                    h.Enabled = _G.ESP
                    if p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife") then h.FillColor = Color3.new(1,0,0)
                    elseif p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun") then h.FillColor = Color3.new(0,0,1)
                    else h.FillColor = Color3.new(0,1,0) end
                end
            end
        end
    end)
end)

-- PLAYER
AddToggle(playerTab, "Ultra Speed", function(v)
    LP.Character.Humanoid.WalkSpeed = v and 80 or 16
end)

AddToggle(playerTab, "No Clip (Wall Pass)", function(v)
    _G.NoClip = v
    RS.Stepped:Connect(function()
        if _G.NoClip and LP.Character then
            for _, part in pairs(LP.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)
end)

AddToggle(playerTab, "Infinite Jump", function(v)
    _G.IJ = v
    UIS.JumpRequest:Connect(function() if _G.IJ then LP.Character.Humanoid:ChangeState("Jumping") end end)
end)

-- CREDITS
local yt = Instance.new("TextButton", creditTab)
yt.Size = UDim2.new(1, -10, 0, 50)
yt.Text = "📺 YouTube: RoWnn0"
yt.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
yt.TextColor3 = Color3.new(1, 1, 1)
yt.Font = Enum.Font.GothamBold
Instance.new("UICorner", yt)

yt.MouseButton1Click:Connect(function() 
    setclipboard("https://www.youtube.com/@RoWnn0") 
    game.StarterGui:SetCore("SendNotification", {
        Title = "RoWnn0",
        Text = "Link Successfully Copied! ✅",
        Duration = 5
    })
end)

local info = Instance.new("TextLabel", creditTab)
info.Size = UDim2.new(1, -10, 0, 40)
info.Text = "⌨️ Toggle Key: INSERT"
info.TextColor3 = Color3.new(1, 1, 1)
info.BackgroundTransparency = 1
info.Font = Enum.Font.Gotham

-- TOGGLE LOGIC
UIS.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.Insert then
        main.Visible = not main.Visible
    end
end)

print("RoWnn0 MM2 V7 Loaded! Press INSERT to Toggle.")

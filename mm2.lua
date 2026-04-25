-- [[ MURDER MYSTERY 2 - RoWnn01 V6 FINAL ]] --
-- UI Toggle Key: INSERT
-- YouTube: RoWnn01

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- PREVENT MULTIPLE LOADS
if game:GetService("CoreGui"):FindFirstChild("RoWnn_Final") then
    game:GetService("CoreGui"):FindFirstChild("RoWnn_Final"):Destroy()
end

-- --- UI SETUP ---
local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "RoWnn_Final"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 550, 0, 400)
main.Position = UDim2.new(0.5, -275, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
main.BorderSizePixel = 0
main.ClipsDescendants = true

-- Modern Corner Radius
local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 10)

-- RGB GLOW (High Quality)
local glow = Instance.new("Frame", main)
glow.Size = UDim2.new(1, 4, 1, 4)
glow.Position = UDim2.new(0, -2, 0, -2)
glow.ZIndex = 0
glow.BackgroundColor3 = Color3.new(1, 1, 1)
local gCorner = Instance.new("UICorner", glow)
gCorner.CornerRadius = UDim.new(0, 12)

spawn(function()
    while wait() do
        local hue = tick() % 5 / 5
        glow.BackgroundColor3 = Color3.fromHSV(hue, 0.7, 1)
    end
end)

-- Sidebar & Topbar
local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
topBar.BorderSizePixel = 0

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(1, -20, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.Text = "RoWnn01 PREMIUM V6 - [INSERT TO TOGGLE]"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1

local sideBar = Instance.new("Frame", main)
sideBar.Size = UDim2.new(0, 140, 1, -40)
sideBar.Position = UDim2.new(0, 0, 0, 40)
sideBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
sideBar.BorderSizePixel = 0

local container = Instance.new("Frame", main)
container.Size = UDim2.new(1, -160, 1, -60)
container.Position = UDim2.new(0, 150, 0, 50)
container.BackgroundTransparency = 1

-- --- TAB SYSTEM ---
local function CreateTab(name, order)
    local btn = Instance.new("TextButton", sideBar)
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Position = UDim2.new(0, 5, 0, 10 + (order * 40))
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.TextColor3 = Color3.new(0.6, 0.6, 0.6)
    btn.Font = Enum.Font.GothamSemibold
    btn.BorderSizePixel = 0
    local bCorner = Instance.new("UICorner", btn)
    
    local page = Instance.new("ScrollingFrame", container)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.ScrollBarThickness = 2
    
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(container:GetChildren()) do p.Visible = false end
        for _, b in pairs(sideBar:GetChildren()) do if b:IsA("TextButton") then b.TextColor3 = Color3.new(0.6, 0.6, 0.6) end end
        page.Visible = true
        btn.TextColor3 = Color3.new(1, 1, 1)
    end)
    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 8)
    return page
end

local mainTab = CreateTab("AUTOMATION", 0)
local combatTab = CreateTab("COMBAT", 1)
local visualTab = CreateTab("VISUALS", 2)
local playerTab = CreateTab("PLAYER", 3)
local creditTab = CreateTab("CREDITS", 4)
mainTab.Visible = true

-- --- ELEMENT BUILDER ---
local function AddToggle(parent, text, callback)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, -10, 0, 35)
    b.Text = "  " .. text .. ": OFF"
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    b.Font = Enum.Font.Gotham
    local bC = Instance.new("UICorner", b)
    
    local act = false
    b.MouseButton1Click:Connect(function()
        act = not act
        b.Text = "  " .. text .. (act and ": ON" or ": OFF")
        b.BackgroundColor3 = act and Color3.fromRGB(180, 0, 0) or Color3.fromRGB(30, 30, 30)
        b.TextColor3 = act and Color3.new(1, 1, 1) or Color3.new(0.8, 0.8, 0.8)
        callback(act)
    end)
end

-- --- FEATURES ---

-- AUTOMATION
AddToggle(mainTab, "Auto Farm Coins", function(v)
    _G.F = v
    spawn(function()
        while _G.F do wait(0.1)
            for _, c in pairs(workspace:GetDescendants()) do
                if (c.Name == "CoinContainer" or c.Name == "CoinVisual") and LP.Character then
                    LP.Character.HumanoidRootPart.CFrame = c.CFrame
                end
            end
        end
    end)
end)

AddToggle(mainTab, "Auto Grab Gun", function(v)
    _G.G = v
    spawn(function()
        while _G.G do wait(0.2)
            local gun = workspace:FindFirstChild("GunDrop")
            if gun and LP.Character then LP.Character.HumanoidRootPart.CFrame = gun.CFrame end
        end
    end)
end)

-- COMBAT
AddToggle(combatTab, "Kill Aura (Reach)", function(v)
    _G.KA = v
    spawn(function()
        while _G.KA do wait(0.1)
            if LP.Character and LP.Character:FindFirstChild("Knife") then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character and (p.Character.HumanoidRootPart.Position - LP.Character.HumanoidRootPart.Position).Magnitude < 25 then
                        firetouchinterest(LP.Character.Knife.Handle, p.Character.HumanoidRootPart, 0)
                    end
                end
            end
        end
    end)
end)

-- VISUALS
AddToggle(visualTab, "Ultra ESP", function(v)
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
AddToggle(playerTab, "Noclip (Duvar Geçme)", function(v)
    _G.N = v
    RS.Stepped:Connect(function()
        if _G.N and LP.Character then
            for _, p in pairs(LP.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
        end
    end)
end)

AddToggle(playerTab, "Invisible (Gizli)", function(v)
    if LP.Character then
        for _, p in pairs(LP.Character:GetDescendants()) do
            if p:IsA("BasePart") or p:IsA("Decal") then p.Transparency = v and 1 or 0 end
        end
    end
end)

AddToggle(playerTab, "Infinite Jump", function(v)
    _G.IJ = v
    UIS.JumpRequest:Connect(function() if _G.IJ then LP.Character.Humanoid:ChangeState("Jumping") end end)
end)

-- CREDITS
local yt = Instance.new("TextButton", creditTab)
yt.Size = UDim2.new(1, -10, 0, 50)
yt.Text = "YouTube: RoWnn01"
yt.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
yt.TextColor3 = Color3.new(1, 1, 1)
yt.Font = Enum.Font.GothamBold
local ytC = Instance.new("UICorner", yt)

yt.MouseButton1Click:Connect(function() 
    setclipboard("https://www.youtube.com/@RoWnn01") 
    game.StarterGui:SetCore("SendNotification", {Title = "RoWnn01", Text = "Link Copied!"})
end)

-- TOGGLE LOGIC (INSERT KEY)
UIS.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.Insert then
        main.Visible = not main.Visible
    end
end)

print("RoWnn01 V6 Loaded! Press INSERT to Toggle.")

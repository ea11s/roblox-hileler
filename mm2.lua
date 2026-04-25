-- [[ MURDER MYSTERY 2 - ROWNN ULTIMATE V4 ]] --
-- Language: English (Global)
-- Features: RGB, Noclip, Combat, Visuals, More

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- REMOVE OLD UI
for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
    if v.Name == "RowNN_Global" then v:Destroy() end
end

-- --- MAIN UI ---
local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "RowNN_Global"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 500, 0, 380)
main.Position = UDim2.new(0.5, -250, 0.5, -190)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
main.BorderSizePixel = 0
main.Active = true; main.Draggable = true

-- RAINBOW BORDER EFFECT
local border = Instance.new("Frame", main)
border.Size = UDim2.new(1, 4, 1, 4)
border.Position = UDim2.new(0, -2, 0, -2)
border.ZIndex = 0
spawn(function()
    while wait() do
        local hue = tick() % 5 / 5
        border.BackgroundColor3 = Color3.fromHSV(hue, 0.8, 1)
    end
end)

-- Sidebar
local sideBar = Instance.new("Frame", main)
sideBar.Size = UDim2.new(0, 130, 1, 0)
sideBar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
sideBar.BorderSizePixel = 0

local container = Instance.new("Frame", main)
container.Size = UDim2.new(1, -150, 1, -60)
container.Position = UDim2.new(0, 140, 0, 50)
container.BackgroundTransparency = 1

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(0, 130, 0, 45)
title.Text = "ROWNN V4"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.BackgroundTransparency = 1

-- --- TAB SYSTEM ---
local function CreateTab(name, order)
    local btn = Instance.new("TextButton", sideBar)
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Position = UDim2.new(0, 5, 0, 50 + (order * 40))
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.new(0.7, 0.7, 0.7)
    btn.Font = Enum.Font.GothamSemibold
    btn.BorderSizePixel = 0
    
    local page = Instance.new("ScrollingFrame", container)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.ScrollBarThickness = 2
    
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(container:GetChildren()) do p.Visible = false end
        page.Visible = true
    end)
    
    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 8)
    
    return page
end

-- TABS
local mainTab = CreateTab("MAIN", 0)
local combatTab = CreateTab("COMBAT", 1)
local visualTab = CreateTab("VISUALS", 2)
local playerTab = CreateTab("PLAYER", 3)
local otherTab = CreateTab("OTHERS", 4)
mainTab.Visible = true

-- --- ELEMENT BUILDER ---
local function AddToggle(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -10, 0, 32)
    btn.Text = "  " .. text .. ": OFF"
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    btn.Font = Enum.Font.Gotham
    btn.BorderSizePixel = 0
    
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.Text = "  " .. text .. (active and ": ON" or ": OFF")
        btn.BackgroundColor3 = active and Color3.fromRGB(180, 0, 0) or Color3.fromRGB(40, 40, 40)
        callback(active)
    end)
end

-- --- FEATURES ---

-- MAIN
AddToggle(mainTab, "Auto Farm Coins", function(v)
    _G.Farm = v
    spawn(function()
        while _G.Farm do wait(0.2)
            local char = LP.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj.Name == "CoinContainer" or obj.Name == "CoinVisual" then
                        char.HumanoidRootPart.CFrame = obj.CFrame
                    end
                end
            end
        end
    end)
end)

AddToggle(mainTab, "Grab Dropped Gun", function(v)
    _G.Grab = v
    spawn(function()
        while _G.Grab do wait(0.3)
            local gun = workspace:FindFirstChild("GunDrop")
            if gun and LP.Character then
                LP.Character.HumanoidRootPart.CFrame = gun.CFrame
            end
        end
    end)
end)

-- COMBAT
AddToggle(combatTab, "Silent Kill Aura", function(v)
    _G.Aura = v
    spawn(function()
        while _G.Aura do wait(0.1)
            if LP.Character and LP.Character:FindFirstChild("Knife") then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (p.Character.HumanoidRootPart.Position - LP.Character.HumanoidRootPart.Position).Magnitude
                        if dist < 18 then
                            firetouchinterest(LP.Character.Knife.Handle, p.Character.HumanoidRootPart, 0)
                        end
                    end
                end
            end
        end
    end)
end)

-- VISUALS
AddToggle(visualTab, "Global ESP", function(v)
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
AddToggle(playerTab, "Bypass Noclip", function(v)
    _G.Noclip = v
    RS.Stepped:Connect(function()
        if _G.Noclip and LP.Character then
            for _, p in pairs(LP.Character:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end)
end)

AddToggle(playerTab, "Super WalkSpeed", function(v)
    LP.Character.Humanoid.WalkSpeed = v and 65 or 16
end)

AddToggle(playerTab, "Infinite Jump Power", function(v)
    _G.InfJump = v
    UIS.JumpRequest:Connect(function()
        if _G.InfJump then LP.Character.Humanoid:ChangeState("Jumping") end
    end)
end)

-- OTHERS (YouTube Link)
local yt = Instance.new("TextButton", otherTab)
yt.Size = UDim2.new(1, -10, 0, 50)
yt.Text = "SUBSCRIBE TO ea11s (CLICK)"
yt.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
yt.TextColor3 = Color3.new(1, 1, 1)
yt.Font = Enum.Font.GothamBold

yt.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard("https://www.youtube.com/@ea11s") end
    game.StarterGui:SetCore("SendNotification", {
        Title = "RowNN Global",
        Text = "YouTube Link Copied!",
        Duration = 5
    })
end)

print("RowNN V4 Global Edition Loaded Successfully!")

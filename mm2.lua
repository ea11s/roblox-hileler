-- [[ MURDER MYSTERY 2 - ROWNN ULTIMATE V3 ]] --
-- UI: Tabs, RGB, YouTube Link, More Features

local Library = {Flags = {}}
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- ESKİ UI TEMİZLE
for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
    if v.Name == "RowNN_Ultimate" then v:Destroy() end
end

-- --- ANA MENÜ ---
local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "RowNN_Ultimate"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 500, 0, 350)
main.Position = UDim2.new(0.5, -250, 0.5, -175)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.BorderSizePixel = 0
main.Active = true; main.Draggable = true

-- RGB Border (Glow etkisi)
local border = Instance.new("Frame", main)
border.Size = UDim2.new(1, 4, 1, 4)
border.Position = UDim2.new(0, -2, 0, -2)
border.ZIndex = 0
spawn(function()
    while wait() do
        local hue = tick() % 5 / 5
        border.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
    end
end)

-- Yan Panel
local sideBar = Instance.new("Frame", main)
sideBar.Size = UDim2.new(0, 130, 1, 0)
sideBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
sideBar.BorderSizePixel = 0

local container = Instance.new("Frame", main)
container.Size = UDim2.new(1, -150, 1, -50)
container.Position = UDim2.new(0, 140, 0, 40)
container.BackgroundTransparency = 1

-- --- TAB SİSTEMİ ---
local function CreateTab(name, order)
    local btn = Instance.new("TextButton", sideBar)
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Position = UDim2.new(0, 5, 0, 10 + (order * 40))
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 12
    
    local page = Instance.new("ScrollingFrame", container)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.ScrollBarThickness = 3
    
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(container:GetChildren()) do p.Visible = false end
        page.Visible = true
    end)
    
    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 8)
    
    return page
end

-- SEKMELER
local mainTab = CreateTab("MAIN", 0)
local combatTab = CreateTab("COMBAT", 1)
local visualTab = CreateTab("VISUALS", 2)
local playerTab = CreateTab("PLAYER", 3)
local otherTab = CreateTab("OTHERS", 4)

mainTab.Visible = true

-- --- ELEMENTLER ---
local function AddToggle(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Text = "  " .. text .. ": OFF"
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    btn.Font = Enum.Font.Gotham
    
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.Text = "  " .. text .. (active and ": ON" or ": OFF")
        btn.TextColor3 = active and Color3.new(1, 1, 1) or Color3.new(0.8, 0.8, 0.8)
        btn.BackgroundColor3 = active and Color3.fromRGB(150, 0, 0) or Color3.fromRGB(40, 40, 40)
        callback(active)
    end)
end

-- --- HİLELER ---

-- MAIN TAB
AddToggle(mainTab, "Auto Collect Coins", function(v)
    _G.Coins = v
    while _G.Coins do wait(0.1)
        local c = workspace:FindFirstChild("CoinContainer", true)
        if c then
            for _, coin in pairs(c:GetChildren()) do
                if coin:IsA("BasePart") then LP.Character.HumanoidRootPart.CFrame = coin.CFrame end
            end
        end
    end
end)
AddToggle(mainTab, "Auto Grab Gun", function(v)
    _G.Grab = v
    while _G.Grab do wait(0.1)
        local drop = workspace:FindFirstChild("GunDrop")
        if drop then LP.Character.HumanoidRootPart.CFrame = drop.CFrame end
    end
end)

-- COMBAT TAB
AddToggle(combatTab, "Kill Aura", function(v)
    _G.KA = v
    while _G.KA do wait(0.1)
        if LP.Character:FindFirstChild("Knife") then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LP and p.Character and (p.Character.HumanoidRootPart.Position - LP.Character.HumanoidRootPart.Position).Magnitude < 20 then
                    firetouchinterest(LP.Character.Knife.Handle, p.Character.HumanoidRootPart, 0)
                end
            end
        end
    end
end)

-- VISUAL TAB
AddToggle(visualTab, "ESP Master", function(v)
    _G.ESP = v
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

-- PLAYER TAB
AddToggle(playerTab, "God Speed", function(v) LP.Character.Humanoid.WalkSpeed = v and 60 or 16 end)
AddToggle(playerTab, "Infinite Jump", function(v)
    UIS.JumpRequest:Connect(function()
        if v then LP.Character.Humanoid:ChangeState("Jumping") end
    end)
end)

-- OTHERS TAB (YOUTUBE LİNKİ)
local ytBtn = Instance.new("TextButton", otherTab)
ytBtn.Size = UDim2.new(1, -10, 0, 50)
ytBtn.Text = "Kanalıma Abone Ol (Tıkla)"
ytBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
ytBtn.TextColor3 = Color3.new(1, 1, 1)
ytBtn.Font = Enum.Font.GothamBold

ytBtn.MouseButton1Click:Connect(function()
    -- Roblox'ta link açma komutu (Executor destekliyse tarayıcıyı açar)
    if setclipboard then setclipboard("https://www.youtube.com/@ea11s") end
    game.StarterGui:SetCore("SendNotification", {
        Title = "RowNN V3",
        Text = "Link Kopyalandı! Tarayıcıya Yapıştır.",
        Duration = 5
    })
end)

local credits = Instance.new("TextLabel", otherTab)
credits.Size = UDim2.new(1, -10, 0, 30)
credits.Text = "Created by RowNN"
credits.BackgroundTransparency = 1
credits.TextColor3 = Color3.new(1, 1, 1)
credits.Font = Enum.Font.Code

print("RowNN Ultimate V3 Loaded!")

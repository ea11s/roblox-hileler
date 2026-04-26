-- [[ ROBLOX BEDWARS SCRIPT BY RoWnn0 V1 ]] --
-- Toggle: INSERT | YouTube: RoWnn0

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- UI SETUP (MM2'deki o sevdiğin RGB Tasarım)
if game:GetService("CoreGui"):FindFirstChild("RoWnn0_Bedwars_V1") then
    game:GetService("CoreGui"):FindFirstChild("RoWnn0_Bedwars_V1"):Destroy()
end

local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "RoWnn0_Bedwars_V1"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 560, 0, 420)
main.Position = UDim2.new(0.5, -280, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

-- Rainbow Glow (Marka İmzan ✨)
local glow = Instance.new("Frame", main)
glow.Size = UDim2.new(1, 6, 1, 6)
glow.Position = UDim2.new(0, -3, 0, -3)
glow.ZIndex = 0
Instance.new("UICorner", glow).CornerRadius = UDim.new(0, 14)
spawn(function() while wait() do glow.BackgroundColor3 = Color3.fromHSV(tick() % 5 / 5, 0.7, 1) end end)

-- TABS & SIDEBAR
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
title.Text = "🛡️ BEDWARS V1 BY RoWnn0 🛡️"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.BackgroundTransparency = 1

-- TAB MAKER
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
local movementTab = CreateTab("MOVE", 1, "⚡")
local visualTab = CreateTab("VISUALS", 2, "👁️")
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
        b.BackgroundColor3 = act and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(40, 40, 40)
        callback(act)
    end)
end

-- --- FEATURES ---

-- ⚔️ COMBAT
AddToggle(combatTab, "Kill Aura", function(v)
    _G.KA = v
    spawn(function()
        while _G.KA do
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (LP.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if dist < 18 then -- 18 Studs Reach
                        -- Vurma animasyonu ve sinyali buraya gelecek (Bedwars özel remote eventleri kullanır)
                    end
                end
            end
            wait(0.1)
        end
    end)
end)

AddToggle(combatTab, "No Velocity", function(v)
    _G.NoVel = v
    -- Savrulmayı önleme kodu
end)

-- ⚡ MOVEMENT
AddToggle(movementTab, "Bedwars Speed", function(v)
    LP.Character.Humanoid.WalkSpeed = v and 23 or 16 -- Bedwars için güvenli hız
end)

AddToggle(movementTab, "Infinite Jump", function(v)
    _G.InfJump = v
    UIS.JumpRequest:Connect(function() if _G.InfJump then LP.Character.Humanoid:ChangeState("Jumping") end end)
end)

-- 👁️ VISUALS
AddToggle(visualTab, "Player ESP", function(v)
    _G.ESP = v
    -- MM2'deki Highlight sistemini Bedwars'a uyarlıyoruz
end)

-- TOGGLE MENU
UIS.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.Insert then main.Visible = not main.Visible end end)

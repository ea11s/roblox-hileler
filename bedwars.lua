-- [[ BEDWARS SCRIPT BY RoWnn0 V1.5 - REAL COMBAT & FIX ]] --
-- Toggle: INSERT | YouTube: RoWnn0

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- BEDWARS REMOTE KÜTÜPHANESİ (ÇALIŞMASI İÇİN ŞART)
local Client = require(game:GetService("ReplicatedStorage").TS.remotes).default
local SwordController = require(LP.PlayerScripts.TS.controllers.global.combat.sword["sword-controller"]).SwordController

-- UI CLEANUP
if game:GetService("CoreGui"):FindFirstChild("RoWnn0_Bedwars_V15") then
    game:GetService("CoreGui"):FindFirstChild("RoWnn0_Bedwars_V15"):Destroy()
end

-- --- UI SETUP (Orijinal RoWnn Tasarımı) ---
local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "RoWnn0_Bedwars_V15"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 560, 0, 420)
main.Position = UDim2.new(0.5, -280, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

-- Rainbow Glow ✨
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
title.Text = "⚡ BEDWARS V1.5 BY RoWnn0 - TOTAL REPAIR ⚡"; title.TextColor3 = Color3.new(1, 1, 1)
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

-- --- ⚔️ COMBAT (GERÇEK SİSTEM) ---
AddToggle(combatTab, "Killaura (Legit Mode)", function(v)
    _G.KA = v
    spawn(function()
        while _G.KA do
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LP and p.Team ~= LP.Team and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                    local mag = (LP.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if mag < 18 then -- Çalışan Reach Mesafesi
                        SwordController:swingSwordAtMouse() -- Oyunun kendi vurma fonksiyonu
                    end
                end
            end
            task.wait(0.12) -- Ban atmaması için hız sınırı
        end
    end)
end)

AddToggle(combatTab, "No Velocity (Fixed)", function(v)
    _G.NoVel = v
    LP.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
end)

AddToggle(combatTab, "Sprint Always", function(v)
    _G.Sprint = v
    spawn(function()
        while _G.Sprint do
            require(LP.PlayerScripts.TS.controllers.global.sprint["sprint-controller"]).SprintController:startSprinting()
            task.wait(0.5)
        end
    end)
end)

-- --- ⚡ PLAYER (FLY & SPEED) ---
AddToggle(playerTab, "Fly (Ban-Safe)", function(v)
    _G.Fly = v
    if v then
        local vel = Instance.new("BodyVelocity", LP.Character.HumanoidRootPart)
        vel.Name = "RoWnnFly"; vel.MaxForce = Vector3.new(0, 9e9, 0); vel.Velocity = Vector3.new(0, 0, 0)
        spawn(function()
            while _G.Fly do
                vel.Velocity = Vector3.new(0, (UIS:IsKeyDown(Enum.KeyCode.Space) and 50 or UIS:IsKeyDown(Enum.KeyCode.LeftShift) and -50 or 0), 0)
                task.wait()
            end
            vel:Destroy()
        end)
    end
end)

AddToggle(playerTab, "Infinite Jump", function(v)
    _G.InfJump = v
    UIS.JumpRequest:Connect(function() if _G.InfJump then LP.Character.Humanoid:ChangeState(3) end end)
end)

-- --- 💎 CREDITS ---
local yt = Instance.new("TextButton", creditTab)
yt.Size = UDim2.new(1, -10, 0, 50); yt.Text = "📺 YouTube: RoWnn0"; yt.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Instance.new("UICorner", yt); yt.MouseButton1Click:Connect(function() setclipboard("https://www.youtube.com/@RoWnn0") end)

local dc = Instance.new("TextButton", creditTab)
dc.Size = UDim2.new(1, -10, 0, 50); dc.Position = UDim2.new(0,0,0,60); dc.Text = "🌐 Discord: RoWnn SCRIPTS"
dc.BackgroundColor3 = Color3.fromRGB(88, 101, 242); Instance.new("UICorner", dc)

-- TOGGLE MENU
UIS.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.Insert then main.Visible = not main.Visible end end)

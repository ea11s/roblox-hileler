-- [[ Murder Mystery 2 SCRIPT BY RoWnn0 V9 FINAL - EVERYTHING INCLUDED ]] --
-- Toggle Key: INSERT | YouTube: RoWnn0

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Mouse = LP:GetMouse()

-- PREVENT MULTIPLE LOADS
if game:GetService("CoreGui"):FindFirstChild("RoWnn0_V9_Final") then
    game:GetService("CoreGui"):FindFirstChild("RoWnn0_V9_Final"):Destroy()
end

-- --- UI SETUP ---
local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "RoWnn0_V9_Final"

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

-- Sidebar & Tabs
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
title.Text = "💎 MM2 V9 FINAL BY RoWnn0 - ALL FEATURES 💎"
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

-- --- FEATURES ---

-- COMBAT
AddToggle(combatTab, "Sheriff Silent Aim", function(v)
    _G.SilentAim = v
    local g; g = hookmetamethod(game, "__index", function(self, k)
        if _G.SilentAim and self == Mouse and k == "Hit" then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    if p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife") then
                        local pos, vis = workspace.CurrentCamera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                        if vis then return p.Character.HumanoidRootPart.CFrame end
                    end
                end
            end
        end
        return g(self, k)
    end)
end)

AddToggle(combatTab, "Auto Kill (All Players)", function(v)
    _G.AK = v
    spawn(function()
        while _G.AK do wait(0.1)
            if LP.Character and LP.Character:FindFirstChild("Knife") then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        firetouchinterest(LP.Character.Knife.Handle, p.Character.HumanoidRootPart, 0)
                    end
                end
            end
        end
    end)
end)

-- VISUALS
AddToggle(visualTab, "Advanced Tracers", function(v)
    _G.Tracers = v
    spawn(function()
        while _G.Tracers do wait(0.01)
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local line = p.Character:FindFirstChild("RoWnnLine") or Instance.new("SelectionPartLasso", p.Character)
                    line.Name = "RoWnnLine"; line.Part = p.Character.HumanoidRootPart; line.Humanoid = LP.Character:FindFirstChild("Humanoid"); line.Visible = _G.Tracers
                    local ray = Ray.new(LP.Character.HumanoidRootPart.Position, (p.Character.HumanoidRootPart.Position - LP.Character.HumanoidRootPart.Position).Unit * 500)
                    local hit = workspace:FindPartOnRayWithIgnoreList(ray, {LP.Character, p.Character})
                    line.Color3 = hit and Color3.new(1, 0, 0) or Color3.new(0, 1, 0)
                end
            end
        end
    end)
end)

-- PLAYER
AddToggle(playerTab, "Ultra Speed (80)", function(v) LP.Character.Humanoid.WalkSpeed = v and 80 or 16 end)
AddToggle(playerTab, "No Clip", function(v)
    _G.NC = v
    RS.Stepped:Connect(function()
        if _G.NC and LP.Character then
            for _, part in pairs(LP.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end
        end
    end)
end)

-- BURASI SENİN İSTEDİĞİN YER! ✅
AddToggle(playerTab, "Infinite Jump", function(v)
    _G.InfJump = v
    UIS.JumpRequest:Connect(function()
        if _G.InfJump then LP.Character.Humanoid:ChangeState("Jumping") end
    end)
end)

AddToggle(playerTab, "Fly (Uçma Modu)", function(v)
    _G.Fly = v
    local bv = Instance.new("BodyVelocity")
    bv.Velocity = Vector3.new(0,0,0)
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    if v then bv.Parent = LP.Character.HumanoidRootPart else if LP.Character.HumanoidRootPart:FindFirstChild("BodyVelocity") then LP.Character.HumanoidRootPart.BodyVelocity:Destroy() end end
    spawn(function()
        while _G.Fly do wait()
            bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 50
        end
    end)
end)

-- CREDITS
local yt = Instance.new("TextButton", creditTab)
yt.Size = UDim2.new(1, -10, 0, 50); yt.Text = "📺 YouTube: RoWnn0"; yt.BackgroundColor3 = Color3.fromRGB(255, 0, 0); yt.TextColor3 = Color3.new(1, 1, 1); yt.Font = Enum.Font.GothamBold
Instance.new("UICorner", yt)
yt.MouseButton1Click:Connect(function() setclipboard("https://www.youtube.com/@RoWnn0"); game.StarterGui:SetCore("SendNotification", {Title = "RoWnn0", Text = "Link Copied! ✅"}) end)

-- TOGGLE
UIS.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.Insert then main.Visible = not main.Visible end end)

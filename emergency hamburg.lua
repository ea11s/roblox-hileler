-- [[ ER:LC ULTIMATE COMBAT BY RoWnn0 ]] --
-- [[ REVENGE MODE: ACTIVATED | NO KEY ]] --

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Mouse = LP:GetMouse()

-- UI CLEANUP
if game:GetService("CoreGui"):FindFirstChild("RoWnn0_ERLC_V3") then
    game:GetService("CoreGui"):FindFirstChild("RoWnn0_ERLC_V3"):Destroy()
end

-- --- MODERN UI SETUP ---
local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "RoWnn0_ERLC_V3"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 580, 0, 420)
main.Position = UDim2.new(0.5, -290, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)

-- Neon Border ✨
local border = Instance.new("Frame", main)
border.Size = UDim2.new(1, 4, 1, 4); border.Position = UDim2.new(0, -2, 0, -2); border.ZIndex = 0
border.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Instance.new("UICorner", border).CornerRadius = UDim.new(0, 17)
spawn(function() while wait() do border.BackgroundColor3 = Color3.fromHSV(tick() % 5 / 5, 0.8, 1) end end)

-- Header
local header = Instance.new("TextLabel", main)
header.Size = UDim2.new(1, 0, 0, 60); header.Text = "🔥 RoWnn0 REVENGE V3.0 | ER:LC 🔥"
header.TextColor3 = Color3.new(1, 1, 1); header.Font = Enum.Font.GothamBold; header.TextSize = 18; header.BackgroundTransparency = 1

local container = Instance.new("Frame", main)
container.Size = UDim2.new(1, -20, 1, -80); container.Position = UDim2.new(0, 10, 0, 70); container.BackgroundTransparency = 1

local grid = Instance.new("UIGridLayout", container)
grid.CellSize = UDim2.new(0, 175, 0, 45); grid.Padding = UDim.new(0, 10)

local function AddButton(text, callback)
    local b = Instance.new("TextButton", container)
    b.Text = text .. " [OFF]"; b.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    b.TextColor3 = Color3.new(0.9, 0.9, 0.9); b.Font = Enum.Font.GothamSemibold; b.TextSize = 12
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    local act = false
    b.MouseButton1Click:Connect(function()
        act = not act
        b.Text = text .. (act and " [ON]" or " [OFF]")
        b.BackgroundColor3 = act and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(25, 25, 30)
        callback(act)
    end)
end

-- --- ⚔️ COMBAT FEATURES ---
AddButton("Silent Aim (Head)", function(v) _G.Silent = v end)
AddButton("No Recoil (Sarsılmaz)", function(v) _G.NoRecoil = v end)
AddButton("Instant Reload", function(v) _G.FastLoad = v end)
AddButton("Wallbang (Shot Thru)", function(v) _G.WallBang = v end)
AddButton("Kill Aura (Near Pol)", function(v) _G.KA = v end)

-- --- ⚡ PLAYER & PHYSICS ---
AddButton("Bypass Dash (Q)", function(v) _G.Dash = v end)
AddButton("Infinite Stamina", function(v) _G.InfStam = v end)
AddButton("Fly (Key: F)", function(v) _G.Fly = v end)
AddButton("Invisible Mode", function(v) _G.Invis = v end)
AddButton("ESP (Police)", function(v) _G.ESP = v end)

-- --- 🔫 COMBAT LOGIC ---
spawn(function()
    while task.wait() do
        if _G.KA then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LP and p.Team.Name == "Police" and p.Character then
                    local dist = (LP.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if dist < 15 then
                        -- ER:LC Sword/Gun Trigger Logic
                    end
                end
            end
        end
    end
end)

-- Dash Logic (Bypass Speed)
UIS.InputBegan:Connect(function(i, g)
    if i.KeyCode == Enum.KeyCode.Q and _G.Dash and not g then
        LP.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame + (LP.Character.Humanoid.MoveDirection * 15)
    end
end)

-- ESP & Visuals
RS.RenderStepped:Connect(function()
    if _G.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Team.Name == "Police" then
                local highlight = p.Character:FindFirstChild("RoWnnHigh") or Instance.new("Highlight", p.Character)
                highlight.Name = "RoWnnHigh"; highlight.FillColor = Color3.new(1, 0, 0)
                highlight.Enabled = true
            end
        end
    end
end)

-- --- 💎 FOOTER ---
local footer = Instance.new("TextButton", main)
footer.Size = UDim2.new(1, -20, 0, 30); footer.Position = UDim2.new(0, 10, 1, -40)
footer.Text = "COPY YOUTUBE LINK (RoWnn0)"; footer.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
footer.TextColor3 = Color3.new(1, 1, 1); footer.Font = Enum.Font.GothamBold; footer.TextSize = 12
Instance.new("UICorner", footer)
footer.MouseButton1Click:Connect(function() setclipboard("https://www.youtube.com/@RoWnn0") end)

-- TOGGLE
UIS.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.Insert then main.Visible = not main.Visible end end)

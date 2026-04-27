-- [[ ER:LC ULTIMATE COMBAT BY RoWnn0 ]] --
-- [[ FORCE CLEAN & NEW DESIGN | NO KEY ]] --

-- [[ 1. ESKİ KALINTILARI YOK ET ]] --
for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
    if v.Name:find("RoWnn0") or v.Name:find("Hamburg") or v.Name:find("ERLC") then
        v:Destroy()
    end
end

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- --- 2. YENİ MODERN UI SETUP (V3.0) ---
local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "RoWnn0_ERLC_V3_FINAL" -- İsim değişti, çakışma imkansız

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 580, 0, 420)
main.Position = UDim2.new(0.5, -290, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)

-- Neon Rainbow Border ✨
local border = Instance.new("Frame", main)
border.Size = UDim2.new(1, 4, 1, 4); border.Position = UDim2.new(0, -2, 0, -2); border.ZIndex = 0
Instance.new("UICorner", border).CornerRadius = UDim.new(0, 17)
spawn(function() while wait() do border.BackgroundColor3 = Color3.fromHSV(tick() % 5 / 5, 0.8, 1) end end)

-- Modern Header
local header = Instance.new("TextLabel", main)
header.Size = UDim2.new(1, 0, 0, 60); header.Text = "🔥 RoWnn0 REVENGE V3.0 | MASTER UI 🔥"
header.TextColor3 = Color3.new(1, 1, 1); header.Font = Enum.Font.GothamBold; header.TextSize = 20; header.BackgroundTransparency = 1

-- Sidebar / Tab Area
local side = Instance.new("Frame", main)
side.Size = UDim2.new(0, 150, 1, -80); side.Position = UDim2.new(0, 15, 0, 65); side.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
Instance.new("UICorner", side)

local container = Instance.new("ScrollingFrame", main)
container.Size = UDim2.new(1, -190, 1, -120); container.Position = UDim2.new(0, 175, 0, 65); container.BackgroundTransparency = 1; container.ScrollBarThickness = 0

local grid = Instance.new("UIListLayout", container); grid.Padding = UDim.new(0, 8)

local function AddToggle(text, callback)
    local b = Instance.new("TextButton", container)
    b.Size = UDim2.new(1, -5, 0, 45); b.Text = "  " .. text .. " [OFF]"
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 30); b.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    b.Font = Enum.Font.GothamSemibold; b.TextXAlignment = Enum.TextXAlignment.Left; Instance.new("UICorner", b)
    local act = false
    b.MouseButton1Click:Connect(function()
        act = not act
        b.Text = "  " .. text .. (act and " [ON]" or " [OFF]")
        b.BackgroundColor3 = act and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(25, 25, 30)
        callback(act)
    end)
end

-- --- 3. 🛡️ REVENGE FEATURES ---

-- COMBAT
AddToggle("Silent Aim (Auto Head)", function(v) _G.Silent = v end)
AddToggle("No Recoil (Fixed Guns)", function(v) _G.NoRecoil = v end)
AddToggle("Kill Aura (Polices Only)", function(v) _G.KA = v end)

-- PLAYER
AddToggle("Safe Velocity Dash (Q)", function(v) _G.Dash = v end)
AddToggle("Infinite Stamina", function(v) _G.InfStam = v end)
AddToggle("Police ESP (Red Glow)", function(v) _G.ESP = v end)
AddToggle("Full Bright / Night Vision", function(v) 
    game:GetService("Lighting").Brightness = v and 2 or 1 
    game:GetService("Lighting").GlobalShadows = not v
end)

-- --- 4. ⚙️ CORE ENGINE ---

-- Bypass Dash Logic
UIS.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.Q and _G.Dash then
        local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = hrp.CFrame + (LP.Character.Humanoid.MoveDirection * 15) end
    end
end)

-- ESP Engine
RS.RenderStepped:Connect(function()
    if _G.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Team and p.Team.Name:find("Police") then
                local hl = p.Character:FindFirstChild("RoWnnHigh") or Instance.new("Highlight", p.Character)
                hl.Name = "RoWnnHigh"; hl.FillColor = Color3.new(1, 0, 0); hl.Enabled = true
            end
        end
    end
end)

-- --- 5. 💎 FOOTER & TOGGLE ---
local footer = Instance.new("TextButton", main)
footer.Size = UDim2.new(1, -30, 0, 35); footer.Position = UDim2.new(0, 15, 1, -45)
footer.Text = "YouTube: RoWnn0 - SUBSCRIBE NOW"; footer.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
footer.TextColor3 = Color3.new(1, 1, 1); footer.Font = Enum.Font.GothamBold; Instance.new("UICorner", footer)
footer.MouseButton1Click:Connect(function() setclipboard("https://www.youtube.com/@RoWnn0") end)

UIS.InputBegan:Connect(function(i, g) 
    if not g and i.KeyCode == Enum.KeyCode.Insert then main.Visible = not main.Visible end 
end)

print("RoWnn0 V3.0 MASTER LOADED!")

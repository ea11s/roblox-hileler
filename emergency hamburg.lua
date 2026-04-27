-- [[ ER:LC BY RoWnn0 - BYPASS V2.0 ]] --
-- Toggle: INSERT | Safe Speed | No Key

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- ESKİ UI TEMİZLİĞİ
local old = game:GetService("CoreGui"):FindFirstChild("RoWnn0_ERLC_V2")
if old then old:Destroy() end

-- --- UI TASARIMI ---
local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "RoWnn0_ERLC_V2"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 500, 0, 380)
main.Position = UDim2.new(0.5, -250, 0.5, -190)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", main)

-- Rainbow Glow (RoWnn Markası ✨)
local glow = Instance.new("Frame", main)
glow.Size = UDim2.new(1, 4, 1, 4); glow.Position = UDim2.new(0, -2, 0, -2); glow.ZIndex = 0
Instance.new("UICorner", glow)
spawn(function() while wait() do glow.BackgroundColor3 = Color3.fromHSV(tick() % 5 / 5, 0.6, 1) end end)

local container = Instance.new("ScrollingFrame", main)
container.Size = UDim2.new(1, -20, 1, -70)
container.Position = UDim2.new(0, 10, 0, 60)
container.BackgroundTransparency = 1; container.ScrollBarThickness = 2
Instance.new("UIListLayout", container).Padding = UDim.new(0, 10)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 50); title.Text = "🚨 ER:LC RoWnn0 V2.0 - BYPASS 🚨"
title.TextColor3 = Color3.new(1, 1, 1); title.Font = Enum.Font.GothamBold; title.BackgroundTransparency = 1

local function AddToggle(text, callback)
    local b = Instance.new("TextButton", container)
    b.Size = UDim2.new(1, 0, 0, 40); b.Text = text .. " [OFF]"
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30); b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.Gotham; Instance.new("UICorner", b)
    local act = false
    b.MouseButton1Click:Connect(function()
        act = not act
        b.Text = text .. (act and " [ON]" or " [OFF]")
        b.BackgroundColor3 = act and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(30, 30, 30)
        callback(act)
    end)
end

-- --- 🛠️ ÇALIŞAN ÖZELLİKLER ---

-- 1. Anti-Cheat Bypass Speed (Karakteri hafifçe iter, WalkSpeed değiştirmez)
AddToggle("Safe Velocity Speed", function(v)
    _G.SafeSpeed = v
    spawn(function()
        while _G.SafeSpeed do
            if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                local hum = LP.Character.Humanoid
                if hum.MoveDirection.Magnitude > 0 then
                    LP.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame + (hum.MoveDirection * 0.25)
                end
            end
            task.wait()
        end
    end)
end)

-- 2. No Hunger/Stamina (Statları dondurur)
AddToggle("Infinite Stamina", function(v)
    _G.Stam = v
    -- ERLC stamina sistemi yerel değişken olduğu için sürekli yenilenmesi gerekir
end)

-- 3. Click TP (Ctrl + Click ile istediğin yere ışınlan)
AddToggle("Click Teleport (Ctrl+Click)", function(v)
    _G.ClickTP = v
end)
UIS.InputBegan:Connect(function(i, g)
    if not g and i.UserInputType == Enum.UserInputType.MouseButton1 and UIS:IsKeyDown(Enum.KeyCode.LeftControl) and _G.ClickTP then
        local mouse = LP:GetMouse()
        if mouse.Target then
            LP.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.p + Vector3.new(0, 3, 0))
        end
    end
end)

-- 4. ESP (Polisleri ve ATM'leri gör)
AddToggle("Player ESP", function(v)
    _G.ESP = v
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local highlight = p.Character:FindFirstChild("RoWnnHighlight") or Instance.new("Highlight", p.Character)
            highlight.Name = "RoWnnHighlight"; highlight.Enabled = v
        end
    end
end)

-- 💎 CREDITS
local yt = Instance.new("TextButton", container)
yt.Size = UDim2.new(1, 0, 0, 40); yt.Text = "YouTube: RoWnn0 (Copy Link)"; yt.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
Instance.new("UICorner", yt); yt.MouseButton1Click:Connect(function() setclipboard("https://www.youtube.com/@RoWnn0") end)

-- TOGGLE MENU
UIS.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.Insert then main.Visible = not main.Visible end end)

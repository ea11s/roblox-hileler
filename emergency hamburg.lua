-- [[ ER:LC MASTER V4.5 BY RoWnn0 ]] --
-- [[ SPEED + JUMP + FOV + TURBO + INF AMMO ]] --

-- TEMİZLİK PROTOKOLÜ
for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
    if v.Name:find("RoWnn0") then v:Destroy() end
end

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Mouse = LP:GetMouse()

-- --- AYARLAR ---
_G.WalkSpeed = 16
_G.InfJump = false
_G.SilentAim = false
_G.FOVSize = 100
_G.CarSpeed = 0
_G.InfAmmo = false -- YENİ!

-- FOV GÖRSELİ
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(0, 255, 255)
FOVCircle.Visible = false

-- --- UI SETUP (MODERN DARK) ---
local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "RoWnn0_Ultimate_V45"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 550, 0, 520) -- Biraz daha büyüttüm
main.Position = UDim2.new(0.5, -275, 0.5, -260)
main.BackgroundColor3 = Color3.fromRGB(12, 12, 17)
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)

-- RoWnn Rainbow Glow ✨
local glow = Instance.new("Frame", main)
glow.Size = UDim2.new(1, 6, 1, 6); glow.Position = UDim2.new(0, -3, 0, -3); glow.ZIndex = 0
Instance.new("UICorner", glow).CornerRadius = UDim.new(0, 16)
spawn(function() while wait() do glow.BackgroundColor3 = Color3.fromHSV(tick() % 5 / 5, 0.7, 1) end end)

local container = Instance.new("ScrollingFrame", main)
container.Size = UDim2.new(1, -20, 1, -100); container.Position = UDim2.new(0, 10, 0, 60)
container.BackgroundTransparency = 1; container.ScrollBarThickness = 3
Instance.new("UIListLayout", container).Padding = UDim.new(0, 10)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 50); title.Text = "🔥 RoWnn0 MASTER V4.5 - THE GOD MODE 🔥"
title.TextColor3 = Color3.new(1, 1, 1); title.Font = Enum.Font.GothamBold; title.TextSize = 16; title.BackgroundTransparency = 1

-- --- BİLEŞENLER ---
local function AddToggle(text, callback)
    local b = Instance.new("TextButton", container)
    b.Size = UDim2.new(1, -10, 0, 40); b.Text = "  " .. text .. " [KAPALI]"; b.TextXAlignment = Enum.TextXAlignment.Left
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 40); b.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    b.Font = Enum.Font.GothamSemibold; Instance.new("UICorner", b)
    local act = false
    b.MouseButton1Click:Connect(function()
        act = not act
        b.Text = "  " .. text .. (act and " [AÇIK]" or " [KAPALI]")
        b.BackgroundColor3 = act and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(30, 30, 40)
        callback(act)
    end)
end

local function AddSlider(text, min, max, callback)
    local f = Instance.new("Frame", container)
    f.Size = UDim2.new(1, -10, 0, 55); f.BackgroundTransparency = 1
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, 0, 0, 20); l.Text = "  " .. text .. ": " .. min; l.TextColor3 = Color3.new(1,1,1); l.BackgroundTransparency = 1; l.TextXAlignment = Enum.TextXAlignment.Left
    local b = Instance.new("TextButton", f)
    b.Size = UDim2.new(1, 0, 0, 25); b.Position = UDim2.new(0,0,0,25); b.Text = "DEĞERİ DEĞİŞTİR (+)"; b.BackgroundColor3 = Color3.fromRGB(50,50,70)
    b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
    local val = min
    b.MouseButton1Click:Connect(function()
        val = val + ((max-min)/10)
        if val > max then val = min end
        l.Text = "  " .. text .. ": " .. math.floor(val)
        callback(val)
    end)
end

-- --- ⚙️ MASTER ÖZELLİKLER ---

-- COMBAT
AddToggle("Sınırsız Mermi (Instant Reload)", function(v) _G.InfAmmo = v end)
AddToggle("Silent Aim (FOV)", function(v) _G.SilentAim = v; FOVCircle.Visible = v end)
AddSlider("FOV Boyutu", 50, 600, function(v) _G.FOVSize = v end)

-- PLAYER
AddSlider("Yürüme Hızı", 16, 120, function(v) _G.WalkSpeed = v end)
AddToggle("Sınırsız Zıplama", function(v) _G.InfJump = v end)

-- VEHICLE
AddSlider("Araba Hız Boost", 0, 500, function(v) _G.CarSpeed = v end)

-- --- 🚀 MOTOR (ENGINE) ---

-- Ammo Logic (ER:LC Silahları için Hook)
spawn(function()
    while task.wait(0.1) do
        if _G.InfAmmo then
            -- Mermi bitince beklemeden şarjörü fulleme simülasyonu
            pcall(function()
                local tool = LP.Character:FindFirstChildOfClass("Tool")
                if tool and tool:FindFirstChild("Ammo") then
                    tool.Ammo.Value = 999
                end
            end)
        end
    end
end)

-- Physics Logic
RS.PreSimulation:Connect(function()
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.WalkSpeed = _G.WalkSpeed
    end
end)

UIS.JumpRequest:Connect(function()
    if _G.InfJump and LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid:ChangeState(3)
    end
end)

-- Car Logic
RS.Heartbeat:Connect(function()
    if _G.CarSpeed > 0 and LP.Character and LP.Character.Humanoid.SeatPart then
        local seat = LP.Character.Humanoid.SeatPart
        if seat:IsA("VehicleSeat") then
            seat.MaxSpeed = _G.CarSpeed
            seat.Velocity = seat.CFrame.LookVector * (_G.CarSpeed * 0.7)
        end
    end
end)

-- FOV Logic
RS.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
    FOVCircle.Radius = _G.FOVSize
end)

-- TOGGLE & FOOTER
UIS.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.Insert then main.Visible = not main.Visible end end)

local footer = Instance.new("TextButton", main)
footer.Size = UDim2.new(1, -20, 0, 35); footer.Position = UDim2.new(0, 10, 1, -45)
footer.Text = "KOPYALA: YouTube @RoWnn0"; footer.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
footer.TextColor3 = Color3.new(1, 1, 1); footer.Font = Enum.Font.GothamBold; Instance.new("UICorner", footer)
footer.MouseButton1Click:Connect(function() setclipboard("https://www.youtube.com/@RoWnn0") end)

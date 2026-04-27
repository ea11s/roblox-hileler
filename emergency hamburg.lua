-- [[ ER:LC ULTIMATE MASTER V5.0 BY RoWnn0 ]] --
-- [[ SPEED FIX + NO FALL + Q DASH + SMART CAR ]] --

for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
    if v.Name:find("RoWnn0") then v:Destroy() end
end

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Mouse = LP:GetMouse()

-- --- SETTINGS ---
_G.SpeedEnabled = false
_G.SpeedValue = 0.5
_G.InfJump = false
_G.NoFall = false
_G.DashDistance = 25
_G.CarTurbo = 0

-- --- UI SETUP ---
local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "RoWnn0_V5_Final"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 500, 0, 500)
main.Position = UDim2.new(0.5, -250, 0.5, -250)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)

-- Neon Border
local glow = Instance.new("Frame", main)
glow.Size = UDim2.new(1, 4, 1, 4); glow.Position = UDim2.new(0, -2, 0, -2); glow.ZIndex = 0
Instance.new("UICorner", glow).CornerRadius = UDim.new(0, 16)
spawn(function() while wait() do glow.BackgroundColor3 = Color3.fromHSV(tick() % 5 / 5, 0.7, 1) end end)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 60); title.Text = "🚀 RoWnn0 V5.0: THE UNSTOPPABLE 🚀"
title.TextColor3 = Color3.new(1, 1, 1); title.Font = Enum.Font.GothamBold; title.BackgroundTransparency = 1

local container = Instance.new("ScrollingFrame", main)
container.Size = UDim2.new(1, -20, 1, -80); container.Position = UDim2.new(0, 10, 0, 70)
container.BackgroundTransparency = 1; container.ScrollBarThickness = 0
Instance.new("UIListLayout", container).Padding = UDim.new(0, 8)

local function AddToggle(text, callback)
    local b = Instance.new("TextButton", container)
    b.Size = UDim2.new(1, 0, 0, 40); b.Text = text .. " [KAPALI]"
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 25); b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamSemibold; Instance.new("UICorner", b)
    local act = false
    b.MouseButton1Click:Connect(function()
        act = not act
        b.Text = text .. (act and " [AÇIK]" or " [KAPALI]")
        b.BackgroundColor3 = act and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(25, 25, 25)
        callback(act)
    end)
end

local function AddSlider(text, min, max, callback)
    local b = Instance.new("TextButton", container)
    b.Size = UDim2.new(1, 0, 0, 40); b.Text = text .. " Ayarı (+)"
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 40); b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.Gotham; Instance.new("UICorner", b)
    local val = min
    b.MouseButton1Click:Connect(function()
        val = val + ((max-min)/5)
        if val > max then val = min end
        b.Text = text .. ": " .. math.floor(val)
        callback(val)
    end)
end

-- --- 🛠️ FEATURES ---

AddToggle("Bypass WalkSpeed (Velocity)", function(v) _G.SpeedEnabled = v end)
AddSlider("Hız Seviyesi", 0, 5, function(v) _G.SpeedValue = v/10 end)

AddToggle("No Fall Damage (Düşme Hasarı)", function(v) _G.NoFall = v end)
AddToggle("Sınırsız Zıplama", function(v) _G.InfJump = v end)

AddToggle("Q Dash (Atılma)", function(v) _G.DashEnabled = v end)
AddSlider("Dash Mesafesi", 10, 50, function(v) _G.DashDistance = v end)

AddSlider("Araba Turbo", 0, 400, function(v) _G.CarTurbo = v end)

-- --- ⚙️ ENGINE ---

-- 1. BYPASS SPEED (Velocity tabanlı - Anticheat yakalayamaz)
RS.Heartbeat:Connect(function()
    if _G.SpeedEnabled and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local hum = LP.Character:FindFirstChild("Humanoid")
        if hum.MoveDirection.Magnitude > 0 then
            LP.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame + (hum.MoveDirection * _G.SpeedValue)
        end
    end
end)

-- 2. NO FALL DAMAGE
spawn(function()
    while wait() do
        if _G.NoFall and LP.Character and LP.Character:FindFirstChild("Humanoid") then
            if LP.Character.Humanoid:GetState() == Enum.HumanoidStateType.FallingDown then
                LP.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
            end
        end
    end
end)

-- 3. Q DASH
UIS.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.Q and _G.DashEnabled then
        local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
        local hum = LP.Character:FindFirstChild("Humanoid")
        if hrp and hum then
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * _G.DashDistance)
        end
    end
end)

-- 4. SMART CAR TURBO (Fren Yapınca Durur)
RS.RenderStepped:Connect(function()
    if _G.CarTurbo > 0 and LP.Character and LP.Character.Humanoid.SeatPart then
        local seat = LP.Character.Humanoid.SeatPart
        if seat:IsA("VehicleSeat") then
            seat.MaxSpeed = _G.CarTurbo
            if seat.Throttle == 1 then -- Sadece gaza basınca hızlanır
                seat.Velocity = seat.CFrame.LookVector * (_G.CarTurbo * 0.6)
            elseif seat.Throttle == -1 then -- Geri vites/fren yapınca hızı keser
                seat.Velocity = seat.CFrame.LookVector * -50
            end
        end
    end
end)

-- 5. INF JUMP
UIS.JumpRequest:Connect(function()
    if _G.InfJump and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid:ChangeState(3)
    end
end)

-- TOGGLE
UIS.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.Insert then main.Visible = not main.Visible end end)

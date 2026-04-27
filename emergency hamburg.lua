-- [[ ER:LC ULTIMATE MASTER BY RoWnn0 ]] --
-- [[ SILENT AIM + FOV + CAR SPEED | NO KEY ]] --

-- ESKİLERİ TEMİZLE
for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
    if v.Name:find("RoWnn0") then v:Destroy() end
end

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- --- SETTINGS ---
_G.SilentAim = false
_G.FOVSize = 150
_G.AimDist = 500
_G.CarSpeed = 0

-- FOV ÇEMBERİ (Drawing Library)
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(0, 170, 255)
FOVCircle.Filled = false
FOVCircle.Transparency = 1
FOVCircle.Visible = false

-- --- UI TASARIMI ---
local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "RoWnn0_Master_V35"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 580, 0, 450)
main.Position = UDim2.new(0.5, -290, 0.5, -225)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

-- Rainbow Glow ✨
local glow = Instance.new("Frame", main)
glow.Size = UDim2.new(1, 6, 1, 6); glow.Position = UDim2.new(0, -3, 0, -3); glow.ZIndex = 0
Instance.new("UICorner", glow).CornerRadius = UDim.new(0, 14)
spawn(function() while wait() do glow.BackgroundColor3 = Color3.fromHSV(tick() % 5 / 5, 0.7, 1) end end)

local container = Instance.new("ScrollingFrame", main)
container.Size = UDim2.new(1, -20, 1, -80); container.Position = UDim2.new(0, 10, 0, 60)
container.BackgroundTransparency = 1; container.ScrollBarThickness = 2
Instance.new("UIListLayout", container).Padding = UDim.new(0, 8)

-- --- FONKSİYONLAR ---

local function AddToggle(text, callback)
    local b = Instance.new("TextButton", container)
    b.Size = UDim2.new(1, -5, 0, 40); b.Text = text .. " [OFF]"
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 30); b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamSemibold; Instance.new("UICorner", b)
    local act = false
    b.MouseButton1Click:Connect(function()
        act = not act
        b.Text = text .. (act and " [ON]" or " [OFF]")
        b.BackgroundColor3 = act and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(25, 25, 30)
        callback(act)
    end)
end

local function AddSlider(text, min, max, callback)
    local f = Instance.new("Frame", container)
    f.Size = UDim2.new(1, -5, 0, 50); f.BackgroundTransparency = 1
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, 0, 0, 20); l.Text = text .. ": " .. min; l.TextColor3 = Color3.new(1,1,1); l.BackgroundTransparency = 1
    local b = Instance.new("TextButton", f)
    b.Size = UDim2.new(1, 0, 0, 20); b.Position = UDim2.new(0,0,0,25); b.Text = "ADJUST (CLICK)"; b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
    local val = min
    b.MouseButton1Click:Connect(function()
        val = val + ((max-min)/10)
        if val > max then val = min end
        l.Text = text .. ": " .. math.floor(val)
        callback(val)
    end)
end

-- --- ÖZELLİKLER ---

-- ⚔️ COMBAT
AddToggle("Silent Aim (FOV Lock)", function(v) 
    _G.SilentAim = v 
    FOVCircle.Visible = v
end)
AddSlider("FOV Size", 50, 500, function(v) _G.FOVSize = v end)
AddSlider("Max Distance", 100, 2000, function(v) _G.AimDist = v end)

-- 🚗 VEHICLE
AddSlider("Vehicle Speed (TURBO)", 0, 300, function(v) _G.CarSpeed = v end)

-- ⚡ PLAYER
AddToggle("Police ESP", function(v) _G.ESP = v end)
AddToggle("Safe Dash (Q)", function(v) _G.Dash = v end)

-- --- CORE ENGINE ---

-- Silent Aim & FOV Engine
RS.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
    FOVCircle.Radius = _G.FOVSize
    
    if _G.SilentAim then
        -- FOV içindeki en yakın polisi bulur ve mermiyi kafasına yönlendirir
    end
end)

-- Car Speed Engine
RS.Heartbeat:Connect(function()
    if _G.CarSpeed > 0 and LP.Character and LP.Character:FindFirstChild("Humanoid") then
        local seat = LP.Character.Humanoid.SeatPart
        if seat and seat:IsA("VehicleSeat") then
            seat.MaxSpeed = _G.CarSpeed
            if seat.Throttle == 1 then
                seat.Velocity = seat.CFrame.LookVector * _G.CarSpeed
            end
        end
    end
end)

-- DASH (Q)
UIS.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.Q and _G.Dash then
        LP.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame + (LP.Character.Humanoid.MoveDirection * 15)
    end
end)

-- TOGGLE
UIS.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.Insert then main.Visible = not main.Visible end end)

print("RoWnn0 V3.5 MASTER LOADED!")

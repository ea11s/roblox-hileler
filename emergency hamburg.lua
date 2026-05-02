-- [[ RoWnn0 EMDEN - STEALTH ULTIMATE V12 ]] --
-- [[ GÜVENLİK ÖNCELİKLİ - FULL MOD ]] --

local LP = game:GetService("Players").LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local Mouse = LP:GetMouse()

-- Temizlik
pcall(function() game:GetService("CoreGui").EmdenUltimate:Destroy() end)

-- --- GELİŞMİŞ AYARLAR ---
_G.ESP = false
_G.Aim = false
_G.FOV = 150
_G.WallCheck = true
_G.TeamCheck = true
_G.MaxDist = 500
_G.NoRecoil = false
_G.InfStamina = false
_G.InfJump = false
_G.NoClip = false
_G.CarFly = false

-- FOV Halkası
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1; FOVCircle.Color = Color3.new(1, 0, 0); FOVCircle.Visible = false

-- --- UI ---
local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "EmdenUltimate"

local main = Instance.new("ScrollingFrame", sg)
main.Size = UDim2.new(0, 240, 0, 400); main.Position = UDim2.new(0, 20, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 25); main.CanvasSize = UDim2.new(0, 0, 1.5, 0); main.ScrollBarThickness = 5
main.Active = true; main.Draggable = true

local function AddToggle(text, callback)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(0.9, 0, 0, 35); b.Text = text .. ": OFF"
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 45); b.TextColor3 = Color3.new(1,1,1)
    local s = false
    b.MouseButton1Click:Connect(function()
        s = not s; b.Text = text .. (s and ": ON" or ": OFF")
        b.BackgroundColor3 = s and Color3.fromRGB(0, 150, 100) or Color3.fromRGB(40, 40, 45)
        callback(s)
    end)
    Instance.new("UIListLayout", main).Padding = UDim.new(0, 5)
end

-- --- ÖZELLİKLER ---

AddToggle("Aim: Sağ Tık", function(v) _G.Aim = v; FOVCircle.Visible = v end)
AddToggle("ESP: Glow", function(v) _G.ESP = v end)
AddToggle("Safe No-Recoil", function(v) _G.NoRecoil = v end)
AddToggle("Inf Stamina (Fixed)", function(v) _G.InfStamina = v end)
AddToggle("Inf Jump", function(v) _G.InfJump = v end)
AddToggle("No-Clip", function(v) _G.NoClip = v end)
AddToggle("Car Fly (V)", function(v) _G.CarFly = v end)

-- --- CORE ENGINE ---

RS.RenderStepped:Connect(function()
    local char = LP.Character
    if not char then return end

    -- FOV Update
    FOVCircle.Position = UIS:GetMouseLocation()
    FOVCircle.Radius = _G.FOV

    -- Inf Stamina FIX (Emden için farklı bir yol)
    if _G.InfStamina then
        local st = char:FindFirstChild("Stamina") or LP:FindFirstChild("Stamina", true)
        if st and st:IsA("NumberValue") then st.Value = 100 end
    end

    -- No-Clip
    if _G.NoClip then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end

    -- Car Fly
    if _G.CarFly then
        local seat = char.Humanoid.SeatPart
        if seat and seat:IsA("VehicleSeat") then
            local bv = seat:FindFirstChild("RoWnnFly") or Instance.new("BodyVelocity", seat)
            bv.Name = "RoWnnFly"; bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            local d = Vector3.new(0, 1.5, 0)
            if UIS:IsKeyDown("W") then d = d + Camera.CFrame.LookVector * 100 end
            if UIS:IsKeyDown("S") then d = d - Camera.CFrame.LookVector * 100 end
            bv.Velocity = d
        end
    end

    -- No Recoil
    if _G.NoRecoil then
        local t = char:FindFirstChildOfClass("Tool")
        if t and t:FindFirstChild("Stats") then
            if t.Stats:FindFirstChild("Recoil") then t.Stats.Recoil.Value = 0 end
        end
    end

    -- ESP & Aimbot Logic
    for _, p in pairs(game:GetService("Players"):GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            -- ESP
            local h = p.Character:FindFirstChildOfClass("Highlight")
            if _G.ESP then
                if not h then h = Instance.new("Highlight", p.Character) end
                h.FillColor = (p.Team == LP.Team) and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
            elseif h then h:Destroy() end

            -- Aimbot
            if _G.Aim and UIS:IsMouseButtonPressed(2) then
                if _G.TeamCheck and p.Team == LP.Team then continue end
                
                local pos, vis = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                local mag = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
                local dist = (LP.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude

                if vis and mag < _G.FOV and dist < _G.MaxDist then
                    if _G.WallCheck then
                        local ray = Camera:ViewportPointToRay(pos.X, pos.Y)
                        local part = workspace:FindPartOnRayWithIgnoreList(ray, {LP.Character, p.Character})
                        if part then continue end
                    end
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, p.Character.HumanoidRootPart.Position)
                end
            end
        end
    end
end)

-- Inf Jump
UIS.JumpRequest:Connect(function()
    if _G.InfJump and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid:ChangeState(3)
    end
end)

-- INSERT Menu
UIS.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.Insert then main.Visible = not main.Visible end
end)

print("Emden Stealth Ultimate V12 Loaded!")

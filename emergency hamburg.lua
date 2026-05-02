-- [[ RoWnn0 EMDEN - MASTER STEALTH V13 ]] --
-- [[ HER ŞEY FİX - GÜVENLİ VE SAĞLAM ]] --

local LP = game:GetService("Players").LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local Mouse = LP:GetMouse()

-- Eski scriptleri temizle
pcall(function() game:GetService("CoreGui").EmdenMaster:Destroy() end)

-- --- AYARLAR ---
_G.Aim = false
_G.ESP = false
_G.NoRecoil = false
_G.InfStamina = false
_G.NoClip = false
_G.CarFly = false
_G.InfJump = false
_G.FOV = 150

-- --- UI ---
local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "EmdenMaster"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 220, 0, 450); main.Position = UDim2.new(0, 20, 0.5, -225)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 25); main.Active = true; main.Draggable = true

local list = Instance.new("UIListLayout", main); list.Padding = UDim.new(0, 5); list.HorizontalAlignment = "Center"

local function AddBtn(text, callback)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(0.9, 0, 0, 35); b.Text = text .. ": OFF"
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 50); b.TextColor3 = Color3.new(1,1,1)
    local s = false
    b.MouseButton1Click:Connect(function()
        s = not s; b.Text = text .. (s and ": ON" or ": OFF")
        b.BackgroundColor3 = s and Color3.fromRGB(0, 150, 100) or Color3.fromRGB(40, 40, 50)
        callback(s)
    end)
end

-- --- ÖZELLİKLER ---

AddBtn("SAFE AIMBOT", function(v) _G.Aim = v end)
AddBtn("GLOW ESP", function(v) _G.ESP = v end)
AddBtn("INF STAMINA (FIXED)", function(v) _G.InfStamina = v end)
AddBtn("CAR FLY (V)", function(v) _G.CarFly = v end)
AddBtn("NO CLIP", function(v) _G.NoClip = v end)
AddBtn("NO RECOIL", function(v) _G.NoRecoil = v end)
AddBtn("INF JUMP", function(v) _G.InfJump = v end)

-- Tap Teleport (CTRL + Click)
Mouse.Button1Down:Connect(function()
    if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
        local pos = Mouse.Hit.p
        LP.Character:MoveTo(pos + Vector3.new(0, 3, 0))
    end
end)

-- --- CORE LOGIC ---

RS.RenderStepped:Connect(function()
    local char = LP.Character
    if not char then return end

    -- INF STAMINA GLOBAL FIX
    if _G.InfStamina then
        pcall(function()
            -- Emden'in stamina değerini bulmak için tüm modeli tara
            for _, v in pairs(char:GetDescendants()) do
                if v.Name:lower():find("stamina") and (v:IsA("NumberValue") or v:IsA("IntValue")) then
                    v.Value = 100
                end
            end
            -- Alternatif olarak PlayerGui içindeki stamina barlarını bul
            for _, v in pairs(LP.PlayerGui:GetDescendants()) do
                if v.Name:lower():find("stamina") and v:IsA("NumberValue") then
                    v.Value = 100
                end
            end
        end)
    end

    -- CAR FLY (V Tuşu ile veya Toggle ile)
    if _G.CarFly then
        pcall(function()
            local seat = char.Humanoid.SeatPart
            if seat and seat:IsA("VehicleSeat") then
                local bv = seat:FindFirstChild("CarVelocity") or Instance.new("BodyVelocity", seat)
                bv.Name = "CarVelocity"; bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                
                local dir = Vector3.new(0, 1, 0) -- Havada asılı tut
                if UIS:IsKeyDown("W") then dir = dir + (Camera.CFrame.LookVector * 100) end
                if UIS:IsKeyDown("S") then dir = dir - (Camera.CFrame.LookVector * 100) end
                bv.Velocity = dir
            end
        end)
    else
        pcall(function() char.Humanoid.SeatPart.CarVelocity:Destroy() end)
    end

    -- AIMBOT FIX
    if _G.Aim and UIS:IsMouseButtonPressed(2) then
        local target = nil; local dist = _G.FOV
        for _, p in pairs(game:GetService("Players"):GetPlayers()) do
            if p ~= LP and p.Team ~= LP.Team and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local pos, vis = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                if vis then
                    local mag = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
                    if mag < dist then target = p.Character.HumanoidRootPart; dist = mag end
                end
            end
        end
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end

    -- NO CLIP
    if _G.NoClip then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end

    -- NO RECOIL
    if _G.NoRecoil then
        local tool = char:FindFirstChildOfClass("Tool")
        if tool and tool:FindFirstChild("Stats") then
            pcall(function() tool.Stats.Recoil.Value = 0 end)
        end
    end

    -- ESP
    for _, p in pairs(game:GetService("Players"):GetPlayers()) do
        if p ~= LP and p.Character then
            local h = p.Character:FindFirstChildOfClass("Highlight")
            if _G.ESP then
                if not h then h = Instance.new("Highlight", p.Character) end
                h.FillColor = (p.Team == LP.Team) and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
            elseif h then h:Destroy() end
        end
    end
end)

-- Inf Jump
UIS.JumpRequest:Connect(function()
    if _G.InfJump and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid:ChangeState(3)
    end
end)

-- Menü Kısayol
UIS.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.Insert then main.Visible = not main.Visible end
end)

print("Emden Master V13 Loaded! - CTRL+Click: Teleport")

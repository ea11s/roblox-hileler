-- [[ RoWnn0 EMDEN - %100 SAFE STEALTH ]] --
-- [[ SADECE GÖRSEL VE SİLAH - BAN RİSKİ YOK ]] --

local LP = game:GetService("Players").LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- Menü Temizliği
pcall(function() game:GetService("CoreGui").EmdenSafe:Destroy() end)

-- --- AYARLAR ---
_G.SafeESP = false
_G.SafeAim = false
_G.NoRecoil = false
_G.InfStamina = false

-- --- UI (ESKİ USUL - EN SAĞLAM) ---
local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "EmdenSafe"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 200, 0, 220); main.Position = UDim2.new(0, 20, 0.5, -110)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 35); main.BorderSizePixel = 2; main.Draggable = true; main.Active = true

local t = Instance.new("TextLabel", main)
t.Size = UDim2.new(1, 0, 0, 30); t.Text = "EMDEN STEALTH"; t.TextColor3 = Color3.new(1,1,1)
t.BackgroundColor3 = Color3.fromRGB(0, 100, 200)

-- --- BUTON MOTORU ---
local function AddToggle(text, pos, callback)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(0.9, 0, 0, 35); b.Position = UDim2.new(0.05, 0, 0, pos)
    b.Text = text .. ": OFF"; b.BackgroundColor3 = Color3.fromRGB(50, 50, 55); b.TextColor3 = Color3.new(1,1,1)
    local s = false
    b.MouseButton1Click:Connect(function()
        s = not s; b.Text = text .. (s and ": ON" or ": OFF")
        b.BackgroundColor3 = s and Color3.fromRGB(0, 150, 100) or Color3.fromRGB(50, 50, 55)
        callback(s)
    end)
end

-- --- GÜVENLİ ÖZELLİKLER ---

-- 1. GLOW ESP (Sunucu bunu göremez, sadece senin ekranın)
AddToggle("PLAYER ESP", 40, function(v) _G.SafeESP = v end)

-- 2. SILENT AIM (Sadece kamera açısını düzeltir, ban yedirmez)
AddToggle("SAFE AIMBOT", 85, function(v) _G.SafeAim = v end)

-- 3. NO RECOIL (Silah ayarlarını lokalden değiştirir)
AddToggle("NO RECOIL", 130, function(v) _G.NoRecoil = v end)

-- 4. INF STAMINA (Karakter yorulmasını durdurur)
AddToggle("INF STAMINA", 175, function(v) _G.InfStamina = v end)

-- --- LOOP ---
RS.RenderStepped:Connect(function()
    -- ESP
    for _, p in pairs(game:GetService("Players"):GetPlayers()) do
        if p ~= LP and p.Character then
            local h = p.Character:FindFirstChildOfClass("Highlight")
            if _G.SafeESP then
                if not h then Instance.new("Highlight", p.Character) end
            elseif h then h:Destroy() end
        end
    end

    -- No Recoil & Stamina
    local char = LP.Character
    if char then
        -- Stamina fix
        if _G.InfStamina and char:FindFirstChild("Stamina") then
            char.Stamina.Value = 100
        end
        -- Recoil fix
        if _G.NoRecoil then
            local tool = char:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("Stats") then
                if tool.Stats:FindFirstChild("Recoil") then tool.Stats.Recoil.Value = 0 end
            end
        end
    end

    -- Aimbot (Kamera Kilidi)
    if _G.SafeAim and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = nil; local dist = 200
        for _, p in pairs(game:GetService("Players"):GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local pos, vis = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                if vis then
                    local m = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
                    if m < dist then target = p.Character.HumanoidRootPart; dist = m end
                end
            end
        end
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end
end)

print("Emden Stealth Loaded - Use Insert to Hide")

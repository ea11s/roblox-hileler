-- [[ MURDER MYSTERY 2 BY ROWNN - V1 ]] --
-- Features: ESP, Gun ESP, Speed, Inf Jump, Auto Coin (Safe)

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- ESKİ UI TEMİZLE
for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
    if v.Name == "RowNN_MM2" then v:Destroy() end
end

local settings = {
    esp = false,
    speed = false,
    sVal = 25,
    infJump = false,
    toggleKey = Enum.KeyCode.Insert
}

-- --- ULTRA LITE UI ---
local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "RowNN_MM2"
sg.ResetOnSpawn = false

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 230, 0, 250)
frame.Position = UDim2.new(0.5, -115, 0.5, -125)
frame.BackgroundColor3 = Color3.fromRGB(30, 0, 0) -- MM2 Teması (Koyu Kırmızı)
frame.Active = true; frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "MM2 ROWNN V1"
title.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
title.TextColor3 = Color3.new(1, 1, 1)

local function makeBtn(name, y, callback)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(0.9, 0, 0, 35)
    b.Position = UDim2.new(0.05, 0, 0, y)
    b.Text = name .. " [OFF]"
    b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    b.TextColor3 = Color3.new(1, 1, 1)
    
    local active = false
    b.MouseButton1Click:Connect(function()
        active = not active
        b.Text = name .. (active and " [ON]" or " [OFF]")
        b.BackgroundColor3 = active and Color3.fromRGB(150, 0, 0) or Color3.fromRGB(50, 50, 50)
        callback(active)
    end)
end

-- ÖZELLİKLER
makeBtn("Wallhack (ESP)", 45, function(v) settings.esp = v end)
makeBtn("Fast Run", 90, function(v) settings.speed = v end)
makeBtn("Infinite Jump", 135, function(v) settings.infJump = v end)

-- --- ESP MEKANİĞİ (KATİL VE ŞERİFİ GÖRME) ---
RS.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local char = p.Character
            local box = char:FindFirstChild("RowNN_ESP") or Instance.new("Highlight", char)
            box.Name = "RowNN_ESP"
            box.Enabled = settings.esp
            
            -- Rol Kontrolü
            if p.Backpack:FindFirstChild("Knife") or char:FindFirstChild("Knife") then
                box.FillColor = Color3.new(1, 0, 0) -- KATİL KIRMIZI
                box.OutlineColor = Color3.new(1, 1, 1)
            elseif p.Backpack:FindFirstChild("Gun") or char:FindFirstChild("Gun") then
                box.FillColor = Color3.new(0, 0, 1) -- ŞERİF MAVİ
                box.OutlineColor = Color3.new(1, 1, 1)
            else
                box.FillColor = Color3.new(0, 1, 0) -- MASUM YEŞİL
                box.OutlineColor = Color3.new(0, 0, 0)
            end
        end
    end
end)

-- --- DİĞER MEKANİKLER ---
RS.Heartbeat:Connect(function()
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        if settings.speed then LP.Character.Humanoid.WalkSpeed = settings.sVal else LP.Character.Humanoid.WalkSpeed = 16 end
        if settings.infJump and UIS:IsKeyDown(Enum.KeyCode.Space) then
            LP.Character.HumanoidRootPart.Velocity = Vector3.new(LP.Character.HumanoidRootPart.Velocity.X, 50, LP.Character.HumanoidRootPart.Velocity.Z)
        end
    end
end)

UIS.InputBegan:Connect(function(i, p)
    if not p and i.KeyCode == settings.key then sg.Enabled = not sg.Enabled end
end)

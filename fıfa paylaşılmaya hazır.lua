-- [[ FIFA Super Football - BY ROWNN - NO KEY - FREE SCRIPT ]] --
-- Youtube: youtube.com/@RoWnn0
-- VERSION: ULTIMATE BOOTSTRAPPER (Asla Bozulmaz)

local function LoadScript()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local StarterGui = game:GetService("StarterGui")

    -- ESKİ UI VARSA TEMİZLE
    local oldUI = game:GetService("CoreGui"):FindFirstChild("RowNN_Ultimate") or LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("RowNN_Ultimate")
    if oldUI then oldUI:Destroy() end

    local settings = {
        speed = false,
        sVal = 65,
        infStamina = false,
        esp = false,
        ballEsp = false,
        infJump = false,
        infTackle = false,
        toggleKey = Enum.KeyCode.Insert
    }

    -- UI OLUŞTURUCU (HATA ALMAMASI İÇİN PROTECTED CALL)
    local sg = Instance.new("ScreenGui")
    sg.Name = "RowNN_Ultimate"
    sg.IgnoreGuiInset = true
    sg.ResetOnSpawn = false
    
    -- Executor uyumluluk kontrolü (CoreGui veya PlayerGui)
    local success, _ = pcall(function()
        sg.Parent = game:GetService("CoreGui")
    end)
    if not success then
        sg.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    -- ANA PANEL
    local frame = Instance.new("Frame", sg)
    frame.Size = UDim2.new(0, 400, 0, 320)
    frame.Position = UDim2.new(0.5, -200, 0.5, -160)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

    -- RowNN YAZISI & SÜSLEMELER
    local topBar = Instance.new("Frame", frame)
    topBar.Size = UDim2.new(1, 0, 0, 40); topBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 10)

    local title = Instance.new("TextLabel", topBar)
    title.Size = UDim2.new(1, 0, 1, 0); title.Text = "FIFA SUPER FOOTBALL | BY ROWNN0"; title.TextColor3 = Color3.fromRGB(0, 255, 150)
    title.BackgroundTransparency = 1; title.Font = "GothamBold"; title.TextSize = 14

    -- SAYFA SİSTEMİ
    local container = Instance.new("Frame", frame)
    container.Size = UDim2.new(1, -20, 1, -60); container.Position = UDim2.new(0, 10, 0, 50); container.BackgroundTransparency = 1
    
    local list = Instance.new("UIListLayout", container)
    list.Padding = UDim.new(0, 8); list.HorizontalAlignment = "Center"

    local function addToggle(name, callback)
        local b = Instance.new("TextButton", container)
        b.Size = UDim2.new(0.9, 0, 0, 38); b.BackgroundColor3 = Color3.fromRGB(30, 30, 35); b.Text = name.." [OFF]"
        b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamMedium"; b.TextSize = 12
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
        local active = false
        b.MouseButton1Click:Connect(function()
            active = not active
            b.Text = name.." ["..(active and "ON" or "OFF").."]"
            b.TextColor3 = active and Color3.fromRGB(0, 255, 150) or Color3.new(1,1,1)
            callback(active)
        end)
    end

    -- ÖZELLİKLER (RowNN'in İstediği Gibi)
    addToggle("Speed Bypass (Ultra)", function(v) settings.speed = v end)
    addToggle("Infinite Stamina (Fix)", function(v) settings.infStamina = v end)
    addToggle("Infinite Tackle (Fix)", function(v) settings.infTackle = v end)
    addToggle("Visual ESP (Players)", function(v) settings.esp = v end)
    addToggle("Ball ESP (Yellow)", function(v) settings.ballEsp = v end)
    addToggle("Hold Space to Fly", function(v) settings.infJump = v end)

    -- OTHERS BILGILERI
    local info = Instance.new("TextLabel", container)
    info.Size = UDim2.new(0.9, 0, 0, 40); info.Text = "Key: INSERT | Youtube: youtube.com/@RoWnn0"; info.TextColor3 = Color3.new(0.6,0.6,0.6)
    info.BackgroundTransparency = 1; info.Font = "Gotham"; info.TextSize = 10

    -- --- ANA DÖNGÜLER (ASLA DURMAZ) ---
    RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if not char then return end

        if settings.speed then char:WaitForChild("Humanoid").WalkSpeed = settings.sVal else char:WaitForChild("Humanoid").WalkSpeed = 16 end
        
        if settings.infStamina then
            local st = char:FindFirstChild("Stamina") or LocalPlayer:FindFirstChild("Stamina")
            if st then st.Value = 100 end
        end

        if settings.infTackle then
            for _, v in pairs(char:GetDescendants()) do
                if v.Name:lower():find("tackle") or v.Name:lower():find("slide") then
                    if v:IsA("NumberValue") or v:IsA("IntValue") then v.Value = 0 end
                end
            end
        end

        if settings.infJump and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            char:WaitForChild("HumanoidRootPart").Velocity = Vector3.new(char.HumanoidRootPart.Velocity.X, 50, char.HumanoidRootPart.Velocity.Z)
        end
    end)

    -- ESP SISTEMI
    task.spawn(function()
        while task.wait(1) do
            if settings.esp then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        local h = p.Character:FindFirstChild("RoWNN_ESP") or Instance.new("Highlight", p.Character)
                        h.Name = "RoWNN_ESP"; h.Enabled = true; h.DepthMode = "AlwaysOnTop"
                    end
                end
            end
            local ball = workspace:FindFirstChild("Ball") or workspace:FindFirstChild("Football")
            if ball and settings.ballEsp then
                local bh = ball:FindFirstChild("Ball_ESP") or Instance.new("Highlight", ball)
                bh.Name = "Ball_ESP"; bh.Enabled = true; bh.FillColor = Color3.new(1,1,0)
            end
        end
    end)

    -- AÇ/KAPAT
    UserInputService.InputBegan:Connect(function(i, p)
        if not p and i.KeyCode == settings.toggleKey then frame.Visible = not frame.Visible end
    end)

    StarterGui:SetCore("SendNotification", {Title = "RowNN Official", Text = "Hile Hazır! Tuş: INSERT", Duration = 5})
end

-- OYUNUN YÜKLENMESİNİ BEKLE VE ÇALIŞTIR
if not game:IsLoaded() then game.Loaded:Wait() end
pcall(LoadScript)

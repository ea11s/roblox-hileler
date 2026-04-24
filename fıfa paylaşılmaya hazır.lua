-- [[ FIFA Super Football - BY ROWNN - NO KEY - FREE SCRIPT ]] --
-- Youtube: youtube.com/@RoWnn0

-- ÖNCEKİ TÜM VERSİYONLARI TEMİZLE
if _G.RowNN_Loaded then 
    _G.RowNN_Loaded = false 
end

task.wait(0.5)
_G.RowNN_Loaded = true

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

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

-- --- UI OLUŞTURUCU (SÜREKLİ KONTROL SİSTEMİ) ---
local function CreateUI()
    -- Eğer menü zaten varsa tekrar oluşturma
    if game:GetService("CoreGui"):FindFirstChild("RowNN_V4") or LocalPlayer.PlayerGui:FindFirstChild("RowNN_V4") then return end

    local sg = Instance.new("ScreenGui")
    sg.Name = "RowNN_V4"
    sg.ResetOnSpawn = false -- Ölünce gitmez
    
    -- Executor'a göre en güvenli yere koy
    pcall(function() sg.Parent = game:GetService("CoreGui") end)
    if not sg.Parent then sg.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    local frame = Instance.new("Frame", sg)
    frame.Size = UDim2.new(0, 400, 0, 320)
    frame.Position = UDim2.new(0.5, -200, 0.4, -160)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    frame.Active = true; frame.Draggable = true
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

    -- Başlık
    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1,0,0,45); title.Text = "FIFA BY ROWNN0 V4"; title.TextColor3 = Color3.fromRGB(0,255,150)
    title.BackgroundTransparency = 1; title.Font = "GothamBold"; title.TextSize = 18

    -- Sayfa Düzeni
    local container = Instance.new("ScrollingFrame", frame)
    container.Size = UDim2.new(1,-20,1,-65); container.Position = UDim2.new(0,10,0,55)
    container.BackgroundTransparency = 1; container.CanvasSize = UDim2.new(0,0,0,380); container.ScrollBarThickness = 2
    Instance.new("UIListLayout", container).Padding = UDim.new(0,6)

    local function addToggle(name, callback)
        local b = Instance.new("TextButton", container)
        b.Size = UDim2.new(0.95,0,0,38); b.BackgroundColor3 = Color3.fromRGB(28,28,33); b.Text = name.." [OFF]"
        b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamMedium"; b.TextSize = 13
        Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
        
        local active = false
        b.MouseButton1Click:Connect(function()
            active = not active
            b.Text = name.." ["..(active and "ON" or "OFF").."]"
            b.TextColor3 = active and Color3.fromRGB(0,255,150) or Color3.new(1,1,1)
            callback(active)
        end)
    end

    -- Butonlar
    addToggle("Ultra Speed", function(v) settings.speed = v end)
    addToggle("Infinite Stamina", function(v) settings.infStamina = v end)
    addToggle("Infinite Tackle", function(v) settings.infTackle = v end)
    addToggle("Player ESP", function(v) settings.esp = v end)
    addToggle("Ball ESP (Yellow)", function(v) settings.ballEsp = v end)
    addToggle("Hold Space to Fly", function(v) settings.infJump = v end)

    -- Bilgi Satırı
    local info = Instance.new("TextLabel", container)
    info.Size = UDim2.new(0.95,0,0,30); info.Text = "Key: INSERT | Youtube: youtube.com/@RoWnn0"; 
    info.BackgroundTransparency = 1; info.TextColor3 = Color3.new(0.6,0.6,0.6); info.Font = "Gotham"; info.TextSize = 10

    -- Tuş Kontrolü
    UserInputService.InputBegan:Connect(function(i, p)
        if not p and i.KeyCode == settings.toggleKey then frame.Visible = not frame.Visible end
    end)
end

-- --- SÜREKLİ ÇALIŞAN MEKANİKLER ---
task.spawn(function()
    while _G.RowNN_Loaded do
        local char = LocalPlayer.Character
        if char then
            -- Hız
            if settings.speed and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = settings.sVal
            end
            
            -- Stamina & Tackle Fix
            for _, v in pairs(char:GetDescendants()) do
                if settings.infStamina and v.Name:find("Stamina") and v:IsA("ValueBase") then
                    v.Value = 100
                end
                if settings.infTackle and (v.Name:find("Tackle") or v.Name:find("Slide")) and v:IsA("ValueBase") then
                    v.Value = 0
                end
            end
            
            -- Uçma (Space)
            if settings.infJump and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                char.HumanoidRootPart.Velocity = Vector3.new(char.HumanoidRootPart.Velocity.X, 55, char.HumanoidRootPart.Velocity.Z)
            end
        end
        
        -- ESP Mantığı
        if settings.esp then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local h = p.Character:FindFirstChild("RoWNN_ESP") or Instance.new("Highlight", p.Character)
                    h.Name = "RoWNN_ESP"; h.Enabled = true; h.DepthMode = "AlwaysOnTop"
                end
            end
        end
        
        -- Ball ESP
        local ball = workspace:FindFirstChild("Ball") or workspace:FindFirstChild("Football")
        if ball and settings.ballEsp then
            local bh = ball:FindFirstChild("Ball_ESP") or Instance.new("Highlight", ball)
            bh.Name = "Ball_ESP"; bh.Enabled = true; bh.FillColor = Color3.new(1,1,0)
        end

        -- EĞER MENÜ SİLİNDİYSE GERİ GETİR
        CreateUI()
        
        task.wait(0.1)
    end
end)

-- İlk Kurulum
CreateUI()
game:GetService("StarterGui"):SetCore("SendNotification", {Title = "RoWnn Official", Text = "V4 Yüklendi! Tuş: INSERT", Duration = 5})

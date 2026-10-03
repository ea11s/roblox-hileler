-- [[ THE WALKING DEAD - ULTIMATE HELPER ]]
-- [[ Menü Aç/Kapa: INSERT ]]
-- [[ Aimbot: SAĞ TIK BASILI TUTUNCA ]]
-- [[ Uçma: SPACE BASILI TUTUNCA ]]
-- [[ Click TP: SOL TIK ]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local LP = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ==========================================
-- 🧹 1. TEMİZLİK
-- ==========================================

_G.TWDCoreRun = false

if _G.TWDCore then
    for k, _ in pairs(_G.TWDCore) do
        _G.TWDCore[k] = false
    end
end

for _, obj in pairs(Workspace:GetDescendants()) do
    if obj.Name == "TWD_ESP_OBJ" then
        obj:Destroy()
    end
end

for _, menuName in pairs({"TWDCoreMenu", "FutbolCoreMenu", "TWDCrosshair"}) do
    local oldMenu = CoreGui:FindFirstChild(menuName)
    if oldMenu then
        oldMenu:Destroy()
    end
end

task.wait(0.1)
_G.TWDCoreRun = true

-- ==========================================
-- ⚙️ 2. AYARLAR
-- ==========================================

_G.TWDCore = {
    SprintSpeed = false,
    FullBright = false,
    PlayerESP = false,
    FlyMode = false,
    Aimbot = false,
    ClickTP = false
}

local Smoothness = 0.12
local TargetFOV = 200
local StepMultiplier = 0.10
local FlySpeed = 25

-- FullBright için orijinal ayarları sakla
local OriginalLighting = {
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    Brightness = Lighting.Brightness,
    GlobalShadows = Lighting.GlobalShadows
}

-- ==========================================
-- 🖥️ 3. GUI
-- ==========================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TWDCoreMenu"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 270, 0, 300)
MainFrame.Position = UDim2.new(0.05, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(255, 60, 60)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(25, 20, 20)
Title.BorderSizePixel = 0
Title.Text = "⚡ TWD ULTIMATE HELPER ⚡"
Title.TextColor3 = Color3.fromRGB(255, 60, 60)
Title.Font = Enum.Font.Code
Title.TextSize = 11
Title.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Parent = MainFrame
Layout.Padding = UDim.new(0, 5)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.SortOrder = Enum.SortOrder.LayoutOrder

local Padding = Instance.new("UIPadding")
Padding.PaddingTop = UDim.new(0, 40)
Padding.Parent = MainFrame

-- ==========================================
-- 🔘 BUTON OLUŞTURUCU
-- ==========================================

local function CreateButton(id, text, callback)
    local Btn = Instance.new("TextButton")

    Btn.Size = UDim2.new(0.92, 0, 0, 32)
    Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Btn.BorderSizePixel = 1
    Btn.BorderColor3 = Color3.fromRGB(50, 50, 50)

    Btn.Text = text .. ": KAPALI"
    Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    Btn.Font = Enum.Font.Code
    Btn.TextSize = 11

    Btn.Parent = MainFrame

    Btn.MouseButton1Click:Connect(function()
        _G.TWDCore[id] = not _G.TWDCore[id]

        local state = _G.TWDCore[id]

        Btn.Text = text .. (state and ": AÇIK" or ": KAPALI")

        Btn.TextColor3 =
            state
            and Color3.fromRGB(255, 60, 60)
            or Color3.fromRGB(150, 150, 150)

        Btn.BorderColor3 =
            state
            and Color3.fromRGB(255, 60, 60)
            or Color3.fromRGB(50, 50, 50)

        Btn.BackgroundColor3 =
            state
            and Color3.fromRGB(35, 15, 15)
            or Color3.fromRGB(25, 25, 25)

        if callback then
            callback(state)
        end
    end)

    return Btn
end

-- ==========================================
-- 🛠️ 4. MENÜ
-- ==========================================

CreateButton(
    "Aimbot",
    "SOFT AIMBOT (SAĞ TIK)",
    function(v)
    end
)

CreateButton(
    "SprintSpeed",
    "STABİL HIZ",
    function(v)
    end
)

CreateButton(
    "FlyMode",
    "UÇMA (SPACE BASILI)",
    function(v)
    end
)

CreateButton(
    "PlayerESP",
    "OYUNCU ESP (MAVİ)",
    function(v)

        if not v then
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj.Name == "TWD_ESP_OBJ"
                    and obj:GetAttribute("ESPType") == "Player" then

                    obj:Destroy()
                end
            end
        end
    end
)

CreateButton(
    "FullBright",
    "FULLBRIGHT",
    function(v)

        if v then

            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            Lighting.Brightness = 3
            Lighting.GlobalShadows = false

        else

            Lighting.Ambient = OriginalLighting.Ambient
            Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient
            Lighting.Brightness = OriginalLighting.Brightness
            Lighting.GlobalShadows = OriginalLighting.GlobalShadows

        end
    end
)

CreateButton(
    "ClickTP",
    "CLICK TP (SOL TIK)",
    function(v)
    end
)

-- ==========================================
-- 🎯 5. AIMBOT
-- ==========================================

local function GetClosestTarget()

    local closest = nil
    local shortest = TargetFOV

    local mousePos = UIS:GetMouseLocation()

    for _, obj in pairs(Workspace:GetChildren()) do

        if obj:IsA("Model")
            and obj:FindFirstChild("Head") then

            local hum = obj:FindFirstChildOfClass("Humanoid")

            if hum
                and hum.Health > 0
                and obj ~= LP.Character then

                local pos, onScreen =
                    Camera:WorldToViewportPoint(
                        obj.Head.Position
                    )

                if onScreen then

                    local dist =
                        (
                            Vector2.new(pos.X, pos.Y)
                            - mousePos
                        ).Magnitude

                    if dist < shortest then

                        shortest = dist
                        closest = obj.Head

                    end
                end
            end
        end
    end

    return closest
end

-- ==========================================
-- 🖱️ 6. CLICK TP
-- ==========================================

local function ClickTeleport()

    if not _G.TWDCore.ClickTP then
        return
    end

    local char = LP.Character

    if not char then
        return
    end

    local hrp = char:FindFirstChild("HumanoidRootPart")

    if not hrp then
        return
    end

    local mousePos = UIS:GetMouseLocation()

    local ray =
        Camera:ViewportPointToRay(
            mousePos.X,
            mousePos.Y
        )

    local params = RaycastParams.new()

    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {char}

    local result =
        Workspace:Raycast(
            ray.Origin,
            ray.Direction * 1000,
            params
        )

    if result then

        local targetPosition =
            result.Position + Vector3.new(0, 3, 0)

        hrp.CFrame =
            CFrame.new(
                targetPosition,
                targetPosition + Camera.CFrame.LookVector
            )
    end
end

UIS.InputBegan:Connect(function(input, gpe)

    if gpe then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        ClickTeleport()
    end

end)

-- ==========================================
-- 🔄 7. ANA HAREKET / AIMBOT DÖNGÜSÜ
-- ==========================================

RS.RenderStepped:Connect(function()

    local char = LP.Character

    if not char then
        return
    end

    local hum =
        char:FindFirstChildOfClass("Humanoid")

    local hrp =
        char:FindFirstChild("HumanoidRootPart")

    -- ======================================
    -- STABİL HIZ
    -- ======================================

    if _G.TWDCore.SprintSpeed
        and hum
        and hrp then

        if hum.MoveDirection.Magnitude > 0 then

            hrp.CFrame =
                hrp.CFrame
                + (
                    hum.MoveDirection
                    * StepMultiplier
                )

        end
    end

    -- ======================================
    -- UÇMA
    -- ======================================

    if _G.TWDCore.FlyMode
        and hrp then

        if UIS:IsKeyDown(Enum.KeyCode.Space) then

            hrp.AssemblyLinearVelocity =
                Vector3.new(
                    hrp.AssemblyLinearVelocity.X,
                    FlySpeed,
                    hrp.AssemblyLinearVelocity.Z
                )

        else

            if math.abs(
                hrp.AssemblyLinearVelocity.Y
                - FlySpeed
            ) < 0.1 then

                hrp.AssemblyLinearVelocity =
                    Vector3.new(
                        hrp.AssemblyLinearVelocity.X,
                        0,
                        hrp.AssemblyLinearVelocity.Z
                    )

            end
        end
    end

    -- ======================================
    -- SOFT AIMBOT
    -- ======================================

    if _G.TWDCore.Aimbot
        and UIS:IsMouseButtonPressed(
            Enum.UserInputType.MouseButton2
        ) then

        local target =
            GetClosestTarget()

        if target then

            Camera.CFrame =
                Camera.CFrame:Lerp(
                    CFrame.new(
                        Camera.CFrame.Position,
                        target.Position
                    ),
                    Smoothness
                )

        end
    end

end)

-- ==========================================
-- 🔵 8. PLAYER ESP
-- ==========================================

task.spawn(function()

    while _G.TWDCoreRun do

        task.wait(0.5)

        if _G.TWDCore.PlayerESP then

            for _, player in pairs(
                Players:GetPlayers()
            ) do

                if player ~= LP
                    and player.Character
                    and not player.Character:FindFirstChild(
                        "TWD_ESP_OBJ"
                    ) then

                    local h =
                        Instance.new("Highlight")

                    h.Name = "TWD_ESP_OBJ"

                    h:SetAttribute(
                        "ESPType",
                        "Player"
                    )

                    h.FillColor =
                        Color3.fromRGB(
                            0,
                            150,
                            255
                        )

                    h.FillTransparency = 0.5

                    h.Adornee =
                        player.Character

                    h.Parent =
                        player.Character

                end
            end

        end

    end

end)

-- ==========================================
-- ⌨️ 9. INSERT MENÜ
-- ==========================================

UIS.InputBegan:Connect(function(input, gpe)

    if gpe then
        return
    end

    if input.KeyCode == Enum.KeyCode.Insert then

        MainFrame.Visible =
            not MainFrame.Visible

    end

end)

print(
    "⚡ TWD ULTIMATE HELPER AKTİF!"
)

-- [[ SIERRA V25 - COUNTER BLOX MENU EDITION ]] --
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("SIERRA V25 - COUNTER BLOX", "Ocean")

-- // ANA AYARLAR
local Settings = {
    Aimbot = false,
    ESP = false,
    NoRecoil = false,
    WalkSpeed = 16,
    JumpPower = 50
}

-- // TABS
local Main = Window:NewTab("Ana Özellikler")
local Combat = Main:NewSection("Savaş Ayarları")
local Visuals = Window:NewTab("Görsel")
local VisSection = Visuals:NewSection("Dünya & ESP")
local PlayerTab = Window:NewTab("Oyuncu")
local PlySection = PlayerTab:NewSection("Hareket")

-- // COMBAT (Aimbot & No Recoil)
Combat:NewToggle("Silent Aim", "En yakın düşmana kilitlenir", function(state)
    Settings.Aimbot = state
end)

Combat:NewToggle("No Recoil", "Silah sekmesini sıfırlar", function(state)
    Settings.NoRecoil = state
    if state then
        task.spawn(function()
            while Settings.NoRecoil do
                for _, v in pairs(getgc(true)) do
                    if type(v) == "table" and rawget(v, "Recoil") then
                        v.Recoil = 0
                        v.MaxRecoil = 0
                    end
                end
                task.wait(1)
            end
        end)
    end
end)

-- // VISUALS (ESP)
VisSection:NewToggle("Box ESP", "Düşmanları kutu içine alır", function(state)
    Settings.ESP = state
    -- ESP Mantığı burada devreye girer
end)

-- // PLAYER (Speed & Jump)
PlySection:NewSlider("Yürüme Hızı", "Hızını ayarlar", 100, 16, function(s)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)

PlySection:NewSlider("Zıplama Gücü", "Zıplama yüksekliği", 200, 50, function(s)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = s
end)

PlySection:NewButton("Bhop Aç", "Zıplama tuşuna basılı tutunca zıplar", function()
    game:GetService("RunService").RenderStepped:Connect(function()
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
            game.Players.LocalPlayer.Character.Humanoid.Jump = true
        end
    end)
end)

-- // AIMBOT LOGIC
game:GetService("RunService").RenderStepped:Connect(function()
    if Settings.Aimbot and game:GetService("UserInputService"):IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local Target = nil
        local MaxDist = 200
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= game.Players.LocalPlayer and v.Team ~= game.Players.LocalPlayer.Team and v.Character and v.Character:FindFirstChild("Head") then
                local Pos, OnScreen = game.Workspace.CurrentCamera:WorldToViewportPoint(v.Character.Head.Position)
                local Dist = (Vector2.new(Pos.X, Pos.Y) - Vector2.new(game.Workspace.CurrentCamera.ViewportSize.X / 2, game.Workspace.CurrentCamera.ViewportSize.Y / 2)).Magnitude
                if OnScreen and Dist < MaxDist then
                    MaxDist = Dist
                    Target = v
                end
            end
        end
        if Target then
            game.Workspace.CurrentCamera.CFrame = CFrame.new(game.Workspace.CurrentCamera.CFrame.Position, Target.Character.Head.Position)
        end
    end
end)

Library:CreateConfigSystem("Sierra") -- Ayarları kaydetme sistemi

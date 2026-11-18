
-- CEMOON BOOMBOX CONTROLLER 💜
-- LocalScript

local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "CemoonBoombox"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(260, 170)
frame.Position = UDim2.new(0.5, -130, 0.5, -85)
frame.BackgroundColor3 = Color3.fromRGB(35, 20, 55)
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius =
    UDim.new(0, 14)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "CEMOON BOOMBOX 💜"
title.TextColor3 = Color3.fromRGB(210, 160, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = frame

local input = Instance.new("TextBox")
input.Size = UDim2.new(0.85, 0, 0, 35)
input.Position = UDim2.new(0.075, 0, 0, 55)
input.PlaceholderText = "Masukkan Music ID..."
input.Text = ""
input.Parent = frame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 25)
status.Position = UDim2.fromOffset(0, 95)
status.BackgroundTransparency = 1
status.Text = "CEMOON READY"
status.TextColor3 = Color3.fromRGB(210, 160, 255)
status.Parent = frame

local sound = Instance.new("Sound")
sound.Volume = 0.5
sound.Parent = SoundService

local play = Instance.new("TextButton")
play.Size = UDim2.fromOffset(90, 30)
play.Position = UDim2.fromOffset(25, 130)
play.Text = "PLAY"
play.Parent = frame

local stop = Instance.new("TextButton")
stop.Size = UDim2.fromOffset(90, 30)
stop.Position = UDim2.fromOffset(145, 130)
stop.Text = "STOP"
stop.Parent = frame

play.MouseButton1Click:Connect(function()
    local id = input.Text:match("%d+")
    if not id then
        status.Text = "INVALID MUSIC ID"
        return
    end

    sound:Stop()
    sound.SoundId = "rbxassetid://" .. id
    sound:Play()
    status.Text = "LOCAL AUDIO PLAYING"
end)

stop.MouseButton1Click:Connect(function()
    sound:Stop()
    status.Text = "STOPPED"
end)

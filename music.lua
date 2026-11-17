
-- CEMOON MUSIC PLAYER 💜
-- LocalScript

local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "CemoonMusic"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 170)
frame.Position = UDim2.new(0.5, -130, 0.5, -85)
frame.BackgroundColor3 = Color3.fromRGB(35, 20, 55)
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "CEMOON MUSIC 💜"
title.TextColor3 = Color3.fromRGB(210, 160, 255)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.Parent = frame

local input = Instance.new("TextBox")
input.Size = UDim2.new(0.85, 0, 0, 35)
input.Position = UDim2.new(0.075, 0, 0, 50)
input.PlaceholderText = "Masukkan Music ID..."
input.Text = ""
input.TextSize = 14
input.BackgroundColor3 = Color3.fromRGB(65, 45, 85)
input.TextColor3 = Color3.new(1, 1, 1)
input.Parent = frame

local sound = Instance.new("Sound")
sound.Name = "CemoonMusicSound"
sound.Volume = 0.5
sound.Parent = SoundService

local play = Instance.new("TextButton")
play.Size = UDim2.new(0.38, 0, 0, 35)
play.Position = UDim2.new(0.08, 0, 0, 100)
play.Text = "PLAY"
play.BackgroundColor3 = Color3.fromRGB(120, 65, 180)
play.TextColor3 = Color3.new(1, 1, 1)
play.Parent = frame

local stop = Instance.new("TextButton")
stop.Size = UDim2.new(0.38, 0, 0, 35)
stop.Position = UDim2.new(0.54, 0, 0, 100)
stop.Text = "STOP"
stop.BackgroundColor3 = Color3.fromRGB(85, 45, 110)
stop.TextColor3 = Color3.new(1, 1, 1)
stop.Parent = frame

play.MouseButton1Click:Connect(function()
    local id = input.Text:match("%d+")
    if id then
        sound:Stop()
        sound.SoundId = "rbxassetid://" .. id
        sound:Play()
    end
end)

stop.MouseButton1Click:Connect(function()
    sound:Stop()
end)
-- CEMOON MUSIC PLAYER 💜
-- LocalScript

local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "CemoonMusic"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 170)
frame.Position = UDim2.new(0.5, -130, 0.5, -85)
frame.BackgroundColor3 = Color3.fromRGB(35, 20, 55)
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "CEMOON MUSIC 💜"
title.TextColor3 = Color3.fromRGB(210, 160, 255)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.Parent = frame

local input = Instance.new("TextBox")
input.Size = UDim2.new(0.85, 0, 0, 35)
input.Position = UDim2.new(0.075, 0, 0, 50)
input.PlaceholderText = "Masukkan Music ID..."
input.Text = ""
input.TextSize = 14
input.BackgroundColor3 = Color3.fromRGB(65, 45, 85)
input.TextColor3 = Color3.new(1, 1, 1)
input.Parent = frame

local sound = Instance.new("Sound")
sound.Name = "CemoonMusicSound"
sound.Volume = 0.5
sound.Parent = SoundService

local play = Instance.new("TextButton")
play.Size = UDim2.new(0.38, 0, 0, 35)
play.Position = UDim2.new(0.08, 0, 0, 100)
play.Text = "PLAY"
play.BackgroundColor3 = Color3.fromRGB(120, 65, 180)
play.TextColor3 = Color3.new(1, 1, 1)
play.Parent = frame

local stop = Instance.new("TextButton")
stop.Size = UDim2.new(0.38, 0, 0, 35)
stop.Position = UDim2.new(0.54, 0, 0, 100)
stop.Text = "STOP"
stop.BackgroundColor3 = Color3.fromRGB(85, 45, 110)
stop.TextColor3 = Color3.new(1, 1, 1)
stop.Parent = frame

play.MouseButton1Click:Connect(function()
    local id = input.Text:match("%d+")
    if id then
        sound:Stop()
        sound.SoundId = "rbxassetid://" .. id
        sound:Play()
    end
end)

stop.MouseButton1Click:Connect(function()
    sound:Stop()
end)


--==================================================
-- CEMOON MUSIC 🌙
-- MOON MENU EDITION
--==================================================

local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- CLEAN OLD GUI
local oldGui = playerGui:FindFirstChild("CemoonMusic")
if oldGui then
    oldGui:Destroy()
end

local oldSound = SoundService:FindFirstChild("CemoonMusicSound")
if oldSound then
    oldSound:Destroy()
end

--==================================================
-- SOUND
--==================================================

local sound = Instance.new("Sound")
sound.Name = "CemoonMusicSound"
sound.Volume = 0.5
sound.Parent = SoundService

--==================================================
-- SCREEN GUI
--==================================================

local gui = Instance.new("ScreenGui")
gui.Name = "CemoonMusic"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999
gui.Parent = playerGui

--==================================================
-- HELPER
--==================================================

local function addCorner(object, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = object
    return corner
end

local function addStroke(object, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness
    stroke.Parent = object
    return stroke
end

--==================================================
-- FLOATING MOON BUTTON
--==================================================

local menuButton = Instance.new("TextButton")
menuButton.Name = "MoonMenu"
menuButton.Size = UDim2.new(0, 58, 0, 58)
menuButton.Position = UDim2.new(1, -75, 1, -125)
menuButton.BackgroundColor3 = Color3.fromRGB(75, 35, 120)
menuButton.Text = "☾"
menuButton.TextColor3 = Color3.fromRGB(225, 190, 255)
menuButton.TextSize = 42
menuButton.Font = Enum.Font.GothamBold
menuButton.AutoButtonColor = true
menuButton.ZIndex = 10
menuButton.Parent = gui

addCorner(menuButton, 100)
addStroke(menuButton, Color3.fromRGB(190, 120, 255), 2)

--==================================================
-- MAIN PANEL
--==================================================

local frame = Instance.new("Frame")
frame.Name = "MusicPanel"
frame.Size = UDim2.new(0, 270, 0, 190)
frame.Position = UDim2.new(0.5, -135, 0.5, -95)
frame.BackgroundColor3 = Color3.fromRGB(25, 15, 40)
frame.Visible = false
frame.Parent = gui

addCorner(frame, 14)
addStroke(frame, Color3.fromRGB(155, 90, 220), 2)

--==================================================
-- TITLE
--==================================================

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 42)
title.Position = UDim2.new(0, 10, 0, 5)
title.BackgroundTransparency = 1
title.Text = "CEMOON MUSIC 🌙"
title.TextColor3 = Color3.fromRGB(220, 175, 255)
title.TextSize = 19
title.Font = Enum.Font.GothamBold
title.Parent = frame

--==================================================
-- MUSIC ID INPUT
--==================================================

local musicInput = Instance.new("TextBox")
musicInput.Name = "MusicID"
musicInput.Size = UDim2.new(1, -30, 0, 38)
musicInput.Position = UDim2.new(0, 15, 0, 53)
musicInput.BackgroundColor3 = Color3.fromRGB(55, 40, 70)
musicInput.PlaceholderText = "Masukkan Music ID..."
musicInput.PlaceholderColor3 = Color3.fromRGB(180, 160, 195)
musicInput.Text = ""
musicInput.TextColor3 = Color3.new(1, 1, 1)
musicInput.TextSize = 14
musicInput.Font = Enum.Font.Gotham
musicInput.ClearTextOnFocus = false
musicInput.Parent = frame

addCorner(musicInput, 8)

--==================================================
-- STATUS
--==================================================

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 25)
status.Position = UDim2.new(0, 10, 0, 96)
status.BackgroundTransparency = 1
status.Text = "CEMOON READY 💜"
status.TextColor3 = Color3.fromRGB(200, 165, 235)
status.TextSize = 12
status.Font = Enum.Font.Gotham
status.Parent = frame

--==================================================
-- PLAY BUTTON
--==================================================

local playButton = Instance.new("TextButton")
playButton.Name = "Play"
playButton.Size = UDim2.new(0, 110, 0, 38)
playButton.Position = UDim2.new(0, 15, 0, 137)
playButton.BackgroundColor3 = Color3.fromRGB(115, 60, 175)
playButton.Text = "▶ PLAY"
playButton.TextColor3 = Color3.new(1, 1, 1)
playButton.TextSize = 14
playButton.Font = Enum.Font.GothamBold
playButton.Parent = frame

addCorner(playButton, 8)

--==================================================
-- STOP BUTTON
--==================================================

local stopButton = Instance.new("TextButton")
stopButton.Name = "Stop"
stopButton.Size = UDim2.new(0, 110, 0, 38)
stopButton.Position = UDim2.new(1, -125, 0, 137)
stopButton.BackgroundColor3 = Color3.fromRGB(85, 45, 110)
stopButton.Text = "■ STOP"
stopButton.TextColor3 = Color3.new(1, 1, 1)
stopButton.TextSize = 14
stopButton.Font = Enum.Font.GothamBold
stopButton.Parent = frame

addCorner(stopButton, 8)

--==================================================
-- MOON MENU TOGGLE
--==================================================

menuButton.Activated:Connect(function()
    frame.Visible = not frame.Visible
end)

--==================================================
-- PLAY MUSIC
--==================================================

playButton.Activated:Connect(function()
    local id = musicInput.Text:match("%d+")

    if not id then
        status.Text = "Music ID tidak valid!"
        return
    end

    sound:Stop()
    sound.SoundId = "rbxassetid://" .. id
    sound:Play()

    status.Text = "Memutar musik... 💜"
end)

--==================================================
-- STOP MUSIC
--==================================================

stopButton.Activated:Connect(function()
    sound:Stop()
    status.Text = "Musik dihentikan."
end)

--==================================================
-- PLAYBACK STATUS
--==================================================

sound.Ended:Connect(function()
    status.Text = "Musik selesai."
end)

sound:GetPropertyChangedSignal("IsPlaying"):Connect(function()
    if sound.IsPlaying then
        status.Text = "Musik sedang diputar 💜"
    end
end)

print("CEMOON MUSIC LOADED 🌙")

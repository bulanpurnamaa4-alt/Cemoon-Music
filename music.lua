
--// CEMOON MUSIC 🌙
--// Floating Crescent Menu

local SoundService = game:GetService("SoundService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local oldGui = playerGui:FindFirstChild("CemoonMusic")
if oldGui then
    oldGui:Destroy()
end

local sound = Instance.new("Sound")
sound.Name = "CemoonMusicSound"
sound.Volume = 0.5
sound.Parent = SoundService

local gui = Instance.new("ScreenGui")
gui.Name = "CemoonMusic"
gui.ResetOnSpawn = false
gui.Parent = playerGui

--// Floating Moon Button
local menuButton = Instance.new("TextButton")
menuButton.Name = "MoonButton"
menuButton.Size = UDim2.new(0, 58, 0, 58)
menuButton.Position = UDim2.new(1, -75, 1, -120)
menuButton.BackgroundColor3 = Color3.fromRGB(90, 35, 150)
menuButton.Text = "🌙"
menuButton.TextSize = 30
menuButton.TextColor3 = Color3.new(1, 1, 1)
menuButton.Parent = gui

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(1, 0)
buttonCorner.Parent = menuButton

local buttonStroke = Instance.new("UIStroke")
buttonStroke.Color = Color3.fromRGB(190, 120, 255)
buttonStroke.Thickness = 2
buttonStroke.Parent = menuButton

--// Music Panel
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 270, 0, 180)
frame.Position = UDim2.new(0.5, -135, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(25, 15, 40)
frame.Visible = false
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(150, 80, 220)
stroke.Thickness = 2
stroke.Parent = frame

--// Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -45, 0, 40)
title.Position = UDim2.new(0, 12, 0, 5)
title.BackgroundTransparency = 1
title.Text = "CEMOON MUSIC 🌙"
title.TextColor3 = Color3.fromRGB(210, 160, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = frame

--// Music ID
local idBox = Instance.new("TextBox")
idBox.Size = UDim2.new(1, -30, 0, 38)
idBox.Position = UDim2.new(0, 15, 0, 55)
idBox.BackgroundColor3 = Color3.fromRGB(50, 35, 65)
idBox.PlaceholderText = "Masukkan Music ID..."
idBox.Text = ""
idBox.TextColor3 = Color3.new(1, 1, 1)
idBox.PlaceholderColor3 = Color3.fromRGB(170, 150, 190)
idBox.TextSize = 14
idBox.Font = Enum.Font.Gotham
idBox.ClearTextOnFocus = false
idBox.Parent = frame

Instance.new("UICorner", idBox).CornerRadius = UDim.new(0, 8)

--// Status
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 22)
status.Position = UDim2.new(0, 10, 0, 98)
status.BackgroundTransparency = 1
status.Text = "Cemoon Music Ready 💜"
status.TextColor3 = Color3.fromRGB(190, 160, 220)
status.TextSize = 12
status.Font = Enum.Font.Gotham
status.Parent = frame

--// Play Button
local play = Instance.new("TextButton")
play.Size = UDim2.new(0, 110, 0, 35)
play.Position = UDim2.new(0, 15, 0, 130)
play.BackgroundColor3 = Color3.fromRGB(115, 55, 180)
play.Text = "▶ PLAY"
play.TextColor3 = Color3.new(1, 1, 1)
play.TextSize = 14
play.Font = Enum.Font.GothamBold
play.Parent = frame

Instance.new("UICorner", play).CornerRadius = UDim.new(0, 8)

--// Stop Button
local stop = Instance.new("TextButton")
stop.Size = UDim2.new(0, 110, 0, 35)
stop.Position = UDim2.new(1, -125, 0, 130)
stop.BackgroundColor3 = Color3.fromRGB(85, 45, 110)
stop.Text = "■ STOP"
stop.TextColor3 = Color3.new(1, 1, 1)
stop.TextSize = 14
stop.Font = Enum.Font.GothamBold
stop.Parent = frame

Instance.new("UICorner", stop).CornerRadius = UDim.new(0, 8)

--// Menu Toggle
menuButton.Activated:Connect(function()
    frame.Visible = not frame.Visible
end)

--// Play Music
play.Activated:Connect(function()
    local id = idBox.Text:match("%d+")

    if not id then
        status.Text = "Masukkan Music ID dulu!"
        return
    end

    sound:Stop()
    sound.SoundId = "rbxassetid://" .. id
    sound:Play()

    status.Text = "Memutar musik 💜"
end)

--// Stop Music
stop.Activated:Connect(function()
    sound:Stop()
    status.Text = "Musik dihentikan"
end)

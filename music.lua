
-- CEMOON MUSIC PLAYER 💜
-- LocalScript

local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "CemoonMusic"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- MAIN FRAME
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.fromOffset(260, 180)
frame.Position = UDim2.new(0.5, -130, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(35, 20, 55)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = frame

-- TITLE / DRAG BAR
local title = Instance.new("TextButton")
title.Name = "DragBar"
title.Size = UDim2.new(1, 0, 0, 42)
title.BackgroundTransparency = 1
title.Text = "CEMOON MUSIC 💜"
title.TextColor3 = Color3.fromRGB(210, 160, 255)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.Active = true
title.Parent = frame

-- DRAG SYSTEM: MOBILE + PC
local dragging = false
local dragInput
local dragStart
local startPos

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then

        dragging = true
        dragStart = input.Position
        startPos = frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart

        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- MUSIC ID INPUT
local musicInput = Instance.new("TextBox")
musicInput.Name = "MusicID"
musicInput.Size = UDim2.new(0.85, 0, 0, 35)
musicInput.Position = UDim2.new(0.075, 0, 0, 52)
musicInput.PlaceholderText = "Masukkan Music ID..."
musicInput.Text = ""
musicInput.TextSize = 15
musicInput.Font = Enum.Font.Gotham
musicInput.BackgroundColor3 = Color3.fromRGB(65, 45, 85)
musicInput.TextColor3 = Color3.new(1, 1, 1)
musicInput.PlaceholderColor3 = Color3.fromRGB(190, 175, 205)
musicInput.ClearTextOnFocus = false
musicInput.Parent = frame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 7)
inputCorner.Parent = musicInput

-- STATUS
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 22)
status.Position = UDim2.new(0, 0, 0, 91)
status.BackgroundTransparency = 1
status.Text = "CEMOON READY 💜"
status.TextColor3 = Color3.fromRGB(210, 160, 255)
status.TextSize = 12
status.Font = Enum.Font.Gotham
status.Parent = frame

-- SOUND
local sound = Instance.new("Sound")
sound.Name = "CemoonMusicSound"
sound.Volume = 0.5
sound.Parent = SoundService

-- PLAY BUTTON
local play = Instance.new("TextButton")
play.Size = UDim2.new(0.38, 0, 0, 35)
play.Position = UDim2.new(0.08, 0, 0, 125)
play.Text = "Mainkan"
play.TextSize = 14
play.Font = Enum.Font.GothamBold
play.BackgroundColor3 = Color3.fromRGB(120, 65, 180)
play.TextColor3 = Color3.new(1, 1, 1)
play.Parent = frame

local playCorner = Instance.new("UICorner")
playCorner.CornerRadius = UDim.new(0, 7)
playCorner.Parent = play

-- STOP BUTTON
local stop = Instance.new("TextButton")
stop.Size = UDim2.new(0.38, 0, 0, 35)
stop.Position = UDim2.new(0.54, 0, 0, 125)
stop.Text = "Berhenti"
stop.TextSize = 14
stop.Font = Enum.Font.GothamBold
stop.BackgroundColor3 = Color3.fromRGB(85, 45, 110)
stop.TextColor3 = Color3.new(1, 1, 1)
stop.Parent = frame

local stopCorner = Instance.new("UICorner")
stopCorner.CornerRadius = UDim.new(0, 7)
stopCorner.Parent = stop

-- PLAY FUNCTION
play.Activated:Connect(function()
    local id = musicInput.Text:match("^%s*(%d+)%s*$")

    if not id then
        status.Text = "Music ID tidak valid!"
        return
    end

    sound:Stop()
    sound.SoundId = "rbxassetid://" .. id
    sound:Play()

    status.Text = "Memutar musik..."
end)

-- STOP FUNCTION
stop.Activated:Connect(function()
    sound:Stop()
    status.Text = "Musik dihentikan."
end)

-- PLAYBACK STATUS
sound.Ended:Connect(function()
    status.Text = "Musik selesai."
end)

sound:GetPropertyChangedSignal("IsPlaying"):Connect(function()
    if sound.IsPlaying then
        status.Text = "Musik sedang diputar 💜"
    end
end)

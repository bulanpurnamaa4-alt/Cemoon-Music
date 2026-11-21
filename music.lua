
--==================================================
-- CEMOON MUSIC 🌙
-- FULL PANEL DRAG FIX EDITION
--==================================================

local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")

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

-- SOUND
local sound = Instance.new("Sound")
sound.Name = "CemoonMusicSound"
sound.Volume = 0.5
sound.Parent = SoundService

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "CemoonMusic"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999
gui.Parent = playerGui

-- HELPERS
local function corner(object, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = object
end

local function stroke(object, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness
    s.Parent = object
end

--==================================================
-- DRAG SYSTEM: TOUCH + MOUSE
--==================================================

local function makeDraggable(handle, target, onClick)
    handle.Active = true

    local dragging = false
    local moved = false
    local dragInput
    local startInput
    local startPosition

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            moved = false
            startInput = input.Position
            startPosition = target.Position

            if input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end

        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input == dragInput then

            local delta = input.Position - startInput

            if math.abs(delta.X) > 6 or math.abs(delta.Y) > 6 then
                moved = true
            end

            if moved then
                target.Position = UDim2.new(
                    startPosition.X.Scale,
                    startPosition.X.Offset + delta.X,
                    startPosition.Y.Scale,
                    startPosition.Y.Offset + delta.Y
                )
            end
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if not dragging then return end

        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input == dragInput then

            dragging = false

            if not moved and onClick then
                onClick()
            end

            dragInput = nil
        end
    end)
end

--==================================================
-- MOON BUTTON
--==================================================

local menuButton = Instance.new("TextButton")
menuButton.Name = "MoonMenu"
menuButton.Size = UDim2.fromOffset(58, 58)
menuButton.Position = UDim2.new(1, -75, 1, -125)
menuButton.BackgroundColor3 = Color3.fromRGB(75, 35, 120)
menuButton.Text = "☾"
menuButton.TextColor3 = Color3.fromRGB(225, 190, 255)
menuButton.TextSize = 42
menuButton.Font = Enum.Font.GothamBold
menuButton.Parent = gui

corner(menuButton, 100)
stroke(menuButton, Color3.fromRGB(190, 120, 255), 2)

--==================================================
-- MUSIC PANEL
--==================================================

local frame = Instance.new("Frame")
frame.Name = "MusicPanel"
frame.Size = UDim2.fromOffset(420, 315)
frame.Position = UDim2.new(0.5, -210, 0.5, -157)
frame.BackgroundColor3 = Color3.fromRGB(25, 15, 40)
frame.Visible = false
frame.Parent = gui

corner(frame, 18)
stroke(frame, Color3.fromRGB(155, 90, 220), 2)

-- TITLE / DRAG HANDLE
local title = Instance.new("TextLabel")
title.Name = "DragTitle"
title.Size = UDim2.new(1, -20, 0, 55)
title.Position = UDim2.fromOffset(10, 8)
title.BackgroundTransparency = 1
title.Text = "CEMOON MUSIC 🌙"
title.TextColor3 = Color3.fromRGB(220, 175, 255)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.Active = true
title.Parent = frame

-- MUSIC ID
local musicInput = Instance.new("TextBox")
musicInput.Name = "MusicID"
musicInput.Size = UDim2.new(1, -40, 0, 62)
musicInput.Position = UDim2.fromOffset(20, 85)
musicInput.BackgroundColor3 = Color3.fromRGB(55, 40, 70)
musicInput.PlaceholderText = "Masukkan Music ID..."
musicInput.PlaceholderColor3 = Color3.fromRGB(180, 160, 195)
musicInput.Text = ""
musicInput.TextColor3 = Color3.new(1, 1, 1)
musicInput.TextSize = 18
musicInput.Font = Enum.Font.Gotham
musicInput.ClearTextOnFocus = false
musicInput.Parent = frame

corner(musicInput, 12)

-- STATUS
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 35)
status.Position = UDim2.fromOffset(10, 158)
status.BackgroundTransparency = 1
status.Text = "CEMOON READY 💜"
status.TextColor3 = Color3.fromRGB(200, 165, 235)
status.TextSize = 16
status.Font = Enum.Font.Gotham
status.Parent = frame

-- PLAY BUTTON
local playButton = Instance.new("TextButton")
playButton.Name = "Play"
playButton.Size = UDim2.new(0.44, 0, 0, 62)
playButton.Position = UDim2.fromOffset(20, 225)
playButton.BackgroundColor3 = Color3.fromRGB(115, 60, 175)
playButton.Text = "▶ PLAY"
playButton.TextColor3 = Color3.new(1, 1, 1)
playButton.TextSize = 18
playButton.Font = Enum.Font.GothamBold
playButton.Parent = frame

corner(playButton, 12)

-- STOP BUTTON
local stopButton = Instance.new("TextButton")
stopButton.Name = "Stop"
stopButton.Size = UDim2.new(0.44, 0, 0, 62)
stopButton.Position = UDim2.new(0.56, -0, 0, 225)
stopButton.BackgroundColor3 = Color3.fromRGB(85, 45, 110)
stopButton.Text = "■ STOP"
stopButton.TextColor3 = Color3.new(1, 1, 1)
stopButton.TextSize = 18
stopButton.Font = Enum.Font.GothamBold
stopButton.Parent = frame

corner(stopButton, 12)

--==================================================
-- DRAG CONTROLS
--==================================================

-- Moon button: drag button, tap to toggle panel
makeDraggable(menuButton, menuButton, function()
    frame.Visible = not frame.Visible
end)

-- IMPORTANT: drag TITLE, move ENTIRE FRAME
makeDraggable(title, frame)

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

sound.Ended:Connect(function()
    status.Text = "Musik selesai."
end)

print("CEMOON MUSIC FULL PANEL DRAG LOADED 🌙")

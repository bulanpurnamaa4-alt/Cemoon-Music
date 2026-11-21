
--==================================================
-- CEMOON MUSIC 🌙
-- SAVE ID EDITION
--==================================================

local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- CLEAN OLD GUI
local oldGui = playerGui:FindFirstChild("CemoonMusic")
if oldGui then oldGui:Destroy() end

local oldSound = SoundService:FindFirstChild("CemoonMusicSound")
if oldSound then oldSound:Destroy() end

-- SOUND
local sound = Instance.new("Sound")
sound.Name = "CemoonMusicSound"
sound.Volume = 0.5
sound.Parent = SoundService

-- SAVED IDS
local savedIDs = {}

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "CemoonMusic"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999
gui.Parent = playerGui

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

local function makeButton(parent, name, text, size, position, color)
    local b = Instance.new("TextButton")
    b.Name = name
    b.Size = size
    b.Position = position
    b.BackgroundColor3 = color
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 15
    b.Font = Enum.Font.GothamBold
    b.Parent = parent
    corner(b, 10)
    return b
end

--==================================================
-- DRAG SYSTEM
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
menuButton.Size = UDim2.fromOffset(52, 52)
menuButton.Position = UDim2.new(1, -68, 1, -115)
menuButton.BackgroundColor3 = Color3.fromRGB(75, 35, 120)
menuButton.Text = "☾"
menuButton.TextColor3 = Color3.fromRGB(225, 190, 255)
menuButton.TextSize = 38
menuButton.Font = Enum.Font.GothamBold
menuButton.Parent = gui

corner(menuButton, 100)
stroke(menuButton, Color3.fromRGB(190, 120, 255), 2)

--==================================================
-- MUSIC PANEL
--==================================================

local frame = Instance.new("Frame")
frame.Name = "MusicPanel"
frame.Size = UDim2.fromOffset(330, 330)
frame.Position = UDim2.new(0.5, -165, 0.5, -165)
frame.BackgroundColor3 = Color3.fromRGB(25, 15, 40)
frame.Visible = false
frame.Parent = gui

corner(frame, 18)
stroke(frame, Color3.fromRGB(155, 90, 220), 2)

-- TITLE
local title = Instance.new("TextLabel")
title.Name = "DragTitle"
title.Size = UDim2.new(1, -20, 0, 45)
title.Position = UDim2.fromOffset(10, 5)
title.BackgroundTransparency = 1
title.Text = "CEMOON MUSIC 🌙"
title.TextColor3 = Color3.fromRGB(220, 175, 255)
title.TextSize = 19
title.Font = Enum.Font.GothamBold
title.Active = true
title.Parent = frame

-- MUSIC INPUT
local musicInput = Instance.new("TextBox")
musicInput.Name = "MusicID"
musicInput.Size = UDim2.new(1, -30, 0, 43)
musicInput.Position = UDim2.fromOffset(15, 53)
musicInput.BackgroundColor3 = Color3.fromRGB(55, 40, 70)
musicInput.PlaceholderText = "Masukkan Music ID..."
musicInput.PlaceholderColor3 = Color3.fromRGB(180, 160, 195)
musicInput.Text = ""
musicInput.TextColor3 = Color3.new(1, 1, 1)
musicInput.TextSize = 15
musicInput.Font = Enum.Font.Gotham
musicInput.ClearTextOnFocus = false
musicInput.Parent = frame
corner(musicInput, 10)

-- SAVE BUTTON
local saveButton = makeButton(
    frame,
    "SaveID",
    "＋ SAVE ID",
    UDim2.new(1, -30, 0, 38),
    UDim2.fromOffset(15, 103),
    Color3.fromRGB(105, 55, 155)
)

-- SAVED LIST LABEL
local listLabel = Instance.new("TextLabel")
listLabel.Size = UDim2.new(1, -30, 0, 23)
listLabel.Position = UDim2.fromOffset(15, 147)
listLabel.BackgroundTransparency = 1
listLabel.Text = "SAVED MUSIC IDs"
listLabel.TextColor3 = Color3.fromRGB(210, 175, 245)
listLabel.TextSize = 13
listLabel.Font = Enum.Font.GothamBold
listLabel.TextXAlignment = Enum.TextXAlignment.Left
listLabel.Parent = frame

-- SAVED LIST
local savedList = Instance.new("ScrollingFrame")
savedList.Name = "SavedList"
savedList.Size = UDim2.new(1, -30, 0, 78)
savedList.Position = UDim2.fromOffset(15, 171)
savedList.BackgroundColor3 = Color3.fromRGB(42, 29, 55)
savedList.BorderSizePixel = 0
savedList.ScrollBarThickness = 4
savedList.CanvasSize = UDim2.new(0, 0, 0, 0)
savedList.Parent = frame
corner(savedList, 9)

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 5)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = savedList

local listPadding = Instance.new("UIPadding")
listPadding.PaddingTop = UDim.new(0, 5)
listPadding.PaddingLeft = UDim.new(0, 5)
listPadding.PaddingRight = UDim.new(0, 5)
listPadding.Parent = savedList

-- STATUS
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -30, 0, 25)
status.Position = UDim2.fromOffset(15, 253)
status.BackgroundTransparency = 1
status.Text = "CEMOON READY 💜"
status.TextColor3 = Color3.fromRGB(200, 165, 235)
status.TextSize = 12
status.Font = Enum.Font.Gotham
status.Parent = frame

-- PLAY / STOP
local playButton = makeButton(
    frame, "Play", "▶ PLAY",
    UDim2.new(0.44, 0, 0, 38),
    UDim2.fromOffset(15, 284),
    Color3.fromRGB(115, 60, 175)
)

local stopButton = makeButton(
    frame, "Stop", "■ STOP",
    UDim2.new(0.44, 0, 0, 38),
    UDim2.new(0.56, 0, 0, 284),
    Color3.fromRGB(85, 45, 110)
)

--==================================================
-- REFRESH SAVED LIST
--==================================================

local function refreshSavedList()
    for _, child in ipairs(savedList:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end

    for index, id in ipairs(savedIDs) do
        local item = Instance.new("Frame")
        item.Size = UDim2.new(1, -4, 0, 30)
        item.BackgroundColor3 = Color3.fromRGB(75, 52, 95)
        item.LayoutOrder = index
        item.Parent = savedList
        corner(item, 7)

        local selectButton = Instance.new("TextButton")
        selectButton.Size = UDim2.new(1, -38, 1, 0)
        selectButton.BackgroundTransparency = 1
        selectButton.Text = "♪  " .. id
        selectButton.TextColor3 = Color3.new(1, 1, 1)
        selectButton.TextSize = 12
        selectButton.Font = Enum.Font.Gotham
        selectButton.Parent = item

        selectButton.Activated:Connect(function()
            musicInput.Text = id
            status.Text = "ID dipilih 💜"
        end)

        local deleteButton = Instance.new("TextButton")
        deleteButton.Size = UDim2.fromOffset(34, 30)
        deleteButton.Position = UDim2.new(1, -34, 0, 0)
        deleteButton.BackgroundTransparency = 1
        deleteButton.Text = "×"
        deleteButton.TextColor3 = Color3.fromRGB(255, 140, 170)
        deleteButton.TextSize = 19
        deleteButton.Font = Enum.Font.GothamBold
        deleteButton.Parent = item

        deleteButton.Activated:Connect(function()
            table.remove(savedIDs, index)
            refreshSavedList()
            status.Text = "ID dihapus."
        end)
    end

    savedList.CanvasSize = UDim2.new(
        0, 0, 0,
        listLayout.AbsoluteContentSize.Y + 10
    )
end

--==================================================
-- SAVE ID
--==================================================

saveButton.Activated:Connect(function()
    local id = musicInput.Text:match("%d+")

    if not id then
        status.Text = "Masukkan ID yang valid!"
        return
    end

    if table.find(savedIDs, id) then
        status.Text = "ID sudah tersimpan!"
        return
    end

    table.insert(savedIDs, id)
    refreshSavedList()
    status.Text = "ID berhasil disimpan 💜"
end)

--==================================================
-- DRAG CONTROLS
--==================================================

makeDraggable(menuButton, menuButton, function()
    frame.Visible = not frame.Visible
end)

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

print("CEMOON MUSIC SAVE ID EDITION LOADED 🌙")

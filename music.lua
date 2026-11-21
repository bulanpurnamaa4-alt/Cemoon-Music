
--[[
    CEMOON MUSIC v2.0
    LUNAR EDITION 🌙
    Mobile + PC
]]

local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- CLEANUP
local old = playerGui:FindFirstChild("CemoonMusic")
if old then old:Destroy() end

-- CONFIG
local FILE = "CemoonMusic_SavedIDs.json"
local PURPLE = Color3.fromRGB(145, 85, 210)
local DARK = Color3.fromRGB(17, 16, 21)
local PANEL = Color3.fromRGB(27, 25, 32)
local WHITE = Color3.fromRGB(240, 237, 245)

local savedIDs = {}
local rgbEnabled = false
local minimized = false

-- STORAGE
local function loadIDs()
    if type(readfile) == "function" then
        local ok, data = pcall(function()
            return readfile(FILE)
        end)
        if ok then
            local success, decoded = pcall(function()
                return game:GetService("HttpService"):JSONDecode(data)
            end)
            if success and type(decoded) == "table" then
                savedIDs = decoded
            end
        end
    end
end

local function saveIDs()
    if type(writefile) == "function" then
        pcall(function()
            writefile(FILE,
                game:GetService("HttpService"):JSONEncode(savedIDs))
        end)
    end
end

loadIDs()

-- SOUND
local sound = Instance.new("Sound")
sound.Name = "CemoonMusicSound"
sound.Volume = 0.5
sound.Parent = SoundService

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "CemoonMusic"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(370, 330)
main.Position = UDim2.new(0.5, -185, 0.5, -165)
main.BackgroundColor3 = DARK
main.BorderSizePixel = 0
main.Active = true
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 17)
corner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(70, 55, 85)
stroke.Thickness = 1
stroke.Parent = main

-- HELPER
local function make(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local function button(parent, text, size, pos, color)
    local b = make("TextButton", {
        Size = size,
        Position = pos,
        BackgroundColor3 = color or PANEL,
        Text = text,
        TextColor3 = WHITE,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        AutoButtonColor = true,
        BorderSizePixel = 0
    }, parent)

    make("UICorner", {
        CornerRadius = UDim.new(0, 9)
    }, b)

    return b
end

-- HEADER
local header = make("Frame", {
    Size = UDim2.new(1, 0, 0, 53),
    BackgroundTransparency = 1
}, main)

local title = make("TextLabel", {
    Position = UDim2.fromOffset(16, 5),
    Size = UDim2.new(1, -115, 0, 25),
    BackgroundTransparency = 1,
    Text = "🌙 CEMOON MUSIC",
    TextColor3 = WHITE,
    TextSize = 17,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
}, header)

local subtitle = make("TextLabel", {
    Position = UDim2.fromOffset(17, 29),
    Size = UDim2.new(1, -120, 0, 15),
    BackgroundTransparency = 1,
    Text = "Lunar Edition • v2.0",
    TextColor3 = Color3.fromRGB(145, 135, 155),
    TextSize = 10,
    Font = Enum.Font.Gotham
}, header)

local rgb = button(header, "RGB", UDim2.fromOffset(48, 28),
    UDim2.new(1, -100, 0, 12), PURPLE)

local minimize = button(header, "—", UDim2.fromOffset(30, 28),
    UDim2.new(1, -43, 0, 12), PANEL)

-- DRAG SYSTEM
local dragging = false
local dragStart
local startPos

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseMovement
    ) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- NAVIGATION
local nav = make("Frame", {
    Position = UDim2.fromOffset(12, 57),
    Size = UDim2.new(1, -24, 0, 34),
    BackgroundTransparency = 1
}, main)

local navNames = {"ID Musik", "Database", "Daftar Musik", "Kredit"}
local pages = {}
local tabs = {}

local content = make("Frame", {
    Position = UDim2.fromOffset(12, 100),
    Size = UDim2.new(1, -24, 1, -112),
    BackgroundTransparency = 1,
    ClipsDescendants = true
}, main)

for i, name in ipairs(navNames) do
    local tab = button(nav, name,
        UDim2.new(0.25, -4, 1, 0),
        UDim2.new((i-1)*0.25, (i-1)*4, 0, 0),
        PANEL)
    tab.TextSize = 10
    tabs[i] = tab

    local page = make("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Visible = i == 1
    }, content)
    pages[i] = page
end

local function switchPage(index)
    for i, page in ipairs(pages) do
        page.Visible = i == index
        tabs[i].BackgroundColor3 =
            i == index and PURPLE or PANEL
    end
end

for i, tab in ipairs(tabs) do
    tab.Activated:Connect(function()
        switchPage(i)
    end)
end

-- PAGE 1: ID MUSIK
local p1 = pages[1]

local input = make("TextBox", {
    Position = UDim2.fromOffset(5, 12),
    Size = UDim2.new(1, -10, 0, 40),
    BackgroundColor3 = PANEL,
    PlaceholderText = "Masukkan Music ID...",
    PlaceholderColor3 = Color3.fromRGB(140, 135, 150),
    Text = "",
    TextColor3 = WHITE,
    Font = Enum.Font.Gotham,
    TextSize = 13,
    ClearTextOnFocus = false,
    BorderSizePixel = 0
}, p1)

make("UICorner", {
    CornerRadius = UDim.new(0, 9)
}, input)

local status = make("TextLabel", {
    Position = UDim2.fromOffset(5, 57),
    Size = UDim2.new(1, -10, 0, 22),
    BackgroundTransparency = 1,
    Text = "● CEMOON READY",
    TextColor3 = Color3.fromRGB(190, 150, 230),
    TextSize = 11,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left
}, p1)

local play = button(p1, "▶ PLAY",
    UDim2.new(0.48, -3, 0, 38),
    UDim2.fromOffset(5, 87), PURPLE)

local stop = button(p1, "■ STOP",
    UDim2.new(0.48, -3, 0, 38),
    UDim2.new(0.52, 0, 0, 87), PANEL)

local save = button(p1, "＋ SAVE ID",
    UDim2.new(1, -10, 0, 35),
    UDim2.fromOffset(5, 135), PANEL)

local function getID()
    return input.Text:match("^%s*(%d+)%s*$")
end

play.Activated:Connect(function()
    local id = getID()
    if not id then
        status.Text = "ID MUSIK TIDAK VALID!"
        return
    end

    sound:Stop()
    sound.SoundId = "rbxassetid://" .. id
    sound:Play()
    status.Text = "● MEMUTAR MUSIK..."
end)

stop.Activated:Connect(function()
    sound:Stop()
    status.Text = "● MUSIK DIHENTIKAN"
end)

save.Activated:Connect(function()
    local id = getID()
    if not id then
        status.Text = "MASUKKAN ID TERLEBIH DAHULU"
        return
    end

    for _, existing in ipairs(savedIDs) do
        if tostring(existing) == id then
            status.Text = "ID SUDAH TERSIMPAN"
            return
        end
    end

    table.insert(savedIDs, id)
    saveIDs()
    status.Text = "● ID BERHASIL DISIMPAN"
end)

-- SAVED ID LIST
local function createSavedPage(page, heading)
    make("TextLabel", {
        Size = UDim2.new(1, 0, 0, 25),
        BackgroundTransparency = 1,
        Text = heading,
        TextColor3 = WHITE,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    }, page)

    local scroll = make("ScrollingFrame", {
        Position = UDim2.fromOffset(0, 30),
        Size = UDim2.new(1, 0, 1, -30),
        BackgroundColor3 = PANEL,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        CanvasSize = UDim2.fromOffset(0, 0)
    }, page)

    make("UICorner", {
        CornerRadius = UDim.new(0, 9)
    }, scroll)

    local layout = make("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, scroll)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.fromOffset(
            0, layout.AbsoluteContentSize.Y + 10
        )
    end)

    return scroll
end

-- PAGE 2: DATABASE
local database = createSavedPage(pages[2], "DATABASE MUSIK")

-- PAGE 3: DAFTAR MUSIK
local playlist = createSavedPage(pages[3], "DAFTAR ID TERSIMPAN")

local function refreshLists()
    for _, page in ipairs({database, playlist}) do
        for _, child in ipairs(page:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end
    end

    for index, id in ipairs(savedIDs) do
        for _, page in ipairs({database, playlist}) do
            local item = make("Frame", {
                Size = UDim2.new(1, -10, 0, 38),
                BackgroundColor3 = Color3.fromRGB(40, 36, 47),
                BorderSizePixel = 0,
                LayoutOrder = index
            }, page)

            make("UICorner", {
                CornerRadius = UDim.new(0, 7)
            }, item)

            make("TextLabel", {
                Position = UDim2.fromOffset(8, 0),
                Size = UDim2.new(1, -90, 1, 0),
                BackgroundTransparency = 1,
                Text = "♫  " .. tostring(id),
                TextColor3 = WHITE,
                Font = Enum.Font.Gotham,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left
            }, item)

            local use = button(item, "PLAY",
                UDim2.fromOffset(38, 27),
                UDim2.new(1, -82, 0, 5), PURPLE)

            use.Activated:Connect(function()
                input.Text = tostring(id)
                sound:Stop()
                sound.SoundId = "rbxassetid://" .. tostring(id)
                sound:Play()
                status.Text = "● MEMUTAR ID TERSIMPAN"
                switchPage(1)
            end)

            local delete = button(item, "×",
                UDim2.fromOffset(32, 27),
                UDim2.new(1, -39, 0, 5),
                Color3.fromRGB(100, 45, 65))

            delete.Activated:Connect(function()
                for i, saved in ipairs(savedIDs) do
                    if tostring(saved) == tostring(id) then
                        table.remove(savedIDs, i)
                        break
                    end
                end
                saveIDs()
                refreshLists()
            end)
        end
    end
end

refreshLists()

local oldSaveFunction = save.Activated
save.Activated:Connect(refreshLists)

-- PAGE 4: KREDIT
local credits = pages[4]

make("TextLabel", {
    Position = UDim2.fromOffset(5, 15),
    Size = UDim2.new(1, -10, 0, 35),
    BackgroundTransparency = 1,
    Text = "CEMOON MUSIC 🌙",
    TextColor3 = WHITE,
    TextSize = 18,
    Font = Enum.Font.GothamBold
}, credits)

make("TextLabel", {
    Position = UDim2.fromOffset(5, 53),
    Size = UDim2.new(1, -10, 0, 100),
    BackgroundTransparency = 1,
    Text = "LUNAR EDITION • VERSION 2.0\n\nDesigned for mobile & PC\nMusic Player • Database • Save ID\n\nMade with 💜 by Cemoon",
    TextColor3 = Color3.fromRGB(170, 160, 185),
    TextSize = 12,
    Font = Enum.Font.Gotham,
    TextWrapped = true
}, credits)

-- MINIMIZE
minimize.Activated:Connect(function()
    minimized = not minimized
    content.Visible = not minimized
    nav.Visible = not minimized
    main.Size = minimized
        and UDim2.fromOffset(220, 53)
        or UDim2.fromOffset(370, 330)
    minimize.Text = minimized and "+" or "—"
end)

-- RGB EFFECT
rgb.Activated:Connect(function()
    rgbEnabled = not rgbEnabled
    rgb.Text = rgbEnabled and "RGB ON" or "RGB"
end)

task.spawn(function()
    local hue = 0
    while gui.Parent do
        task.wait(0.04)
        if rgbEnabled then
            hue = (hue + 0.004) % 1
            local color = Color3.fromHSV(hue, 0.65, 0.95)
            stroke.Color = color
            rgb.BackgroundColor3 = color
            for _, tab in ipairs(tabs) do
                if tab.BackgroundColor3 ~= PANEL then
                    tab.BackgroundColor3 = color
                end
            end
            play.BackgroundColor3 = color
        end
    end
end)

sound.Ended:Connect(function()
    status.Text = "● MUSIK SELESAI"
end)

print("CEMOON MUSIC v2.0 LOADED 🌙")

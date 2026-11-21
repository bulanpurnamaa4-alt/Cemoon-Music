--[[
    CEMOON MUSIC v2.1
    LUNAR EDITION ð
    Mobile + PC
]]

local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- CLEANUP
local oldGui = playerGui:FindFirstChild("CemoonMusic")
if oldGui then oldGui:Destroy() end

local oldSound = SoundService:FindFirstChild("CemoonMusicSound")
if oldSound then oldSound:Destroy() end

-- CONFIG
local FILE = "CemoonMusic_Database.json"
local DARK = Color3.fromRGB(13, 12, 17)
local PANEL = Color3.fromRGB(25, 23, 30)
local CARD = Color3.fromRGB(31, 29, 37)
local PURPLE = Color3.fromRGB(145, 85, 210)
local WHITE = Color3.fromRGB(240, 237, 245)
local MUTED = Color3.fromRGB(145, 138, 155)

local savedSongs = {}
local rgbEnabled = false
local minimized = false
local activeTab = 1

-- STORAGE
local function saveDatabase()
    if type(writefile) == "function" then
        pcall(function()
            writefile(FILE, HttpService:JSONEncode(savedSongs))
        end)
    end
end

local function loadDatabase()
    if type(readfile) ~= "function" then return end
    local ok, raw = pcall(function() return readfile(FILE) end)
    if not ok or type(raw) ~= "string" then return end

    local decodedOK, decoded = pcall(function()
        return HttpService:JSONDecode(raw)
    end)
    if not decodedOK or type(decoded) ~= "table" then return end

    for _, entry in ipairs(decoded) do
        if type(entry) == "table" and entry.id then
            table.insert(savedSongs, {
                name = tostring(entry.name or "Tanpa Nama"),
                id = tostring(entry.id)
            })
        elseif type(entry) == "string" or type(entry) == "number" then
            -- Import old v2.0 ID-only database
            table.insert(savedSongs, {
                name = "Musik " .. tostring(entry),
                id = tostring(entry)
            })
        end
    end
end

loadDatabase()

-- SOUND
local sound = Instance.new("Sound")
sound.Name = "CemoonMusicSound"
sound.Volume = 0.5
sound.Parent = SoundService

-- HELPERS
local function make(className, props, parent)
    local object = Instance.new(className)
    for key, value in pairs(props) do object[key] = value end
    object.Parent = parent
    return object
end

local function round(object, radius)
    make("UICorner", {CornerRadius = UDim.new(0, radius or 9)}, object)
end

local function button(parent, text, size, position, color)
    local b = make("TextButton", {
        Size = size,
        Position = position,
        BackgroundColor3 = color or PANEL,
        Text = text,
        TextColor3 = WHITE,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        AutoButtonColor = true,
        BorderSizePixel = 0
    }, parent)
    round(b, 9)
    return b
end

local function label(parent, text, size, position, textSize, color, bold)
    return make("TextLabel", {
        Size = size,
        Position = position,
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = color or WHITE,
        Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham,
        TextSize = textSize or 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center
    }, parent)
end

local function textBox(parent, placeholder, size, position)
    local box = make("TextBox", {
        Size = size,
        Position = position,
        BackgroundColor3 = CARD,
        PlaceholderText = placeholder,
        PlaceholderColor3 = MUTED,
        Text = "",
        TextColor3 = WHITE,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        ClearTextOnFocus = false,
        BorderSizePixel = 0,
        TextXAlignment = Enum.TextXAlignment.Left
    }, parent)
    round(box, 8)
    return box
end

-- GUI
local gui = make("ScreenGui", {
    Name = "CemoonMusic",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, playerGui)

local main = make("Frame", {
    Name = "Main",
    Size = UDim2.fromOffset(560, 410),
    Position = UDim2.new(0.5, -280, 0.5, -205),
    BackgroundColor3 = DARK,
    BorderSizePixel = 0,
    Active = true,
    ClipsDescendants = true
}, gui)
round(main, 18)

local stroke = make("UIStroke", {
    Color = Color3.fromRGB(75, 57, 91),
    Thickness = 1.2
}, main)

-- Keep the window inside the visible screen
local function fitWindow()
    local camera = workspace.CurrentCamera
    if not camera then return end
    local viewport = camera.ViewportSize
    local width = math.min(560, math.max(300, viewport.X - 24))
    local height = math.min(410, math.max(280, viewport.Y - 24))
    main.Size = UDim2.fromOffset(width, height)
    main.Position = UDim2.new(0.5, -width / 2, 0.5, -height / 2)
end
fitWindow()

-- HEADER
local header = make("Frame", {
    Size = UDim2.new(1, 0, 0, 58),
    BackgroundTransparency = 1,
    Active = true
}, main)

label(header, "ð CEMOON MUSIC", UDim2.new(1, -155, 0, 26),
    UDim2.fromOffset(17, 5), 17, WHITE, true)
label(header, "Lunar Edition â¢ v2.1", UDim2.new(1, -155, 0, 17),
    UDim2.fromOffset(18, 31), 10, MUTED, false)

local rgb = button(header, "RGB", UDim2.fromOffset(55, 30),
    UDim2.new(1, -128, 0, 14), Color3.fromRGB(80, 220, 90))
local minimize = button(header, "â", UDim2.fromOffset(34, 30),
    UDim2.new(1, -48, 0, 14), PANEL)

-- DRAG (ignore taps on header buttons)
local dragging, dragStart, startPos = false, nil, nil
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        local x = input.Position.X
        local rightEdge = main.AbsolutePosition.X + main.AbsoluteSize.X
        if x < rightEdge - 170 then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
        end
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- NAVIGATION + CONTENT
local nav = make("Frame", {
    Position = UDim2.fromOffset(12, 64),
    Size = UDim2.new(1, -24, 0, 36),
    BackgroundTransparency = 1
}, main)

local content = make("Frame", {
    Position = UDim2.fromOffset(12, 108),
    Size = UDim2.new(1, -24, 1, -120),
    BackgroundTransparency = 1,
    ClipsDescendants = true
}, main)

local navNames = {"ID Musik", "Database", "Daftar Musik", "Kredit"}
local pages, tabs = {}, {}

for i, name in ipairs(navNames) do
    local tab = button(nav, name,
        UDim2.new(0.25, -4, 1, 0),
        UDim2.new((i - 1) * 0.25, (i - 1) * 4, 0, 0), PANEL)
    tab.TextSize = 11
    tabs[i] = tab

    pages[i] = make("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Visible = i == 1
    }, content)
end

local function switchPage(index)
    activeTab = index
    for i, page in ipairs(pages) do
        page.Visible = i == index
        tabs[i].BackgroundColor3 = i == index and PURPLE or PANEL
    end
end
for i, tab in ipairs(tabs) do
    tab.Activated:Connect(function() switchPage(i) end)
end
switchPage(1)

-- PAGE 1: ID MUSIK
local p1 = pages[1]
local idInput = textBox(p1, "Masukkan ID musik...", UDim2.new(1, -10, 0, 40),
    UDim2.fromOffset(5, 12))
local status = label(p1, "â CEMOON READY", UDim2.new(1, -10, 0, 24),
    UDim2.fromOffset(5, 58), 11, Color3.fromRGB(190, 150, 230), false)

local playButton = button(p1, "â¶ PLAY",
    UDim2.new(0.5, -7, 0, 38), UDim2.fromOffset(5, 91), PURPLE)
local stopButton = button(p1, "â  STOP",
    UDim2.new(0.5, -7, 0, 38), UDim2.new(0.5, 2, 0, 91), PANEL)
local saveIdButton = button(p1, "ï¼ SIMPAN ID KE DATABASE",
    UDim2.new(1, -10, 0, 36), UDim2.fromOffset(5, 139), PANEL)

local function playID(id)
    if not id or not tostring(id):match("^%d+$") then
        status.Text = "ID MUSIK TIDAK VALID"
        return
    end
    sound:Stop()
    sound.SoundId = "rbxassetid://" .. tostring(id)
    sound:Play()
    status.Text = "â MEMUTAR ID " .. tostring(id)
end

playButton.Activated:Connect(function()
    local id = idInput.Text:match("^%s*(%d+)%s*$")
    if not id then status.Text = "MASUKKAN ID TERLEBIH DAHULU" return end
    playID(id)
end)
stopButton.Activated:Connect(function()
    sound:Stop()
    status.Text = "â MUSIK DIHENTIKAN"
end)

-- SCROLL LIST HELPER
local function createScroll(parent, topOffset)
    local scroll = make("ScrollingFrame", {
        Position = UDim2.fromOffset(0, topOffset or 0),
        Size = UDim2.new(1, 0, 1, -(topOffset or 0)),
        BackgroundColor3 = PANEL,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = PURPLE,
        CanvasSize = UDim2.fromOffset(0, 0)
    }, parent)
    round(scroll, 10)
    make("UIPadding", {
        PaddingTop = UDim.new(0, 7),
        PaddingBottom = UDim.new(0, 7),
        PaddingLeft = UDim.new(0, 7),
        PaddingRight = UDim.new(0, 7)
    }, scroll)
    local layout = make("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, scroll)
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 18)
    end)
    return scroll
end

-- PAGE 2: DATABASE (PERSONAL COLLECTION)
local databasePage = pages[2]
label(databasePage, "DATABASE MUSIK", UDim2.new(1, 0, 0, 24),
    UDim2.fromOffset(2, 0), 13, WHITE, true)
local addSong = button(databasePage, "ï¼ TAMBAH",
    UDim2.fromOffset(105, 30), UDim2.new(1, -107, 0, 0), PURPLE)

local form = make("Frame", {
    Position = UDim2.fromOffset(0, 36),
    Size = UDim2.new(1, 0, 0, 122),
    BackgroundColor3 = PANEL,
    BorderSizePixel = 0,
    Visible = false
}, databasePage)
round(form, 10)

label(form, "TAMBAH MUSIK BARU", UDim2.new(1, -16, 0, 20),
    UDim2.fromOffset(10, 5), 11, WHITE, true)
local songNameInput = textBox(form, "Kasih nama song...", UDim2.new(1, -20, 0, 32),
    UDim2.fromOffset(10, 29))
local songIdInput = textBox(form, "ID song...", UDim2.new(1, -20, 0, 32),
    UDim2.fromOffset(10, 66))
local confirmAdd = button(form, "TAMBAH", UDim2.fromOffset(90, 27),
    UDim2.new(1, -100, 1, -32), PURPLE)
local formStatus = label(form, "", UDim2.new(1, -110, 0, 24),
    UDim2.fromOffset(10, 94), 10, MUTED, false)

local databaseScroll = createScroll(databasePage, 166)

-- PAGE 3: DAFTAR MUSIK (CATALOG)
local playlistPage = pages[3]
local searchInput = textBox(playlistPage, "Cari nama / pembuat / id...",
    UDim2.new(1, 0, 0, 36), UDim2.fromOffset(0, 0))
label(playlistPage, "GLOBAL HITS",
    UDim2.new(1, 0, 0, 24), UDim2.fromOffset(3, 41), 10, MUTED, true)
local playlistScroll = createScroll(playlistPage, 69)

-- Catalog stays empty until user provides song IDs.
local catalogSongs = {}

local function clearSongRows(scroll)
    for _, child in ipairs(scroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
end

local refreshDatabase

local function makeSongRow(scroll, song, index, showDelete)
    local row = make("Frame", {
        Size = UDim2.new(1, -2, 0, 54),
        BackgroundColor3 = CARD,
        BorderSizePixel = 0,
        LayoutOrder = index
    }, scroll)
    round(row, 9)

    label(row, song.name, UDim2.new(1, -112, 0, 25),
        UDim2.fromOffset(12, 5), 12, WHITE, true)
    label(row, "ID " .. tostring(song.id), UDim2.new(1, -112, 0, 17),
        UDim2.fromOffset(12, 29), 9, MUTED, false)

    local play = button(row, "â¶", UDim2.fromOffset(34, 34),
        UDim2.new(1, -43, 0, 10), Color3.fromRGB(235, 232, 240))
    play.TextColor3 = DARK
    play.Activated:Connect(function()
        idInput.Text = tostring(song.id)
        playID(song.id)
        switchPage(1)
    end)

    if showDelete then
        local delete = button(row, "Ã", UDim2.fromOffset(27, 27),
            UDim2.new(1, -77, 0, 14), Color3.fromRGB(100, 45, 65))
        delete.Activated:Connect(function()
            for i, saved in ipairs(savedSongs) do
                if tostring(saved.id) == tostring(song.id)
                and tostring(saved.name) == tostring(song.name) then
                    table.remove(savedSongs, i)
                    break
                end
            end
            saveDatabase()
            if refreshDatabase then refreshDatabase() end
        end)
    end
end

refreshDatabase = function()
    clearSongRows(databaseScroll)
    if #savedSongs == 0 then
        label(databaseScroll, "Belum ada lagu. Tekan + TAMBAH untuk membuat koleksi.",
            UDim2.new(1, -8, 0, 42), UDim2.fromOffset(4, 0), 11, MUTED, false)
        return
    end
    for i, song in ipairs(savedSongs) do
        makeSongRow(databaseScroll, song, i, true)
    end
end

local function refreshCatalog()
    clearSongRows(playlistScroll)
    local query = string.lower(searchInput.Text or "")
    local shown = 0
    for _, song in ipairs(catalogSongs) do
        local haystack = string.lower(song.name .. " " .. tostring(song.id)
            .. " " .. tostring(song.creator or ""))
        if query == "" or string.find(haystack, query, 1, true) then
            shown = shown + 1
            makeSongRow(playlistScroll, song, shown, false)
        end
    end
    if shown == 0 then
        label(playlistScroll,
            #catalogSongs == 0 and "Katalog masih kosong. Kirim nama lagu dan ID-nya untuk mengisi GLOBAL HITS."
            or "Lagu tidak ditemukan.",
            UDim2.new(1, -8, 0, 48), UDim2.fromOffset(4, 0), 11, MUTED, false)
    end
end

addSong.Activated:Connect(function()
    form.Visible = not form.Visible
    if form.Visible then songNameInput:CaptureFocus() end
end)

confirmAdd.Activated:Connect(function()
    local name = songNameInput.Text:match("^%s*(.-)%s*$")
    local id = songIdInput.Text:match("^%s*(%d+)%s*$")
    if not name or name == "" then
        formStatus.Text = "Isi nama lagu dulu"
        return
    end
    if not id then
        formStatus.Text = "ID harus berupa angka"
        return
    end
    for _, song in ipairs(savedSongs) do
        if tostring(song.id) == id then
            formStatus.Text = "ID sudah ada di database"
            return
        end
    end
    table.insert(savedSongs, {name = name, id = id})
    saveDatabase()
    songNameInput.Text = ""
    songIdInput.Text = ""
    formStatus.Text = "Berhasil ditambahkan!"
    refreshDatabase()
end)

saveIdButton.Activated:Connect(function()
    local id = idInput.Text:match("^%s*(%d+)%s*$")
    if not id then status.Text = "MASUKKAN ID TERLEBIH DAHULU" return end
    for _, song in ipairs(savedSongs) do
        if tostring(song.id) == id then
            status.Text = "ID SUDAH ADA DI DATABASE"
            switchPage(2)
            return
        end
    end
    table.insert(savedSongs, {name = "Musik " .. id, id = id})
    saveDatabase()
    status.Text = "â ID DISIMPAN KE DATABASE"
    refreshDatabase()
end)

searchInput:GetPropertyChangedSignal("Text"):Connect(refreshCatalog)

-- PAGE 4: KREDIT
local credits = pages[4]
label(credits, "CEMOON MUSIC ð", UDim2.new(1, -10, 0, 30),
    UDim2.fromOffset(5, 15), 18, WHITE, true)
make("TextLabel", {
    Position = UDim2.fromOffset(5, 52),
    Size = UDim2.new(1, -10, 0, 110),
    BackgroundTransparency = 1,
    Text = "LUNAR EDITION â¢ VERSION 2.1\n\nMobile + PC Music Player\nPersonal Database â¢ Song Catalog\n\nMade with ð by Cemoon",
    TextColor3 = MUTED,
    TextSize = 12,
    Font = Enum.Font.Gotham,
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top
}, credits)

-- MINIMIZE
minimize.Activated:Connect(function()
    minimized = not minimized
    nav.Visible = not minimized
    content.Visible = not minimized
    main.Size = minimized and UDim2.fromOffset(220, 58)
        or UDim2.fromOffset(560, 410)
    if not minimized then fitWindow() end
    minimize.Text = minimized and "+" or "â"
end)

-- RGB
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
            tabs[activeTab].BackgroundColor3 = color
        end
    end
end)

sound.Ended:Connect(function()
    status.Text = "â MUSIK SELESAI"
end)

refreshDatabase()
refreshCatalog()
print("CEMOON MUSIC v2.1 LOADED ð")


--[[
    CEMOON MUSIC v3.1
    Lunar Edition | Mobile + PC
]]

local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Cleanup old version
local oldGui = playerGui:FindFirstChild("CemoonMusic")
if oldGui then oldGui:Destroy() end

local oldSound = SoundService:FindFirstChild("CemoonMusicSound")
if oldSound then oldSound:Destroy() end

-- Config
local FILE = "CemoonMusic_Database.json"

local C = {
    bg = Color3.fromRGB(13, 12, 18),
    panel = Color3.fromRGB(25, 23, 32),
    card = Color3.fromRGB(34, 31, 42),
    purple = Color3.fromRGB(151, 94, 220),
    white = Color3.fromRGB(242, 238, 248),
    muted = Color3.fromRGB(155, 146, 168),
    red = Color3.fromRGB(130, 48, 70)
}

local songs = {}
local catalog = {
    -- Tambahkan katalog lagu di sini nanti:
    -- {name = "Nama Lagu", id = "123456789", creator = "Nama Creator"},
}

local activeTab = 1
local rgbEnabled = false
local minimized = false
local savedWindowSize
local dragging = false
local dragStart
local startPosition

-- Helpers
local function create(className, properties, parent)
    local obj = Instance.new(className)

    for key, value in pairs(properties) do
        obj[key] = value
    end

    obj.Parent = parent
    return obj
end

local function corner(obj, radius)
    create("UICorner", {
        CornerRadius = UDim.new(0, radius or 9)
    }, obj)
end

local function outline(obj, color, thickness)
    return create("UIStroke", {
        Color = color or Color3.fromRGB(75, 58, 95),
        Thickness = thickness or 1
    }, obj)
end

local function makeLabel(parent, text, size, position, textSize, color, bold)
    return create("TextLabel", {
        BackgroundTransparency = 1,
        Size = size,
        Position = position,
        Text = text,
        TextColor3 = color or C.white,
        TextSize = textSize or 12,
        Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        TextWrapped = true
    }, parent)
end

local function makeButton(parent, text, size, position, color)
    local button = create("TextButton", {
        Size = size,
        Position = position,
        BackgroundColor3 = color or C.panel,
        Text = text,
        TextColor3 = C.white,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        AutoButtonColor = true
    }, parent)

    corner(button, 8)
    return button
end

local function makeBox(parent, placeholder, size, position)
    local box = create("TextBox", {
        Size = size,
        Position = position,
        BackgroundColor3 = C.card,
        PlaceholderText = placeholder,
        PlaceholderColor3 = C.muted,
        Text = "",
        TextColor3 = C.white,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        ClearTextOnFocus = false,
        BorderSizePixel = 0,
        TextXAlignment = Enum.TextXAlignment.Left
    }, parent)

    corner(box, 8)

    create("UIPadding", {
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 8)
    }, box)

    return box
end

local function validId(value)
    return tostring(value or ""):match("^%s*(%d+)%s*$")
end

-- Database
local function saveDatabase()
    if type(writefile) ~= "function" then
        return false, "Executor tidak mendukung writefile"
    end

    local ok = pcall(function()
        writefile(FILE, HttpService:JSONEncode(songs))
    end)

    return ok, ok and "Tersimpan" or "Gagal menyimpan database"
end

local function loadDatabase()
    if type(readfile) ~= "function" then
        return
    end

    if type(isfile) == "function" then
        local checkOk, exists = pcall(isfile, FILE)

        if checkOk and not exists then
            return
        end
    end

    local ok, raw = pcall(readfile, FILE)

    if not ok or type(raw) ~= "string" then
        return
    end

    local decodedOk, data = pcall(function()
        return HttpService:JSONDecode(raw)
    end)

    if not decodedOk or type(data) ~= "table" then
        return
    end

    local seen = {}

    for _, entry in ipairs(data) do
        local id
        local name

        if type(entry) == "table" then
            id = validId(entry.id)
            name = tostring(entry.name or "Tanpa Nama")

        elseif type(entry) == "string" or type(entry) == "number" then
            id = validId(entry)
            name = "Musik " .. tostring(entry)
        end

        if id and not seen[id] then
            seen[id] = true

            table.insert(songs, {
                name = name or "Tanpa Nama",
                id = id
            })
        end
    end
end

loadDatabase()

-- Sound
local sound = create("Sound", {
    Name = "CemoonMusicSound",
    Volume = 0.5
}, SoundService)

-- GUI
local gui = create("ScreenGui", {
    Name = "CemoonMusic",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, playerGui)

local main = create("Frame", {
    Name = "Main",
    Size = UDim2.fromOffset(540, 400),
    Position = UDim2.new(0.5, -270, 0.5, -200),
    BackgroundColor3 = C.bg,
    BorderSizePixel = 0,
    Active = true,
    ClipsDescendants = true
}, gui)

corner(main, 16)

local mainStroke = outline(
    main,
    Color3.fromRGB(83, 62, 108),
    1.2
)

local function fitWindow()
    local camera = workspace.CurrentCamera
    if not camera then return end

    local viewport = camera.ViewportSize

    local width = math.max(290, math.min(540, viewport.X - 20))
    local height = math.max(300, math.min(400, viewport.Y - 20))

    main.Size = UDim2.fromOffset(width, height)
    main.Position = UDim2.new(
        0.5, -width / 2,
        0.5, -height / 2
    )

    savedWindowSize = main.Size
end

fitWindow()

-- Header
local header = create("Frame", {
    Size = UDim2.new(1, 0, 0, 56),
    BackgroundTransparency = 1,
    Active = true
}, main)

makeLabel(
    header,
    "CEMOON MUSIC",
    UDim2.new(1, -170, 0, 25),
    UDim2.fromOffset(15, 5),
    16,
    C.white,
    true
)

makeLabel(
    header,
    "Lunar Edition | v3.1",
    UDim2.new(1, -170, 0, 17),
    UDim2.fromOffset(16, 30),
    10,
    C.muted,
    false
)

local rgbButton = makeButton(
    header,
    "RGB",
    UDim2.fromOffset(54, 29),
    UDim2.new(1, -119, 0, 13),
    C.purple
)

local minimizeButton = makeButton(
    header,
    "—",
    UDim2.fromOffset(34, 29),
    UDim2.new(1, -48, 0, 13),
    C.panel
)

-- Drag window: mouse + touch
local activeDragInput

local function beginDrag(input)
    if input.UserInputType ~= Enum.UserInputType.MouseButton1
        and input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end

    local x = input.Position.X

    if x >= main.AbsolutePosition.X + main.AbsoluteSize.X - 125 then
        return
    end

    dragging = true
    activeDragInput = input
    dragStart = input.Position
    startPosition = main.Position
end

header.InputBegan:Connect(beginDrag)

UserInputService.InputChanged:Connect(function(input)
    if not dragging then return end

    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then

        if activeDragInput
            and activeDragInput.UserInputType == Enum.UserInputType.Touch
            and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        local delta = input.Position - dragStart

        main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input == activeDragInput
        or input.UserInputType == Enum.UserInputType.MouseButton1 then

        dragging = false
        activeDragInput = nil
    end
end)

-- Navigation
local nav = create("Frame", {
    Position = UDim2.fromOffset(10, 62),
    Size = UDim2.new(1, -20, 0, 34),
    BackgroundTransparency = 1
}, main)

local content = create("Frame", {
    Position = UDim2.fromOffset(10, 104),
    Size = UDim2.new(1, -20, 1, -114),
    BackgroundTransparency = 1,
    ClipsDescendants = true
}, main)

local names = {
    "ID Musik",
    "Database",
    "Daftar Musik",
    "Kredit"
}

local pages = {}
local tabs = {}

for i, name in ipairs(names) do
    local tab = makeButton(
        nav,
        name,
        UDim2.new(0.25, -4, 1, 0),
        UDim2.new((i - 1) * 0.25, (i - 1) * 4, 0, 0),
        C.panel
    )

    tab.TextSize = 10
    tabs[i] = tab

    pages[i] = create("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Visible = i == 1
    }, content)
end

local function switchPage(index)
    activeTab = index

    for i, page in ipairs(pages) do
        page.Visible = i == index
        tabs[i].BackgroundColor3 =
            i == index and C.purple or C.panel
    end
end

for i, tab in ipairs(tabs) do
    tab.Activated:Connect(function()
        switchPage(i)
    end)
end

switchPage(1)

-- ID MUSIC PAGE
local idPage = pages[1]

local idInput = makeBox(
    idPage,
    "Masukkan ID musik...",
    UDim2.new(1, -8, 0, 39),
    UDim2.fromOffset(4, 12)
)

local status = makeLabel(
    idPage,
    "CEMOON READY",
    UDim2.new(1, -8, 0, 24),
    UDim2.fromOffset(5, 57),
    11,
    C.purple,
    true
)

local playButton = makeButton(
    idPage,
    "PLAY",
    UDim2.new(0.5, -6, 0, 38),
    UDim2.fromOffset(4, 89),
    C.purple
)

local stopButton = makeButton(
    idPage,
    "STOP",
    UDim2.new(0.5, -6, 0, 38),
    UDim2.new(0.5, 2, 0, 89),
    C.panel
)

local saveIdButton = makeButton(
    idPage,
    "+ SIMPAN ID KE DATABASE",
    UDim2.new(1, -8, 0, 36),
    UDim2.fromOffset(4, 136),
    C.panel
)

local function playId(id)
    id = validId(id)

    if not id then
        status.Text = "ID MUSIK TIDAK VALID"
        return
    end

    sound:Stop()
    sound.SoundId = "rbxassetid://" .. id

    local ok = pcall(function()
        sound:Play()
    end)

    status.Text = ok
        and ("MEMUTAR ID " .. id)
        or "GAGAL MEMUTAR MUSIK"
end

playButton.Activated:Connect(function()
    local id = validId(idInput.Text)

    if not id then
        status.Text = "MASUKKAN ID TERLEBIH DAHULU"
        return
    end

    playId(id)
end)

stopButton.Activated:Connect(function()
    sound:Stop()
    status.Text = "MUSIK DIHENTIKAN"
end)

-- Scroll list helper
local function makeScroll(parent, top)
    local scroll = create("ScrollingFrame", {
        Position = UDim2.fromOffset(0, top),
        Size = UDim2.new(1, 0, 1, -top),
        BackgroundColor3 = C.panel,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = C.purple,
        CanvasSize = UDim2.fromOffset(0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.None
    }, parent)

    corner(scroll, 9)

    create("UIPadding", {
        PaddingTop = UDim.new(0, 7),
        PaddingBottom = UDim.new(0, 7),
        PaddingLeft = UDim.new(0, 7),
        PaddingRight = UDim.new(0, 7)
    }, scroll)

    local layout = create("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, scroll)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.fromOffset(
            0,
            layout.AbsoluteContentSize.Y + 18
        )
    end)

    return scroll
end

-- DATABASE PAGE
local dbPage = pages[2]

makeLabel(
    dbPage,
    "DATABASE MUSIK",
    UDim2.new(1, -120, 0, 27),
    UDim2.fromOffset(2, 0),
    13,
    C.white,
    true
)

local addButton = makeButton(
    dbPage,
    "+ TAMBAH",
    UDim2.fromOffset(105, 29),
    UDim2.new(1, -105, 0, 0),
    C.purple
)

local form = create("Frame", {
    Position = UDim2.fromOffset(0, 35),
    Size = UDim2.new(1, 0, 0, 125),
    BackgroundColor3 = C.panel,
    BorderSizePixel = 0,
    Visible = false
}, dbPage)

corner(form, 9)

makeLabel(
    form,
    "TAMBAH MUSIK BARU",
    UDim2.new(1, -16, 0, 19),
    UDim2.fromOffset(9, 4),
    10,
    C.white,
    true
)

local nameInput = makeBox(
    form,
    "Kasih nama song...",
    UDim2.new(1, -18, 0, 30),
    UDim2.fromOffset(9, 26)
)

local songIdInput = makeBox(
    form,
    "ID song...",
    UDim2.new(1, -18, 0, 30),
    UDim2.fromOffset(9, 61)
)

local addConfirm = makeButton(
    form,
    "TAMBAH",
    UDim2.fromOffset(84, 25),
    UDim2.new(1, -93, 1, -29),
    C.purple
)

local formStatus = makeLabel(
    form,
    "",
    UDim2.new(1, -105, 0, 22),
    UDim2.fromOffset(9, 98),
    9,
    C.muted,
    false
)

local dbScroll = makeScroll(dbPage, 168)

-- CATALOG PAGE
local catalogPage = pages[3]

local searchBox = makeBox(
    catalogPage,
    "Cari nama / pembuat / id...",
    UDim2.new(1, 0, 0, 34),
    UDim2.fromOffset(0, 0)
)

makeLabel(
    catalogPage,
    "GLOBAL HITS",
    UDim2.new(1, 0, 0, 22),
    UDim2.fromOffset(3, 38),
    10,
    C.muted,
    true
)

local catalogScroll = makeScroll(catalogPage, 64)

-- Clear generated rows and empty messages
local function clearRows(scroll)
    for _, child in ipairs(scroll:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") then
            child:Destroy()
        end
    end
end

local function emptyMessage(scroll, message)
    makeLabel(
        scroll,
        message,
        UDim2.new(1, -8, 0, 48),
        UDim2.fromOffset(4, 0),
        10,
        C.muted,
        false
    )
end

local refreshDatabase

local function makeSongRow(scroll, song, index, canDelete)
    local row = create("Frame", {
        Size = UDim2.new(1, -2, 0, 53),
        BackgroundColor3 = C.card,
        BorderSizePixel = 0,
        LayoutOrder = index
    }, scroll)

    corner(row, 8)

    makeLabel(
        row,
        tostring(song.name),
        UDim2.new(1, -115, 0, 24),
        UDim2.fromOffset(10, 4),
        11,
        C.white,
        true
    )

    makeLabel(
        row,
        "ID " .. tostring(song.id),
        UDim2.new(1, -115, 0, 17),
        UDim2.fromOffset(10, 28),
        9,
        C.muted,
        false
    )

    local play = makeButton(
        row,
        "PLAY",
        UDim2.fromOffset(42, 33),
        UDim2.new(1, -50, 0, 10),
        C.purple
    )

    play.Activated:Connect(function()
        idInput.Text = tostring(song.id)
        switchPage(1)
        playId(song.id)
    end)

    if canDelete then
        local del = makeButton(
            row,
            "X",
            UDim2.fromOffset(25, 25),
            UDim2.new(1, -80, 0, 14),
            C.red
        )

        del.Activated:Connect(function()
            for i, item in ipairs(songs) do
                if tostring(item.id) == tostring(song.id)
                    and tostring(item.name) == tostring(song.name) then

                    table.remove(songs, i)
                    break
                end
            end

            saveDatabase()
            refreshDatabase()
        end)
    end
end

-- Refresh database
refreshDatabase = function()
    clearRows(dbScroll)

    if #songs == 0 then
        emptyMessage(
            dbScroll,
            "Belum ada lagu. Tekan + TAMBAH untuk membuat koleksi."
        )
        return
    end

    for i, song in ipairs(songs) do
        makeSongRow(dbScroll, song, i, true)
    end
end

-- Refresh catalog
local function refreshCatalog()
    clearRows(catalogScroll)

    local query = string.lower(searchBox.Text or "")
    local count = 0

    for _, song in ipairs(catalog) do
        local haystack = string.lower(
            tostring(song.name or "") .. " " ..
            tostring(song.id or "") .. " " ..
            tostring(song.creator or "")
        )

        if query == "" or string.find(haystack, query, 1, true) then
            count += 1
            makeSongRow(catalogScroll, song, count, false)
        end
    end

    if count == 0 then
        emptyMessage(
            catalogScroll,
            #catalog == 0
                and "Katalog masih kosong. Data lagu bisa ditambahkan ke bagian catalog di script."
                or "Lagu tidak ditemukan."
        )
    end
end

-- Add form
addButton.Activated:Connect(function()
    form.Visible = not form.Visible

    if form.Visible then
        nameInput:CaptureFocus()
    end
end)

addConfirm.Activated:Connect(function()
    local name = tostring(nameInput.Text):match("^%s*(.-)%s*$")
    local id = validId(songIdInput.Text)

    if name == "" then
        formStatus.Text = "Isi nama lagu dulu"
        return
    end

    if not id then
        formStatus.Text = "ID harus berupa angka"
        return
    end

    for _, song in ipairs(songs) do
        if tostring(song.id) == id then
            formStatus.Text = "ID sudah ada di database"
            return
        end
    end

    table.insert(songs, {
        name = name,
        id = id
    })

    local ok, message = saveDatabase()

    nameInput.Text = ""
    songIdInput.Text = ""

    formStatus.Text = ok
        and "Berhasil ditambahkan!"
        or "Ditambahkan, tapi " .. message

    refreshDatabase()
end)

-- Save ID from player page
saveIdButton.Activated:Connect(function()
    local id = validId(idInput.Text)

    if not id then
        status.Text = "MASUKKAN ID TERLEBIH DAHULU"
        return
    end

    for _, song in ipairs(songs) do
        if tostring(song.id) == id then
            status.Text = "ID SUDAH ADA DI DATABASE"
            switchPage(2)
            return
        end
    end

    table.insert(songs, {
        name = "Musik " .. id,
        id = id
    })

    local ok = saveDatabase()

    status.Text = ok
        and "ID DISIMPAN KE DATABASE"
        or "ID ditambahkan, penyimpanan tidak didukung"

    refreshDatabase()
end)

searchBox:GetPropertyChangedSignal("Text"):Connect(refreshCatalog)

-- CREDITS PAGE
local credits = pages[4]

makeLabel(
    credits,
    "CEMOON MUSIC",
    UDim2.new(1, -10, 0, 30),
    UDim2.fromOffset(5, 14),
    17,
    C.white,
    true
)

makeLabel(
    credits,
    "LUNAR EDITION | VERSION 3.1\n\nMobile + PC Music Player\nPersonal Database | Song Catalog\n\nMade by Cemoon",
    UDim2.new(1, -10, 0, 125),
    UDim2.fromOffset(5, 51),
    11,
    C.muted,
    false
)

-- Minimize / restore
minimizeButton.Activated:Connect(function()
    minimized = not minimized

    if minimized then
        savedWindowSize = main.Size

        nav.Visible = false
        content.Visible = false

        main.Size = UDim2.fromOffset(220, 56)
        minimizeButton.Text = "+"

    else
        nav.Visible = true
        content.Visible = true

        if savedWindowSize then
            main.Size = savedWindowSize
        else
            fitWindow()
        end

        minimizeButton.Text = "—"
    end
end)

-- RGB outline effect
rgbButton.Activated:Connect(function()
    rgbEnabled = not rgbEnabled

    rgbButton.Text = rgbEnabled and "RGB ON" or "RGB"

    if not rgbEnabled then
        mainStroke.Color = Color3.fromRGB(83, 62, 108)
        rgbButton.BackgroundColor3 = C.purple
        tabs[activeTab].BackgroundColor3 = C.purple
    end
end)

task.spawn(function()
    local hue = 0

    while gui.Parent do
        task.wait(0.05)

        if rgbEnabled then
            hue = (hue + 0.004) % 1

            local color = Color3.fromHSV(hue, 0.62, 0.95)

            mainStroke.Color = color
            rgbButton.BackgroundColor3 = color
            tabs[activeTab].BackgroundColor3 = color
        end
    end
end)

sound.Ended:Connect(function()
    status.Text = "MUSIK SELESAI"
end)

refreshDatabase()
refreshCatalog()

print("CEMOON MUSIC v3.1 LOADED")

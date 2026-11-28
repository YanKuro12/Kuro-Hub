local P = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local LP = P.LocalPlayer
local WS = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

local VALID_PLACES = {2753915549, 4442272183, 7449423635}
local isValidGame = table.find(VALID_PLACES, game.PlaceId) ~= nil

local Connections = {}
local function connect(signal, fn)
    local c = signal:Connect(fn)
    table.insert(Connections, c)
    return c
end

local Toggles = {}

local ThemeElements = {
    accent = {}, surface = {}, surfaceAlt = {}, border = {}, text = {}, textMuted = {}, bg = {}
}

local function registerTheme(instance, prop, themeKey)
    if not ThemeElements[themeKey] then return end
    table.insert(ThemeElements[themeKey], {instance = instance, prop = prop})
end

local Themes = {
    Gold = {
        name="Gold", accent=Color3.fromRGB(218,180,90),
        surface=Color3.fromRGB(24,24,28), surfaceAlt=Color3.fromRGB(34,34,40),
        bg=Color3.fromRGB(14,14,17), border=Color3.fromRGB(65,60,45),
        text=Color3.fromRGB(245,243,235), textMuted=Color3.fromRGB(160,158,150),
    },
    Obsidian = {
        name="Obsidian", accent=Color3.fromRGB(130,200,255),
        surface=Color3.fromRGB(20,22,28), surfaceAlt=Color3.fromRGB(28,30,38),
        bg=Color3.fromRGB(10,12,16), border=Color3.fromRGB(45,50,60),
        text=Color3.fromRGB(235,240,250), textMuted=Color3.fromRGB(140,150,170),
    },
    Hacker = {
        name="Hacker", accent=Color3.fromRGB(0,210,110),
        surface=Color3.fromRGB(6,18,10), surfaceAlt=Color3.fromRGB(12,28,18),
        bg=Color3.fromRGB(2,10,5), border=Color3.fromRGB(0,80,40),
        text=Color3.fromRGB(200,255,220), textMuted=Color3.fromRGB(100,180,140),
    },
    Neon = {
        name="Neon", accent=Color3.fromRGB(255,80,200),
        surface=Color3.fromRGB(18,15,25), surfaceAlt=Color3.fromRGB(28,22,38),
        bg=Color3.fromRGB(8,5,12), border=Color3.fromRGB(200,50,180),
        text=Color3.fromRGB(255,255,255), textMuted=Color3.fromRGB(190,180,220),
    }
}
local ThemeOrder = {"Gold","Obsidian","Hacker","Neon"}

local SAVE_FOLDER = "Kuro-Hub"
local SAVE_FILE = SAVE_FOLDER .. "/settings.json"
local SaveData = {Theme = "Gold", Toggles = {}}

local function loadSave()
    if not (isfolder and writefile and readfile) then return end
    if not isfolder(SAVE_FOLDER) then makefolder(SAVE_FOLDER) end
    local ok, data = pcall(function()
        return HttpService:JSONDecode(readfile(SAVE_FILE))
    end)
    if ok and type(data) == "table" then
        SaveData.Theme = data.Theme or "Gold"
        SaveData.Toggles = data.Toggles or {}
    end
end

local function writeSave()
    if not (writefile and isfolder) then return end
    if not isfolder(SAVE_FOLDER) then makefolder(SAVE_FOLDER) end
    pcall(function()
        writefile(SAVE_FILE, HttpService:JSONEncode(SaveData))
    end)
end

loadSave()

_G.KuroAutoFarm = false; _G.KuroAutoSecret = false; _G.KuroAutoBuso = false
_G.KuroAutoKen = false; _G.KuroRaidBuyChip = false; _G.KuroRaidFarm = false
_G.KuroRaidKill = false; _G.KuroRaidStart = false; _G.KuroRaidAwake = false

local IsMinimized = false
local CurrentTab = "Status"
local CurrentTheme = SaveData.Theme

local C = {
    bg = Themes[CurrentTheme].bg, surface = Themes[CurrentTheme].surface, surfaceAlt = Themes[CurrentTheme].surfaceAlt,
    border = Themes[CurrentTheme].border, accent = Themes[CurrentTheme].accent,
    text = Themes[CurrentTheme].text, textMuted = Themes[CurrentTheme].textMuted,
}

local function tween(obj, time, props, style)
    return TS:Create(obj, TweenInfo.new(time, style or Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props)
end

local function createSection(parent, titleText, descText)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, -10, 0, 44)
    section.BackgroundTransparency = 1
    section.Parent = parent
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 20)
    title.BackgroundTransparency = 1
    title.Text = string.upper(titleText)
    title.TextColor3 = C.accent
    title.Font = Enum.Font.GothamBold
    title.TextSize = 11
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = section
    registerTheme(title, "TextColor3", "accent")
    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(1, 0, 0, 15)
    desc.Position = UDim2.fromOffset(0, 22)
    desc.BackgroundTransparency = 1
    desc.Text = descText
    desc.TextColor3 = C.textMuted
    desc.Font = Enum.Font.Gotham
    desc.TextSize = 10
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.Parent = section
    registerTheme(desc, "TextColor3", "textMuted")
end

local function createToggle(parent, titleText, descText, toggleInitial, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -10, 0, 58)
    card.BackgroundColor3 = C.surface
    card.Parent = parent
    registerTheme(card, "BackgroundColor3", "surface")

    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 8) c.Parent = card
    local stroke = Instance.new("UIStroke") stroke.Color = C.border stroke.Thickness = 1 stroke.Transparency = 0.6 stroke.Parent = card
    registerTheme(stroke, "Color", "border")

    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, -80, 0, 18) t.Position = UDim2.fromOffset(12, 10)
    t.BackgroundTransparency = 1 t.Text = titleText t.TextColor3 = C.text
    t.Font = Enum.Font.GothamSemibold t.TextSize = 12 t.TextXAlignment = Enum.TextXAlignment.Left t.Parent = card
    registerTheme(t, "TextColor3", "text")

    local d = Instance.new("TextLabel")
    d.Size = UDim2.new(1, -80, 0, 14) d.Position = UDim2.fromOffset(12, 28)
    d.BackgroundTransparency = 1 d.Text = descText d.TextColor3 = C.textMuted
    d.Font = Enum.Font.Gotham d.TextSize = 9 d.TextXAlignment = Enum.TextXAlignment.Left d.Parent = card
    registerTheme(d, "TextColor3", "textMuted")

    local toggle = Instance.new("TextButton")
    toggle.AnchorPoint = Vector2.new(1, 0.5) toggle.Position = UDim2.new(1, -12, 0.5, 0)
    toggle.Size = UDim2.fromOffset(38, 20)
    toggle.BackgroundColor3 = toggleInitial and C.accent or C.surfaceAlt
    toggle.AutoButtonColor = false toggle.Text = "" toggle.Parent = card

    local tc = Instance.new("UICorner") tc.CornerRadius = UDim.new(1, 0) tc.Parent = toggle

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(14, 14)
    knob.Position = toggleInitial and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.Parent = toggle

    local kc = Instance.new("UICorner") kc.CornerRadius = UDim.new(1, 0) kc.Parent = knob

    local state = toggleInitial

    local function setState(newState, fireCallback)
        state = newState
        tween(knob, 0.2, {Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)}):Play()
        tween(toggle, 0.2, {BackgroundColor3 = state and C.accent or C.surfaceAlt}):Play()
        tween(stroke, 0.2, {Color = state and C.accent or C.border, Transparency = state and 0.2 or 0.6}):Play()
        if fireCallback and callback then callback(state) end
    end

    toggle.MouseButton1Click:Connect(function()
        setState(not state, true)
        SaveData.Toggles[titleText] = state
        writeSave()
    end)

    Toggles[titleText] = {
        get = function() return state end,
        set = function(v, fire) setState(v, fire ~= false) end,
        card = card
    }

    return Toggles[titleText]
end

local gui = Instance.new("ScreenGui")
gui.Name = "KuroHubUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.DisplayOrder = 999

local successCore = pcall(function() gui.Parent = game:GetService("CoreGui") end)
if not successCore then gui.Parent = LP:WaitForChild("PlayerGui") end

local main = Instance.new("Frame")
main.Name = "Main"
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)
main.Size = UDim2.fromOffset(500, 380)
main.BackgroundColor3 = C.bg
main.BorderSizePixel = 0
main.Active = true
main.ClipsDescendants = true
main.Parent = gui
registerTheme(main, "BackgroundColor3", "bg")

local mainCorner = Instance.new("UICorner") mainCorner.CornerRadius = UDim.new(0, 14) mainCorner.Parent = main
local mainStroke = Instance.new("UIStroke") mainStroke.Color = C.border mainStroke.Thickness = 1 mainStroke.Transparency = 0.4 mainStroke.Parent = main
registerTheme(mainStroke, "Color", "border")

local uiScale = Instance.new("UIScale")
uiScale.Parent = main

local islandFrame = Instance.new("Frame")
islandFrame.Name = "DynamicIsland"
islandFrame.AnchorPoint = Vector2.new(0.5, 0)
islandFrame.Position = UDim2.new(0.5, 0, 0, 12)
islandFrame.Size = UDim2.fromOffset(150, 35)
islandFrame.BackgroundColor3 = C.surface
islandFrame.Visible = false
islandFrame.ZIndex = 5
islandFrame.Active = true
islandFrame.Parent = gui
registerTheme(islandFrame, "BackgroundColor3", "surface")

local islandCorner = Instance.new("UICorner") islandCorner.CornerRadius = UDim.new(1, 0) islandCorner.Parent = islandFrame
local islandStroke = Instance.new("UIStroke") islandStroke.Color = C.border islandStroke.Thickness = 1 islandStroke.Parent = islandFrame
registerTheme(islandStroke, "Color", "border")

local islandText = Instance.new("TextLabel")
islandText.Size = UDim2.fromScale(1, 1)
islandText.BackgroundTransparency = 1
islandText.Text = "KURO ISLAND"
islandText.TextColor3 = C.accent
islandText.Font = Enum.Font.GothamBold
islandText.TextSize = 10
islandText.TextScaled = true
islandText.Parent = islandFrame
registerTheme(islandText, "TextColor3", "accent")

local saveSize = UDim2.fromOffset(500, 380)

local function isPortrait()
    local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize
    return vp and vp.Y > vp.X
end

local function updateIslandScale()
    local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize
    if not vp then return end
    local baseWidth = 150
    local scale = math.clamp(vp.X / 1200, 0.5, 1.2)
    islandFrame.Size = UDim2.fromOffset(baseWidth * scale, 35 * scale)
    islandFrame.Position = UDim2.new(0.5, 0, 0, 12 * scale)
    islandText.TextSize = math.clamp(10 * scale, 7, 14)
    islandStroke.Thickness = math.max(1, math.floor(scale))
end

local function updateScale()
    local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize
    if not vp then return end
    local scaleX = (vp.X * 0.9) / 500
    local scaleY = (vp.Y * 0.9) / 380
    local scale = math.clamp(math.min(scaleX, scaleY), 0.4, 1.1)
    uiScale.Scale = scale
    if isPortrait() then
        main.Size = UDim2.fromOffset(400, 500)
    else
        main.Size = UDim2.fromOffset(500, 380)
    end
    updateIslandScale()
end

local viewportDebounce = false
local function onViewportChange()
    if viewportDebounce then return end
    viewportDebounce = true
    task.delay(0.1, function()
        updateScale()
        viewportDebounce = false
    end)
end

updateScale()
if workspace.CurrentCamera then
    connect(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), onViewportChange)
end

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = C.surface
header.ZIndex = 2
header.Parent = main
registerTheme(header, "BackgroundColor3", "surface")

local headerCorner = Instance.new("UICorner") headerCorner.CornerRadius = UDim.new(0, 14) headerCorner.Parent = header
local headerFix = Instance.new("Frame") headerFix.Size = UDim2.new(1, 0, 0, 10) headerFix.Position = UDim2.new(0, 0, 1, -10) headerFix.BackgroundColor3 = C.surface headerFix.BorderSizePixel = 0 headerFix.ZIndex = 2 headerFix.Parent = header
registerTheme(headerFix, "BackgroundColor3", "surface")

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -180, 1, 0) title.Position = UDim2.fromOffset(16, 0)
title.BackgroundTransparency = 1 title.Text = "KURO HUB"
title.TextColor3 = C.text title.Font = Enum.Font.GothamBold
title.TextSize = 15 title.TextXAlignment = Enum.TextXAlignment.Left title.ZIndex = 3 title.Parent = header
registerTheme(title, "TextColor3", "text")

local btnContainer = Instance.new("Frame")
btnContainer.AnchorPoint = Vector2.new(1, 0.5) btnContainer.Position = UDim2.new(1, -12, 0.5, 0)
btnContainer.Size = UDim2.fromOffset(96, 24) btnContainer.BackgroundTransparency = 1 btnContainer.ZIndex = 3 btnContainer.Parent = header
local btnLayout = Instance.new("UIListLayout") btnLayout.FillDirection = Enum.FillDirection.Horizontal btnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right btnLayout.Padding = UDim.new(0, 6) btnLayout.Parent = btnContainer

local function createHeaderBtn(icon, hoverColor)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromOffset(24, 24)
    btn.BackgroundColor3 = C.surfaceAlt
    btn.AutoButtonColor = false btn.Text = icon btn.TextColor3 = C.textMuted
    btn.Font = Enum.Font.GothamBold btn.TextSize = 12 btn.Parent = btnContainer
    registerTheme(btn, "BackgroundColor3", "surfaceAlt")
    registerTheme(btn, "TextColor3", "textMuted")
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 6) c.Parent = btn
    btn.MouseEnter:Connect(function() tween(btn, 0.15, {BackgroundColor3 = hoverColor, TextColor3 = Color3.new(1,1,1)}):Play() end)
    btn.MouseLeave:Connect(function() tween(btn, 0.15, {BackgroundColor3 = C.surfaceAlt, TextColor3 = C.textMuted}):Play() end)
    return btn
end

local setBtn = createHeaderBtn("⚙", C.accent)
local minBtn = createHeaderBtn("—", C.accent)
local closeBtn = createHeaderBtn("X", Color3.fromRGB(200, 70, 90))

local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, -32, 0, 30) tabBar.Position = UDim2.fromOffset(16, 60)
tabBar.BackgroundTransparency = 1 tabBar.ZIndex = 2 tabBar.Parent = main
local tabScroll = Instance.new("ScrollingFrame")
tabScroll.Size = UDim2.fromScale(1, 1) tabScroll.BackgroundTransparency = 1 tabScroll.ScrollBarThickness = 0
tabScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
tabScroll.CanvasSize = UDim2.new(0, 0, 0, 0) tabScroll.Parent = tabBar
local tabLayout = Instance.new("UIListLayout") tabLayout.FillDirection = Enum.FillDirection.Horizontal tabLayout.Padding = UDim.new(0, 4) tabLayout.Parent = tabScroll

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -32, 1, -110) content.Position = UDim2.fromOffset(16, 100)
content.BackgroundTransparency = 1 content.ZIndex = 2 content.Parent = main

local pages = {}
local function makePage(name)
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.fromScale(1, 1) scroll.BackgroundTransparency = 1 scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 2 scroll.ScrollBarImageColor3 = C.border
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y scroll.Visible = false scroll.Parent = content
    registerTheme(scroll, "ScrollBarImageColor3", "border")
    local grid = Instance.new("UIListLayout") grid.Padding = UDim.new(0, 8) grid.Parent = scroll
    local pad = Instance.new("UIPadding") pad.PaddingRight = UDim.new(0, 6) pad.Parent = scroll
    pages[name] = scroll
    return scroll
end

local menuTabs = {"Status", "Main", "RAID", "SEA EVENT", "ISLAND EVENT", "DUNGEON", "QUEST", "SHOP", "MISC", "Farm Settings"}
for _, t in ipairs(menuTabs) do makePage(t) end

local tabButtons = {}
local function switchTab(name)
    CurrentTab = name
    for n, p in pairs(pages) do p.Visible = (n == name) end
    for tName, btn in pairs(tabButtons) do
        local isActive = (tName == name)
        tween(btn, 0.2, {BackgroundColor3 = isActive and C.accent or C.surface, BackgroundTransparency = isActive and 0 or 0.5}):Play()
        tween(btn, 0.2, {TextColor3 = isActive and Color3.fromRGB(20,20,20) or C.textMuted}):Play()
    end
end

local tabWidth = 80
local vp0 = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize
if vp0 and vp0.X < 800 then tabWidth = 60 end

for _, tName in ipairs(menuTabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, tabWidth, 1, 0) btn.BackgroundColor3 = C.surface btn.BackgroundTransparency = 0.5
    btn.AutoButtonColor = false btn.Text = string.upper(tName) btn.TextColor3 = C.textMuted
    btn.Font = Enum.Font.GothamSemibold btn.TextSize = 9 btn.Parent = tabScroll
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(1, 0) c.Parent = btn
    btn.MouseButton1Click:Connect(function() switchTab(tName) end)
    tabButtons[tName] = btn
end

local statusGui = pages["Status"]
statusGui.AutomaticCanvasSize = Enum.AutomaticSize.Y
statusGui.ScrollBarThickness = 0

local profileContainer = Instance.new("Frame") profileContainer.Size = UDim2.new(1, -10, 0, 50) profileContainer.BackgroundTransparency = 1 profileContainer.Parent = statusGui
local avatar = Instance.new("ImageLabel") avatar.Size = UDim2.fromOffset(44, 44) avatar.BackgroundColor3 = C.surface avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LP.UserId .. "&w=150&h=150" avatar.Parent = profileContainer
registerTheme(avatar, "BackgroundColor3", "surface")
local avCorner = Instance.new("UICorner") avCorner.CornerRadius = UDim.new(1, 0) avCorner.Parent = avatar
local avStroke = Instance.new("UIStroke") avStroke.Color = C.accent avStroke.Thickness = 1 avStroke.Transparency = 0.3 avStroke.Parent = avatar
registerTheme(avStroke, "Color", "accent")

local greet = Instance.new("TextLabel") greet.Size = UDim2.new(1, -60, 0, 20) greet.Position = UDim2.fromOffset(54, 4) greet.BackgroundTransparency = 1 greet.Text = "Welcome, " .. LP.DisplayName greet.TextColor3 = C.text greet.Font = Enum.Font.GothamBold greet.TextSize = 14 greet.TextXAlignment = Enum.TextXAlignment.Left greet.Parent = profileContainer
registerTheme(greet, "TextColor3", "text")

local subGreet = Instance.new("TextLabel") subGreet.Size = UDim2.new(1, -60, 0, 14) subGreet.Position = UDim2.fromOffset(54, 24) subGreet.BackgroundTransparency = 1 subGreet.Text = "@" .. LP.Name subGreet.TextColor3 = C.accent subGreet.Font = Enum.Font.Gotham subGreet.TextSize = 10 subGreet.TextXAlignment = Enum.TextXAlignment.Left subGreet.Parent = profileContainer
registerTheme(subGreet, "TextColor3", "accent")

local function createBigBox(titleText)
    local box = Instance.new("Frame")
    box.Size = UDim2.new(1, -10, 0, 0)
    box.AutomaticSize = Enum.AutomaticSize.Y
    box.BackgroundColor3 = C.surface
    box.Parent = statusGui
    registerTheme(box, "BackgroundColor3", "surface")
    local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0, 8) bc.Parent = box
    local bs = Instance.new("UIStroke") bs.Color = C.border bs.Thickness = 1 bs.Transparency = 0.6 bs.Parent = box
    registerTheme(bs, "Color", "border")
    local pad = Instance.new("UIPadding") pad.PaddingTop = UDim.new(0, 10) pad.PaddingBottom = UDim.new(0, 10) pad.PaddingLeft = UDim.new(0, 10) pad.PaddingRight = UDim.new(0, 10) pad.Parent = box
    local layout = Instance.new("UIListLayout") layout.Padding = UDim.new(0, 6) layout.Parent = box
    local lbl = Instance.new("TextLabel") lbl.Size = UDim2.new(1, 0, 0, 15) lbl.BackgroundTransparency = 1 lbl.Text = string.upper(titleText) lbl.TextColor3 = C.accent lbl.Font = Enum.Font.GothamBold lbl.TextSize = 10 lbl.TextXAlignment = Enum.TextXAlignment.Left lbl.Parent = box
    registerTheme(lbl, "TextColor3", "accent")
    return box
end

local function addSmallStat(parent, titleText, initialVal)
    local row = Instance.new("Frame") row.Size = UDim2.new(1, 0, 0, 24) row.BackgroundColor3 = C.surfaceAlt row.Parent = parent
    registerTheme(row, "BackgroundColor3", "surfaceAlt")
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 6) c.Parent = row
    local t = Instance.new("TextLabel") t.Size = UDim2.new(0.5, -5, 1, 0) t.Position = UDim2.fromOffset(8, 0) t.BackgroundTransparency = 1 t.Text = titleText t.TextColor3 = C.textMuted t.Font = Enum.Font.Gotham t.TextSize = 10 t.TextXAlignment = Enum.TextXAlignment.Left t.Parent = row
    registerTheme(t, "TextColor3", "textMuted")
    local v = Instance.new("TextLabel") v.Size = UDim2.new(0.5, -15, 1, 0) v.Position = UDim2.new(0.5, 5, 0, 0) v.BackgroundTransparency = 1 v.Text = initialVal v.TextColor3 = C.text v.Font = Enum.Font.GothamBold v.TextSize = 10 v.TextXAlignment = Enum.TextXAlignment.Right v.Parent = row
    registerTheme(v, "TextColor3", "text")
    return v
end

local accGrid = createBigBox("Account Stats")
addSmallStat(accGrid, "Name", LP.Name)
local valLevel = addSmallStat(accGrid, "Level", "...")
local valRace = addSmallStat(accGrid, "Race", "...")
local valBeli = addSmallStat(accGrid, "Beli", "...")
local valFrag = addSmallStat(accGrid, "Fragments", "...")

local srvGrid = createBigBox("Server Stats")
addSmallStat(srvGrid, "Place ID", tostring(game.PlaceId))
local valSession = addSmallStat(srvGrid, "Session", "...")
local valServerAge = addSmallStat(srvGrid, "Server Age", "...")
local valPrehistoric = addSmallStat(srvGrid, "Prehistoric", "...")
local valMirage = addSmallStat(srvGrid, "Mirage", "...")
local valElite = addSmallStat(srvGrid, "Elite Hunter", "...")

local startTime = tick()
local function formatTime(sec) return tostring(math.floor(sec / 60)).."m "..tostring(math.floor(sec % 60)).."s" end

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local data = LP:FindFirstChild("Data")
            if data then
                if data:FindFirstChild("Level") then valLevel.Text = tostring(data.Level.Value) end
                if data:FindFirstChild("Race") then valRace.Text = tostring(data.Race.Value) end
                if data:FindFirstChild("Beli") then valBeli.Text = tostring(data.Beli.Value) end
                if data:FindFirstChild("Fragments") then valFrag.Text = tostring(data.Fragments.Value) end
            end
            valSession.Text = formatTime(tick() - startTime)
            valServerAge.Text = formatTime(workspace.DistributedGameTime)
            valPrehistoric.Text = (WS:FindFirstChild("Prehistoric Island") or WS:FindFirstChild("PrehistoricIsland")) and "ACTIVE" or "Not Found"
            valPrehistoric.TextColor3 = valPrehistoric.Text == "ACTIVE" and C.accent or C.text
            valMirage.Text = (WS:FindFirstChild("Mirage Island") or WS:FindFirstChild("MirageIsland")) and "ACTIVE" or "Not Found"
            valMirage.TextColor3 = valMirage.Text == "ACTIVE" and C.accent or C.text
            valElite.Text = (WS:FindFirstChild("Elite Hunter") or WS:FindFirstChild("EliteHunter")) and "ACTIVE" or "Not Found"
            valElite.TextColor3 = valElite.Text == "ACTIVE" and C.accent or C.text
        end)
    end
end)

local mainPage = pages["Main"]
createSection(mainPage, "Auto Farm", "Konfigurasi farming level & secret.")
createToggle(mainPage, "Auto Farm Level", "Farms mobs to max level.", SaveData.Toggles["Auto Farm Level"] or false, function(s) _G.KuroAutoFarm = s end)
createToggle(mainPage, "Auto Secret Quests", "Completes Secret Quests.", SaveData.Toggles["Auto Secret Quests"] or false, function(s) _G.KuroAutoSecret = s end)

local raidPage = pages["RAID"]
createSection(raidPage, "Normal Raid", "Fitur untuk semua jenis raid (kecuali Law).")
createToggle(raidPage, "Auto Buy Chip", "Beli chip raid otomatis.", SaveData.Toggles["Auto Buy Chip"] or false, function(s) _G.KuroRaidBuyChip = s end)
createToggle(raidPage, "Auto Farm Raid", "Kill NPC & pindah island.", SaveData.Toggles["Auto Farm Raid"] or false, function(s) _G.KuroRaidFarm = s end)
createToggle(raidPage, "Instant Kill NPC", "Bunuh bos secara instan.", SaveData.Toggles["Instant Kill NPC"] or false, function(s) _G.KuroRaidKill = s end)
createToggle(raidPage, "Auto Start Raid", "Mulai raid otomatis.", SaveData.Toggles["Auto Start Raid"] or false, function(s) _G.KuroRaidStart = s end)
createToggle(raidPage, "Auto Awakening", "Buka awakening fruit otomatis.", SaveData.Toggles["Auto Awakening"] or false, function(s) _G.KuroRaidAwake = s end)

local fsPage = pages["Farm Settings"]
createSection(fsPage, "Buff System", "Nyalain buff secara otomatis saat farm.")
createToggle(fsPage, "Auto Buso", "Auto activates Buso (Armament).", SaveData.Toggles["Auto Buso"] or false, function(s) _G.KuroAutoBuso = s end)
createToggle(fsPage, "Auto Ken", "Auto activates Ken (Observation).", SaveData.Toggles["Auto Ken"] or false, function(s) _G.KuroAutoKen = s end)

local settingsPanel = Instance.new("Frame")
settingsPanel.Size = UDim2.new(1, -32, 1, -110)
settingsPanel.Position = UDim2.fromOffset(16, 100)
settingsPanel.BackgroundTransparency = 1
settingsPanel.Visible = false
settingsPanel.ZIndex = 2
settingsPanel.Parent = main
local spCorner = Instance.new("UICorner") spCorner.CornerRadius = UDim.new(0, 8) spCorner.Parent = settingsPanel
local spScroll = Instance.new("ScrollingFrame") spScroll.Size = UDim2.fromScale(1,1) spScroll.BackgroundTransparency = 1 spScroll.ScrollBarThickness = 2 spScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y spScroll.Parent = settingsPanel
local spLayout = Instance.new("UIListLayout") spLayout.Padding = UDim.new(0, 10) spLayout.Parent = spScroll
local spPad = Instance.new("UIPadding") spPad.PaddingTop = UDim.new(0, 10) spPad.PaddingLeft = UDim.new(0, 10) spPad.PaddingRight = UDim.new(0, 10) spPad.Parent = spScroll

local themeCard = Instance.new("Frame") themeCard.Size = UDim2.new(1, -10, 0, 130) themeCard.BackgroundColor3 = C.surface themeCard.Parent = spScroll
registerTheme(themeCard, "BackgroundColor3", "surface")
local tcCorner = Instance.new("UICorner") tcCorner.CornerRadius = UDim.new(0, 8) tcCorner.Parent = themeCard
local themeLbl = Instance.new("TextLabel") themeLbl.Size = UDim2.new(1, -20, 0, 20) themeLbl.Position = UDim2.fromOffset(10, 8) themeLbl.BackgroundTransparency = 1 themeLbl.Text = "CHANGE THEME" themeLbl.TextColor3 = C.text themeLbl.Font = Enum.Font.GothamBold themeLbl.TextSize = 12 themeLbl.TextXAlignment = Enum.TextXAlignment.Left themeLbl.Parent = themeCard
registerTheme(themeLbl, "TextColor3", "text")

local confirmFrame = Instance.new("Frame")
confirmFrame.Size = UDim2.new(1, -32, 1, -110)
confirmFrame.Position = UDim2.fromOffset(16, 100)
confirmFrame.BackgroundColor3 = C.surface
confirmFrame.Visible = false
confirmFrame.ZIndex = 10
confirmFrame.Active = true
confirmFrame.Parent = main
registerTheme(confirmFrame, "BackgroundColor3", "surface")

local cfCorner = Instance.new("UICorner") cfCorner.CornerRadius = UDim.new(0, 8) cfCorner.Parent = confirmFrame
local cfText = Instance.new("TextLabel") cfText.Size = UDim2.new(1, -20, 0, 40) cfText.Position = UDim2.fromOffset(10, 20) cfText.BackgroundTransparency = 1 cfText.Text = "Yakin mau menutup Kuro Hub?" cfText.TextColor3 = C.text cfText.Font = Enum.Font.GothamBold cfText.TextSize = 14 cfText.TextWrapped = true cfText.Parent = confirmFrame
registerTheme(cfText, "TextColor3", "text")

local yesBtn = Instance.new("TextButton") yesBtn.Size = UDim2.fromOffset(80, 30) yesBtn.Position = UDim2.new(0.5, -90, 1, -50) yesBtn.BackgroundColor3 = Color3.fromRGB(200, 70, 90) yesBtn.Text = "Ya, Tutup" yesBtn.TextColor3 = Color3.new(1,1,1) yesBtn.Font = Enum.Font.GothamBold yesBtn.TextSize = 11 yesBtn.Parent = confirmFrame
local yc = Instance.new("UICorner") yc.CornerRadius = UDim.new(0, 6) yc.Parent = yesBtn
local noBtn = Instance.new("TextButton") noBtn.Size = UDim2.fromOffset(80, 30) noBtn.Position = UDim2.new(0.5, 10, 1, -50) noBtn.BackgroundColor3 = C.surfaceAlt noBtn.Text = "Batal" noBtn.TextColor3 = C.text noBtn.Font = Enum.Font.GothamBold noBtn.TextSize = 11 noBtn.Parent = confirmFrame
registerTheme(noBtn, "BackgroundColor3", "surfaceAlt")
registerTheme(noBtn, "TextColor3", "text")
local nc = Instance.new("UICorner") nc.CornerRadius = UDim.new(0, 6) nc.Parent = noBtn

local function applyTheme(themeName)
    local T = Themes[themeName]
    if not T then return end
    CurrentTheme = themeName
    C.accent=T.accent; C.surface=T.surface; C.surfaceAlt=T.surfaceAlt
    C.bg=T.bg; C.border=T.border; C.text=T.text; C.textMuted=T.textMuted
    applyThemeValues()
    for tName, btn in pairs(tabButtons) do
        local isActive = (tName == CurrentTab)
        btn.BackgroundColor3 = isActive and C.accent or C.surface
        btn.TextColor3 = isActive and Color3.fromRGB(20,20,20) or C.textMuted
    end
    SaveData.Theme = themeName
    writeSave()
end

for i, tName in ipairs(ThemeOrder) do
    local col = (i-1) % 3
    local row = math.floor((i-1)/3)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromOffset(85, 24)
    btn.Position = UDim2.fromOffset(10 + col*90, 35 + row*30)
    btn.BackgroundColor3 = Themes[tName].accent
    btn.Text = tName
    btn.TextColor3 = Color3.fromRGB(0,0,0)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 9
    btn.Parent = themeCard
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 6) c.Parent = btn
    btn.MouseButton1Click:Connect(function() applyTheme(tName) end)
end

local hideBtn = Instance.new("TextButton") hideBtn.Size = UDim2.new(1, -10, 0, 30) hideBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50) hideBtn.Text = "Sembunyikan Hub (Hide)" hideBtn.TextColor3 = Color3.new(1,1,1) hideBtn.Font = Enum.Font.GothamBold hideBtn.Parent = spScroll
local hc = Instance.new("UICorner") hc.CornerRadius = UDim.new(0, 8) hc.Parent = hideBtn

local function minimizeToIsland()
    if IsMinimized then return end
    IsMinimized = true
    saveSize = main.Size
    main.Visible = false
    islandFrame.Visible = true
    local targetSize = islandFrame.Size
    islandFrame.Size = UDim2.fromOffset(0, targetSize.Y.Offset)
    tween(islandFrame, 0.3, {Size = targetSize}, Enum.EasingStyle.Back):Play()
end

local function restoreFromIsland()
    if not IsMinimized then return end
    IsMinimized = false
    tween(islandFrame, 0.3, {Size = UDim2.fromOffset(0, islandFrame.Size.Y.Offset)}, Enum.EasingStyle.Back):Play()
    task.delay(0.3, function()
        islandFrame.Visible = false
        main.Visible = true
        main.AnchorPoint = Vector2.new(0.5, 0.5)
        main.Position = UDim2.fromScale(0.5, 0.5)
        main.Size = saveSize
    end)
end

connect(islandFrame.InputBegan, function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        restoreFromIsland()
    end
end)

hideBtn.MouseButton1Click:Connect(function() settingsPanel.Visible = false; minimizeToIsland() end)
minBtn.MouseButton1Click:Connect(function()
    if settingsPanel.Visible then settingsPanel.Visible = false; content.Visible = true; tabBar.Visible = true; return end
    if IsMinimized then restoreFromIsland() else minimizeToIsland() end
end)

setBtn.MouseButton1Click:Connect(function()
    if IsMinimized then return end
    settingsPanel.Visible = not settingsPanel.Visible
    content.Visible = not settingsPanel.Visible
    tabBar.Visible = not settingsPanel.Visible
end)

closeBtn.MouseButton1Click:Connect(function()
    confirmFrame.Visible = true
end)

noBtn.MouseButton1Click:Connect(function()
    confirmFrame.Visible = false
end)

yesBtn.MouseButton1Click:Connect(function()
    local closeTween = TS:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.fromOffset(0, 0), BackgroundTransparency = 1})
    closeTween:Play()
    TS:Create(mainStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
    closeTween.Completed:Connect(function() gui:Destroy() end)
end)

local dragging = false; local dragInput, dragStart, startPos
local function startDrag(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end
header.InputBegan:Connect(startDrag)

header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging and not IsMinimized then
        local delta = input.Position - dragStart
        local newX = startPos.X.Offset + delta.X
        local newY = startPos.Y.Offset + delta.Y
        local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
        local mainSize = main.AbsoluteSize
        newX = math.clamp(newX, 0, vp.X - mainSize.X)
        newY = math.clamp(newY, 0, vp.Y - mainSize.Y)
        main.Position = UDim2.fromOffset(newX, newY)
    end
end)

gui.Destroying:Connect(function()
    disconnectAll()
    for _, key in ipairs(GLOBAL_KEYS) do _G[key] = false end
end)

if not isValidGame then
    warn("[Kuro-Hub] Script ini hanya untuk Blox Fruits!")
end

switchTab("Status")
applyTheme(CurrentTheme)
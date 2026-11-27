local P = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local CG = game:GetService("CoreGui")
local LP = P.LocalPlayer
local WS = game:GetService("Workspace")

local Themes = {
    Blue = {accent = Color3.fromRGB(0, 140, 255), surface = Color3.fromRGB(22, 28, 40), bg = Color3.fromRGB(15, 18, 26)},
    Purple = {accent = Color3.fromRGB(160, 80, 255), surface = Color3.fromRGB(28, 22, 40), bg = Color3.fromRGB(18, 14, 26)},
    Green = {accent = Color3.fromRGB(50, 220, 120), surface = Color3.fromRGB(20, 35, 28), bg = Color3.fromRGB(14, 22, 18)},
    Red = {accent = Color3.fromRGB(255, 70, 70), surface = Color3.fromRGB(38, 22, 22), bg = Color3.fromRGB(24, 14, 14)},
    Yellow = {accent = Color3.fromRGB(255, 200, 50), surface = Color3.fromRGB(35, 32, 20), bg = Color3.fromRGB(22, 20, 14)}
}

local CurrentTheme = "Blue"
local UI_Scale = 1
local IsMinimized = false
local CurrentTab = "Status"

local C = {
    bg = Themes.Blue.bg, surface = Themes.Blue.surface, surfaceAlt = Color3.fromRGB(30, 38, 55),
    border = Color3.fromRGB(45, 55, 75), accent = Themes.Blue.accent,
    text = Color3.fromRGB(255, 255, 255), textMuted = Color3.fromRGB(140, 150, 170),
}

local function tween(obj, time, props, style)
    return TS:Create(obj, TweenInfo.new(time, style or Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props)
end

local function applyTheme(themeName)
    local t = Themes[themeName]
    if not t then return end
    CurrentTheme = themeName
    C.accent = t.accent
    C.surface = t.surface
    C.bg = t.bg
end

local gui = Instance.new("ScreenGui")
gui.Name = "KuroHubUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.Parent = CG

local main = Instance.new("Frame")
main.Name = "Main"
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)
main.Size = UDim2.fromOffset(650, 420)
main.BackgroundColor3 = C.bg
main.BorderSizePixel = 0
main.Active = true
main.ClipsDescendants = true
main.Parent = gui

local uiScale = Instance.new("UIScale")
uiScale.Scale = UI_Scale
uiScale.Parent = main

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = C.border
mainStroke.Thickness = 1
mainStroke.Parent = main

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = C.surface
header.Parent = main

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

local headerFix = Instance.new("Frame")
headerFix.Size = UDim2.new(1, 0, 0, 10)
headerFix.Position = UDim2.new(0, 0, 1, -10)
headerFix.BackgroundColor3 = C.surface
headerFix.BorderSizePixel = 0
headerFix.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -180, 1, 0)
title.Position = UDim2.fromOffset(20, 0)
title.BackgroundTransparency = 1
title.Text = "Kuro Hub | Blox Fruits"
title.TextColor3 = C.text
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Header Buttons
local btnContainer = Instance.new("Frame")
btnContainer.AnchorPoint = Vector2.new(1, 0.5)
btnContainer.Position = UDim2.new(1, -15, 0.5, 0)
btnContainer.Size = UDim2.fromOffset(110, 30)
btnContainer.BackgroundTransparency = 1
btnContainer.Parent = header

local btnLayout = Instance.new("UIListLayout")
btnLayout.FillDirection = Enum.FillDirection.Horizontal
btnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
btnLayout.Padding = UDim.new(0, 6)
btnLayout.Parent = btnContainer

local function createHeaderBtn(icon, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromOffset(30, 30)
    btn.BackgroundColor3 = C.surfaceAlt
    btn.AutoButtonColor = false
    btn.Text = icon
    btn.TextColor3 = C.text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.LayoutOrder = order
    btn.Parent = btnContainer
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn
    
    btn.MouseEnter:Connect(function() tween(btn, 0.1, {BackgroundColor3 = C.accent}):Play() end)
    btn.MouseLeave:Connect(function() tween(btn, 0.1, {BackgroundColor3 = C.surfaceAlt}):Play() end)
    return btn
end

local setBtn = createHeaderBtn("⚙", 1)
local minBtn = createHeaderBtn("−", 2)
local closeBtn = createHeaderBtn("×", 3)

-- Tab Bar
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, -40, 0, 36)
tabBar.Position = UDim2.fromOffset(20, 60)
tabBar.BackgroundTransparency = 1
tabBar.Parent = main

local tabScroll = Instance.new("ScrollingFrame")
tabScroll.Size = UDim2.fromScale(1, 1)
tabScroll.BackgroundTransparency = 1
tabScroll.ScrollBarThickness = 0
tabScroll.CanvasSize = UDim2.new(0, 800, 0, 0)
tabScroll.Parent = tabBar

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 6)
tabLayout.Parent = tabScroll

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -40, 1, -120)
content.Position = UDim2.fromOffset(20, 105)
content.BackgroundTransparency = 1
content.Parent = main

local pages = {}
local function makePage(name)
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.fromScale(1, 1)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 3
    scroll.ScrollBarImageColor3 = C.border
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.Visible = false
    scroll.Parent = content
    
    local grid = Instance.new("UIGridLayout")
    grid.CellSize = UDim2.new(0, 280, 0, 85)
    grid.CellPadding = UDim2.new(0, 10, 0, 10)
    grid.Parent = scroll
    
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
        btn.BackgroundColor3 = (tName == name) and C.accent or C.surface
        btn.TextColor3 = (tName == name) and Color3.new(1,1,1) or C.textMuted
    end
end

for _, tName in ipairs(menuTabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 1, 0)
    btn.BackgroundColor3 = C.surface
    btn.AutoButtonColor = false
    btn.Text = tName
    btn.TextColor3 = C.textMuted
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 11
    btn.Parent = tabScroll
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn
    
    btn.MouseButton1Click:Connect(function() switchTab(tName) end)
    tabButtons[tName] = btn
end

-- ==========================================
-- STATUS PAGE CUSTOM UI (ALa Maru)
-- ==========================================
local statusGui = pages["Status"]
statusGui.AutomaticCanvasSize = Enum.AutomaticSize.None
statusGui.CanvasSize = UDim2.new(0,0,0,0)

local greet = Instance.new("TextLabel")
greet.Size = UDim2.new(1, -20, 0, 30)
greet.Position = UDim2.fromOffset(10, 5)
greet.BackgroundTransparency = 1
greet.Text = "Status & Informasi"
greet.TextColor3 = C.text
greet.Font = Enum.Font.GothamBold
greet.TextSize = 16
greet.TextXAlignment = Enum.TextXAlignment.Left
greet.Parent = statusGui

local function createGridSection(title, yPos)
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -20, 0, 15)
    titleLbl.Position = UDim2.fromOffset(10, yPos)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.TextColor3 = C.textMuted
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 10
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = statusGui

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -20, 0, 80)
    container.Position = UDim2.fromOffset(10, yPos + 20)
    container.BackgroundTransparency = 1
    container.Parent = statusGui

    local grid = Instance.new("UIGridLayout")
    grid.CellSize = UDim2.new(0, 185, 0, 50)
    grid.CellPadding = UDim2.new(0, 10, 0, 10)
    grid.Parent = container

    return container
end

local function addStatBox(parent, titleText, initialVal)
    local box = Instance.new("Frame")
    box.BackgroundColor3 = C.surface
    box.Parent = parent
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = box
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = C.border
    stroke.Parent = box

    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, -16, 0, 15)
    t.Position = UDim2.fromOffset(8, 8)
    t.BackgroundTransparency = 1
    t.Text = titleText
    t.TextColor3 = C.textMuted
    t.Font = Enum.Font.Gotham
    t.TextSize = 10
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Parent = box

    local v = Instance.new("TextLabel")
    v.Size = UDim2.new(1, -16, 0, 20)
    v.Position = UDim2.fromOffset(8, 23)
    v.BackgroundTransparency = 1
    v.Text = initialVal
    v.TextColor3 = C.text
    v.Font = Enum.Font.GothamBold
    v.TextSize = 12
    v.TextXAlignment = Enum.TextXAlignment.Left
    v.Parent = box

    return v
end

-- Account Section
local accContainer = createGridSection("ACCOUNT INFO", 45)
local valName = addStatBox(accContainer, "Name", LP.Name)
local valLevel = addStatBox(accContainer, "Level", "Loading...")
local valRace = addStatBox(accContainer, "Race", "Loading...")
local valBeli = addStatBox(accContainer, "Beli", "Loading...")
local valFrag = addStatBox(accContainer, "Fragment", "Loading...")

-- Server Section
local srvContainer = createGridSection("SERVER INFO", 155)
local valPlaceId = addStatBox(srvContainer, "Place ID", tostring(game.PlaceId))
local valSession = addStatBox(srvContainer, "Session Time", "0s")
local valServerAge = addStatBox(srvContainer, "Server Age", "0s")
local valPrehistoric = addStatBox(srvContainer, "Prehistoric Island", "Checking...")
local valMirage = addStatBox(srvContainer, "Mirage Island", "Checking...")
local valElite = addStatBox(srvContainer, "Elite Hunter", "Checking...")

-- Logic Update Data
local startTime = tick()

local function formatTime(sec)
    local m = math.floor(sec / 60)
    local s = math.floor(sec % 60)
    return tostring(m).."m "..tostring(s).."s"
end

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            -- Account Stats
            local data = LP:FindFirstChild("Data")
            if data then
                if data:FindFirstChild("Level") then valLevel.Text = tostring(data.Level.Value) end
                if data:FindFirstChild("Race") then valRace.Text = tostring(data.Race.Value) end
                if data:FindFirstChild("Beli") then valBeli.Text = tostring(data.Beli.Value) end
                if data:FindFirstChild("Fragments") then valFrag.Text = tostring(data.Fragments.Value) end
            end

            -- Server Stats
            valSession.Text = formatTime(tick() - startTime)
            valServerAge.Text = formatTime(workspace.DistributedGameTime)

            -- Events Detection (Simple check)
            valPrehistoric.Text = (WS:FindFirstChild("Prehistoric Island") or WS:FindFirstChild("PrehistoricIsland")) and "ACTIVE" or "Not Found"
            valPrehistoric.TextColor3 = valPrehistoric.Text == "ACTIVE" and Color3.fromRGB(50, 255, 50) or C.text
            
            valMirage.Text = (WS:FindFirstChild("Mirage Island") or WS:FindFirstChild("MirageIsland")) and "ACTIVE" or "Not Found"
            valMirage.TextColor3 = valMirage.Text == "ACTIVE" and Color3.fromRGB(50, 255, 50) or C.text
            
            valElite.Text = (WS:FindFirstChild("Elite Hunter") or WS:FindFirstChild("EliteHunter")) and "ACTIVE" or "Not Found"
            valElite.TextColor3 = valElite.Text == "ACTIVE" and Color3.fromRGB(50, 255, 50) or C.text
        end)
    end
end)

-- ==========================================
-- COMPONENTS (Toggle & Settings)
-- ==========================================
local function createCard(parent, titleText, descText, toggleInitial, callback)
    local card = Instance.new("Frame")
    card.BackgroundColor3 = C.surface
    card.Parent = parent
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = card
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = C.border
    stroke.Parent = card
    
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, -20, 0, 20)
    t.Position = UDim2.fromOffset(12, 10)
    t.BackgroundTransparency = 1
    t.Text = titleText
    t.TextColor3 = C.text
    t.Font = Enum.Font.GothamBold
    t.TextSize = 12
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Parent = card
    
    local d = Instance.new("TextLabel")
    d.Size = UDim2.new(1, -60, 0, 30)
    d.Position = UDim2.fromOffset(12, 30)
    d.BackgroundTransparency = 1
    d.Text = descText
    d.TextColor3 = C.textMuted
    d.Font = Enum.Font.Gotham
    d.TextSize = 10
    d.TextWrapped = true
    d.TextXAlignment = Enum.TextXAlignment.Left
    d.TextYAlignment = Enum.TextYAlignment.Top
    d.Parent = card
    
    local toggle = Instance.new("TextButton")
    toggle.AnchorPoint = Vector2.new(1, 0.5)
    toggle.Position = UDim2.new(1, -12, 0.5, 0)
    toggle.Size = UDim2.fromOffset(36, 20)
    toggle.BackgroundColor3 = toggleInitial and C.accent or C.surfaceAlt
    toggle.AutoButtonColor = false
    toggle.Text = ""
    toggle.Parent = card
    
    local tc = Instance.new("UICorner")
    tc.CornerRadius = UDim.new(1, 0)
    tc.Parent = toggle
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(16, 16)
    knob.Position = toggleInitial and UDim2.new(1, -18, 0.5, -8) or UDim.new(0, 2, 0.5, -8)
    knob.BackgroundColor3 = Color3.new(1,1,1)
    knob.Parent = toggle
    
    local kc = Instance.new("UICorner")
    kc.CornerRadius = UDim.new(1, 0)
    kc.Parent = knob
    
    local state = toggleInitial
    toggle.MouseButton1Click:Connect(function()
        state = not state
        tween(knob, 0.15, {Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
        tween(toggle, 0.15, {BackgroundColor3 = state and C.accent or C.surfaceAlt}):Play()
        if callback then callback(state) end
    end)
    
    card.MouseEnter:Connect(function() tween(card, 0.1, {BackgroundColor3 = C.surfaceAlt}):Play() end)
    card.MouseLeave:Connect(function() tween(card, 0.1, {BackgroundColor3 = C.surface}):Play() end)
end

-- SETTINGS PANEL
local settingsPanel = Instance.new("Frame")
settingsPanel.Size = UDim2.new(1, -40, 1, -120)
settingsPanel.Position = UDim2.fromOffset(20, 105)
settingsPanel.BackgroundColor3 = C.bg
settingsPanel.Visible = false
settingsPanel.Parent = main

local spCorner = Instance.new("UICorner")
spCorner.CornerRadius = UDim.new(0, 10)
spCorner.Parent = settingsPanel

local spScroll = Instance.new("ScrollingFrame")
spScroll.Size = UDim2.fromScale(1,1)
spScroll.BackgroundTransparency = 1
spScroll.ScrollBarThickness = 2
spScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
spScroll.Parent = settingsPanel

local spLayout = Instance.new("UIListLayout")
spLayout.Padding = UDim.new(0, 10)
spLayout.Parent = spScroll

-- Theme Setting
local themeCard = Instance.new("Frame")
themeCard.Size = UDim2.new(1, -20, 0, 80)
themeCard.BackgroundColor3 = C.surface
themeCard.Parent = spScroll
local tcCorner = Instance.new("UICorner") tcCorner.CornerRadius = UDim.new(0,8) tcCorner.Parent = themeCard

local themeLbl = Instance.new("TextLabel")
themeLbl.Size = UDim2.new(1, -20, 0, 20)
themeLbl.Position = UDim2.fromOffset(10, 8)
themeLbl.BackgroundTransparency = 1
themeLbl.Text = "Change Theme"
themeLbl.TextColor3 = C.text
themeLbl.Font = Enum.Font.GothamBold
themeLbl.TextSize = 12
themeLbl.TextXAlignment = Enum.TextXAlignment.Left
themeLbl.Parent = themeCard

for i, tName in ipairs({"Blue", "Purple", "Green", "Red", "Yellow"}) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromOffset(50, 20)
    btn.Position = UDim2.fromOffset(10 + ((i-1)*56), 40)
    btn.BackgroundColor3 = Themes[tName].accent
    btn.Text = tName
    btn.TextColor3 = Color3.new(0,0,0)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 9
    btn.Parent = themeCard
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 4)
    c.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        applyTheme(tName)
        main.BackgroundColor3 = C.bg
        header.BackgroundColor3 = C.surface
        headerFix.BackgroundColor3 = C.surface
        for _, t in pairs(tabButtons) do t.BackgroundColor3 = (t.Text == CurrentTab) and C.accent or C.surface end
        setBtn.BackgroundColor3 = C.surfaceAlt
        minBtn.BackgroundColor3 = C.surfaceAlt
        closeBtn.BackgroundColor3 = C.surfaceAlt
    end)
end

-- Scale Setting
local scaleCard = Instance.new("Frame")
scaleCard.Size = UDim2.new(1, -20, 0, 80)
scaleCard.BackgroundColor3 = C.surface
scaleCard.Parent = spScroll
local scCorner = Instance.new("UICorner") scCorner.CornerRadius = UDim.new(0,8) scCorner.Parent = scaleCard

local scaleLbl = Instance.new("TextLabel")
scaleLbl.Size = UDim2.new(1, -20, 0, 20)
scaleLbl.Position = UDim2.fromOffset(10, 8)
scaleLbl.BackgroundTransparency = 1
scaleLbl.Text = "UI Scale"
scaleLbl.TextColor3 = C.text
scaleLbl.Font = Enum.Font.GothamBold
scaleLbl.TextSize = 12
scaleLbl.TextXAlignment = Enum.TextXAlignment.Left
scaleLbl.Parent = scaleCard

for i, s in ipairs({0.8, 1.0, 1.2, 1.4}) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromOffset(50, 20)
    btn.Position = UDim2.fromOffset(10 + ((i-1)*56), 40)
    btn.BackgroundColor3 = (s == UI_Scale) and C.accent or C.surfaceAlt
    btn.Text = tostring(s) .. "x"
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 9
    btn.Parent = scaleCard
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 4)
    c.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        UI_Scale = s
        tween(uiScale, 0.2, {Scale = UI_Scale}):Play()
        for _, child in pairs(scaleCard:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = (child.Text == tostring(s).."x") and C.accent or C.surfaceAlt
            end
        end
    end)
end

-- Hide Button
local hideBtn = Instance.new("TextButton")
hideBtn.Size = UDim2.new(1, -20, 0, 30)
hideBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
hideBtn.Text = "Sembunyikan Hub (Hide)"
hideBtn.TextColor3 = Color3.new(1,1,1)
hideBtn.Font = Enum.Font.GothamBold
hideBtn.Parent = spScroll
local hc = Instance.new("UICorner") hc.CornerRadius = UDim.new(0,8) hc.Parent = hideBtn

hideBtn.MouseButton1Click:Connect(function()
    settingsPanel.Visible = false
    IsMinimized = true
    tween(main, 0.4, {
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 15),
        Size = UDim2.fromOffset(280, 40),
        BackgroundTransparency = 0
    }, Enum.EasingStyle.Back):Play()
    tabBar.Visible = false
    content.Visible = false
    title.Text = "Kuro Island"
    title.TextSize = 13
    minBtn.Text = "□"
end)

-- MINIMIZE (Dynamic Island Logic)
minBtn.MouseButton1Click:Connect(function()
    if settingsPanel.Visible then
        settingsPanel.Visible = false
        content.Visible = true
        return
    end
    
    IsMinimized = not IsMinimized
    
    if IsMinimized then
        tween(main, 0.4, {
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.new(0.5, 0, 0, 15),
            Size = UDim2.fromOffset(280, 40),
            BackgroundTransparency = 0
        }, Enum.EasingStyle.Back):Play()
        tabBar.Visible = false
        content.Visible = false
        title.Text = "KuroHub"
        title.TextSize = 13
        minBtn.Text = "□"
    else
        tween(main, 0.4, {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(650, 420),
            BackgroundTransparency = 0
        }, Enum.EasingStyle.Back):Play()
        tabBar.Visible = true
        content.Visible = true
        title.Text = "Kuro Hub | Blox Fruits"
        title.TextSize = 15
        minBtn.Text = "−"
    end
end)

-- Klik Dimana Aja Pas Minimized Buat Balik
main.InputBegan:Connect(function(input)
    if IsMinimized and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        IsMinimized = false
        tween(main, 0.4, {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(650, 420),
            BackgroundTransparency = 0
        }, Enum.EasingStyle.Back):Play()
        tabBar.Visible = true
        content.Visible = true
        title.Text = "Kuro Hub | Blox Fruits"
        title.TextSize = 15
        minBtn.Text = "−"
    end
end)

-- SETTINGS BUTTON
setBtn.MouseButton1Click:Connect(function()
    if IsMinimized then return end
    settingsPanel.Visible = not settingsPanel.Visible
    content.Visible = not settingsPanel.Visible
    tabBar.Visible = not settingsPanel.Visible
end)

-- CLOSE BUTTON
closeBtn.MouseButton1Click:Connect(function()
    local closeTween = TS:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.fromOffset(0, 0), BackgroundTransparency = 1})
    closeTween:Play()
    TS:Create(mainStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
    closeTween.Completed:Connect(function() gui:Destroy() end)
end)

-- DRAG
local dragging = false
local dragInput, dragStart, startPos
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- DEFAULT CARDS
createCard(pages["Main"], "Auto Farm Level", "Farms mobs to max level.", false, function(s) print("Auto Farm:", s) end)
createCard(pages["Main"], "Auto Secret Quests", "Completes Secret Quests.", false, function(s) print("Secret:", s) end)
createCard(pages["Farm Settings"], "Auto Buso", "Auto activates Buso.", false, function(s) print("Buso:", s) end)
createCard(pages["Farm Settings"], "Auto Ken", "Auto activates Ken.", false, function(s) print("Ken:", s) end)

switchTab("Status")
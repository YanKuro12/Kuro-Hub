local P = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local CG = game:GetService("CoreGui")
local LP = P.LocalPlayer
local WS = game:GetService("Workspace")

local Themes = {
    Blue = {accent = Color3.fromRGB(0, 200, 255), surface = Color3.fromRGB(18, 24, 38), bg = Color3.fromRGB(10, 14, 22)},
    Purple = {accent = Color3.fromRGB(190, 80, 255), surface = Color3.fromRGB(24, 18, 38), bg = Color3.fromRGB(12, 10, 20)},
    Green = {accent = Color3.fromRGB(50, 255, 150), surface = Color3.fromRGB(16, 28, 22), bg = Color3.fromRGB(8, 16, 12)},
    Red = {accent = Color3.fromRGB(255, 60, 80), surface = Color3.fromRGB(32, 16, 20), bg = Color3.fromRGB(18, 8, 10)},
    Yellow = {accent = Color3.fromRGB(255, 220, 50), surface = Color3.fromRGB(30, 26, 16), bg = Color3.fromRGB(16, 14, 8)}
}

local CurrentTheme = "Blue"
local IsMinimized = false
local CurrentTab = "Status"

local C = {
    bg = Themes.Blue.bg, surface = Themes.Blue.surface, surfaceAlt = Color3.fromRGB(28, 36, 52),
    border = Color3.fromRGB(45, 65, 95), accent = Themes.Blue.accent,
    text = Color3.fromRGB(255, 255, 255), textMuted = Color3.fromRGB(160, 175, 195),
}

local function tween(obj, time, props, style)
    return TS:Create(obj, TweenInfo.new(time, style or Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props)
end

local function createCard(parent, titleText, descText, toggleInitial, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -10, 0, 85)
    card.BackgroundColor3 = C.surface
    card.Parent = parent
    
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 8) c.Parent = card
    
    local stroke = Instance.new("UIStroke") stroke.Color = C.border stroke.Thickness = 1 stroke.Parent = card
    
    local t = Instance.new("TextLabel") t.Size = UDim2.new(1, -60, 0, 20) t.Position = UDim2.fromOffset(12, 10) t.BackgroundTransparency = 1 t.Text = titleText t.TextColor3 = C.text t.Font = Enum.Font.GothamBold t.TextSize = 12 t.TextXAlignment = Enum.TextXAlignment.Left t.Parent = card
    
    local d = Instance.new("TextLabel") d.Size = UDim2.new(1, -60, 0, 30) d.Position = UDim2.fromOffset(12, 30) d.BackgroundTransparency = 1 d.Text = descText d.TextColor3 = C.textMuted d.Font = Enum.Font.Gotham d.TextSize = 10 d.TextWrapped = true d.TextXAlignment = Enum.TextXAlignment.Left d.TextYAlignment = Enum.TextYAlignment.Top d.Parent = card
    
    local toggle = Instance.new("TextButton") toggle.AnchorPoint = Vector2.new(1, 0.5) toggle.Position = UDim2.new(1, -12, 0.5, 0) toggle.Size = UDim2.fromOffset(36, 20) toggle.BackgroundColor3 = toggleInitial and C.accent or C.surfaceAlt toggle.AutoButtonColor = false toggle.Text = "" toggle.Parent = card
    
    local tc = Instance.new("UICorner") tc.CornerRadius = UDim.new(1, 0) tc.Parent = toggle
    local knob = Instance.new("Frame") knob.Size = UDim2.fromOffset(16, 16) knob.Position = toggleInitial and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8) knob.BackgroundColor3 = Color3.new(1,1,1) knob.Parent = toggle
    local kc = Instance.new("UICorner") kc.CornerRadius = UDim.new(1, 0) kc.Parent = knob
    
    local state = toggleInitial
    toggle.MouseButton1Click:Connect(function()
        state = not state
        tween(knob, 0.15, {Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
        tween(toggle, 0.15, {BackgroundColor3 = state and C.accent or C.surfaceAlt}):Play()
        if callback then callback(state) end
    end)
    
    card.MouseEnter:Connect(function() tween(stroke, 0.2, {Color = C.accent, Thickness = 2}):Play() tween(card, 0.2, {BackgroundColor3 = C.surfaceAlt}):Play() end)
    card.MouseLeave:Connect(function() tween(stroke, 0.2, {Color = C.border, Thickness = 1}):Play() tween(card, 0.2, {BackgroundColor3 = C.surface}):Play() end)
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
main.Size = UDim2.fromOffset(500, 380)
main.BackgroundColor3 = C.bg
main.BorderSizePixel = 0
main.Active = true
main.ClipsDescendants = true
main.Parent = gui

local uiScale = Instance.new("UIScale")
uiScale.Parent = main

local function updateScale()
    local vp = workspace.CurrentCamera.ViewportSize
    local sx = (vp.X * 0.9) / 500
    local sy = (vp.Y * 0.8) / 380
    uiScale.Scale = math.clamp(math.min(sx, sy), 0.5, 1.0)
end
updateScale()
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)

local mainCorner = Instance.new("UICorner") mainCorner.CornerRadius = UDim.new(0, 12) mainCorner.Parent = main
local mainStroke = Instance.new("UIStroke") mainStroke.Color = C.border mainStroke.Thickness = 1 mainStroke.Parent = main

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 45)
header.BackgroundColor3 = C.surface
header.Parent = main
local headerCorner = Instance.new("UICorner") headerCorner.CornerRadius = UDim.new(0, 12) headerCorner.Parent = header
local headerFix = Instance.new("Frame") headerFix.Size = UDim2.new(1, 0, 0, 10) headerFix.Position = UDim2.new(0, 0, 1, -10) headerFix.BackgroundColor3 = C.surface headerFix.BorderSizePixel = 0 headerFix.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -130, 1, 0) -- Kasih ruang lebih buat tombol
title.Position = UDim2.fromOffset(15, 0)
title.BackgroundTransparency = 1
title.Text = "Kuro Hub | Blox Fruits"
title.TextColor3 = C.text
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local btnContainer = Instance.new("Frame")
btnContainer.AnchorPoint = Vector2.new(1, 0.5)
btnContainer.Position = UDim2.new(1, -10, 0.5, 0)
btnContainer.Size = UDim2.fromOffset(90, 25)
btnContainer.BackgroundTransparency = 1
btnContainer.Parent = header
local btnLayout = Instance.new("UIListLayout") btnLayout.FillDirection = Enum.FillDirection.Horizontal btnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right btnLayout.Padding = UDim.new(0, 5) btnLayout.Parent = btnContainer

local function createHeaderBtn(icon, order, hoverColor)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromOffset(25, 25)
    btn.BackgroundColor3 = C.surfaceAlt
    btn.AutoButtonColor = false
    btn.Text = icon
    btn.TextColor3 = C.text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.LayoutOrder = order
    btn.Parent = btnContainer
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 6) c.Parent = btn
    local stroke = Instance.new("UIStroke") stroke.Color = Color3.new(0,0,0) stroke.Transparency = 1 stroke.Parent = btn
    
    btn.MouseEnter:Connect(function() tween(btn, 0.1, {BackgroundColor3 = hoverColor}):Play() tween(stroke, 0.1, {Transparency = 0, Color = hoverColor}):Play() end)
    btn.MouseLeave:Connect(function() tween(btn, 0.1, {BackgroundColor3 = C.surfaceAlt}):Play() tween(stroke, 0.1, {Transparency = 1}):Play() end)
    return btn
end

local setBtn = createHeaderBtn("⚙", 1, C.accent)
local minBtn = createHeaderBtn("−", 2, C.accent)
local closeBtn = createHeaderBtn("×", 3, Color3.fromRGB(255, 60, 80))

local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, -30, 0, 32)
tabBar.Position = UDim2.fromOffset(15, 55)
tabBar.BackgroundTransparency = 1
tabBar.Parent = main
local tabScroll = Instance.new("ScrollingFrame") tabScroll.Size = UDim2.fromScale(1, 1) tabScroll.BackgroundTransparency = 1 tabScroll.ScrollBarThickness = 0 tabScroll.CanvasSize = UDim2.new(0, 800, 0, 0) tabScroll.Parent = tabBar
local tabLayout = Instance.new("UIListLayout") tabLayout.FillDirection = Enum.FillDirection.Horizontal tabLayout.Padding = UDim.new(0, 5) tabLayout.Parent = tabScroll

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -30, 1, -100)
content.Position = UDim2.fromOffset(15, 95)
content.BackgroundTransparency = 1
content.Parent = main

local pages = {}
local function makePage(name)
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.fromScale(1, 1)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 2
    scroll.ScrollBarImageColor3 = C.border
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.Visible = false
    scroll.Parent = content
    local grid = Instance.new("UIListLayout") grid.Padding = UDim.new(0, 8) grid.Parent = scroll
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
        tween(btn, 0.15, {BackgroundColor3 = isActive and C.accent or C.surface}):Play()
        tween(btn, 0.15, {TextColor3 = isActive and Color3.new(1,1,1) or C.textMuted}):Play()
    end
end

for _, tName in ipairs(menuTabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 90, 1, 0)
    btn.BackgroundColor3 = C.surface
    btn.AutoButtonColor = false
    btn.Text = tName
    btn.TextColor3 = C.textMuted
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 10
    btn.Parent = tabScroll
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 5) c.Parent = btn
    btn.MouseButton1Click:Connect(function() switchTab(tName) end)
    tabButtons[tName] = btn
end

-- STATUS PAGE
local statusGui = pages["Status"]
statusGui.AutomaticCanvasSize = Enum.AutomaticSize.Y
statusGui.ScrollBarThickness = 0

local profileContainer = Instance.new("Frame") profileContainer.Size = UDim2.new(1, -10, 0, 50) profileContainer.BackgroundTransparency = 1 profileContainer.Parent = statusGui
local avatar = Instance.new("ImageLabel") avatar.Size = UDim2.fromOffset(45, 45) avatar.BackgroundColor3 = C.surface avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LP.UserId .. "&w=150&h=150" avatar.Parent = profileContainer
local avCorner = Instance.new("UICorner") avCorner.CornerRadius = UDim.new(1, 0) avCorner.Parent = avatar
local greet = Instance.new("TextLabel") greet.Size = UDim2.new(1, -60, 0, 20) greet.Position = UDim2.fromOffset(55, 5) greet.BackgroundTransparency = 1 greet.Text = "Hi, " .. LP.DisplayName greet.TextColor3 = C.text greet.Font = Enum.Font.GothamBold greet.TextSize = 15 greet.TextXAlignment = Enum.TextXAlignment.Left greet.Parent = profileContainer
local subGreet = Instance.new("TextLabel") subGreet.Size = UDim2.new(1, -60, 0, 15) subGreet.Position = UDim2.fromOffset(55, 25) subGreet.BackgroundTransparency = 1 subGreet.Text = "User: " .. LP.Name subGreet.TextColor3 = C.textMuted subGreet.Font = Enum.Font.Gotham subGreet.TextSize = 11 subGreet.TextXAlignment = Enum.TextXAlignment.Left subGreet.Parent = profileContainer

local function createBigBox(titleText)
    local box = Instance.new("Frame") box.Size = UDim2.new(1, -10, 0, 0) box.AutomaticSize = Enum.AutomaticSize.Y box.BackgroundColor3 = C.surface box.Parent = statusGui
    local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0, 8) bc.Parent = box
    local bs = Instance.new("UIStroke") bs.Color = C.border bs.Thickness = 1 bs.Parent = box
    local pad = Instance.new("UIPadding") pad.PaddingTop = UDim.new(0, 8) pad.PaddingBottom = UDim.new(0, 8) pad.PaddingLeft = UDim.new(0, 8) pad.PaddingRight = UDim.new(0, 8) pad.Parent = box
    local layout = Instance.new("UIListLayout") layout.Padding = UDim.new(0, 8) layout.Parent = box
    local lbl = Instance.new("TextLabel") lbl.Size = UDim2.new(1, 0, 0, 15) lbl.BackgroundTransparency = 1 lbl.Text = titleText lbl.TextColor3 = C.accent lbl.Font = Enum.Font.GothamBold lbl.TextSize = 11 lbl.TextXAlignment = Enum.TextXAlignment.Left lbl.Parent = box
    return box
end

local function addSmallStat(parent, titleText, initialVal)
    local row = Instance.new("Frame") row.Size = UDim2.new(1, 0, 0, 25) row.BackgroundColor3 = C.surfaceAlt row.Parent = parent
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 5) c.Parent = row
    local t = Instance.new("TextLabel") t.Size = UDim2.new(0.5, -5, 1, 0) t.Position = UDim2.fromOffset(8, 0) t.BackgroundTransparency = 1 t.Text = titleText t.TextColor3 = C.textMuted t.Font = Enum.Font.Gotham t.TextSize = 10 t.TextXAlignment = Enum.TextXAlignment.Left t.Parent = row
    local v = Instance.new("TextLabel") v.Size = UDim2.new(0.5, -5, 1, 0) v.Position = UDim2.new(0.5, 5, 0, 0) v.BackgroundTransparency = 1 v.Text = initialVal v.TextColor3 = C.text v.Font = Enum.Font.GothamBold v.TextSize = 10 v.TextXAlignment = Enum.TextXAlignment.Right v.Parent = row
    return v
end

local accGrid = createBigBox("ACCOUNT STATS")
addSmallStat(accGrid, "Name", LP.Name)
local valLevel = addSmallStat(accGrid, "Level", "...")
local valRace = addSmallStat(accGrid, "Race", "...")
local valBeli = addSmallStat(accGrid, "Beli", "...")
local valFrag = addSmallStat(accGrid, "Fragments", "...")

local srvGrid = createBigBox("SERVER STATS")
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

-- SETTINGS
local settingsPanel = Instance.new("Frame") settingsPanel.Size = UDim2.new(1, -30, 1, -100) settingsPanel.Position = UDim2.fromOffset(15, 95) settingsPanel.BackgroundColor3 = C.bg settingsPanel.Visible = false settingsPanel.Parent = main
local spCorner = Instance.new("UICorner") spCorner.CornerRadius = UDim.new(0, 8) spCorner.Parent = settingsPanel
local spScroll = Instance.new("ScrollingFrame") spScroll.Size = UDim2.fromScale(1,1) spScroll.BackgroundTransparency = 1 spScroll.ScrollBarThickness = 2 spScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y spScroll.Parent = settingsPanel
local spLayout = Instance.new("UIListLayout") spLayout.Padding = UDim.new(0, 10) spLayout.Parent = spScroll
local spPad = Instance.new("UIPadding") spPad.PaddingTop = UDim.new(0, 10) spPad.PaddingLeft = UDim.new(0, 10) spPad.PaddingRight = UDim.new(0, 10) spPad.Parent = spScroll

local themeCard = Instance.new("Frame") themeCard.Size = UDim2.new(1, 0, 0, 80) themeCard.BackgroundColor3 = C.surface themeCard.Parent = spScroll
local tcCorner = Instance.new("UICorner") tcCorner.CornerRadius = UDim.new(0,8) tcCorner.Parent = themeCard
local themeLbl = Instance.new("TextLabel") themeLbl.Size = UDim2.new(1, -20, 0, 20) themeLbl.Position = UDim2.fromOffset(10, 8) themeLbl.BackgroundTransparency = 1 themeLbl.Text = "Change Theme" themeLbl.TextColor3 = C.text themeLbl.Font = Enum.Font.GothamBold themeLbl.TextSize = 12 themeLbl.TextXAlignment = Enum.TextXAlignment.Left themeLbl.Parent = themeCard

for i, tName in ipairs({"Blue", "Purple", "Green", "Red", "Yellow"}) do
    local btn = Instance.new("TextButton") btn.Size = UDim2.fromOffset(50, 20) btn.Position = UDim2.fromOffset(10 + ((i-1)*56), 40) btn.BackgroundColor3 = Themes[tName].accent btn.Text = tName btn.TextColor3 = Color3.new(0,0,0) btn.Font = Enum.Font.GothamBold btn.TextSize = 9 btn.Parent = themeCard
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 4) c.Parent = btn
    btn.MouseButton1Click:Connect(function()
        C.accent = Themes[tName].accent; C.surface = Themes[tName].surface; C.bg = Themes[tName].bg
        main.BackgroundColor3 = C.bg; header.BackgroundColor3 = C.surface; headerFix.BackgroundColor3 = C.surface
        mainStroke.Color = C.border
        -- FIX UTAMA: Update teks tab biar ga ilang
        for tName, t in pairs(tabButtons) do
            t.BackgroundColor3 = (tName == CurrentTab) and C.accent or C.surface
            t.TextColor3 = (tName == CurrentTab) and Color3.new(1,1,1) or C.textMuted
        end
        -- Update header button text color
        for _, btn in ipairs(btnContainer:GetChildren()) do
            if btn:IsA("TextButton") then btn.TextColor3 = C.text end
        end
    end)
end

local hideBtn = Instance.new("TextButton") hideBtn.Size = UDim2.new(1, 0, 0, 30) hideBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50) hideBtn.Text = "Sembunyikan Hub (Hide)" hideBtn.TextColor3 = Color3.new(1,1,1) hideBtn.Font = Enum.Font.GothamBold hideBtn.Parent = spScroll
local hc = Instance.new("UICorner") hc.CornerRadius = UDim.new(0,8) hc.Parent = hideBtn
hideBtn.MouseButton1Click:Connect(function()
    settingsPanel.Visible = false
    IsMinimized = true
    tween(main, 0.4, {AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 15), Size = UDim2.fromOffset(280, 40), BackgroundTransparency = 0}, Enum.EasingStyle.Back):Play()
    tabBar.Visible = false; content.Visible = false; title.Text = "Kuro Island"; title.TextSize = 13; minBtn.Text = "□"
end)

minBtn.MouseButton1Click:Connect(function()
    if settingsPanel.Visible then settingsPanel.Visible = false; content.Visible = true; return end
    IsMinimized = not IsMinimized
    if IsMinimized then
        tween(main, 0.4, {AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 15), Size = UDim2.fromOffset(280, 40), BackgroundTransparency = 0}, Enum.EasingStyle.Back):Play()
        tabBar.Visible = false; content.Visible = false; title.Text = "Kuro Island"; title.TextSize = 13; minBtn.Text = "□"
    else
        tween(main, 0.4, {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(500, 380), BackgroundTransparency = 0}, Enum.EasingStyle.Back):Play()
        tabBar.Visible = true; content.Visible = true; title.Text = "Kuro Hub | Blox Fruits"; title.TextSize = 14; minBtn.Text = "−"
    end
end)

main.InputBegan:Connect(function(input)
    if IsMinimized and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        IsMinimized = false
        tween(main, 0.4, {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(500, 380), BackgroundTransparency = 0}, Enum.EasingStyle.Back):Play()
        tabBar.Visible = true; content.Visible = true; title.Text = "Kuro Hub | Blox Fruits"; title.TextSize = 14; minBtn.Text = "−"
    end
end)

setBtn.MouseButton1Click:Connect(function()
    if IsMinimized then return end
    settingsPanel.Visible = not settingsPanel.Visible
    content.Visible = not settingsPanel.Visible
    tabBar.Visible = not settingsPanel.Visible
end)

closeBtn.MouseButton1Click:Connect(function()
    local closeTween = TS:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.fromOffset(0, 0), BackgroundTransparency = 1})
    closeTween:Play()
    TS:Create(mainStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
    closeTween.Completed:Connect(function() gui:Destroy() end)
end)

local dragging = false
local dragInput, dragStart, startPos
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = main.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
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

local resizeBtn = Instance.new("TextButton")
resizeBtn.Size = UDim2.fromOffset(15, 15)
resizeBtn.Position = UDim2.new(1, -15, 1, -15)
resizeBtn.BackgroundColor3 = C.accent
resizeBtn.Text = ""
resizeBtn.Parent = main
local rc = Instance.new("UICorner") rc.CornerRadius = UDim.new(0, 4) rc.Parent = resizeBtn

local resizing = false
local resizeStart, startSize
resizeBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        resizing = true; resizeStart = input.Position; startSize = main.Size
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then resizing = false end end)
    end
end)
UIS.InputChanged:Connect(function(input)
    if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - resizeStart
        main.Size = UDim2.fromOffset(math.clamp(startSize.X.Offset + delta.X, 300, 800), math.clamp(startSize.Y.Offset + delta.Y, 250, 600))
    end
end)

createCard(pages["Main"], "Auto Farm Level", "Farms mobs to max level.", false, function(s) print("Auto Farm:", s) end)
createCard(pages["Main"], "Auto Secret Quests", "Completes Secret Quests.", false, function(s) print("Secret:", s) end)
createCard(pages["Farm Settings"], "Auto Buso", "Auto activates Buso.", false, function(s) print("Buso:", s) end)
createCard(pages["Farm Settings"], "Auto Ken", "Auto activates Ken.", false, function(s) print("Ken:", s) end)

switchTab("Status")
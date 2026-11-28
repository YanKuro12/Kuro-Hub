local P = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local LP = P.LocalPlayer
local WS = game:GetService("Workspace")

local function safeHttpGet(url)
    local success, result = pcall(function()
        if game.HttpGet then
            return game:HttpGet(url)
        elseif syn and syn.request then
            return syn.request({Url = url, Method = "GET"}).Body
        elseif http_request then
            return http_request({Url = url, Method = "GET"}).Body
        elseif request then
            return request({Url = url, Method = "GET"}).Body
        else
            return game:HttpGet(url)
        end
    end)
    return success and result or nil
end

local THEMES_URL = "https://raw.githubusercontent.com/YanKuro12/Kuro-Hub/main/themes.lua"
local RESPONSIVE_URL = "https://raw.githubusercontent.com/YanKuro12/Kuro-Hub/main/responsive.lua"

local Themes, Responsive
pcall(function()
    local data = safeHttpGet(THEMES_URL)
    if data then Themes = loadstring(data)() end
end)

pcall(function()
    local data = safeHttpGet(RESPONSIVE_URL)
    if data then Responsive = loadstring(data)() end
end)

if not Themes then
    Themes = {
        Gold = {
            name="Gold", accent=Color3.fromRGB(218,180,90), accent2=Color3.fromRGB(255,225,150),
            surface=Color3.fromRGB(24,24,28), surfaceAlt=Color3.fromRGB(34,34,40),
            bg=Color3.fromRGB(14,14,17), border=Color3.fromRGB(65,60,45),
            text=Color3.fromRGB(245,243,235), textMuted=Color3.fromRGB(160,158,150),
            font=Enum.Font.GothamBold, fontBody=Enum.Font.Gotham,
            corner=14, cornerHeader=18, strokeThickness=1, strokeTransparency=0.4,
            tabStyle="pill", glow=true, particles="✨", particleColor=Color3.fromRGB(255,220,120),
            glass=0.85, shimmer=true, sound="rbxassetid://6944742108",
        },
    }
end
local ThemeOrder = {"Gold","Obsidian","Halloween","Hacker","Christmas","Valentine","Neon","Cyberpunk","Custom"}

_G.KuroAutoFarm = false; _G.KuroAutoSecret = false; _G.KuroAutoBuso = false
_G.KuroAutoKen = false; _G.KuroRaidBuyChip = false; _G.KuroRaidFarm = false
_G.KuroRaidKill = false; _G.KuroRaidStart = false; _G.KuroRaidAwake = false

local IsMinimized = false
local CurrentTab = "Status"
local CurrentTheme = "Gold"

local C = {
    bg = Themes.Gold.bg, surface = Themes.Gold.surface, surfaceAlt = Themes.Gold.surfaceAlt,
    border = Themes.Gold.border, accent = Themes.Gold.accent,
    text = Themes.Gold.text, textMuted = Themes.Gold.textMuted,
}

local function tween(obj, time, props, style)
    return TS:Create(obj, TweenInfo.new(time, style or Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props)
end

local function playClick(T)
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = T.sound or "rbxassetid://6944742108"
        s.Volume = 0.22; s.PlaybackSpeed = 1.1
        s.Parent = SoundService; s:Play()
        task.delay(2, function() s:Destroy() end)
    end)
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
end

local function createToggle(parent, titleText, descText, toggleInitial, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -10, 0, 58)
    card.BackgroundColor3 = C.surface
    card.Parent = parent
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 8) c.Parent = card
    local stroke = Instance.new("UIStroke") stroke.Color = C.border stroke.Thickness = 1 stroke.Transparency = 0.6 stroke.Parent = card

    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, -80, 0, 18) t.Position = UDim2.fromOffset(12, 10)
    t.BackgroundTransparency = 1 t.Text = titleText t.TextColor3 = C.text
    t.Font = Enum.Font.GothamSemibold t.TextSize = 12 t.TextXAlignment = Enum.TextXAlignment.Left t.Parent = card

    local d = Instance.new("TextLabel")
    d.Size = UDim2.new(1, -80, 0, 14) d.Position = UDim2.fromOffset(12, 28)
    d.BackgroundTransparency = 1 d.Text = descText d.TextColor3 = C.textMuted
    d.Font = Enum.Font.Gotham d.TextSize = 9 d.TextXAlignment = Enum.TextXAlignment.Left d.Parent = card

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
    toggle.MouseButton1Click:Connect(function()
        state = not state
        tween(knob, 0.2, {Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)}):Play()
        tween(toggle, 0.2, {BackgroundColor3 = state and C.accent or C.surfaceAlt}):Play()
        tween(stroke, 0.2, {Color = state and C.accent or C.border, Transparency = state and 0.2 or 0.6}):Play()
        if callback then callback(state) end
    end)
end

local function createDropdown(parent, titleText, options, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -10, 0, 60)
    card.BackgroundColor3 = C.surface
    card.Parent = parent
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 8) c.Parent = card
    local stroke = Instance.new("UIStroke") stroke.Color = C.border stroke.Thickness = 1 stroke.Transparency = 0.6 stroke.Parent = card

    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, -24, 0, 18) t.Position = UDim2.fromOffset(12, 8)
    t.BackgroundTransparency = 1 t.Text = titleText t.TextColor3 = C.text
    t.Font = Enum.Font.GothamSemibold t.TextSize = 11 t.TextXAlignment = Enum.TextXAlignment.Left t.Parent = card

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -24, 0, 24) btn.Position = UDim2.fromOffset(12, 26)
    btn.BackgroundColor3 = C.surfaceAlt btn.AutoButtonColor = false
    btn.Text = "  " .. options[1] .. "  ▾" btn.TextColor3 = C.accent
    btn.Font = Enum.Font.GothamSemibold btn.TextSize = 10
    btn.TextXAlignment = Enum.TextXAlignment.Left btn.Parent = card
    local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0, 6) bc.Parent = btn

    local idx = 1
    btn.MouseButton1Click:Connect(function()
        idx = idx + 1
        if idx > #options then idx = 1 end
        btn.Text = "  " .. options[idx] .. "  ▾"
        if callback then callback(options[idx]) end
    end)
end

local gui = Instance.new("ScreenGui")
gui.Name = "KuroHubUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999

local successCore, errCore = pcall(function()
    gui.Parent = game:GetService("CoreGui")
end)

if not successCore then
    gui.Parent = LP:WaitForChild("PlayerGui")
end

local main = Instance.new("Frame")
main.Name = "Main"
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)
main.Size = UDim2.fromOffset(500, 380)
main.BackgroundColor3 = C.bg
main.BackgroundTransparency = 1
main.BorderSizePixel = 0
main.Active = true
main.ClipsDescendants = true
main.Parent = gui

if Responsive and Responsive.Apply then
    Responsive.Apply(main, Vector2.new(500, 380))
else
    local uiScale = Instance.new("UIScale")
    uiScale.Parent = main
    local function updateScale()
        local vp = workspace.CurrentCamera.ViewportSize
        local sx = (vp.X * 0.9) / 500
        local sy = (vp.Y * 0.9) / 380
        uiScale.Scale = math.clamp(math.min(sx, sy), 0.5, 1.1)
    end
    updateScale()
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
end

local mainCorner = Instance.new("UICorner") mainCorner.CornerRadius = UDim.new(0, 14) mainCorner.Parent = main
local mainStroke = Instance.new("UIStroke") mainStroke.Color = C.border mainStroke.Thickness = 1 mainStroke.Transparency = 0.4 mainStroke.Parent = main

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = C.surface
header.ZIndex = 2
header.Parent = main
local headerCorner = Instance.new("UICorner") headerCorner.CornerRadius = UDim.new(0, 14) headerCorner.Parent = header
local headerFix = Instance.new("Frame") headerFix.Size = UDim2.new(1, 0, 0, 10) headerFix.Position = UDim2.new(0, 0, 1, -10) headerFix.BackgroundColor3 = C.surface headerFix.BorderSizePixel = 0 headerFix.ZIndex = 2 headerFix.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -180, 1, 0) title.Position = UDim2.fromOffset(16, 0)
title.BackgroundTransparency = 1 title.Text = "KURO HUB"
title.TextColor3 = C.text title.Font = Enum.Font.GothamBold
title.TextSize = 15 title.TextXAlignment = Enum.TextXAlignment.Left title.ZIndex = 3 title.Parent = header

local searchFrame = Instance.new("Frame")
searchFrame.AnchorPoint = Vector2.new(1, 0.5) searchFrame.Position = UDim2.new(1, -130, 0.5, 0)
searchFrame.Size = UDim2.fromOffset(100, 24) searchFrame.BackgroundColor3 = C.surfaceAlt searchFrame.ZIndex = 3 searchFrame.Parent = header
local searchCorner = Instance.new("UICorner") searchCorner.CornerRadius = UDim.new(0, 6) searchCorner.Parent = searchFrame
local searchIcon = Instance.new("TextLabel") searchIcon.Size = UDim2.fromOffset(20, 24) searchIcon.BackgroundTransparency = 1 searchIcon.Text = "🔍" searchIcon.TextSize = 10 searchIcon.Parent = searchFrame
local searchBox = Instance.new("TextBox") searchBox.Size = UDim2.new(1, -24, 1, 0) searchBox.Position = UDim2.fromOffset(20, 0) searchBox.BackgroundTransparency = 1 searchBox.Text = "" searchBox.PlaceholderText = "Search..." searchBox.PlaceholderColor3 = C.textMuted searchBox.TextColor3 = C.text searchBox.Font = Enum.Font.Gotham searchBox.TextSize = 10 searchBox.TextXAlignment = Enum.TextXAlignment.Left searchBox.Parent = searchFrame

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

for _, tName in ipairs(menuTabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 80, 1, 0) btn.BackgroundColor3 = C.surface btn.BackgroundTransparency = 0.5
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
local avCorner = Instance.new("UICorner") avCorner.CornerRadius = UDim.new(1, 0) avCorner.Parent = avatar
local avStroke = Instance.new("UIStroke") avStroke.Color = C.accent avStroke.Thickness = 1 avStroke.Transparency = 0.3 avStroke.Parent = avatar
local greet = Instance.new("TextLabel") greet.Size = UDim2.new(1, -60, 0, 20) greet.Position = UDim2.fromOffset(54, 4) greet.BackgroundTransparency = 1 greet.Text = "Welcome, " .. LP.DisplayName greet.TextColor3 = C.text greet.Font = Enum.Font.GothamBold greet.TextSize = 14 greet.TextXAlignment = Enum.TextXAlignment.Left greet.Parent = profileContainer
local subGreet = Instance.new("TextLabel") subGreet.Size = UDim2.new(1, -60, 0, 14) subGreet.Position = UDim2.fromOffset(54, 24) subGreet.BackgroundTransparency = 1 subGreet.Text = "@" .. LP.Name subGreet.TextColor3 = C.accent subGreet.Font = Enum.Font.Gotham subGreet.TextSize = 10 subGreet.TextXAlignment = Enum.TextXAlignment.Left subGreet.Parent = profileContainer

local function createBigBox(titleText)
    local box = Instance.new("Frame") 
    box.Size = UDim2.new(1, -10, 0, 0) 
    box.AutomaticSize = Enum.AutomaticSize.Y 
    box.BackgroundColor3 = C.surface 
    box.Parent = statusGui
    local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0, 8) bc.Parent = box
    local bs = Instance.new("UIStroke") bs.Color = C.border bs.Thickness = 1 bs.Transparency = 0.6 bs.Parent = box
    local pad = Instance.new("UIPadding") pad.PaddingTop = UDim.new(0, 10) pad.PaddingBottom = UDim.new(0, 10) pad.PaddingLeft = UDim.new(0, 10) pad.PaddingRight = UDim.new(0, 10) pad.Parent = box
    local layout = Instance.new("UIListLayout") layout.Padding = UDim.new(0, 6) layout.Parent = box
    local lbl = Instance.new("TextLabel") lbl.Size = UDim2.new(1, 0, 0, 15) lbl.BackgroundTransparency = 1 lbl.Text = string.upper(titleText) lbl.TextColor3 = C.accent lbl.Font = Enum.Font.GothamBold lbl.TextSize = 10 lbl.TextXAlignment = Enum.TextXAlignment.Left lbl.Parent = box
    return box
end

local function addSmallStat(parent, titleText, initialVal)
    local row = Instance.new("Frame") row.Size = UDim2.new(1, 0, 0, 24) row.BackgroundColor3 = C.surfaceAlt row.Parent = parent
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 6) c.Parent = row
    local t = Instance.new("TextLabel") t.Size = UDim2.new(0.5, -5, 1, 0) t.Position = UDim2.fromOffset(8, 0) t.BackgroundTransparency = 1 t.Text = titleText t.TextColor3 = C.textMuted t.Font = Enum.Font.Gotham t.TextSize = 10 t.TextXAlignment = Enum.TextXAlignment.Left t.Parent = row
    local v = Instance.new("TextLabel") v.Size = UDim2.new(0.5, -15, 1, 0) v.Position = UDim2.new(0.5, 5, 0, 0) v.BackgroundTransparency = 1 v.Text = initialVal v.TextColor3 = C.text v.Font = Enum.Font.GothamBold v.TextSize = 10 v.TextXAlignment = Enum.TextXAlignment.Right v.Parent = row
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
createToggle(mainPage, "Auto Farm Level", "Farms mobs to max level.", false, function(s) _G.KuroAutoFarm = s end)
createToggle(mainPage, "Auto Secret Quests", "Completes Secret Quests.", false, function(s) _G.KuroAutoSecret = s end)

local raidPage = pages["RAID"]
createSection(raidPage, "Normal Raid", "Fitur untuk semua jenis raid (kecuali Law).")
createDropdown(raidPage, "Choice Raid", {"Flame", "Ice", "Dark", "Sand", "Quake", "Buddha", "Spider", "Dough", "Phoenix"}, function(val) _G.KuroRaidChoice = val end)
createToggle(raidPage, "Auto Buy Chip", "Beli chip raid otomatis.", false, function(s) _G.KuroRaidBuyChip = s end)
createToggle(raidPage, "Auto Farm Raid", "Kill NPC & pindah island.", false, function(s) _G.KuroRaidFarm = s end)
createToggle(raidPage, "Instant Kill NPC", "Bunuh bos secara instan.", false, function(s) _G.KuroRaidKill = s end)
createToggle(raidPage, "Auto Start Raid", "Mulai raid otomatis.", false, function(s) _G.KuroRaidStart = s end)
createToggle(raidPage, "Auto Awakening", "Buka awakening fruit otomatis.", false, function(s) _G.KuroRaidAwake = s end)

local fsPage = pages["Farm Settings"]
createSection(fsPage, "Buff System", "Nyalain buff secara otomatis saat farm.")
createToggle(fsPage, "Auto Buso", "Auto activates Buso (Armament).", false, function(s) _G.KuroAutoBuso = s end)
createToggle(fsPage, "Auto Ken", "Auto activates Ken (Observation).", false, function(s) _G.KuroAutoKen = s end)

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

local themeCard = Instance.new("Frame") themeCard.Size = UDim2.new(1, -10, 0, 160) themeCard.BackgroundColor3 = C.surface themeCard.Parent = spScroll
local tcCorner = Instance.new("UICorner") tcCorner.CornerRadius = UDim.new(0, 8) tcCorner.Parent = themeCard
local themeLbl = Instance.new("TextLabel") themeLbl.Size = UDim2.new(1, -20, 0, 20) themeLbl.Position = UDim2.fromOffset(10, 8) themeLbl.BackgroundTransparency = 1 themeLbl.Text = "CHANGE THEME" themeLbl.TextColor3 = C.text themeLbl.Font = Enum.Font.GothamBold themeLbl.TextSize = 12 themeLbl.TextXAlignment = Enum.TextXAlignment.Left themeLbl.Parent = themeCard

local colorCard = Instance.new("Frame") 
colorCard.Size = UDim2.new(1, -10, 0, 120) 
colorCard.BackgroundColor3 = C.surface 
colorCard.Parent = spScroll
local ccCorner = Instance.new("UICorner") ccCorner.CornerRadius = UDim.new(0, 8) ccCorner.Parent = colorCard
local colorLbl = Instance.new("TextLabel") colorLbl.Size = UDim2.new(1, -20, 0, 20) colorLbl.Position = UDim2.fromOffset(10, 8) colorLbl.BackgroundTransparency = 1 colorLbl.Text = "RECOMMENDED COLORS" colorLbl.TextColor3 = C.text colorLbl.Font = Enum.Font.GothamBold colorLbl.TextSize = 12 colorLbl.TextXAlignment = Enum.TextXAlignment.Left colorLbl.Parent = colorCard

local inputBg = Instance.new("TextBox")
inputBg.Size = UDim2.new(0.45, -15, 0, 24)
inputBg.Position = UDim2.fromOffset(10, 35)
inputBg.BackgroundColor3 = C.surfaceAlt
inputBg.TextColor3 = C.text
inputBg.PlaceholderText = "Accent (Hex)"
inputBg.Font = Enum.Font.Code
inputBg.TextSize = 10
inputBg.Parent = colorCard
local ibc = Instance.new("UICorner") ibc.CornerRadius = UDim.new(0, 6) ibc.Parent = inputBg

local inputBg2 = Instance.new("TextBox")
inputBg2.Size = UDim2.new(0.45, -15, 0, 24)
inputBg2.Position = UDim2.new(0.5, 5, 35, 0)
inputBg2.BackgroundColor3 = C.surfaceAlt
inputBg2.TextColor3 = C.text
inputBg2.PlaceholderText = "BG (Hex)"
inputBg2.Font = Enum.Font.Code
inputBg2.TextSize = 10
inputBg2.Parent = colorCard
local ibc2 = Instance.new("UICorner") ibc2.CornerRadius = UDim.new(0, 6) ibc2.Parent = inputBg2

local applyColorBtn = Instance.new("TextButton")
applyColorBtn.Size = UDim2.new(1, -20, 0, 20)
applyColorBtn.Position = UDim2.fromOffset(10, 65)
applyColorBtn.BackgroundColor3 = C.accent
applyColorBtn.Text = "Terapkan Custom Hex"
applyColorBtn.TextColor3 = Color3.new(0,0,0)
applyColorBtn.Font = Enum.Font.GothamBold
applyColorBtn.TextSize = 9
applyColorBtn.Parent = colorCard
local acb = Instance.new("UICorner") acb.CornerRadius = UDim.new(0, 6) acb.Parent = applyColorBtn

local presetColors = {
    {name="Cyber Blue", accent="00A2FF", bg="0A121E"},
    {name="Toxic Green", accent="39FF14", bg="0A1A0A"},
    {name="Blood Red", accent="FF2A2A", bg="1A0A0A"},
    {name="Sakura Pink", accent="FF8CB3", bg="1A0E14"},
    {name="Golden", accent="FFD700", bg="1A160A"},
    {name="Purple Haze", accent="A855F7", bg="140E1E"},
}

local presetContainer = Instance.new("Frame")
presetContainer.Size = UDim2.new(1, -20, 0, 30)
presetContainer.Position = UDim2.fromOffset(10, 90)
presetContainer.BackgroundTransparency = 1
presetContainer.Parent = colorCard
local pcLayout = Instance.new("UIListLayout") pcLayout.FillDirection = Enum.FillDirection.Horizontal pcLayout.Padding = UDim.new(0, 4) pcLayout.Parent = presetContainer

for i, preset in ipairs(presetColors) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromOffset(42, 24)
    btn.BackgroundColor3 = Color3.fromHex(preset.accent)
    btn.Text = preset.name
    btn.TextColor3 = Color3.fromRGB(0,0,0)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 7
    btn.Parent = presetContainer
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 4) c.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        Themes.Custom.accent = Color3.fromHex(preset.accent)
        Themes.Custom.accent2 = Color3.fromHex(preset.accent):Lerp(Color3.new(1,1,1), 0.5)
        Themes.Custom.bg = Color3.fromHex(preset.bg)
        Themes.Custom.surface = Color3.fromHex(preset.bg):Lerp(Color3.new(1,1,1), 0.1)
        Themes.Custom.surfaceAlt = Color3.fromHex(preset.bg):Lerp(Color3.new(1,1,1), 0.2)
        Themes.Custom.border = Color3.fromHex(preset.bg):Lerp(Color3.new(1,1,1), 0.3)
        Themes.Custom.particleColor = Color3.fromHex(preset.accent)
        applyTheme("Custom")
    end)
end

local confirmFrame = Instance.new("Frame")
confirmFrame.Size = UDim2.new(1, -32, 1, -110)
confirmFrame.Position = UDim2.fromOffset(16, 100)
confirmFrame.BackgroundColor3 = C.surface
confirmFrame.Visible = false
confirmFrame.ZIndex = 10
confirmFrame.Parent = main
local cfCorner = Instance.new("UICorner") cfCorner.CornerRadius = UDim.new(0, 8) cfCorner.Parent = confirmFrame
local cfText = Instance.new("TextLabel") cfText.Size = UDim2.new(1, -20, 0, 40) cfText.Position = UDim2.fromOffset(10, 20) cfText.BackgroundTransparency = 1 cfText.Text = "Yakin mau menutup Kuro Hub?" cfText.TextColor3 = C.text cfText.Font = Enum.Font.GothamBold cfText.TextSize = 14 cfText.TextWrapped = true cfText.Parent = confirmFrame
local yesBtn = Instance.new("TextButton") yesBtn.Size = UDim2.fromOffset(80, 30) yesBtn.Position = UDim2.new(0.5, -90, 1, -50) yesBtn.BackgroundColor3 = Color3.fromRGB(200, 70, 90) yesBtn.Text = "Ya, Tutup" yesBtn.TextColor3 = Color3.new(1,1,1) yesBtn.Font = Enum.Font.GothamBold yesBtn.TextSize = 11 yesBtn.Parent = confirmFrame
local yc = Instance.new("UICorner") yc.CornerRadius = UDim.new(0, 6) yc.Parent = yesBtn
local noBtn = Instance.new("TextButton") noBtn.Size = UDim2.fromOffset(80, 30) noBtn.Position = UDim2.new(0.5, 10, 1, -50) noBtn.BackgroundColor3 = C.surfaceAlt noBtn.Text = "Batal" noBtn.TextColor3 = C.text noBtn.Font = Enum.Font.GothamBold noBtn.TextSize = 11 noBtn.Parent = confirmFrame
local nc = Instance.new("UICorner") nc.CornerRadius = UDim.new(0, 6) nc.Parent = noBtn

local function createLandscape(T)
    local existing = main:FindFirstChild("LandscapeLayer")
    if existing then existing:Destroy() end

    local layer = Instance.new("CanvasGroup")
    layer.Name = "LandscapeLayer"
    layer.Size = UDim2.fromScale(1, 1)
    layer.BackgroundColor3 = T.bg
    layer.BorderSizePixel = 0
    layer.ZIndex = 0
    layer.Parent = main
    
    local uc = Instance.new("UICorner") 
    uc.CornerRadius = UDim.new(0, 14)
    uc.Parent = layer

    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, T.bg),
        ColorSequenceKeypoint.new(0.5, T.surface),
        ColorSequenceKeypoint.new(1, T.bg),
    }
    grad.Rotation = 90
    grad.Parent = layer

    if T.particles then
        task.spawn(function()
            while layer.Parent do
                local p = Instance.new("TextLabel")
                p.Size = UDim2.fromOffset(16,16)
                p.BackgroundTransparency = 1
                p.Text = T.particles
                p.TextColor3 = T.particleColor
                p.TextTransparency = 0.5
                p.Font = Enum.Font.GothamBold
                p.TextSize = 12
                p.Position = UDim2.new(math.random(), 0, 1.05, 0)
                p.Parent = layer
                
                local dur = math.random(30, 80) / 10
                local tx = TS:Create(p, TweenInfo.new(dur, Enum.EasingStyle.Linear), {
                    Position = UDim2.new(math.random(), 0, -0.1, 0),
                    TextTransparency = 1
                })
                tx:Play()
                tx.Completed:Connect(function() p:Destroy() end)
                task.wait(0.3)
            end
        end)
    end
end

local function applyTheme(themeName)
    local T = Themes[themeName]
    if not T then return end
    playClick(T)
    CurrentTheme = themeName
    C.accent=T.accent; C.surface=T.surface; C.surfaceAlt=T.surfaceAlt
    C.bg=T.bg; C.border=T.border; C.text=T.text; C.textMuted=T.textMuted

    createLandscape(T)

    mainStroke.Color = C.border
    header.BackgroundColor3 = C.surface
    headerFix.BackgroundColor3 = C.surface
    title.TextColor3 = C.text
    subGreet.TextColor3 = C.accent

    for tName, btn in pairs(tabButtons) do
        local isActive = (tName == CurrentTab)
        btn.BackgroundColor3 = isActive and C.accent or C.surface
        btn.TextColor3 = isActive and Color3.fromRGB(20,20,20) or C.textMuted
    end

    for _, d in ipairs(main:GetDescendants()) do
        if d:IsA("Frame") or d:IsA("TextButton") or d:IsA("TextLabel") or d:IsA("TextBox") then
            if d:FindFirstChildOfClass("UICorner") and d~=main and d~=header and d.Name~="LandscapeLayer" then
                d:FindFirstChildOfClass("UICorner").CornerRadius = UDim.new(0, T.corner)
            end
            if d:FindFirstChildOfClass("UIStroke") and d~=main then
                local s = d:FindFirstChildOfClass("UIStroke")
                s.Color = C.border
            end
        end
    end
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

applyColorBtn.MouseButton1Click:Connect(function()
    local hexAccent = inputBg.Text
    local hexBg = inputBg2.Text
    
    if #hexAccent == 6 then
        Themes.Custom.accent = Color3.fromHex(hexAccent)
        Themes.Custom.accent2 = Color3.fromHex(hexAccent):Lerp(Color3.new(1,1,1), 0.5)
        Themes.Custom.particleColor = Color3.fromHex(hexAccent)
    end
    if #hexBg == 6 then
        Themes.Custom.bg = Color3.fromHex(hexBg)
        Themes.Custom.surface = Color3.fromHex(hexBg):Lerp(Color3.new(1,1,1), 0.1)
        Themes.Custom.surfaceAlt = Color3.fromHex(hexBg):Lerp(Color3.new(1,1,1), 0.2)
        Themes.Custom.border = Color3.fromHex(hexBg):Lerp(Color3.new(1,1,1), 0.3)
    end
    
    applyTheme("Custom")
end)

local hideBtn = Instance.new("TextButton") hideBtn.Size = UDim2.new(1, -10, 0, 30) hideBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50) hideBtn.Text = "Sembunyikan Hub (Hide)" hideBtn.TextColor3 = Color3.new(1,1,1) hideBtn.Font = Enum.Font.GothamBold hideBtn.Parent = spScroll
local hc = Instance.new("UICorner") hc.CornerRadius = UDim.new(0, 8) hc.Parent = hideBtn

local function minimizeToIsland()
    IsMinimized = true
    tween(main, 0.4, {AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 15), Size = UDim2.fromOffset(280, 40), BackgroundColor3 = C.surface, BackgroundTransparency = 0}, Enum.EasingStyle.Back):Play()
    tween(mainCorner, 0.4, {CornerRadius = UDim.new(1, 0)}):Play()
    mainStroke.Transparency = 1; tabBar.Visible = false; content.Visible = false; title.Text = "KURO"; title.TextSize = 13; minBtn.Text = "□"
end

local function restoreFromIsland()
    IsMinimized = false
    tween(main, 0.4, {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(500, 380), BackgroundColor3 = C.bg, BackgroundTransparency = 1}, Enum.EasingStyle.Back):Play()
    tween(mainCorner, 0.4, {CornerRadius = UDim.new(0, 14)}):Play()
    mainStroke.Transparency = 0; tabBar.Visible = true; content.Visible = true; title.Text = "KURO HUB"; title.TextSize = 15; minBtn.Text = "—"
end

hideBtn.MouseButton1Click:Connect(function() settingsPanel.Visible = false; minimizeToIsland() end)
minBtn.MouseButton1Click:Connect(function() 
    if settingsPanel.Visible then settingsPanel.Visible = false; content.Visible = true; tabBar.Visible = true; return end
    if IsMinimized then restoreFromIsland() else minimizeToIsland() end 
end)
main.InputBegan:Connect(function(input) if IsMinimized and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then restoreFromIsland() end end)

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
header.InputBegan:Connect(function(input) 
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
        dragging = true; dragStart = input.Position; startPos = main.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) 
    end 
end)
header.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
UIS.InputChanged:Connect(function(input) 
    if input == dragInput and dragging then 
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) 
    end 
end)

local resizeBtn = Instance.new("TextButton"); resizeBtn.Size = UDim2.fromOffset(15, 15); resizeBtn.Position = UDim2.new(1, -15, 1, -15); resizeBtn.BackgroundColor3 = C.accent; resizeBtn.Text = ""; resizeBtn.Parent = main
local rc = Instance.new("UICorner") rc.CornerRadius = UDim.new(0, 4) rc.Parent = resizeBtn
local resizing = false; local resizeStart, startSize
resizeBtn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then resizing = true; resizeStart = input.Position; startSize = main.Size; input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then resizing = false end end) end end)
UIS.InputChanged:Connect(function(input) if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local delta = input.Position - resizeStart; main.Size = UDim2.fromOffset(math.clamp(startSize.X.Offset + delta.X, 320, 800), math.clamp(startSize.Y.Offset + delta.Y, 250, 600)) end end)

switchTab("Status")
applyTheme("Gold")
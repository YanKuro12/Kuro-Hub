local P = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local LP = P.LocalPlayer
local WS = game:GetService("Workspace")

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

local mainCorner = Instance.new("UICorner") mainCorner.CornerRadius = UDim.new(0, 14) mainCorner.Parent = main
local mainStroke = Instance.new("UIStroke") mainStroke.Color = C.border mainStroke.Thickness = 1 mainStroke.Transparency = 0.4 mainStroke.Parent = main

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

local islandFrame = Instance.new("Frame")
islandFrame.Name = "DynamicIsland"
islandFrame.Size = UDim2.fromOffset(150, 35)
islandFrame.Position = UDim2.new(0.5, 0, 0, 15)
islandFrame.AnchorPoint = Vector2.new(0.5, 0)
islandFrame.BackgroundColor3 = C.surface
islandFrame.Visible = false
islandFrame.ZIndex = 5
islandFrame.Parent = gui
local islandCorner = Instance.new("UICorner") islandCorner.CornerRadius = UDim.new(1, 0) islandCorner.Parent = islandFrame
local islandStroke = Instance.new("UIStroke") islandStroke.Color = C.border islandStroke.Thickness = 1 islandStroke.Parent = islandFrame
local islandText = Instance.new("TextLabel") 
islandText.Size = UDim2.fromScale(1, 1) 
islandText.BackgroundTransparency = 1 
islandText.Text = "KURO ISLAND" 
islandText.TextColor3 = C.accent 
islandText.Font = Enum.Font.GothamBold 
islandText.TextSize = 10 
islandText.Parent = islandFrame

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

local themeCard = Instance.new("Frame") themeCard.Size = UDim2.new(1, -10, 0, 130) themeCard.BackgroundColor3 = C.surface themeCard.Parent = spScroll
local tcCorner = Instance.new("UICorner") tcCorner.CornerRadius = UDim.new(0, 8) tcCorner.Parent = themeCard
local themeLbl = Instance.new("TextLabel") themeLbl.Size = UDim2.new(1, -20, 0, 20) themeLbl.Position = UDim2.fromOffset(10, 8) themeLbl.BackgroundTransparency = 1 themeLbl.Text = "CHANGE THEME" themeLbl.TextColor3 = C.text themeLbl.Font = Enum.Font.GothamBold themeLbl.TextSize = 12 themeLbl.TextXAlignment = Enum.TextXAlignment.Left themeLbl.Parent = themeCard

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

local function applyTheme(themeName)
    local T = Themes[themeName]
    if not T then return end
    CurrentTheme = themeName
    C.accent=T.accent; C.surface=T.surface; C.surfaceAlt=T.surfaceAlt
    C.bg=T.bg; C.border=T.border; C.text=T.text; C.textMuted=T.textMuted

    main.BackgroundColor3 = C.bg
    mainStroke.Color = C.border
    header.BackgroundColor3 = C.surface
    headerFix.BackgroundColor3 = C.surface
    title.TextColor3 = C.text
    subGreet.TextColor3 = C.accent
    
    islandFrame.BackgroundColor3 = C.surface
    islandStroke.Color = C.border
    islandText.TextColor3 = C.accent

    for tName, btn in pairs(tabButtons) do
        local isActive = (tName == CurrentTab)
        btn.BackgroundColor3 = isActive and C.accent or C.surface
        btn.TextColor3 = isActive and Color3.fromRGB(20,20,20) or C.textMuted
    end

    for _, d in ipairs(main:GetDescendants()) do
        if d:IsA("Frame") or d:IsA("TextButton") or d:IsA("TextLabel") then
            if d:FindFirstChildOfClass("UICorner") and d~=main and d~=header then
                d:FindFirstChildOfClass("UICorner").CornerRadius = UDim.new(0, 8)
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

local hideBtn = Instance.new("TextButton") hideBtn.Size = UDim2.new(1, -10, 0, 30) hideBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50) hideBtn.Text = "Sembunyikan Hub (Hide)" hideBtn.TextColor3 = Color3.new(1,1,1) hideBtn.Font = Enum.Font.GothamBold hideBtn.Parent = spScroll
local hc = Instance.new("UICorner") hc.CornerRadius = UDim.new(0, 8) hc.Parent = hideBtn

local function minimizeToIsland()
    IsMinimized = true
    main.Visible = false
    islandFrame.Visible = true
    islandFrame.Size = UDim2.fromOffset(0, 35)
    tween(islandFrame, 0.3, {Size = UDim2.fromOffset(160, 35)}, Enum.EasingStyle.Back):Play()
end

local function restoreFromIsland()
    IsMinimized = false
    tween(islandFrame, 0.3, {Size = UDim2.fromOffset(0, 35)}, Enum.EasingStyle.Back):Play()
    task.delay(0.3, function()
        islandFrame.Visible = false
        main.Visible = true
        
        main.AnchorPoint = Vector2.new(0.5, 0.5)
        main.Position = UDim2.fromScale(0.5, 0.5)
        main.Size = UDim2.fromOffset(500, 380)
    end)
end

islandFrame.InputBegan:Connect(function(input)
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
main.InputBegan:Connect(function(input) 
    if not IsMinimized and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        if input.Position.Y > main.AbsolutePosition.Y + (main.AbsoluteSize.Y * 0.5) then
            startDrag(input)
        end
    end
end)

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
        
        local vp = workspace.CurrentCamera.ViewportSize
        local mainSize = main.AbsoluteSize
        
        newX = math.clamp(newX, 0, vp.X - mainSize.X)
        newY = math.clamp(newY, 0, vp.Y - mainSize.Y)
        
        main.Position = UDim2.fromOffset(newX, newY)
    end 
end)

switchTab("Status")
applyTheme("Gold")
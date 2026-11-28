local P = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local CG = game:GetService("CoreGui")
local RS = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local LP = P.LocalPlayer
local WS = game:GetService("Workspace")

-- ==========================================
-- LOAD THEMES
-- ==========================================
local Themes
pcall(function()
    Themes = require(script.Parent.themes)
end)
if not Themes then
    Themes = loadstring(game:HttpGet("https://raw.githubusercontent.com/YanKuro12/Kuro-Hub/main/themes.lua"))()
end

local ThemeOrder = {"Gold","Obsidian","Halloween","Hacker","Christmas","Valentine"}

-- ==========================================
-- GLOBAL VARIABLES
-- ==========================================
_G.KuroAutoFarm = false
_G.KuroAutoSecret = false
_G.KuroAutoBuso = false
_G.KuroAutoKen = false
_G.KuroRaidBuyChip = false
_G.KuroRaidFarm = false
_G.KuroRaidKill = false
_G.KuroRaidStart = false
_G.KuroRaidAwake = false

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

-- ==========================================
-- LUXURY HELPERS
-- ==========================================
local effectThreads = {}
local function clearEffects()
    for _, th in ipairs(effectThreads) do pcall(function() task.cancel(th) end) end
    effectThreads = {}
    for _, d in ipairs(main:GetDescendants()) do
        if d.Name == "TemaParticle" or d.Name == "TemaGlow" or d.Name == "LuxShimmer"
        or d.Name == "LuxParallax" or d.Name == "LandscapeLayer" then
            d:Destroy()
        end
    end
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

-- ==========================================
-- DYNAMIC LANDSCAPE (PREMIUM)
-- ==========================================
local function createLandscape(T)
    local layer = Instance.new("Frame")
    layer.Name = "LandscapeLayer"
    layer.Size = UDim2.fromScale(1,1)
    layer.BackgroundTransparency = 1
    layer.ClipsDescendants = true
    layer.ZIndex = 0
    layer.Parent = main
    local uc = Instance.new("UICorner") uc.CornerRadius = UDim.new(0,T.cornerHeader) uc.Parent = layer

    local sky = Instance.new("Frame")
    sky.Size = UDim2.fromScale(1,1)
    sky.BackgroundColor3 = T.bg
    sky.BorderSizePixel = 0
    sky.ZIndex = 0
    sky.Parent = layer
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, T.bg),
        ColorSequenceKeypoint.new(0.5, T.surface),
        ColorSequenceKeypoint.new(1, T.bg),
    }
    grad.Rotation = 90
    grad.Parent = sky

    for i=1, 6 do
        local orb = Instance.new("ImageLabel")
        orb.Size = UDim2.fromOffset(math.random(40,90), math.random(40,90))
        orb.BackgroundTransparency = 1
        orb.Image = "rbxassetid://1316045217"
        orb.ImageColor3 = T.accent2
        orb.ImageTransparency = math.random(70,90)/100
        orb.Position = UDim2.new(math.random(), 0, math.random(), 0)
        orb.ZIndex = 1
        orb.Parent = layer
        task.spawn(function()
            while orb.Parent do
                local dur = math.random(60, 120)/10
                tween(orb, dur, {
                    Position = UDim2.new(math.random(), 0, math.random(), 0),
                    ImageTransparency = math.random(60,95)/100
                }, Enum.EasingStyle.Sine):Play()
                task.wait(dur)
            end
        end)
    end

    for i=1, 8 do
        local line = Instance.new("Frame")
        line.Size = UDim2.new(1, 0, 0, 1)
        line.Position = UDim2.new(0, 0, i/8, 0)
        line.BackgroundColor3 = T.accent
        line.BackgroundTransparency = 0.85
        line.BorderSizePixel = 0
        line.ZIndex = 2
        line.Parent = layer
        task.spawn(function()
            while line.Parent do
                tween(line, 3, {BackgroundTransparency = 0.95}, Enum.EasingStyle.Sine):Play()
                task.wait(3)
                tween(line, 3, {BackgroundTransparency = 0.8}, Enum.EasingStyle.Sine):Play()
                task.wait(3)
            end
        end)
    end

    local horizon = Instance.new("ImageLabel")
    horizon.Size = UDim2.new(1, 0, 0.4, 0)
    horizon.Position = UDim2.new(0, 0, 0.3, 0)
    horizon.BackgroundTransparency = 1
    horizon.Image = "rbxassetid://1316045217"
    horizon.ImageColor3 = T.accent
    horizon.ImageTransparency = 0.85
    horizon.ScaleType = Enum.ScaleType.Stretch
    horizon.ZIndex = 2
    horizon.Parent = layer

    task.spawn(function()
        while layer.Parent do
            local sym = T.landscape[math.random(#T.landscape)]
            local p = Instance.new("TextLabel")
            p.Size = UDim2.fromOffset(16,16)
            p.BackgroundTransparency = 1
            p.Text = sym
            p.TextColor3 = T.particleColor
            p.TextTransparency = 0.55
            p.Font = Enum.Font.GothamBold
            p.TextSize = math.random(10,16)
            p.Position = UDim2.new(math.random(), 0, 1.05, 0)
            p.ZIndex = 3
            p.Parent = layer
            local dur = math.random(60, 140)/10
            local tx = TS:Create(p, TweenInfo.new(dur, Enum.EasingStyle.Linear), {
                Position = UDim2.new(math.random(), 0, -0.1, 0),
                TextTransparency = 1
            })
            tx:Play()
            tx.Completed:Connect(function() p:Destroy() end)
            task.wait(0.35)
        end
    end)

    local vignette = Instance.new("ImageLabel")
    vignette.Size = UDim2.fromScale(1.4,1.4)
    vignette.Position = UDim2.fromScale(-0.2,-0.2)
    vignette.BackgroundTransparency = 1
    vignette.Image = "rbxassetid://1316045217"
    vignette.ImageColor3 = Color3.new(0,0,0)
    vignette.ImageTransparency = 0.7
    vignette.ZIndex = 4
    vignette.Parent = layer
    task.spawn(function()
        while vignette.Parent do
            tween(vignette, 20, {Rotation = vignette.Rotation + 180}, Enum.EasingStyle.Linear):Play()
            task.wait(20)
        end
    end)
end

-- ==========================================
-- SHIMMER / PARALLAX / FADE / BOOT / GLOW / PARTICLES
-- ==========================================
local shimmerObj
local function startShimmer(T)
    if shimmerObj then shimmerObj:Destroy() end
    if not T.shimmer then return end
    shimmerObj = Instance.new("Frame")
    shimmerObj.Name = "LuxShimmer"
    shimmerObj.Size = UDim2.new(0.35, 0, 1, 0)
    shimmerObj.Position = UDim2.new(-0.4, 0, 0, 0)
    shimmerObj.BackgroundColor3 = Color3.new(1,1,1)
    shimmerObj.BackgroundTransparency = 1
    shimmerObj.BorderSizePixel = 0
    shimmerObj.ZIndex = 2
    shimmerObj.Parent = header
    local g = Instance.new("UIGradient")
    g.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0,1), NumberSequenceKeypoint.new(0.5,0.75), NumberSequenceKeypoint.new(1,1)
    }
    g.Rotation = 20
    g.Parent = shimmerObj
    local uc = Instance.new("UICorner") uc.CornerRadius = UDim.new(0,18) uc.Parent = shimmerObj
    task.spawn(function()
        while shimmerObj.Parent do
            shimmerObj.Position = UDim2.new(-0.4,0,0,0)
            tween(shimmerObj, 2.2, {Position = UDim2.new(1.1,0,0,0)}, Enum.EasingStyle.Quad):Play()
            task.wait(3.5)
        end
    end)
end

local parallaxGlow
local function startParallax(T)
    if parallaxGlow then parallaxGlow:Destroy() end
    if not T.glow then return end
    parallaxGlow = Instance.new("ImageLabel")
    parallaxGlow.Name = "LuxParallax"
    parallaxGlow.Size = UDim2.fromOffset(220,220)
    parallaxGlow.BackgroundTransparency = 1
    parallaxGlow.Image = "rbxassetid://1316045217"
    parallaxGlow.ImageColor3 = T.accent
    parallaxGlow.ImageTransparency = 0.82
    parallaxGlow.ZIndex = 0
    parallaxGlow.Parent = main
    UIS.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and parallaxGlow.Parent then
            local rel = input.Position - main.AbsolutePosition
            parallaxGlow.Position = UDim2.fromOffset(rel.X - 110, rel.Y - 110)
        end
    end)
end

local function fadeTheme(T, callback)
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.fromScale(1,1)
    overlay.BackgroundColor3 = T.accent
    overlay.BackgroundTransparency = 0.7
    overlay.BorderSizePixel = 0
    overlay.ZIndex = 50
    overlay.Parent = main
    local uc = Instance.new("UICorner") uc.CornerRadius = UDim.new(0,18) uc.Parent = overlay
    tween(overlay, 0.18, {BackgroundTransparency = 0.3}):Play()
    task.wait(0.18)
    if callback then callback() end
    tween(overlay, 0.35, {BackgroundTransparency = 1}):Play()
    task.wait(0.35)
    overlay:Destroy()
end

local function bootAnimation()
    main.BackgroundTransparency = 1
    main.Size = UDim2.fromOffset(0,0)
    tween(main, 0.7, {Size = UDim2.fromOffset(520,400), BackgroundTransparency = 0}, Enum.EasingStyle.Back):Play()
    title.TextTransparency = 1
    subtitle.TextTransparency = 1
    task.delay(0.4, function()
        tween(title, 0.5, {TextTransparency = 0}):Play()
        tween(subtitle, 0.5, {TextTransparency = 0}):Play()
    end)
end

local function spawnParticles(T)
    if not T.particles then return end
    local layer = Instance.new("Frame")
    layer.Name = "TemaParticle"
    layer.Size = UDim2.fromScale(1,1)
    layer.BackgroundTransparency = 1
    layer.ClipsDescendants = true
    layer.ZIndex = 1
    layer.Parent = main
    local th = task.spawn(function()
        while layer.Parent do
            local p = Instance.new("TextLabel")
            p.Size = UDim2.fromOffset(16,16)
            p.BackgroundTransparency = 1
            p.Text = T.particles
            p.TextColor3 = T.particleColor
            p.TextTransparency = 0.4
            p.Font = Enum.Font.GothamBold
            p.TextSize = 12
            p.Position = UDim2.new(math.random(), 0, 1.05, 0)
            p.Parent = layer
            local dur = math.random(40, 90)/10
            local tx = TS:Create(p, TweenInfo.new(dur, Enum.EasingStyle.Linear), {
                Position = UDim2.new(math.random(), 0, -0.1, 0),
                TextTransparency = 1
            })
            tx:Play()
            tx.Completed:Connect(function() p:Destroy() end)
            task.wait(0.25)
        end
    end)
    table.insert(effectThreads, th)
end

local function spawnGlow(T)
    if not T.glow then return end
    local glowStroke = Instance.new("UIStroke")
    glowStroke.Name = "TemaGlow"
    glowStroke.Color = T.accent2
    glowStroke.Thickness = 3
    glowStroke.Transparency = 0.7
    glowStroke.Parent = main
    local th = task.spawn(function()
        while glowStroke.Parent do
            tween(glowStroke, 1.8, {Transparency = 0.2, Thickness = 5}, Enum.EasingStyle.Sine):Play()
            task.wait(1.8)
            tween(glowStroke, 1.8, {Transparency = 0.8, Thickness = 2}, Enum.EasingStyle.Sine):Play()
            task.wait(1.8)
        end
    end)
    table.insert(effectThreads, th)
end

-- ==========================================
-- KOMPONEN UI
-- ==========================================
local function createSection(parent, titleText, descText)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, -10, 0, 46)
    section.BackgroundTransparency = 1
    section.Parent = parent
    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 3, 0, 28)
    accentBar.Position = UDim2.fromOffset(0, 8)
    accentBar.BackgroundColor3 = C.accent
    accentBar.BorderSizePixel = 0
    accentBar.Parent = section
    local abCorner = Instance.new("UICorner") abCorner.CornerRadius = UDim.new(1,0) abCorner.Parent = accentBar
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, -15, 0, 20) t.Position = UDim2.fromOffset(14, 4)
    t.BackgroundTransparency = 1 t.Text = string.upper(titleText)
    t.TextColor3 = C.accent t.Font = Enum.Font.GothamBold t.TextSize = 12
    t.TextXAlignment = Enum.TextXAlignment.Left t.Parent = section
    local d = Instance.new("TextLabel")
    d.Size = UDim2.new(1, -15, 0, 15) d.Position = UDim2.fromOffset(14, 24)
    d.BackgroundTransparency = 1 d.Text = descText d.TextColor3 = C.textMuted
    d.Font = Enum.Font.Gotham d.TextSize = 10 d.TextXAlignment = Enum.TextXAlignment.Left d.Parent = section
end

local function createToggle(parent, titleText, descText, toggleInitial, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -10, 0, 68)
    card.BackgroundColor3 = C.surface
    card.Parent = parent
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0,14) c.Parent = card
    local stroke = Instance.new("UIStroke") stroke.Color = C.border stroke.Thickness = 1 stroke.Transparency = 0.4 stroke.Parent = card
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1,-80,0,18) t.Position = UDim2.fromOffset(16,12) t.BackgroundTransparency = 1
    t.Text = titleText t.TextColor3 = C.text t.Font = Enum.Font.GothamBold t.TextSize = 11
    t.TextXAlignment = Enum.TextXAlignment.Left t.Parent = card
    local d = Instance.new("TextLabel")
    d.Size = UDim2.new(1,-80,0,14) d.Position = UDim2.fromOffset(16,31) d.BackgroundTransparency = 1
    d.Text = descText d.TextColor3 = C.textMuted d.Font = Enum.Font.Gotham d.TextSize = 9
    d.TextXAlignment = Enum.TextXAlignment.Left d.Parent = card
    local toggle = Instance.new("TextButton")
    toggle.AnchorPoint = Vector2.new(1,0.5) toggle.Position = UDim2.new(1,-16,0.5,0)
    toggle.Size = UDim2.fromOffset(42,22)
    toggle.BackgroundColor3 = toggleInitial and C.accent or C.surfaceAlt
    toggle.AutoButtonColor = false toggle.Text = "" toggle.Parent = card
    local tc = Instance.new("UICorner") tc.CornerRadius = UDim.new(1,0) tc.Parent = toggle
    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(16,16)
    knob.Position = toggleInitial and UDim2.new(1,-20,0.5,-8) or UDim2.new(0,3,0.5,-8)
    knob.BackgroundColor3 = Color3.fromRGB(250,248,240) knob.Parent = toggle
    local kc = Instance.new("UICorner") kc.CornerRadius = UDim.new(1,0) kc.Parent = knob
    local state = toggleInitial
    toggle.MouseButton1Click:Connect(function()
        state = not state
        tween(knob, 0.2, {Position = state and UDim2.new(1,-20,0.5,-8) or UDim2.new(0,3,0.5,-8)}):Play()
        tween(toggle, 0.2, {BackgroundColor3 = state and C.accent or C.surfaceAlt}):Play()
        tween(stroke, 0.2, {Color = state and C.accent or C.border, Transparency = state and 0 or 0.4}):Play()
        if callback then callback(state) end
    end)
    card.MouseEnter:Connect(function() tween(stroke, 0.15, {Color = C.accent, Transparency = 0}):Play() end)
    card.MouseLeave:Connect(function() if not state then tween(stroke, 0.15, {Color = C.border, Transparency = 0.4}):Play() end end)
end

local function createDropdown(parent, titleText, options, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -10, 0, 62)
    card.BackgroundColor3 = C.surface card.Parent = parent
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0,14) c.Parent = card
    local stroke = Instance.new("UIStroke") stroke.Color = C.border stroke.Thickness = 1 stroke.Transparency = 0.4 stroke.Parent = card
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1,-24,0,18) t.Position = UDim2.fromOffset(16,10) t.BackgroundTransparency = 1
    t.Text = titleText t.TextColor3 = C.text t.Font = Enum.Font.GothamBold t.TextSize = 11
    t.TextXAlignment = Enum.TextXAlignment.Left t.Parent = card
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-32,0,24) btn.Position = UDim2.fromOffset(16,30)
    btn.BackgroundColor3 = C.surfaceAlt btn.AutoButtonColor = false
    btn.Text = options[1].."   ▾" btn.TextColor3 = C.accent
    btn.Font = Enum.Font.GothamSemibold btn.TextSize = 10
    btn.TextXAlignment = Enum.TextXAlignment.Left btn.Parent = card
    local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0,7) bc.Parent = btn
    local bpad = Instance.new("UIPadding") bpad.PaddingLeft = UDim.new(0,8) bpad.Parent = btn
    local idx = 1
    btn.MouseButton1Click:Connect(function()
        idx = idx + 1
        if idx > #options then idx = 1 end
        btn.Text = options[idx].."   ▾"
        if callback then callback(options[idx]) end
    end)
    card.MouseEnter:Connect(function() tween(stroke, 0.15, {Color = C.accent, Transparency = 0}):Play() end)
    card.MouseLeave:Connect(function() tween(stroke, 0.15, {Color = C.border, Transparency = 0.4}):Play() end)
end

-- ==========================================
-- GUI UTAMA
-- ==========================================
local gui = Instance.new("ScreenGui")
gui.Name = "KuroHubUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.Parent = CG

local main = Instance.new("Frame")
main.Name = "Main"
main.AnchorPoint = Vector2.new(0.5,0.5)
main.Position = UDim2.fromScale(0.5,0.5)
main.Size = UDim2.fromOffset(520,400)
main.BackgroundColor3 = C.bg
main.BorderSizePixel = 0
main.Active = true
main.ClipsDescendants = true
main.Parent = gui

local uiScale = Instance.new("UIScale") uiScale.Parent = main
local function updateScale()
    local vp = workspace.CurrentCamera.ViewportSize
    local sx = (vp.X * 0.9) / 520
    local sy = (vp.Y * 0.8) / 400
    uiScale.Scale = math.clamp(math.min(sx, sy), 0.5, 1.0)
end
updateScale()
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)

local mainCorner = Instance.new("UICorner") mainCorner.CornerRadius = UDim.new(0,18) mainCorner.Parent = main
local mainStroke = Instance.new("UIStroke") mainStroke.Color = C.border mainStroke.Thickness = 1 mainStroke.Transparency = 0.3 mainStroke.Parent = main

local header = Instance.new("Frame")
header.Size = UDim2.new(1,0,0,50)
header.BackgroundColor3 = C.surface
header.ZIndex = 10
header.Parent = main
local headerCorner = Instance.new("UICorner") headerCorner.CornerRadius = UDim.new(0,18) headerCorner.Parent = header
local headerFix = Instance.new("Frame") headerFix.Size = UDim2.new(1,0,0,12) headerFix.Position = UDim2.new(0,0,1,-12) headerFix.BackgroundColor3 = C.surface headerFix.BorderSizePixel = 0 headerFix.ZIndex = 10 headerFix.Parent = header
local headerLine = Instance.new("Frame")
headerLine.Size = UDim2.new(1,-40,0,1) headerLine.Position = UDim2.new(0,20,1,-1)
headerLine.BackgroundColor3 = C.accent headerLine.BackgroundTransparency = 0.6 headerLine.BorderSizePixel = 0 headerLine.ZIndex = 11 headerLine.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-140,1,0) title.Position = UDim2.fromOffset(20,0)
title.BackgroundTransparency = 1 title.Text = "KURO HUB" title.TextColor3 = C.text
title.Font = Enum.Font.GothamBold title.TextSize = 15 title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 11 title.Parent = header

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1,-140,0,14) subtitle.Position = UDim2.new(0,20,1,-18)
subtitle.BackgroundTransparency = 1 subtitle.Text = "Blox Fruits  ·  Premium Edition"
subtitle.TextColor3 = C.accent subtitle.Font = Enum.Font.Gotham subtitle.TextSize = 9
subtitle.TextXAlignment = Enum.TextXAlignment.Left subtitle.ZIndex = 11 subtitle.Parent = header

local btnContainer = Instance.new("Frame")
btnContainer.AnchorPoint = Vector2.new(1,0.5) btnContainer.Position = UDim2.new(1,-14,0.5,0)
btnContainer.Size = UDim2.fromOffset(96,26) btnContainer.BackgroundTransparency = 1
btnContainer.ZIndex = 11 btnContainer.Parent = header
local btnLayout = Instance.new("UIListLayout") btnLayout.FillDirection = Enum.FillDirection.Horizontal
btnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right btnLayout.Padding = UDim.new(0,6) btnLayout.Parent = btnContainer

local function createHeaderBtn(icon, order, hoverColor)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromOffset(26,26)
    btn.BackgroundColor3 = C.surfaceAlt
    btn.AutoButtonColor = false btn.Text = icon btn.TextColor3 = C.textMuted
    btn.Font = Enum.Font.GothamBold btn.TextSize = 13 btn.LayoutOrder = order btn.Parent = btnContainer
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(1,0) c.Parent = btn
    btn.MouseEnter:Connect(function() tween(btn, 0.15, {BackgroundColor3 = hoverColor, TextColor3 = Color3.new(1,1,1)}):Play() end)
    btn.MouseLeave:Connect(function() tween(btn, 0.15, {BackgroundColor3 = C.surfaceAlt, TextColor3 = C.textMuted}):Play() end)
    return btn
end

local setBtn = createHeaderBtn("⚙", 1, C.accent)
local minBtn = createHeaderBtn("—", 2, C.accent)
local closeBtn = createHeaderBtn("✕", 3, Color3.fromRGB(200,70,90))

local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1,-40,0,34) tabBar.Position = UDim2.fromOffset(20,62)
tabBar.BackgroundTransparency = 1 tabBar.ZIndex = 5 tabBar.Parent = main
local tabScroll = Instance.new("ScrollingFrame") tabScroll.Size = UDim2.fromScale(1,1)
tabScroll.BackgroundTransparency = 1 tabScroll.ScrollBarThickness = 0
tabScroll.CanvasSize = UDim2.new(0,820,0,0) tabScroll.Parent = tabBar
local tabLayout = Instance.new("UIListLayout") tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0,6) tabLayout.Parent = tabScroll

local content = Instance.new("Frame")
content.Size = UDim2.new(1,-40,1,-112) content.Position = UDim2.fromOffset(20,104)
content.BackgroundTransparency = 1 content.ZIndex = 5 content.Parent = main

local pages = {}
local function makePage(name)
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.fromScale(1,1) scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0 scroll.ScrollBarThickness = 2
    scroll.ScrollBarImageColor3 = C.border
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.Visible = false scroll.Parent = content
    local grid = Instance.new("UIListLayout") grid.Padding = UDim.new(0,10) grid.Parent = scroll
    local pad = Instance.new("UIPadding") pad.PaddingRight = UDim.new(0,6) pad.Parent = scroll
    pages[name] = scroll
    return scroll
end

local menuTabs = {"Status","Main","RAID","SEA EVENT","ISLAND EVENT","DUNGEON","QUEST","SHOP","MISC","Farm Settings"}
for _, t in ipairs(menuTabs) do makePage(t) end

local tabButtons = {}
local function switchTab(name)
    CurrentTab = name
    for n, p in pairs(pages) do p.Visible = (n == name) end
    local T = Themes[CurrentTheme]
    for tName, btn in pairs(tabButtons) do
        local isActive = (tName == name)
        tween(btn, 0.2, {BackgroundColor3 = isActive and C.accent or C.surface}):Play()
        tween(btn, 0.2, {TextColor3 = isActive and Color3.fromRGB(20,20,20) or C.textMuted}):Play()
        tween(btn, 0.2, {BackgroundTransparency = isActive and 0 or 0.35}):Play()
    end
end

for _, tName in ipairs(menuTabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,92,1,0)
    btn.BackgroundColor3 = C.surface btn.BackgroundTransparency = 0.35
    btn.AutoButtonColor = false btn.Text = string.upper(tName)
    btn.TextColor3 = C.textMuted btn.Font = Enum.Font.GothamSemibold btn.TextSize = 9
    btn.Parent = tabScroll
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(1,0) c.Parent = btn
    btn.MouseButton1Click:Connect(function() switchTab(tName) end)
    tabButtons[tName] = btn
end

-- ==========================================
-- TAB STATUS
-- ==========================================
local statusGui = pages["Status"]
statusGui.AutomaticCanvasSize = Enum.AutomaticSize.Y
statusGui.ScrollBarThickness = 0
local profileContainer = Instance.new("Frame") profileContainer.Size = UDim2.new(1,-10,0,54) profileContainer.BackgroundTransparency = 1 profileContainer.Parent = statusGui
local avatar = Instance.new("ImageLabel") avatar.Size = UDim2.fromOffset(48,48) avatar.BackgroundColor3 = C.surface avatar.Image = "rbxthumb://type=AvatarHeadShot&id="..LP.UserId.."&w=150&h=150" avatar.Parent = profileContainer
local avCorner = Instance.new("UICorner") avCorner.CornerRadius = UDim.new(1,0) avCorner.Parent = avatar
local avStroke = Instance.new("UIStroke") avStroke.Color = C.accent avStroke.Thickness = 1.5 avStroke.Transparency = 0.3 avStroke.Parent = avatar
local greet = Instance.new("TextLabel") greet.Size = UDim2.new(1,-64,0,20) greet.Position = UDim2.fromOffset(60,6) greet.BackgroundTransparency = 1 greet.Text = "Welcome, "..LP.DisplayName greet.TextColor3 = C.text greet.Font = Enum.Font.GothamBold greet.TextSize = 15 greet.TextXAlignment = Enum.TextXAlignment.Left greet.Parent = profileContainer
local subGreet = Instance.new("TextLabel") subGreet.Size = UDim2.new(1,-64,0,15) subGreet.Position = UDim2.fromOffset(60,27) subGreet.BackgroundTransparency = 1 subGreet.Text = "@"..LP.Name subGreet.TextColor3 = C.accent subGreet.Font = Enum.Font.Gotham subGreet.TextSize = 10 subGreet.TextXAlignment = Enum.TextXAlignment.Left subGreet.Parent = profileContainer

local function createBigBox(titleText)
    local box = Instance.new("Frame") box.Size = UDim2.new(1,-10,0,0) box.AutomaticSize = Enum.AutomaticSize.Y box.BackgroundColor3 = C.surface box.Parent = statusGui
    local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0,14) bc.Parent = box
    local bs = Instance.new("UIStroke") bs.Color = C.border bs.Thickness = 1 bs.Transparency = 0.4 bs.Parent = box
    local pad = Instance.new("UIPadding") pad.PaddingTop = UDim.new(0,12) pad.PaddingBottom = UDim.new(0,12) pad.PaddingLeft = UDim.new(0,12) pad.PaddingRight = UDim.new(0,12) pad.Parent = box
    local layout = Instance.new("UIListLayout") layout.Padding = UDim.new(0,8) layout.Parent = box
    local lbl = Instance.new("TextLabel") lbl.Size = UDim2.new(1,0,0,15) lbl.BackgroundTransparency = 1 lbl.Text = string.upper(titleText) lbl.TextColor3 = C.accent lbl.Font = Enum.Font.GothamBold lbl.TextSize = 10 lbl.TextXAlignment = Enum.TextXAlignment.Left lbl.Parent = box
    return box
end

local function addSmallStat(parent, titleText, initialVal)
    local row = Instance.new("Frame") row.Size = UDim2.new(1,0,0,26) row.BackgroundColor3 = C.surfaceAlt row.Parent = parent
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0,8) c.Parent = row
    local t = Instance.new("TextLabel") t.Size = UDim2.new(0.5,-5,1,0) t.Position = UDim2.fromOffset(10,0) t.BackgroundTransparency = 1 t.Text = titleText t.TextColor3 = C.textMuted t.Font = Enum.Font.Gotham t.TextSize = 10 t.TextXAlignment = Enum.TextXAlignment.Left t.Parent = row
    local v = Instance.new("TextLabel") v.Size = UDim2.new(0.5,-15,1,0) v.Position = UDim2.new(0.5,5,0,0) v.BackgroundTransparency = 1 v.Text = initialVal v.TextColor3 = C.text v.Font = Enum.Font.GothamBold v.TextSize = 10 v.TextXAlignment = Enum.TextXAlignment.Right v.Parent = row
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
local function formatTime(sec) return tostring(math.floor(sec/60)).."m "..tostring(math.floor(sec%60)).."s" end
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

-- ==========================================
-- TAB MAIN
-- ==========================================
local mainPage = pages["Main"]
createSection(mainPage, "Auto Farm", "Konfigurasi farming level & secret.")
createToggle(mainPage, "Auto Farm Level", "Farms mobs to max level.", false, function(s) _G.KuroAutoFarm = s; print("System: Auto Farm", s and "ON" or "OFF") end)
createToggle(mainPage, "Auto Secret Quests", "Completes Secret Quests.", false, function(s) _G.KuroAutoSecret = s; print("System: Auto Secret", s and "ON" or "OFF") end)

-- ==========================================
-- TAB RAID
-- ==========================================
local raidPage = pages["RAID"]
raidPage.ScrollBarThickness = 2
createSection(raidPage, "Normal Raid", "Fitur untuk semua jenis raid (kecuali Law).")
createDropdown(raidPage, "Choice Raid", {"Flame","Ice","Dark","Sand","Quake","Buddha","Spider","Dough","Phoenix"}, function(val) _G.KuroRaidChoice = val end)
createToggle(raidPage, "Auto Buy Chip", "Beli chip raid otomatis.", false, function(s) _G.KuroRaidBuyChip = s end)
createToggle(raidPage, "Auto Farm Raid", "Kill NPC & pindah island.", false, function(s) _G.KuroRaidFarm = s end)
createToggle(raidPage, "Instant Kill NPC", "Bunuh bos secara instan.", false, function(s) _G.KuroRaidKill = s end)
createToggle(raidPage, "Auto Start Raid", "Mulai raid otomatis.", false, function(s) _G.KuroRaidStart = s end)
createToggle(raidPage, "Auto Awakening", "Buka awakening fruit otomatis.", false, function(s) _G.KuroRaidAwake = s end)
local spacer = Instance.new("Frame") spacer.Size = UDim2.new(1,-10,0,18) spacer.BackgroundTransparency = 1 spacer.Parent = raidPage
createSection(raidPage, "Raid Law", "Fitur khusus farming Law secara otomatis.")
createToggle(raidPage, "Buy Chip Law Raid", "Beli chip raid Law otomatis.", false, function(s) _G.KuroRaidLawChip = s end)
createToggle(raidPage, "Auto Farm Law Boss", "Kill boss Law secara otomatis.", false, function(s) _G.KuroRaidLawBoss = s end)

-- ==========================================
-- TAB FARM SETTINGS
-- ==========================================
local fsPage = pages["Farm Settings"]
createSection(fsPage, "Buff System", "Nyalain buff secara otomatis saat farm.")
createToggle(fsPage, "Auto Buso", "Auto activates Buso (Armament).", false, function(s) _G.KuroAutoBuso = s end)
createToggle(fsPage, "Auto Ken", "Auto activates Ken (Observation).", false, function(s) _G.KuroAutoKen = s end)

-- ==========================================
-- SETTINGS PANEL
-- ==========================================
local settingsPanel = Instance.new("Frame")
settingsPanel.Size = UDim2.new(1,-40,1,-112) settingsPanel.Position = UDim2.fromOffset(20,104)
settingsPanel.BackgroundColor3 = C.bg settingsPanel.Visible = false settingsPanel.ZIndex = 6
settingsPanel.Parent = main
local spCorner = Instance.new("UICorner") spCorner.CornerRadius = UDim.new(0,14) spCorner.Parent = settingsPanel
local spScroll = Instance.new("ScrollingFrame") spScroll.Size = UDim2.fromScale(1,1) spScroll.BackgroundTransparency = 1 spScroll.ScrollBarThickness = 2 spScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y spScroll.Parent = settingsPanel
local spLayout = Instance.new("UIListLayout") spLayout.Padding = UDim.new(0,12) spLayout.Parent = spScroll
local spPad = Instance.new("UIPadding") spPad.PaddingTop = UDim.new(0,12) spPad.PaddingLeft = UDim.new(0,12) spPad.PaddingRight = UDim.new(0,12) spPad.Parent = spScroll

local themeCard = Instance.new("Frame") themeCard.Size = UDim2.new(1,0,0,132) themeCard.BackgroundColor3 = C.surface themeCard.Parent = spScroll
local tcCorner = Instance.new("UICorner") tcCorner.CornerRadius = UDim.new(0,14) tcCorner.Parent = themeCard
local themeStroke = Instance.new("UIStroke") themeStroke.Color = C.border themeStroke.Thickness = 1 themeStroke.Transparency = 0.4 themeStroke.Parent = themeCard
local themeLbl = Instance.new("TextLabel") themeLbl.Size = UDim2.new(1,-24,0,20) themeLbl.Position = UDim2.fromOffset(14,10) themeLbl.BackgroundTransparency = 1 themeLbl.Text = "APPEARANCE" themeLbl.TextColor3 = C.accent themeLbl.Font = Enum.Font.GothamBold themeLbl.TextSize = 10 themeLbl.TextXAlignment = Enum.TextXAlignment.Left themeLbl.Parent = themeCard

local themeButtons = {}
for i, tName in ipairs(ThemeOrder) do
    local col = (i-1) % 3
    local row = math.floor((i-1)/3)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromOffset(90,26)
    btn.Position = UDim2.fromOffset(14 + col*96, 44 + row*32)
    btn.BackgroundColor3 = Themes[tName].accent
    btn.Text = tName
    btn.TextColor3 = Color3.fromRGB(20,20,20)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 9
    btn.Parent = themeCard
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(1,0) c.Parent = btn
    local s = Instance.new("UIStroke") s.Color = Themes[tName].accent2 s.Thickness = 1 s.Transparency = 0.3 s.Parent = btn
    btn.MouseButton1Click:Connect(function() applyTheme(tName) end)
    btn.MouseEnter:Connect(function() tween(s, 0.2, {Transparency = 0, Thickness = 2}):Play() end)
    btn.MouseLeave:Connect(function() tween(s, 0.2, {Transparency = 0.3, Thickness = 1}):Play() end)
    themeButtons[tName] = btn
end

local hideBtn = Instance.new("TextButton")
hideBtn.Size = UDim2.new(1,0,0,34) hideBtn.BackgroundColor3 = C.surface hideBtn.AutoButtonColor = false
hideBtn.Text = "Sembunyikan Hub" hideBtn.TextColor3 = C.accent hideBtn.Font = Enum.Font.GothamBold hideBtn.TextSize = 10 hideBtn.Parent = spScroll
local hc = Instance.new("UICorner") hc.CornerRadius = UDim.new(1,0) hc.Parent = hideBtn
local hs = Instance.new("UIStroke") hs.Color = C.accent hs.Thickness = 1 hs.Transparency = 0.4 hs.Parent = hideBtn

-- ==========================================
-- APPLY THEME
-- ==========================================
function applyTheme(themeName)
    local T = Themes[themeName]
    if not T then return end
    playClick(T)
    fadeTheme(T, function()
        CurrentTheme = themeName
        C.accent=T.accent; C.surface=T.surface; C.surfaceAlt=T.surfaceAlt
        C.bg=T.bg; C.border=T.border; C.text=T.text; C.textMuted=T.textMuted
        clearEffects()

        main.BackgroundColor3 = C.bg
        mainStroke.Color = C.border
        mainStroke.Thickness = T.strokeThickness
        mainStroke.Transparency = T.strokeTransparency
        mainCorner.CornerRadius = UDim.new(0, T.cornerHeader)

        local eg = header:FindFirstChildOfClass("UIGradient")
        if eg then eg:Destroy() end
        if T.name ~= "Hacker" then
            local grad = Instance.new("UIGradient")
            grad.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, T.surface),
                ColorSequenceKeypoint.new(0.5, T.surfaceAlt),
                ColorSequenceKeypoint.new(1, T.surface),
            }
            grad.Rotation = 90
            grad.Parent = header
        end

        header.BackgroundColor3 = C.surface
        headerFix.BackgroundColor3 = C.surface
        headerCorner.CornerRadius = UDim.new(0, T.cornerHeader)
        headerLine.BackgroundColor3 = C.accent
        title.Font = T.font; title.TextColor3 = C.text
        title.Text = T.name=="Hacker" and "> KURO_HUB_" or "KURO HUB"
        subtitle.Font = T.fontBody; subtitle.TextColor3 = C.accent
        subtitle.Text = T.name=="Hacker" and "[system ready]" or ("Blox Fruits  ·  "..T.name.." Edition")

        for tName, btn in pairs(tabButtons) do
            local isActive = (tName == CurrentTab)
            btn.BackgroundColor3 = isActive and C.accent or C.surface
            btn.TextColor3 = isActive and Color3.fromRGB(20,20,20) or C.textMuted
            btn.Font = T.fontBody
            btn.BackgroundTransparency = isActive and 0 or 0.35
            btn.Text = string.upper(tName)
            if T.tabStyle=="bracket" then btn.Text = "["..string.upper(tName).."]" end
            local uc = btn:FindFirstChildOfClass("UICorner")
            if uc then uc.CornerRadius = T.tabStyle=="pill" and UDim.new(1,0) or UDim.new(0,4) end
        end

        for _, d in ipairs(main:GetDescendants()) do
            if d:IsA("Frame") or d:IsA("TextButton") or d:IsA("TextLabel") then
                if d:FindFirstChildOfClass("UICorner") and d~=main and d~=header then
                    d:FindFirstChildOfClass("UICorner").CornerRadius = UDim.new(0, T.corner)
                end
                if d:FindFirstChildOfClass("UIStroke") and d~=main then
                    local s = d:FindFirstChildOfClass("UIStroke")
                    s.Color = C.border
                    s.Thickness = T.strokeThickness
                    s.Transparency = T.strokeTransparency
                end
            end
        end

        for _, d in ipairs(main:GetDescendants()) do
            if d:IsA("Frame") and d.BackgroundColor3 == C.surface and d ~= header then
                d.BackgroundTransparency = 1 - T.glass
            end
        end

        createLandscape(T)
        startShimmer(T)
        startParallax(T)
        spawnParticles(T)
        spawnGlow(T)
    end)
end

-- ==========================================
-- MINIMIZE PREMIUM
-- ==========================================
local islandGlow = Instance.new("UIStroke") islandGlow.Color = C.accent islandGlow.Thickness = 2 islandGlow.Transparency = 1 islandGlow.Parent = main
local isPulsing = false
local function startIslandEffects()
    islandGlow.Transparency = 0.6
    if isPulsing then return end
    isPulsing = true
    task.spawn(function()
        while isPulsing do
            tween(islandGlow, 1.6, {Transparency = 0.15, Thickness = 4}, Enum.EasingStyle.Sine):Play()
            task.wait(1.6)
            tween(islandGlow, 1.6, {Transparency = 0.6, Thickness = 1.5}, Enum.EasingStyle.Sine):Play()
            task.wait(1.6)
        end
    end)
end
local function stopIslandEffects()
    isPulsing = false
    islandGlow.Transparency = 1
end

local function minimizeToIsland()
    IsMinimized = true
    tween(main, 0.45, {AnchorPoint = Vector2.new(0.5,0), Position = UDim2.new(0.5,0,0,15), Size = UDim2.fromOffset(300,44), BackgroundColor3 = C.surface}, Enum.EasingStyle.Quint):Play()
    tween(mainCorner, 0.45, {CornerRadius = UDim.new(1,0)}):Play()
    mainStroke.Transparency = 1; tabBar.Visible = false; content.Visible = false
    title.Text = "KURO"; title.TextSize = 14; subtitle.Visible = false
    minBtn.Text = "□"
    startIslandEffects()
end
local function restoreFromIsland()
    IsMinimized = false
    tween(main, 0.45, {AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromScale(0.5,0.5), Size = UDim2.fromOffset(520,400), BackgroundColor3 = C.bg}, Enum.EasingStyle.Quint):Play()
    tween(mainCorner, 0.45, {CornerRadius = UDim.new(0,18)}):Play()
    mainStroke.Transparency = 0.3; tabBar.Visible = true; content.Visible = true
    title.Text = CurrentTheme=="Hacker" and "> KURO_HUB_" or "KURO HUB"; title.TextSize = 15; subtitle.Visible = true
    minBtn.Text = "—"
    stopIslandEffects()
end

hideBtn.MouseButton1Click:Connect(function() settingsPanel.Visible = false; minimizeToIsland() end)
minBtn.MouseButton1Click:Connect(function()
    if settingsPanel.Visible then settingsPanel.Visible = false; content.Visible = true; tabBar.Visible = true; return end
    if IsMinimized then restoreFromIsland() else minimizeToIsland() end
end)
main.InputBegan:Connect(function(input)
    if IsMinimized and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then restoreFromIsland() end
end)
setBtn.MouseButton1Click:Connect(function()
    if IsMinimized then return end
    settingsPanel.Visible = not settingsPanel.Visible
    content.Visible = not settingsPanel.Visible
    tabBar.Visible = not settingsPanel.Visible
end)
closeBtn.MouseButton1Click:Connect(function()
    local closeTween = TS:Create(main, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Size = UDim2.fromOffset(0,0), BackgroundTransparency = 1})
    closeTween:Play()
    TS:Create(mainStroke, TweenInfo.new(0.35), {Transparency = 1}):Play()
    closeTween.Completed:Connect(function() gui:Destroy() end)
end)

-- ==========================================
-- DRAG & RESIZE
-- ==========================================
local dragging=false; local dragInput, dragStart, startPos
header.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        dragging=true; dragStart=input.Position; startPos=main.Position
        input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then dragging=false end end)
    end
end)
header.InputChanged:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then dragInput=input end
end)
UIS.InputChanged:Connect(function(input)
    if input==dragInput and dragging then
        local delta=input.Position-dragStart
        main.Position=UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X, startPos.Y.Scale, startPos.Y.Offset+delta.Y)
    end
end)
local resizeBtn=Instance.new("TextButton")
resizeBtn.Size=UDim2.fromOffset(14,14) resizeBtn.Position=UDim2.new(1,-18,1,-18)
resizeBtn.BackgroundColor3=C.accent resizeBtn.BackgroundTransparency=0.3 resizeBtn.Text="" resizeBtn.ZIndex=20 resizeBtn.Parent=main
local rc=Instance.new("UICorner") rc.CornerRadius=UDim.new(1,0) rc.Parent=resizeBtn
local resizing=false; local resizeStart, startSize
resizeBtn.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        resizing=true; resizeStart=input.Position; startSize=main.Size
        input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then resizing=false end end)
    end
end)
UIS.InputChanged:Connect(function(input)
    if resizing and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
        local delta=input.Position-resizeStart
        main.Size=UDim2.fromOffset(math.clamp(startSize.X.Offset+delta.X,320,820), math.clamp(startSize.Y.Offset+delta.Y,260,620))
    end
end)

-- ==========================================
-- START
-- ==========================================
switchTab("Status")
bootAnimation()
task.delay(0.8, function() applyTheme("Gold") end)
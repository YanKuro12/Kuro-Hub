local P = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local CG = game:GetService("CoreGui")
local LP = P.LocalPlayer

local C = {
    bg          = Color3.fromRGB(15, 18, 26),
    surface     = Color3.fromRGB(22, 28, 40),
    surfaceAlt  = Color3.fromRGB(30, 38, 55),
    border      = Color3.fromRGB(45, 55, 75),
    accent      = Color3.fromRGB(0, 140, 255),
    text        = Color3.fromRGB(255, 255, 255),
    textMuted   = Color3.fromRGB(140, 150, 170),
}

local function computeScale()
    local vp = workspace.CurrentCamera.ViewportSize
    local sx = (vp.X * 0.95) / 600
    local sy = (vp.Y * 0.90) / 380
    local s = math.min(sx, sy)
    if UIS.TouchEnabled and not UIS.KeyboardEnabled then
        return math.clamp(s, 0.45, 1.0)
    end
    return math.clamp(s, 0.6, 1.0)
end

local gui = Instance.new("ScreenGui")
gui.Name = "KuroHubUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.Parent = CG

local main = Instance.new("Frame")
main.Name = "Main"
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)
main.Size = UDim2.fromOffset(600, 380)
main.BackgroundColor3 = C.bg
main.BorderSizePixel = 0
main.Active = true
main.ClipsDescendants = true
main.Parent = gui

local uiScale = Instance.new("UIScale")
uiScale.Scale = computeScale()
uiScale.Parent = main

workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    TS:Create(uiScale, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Scale = computeScale()}):Play()
end)

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = C.border
mainStroke.Thickness = 1
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
mainStroke.Parent = main

local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = C.surface
header.BorderSizePixel = 0
header.Parent = main

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 10)
headerCorner.Parent = header

local headerFix = Instance.new("Frame")
headerFix.Size = UDim2.new(1, 0, 0, 10)
headerFix.Position = UDim2.new(0, 0, 1, -10)
headerFix.BackgroundColor3 = C.surface
headerFix.BorderSizePixel = 0
headerFix.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -100, 1, 0)
title.Position = UDim2.fromOffset(20, 0)
title.BackgroundTransparency = 1
title.Text = "Kuro Hub | Blox Fruits"
title.TextColor3 = C.text
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.AnchorPoint = Vector2.new(1, 0.5)
closeBtn.Position = UDim2.new(1, -15, 0.5, 0)
closeBtn.Size = UDim2.fromOffset(30, 30)
closeBtn.BackgroundColor3 = C.surfaceAlt
closeBtn.AutoButtonColor = false
closeBtn.Text = "×"
closeBtn.TextColor3 = C.text
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

closeBtn.MouseEnter:Connect(function() TS:Create(closeBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}):Play() end)
closeBtn.MouseLeave:Connect(function() TS:Create(closeBtn, TweenInfo.new(0.1), {BackgroundColor3 = C.surfaceAlt}):Play() end)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

local minBtn = Instance.new("TextButton")
minBtn.AnchorPoint = Vector2.new(1, 0.5)
minBtn.Position = UDim2.new(1, -55, 0.5, 0)
minBtn.Size = UDim2.fromOffset(30, 30)
minBtn.BackgroundColor3 = C.surfaceAlt
minBtn.AutoButtonColor = false
minBtn.Text = "−"
minBtn.TextColor3 = C.text
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 18
minBtn.Parent = header

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 8)
minCorner.Parent = minBtn

local isMinimized = false
minBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    local target = isMinimized and UDim2.fromOffset(600, 50) or UDim2.fromOffset(600, 380)
    TS:Create(main, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = target}):Play()
end)

local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, -40, 0, 40)
tabBar.Position = UDim2.fromOffset(20, 60)
tabBar.BackgroundTransparency = 1
tabBar.Parent = main

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 8)
tabLayout.Parent = tabBar

local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -40, 1, -120)
content.Position = UDim2.fromOffset(20, 110)
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
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.Visible = false
    scroll.Parent = content
    
    local grid = Instance.new("UIGridLayout")
    grid.CellSize = UDim2.new(0, 260, 0, 85)
    grid.CellPadding = UDim2.new(0, 10, 0, 10)
    grid.SortOrder = Enum.SortOrder.LayoutOrder
    grid.Parent = scroll
    
    pages[name] = scroll
end

makePage("Main")
makePage("Farm Settings")
makePage("Status")

local function showPage(name)
    for n, p in pairs(pages) do p.Visible = (n == name) end
end

local function makeTab(text, pageName)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 120, 1, 0)
    btn.BackgroundColor3 = C.surface
    btn.AutoButtonColor = false
    btn.Text = text
    btn.TextColor3 = C.textMuted
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 12
    btn.Parent = tabBar
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        showPage(pageName)
        for _, child in ipairs(tabBar:GetChildren()) do
            if child:IsA("TextButton") then
                local isActive = (child.Text == text)
                child.BackgroundColor3 = isActive and C.accent or C.surface
                child.TextColor3 = isActive and Color3.new(1,1,1) or C.textMuted
            end
        end
    end)
    
    return btn
end

local firstTab = makeTab("Main", "Main")
makeTab("Farm Settings", "Farm Settings")
makeTab("Status", "Status")

firstTab.BackgroundColor3 = C.accent
firstTab.TextColor3 = Color3.new(1,1,1)

local function createCard(parent, titleText, descText, toggleInitial, callback)
    local card = Instance.new("Frame")
    card.BackgroundColor3 = C.surface
    card.BorderSizePixel = 0
    card.Parent = parent
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = card
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = C.border
    stroke.Thickness = 1
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
    knob.Position = toggleInitial and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    knob.BackgroundColor3 = Color3.new(1,1,1)
    knob.Parent = toggle
    
    local kc = Instance.new("UICorner")
    kc.CornerRadius = UDim.new(1, 0)
    kc.Parent = knob
    
    local state = toggleInitial
    toggle.MouseButton1Click:Connect(function()
        state = not state
        TS:Create(knob, TweenInfo.new(0.15), {Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
        TS:Create(toggle, TweenInfo.new(0.15), {BackgroundColor3 = state and C.accent or C.surfaceAlt}):Play()
        if callback then callback(state) end
    end)
end

local function createDropdown(parent, titleText, options, callback)
    local card = Instance.new("Frame")
    card.BackgroundColor3 = C.surface
    card.BorderSizePixel = 0
    card.Parent = parent
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = card
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = C.border
    stroke.Thickness = 1
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
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -24, 0, 30)
    btn.Position = UDim2.fromOffset(12, 40)
    btn.BackgroundColor3 = C.surfaceAlt
    btn.AutoButtonColor = false
    btn.Text = options[1]
    btn.TextColor3 = C.text
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 11
    btn.Parent = card
    
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 6)
    bc.Parent = btn
    
    local idx = 1
    btn.MouseButton1Click:Connect(function()
        idx = idx + 1
        if idx > #options then idx = 1 end
        btn.Text = options[idx]
        if callback then callback(btn.Text) end
    end)
end

createCard(pages["Main"], "Auto Farm Level", "Automatically farms mobs to max level.", false, function(s) print("Auto Farm Level:", s) end)
createCard(pages["Main"], "Auto Secret Quests", "Completes available Secret Quests.", false, function(s) print("Auto Secret:", s) end)

createCard(pages["Farm Settings"], "Auto Use Buso", "Auto-activates Buso (Armament).", false, function(s) print("Auto Buso:", s) end)
createCard(pages["Farm Settings"], "Auto Use Ken", "Auto-activates Ken (Observation).", false, function(s) print("Auto Ken:", s) end)

createDropdown(pages["Farm Settings"], "Select Weapon", {"Melee", "Sword", "Gun", "Fruit M1", "Fruit Skill", "M1"}, function(v) print("Weapon:", v) end)

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -8, 0, 80)
statusLabel.BackgroundColor3 = C.surface
statusLabel.Text = "Status: Idle\nLevel: 3000\nWeapon: Melee"
statusLabel.TextColor3 = C.text
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = pages["Status"]

local sc = Instance.new("UICorner")
sc.CornerRadius = UDim.new(0, 8)
sc.Parent = statusLabel

local sp = Instance.new("UIPadding")
sp.PaddingLeft = UDim.new(0, 15)
sp.PaddingTop = UDim.new(0, 10)
sp.Parent = statusLabel

showPage("Main")

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
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
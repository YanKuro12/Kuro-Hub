local UserInputService = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local CoreGui           = game:GetService("CoreGui")

local C = {
    bg          = Color3.fromRGB(18, 18, 24),
    surface     = Color3.fromRGB(26, 26, 34),
    surfaceAlt  = Color3.fromRGB(32, 32, 42),
    border      = Color3.fromRGB(48, 48, 64),
    accent      = Color3.fromRGB(99, 102, 241),   -- indigo
    accentHover = Color3.fromRGB(129, 132, 255),
    text        = Color3.fromRGB(235, 235, 245),
    textMuted   = Color3.fromRGB(140, 140, 165),
    success     = Color3.fromRGB(52, 211, 153),
    danger      = Color3.fromRGB(248, 113, 113),
}

local gui = Instance.new("ScreenGui")
gui.Name = "KuroKeySystem"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.Parent = CoreGui

local overlay = Instance.new("Frame")
overlay.Size = UDim2.fromScale(1, 1)
overlay.BackgroundColor3 = Color3.new(0, 0, 0)
overlay.BackgroundTransparency = 0.45
overlay.BorderSizePixel = 0
overlay.Parent = gui

local WINDOW_W, WINDOW_H = 420, 500
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(WINDOW_W, WINDOW_H)
main.Position = UDim2.new(0.5, -WINDOW_W / 2, 0.5, -WINDOW_H / 2)
main.BackgroundColor3 = C.bg
main.BorderSizePixel = 0
main.Active = true
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = C.border
mainStroke.Thickness = 1
mainStroke.Transparency = 0.2
mainStroke.Parent = main

local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.Position = UDim2.fromScale(0.5, 0.5)
shadow.Size = UDim2.new(1, 40, 1, 40)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://6015897843"
shadow.ImageColor3 = Color3.new(0, 0, 0)
shadow.ImageTransparency = 0.55
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(49, 49, 450, 450)
shadow.ZIndex = -1
shadow.Parent = main

local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 68)
header.BackgroundTransparency = 1
header.Parent = main

local logo = Instance.new("Frame")
logo.Size = UDim2.fromOffset(40, 40)
logo.Position = UDim2.fromOffset(22, 16)
logo.BackgroundColor3 = C.accent
logo.BorderSizePixel = 0
logo.Parent = header

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0, 10)
logoCorner.Parent = logo

local logoText = Instance.new("TextLabel")
logoText.Size = UDim2.fromScale(1, 1)
logoText.BackgroundTransparency = 1
logoText.Text = "K"
logoText.TextColor3 = Color3.new(1, 1, 1)
logoText.TextSize = 20
logoText.Font = Enum.Font.GothamBold
logoText.Parent = logo

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -160, 0, 20)
title.Position = UDim2.fromOffset(74, 18)
title.BackgroundTransparency = 1
title.Text = "Kuro Hub"
title.TextColor3 = C.text
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -160, 0, 14)
subtitle.Position = UDim2.fromOffset(74, 38)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Enter your access key to continue"
subtitle.TextColor3 = C.textMuted
subtitle.TextSize = 11
subtitle.Font = Enum.Font.Gotham
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = header

local function makeIconButton(text, xOffset, hoverBg, hoverText)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromOffset(30, 30)
    btn.Position = UDim2.new(1, xOffset, 0, 19)
    btn.BackgroundColor3 = C.surface
    btn.AutoButtonColor = false
    btn.Text = text
    btn.TextColor3 = C.textMuted
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamBold
    btn.Parent = header

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = hoverBg}):Play()
        TweenService:Create(btn, TweenInfo.new(0.15), {TextColor3 = hoverText}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = C.surface}):Play()
        TweenService:Create(btn, TweenInfo.new(0.15), {TextColor3 = C.textMuted}):Play()
    end)
    return btn
end

local minimizeBtn = makeIconButton("−", -76, C.surfaceAlt, C.text)
local closeBtn    = makeIconButton("×", -40, C.danger,     Color3.new(1, 1, 1))

local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, -44, 0, 1)
divider.Position = UDim2.fromOffset(22, 68)
divider.BackgroundColor3 = C.border
divider.BackgroundTransparency = 0.4
divider.BorderSizePixel = 0
divider.Parent = main

local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -44, 1, -68)
content.Position = UDim2.fromOffset(22, 84)
content.BackgroundTransparency = 1
content.Parent = main

local statusPill = Instance.new("Frame")
statusPill.Size = UDim2.fromOffset(160, 28)
statusPill.BackgroundColor3 = C.surface
statusPill.BorderSizePixel = 0
statusPill.Parent = content

local statusPillCorner = Instance.new("UICorner")
statusPillCorner.CornerRadius = UDim.new(1, 0)
statusPillCorner.Parent = statusPill

local statusDot = Instance.new("Frame")
statusDot.Size = UDim2.fromOffset(8, 8)
statusDot.Position = UDim2.new(0, 12, 0.5, -4)
statusDot.BackgroundColor3 = C.danger
statusDot.BorderSizePixel = 0
statusDot.Parent = statusPill

local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = statusDot

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -32, 1, 0)
statusLabel.Position = UDim2.fromOffset(28, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Not verified"
statusLabel.TextColor3 = C.text
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.GothamMedium
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = statusPill

-- Field label
local keyLabel = Instance.new("TextLabel")
keyLabel.Size = UDim2.new(1, 0, 0, 16)
keyLabel.Position = UDim2.fromOffset(0, 48)
keyLabel.BackgroundTransparency = 1
keyLabel.Text = "Access Key"
keyLabel.TextColor3 = C.textMuted
keyLabel.TextSize = 11
keyLabel.Font = Enum.Font.GothamSemibold
keyLabel.TextXAlignment = Enum.TextXAlignment.Left
keyLabel.Parent = content

-- Key input
local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(1, 0, 0, 46)
keyBox.Position = UDim2.fromOffset(0, 70)
keyBox.BackgroundColor3 = C.surface
keyBox.BorderSizePixel = 0
keyBox.PlaceholderText = "Paste your key here"
keyBox.Text = ""
keyBox.ClearTextOnFocus = false
keyBox.TextColor3 = C.text
keyBox.PlaceholderColor3 = C.textMuted
keyBox.TextSize = 13
keyBox.Font = Enum.Font.Gotham
keyBox.TextXAlignment = Enum.TextXAlignment.Left
keyBox.Parent = content

local keyCorner = Instance.new("UICorner")
keyCorner.CornerRadius = UDim.new(0, 10)
keyCorner.Parent = keyBox

local keyStroke = Instance.new("UIStroke")
keyStroke.Color = C.border
keyStroke.Thickness = 1
keyStroke.Parent = keyBox

local keyPad = Instance.new("UIPadding")
keyPad.PaddingLeft = UDim.new(0, 14)
keyPad.PaddingRight = UDim.new(0, 14)
keyPad.Parent = keyBox

-- focus animation
keyBox.Focused:Connect(function()
    TweenService:Create(keyStroke, TweenInfo.new(0.15), {Color = C.accent}):Play()
end)
keyBox.FocusLost:Connect(function()
    TweenService:Create(keyStroke, TweenInfo.new(0.15), {Color = C.border}):Play()
end)

-- Submit
local submitBtn = Instance.new("TextButton")
submitBtn.Size = UDim2.new(1, 0, 0, 46)
submitBtn.Position = UDim2.fromOffset(0, 128)
submitBtn.BackgroundColor3 = C.accent
submitBtn.AutoButtonColor = false
submitBtn.Text = "Verify Key"
submitBtn.TextColor3 = Color3.new(1, 1, 1)
submitBtn.TextSize = 13
submitBtn.Font = Enum.Font.GothamBold
submitBtn.Parent = content

local submitCorner = Instance.new("UICorner")
submitCorner.CornerRadius = UDim.new(0, 10)
submitCorner.Parent = submitBtn

submitBtn.MouseEnter:Connect(function()
    TweenService:Create(submitBtn, TweenInfo.new(0.15), {BackgroundColor3 = C.accentHover}):Play()
end)
submitBtn.MouseLeave:Connect(function()
    TweenService:Create(submitBtn, TweenInfo.new(0.15), {BackgroundColor3 = C.accent}):Play()
end)

-- Secondary actions row
local actionRow = Instance.new("Frame")
actionRow.Size = UDim2.new(1, 0, 0, 40)
actionRow.Position = UDim2.fromOffset(0, 186)
actionRow.BackgroundTransparency = 1
actionRow.Parent = content

local function makeGhostButton(text, xScale, xOffset, widthScale)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(widthScale, -6, 1, 0)
    btn.Position = UDim2.new(xScale, xOffset, 0, 0)
    btn.BackgroundColor3 = C.surface
    btn.AutoButtonColor = false
    btn.Text = text
    btn.TextColor3 = C.text
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = actionRow

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 10)
    c.Parent = btn

    local s = Instance.new("UIStroke")
    s.Color = C.border
    s.Thickness = 1
    s.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = C.surfaceAlt}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = C.surface}):Play()
    end)
    return btn
end

local copyBtn = makeGhostButton("Copy Discord", 0, 0, 0.5)
local getBtn  = makeGhostButton("Get Key",      0.5, 6, 0.5)

-- Info card
local infoCard = Instance.new("Frame")
infoCard.Size = UDim2.new(1, 0, 1, -238)
infoCard.Position = UDim2.fromOffset(0, 238)
infoCard.BackgroundColor3 = C.surface
infoCard.BorderSizePixel = 0
infoCard.Parent = content

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 12)
infoCorner.Parent = infoCard

local infoStroke = Instance.new("UIStroke")
infoStroke.Color = C.border
infoStroke.Thickness = 1
infoStroke.Transparency = 0.5
infoStroke.Parent = infoCard

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -28, 1, -28)
infoLabel.Position = UDim2.fromOffset(14, 14)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "Don't have a key?\nJoin our Discord server to get one for free.\n\ndiscord.gg/kurodev"
infoLabel.TextColor3 = C.textMuted
infoLabel.TextSize = 11
infoLabel.Font = Enum.Font.Gotham
infoLabel.LineHeight = 1.3
infoLabel.TextWrapped = true
infoLabel.TextYAlignment = Enum.TextYAlignment.Top
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.Parent = infoCard

-- ---------- Minimize ----------
local isMinimized = false
local normalSize    = UDim2.fromOffset(WINDOW_W, WINDOW_H)
local minimizedSize = UDim2.fromOffset(WINDOW_W, 68)

local function toggleMinimize()
    isMinimized = not isMinimized
    if isMinimized then
        content.Visible = false
        divider.Visible = false
        TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = minimizedSize}):Play()
    else
        TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = normalSize}):Play()
        task.wait(0.05)
        content.Visible = true
        divider.Visible = true
    end
end

minimizeBtn.MouseButton1Click:Connect(toggleMinimize)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- ---------- Verify ----------
local VALID_KEY = "WAFZONEX"

submitBtn.MouseButton1Click:Connect(function()
    if keyBox.Text == VALID_KEY then
        statusLabel.Text = "Verified"
        statusDot.BackgroundColor3 = C.success
        submitBtn.Text = "Verified ✓"
        submitBtn.BackgroundColor3 = C.success
        TweenService:Create(keyStroke, TweenInfo.new(0.2), {Color = C.success}):Play()
        task.wait(0.6)
        gui:Destroy()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/YanKuro12/Kuro-Hub/main/script.lua"))()
    else
        statusLabel.Text = "Invalid key"
        statusDot.BackgroundColor3 = C.danger
        keyBox.Text = ""
        keyStroke.Color = C.danger
        TweenService:Create(keyStroke, TweenInfo.new(0.4), {Color = C.border}):Play()
        -- shake
        local orig = main.Position
        for i = 1, 6 do
            local dx = (i % 2 == 0) and 8 or -8
            main.Position = orig + UDim2.fromOffset(dx, 0)
            task.wait(0.03)
        end
        main.Position = orig
    end
end)

-- ---------- Clipboard ----------
local function flashButton(btn, label)
    btn.Text = "Copied ✓"
    task.wait(1)
    btn.Text = label
end

copyBtn.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/kurodev")
    flashButton(copyBtn, "Copy Discord")
end)

getBtn.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/kurodev")
    flashButton(getBtn, "Get Key")
end)

-- ---------- Dragging ----------
local dragging, dragInput, dragStart, startPos
local function onDragStart(input)
    dragging  = true
    dragStart = input.Position
    startPos  = main.Position
    input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
            dragging = false
        end
    end)
end

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        onDragStart(input)
    end
end)

header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local d = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + d.X,
            startPos.Y.Scale, startPos.Y.Offset + d.Y
        )
    end
end)
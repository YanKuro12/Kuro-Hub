local UserInputService = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local CoreGui           = game:GetService("CoreGui")

local C = {
    bg          = Color3.fromRGB(16, 16, 22),
    surface     = Color3.fromRGB(24, 24, 32),
    surfaceAlt  = Color3.fromRGB(32, 32, 42),
    border      = Color3.fromRGB(52, 52, 70),
    accent      = Color3.fromRGB(99, 102, 241),
    accentHover = Color3.fromRGB(129, 132, 255),
    text        = Color3.fromRGB(235, 235, 245),
    textMuted   = Color3.fromRGB(140, 140, 165),
    success     = Color3.fromRGB(52, 211, 153),
    danger      = Color3.fromRGB(248, 113, 113),
    dangerHover = Color3.fromRGB(255, 140, 140),
}

local function isMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

local function getViewport()
    local cam = workspace.CurrentCamera
    return cam and cam.ViewportSize or Vector2.new(1280, 720)
end

local BASE_W, BASE_H = 420, 520

local function computeScale()
    local vp = getViewport()
    local sx = (vp.X * 0.9) / BASE_W
    local sy = (vp.Y * 0.9) / BASE_H
    local s  = math.min(sx, sy)
    if isMobile() then
        return math.clamp(s, 0.62, 1.0)
    end
    return math.clamp(s, 0.7, 1.0)
end

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
overlay.BackgroundTransparency = 0.5
overlay.BorderSizePixel = 0
overlay.Parent = gui

local main = Instance.new("Frame")
main.Name = "Main"
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)
main.Size = UDim2.fromOffset(BASE_W, BASE_H)
main.BackgroundColor3 = C.bg
main.BorderSizePixel = 0
main.Active = true
main.ClipsDescendants = true
main.Parent = gui

local uiScale = Instance.new("UIScale")
uiScale.Scale = computeScale()
uiScale.Parent = main

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = C.border
mainStroke.Thickness = 1
mainStroke.Transparency = 0.15
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
mainStroke.Parent = main

local function refreshScale()
    local newScale = computeScale()
    TweenService:Create(uiScale, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Scale = newScale}):Play()
end

workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(refreshScale)

local HEADER_H = 68

local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, HEADER_H)
header.BackgroundTransparency = 1
header.Parent = main

local logo = Instance.new("Frame")
logo.Size = UDim2.fromOffset(40, 40)
logo.Position = UDim2.fromOffset(20, 14)
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
title.Size = UDim2.new(1, -170, 0, 20)
title.Position = UDim2.fromOffset(72, 16)
title.BackgroundTransparency = 1
title.Text = "Kuro Hub"
title.TextColor3 = C.text
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -170, 0, 14)
subtitle.Position = UDim2.fromOffset(72, 36)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Masukkan access key untuk melanjutkan"
subtitle.TextColor3 = C.textMuted
subtitle.TextSize = 11
subtitle.Font = Enum.Font.Gotham
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = header

local function makeIconButton(text, xOffset, hoverBg, hoverText)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromOffset(32, 32)
    btn.Position = UDim2.new(1, xOffset, 0, 18)
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

local minimizeBtn = makeIconButton("−", -80, C.surfaceAlt, C.text)
local closeBtn    = makeIconButton("×", -42, C.danger, Color3.new(1, 1, 1))

local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, -40, 0, 1)
divider.Position = UDim2.fromOffset(20, HEADER_H)
divider.BackgroundColor3 = C.border
divider.BackgroundTransparency = 0.5
divider.BorderSizePixel = 0
divider.Parent = main

local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -40, 1, -HEADER_H - 20)
content.Position = UDim2.fromOffset(20, HEADER_H + 20)
content.BackgroundTransparency = 1
content.Parent = main

local statusPill = Instance.new("Frame")
statusPill.Size = UDim2.fromOffset(170, 28)
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
statusLabel.Text = "Belum terverifikasi"
statusLabel.TextColor3 = C.text
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.GothamMedium
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = statusPill

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

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(1, 0, 0, 46)
keyBox.Position = UDim2.fromOffset(0, 70)
keyBox.BackgroundColor3 = C.surface
keyBox.BorderSizePixel = 0
keyBox.PlaceholderText = "Tempel key kamu di sini"
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

keyBox.Focused:Connect(function()
    TweenService:Create(keyStroke, TweenInfo.new(0.15), {Color = C.accent}):Play()
end)
keyBox.FocusLost:Connect(function()
    TweenService:Create(keyStroke, TweenInfo.new(0.15), {Color = C.border}):Play()
end)

local submitBtn = Instance.new("TextButton")
submitBtn.Size = UDim2.new(1, 0, 0, 46)
submitBtn.Position = UDim2.fromOffset(0, 128)
submitBtn.BackgroundColor3 = C.accent
submitBtn.AutoButtonColor = false
submitBtn.Text = "Verifikasi Key"
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
local getBtn  = makeGhostButton("Get Key", 0.5, 6, 0.5)

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
infoStroke.Transparency = 0.6
infoStroke.Parent = infoCard

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -28, 1, -28)
infoLabel.Position = UDim2.fromOffset(14, 14)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "Belum punya key?\nGabung Discord kami untuk mendapatkannya gratis.\n\ndiscord.gg/kurodev"
infoLabel.TextColor3 = C.textMuted
infoLabel.TextSize = 11
infoLabel.Font = Enum.Font.Gotham
infoLabel.LineHeight = 1.3
infoLabel.TextWrapped = true
infoLabel.TextYAlignment = Enum.TextYAlignment.Top
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.Parent = infoCard

local isMinimized = false
local normalSize = UDim2.fromOffset(BASE_W, BASE_H)
local minimizedSize = UDim2.fromOffset(BASE_W, HEADER_H)

local function toggleMinimize()
    isMinimized = not isMinimized
    if isMinimized then
        TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = minimizedSize}):Play()
        TweenService:Create(content, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        content.Visible = false
        divider.Visible = false
    else
        content.Visible = true
        divider.Visible = true
        TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = normalSize}):Play()
    end
end

minimizeBtn.MouseButton1Click:Connect(toggleMinimize)

closeBtn.MouseButton1Click:Connect(function()
    TweenService:Create(main, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        Size = UDim2.fromOffset(BASE_W, 0),
        BackgroundTransparency = 1
    }):Play()
    TweenService:Create(mainStroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
    task.wait(0.22)
    gui:Destroy()
end)

local VALID_KEY = "WAFZONEX"

submitBtn.MouseButton1Click:Connect(function()
    if keyBox.Text == VALID_KEY then
        statusLabel.Text = "Terverifikasi"
        statusDot.BackgroundColor3 = C.success
        submitBtn.Text = "Verified ✓"
        submitBtn.BackgroundColor3 = C.success
        TweenService:Create(keyStroke, TweenInfo.new(0.2), {Color = C.success}):Play()
        task.wait(0.6)
        gui:Destroy()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/YanKuro12/Kuro-Hub/main/script.lua"))()
    else
        statusLabel.Text = "Key salah"
        statusDot.BackgroundColor3 = C.danger
        keyBox.Text = ""
        keyStroke.Color = C.danger
        TweenService:Create(keyStroke, TweenInfo.new(0.4), {Color = C.border}):Play()
        local origPos = main.Position
        for i = 1, 6 do
            local dx = (i % 2 == 0) and 8 or -8
            main.Position = origPos + UDim2.fromOffset(dx, 0)
            task.wait(0.03)
        end
        main.Position = origPos
    end
end)

keyBox.FocusLost:Connect(function(enter)
    if enter then
        submitBtn:Fire("MouseButton1Click")
    end
end)

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

local dragging = false
local dragInput, dragStart, startPos

local function clampPosition(pos)
    local vp = getViewport()
    local scale = uiScale.Scale
    local w = BASE_W * scale
    local h = (isMinimized and HEADER_H or BASE_H) * scale
    local halfW = w / 2
    local halfH = h / 2

    local px = pos.X.Offset
    local py = pos.Y.Offset
    local cx = vp.X / 2
    local cy = vp.Y / 2

    local absX = cx + px
    local absY = cy + py

    absX = math.clamp(absX, halfW + 8, vp.X - halfW - 8)
    absY = math.clamp(absY, halfH + 8, vp.Y - halfH - 8)

    return UDim2.new(0.5, absX - cx, 0.5, absY - cy)
end

local function beginDrag(input)
    dragging = true
    dragStart = input.Position
    startPos = main.Position
    input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
            dragging = false
        end
    end)
end

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        beginDrag(input)
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
        local delta = input.Position - dragStart
        local newPos = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
        main.Position = clampPosition(newPos)
    end
end)

UserInputService.TouchEnded:Connect(function()
    dragging = false
end)
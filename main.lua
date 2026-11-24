local UserInputService = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local CoreGui           = game:GetService("CoreGui")
local HttpService       = game:GetService("HttpService")
local Lighting          = game:GetService("Lighting")

local KEY_SYSTEM_ENABLED = false

local LUARMOR_SCRIPT_ID = "ISI_SCRIPT_ID_LUARMOR_KAMU"
local KEY_FILE          = "kuro_key.txt"
local SETTINGS_FILE     = "kuro_settings.json"
local SCRIPT_URL        = "https://raw.githubusercontent.com/YanKuro12/Kuro-Hub/main/script.lua"

local THEMES = {
    { name = "Indigo",  accent = Color3.fromRGB(99, 102, 241),  hover = Color3.fromRGB(129, 132, 255) },
    { name = "Emerald", accent = Color3.fromRGB(16, 185, 129),  hover = Color3.fromRGB(52, 211, 153) },
    { name = "Rose",    accent = Color3.fromRGB(244, 63, 94),   hover = Color3.fromRGB(251, 113, 133) },
    { name = "Amber",   accent = Color3.fromRGB(245, 158, 11),  hover = Color3.fromRGB(251, 191, 36) },
    { name = "Sky",     accent = Color3.fromRGB(14, 165, 233),  hover = Color3.fromRGB(56, 189, 248) },
    { name = "Violet",  accent = Color3.fromRGB(168, 85, 247),  hover = Color3.fromRGB(192, 132, 252) },
}

local C = {
    bg          = Color3.fromRGB(16, 16, 22),
    surface     = Color3.fromRGB(24, 24, 32),
    surfaceAlt  = Color3.fromRGB(32, 32, 42),
    border      = Color3.fromRGB(52, 52, 70),
    accent      = THEMES[1].accent,
    accentHover = THEMES[1].hover,
    text        = Color3.fromRGB(235, 235, 245),
    textMuted   = Color3.fromRGB(140, 140, 165),
    success     = Color3.fromRGB(52, 211, 153),
    danger      = Color3.fromRGB(248, 113, 113),
    dangerHover = Color3.fromRGB(255, 140, 140),
}

local SETTINGS = {
    fpsBooster   = false,
    lowGraphics  = false,
    themeIndex   = 1,
    uiScale      = 1.0,
}

local function loadSettings()
    if not (isfile and isfile(SETTINGS_FILE)) then return end
    local ok, content = pcall(readfile, SETTINGS_FILE)
    if not ok or not content or content == "" then return end
    local ok2, data = pcall(function() return HttpService:JSONDecode(content) end)
    if not ok2 or type(data) ~= "table" then return end
    for k, v in pairs(data) do
        if SETTINGS[k] ~= nil then SETTINGS[k] = v end
    end
    if THEMES[SETTINGS.themeIndex] then
        C.accent = THEMES[SETTINGS.themeIndex].accent
        C.accentHover = THEMES[SETTINGS.themeIndex].hover
    end
end

local function saveSettings()
    if not writefile then return end
    local ok, encoded = pcall(function() return HttpService:JSONEncode(SETTINGS) end)
    if ok then pcall(writefile, SETTINGS_FILE, encoded) end
end

loadSettings()

local function applyFPSBooster(state)
    pcall(function()
        settings().Rendering.QualityLevel = state and Enum.QualityLevel.Level01 or Enum.QualityLevel.Level10
    end)
    pcall(function()
        for _, obj in ipairs(Lighting:GetDescendants()) do
            if obj:IsA("PostEffect") or obj:IsA("Atmosphere") or obj:IsA("Sky") then
                obj.Enabled = not state
            end
        end
    end)
end

local function applyLowGraphics(state)
    pcall(function()
        Lighting.GlobalShadows = not state
        Lighting.FogEnd = state and 100000 or 100000
        Lighting.Brightness = state and 1 or 2
    end)
    pcall(function()
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                obj.Enabled = not state
            end
        end
    end)
    pcall(function()
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if terrain then terrain.Decoration = not state end
    end)
end

if SETTINGS.fpsBooster then applyFPSBooster(true) end
if SETTINGS.lowGraphics then applyLowGraphics(true) end

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
    local minS = isMobile() and 0.5 or 0.65
    return math.clamp(s, minS, 1.0) * SETTINGS.uiScale
end

if not KEY_SYSTEM_ENABLED then
    loadstring(game:HttpGet(SCRIPT_URL))()
    return
end

local LuarmorAPI
do
    local ok, lib = pcall(function()
        return loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()
    end)
    if ok and lib then
        LuarmorAPI = lib
        LuarmorAPI.script_id = LUARMOR_SCRIPT_ID
    else
        warn("[Kuro] Gagal load Luarmor library")
    end
end

local function readKeyFile()
    if not (isfile and isfile(KEY_FILE)) then return nil end
    local ok, content = pcall(readfile, KEY_FILE)
    if not ok or not content or content == "" then return nil end
    return content
end

local function saveKeyFile(key)
    if not writefile then return false end
    return pcall(writefile, KEY_FILE, key)
end

local function deleteKeyFile()
    if delfile and isfile and isfile(KEY_FILE) then
        pcall(delfile, KEY_FILE)
    end
end

local function verifyKey(inputKey)
    if not LuarmorAPI then return false, "Library Luarmor gagal dimuat" end
    if not inputKey or inputKey == "" then return false, "Key kosong" end
    local ok, status = pcall(function() return LuarmorAPI.check_key(inputKey) end)
    if not ok or not status then return false, "Gagal cek key" end
    if status.code == "KEY_VALID" then return true, "OK"
    elseif status.code == "KEY_HWID_LOCKED" then return false, "Key sudah dipakai di device lain"
    elseif status.code == "KEY_INCORRECT" then return false, "Key salah"
    elseif status.code == "KEY_EXPIRED" then return false, "Key expired"
    else return false, "Verifikasi gagal: " .. tostring(status.code) end
end

local function tryAutoLogin()
    local savedKey = readKeyFile()
    if not savedKey then return false end
    local valid, _ = verifyKey(savedKey)
    if valid then return true end
    deleteKeyFile()
    return false
end

if tryAutoLogin() then
    loadstring(game:HttpGet(SCRIPT_URL))()
    return
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
title.Size = UDim2.new(1, -190, 0, 20)
title.Position = UDim2.fromOffset(72, 16)
title.BackgroundTransparency = 1
title.Text = "Kuro Hub"
title.TextColor3 = C.text
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -190, 0, 14)
subtitle.Position = UDim2.fromOffset(72, 36)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Masukkan access key untuk melanjutkan"
subtitle.TextColor3 = C.textMuted
subtitle.TextSize = 11
subtitle.Font = Enum.Font.Gotham
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = header

local headerBtns = Instance.new("Frame")
headerBtns.Name = "HeaderButtons"
headerBtns.AnchorPoint = Vector2.new(1, 0)
headerBtns.Position = UDim2.new(1, -16, 0, 18)
headerBtns.Size = UDim2.fromOffset(112, 32)
headerBtns.BackgroundTransparency = 1
headerBtns.Parent = header

local headerBtnLayout = Instance.new("UIListLayout")
headerBtnLayout.FillDirection = Enum.FillDirection.Horizontal
headerBtnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
headerBtnLayout.Padding = UDim.new(0, 6)
headerBtnLayout.SortOrder = Enum.SortOrder.LayoutOrder
headerBtnLayout.Parent = headerBtns

local function makeIconButton(text, hoverBg, hoverText, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromOffset(32, 32)
    btn.BackgroundColor3 = C.surface
    btn.AutoButtonColor = false
    btn.Text = text
    btn.TextColor3 = C.textMuted
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamBold
    btn.LayoutOrder = order
    btn.Parent = headerBtns

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

local settingsBtn = makeIconButton("⚙", C.surfaceAlt, C.text, 1)
local minimizeBtn = makeIconButton("−", C.surfaceAlt, C.text, 2)
local closeBtn    = makeIconButton("×", C.danger, Color3.new(1, 1, 1), 3)

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
infoLabel.Text = "Belum punya key?\nGabung Discord kami, lalu kerjakan misi untuk mendapat key gratis.\n\ndiscord.gg/kurodev"
infoLabel.TextColor3 = C.textMuted
infoLabel.TextSize = 11
infoLabel.Font = Enum.Font.Gotham
infoLabel.LineHeight = 1.3
infoLabel.TextWrapped = true
infoLabel.TextYAlignment = Enum.TextYAlignment.Top
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.Parent = infoCard

local settingsPanel = Instance.new("Frame")
settingsPanel.Name = "SettingsPanel"
settingsPanel.Size = UDim2.new(1, -40, 1, -HEADER_H - 20)
settingsPanel.Position = UDim2.fromOffset(20, HEADER_H + 20)
settingsPanel.BackgroundTransparency = 1
settingsPanel.Visible = false
settingsPanel.ClipsDescendants = true
settingsPanel.Parent = main

local settingsScroll = Instance.new("ScrollingFrame")
settingsScroll.Size = UDim2.new(1, 0, 1, 0)
settingsScroll.BackgroundTransparency = 1
settingsScroll.BorderSizePixel = 0
settingsScroll.ScrollBarThickness = 4
settingsScroll.ScrollBarImageColor3 = C.border
settingsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
settingsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
settingsScroll.Parent = settingsPanel

local settingsLayout = Instance.new("UIListLayout")
settingsLayout.Padding = UDim.new(0, 10)
settingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
settingsLayout.Parent = settingsScroll

local function makeSection(titleText, order)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, -8, 0, 20)
    section.BackgroundTransparency = 1
    section.LayoutOrder = order
    section.Parent = settingsScroll

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.fromScale(1, 1)
    lbl.BackgroundTransparency = 1
    lbl.Text = titleText
    lbl.TextColor3 = C.text
    lbl.TextSize = 13
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = section

    return section
end

local function makeToggle(labelText, initialState, onChange, order)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -8, 0, 44)
    row.BackgroundColor3 = C.surface
    row.BorderSizePixel = 0
    row.LayoutOrder = order
    row.Parent = settingsScroll

    local rc = Instance.new("UICorner")
    rc.CornerRadius = UDim.new(0, 10)
    rc.Parent = row

    local rs = Instance.new("UIStroke")
    rs.Color = C.border
    rs.Thickness = 1
    rs.Parent = row

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -80, 1, 0)
    lbl.Position = UDim2.fromOffset(14, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = C.text
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local track = Instance.new("Frame")
    track.AnchorPoint = Vector2.new(1, 0.5)
    track.Position = UDim2.new(1, -14, 0.5, 0)
    track.Size = UDim2.fromOffset(44, 24)
    track.BackgroundColor3 = initialState and C.accent or C.surfaceAlt
    track.BorderSizePixel = 0
    track.Parent = row

    local tc = Instance.new("UICorner")
    tc.CornerRadius = UDim.new(1, 0)
    tc.Parent = track

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(18, 18)
    knob.Position = initialState and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.BorderSizePixel = 0
    knob.Parent = track

    local kc = Instance.new("UICorner")
    kc.CornerRadius = UDim.new(1, 0)
    kc.Parent = knob

    local state = initialState
    local clickable = Instance.new("TextButton")
    clickable.Size = UDim2.fromScale(1, 1)
    clickable.BackgroundTransparency = 1
    clickable.Text = ""
    clickable.Parent = row

    clickable.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(knob, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {
            Position = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        }):Play()
        TweenService:Create(track, TweenInfo.new(0.18), {
            BackgroundColor3 = state and C.accent or C.surfaceAlt
        }):Play()
        onChange(state)
    end)

    return row, function() return state end
end

local function makeButtonRow(labelText, buttonText, onClick, order)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -8, 0, 44)
    row.BackgroundColor3 = C.surface
    row.BorderSizePixel = 0
    row.LayoutOrder = order
    row.Parent = settingsScroll

    local rc = Instance.new("UICorner")
    rc.CornerRadius = UDim.new(0, 10)
    rc.Parent = row

    local rs = Instance.new("UIStroke")
    rs.Color = C.border
    rs.Thickness = 1
    rs.Parent = row

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -120, 1, 0)
    lbl.Position = UDim2.fromOffset(14, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = C.text
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local btn = Instance.new("TextButton")
    btn.AnchorPoint = Vector2.new(1, 0.5)
    btn.Position = UDim2.new(1, -14, 0.5, 0)
    btn.Size = UDim2.fromOffset(90, 28)
    btn.BackgroundColor3 = C.accent
    btn.AutoButtonColor = false
    btn.Text = buttonText
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = row

    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 8)
    bc.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = C.accentHover}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = C.accent}):Play()
    end)
    btn.MouseButton1Click:Connect(onClick)

    return row
end

local sectionPerf = makeSection("PERFORMA", 1)
makeToggle("FPS Booster", SETTINGS.fpsBooster, function(state)
    SETTINGS.fpsBooster = state
    applyFPSBooster(state)
    saveSettings()
end, 2)
makeToggle("Grafik Low (HP Kentang)", SETTINGS.lowGraphics, function(state)
    SETTINGS.lowGraphics = state
    applyLowGraphics(state)
    saveSettings()
end, 3)

local sectionTheme = makeSection("TEMA WARNA", 4)

local themeRow = Instance.new("Frame")
themeRow.Size = UDim2.new(1, -8, 0, 76)
themeRow.BackgroundColor3 = C.surface
themeRow.BorderSizePixel = 0
themeRow.LayoutOrder = 5
themeRow.Parent = settingsScroll

local themeRowCorner = Instance.new("UICorner")
themeRowCorner.CornerRadius = UDim.new(0, 10)
themeRowCorner.Parent = themeRow

local themeRowStroke = Instance.new("UIStroke")
themeRowStroke.Color = C.border
themeRowStroke.Thickness = 1
themeRowStroke.Parent = themeRow

local themeGrid = Instance.new("Frame")
themeGrid.Size = UDim2.new(1, -20, 1, -20)
themeGrid.Position = UDim2.fromOffset(10, 10)
themeGrid.BackgroundTransparency = 1
themeGrid.Parent = themeRow

local themeLayout = Instance.new("UIListLayout")
themeLayout.FillDirection = Enum.FillDirection.Horizontal
themeLayout.Padding = UDim.new(0, 8)
themeLayout.SortOrder = Enum.SortOrder.LayoutOrder
themeLayout.Parent = themeGrid

for i, theme in ipairs(THEMES) do
    local sw = Instance.new("TextButton")
    sw.Size = UDim2.fromOffset(38, 38)
    sw.BackgroundColor3 = theme.accent
    sw.AutoButtonColor = false
    sw.Text = (i == SETTINGS.themeIndex) and "✓" or ""
    sw.TextColor3 = Color3.new(1, 1, 1)
    sw.TextSize = 16
    sw.Font = Enum.Font.GothamBold
    sw.LayoutOrder = i
    sw.Parent = themeGrid

    local swc = Instance.new("UICorner")
    swc.CornerRadius = UDim.new(1, 0)
    swc.Parent = sw

    local sws = Instance.new("UIStroke")
    sws.Color = (i == SETTINGS.themeIndex) and Color3.new(1, 1, 1) or C.border
    sws.Thickness = (i == SETTINGS.themeIndex) and 2 or 1
    sws.Parent = sw

    sw.MouseButton1Click:Connect(function()
        SETTINGS.themeIndex = i
        C.accent = theme.accent
        C.accentHover = theme.hover

        for _, child in ipairs(themeGrid:GetChildren()) do
            if child:IsA("TextButton") then
                local idx = child.LayoutOrder
                child.Text = (idx == i) and "✓" or ""
                local s = child:FindFirstChildOfClass("UIStroke")
                if s then
                    s.Color = (idx == i) and Color3.new(1, 1, 1) or C.border
                    s.Thickness = (idx == i) and 2 or 1
                end
            end
        end

        logo.BackgroundColor3 = C.accent
        submitBtn.BackgroundColor3 = C.accent
        settingsBtn.MouseEnter:Connect(function() end)
        for _, obj in ipairs({logo}) do
            if obj.BackgroundColor3 then obj.BackgroundColor3 = C.accent end
        end

        saveSettings()
    end)
end

local sectionSize = makeSection("UKURAN TAMPILAN", 6)

local sizeRow = Instance.new("Frame")
sizeRow.Size = UDim2.new(1, -8, 0, 64)
sizeRow.BackgroundColor3 = C.surface
sizeRow.BorderSizePixel = 0
sizeRow.LayoutOrder = 7
sizeRow.Parent = settingsScroll

local sizeRowCorner = Instance.new("UICorner")
sizeRowCorner.CornerRadius = UDim.new(0, 10)
sizeRowCorner.Parent = sizeRow

local sizeRowStroke = Instance.new("UIStroke")
sizeRowStroke.Color = C.border
sizeRowStroke.Thickness = 1
sizeRowStroke.Parent = sizeRow

local sizeLabel = Instance.new("TextLabel")
sizeLabel.Size = UDim2.new(1, -28, 0, 20)
sizeLabel.Position = UDim2.fromOffset(14, 8)
sizeLabel.BackgroundTransparency = 1
sizeLabel.Text = "Skala UI: " .. string.format("%.0f%%", SETTINGS.uiScale * 100)
sizeLabel.TextColor3 = C.text
sizeLabel.TextSize = 12
sizeLabel.Font = Enum.Font.GothamMedium
sizeLabel.TextXAlignment = Enum.TextXAlignment.Left
sizeLabel.Parent = sizeRow

local sizeBtns = Instance.new("Frame")
sizeBtns.Size = UDim2.new(1, -28, 0, 26)
sizeBtns.Position = UDim2.fromOffset(14, 30)
sizeBtns.BackgroundTransparency = 1
sizeBtns.Parent = sizeRow

local sizeLayout = Instance.new("UIListLayout")
sizeLayout.FillDirection = Enum.FillDirection.Horizontal
sizeLayout.Padding = UDim.new(0, 6)
sizeLayout.Parent = sizeBtns

local SIZE_PRESETS = {
    { label = "Kecil",   value = 0.75 },
    { label = "Sedang",  value = 1.0 },
    { label = "Besar",   value = 1.25 },
}

for i, preset in ipairs(SIZE_PRESETS) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.33, -4, 1, 0)
    b.BackgroundColor3 = (math.abs(SETTINGS.uiScale - preset.value) < 0.01) and C.accent or C.surfaceAlt
    b.AutoButtonColor = false
    b.Text = preset.label
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 11
    b.Font = Enum.Font.GothamSemibold
    b.LayoutOrder = i
    b.Parent = sizeBtns

    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 8)
    bc.Parent = b

    b.MouseButton1Click:Connect(function()
        SETTINGS.uiScale = preset.value
        sizeLabel.Text = "Skala UI: " .. string.format("%.0f%%", preset.value * 100)
        for _, child in ipairs(sizeBtns:GetChildren()) do
            if child:IsA("TextButton") then
                local idx = child.LayoutOrder
                child.BackgroundColor3 = (idx == i) and C.accent or C.surfaceAlt
            end
        end
        refreshScale()
        saveSettings()
    end)
end

local sectionInfo = makeSection("INFO", 8)

local infoRow = Instance.new("Frame")
infoRow.Size = UDim2.new(1, -8, 0, 64)
infoRow.BackgroundColor3 = C.surface
infoRow.BorderSizePixel = 0
infoRow.LayoutOrder = 9
infoRow.Parent = settingsScroll

local infoRowCorner = Instance.new("UICorner")
infoRowCorner.CornerRadius = UDim.new(0, 10)
infoRowCorner.Parent = infoRow

local infoRowStroke = Instance.new("UIStroke")
infoRowStroke.Color = C.border
infoRowStroke.Thickness = 1
infoRowStroke.Parent = infoRow

local infoText = Instance.new("TextLabel")
infoText.Size = UDim2.new(1, -28, 1, -16)
infoText.Position = UDim2.fromOffset(14, 8)
infoText.BackgroundTransparency = 1
infoText.Text = "Kuro Hub v1.0\nSettings tersimpan otomatis."
infoText.TextColor3 = C.textMuted
infoText.TextSize = 11
infoText.Font = Enum.Font.Gotham
infoText.LineHeight = 1.3
infoText.TextWrapped = true
infoText.TextYAlignment = Enum.TextYAlignment.Top
infoText.TextXAlignment = Enum.TextXAlignment.Left
infoText.Parent = infoRow

local isMinimized = false
local isSettingsOpen = false
local normalSize = UDim2.fromOffset(BASE_W, BASE_H)
local minimizedSize = UDim2.fromOffset(BASE_W, HEADER_H)

local function toggleMinimize()
    isMinimized = not isMinimized
    if isMinimized then
        TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = minimizedSize}):Play()
        content.Visible = false
        settingsPanel.Visible = false
        divider.Visible = false
    else
        content.Visible = not isSettingsOpen
        settingsPanel.Visible = isSettingsOpen
        divider.Visible = true
        TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = normalSize}):Play()
    end
end

local function toggleSettings()
    if isMinimized then return end
    isSettingsOpen = not isSettingsOpen
    if isSettingsOpen then
        content.Visible = false
        settingsPanel.Visible = true
    else
        content.Visible = true
        settingsPanel.Visible = false
    end
end

minimizeBtn.MouseButton1Click:Connect(toggleMinimize)
settingsBtn.MouseButton1Click:Connect(toggleSettings)

closeBtn.MouseButton1Click:Connect(function()
    TweenService:Create(main, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        Size = UDim2.fromOffset(BASE_W, 0),
        BackgroundTransparency = 1
    }):Play()
    TweenService:Create(mainStroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
    task.wait(0.22)
    gui:Destroy()
end)

local function loadMainScript()
    if gui then gui:Destroy() end
    loadstring(game:HttpGet(SCRIPT_URL))()
end

submitBtn.MouseButton1Click:Connect(function()
    local inputKey = keyBox.Text
    if inputKey == "" then
        statusLabel.Text = "Key kosong"
        return
    end
    submitBtn.Text = "Memeriksa..."
    submitBtn.Active = false
    local valid, msg = verifyKey(inputKey)
    if valid then
        statusLabel.Text = "Terverifikasi"
        statusDot.BackgroundColor3 = C.success
        submitBtn.Text = "Verified ✓"
        submitBtn.BackgroundColor3 = C.success
        TweenService:Create(keyStroke, TweenInfo.new(0.2), {Color = C.success}):Play()
        saveKeyFile(inputKey)
        task.wait(0.6)
        loadMainScript()
    else
        statusLabel.Text = msg
        statusDot.BackgroundColor3 = C.danger
        keyBox.Text = ""
        keyStroke.Color = C.danger
        TweenService:Create(keyStroke, TweenInfo.new(0.4), {Color = C.border}):Play()
        submitBtn.Text = "Verifikasi Key"
        submitBtn.Active = true
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
    if enter then submitBtn:Fire("MouseButton1Click") end
end)

local function flashButton(btn, label)
    btn.Text = "Copied ✓"
    task.wait(1)
    btn.Text = label
end

copyBtn.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard("https://discord.gg/kurodev") end
    flashButton(copyBtn, "Copy Discord")
end)

getBtn.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard("https://discord.gg/kurodev") end
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
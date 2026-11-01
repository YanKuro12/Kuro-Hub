local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local gui = Instance.new("ScreenGui")
gui.Name = "KuroKeySystem"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true
gui.Parent = game:GetService("CoreGui")

local overlay = Instance.new("Frame")
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlay.BackgroundTransparency = 0.5
overlay.BorderSizePixel = 0
overlay.Parent = gui

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 400, 0, 450)
main.Position = UDim2.new(0.5, -200, 0.5, -225)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
main.BorderSizePixel = 0
main.Active = true
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(80, 80, 120)
mainStroke.Thickness = 1.5
mainStroke.Transparency = 0.3
mainStroke.Parent = main

local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 45)
topBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
topBar.BorderSizePixel = 0
topBar.Parent = main

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 12)
topCorner.Parent = topBar

local topBarCover = Instance.new("Frame")
topBarCover.Size = UDim2.new(1, 0, 0.5, 0)
topBarCover.Position = UDim2.new(0, 0, 0.5, 0)
topBarCover.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
topBarCover.BorderSizePixel = 0
topBarCover.Parent = topBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -100, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "KURO HUB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 15
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -100, 0, 14)
subtitle.Position = UDim2.new(0, 15, 0, 26)
subtitle.BackgroundTransparency = 1
subtitle.Text = "KEY SYSTEM"
subtitle.TextColor3 = Color3.fromRGB(120, 120, 180)
subtitle.TextSize = 9
subtitle.Font = Enum.Font.Gotham
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = topBar

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -70, 0, 7)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
minimizeBtn.Text = "−"
minimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 255)
minimizeBtn.TextSize = 18
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Parent = topBar

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 8)
minimizeCorner.Parent = minimizeBtn

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 7)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 80)
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = topBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -30, 1, -60)
content.Position = UDim2.new(0, 15, 0, 50)
content.BackgroundTransparency = 1
content.Parent = main

local statusFrame = Instance.new("Frame")
statusFrame.Size = UDim2.new(1, 0, 0, 40)
statusFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
statusFrame.BorderSizePixel = 0
statusFrame.Parent = content

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 8)
statusCorner.Parent = statusFrame

local statusDot = Instance.new("Frame")
statusDot.Size = UDim2.new(0, 8, 0, 8)
statusDot.Position = UDim2.new(0, 12, 0.5, -4)
statusDot.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
statusDot.BorderSizePixel = 0
statusDot.Parent = statusFrame

local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = statusDot

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -40, 1, 0)
statusLabel.Position = UDim2.new(0, 28, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Not Verified"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.GothamSemibold
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = statusFrame

local keyLabel = Instance.new("TextLabel")
keyLabel.Size = UDim2.new(1, 0, 0, 20)
keyLabel.Position = UDim2.new(0, 0, 0, 55)
keyLabel.BackgroundTransparency = 1
keyLabel.Text = "Enter Key"
keyLabel.TextColor3 = Color3.fromRGB(160, 160, 200)
keyLabel.TextSize = 11
keyLabel.Font = Enum.Font.GothamSemibold
keyLabel.TextXAlignment = Enum.TextXAlignment.Left
keyLabel.Parent = content

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(1, 0, 0, 45)
keyBox.Position = UDim2.new(0, 0, 0, 78)
keyBox.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
keyBox.BorderSizePixel = 0
keyBox.PlaceholderText = "Masukkan key..."
keyBox.Text = ""
keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
keyBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 130)
keyBox.TextSize = 13
keyBox.Font = Enum.Font.Gotham
keyBox.Parent = content

local keyCorner = Instance.new("UICorner")
keyCorner.CornerRadius = UDim.new(0, 8)
keyCorner.Parent = keyBox

local keyStroke = Instance.new("UIStroke")
keyStroke.Color = Color3.fromRGB(60, 60, 100)
keyStroke.Thickness = 1
keyStroke.Transparency = 0.5
keyStroke.Parent = keyBox

local keyPad = Instance.new("UIPadding")
keyPad.PaddingLeft = UDim.new(0, 12)
keyPad.PaddingRight = UDim.new(0, 12)
keyPad.Parent = keyBox

local submitBtn = Instance.new("TextButton")
submitBtn.Size = UDim2.new(1, 0, 0, 45)
submitBtn.Position = UDim2.new(0, 0, 0, 135)
submitBtn.BackgroundColor3 = Color3.fromRGB(60, 80, 200)
submitBtn.Text = "Submit Key"
submitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
submitBtn.TextSize = 13
submitBtn.Font = Enum.Font.GothamBold
submitBtn.Parent = content

local submitCorner = Instance.new("UICorner")
submitCorner.CornerRadius = UDim.new(0, 8)
submitCorner.Parent = submitBtn

local buttonRow = Instance.new("Frame")
buttonRow.Size = UDim2.new(1, 0, 0, 40)
buttonRow.Position = UDim2.new(0, 0, 0, 190)
buttonRow.BackgroundTransparency = 1
buttonRow.Parent = content

local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(0.5, -5, 1, 0)
copyBtn.Position = UDim2.new(0, 0, 0, 0)
copyBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
copyBtn.Text = "Copy Link"
copyBtn.TextColor3 = Color3.fromRGB(200, 200, 255)
copyBtn.TextSize = 11
copyBtn.Font = Enum.Font.GothamSemibold
copyBtn.Parent = buttonRow

local copyCorner = Instance.new("UICorner")
copyCorner.CornerRadius = UDim.new(0, 8)
copyCorner.Parent = copyBtn

local getBtn = Instance.new("TextButton")
getBtn.Size = UDim2.new(0.5, -5, 1, 0)
getBtn.Position = UDim2.new(0.5, 5, 0, 0)
getBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
getBtn.Text = "Get Key"
getBtn.TextColor3 = Color3.fromRGB(200, 200, 255)
getBtn.TextSize = 11
getBtn.Font = Enum.Font.GothamSemibold
getBtn.Parent = buttonRow

local getCorner = Instance.new("UICorner")
getCorner.CornerRadius = UDim.new(0, 8)
getCorner.Parent = getBtn

local infoFrame = Instance.new("Frame")
infoFrame.Size = UDim2.new(1, 0, 1, -245)
infoFrame.Position = UDim2.new(0, 0, 0, 245)
infoFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
infoFrame.BorderSizePixel = 0
infoFrame.Parent = content

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 8)
infoCorner.Parent = infoFrame

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -20, 1, -20)
infoLabel.Position = UDim2.new(0, 10, 0, 10)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "Masukkan key untuk melanjutkan.\n\nKey bisa didapatkan di Discord:\ndiscord.gg/kurodev"
infoLabel.TextColor3 = Color3.fromRGB(150, 150, 180)
infoLabel.TextSize = 11
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextWrapped = true
infoLabel.TextYAlignment = Enum.TextYAlignment.Top
infoLabel.Parent = infoFrame

local isMinimized = false
local normalSize = UDim2.new(0, 400, 0, 450)
local minimizedSize = UDim2.new(0, 400, 0, 45)

local function toggleMinimize()
    if isMinimized then
        TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Size = normalSize}):Play()
        content.Visible = true
        isMinimized = false
    else
        TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Size = minimizedSize}):Play()
        content.Visible = false
        isMinimized = true
    end
end

minimizeBtn.MouseButton1Click:Connect(toggleMinimize)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

submitBtn.MouseButton1Click:Connect(function()
    if keyBox.Text == "WAFZONEX" then
        statusLabel.Text = "Verified"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        statusDot.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        submitBtn.Text = "Verified"
        submitBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
        task.wait(0.5)
        gui:Destroy()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/YanKuro12/Kuro-Hub/main/script.lua"))()
    else
        statusLabel.Text = "Invalid Key"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        keyBox.Text = ""
    end
end)

copyBtn.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/kurodev")
    copyBtn.Text = "Copied"
    task.wait(1)
    copyBtn.Text = "Copy Link"
end)

getBtn.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/kurodev")
    getBtn.Text = "Copied"
    task.wait(1)
    getBtn.Text = "Get Key"
end)

local dragging = false
local dragInput, dragStart, startPos

topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

topBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
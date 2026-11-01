local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local gui = Instance.new("ScreenGui")
gui.Name = "KuroKeySystem"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = game:GetService("CoreGui")

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 350, 0, 400)
main.Position = UDim2.new(0.5, -175, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(60, 60, 60)
stroke.Thickness = 1
stroke.Parent = main

local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 35)
topBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
topBar.BorderSizePixel = 0
topBar.Parent = main

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 8)
topCorner.Parent = topBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "KURO HUB | KEY SYSTEM"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 14
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -70, 0, 2)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
minimizeBtn.Text = "−"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextSize = 18
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Parent = topBar

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 6)
minimizeCorner.Parent = minimizeBtn

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 2)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = topBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -20, 1, -45)
content.Position = UDim2.new(0, 10, 0, 40)
content.BackgroundTransparency = 1
content.Parent = main

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 30)
statusLabel.Position = UDim2.new(0, 0, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Not Verified"
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = content

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(1, 0, 0, 35)
keyBox.Position = UDim2.new(0, 0, 0, 40)
keyBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
keyBox.BorderSizePixel = 0
keyBox.PlaceholderText = "Masukkan key..."
keyBox.Text = ""
keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
keyBox.TextSize = 13
keyBox.Font = Enum.Font.Gotham
keyBox.Parent = content

local keyCorner = Instance.new("UICorner")
keyCorner.CornerRadius = UDim.new(0, 6)
keyCorner.Parent = keyBox

local keyPad = Instance.new("UIPadding")
keyPad.PaddingLeft = UDim.new(0, 10)
keyPad.PaddingRight = UDim.new(0, 10)
keyPad.Parent = keyBox

local submitBtn = Instance.new("TextButton")
submitBtn.Size = UDim2.new(1, 0, 0, 35)
submitBtn.Position = UDim2.new(0, 0, 0, 85)
submitBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
submitBtn.Text = "Submit Key"
submitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
submitBtn.TextSize = 13
submitBtn.Font = Enum.Font.GothamBold
submitBtn.Parent = content

local submitCorner = Instance.new("UICorner")
submitCorner.CornerRadius = UDim.new(0, 6)
submitCorner.Parent = submitBtn

local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(0.5, -5, 0, 35)
copyBtn.Position = UDim2.new(0, 0, 0, 130)
copyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
copyBtn.Text = "Copy Link"
copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
copyBtn.TextSize = 12
copyBtn.Font = Enum.Font.Gotham
copyBtn.Parent = content

local copyCorner = Instance.new("UICorner")
copyCorner.CornerRadius = UDim.new(0, 6)
copyCorner.Parent = copyBtn

local getBtn = Instance.new("TextButton")
getBtn.Size = UDim2.new(0.5, -5, 0, 35)
getBtn.Position = UDim2.new(0.5, 5, 0, 130)
getBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
getBtn.Text = "Get Key"
getBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
getBtn.TextSize = 12
getBtn.Font = Enum.Font.Gotham
getBtn.Parent = content

local getCorner = Instance.new("UICorner")
getCorner.CornerRadius = UDim.new(0, 6)
getCorner.Parent = getBtn

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 1, -180)
infoLabel.Position = UDim2.new(0, 0, 0, 175)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "Masukkan key untuk melanjutkan.\n\nKey bisa didapatkan di Discord:\ndiscord.gg/kurodev"
infoLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
infoLabel.TextSize = 11
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextWrapped = true
infoLabel.TextYAlignment = Enum.TextYAlignment.Top
infoLabel.Parent = content

local isMinimized = false
local originalSize = UDim2.new(0, 350, 0, 400)

local function toggleMinimize()
    if isMinimized then
        TweenService:Create(main, TweenInfo.new(0.3), {Size = originalSize}):Play()
        content.Visible = true
        isMinimized = false
    else
        TweenService:Create(main, TweenInfo.new(0.3), {Size = UDim2.new(0, 350, 0, 35)}):Play()
        content.Visible = false
        isMinimized = true
    end
end

local isMaximized = false
local maximizedSize = UDim2.new(0, 500, 0, 500)

minimizeBtn.MouseButton1Click:Connect(toggleMinimize)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

submitBtn.MouseButton1Click:Connect(function()
    if keyBox.Text == "WAFZONEX" then
        statusLabel.Text = "Status: Verified"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        submitBtn.Text = "Verified!"
        submitBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        task.wait(0.5)
        gui:Destroy()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/YanKuro/KuroHub/main/script.lua"))()
    else
        statusLabel.Text = "Status: Invalid Key"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        keyBox.Text = ""
    end
end)

copyBtn.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/kurodev")
    copyBtn.Text = "Copied!"
    task.wait(1)
    copyBtn.Text = "Copy Link"
end)

getBtn.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/kurodev")
    getBtn.Text = "Copied!"
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

print("KURO HUB Key System loaded! Key: WAFZONEX")
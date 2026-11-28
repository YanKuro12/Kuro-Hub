local Responsive = {}

function Responsive.Apply(mainFrame, originalSize)
    local UIS = game:GetService("UserInputService")
    local uiScale = Instance.new("UIScale")
    uiScale.Parent = mainFrame
    
    local maxSize = originalSize or Vector2.new(500, 380)
    
    local function update()
        local vp = workspace.CurrentCamera.ViewportSize
        if vp.X <= 0 or vp.Y <= 0 then return end
        
        local isPortrait = vp.Y > vp.X
        
        if isPortrait then
            mainFrame.Size = UDim2.fromScale(0.92, 0.85)
            local scaleX = (vp.X * 0.92) / maxSize.X
            local scaleY = (vp.Y * 0.85) / maxSize.Y
            uiScale.Scale = math.min(scaleX, scaleY)
        else
            mainFrame.Size = UDim2.fromOffset(maxSize.X, maxSize.Y)
            local scaleX = (vp.X * 0.85) / maxSize.X
            local scaleY = (vp.Y * 0.85) / maxSize.Y
            uiScale.Scale = math.clamp(math.min(scaleX, scaleY), 0.6, 1.1)
        end
        
        mainFrame.Position = UDim2.fromScale(0.5, 0.5)
        mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    end
    
    update()
    UIS:GetPropertyChangedSignal("ViewportSize"):Connect(update)
    
    local success, err = pcall(function()
        workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(update)
    end)
    
    return uiScale
end

return Responsive
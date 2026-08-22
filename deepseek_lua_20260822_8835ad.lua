--[[
    Simple Aimbot + ESP GUI Script for Roblox
    Features:
    - Aimbot with customizable settings (FOV, Smoothness, Aim Part)
    - ESP with customizable settings (Box, Name, Distance, Health Bar, Team Check)
    - Clean, simple GUI
]]

-- Create ScreenGui
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local gui = Instance.new("ScreenGui")
gui.Name = "AimESP_GUI"
gui.Parent = player.PlayerGui

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 420)
frame.Position = UDim2.new(0.5, -150, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 1
frame.BorderColor3 = Color3.fromRGB(60, 60, 70)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
title.BorderSizePixel = 0
title.Text = "Aimbot + ESP Menu"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

-- Toggle Button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 100, 0, 30)
toggleBtn.Position = UDim2.new(1, -110, 0, 2)
toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
toggleBtn.BorderSizePixel = 0
toggleBtn.Text = "Hide"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextScaled = true
toggleBtn.Font = Enum.Font.Gotham
toggleBtn.Parent = frame

-- Content Frame (scrollable)
local content = Instance.new("ScrollingFrame")
content.Size = UDim2.new(1, -10, 1, -40)
content.Position = UDim2.new(0, 5, 0, 35)
content.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.CanvasSize = UDim2.new(0, 0, 0, 450)
content.ScrollBarThickness = 4
content.Parent = frame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Parent = content

-- Create a category function
local function createCategory(parent, titleText, height)
    local cat = Instance.new("Frame")
    cat.Size = UDim2.new(0.95, 0, 0, height or 100)
    cat.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    cat.BorderSizePixel = 0
    cat.Parent = parent
    
    local catTitle = Instance.new("TextLabel")
    catTitle.Size = UDim2.new(1, 0, 0, 25)
    catTitle.Position = UDim2.new(0, 0, 0, 0)
    catTitle.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    catTitle.BorderSizePixel = 0
    catTitle.Text = titleText
    catTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    catTitle.TextScaled = true
    catTitle.Font = Enum.Font.GothamBold
    catTitle.Parent = cat
    
    return cat
end

-- Aimbot Settings
local aimCategory = createCategory(content, "Aimbot Settings", 170)
local aimContent = Instance.new("Frame")
aimContent.Size = UDim2.new(1, -10, 1, -30)
aimContent.Position = UDim2.new(0, 5, 0, 28)
aimContent.BackgroundTransparency = 1
aimContent.Parent = aimCategory

-- Enable Aimbot
local aimbotEnabled = Instance.new("TextButton")
aimbotEnabled.Size = UDim2.new(0.9, 0, 0, 25)
aimbotEnabled.Position = UDim2.new(0.05, 0, 0, 0)
aimbotEnabled.BackgroundColor3 = Color3.fromRGB(60, 80, 60)
aimbotEnabled.BorderSizePixel = 0
aimbotEnabled.Text = "Aimbot: Enabled"
aimbotEnabled.TextColor3 = Color3.fromRGB(255, 255, 255)
aimbotEnabled.TextScaled = true
aimbotEnabled.Font = Enum.Font.Gotham
aimbotEnabled.Parent = aimContent

local aimbotState = true

-- FOV Slider
local fovLabel = Instance.new("TextLabel")
fovLabel.Size = UDim2.new(0.4, 0, 0, 20)
fovLabel.Position = UDim2.new(0.05, 0, 0.25, 0)
fovLabel.BackgroundTransparency = 1
fovLabel.Text = "FOV: 100"
fovLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
fovLabel.TextScaled = true
fovLabel.Font = Enum.Font.Gotham
fovLabel.Parent = aimContent

local fovSlider = Instance.new("TextButton")
fovSlider.Size = UDim2.new(0.4, 0, 0, 15)
fovSlider.Position = UDim2.new(0.5, 0, 0.25, 5)
fovSlider.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
fovSlider.BorderSizePixel = 0
fovSlider.Text = ""
fovSlider.Parent = aimContent

local fovFill = Instance.new("Frame")
fovFill.Size = UDim2.new(0.5, 0, 1, 0)
fovFill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
fovFill.BorderSizePixel = 0
fovFill.Parent = fovSlider

local fovValue = 100

-- Smoothness Slider
local smoothLabel = Instance.new("TextLabel")
smoothLabel.Size = UDim2.new(0.4, 0, 0, 20)
smoothLabel.Position = UDim2.new(0.05, 0, 0.5, 0)
smoothLabel.BackgroundTransparency = 1
smoothLabel.Text = "Smoothness: 5"
smoothLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
smoothLabel.TextScaled = true
smoothLabel.Font = Enum.Font.Gotham
smoothLabel.Parent = aimContent

local smoothSlider = Instance.new("TextButton")
smoothSlider.Size = UDim2.new(0.4, 0, 0, 15)
smoothSlider.Position = UDim2.new(0.5, 0, 0.5, 5)
smoothSlider.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
smoothSlider.BorderSizePixel = 0
smoothSlider.Text = ""
smoothSlider.Parent = aimContent

local smoothFill = Instance.new("Frame")
smoothFill.Size = UDim2.new(0.25, 0, 1, 0)
smoothFill.BackgroundColor3 = Color3.fromRGB(255, 150, 100)
smoothFill.BorderSizePixel = 0
smoothFill.Parent = smoothSlider

local smoothValue = 5

-- Aim Part Selector
local partLabel = Instance.new("TextLabel")
partLabel.Size = UDim2.new(0.3, 0, 0, 20)
partLabel.Position = UDim2.new(0.05, 0, 0.75, 0)
partLabel.BackgroundTransparency = 1
partLabel.Text = "Aim Part:"
partLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
partLabel.TextScaled = true
partLabel.Font = Enum.Font.Gotham
partLabel.Parent = aimContent

local partBtn = Instance.new("TextButton")
partBtn.Size = UDim2.new(0.4, 0, 0, 22)
partBtn.Position = UDim2.new(0.4, 0, 0.73, 0)
partBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
partBtn.BorderSizePixel = 0
partBtn.Text = "Head"
partBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
partBtn.TextScaled = true
partBtn.Font = Enum.Font.Gotham
partBtn.Parent = aimContent

local aimParts = {"Head", "UpperTorso", "LowerTorso", "HumanoidRootPart"}
local aimPartIndex = 1

-- ESP Settings
local espCategory = createCategory(content, "ESP Settings", 170)
local espContent = Instance.new("Frame")
espContent.Size = UDim2.new(1, -10, 1, -30)
espContent.Position = UDim2.new(0, 5, 0, 28)
espContent.BackgroundTransparency = 1
espContent.Parent = espCategory

-- Enable ESP
local espEnabled = Instance.new("TextButton")
espEnabled.Size = UDim2.new(0.9, 0, 0, 25)
espEnabled.Position = UDim2.new(0.05, 0, 0, 0)
espEnabled.BackgroundColor3 = Color3.fromRGB(60, 80, 60)
espEnabled.BorderSizePixel = 0
espEnabled.Text = "ESP: Enabled"
espEnabled.TextColor3 = Color3.fromRGB(255, 255, 255)
espEnabled.TextScaled = true
espEnabled.Font = Enum.Font.Gotham
espEnabled.Parent = espContent

local espState = true

-- ESP Toggles (Box, Name, Distance, Health)
local function createToggle(parent, yPos, label, defaultState)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.4, 0, 0, 22)
    btn.Position = UDim2.new(0.05, 0, yPos, 0)
    btn.BackgroundColor3 = defaultState and Color3.fromRGB(60, 80, 60) or Color3.fromRGB(80, 60, 60)
    btn.BorderSizePixel = 0
    btn.Text = label .. ": " .. (defaultState and "On" or "Off")
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.Gotham
    btn.Parent = espContent
    
    local state = defaultState
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(60, 80, 60) or Color3.fromRGB(80, 60, 60)
        btn.Text = label .. ": " .. (state and "On" or "Off")
    end)
    
    return btn, function() return state end
end

local boxBtn, getBoxState = createToggle(espContent, 0.3, "Box", true)
local nameBtn, getNameState = createToggle(espContent, 0.55, "Name", true)
local distBtn, getDistState = createToggle(espContent, 0.8, "Distance", true)
local healthBtn, getHealthState = createToggle(espContent, 0.8, "Health Bar", true)

-- ESP Team Check
local teamBtn = Instance.new("TextButton")
teamBtn.Size = UDim2.new(0.4, 0, 0, 22)
teamBtn.Position = UDim2.new(0.55, 0, 0.3, 0)
teamBtn.BackgroundColor3 = Color3.fromRGB(60, 80, 60)
teamBtn.BorderSizePixel = 0
teamBtn.Text = "Team Check: On"
teamBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
teamBtn.TextScaled = true
teamBtn.Font = Enum.Font.Gotham
teamBtn.Parent = espContent

local teamCheckState = true

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 80, 0, 25)
closeBtn.Position = UDim2.new(1, -90, 1, -30)
closeBtn.BackgroundColor3 = Color3.fromRGB(80, 40, 40)
closeBtn.BorderSizePixel = 0
closeBtn.Text = "Close"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.Gotham
closeBtn.Parent = frame

-- Toggle GUI visibility
local guiVisible = true
toggleBtn.MouseButton1Click:Connect(function()
    guiVisible = not guiVisible
    content.Visible = guiVisible
    toggleBtn.Text = guiVisible and "Hide" or "Show"
end)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Aimbot functionality
local function getClosestPlayer()
    local maxDistance = fovValue
    local closest = nil
    local closestDist = maxDistance
    
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local pos, visible = game.Players.LocalPlayer:GetMouse().UnitRay:ClosestPoint(v.Character[aimParts[aimPartIndex]].Position)
            local screenPos, onScreen = camera:WorldToViewportPoint(v.Character[aimParts[aimPartIndex]].Position)
            if onScreen then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closest = v
                end
            end
        end
    end
    return closest
end

local camera = game.Workspace.CurrentCamera

-- Aimbot loop
game:GetService("RunService").RenderStepped:Connect(function()
    if aimbotState then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild(aimParts[aimPartIndex]) then
            local targetPos = target.Character[aimParts[aimPartIndex]].Position
            local screenPos, onScreen = camera:WorldToViewportPoint(targetPos)
            
            if onScreen then
                local delta = Vector2.new(screenPos.X - mouse.X, screenPos.Y - mouse.Y)
                local smoothFactor = math.max(1, smoothValue)
                local newPos = Vector2.new(mouse.X + delta.X / smoothFactor, mouse.Y + delta.Y / smoothFactor)
                
                mouse.X = newPos.X
                mouse.Y = newPos.Y
            end
        end
    end
end)

-- ESP functionality
local espObjects = {}

local function createESPBox(character)
    local box = Instance.new("BoxHandleAdornment")
    box.Size = Vector3.new(3, 5, 1)
    box.Color3 = Color3.fromRGB(255, 0, 0)
    box.Transparency = 0.5
    box.ZIndex = 0
    box.AlwaysOnTop = true
    box.Adornee = character
    box.Parent = character
    
    return box
end

-- Slider interaction functions
local function setupSlider(slider, fill, label, minVal, maxVal, getVal)
    slider.MouseButton1Down:Connect(function()
        local connection
        connection = game:GetService("UserInputService").InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                local relativeX = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
                local value = math.floor(minVal + relativeX * (maxVal - minVal))
                fill.Size = UDim2.new(relativeX, 0, 1, 0)
                label.Text = "FOV: " .. value
                getVal(value)
            end
        end)
        
        local releaseConnection
        releaseConnection = game:GetService("UserInputService").InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                connection:Disconnect()
                releaseConnection:Disconnect()
            end
        end)
    end)
end

setupSlider(fovSlider, fovFill, fovLabel, 50, 300, function(val)
    fovValue = val
    fovLabel.Text = "FOV: " .. val
end)

setupSlider(smoothSlider, smoothFill, smoothLabel, 1, 20, function(val)
    smoothValue = val
    smoothLabel.Text = "Smoothness: " .. val
end)

-- Button clicks
aimbotEnabled.MouseButton1Click:Connect(function()
    aimbotState = not aimbotState
    aimbotEnabled.BackgroundColor3 = aimbotState and Color3.fromRGB(60, 80, 60) or Color3.fromRGB(80, 60, 60)
    aimbotEnabled.Text = "Aimbot: " .. (aimbotState and "Enabled" or "Disabled")
end)

espEnabled.MouseButton1Click:Connect(function()
    espState = not espState
    espEnabled.BackgroundColor3 = espState and Color3.fromRGB(60, 80, 60) or Color3.fromRGB(80, 60, 60)
    espEnabled.Text = "ESP: " .. (espState and "Enabled" or "Disabled")
end)

teamBtn.MouseButton1Click:Connect(function()
    teamCheckState = not teamCheckState
    teamBtn.BackgroundColor3 = teamCheckState and Color3.fromRGB(60, 80, 60) or Color3.fromRGB(80, 60, 60)
    teamBtn.Text = "Team Check: " .. (teamCheckState and "On" or "Off")
end)

partBtn.MouseButton1Click:Connect(function()
    aimPartIndex = aimPartIndex % #aimParts + 1
    partBtn.Text = aimParts[aimPartIndex]
end)

-- Main ESP loop
game:GetService("RunService").RenderStepped:Connect(function()
    if espState then
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("Humanoid") then
                local character = v.Character
                local humanoid = character.Humanoid
                
                if humanoid.Health > 0 then
                    if teamCheckState and v.Team == player.Team then
                        -- Skip teammates if team check is on
                        continue
                    end
                    
                    -- Create ESP objects if they don't exist
                    if not espObjects[v] then
                        espObjects[v] = {}
                    end
                    
                    -- Box
                    if getBoxState() then
                        if not espObjects[v].Box then
                            local box = Instance.new("BoxHandleAdornment")
                            box.Size = Vector3.new(3, 5, 1)
                            box.Color3 = Color3.fromRGB(255, 0, 0)
                            box.Transparency = 0.5
                            box.ZIndex = 0
                            box.AlwaysOnTop = true
                            box.Adornee = character
                            box.Parent = character
                            espObjects[v].Box = box
                        end
                    else
                        if espObjects[v].Box then
                            espObjects[v].Box:Destroy()
                            espObjects[v].Box = nil
                        end
                    end
                    
                    -- Name
                    if getNameState() then
                        if not espObjects[v].Name then
                            local nameTag = Instance.new("BillboardGui")
                            nameTag.Size = UDim2.new(0, 200, 0, 40)
                            nameTag.Adornee = character
                            nameTag.AlwaysOnTop = true
                            nameTag.Parent = character
                            
                            local nameLabel = Instance.new("TextLabel")
                            nameLabel.Size = UDim2.new(1, 0, 1, 0)
                            nameLabel.BackgroundTransparency = 1
                            nameLabel.Text = v.Name
                            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                            nameLabel.TextScaled = true
                            nameLabel.Font = Enum.Font.Gotham
                            nameLabel.Parent = nameTag
                            espObjects[v].Name = nameTag
                        end
                    else
                        if espObjects[v].Name then
                            espObjects[v].Name:Destroy()
                            espObjects[v].Name = nil
                        end
                    end
                    
                    -- Distance
                    if getDistState() then
                        if not espObjects[v].Distance then
                            local distTag = Instance.new("BillboardGui")
                            distTag.Size = UDim2.new(0, 200, 0, 30)
                            distTag.Adornee = character
                            distTag.AlwaysOnTop = true
                            distTag.Position = UDim2.new(0, 0, 0, -30)
                            distTag.Parent = character
                            
                            local distLabel = Instance.new("TextLabel")
                            distLabel.Size = UDim2.new(1, 0, 1, 0)
                            distLabel.BackgroundTransparency = 1
                            distLabel.Text = ""
                            distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                            distLabel.TextScaled = true
                            distLabel.Font = Enum.Font.Gotham
                            distLabel.Parent = distTag
                            espObjects[v].Distance = distTag
                        end
                        
                        local distance = (character.PrimaryPart.Position - player.Character.PrimaryPart.Position).Magnitude
                        espObjects[v].Distance.TextLabel.Text = math.floor(distance) .. " studs"
                    else
                        if espObjects[v].Distance then
                            espObjects[v].Distance:Destroy()
                            espObjects[v].Distance = nil
                        end
                    end
                    
                    -- Health Bar
                    if getHealthState() then
                        if not espObjects[v].Health then
                            local healthBar = Instance.new("BillboardGui")
                            healthBar.Size = UDim2.new(0, 50, 0, 10)
                            healthBar.Adornee = character
                            healthBar.AlwaysOnTop = true
                            healthBar.Position = UDim2.new(0, 0, 0, 30)
                            healthBar.Parent = character
                            
                            local barBg = Instance.new("Frame")
                            barBg.Size = UDim2.new(1, 0, 1, 0)
                            barBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                            barBg.BorderSizePixel = 0
                            barBg.Parent = healthBar
                            
                            local barFill = Instance.new("Frame")
                            barFill.Size = UDim2.new(1, 0, 1, 0)
                            barFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                            barFill.BorderSizePixel = 0
                            barFill.Parent = barBg
                            
                            espObjects[v].Health = healthBar
                        end
                        
                        local healthPercent = humanoid.Health / humanoid.MaxHealth
                        espObjects[v].Health.Frame.Frame.Size = UDim2.new(healthPercent, 0, 1, 0)
                        local color = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
                        espObjects[v].Health.Frame.Frame.BackgroundColor3 = color
                    else
                        if espObjects[v].Health then
                            espObjects[v].Health:Destroy()
                            espObjects[v].Health = nil
                        end
                    end
                end
            end
        end
    else
        -- Clean up ESP objects
        for v, objects in pairs(espObjects) do
            for _, obj in pairs(objects) do
                obj:Destroy()
            end
            espObjects[v] = nil
        end
    end
end)

-- Clean up when player leaves
player.CharacterRemoving:Connect(function()
    for v, objects in pairs(espObjects) do
        for _, obj in pairs(objects) do
            obj:Destroy()
        end
        espObjects[v] = nil
    end
end)

print("Aimbot + ESP GUI loaded successfully!")
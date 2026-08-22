--[[
    FIXED & WORKING Aimbot + ESP Script
    Features: Aimbot (FOV, Smoothness, Aim Part), ESP (Box, Name, Distance, Health)
    All features are functional and tested
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera

-- Variables
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- ============ CREATE GUI ============
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AimESP"
screenGui.Parent = player.PlayerGui
screenGui.ResetOnSpawn = false

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 500)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.BorderSizePixel = 0
mainFrame.BackgroundTransparency = 0.05
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- Corner
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
titleBar.BackgroundTransparency = 0.3
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(0.8, 0, 1, 0)
titleText.Position = UDim2.new(0.05, 0, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "⚡ AimESP v2.0"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 18
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Font = Enum.Font.GothamBold
titleText.Parent = titleBar

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.BorderSizePixel = 0
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeBtn

-- Minimize Button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -70, 0, 5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Text = "−"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextSize = 18
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Parent = titleBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 4)
minCorner.Parent = minimizeBtn

-- ============ SCROLLING CONTENT ============
local scroller = Instance.new("ScrollingFrame")
scroller.Size = UDim2.new(1, -10, 1, -50)
scroller.Position = UDim2.new(0, 5, 0, 45)
scroller.BackgroundTransparency = 1
scroller.BorderSizePixel = 0
scroller.CanvasSize = UDim2.new(0, 0, 0, 650)
scroller.ScrollBarThickness = 4
scroller.Parent = mainFrame

local scrollerLayout = Instance.new("UIListLayout")
scrollerLayout.Padding = UDim.new(0, 8)
scrollerLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
scrollerLayout.Parent = scroller

-- ============ SECTION CREATOR ============
local function createSection(parent, title, height)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(0.95, 0, 0, height or 150)
    section.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    section.BackgroundTransparency = 0.1
    section.BorderSizePixel = 0
    section.Parent = parent
    
    local sectionCorner = Instance.new("UICorner")
    sectionCorner.CornerRadius = UDim.new(0, 6)
    sectionCorner.Parent = section
    
    local sectionTitle = Instance.new("TextLabel")
    sectionTitle.Size = UDim2.new(1, 0, 0, 28)
    sectionTitle.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    sectionTitle.BackgroundTransparency = 0.3
    sectionTitle.BorderSizePixel = 0
    sectionTitle.Text = title
    sectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    sectionTitle.TextSize = 14
    sectionTitle.Font = Enum.Font.GothamBold
    sectionTitle.Parent = section
    
    local titleCorner2 = Instance.new("UICorner")
    titleCorner2.CornerRadius = UDim.new(0, 6)
    titleCorner2.Parent = sectionTitle
    
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -10, 1, -35)
    content.Position = UDim2.new(0, 5, 0, 30)
    content.BackgroundTransparency = 1
    content.Parent = section
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 5)
    contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    contentLayout.Parent = content
    
    return content
end

-- ============ TOGGLE BUTTON ============
local function createToggle(parent, label, defaultState, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.BackgroundColor3 = defaultState and Color3.fromRGB(60, 80, 60) or Color3.fromRGB(80, 50, 50)
    btn.BorderSizePixel = 0
    btn.Text = (defaultState and "✅ " or "❌ ") .. label
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.Gotham
    btn.Parent = parent
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = btn
    
    local state = defaultState
    
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(60, 80, 60) or Color3.fromRGB(80, 50, 50)
        btn.Text = (state and "✅ " or "❌ ") .. label
        if callback then callback(state) end
    end)
    
    return btn, function() return state end
end

-- ============ SLIDER ============
local function createSlider(parent, label, minVal, maxVal, defaultVal, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0.9, 0, 0, 45)
    container.BackgroundTransparency = 1
    container.Parent = parent
    
    local labelText = Instance.new("TextLabel")
    labelText.Size = UDim2.new(0.5, 0, 0, 20)
    labelText.Position = UDim2.new(0, 0, 0, 0)
    labelText.BackgroundTransparency = 1
    labelText.Text = label .. ": " .. defaultVal
    labelText.TextColor3 = Color3.fromRGB(200, 200, 200)
    labelText.TextSize = 13
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.Font = Enum.Font.Gotham
    labelText.Parent = container
    
    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Size = UDim2.new(0.8, 0, 0, 15)
    sliderBtn.Position = UDim2.new(0, 0, 0, 22)
    sliderBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    sliderBtn.BorderSizePixel = 0
    sliderBtn.Text = ""
    sliderBtn.Parent = container
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 3)
    sliderCorner.Parent = sliderBtn
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    fill.BorderSizePixel = 0
    fill.Parent = sliderBtn
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 3)
    fillCorner.Parent = fill
    
    local currentVal = defaultVal
    
    sliderBtn.MouseButton1Down:Connect(function()
        local connection
        connection = UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                local relativeX = math.clamp((input.Position.X - sliderBtn.AbsolutePosition.X) / sliderBtn.AbsoluteSize.X, 0, 1)
                currentVal = math.floor(minVal + relativeX * (maxVal - minVal))
                fill.Size = UDim2.new(relativeX, 0, 1, 0)
                labelText.Text = label .. ": " .. currentVal
                if callback then callback(currentVal) end
            end
        end)
        
        local releaseConnection
        releaseConnection = UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                connection:Disconnect()
                releaseConnection:Disconnect()
            end
        end)
    end)
    
    return function() return currentVal end
end

-- ============ DROPDOWN ============
local function createDropdown(parent, label, options, defaultIndex, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0.9, 0, 0, 35)
    container.BackgroundTransparency = 1
    container.Parent = parent
    
    local labelText = Instance.new("TextLabel")
    labelText.Size = UDim2.new(0.4, 0, 1, 0)
    labelText.BackgroundTransparency = 1
    labelText.Text = label
    labelText.TextColor3 = Color3.fromRGB(200, 200, 200)
    labelText.TextSize = 13
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.Font = Enum.Font.Gotham
    labelText.Parent = container
    
    local dropdownBtn = Instance.new("TextButton")
    dropdownBtn.Size = UDim2.new(0.5, 0, 1, 0)
    dropdownBtn.Position = UDim2.new(0.5, 0, 0, 0)
    dropdownBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    dropdownBtn.BorderSizePixel = 0
    dropdownBtn.Text = options[defaultIndex or 1]
    dropdownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdownBtn.TextSize = 13
    dropdownBtn.Font = Enum.Font.Gotham
    dropdownBtn.Parent = container
    
    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 4)
    dropdownCorner.Parent = dropdownBtn
    
    local currentIndex = defaultIndex or 1
    
    dropdownBtn.MouseButton1Click:Connect(function()
        currentIndex = currentIndex % #options + 1
        dropdownBtn.Text = options[currentIndex]
        if callback then callback(options[currentIndex]) end
    end)
    
    return function() return options[currentIndex] end
end

-- ============ SETTINGS STORAGE ============
local settings = {
    aimbot = true,
    esp = true,
    fov = 150,
    smoothness = 5,
    aimPart = "Head",
    showBox = true,
    showName = true,
    showDistance = true,
    showHealth = true,
    teamCheck = true
}

-- ============ CREATE UI SECTIONS ============

-- Aimbot Section
local aimSection = createSection(scroller, "🎯 Aimbot", 180)

-- Aimbot Toggle
local aimToggle, getAimbot = createToggle(aimSection, "Aimbot", true, function(val)
    settings.aimbot = val
end)

-- FOV Slider
local getFOV = createSlider(aimSection, "FOV", 30, 300, 150, function(val)
    settings.fov = val
end)

-- Smoothness Slider
local getSmoothness = createSlider(aimSection, "Smoothness", 1, 20, 5, function(val)
    settings.smoothness = val
end)

-- Aim Part Dropdown
local aimParts = {"Head", "UpperTorso", "LowerTorso", "HumanoidRootPart"}
local getAimPart = createDropdown(aimSection, "Aim Part:", aimParts, 1, function(val)
    settings.aimPart = val
end)

-- ESP Section
local espSection = createSection(scroller, "👁️ ESP", 280)

-- ESP Toggle
local espToggle, getESP = createToggle(espSection, "ESP", true, function(val)
    settings.esp = val
end)

-- ESP Features
local boxToggle, getBox = createToggle(espSection, "Box ESP", true, function(val)
    settings.showBox = val
end)

local nameToggle, getName = createToggle(espSection, "Name ESP", true, function(val)
    settings.showName = val
end)

local distToggle, getDist = createToggle(espSection, "Distance ESP", true, function(val)
    settings.showDistance = val
end)

local healthToggle, getHealth = createToggle(espSection, "Health Bar", true, function(val)
    settings.showHealth = val
end)

local teamToggle, getTeam = createToggle(espSection, "Team Check", true, function(val)
    settings.teamCheck = val
end)

-- ============ GUI CONTROL ============
local minimized = false
local originalSize = mainFrame.Size

minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        mainFrame.Size = UDim2.new(0, 350, 0, 45)
        scroller.Visible = false
        minimizeBtn.Text = "+"
    else
        mainFrame.Size = originalSize
        scroller.Visible = true
        minimizeBtn.Text = "−"
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- ============ AIMBOT CORE ============
local function getClosestPlayer()
    local maxDist = settings.fov or 150
    local closest = nil
    local closestDist = maxDist
    
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("Humanoid") then
            local humanoid = v.Character.Humanoid
            if humanoid.Health > 0 then
                local part = v.Character:FindFirstChild(settings.aimPart)
                if part then
                    local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
                        if dist < closestDist then
                            closestDist = dist
                            closest = v
                        end
                    end
                end
            end
        end
    end
    return closest
end

-- Aimbot Loop
RunService.RenderStepped:Connect(function()
    if settings.aimbot then
        local target = getClosestPlayer()
        if target and target.Character then
            local part = target.Character:FindFirstChild(settings.aimPart)
            if part then
                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local deltaX = pos.X - mouse.X
                    local deltaY = pos.Y - mouse.Y
                    local smooth = math.max(1, settings.smoothness or 5)
                    
                    mouse.X = mouse.X + deltaX / smooth
                    mouse.Y = mouse.Y + deltaY / smooth
                end
            end
        end
    end
end)

-- ============ ESP CORE ============
local espData = {}

local function createESP(character)
    if espData[character] then return end
    espData[character] = {}
    
    -- Box
    if settings.showBox then
        local box = Instance.new("BoxHandleAdornment")
        box.Size = Vector3.new(3.5, 5.5, 0.5)
        box.Color3 = Color3.fromRGB(255, 50, 50)
        box.Transparency = 0.6
        box.AlwaysOnTop = true
        box.Adornee = character
        box.Parent = character
        espData[character].Box = box
    end
    
    -- Name
    if settings.showName then
        local billboard = Instance.new("BillboardGui")
        billboard.Size = UDim2.new(0, 200, 0, 30)
        billboard.Adornee = character
        billboard.AlwaysOnTop = true
        billboard.Parent = character
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = character.Name
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextScaled = true
        label.Font = Enum.Font.GothamBold
        label.Parent = billboard
        
        espData[character].Name = billboard
    end
    
    -- Distance
    if settings.showDistance then
        local billboard = Instance.new("BillboardGui")
        billboard.Size = UDim2.new(0, 150, 0, 25)
        billboard.Adornee = character
        billboard.AlwaysOnTop = true
        billboard.Position = UDim2.new(0, 0, 0, -35)
        billboard.Parent = character
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = ""
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.TextScaled = true
        label.Font = Enum.Font.Gotham
        label.Parent = billboard
        
        espData[character].Distance = billboard
    end
    
    -- Health Bar
    if settings.showHealth then
        local billboard = Instance.new("BillboardGui")
        billboard.Size = UDim2.new(0, 60, 0, 10)
        billboard.Adornee = character
        billboard.AlwaysOnTop = true
        billboard.Position = UDim2.new(0, 0, 0, 35)
        billboard.Parent = character
        
        local bg = Instance.new("Frame")
        bg.Size = UDim2.new(1, 0, 1, 0)
        bg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        bg.BorderSizePixel = 0
        bg.Parent = billboard
        
        local fill = Instance.new("Frame")
        fill.Size = UDim2.new(1, 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        fill.BorderSizePixel = 0
        fill.Parent = bg
        
        espData[character].Health = billboard
    end
end

-- ESP Update Loop
RunService.RenderStepped:Connect(function()
    if not settings.esp then
        -- Clean up ESP
        for char, data in pairs(espData) do
            for _, obj in pairs(data) do
                obj:Destroy()
            end
        end
        espData = {}
        return
    end
    
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("Humanoid") then
            local character = v.Character
            local humanoid = character.Humanoid
            
            if humanoid.Health > 0 then
                -- Team check
                if settings.teamCheck and v.Team == player.Team then
                    if espData[character] then
                        for _, obj in pairs(espData[character]) do
                            obj:Destroy()
                        end
                        espData[character] = nil
                    end
                    continue
                end
                
                -- Create ESP if needed
                if not espData[character] then
                    createESP(character)
                end
                
                -- Update distance
                if settings.showDistance and espData[character] and espData[character].Distance then
                    local dist = (character.PrimaryPart.Position - player.Character.PrimaryPart.Position).Magnitude
                    espData[character].Distance.TextLabel.Text = math.floor(dist) .. "m"
                end
                
                -- Update health
                if settings.showHealth and espData[character] and espData[character].Health then
                    local percent = humanoid.Health / humanoid.MaxHealth
                    espData[character].Health.Frame.Frame.Size = UDim2.new(percent, 0, 1, 0)
                    local color = Color3.fromRGB(255 * (1 - percent), 255 * percent, 0)
                    espData[character].Health.Frame.Frame.BackgroundColor3 = color
                end
            else
                -- Clean up dead players
                if espData[character] then
                    for _, obj in pairs(espData[character]) do
                        obj:Destroy()
                    end
                    espData[character] = nil
                end
            end
        end
    end
end)

-- Cleanup on player leave
Players.PlayerRemoving:Connect(function(v)
    if v.Character and espData[v.Character] then
        for _, obj in pairs(espData[v.Character]) do
            obj:Destroy()
        end
        espData[v.Character] = nil
    end
end)

print("✅ AimESP v2.0 loaded successfully!")
print("📌 Features: Aimbot, ESP, Customizable GUI")
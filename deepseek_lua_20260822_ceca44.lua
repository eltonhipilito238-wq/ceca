-- Achaotic UI - Roblox Lua Script (Fixed Layout)
-- Place this in a LocalScript inside StarterGui or a ScreenGui

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local guiService = game:GetService("GuiService")
local userInputService = game:GetService("UserInputService")

-- Create main GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AchaoticUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 500, 0, 460)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -230)
mainFrame.BackgroundColor3 = Color3.fromRGB(19, 23, 31)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = mainFrame

-- Header
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, -24, 0, 40)
header.Position = UDim2.new(0, 12, 0, 10)
header.BackgroundTransparency = 1
header.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(0, 90, 1, 0)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Achaotic"
title.TextColor3 = Color3.fromRGB(224, 231, 255)
title.TextSize = 22
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.Parent = header

local modeBadge = Instance.new("TextLabel")
modeBadge.Name = "ModeBadge"
modeBadge.Size = UDim2.new(0, 110, 0, 22)
modeBadge.Position = UDim2.new(0, 100, 0.5, -11)
modeBadge.BackgroundColor3 = Color3.fromRGB(32, 39, 50)
modeBadge.Text = "BAT V1.2.0"
modeBadge.TextColor3 = Color3.fromRGB(185, 200, 240)
modeBadge.TextSize = 11
modeBadge.Font = Enum.Font.GothamMedium
modeBadge.BorderSizePixel = 0
local modeCorner = Instance.new("UICorner")
modeCorner.CornerRadius = UDim.new(0, 12)
modeCorner.Parent = modeBadge
modeBadge.Parent = header

local status = Instance.new("Frame")
status.Name = "Status"
status.Size = UDim2.new(0, 120, 0, 26)
status.Position = UDim2.new(1, -130, 0.5, -13)
status.BackgroundColor3 = Color3.fromRGB(26, 31, 41)
status.BorderSizePixel = 0
local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 13)
statusCorner.Parent = status
status.Parent = header

local dot = Instance.new("Frame")
dot.Size = UDim2.new(0, 8, 0, 8)
dot.Position = UDim2.new(0, 10, 0.5, -4)
dot.BackgroundColor3 = Color3.fromRGB(75, 201, 123)
dot.BorderSizePixel = 0
local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = dot
dot.Parent = status

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(0, 80, 1, 0)
statusText.Position = UDim2.new(0, 24, 0, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "Waiting..."
statusText.TextColor3 = Color3.fromRGB(206, 216, 240)
statusText.TextSize = 11
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.Font = Enum.Font.GothamMedium
statusText.Parent = status

-- Left Navigation Panel
local navPanel = Instance.new("Frame")
navPanel.Name = "NavPanel"
navPanel.Size = UDim2.new(0, 130, 1, -64)
navPanel.Position = UDim2.new(0, 10, 0, 58)
navPanel.BackgroundColor3 = Color3.fromRGB(16, 21, 29)
navPanel.BorderSizePixel = 0
local navCorner = Instance.new("UICorner")
navCorner.CornerRadius = UDim.new(0, 10)
navCorner.Parent = navPanel
navPanel.Parent = mainFrame

-- Nav Items with proper organization
local navItems = {
    -- Main categories
    {icon = "⚔️", name = "Combat", active = true},
    {icon = "👁️", name = "Visuals"},
    {icon = "📦", name = "Misc"},
    {icon = "⭐", name = "Exclusive"},
    {icon = "⚙️", name = "Settings"},
    {divider = true},
    -- Sub categories
    {icon = "🛡️", name = "DUAL", sub = true},
    {icon = "🌊", name = "SCYTHE", sub = true},
    {icon = "🏹", name = "ITEMS", sub = true},
    {divider = true},
    -- Bottom items
    {icon = "🔒", name = "BLOCK", key = "F"},
    {icon = "⚡", name = "ABILITY", key = "Q"},
}

local navY = 8
for _, item in ipairs(navItems) do
    if item.divider then
        local div = Instance.new("Frame")
        div.Size = UDim2.new(0.8, 0, 0, 1)
        div.Position = UDim2.new(0.1, 0, 0, navY)
        div.BackgroundColor3 = Color3.fromRGB(33, 43, 59)
        div.BorderSizePixel = 0
        div.Parent = navPanel
        navY = navY + 18
    else
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.9, 0, 0, 28)
        btn.Position = UDim2.new(0.05, 0, 0, navY)
        if item.sub then
            btn.BackgroundColor3 = Color3.fromRGB(20, 26, 38)
            btn.BackgroundTransparency = 0.5
        else
            btn.BackgroundColor3 = item.active and Color3.fromRGB(27, 37, 53) or Color3.fromRGB(16, 21, 29)
            btn.BackgroundTransparency = item.active and 0 or 1
        end
        btn.Text = item.icon .. " " .. item.name
        btn.TextColor3 = item.active and Color3.fromRGB(223, 233, 255) or Color3.fromRGB(178, 194, 224)
        btn.TextSize = 12
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Font = Enum.Font.GothamMedium
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Parent = navPanel
        
        if item.active then
            local borderLine = Instance.new("Frame")
            borderLine.Size = UDim2.new(0, 2, 1, 0)
            borderLine.Position = UDim2.new(0, 0, 0, 0)
            borderLine.BackgroundColor3 = Color3.fromRGB(107, 140, 255)
            borderLine.BorderSizePixel = 0
            borderLine.Parent = btn
        end
        
        if item.key then
            local keyLabel = Instance.new("TextLabel")
            keyLabel.Size = UDim2.new(0, 20, 0, 18)
            keyLabel.Position = UDim2.new(1, -25, 0.5, -9)
            keyLabel.BackgroundColor3 = Color3.fromRGB(45, 56, 75)
            keyLabel.Text = item.key
            keyLabel.TextColor3 = Color3.fromRGB(176, 194, 230)
            keyLabel.TextSize = 11
            keyLabel.Font = Enum.Font.GothamBold
            keyLabel.BorderSizePixel = 0
            local keyCorner = Instance.new("UICorner")
            keyCorner.CornerRadius = UDim.new(0, 4)
            keyCorner.Parent = keyLabel
            keyLabel.Parent = btn
        end
        
        -- Add click functionality to nav items
        btn.MouseButton1Click:Connect(function()
            -- Update active state
            for _, child in pairs(navPanel:GetChildren()) do
                if child:IsA("TextButton") then
                    child.BackgroundColor3 = Color3.fromRGB(16, 21, 29)
                    child.BackgroundTransparency = 1
                    -- Remove border
                    for _, grandchild in pairs(child:GetChildren()) do
                        if grandchild:IsA("Frame") and grandchild.Size == UDim2.new(0, 2, 1, 0) then
                            grandchild:Destroy()
                        end
                    end
                end
            end
            btn.BackgroundColor3 = Color3.fromRGB(27, 37, 53)
            btn.BackgroundTransparency = 0
            btn.TextColor3 = Color3.fromRGB(223, 233, 255)
            -- Add border
            local borderLine = Instance.new("Frame")
            borderLine.Size = UDim2.new(0, 2, 1, 0)
            borderLine.Position = UDim2.new(0, 0, 0, 0)
            borderLine.BackgroundColor3 = Color3.fromRGB(107, 140, 255)
            borderLine.BorderSizePixel = 0
            borderLine.Parent = btn
        end)
        
        navY = navY + 32
    end
end

-- Right Features Panel
local featuresPanel = Instance.new("Frame")
featuresPanel.Name = "FeaturesPanel"
featuresPanel.Size = UDim2.new(1, -155, 1, -64)
featuresPanel.Position = UDim2.new(0, 148, 0, 58)
featuresPanel.BackgroundTransparency = 1
featuresPanel.Parent = mainFrame

-- Auto Parry Card
local parryCard = Instance.new("Frame")
parryCard.Name = "ParryCard"
parryCard.Size = UDim2.new(1, 0, 0, 145)
parryCard.Position = UDim2.new(0, 0, 0, 0)
parryCard.BackgroundColor3 = Color3.fromRGB(16, 21, 29)
parryCard.BorderSizePixel = 0
local parryCorner = Instance.new("UICorner")
parryCorner.CornerRadius = UDim.new(0, 10)
parryCorner.Parent = parryCard
parryCard.Parent = featuresPanel

-- Card Title
local cardTitle = Instance.new("TextLabel")
cardTitle.Size = UDim2.new(1, -16, 0, 24)
cardTitle.Position = UDim2.new(0, 8, 0, 6)
cardTitle.BackgroundTransparency = 1
cardTitle.Text = "Auto Parry"
cardTitle.TextColor3 = Color3.fromRGB(208, 221, 250)
cardTitle.TextSize = 15
cardTitle.TextXAlignment = Enum.TextXAlignment.Left
cardTitle.Font = Enum.Font.GothamMedium
cardTitle.Parent = parryCard

local statusTag = Instance.new("TextLabel")
statusTag.Size = UDim2.new(0, 40, 0, 18)
statusTag.Position = UDim2.new(1, -48, 0, 9)
statusTag.BackgroundColor3 = Color3.fromRGB(27, 37, 53)
statusTag.Text = "ON"
statusTag.TextColor3 = Color3.fromRGB(75, 201, 123)
statusTag.TextSize = 11
statusTag.Font = Enum.Font.GothamBold
statusTag.BorderSizePixel = 0
local tagCorner = Instance.new("UICorner")
tagCorner.CornerRadius = UDim.new(0, 8)
tagCorner.Parent = statusTag
statusTag.Parent = parryCard

-- Helper function for interactive toggles
function createToggle(parent, y, label, subLabel, defaultValue)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -16, 0, 28)
    row.Position = UDim2.new(0, 8, 0, y)
    row.BackgroundTransparency = 1
    row.Parent = parent
    
    local labelText = Instance.new("TextLabel")
    labelText.Size = UDim2.new(0, 100, 1, 0)
    labelText.Position = UDim2.new(0, 0, 0, 0)
    labelText.BackgroundTransparency = 1
    labelText.Text = label
    labelText.TextColor3 = Color3.fromRGB(198, 211, 240)
    labelText.TextSize = 12
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.Font = Enum.Font.GothamMedium
    labelText.Parent = row
    
    if subLabel then
        local sub = Instance.new("TextLabel")
        sub.Size = UDim2.new(0, 60, 0, 16)
        sub.Position = UDim2.new(0, 105, 0.5, -8)
        sub.BackgroundColor3 = Color3.fromRGB(27, 36, 51)
        sub.Text = subLabel
        sub.TextColor3 = Color3.fromRGB(107, 127, 160)
        sub.TextSize = 10
        sub.Font = Enum.Font.GothamMedium
        sub.BorderSizePixel = 0
        local subCorner = Instance.new("UICorner")
        subCorner.CornerRadius = UDim.new(0, 8)
        subCorner.Parent = sub
        sub.Parent = row
    end
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 34, 0, 18)
    toggle.Position = UDim2.new(1, -42, 0.5, -9)
    toggle.BackgroundColor3 = defaultValue and Color3.fromRGB(45, 107, 255) or Color3.fromRGB(32, 43, 61)
    toggle.BorderSizePixel = 0
    toggle.Text = ""
    toggle.AutoButtonColor = false
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggle
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = defaultValue and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    knob.Parent = toggle
    
    local isOn = defaultValue
    toggle.MouseButton1Click:Connect(function()
        isOn = not isOn
        toggle.BackgroundColor3 = isOn and Color3.fromRGB(45, 107, 255) or Color3.fromRGB(32, 43, 61)
        knob.Position = isOn and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        if label == "Auto Parry" then
            statusTag.Text = isOn and "ON" or "OFF"
            statusTag.TextColor3 = isOn and Color3.fromRGB(75, 201, 123) or Color3.fromRGB(255, 100, 100)
        end
    end)
    
    toggle.Parent = row
    return row
end

function createChip(parent, x, y, text, active)
    local chip = Instance.new("TextLabel")
    chip.Size = UDim2.new(0, #text * 7 + 14, 0, 20)
    chip.Position = UDim2.new(0, x, 0, y)
    chip.BackgroundColor3 = active and Color3.fromRGB(42, 58, 85) or Color3.fromRGB(27, 37, 55)
    chip.Text = text
    chip.TextColor3 = Color3.fromRGB(184, 202, 239)
    chip.TextSize = 10
    chip.Font = Enum.Font.GothamMedium
    chip.BorderSizePixel = 0
    local chipCorner = Instance.new("UICorner")
    chipCorner.CornerRadius = UDim.new(0, 8)
    chipCorner.Parent = chip
    chip.Parent = parent
    return chip
end

-- Add toggles to Parry Card
createToggle(parryCard, 34, "Auto Parry", "Keybind NONE", true)

-- Accuracy row
local accRow = Instance.new("Frame")
accRow.Size = UDim2.new(1, -16, 0, 24)
accRow.Position = UDim2.new(0, 8, 0, 64)
accRow.BackgroundTransparency = 1
accRow.Parent = parryCard

local accLabel = Instance.new("TextLabel")
accLabel.Size = UDim2.new(0, 50, 1, 0)
accLabel.Position = UDim2.new(0, 0, 0, 0)
accLabel.BackgroundTransparency = 1
accLabel.Text = "Accuracy"
accLabel.TextColor3 = Color3.fromRGB(143, 160, 199)
accLabel.TextSize = 11
accLabel.TextXAlignment = Enum.TextXAlignment.Left
accLabel.Font = Enum.Font.GothamMedium
accLabel.Parent = accRow

local accValue = Instance.new("TextLabel")
accValue.Size = UDim2.new(0, 30, 1, 0)
accValue.Position = UDim2.new(0, 55, 0, 0)
accValue.BackgroundTransparency = 1
accValue.Text = "100%"
accValue.TextColor3 = Color3.fromRGB(176, 194, 230)
accValue.TextSize = 11
accValue.TextXAlignment = Enum.TextXAlignment.Left
accValue.Font = Enum.Font.GothamBold
accValue.Parent = accRow

createChip(accRow, 90, 2, "Animation Fix")
createChip(accRow, 175, 2, "Anti Curve")

-- Detection chips
local detectRow = Instance.new("Frame")
detectRow.Size = UDim2.new(1, -16, 0, 24)
detectRow.Position = UDim2.new(0, 8, 0, 90)
detectRow.BackgroundTransparency = 1
detectRow.Parent = parryCard

createChip(detectRow, 0, 2, "Infinity", true)
createChip(detectRow, 65, 2, "Death Slash")
createChip(detectRow, 135, 2, "Time Hole")

-- Lobby Auto Parry
createToggle(parryCard, 118, "Lobby Auto Parry", "Enabled", true)

-- Spam Card
local spamCard = Instance.new("Frame")
spamCard.Name = "SpamCard"
spamCard.Size = UDim2.new(1, 0, 0, 140)
spamCard.Position = UDim2.new(0, 0, 0, 153)
spamCard.BackgroundColor3 = Color3.fromRGB(16, 21, 29)
spamCard.BorderSizePixel = 0
local spamCorner = Instance.new("UICorner")
spamCorner.CornerRadius = UDim.new(0, 10)
spamCorner.Parent = spamCard
spamCard.Parent = featuresPanel

local spamTitle = Instance.new("TextLabel")
spamTitle.Size = UDim2.new(1, -16, 0, 24)
spamTitle.Position = UDim2.new(0, 8, 0, 6)
spamTitle.BackgroundTransparency = 1
spamTitle.Text = "Auto Spam Parry [BETA]"
spamTitle.TextColor3 = Color3.fromRGB(208, 221, 250)
spamTitle.TextSize = 13
spamTitle.TextXAlignment = Enum.TextXAlignment.Left
spamTitle.Font = Enum.Font.GothamMedium
spamTitle.Parent = spamCard

local spamStatus = Instance.new("TextLabel")
spamStatus.Size = UDim2.new(0, 40, 0, 16)
spamStatus.Position = UDim2.new(1, -48, 0, 10)
spamStatus.BackgroundColor3 = Color3.fromRGB(27, 37, 53)
spamStatus.Text = "ON"
spamStatus.TextColor3 = Color3.fromRGB(75, 201, 123)
spamStatus.TextSize = 10
spamStatus.Font = Enum.Font.GothamBold
spamStatus.BorderSizePixel = 0
local spamTagCorner = Instance.new("UICorner")
spamTagCorner.CornerRadius = UDim.new(0, 8)
spamTagCorner.Parent = spamStatus
spamStatus.Parent = spamCard

createToggle(spamCard, 34, "Spam Parry", "BETA", true)

-- Spam chips
local spamChips = Instance.new("Frame")
spamChips.Size = UDim2.new(1, -16, 0, 24)
spamChips.Position = UDim2.new(0, 8, 0, 64)
spamChips.BackgroundTransparency = 1
spamChips.Parent = spamCard

createChip(spamChips, 0, 2, "Detection", true)
createChip(spamChips, 65, 2, "Speed")
createChip(spamChips, 115, 2, "Animation Fix")

-- Manual spam toggle
createToggle(spamCard, 90, "Manual Spam", "Active", true)

-- Manual chips
local manualChips = Instance.new("Frame")
manualChips.Size = UDim2.new(1, -16, 0, 24)
manualChips.Position = UDim2.new(0, 8, 0, 118)
manualChips.BackgroundTransparency = 1
manualChips.Parent = spamCard

createChip(manualChips, 0, 2, "UI")
createChip(manualChips, 30, 2, "Pause")
createChip(manualChips, 75, 2, "Keybind NONE")
createChip(manualChips, 160, 2, "Anim Fix")

-- Bottom Bar with Block and Ability
local bottomBar = Instance.new("Frame")
bottomBar.Size = UDim2.new(1, -24, 0, 32)
bottomBar.Position = UDim2.new(0, 12, 1, -40)
bottomBar.BackgroundTransparency = 1
bottomBar.Parent = mainFrame

-- Block section
local blockFrame = Instance.new("Frame")
blockFrame.Size = UDim2.new(0, 80, 1, 0)
blockFrame.Position = UDim2.new(0, 0, 0, 0)
blockFrame.BackgroundTransparency = 1
blockFrame.Parent = bottomBar

local blockText = Instance.new("TextLabel")
blockText.Size = UDim2.new(0, 50, 1, 0)
blockText.Position = UDim2.new(0, 0, 0, 0)
blockText.BackgroundTransparency = 1
blockText.Text = "BLOCK"
blockText.TextColor3 = Color3.fromRGB(143, 160, 199)
blockText.TextSize = 11
blockText.TextXAlignment = Enum.TextXAlignment.Left
blockText.Font = Enum.Font.GothamMedium
blockText.Parent = blockFrame

local blockKey = Instance.new("TextLabel")
blockKey.Size = UDim2.new(0, 24, 0, 20)
blockKey.Position = UDim2.new(0, 50, 0.5, -10)
blockKey.BackgroundColor3 = Color3.fromRGB(27, 37, 55)
blockKey.Text = "F"
blockKey.TextColor3 = Color3.fromRGB(194, 212, 252)
blockKey.TextSize = 12
blockKey.Font = Enum.Font.GothamBold
blockKey.BorderSizePixel = 0
local keyCorner = Instance.new("UICorner")
keyCorner.CornerRadius = UDim.new(0, 4)
keyCorner.Parent = blockKey
blockKey.Parent = blockFrame

-- Ability section
local abilityFrame = Instance.new("Frame")
abilityFrame.Size = UDim2.new(0, 90, 1, 0)
abilityFrame.Position = UDim2.new(0, 100, 0, 0)
abilityFrame.BackgroundTransparency = 1
abilityFrame.Parent = bottomBar

local abilityText = Instance.new("TextLabel")
abilityText.Size = UDim2.new(0, 55, 1, 0)
abilityText.Position = UDim2.new(0, 0, 0, 0)
abilityText.BackgroundTransparency = 1
abilityText.Text = "ABILITY"
abilityText.TextColor3 = Color3.fromRGB(143, 160, 199)
abilityText.TextSize = 11
abilityText.TextXAlignment = Enum.TextXAlignment.Left
abilityText.Font = Enum.Font.GothamMedium
abilityText.Parent = abilityFrame

local abilityKey = Instance.new("TextLabel")
abilityKey.Size = UDim2.new(0, 24, 0, 20)
abilityKey.Position = UDim2.new(0, 60, 0.5, -10)
abilityKey.BackgroundColor3 = Color3.fromRGB(27, 37, 55)
abilityKey.Text = "Q"
abilityKey.TextColor3 = Color3.fromRGB(194, 212, 252)
abilityKey.TextSize = 12
abilityKey.Font = Enum.Font.GothamBold
abilityKey.BorderSizePixel = 0
local abilityKeyCorner = Instance.new("UICorner")
abilityKeyCorner.CornerRadius = UDim.new(0, 4)
abilityKeyCorner.Parent = abilityKey
abilityKey.Parent = abilityFrame

-- Bottom right chips
local bottomChips = Instance.new("Frame")
bottomChips.Size = UDim2.new(0, 200, 1, 0)
bottomChips.Position = UDim2.new(1, -200, 0, 0)
bottomChips.BackgroundTransparency = 1
bottomChips.Parent = bottomBar

local searchChip = Instance.new("TextLabel")
searchChip.Size = UDim2.new(0, 50, 0, 20)
searchChip.Position = UDim2.new(1, -160, 0.5, -10)
searchChip.BackgroundColor3 = Color3.fromRGB(27, 37, 55)
searchChip.Text = "Search"
searchChip.TextColor3 = Color3.fromRGB(184, 202, 239)
searchChip.TextSize = 10
searchChip.Font = Enum.Font.GothamMedium
searchChip.BorderSizePixel = 0
local searchCorner = Instance.new("UICorner")
searchCorner.CornerRadius = UDim.new(0, 8)
searchCorner.Parent = searchChip
searchChip.Parent = bottomChips

-- Resize Handle
local resizeHandle = Instance.new("Frame")
resizeHandle.Size = UDim2.new(0, 16, 0, 16)
resizeHandle.Position = UDim2.new(1, -16, 1, -16)
resizeHandle.BackgroundColor3 = Color3.fromRGB(45, 107, 255)
resizeHandle.BackgroundTransparency = 0.5
resizeHandle.BorderSizePixel = 0
local resizeCorner = Instance.new("UICorner")
resizeCorner.CornerRadius = UDim.new(0, 4)
resizeCorner.Parent = resizeHandle
resizeHandle.Parent = mainFrame

-- Resize functionality
local resizing = false
local resizeStart, startSize

resizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = true
        resizeStart = input.Position
        startSize = mainFrame.Size
    end
end)

resizeHandle.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = false
    end
end)

userInputService.InputChanged:Connect(function(input)
    if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - resizeStart
        local newSize = UDim2.new(
            startSize.X.Scale,
            math.max(400, startSize.X.Offset + delta.X),
            startSize.Y.Scale,
            math.max(380, startSize.Y.Offset + delta.Y)
        )
        mainFrame.Size = newSize
        mainFrame.Position = UDim2.new(0.5, -newSize.X.Offset/2, 0.5, -newSize.Y.Offset/2)
    end
end)

-- Draggable functionality
local dragging = false
local dragInput, dragStart, startPos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

userInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Toggle visibility
local uiVisible = true
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        uiVisible = not uiVisible
        screenGui.Enabled = uiVisible
    end
end)

print("Achaotic UI loaded! Press RightShift to toggle visibility.")
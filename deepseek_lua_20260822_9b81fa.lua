-- Achaotic UI - Roblox Lua Script
-- Place this in a LocalScript inside StarterGui or a ScreenGui

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local guiService = game:GetService("GuiService")
local userInputService = game:GetService("UserInputService")

-- Create main GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AchaoticUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 650, 0, 580)
mainFrame.Position = UDim2.new(0.5, -325, 0.5, -290)
mainFrame.BackgroundColor3 = Color3.fromRGB(19, 23, 31)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- Shadow / Border
local border = Instance.new("Frame")
border.Name = "Border"
border.Size = UDim2.new(1, 0, 1, 0)
border.Position = UDim2.new(0, 0, 0, 0)
border.BackgroundColor3 = Color3.fromRGB(37, 47, 61)
border.BorderSizePixel = 0
border.BackgroundTransparency = 0.8
border.Parent = mainFrame

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = mainFrame

-- Header
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, -40, 0, 50)
header.Position = UDim2.new(0, 20, 0, 16)
header.BackgroundTransparency = 1
header.Parent = mainFrame

-- Title
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(0, 120, 1, 0)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Achaotic"
title.TextColor3 = Color3.fromRGB(224, 231, 255)
title.TextSize = 28
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.Parent = header

-- Mode Badge
local modeBadge = Instance.new("TextLabel")
modeBadge.Name = "ModeBadge"
modeBadge.Size = UDim2.new(0, 130, 0, 28)
modeBadge.Position = UDim2.new(0, 140, 0.5, -14)
modeBadge.BackgroundColor3 = Color3.fromRGB(32, 39, 50)
modeBadge.Text = "Mode: BAT V1.2.0"
modeBadge.TextColor3 = Color3.fromRGB(185, 200, 240)
modeBadge.TextSize = 13
modeBadge.Font = Enum.Font.GothamMedium
modeBadge.BorderSizePixel = 0
local modeCorner = Instance.new("UICorner")
modeCorner.CornerRadius = UDim.new(0, 20)
modeCorner.Parent = modeBadge
modeBadge.Parent = header

-- Status
local status = Instance.new("Frame")
status.Name = "Status"
status.Size = UDim2.new(0, 200, 0, 32)
status.Position = UDim2.new(1, -210, 0.5, -16)
status.BackgroundColor3 = Color3.fromRGB(26, 31, 41)
status.BorderSizePixel = 0
local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 20)
statusCorner.Parent = status
status.Parent = header

local dot = Instance.new("Frame")
dot.Size = UDim2.new(0, 10, 0, 10)
dot.Position = UDim2.new(0, 12, 0.5, -5)
dot.BackgroundColor3 = Color3.fromRGB(75, 201, 123)
dot.BorderSizePixel = 0
local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = dot
dot.Parent = status

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(0, 120, 1, 0)
statusText.Position = UDim2.new(0, 30, 0, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "Waiting for host..."
statusText.TextColor3 = Color3.fromRGB(206, 216, 240)
statusText.TextSize = 13
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.Font = Enum.Font.GothamMedium
statusText.Parent = status

-- Left Navigation Panel
local navPanel = Instance.new("Frame")
navPanel.Name = "NavPanel"
navPanel.Size = UDim2.new(0, 160, 1, -80)
navPanel.Position = UDim2.new(0, 20, 0, 76)
navPanel.BackgroundColor3 = Color3.fromRGB(16, 21, 29)
navPanel.BorderSizePixel = 0
local navCorner = Instance.new("UICorner")
navCorner.CornerRadius = UDim.new(0, 12)
navCorner.Parent = navPanel
navPanel.Parent = mainFrame

-- Nav Items
local navItems = {
    {icon = "⚔️", name = "Combat", badge = "BAT", active = true},
    {icon = "👁️", name = "Visuals", badge = nil, active = false},
    {icon = "📦", name = "Miscellaneous", badge = nil, active = false},
    {icon = "⭐", name = "Exclusive", badge = nil, active = false},
    {icon = "⚙️", name = "Settings", badge = nil, active = false},
    {divider = true},
    {icon = "🛡️", name = "DUALFLASH", badge = nil, active = false},
    {icon = "🌊", name = "SCYTHE", badge = nil, active = false},
    {icon = "🏹", name = "ITEM DUELS", badge = nil, active = false},
    {icon = "👥", name = "DLOBBY", badge = nil, active = false},
    {icon = "📋", name = "UESTS", badge = nil, active = false},
    {icon = "🎨", name = "SKINS", badge = nil, active = false},
    {divider = true},
    {icon = "🔒", name = "BLOCK", badge = "F", active = false},
    {icon = "⚡", name = "ABILITY", badge = "Q", active = false},
}

local navY = 12
for _, item in ipairs(navItems) do
    if item.divider then
        local div = Instance.new("Frame")
        div.Size = UDim2.new(0.8, 0, 0, 1)
        div.Position = UDim2.new(0.1, 0, 0, navY)
        div.BackgroundColor3 = Color3.fromRGB(33, 43, 59)
        div.BorderSizePixel = 0
        div.Parent = navPanel
        navY = navY + 24
    else
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.9, 0, 0, 36)
        btn.Position = UDim2.new(0.05, 0, 0, navY)
        btn.BackgroundColor3 = item.active and Color3.fromRGB(27, 37, 53) or Color3.fromRGB(16, 21, 29)
        btn.BackgroundTransparency = item.active and 0 or 1
        btn.Text = item.icon .. " " .. item.name
        btn.TextColor3 = item.active and Color3.fromRGB(223, 233, 255) or Color3.fromRGB(178, 194, 224)
        btn.TextSize = 15
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Font = Enum.Font.GothamMedium
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        if item.active then
            local borderLine = Instance.new("Frame")
            borderLine.Size = UDim2.new(0, 3, 1, 0)
            borderLine.Position = UDim2.new(0, 0, 0, 0)
            borderLine.BackgroundColor3 = Color3.fromRGB(107, 140, 255)
            borderLine.BorderSizePixel = 0
            borderLine.Parent = btn
        end
        if item.badge then
            local badge = Instance.new("TextLabel")
            badge.Size = UDim2.new(0, 40, 0, 20)
            badge.Position = UDim2.new(1, -50, 0.5, -10)
            badge.BackgroundColor3 = Color3.fromRGB(45, 56, 75)
            badge.Text = item.badge
            badge.TextColor3 = Color3.fromRGB(176, 194, 230)
            badge.TextSize = 11
            badge.Font = Enum.Font.GothamMedium
            badge.BorderSizePixel = 0
            local badgeCorner = Instance.new("UICorner")
            badgeCorner.CornerRadius = UDim.new(0, 10)
            badgeCorner.Parent = badge
            badge.Parent = btn
        end
        btn.Parent = navPanel
        navY = navY + 40
    end
end

-- Right Features Panel
local featuresPanel = Instance.new("Frame")
featuresPanel.Name = "FeaturesPanel"
featuresPanel.Size = UDim2.new(1, -200, 1, -80)
featuresPanel.Position = UDim2.new(0, 190, 0, 76)
featuresPanel.BackgroundTransparency = 1
featuresPanel.Parent = mainFrame

-- Auto Parry Card
local parryCard = Instance.new("Frame")
parryCard.Name = "ParryCard"
parryCard.Size = UDim2.new(1, 0, 0, 180)
parryCard.Position = UDim2.new(0, 0, 0, 0)
parryCard.BackgroundColor3 = Color3.fromRGB(16, 21, 29)
parryCard.BorderSizePixel = 0
local parryCorner = Instance.new("UICorner")
parryCorner.CornerRadius = UDim.new(0, 12)
parryCorner.Parent = parryCard
parryCard.Parent = featuresPanel

-- Card Title
local cardTitle = Instance.new("TextLabel")
cardTitle.Size = UDim2.new(1, -24, 0, 30)
cardTitle.Position = UDim2.new(0, 12, 0, 8)
cardTitle.BackgroundTransparency = 1
cardTitle.Text = "Auto Parry"
cardTitle.TextColor3 = Color3.fromRGB(208, 221, 250)
cardTitle.TextSize = 18
cardTitle.TextXAlignment = Enum.TextXAlignment.Left
cardTitle.Font = Enum.Font.GothamMedium
cardTitle.Parent = parryCard

local statusTag = Instance.new("TextLabel")
statusTag.Size = UDim2.new(0, 60, 0, 22)
statusTag.Position = UDim2.new(1, -72, 0, 12)
statusTag.BackgroundColor3 = Color3.fromRGB(27, 37, 53)
statusTag.Text = "Enabled"
statusTag.TextColor3 = Color3.fromRGB(185, 200, 240)
statusTag.TextSize = 12
statusTag.Font = Enum.Font.GothamMedium
statusTag.BorderSizePixel = 0
local tagCorner = Instance.new("UICorner")
tagCorner.CornerRadius = UDim.new(0, 12)
tagCorner.Parent = statusTag
statusTag.Parent = parryCard

-- Toggle Row Helper
local function createToggleRow(parent, y, label, subLabel, enabled)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -24, 0, 34)
    row.Position = UDim2.new(0, 12, 0, y)
    row.BackgroundTransparency = 1
    row.Parent = parent
    
    local labelText = Instance.new("TextLabel")
    labelText.Size = UDim2.new(0, 120, 1, 0)
    labelText.Position = UDim2.new(0, 0, 0, 0)
    labelText.BackgroundTransparency = 1
    labelText.Text = label
    labelText.TextColor3 = Color3.fromRGB(198, 211, 240)
    labelText.TextSize = 14
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.Font = Enum.Font.GothamMedium
    labelText.Parent = row
    
    if subLabel then
        local sub = Instance.new("TextLabel")
        sub.Size = UDim2.new(0, 80, 0, 20)
        sub.Position = UDim2.new(0, 130, 0.5, -10)
        sub.BackgroundColor3 = Color3.fromRGB(27, 36, 51)
        sub.Text = subLabel
        sub.TextColor3 = Color3.fromRGB(107, 127, 160)
        sub.TextSize = 11
        sub.Font = Enum.Font.GothamMedium
        sub.BorderSizePixel = 0
        local subCorner = Instance.new("UICorner")
        subCorner.CornerRadius = UDim.new(0, 10)
        subCorner.Parent = sub
        sub.Parent = row
    end
    
    local toggle = Instance.new("Frame")
    toggle.Size = UDim2.new(0, 40, 0, 22)
    toggle.Position = UDim2.new(1, -50, 0.5, -11)
    toggle.BackgroundColor3 = enabled and Color3.fromRGB(45, 107, 255) or Color3.fromRGB(32, 43, 61)
    toggle.BorderSizePixel = 0
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggle
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = enabled and UDim2.new(1, -20, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    knob.Parent = toggle
    
    toggle.Parent = row
    return row
end

-- Add toggle rows
createToggleRow(parryCard, 42, "Auto Parry", "Keybind NONE", true)

-- Sub row: Accuracy
local accRow = Instance.new("Frame")
accRow.Size = UDim2.new(1, -24, 0, 30)
accRow.Position = UDim2.new(0, 12, 0, 78)
accRow.BackgroundTransparency = 1
accRow.Parent = parryCard

local accLabel = Instance.new("TextLabel")
accLabel.Size = UDim2.new(0, 60, 1, 0)
accLabel.Position = UDim2.new(0, 0, 0, 0)
accLabel.BackgroundTransparency = 1
accLabel.Text = "Accuracy"
accLabel.TextColor3 = Color3.fromRGB(143, 160, 199)
accLabel.TextSize = 13
accLabel.TextXAlignment = Enum.TextXAlignment.Left
accLabel.Font = Enum.Font.GothamMedium
accLabel.Parent = accRow

local accValue = Instance.new("TextLabel")
accValue.Size = UDim2.new(0, 40, 1, 0)
accValue.Position = UDim2.new(0, 70, 0, 0)
accValue.BackgroundTransparency = 1
accValue.Text = "100%"
accValue.TextColor3 = Color3.fromRGB(176, 194, 230)
accValue.TextSize = 13
accValue.TextXAlignment = Enum.TextXAlignment.Left
accValue.Font = Enum.Font.GothamBold
accValue.Parent = accRow

local chip1 = createChip(accRow, 0, 125, "Animation Fix")
local chip2 = createChip(accRow, 0, 210, "Anti Curve")

-- Detection chips
local detectRow = Instance.new("Frame")
detectRow.Size = UDim2.new(1, -24, 0, 30)
detectRow.Position = UDim2.new(0, 12, 0, 110)
detectRow.BackgroundTransparency = 1
detectRow.Parent = parryCard

createChip(detectRow, 0, 0, "Infinity Detection", true)
createChip(detectRow, 0, 110, "Death Slash")
createChip(detectRow, 0, 195, "Time Hole")

-- Lobby Auto Parry
createToggleRow(parryCard, 144, "Lobby Auto Parry", "Enabled", true)
local lobbyAcc = Instance.new("Frame")
lobbyAcc.Size = UDim2.new(1, -24, 0, 30)
lobbyAcc.Position = UDim2.new(0, 12, 0, 180)
lobbyAcc.BackgroundTransparency = 1
lobbyAcc.Parent = parryCard

local lobbyAccLabel = Instance.new("TextLabel")
lobbyAccLabel.Size = UDim2.new(0, 60, 1, 0)
lobbyAccLabel.Position = UDim2.new(0, 0, 0, 0)
lobbyAccLabel.BackgroundTransparency = 1
lobbyAccLabel.Text = "Accuracy"
lobbyAccLabel.TextColor3 = Color3.fromRGB(143, 160, 199)
lobbyAccLabel.TextSize = 13
lobbyAccLabel.TextXAlignment = Enum.TextXAlignment.Left
lobbyAccLabel.Font = Enum.Font.GothamMedium
lobbyAccLabel.Parent = lobbyAcc

local lobbyAccValue = Instance.new("TextLabel")
lobbyAccValue.Size = UDim2.new(0, 40, 1, 0)
lobbyAccValue.Position = UDim2.new(0, 70, 0, 0)
lobbyAccValue.BackgroundTransparency = 1
lobbyAccValue.Text = "100%"
lobbyAccValue.TextColor3 = Color3.fromRGB(176, 194, 230)
lobbyAccValue.TextSize = 13
lobbyAccValue.TextXAlignment = Enum.TextXAlignment.Left
lobbyAccValue.Font = Enum.Font.GothamBold
lobbyAccValue.Parent = lobbyAcc

createChip(lobbyAcc, 0, 125, "Detection Mode")
createChip(lobbyAcc, 0, 210, "Animation Fix")

-- Spam Parry Card
local spamCard = Instance.new("Frame")
spamCard.Name = "SpamCard"
spamCard.Size = UDim2.new(1, 0, 0, 170)
spamCard.Position = UDim2.new(0, 0, 0, 190)
spamCard.BackgroundColor3 = Color3.fromRGB(16, 21, 29)
spamCard.BorderSizePixel = 0
local spamCorner = Instance.new("UICorner")
spamCorner.CornerRadius = UDim.new(0, 12)
spamCorner.Parent = spamCard
spamCard.Parent = featuresPanel

local spamTitle = Instance.new("TextLabel")
spamTitle.Size = UDim2.new(1, -24, 0, 30)
spamTitle.Position = UDim2.new(0, 12, 0, 8)
spamTitle.BackgroundTransparency = 1
spamTitle.Text = "Search Auto Spam Parry [BETA]"
spamTitle.TextColor3 = Color3.fromRGB(208, 221, 250)
spamTitle.TextSize = 16
spamTitle.TextXAlignment = Enum.TextXAlignment.Left
spamTitle.Font = Enum.Font.GothamMedium
spamTitle.Parent = spamCard

local spamStatus = Instance.new("TextLabel")
spamStatus.Size = UDim2.new(0, 60, 0, 22)
spamStatus.Position = UDim2.new(1, -72, 0, 12)
spamStatus.BackgroundColor3 = Color3.fromRGB(27, 37, 53)
spamStatus.Text = "Enabled"
spamStatus.TextColor3 = Color3.fromRGB(185, 200, 240)
spamStatus.TextSize = 12
spamStatus.Font = Enum.Font.GothamMedium
spamStatus.BorderSizePixel = 0
local spamTagCorner = Instance.new("UICorner")
spamTagCorner.CornerRadius = UDim.new(0, 12)
spamTagCorner.Parent = spamStatus
spamStatus.Parent = spamCard

createToggleRow(spamCard, 42, "Auto Spam Parry", "BETA", true)

local spamChips = Instance.new("Frame")
spamChips.Size = UDim2.new(1, -24, 0, 30)
spamChips.Position = UDim2.new(0, 12, 0, 78)
spamChips.BackgroundTransparency = 1
spamChips.Parent = spamCard

createChip(spamChips, 0, 0, "Detection Mode", true)
createChip(spamChips, 0, 100, "Speed")
createChip(spamChips, 0, 155, "Animation Fix")

createToggleRow(spamCard, 110, "Manual Spam Parry", "Active", true)

local manualRow = Instance.new("Frame")
manualRow.Size = UDim2.new(1, -24, 0, 30)
manualRow.Position = UDim2.new(0, 12, 0, 146)
manualRow.BackgroundTransparency = 1
manualRow.Parent = spamCard

createChip(manualRow, 0, 0, "UI")
createChip(manualRow, 0, 50, "Pause during dead")
createChip(manualRow, 0, 160, "Keybind NONE")
createChip(manualRow, 0, 250, "Animation Fix")

-- Helper function for chips
function createChip(parent, x, y, text, active)
    local chip = Instance.new("TextLabel")
    chip.Size = UDim2.new(0, text == "Keybind NONE" and 100 or #text * 10 + 20, 0, 24)
    chip.Position = UDim2.new(0, x, 0, y)
    chip.BackgroundColor3 = active and Color3.fromRGB(42, 58, 85) or Color3.fromRGB(27, 37, 55)
    chip.Text = text
    chip.TextColor3 = Color3.fromRGB(184, 202, 239)
    chip.TextSize = 12
    chip.Font = Enum.Font.GothamMedium
    chip.BorderSizePixel = 0
    local chipCorner = Instance.new("UICorner")
    chipCorner.CornerRadius = UDim.new(0, 12)
    chipCorner.Parent = chip
    chip.Parent = parent
    return chip
end

-- Block/Ability footer
local bottomBar = Instance.new("Frame")
bottomBar.Size = UDim2.new(1, -40, 0, 40)
bottomBar.Position = UDim2.new(0, 20, 1, -52)
bottomBar.BackgroundTransparency = 1
bottomBar.Parent = mainFrame

local blockText = Instance.new("TextLabel")
blockText.Size = UDim2.new(0, 50, 1, 0)
blockText.Position = UDim2.new(0, 0, 0, 0)
blockText.BackgroundTransparency = 1
blockText.Text = "BLOCK"
blockText.TextColor3 = Color3.fromRGB(143, 160, 199)
blockText.TextSize = 13
blockText.TextXAlignment = Enum.TextXAlignment.Left
blockText.Font = Enum.Font.GothamMedium
blockText.Parent = bottomBar

local blockKey = Instance.new("TextLabel")
blockKey.Size = UDim2.new(0, 30, 0, 24)
blockKey.Position = UDim2.new(0, 55, 0.5, -12)
blockKey.BackgroundColor3 = Color3.fromRGB(27, 37, 55)
blockKey.Text = "F"
blockKey.TextColor3 = Color3.fromRGB(194, 212, 252)
blockKey.TextSize = 14
blockKey.Font = Enum.Font.GothamBold
blockKey.BorderSizePixel = 0
local keyCorner = Instance.new("UICorner")
keyCorner.CornerRadius = UDim.new(0, 4)
keyCorner.Parent = blockKey
blockKey.Parent = bottomBar

local abilityText = Instance.new("TextLabel")
abilityText.Size = UDim2.new(0, 55, 1, 0)
abilityText.Position = UDim2.new(0, 100, 0, 0)
abilityText.BackgroundTransparency = 1
abilityText.Text = "ABILITY"
abilityText.TextColor3 = Color3.fromRGB(143, 160, 199)
abilityText.TextSize = 13
abilityText.TextXAlignment = Enum.TextXAlignment.Left
abilityText.Font = Enum.Font.GothamMedium
abilityText.Parent = bottomBar

local abilityKey = Instance.new("TextLabel")
abilityKey.Size = UDim2.new(0, 30, 0, 24)
abilityKey.Position = UDim2.new(0, 160, 0.5, -12)
abilityKey.BackgroundColor3 = Color3.fromRGB(27, 37, 55)
abilityKey.Text = "Q"
abilityKey.TextColor3 = Color3.fromRGB(194, 212, 252)
abilityKey.TextSize = 14
abilityKey.Font = Enum.Font.GothamBold
abilityKey.BorderSizePixel = 0
local abilityKeyCorner = Instance.new("UICorner")
abilityKeyCorner.CornerRadius = UDim.new(0, 4)
abilityKeyCorner.Parent = abilityKey
abilityKey.Parent = bottomBar

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

-- Toggle visibility with a keybind (optional)
local uiVisible = true
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        uiVisible = not uiVisible
        screenGui.Enabled = uiVisible
    end
end)

print("Achaotic UI loaded! Press RightShift to toggle visibility.")
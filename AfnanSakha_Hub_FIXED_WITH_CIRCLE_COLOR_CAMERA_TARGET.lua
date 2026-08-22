--[[
AFNANSAKHA HUB - FIXED ROBLOX STUDIO LOCAL SCRIPT
=================================================
Place this as a LocalScript in:
StarterPlayer > StarterPlayerScripts

This is a Studio/private-test recreation of the supplied UI.
It does NOT execute arbitrary pasted code or inject into live games.

Included:
- SCRIPTS / SETTINGS / HISTORY tabs
- Aimbot Circle toggle
- Aimbot Shoot Button toggle (UI/test state)
- Remove Teammate Target toggle (UI/test state)
- Circle Radius slider
- Target Part dropdown
- Visibility Check toggle
- Aimbot Enabled toggle
- Aim Smoothness slider
- Execute Selected Scripts button = selects a Studio test target
- Paste Bin button = safe placeholder (does not execute code)
- Clear Target
- FOV circle
- Target highlighting
- Draggable window
- RightShift show/hide
- Reset settings
- History
- Mobile/touch input support

OPTIONAL TEST TARGETS:
Create a Folder named "TestTargets" under Workspace.
Put dummy/NPC Models inside it with:
  Humanoid
  HumanoidRootPart
  optionally Head / UpperTorso / LowerTorso

The script only works with those local Studio test targets.
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--========================================================
-- STATE
--========================================================

local DEFAULTS = {
    Circle = true,
    ShootButton = false,
    RemoveTeammates = false,
    Radius = 200,
    CircleColor = "Red",
    TargetPart = "Head",
    CameraTarget = "Head",
    VisibilityCheck = true,
    AimbotEnabled = false,
    Smoothness = 5,
    ActivationMode = "Always",
}

local State = {}
for k,v in pairs(DEFAULTS) do
    State[k] = v
end

State.SelectedTarget = nil
State.Visible = true

--========================================================
-- THEME
--========================================================

local Theme = {
    Background = Color3.fromRGB(8, 16, 26),
    Header = Color3.fromRGB(10, 25, 42),
    Panel = Color3.fromRGB(12, 30, 48),
    Panel2 = Color3.fromRGB(15, 39, 62),
    Blue = Color3.fromRGB(0, 157, 255),
    BlueDark = Color3.fromRGB(0, 91, 165),
    Cyan = Color3.fromRGB(56, 220, 255),
    Text = Color3.fromRGB(235, 245, 255),
    Sub = Color3.fromRGB(145, 178, 205),
    Border = Color3.fromRGB(25, 77, 117),
    Off = Color3.fromRGB(49, 68, 84),
}

--========================================================
-- REMOVE OLD INSTANCE
--========================================================

local old = PlayerGui:FindFirstChild("AfnanSakhaHub")
if old then
    old:Destroy()
end

--========================================================
-- UTILITY FUNCTIONS
--========================================================

local function AddCorner(object, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 5)
    c.Parent = object
    return c
end

local function AddStroke(object, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or Theme.Border
    s.Thickness = thickness or 1
    s.Parent = object
    return s
end

local function NewLabel(parent, text, textSize, height)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Theme.Text
    l.Font = Enum.Font.Gotham
    l.TextSize = textSize or 12
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Size = UDim2.new(1, 0, 0, height or 24)
    l.Parent = parent
    return l
end

local function NewButton(parent, text, size)
    local b = Instance.new("TextButton")
    b.AutoButtonColor = false
    b.Text = text
    b.TextColor3 = Theme.Text
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 11
    b.BackgroundColor3 = Theme.Panel2
    b.BorderSizePixel = 0
    b.Size = size
    b.Parent = parent
    AddCorner(b, 5)
    AddStroke(b, Theme.Border, 1)
    return b
end

--========================================================
-- SCREEN GUI
--========================================================

local Gui = Instance.new("ScreenGui")
Gui.Name = "AfnanSakhaHub"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

-- UI scale makes the window usable on phones/tablets too.
local Scale = Instance.new("UIScale")
Scale.Scale = math.clamp(math.min(
    Gui.AbsoluteSize.X / 900,
    Gui.AbsoluteSize.Y / 700
), 0.72, 1.15)
Scale.Parent = Gui

--========================================================
-- FOV CIRCLE
--========================================================

local FOV = Instance.new("Frame")
FOV.Name = "AimbotCircle"
FOV.AnchorPoint = Vector2.new(0.5, 0.5)
FOV.Position = UDim2.fromScale(0.5, 0.5)
FOV.Size = UDim2.fromOffset(DEFAULTS.Radius * 2, DEFAULTS.Radius * 2)
FOV.BackgroundTransparency = 1
FOV.BorderSizePixel = 0
FOV.Visible = true
FOV.ZIndex = 2
FOV.Parent = Gui
AddCorner(FOV, 999)

local CircleColors = {
    Red = Color3.fromRGB(255, 70, 70),
    Blue = Color3.fromRGB(45, 145, 255),
    Cyan = Color3.fromRGB(56, 220, 255),
    Green = Color3.fromRGB(60, 230, 130),
    Yellow = Color3.fromRGB(255, 220, 70),
    White = Color3.fromRGB(245, 245, 245),
    Purple = Color3.fromRGB(170, 100, 255),
}

local FOVStroke = AddStroke(FOV, CircleColors[DEFAULTS.CircleColor], 2)
FOVStroke.Transparency = 0.08

--========================================================
-- MAIN WINDOW
--========================================================

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Position = UDim2.fromScale(0.70, 0.54)
Main.Size = UDim2.fromOffset(370, 300)
Main.BackgroundColor3 = Theme.Background
Main.BorderSizePixel = 0
Main.ZIndex = 10
Main.Parent = Gui
AddCorner(Main, 8)
AddStroke(Main, Theme.BlueDark, 2)

--========================================================
-- HEADER
--========================================================

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 36)
Header.BackgroundColor3 = Theme.Header
Header.BorderSizePixel = 0
Header.ZIndex = 11
Header.Parent = Main
AddCorner(Header, 8)

local Title = NewLabel(Header, "AFNANSAKHA HUB", 13, 30)
Title.Position = UDim2.fromOffset(11, 3)
Title.Size = UDim2.new(1, -48, 0, 30)
Title.TextColor3 = Theme.Cyan
Title.Font = Enum.Font.GothamBold
Title.ZIndex = 12

local Close = NewButton(Header, "×", UDim2.fromOffset(27, 27))
Close.Position = UDim2.new(1, -31, 0, 4)
Close.TextSize = 18
Close.ZIndex = 13

Close.MouseButton1Click:Connect(function()
    State.Visible = false
    Main.Visible = false
end)

--========================================================
-- TABS
--========================================================

local Tabs = Instance.new("Frame")
Tabs.BackgroundTransparency = 1
Tabs.Position = UDim2.fromOffset(8, 42)
Tabs.Size = UDim2.new(1, -16, 0, 29)
Tabs.ZIndex = 11
Tabs.Parent = Main

local TabButtons = {}
local Pages = {}

local function CreateTab(name, x)
    local b = NewButton(Tabs, name, UDim2.fromOffset(108, 28))
    b.Position = UDim2.fromOffset(x, 0)
    b.ZIndex = 12
    TabButtons[name] = b
    return b
end

CreateTab("SCRIPTS", 0)
CreateTab("SETTINGS", 112)
CreateTab("HISTORY", 224)

local Content = Instance.new("Frame")
Content.BackgroundTransparency = 1
Content.Position = UDim2.fromOffset(8, 77)
Content.Size = UDim2.new(1, -16, 1, -85)
Content.ZIndex = 11
Content.Parent = Main

for _, name in ipairs({"SCRIPTS", "SETTINGS", "HISTORY"}) do
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.Size = UDim2.fromScale(1, 1)
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Theme.Blue
    page.Visible = false
    page.ZIndex = 11
    page.Parent = Content

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 5)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Parent = page

    local padding = Instance.new("UIPadding")
    padding.PaddingBottom = UDim.new(0, 8)
    padding.Parent = page

    Pages[name] = page
end

local function SetTab(name)
    for pageName, page in pairs(Pages) do
        page.Visible = pageName == name
    end

    for tabName, tab in pairs(TabButtons) do
        tab.BackgroundColor3 = tabName == name and Theme.BlueDark or Theme.Panel2
    end
end

for name, tab in pairs(TabButtons) do
    tab.MouseButton1Click:Connect(function()
        SetTab(name)
    end)
end

SetTab("SCRIPTS")

--========================================================
-- CONTROLS
--========================================================

local function CreateToggle(parent, text, initial, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 32)
    row.BackgroundColor3 = Theme.Panel
    row.BorderSizePixel = 0
    row.ZIndex = 12
    row.Parent = parent
    AddCorner(row, 5)
    AddStroke(row, Theme.Border, 1)

    local txt = NewLabel(row, text, 10, 26)
    txt.Position = UDim2.fromOffset(9, 3)
    txt.Size = UDim2.new(1, -57, 0, 26)
    txt.ZIndex = 13

    local switch = Instance.new("TextButton")
    switch.Text = ""
    switch.AutoButtonColor = false
    switch.Size = UDim2.fromOffset(38, 20)
    switch.Position = UDim2.new(1, -47, 0.5, -10)
    switch.BackgroundColor3 = initial and Theme.Blue or Theme.Off
    switch.BorderSizePixel = 0
    switch.ZIndex = 13
    switch.Parent = row
    AddCorner(switch, 10)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(14, 14)
    knob.Position = initial
        and UDim2.new(1, -17, 0.5, -7)
        or UDim2.fromOffset(3, 3)
    knob.BackgroundColor3 = Color3.fromRGB(245, 250, 255)
    knob.BorderSizePixel = 0
    knob.ZIndex = 14
    knob.Parent = switch
    AddCorner(knob, 10)

    local value = initial

    switch.MouseButton1Click:Connect(function()
        value = not value
        switch.BackgroundColor3 = value and Theme.Blue or Theme.Off
        knob.Position = value
            and UDim2.new(1, -17, 0.5, -7)
            or UDim2.fromOffset(3, 3)
        callback(value)
    end)

    return row
end

local function CreateDropdown(parent, text, options, initial, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 52)
    row.BackgroundColor3 = Theme.Panel
    row.BorderSizePixel = 0
    row.ZIndex = 12
    row.Parent = parent
    AddCorner(row, 5)
    AddStroke(row, Theme.Border, 1)

    local txt = NewLabel(row, text, 10, 20)
    txt.Position = UDim2.fromOffset(9, 1)
    txt.ZIndex = 13

    local current = NewButton(row, initial, UDim2.new(1, -18, 0, 24))
    current.Position = UDim2.fromOffset(9, 25)
    current.TextXAlignment = Enum.TextXAlignment.Left
    current.ZIndex = 13

    local menu = Instance.new("Frame")
    menu.BackgroundColor3 = Theme.Panel2
    menu.BorderSizePixel = 0
    menu.Position = UDim2.fromOffset(9, 50)
    menu.Size = UDim2.new(1, -18, 0, #options * 25)
    menu.Visible = false
    menu.ZIndex = 50
    menu.Parent = row
    AddCorner(menu, 4)
    AddStroke(menu, Theme.Border, 1)

    local opened = false

    for i, option in ipairs(options) do
        local opt = NewButton(menu, option, UDim2.new(1, 0, 0, 25))
        opt.Position = UDim2.fromOffset(0, (i - 1) * 25)
        opt.ZIndex = 51

        opt.MouseButton1Click:Connect(function()
            current.Text = option
            opened = false
            menu.Visible = false
            callback(option)
        end)
    end

    current.MouseButton1Click:Connect(function()
        opened = not opened
        menu.Visible = opened
    end)

    return row
end

local function CreateSlider(parent, text, minimum, maximum, initial, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 48)
    row.BackgroundColor3 = Theme.Panel
    row.BorderSizePixel = 0
    row.ZIndex = 12
    row.Parent = parent
    AddCorner(row, 5)
    AddStroke(row, Theme.Border, 1)

    local txt = NewLabel(row, text, 10, 20)
    txt.Position = UDim2.fromOffset(9, 2)
    txt.Size = UDim2.new(1, -75, 0, 20)
    txt.ZIndex = 13

    local valueText = NewLabel(row, tostring(initial), 10, 20)
    valueText.Position = UDim2.new(1, -68, 0, 2)
    valueText.Size = UDim2.fromOffset(59, 20)
    valueText.TextXAlignment = Enum.TextXAlignment.Right
    valueText.TextColor3 = Theme.Sub
    valueText.ZIndex = 13

    local bar = Instance.new("Frame")
    bar.Position = UDim2.fromOffset(9, 29)
    bar.Size = UDim2.new(1, -18, 0, 6)
    bar.BackgroundColor3 = Color3.fromRGB(36, 55, 71)
    bar.BorderSizePixel = 0
    bar.ZIndex = 13
    bar.Parent = row
    AddCorner(bar, 6)

    local fill = Instance.new("Frame")
    fill.BackgroundColor3 = Theme.Blue
    fill.BorderSizePixel = 0
    fill.Size = UDim2.new(
        (initial - minimum) / (maximum - minimum),
        0, 1, 0
    )
    fill.ZIndex = 14
    fill.Parent = bar
    AddCorner(fill, 6)

    local dragging = false

    local function SetFromX(x)
        if bar.AbsoluteSize.X <= 0 then return end

        local percent = math.clamp(
            (x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X,
            0, 1
        )

        local value = math.floor(
            minimum + (maximum - minimum) * percent + 0.5
        )

        fill.Size = UDim2.new(
            (value - minimum) / (maximum - minimum),
            0, 1, 0
        )

        valueText.Text = tostring(value)
        callback(value)
    end

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            SetFromX(input.Position.X)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end

        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            SetFromX(input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    return row
end

--========================================================
-- HISTORY
--========================================================

local HistoryPage = Pages.HISTORY

local HistoryTitle = NewLabel(
    HistoryPage,
    "HISTORY",
    12,
    24
)
HistoryTitle.TextColor3 = Theme.Cyan
HistoryTitle.Font = Enum.Font.GothamBold

local HistoryBox = Instance.new("TextLabel")
HistoryBox.Size = UDim2.new(1, 0, 0, 150)
HistoryBox.BackgroundColor3 = Theme.Panel
HistoryBox.BorderSizePixel = 0
HistoryBox.TextColor3 = Theme.Sub
HistoryBox.Font = Enum.Font.Code
HistoryBox.TextSize = 10
HistoryBox.TextXAlignment = Enum.TextXAlignment.Left
HistoryBox.TextYAlignment = Enum.TextYAlignment.Top
HistoryBox.TextWrapped = true
HistoryBox.Text = "Ready.\nStudio-safe mode initialized."
HistoryBox.ZIndex = 12
HistoryBox.Parent = HistoryPage
AddCorner(HistoryBox, 5)
AddStroke(HistoryBox, Theme.Border, 1)

local function Log(message)
    HistoryBox.Text = HistoryBox.Text
        .. "\n[" .. os.date("%H:%M:%S") .. "] "
        .. message
end

local ClearHistory = NewButton(
    HistoryPage,
    "CLEAR HISTORY",
    UDim2.new(1, 0, 0, 32)
)
ClearHistory.MouseButton1Click:Connect(function()
    HistoryBox.Text = "History cleared."
end)

--========================================================
-- SCRIPTS PAGE
--========================================================

local ScriptsPage = Pages.SCRIPTS

local ScriptsTitle = NewLabel(
    ScriptsPage,
    "SCRIPT CONTROLS",
    12,
    24
)
ScriptsTitle.TextColor3 = Theme.Cyan
ScriptsTitle.Font = Enum.Font.GothamBold

CreateToggle(
    ScriptsPage,
    "Aimbot Circle (ON)",
    State.Circle,
    function(value)
        State.Circle = value
        FOV.Visible = value
        Log("Aimbot Circle = " .. tostring(value))
    end
)

CreateToggle(
    ScriptsPage,
    "Aimbot Shoot Button (OFF)",
    State.ShootButton,
    function(value)
        State.ShootButton = value
        Log("Aimbot Shoot Button = " .. tostring(value))
    end
)

CreateToggle(
    ScriptsPage,
    "Remove Teammate target (OFF)",
    State.RemoveTeammates,
    function(value)
        State.RemoveTeammates = value
        Log("Remove Teammate target = " .. tostring(value))
    end
)

CreateSlider(
    ScriptsPage,
    "Circle Radius",
    50,
    500,
    State.Radius,
    function(value)
        State.Radius = value
        FOV.Size = UDim2.fromOffset(value * 2, value * 2)
    end
)

CreateDropdown(
    ScriptsPage,
    "Circle Color",
    {"Red", "Blue", "Cyan", "Green", "Yellow", "White", "Purple"},
    State.CircleColor,
    function(value)
        State.CircleColor = value
        local selectedColor = CircleColors[value]
        if selectedColor then
            FOVStroke.Color = selectedColor
        end
        Log("Circle Color = " .. value)
    end
)

CreateDropdown(
    ScriptsPage,
    "Camera Target",
    {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"},
    State.CameraTarget,
    function(value)
        State.CameraTarget = value
        State.TargetPart = value
        Log("Camera Target = " .. value)
    end
)

CreateToggle(
    ScriptsPage,
    "Visibility Check",
    State.VisibilityCheck,
    function(value)
        State.VisibilityCheck = value
    end
)

CreateToggle(
    ScriptsPage,
    "Aimbot Enabled (Studio Test)",
    State.AimbotEnabled,
    function(value)
        State.AimbotEnabled = value
        Log("Aimbot Studio Test = " .. tostring(value))
    end
)

CreateSlider(
    ScriptsPage,
    "Aim Smoothness",
    1,
    20,
    State.Smoothness,
    function(value)
        State.Smoothness = value
    end
)

CreateDropdown(
    ScriptsPage,
    "Activation Mode",
    {"Always", "Hold", "Toggle"},
    State.ActivationMode,
    function(value)
        State.ActivationMode = value
        Log("Activation Mode = " .. value)
    end
)

local Execute = NewButton(
    ScriptsPage,
    "EXECUTE SELECTED SCRIPTS",
    UDim2.new(1, 0, 0, 34)
)
Execute.BackgroundColor3 = Theme.BlueDark

local PasteBin = NewButton(
    ScriptsPage,
    "PASTE BIN",
    UDim2.new(1, 0, 0, 32)
)

local ClearTarget = NewButton(
    ScriptsPage,
    "CLEAR TARGET",
    UDim2.new(1, 0, 0, 32)
)

local TargetStatus = NewLabel(
    ScriptsPage,
    "Target: none",
    10,
    22
)
TargetStatus.TextColor3 = Theme.Sub

--========================================================
-- SETTINGS PAGE
--========================================================

local SettingsPage = Pages.SETTINGS

local SettingsTitle = NewLabel(
    SettingsPage,
    "SETTINGS",
    12,
    24
)
SettingsTitle.TextColor3 = Theme.Cyan
SettingsTitle.Font = Enum.Font.GothamBold

CreateToggle(
    SettingsPage,
    "Show FOV Circle",
    State.Circle,
    function(value)
        State.Circle = value
        FOV.Visible = value
    end
)

CreateToggle(
    SettingsPage,
    "Visibility Check",
    State.VisibilityCheck,
    function(value)
        State.VisibilityCheck = value
    end
)

CreateDropdown(
    SettingsPage,
    "Circle Color",
    {"Red", "Blue", "Cyan", "Green", "Yellow", "White", "Purple"},
    State.CircleColor,
    function(value)
        State.CircleColor = value
        local selectedColor = CircleColors[value]
        if selectedColor then
            FOVStroke.Color = selectedColor
        end
    end
)

CreateDropdown(
    SettingsPage,
    "Camera Target",
    {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"},
    State.CameraTarget,
    function(value)
        State.CameraTarget = value
        State.TargetPart = value
    end
)

CreateDropdown(
    SettingsPage,
    "Activation Mode",
    {"Always", "Hold", "Toggle"},
    State.ActivationMode,
    function(value)
        State.ActivationMode = value
    end
)

local Reset = NewButton(
    SettingsPage,
    "RESET ALL SETTINGS",
    UDim2.new(1, 0, 0, 34)
)
Reset.BackgroundColor3 = Theme.BlueDark

--========================================================
-- TARGET FUNCTIONS
--========================================================

local function GetTargetFolder()
    return workspace:FindFirstChild("TestTargets")
end

local function GetPart(model)
    if not model then return nil end

    local requested = State.CameraTarget or State.TargetPart or "Head"

    return model:FindFirstChild(requested)
        or model:FindFirstChild("Head")
        or model:FindFirstChild("HumanoidRootPart")
end

local function IsVisible(part)
    if not State.VisibilityCheck then
        return true
    end

    local camera = workspace.CurrentCamera
    if not camera or not part then
        return false
    end

    local character = LocalPlayer.Character

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = character
        and {character}
        or {}

    local origin = camera.CFrame.Position
    local direction = part.Position - origin
    local result = workspace:Raycast(origin, direction, params)

    if result == nil then
        return true
    end

    return result.Instance ~= nil
        and result.Instance:IsDescendantOf(part.Parent)
end

local function IsTeammate(model)
    if not State.RemoveTeammates then
        return false
    end

    local otherPlayer = Players:GetPlayerFromCharacter(model)
    if not otherPlayer then
        return false
    end

    return otherPlayer.Team ~= nil
        and LocalPlayer.Team ~= nil
        and otherPlayer.Team == LocalPlayer.Team
end

local function FindBestTarget()
    local folder = GetTargetFolder()
    local camera = workspace.CurrentCamera

    if not folder or not camera then
        return nil
    end

    local viewportCenter = Vector2.new(
        camera.ViewportSize.X / 2,
        camera.ViewportSize.Y / 2
    )

    local best = nil
    local bestDistance = State.Radius

    for _, model in ipairs(folder:GetChildren()) do
        if model:IsA("Model") and not IsTeammate(model) then
            local humanoid = model:FindFirstChildOfClass("Humanoid")
            local part = GetPart(model)

            if humanoid and humanoid.Health > 0 and part then
                local screenPosition, onScreen =
                    camera:WorldToViewportPoint(part.Position)

                if onScreen then
                    local distance = (
                        Vector2.new(screenPosition.X, screenPosition.Y)
                        - viewportCenter
                    ).Magnitude

                    if distance <= bestDistance and IsVisible(part) then
                        best = model
                        bestDistance = distance
                    end
                end
            end
        end
    end

    return best
end

--========================================================
-- BUTTON ACTIONS
--========================================================

Execute.MouseButton1Click:Connect(function()
    local target = FindBestTarget()

    if target then
        State.SelectedTarget = target
        TargetStatus.Text = "Target: " .. target.Name
        TargetStatus.TextColor3 = Theme.Cyan
        Log("Selected Studio test target: " .. target.Name)
    else
        State.SelectedTarget = nil
        TargetStatus.Text = "Target: none"
        TargetStatus.TextColor3 = Theme.Sub
        Log("No valid TestTargets target found.")
    end
end)

PasteBin.MouseButton1Click:Connect(function()
    -- Intentionally safe: arbitrary code execution is not supported.
    Log("Paste Bin is disabled in Studio-safe mode.")
end)

ClearTarget.MouseButton1Click:Connect(function()
    State.SelectedTarget = nil
    TargetStatus.Text = "Target: none"
    TargetStatus.TextColor3 = Theme.Sub
    Log("Target cleared.")
end)

Reset.MouseButton1Click:Connect(function()
    for k, v in pairs(DEFAULTS) do
        State[k] = v
    end

    State.SelectedTarget = nil

    FOV.Visible = State.Circle
    FOV.Size = UDim2.fromOffset(State.Radius * 2, State.Radius * 2)

    local resetColor = CircleColors[State.CircleColor]
    if resetColor then
        FOVStroke.Color = resetColor
    end

    TargetStatus.Text = "Target: none"
    TargetStatus.TextColor3 = Theme.Sub

    Log("All settings reset.")
end)

--========================================================
-- DRAGGING
--========================================================

local dragging = false
local dragStart
local startPosition

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPosition = Main.Position
    end
end)

Header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not dragging then return end

    if input.UserInputType ~= Enum.UserInputType.MouseMovement
        and input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end

    local delta = input.Position - dragStart

    Main.Position = UDim2.new(
        startPosition.X.Scale,
        startPosition.X.Offset + delta.X,
        startPosition.Y.Scale,
        startPosition.Y.Offset + delta.Y
    )
end)

--========================================================
-- RIGHT SHIFT TOGGLE
--========================================================

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.RightShift then
        State.Visible = not State.Visible
        Main.Visible = State.Visible
    end
end)

--========================================================
-- HIGHLIGHT / TEST TARGET UPDATE
--========================================================

local Highlight

local function RemoveHighlight()
    if Highlight then
        Highlight:Destroy()
        Highlight = nil
    end
end

local function ShowHighlight(model)
    if not model then
        RemoveHighlight()
        return
    end

    if not Highlight then
        Highlight = Instance.new("Highlight")
        Highlight.Name = "AfnanSakhaStudioTarget"
        Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        Highlight.FillTransparency = 0.72
        Highlight.OutlineTransparency = 0
        Highlight.FillColor = Theme.Blue
        Highlight.OutlineColor = Theme.Cyan
        Highlight.Parent = Gui
    end

    Highlight.Adornee = model
end

RunService.RenderStepped:Connect(function()
    -- Keep the FOV circle centered.
    FOV.Position = UDim2.fromScale(0.5, 0.5)

    -- Only run target selection in the private Studio test folder.
    if not State.AimbotEnabled then
        RemoveHighlight()
        return
    end

    if State.SelectedTarget then
        local humanoid = State.SelectedTarget:FindFirstChildOfClass("Humanoid")

        if not State.SelectedTarget.Parent
            or not humanoid
            or humanoid.Health <= 0 then

            State.SelectedTarget = nil
            TargetStatus.Text = "Target: none"
        end
    end

    if not State.SelectedTarget then
        State.SelectedTarget = FindBestTarget()
    end

    if State.SelectedTarget then
        TargetStatus.Text = "Target: " .. State.SelectedTarget.Name
        TargetStatus.TextColor3 = Theme.Cyan
        ShowHighlight(State.SelectedTarget)
    else
        RemoveHighlight()
    end
end)

--========================================================
-- INITIALIZE
--========================================================

FOV.Size = UDim2.fromOffset(
    State.Radius * 2,
    State.Radius * 2
)

FOV.Visible = State.Circle
FOVStroke.Color = CircleColors[State.CircleColor] or Theme.Cyan

Log("UI loaded successfully.")
Log("Studio-safe mode: ready.")


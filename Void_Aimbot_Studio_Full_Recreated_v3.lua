--[[
============================================================
 VOID AIMBOT / VOIDHUB - ROBLOX STUDIO PRIVATE TEST v3
============================================================
INSTALL:
StarterPlayer > StarterPlayerScripts > LocalScript

SAFE TEST TARGETS:
Create Workspace.TestTargets (Folder) and put NPC Models
inside it. Each Model should have a Humanoid and Head or
HumanoidRootPart.

This is a Studio test UI. Targeting is deliberately limited
to Workspace.TestTargets and does not use exploit/executor APIs.

HOTKEYS:
Q          = Aim (default)
RightShift = Show / Hide UI
F8         = Reset test settings
============================================================
]]

--============================================================
-- SERVICES
--============================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

--============================================================
-- STATE
--============================================================

local Defaults = {
    UIVisible = true,

    Aimbot = true,
    TeamCheck = true,
    VisibilityCheck = true,
    WallCheck = true,
    TargetPart = "Head",
    FOVRadius = 150,
    Smoothness = 5,
    ActivationMode = "Always",
    AimKey = Enum.KeyCode.Q,
    AimHeld = false,

    Triggerbot = false,
    TriggerMode = "Always On",
    TriggerKey = Enum.UserInputType.MouseButton2,
    TriggerDelay = 50,
    TriggerTeamCheck = false,

    AutoClicker = false,
    ClickPerSecond = 10,

    ShowFOV = false,
    FilledFOV = false,
    FillTransparency = 1,

    ESP = false,
    ESPNames = true,
    ESPDistance = true,
    ESPHealth = false,
    ESPBoxes = false,

    WalkSpeedEnabled = false,
    WalkSpeed = 16,
    JumpPowerEnabled = false,
    JumpPower = 50,

    FullBright = false,
    NoFog = false,

    RainbowUI = false,
    UITransparency = 0,
}

local State = {}
for k, v in pairs(Defaults) do
    State[k] = v
end

--============================================================
-- THEME
--============================================================

local Theme = {
    Background = Color3.fromRGB(14, 15, 17),
    Topbar = Color3.fromRGB(20, 21, 24),
    Panel = Color3.fromRGB(18, 19, 22),
    Panel2 = Color3.fromRGB(25, 26, 30),
    Panel3 = Color3.fromRGB(31, 32, 37),

    Text = Color3.fromRGB(242, 243, 247),
    SubText = Color3.fromRGB(178, 180, 188),
    Muted = Color3.fromRGB(112, 115, 124),

    Blue = Color3.fromRGB(38, 100, 245),
    BlueBright = Color3.fromRGB(62, 125, 255),
    BlueDark = Color3.fromRGB(23, 61, 150),

    Border = Color3.fromRGB(58, 60, 67),
    Off = Color3.fromRGB(48, 50, 56),

    Green = Color3.fromRGB(45, 220, 85),
    Red = Color3.fromRGB(235, 70, 82),
    Yellow = Color3.fromRGB(245, 195, 55),
}

local function clamp(value, minimum, maximum)
    return math.max(minimum, math.min(maximum, value))
end

local function tween(instance, duration, properties)
    return TweenService:Create(
        instance,
        TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        properties
    )
end

local function isAlive(model)
    if not model or not model:IsA("Model") then
        return false
    end

    local humanoid = model:FindFirstChildOfClass("Humanoid")
    return humanoid ~= nil and humanoid.Health > 0
end

--============================================================
-- CLEAN PREVIOUS UI
--============================================================

local old = PlayerGui:FindFirstChild("VoidAimbotUI")
if old then
    old:Destroy()
end

pcall(function()
    RunService:UnbindFromRenderStep("VoidAimbotStudioTest")
end)

--============================================================
-- SCREEN GUI
--============================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VoidAimbotUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 100
ScreenGui.Parent = PlayerGui

--============================================================
-- MAIN WINDOW
--============================================================

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(1040, 690)
Main.Position = UDim2.new(0.5, -520, 0.5, -345)
Main.BackgroundColor3 = Theme.Background
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 6)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Theme.BlueDark
MainStroke.Thickness = 2
MainStroke.Parent = Main

--============================================================
-- TOP BAR
--============================================================

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 48)
TopBar.BackgroundColor3 = Theme.Topbar
TopBar.BorderSizePixel = 0
TopBar.Parent = Main

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Position = UDim2.fromOffset(16, 0)
Title.Size = UDim2.fromOffset(260, 48)
Title.Font = Enum.Font.GothamMedium
Title.Text = "Void Aimbot Script"
Title.TextColor3 = Theme.Text
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local Status = Instance.new("TextLabel")
Status.BackgroundTransparency = 1
Status.Position = UDim2.fromOffset(225, 0)
Status.Size = UDim2.fromOffset(150, 48)
Status.Font = Enum.Font.Gotham
Status.Text = "STUDIO TEST"
Status.TextColor3 = Theme.BlueBright
Status.TextSize = 10
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.Parent = TopBar

local AimKeyLabel = Instance.new("TextLabel")
AimKeyLabel.BackgroundTransparency = 1
AimKeyLabel.AnchorPoint = Vector2.new(0.5, 0)
AimKeyLabel.Position = UDim2.new(0.5, 0, 0, 0)
AimKeyLabel.Size = UDim2.fromOffset(220, 48)
AimKeyLabel.Font = Enum.Font.Gotham
AimKeyLabel.Text = "Aim Key: " .. State.AimKey.Name
AimKeyLabel.TextColor3 = Theme.SubText
AimKeyLabel.TextSize = 13
AimKeyLabel.Parent = TopBar

local Minimize = Instance.new("TextButton")
Minimize.Name = "Minimize"
Minimize.Position = UDim2.new(1, -82, 0, 6)
Minimize.Size = UDim2.fromOffset(34, 34)
Minimize.BackgroundColor3 = Theme.Panel2
Minimize.BorderSizePixel = 0
Minimize.Text = "—"
Minimize.Font = Enum.Font.GothamBold
Minimize.TextColor3 = Theme.Text
Minimize.TextSize = 17
Minimize.AutoButtonColor = false
Minimize.Parent = TopBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 4)
MinCorner.Parent = Minimize

local Close = Instance.new("TextButton")
Close.Name = "Close"
Close.Position = UDim2.new(1, -42, 0, 6)
Close.Size = UDim2.fromOffset(34, 34)
Close.BackgroundColor3 = Theme.Panel2
Close.BorderSizePixel = 0
Close.Text = "×"
Close.Font = Enum.Font.Gotham
Close.TextColor3 = Theme.SubText
Close.TextSize = 20
Close.AutoButtonColor = false
Close.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = Close

--============================================================
-- DRAGGING
--============================================================

local dragging = false
local dragStart
local startPosition

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPosition = Main.Position
    end
end)

TopBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not dragging then
        return
    end

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

--============================================================
-- BODY + TABS
--============================================================

local TabBar = Instance.new("Frame")
TabBar.Position = UDim2.fromOffset(8, 55)
TabBar.Size = UDim2.new(1, -16, 0, 43)
TabBar.BackgroundTransparency = 1
TabBar.Parent = Main

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 5)
TabLayout.Parent = TabBar

local Pages = {}
local Tabs = {}
local CurrentTab = "Combat"

local TabNames = {
    "Combat",
    "Visuals",
    "Player",
    "World",
    "Misc",
    "UI Settings",
}

for _, name in ipairs(TabNames) do
    local page = Instance.new("ScrollingFrame")
    page.Name = name:gsub("%s+", "") .. "Page"
    page.Position = UDim2.fromOffset(8, 104)
    page.Size = UDim2.new(1, -16, 1, -112)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = Theme.Blue
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.CanvasSize = UDim2.new()
    page.Visible = name == CurrentTab
    page.ClipsDescendants = true
    page.Parent = Main

    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 10)
    pad.PaddingRight = UDim.new(0, 10)
    pad.PaddingTop = UDim.new(0, 4)
    pad.PaddingBottom = UDim.new(0, 14)
    pad.Parent = page

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page

    Pages[name] = page

    local tab = Instance.new("TextButton")
    tab.Size = UDim2.fromOffset(name == "UI Settings" and 120 or 98, 40)
    tab.BackgroundColor3 = name == CurrentTab and Theme.Panel2 or Theme.Panel
    tab.BorderSizePixel = 0
    tab.Font = Enum.Font.GothamMedium
    tab.Text = name
    tab.TextColor3 = name == CurrentTab and Theme.Text or Theme.SubText
    tab.TextSize = 13
    tab.AutoButtonColor = false
    tab.Parent = TabBar

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = tab

    local accent = Instance.new("Frame")
    accent.Position = UDim2.new(0, 0, 1, -3)
    accent.Size = UDim2.new(1, 0, 0, 3)
    accent.BackgroundColor3 = Theme.Blue
    accent.BorderSizePixel = 0
    accent.Visible = name == CurrentTab
    accent.Parent = tab

    Tabs[name] = {
        Button = tab,
        Accent = accent,
    }

    tab.MouseButton1Click:Connect(function()
        CurrentTab = name

        for pageName, otherPage in pairs(Pages) do
            otherPage.Visible = pageName == name
        end

        for tabName, data in pairs(Tabs) do
            local active = tabName == name
            data.Button.BackgroundColor3 = active and Theme.Panel2 or Theme.Panel
            data.Button.TextColor3 = active and Theme.Text or Theme.SubText
            data.Accent.Visible = active
        end
    end)
end

--============================================================
-- FACTORIES
--============================================================

local function Section(parent, text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 28)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamMedium
    label.Text = text
    label.TextColor3 = Theme.Text
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
    return label
end

local function Panel(parent, height)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, height)
    frame.BackgroundColor3 = Theme.Panel
    frame.BorderSizePixel = 0
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Theme.Border
    stroke.Thickness = 1
    stroke.Parent = frame

    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 14)
    pad.PaddingRight = UDim.new(0, 14)
    pad.PaddingTop = UDim.new(0, 10)
    pad.PaddingBottom = UDim.new(0, 10)
    pad.Parent = frame

    return frame
end

local function Toggle(parent, text, default, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 34)
    row.BackgroundTransparency = 1
    row.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -52, 1, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = Theme.Text
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local button = Instance.new("TextButton")
    button.Position = UDim2.new(1, -32, 0.5, -12)
    button.Size = UDim2.fromOffset(26, 26)
    button.BackgroundColor3 = default and Theme.Blue or Theme.Off
    button.BorderSizePixel = 0
    button.Text = default and "✓" or ""
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextSize = 16
    button.Font = Enum.Font.GothamBold
    button.AutoButtonColor = false
    button.Parent = row

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 3)
    corner.Parent = button

    local value = default

    button.MouseButton1Click:Connect(function()
        value = not value
        button.BackgroundColor3 = value and Theme.Blue or Theme.Off
        button.Text = value and "✓" or ""
        callback(value)
    end)

    return row
end

local function Slider(parent, text, min, max, default, callback, suffix)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 60)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -100, 0, 20)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = Theme.Text
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Position = UDim2.new(1, -100, 0, 0)
    valueLabel.Size = UDim2.fromOffset(100, 20)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextColor3 = Theme.SubText
    valueLabel.TextSize = 10
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Text = tostring(default) .. (suffix or "")
    valueLabel.Parent = frame

    local bar = Instance.new("Frame")
    bar.Position = UDim2.fromOffset(0, 28)
    bar.Size = UDim2.new(1, 0, 0, 18)
    bar.BackgroundColor3 = Theme.Panel3
    bar.BorderSizePixel = 0
    bar.Parent = frame

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 3)
    barCorner.Parent = bar

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(
        (default - min) / math.max(max - min, 1),
        0,
        1,
        0
    )
    fill.BackgroundColor3 = Theme.Blue
    fill.BorderSizePixel = 0
    fill.Parent = bar

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 3)
    fillCorner.Parent = fill

    local moving = false

    local function setFromX(x)
        local width = math.max(bar.AbsoluteSize.X, 1)
        local percent = clamp(
            (x - bar.AbsolutePosition.X) / width,
            0,
            1
        )

        local value = min + ((max - min) * percent)
        value = math.floor(value + 0.5)

        local fraction = (value - min) / math.max(max - min, 1)
        fill.Size = UDim2.new(fraction, 0, 1, 0)
        valueLabel.Text = tostring(value) .. (suffix or "")
        callback(value)
    end

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            moving = true
            setFromX(input.Position.X)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not moving then
            return
        end

        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then

            setFromX(input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            moving = false
        end
    end)

    return frame
end

local function Dropdown(parent, text, options, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 60)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    frame.ZIndex = 10

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = Theme.Text
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local button = Instance.new("TextButton")
    button.Position = UDim2.fromOffset(0, 26)
    button.Size = UDim2.new(1, 0, 0, 31)
    button.BackgroundColor3 = Theme.Panel2
    button.BorderSizePixel = 0
    button.Font = Enum.Font.Gotham
    button.Text = tostring(default)
    button.TextColor3 = Theme.Text
    button.TextSize = 11
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.AutoButtonColor = false
    button.Parent = frame

    local arrow = Instance.new("TextLabel")
    arrow.AnchorPoint = Vector2.new(1, 0.5)
    arrow.Position = UDim2.new(1, -8, 0, 41)
    arrow.Size = UDim2.fromOffset(20, 20)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.Font = Enum.Font.Gotham
    arrow.TextColor3 = Theme.SubText
    arrow.TextSize = 10
    arrow.Parent = frame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 3)
    corner.Parent = button

    local open = false

    local menu = Instance.new("Frame")
    menu.Position = UDim2.fromOffset(0, 59)
    menu.Size = UDim2.new(1, 0, 0, #options * 28)
    menu.BackgroundColor3 = Theme.Panel3
    menu.BorderSizePixel = 0
    menu.Visible = false
    menu.ZIndex = 100
    menu.Parent = frame

    local menuCorner = Instance.new("UICorner")
    menuCorner.CornerRadius = UDim.new(0, 3)
    menuCorner.Parent = menu

    for index, option in ipairs(options) do
        local choice = Instance.new("TextButton")
        choice.Position = UDim2.fromOffset(0, (index - 1) * 28)
        choice.Size = UDim2.new(1, 0, 0, 28)
        choice.BackgroundTransparency = 1
        choice.Font = Enum.Font.Gotham
        choice.Text = tostring(option)
        choice.TextColor3 = Theme.Text
        choice.TextSize = 11
        choice.TextXAlignment = Enum.TextXAlignment.Left
        choice.ZIndex = 101
        choice.Parent = menu

        local choicePad = Instance.new("UIPadding")
        choicePad.PaddingLeft = UDim.new(0, 10)
        choicePad.Parent = choice

        choice.MouseButton1Click:Connect(function()
            button.Text = tostring(option)
            open = false
            menu.Visible = false
            callback(option)
        end)
    end

    button.MouseButton1Click:Connect(function()
        open = not open
        menu.Visible = open
    end)

    return frame
end

local function Keybind(parent, text, defaultKey, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 34)
    button.BackgroundColor3 = Theme.Panel2
    button.BorderSizePixel = 0
    button.Font = Enum.Font.Gotham
    button.Text = text .. ": " .. defaultKey.Name
    button.TextColor3 = Theme.Text
    button.TextSize = 11
    button.AutoButtonColor = false
    button.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 3)
    corner.Parent = button

    local waiting = false
    local connection

    button.MouseButton1Click:Connect(function()
        if waiting then
            return
        end

        waiting = true
        button.Text = text .. ": Press a key..."

        connection = UserInputService.InputBegan:Connect(function(input, processed)
            if processed then
                return
            end

            if input.UserInputType == Enum.UserInputType.Keyboard then
                waiting = false
                button.Text = text .. ": " .. input.KeyCode.Name
                callback(input.KeyCode)

                if connection then
                    connection:Disconnect()
                    connection = nil
                end
            end
        end)
    end)

    return button
end

local function ActionButton(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 34)
    button.BackgroundColor3 = Theme.Panel2
    button.BorderSizePixel = 0
    button.Font = Enum.Font.Gotham
    button.Text = text
    button.TextColor3 = Theme.Text
    button.TextSize = 11
    button.AutoButtonColor = false
    button.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 3)
    corner.Parent = button

    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Theme.Panel3
    end)

    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Theme.Panel2
    end)

    button.MouseButton1Click:Connect(callback)
    return button
end

--============================================================
-- COMBAT
--============================================================

local Combat = Pages["Combat"]

Section(Combat, "Aimbot")

local AimPanel = Panel(Combat, 405)

Toggle(AimPanel, "Enabled", State.Aimbot, function(v)
    State.Aimbot = v
end)

Toggle(AimPanel, "Team Check", State.TeamCheck, function(v)
    State.TeamCheck = v
end)

Toggle(AimPanel, "Visibility Check", State.VisibilityCheck, function(v)
    State.VisibilityCheck = v
end)

Toggle(AimPanel, "Wall Check (Raycast)", State.WallCheck, function(v)
    State.WallCheck = v
end)

Dropdown(
    AimPanel,
    "Target Part",
    {"Head", "HumanoidRootPart", "UpperTorso", "Torso"},
    State.TargetPart,
    function(v)
        State.TargetPart = v
    end
)

Slider(
    AimPanel,
    "FOV Radius",
    25,
    500,
    State.FOVRadius,
    function(v)
        State.FOVRadius = v
    end,
    "/500"
)

Slider(
    AimPanel,
    "Smoothness",
    1,
    20,
    State.Smoothness,
    function(v)
        State.Smoothness = v
    end,
    "/20"
)

Dropdown(
    AimPanel,
    "Activation Mode",
    {"Always", "Hold Key"},
    State.ActivationMode,
    function(v)
        State.ActivationMode = v
    end
)

Keybind(
    AimPanel,
    "Aim Key",
    State.AimKey,
    function(v)
        State.AimKey = v
        AimKeyLabel.Text = "Aim Key: " .. v.Name
    end
)

Section(Combat, "Triggerbot & Auto Clicker")

local TriggerPanel = Panel(Combat, 430)

Toggle(TriggerPanel, "Triggerbot Enabled", State.Triggerbot, function(v)
    State.Triggerbot = v
end)

Dropdown(
    TriggerPanel,
    "Trigger Mode",
    {"Always On", "Hold Key"},
    State.TriggerMode,
    function(v)
        State.TriggerMode = v
    end
)

Dropdown(
    TriggerPanel,
    "Trigger Key",
    {"Right Mouse Button", "Left Mouse Button"},
    "Right Mouse Button",
    function(v)
        State.TriggerKey = v == "Right Mouse Button"
            and Enum.UserInputType.MouseButton2
            or Enum.UserInputType.MouseButton1
    end
)

Slider(
    TriggerPanel,
    "Trigger Delay (ms)",
    10,
    1000,
    State.TriggerDelay,
    function(v)
        State.TriggerDelay = v
    end,
    "/1000"
)

Toggle(
    TriggerPanel,
    "Trigger Team Check",
    State.TriggerTeamCheck,
    function(v)
        State.TriggerTeamCheck = v
    end
)

Toggle(
    TriggerPanel,
    "Auto Clicker (Continuous Tap)",
    State.AutoClicker,
    function(v)
        State.AutoClicker = v
    end
)

Slider(
    TriggerPanel,
    "Click Per Second (CPS)",
    1,
    30,
    State.ClickPerSecond,
    function(v)
        State.ClickPerSecond = v
    end,
    "/30"
)

Section(Combat, "FOV Circle Settings")

local FOVPanel = Panel(Combat, 245)

Toggle(FOVPanel, "Show FOV Circle", State.ShowFOV, function(v)
    State.ShowFOV = v
end)

Toggle(FOVPanel, "Filled FOV Circle", State.FilledFOV, function(v)
    State.FilledFOV = v
end)

Slider(
    FOVPanel,
    "Fill Transparency",
    0,
    100,
    math.floor(State.FillTransparency * 100),
    function(v)
        State.FillTransparency = v / 100
    end,
    "%"
)

--============================================================
-- VISUALS
--============================================================

local Visuals = Pages["Visuals"]

Section(Visuals, "ESP")

local ESPPanel = Panel(Visuals, 300)

Toggle(ESPPanel, "ESP Enabled", State.ESP, function(v)
    State.ESP = v
end)

Toggle(ESPPanel, "Names", State.ESPNames, function(v)
    State.ESPNames = v
end)

Toggle(ESPPanel, "Distance", State.ESPDistance, function(v)
    State.ESPDistance = v
end)

Toggle(ESPPanel, "Health", State.ESPHealth, function(v)
    State.ESPHealth = v
end)

Toggle(ESPPanel, "Boxes", State.ESPBoxes, function(v)
    State.ESPBoxes = v
end)

Section(Visuals, "Target Highlight")

local HitPanel = Panel(Visuals, 150)

ActionButton(HitPanel, "Highlight Current Target", function()
    local folder = workspace:FindFirstChild("TestTargets")
    if not folder then
        return
    end

    for _, model in ipairs(folder:GetChildren()) do
        if model:IsA("Model") then
            local oldHighlight = model:FindFirstChild("VoidTargetHighlight")
            if oldHighlight then
                oldHighlight:Destroy()
            end
        end
    end
end)

--============================================================
-- PLAYER
--============================================================

local PlayerPage = Pages["Player"]

Section(PlayerPage, "Movement")

local PlayerPanel = Panel(PlayerPage, 255)

Toggle(PlayerPanel, "WalkSpeed Enabled", State.WalkSpeedEnabled, function(v)
    State.WalkSpeedEnabled = v
end)

Slider(
    PlayerPanel,
    "WalkSpeed",
    8,
    100,
    State.WalkSpeed,
    function(v)
        State.WalkSpeed = v
    end
)

Toggle(PlayerPanel, "JumpPower Enabled", State.JumpPowerEnabled, function(v)
    State.JumpPowerEnabled = v
end)

Slider(
    PlayerPanel,
    "JumpPower",
    25,
    150,
    State.JumpPower,
    function(v)
        State.JumpPower = v
    end
)

Section(PlayerPage, "Player Actions")

local PlayerActions = Panel(PlayerPage, 120)

ActionButton(PlayerActions, "Reset Movement", function()
    State.WalkSpeedEnabled = false
    State.JumpPowerEnabled = false

    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        humanoid.WalkSpeed = 16
        humanoid.JumpPower = 50
    end
end)

--============================================================
-- WORLD
--============================================================

local World = Pages["World"]

Section(World, "Environment")

local WorldPanel = Panel(World, 190)

Toggle(WorldPanel, "FullBright", State.FullBright, function(v)
    State.FullBright = v
end)

Toggle(WorldPanel, "No Fog", State.NoFog, function(v)
    State.NoFog = v
end)

ActionButton(WorldPanel, "Restore Lighting", function()
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.FogStart = 0
    Lighting.FogEnd = 100000
end)

--============================================================
-- MISC
--============================================================

local Misc = Pages["Misc"]

Section(Misc, "Utilities")

local MiscPanel = Panel(Misc, 230)

ActionButton(MiscPanel, "Reset All Settings", function()
    for key, value in pairs(Defaults) do
        State[key] = value
    end

    AimKeyLabel.Text = "Aim Key: " .. State.AimKey.Name
end)

ActionButton(MiscPanel, "Hide UI", function()
    State.UIVisible = false
    Main.Visible = false
end)

ActionButton(MiscPanel, "Show UI", function()
    State.UIVisible = true
    Main.Visible = true
end)

ActionButton(MiscPanel, "Clear Test Highlights", function()
    local folder = workspace:FindFirstChild("TestTargets")
    if not folder then
        return
    end

    for _, model in ipairs(folder:GetChildren()) do
        local highlight = model:FindFirstChild("VoidTargetHighlight")
        if highlight then
            highlight:Destroy()
        end
    end
end)

Section(Misc, "Test Target Setup")

local SetupPanel = Panel(Misc, 150)

ActionButton(SetupPanel, "Create TestTargets Folder", function()
    local folder = workspace:FindFirstChild("TestTargets")
    if not folder then
        folder = Instance.new("Folder")
        folder.Name = "TestTargets"
        folder.Parent = workspace
    end
end)

ActionButton(SetupPanel, "Print Test Target Count", function()
    local folder = workspace:FindFirstChild("TestTargets")
    local count = 0

    if folder then
        for _, child in ipairs(folder:GetChildren()) do
            if child:IsA("Model") and isAlive(child) then
                count += 1
            end
        end
    end

    print("[VoidHub] Test targets:", count)
end)

--============================================================
-- UI SETTINGS
--============================================================

local UIPage = Pages["UI Settings"]

Section(UIPage, "Interface")

local UIPanel = Panel(UIPage, 230)

Toggle(UIPanel, "Rainbow Accent", State.RainbowUI, function(v)
    State.RainbowUI = v
end)

Slider(
    UIPanel,
    "UI Transparency",
    0,
    80,
    0,
    function(v)
        State.UITransparency = v / 100
    end,
    "%"
)

ActionButton(UIPanel, "Center Window", function()
    updateScale()
end)

ActionButton(UIPanel, "Toggle UI (RightShift)", function()
    State.UIVisible = not State.UIVisible
    Main.Visible = State.UIVisible
end)

--============================================================
-- FOV VISUAL
--============================================================

local FOVCircle = Instance.new("Frame")
FOVCircle.Name = "FOVCircle"
FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
FOVCircle.Position = UDim2.fromScale(0.5, 0.5)
FOVCircle.Size = UDim2.fromOffset(State.FOVRadius * 2, State.FOVRadius * 2)
FOVCircle.BackgroundColor3 = Theme.Blue
FOVCircle.BackgroundTransparency = 1
FOVCircle.BorderSizePixel = 0
FOVCircle.Visible = false
FOVCircle.ZIndex = 2
FOVCircle.Parent = ScreenGui

local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(1, 0)
FOVCorner.Parent = FOVCircle

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Color = Theme.BlueBright
FOVStroke.Thickness = 2
FOVStroke.Transparency = 0.1
FOVStroke.Parent = FOVCircle

local function updateFOV()
    local radius = State.FOVRadius
    FOVCircle.Size = UDim2.fromOffset(radius * 2, radius * 2)
    FOVCircle.Visible = State.ShowFOV
    FOVCircle.BackgroundTransparency = State.FilledFOV
        and clamp(State.FillTransparency, 0, 1)
        or 1
end

--============================================================
-- SAFE TEST TARGETING
--============================================================

local RayParams = RaycastParams.new()
RayParams.FilterType = Enum.RaycastFilterType.Exclude

local function updateRayFilter()
    local character = LocalPlayer.Character
    RayParams.FilterDescendantsInstances = character and {character} or {}
end

updateRayFilter()

LocalPlayer.CharacterAdded:Connect(function()
    task.defer(updateRayFilter)
end)

local function getTargetPart(model)
    if not model then
        return nil
    end

    local preferred = model:FindFirstChild(State.TargetPart)
    if preferred and preferred:IsA("BasePart") then
        return preferred
    end

    local fallback = model:FindFirstChild("Head")
        or model:FindFirstChild("HumanoidRootPart")

    return fallback and fallback:IsA("BasePart") and fallback or nil
end

local function sameTeam(model)
    if not State.TeamCheck then
        return false
    end

    local player = Players:GetPlayerFromCharacter(model)

    if not player then
        return false
    end

    return LocalPlayer.Team ~= nil
        and player.Team ~= nil
        and LocalPlayer.Team == player.Team
end

local function visible(part)
    if not part then
        return false
    end

    if not State.VisibilityCheck and not State.WallCheck then
        return true
    end

    Camera = workspace.CurrentCamera or Camera

    if not Camera then
        return false
    end

    local origin = Camera.CFrame.Position
    local direction = part.Position - origin
    local result = workspace:Raycast(origin, direction, RayParams)

    return result == nil or result.Instance:IsDescendantOf(part.Parent)
end

local function findBestTarget()
    local folder = workspace:FindFirstChild("TestTargets")

    if not folder then
        return nil
    end

    Camera = workspace.CurrentCamera or Camera

    if not Camera then
        return nil
    end

    local center = Camera.ViewportSize * 0.5
    local bestPart
    local bestDistance = State.FOVRadius

    for _, model in ipairs(folder:GetChildren()) do
        if model:IsA("Model") and isAlive(model) and not sameTeam(model) then
            local part = getTargetPart(model)

            if part then
                local screenPoint, onScreen =
                    Camera:WorldToViewportPoint(part.Position)

                if onScreen and screenPoint.Z > 0 then
                    local dx = screenPoint.X - center.X
                    local dy = screenPoint.Y - center.Y
                    local distance = math.sqrt(dx * dx + dy * dy)

                    if distance <= bestDistance and visible(part) then
                        bestDistance = distance
                        bestPart = part
                    end
                end
            end
        end
    end

    return bestPart
end

local function aimAt(part, dt)
    if not part then
        return
    end

    Camera = workspace.CurrentCamera or Camera

    if not Camera then
        return
    end

    local current = Camera.CFrame
    local desired = CFrame.lookAt(current.Position, part.Position)

    local smooth = clamp(State.Smoothness, 1, 20)
    local alpha = clamp((dt * 12) / smooth, 0.02, 1)

    Camera.CFrame = current:Lerp(desired, alpha)
end

--============================================================
-- ESP
--============================================================

local ESPObjects = {}

local function destroyESP(model)
    local data = ESPObjects[model]
    if not data then
        return
    end

    if data.highlight then
        data.highlight:Destroy()
    end

    if data.billboard then
        data.billboard:Destroy()
    end

    ESPObjects[model] = nil
end

local function ensureESP(model)
    if not State.ESP or not model:IsA("Model") then
        return
    end

    local head = model:FindFirstChild("Head")
        or model:FindFirstChild("HumanoidRootPart")

    if not head or not head:IsA("BasePart") then
        return
    end

    local data = ESPObjects[model]

    if not data then
        data = {}
        ESPObjects[model] = data
    end

    if State.ESPBoxes then
        if not data.highlight then
            local highlight = Instance.new("Highlight")
            highlight.Name = "VoidTargetHighlight"
            highlight.FillColor = Theme.Blue
            highlight.OutlineColor = Theme.BlueBright
            highlight.FillTransparency = 0.75
            highlight.OutlineTransparency = 0.1
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Parent = model
            data.highlight = highlight
        end
    elseif data.highlight then
        data.highlight:Destroy()
        data.highlight = nil
    end

    if State.ESPNames or State.ESPDistance or State.ESPHealth then
        if not data.billboard then
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "VoidESP"
            billboard.Size = UDim2.fromOffset(180, 48)
            billboard.StudsOffset = Vector3.new(0, 3, 0)
            billboard.AlwaysOnTop = true
            billboard.Parent = head
            data.billboard = billboard

            local label = Instance.new("TextLabel")
            label.Name = "Text"
            label.Size = UDim2.fromScale(1, 1)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.GothamBold
            label.TextColor3 = Theme.Text
            label.TextStrokeTransparency = 0.25
            label.TextSize = 12
            label.Parent = billboard
            data.label = label
        end

        local humanoid = model:FindFirstChildOfClass("Humanoid")
        local pieces = {}

        if State.ESPNames then
            table.insert(pieces, model.Name)
        end

        if State.ESPDistance and LocalPlayer.Character then
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local distance = math.floor((root.Position - head.Position).Magnitude)
                table.insert(pieces, distance .. " studs")
            end
        end

        if State.ESPHealth and humanoid then
            table.insert(
                pieces,
                math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
            )
        end

        data.label.Text = table.concat(pieces, "  •  ")
        data.billboard.Enabled = #pieces > 0
    elseif data.billboard then
        data.billboard:Destroy()
        data.billboard = nil
        data.label = nil
    end
end

local function clearESP()
    for model in pairs(ESPObjects) do
        destroyESP(model)
    end
end

--============================================================
-- PLAYER MOVEMENT
--============================================================

local function updateMovement()
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if not humanoid then
        return
    end

    humanoid.WalkSpeed = State.WalkSpeedEnabled and State.WalkSpeed or 16

    pcall(function()
        humanoid.UseJumpPower = true
        humanoid.JumpPower = State.JumpPowerEnabled and State.JumpPower or 50
    end)
end

--============================================================
-- INPUT
--============================================================

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then
        return
    end

    if input.KeyCode == Enum.KeyCode.RightShift then
        State.UIVisible = not State.UIVisible
        Main.Visible = State.UIVisible
        return
    end

    if input.KeyCode == Enum.KeyCode.F8 then
        for key, value in pairs(Defaults) do
            State[key] = value
        end

        AimKeyLabel.Text = "Aim Key: " .. State.AimKey.Name
        return
    end

    if input.KeyCode == State.AimKey then
        State.AimHeld = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == State.AimKey then
        State.AimHeld = false
    end
end)

--============================================================
-- WINDOW BUTTONS
--============================================================

local updateScale

local minimized = false
local normalSize = Main.Size

Minimize.MouseButton1Click:Connect(function()
    minimized = not minimized

    if minimized then
        Main.Size = UDim2.fromOffset(1040, 48)
        Minimize.Text = "+"
    else
        Main.Size = normalSize
        Minimize.Text = "—"
    end
    updateScale()
end)

Close.MouseButton1Click:Connect(function()
    State.UIVisible = false
    Main.Visible = false
end)

Close.MouseEnter:Connect(function()
    Close.TextColor3 = Theme.Red
end)

Close.MouseLeave:Connect(function()
    Close.TextColor3 = Theme.SubText
end)

--============================================================
-- OUTER QUICK-ACCESS UI
--============================================================

local Quick = Instance.new("Frame")
Quick.Name = "QuickAccess"
Quick.Size = UDim2.fromOffset(180, 42)
Quick.Position = UDim2.new(0.5, -90, 0, 8)
Quick.BackgroundTransparency = 1
Quick.ZIndex = 200
Quick.Parent = ScreenGui

local quickLayout = Instance.new("UIListLayout")
quickLayout.FillDirection = Enum.FillDirection.Horizontal
quickLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
quickLayout.Padding = UDim.new(0, 6)
quickLayout.Parent = Quick

local function QuickButton(text)
    local button = Instance.new("TextButton")
    button.Size = UDim2.fromOffset(86, 40)
    button.BackgroundColor3 = Color3.fromRGB(5, 12, 26)
    button.BackgroundTransparency = 0.08
    button.BorderSizePixel = 0
    button.Font = Enum.Font.GothamBold
    button.Text = text
    button.TextColor3 = Theme.Text
    button.TextSize = 17
    button.AutoButtonColor = false
    button.ZIndex = 201
    button.Parent = Quick

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = button

    return button
end

local CatalogButton = QuickButton("Catalog")
local StoresButton = QuickButton("Stores")

-- Left/right action stacks.
local LeftActions = Instance.new("Frame")
LeftActions.Size = UDim2.fromOffset(126, 120)
LeftActions.Position = UDim2.new(0, 24, 0.5, -60)
LeftActions.BackgroundTransparency = 1
LeftActions.ZIndex = 200
LeftActions.Parent = ScreenGui

local leftLayout = Instance.new("UIListLayout")
leftLayout.Padding = UDim.new(0, 8)
leftLayout.Parent = LeftActions

local CommunityButton = QuickButton("Community\nOutfits")
CommunityButton.Size = UDim2.fromOffset(126, 54)
CommunityButton.Parent = LeftActions

local LoaderButton = QuickButton("Outfit\nLoader")
LoaderButton.Size = UDim2.fromOffset(126, 54)
LoaderButton.Parent = LeftActions

local RightActions = Instance.new("Frame")
RightActions.Size = UDim2.fromOffset(126, 120)
RightActions.Position = UDim2.new(1, -150, 0.5, -60)
RightActions.BackgroundTransparency = 1
RightActions.ZIndex = 200
RightActions.Parent = ScreenGui

local rightLayout = Instance.new("UIListLayout")
rightLayout.Padding = UDim.new(0, 8)
rightLayout.Parent = RightActions

local SavedButton = QuickButton("Saved\nOutfits")
SavedButton.Size = UDim2.fromOffset(126, 54)
SavedButton.Parent = RightActions

local EmotesButton = QuickButton("Emotes")
EmotesButton.Size = UDim2.fromOffset(126, 54)
EmotesButton.Parent = RightActions

local function quickMessage(button, message)
    local oldText = button.Text
    button.Text = message
    task.delay(1.2, function()
        if button and button.Parent then
            button.Text = oldText
        end
    end)
end

CatalogButton.MouseButton1Click:Connect(function()
    quickMessage(CatalogButton, "Catalog ✓")
end)

StoresButton.MouseButton1Click:Connect(function()
    quickMessage(StoresButton, "Stores ✓")
end)

CommunityButton.MouseButton1Click:Connect(function()
    quickMessage(CommunityButton, "Outfits ✓")
end)

LoaderButton.MouseButton1Click:Connect(function()
    quickMessage(LoaderButton, "Loader ✓")
end)

SavedButton.MouseButton1Click:Connect(function()
    quickMessage(SavedButton, "Saved ✓")
end)

EmotesButton.MouseButton1Click:Connect(function()
    quickMessage(EmotesButton, "Emotes ✓")
end)

--============================================================
-- BOTTOM QUICK BUTTONS
--============================================================

local Bottom = Instance.new("Frame")
Bottom.Size = UDim2.fromOffset(300, 52)
Bottom.Position = UDim2.new(0.5, -150, 1, -62)
Bottom.BackgroundTransparency = 1
Bottom.ZIndex = 200
Bottom.Parent = ScreenGui

local bottomLayout = Instance.new("UIListLayout")
bottomLayout.FillDirection = Enum.FillDirection.Horizontal
bottomLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
bottomLayout.Padding = UDim.new(0, 7)
bottomLayout.Parent = Bottom

local bottomButtons = {
    "Player+",
    "Spawn",
    "Roblox",
    "Refresh",
}

for _, textValue in ipairs(bottomButtons) do
    local b = QuickButton(textValue)
    b.Size = UDim2.fromOffset(68, 48)
    b.Parent = Bottom

    b.MouseButton1Click:Connect(function()
        quickMessage(b, "✓")
    end)
end

--============================================================
-- RESPONSIVE SCALE
--============================================================

local UIScale = Instance.new("UIScale")
UIScale.Scale = 1
UIScale.Parent = Main

updateScale = function()
    local viewport = Camera and Camera.ViewportSize or Vector2.new(1280, 720)
    local scaleX = viewport.X / 1080
    local scaleY = viewport.Y / 720
    local scale = clamp(math.min(scaleX, scaleY), 0.62, 1)

    UIScale.Scale = scale

    -- UIScale scales from the GUI's top-left corner, so recenter
    -- the scaled window explicitly instead of leaving it offset.
    local baseHeight = minimized and 48 or 690

    Main.Position = UDim2.new(
        0.5,
        -(1040 * scale) / 2,
        0.5,
        -(baseHeight * scale) / 2
    )
end

if Camera then
    Camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
end

updateScale()

--============================================================
-- UI TRANSPARENCY
--============================================================

local function applyTransparency()
    local t = clamp(State.UITransparency, 0, 0.8)

    Main.BackgroundTransparency = t
    TopBar.BackgroundTransparency = t
end

--============================================================
-- RENDER LOOP
--============================================================

local elapsed = 0
local espElapsed = 0
local rainbowHue = 0

RunService:BindToRenderStep(
    "VoidAimbotStudioTest",
    Enum.RenderPriority.Camera.Value + 1,
    function(dt)

        updateFOV()
        applyTransparency()
        updateMovement()

        -- Safe Studio aim test.
        local shouldAim =
            State.Aimbot
            and State.UIVisible
            and (
                State.ActivationMode == "Always"
                or State.AimHeld
            )

        if shouldAim then
            local target = findBestTarget()
            aimAt(target, dt)
        end

        -- Environment controls.
        if State.FullBright then
            Lighting.Brightness = 3
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
        end

        if State.NoFog then
            Lighting.FogStart = 0
            Lighting.FogEnd = 100000
        end

        -- Rainbow UI accent.
        if State.RainbowUI then
            rainbowHue = (rainbowHue + dt * 0.12) % 1
            local color = Color3.fromHSV(rainbowHue, 0.8, 1)

            MainStroke.Color = color
            FOVStroke.Color = color

            for _, data in pairs(Tabs) do
                data.Accent.BackgroundColor3 = color
            end
        else
            MainStroke.Color = Theme.BlueDark
            FOVStroke.Color = Theme.BlueBright

            for _, data in pairs(Tabs) do
                data.Accent.BackgroundColor3 = Theme.Blue
            end
        end

        elapsed += dt
        espElapsed += dt

        if espElapsed >= 0.2 then
            espElapsed = 0

            if State.ESP then
                local folder = workspace:FindFirstChild("TestTargets")

                if folder then
                    local seen = {}

                    for _, model in ipairs(folder:GetChildren()) do
                        if model:IsA("Model") and isAlive(model) then
                            seen[model] = true
                            ensureESP(model)
                        end
                    end

                    for model in pairs(ESPObjects) do
                        if not seen[model] then
                            destroyESP(model)
                        end
                    end
                else
                    clearESP()
                end
            else
                clearESP()
            end
        end
    end
)

--============================================================
-- STARTUP
--============================================================

applyTransparency()
updateFOV()

print("============================================================")
print("Void Aimbot Script - Studio Test v3 loaded successfully.")
print("Create Workspace.TestTargets and place NPCs inside it.")
print("Q = Aim | RightShift = UI | F8 = Reset")
print("============================================================")

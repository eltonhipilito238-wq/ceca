--[[
============================================================
 VOID AIMBOT SCRIPT - ROBLOX STUDIO TEST BUILD v2 OPTIMIZED
============================================================
Place this as a LocalScript in:
StarterPlayer > StarterPlayerScripts

SAFE TEST TARGET SETUP:
Create a Folder named "TestTargets" under Workspace and put
NPC/dummy Models inside it. Each target should have a Humanoid
and Head/HumanoidRootPart.

This build recreates the supplied UI and keeps targeting
restricted to Workspace.TestTargets so it is suitable for
a private Roblox Studio test place.

HOTKEYS:
RightShift = Show / Hide UI
Q          = Aim key (default)
============================================================
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--==========================================================
-- STATE
--==========================================================

local State = {
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

--==========================================================
-- THEME
--==========================================================

local Theme = {
    Background = Color3.fromRGB(13, 14, 16),
    Panel = Color3.fromRGB(18, 19, 21),
    Panel2 = Color3.fromRGB(24, 25, 28),
    Panel3 = Color3.fromRGB(29, 30, 34),
    Text = Color3.fromRGB(235, 238, 245),
    SubText = Color3.fromRGB(170, 173, 182),
    Muted = Color3.fromRGB(110, 113, 122),
    Blue = Color3.fromRGB(35, 94, 235),
    BlueBright = Color3.fromRGB(55, 115, 255),
    BlueDark = Color3.fromRGB(24, 62, 150),
    Border = Color3.fromRGB(55, 57, 63),
    Off = Color3.fromRGB(38, 40, 44),
    Red = Color3.fromRGB(230, 65, 75),
}

--==========================================================
-- HELPERS
--==========================================================

local function clamp(v, a, b)
    return math.max(a, math.min(b, v))
end

local function tween(object, info, props)
    return TweenService:Create(object, info, props)
end

local Old = PlayerGui:FindFirstChild("VoidAimbotUI")
if Old then
    Old:Destroy()
end

--==========================================================
-- GUI
--==========================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VoidAimbotUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Name = "Window"
Main.Size = UDim2.fromOffset(745, 610)
Main.Position = UDim2.new(0.5, -372, 0.5, -305)
Main.BackgroundColor3 = Theme.Background
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 5)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Theme.BlueDark
MainStroke.Thickness = 2
MainStroke.Parent = Main

--==========================================================
-- TITLE BAR
--==========================================================

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 48)
TitleBar.BackgroundColor3 = Theme.Panel
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Main

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Position = UDim2.fromOffset(14, 0)
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Font = Enum.Font.Gotham
Title.Text = "Void Aimbot Script | Studio Test"
Title.TextColor3 = Theme.Text
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local Minimize = Instance.new("TextButton")
Minimize.BackgroundTransparency = 1
Minimize.Position = UDim2.new(1, -78, 0, 0)
Minimize.Size = UDim2.fromOffset(38, 48)
Minimize.Text = "—"
Minimize.TextColor3 = Theme.SubText
Minimize.TextSize = 18
Minimize.Font = Enum.Font.Gotham
Minimize.Parent = TitleBar

local Close = Instance.new("TextButton")
Close.BackgroundTransparency = 1
Close.Position = UDim2.new(1, -40, 0, 0)
Close.Size = UDim2.fromOffset(38, 48)
Close.Text = "×"
Close.TextColor3 = Theme.SubText
Close.TextSize = 23
Close.Font = Enum.Font.Gotham
Close.Parent = TitleBar

--==========================================================
-- DRAG
--==========================================================

local dragging = false
local dragStart
local startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)

TitleBar.InputEnded:Connect(function(input)
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
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end)

Minimize.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
    State.UIVisible = Main.Visible
end)

Close.MouseButton1Click:Connect(function()
    State.UIVisible = false
    Main.Visible = false
end)

--==========================================================
-- TAB BAR
--==========================================================

local TabBar = Instance.new("Frame")
TabBar.Position = UDim2.fromOffset(8, 50)
TabBar.Size = UDim2.new(1, -16, 0, 48)
TabBar.BackgroundTransparency = 1
TabBar.Parent = Main

local TabList = Instance.new("UIListLayout")
TabList.FillDirection = Enum.FillDirection.Horizontal
TabList.Padding = UDim.new(0, 5)
TabList.Parent = TabBar

local Pages = {}
local Tabs = {}
local CurrentTab = "Combat"

for _, name in ipairs({
    "Combat",
    "Visuals",
    "Player",
    "World",
    "Misc",
    "UI Settings",
}) do
    local page = Instance.new("ScrollingFrame")
    page.Name = name .. "Page"
    page.Position = UDim2.fromOffset(8, 98)
    page.Size = UDim2.new(1, -16, 1, -106)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Theme.Blue
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.CanvasSize = UDim2.new()
    page.Visible = name == CurrentTab
    page.Parent = Main

    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 10)
    pad.PaddingRight = UDim.new(0, 10)
    pad.PaddingTop = UDim.new(0, 4)
    pad.PaddingBottom = UDim.new(0, 10)
    pad.Parent = page

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.Parent = page

    Pages[name] = page

    local tab = Instance.new("TextButton")
    tab.Size = UDim2.fromOffset(name == "UI Settings" and 116 or 95, 40)
    tab.BackgroundColor3 = name == CurrentTab and Theme.Panel2 or Theme.Panel
    tab.BorderSizePixel = 0
    tab.Font = Enum.Font.Gotham
    tab.Text = name
    tab.TextColor3 = name == CurrentTab and Theme.Text or Theme.SubText
    tab.TextSize = 13
    tab.AutoButtonColor = false
    tab.Parent = TabBar

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 3)
    corner.Parent = tab

    local accent = Instance.new("Frame")
    accent.Position = UDim2.new(0, 0, 1, -3)
    accent.Size = UDim2.new(1, 0, 0, 3)
    accent.BackgroundColor3 = Theme.Blue
    accent.BorderSizePixel = 0
    accent.Visible = name == CurrentTab
    accent.Parent = tab

    Tabs[name] = {Button = tab, Accent = accent}

    tab.MouseButton1Click:Connect(function()
        CurrentTab = name

        for n, p in pairs(Pages) do
            p.Visible = n == name
        end

        for n, data in pairs(Tabs) do
            data.Button.BackgroundColor3 = n == name and Theme.Panel2 or Theme.Panel
            data.Button.TextColor3 = n == name and Theme.Text or Theme.SubText
            data.Accent.Visible = n == name
        end
    end)
end

--==========================================================
-- UI FACTORIES
--==========================================================

local function Section(parent, text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 28)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
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
    corner.CornerRadius = UDim.new(0, 3)
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
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -55, 1, 0)
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = Theme.Text
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local button = Instance.new("TextButton")
    button.Position = UDim2.new(1, -38, 0.5, -13)
    button.Size = UDim2.fromOffset(28, 28)
    button.BackgroundColor3 = default and Theme.Blue or Theme.Off
    button.BorderSizePixel = 0
    button.Text = default and "✓" or ""
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextSize = 17
    button.Font = Enum.Font.GothamBold
    button.AutoButtonColor = false
    button.Parent = row

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 2)
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
    frame.Size = UDim2.new(1, 0, 0, 62)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -100, 0, 22)
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = Theme.Text
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local valueLabel = Instance.new("TextLabel")
    valueLabel.BackgroundTransparency = 1
    valueLabel.Position = UDim2.new(1, -100, 0, 0)
    valueLabel.Size = UDim2.fromOffset(100, 22)
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextColor3 = Theme.SubText
    valueLabel.TextSize = 11
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = frame

    local bar = Instance.new("Frame")
    bar.Position = UDim2.fromOffset(0, 31)
    bar.Size = UDim2.new(1, 0, 0, 23)
    bar.BackgroundColor3 = Theme.Panel3
    bar.BorderSizePixel = 0
    bar.Parent = frame

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 2)
    barCorner.Parent = bar

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Theme.Blue
    fill.BorderSizePixel = 0
    fill.Parent = bar

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 2)
    fillCorner.Parent = fill

    local moving = false

    local function setFromX(x)
        local percent = clamp(
            (x - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1),
            0, 1
        )

        local value = min + ((max - min) * percent)
        value = math.floor(value + 0.5)

        fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
        valueLabel.Text = tostring(value) .. (suffix or "")
        callback(value)
    end

    valueLabel.Text = tostring(default) .. (suffix or "")

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            moving = true
            setFromX(input.Position.X)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if moving and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
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

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 22)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = Theme.Text
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local button = Instance.new("TextButton")
    button.Position = UDim2.fromOffset(0, 27)
    button.Size = UDim2.new(1, 0, 0, 31)
    button.BackgroundColor3 = Theme.Panel2
    button.BorderSizePixel = 0
    button.Font = Enum.Font.Gotham
    button.Text = "  " .. tostring(default) .. "                                      ▼"
    button.TextColor3 = Theme.Text
    button.TextSize = 12
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.AutoButtonColor = false
    button.Parent = frame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 2)
    corner.Parent = button

    local open = false
    local menu = Instance.new("Frame")
    menu.Position = UDim2.fromOffset(0, 59)
    menu.Size = UDim2.new(1, 0, 0, #options * 28)
    menu.BackgroundColor3 = Theme.Panel3
    menu.BorderSizePixel = 0
    menu.Visible = false
    menu.ZIndex = 50
    menu.Parent = frame

    for index, option in ipairs(options) do
        local choice = Instance.new("TextButton")
        choice.Position = UDim2.fromOffset(0, (index - 1) * 28)
        choice.Size = UDim2.new(1, 0, 0, 28)
        choice.BackgroundTransparency = 1
        choice.Font = Enum.Font.Gotham
        choice.Text = "  " .. tostring(option)
        choice.TextColor3 = Theme.Text
        choice.TextSize = 12
        choice.TextXAlignment = Enum.TextXAlignment.Left
        choice.ZIndex = 51
        choice.Parent = menu

        choice.MouseButton1Click:Connect(function()
            button.Text = "  " .. tostring(option) .. "                                      ▼"
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

local function Button(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 34)
    button.BackgroundColor3 = Theme.Panel2
    button.BorderSizePixel = 0
    button.Font = Enum.Font.Gotham
    button.Text = text
    button.TextColor3 = Theme.Text
    button.TextSize = 12
    button.AutoButtonColor = false
    button.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 2)
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

--==========================================================
-- COMBAT PAGE
--==========================================================

local Combat = Pages["Combat"]

Section(Combat, "Aimbot")
local AimPanel = Panel(Combat, 410)

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

Dropdown(AimPanel, "Target Part",
    {"Head", "HumanoidRootPart", "UpperTorso", "Torso"},
    State.TargetPart,
    function(v) State.TargetPart = v end
)

Slider(AimPanel, "FOV Radius", 25, 500, State.FOVRadius, function(v)
    State.FOVRadius = v
end, "/500")

Slider(AimPanel, "Smoothness", 1, 20, State.Smoothness, function(v)
    State.Smoothness = v
end, "/20")

Dropdown(AimPanel, "Activation Mode",
    {"Always", "Hold Key", "Toggle"},
    State.ActivationMode,
    function(v) State.ActivationMode = v end
)

Button(AimPanel, "Aim Key: " .. State.AimKey.Name, function(button)
    button.Text = "Aim Key: Press a key..."
    local connection
    connection = UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.UserInputType == Enum.UserInputType.Keyboard then
            State.AimKey = input.KeyCode
            button.Text = "Aim Key: " .. input.KeyCode.Name
            connection:Disconnect()
        end
    end)
end)

Section(Combat, "Triggerbot & Auto Clicker")
local TriggerPanel = Panel(Combat, 350)

Toggle(TriggerPanel, "Triggerbot Enabled", State.Triggerbot, function(v)
    State.Triggerbot = v
end)

Dropdown(TriggerPanel, "Trigger Mode",
    {"Always On", "Hold Key", "Toggle"},
    State.TriggerMode,
    function(v) State.TriggerMode = v end
)

Dropdown(TriggerPanel, "Trigger Key",
    {"Right Mouse Button", "Left Shift", "E", "Q"},
    "Right Mouse Button",
    function(v)
        if v == "Right Mouse Button" then
            State.TriggerKey = Enum.UserInputType.MouseButton2
        elseif v == "Left Shift" then
            State.TriggerKey = Enum.KeyCode.LeftShift
        elseif v == "E" then
            State.TriggerKey = Enum.KeyCode.E
        else
            State.TriggerKey = Enum.KeyCode.Q
        end
    end
)

Slider(TriggerPanel, "Trigger Delay (ms)", 10, 1000, State.TriggerDelay, function(v)
    State.TriggerDelay = v
end, "/1000")

Toggle(TriggerPanel, "Trigger Team Check", State.TriggerTeamCheck, function(v)
    State.TriggerTeamCheck = v
end)

Toggle(TriggerPanel, "Auto Clicker (Test Tap)", State.AutoClicker, function(v)
    State.AutoClicker = v
end)

Slider(TriggerPanel, "Click Per Second (CPS)", 1, 30, State.ClickPerSecond, function(v)
    State.ClickPerSecond = v
end, "/30")

--==========================================================
-- FOV PAGE AREA ON COMBAT
--==========================================================

Section(Combat, "FOV Circle Settings")
local FOVPanel = Panel(Combat, 230)

Toggle(FOVPanel, "Show FOV Circle", State.ShowFOV, function(v)
    State.ShowFOV = v
end)

Toggle(FOVPanel, "Filled FOV Circle", State.FilledFOV, function(v)
    State.FilledFOV = v
end)

Slider(FOVPanel, "Fill Transparency", 0, 100, 100, function(v)
    State.FillTransparency = v / 100
end, "/1")

Button(FOVPanel, "Reset Combat Settings", function()
    State.Aimbot = true
    State.TeamCheck = true
    State.VisibilityCheck = true
    State.WallCheck = true
    State.TargetPart = "Head"
    State.FOVRadius = 150
    State.Smoothness = 5
    State.ActivationMode = "Always"
end)

--==========================================================
-- VISUALS
--==========================================================

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

Button(ESPPanel, "Refresh ESP", function()
    -- ESP is rebuilt automatically in the render loop.
end)

Section(Visuals, "Test Hitboxes")
local HitPanel = Panel(Visuals, 140)

Slider(HitPanel, "Test Hitbox Size", 2, 30, 10, function(v)
    for _, target in ipairs(workspace:FindFirstChild("TestTargets") and workspace.TestTargets:GetChildren() or {}) do
        local root = target:FindFirstChild("HumanoidRootPart")
        if root then
            root.Size = Vector3.new(v, v, v)
        end
    end
end)

Toggle(HitPanel, "Show Test Hitboxes", false, function(v)
    for _, target in ipairs(workspace:FindFirstChild("TestTargets") and workspace.TestTargets:GetChildren() or {}) do
        local root = target:FindFirstChild("HumanoidRootPart")
        if root then
            root.Transparency = v and 0.45 or 0
        end
    end
end)

--==========================================================
-- PLAYER
--==========================================================

local PlayerPage = Pages["Player"]

Section(PlayerPage, "Local Character")
local PlayerPanel = Panel(PlayerPage, 260)

Toggle(PlayerPanel, "Custom WalkSpeed", State.WalkSpeedEnabled, function(v)
    State.WalkSpeedEnabled = v
end)

Slider(PlayerPanel, "WalkSpeed", 8, 100, State.WalkSpeed, function(v)
    State.WalkSpeed = v
end)

Toggle(PlayerPanel, "Custom JumpPower", State.JumpPowerEnabled, function(v)
    State.JumpPowerEnabled = v
end)

Slider(PlayerPanel, "JumpPower", 20, 150, State.JumpPower, function(v)
    State.JumpPower = v
end)

Button(PlayerPanel, "Reset Character Movement", function()
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = 16
        humanoid.JumpPower = 50
    end
end)

--==========================================================
-- WORLD
--==========================================================

local World = Pages["World"]

Section(World, "World Test Settings")
local WorldPanel = Panel(World, 220)

Toggle(WorldPanel, "Fullbright (Local Test)", State.FullBright, function(v)
    State.FullBright = v
end)

Toggle(WorldPanel, "No Fog (Local Test)", State.NoFog, function(v)
    State.NoFog = v
end)

Button(WorldPanel, "Restore Lighting", function()
    local lighting = game:GetService("Lighting")
    lighting.Brightness = 2
    lighting.FogEnd = 100000
    lighting.FogStart = 0
end)

Button(WorldPanel, "Print Test Target Count", function()
    local folder = workspace:FindFirstChild("TestTargets")
    local count = folder and #folder:GetChildren() or 0
    print("[VoidHub] TestTargets:", count)
end)

--==========================================================
-- MISC
--==========================================================

local Misc = Pages["Misc"]

Section(Misc, "Utilities")
local MiscPanel = Panel(Misc, 250)

Button(MiscPanel, "Rebuild Test Target Folder", function()
    local folder = workspace:FindFirstChild("TestTargets")
    if not folder then
        folder = Instance.new("Folder")
        folder.Name = "TestTargets"
        folder.Parent = workspace
    end
    print("[VoidHub] Workspace.TestTargets is ready.")
end)

Button(MiscPanel, "Print Current Settings", function()
    print("[VoidHub] FOV:", State.FOVRadius,
        "Smoothness:", State.Smoothness,
        "Target:", State.TargetPart)
end)

Button(MiscPanel, "Reset All Settings", function()
    for key, value in pairs({
        Aimbot=true, TeamCheck=true, VisibilityCheck=true, WallCheck=true,
        TargetPart="Head", FOVRadius=150, Smoothness=5,
        ActivationMode="Always", Triggerbot=false, TriggerDelay=50,
        TriggerTeamCheck=false, AutoClicker=false, ClickPerSecond=10,
        ShowFOV=false, FilledFOV=false, FillTransparency=1,
        ESP=false, ESPNames=true, ESPDistance=true, ESPHealth=false,
        ESPBoxes=false, WalkSpeedEnabled=false, WalkSpeed=16,
        JumpPowerEnabled=false, JumpPower=50, FullBright=false, NoFog=false,
    }) do
        State[key] = value
    end
end)

--==========================================================
-- UI SETTINGS
--==========================================================

local UIPage = Pages["UI Settings"]

Section(UIPage, "Interface")
local function applyUITransparency()
    local transparency = clamp(State.UITransparency, 0, 1)

    for _, object in ipairs(Main:GetDescendants()) do
        if object:IsA("TextLabel") or object:IsA("TextButton") then
            object.TextTransparency = transparency
        end
    end
end

local UIPanel = Panel(UIPage, 240)

Toggle(UIPanel, "Rainbow UI", State.RainbowUI, function(v)
    State.RainbowUI = v
end)

Slider(UIPanel, "UI Transparency", 0, 80, 0, function(v)
    State.UITransparency = v / 100
    applyUITransparency()
end, "%")

Button(UIPanel, "Reset Window Position", function()
    Main.Position = UDim2.new(0.5, -372, 0.5, -305)
end)

Button(UIPanel, "Hide UI", function()
    State.UIVisible = false
    Main.Visible = false
end)

Button(UIPanel, "Show UI", function()
    State.UIVisible = true
    Main.Visible = true
end)

--==========================================================
-- FOV VISUAL
--==========================================================

local FOV = Instance.new("Frame")
FOV.Name = "FOVCircle"
FOV.AnchorPoint = Vector2.new(0.5, 0.5)
FOV.BackgroundColor3 = Theme.Blue
FOV.BackgroundTransparency = 1
FOV.BorderSizePixel = 0
FOV.ZIndex = 1
FOV.Parent = ScreenGui

local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(1, 0)
FOVCorner.Parent = FOV

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Color = Theme.BlueBright
FOVStroke.Thickness = 1
FOVStroke.Parent = FOV

--==========================================================
-- TARGET HELPERS
--==========================================================

local function getTestFolder()
    return workspace:FindFirstChild("TestTargets")
end

local function isValidTarget(model)
    if not model or not model:IsA("Model") then
        return false
    end

    if LocalPlayer.Character and model == LocalPlayer.Character then
        return false
    end

    local humanoid = model:FindFirstChildOfClass("Humanoid")
    local root = model:FindFirstChild("HumanoidRootPart")

    return humanoid ~= nil and humanoid.Health > 0 and root ~= nil
end

local function getTargetPart(model)
    return model:FindFirstChild(State.TargetPart)
        or model:FindFirstChild("Head")
        or model:FindFirstChild("HumanoidRootPart")
end

local RayParams = RaycastParams.new()
RayParams.FilterType = Enum.RaycastFilterType.Exclude

local function refreshRaycastFilter()
    local character = LocalPlayer.Character
    RayParams.FilterDescendantsInstances = character and {character} or {}
end

refreshRaycastFilter()

LocalPlayer.CharacterAdded:Connect(function()
    task.defer(refreshRaycastFilter)
end)

local function hasLineOfSight(part)
    if not State.VisibilityCheck and not State.WallCheck then
        return true
    end

    local camera = workspace.CurrentCamera
    if not camera or not part or not part.Parent then
        return false
    end

    local origin = camera.CFrame.Position
    local direction = part.Position - origin
    local result = workspace:Raycast(origin, direction, RayParams)

    return result == nil or result.Instance:IsDescendantOf(part.Parent)
end

local function getClosestTarget()
    local folder = getTestFolder()
    if not folder then return nil end

    local camera = workspace.CurrentCamera
    local center = Vector2.new(
        camera.ViewportSize.X / 2,
        camera.ViewportSize.Y / 2
    )

    local bestPart = nil
    local bestDistance = State.FOVRadius

    for _, model in ipairs(folder:GetChildren()) do
        if isValidTarget(model) then
            local part = getTargetPart(model)

            if part then
                local screenPos, onScreen =
                    camera:WorldToViewportPoint(part.Position)

                if onScreen then
                    local distance = (
                        Vector2.new(screenPos.X, screenPos.Y) - center
                    ).Magnitude

                    if distance <= bestDistance then
                        if hasLineOfSight(part) then
                            bestDistance = distance
                            bestPart = part
                        end
                    end
                end
            end
        end
    end

    return bestPart
end

--==========================================================
-- ESP
--==========================================================

local ESPObjects = {}

local function destroyESP(model)
    local data = ESPObjects[model]
    if not data then return end

    for _, object in ipairs(data) do
        if object and object.Parent then
            object:Destroy()
        end
    end

    ESPObjects[model] = nil
end

local function createESP(model)
    if ESPObjects[model] or not isValidTarget(model) then
        return
    end

    local root = model:FindFirstChild("HumanoidRootPart")
    local head = model:FindFirstChild("Head") or root
    if not head then return end

    local objects = {}

    local highlight = Instance.new("Highlight")
    highlight.Adornee = model
    highlight.FillColor = Theme.Blue
    highlight.FillTransparency = 0.82
    highlight.OutlineColor = Theme.BlueBright
    highlight.OutlineTransparency = 0.15
    highlight.Enabled = false
    highlight.Parent = ScreenGui
    table.insert(objects, highlight)

    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = head
    billboard.Size = UDim2.fromOffset(190, 45)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Enabled = false
    billboard.Parent = ScreenGui
    table.insert(objects, billboard)

    local text = Instance.new("TextLabel")
    text.Size = UDim2.fromScale(1, 1)
    text.BackgroundTransparency = 1
    text.Font = Enum.Font.GothamBold
    text.TextColor3 = Theme.Text
    text.TextStrokeTransparency = 0.5
    text.TextSize = 12
    text.Parent = billboard

    ESPObjects[model] = objects
    ESPObjects[model].Text = text
    ESPObjects[model].Highlight = highlight
    ESPObjects[model].Billboard = billboard
end

local function updateESP()
    local folder = getTestFolder()
    if not folder then return end

    for _, model in ipairs(folder:GetChildren()) do
        createESP(model)
    end

    for model, data in pairs(ESPObjects) do
        if not model.Parent or not isValidTarget(model) then
            destroyESP(model)
        else
            data.Highlight.Enabled = State.ESP
            data.Billboard.Enabled = State.ESP

            local root = model:FindFirstChild("HumanoidRootPart")
            local myRoot = LocalPlayer.Character
                and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

            local parts = {}

            if State.ESPNames then
                table.insert(parts, model.Name)
            end

            if State.ESPDistance and root and myRoot then
                table.insert(parts, string.format(
                    "%dm",
                    math.floor((root.Position - myRoot.Position).Magnitude)
                ))
            end

            if State.ESPHealth then
                local humanoid = model:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    table.insert(parts, string.format(
                        "%d/%d HP",
                        math.floor(humanoid.Health),
                        math.floor(humanoid.MaxHealth)
                    ))
                end
            end

            data.Text.Text = table.concat(parts, "  |  ")
        end
    end
end

--==========================================================
-- RENDER LOOP
--==========================================================

local aimToggle = false
local triggerClock = 0
local clickClock = 0

local function activationActive()
    if State.ActivationMode == "Always" then
        return true
    elseif State.ActivationMode == "Hold Key" then
        return State.AimHeld
    elseif State.ActivationMode == "Toggle" then
        return aimToggle
    end
    return false
end

RunService:BindToRenderStep(
    "VoidAimbotStudioTest",
    Enum.RenderPriority.Camera.Value + 1,
    function(deltaTime)

        local camera = workspace.CurrentCamera

        FOV.Position = UDim2.fromOffset(
            camera.ViewportSize.X / 2,
            camera.ViewportSize.Y / 2
        )

        FOV.Size = UDim2.fromOffset(
            State.FOVRadius * 2,
            State.FOVRadius * 2
        )

        FOV.Visible = State.ShowFOV and State.UIVisible

        FOV.BackgroundTransparency =
            State.FilledFOV and State.FillTransparency or 1

        -- Local movement test
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            if State.WalkSpeedEnabled then
                humanoid.WalkSpeed = State.WalkSpeed
            else
                humanoid.WalkSpeed = 16
            end

            if State.JumpPowerEnabled then
                humanoid.UseJumpPower = true
                humanoid.JumpPower = State.JumpPower
            else
                humanoid.UseJumpPower = true
                humanoid.JumpPower = 50
            end
        end

        -- Local lighting test
        if State.FullBright then
            Lighting.Brightness = 3
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
        end

        if State.NoFog then
            Lighting.FogEnd = 100000
            Lighting.FogStart = 0
        end

        -- Safe NPC-only camera assist
        if State.Aimbot and activationActive() then
            local target = getClosestTarget()

            if target then
                local desired = CFrame.lookAt(
                    camera.CFrame.Position,
                    target.Position
                )

                local alpha = clamp(
                    State.Smoothness * deltaTime,
                    0,
                    1
                )

                camera.CFrame = camera.CFrame:Lerp(desired, alpha)
            end
        end

        -- Triggerbot/auto-clicker indicator only:
        -- no simulated mouse input is sent outside the Studio test UI.
        if State.Triggerbot then
            triggerClock += deltaTime
            if triggerClock >= State.TriggerDelay / 1000 then
                triggerClock = 0
                local target = getClosestTarget()
                if target then
                    print("[VoidHub Test] Triggerbot target:", target.Parent.Name)
                end
            end
        end

        if State.AutoClicker then
            clickClock += deltaTime
            if clickClock >= 1 / math.max(State.ClickPerSecond, 1) then
                clickClock = 0
                print("[VoidHub Test] Auto-click tick")
            end
        end

        -- UI transparency is updated only when the setting changes.
        -- This avoids walking every GUI object every render frame.

        if State.RainbowUI then
            local hue = (os.clock() * 0.15) % 1
            MainStroke.Color = Color3.fromHSV(hue, 0.8, 1)
        else
            MainStroke.Color = Theme.BlueDark
        end
    end
)

--==========================================================
-- INPUT
--==========================================================

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end

    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == Enum.KeyCode.RightShift then
            State.UIVisible = not State.UIVisible
            Main.Visible = State.UIVisible
        end

        if input.KeyCode == State.AimKey then
            State.AimHeld = true

            if State.ActivationMode == "Toggle" then
                aimToggle = not aimToggle
            end
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard
        and input.KeyCode == State.AimKey then
        State.AimHeld = false
    end
end)

--==========================================================
-- FOLDER EVENTS
--==========================================================

local function connectTargetFolder(folder)
    folder.ChildAdded:Connect(function()
        task.wait()
        updateESP()
    end)

    folder.ChildRemoved:Connect(function(child)
        destroyESP(child)
    end)
end

local targetFolder = workspace:FindFirstChild("TestTargets")

if targetFolder then
    connectTargetFolder(targetFolder)
end

workspace.ChildAdded:Connect(function(child)
    if child.Name == "TestTargets" and child:IsA("Folder") then
        connectTargetFolder(child)
    end
end)

--==========================================================
-- START
--==========================================================

applyUITransparency()

task.spawn(function()
    while ScreenGui.Parent do
        updateESP()
        task.wait(0.25)
    end
end)

--==========================================================
-- CLEANUP
--==========================================================
-- Re-executing the LocalScript will remove the previous UI above.
-- BindToRenderStep is explicitly unbound here if this script is
-- stopped/reloaded by Studio tooling.
local function cleanup()
    pcall(function()
        RunService:UnbindFromRenderStep("VoidAimbotStudioTest")
    end)

    if ScreenGui and ScreenGui.Parent then
        ScreenGui:Destroy()
    end
end

print("==================================================")
print("Void Aimbot Script - Studio Test Build v2 Optimized loaded")
print("Targets: Workspace.TestTargets")
print("RightShift: Toggle UI")
print("Aim key:", State.AimKey.Name)
--==========================================================
-- CLEANUP
--==========================================================
-- Re-executing the LocalScript will remove the previous UI above.
-- BindToRenderStep is explicitly unbound here if this script is
-- stopped/reloaded by Studio tooling.
local function cleanup()
    pcall(function()
        RunService:UnbindFromRenderStep("VoidAimbotStudioTest")
    end)

    if ScreenGui and ScreenGui.Parent then
        ScreenGui:Destroy()
    end
end

print("==================================================")

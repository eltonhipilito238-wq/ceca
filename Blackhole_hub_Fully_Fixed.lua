--[[
    BLACKHOLE.HUB - BLACK THEME
    BLACKHOLE.HUB
    ROBLOX STUDIO PRIVATE TEST BUILD
    LocalScript - place in StarterPlayer > StarterPlayerScripts

    Features:
    • Combat / Aimbot
    • FOV circle with live radius + color
    • Target-part / camera-target selection
    • Team check
    • Visibility / raycast check
    • Hold or Always activation
    • Q default aim key
    • Visuals / Player / World / Misc / UI Settings pages
    • Fixed dropdowns that render above the scrolling content
    • Mobile-friendly buttons
    • No external libraries / no executor-only APIs
]]

--// SERVICES
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

--// CLEAN OLD BUILD
local old = PlayerGui:FindFirstChild("BlackholeHubUI")
if old then
    old:Destroy()
end

--// STATE
local State = {
    Aimbot = true,
    TeamCheck = true,
    VisibilityCheck = true,
    WallCheck = true,
    TargetPart = "Head",
    FOVRadius = 200,
    Smoothness = 5,
    ActivationMode = "Always",
    AimKey = Enum.KeyCode.Q,

    ShowFOV = true,
    FilledFOV = false,
    FOVTransparency = 0.9,
    CircleColor = "Red",

    Triggerbot = false,
    AutoClicker = false,

    PlayerESP = false,
    Crosshair = false,
    Fullbright = false,

    UIVisible = true,
}

local CircleColors = {
    Red = Color3.fromRGB(255, 70, 70),
    Blue = Color3.fromRGB(70, 140, 255),
    Cyan = Color3.fromRGB(40, 220, 255),
    Green = Color3.fromRGB(70, 230, 110),
    Yellow = Color3.fromRGB(255, 220, 70),
    White = Color3.fromRGB(245, 245, 245),
    Purple = Color3.fromRGB(170, 100, 255),
}

--// SAVE CHANGES
-- LocalScripts cannot write Roblox DataStores directly. This save system keeps
-- the player's configuration for the current play session and respawns.
local SavedState = nil
local SaveStatusLabel = nil

local function cloneState()
    local copy = {}
    for key, value in pairs(State) do
        copy[key] = value
    end
    return copy
end

local function saveChanges()
    SavedState = cloneState()
    if SaveStatusLabel then
        SaveStatusLabel.Text = "Saved ✓"
        task.delay(2, function()
            if SaveStatusLabel and SaveStatusLabel.Parent then
                SaveStatusLabel.Text = "Changes are saved for this play session."
            end
        end)
    end
end

--// THEME
local Theme = {
    -- Blackhole.hub black theme
    Background = Color3.fromRGB(3, 3, 4),
    Panel = Color3.fromRGB(8, 8, 10),
    Panel2 = Color3.fromRGB(14, 14, 17),
    Panel3 = Color3.fromRGB(20, 20, 24),
    Text = Color3.fromRGB(245, 245, 245),
    SubText = Color3.fromRGB(150, 150, 155),
    Blue = Color3.fromRGB(235, 235, 235),
    Blue2 = Color3.fromRGB(55, 55, 60),
    Border = Color3.fromRGB(75, 75, 82),
    Off = Color3.fromRGB(40, 40, 44),
}

--// HELPERS
local function new(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        obj[k] = v
    end
    if parent then
        obj.Parent = parent
    end
    return obj
end

local function corner(obj, radius)
    return new("UICorner", {CornerRadius = UDim.new(0, radius or 6)}, obj)
end

local function stroke(obj, color, thickness)
    return new("UIStroke", {
        Color = color or Theme.Border,
        Thickness = thickness or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, obj)
end

local function clamp(v, a, b)
    return math.max(a, math.min(b, v))
end

--// SCREEN GUI
local Gui = new("ScreenGui", {
    Name = "BlackholeHubUI",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Global,
    DisplayOrder = 100,
}, PlayerGui)

--// FOV CIRCLE - ROBLOX STUDIO SAFE (NO DRAWING API)
local FOVCircle = new("Frame", {
    Name = "FOVCircle",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(State.FOVRadius * 2, State.FOVRadius * 2),
    BackgroundColor3 = CircleColors[State.CircleColor],
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Visible = State.ShowFOV,
    ZIndex = 1,
}, Gui)
corner(FOVCircle, 9999)
local FOVStroke = stroke(FOVCircle, CircleColors[State.CircleColor], 2)

local FOVFill = new("Frame", {
    Name = "Fill",
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = CircleColors[State.CircleColor],
    BackgroundTransparency = State.FilledFOV and State.FOVTransparency or 1,
    BorderSizePixel = 0,
    ZIndex = 0,
}, FOVCircle)
corner(FOVFill, 9999)

local Crosshair = new("Frame", {
    Name = "Crosshair",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(4, 4),
    BackgroundColor3 = Color3.new(1,1,1),
    BorderSizePixel = 0,
    Visible = false,
    ZIndex = 10,
}, Gui)
corner(Crosshair, 99)

local function updateCircle()
    FOVCircle.Size = UDim2.fromOffset(State.FOVRadius * 2, State.FOVRadius * 2)
    local c = CircleColors[State.CircleColor] or CircleColors.Red
    FOVStroke.Color = c
    FOVFill.BackgroundColor3 = c
    FOVFill.BackgroundTransparency = State.FilledFOV and State.FOVTransparency or 1
    FOVCircle.Visible = State.ShowFOV
end

--// MAIN WINDOW
local Main = new("Frame", {
    Name = "Main",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(820, 590),
    BackgroundColor3 = Theme.Background,
    BorderSizePixel = 0,
    ClipsDescendants = false,
    ZIndex = 20,
}, Gui)
corner(Main, 8)
stroke(Main, Theme.Border, 1)

local Top = new("Frame", {
    Size = UDim2.new(1, 0, 0, 46),
    BackgroundColor3 = Theme.Panel,
    BorderSizePixel = 0,
    ZIndex = 21,
}, Main)
corner(Top, 8)

local Title = new("TextLabel", {
    Position = UDim2.fromOffset(14, 0),
    Size = UDim2.fromOffset(360, 46),
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamMedium,
    Text = "Blackhole.hub",
    TextColor3 = Theme.Blue,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 22,
}, Top)

local Close = new("TextButton", {
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -8, 0.5, 0),
    Size = UDim2.fromOffset(30, 30),
    BackgroundColor3 = Theme.Panel2,
    Text = "×",
    TextColor3 = Theme.Text,
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    AutoButtonColor = false,
    ZIndex = 22,
}, Top)
corner(Close, 5)

Close.MouseButton1Click:Connect(function()
    State.UIVisible = false
    Main.Visible = false
end)

--// DRAG
do
    local dragging = false
    local dragStart
    local startPos

    Top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)

    Top.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement
        and input.UserInputType ~= Enum.UserInputType.Touch then return end

        local delta = input.Position - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end)
end

--// TABS
local TabBar = new("Frame", {
    Position = UDim2.fromOffset(8, 53),
    Size = UDim2.new(1, -16, 0, 40),
    BackgroundTransparency = 1,
    ZIndex = 22,
}, Main)

local TabNames = {"Combat", "Visuals", "Player", "World", "Misc", "UI Settings"}
local Pages = {}
local TabButtons = {}
local CurrentTab = "Combat"

local function makeTab(name, index)
    local b = new("TextButton", {
        Position = UDim2.new((index-1)/6, 2, 0, 0),
        Size = UDim2.new(1/6, -4, 1, 0),
        BackgroundColor3 = name == CurrentTab and Theme.Blue2 or Theme.Panel2,
        BorderSizePixel = 0,
        Text = name,
        TextColor3 = Theme.Text,
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        AutoButtonColor = false,
        ZIndex = 23,
    }, TabBar)
    corner(b, 5)
    stroke(b, Theme.Border, 1)
    TabButtons[name] = b
    return b
end

for i, name in ipairs(TabNames) do
    makeTab(name, i)
end

local Content = new("Frame", {
    Position = UDim2.fromOffset(8, 100),
    Size = UDim2.new(1, -16, 1, -108),
    BackgroundTransparency = 1,
    ClipsDescendants = false,
    ZIndex = 21,
}, Main)

local function makePage(name)
    local p = new("ScrollingFrame", {
        Name = name .. "Page",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Theme.Blue,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(),
        Visible = name == CurrentTab,
        ClipsDescendants = true,
        ZIndex = 21,
    }, Content)

    new("UIPadding", {
        PaddingLeft = UDim.new(0, 4),
        PaddingRight = UDim.new(0, 4),
        PaddingTop = UDim.new(0, 4),
        PaddingBottom = UDim.new(0, 12),
    }, p)

    new("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, p)

    Pages[name] = p
    return p
end

for _, name in ipairs(TabNames) do
    makePage(name)
end

local function switchTab(name)
    CurrentTab = name
    for n, p in pairs(Pages) do
        p.Visible = n == name
    end
    for n, b in pairs(TabButtons) do
        b.BackgroundColor3 = n == name and Theme.Blue2 or Theme.Panel2
    end
end

for name, b in pairs(TabButtons) do
    b.MouseButton1Click:Connect(function()
        switchTab(name)
    end)
end

--// PANEL HELPERS
local function section(parent, title)
    local p = new("Frame", {
        Size = UDim2.new(1, -4, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.Panel,
        BorderSizePixel = 0,
        LayoutOrder = 1,
        ZIndex = 22,
    }, parent)
    corner(p, 6)
    stroke(p, Theme.Border, 1)

    new("UIPadding", {
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        PaddingTop = UDim.new(0, 9),
        PaddingBottom = UDim.new(0, 10),
    }, p)

    new("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, p)

    new("TextLabel", {
        Size = UDim2.new(1, 0, 0, 24),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Theme.Text,
        Font = Enum.Font.GothamMedium,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 0,
        ZIndex = 23,
    }, p)

    return p
end

local function row(parent, text)
    local r = new("Frame", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundTransparency = 1,
        ZIndex = 23,
    }, parent)

    new("TextLabel", {
        Size = UDim2.new(1, -60, 1, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Theme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 24,
    }, r)

    return r
end

local function toggle(parent, text, key)
    local r = row(parent, text)

    local b = new("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.fromOffset(42, 20),
        BackgroundColor3 = State[key] and Theme.Blue or Theme.Off,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 25,
    }, r)
    corner(b, 99)

    local knob = new("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = State[key] and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
        Size = UDim2.fromOffset(14, 14),
        BackgroundColor3 = Color3.fromRGB(245,245,245),
        BorderSizePixel = 0,
        ZIndex = 26,
    }, b)
    corner(knob, 99)

    b.MouseButton1Click:Connect(function()
        State[key] = not State[key]
        b.BackgroundColor3 = State[key] and Theme.Blue or Theme.Off
        TweenService:Create(knob, TweenInfo.new(0.12), {
            Position = State[key]
                and UDim2.new(1, -18, 0.5, 0)
                or UDim2.new(0, 3, 0.5, 0)
        }):Play()

        if key == "ShowFOV" or key == "FilledFOV" then
            updateCircle()
        end
    end)
end

local function slider(parent, text, key, min, max, suffix)
    local f = new("Frame", {
        Size = UDim2.new(1, 0, 0, 56),
        BackgroundTransparency = 1,
        ZIndex = 23,
    }, parent)

    local label = new("TextLabel", {
        Size = UDim2.new(1, -80, 0, 22),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Theme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 24,
    }, f)

    local value = new("TextLabel", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.fromOffset(90, 22),
        BackgroundTransparency = 1,
        Text = tostring(State[key]) .. (suffix or ""),
        TextColor3 = Theme.SubText,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Right,
        ZIndex = 24,
    }, f)

    local bar = new("TextButton", {
        Position = UDim2.fromOffset(0, 30),
        Size = UDim2.new(1, 0, 0, 6),
        BackgroundColor3 = Theme.Off,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 24,
    }, f)
    corner(bar, 99)

    local fill = new("Frame", {
        Size = UDim2.new((State[key]-min)/(max-min), 0, 1, 0),
        BackgroundColor3 = Theme.Blue,
        BorderSizePixel = 0,
        ZIndex = 25,
    }, bar)
    corner(fill, 99)

    local dragging = false

    local function setFromX(x)
        local pct = clamp((x - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), 0, 1)
        local v = math.floor(min + (max-min)*pct + 0.5)
        State[key] = v
        value.Text = tostring(v) .. (suffix or "")
        fill.Size = UDim2.new((v-min)/(max-min), 0, 1, 0)

        if key == "FOVRadius" then updateCircle() end
    end

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            setFromX(input.Position.X)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            setFromX(input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

--// DROPDOWN OVERLAY - FIXES CLIPPING / WRONG Z-ORDER
local DropOverlay = new("Frame", {
    Name = "DropdownOverlay",
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Visible = false,
    ZIndex = 200,
}, Gui)

local activeDrop = nil

local function closeDropdown()
    if activeDrop then
        activeDrop.Visible = false
        activeDrop = nil
    end
    DropOverlay.Visible = false
end

local function dropdown(parent, text, key, options)
    local f = new("Frame", {
        Size = UDim2.new(1, 0, 0, 56),
        BackgroundTransparency = 1,
        ZIndex = 23,
    }, parent)

    new("TextLabel", {
        Size = UDim2.new(1, 0, 0, 21),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Theme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 24,
    }, f)

    local button = new("TextButton", {
        Position = UDim2.fromOffset(0, 24),
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Theme.Panel2,
        Text = tostring(State[key]),
        TextColor3 = Theme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false,
        ZIndex = 25,
    }, f)
    corner(button, 4)
    stroke(button, Theme.Border, 1)

    local list = new("Frame", {
        Size = UDim2.fromOffset(1, 1),
        BackgroundColor3 = Theme.Panel3,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 201,
    }, DropOverlay)
    corner(list, 4)
    stroke(list, Theme.Border, 1)

    local layout = new("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, list)

    for _, option in ipairs(options) do
        local opt = new("TextButton", {
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundTransparency = 1,
            Text = "  " .. tostring(option),
            TextColor3 = Theme.Text,
            Font = Enum.Font.Gotham,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false,
            ZIndex = 202,
        }, list)

        opt.MouseEnter:Connect(function()
            opt.BackgroundTransparency = 0
            opt.BackgroundColor3 = Theme.Blue2
        end)
        opt.MouseLeave:Connect(function()
            opt.BackgroundTransparency = 1
        end)

        opt.MouseButton1Click:Connect(function()
            State[key] = option
            button.Text = tostring(option)
            closeDropdown()

            if key == "CircleColor" then
                updateCircle()
            end
        end)
    end

    button.MouseButton1Click:Connect(function()
        if activeDrop == list then
            closeDropdown()
            return
        end

        closeDropdown()
        activeDrop = list
        DropOverlay.Visible = true

        local pos = button.AbsolutePosition
        local size = button.AbsoluteSize
        list.Position = UDim2.fromOffset(pos.X, pos.Y + size.Y + 2)
        list.Size = UDim2.fromOffset(size.X, #options * 30)
        list.Visible = true
    end)
end

--// COMBAT PAGE
do
    local p = Pages.Combat

    local left = section(p, "Aimbot")
    toggle(left, "Aimbot Enabled", "Aimbot")
    toggle(left, "Team Check", "TeamCheck")
    toggle(left, "Visibility Check", "VisibilityCheck")
    toggle(left, "Wall Check (Raycast)", "WallCheck")
    dropdown(left, "Target Part", "TargetPart", {"Head","HumanoidRootPart","UpperTorso","LowerTorso"})
    slider(left, "FOV Radius", "FOVRadius", 50, 500, " px")
    slider(left, "Smoothness", "Smoothness", 1, 20, "")
    dropdown(left, "Activation Mode", "ActivationMode", {"Always","Hold Key"})
    dropdown(left, "Aim Key", "AimKey", {Enum.KeyCode.Q,Enum.KeyCode.E,Enum.KeyCode.LeftShift,Enum.KeyCode.RightMouseButton})

    local fov = section(p, "FOV Circle Settings")
    toggle(fov, "Show FOV Circle", "ShowFOV")
    toggle(fov, "Filled FOV Circle", "FilledFOV")
    dropdown(fov, "Circle Color", "CircleColor", {"Red","Blue","Cyan","Green","Yellow","White","Purple"})
    slider(fov, "Fill Transparency", "FOVTransparency", 0, 100, "%")

    local trigger = section(p, "Triggerbot / Auto Clicker")
    toggle(trigger, "Triggerbot Enabled", "Triggerbot")
    toggle(trigger, "Auto Clicker", "AutoClicker")
end

--// VISUALS
do
    local p = Pages.Visuals
    local s = section(p, "Visuals")
    toggle(s, "Player ESP (Studio test)", "PlayerESP")
    toggle(s, "Crosshair", "Crosshair")
    toggle(s, "Fullbright", "Fullbright")

    local info = section(p, "Target Information")
    new("TextLabel", {
        Size = UDim2.new(1,0,0,54),
        BackgroundTransparency = 1,
        Text = "The FOV scanner selects the closest valid player to the screen center.\\nPlayers outside the circle are ignored.",
        TextColor3 = Theme.SubText,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 24,
    }, info)
end

--// PLAYER
do
    local p = Pages.Player
    local s = section(p, "Player")
    new("TextLabel", {
        Size = UDim2.new(1,0,0,32),
        BackgroundTransparency = 1,
        Text = "Local player controls are kept Studio-safe. No executor-only APIs are used.",
        TextColor3 = Theme.SubText,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 24,
    }, s)
end

--// WORLD
do
    local p = Pages.World
    local s = section(p, "World")
    toggle(s, "Fullbright", "Fullbright")
end

--// MISC
do
    local p = Pages.Misc
    local s = section(p, "Misc")
    new("TextLabel", {
        Size = UDim2.new(1,0,0,42),
        BackgroundTransparency = 1,
        Text = "Studio test build. Aimbot only evaluates Roblox Player characters in the current place.",
        TextColor3 = Theme.SubText,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 24,
    }, s)
end

--// UI SETTINGS / SAVE CHANGES
do
    local p = Pages["UI Settings"]

    local interfaceSection = section(p, "Interface")
    toggle(interfaceSection, "Show FOV Circle", "ShowFOV")
    toggle(interfaceSection, "Crosshair", "Crosshair")

    local saveSection = section(p, "Configuration")
    local saveButton = new("TextButton", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Theme.Panel3,
        BorderSizePixel = 0,
        Text = "Save Changes",
        TextColor3 = Theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        AutoButtonColor = false,
        ZIndex = 24,
    }, saveSection)
    corner(saveButton, 5)
    stroke(saveButton, Theme.Border, 1)

    saveButton.MouseEnter:Connect(function()
        saveButton.BackgroundColor3 = Theme.Blue2
    end)

    saveButton.MouseLeave:Connect(function()
        saveButton.BackgroundColor3 = Theme.Panel3
    end)

    saveButton.MouseButton1Click:Connect(function()
        saveChanges()
    end)

    SaveStatusLabel = new("TextLabel", {
        Position = UDim2.fromOffset(0, 44),
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Text = "Changes are saved for this play session.",
        TextColor3 = Theme.SubText,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        ZIndex = 24,
    }, saveSection)

    local info = new("TextLabel", {
        Position = UDim2.fromOffset(0, 76),
        Size = UDim2.new(1, 0, 0, 42),
        BackgroundTransparency = 1,
        Text = "Tip: Save Changes after changing your aimbot, FOV, target, color, or UI options.",
        TextColor3 = Theme.SubText,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 24,
    }, saveSection)
end

--// CROSSHAIR CONNECTION
local crosshairConnection
crosshairConnection = RunService.RenderStepped:Connect(function()
    Crosshair.Visible = State.Crosshair and State.UIVisible
end)

--// KEY INPUT
local aimHeld = false
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == State.AimKey then
            aimHeld = true
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == State.AimKey then
            aimHeld = false
        end
    end
end)

--// TARGETING
local function getCharacter(player)
    local character = player.Character
    if not character then return nil end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return nil end
    return character
end

local function getTargetPart(character)
    local part = character:FindFirstChild(State.TargetPart)
    if part and part:IsA("BasePart") then
        return part
    end

    return character:FindFirstChild("Head")
        or character:FindFirstChild("HumanoidRootPart")
end

local function sameTeam(player)
    if not State.TeamCheck then return false end
    if LocalPlayer.Team == nil or player.Team == nil then return false end
    return LocalPlayer.Team == player.Team
end

local function visible(part, character)
    if not (State.VisibilityCheck or State.WallCheck) then
        return true
    end

    local origin = Camera.CFrame.Position
    local direction = part.Position - origin

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {
        LocalPlayer.Character,
        Camera,
    }
    params.IgnoreWater = true

    local result = workspace:Raycast(origin, direction, params)
    if not result then
        return true
    end

    return result.Instance and result.Instance:IsDescendantOf(character)
end

local function getBestTarget()
    local viewport = Camera.ViewportSize
    local center = Vector2.new(viewport.X / 2, viewport.Y / 2)

    local bestPlayer = nil
    local bestPart = nil
    local bestDistance = State.FOVRadius

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and not sameTeam(player) then
            local character = getCharacter(player)
            if character then
                local part = getTargetPart(character)
                if part then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)

                    if onScreen and screenPos.Z > 0 then
                        local distance = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude

                        if distance <= bestDistance then
                            if visible(part, character) then
                                bestDistance = distance
                                bestPlayer = player
                                bestPart = part
                            end
                        end
                    end
                end
            end
        end
    end

    return bestPlayer, bestPart
end

--// STRONG AIM LOOP
-- Smoothness 1 is near-instant; higher values are softer.
RunService.RenderStepped:Connect(function(dt)
    if not State.Aimbot then return end

    local active = State.ActivationMode == "Always" or aimHeld
    if not active then return end

    local _, part = getBestTarget()
    if not part then return end

    local cameraPos = Camera.CFrame.Position
    local desired = CFrame.lookAt(cameraPos, part.Position)

    -- Stable frame-rate independent response.
    local strength = clamp(1 - math.exp(-dt * (22 / math.max(State.Smoothness, 1))), 0, 1)
    Camera.CFrame = Camera.CFrame:Lerp(desired, strength)
end)

--// SIMPLE STUDIO ESP
local espFolder = new("Folder", {Name = "BlackholeESP"}, Gui)

local function clearESP()
    for _, obj in ipairs(espFolder:GetChildren()) do
        obj:Destroy()
    end
end

RunService.RenderStepped:Connect(function()
    clearESP()
    if not State.PlayerESP then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and not sameTeam(player) then
            local character = getCharacter(player)
            local head = character and character:FindFirstChild("Head")
            if head then
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 2, 0))
                if onScreen then
                    local label = new("TextLabel", {
                        Position = UDim2.fromOffset(pos.X - 60, pos.Y - 12),
                        Size = UDim2.fromOffset(120, 24),
                        BackgroundTransparency = 1,
                        Text = player.Name,
                        TextColor3 = CircleColors[State.CircleColor] or CircleColors.Red,
                        TextStrokeTransparency = 0,
                        Font = Enum.Font.GothamBold,
                        TextSize = 12,
                        ZIndex = 15,
                    }, espFolder)
                end
            end
        end
    end
end)

--// FULLBRIGHT TEST
local Lighting = game:GetService("Lighting")
local originalBrightness = Lighting.Brightness
local originalAmbient = Lighting.Ambient
local originalOutdoor = Lighting.OutdoorAmbient

RunService.RenderStepped:Connect(function()
    if State.Fullbright then
        Lighting.Brightness = 3
        Lighting.Ambient = Color3.new(1,1,1)
        Lighting.OutdoorAmbient = Color3.new(1,1,1)
    else
        Lighting.Brightness = originalBrightness
        Lighting.Ambient = originalAmbient
        Lighting.OutdoorAmbient = originalOutdoor
    end
end)

--// RESPONSIVE WINDOW
local function resize()
    local camera = workspace.CurrentCamera
    if not camera then return end
    local vp = camera.ViewportSize

    if vp.X < 850 then
        Main.Size = UDim2.new(0.94, 0, 0, math.min(590, vp.Y - 20))
    else
        Main.Size = UDim2.fromOffset(820, 590)
    end
end

resize()
if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(resize)
end

--// CLOSE DROPDOWN WHEN CLICKING ELSEWHERE
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        task.defer(function()
            -- Overlay buttons handle their own click first.
            -- Keep open if a dropdown is currently being interacted with.
        end)
    end
end)

updateCircle()
switchTab("Combat")

print("[BlackholeHubUI] Loaded successfully - Roblox Studio test build")

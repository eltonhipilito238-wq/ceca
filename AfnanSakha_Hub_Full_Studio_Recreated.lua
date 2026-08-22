--[[
    AFNANSAKHA HUB - ROBLOX STUDIO TEST BUILD
    UI recreation based on the supplied screenshot.

    IMPORTANT:
    This is a Studio/private-test UI. It does NOT execute arbitrary
    injected/executor code and does not automate public Roblox games.

    SETUP:
      1. Put this LocalScript in StarterPlayer > StarterPlayerScripts.
      2. Optional: create Workspace > TestTargets and put dummy Models inside.
      3. Press RightShift to hide/show the panel.
      4. Drag the blue title bar to move the window.
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

local OLD_NAME = "AfnanSakhaHub_Studio"
local old = PlayerGui:FindFirstChild(OLD_NAME)
if old then
    old:Destroy()
end

--==========================================================
-- STATE
--==========================================================

local State = {
    Visible = true,
    Tab = "Scripts",

    AimbotCircle = true,
    AimbotShootButton = false,
    RemoveTeammateTarget = false,
    CircleRadius = 200,

    AimEnabled = false,
    AimSmoothness = 8,
    TargetPart = "Head",
    VisibilityCheck = true,

    FOVColor = Color3.fromRGB(0, 205, 255),

    SelectedScript = nil,
    History = {},
}

--==========================================================
-- HELPERS
--==========================================================

local function clamp(v, a, b)
    return math.max(a, math.min(b, v))
end

local function addHistory(text)
    table.insert(State.History, 1, os.date("%H:%M:%S") .. "  " .. text)
    if #State.History > 30 then
        table.remove(State.History)
    end
end

--==========================================================
-- GUI
--==========================================================

local Gui = Instance.new("ScreenGui")
Gui.Name = OLD_NAME
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

local Scale = Instance.new("UIScale")
Scale.Parent = Gui

local Main = Instance.new("Frame")
Main.Name = "Hub"
Main.Size = UDim2.fromOffset(370, 285)
Main.Position = UDim2.new(1, -390, 0.5, -142)
Main.BackgroundColor3 = Color3.fromRGB(9, 24, 43)
Main.BorderSizePixel = 0
Main.Parent = Gui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 151, 255)
MainStroke.Thickness = 2
MainStroke.Transparency = 0.15
MainStroke.Parent = Main

--==========================================================
-- HEADER
--==========================================================

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 38)
Header.BackgroundColor3 = Color3.fromRGB(8, 29, 52)
Header.BorderSizePixel = 0
Header.Parent = Main

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Position = UDim2.fromOffset(12, 0)
Title.Size = UDim2.new(1, -52, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "AFNANSAKHA HUB"
Title.TextColor3 = Color3.fromRGB(0, 205, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(28, 28)
Close.Position = UDim2.new(1, -34, 0, 5)
Close.BackgroundColor3 = Color3.fromRGB(10, 48, 79)
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(130, 220, 255)
Close.TextSize = 18
Close.Font = Enum.Font.GothamBold
Close.AutoButtonColor = false
Close.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = Close

Close.MouseButton1Click:Connect(function()
    State.Visible = false
    Main.Visible = false
end)

--==========================================================
-- DRAGGING
--==========================================================

local dragging = false
local dragStart
local startPos

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
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
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end)

--==========================================================
-- TABS
--==========================================================

local TabBar = Instance.new("Frame")
TabBar.Position = UDim2.fromOffset(9, 43)
TabBar.Size = UDim2.new(1, -18, 0, 32)
TabBar.BackgroundTransparency = 1
TabBar.Parent = Main

local TabButtons = {}
local Pages = {}

local function makeTab(name, x)
    local b = Instance.new("TextButton")
    b.Position = UDim2.fromOffset(x, 0)
    b.Size = UDim2.fromOffset(106, 28)
    b.BackgroundColor3 = Color3.fromRGB(12, 39, 66)
    b.BorderSizePixel = 0
    b.Font = Enum.Font.GothamBold
    b.Text = name:upper()
    b.TextColor3 = Color3.fromRGB(125, 205, 240)
    b.TextSize = 10
    b.AutoButtonColor = false
    b.Parent = TabBar

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 5)
    c.Parent = b

    TabButtons[name] = b

    b.MouseButton1Click:Connect(function()
        State.Tab = name

        for n, button in pairs(TabButtons) do
            button.BackgroundColor3 =
                n == name
                and Color3.fromRGB(0, 105, 190)
                or Color3.fromRGB(12, 39, 66)
            button.TextColor3 =
                n == name
                and Color3.fromRGB(255,255,255)
                or Color3.fromRGB(125,205,240)
        end

        for n, page in pairs(Pages) do
            page.Visible = n == name
        end
    end)
end

makeTab("Scripts", 0)
makeTab("Settings", 111)
makeTab("History", 222)

--==========================================================
-- PAGE FACTORY
--==========================================================

local function makePage(name)
    local p = Instance.new("ScrollingFrame")
    p.Name = name
    p.Position = UDim2.fromOffset(9, 79)
    p.Size = UDim2.new(1, -18, 1, -88)
    p.BackgroundTransparency = 1
    p.BorderSizePixel = 0
    p.ScrollBarThickness = 3
    p.ScrollBarImageColor3 = Color3.fromRGB(0, 160, 255)
    p.AutomaticCanvasSize = Enum.AutomaticSize.Y
    p.CanvasSize = UDim2.new()
    p.Visible = name == "Scripts"
    p.Parent = Main

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 6)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Parent = p

    Pages[name] = p
    return p
end

local ScriptsPage = makePage("Scripts")
local SettingsPage = makePage("Settings")
local HistoryPage = makePage("History")

--==========================================================
-- CONTROLS
--==========================================================

local function makeRow(parent, height)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -2, 0, height or 34)
    row.BackgroundColor3 = Color3.fromRGB(10, 35, 59)
    row.BorderSizePixel = 0
    row.Parent = parent

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = row

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 83, 135)
    stroke.Transparency = 0.35
    stroke.Parent = row

    return row
end

local function makeToggle(parent, label, getter, setter)
    local row = makeRow(parent, 34)

    local text = Instance.new("TextLabel")
    text.BackgroundTransparency = 1
    text.Position = UDim2.fromOffset(10, 0)
    text.Size = UDim2.new(1, -68, 1, 0)
    text.Font = Enum.Font.Gotham
    text.Text = label
    text.TextColor3 = Color3.fromRGB(225, 238, 248)
    text.TextSize = 11
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.Parent = row

    local toggle = Instance.new("TextButton")
    toggle.Position = UDim2.new(1, -51, 0.5, -10)
    toggle.Size = UDim2.fromOffset(42, 20)
    toggle.Text = ""
    toggle.AutoButtonColor = false
    toggle.Parent = row

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(14, 14)
    knob.Parent = toggle

    local kc = Instance.new("UICorner")
    kc.CornerRadius = UDim.new(1, 0)
    kc.Parent = knob

    local function refresh()
        local on = getter()
        toggle.BackgroundColor3 =
            on and Color3.fromRGB(0, 174, 245)
            or Color3.fromRGB(27, 46, 62)

        knob.BackgroundColor3 =
            on and Color3.fromRGB(235, 252, 255)
            or Color3.fromRGB(190, 205, 215)

        knob.Position =
            on
            and UDim2.new(1, -17, 0.5, -7)
            or UDim2.fromOffset(3, 3)
    end

    local tc = Instance.new("UICorner")
    tc.CornerRadius = UDim.new(1, 0)
    tc.Parent = toggle

    toggle.MouseButton1Click:Connect(function()
        setter(not getter())
        refresh()
    end)

    refresh()
    return row
end

local function makeSlider(parent, label, min, max, getter, setter)
    local row = makeRow(parent, 54)

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Position = UDim2.fromOffset(10, 4)
    title.Size = UDim2.new(1, -80, 0, 18)
    title.Font = Enum.Font.Gotham
    title.Text = label
    title.TextColor3 = Color3.fromRGB(225, 238, 248)
    title.TextSize = 11
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = row

    local valueText = Instance.new("TextLabel")
    valueText.BackgroundTransparency = 1
    valueText.Position = UDim2.new(1, -62, 4, 0)
    valueText.Size = UDim2.fromOffset(52, 18)
    valueText.Font = Enum.Font.GothamBold
    valueText.TextColor3 = Color3.fromRGB(150, 215, 245)
    valueText.TextSize = 10
    valueText.TextXAlignment = Enum.TextXAlignment.Right
    valueText.Parent = row

    local bar = Instance.new("Frame")
    bar.Position = UDim2.fromOffset(10, 32)
    bar.Size = UDim2.new(1, -20, 0, 6)
    bar.BackgroundColor3 = Color3.fromRGB(21, 54, 78)
    bar.BorderSizePixel = 0
    bar.Parent = row

    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(1, 0)
    bc.Parent = bar

    local fill = Instance.new("Frame")
    fill.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
    fill.BorderSizePixel = 0
    fill.Parent = bar

    local fc = Instance.new("UICorner")
    fc.CornerRadius = UDim.new(1, 0)
    fc.Parent = fill

    local draggingSlider = false

    local function refresh()
        local v = getter()
        local pct = (v - min) / (max - min)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        valueText.Text = tostring(v)
    end

    local function setFromX(x)
        local pct = clamp(
            (x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X,
            0, 1
        )
        local v = math.floor(min + (max - min) * pct + 0.5)
        setter(v)
        refresh()
    end

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = true
            setFromX(input.Position.X)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not draggingSlider then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            setFromX(input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = false
        end
    end)

    refresh()
    return row
end

local function makeButton(parent, text, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -2, 34)
    b.BackgroundColor3 = Color3.fromRGB(0, 91, 192)
    b.BorderSizePixel = 0
    b.Font = Enum.Font.GothamBold
    b.Text = text
    b.TextColor3 = Color3.fromRGB(230, 250, 255)
    b.TextSize = 10
    b.AutoButtonColor = false
    b.Parent = parent

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = b

    b.MouseEnter:Connect(function()
        TweenService:Create(
            b,
            TweenInfo.new(0.1),
            {BackgroundColor3 = Color3.fromRGB(0, 125, 225)}
        ):Play()
    end)

    b.MouseLeave:Connect(function()
        TweenService:Create(
            b,
            TweenInfo.new(0.1),
            {BackgroundColor3 = Color3.fromRGB(0, 91, 192)}
        ):Play()
    end)

    b.MouseButton1Click:Connect(callback)
    return b
end

--==========================================================
-- FOV CIRCLE
--==========================================================

local FOV = Instance.new("Frame")
FOV.Name = "AimbotCircle"
FOV.AnchorPoint = Vector2.new(0.5, 0.5)
FOV.BackgroundColor3 = State.FOVColor
FOV.BackgroundTransparency = 1
FOV.BorderSizePixel = 0
FOV.Visible = State.AimbotCircle
FOV.ZIndex = 1
FOV.Parent = Gui

local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(1, 0)
fovCorner.Parent = FOV

local fovStroke = Instance.new("UIStroke")
fovStroke.Color = State.FOVColor
fovStroke.Thickness = 2
fovStroke.Transparency = 0.15
fovStroke.Parent = FOV

local function updateFOV()
    local viewport = Camera and Camera.ViewportSize or Vector2.new(1280, 720)
    FOV.Position = UDim2.fromOffset(viewport.X / 2, viewport.Y / 2)
    FOV.Size = UDim2.fromOffset(State.CircleRadius * 2, State.CircleRadius * 2)
    FOV.Visible = State.AimbotCircle and State.Visible
end

--==========================================================
-- SCRIPTS PAGE
--==========================================================

makeToggle(ScriptsPage, "Aimbot Circle", function()
    return State.AimbotCircle
end, function(v)
    State.AimbotCircle = v
    updateFOV()
    addHistory("Aimbot Circle " .. (v and "enabled" or "disabled"))
end)

makeToggle(ScriptsPage, "Aimbot Shoot Button", function()
    return State.AimbotShootButton
end, function(v)
    State.AimbotShootButton = v
    addHistory("Aimbot Shoot Button " .. (v and "enabled" or "disabled"))
end)

makeToggle(ScriptsPage, "Remove Teammate Target", function()
    return State.RemoveTeammateTarget
end, function(v)
    State.RemoveTeammateTarget = v
    addHistory("Team filtering " .. (v and "enabled" or "disabled"))
end)

makeSlider(ScriptsPage, "Circle Radius", 50, 500, function()
    return State.CircleRadius
end, function(v)
    State.CircleRadius = v
    updateFOV()
end)

-- Target preview / selection
local TargetRow = makeRow(ScriptsPage, 38)

local TargetLabel = Instance.new("TextLabel")
TargetLabel.BackgroundTransparency = 1
TargetLabel.Position = UDim2.fromOffset(10, 0)
TargetLabel.Size = UDim2.new(1, -100, 1, 0)
TargetLabel.Font = Enum.Font.Gotham
TargetLabel.Text = "Selected Test Target: none"
TargetLabel.TextColor3 = Color3.fromRGB(225,238,248)
TargetLabel.TextSize = 10
TargetLabel.TextXAlignment = Enum.TextXAlignment.Left
TargetLabel.Parent = TargetRow

local selectTarget = Instance.new("TextButton")
selectTarget.Position = UDim2.new(1, -88, 0.5, -12)
selectTarget.Size = UDim2.fromOffset(78, 24)
selectTarget.BackgroundColor3 = Color3.fromRGB(0, 91, 160)
selectTarget.Text = "SELECT"
selectTarget.TextColor3 = Color3.fromRGB(225,250,255)
selectTarget.Font = Enum.Font.GothamBold
selectTarget.TextSize = 9
selectTarget.Parent = TargetRow

local stc = Instance.new("UICorner")
stc.CornerRadius = UDim.new(0, 5)
stc.Parent = selectTarget

selectTarget.MouseButton1Click:Connect(function()
    local folder = workspace:FindFirstChild("TestTargets")
    if not folder then
        TargetLabel.Text = "Selected Test Target: TestTargets missing"
        addHistory("TestTargets folder missing")
        return
    end

    local firstModel
    for _, obj in ipairs(folder:GetChildren()) do
        if obj:IsA("Model") then
            firstModel = obj
            break
        end
    end

    if firstModel then
        State.SelectedScript = firstModel
        TargetLabel.Text = "Selected Test Target: " .. firstModel.Name
        addHistory("Selected target: " .. firstModel.Name)
    else
        TargetLabel.Text = "Selected Test Target: none"
        addHistory("No Model found in TestTargets")
    end
end)

makeButton(ScriptsPage, "EXECUTE SELECTED STUDIO TEST", function()
    if State.SelectedScript and State.SelectedScript.Parent then
        addHistory("Studio test selected: " .. State.SelectedScript.Name)
        TargetLabel.Text = "Selected Test Target: " .. State.SelectedScript.Name
    else
        addHistory("No test target selected")
        TargetLabel.Text = "Selected Test Target: none"
    end
end)

makeButton(ScriptsPage, "CLEAR SELECTION", function()
    State.SelectedScript = nil
    TargetLabel.Text = "Selected Test Target: none"
    addHistory("Selection cleared")
end)

--==========================================================
-- SETTINGS PAGE
--==========================================================

makeToggle(SettingsPage, "Aimbot Enabled", function()
    return State.AimEnabled
end, function(v)
    State.AimEnabled = v
    addHistory("Aimbot " .. (v and "enabled" or "disabled"))
end)

makeToggle(SettingsPage, "Visibility Check", function()
    return State.VisibilityCheck
end, function(v)
    State.VisibilityCheck = v
    addHistory("Visibility Check " .. (v and "enabled" or "disabled"))
end)

makeToggle(SettingsPage, "Remove Teammate Target", function()
    return State.RemoveTeammateTarget
end, function(v)
    State.RemoveTeammateTarget = v
end)

makeSlider(SettingsPage, "Aim Smoothness", 1, 20, function()
    return State.AimSmoothness
end, function(v)
    State.AimSmoothness = v
end)

makeButton(SettingsPage, "RESET SETTINGS", function()
    State.AimbotCircle = true
    State.AimbotShootButton = false
    State.RemoveTeammateTarget = false
    State.CircleRadius = 200
    State.AimEnabled = false
    State.AimSmoothness = 8
    State.VisibilityCheck = true

    updateFOV()
    addHistory("Settings reset")
end)

--==========================================================
-- HISTORY PAGE
--==========================================================

local HistoryList = Instance.new("Frame")
HistoryList.Size = UDim2.new(1, -2, 0, 1)
HistoryList.BackgroundTransparency = 1
HistoryList.Parent = HistoryPage

local historyLayout = Instance.new("UIListLayout")
historyLayout.Padding = UDim.new(0, 5)
historyLayout.SortOrder = Enum.SortOrder.LayoutOrder
historyLayout.Parent = HistoryList

local function refreshHistory()
    for _, child in ipairs(HistoryList:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end

    for _, entry in ipairs(State.History) do
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1, -2, 0, 28)
        l.BackgroundColor3 = Color3.fromRGB(10,35,59)
        l.BorderSizePixel = 0
        l.Font = Enum.Font.Code
        l.Text = entry
        l.TextColor3 = Color3.fromRGB(175,220,240)
        l.TextSize = 9
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = HistoryList

        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0,5)
        c.Parent = l
    end

    HistoryList.Size = UDim2.new(1, -2, 0, math.max(1, #State.History * 33))
end

-- refresh history whenever the user opens the tab
TabButtons.History.MouseButton1Click:Connect(refreshHistory)

--==========================================================
-- RESPONSIVE SCALE
--==========================================================

local function updateScale()
    local viewport = Camera and Camera.ViewportSize or Vector2.new(1280, 720)

    local sx = viewport.X / 900
    local sy = viewport.Y / 600
    local scale = clamp(math.min(sx, sy), 0.72, 1.15)

    Scale.Scale = scale

    -- Keep the window inside the screen.
    local w = 370 * scale
    local h = 285 * scale

    Main.Position = UDim2.new(
        0.5,
        -w / 2,
        0.5,
        -h / 2
    )
end

Camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
updateScale()
updateFOV()

--==========================================================
-- VISIBILITY / HOTKEY
--==========================================================

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end

    if input.KeyCode == Enum.KeyCode.RightShift then
        State.Visible = not State.Visible
        Main.Visible = State.Visible
        updateFOV()
    end
end)

--==========================================================
-- SAFE TEST TARGET HIGHLIGHT
--==========================================================

local highlights = {}

local function clearHighlights()
    for model, h in pairs(highlights) do
        if h and h.Parent then
            h:Destroy()
        end
        highlights[model] = nil
    end
end

local function refreshHighlights()
    clearHighlights()

    if not State.AimEnabled then
        return
    end

    local folder = workspace:FindFirstChild("TestTargets")
    if not folder then return end

    for _, model in ipairs(folder:GetChildren()) do
        if model:IsA("Model") then
            local h = Instance.new("Highlight")
            h.Name = "StudioTargetHighlight"
            h.Adornee = model
            h.FillColor = Color3.fromRGB(0, 170, 255)
            h.FillTransparency = 0.82
            h.OutlineColor = Color3.fromRGB(0, 220, 255)
            h.OutlineTransparency = 0.05
            h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            h.Parent = Gui
            highlights[model] = h
        end
    end
end

-- Only visualize Studio test targets; no arbitrary game targeting.
RunService.Heartbeat:Connect(function()
    if not Gui.Parent then return end

    local folder = workspace:FindFirstChild("TestTargets")
    if State.AimEnabled and folder then
        -- Keep highlights valid if a target was added/removed.
        for model, h in pairs(highlights) do
            if not model.Parent or not h.Parent then
                refreshHighlights()
                break
            end
        end
    end
end)

-- Rebuild highlights when the setting changes through the toggle.
for _, child in ipairs(SettingsPage:GetChildren()) do
    if child:IsA("Frame") then
        local button = child:FindFirstChildWhichIsA("TextButton")
        if button then
            button.MouseButton1Click:Connect(function()
                task.defer(refreshHighlights)
            end)
        end
    end
end

addHistory("Hub loaded")
addHistory("Studio test mode active")
refreshHistory()

print("[AFNANSAKHA HUB] Studio test UI loaded successfully.")

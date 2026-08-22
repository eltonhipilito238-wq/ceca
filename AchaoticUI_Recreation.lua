-- Achaotic-style Roblox UI recreation
-- UI/visual prototype only. The controls do not automate gameplay,
-- bypass mechanics, or implement exploit functionality.

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "AchaoticUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local function corner(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 5)
    c.Parent = obj
end

local function stroke(obj, color, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or Color3.fromRGB(32,40,50)
    s.Transparency = transparency or 0
    s.Thickness = 1
    s.Parent = obj
end

local function label(parent, text, size, color)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = color or Color3.fromRGB(225,230,235)
    l.Font = Enum.Font.Gotham
    l.TextSize = size or 13
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = parent
    return l
end

local root = Instance.new("Frame")
root.Name = "Window"
root.Size = UDim2.fromOffset(960, 650)
root.Position = UDim2.fromScale(.5,.5)
root.AnchorPoint = Vector2.new(.5,.5)
root.BackgroundColor3 = Color3.fromRGB(10,14,19)
root.BorderSizePixel = 0
root.Parent = gui
corner(root,8)
stroke(root)

-- Dragging
local dragging, dragStart, startPos
root.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = root.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local d = input.Position - dragStart
        root.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,
            startPos.Y.Scale,startPos.Y.Offset+d.Y)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging=false end
end)

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0,210,1,0)
sidebar.BackgroundColor3 = Color3.fromRGB(13,18,24)
sidebar.BorderSizePixel = 0
sidebar.Parent = root

local title = label(sidebar,"Achaotic",19,Color3.fromRGB(235,238,242))
title.Font = Enum.Font.GothamBold
title.Position = UDim2.fromOffset(22,18)
title.Size = UDim2.fromOffset(160,25)

local subtitle = label(sidebar,"UI Recreation",10,Color3.fromRGB(95,105,116))
subtitle.Position = UDim2.fromOffset(22,42)
subtitle.Size = UDim2.fromOffset(160,18)

local nav = Instance.new("Frame")
nav.BackgroundTransparency = 1
nav.Position = UDim2.fromOffset(12,78)
nav.Size = UDim2.new(1,-24,0,300)
nav.Parent = sidebar

local navLayout = Instance.new("UIListLayout")
navLayout.Padding = UDim.new(0,4)
navLayout.Parent = nav

local main = Instance.new("Frame")
main.Position = UDim2.fromOffset(210,0)
main.Size = UDim2.new(1,-210,1,0)
main.BackgroundColor3 = Color3.fromRGB(10,14,19)
main.BorderSizePixel = 0
main.Parent = root

local top = Instance.new("Frame")
top.Size = UDim2.new(1,0,0,58)
top.BackgroundColor3 = Color3.fromRGB(10,14,19)
top.BorderSizePixel = 0
top.Parent = main

local search = Instance.new("TextBox")
search.Size = UDim2.fromOffset(250,34)
search.Position = UDim2.new(1,-270,0,12)
search.BackgroundColor3 = Color3.fromRGB(11,16,22)
search.TextColor3 = Color3.fromRGB(175,185,195)
search.PlaceholderColor3 = Color3.fromRGB(90,100,110)
search.PlaceholderText = "Search"
search.Text = ""
search.ClearTextOnFocus = false
search.Font = Enum.Font.Gotham
search.TextSize = 12
search.BorderSizePixel = 0
search.Parent = top
corner(search,5)
stroke(search)

local content = Instance.new("ScrollingFrame")
content.Position = UDim2.fromOffset(0,58)
content.Size = UDim2.new(1,0,1,-82)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 5
content.ScrollBarImageColor3 = Color3.fromRGB(40,50,60)
content.Parent = main

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0,20)
padding.PaddingLeft = UDim.new(0,20)
padding.PaddingRight = UDim.new(0,20)
padding.Parent = content

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0,12)
layout.Parent = content

local pages = {}

local function makePage(name)
    local page = Instance.new("Frame")
    page.Name = name
    page.Size = UDim2.new(1,0,0,500)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = content
    pages[name] = page
    return page
end

local function makeCard(parent, titleText)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(.5,-9,0,0)
    card.AutomaticSize = Enum.AutomaticSize.Y
    card.BackgroundColor3 = Color3.fromRGB(13,18,24)
    card.BorderSizePixel = 0
    card.Parent = parent
    corner(card,5)
    stroke(card)

    local head = label(card,titleText,12,Color3.fromRGB(225,230,235))
    head.Font = Enum.Font.GothamSemibold
    head.Position = UDim2.fromOffset(14,0)
    head.Size = UDim2.new(1,-28,0,40)

    local rows = Instance.new("Frame")
    rows.Position = UDim2.fromOffset(0,40)
    rows.Size = UDim2.new(1,0,0,0)
    rows.AutomaticSize = Enum.AutomaticSize.Y
    rows.BackgroundTransparency = 1
    rows.Parent = card

    local rl = Instance.new("UIListLayout")
    rl.Parent = rows
    return card, rows
end

local function makeRow(rows, text, kind, default)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1,0,0,43)
    row.BackgroundTransparency = 1
    row.Parent = rows

    local t = label(row,text,12,Color3.fromRGB(170,180,190))
    t.Position = UDim2.fromOffset(14,0)
    t.Size = UDim2.new(.55,0,1,0)

    local holder = Instance.new("Frame")
    holder.Position = UDim2.new(.55,0,0,0)
    holder.Size = UDim2.new(.45,-14,1,0)
    holder.BackgroundTransparency = 1
    holder.Parent = row

    if kind == "toggle" then
        local b = Instance.new("TextButton")
        b.Size = UDim2.fromOffset(35,18)
        b.Position = UDim2.new(1,-35,.5,-9)
        b.Text = ""
        b.BackgroundColor3 = Color3.fromRGB(48,57,66)
        b.BorderSizePixel = 0
        b.Parent = holder
        corner(b,20)
        local dot = Instance.new("Frame")
        dot.Size = UDim2.fromOffset(12,12)
        dot.Position = UDim2.fromOffset(3,3)
        dot.BackgroundColor3 = Color3.fromRGB(220,224,228)
        dot.BorderSizePixel = 0
        dot.Parent = b
        corner(dot,20)
        local on = default == true
        local function refresh()
            b.BackgroundColor3 = on and Color3.fromRGB(85,100,14) or Color3.fromRGB(48,57,66)
            dot.Position = on and UDim2.new(1,-15,0,3) or UDim2.fromOffset(3,3)
            dot.BackgroundColor3 = on and Color3.fromRGB(216,245,43) or Color3.fromRGB(220,224,228)
        end
        b.MouseButton1Click:Connect(function() on=not on; refresh() end)
        refresh()
    elseif kind == "key" then
        local b = Instance.new("TextButton")
        b.Size = UDim2.fromOffset(58,24)
        b.Position = UDim2.new(1,-58,.5,-12)
        b.Text = "NONE"
        b.TextColor3 = Color3.fromRGB(170,180,30)
        b.Font = Enum.Font.Gotham
        b.TextSize = 10
        b.BackgroundColor3 = Color3.fromRGB(18,24,12)
        b.BorderSizePixel = 0
        b.Parent = holder
        corner(b,3); stroke(b,Color3.fromRGB(40,48,24))
    elseif kind == "select" then
        local b = Instance.new("TextButton")
        b.Size = UDim2.fromOffset(115,26)
        b.Position = UDim2.new(1,-115,.5,-13)
        b.Text = default or "Speed"
        b.TextColor3 = Color3.fromRGB(170,180,190)
        b.Font = Enum.Font.Gotham
        b.TextSize = 10
        b.BackgroundColor3 = Color3.fromRGB(17,23,30)
        b.BorderSizePixel = 0
        b.Parent = holder
        corner(b,3); stroke(b)
    end
    return row
end

local function gridPage(name)
    local page = makePage(name)
    local grid = Instance.new("UIGridLayout")
    grid.CellSize = UDim2.new(.5,-9,0,0)
    grid.CellPadding = UDim2.fromOffset(18,12)
    grid.FillDirectionMaxCells = 2
    grid.SortOrder = Enum.SortOrder.LayoutOrder
    grid.Parent = page
    return page
end

local general = gridPage("General")
do
    local _,r=makeCard(general,"General")
    makeRow(r,"UI Scale","select","100%")
    makeRow(r,"Animation Fix","toggle")
    makeRow(r,"Notifications","toggle",true)
    local _,r2=makeCard(general,"Input")
    makeRow(r2,"Toggle Menu","key")
    makeRow(r2,"Reset Settings","select","Reset")
end

local combat = gridPage("Combat")
do
    local _,r=makeCard(combat,"Auto Parry")
    for _,x in ipairs({"Enabled","Accuracy","Keybind","Animation Fix","Anti Curve","Infinity Detection","Death Slash Detection","Time Hole Detection"}) do
        makeRow(r,x,x=="Keybind" and "key" or "toggle",x=="Anti Curve")
    end
    local _,r2=makeCard(combat,"Auto Spam Parry [BETA]")
    makeRow(r2,"Enabled","toggle"); makeRow(r2,"Detection Mode","select","Speed"); makeRow(r2,"Animation Fix","toggle")
    local _,r3=makeCard(combat,"Lobby Auto Party")
    makeRow(r3,"Enabled","toggle"); makeRow(r3,"Accuracy","select","80%")
    local _,r4=makeCard(combat,"Manual Spam Parry")
    makeRow(r4,"Active","toggle"); makeRow(r4,"UI","toggle"); makeRow(r4,"Pause during dead","toggle",true); makeRow(r4,"Keybind","key"); makeRow(r4,"Animation Fix","toggle")
    local _,r5=makeCard(combat,"Trigger Bot")
    makeRow(r5,"Active","toggle"); makeRow(r5,"UI","toggle"); makeRow(r5,"Keybind","key"); makeRow(r5,"Animation Fix","toggle")
end

local visuals=gridPage("Visuals")
do
    local _,r=makeCard(visuals,"Visualizer"); makeRow(r,"Enabled","toggle")
    local _,r2=makeCard(visuals,"Effects"); makeRow(r2,"Hit Effect","toggle")
end

local misc=gridPage("Miscellaneous")
do
    local _,r=makeCard(misc,"Spamming")
    makeRow(r,"Mode","select","Advanced"); makeRow(r,"Max Speed","select","180p/s"); makeRow(r,"Fast Ball Protection","toggle"); makeRow(r,"Reset After Parry","toggle",true); makeRow(r,"Loop Speed","select","3824 RPS"); makeRow(r,"Animation Fix","toggle"); makeRow(r,"Max Rate","select","60 FPS"); makeRow(r,"Spam F.E","toggle")
    local _,r2=makeCard(misc,"Party System")
    makeRow(r2,"Method","select","BIDANT"); makeRow(r2,"Hash Check","toggle"); makeRow(r2,"Curve Direction","select","Camera")
end

local exclusive=gridPage("Exclusive")
do
    local _,r=makeCard(exclusive,"Animation Disabler"); makeRow(r,"Disable Party Animation","toggle"); makeRow(r,"Disable Child Animation","toggle")
    local _,r2=makeCard(exclusive,"Ball Stats"); makeRow(r2,"Enabled","toggle")
    local _,r3=makeCard(exclusive,"Immortality"); makeRow(r3,"Enabled","toggle"); makeRow(r3,"Radius","select","25 studs"); makeRow(r3,"Height","select","90 studs"); makeRow(r3,"Force","select","8000 studs")
    local _,r4=makeCard(exclusive,"Skin Changer [BETA]"); makeRow(r4,"Enabled","toggle"); makeRow(r4,"Change Model","toggle"); makeRow(r4,"Model","select","Flashback Butterfly Blade"); makeRow(r4,"Change Animations","toggle"); makeRow(r4,"Animation","select","Flashback Butterfly"); makeRow(r4,"Change FX","toggle")
    local _,r5=makeCard(exclusive,"Optimization"); makeRow(r5,"No Render","toggle")
end

local settings=gridPage("Settings")
do
    local _,r=makeCard(settings,"Settings"); makeRow(r,"Theme","select","Dark"); makeRow(r,"UI Animations","toggle",true); makeRow(r,"Reset All","select","Reset")
end

for name,page in pairs(pages) do
    page.Visible = (name=="General")
end

local navItems={"General","Combat","Visuals","Miscellaneous","Exclusive","Settings"}
for _,name in ipairs(navItems) do
    local b=Instance.new("TextButton")
    b.Size=UDim2.new(1,0,0,38)
    b.Text="   "..name
    b.TextXAlignment=Enum.TextXAlignment.Left
    b.TextColor3=Color3.fromRGB(115,125,137)
    b.Font=Enum.Font.Gotham
    b.TextSize=12
    b.BackgroundColor3=Color3.fromRGB(13,18,24)
    b.BorderSizePixel=0
    b.Parent=nav
    corner(b,5)
    b.MouseButton1Click:Connect(function()
        for n,p in pairs(pages) do p.Visible=(n==name) end
        for _,x in ipairs(nav:GetChildren()) do
            if x:IsA("TextButton") then
                x.BackgroundColor3=Color3.fromRGB(13,18,24)
                x.TextColor3=Color3.fromRGB(115,125,137)
            end
        end
        b.BackgroundColor3=Color3.fromRGB(21,29,37)
        b.TextColor3=Color3.fromRGB(240,243,246)
    end)
    if name=="General" then
        b.BackgroundColor3=Color3.fromRGB(21,29,37)
        b.TextColor3=Color3.fromRGB(240,243,246)
    end
end

local footer=label(main,"Achaotic-style UI recreation • Visual prototype",10,Color3.fromRGB(80,90,100))
footer.Position=UDim2.new(0,18,1,-20)
footer.Size=UDim2.new(1,-36,0,15)
footer.TextXAlignment=Enum.TextXAlignment.Left

print("Achaotic UI recreation loaded.")

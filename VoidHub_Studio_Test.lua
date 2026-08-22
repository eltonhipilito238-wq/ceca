-- VOIDHUB STUDIO TEST BUILD
-- LocalScript: StarterPlayer > StarterPlayerScripts
-- Safe test mode: only targets NPCs in workspace.TestTargets.
-- Q = aim assist | RightShift = show/hide UI

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera
local targets = workspace:FindFirstChild("TestTargets") or Instance.new("Folder", workspace)
targets.Name = "TestTargets"

local S = {
    Aim = true, FOV = true, WallCheck = true, LockCenter = true,
    Radius = 140, Smooth = 12, Part = "Head", AimKey = Enum.KeyCode.Q,
    ESP = false, Names = true, Distance = true, Hitbox = false,
    HitboxSize = 10, HitboxTransparency = .55,
    Walk = false, WalkSpeed = 16, Jump = false, JumpPower = 50,
    UIKey = Enum.KeyCode.RightShift, Visible = true
}

local T = {
    bg=Color3.fromRGB(10,10,12), side=Color3.fromRGB(13,13,16),
    panel=Color3.fromRGB(17,17,21), panel2=Color3.fromRGB(21,21,27),
    text=Color3.fromRGB(235,235,240), sub=Color3.fromRGB(145,145,155),
    purple=Color3.fromRGB(139,92,246), light=Color3.fromRGB(170,125,255),
    border=Color3.fromRGB(38,38,46)
}

local old = gui:FindFirstChild("VoidAimbotUI")
if old then old:Destroy() end

local SG = Instance.new("ScreenGui")
SG.Name="VoidAimbotUI"; SG.ResetOnSpawn=false; SG.IgnoreGuiInset=true
SG.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; SG.Parent=gui

local main=Instance.new("Frame",SG)
main.Name="Main"; main.Size=UDim2.fromOffset(720,480)
main.Position=UDim2.new(.5,-360,.5,-240); main.BackgroundColor3=T.bg
main.BorderSizePixel=0

local mc=Instance.new("UICorner",main); mc.CornerRadius=UDim.new(0,8)
local ms=Instance.new("UIStroke",main); ms.Color=T.border

local top=Instance.new("Frame",main)
top.Size=UDim2.new(1,0,0,42); top.BackgroundColor3=T.panel; top.BorderSizePixel=0
local tc=Instance.new("UICorner",top); tc.CornerRadius=UDim.new(0,8)

local title=Instance.new("TextLabel",top)
title.BackgroundTransparency=1; title.Position=UDim2.fromOffset(14,0)
title.Size=UDim2.fromOffset(250,42); title.Font=Enum.Font.GothamMedium
title.Text="VoidHub"; title.TextColor3=T.text; title.TextSize=15
title.TextXAlignment=Enum.TextXAlignment.Left

local status=Instance.new("TextLabel",top)
status.BackgroundTransparency=1; status.Position=UDim2.fromOffset(78,0)
status.Size=UDim2.fromOffset(150,42); status.Font=Enum.Font.Gotham
status.Text="STUDIO TEST"; status.TextColor3=T.purple; status.TextSize=9

local search=Instance.new("TextBox",top)
search.Position=UDim2.new(1,-240,0,8); search.Size=UDim2.fromOffset(170,26)
search.BackgroundColor3=T.panel2; search.BorderSizePixel=0; search.Font=Enum.Font.Gotham
search.PlaceholderText="Search"; search.PlaceholderColor3=T.sub
search.Text=""; search.TextColor3=T.text; search.TextSize=10

local close=Instance.new("TextButton",top)
close.BackgroundTransparency=1; close.Position=UDim2.new(1,-42,0,0)
close.Size=UDim2.fromOffset(42,42); close.Text="×"; close.Font=Enum.Font.Gotham
close.TextColor3=T.sub; close.TextSize=22
close.MouseButton1Click:Connect(function() S.Visible=false; main.Visible=false end)

local drag,ds,sp=false,nil,nil
top.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
        drag=true; ds=i.Position; sp=main.Position
    end
end)
top.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=false end
end)
UIS.InputChanged:Connect(function(i)
    if drag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
        local d=i.Position-ds
        main.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)
    end
end)

local side=Instance.new("Frame",main)
side.Position=UDim2.fromOffset(0,42); side.Size=UDim2.new(0,145,1,-42)
side.BackgroundColor3=T.side; side.BorderSizePixel=0

local logo=Instance.new("TextLabel",side)
logo.BackgroundTransparency=1; logo.Position=UDim2.fromOffset(16,16)
logo.Size=UDim2.fromOffset(110,30); logo.Font=Enum.Font.GothamBold
logo.Text="VOID"; logo.TextColor3=T.light; logo.TextSize=18
logo.TextXAlignment=Enum.TextXAlignment.Left

local line=Instance.new("Frame",side)
line.Position=UDim2.fromOffset(16,48); line.Size=UDim2.new(1,-32,0,1)
line.BackgroundColor3=T.border; line.BorderSizePixel=0

local content=Instance.new("Frame",main)
content.Position=UDim2.fromOffset(145,42); content.Size=UDim2.new(1,-145,1,-42)
content.BackgroundColor3=T.bg; content.BorderSizePixel=0

local pages={}
for _,name in ipairs({"Main","Visuals","Player","UI Settings"}) do
    local p=Instance.new("ScrollingFrame",content)
    p.Name=name.."Page"; p.Size=UDim2.fromScale(1,1); p.BackgroundTransparency=1
    p.BorderSizePixel=0; p.ScrollBarThickness=3; p.ScrollBarImageColor3=T.purple
    p.AutomaticCanvasSize=Enum.AutomaticSize.Y; p.CanvasSize=UDim2.new()
    p.Visible=name=="Main"
    local pad=Instance.new("UIPadding",p)
    pad.PaddingTop=UDim.new(0,18); pad.PaddingLeft=UDim.new(0,18)
    pad.PaddingRight=UDim.new(0,18); pad.PaddingBottom=UDim.new(0,18)
    local list=Instance.new("UIListLayout",p); list.Padding=UDim.new(0,10)
    pages[name]=p
end

local function section(p,text)
    local l=Instance.new("TextLabel",p); l.Size=UDim2.new(1,0,0,26)
    l.BackgroundTransparency=1; l.Font=Enum.Font.GothamMedium
    l.Text=text; l.TextColor3=T.text; l.TextSize=14
    l.TextXAlignment=Enum.TextXAlignment.Left
end

local function panel(p,h)
    local f=Instance.new("Frame",p); f.Size=UDim2.new(1,0,0,h)
    f.BackgroundColor3=T.panel; f.BorderSizePixel=0
    local c=Instance.new("UICorner",f); c.CornerRadius=UDim.new(0,6)
    local s=Instance.new("UIStroke",f); s.Color=T.border
    local pad=Instance.new("UIPadding",f)
    pad.PaddingLeft=UDim.new(0,12); pad.PaddingRight=UDim.new(0,12)
    pad.PaddingTop=UDim.new(0,8); pad.PaddingBottom=UDim.new(0,8)
    local list=Instance.new("UIListLayout",f); list.Padding=UDim.new(0,2)
    return f
end

local function toggle(p,text,default,cb)
    local r=Instance.new("Frame",p); r.Size=UDim2.new(1,0,0,34); r.BackgroundTransparency=1
    local l=Instance.new("TextLabel",r); l.Size=UDim2.new(1,-55,1,0)
    l.BackgroundTransparency=1; l.Font=Enum.Font.Gotham; l.Text=text
    l.TextColor3=T.text; l.TextSize=12; l.TextXAlignment=Enum.TextXAlignment.Left
    local b=Instance.new("TextButton",r); b.Position=UDim2.new(1,-42,.5,-9)
    b.Size=UDim2.fromOffset(38,18); b.Text=""; b.AutoButtonColor=false
    b.BackgroundColor3=default and T.purple or Color3.fromRGB(50,50,58)
    local c=Instance.new("UICorner",b); c.CornerRadius=UDim.new(1,0)
    local k=Instance.new("Frame",b); k.Size=UDim2.fromOffset(14,14)
    k.Position=default and UDim2.new(1,-16,.5,-7) or UDim2.new(0,2,.5,-7)
    k.BackgroundColor3=Color3.fromRGB(245,245,250); k.BorderSizePixel=0
    local kc=Instance.new("UICorner",k); kc.CornerRadius=UDim.new(1,0)
    local v=default
    b.MouseButton1Click:Connect(function()
        v=not v
        TweenService:Create(b,TweenInfo.new(.12),{BackgroundColor3=v and T.purple or Color3.fromRGB(50,50,58)}):Play()
        TweenService:Create(k,TweenInfo.new(.12),{Position=v and UDim2.new(1,-16,.5,-7) or UDim2.new(0,2,.5,-7)}):Play()
        cb(v)
    end)
end

local function slider(p,text,min,max,default,cb)
    local f=Instance.new("Frame",p); f.Size=UDim2.new(1,0,0,55); f.BackgroundTransparency=1
    local l=Instance.new("TextLabel",f); l.Size=UDim2.new(1,-70,0,20); l.BackgroundTransparency=1
    l.Font=Enum.Font.Gotham; l.Text=text; l.TextColor3=T.text; l.TextSize=12
    l.TextXAlignment=Enum.TextXAlignment.Left
    local val=Instance.new("TextLabel",f); val.Position=UDim2.new(1,-65,0,0); val.Size=UDim2.fromOffset(65,20)
    val.BackgroundTransparency=1; val.Font=Enum.Font.Gotham; val.TextColor3=T.sub; val.TextSize=10
    val.TextXAlignment=Enum.TextXAlignment.Right; val.Text=tostring(default)
    local bar=Instance.new("Frame",f); bar.Position=UDim2.fromOffset(0,30); bar.Size=UDim2.new(1,0,0,5)
    bar.BackgroundColor3=Color3.fromRGB(40,40,48); bar.BorderSizePixel=0
    local bc=Instance.new("UICorner",bar); bc.CornerRadius=UDim.new(1,0)
    local fill=Instance.new("Frame",bar); fill.Size=UDim2.new((default-min)/(max-min),0,1,0)
    fill.BackgroundColor3=T.purple; fill.BorderSizePixel=0
    local fc=Instance.new("UICorner",fill); fc.CornerRadius=UDim.new(1,0)
    local moving=false
    local function set(x)
        local q=math.clamp((x-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
        local v=math.floor(min+(max-min)*q+.5)
        fill.Size=UDim2.new((v-min)/(max-min),0,1,0); val.Text=tostring(v); cb(v)
    end
    bar.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then moving=true; set(i.Position.X) end
    end)
    UIS.InputChanged:Connect(function(i)
        if moving and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then set(i.Position.X) end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then moving=false end
    end)
end

local function dropdown(p,text,options,default,cb)
    local f=Instance.new("Frame",p); f.Size=UDim2.new(1,0,0,55); f.BackgroundTransparency=1
    local l=Instance.new("TextLabel",f); l.Size=UDim2.new(1,0,0,20); l.BackgroundTransparency=1
    l.Font=Enum.Font.Gotham; l.Text=text; l.TextColor3=T.text; l.TextSize=12; l.TextXAlignment=Enum.TextXAlignment.Left
    local b=Instance.new("TextButton",f); b.Position=UDim2.fromOffset(0,24); b.Size=UDim2.new(1,0,0,28)
    b.BackgroundColor3=T.panel2; b.BorderSizePixel=0; b.Font=Enum.Font.Gotham
    b.Text="  "..default; b.TextColor3=T.text; b.TextSize=11; b.TextXAlignment=Enum.TextXAlignment.Left
    local c=Instance.new("UICorner",b); c.CornerRadius=UDim.new(0,4)
    local menu=Instance.new("Frame",f); menu.Position=UDim2.fromOffset(0,55); menu.Size=UDim2.new(1,0,0,#options*27)
    menu.BackgroundColor3=T.panel2; menu.BorderSizePixel=0; menu.Visible=false; menu.ZIndex=20
    for n,opt in ipairs(options) do
        local o=Instance.new("TextButton",menu); o.Position=UDim2.fromOffset(0,(n-1)*27); o.Size=UDim2.new(1,0,0,27)
        o.BackgroundTransparency=1; o.Font=Enum.Font.Gotham; o.Text="  "..opt; o.TextColor3=T.text; o.TextSize=11
        o.TextXAlignment=Enum.TextXAlignment.Left; o.ZIndex=21
        o.MouseButton1Click:Connect(function() b.Text="  "..opt; menu.Visible=false; cb(opt) end)
    end
    b.MouseButton1Click:Connect(function() menu.Visible=not menu.Visible end)
end

local function action(p,text,cb)
    local b=Instance.new("TextButton",p); b.Size=UDim2.new(1,0,0,32)
    b.BackgroundColor3=T.panel2; b.BorderSizePixel=0; b.Font=Enum.Font.Gotham
    b.Text=text; b.TextColor3=T.text; b.TextSize=11; b.AutoButtonColor=false
    local c=Instance.new("UICorner",b); c.CornerRadius=UDim.new(0,4)
    b.MouseButton1Click:Connect(cb)
end

local function keybind(p,text,default,cb)
    local b=Instance.new("TextButton",p); b.Size=UDim2.new(1,0,0,32)
    b.BackgroundColor3=T.panel2; b.BorderSizePixel=0; b.Font=Enum.Font.Gotham
    b.Text=text..": "..default.Name; b.TextColor3=T.text; b.TextSize=11; b.AutoButtonColor=false
    local c=Instance.new("UICorner",b); c.CornerRadius=UDim.new(0,4)
    b.MouseButton1Click:Connect(function()
        b.Text=text..": Press a key..."
        local con
        con=UIS.InputBegan:Connect(function(i,p)
            if not p and i.UserInputType==Enum.UserInputType.Keyboard then
                b.Text=text..": "..i.KeyCode.Name; cb(i.KeyCode); con:Disconnect()
            end
        end)
    end)
end

-- FOV
local circle=Instance.new("Frame",SG); circle.AnchorPoint=Vector2.new(.5,.5)
circle.BackgroundTransparency=1; circle.BorderSizePixel=0; circle.ZIndex=1
local cc=Instance.new("UICorner",circle); cc.CornerRadius=UDim.new(1,0)
local cs=Instance.new("UIStroke",circle); cs.Color=T.purple; cs.Transparency=.15

local function updateCircle()
    local v=camera.ViewportSize
    circle.Position=UDim2.fromOffset(v.X/2,v.Y/2)
    circle.Size=UDim2.fromOffset(S.Radius*2,S.Radius*2)
    circle.Visible=S.FOV and S.Visible
end

-- Targeting
local function valid(m)
    if not m or not m:IsA("Model") or m==player.Character then return false end
    local h=m:FindFirstChildOfClass("Humanoid")
    return h and h.Health>0 and m:FindFirstChild("HumanoidRootPart")
end

local function partOf(m)
    if S.Part=="Head" then return m:FindFirstChild("Head") or m:FindFirstChild("HumanoidRootPart") end
    return m:FindFirstChild("HumanoidRootPart")
end

local function visible(part)
    if not S.WallCheck then return true end
    local rp=RaycastParams.new()
    rp.FilterType=Enum.RaycastFilterType.Exclude
    rp.FilterDescendantsInstances={player.Character}
    local hit=workspace:Raycast(camera.CFrame.Position,part.Position-camera.CFrame.Position,rp)
    return not hit or hit.Instance:IsDescendantOf(part.Parent)
end

local function closest()
    local center=Vector2.new(camera.ViewportSize.X/2,camera.ViewportSize.Y/2)
    local best,bestD=nil,S.Radius
    for _,m in ipairs(targets:GetChildren()) do
        if valid(m) then
            local p=partOf(m)
            if p then
                local pos,on= camera:WorldToViewportPoint(p.Position)
                if on and visible(p) then
                    local d=(Vector2.new(pos.X,pos.Y)-center).Magnitude
                    if d<=bestD then best,bestD=p,d end
                end
            end
        end
    end
    return best
end

-- ESP
local esp={}
local function removeESP(m)
    if esp[m] then
        for _,x in pairs(esp[m]) do x:Destroy() end
        esp[m]=nil
    end
end
local function makeESP(m)
    if esp[m] or not valid(m) then return end
    local h=Instance.new("Highlight",SG); h.Adornee=m; h.FillColor=T.purple; h.FillTransparency=.82
    h.OutlineColor=T.light; h.OutlineTransparency=.15; h.Enabled=S.ESP
    local b=Instance.new("BillboardGui",SG); b.Adornee=m:FindFirstChild("Head") or m:FindFirstChild("HumanoidRootPart")
    b.Size=UDim2.fromOffset(180,40); b.StudsOffset=Vector3.new(0,2.7,0); b.AlwaysOnTop=true; b.Enabled=S.ESP
    local l=Instance.new("TextLabel",b); l.Size=UDim2.fromScale(1,1); l.BackgroundTransparency=1
    l.Font=Enum.Font.GothamBold; l.TextColor3=T.text; l.TextStrokeTransparency=.5; l.TextSize=11
    esp[m]={h=h,b=b,l=l}
end
local function updateESP()
    for m,d in pairs(esp) do
        if not valid(m) then removeESP(m) else
            d.h.Enabled=S.ESP; d.b.Enabled=S.ESP
            local r=m:FindFirstChild("HumanoidRootPart"); local my=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if r and my then
                local dist=math.floor((r.Position-my.Position).Magnitude)
                local text=S.Names and m.Name or ""
                if S.Distance then text=text..(text~="" and "  " or "").."["..dist.."m]" end
                d.l.Text=text
            end
        end
    end
    for _,m in ipairs(targets:GetChildren()) do makeESP(m) end
end

targets.ChildAdded:Connect(function(m) task.wait(); makeESP(m) end)
targets.ChildRemoved:Connect(removeESP)

-- Hitboxes
local original={}
local function hitboxes()
    for _,m in ipairs(targets:GetChildren()) do
        if valid(m) then
            local r=m:FindFirstChild("HumanoidRootPart")
            if r then
                original[m]=original[m] or {Size=r.Size,Transparency=r.Transparency}
                if S.Hitbox then
                    r.Size=Vector3.new(S.HitboxSize,S.HitboxSize,S.HitboxSize)
                    r.Transparency=S.HitboxTransparency
                else
                    r.Size=original[m].Size; r.Transparency=original[m].Transparency
                end
            end
        end
    end
end

-- Navigation
local current="Main"; local nav={}
local function navButton(name,y)
    local b=Instance.new("TextButton",side); b.Position=UDim2.fromOffset(8,y); b.Size=UDim2.new(1,-16,0,38)
    b.BackgroundColor3=name==current and T.panel2 or T.side; b.BorderSizePixel=0
    b.Font=Enum.Font.GothamMedium; b.Text="    "..name
    b.TextColor3=name==current and T.text or T.sub; b.TextSize=12; b.TextXAlignment=Enum.TextXAlignment.Left
    local c=Instance.new("UICorner",b); c.CornerRadius=UDim.new(0,5)
    local a=Instance.new("Frame",b); a.Position=UDim2.fromOffset(0,7); a.Size=UDim2.fromOffset(3,24)
    a.BackgroundColor3=T.purple; a.BorderSizePixel=0; a.Visible=name==current
    nav[name]={b=b,a=a}
    b.MouseButton1Click:Connect(function()
        current=name
        for n,p in pairs(pages) do p.Visible=n==name end
        for n,d in pairs(nav) do
            d.b.BackgroundColor3=n==name and T.panel2 or T.side
            d.b.TextColor3=n==name and T.text or T.sub; d.a.Visible=n==name
        end
    end)
end
navButton("Main",65); navButton("Visuals",108); navButton("Player",151); navButton("UI Settings",194)

-- Main
section(pages.Main,"Combat")
local ap=panel(pages.Main,285)
toggle(ap,"Aimbot / Camera Assist",S.Aim,function(v) S.Aim=v end)
toggle(ap,"FOV Circle",S.FOV,function(v) S.FOV=v end)
toggle(ap,"Wall Check",S.WallCheck,function(v) S.WallCheck=v end)
toggle(ap,"Lock To Center",S.LockCenter,function(v) S.LockCenter=v end)
slider(ap,"FOV Radius",50,400,S.Radius,function(v) S.Radius=v end)
slider(ap,"Smoothness",1,30,S.Smooth,function(v) S.Smooth=v end)
dropdown(ap,"Aim Target",{"Head","HumanoidRootPart"},S.Part,function(v) S.Part=v end)
keybind(ap,"Aim Key",S.AimKey,function(v) S.AimKey=v end)

section(pages.Main,"Test Targets")
local tp=panel(pages.Main,100)
action(tp,"Refresh Test Targets",function() updateESP(); hitboxes() end)
action(tp,"Reset Test Hitboxes",function() S.Hitbox=false; hitboxes() end)

-- Visuals
section(pages.Visuals,"Visuals")
local vp=panel(pages.Visuals,230)
toggle(vp,"ESP",S.ESP,function(v) S.ESP=v; updateESP() end)
toggle(vp,"Names",S.Names,function(v) S.Names=v end)
toggle(vp,"Distance",S.Distance,function(v) S.Distance=v end)
toggle(vp,"Hitbox Visualizer",S.Hitbox,function(v) S.Hitbox=v; hitboxes() end)
slider(vp,"Hitbox Size",2,30,S.HitboxSize,function(v) S.HitboxSize=v; hitboxes() end)
slider(vp,"Hitbox Transparency",0,100,55,function(v) S.HitboxTransparency=v/100; hitboxes() end)

-- Player
section(pages.Player,"Local Test Character")
local pp=panel(pages.Player,175)
toggle(pp,"Custom WalkSpeed",S.Walk,function(v)
    S.Walk=v; local h=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if h then h.WalkSpeed=v and S.WalkSpeed or 16 end
end)
slider(pp,"WalkSpeed",8,100,S.WalkSpeed,function(v)
    S.WalkSpeed=v; local h=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if h and S.Walk then h.WalkSpeed=v end
end)
toggle(pp,"Custom JumpPower",S.Jump,function(v)
    S.Jump=v; local h=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if h then h.UseJumpPower=true; h.JumpPower=v and S.JumpPower or 50 end
end)
slider(pp,"JumpPower",20,150,S.JumpPower,function(v)
    S.JumpPower=v; local h=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if h and S.Jump then h.UseJumpPower=true; h.JumpPower=v end
end)

-- UI
section(pages["UI Settings"],"Interface")
local up=panel(pages["UI Settings"],140)
keybind(up,"UI Toggle Key",S.UIKey,function(v) S.UIKey=v end)
action(up,"Reset UI Position",function() main.Position=UDim2.new(.5,-360,.5,-240) end)
action(up,"Hide UI",function() S.Visible=false; main.Visible=false end)

-- Search
search:GetPropertyChangedSignal("Text"):Connect(function()
    local q=string.lower(search.Text)
    if q=="" then return end
    for _,p in pairs(pages) do
        for _,x in ipairs(p:GetDescendants()) do
            if x:IsA("TextLabel") then
                x.TextTransparency=string.find(string.lower(x.Text),q,1,true) and 0 or .75
            end
        end
    end
end)

UIS.InputBegan:Connect(function(i,processed)
    if processed or i.UserInputType~=Enum.UserInputType.Keyboard then return end
    if i.KeyCode==S.AimKey then S.Holding=true end
    if i.KeyCode==S.UIKey then
        S.Visible=not S.Visible; main.Visible=S.Visible
    end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.Keyboard and i.KeyCode==S.AimKey then S.Holding=false end
end)

RunService:BindToRenderStep("VoidStudioAim",Enum.RenderPriority.Camera.Value+1,function(dt)
    updateCircle()
    if S.Aim and S.Holding then
        local p=closest()
        if p then
            local desired=CFrame.lookAt(camera.CFrame.Position,p.Position)
            camera.CFrame=camera.CFrame:Lerp(desired,math.clamp(S.Smooth*dt,0,1))
        end
    end
end)

task.spawn(function()
    while SG.Parent do
        updateESP(); hitboxes()
        local h=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if h then
            if S.Walk then h.WalkSpeed=S.WalkSpeed end
            if S.Jump then h.UseJumpPower=true; h.JumpPower=S.JumpPower end
        end
        task.wait(.2)
    end
end)

updateESP(); hitboxes(); updateCircle()
print("VoidHub loaded. Add NPC dummies to workspace.TestTargets.")

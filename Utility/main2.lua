local Utility = { Connections = {}, Old_Functions = {}, Rendered_Objects = {}; }

local LocalPlayer = game:GetService("Players").LocalPlayer
local DebrisService = game:GetService('Debris');
local TweenService = game:GetService('TweenService');
Utility.Client = getsenv(LocalPlayer.PlayerGui.Client)

function Utility:Create_Beam(From: Vector3?|CFrame?, To: Vector3?|CFrame?, Lifetime: number, Transparency: number, Color: Color3?, Thickness: number?, Texture: string?|number?, LightEmission: number?, FaceCamera: boolean?): Beam?
    coroutine.wrap(function()
        Color = ColorSequence.new(Color) or ColorSequence.new(Color3.fromRGB(255, 255, 255))
    
    
        local Part_1 = Instance.new("Part", workspace.Ray_Ignore)
        local Part_2 = Instance.new("Part", workspace.Ray_Ignore)
    
        local Beam = Instance.new("Beam", Part_1)
    
        local A1 = Instance.new("Attachment", Part_1)
        local A2 = Instance.new("Attachment", Part_2)
    
        Part_1.Transparency = 1
        Part_2.Transparency = 1
    
        Part_1.Position = typeof(From) == "Vector3" and From or From.Position
        Part_2.Position = typeof(To) == "Vector3" and To or To.Position
    
        Part_1.CanCollide = false
        Part_2.CanCollide = false
    
        Part_1.Anchored = true
        Part_2.Anchored = true
    
        Beam.Color = Color
        Beam.Texture = typeof(Texture) == "string" and Texture or "rbxassetid://".. tostring(Texture)
        Beam.LightEmission = LightEmission
        Beam.LightInfluence = 0
        Beam.FaceCamera = FaceCamera or false
        Beam.Transparency = NumberSequence.new(Transparency)
        Beam.Width0 = Thickness
        Beam.Width1 = Thickness
        Beam.Attachment0 = A1
        Beam.Attachment1 = A2

        DebrisService:AddItem(Part_1, Lifetime)
        DebrisService:AddItem(Part_2, Lifetime)
    end)()
end

function Utility:Is_Alive(Player: Player): Instance
    if not Player then Player = LocalPlayer end
    return Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character.Humanoid.Health > 0
end

function Utility:Get_Gun(Player: Player)
    if not Player then return Utility.Client.gun end
    return Utility:Is_Alive(Player) and Player.Character:FindFirstChild("EquippedTool") or ""
end 

function Utility:Encode(Position: Vector3)
    return Vector3.new(((Position.X - 74312) * 4 + 1325) * 13, (Position.Y + 3183421) * 4 - 4201432, (Position.Z * 41 - 581357) * 2);
end

function Utility:Create_Drag(GUI: Frame)
    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        TS:Create(gui, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}):Play();
    end

    local lastEnd = 0
    local lastMoved = 0
    local con
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)


    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
            lastMoved = os.clock()
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

function Utility:Create_Instance(ClassName: string, Properties: table)
    local New_Instance = Instance.new(ClassName)

    for i,v in next, Properties do
        if typeof(i) ~= "string" then continue end;  
        
        New_Instance[i] = v
    end

    return New_Instance
end

function Utility:Team_Check(Player_1)
    return Player_1.Team ~= LocalPlayer.Team
end

function Utility:Connect(Signal, Func)
    local Connection = Signal:Connect(Func)
    
    return table.insert(Utility.Connections, Connection)
end

function Utility:Draw(Type: string, Args: table)
    local New_Drawing = Drawing.new(Type);

    for i,v in next, Args do
        New_Drawing[i] = v
    end

    table.insert(New_Drawing, Utility.Rendered_Objects)
    
    return New_Drawing
end

-- // Notification System
local Notification = Utility:Create_Instance("ScreenGui", {
    Name = "Notification",
    Parent = gethui(),
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
})

local NotificationHolder = Utility:Create_Instance("Frame", {
    Name = "NotificationHolder",
    Position = UDim2.new(0.018, 0, 0.092, 0),
    Size = UDim2.new(0, 219, 0, 629),
    Parent = Notification,
    BackgroundTransparency = 1,
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BorderSizePixel = 0,
    ZIndex = 500
})

Utility:Create_Instance("UIListLayout", {
    Parent = NotificationHolder,
    Padding = UDim.new(0, 6),
    FillDirection = Enum.FillDirection.Vertical,
    HorizontalAlignment = Enum.HorizontalAlignment.Left,
    VerticalAlignment = Enum.VerticalAlignment.Top,
    SortOrder = Enum.SortOrder.LayoutOrder
})

function Utility:Create_Notification(Text: string, Duration: number)
    local New_Notification = Utility:Create_Instance("Frame", {
        Name = "NotificationSample",
        Size = UDim2.new(0, 204, 0, 46),
        Parent = NotificationHolder,
        BackgroundColor3 = Color3.fromRGB(14, 14, 14),
        BorderSizePixel = 0,
        ZIndex = 501
    })

    Utility:Create_Instance("UIStroke", {
        Parent = New_Notification,
        Color = Color3.fromRGB(26, 26, 26),
        Thickness = 1.6,
        Transparency = 0
    })

    local NotificationFrame = Utility:Create_Instance("Frame", {
        Name = "NotificationFrame",
        Position = UDim2.new(0.02, 0, 0.1, 0),
        Size = UDim2.new(1, -4, 1, -8),
        Parent = New_Notification,
        BackgroundColor3 = Color3.fromRGB(21, 21, 21),
        BorderSizePixel = 0,
        ZIndex = 502
    })

    Utility:Create_Instance("UIStroke", {
        Parent = NotificationFrame,
        Color = Color3.fromRGB(21, 21, 21),
        Thickness = 1,
        Transparency = 0
    })

    local TextLabel = Utility:Create_Instance("TextLabel", {
        Name = "TextLabel",
        Size = UDim2.new(1, 0, 1, 0),
        Parent = NotificationFrame,
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Text = Text,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
        TextColor3 = Color3.fromRGB(178, 178, 178),
        TextSize = 14,
        BorderSizePixel = 0,
        ZIndex = 503
    })

    local Timer = Utility:Create_Instance("Frame", {
        Name = "Timer",
        Position = UDim2.new(0, 0, 1, 0),
        Size = UDim2.new(1, 0, 0, 1),
        Parent = New_Notification,
        BackgroundColor3 = Color3.fromRGB(79, 116, 171),
        BorderSizePixel = 0,
        ZIndex = 504
    })

    task.wait()

    -- TextLabel.Size = UDim2.new(0, TextLabel.TextBounds.X, 1, 0)
    -- Timer.Size = UDim2.new(1, -TextLabel.TextBounds.X, 0, 1)
    -- NotificationFrame.Size = UDim2.new(1, TextLabel.TextBounds.X + 4, 1, -8)
    -- New_Notification.Size = UDim2.new(0, TextLabel.TextBounds.X + 204, 0, 46)

    local TimerTween = TweenService:Create(Timer, TweenInfo.new(Duration, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 1)})
    TimerTween:Play()

    TimerTween.Completed:Connect(function()
        New_Notification:Destroy()
    end)
end


Utility.Gun_Settings = {
    ["Glock"] = {
        MinDamage = 21,
        OverrideActive = false,
        MinDamageOverride = 0
    },
    ["DualBerettas"] = {
        MinDamage = 13,
        OverrideActive = false,
        MinDamageOverride = 0
    },
    ["P250"] = {
        MinDamage = 54,
        OverrideActive = false,
        MinDamageOverride = 0
    },
    ["Tec9"] = {
        MinDamage = 75,
        OverrideActive = false,
        MinDamageOverride = 0
    },
    ["USP"] = {
        MinDamage = 55,
        OverrideActive = false,
        MinDamageOverride = 0
    },
    ["P2000"] = {
        MinDamage = 55,
        OverrideActive = false,
        MinDamageOverride = 0
    },
    ["CZ"] = {
        MinDamage = 25,
        OverrideActive = false,
        MinDamageOverride = 0
    },
    ["FiveSeven"] = {
        MinDamage = 54,
        OverrideActive = false,
        MinDamageOverride = 0
    },
    ["R8"] = {
        MinDamage = 0,
        OverrideActive = false,
        MinDamageOverride = 0
    },
    ["DesertEagle"] = {
        MinDamage = 89,
        OverrideActive = false,
        MinDamageOverride = 0
    },
    ["Nova"] = {
        MinDamage = 32,
        OverrideActive = false,
        MinDamageOverride = 0
    },
    ["XM"] = {
        MinDamage = 0,
        OverrideActive = false,
        MinDamageOverride = 0
    },
    ["SawedOff"] = {
        MinDamage = 44,
        OverrideActive = false,
        MinDamageOverride = 0
    },
    ["MAG7"] = {
        MinDamage = 0,
        OverrideActive = false,
        MinDamageOverride = 0
    },
    ["M4A4"] = {
        MinDamage = 0,
        OverrideActive = false,
        MinDamageOverride = 0
    },
    ["M4A1"] = {
        MinDamage = 0,
        OverrideActive = false,
        MinDamageOverride = 0
    },
    ["AK47"] = {
        MinDamage = 34,
        OverrideActive = false,
        MinDamageOverride = 0
    },
    ["Famas"] = {
        MinDamage = 0,
        OverrideActive = false,
        MinDamageOverride = 0
    },
    ["Galil"] = {
        MinDamage = 0,
        OverrideActive = false,
        MinDamageOverride = 0
    },
    ["AUG"] = {
        MinDamage = 0,
        OverrideActive = false,
        MinDamageOverride = 0
    },
    ["SG"] = {
        MinDamage = 0,
        OverrideActive = false,
        MinDamageOverride = 0
    },
    ["Negev"] = {
        MinDamage = 0,
        OverrideActive = false,
        MinDamageOverride = 0
    },
    ["M249"] = {
        MinDamage = 0,
        OverrideActive = false,
        MinDamageOverride = 0
    },
    ["MP9"] = {
        MinDamage = 0,
        OverrideActive = false,
        MinDamageOverride = 0
    },
    ["MAC10"] = {
        MinDamage = 0,
        OverrideActive = false,
        MinDamageOverride = 0
    },
    ["MP7"] = {
        MinDamage = 0,
        OverrideActive = false,
        MinDamageOverride = 0
    },
    ["MP7-SD"] = {
        MinDamage = 0,
        OverrideActive = false,
        MinDamageOverride = 0
    },
    ["UMP"] = {
        MinDamage = 0,
        OverrideActive = false,
        MinDamageOverride = 0
    },
    ["P90"] = {
        MinDamage = 0,
        OverrideActive = false,
        MinDamageOverride = 0
    },
    ["Bizon"] = {
        MinDamage = 0,
        OverrideActive = false,
        MinDamageOverride = 0
    },
    ["Scout"] = {
        MinDamage = 101,
        OverrideActive = false,
        MinDamageOverride = 0
    },
    ["AWP"] = {
        MinDamage = 101,
        OverrideActive = false,
        MinDamageOverride = 0
    },
    ["G3SG1"] = {
        MinDamage = 54,
        OverrideActive = false,
        MinDamageOverride = 0
    }
}

--Utility:Create_Notification("This is a really fucking long message that is only20characters haha", 5)
return Utility;

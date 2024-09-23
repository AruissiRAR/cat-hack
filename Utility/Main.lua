local Utility = { Connections = {}, Old_Functions = {} }

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


-- // Notification System

local Notfication = Utility:Create_Instance("ScreenGui", {
    Name = "Notification",
    Parent = game.Players.LocalPlayer.PlayerGui,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
})

local NotificationHolder = Utility:Create_Instance("Frame", {
    Name = "NotificationHolder",
    Position = UDim2.new(0.018, 0.000, 0.092, 0.000),
    Size = UDim2.new(0.000, 219.000, 0.000, 629.000),
    Parent = Notfication,
    BackgroundTransparency = 1,
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BorderSizePixel = 0,
    ZIndex = 1
})

Utility:Create_Instance("UIListLayout", {
    Parent = NotificationHolder,
    Padding = UDim.new(0, 6),
    FillDirection = Enum.FillDirection.Vertical,
    HorizontalAlignment = Enum.HorizontalAlignment.Left,
    VerticalAlignment = Enum.VerticalAlignment.Top,
    SortOrder = Enum.SortOrder.LayoutOrder
})



function Create_Notification(Text: string, Duration: number)
	local New_Notification = Utility:Create_Instance("Frame", {
		Name = "NotificationSample",
		Position = UDim2.new(0.000, 0.000, 0.000, 0.000),
		Size = UDim2.new(0.000, 204.000, 0.000, 46.000),
		Parent = NotificationHolder,
		BackgroundColor3 = Color3.fromRGB(14, 14, 14),
		BorderSizePixel = 0,
		ZIndex = 1
	})

	Utility:Create_Instance("UIStroke", {
		Parent = New_Notification,
		Color = Color3.fromRGB(26, 26, 26),
		Thickness = 1.600000023841858,
		Transparency = 0
	})

	local NotificationFrame = Utility:Create_Instance("Frame", {
		Name = "NotificationFrame",
		Position = UDim2.new(0.020, 0.000, 0.087, 0.000),
		Size = UDim2.new(0.000, 196.000, 0.000, 38.000),
		Parent = New_Notification,
		BackgroundColor3 = Color3.fromRGB(21, 21, 21),
		BorderSizePixel = 0,
		ZIndex = 1
	})

	Utility:Create_Instance("UIStroke", {
		Parent = NotificationFrame,
		Color = Color3.fromRGB(21, 21, 21),
		Thickness = 1,
		Transparency = 0
	})

	Utility:Create_Instance("TextLabel", {
		Name = "TextLabel",
		Position = UDim2.new(-0.020, 0.000, 0.105, 0.000),
		Size = UDim2.new(0.000, 200.000, 0.000, 30.000),
		Parent = NotificationFrame,
		BackgroundTransparency = 1,
		Font = Enum.Font.SourceSans,
		Text = Text,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextColor3 = Color3.fromRGB(178, 178, 178),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 14,
		BorderSizePixel = 0,
		ZIndex = 1
	})

	local Timer = Utility:Create_Instance("Frame", {
		Name = "Timer",
		Position = UDim2.new(0.000, 0.000, 1.000, 0.000),
		Size = UDim2.new(0.000, 204.000, 0.000, 1.000),
		Parent = New_Notification,
		BackgroundColor3 = Color3.fromRGB(79, 116, 171),
		BorderSizePixel = 0,
		ZIndex = 1
	})

	local TimerTween = TweenService:Create(Timer, TweenInfo.new(Duration, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 1)})
	TimerTween:Play()


	TimerTween.Completed:Connect(function()	
		New_Notification:Destroy()
	end)
end

return Utility;

local Utility = {}

local LocalPlayer = game:GetService("Players").LocalPlayer
Utility.Client = getsenv(LocalPlayer.PlayerGui.Client)

function Utility:Create_Beam(From: Vector3?|CFrame?, To: Vector3?|CFrame?, Lifetime: number, Transparency: number, Color: Color3?, Thickness: number?, Texture: string?|number?, LightEmission: number?, FaceCamera: boolean?): Beam?
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
    Beam.FaceCamera = FaceCamera
    Beam.Transparency = NumberSequence.new(Transparency)
    Beam.Width0 = Thickness
    Beam.Width1 = Thickness
    Beam.Attachment0 = A1
    Beam.Attachment1 = A2

    task.wait(Lifetime)

    coroutine.wrap(function()
        for i=Transparency, 1.05, 0.05 do task.wait()
            Beam.Transparency = NumberSequence.new(i)
        end

        Part_1:Destroy()
        Part_2:Destroy()
    end)
end

function Utility:Is_Alive(Player: Player): Instance
    if not Player then Player = LocalPlayer end
    return Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character.Humanoid.Health > 0
end

function Utility:Get_Gun(Player: Player)
    if not Player then return Utility.Client.gun end
    return Utility:Is_Alive(Player) and Player.Character:FindFirstChild("EquippedTool") or ""
end 

function Utility:Team_Check(Player_1)
    return Player_1.Team ~= LocalPlayer.Team
end

return Utility;

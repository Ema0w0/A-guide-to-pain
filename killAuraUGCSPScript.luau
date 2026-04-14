-- Seachers for player and hooks when found. Same with server.
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Create a GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KillAuraGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 200, 0, 120)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -60)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-----------
-- Title --
-----------
-- Title Bar (Rectangle)
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 20)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame
-- Title Text
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, 100, 1, 0)
Title.Position = UDim2.new(0, 5, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Kill Aura"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.SourceSans
Title.TextSize = 14
Title.Parent = TitleBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 20, 1, 0)
CloseButton.Position = UDim2.new(1, -20, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.SourceSans
CloseButton.TextSize = 14
CloseButton.Parent = TitleBar

-- Minimise Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 20, 1, 0)
MinimizeButton.Position = UDim2.new(1, -40, 0, 0)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(200, 200, 50)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Text = "_"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Font = Enum.Font.SourceSans
MinimizeButton.TextSize = 14
MinimizeButton.Parent = TitleBar

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, 0, 1, -20)
ContentFrame.Position = UDim2.new(0, 0, 0, 20)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Visible = true
ContentFrame.Parent = MainFrame

-- Aura Button
local KillAuraButton = Instance.new("TextButton")
KillAuraButton.Name = "KillAuraButton"
KillAuraButton.Size = UDim2.new(0.8, 0, 0, 30)
KillAuraButton.Position = UDim2.new(0.1, 0, 0.2, 0)
KillAuraButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
KillAuraButton.BorderSizePixel = 0
KillAuraButton.Text = "Kill Aura"
KillAuraButton.TextColor3 = Color3.fromRGB(255, 255, 255)
KillAuraButton.Font = Enum.Font.SourceSans
KillAuraButton.TextSize = 14
KillAuraButton.Parent = ContentFrame

-- Credit Label
local CreditLabel = Instance.new("TextLabel")
CreditLabel.Name = "CreditLabel"
CreditLabel.Size = UDim2.new(0.8, 0, 0, 20)
CreditLabel.Position = UDim2.new(0.1, 0, 0.6, 0)
CreditLabel.BackgroundTransparency = 1
CreditLabel.Text = "Created by You"
CreditLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
CreditLabel.Font = Enum.Font.SourceSans
CreditLabel.TextSize = 14
CreditLabel.Parent = ContentFrame

-- Variables for Aura
local KillAuraEnabled = false
local RangePart = nil
local HeartbeatConnection = nil
local Range = 50 -- Range (in stud)

-- Variable for rotation
local BodyAngularVelocity = nil
local SpinSpeed = 50 -- Rotation speed (rad/s, can be adjusted)

-- GUI close function
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Minimization function
local Minimized = false
local OriginalSize = MainFrame.Size
MinimizeButton.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    if Minimized then
        MainFrame.Size = UDim2.new(OriginalSize.X.Scale, OriginalSize.X.Offset, 0, 20)
        ContentFrame.Visible = false
    else
        MainFrame.Size = OriginalSize
        ContentFrame.Visible = true
    end
end)

-- Kill Aura and rotation enable function
local function EnableKillAura()
    -- Create a part to visualize the radius
    RangePart = Instance.new("Part")
    RangePart.Name = "KillAuraRange"
    RangePart.Shape = Enum.PartType.Ball
    RangePart.Size = Vector3.new(Range * 2, Range * 2, Range * 2)
    RangePart.Anchored = true
    RangePart.CanCollide = false
    RangePart.Transparency = 0.9
    RangePart.Material = Enum.Material.Neon
    RangePart.Color = Color3.fromRGB(0, 255, 255)
    RangePart.Parent = workspace

    -- Adding character rotation
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        BodyAngularVelocity = Instance.new("BodyAngularVelocity")
        BodyAngularVelocity.Name = "SpinVelocity"
        BodyAngularVelocity.MaxTorque = Vector3.new(0, math.huge, 0) -- Rotation only around the Y axis
        BodyAngularVelocity.AngularVelocity = Vector3.new(0, SpinSpeed, 0) -- Rotation speed
        BodyAngularVelocity.Parent = LocalPlayer.Character.HumanoidRootPart
    end

    -- Update the unit's position and attack
    HeartbeatConnection = RunService.Heartbeat:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            -- Updating the part's position
            RangePart.Position = LocalPlayer.Character.HumanoidRootPart.Position

            -- Finding a tool
            local Tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if Tool and Tool:FindFirstChild("Handle") then
                -- We check the parts within the radius
                local PartsInRange = workspace:GetPartsInPart(RangePart)
                for _, Part in ipairs(PartsInRange) do
                    if Part.Parent and Part.Parent ~= LocalPlayer.Character and Part.Parent:FindFirstChildOfClass("Humanoid") then
                        -- Activate the tool and simulate touching
                        Tool:Activate()
                        pcall(function()
                            firetouchinterest(Tool.Handle, Part, 0)
                            firetouchinterest(Tool.Handle, Part, 1)
                        end)
                    end
                end
            end
        end
    end)
end

-- Kill Aura and rotation disable function
local function DisableKillAura()
    if HeartbeatConnection then
        HeartbeatConnection:Disconnect()
        HeartbeatConnection = nil
    end
    if RangePart then
        RangePart:Destroy()
        RangePart = nil
    end
    if BodyAngularVelocity then
        BodyAngularVelocity:Destroy()
        BodyAngularVelocity = nil
    end
end

-- Kill Aura button handler
KillAuraButton.MouseButton1Click:Connect(function()
    KillAuraEnabled = not KillAuraEnabled
    if KillAuraEnabled then
        KillAuraButton.Text = " (ON)"
        KillAuraButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        EnableKillAura()
    else
        KillAuraButton.Text = "Kill Aura"
        KillAuraButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        DisableKillAura()
    end
end)

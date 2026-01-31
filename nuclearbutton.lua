local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

--------------------------------------------------
-- SLIM STAND
--------------------------------------------------
local stand = Instance.new("Part")
stand.Size = Vector3.new(2, 8, 2) -- slim and tall
stand.Position = char.HumanoidRootPart.Position + Vector3.new(0, 4, 0)
stand.Anchored = true
stand.Material = Enum.Material.Metal
stand.Color = Color3.fromRGB(40,40,40)
stand.Name = "Stand"
stand.Parent = workspace

--------------------------------------------------
-- BUTTON (short cylinder)
--------------------------------------------------
local button = Instance.new("Part")
button.Shape = Enum.PartType.Cylinder
button.Size = Vector3.new(2, 1, 2) -- short cylinder
button.Position = stand.Position + Vector3.new(0, 4.5, 0)
button.Orientation = Vector3.new(0,0,90) -- lay cylinder flat on top
button.Anchored = true
button.Material = Enum.Material.Neon
button.Color = Color3.fromRGB(255, 0, 0)
button.Name = "RedButton"
button.Parent = workspace

local click = Instance.new("ClickDetector")
click.MaxActivationDistance = 32
click.Parent = button

--------------------------------------------------
-- BUTTON AMBIENCE
--------------------------------------------------
local ambience = Instance.new("Sound")
ambience.SoundId = "rbxassetid://132518046426639"
ambience.Looped = true
ambience.Volume = 2
ambience.Parent = button
ambience:Play()

--------------------------------------------------
-- BLUR EFFECT (disabled initially)
--------------------------------------------------
local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = Lighting

--------------------------------------------------
-- CLICK FUNCTION
--------------------------------------------------
click.MouseClick:Connect(function()
	-- destroy button
	button:Destroy()

	local buttonPos = stand.Position + Vector3.new(0, 4.5, 0) -- pivot center

	-- First sound
	local s1 = Instance.new("Sound")
	s1.SoundId = "rbxassetid://9081625499"
	s1.Volume = 5
	s1.Parent = workspace
	s1:Play()

	task.wait(11)

	-- Second sound
	local s2 = Instance.new("Sound")
	s2.SoundId = "rbxassetid://1391727615"
	s2.Volume = 10
	s2.Parent = workspace
	s2:Play()

	--------------------------------------------------
	-- GIANT SPHERES (pivot at button)
	--------------------------------------------------
	local yellowSphere = Instance.new("Part")
	yellowSphere.Shape = Enum.PartType.Ball
	yellowSphere.Size = Vector3.new(1000,1000,1000)
	yellowSphere.Position = buttonPos
	yellowSphere.Anchored = true
	yellowSphere.Material = Enum.Material.Neon
	yellowSphere.Color = Color3.fromRGB(255, 255, 0)
	yellowSphere.CanCollide = false
	yellowSphere.Parent = workspace

	local whiteSphere = Instance.new("Part")
	whiteSphere.Shape = Enum.PartType.Ball
	whiteSphere.Size = Vector3.new(1200,1200,1200)
	whiteSphere.Position = buttonPos
	whiteSphere.Anchored = true
	whiteSphere.Material = Enum.Material.Neon
	whiteSphere.Color = Color3.fromRGB(255,255,255)
	whiteSphere.Transparency = 0.6
	whiteSphere.CanCollide = false
	whiteSphere.Parent = workspace

	--------------------------------------------------
	-- POINT LIGHT
	--------------------------------------------------
	local light = Instance.new("PointLight")
	light.Range = 999999999
	light.Brightness = 99999999999
	light.Color = Color3.new(1,1,1)
	light.Parent = whiteSphere

	--------------------------------------------------
	-- SPHERES ROTATION (around button pivot)
	--------------------------------------------------
	local startTime = tick()
	local duration = 60 -- despawn after 60 seconds

	local connection
	connection = RunService.Heartbeat:Connect(function(deltaTime)
		local t = tick() - startTime
		if t >= duration then
			yellowSphere:Destroy()
			whiteSphere:Destroy()
			connection:Disconnect()
			return
		end

		-- rotate spheres
		yellowSphere.CFrame = CFrame.new(buttonPos) * CFrame.Angles(0, t, 0)
		whiteSphere.CFrame = CFrame.new(buttonPos) * CFrame.Angles(t/2, t/2, 0)

		-- KILL EVERYTHING INSIDE SPHERES
		for _, obj in pairs(workspace:GetDescendants()) do
			if obj:IsA("Model") and obj:FindFirstChild("Humanoid") then
				local root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")
				if root then
					local dist = (root.Position - buttonPos).Magnitude
					if dist <= whiteSphere.Size.X/2 then
						obj:BreakJoints() -- insta kill
					end
				end
			end
		end
	end)

	--------------------------------------------------
	-- BLUR GO BRRR
	--------------------------------------------------
	for i = 0, 56, 2 do
		blur.Size = i
		task.wait(0.03)
	end
end)

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Create the ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ScavengerTeleporter"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Create the Button / Progress Display
local actionButton = Instance.new("TextButton")
actionButton.Size = UDim2.new(0, 250, 0, 60)
actionButton.Position = UDim2.new(0.5, -125, 0.9, -80)
actionButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
actionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
actionButton.Font = Enum.Font.GothamBold
actionButton.TextScaled = true
actionButton.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = actionButton

-- Locate the folder and get all targets
local devModules = workspace:WaitForChild("DevModules", 5)
local scavengerHuntFolder = devModules and devModules:WaitForChild("ScavengerHunt", 5)

local targets = {}
if scavengerHuntFolder then
	targets = scavengerHuntFolder:GetChildren()
end

local totalTargets = #targets
local currentIndex = 1

if totalTargets == 0 then
	actionButton.Text = "Folder empty/not found!"
	actionButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
else
	actionButton.Text = "Start Scavenging (0/" .. totalTargets .. ")"
end

-- Handle Click Event
actionButton.MouseButton1Click:Connect(function()
	if totalTargets == 0 then return end -- Do nothing if folder is empty
	
	if currentIndex > totalTargets then
		actionButton.Text = "Finished all " .. totalTargets .. "!"
		actionButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
		task.wait(2)
		screenGui:Destroy()
		return
	end

	local character = player.Character or player.CharacterAdded:Wait()
	local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

	-- Get the current target from our list
	local targetInstance = targets[currentIndex]

	if targetInstance then
		local targetCFrame
		
		-- Figure out if it's a Model or a Part and get its position
		if targetInstance:IsA("Model") then
			targetCFrame = targetInstance:GetPivot()
		elseif targetInstance:IsA("BasePart") then
			targetCFrame = targetInstance.CFrame
		end

		-- Teleport player slightly above it
		if targetCFrame then
			humanoidRootPart.CFrame = targetCFrame + Vector3.new(0, 4, 0)
			actionButton.Text = "Got: " .. targetInstance.Name .. "\n(" .. currentIndex .. " / " .. totalTargets .. ")"
		else
			actionButton.Text = "Skipped invalid object\n(" .. currentIndex .. " / " .. totalTargets .. ")"
		end
	end
	
	currentIndex += 1
end)

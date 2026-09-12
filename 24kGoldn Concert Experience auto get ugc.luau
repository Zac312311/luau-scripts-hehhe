local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Create gui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportProgressTracker"
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
actionButton.Text = "Start Teleporting (0/24)"
actionButton.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = actionButton

-- Variables for trackingg
local currentTarget = 1
local maxTargets = 24

-- Handle Click Event
actionButton.MouseButton1Click:Connect(function()
	if currentTarget > maxTargets then
		actionButton.Text = "Finished all 24!"
		actionButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
		task.wait(2)
		screenGui:Destroy()
		return
	end

	local character = player.Character or player.CharacterAdded:Wait()
	local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

	local targetName = tostring(currentTarget)
	
	-- UPDATED: Look for the specific "Workspace" folder/model inside the main workspace
	local customWorkspace = workspace:FindFirstChild("Workspace")
	local targetInstance = customWorkspace and customWorkspace:FindFirstChild(targetName)

	if targetInstance then
		local targetCFrame
		
		if targetInstance:IsA("Model") then
			targetCFrame = targetInstance:GetPivot()
		elseif targetInstance:IsA("BasePart") then
			targetCFrame = targetInstance.CFrame
		end

		if targetCFrame then
			humanoidRootPart.CFrame = targetCFrame + Vector3.new(0, 4, 0)
		end

		actionButton.Text = "Progress: " .. currentTarget .. " / 24\n(Click for next)"
	else
		warn("Could not find a model/part named: " .. targetName .. " inside workspace.Workspace")
		actionButton.Text = "Missing '" .. targetName .. "'\n(Click to skip)"
	end
	
	currentTarget += 1
end)

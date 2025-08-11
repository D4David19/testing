local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local isAutoClaimOn = false

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoClaimGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 150, 0, 50)
toggleButton.Position = UDim2.new(0.5, -75, 0.3, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(211, 47, 47) -- red = off
toggleButton.Text = "AutoClaim: OFF"
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.TextScaled = true
toggleButton.Parent = screenGui

-- Dragging variables
local dragging = false
local dragInput
local dragStart
local startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    toggleButton.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

toggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = toggleButton.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

toggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)

-- Toggle AutoClaim On/Off
toggleButton.MouseButton1Click:Connect(function()
    isAutoClaimOn = not isAutoClaimOn
    if isAutoClaimOn then
        toggleButton.Text = "AutoClaim: ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(76, 175, 80) -- green = on
    else
        toggleButton.Text = "AutoClaim: OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(211, 47, 47) -- red = off
    end
end)

-- AutoClaim loop
spawn(function()
    while true do
        wait(0.5)
        if isAutoClaimOn then
            ReplicatedStorage.RestartRemotes.Loader:FireServer()
        end
    end
end)

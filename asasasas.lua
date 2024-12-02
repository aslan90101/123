-- GUI Script with Rainbow Background and Auto Jump
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoJumpGUI"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Create Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 200, 0, 100)
mainFrame.Position = UDim2.new(0.8, 0, 0.1, 0)
mainFrame.BackgroundTransparency = 0.2
mainFrame.Parent = screenGui

-- Create Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0.8, 0, 0.4, 0)
toggleButton.Position = UDim2.new(0.1, 0, 0.3, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = "Auto Jump: OFF"
toggleButton.Parent = mainFrame

-- Create Keybind Text
local keybindText = Instance.new("TextLabel")
keybindText.Name = "KeybindText"
keybindText.Size = UDim2.new(0.8, 0, 0.2, 0)
keybindText.Position = UDim2.new(0.1, 0, 0.8, 0)
keybindText.BackgroundTransparency = 1
keybindText.Text = "Press K to change keybind"
keybindText.TextColor3 = Color3.fromRGB(255, 255, 255)
keybindText.Parent = mainFrame

-- Variables
local autoJumpEnabled = false
local toggleKey = Enum.KeyCode.Z -- Default key
local changingKeybind = false
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Rainbow background effect
spawn(function()
    while wait() do
        for i = 0, 1, 0.001 do
            mainFrame.BackgroundColor3 = Color3.fromHSV(i, 1, 1)
            wait()
        end
    end
end)

-- Toggle Auto Jump function
local function toggleAutoJump()
    autoJumpEnabled = not autoJumpEnabled
    toggleButton.Text = "Auto Jump: " .. (autoJumpEnabled and "ON" or "OFF")
    
    if autoJumpEnabled then
        spawn(function()
            while autoJumpEnabled do
                wait()
                if humanoid and humanoid.FloorMaterial ~= Enum.Material.Air then
                    humanoid.Jump = true
                end
            end
        end)
    end
end

-- Handle key press
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if changingKeybind then
        toggleKey = input.KeyCode
        keybindText.Text = "Toggle Key: " .. tostring(toggleKey)
        changingKeybind = false
        return
    end
    
    if input.KeyCode == Enum.KeyCode.K then
        changingKeybind = true
        keybindText.Text = "Press any key..."
    elseif input.KeyCode == toggleKey then
        toggleAutoJump()
    end
end)

-- Connect button
toggleButton.MouseButton1Click:Connect(toggleAutoJump)

-- Handle character respawn
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
end)

-- Make GUI draggable
local dragging
local dragStart
local startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        updateDrag(input)
    end
end)

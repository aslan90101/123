local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/Undebolted/FTAP/refs/heads/main/OrionLib.lua')))()
local Window = OrionLib:MakeWindow({Name = "BHop Script", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})

--Main Tab
local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

--Variables
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

--BHop Toggle
local BHopEnabled = false
local BHopKeybind = Enum.KeyCode.F

MainTab:AddToggle({
    Name = "BHop",
    Default = false,
    Save = true,
    Flag = "bhopToggle",
    Callback = function(Value)
        BHopEnabled = Value
    end    
})

--Keybind Setting
MainTab:AddBind({
    Name = "BHop Keybind",
    Default = Enum.KeyCode.F,
    Hold = false,
    Save = true,
    Flag = "bhopBind",
    Callback = function()
        BHopEnabled = not BHopEnabled
        OrionLib:MakeNotification({
            Name = "BHop",
            Content = BHopEnabled and "Enabled" or "Disabled",
            Image = "rbxassetid://4483345998",
            Time = 2
        })
    end    
})

--BHop Function
RunService.Heartbeat:Connect(function()
    if BHopEnabled then
        local ray = Ray.new(HumanoidRootPart.Position, Vector3.new(0, -4, 0))
        local part = workspace:FindPartOnRay(ray, Player.Character)
            
        if part then
            Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

--Character Respawn Handler
Player.CharacterAdded:Connect(function(NewCharacter)
    Character = NewCharacter
    Humanoid = Character:WaitForChild("Humanoid")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
end)

OrionLib:Init()

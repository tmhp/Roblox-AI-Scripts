local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "WallhackGui"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
MainFrame.Size = UDim2.new(0, 300, 0, 400) 
MainFrame.Active = true
MainFrame.Draggable = true

-- Create a title label (separate from MainFrame)
local TitleLabel = Instance.new("TextLabel", ScreenGui) 
TitleLabel.Name = "TitleLabel"
TitleLabel.Text = "Wallhack Menu"
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 24
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0.5, 0, 0.2, 0) -- Position above MainFrame
TitleLabel.Size = UDim2.new(1, -20, 0, 30)

-- Open/Close Button
local OpenCloseButton = Instance.new("TextButton", MainFrame)
OpenCloseButton.Name = "OpenCloseButton"
OpenCloseButton.Text = "-"
OpenCloseButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
OpenCloseButton.Size = UDim2.new(0, 20, 0, 20)
OpenCloseButton.Position = UDim2.new(1, -25, 0, 5)

-- Wallhack Toggle Button
local WallhackToggle = Instance.new("TextButton", MainFrame)
WallhackToggle.Name = "WallhackToggle"
WallhackToggle.Text = "Wallhack: Off"
WallhackToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
WallhackToggle.Size = UDim2.new(0, 150, 0, 30)
WallhackToggle.Position = UDim2.new(0.5, -75, 0, 60)

-- Add more features here (e.g., ESP, Aimbot, etc.)

-- Variables
local isOpen = true
local isWallhackEnabled = false
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local highlights = {}

-- Open/Close Functionality
OpenCloseButton.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    OpenCloseButton.Text = isOpen and "-" or "+"

    -- Toggle visibility of children (except OpenCloseButton)
    for _, child in pairs(MainFrame:GetChildren()) do
        if child ~= OpenCloseButton then
            child.Visible = isOpen
        end
    end

    TweenService:Create(MainFrame, tweenInfo, {Size = UDim2.new(0, 300, 0, isOpen and 400 or 40)}):Play()
end)

-- Highlight Functionality
local function highlightPlayer(player)
    if player ~= LocalPlayer then
        local character = player.Character
        if character then
            -- Reuse existing Highlight if available
            local highlight = highlights[player] or Instance.new("Highlight")
            highlight.Name = "Highlight"
            highlight.Adornee = character
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.OutlineTransparency = 0.1
            highlight.FillTransparency = 0.8
            highlight.DepthMode = isWallhackEnabled and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
            highlight.Parent = workspace
            highlights[player] = highlight -- Store the Highlight
        end
    end
end

-- Call highlightPlayer on existing players
for _, player in pairs(Players:GetPlayers()) do
    highlightPlayer(player)
end

-- Call highlightPlayer when a new player joins
Players.PlayerAdded:Connect(function(player)
    highlightPlayer(player)
end)

-- Toggle Wallhack
WallhackToggle.MouseButton1Click:Connect(function()
    isWallhackEnabled = not isWallhackEnabled
    WallhackToggle.Text = "Wallhack: " .. (isWallhackEnabled and "On" or "Off")

    -- Re-apply highlights to update DepthMode
    for _, player in pairs(Players:GetPlayers()) do
        highlightPlayer(player)
    end
end)

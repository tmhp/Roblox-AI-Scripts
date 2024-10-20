local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- GUI Setup (Compact)
local ScreenGui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name, MainFrame.BackgroundColor3, MainFrame.Position, MainFrame.Size, MainFrame.Active = "MainFrame", Color3.fromRGB(50, 50, 50), UDim2.new(0.5, -100, 0.5, -100), UDim2.new(0, 200, 0, 300), true

local OpenCloseButton = Instance.new("TextButton", MainFrame)
OpenCloseButton.Name, OpenCloseButton.Text, OpenCloseButton.BackgroundColor3, OpenCloseButton.Size, OpenCloseButton.Position = "OpenCloseButton", "+", Color3.fromRGB(70, 70, 70), UDim2.new(0, 20, 0, 20), UDim2.new(1, -25, 0, 5)

-- Wallhack Toggle Button
local WallhackToggle = Instance.new("TextButton", MainFrame)
WallhackToggle.Name = "WallhackToggle"
WallhackToggle.Text = "Wallhack: Off"
WallhackToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
WallhackToggle.Size = UDim2.new(0, 150, 0, 30)
WallhackToggle.Position = UDim2.new(0.5, -75, 0, 50) -- Adjusted position

-- Variables (Compact)
local isDragging, dragStart, startPos, isOpen, isWallhackEnabled = false, nil, nil, true, false
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Add this line to define the highlights table:
local highlights = {} 

-- Dragging Functionality (Compact)
local function update(input)
  MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + input.Position.X - dragStart.X, startPos.Y.Scale, startPos.Y.Offset + input.Position.Y - dragStart.Y)
end

MainFrame.InputBegan:Connect(function(input)
  if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
    isDragging, dragStart, startPos = true, input.Position, MainFrame.Position
    input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then isDragging = false end end)
  end
end)

UserInputService.InputChanged:Connect(function(input)
  if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
    if isDragging then update(input) end
  end
end)

-- Open/Close Functionality (Compact)
OpenCloseButton.MouseButton1Click:Connect(function()
  isOpen = not isOpen
  OpenCloseButton.Text = isOpen and "+" or "-"

  -- **Correctly toggle visibility of children**
  for _, child in pairs(MainFrame:GetChildren()) do
    if child ~= OpenCloseButton then -- Keep the Open/Close button visible
      child.Visible = isOpen
    end
  end

  TweenService:Create(MainFrame, tweenInfo, {Size = UDim2.new(0, 200, 0, isOpen and 300 or 25)}):Play()
end)

-- Highlight Functionality (Optimized with Wallhack Toggle)
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

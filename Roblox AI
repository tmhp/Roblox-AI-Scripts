-- Load Kavo UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

local Window = Library.CreateLib("Universal Cheat", "DarkTheme")

-- Tabs
local AimAssistTab = Window:NewTab("Aim Assist")
local ESPTab = Window:NewTab("ESP")

-- Sections
local AimAssistSection = AimAssistTab:NewSection("Aim Assist Settings")
local ESPSection = ESPTab:NewSection("ESP Settings")

-- Config
local Config = {
    AimAssist = {
        Enabled = false,
        Smoothness = 0.2,
        FOV = 100,
        AimKeybind = Enum.UserInputType.MouseButton2,
        FOVVisible = false,
        LockedTarget = nil,
        KeyPressed = false
    },
    ESP = {
        Enabled = false,
        Box = true,
        HealthBar = true,
        Tracers = true,
        Distance = true,
        MaxDistance = 500,
        TeamCheck = true,
        BoxColor = Color3.fromRGB(255, 255, 255),
        TracerColor = Color3.fromRGB(255, 0, 0),
        HealthBarColor = Color3.fromRGB(0, 255, 0),
        DistanceColor = Color3.fromRGB(255, 255, 0),
        BoxThickness = 2,
        TracerThickness = 1,
        HealthBarThickness = 2,
        DistanceSize = 13
    }
}

-- FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.new(1, 0, 0)
FOVCircle.Thickness = 2
FOVCircle.Filled = false
FOVCircle.Visible = false

local function updateFOVCircle()
    local cam = workspace.CurrentCamera
    FOVCircle.Radius = Config.AimAssist.FOV
    FOVCircle.Position = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    FOVCircle.Visible = Config.AimAssist.FOVVisible
end

-- ESP System
local ESPObjects = {}

local function createESP(player)
    local esp = {
        Box = Drawing.new("Square"),
        HealthBar = Drawing.new("Line"),
        Tracer = Drawing.new("Line"),
        Distance = Drawing.new("Text")
    }

    -- Box
    esp.Box.Thickness = Config.ESP.BoxThickness
    esp.Box.Filled = false
    esp.Box.Color = Config.ESP.BoxColor

    -- Health Bar
    esp.HealthBar.Thickness = Config.ESP.HealthBarThickness
    esp.HealthBar.Color = Config.ESP.HealthBarColor

    -- Tracer
    esp.Tracer.Thickness = Config.ESP.TracerThickness
    esp.Tracer.Color = Config.ESP.TracerColor

    -- Distance Text
    esp.Distance.Size = Config.ESP.DistanceSize
    esp.Distance.Center = true
    esp.Distance.Color = Config.ESP.DistanceColor

    ESPObjects[player] = esp
end

local function removeESP(player)
    if ESPObjects[player] then
        for _, obj in pairs(ESPObjects[player]) do
            obj:Remove()
        end
        ESPObjects[player] = nil
    end
end

local function updateESP()
    local cam = workspace.CurrentCamera
    for player, esp in pairs(ESPObjects) do
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Humanoid") then
            local rootPart = character.HumanoidRootPart
            local humanoid = character.Humanoid
            local screenPos, onScreen = cam:WorldToViewportPoint(rootPart.Position)

            if onScreen and (rootPart.Position - cam.CFrame.Position).Magnitude <= Config.ESP.MaxDistance then
                -- Box
                if Config.ESP.Box then
                    local size = Vector2.new(60, 100)
                    esp.Box.Size = size
                    esp.Box.Position = Vector2.new(screenPos.X - size.X / 2, screenPos.Y - size.Y / 2)
                    esp.Box.Color = Config.ESP.BoxColor
                    esp.Box.Thickness = Config.ESP.BoxThickness
                    esp.Box.Visible = true
                else
                    esp.Box.Visible = false
                end

                -- Health Bar
                if Config.ESP.HealthBar then
                    local healthRatio = humanoid.Health / humanoid.MaxHealth
                    esp.HealthBar.From = Vector2.new(screenPos.X - 35, screenPos.Y + 50)
                    esp.HealthBar.To = Vector2.new(screenPos.X - 35, screenPos.Y + 50 - (80 * healthRatio))
                    esp.HealthBar.Color = Config.ESP.HealthBarColor
                    esp.HealthBar.Thickness = Config.ESP.HealthBarThickness
                    esp.HealthBar.Visible = true
                else
                    esp.HealthBar.Visible = false
                end

                -- Tracer
                if Config.ESP.Tracers then
                    esp.Tracer.From = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y)
                    esp.Tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                    esp.Tracer.Color = Config.ESP.TracerColor
                    esp.Tracer.Thickness = Config.ESP.TracerThickness
                    esp.Tracer.Visible = true
                else
                    esp.Tracer.Visible = false
                end

                -- Distance Text
                if Config.ESP.Distance then
                    esp.Distance.Text = string.format("%.0f studs", (rootPart.Position - cam.CFrame.Position).Magnitude)
                    esp.Distance.Position = Vector2.new(screenPos.X, screenPos.Y + 60)
                    esp.Distance.Color = Config.ESP.DistanceColor
                    esp.Distance.Size = Config.ESP.DistanceSize
                    esp.Distance.Visible = true
                else
                    esp.Distance.Visible = false
                end
            else
                for _, obj in pairs(esp) do
                    obj.Visible = false
                end
            end
        else
            removeESP(player)
        end
    end
end

-- Add & Remove ESP
game.Players.PlayerAdded:Connect(function(player)
    if Config.ESP.Enabled then
        createESP(player)
    end
end)
game.Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

local function initESP()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            createESP(player)
        end
    end
end

-- ================== UI ==================

-- Aim Assist
AimAssistSection:NewToggle("Enable Aim Assist", "Toggle aim assist", function(state)
    Config.AimAssist.Enabled = state
end)
AimAssistSection:NewSlider("Smoothness", "Adjust smoothness", 1, 0, Config.AimAssist.Smoothness, function(val)
    Config.AimAssist.Smoothness = val
end)
AimAssistSection:NewSlider("FOV Size", "Adjust FOV size", 500, 0, Config.AimAssist.FOV, function(val)
    Config.AimAssist.FOV = val
end)
AimAssistSection:NewToggle("Show FOV Circle", "Show/hide FOV circle", function(state)
    Config.AimAssist.FOVVisible = state
end)
AimAssistSection:NewKeybind("Aim Keybind", "Key to hold aim", Config.AimAssist.AimKeybind, function(key)
    Config.AimAssist.AimKeybind = key
end)

-- ESP Toggles
ESPSection:NewToggle("Enable ESP", "Toggle ESP", function(state)
    Config.ESP.Enabled = state
    if state then
        initESP()
    else
        for player, _ in pairs(ESPObjects) do
            removeESP(player)
        end
    end
end)
ESPSection:NewToggle("Box ESP", "Show boxes", function(state)
    Config.ESP.Box = state
end)
ESPSection:NewToggle("Health Bar", "Show health bar", function(state)
    Config.ESP.HealthBar = state
end)
ESPSection:NewToggle("Tracers", "Show tracers", function(state)
    Config.ESP.Tracers = state
end)
ESPSection:NewToggle("Distance Text", "Show distance", function(state)
    Config.ESP.Distance = state
end)
ESPSection:NewToggle("Team Check", "Ignore teammates", function(state)
    Config.ESP.TeamCheck = state
end)

ESPSection:NewSlider("Max Distance", "ESP max distance", 1000, 100, Config.ESP.MaxDistance, function(val)
    Config.ESP.MaxDistance = val
end)

-- ================= Colors & Thickness Customization ==================
ESPSection:NewColorPicker("Box Color", "Change box color", Config.ESP.BoxColor, function(color)
    Config.ESP.BoxColor = color
end)
ESPSection:NewColorPicker("Tracer Color", "Change tracer color", Config.ESP.TracerColor, function(color)
    Config.ESP.TracerColor = color
end)
ESPSection:NewColorPicker("Health Bar Color", "Change health bar color", Config.ESP.HealthBarColor, function(color)
    Config.ESP.HealthBarColor = color
end)
ESPSection:NewColorPicker("Distance Color", "Change distance text color", Config.ESP.DistanceColor, function(color)
    Config.ESP.DistanceColor = color
end)

ESPSection:NewSlider("Box Thickness", "Adjust box thickness", 10, 1, Config.ESP.BoxThickness, function(val)
    Config.ESP.BoxThickness = val
end)
ESPSection:NewSlider("Tracer Thickness", "Adjust tracer thickness", 10, 1, Config.ESP.TracerThickness, function(val)
    Config.ESP.TracerThickness = val
end)
ESPSection:NewSlider("HealthBar Thickness", "Adjust health bar thickness", 10, 1, Config.ESP.HealthBarThickness, function(val)
    Config.ESP.HealthBarThickness = val
end)
ESPSection:NewSlider("Distance Text Size", "Adjust distance text size", 20, 10, Config.ESP.DistanceSize, function(val)
    Config.ESP.DistanceSize = val
end)

-- =================== Aim Assist Logic =====================
local function getClosestTarget()
    local closest, shortest = nil, Config.AimAssist.FOV
    local mouse = game.Players.LocalPlayer:GetMouse()
    local cam = workspace.CurrentCamera

    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local screenPoint = cam:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
            if distance < shortest then
                closest = player.Character.HumanoidRootPart
                shortest = distance
            end
        end
    end
    return closest
end

local function aimAtTarget(target)
    if target then
        local cam = workspace.CurrentCamera
        local targetPos = target.Position
        local newCFrame = CFrame.new(cam.CFrame.Position, targetPos)
        cam.CFrame = cam.CFrame:Lerp(newCFrame, Config.AimAssist.Smoothness)
    end
end

game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.UserInputType == Config.AimAssist.AimKeybind and Config.AimAssist.Enabled then
        Config.AimAssist.KeyPressed = true
        Config.AimAssist.LockedTarget = getClosestTarget()
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Config.AimAssist.AimKeybind then
        Config.AimAssist.KeyPressed = false
        Config.AimAssist.LockedTarget = nil
    end
end)

-- =================== Main Loop =========================
game:GetService("RunService").RenderStepped:Connect(function()
    -- Aim Assist
    if Config.AimAssist.Enabled and Config.AimAssist.KeyPressed then
        if Config.AimAssist.LockedTarget then
            aimAtTarget(Config.AimAssist.LockedTarget)
        end
    end
    updateFOVCircle()

    -- ESP
    if Config.ESP.Enabled then
        updateESP()
    end
end)

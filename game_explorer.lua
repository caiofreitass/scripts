local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

-- GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GameExplorerGui"
screenGui.Enabled = true
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,400,0,500)
frame.Position = UDim2.new(0,10,0,10)
frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local uiList = Instance.new("UIListLayout")
uiList.Padding = UDim.new(0,5)
uiList.Parent = frame

local function createButtonForObject(obj, parentFrame, indent)
    indent = indent or 0
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -indent, 0, 25)
    btn.Position = UDim2.new(0, indent, 0, 0)
    btn.Text = obj.Name .. " [" .. obj.ClassName .. "]"
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.Font = Enum.Font.SourceSans
    btn.TextScaled = true
    btn.Parent = parentFrame

    local expanded = false
    local childButtons = {}

    btn.MouseButton1Click:Connect(function()
        if #childButtons == 0 then
            for _, child in pairs(obj:GetChildren()) do
                local b = createButtonForObject(child, parentFrame, indent + 20)
                table.insert(childButtons, b)
            end
        else
            if expanded then
                for _, b in pairs(childButtons) do
                    b.Visible = false
                end
            else
                for _, b in pairs(childButtons) do
                    b.Visible = true
                end
            end
        end
        expanded = not expanded
    end)

    return btn
end

-- Função recursiva para puxar Workspace
for _, obj in pairs(Workspace:GetChildren()) do
    createButtonForObject(obj, frame)
end

-- Tecla G para esconder/mostrar GUI
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.G then
        screenGui.Enabled = not screenGui.Enabled
    end
end)

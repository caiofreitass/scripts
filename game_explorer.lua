local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- Pasta para guardar scripts clonados
local clonedFolder = ServerStorage:FindFirstChild("ClonedScripts") or Instance.new("Folder")
clonedFolder.Name = "ClonedScripts"
clonedFolder.Parent = ServerStorage
clonedFolder:ClearAllChildren()

-- GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ScriptExplorerGui"
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0,400,0,500)
mainFrame.Position = UDim2.new(0,10,0,10)
mainFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- ScrollingFrame
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1,0,1,0)
scrollFrame.CanvasSize = UDim2.new(0,0,0,0)
scrollFrame.ScrollBarThickness = 10
scrollFrame.BackgroundTransparency = 1
scrollFrame.Parent = mainFrame

local uiList = Instance.new("UIListLayout")
uiList.Padding = UDim.new(0,2)
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Parent = scrollFrame

-- Atualiza CanvasSize
local function updateCanvas()
    local total = 0
    for _, c in pairs(scrollFrame:GetChildren()) do
        if c:IsA("TextButton") then
            total = total + c.AbsoluteSize.Y + uiList.Padding.Offset
        end
    end
    scrollFrame.CanvasSize = UDim2.new(0,0,0,total)
end

-- Função recursiva para criar botões de objetos
local function createButton(obj, parent, indent)
    indent = indent or 0
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-indent,0,25)
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSans
    btn.TextScaled = true
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Text = (" "):rep(indent/10)..obj.Name.." ["..obj.ClassName.."]"
    btn.Visible = true
    btn.Parent = parent

    local expanded = false
    local childButtons = {}

    -- Clique esquerdo: expande/contrai filhos
    btn.MouseButton1Click:Connect(function()
        if #childButtons == 0 then
            for _, child in pairs(obj:GetChildren()) do
                local b = createButton(child, parent, indent + 20)
                table.insert(childButtons, b)
            end
        else
            for _, b in pairs(childButtons) do
                b.Visible = not expanded
            end
        end
        expanded = not expanded
        updateCanvas()
    end)

    -- Clique direito: clona script
    btn.MouseButton2Click:Connect(function()
        if obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
            obj:Clone().Parent = clonedFolder
            print("Clonado:", obj:GetFullName())
        end
    end)

    updateCanvas()
    return btn
end

-- Inicializa GUI com Workspace e ReplicatedStorage
for _, obj in pairs(Workspace:GetChildren()) do
    createButton(obj, scrollFrame)
end
for _, obj in pairs(ReplicatedStorage:GetChildren()) do
    createButton(obj, scrollFrame)
end

-- Tecla G para mostrar/esconder GUI
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.G then
        screenGui.Enabled = not screenGui.Enabled
    end
end)

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ScriptExplorerGui"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0,400,0,500)
mainFrame.Position = UDim2.new(0,10,0,10)
mainFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Scroll para hierarquia
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(0.6,0,1,0)
scrollFrame.Position = UDim2.new(0,0,0,0)
scrollFrame.CanvasSize = UDim2.new(0,0,0,0)
scrollFrame.ScrollBarThickness = 10
scrollFrame.BackgroundTransparency = 1
scrollFrame.Parent = mainFrame

local uiList = Instance.new("UIListLayout")
uiList.Padding = UDim.new(0,2)
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Parent = scrollFrame

-- Frame lateral para preview
local previewFrame = Instance.new("Frame")
previewFrame.Size = UDim2.new(0.4,0,1,0)
previewFrame.Position = UDim2.new(0.6,0,0,0)
previewFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
previewFrame.BorderSizePixel = 0
previewFrame.Parent = mainFrame

local previewLabel = Instance.new("TextLabel")
previewLabel.Size = UDim2.new(1,-10,1,-10)
previewLabel.Position = UDim2.new(0,5,0,5)
previewLabel.BackgroundTransparency = 1
previewLabel.TextColor3 = Color3.fromRGB(255,255,255)
previewLabel.TextScaled = false
previewLabel.TextXAlignment = Enum.TextXAlignment.Left
previewLabel.TextYAlignment = Enum.TextYAlignment.Top
previewLabel.Font = Enum.Font.Code
previewLabel.RichText = true
previewLabel.TextWrapped = true
previewLabel.Text = ""
previewLabel.TextXAlignment = Enum.TextXAlignment.Left
previewLabel.TextYAlignment = Enum.TextYAlignment.Top
previewLabel.TextStrokeTransparency = 0.8
previewLabel.Parent = previewFrame

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

-- Função recursiva para criar botões
local function createButton(obj, parent, indent, path)
    indent = indent or 0
    path = path or obj.Name
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

    -- Clique esquerdo: expandir/contrair
    btn.MouseButton1Click:Connect(function()
        if #childButtons == 0 then
            for _, child in pairs(obj:GetChildren()) do
                local b = createButton(child, parent, indent + 20, path.."."..child.Name)
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

    -- Clique direito: mostrar conteúdo do script no preview
    btn.MouseButton2Click:Connect(function()
        if obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
            previewLabel.Text = obj.Source or "-- Sem código disponível"
        else
            previewLabel.Text = "-- Não é um script"
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

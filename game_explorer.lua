local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ScriptExplorer"
screenGui.Enabled = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0,600,0,500)
mainFrame.Position = UDim2.new(0,10,0,10)
mainFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Botões topo
local hierButton = Instance.new("TextButton")
hierButton.Size = UDim2.new(0,120,0,30)
hierButton.Position = UDim2.new(0,5,0,5)
hierButton.Text = "Hierarquia"
hierButton.Parent = mainFrame

local scriptButton = Instance.new("TextButton")
scriptButton.Size = UDim2.new(0,120,0,30)
scriptButton.Position = UDim2.new(0,130,0,5)
scriptButton.Text = "Scripts"
scriptButton.Parent = mainFrame

-- Scroll frame
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(0.6,0,1,-40)
scrollFrame.Position = UDim2.new(0,0,0,40)
scrollFrame.CanvasSize = UDim2.new(0,0,0,0)
scrollFrame.ScrollBarThickness = 10
scrollFrame.BackgroundTransparency = 1
scrollFrame.Parent = mainFrame

local uiList = Instance.new("UIListLayout")
uiList.Padding = UDim.new(0,2)
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Parent = scrollFrame

-- Preview frame
local previewFrame = Instance.new("Frame")
previewFrame.Size = UDim2.new(0.4,0,1,0)
previewFrame.Position = UDim2.new(0.6,0,0,0)
previewFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
previewFrame.Parent = mainFrame

local previewLabel = Instance.new("TextLabel")
previewLabel.Size = UDim2.new(1,0,1,0)
previewLabel.BackgroundTransparency = 1
previewLabel.TextColor3 = Color3.new(1,1,1)
previewLabel.Font = Enum.Font.Code
previewLabel.TextXAlignment = Enum.TextXAlignment.Left
previewLabel.TextYAlignment = Enum.TextYAlignment.Top
previewLabel.RichText = true
previewLabel.TextWrapped = true
previewLabel.Text = ""
previewLabel.Parent = previewFrame

-- Função para criar botão
local function createButton(obj, parent, indent)
    indent = indent or 0
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-indent,0,25)
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSans
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Text = (" "):rep(indent/10)..obj.Name.." ["..obj.ClassName.."]"
    btn.Parent = parent

    -- Lazy loading: cria filhos ao clicar
    local expanded = false
    local childButtons = {}

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
    end)

    -- Clique direito: preview
    btn.MouseButton2Click:Connect(function()
        if obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
            previewLabel.Text = obj.Source or "-- Sem código disponível"
        else
            previewLabel.Text = "-- Não é um script"
        end
    end)

    return btn
end

-- Coletar todos objetos
local allObjects = {}
for _, obj in pairs(Workspace:GetChildren()) do table.insert(allObjects,obj) end
for _, obj in pairs(ReplicatedStorage:GetChildren()) do table.insert(allObjects,obj) end

-- Mostrar hierarquia
local function showAllHierarchy()
    scrollFrame:ClearAllChildren()
    for _, obj in pairs(allObjects) do
        createButton(obj, scrollFrame, 0)
    end
end

-- Mostrar apenas scripts
local function showAllScripts()
    scrollFrame:ClearAllChildren()
    local function addScriptsRecursively(o, parent)
        if o:IsA("Script") or o:IsA("LocalScript") or o:IsA("ModuleScript") then
            createButton(o, parent)
        end
        for _, child in pairs(o:GetChildren()) do
            addScriptsRecursively(child, parent)
        end
    end
    for _, obj in pairs(allObjects) do
        addScriptsRecursively(obj, scrollFrame)
    end
end

-- Conecta botões
hierButton.MouseButton1Click:Connect(showAllHierarchy)
scriptButton.MouseButton1Click:Connect(showAllScripts)

-- Tecla G para mostrar GUI
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.G then
        screenGui.Enabled = not screenGui.Enabled
    end
end)

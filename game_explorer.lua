local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ScriptExplorerGui"
screenGui.Enabled = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0,500,0,500)
mainFrame.Position = UDim2.new(0,10,0,10)
mainFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Botões no topo
local hierButton = Instance.new("TextButton")
hierButton.Size = UDim2.new(0,120,0,30)
hierButton.Position = UDim2.new(0,5,0,5)
hierButton.Text = "Hierarquia"
hierButton.TextScaled = true
hierButton.Font = Enum.Font.SourceSansBold
hierButton.BackgroundColor3 = Color3.fromRGB(0,120,200)
hierButton.TextColor3 = Color3.fromRGB(255,255,255)
hierButton.Parent = mainFrame

local scriptButton = Instance.new("TextButton")
scriptButton.Size = UDim2.new(0,120,0,30)
scriptButton.Position = UDim2.new(0,130,0,5)
scriptButton.Text = "Scripts"
scriptButton.TextScaled = true
scriptButton.Font = Enum.Font.SourceSansBold
scriptButton.BackgroundColor3 = Color3.fromRGB(0,150,0)
scriptButton.TextColor3 = Color3.fromRGB(255,255,255)
scriptButton.Parent = mainFrame

-- Scroll para hierarquia / scripts
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

-- Frame lateral para preview de scripts
local previewFrame = Instance.new("Frame")
previewFrame.Size = UDim2.new(0.4,0,1,0)
previewFrame.Position = UDim2.new(0.6,0,0,0)
previewFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
previewFrame.BorderSizePixel = 0
previewFrame.Parent = mainFrame

-- Scrolling frame para o conteúdo do script
local previewScroll = Instance.new("ScrollingFrame")
previewScroll.Size = UDim2.new(1,-10,1,-10)
previewScroll.Position = UDim2.new(0,5,0,5)
previewScroll.CanvasSize = UDim2.new(0,0,0,0)
previewScroll.ScrollBarThickness = 10
previewScroll.BackgroundTransparency = 1
previewScroll.Parent = previewFrame

local previewLabel = Instance.new("TextLabel")
previewLabel.Size = UDim2.new(1,0,0,0)
previewLabel.BackgroundTransparency = 1
previewLabel.TextColor3 = Color3.fromRGB(255,255,255)
previewLabel.Font = Enum.Font.Code
previewLabel.TextScaled = false
previewLabel.TextXAlignment = Enum.TextXAlignment.Left
previewLabel.TextYAlignment = Enum.TextYAlignment.Top
previewLabel.RichText = true
previewLabel.TextWrapped = true
previewLabel.TextStrokeTransparency = 0.8
previewLabel.Text = ""
previewLabel.Parent = previewScroll

-- Atualiza canvas size do preview
local function updatePreviewCanvas()
    local textSize = previewLabel.TextBounds.Y
    previewLabel.Size = UDim2.new(1,0,0,textSize)
    previewScroll.CanvasSize = UDim2.new(0,0,0,textSize)
end

-- Atualiza canvas do scroll principal
local function updateCanvas()
    local total = 0
    for _, c in pairs(scrollFrame:GetChildren()) do
        if c:IsA("TextButton") then
            total = total + c.AbsoluteSize.Y + uiList.Padding.Offset
        end
    end
    scrollFrame.CanvasSize = UDim2.new(0,0,0,total)
end

-- Cria botões recursivamente
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

    -- Clique direito: mostrar conteúdo do script
    btn.MouseButton2Click:Connect(function()
        if obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
            previewLabel.Text = obj.Source or "-- Sem código disponível"
        else
            previewLabel.Text = "-- Não é um script"
        end
        updatePreviewCanvas()
    end)

    -- Duplo clique para copiar conteúdo para clipboard
    btn.MouseButton2Click:Connect(function()
        if obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
            setclipboard(obj.Source or "")
            print("Conteúdo copiado para o clipboard")
        end
    end)

    updateCanvas()
    return btn
end

-- Coleta todos objetos
local allObjects = {}
for _, obj in pairs(Workspace:GetChildren()) do
    table.insert(allObjects, obj)
end
for _, obj in pairs(ReplicatedStorage:GetChildren()) do
    table.insert(allObjects, obj)
end

-- Mostrar Hierarquia completa
local function showAllHierarchy()
    scrollFrame:ClearAllChildren()
    for _, obj in pairs(allObjects) do
        local function addRecursively(o, parent, path)
            path = path or o.Name
            createButton(o, parent, 0, path)
            for _, child in pairs(o:GetChildren()) do
                addRecursively(child, parent, path.."."..child.Name)
            end
        end
        addRecursively(obj, scrollFrame)
    end
end

-- Mostrar apenas Scripts
local function showAllScripts()
    scrollFrame:ClearAllChildren()
    for _, obj in pairs(allObjects) do
        local function addScriptsRecursively(o, parent, path)
            path = path or o.Name
            if o:IsA("Script") or o:IsA("LocalScript") or o:IsA("ModuleScript") then
                createButton(o, parent, 0, path)
            end
            for _, child in pairs(o:GetChildren()) do
                addScriptsRecursively(child, parent, path.."."..child.Name)
            end
        end
        addScriptsRecursively(obj, scrollFrame)
    end
end

-- Conecta botões
hierButton.MouseButton1Click:Connect(showAllHierarchy)
scriptButton.MouseButton1Click:Connect(showAllScripts)

-- Tecla G para mostrar/esconder GUI
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.G then
        screenGui.Enabled = not screenGui.Enabled
    end
end)

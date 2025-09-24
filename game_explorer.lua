-- Game Explorer completo com filhos indentados à direita
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- Cria GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GameExplorer"
screenGui.Enabled = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0,800,0,500)
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

-- Scroll frame da hierarquia
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(0.4,0,1,-40)
scrollFrame.Position = UDim2.new(0,0,0,40)
scrollFrame.CanvasSize = UDim2.new(0,0,0,0)
scrollFrame.ScrollBarThickness = 10
scrollFrame.BackgroundTransparency = 1
scrollFrame.Parent = mainFrame

local uiList = Instance.new("UIListLayout")
uiList.Padding = UDim.new(0,2)
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Parent = scrollFrame

-- Frame lateral para preview/propriedades
local previewFrame = Instance.new("Frame")
previewFrame.Size = UDim2.new(0.6,0,1,0)
previewFrame.Position = UDim2.new(0.4,0,0,0)
previewFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
previewFrame.Parent = mainFrame

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
previewLabel.TextXAlignment = Enum.TextXAlignment.Left
previewLabel.TextYAlignment = Enum.TextYAlignment.Top
previewLabel.RichText = true
previewLabel.TextWrapped = true
previewLabel.Text = ""
previewLabel.Parent = previewScroll

-- Atualiza scroll lateral
local function updatePreviewCanvas()
    local textSize = previewLabel.TextBounds.Y
    previewLabel.Size = UDim2.new(1,0,0,textSize)
    previewScroll.CanvasSize = UDim2.new(0,0,0,textSize)
end

local function updateCanvas()
    local total = 0
    for _, c in pairs(scrollFrame:GetChildren()) do
        if c:IsA("TextButton") then
            total = total + c.AbsoluteSize.Y + uiList.Padding.Offset
        end
    end
    scrollFrame.CanvasSize = UDim2.new(0,0,0,total)
end

-- Lista propriedades do objeto
local function listProperties(obj)
    local text = ""
    for _, prop in pairs(obj:GetAttributes()) do
        text = text..prop.."\n"
    end
    if obj:IsA("BasePart") then
        text = text.."\nSize: "..tostring(obj.Size)
        text = text.."\nPosition: "..tostring(obj.Position)
        text = text.."\nColor: "..tostring(obj.Color)
        text = text.."\nAnchored: "..tostring(obj.Anchored)
        text = text.."\nCanCollide: "..tostring(obj.CanCollide)
    elseif obj:IsA("GuiObject") then
        text = text.."\nSize: "..tostring(obj.Size)
        text = text.."\nPosition: "..tostring(obj.Position)
        text = text.."\nVisible: "..tostring(obj.Visible)
    end
    return text
end

-- Função para criar botão com filhos indentados à direita
local function createButton(obj, parent, indent, path)
    indent = indent or 0
    path = path or obj.Name

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-indent,0,25)
    btn.Position = UDim2.new(0,indent,0,0)
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

    -- Clique esquerdo: expandir/contrair filhos
    btn.MouseButton1Click:Connect(function()
        if #childButtons == 0 then
            local lastY = btn.Position.Y.Offset + btn.Size.Y.Offset
            for _, child in pairs(obj:GetChildren()) do
                local childBtn = createButton(child, parent, indent + 20, path.."."..child.Name)
                childBtn.Position = UDim2.new(0, indent + 20, 0, lastY)
                lastY = lastY + childBtn.AbsoluteSize.Y + 2
                table.insert(childButtons, childBtn)
            end
        else
            for _, b in pairs(childButtons) do
                b.Visible = not expanded
            end
        end
        expanded = not expanded
        updateCanvas()
    end)

    -- Clique direito: copiar caminho completo
    btn.MouseButton2Click:Connect(function()
        if obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
            setclipboard(path)
            print("Caminho copiado para o clipboard:", path)
        end
    end)

    updateCanvas()
    return btn
end

-- Carrega todos objetos recursivamente
local function loadAllObjects()
    local allObjects = {}
    local function addRecursively(parent)
        table.insert(allObjects, parent)
        for _, child in pairs(parent:GetChildren()) do
            addRecursively(child)
        end
    end
    for _, obj in pairs(Workspace:GetChildren()) do addRecursively(obj) end
    for _, obj in pairs(ReplicatedStorage:GetChildren()) do addRecursively(obj) end
    return allObjects
end

local allObjects = loadAllObjects()

-- Mostrar hierarquia
local function showAllHierarchy()
    scrollFrame:ClearAllChildren()
    for _, obj in pairs(allObjects) do
        createButton(obj, scrollFrame, 0)
    end
    updateCanvas()
end

-- Mostrar scripts
local function showAllScripts()
    scrollFrame:ClearAllChildren()
    for _, obj in pairs(allObjects) do
        if obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
            createButton(obj, scrollFrame, 0)
        end
    end
    updateCanvas()
end

-- Botões topo
hierButton.MouseButton1Click:Connect(showAllHierarchy)
scriptButton.MouseButton1Click:Connect(showAllScripts)

-- Tecla G para mostrar/ocultar GUI
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.G then
        screenGui.Enabled = not screenGui.Enabled
    end
end)

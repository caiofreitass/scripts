local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ServerStorage = game:GetService("ServerStorage")

local player = Players.LocalPlayer

-- GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ClonerGui"
screenGui.Enabled = true
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
local function updateCanvasSize()
    local total = 0
    for _, child in pairs(scrollFrame:GetChildren()) do
        if child:IsA("TextButton") and child.Visible then
            total = total + child.AbsoluteSize.Y + uiList.Padding.Offset
        end
    end
    scrollFrame.CanvasSize = UDim2.new(0,0,0,total)
end

-- Função recursiva para criar botões de clonagem
local function createButtonForObject(obj, parent, indent)
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

    -- Ao clicar, expande filhos ou clona
    btn.MouseButton1Click:Connect(function()
        if #childButtons == 0 then
            -- cria botões filhos
            for _, child in pairs(obj:GetChildren()) do
                local b = createButtonForObject(child, parent, indent + 20)
                b.LayoutOrder = btn.LayoutOrder + 1
                table.insert(childButtons, b)
            end
        else
            for _, b in pairs(childButtons) do
                b.Visible = not expanded
            end
        end
        expanded = not expanded
        updateCanvasSize()
    end)

    -- Botão direito para clonar
    btn.MouseButton2Click:Connect(function()
        local cloneFolder = ServerStorage:FindFirstChild("ClonedWorkspace") or Instance.new("Folder", ServerStorage)
        cloneFolder.Name = "ClonedWorkspace"
        obj:Clone().Parent = cloneFolder
        print("Clonado:", obj.Name)
    end)

    updateCanvasSize()
    return btn
end

-- Cria botões iniciais do Workspace
for _, obj in pairs(Workspace:GetChildren()) do
    createButtonForObject(obj, scrollFrame)
end

-- Tecla G para mostrar/esconder GUI
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.G then
        screenGui.Enabled = not screenGui.Enabled
    end
end)

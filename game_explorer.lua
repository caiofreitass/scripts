local Workspace = game:GetService("Workspace")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Cria a pasta para o clone
local cloneFolder = ServerStorage:FindFirstChild("WorkspaceClone")
if not cloneFolder then
    cloneFolder = Instance.new("Folder")
    cloneFolder.Name = "WorkspaceClone"
    cloneFolder.Parent = ServerStorage
else
    cloneFolder:ClearAllChildren()
end

-- Função recursiva para clonar objetos
local function cloneObject(obj, parent)
    local clone = obj:Clone()
    clone.Parent = parent
    for _, child in pairs(obj:GetChildren()) do
        cloneObject(child, clone)
    end
end

-- Clona todo o Workspace
for _, obj in pairs(Workspace:GetChildren()) do
    cloneObject(obj, cloneFolder)
end

-- GUI simples para avisar
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CloneNoticeGui"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,300,0,100)
frame.Position = UDim2.new(0.5,-150,0.5,-50)
frame.BackgroundColor3 = Color3.fromRGB(0,150,0)
frame.Parent = screenGui

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1,0,1,0)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.new(1,1,1)
label.Font = Enum.Font.SourceSansBold
label.TextScaled = true
label.Text = "Clone do Workspace criado em ServerStorage!"
label.Parent = frame

-- Pressione qualquer tecla para remover a mensagem
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function()
    screenGui:Destroy()
end)

print("Clone do Workspace criado em ServerStorage.WorkspaceClone! Abra no Studio para salvar como .rbxl.")

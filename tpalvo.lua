-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- RemoteEvents
local tpRemote = ReplicatedStorage:FindFirstChild("TeleportToMe")
local chatRemote = ReplicatedStorage:FindFirstChild("SendMessage")

if not tpRemote then warn("RemoteEvent 'TeleportToMe' não encontrado!") end
if not chatRemote then warn("RemoteEvent 'SendMessage' não encontrado!") end

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PlayerToolsGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 600)
mainFrame.Position = UDim2.new(0, 50, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
mainFrame.Parent = screenGui

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0,5)
UIListLayout.Parent = mainFrame

-- Caixa de texto para mensagem
local messageBox = Instance.new("TextBox")
messageBox.Size = UDim2.new(1,0,0,40)
messageBox.PlaceholderText = "Digite sua mensagem aqui..."
messageBox.Text = ""
messageBox.ClearTextOnFocus = false
messageBox.Font = Enum.Font.SourceSans
messageBox.TextScaled = true
messageBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
messageBox.TextColor3 = Color3.fromRGB(0,0,0)
messageBox.Parent = mainFrame

-- Função para criar botão
local function createButton(title, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,0,40)
    btn.Text = title
    btn.Font = Enum.Font.SourceSans
    btn.TextScaled = true
    btn.BackgroundColor3 = Color3.fromRGB(0,150,255)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Parent = mainFrame
    btn.MouseButton1Click:Connect(callback)
end

-- Atualiza lista de jogadores
local function updatePlayerButtons()
    -- Remove botões antigos (exceto a TextBox)
    for _, child in pairs(mainFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end

    -- Cria novos botões
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            -- Teleportar para você
            createButton("Teleport "..p.Name.." to me", function()
                if tpRemote then tpRemote:FireServer(p.Name) end
            end)
            -- Enviar mensagem
            createButton("Send message to "..p.Name, function()
                if chatRemote then
                    local msg = messageBox.Text
                    if msg ~= "" then
                        chatRemote:FireServer(msg)
                    end
                end
            end)
        end
    end
end

-- Inicializa lista
updatePlayerButtons()

-- Atualiza quando jogadores entram ou saem
Players.PlayerAdded:Connect(updatePlayerButtons)
Players.PlayerRemoving:Connect(updatePlayerButtons)

-- Script para todos verem GUI global ao apertar L
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Cria RemoteEvent se não existir
local remote = ReplicatedStorage:FindFirstChild("MensagemGUIGlobal")
if not remote then
    remote = Instance.new("RemoteEvent")
    remote.Name = "MensagemGUIGlobal"
    remote.Parent = ReplicatedStorage
end

-- SERVER: dispara para todos os clientes
if RunService:IsServer() then
    remote.OnServerEvent:Connect(function(player)
        remote:FireAllClients("rapadura mole")
    end)
end

-- CLIENT: cria GUI e detecta tecla L
if RunService:IsClient() then
    local player = Players.LocalPlayer

    -- Cria ScreenGui e Label
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MensagemGlobalGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 0.1, 0)
    label.Position = UDim2.new(0.25, 0, 0.45, 0)
    label.BackgroundTransparency = 0.5
    label.BackgroundColor3 = Color3.new(0, 0, 0)
    label.TextColor3 = Color3.new(1, 0, 0) -- vermelho
    label.Font = Enum.Font.FredokaOne
    label.TextScaled = true
    label.Text = ""
    label.Parent = screenGui

    -- Função para mostrar mensagem por 3 segundos
    local function mostrarMensagem(msg)
        label.Text = msg
        wait(3)
        label.Text = ""
    end

    -- Recebe evento do servidor
    remote.OnClientEvent:Connect(function(msg)
        mostrarMensagem(msg)
    end)

    -- Detecta tecla L e envia para o servidor
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.L then
            remote:FireServer()
        end
    end)
end

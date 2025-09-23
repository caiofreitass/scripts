-- HTTP-ready, funciona para todos os jogadores

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- CRIAR RemoteEvent
local remote = ReplicatedStorage:FindFirstChild("MensagemGUIGlobal")
if not remote then
    remote = Instance.new("RemoteEvent")
    remote.Name = "MensagemGUIGlobal"
    remote.Parent = ReplicatedStorage
end

-- CÓDIGO DO SERVIDOR
if RunService:IsServer() then
    remote.OnServerEvent:Connect(function(player)
        -- Dispara para todos os clientes
        remote:FireAllClients("rapadura mole")
    end)
end

-- CÓDIGO DO CLIENTE
if RunService:IsClient() then
    local player = Players.LocalPlayer

    -- Função para criar GUI temporária
    local function mostrarMensagem(msg)
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "MensagemGlobalGUI"
        screenGui.ResetOnSpawn = false
        screenGui.Parent = player:WaitForChild("PlayerGui")

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.5, 0, 0.1, 0)
        label.Position = UDim2.new(0.25, 0, 0.45, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.new(1, 0, 0)
        label.Font = Enum.Font.FredokaOne
        label.TextScaled = true
        label.Text = msg
        label.Parent = screenGui

        task.delay(3, function()
            screenGui:Destroy()
        end)
    end

    -- Recebe evento do servidor
    remote.OnClientEvent:Connect(function(msg)
        mostrarMensagem(msg)
    end)

    -- Detecta tecla L e envia evento pro servidor
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.L then
            remote:FireServer()
        end
    end)
end

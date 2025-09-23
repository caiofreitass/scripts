local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- RemoteEvent
local remote = ReplicatedStorage:FindFirstChild("MensagemGUIGlobal")
if not remote then
    remote = Instance.new("RemoteEvent")
    remote.Name = "MensagemGUIGlobal"
    remote.Parent = ReplicatedStorage
end

-- SERVER: envia para todos
if RunService:IsServer() then
    remote.OnServerEvent:Connect(function(player)
        remote:FireAllClients("rapadura mole")
    end)
end

-- CLIENT: cria GUI e detecta tecla
if RunService:IsClient() then
    local player = Players.LocalPlayer

    local function mostrarMensagem(msg)
        -- Cria ScreenGui temporário
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "MensagemGlobalGUI"
        screenGui.ResetOnSpawn = false
        screenGui.Parent = player:WaitForChild("PlayerGui")

        -- Cria TextLabel transparente
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.5,0,0.1,0)
        label.Position = UDim2.new(0.25,0,0.45,0)
        label.BackgroundTransparency = 1 -- totalmente transparente
        label.TextColor3 = Color3.new(1,0,0)
        label.Font = Enum.Font.FredokaOne
        label.TextScaled = true
        label.Text = msg
        label.Parent = screenGui

        -- Destrói GUI depois de 3 segundos
        task.delay(3, function()
            screenGui:Destroy()
        end)
    end

    -- Recebe evento do servidor
    remote.OnClientEvent:Connect(function(msg)
        mostrarMensagem(msg)
    end)

    -- Detecta tecla L
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.L then
            remote:FireServer()
        end
    end)
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- RemoteEvent para mostrar mensagem global
local remote = ReplicatedStorage:FindFirstChild("MensagemGUIGlobal")
if not remote then
    remote = Instance.new("RemoteEvent")
    remote.Name = "MensagemGUIGlobal"
    remote.Parent = ReplicatedStorage
end

-- Função para teleporte e mensagem
local function teleportarEAnunciar()
    local alvo = Players:FindFirstChild("Damon_o19")
    local destino = Players:FindFirstChild("caiorimador")
    
    if alvo and destino and alvo.Character and destino.Character then
        -- Teleporta Damon_o19 para caiorimador
        local hrpAlvo = alvo.Character:FindFirstChild("HumanoidRootPart")
        local hrpDestino = destino.Character:FindFirstChild("HumanoidRootPart")
        if hrpAlvo and hrpDestino then
            hrpAlvo.CFrame = hrpDestino.CFrame + Vector3.new(0, 3, 0) -- um pouco acima
        end
        
        -- Envia mensagem global
        remote:FireAllClients("Damon_o19 foi teleportado para caiorimador")
    end
end

-- Dispara a função ao apertar a tecla T (pode trocar)
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.T then
        teleportarEAnunciar()
    end
end)

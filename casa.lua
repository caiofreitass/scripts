-- ServerScriptService/TeleportaJogador.lua
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local NOME_ALVO = "mita_2060" -- Jogador específico
local DISTANCIA_FINAL = 3 -- Distância final em frente ao player que apertou a tecla

-- Função para teletransportar o jogador alvo
local function teleportarAlvo(player)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local posPlayer = hrp.Position

    local alvo = Players:FindFirstChild(NOME_ALVO)
    if alvo and alvo.Character and alvo.Character:FindFirstChild("HumanoidRootPart") then
        local hrpAlvo = alvo.Character.HumanoidRootPart
        -- Teleporta o alvo para frente do player
        hrpAlvo.CFrame = CFrame.new(posPlayer + Vector3.new(0, 0, -DISTANCIA_FINAL))
    end
end

-- Detecta tecla
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.K then
        local player = Players:GetPlayers()[1] -- Adaptar para o jogador que apertou a tecla, se necessário
        teleportarAlvo(player)
    end
end)

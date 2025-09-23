-- ServerScriptService/TeleportaJogadorMoveTo.lua
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local NOME_ALVO = "mita_2060" -- Jogador específico
local DISTANCIA_FINAL = 3 -- Distância final em frente ao player que apertou a tecla

-- Função para teletransportar o jogador alvo usando MoveTo
local function teleportarAlvo(player)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = player.Character.HumanoidRootPart
    local posPlayer = hrp.Position

    local alvo = Players:FindFirstChild(NOME_ALVO)
    if alvo and alvo.Character and alvo.Character:FindFirstChild("Humanoid") and alvo.Character:FindFirstChild("HumanoidRootPart") then
        local humanoid = alvo.Character.Humanoid
        local hrpAlvo = alvo.Character.HumanoidRootPart
        local destino = posPlayer + Vector3.new(0, 0, -DISTANCIA_FINAL)

        -- Move o Humanoid para o destino
        humanoid:MoveTo(destino)

        -- Opcional: reforçar a posição após 0.1s caso o personagem ainda esteja “deslizando”
        delay(0.1, function()
            humanoid:MoveTo(destino)
        end)
    end
end

-- Detecta tecla
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.K then
        local player = Players:GetPlayers()[1] -- adaptável para jogador que apertou a tecla
        teleportarAlvo(player)
    end
end)

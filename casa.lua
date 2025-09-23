-- ServerScriptService/TeleportaMita.lua
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local NOME_ALVO = "mita_2060" -- Jogador que será teleportado
local DISTANCIA_FINAL = 3 -- Distância à frente do jogador que apertou a tecla

local function teleportarAlvo(player)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = player.Character.HumanoidRootPart
    local posPlayer = hrp.Position

    local alvo = Players:FindFirstChild(NOME_ALVO)
    if alvo and alvo.Character and alvo.Character:FindFirstChild("Humanoid") and alvo.Character:FindFirstChild("HumanoidRootPart") then
        local humanoid = alvo.Character.Humanoid
        local destino = posPlayer + Vector3.new(0, 0, -DISTANCIA_FINAL)

        -- Desativa movimentação temporariamente
        humanoid.PlatformStand = true
        -- Teleporta usando SetPrimaryPartCFrame
        alvo.Character:SetPrimaryPartCFrame(CFrame.new(destino))
        -- Reativa movimentação depois de 0.1s
        task.delay(0.1, function()
            humanoid.PlatformStand = false
        end)
    end
end

-- Detecta tecla
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.K then
        local player = Players:GetPlayers()[1] -- adaptável para o jogador que apertou a tecla
        teleportarAlvo(player)
    end
end)

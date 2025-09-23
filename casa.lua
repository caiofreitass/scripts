-- ServerScriptService/PuxarPlayers.lua
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local RAIO = 30 -- Distância máxima para puxar jogadores
local DISTANCIA_FINAL = 5 -- Distância final de onde você estará

-- Função para puxar jogadores próximos
local function puxarProximo(player)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local posPlayer = hrp.Position

    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local otherHrp = otherPlayer.Character.HumanoidRootPart
            local distancia = (otherHrp.Position - posPlayer).Magnitude
            if distancia <= RAIO then
                -- Move o jogador próximo para frente do player
                otherHrp.CFrame = CFrame.new(posPlayer + Vector3.new(0, 0, -DISTANCIA_FINAL))
            end
        end
    end
end

-- Detecta tecla
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.O then
        -- Puxa o jogador local e todos próximos
        local player = Players:GetPlayers()[1] -- No server, você pode adaptar para o jogador que pressionou
        puxarProximo(player)
    end
end)

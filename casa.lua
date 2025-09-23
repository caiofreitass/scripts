-- ServerScriptService/TeleportaMitaComTexto.lua
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local NOME_ALVO = "mita_2060" -- Jogador que será teleportado
local DISTANCIA_FINAL = 3 -- Distância à frente do jogador que apertou a tecla

-- Função para criar BillboardGui com texto
local function criarTextoAcimaJogador(alvo, texto)
    if not alvo.Character or not alvo.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = alvo.Character.HumanoidRootPart

    -- Remove GUI antiga se existir
    if hrp:FindFirstChild("NomeGui") then
        hrp.NomeGui:Destroy()
    end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "NomeGui"
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.Adornee = hrp
    billboard.AlwaysOnTop = true
    billboard.Parent = hrp

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 0, 0) -- vermelho
    label.TextStrokeTransparency = 0
    label.TextScaled = true
    label.Text = texto
    label.Parent = billboard
end

-- Função de teleporte
local function teleportarAlvo(player)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = player.Character.HumanoidRootPart
    local posPlayer = hrp.Position

    local alvo = Players:FindFirstChild(NOME_ALVO)
    if alvo and alvo.Character and alvo.Character:FindFirstChild("Humanoid") and alvo.Character:FindFirstChild("HumanoidRootPart") then
        local humanoid = alvo.Character.Humanoid
        local destino = posPlayer + Vector3.new(0, 0, -DISTANCIA_FINAL)

        -- Bloqueia movimento temporariamente
        humanoid.PlatformStand = true
        alvo.Character:SetPrimaryPartCFrame(CFrame.new(destino))
        task.delay(0.1, function()
            humanoid.PlatformStand = false
        end)

        -- Adiciona texto acima do jogador
        criarTextoAcimaJogador(alvo, "rapadura mole")
    end
end

-- Detecta tecla
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.K then
        local player = Players:GetPlayers()[1] -- adaptável
        teleportarAlvo(player)
    end
end)

-- ServerScriptService/PredioServidor.lua
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Dimensões do prédio
local NOME_PASTA = "Predio"
local PREDIO_WIDTH = 30
local PREDIO_LENGTH = 20
local PREDIO_HEIGHT = 8
local PAREDE_THICKNESS = 1
local NUM_ANDARES = 3
local PORTA_WIDTH = 6
local PORTA_HEIGHT = 7
local ESCADA_WIDTH = 4
local ESCADA_STEP_HEIGHT = 1
local ESCADA_STEP_DEPTH = 2

-- Função para criar uma part sólida
local function criarPart(size, pos, cor, parent)
    local part = Instance.new("Part")
    part.Size = size
    part.Position = pos
    part.Anchored = true
    part.CanCollide = true
    part.BrickColor = BrickColor.new(cor)
    part.Parent = parent
    return part
end

-- Função para criar o prédio
local function criarPredio()
    -- Remove pasta existente
    local pastaExistente = workspace:FindFirstChild(NOME_PASTA)
    if pastaExistente then pastaExistente:Destroy() end

    local pasta = Instance.new("Folder")
    pasta.Name = NOME_PASTA
    pasta.Parent = workspace

    -- Posiciona o prédio à frente do primeiro jogador
    local player = Players:GetPlayers()[1]
    if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = player.Character.HumanoidRootPart
    local frente = hrp.Position + hrp.CFrame.LookVector * (PREDIO_LENGTH + 10)

    -- Função para criar cada andar
    local function criarAndar(yBase)
        -- Chão
        criarPart(Vector3.new(PREDIO_WIDTH, PAREDE_THICKNESS, PREDIO_LENGTH), frente + Vector3.new(0, yBase + PAREDE_THICKNESS/2, 0), "Bright blue", pasta)

        -- Paredes laterais
        criarPart(Vector3.new(PAREDE_THICKNESS, PREDIO_HEIGHT, PREDIO_LENGTH), frente + Vector3.new(-PREDIO_WIDTH/2, yBase + PREDIO_HEIGHT/2, 0), "Bright blue", pasta)
        criarPart(Vector3.new(PAREDE_THICKNESS, PREDIO_HEIGHT, PREDIO_LENGTH), frente + Vector3.new(PREDIO_WIDTH/2, yBase + PREDIO_HEIGHT/2, 0), "Bright blue", pasta)

        -- Parede traseira
        criarPart(Vector3.new(PREDIO_WIDTH, PREDIO_HEIGHT, PAREDE_THICKNESS), frente + Vector3.new(0, yBase + PREDIO_HEIGHT/2, -PREDIO_LENGTH/2), "Bright blue", pasta)

        -- Parede frontal
        if yBase == 0 then
            -- Porta grande
            local ladoPorta = (PREDIO_WIDTH - PORTA_WIDTH) / 2
            criarPart(Vector3.new(ladoPorta, PREDIO_HEIGHT, PAREDE_THICKNESS), frente + Vector3.new(-(ladoPorta + PORTA_WIDTH)/2, yBase + PREDIO_HEIGHT/2, PREDIO_LENGTH/2), "Bright blue", pasta)
            criarPart(Vector3.new(ladoPorta, PREDIO_HEIGHT, PAREDE_THICKNESS), frente + Vector3.new((ladoPorta + PORTA_WIDTH)/2, yBase + PREDIO_HEIGHT/2, PREDIO_LENGTH/2), "Bright blue", pasta)
        else
            -- Andares superiores
            criarPart(Vector3.new(PREDIO_WIDTH, PREDIO_HEIGHT, PAREDE_THICKNESS), frente + Vector3.new(0, yBase + PREDIO_HEIGHT/2, PREDIO_LENGTH/2), "Bright blue", pasta)
        end

        -- Teto do andar
        criarPart(Vector3.new(PREDIO_WIDTH, PAREDE_THICKNESS, PREDIO_LENGTH), frente + Vector3.new(0, yBase + PREDIO_HEIGHT + PAREDE_THICKNESS/2, 0), "Bright blue", pasta)
    end

    -- Criar todos os andares
    for i = 0, NUM_ANDARES-1 do
        criarAndar(i * PREDIO_HEIGHT)
    end

    -- Criar escada interna com abertura no teto
    local escadaX = -PREDIO_WIDTH/2 + ESCADA_WIDTH/2 + 1
    local escadaZ = -PREDIO_LENGTH/2 + ESCADA_STEP_DEPTH/2 + 1
    for andar = 0, NUM_ANDARES-1 do
        for step = 0, PREDIO_HEIGHT - 1 do
            criarPart(Vector3.new(ESCADA_WIDTH, ESCADA_STEP_HEIGHT, ESCADA_STEP_DEPTH),
                frente + Vector3.new(escadaX, andar * PREDIO_HEIGHT + step + ESCADA_STEP_HEIGHT/2, escadaZ + step * ESCADA_STEP_DEPTH), "Reddish brown", pasta)
        end
        -- Abre espaço no teto para próxima escada
        if andar < NUM_ANDARES-1 then
            criarPart(Vector3.new(ESCADA_WIDTH, PAREDE_THICKNESS/2, ESCADA_STEP_DEPTH), 
                frente + Vector3.new(escadaX, (andar+1) * PREDIO_HEIGHT - PAREDE_THICKNESS/4, escadaZ + (PREDIO_HEIGHT-1) * ESCADA_STEP_DEPTH), "Bright blue", pasta)
        end
    end
end

-- Função para remover o prédio
local function removerPredio()
    local pasta = workspace:FindFirstChild(NOME_PASTA)
    if pasta then pasta:Destroy() end
end

-- Detecta teclas
Players.PlayerAdded:Connect(function(player)
    -- Para testes, cada jogador local poderia usar RemoteEvent, mas aqui usamos RunService para exemplo
    RunService.RenderStepped:Connect(function()
        -- Não faz nada, só mantém o script rodando
    end)
end)

-- Para testes, usar RemoteEvent ou BindAction para criar/remover
-- Aqui simplificado para criar/remover usando o primeiro jogador
local uis = game:GetService("UserInputService")
uis.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Semicolon then
        criarPredio()
    elseif input.KeyCode == Enum.KeyCode.P then
        removerPredio()
    end
end)

-- CasaGiganteComPasta.lua
local UserInput = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

-- Nome da pasta que armazenará a casa
local NOME_PASTA = "MinhaCasa"

-- Dimensões da casa
local CASA_WIDTH = 40
local CASA_LENGTH = 30
local CASA_HEIGHT = 8
local PAREDE_THICKNESS = 1

-- Tamanho da abertura frontal
local ABERTURA_LARGURA = 4

-- Função para criar uma part
local function criarPart(size, pos, cor, parent)
    local part = Instance.new("Part")
    part.Size = size
    part.Position = pos
    part.Anchored = true
    part.BrickColor = BrickColor.new(cor)
    part.Parent = parent or workspace
    return part
end

-- Função que cria a casa gigante dentro da pasta
local function criarCasa()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local frente = hrp.Position + hrp.CFrame.LookVector * (CASA_LENGTH + 10)

    -- Cria a pasta, removendo se já existir
    local pastaExistente = workspace:FindFirstChild(NOME_PASTA)
    if pastaExistente then pastaExistente:Destroy() end
    local pastaCasa = Instance.new("Folder")
    pastaCasa.Name = NOME_PASTA
    pastaCasa.Parent = workspace

    -- Função auxiliar para criar cada andar
    local function criarAndar(yBase)
        -- Chão do andar
        criarPart(Vector3.new(CASA_WIDTH, PAREDE_THICKNESS, CASA_LENGTH), frente + Vector3.new(0, yBase + PAREDE_THICKNESS/2, 0), "Bright red", pastaCasa)

        -- Paredes frontais com abertura
        local aberturaMeio = ABERTURA_LARGURA
        local paredeLado = (CASA_WIDTH - aberturaMeio) / 2

        criarPart(Vector3.new(paredeLado, CASA_HEIGHT, PAREDE_THICKNESS), frente + Vector3.new(-(paredeLado+aberturaMeio)/2, yBase + CASA_HEIGHT/2, CASA_LENGTH/2), "Bright red", pastaCasa)
        criarPart(Vector3.new(paredeLado, CASA_HEIGHT, PAREDE_THICKNESS), frente + Vector3.new((paredeLado+aberturaMeio)/2, yBase + CASA_HEIGHT/2, CASA_LENGTH/2), "Bright red", pastaCasa)

        -- Parede traseira inteira
        criarPart(Vector3.new(CASA_WIDTH, CASA_HEIGHT, PAREDE_THICKNESS), frente + Vector3.new(0, yBase + CASA_HEIGHT/2, -CASA_LENGTH/2), "Bright red", pastaCasa)

        -- Paredes laterais
        criarPart(Vector3.new(PAREDE_THICKNESS, CASA_HEIGHT, CASA_LENGTH), frente + Vector3.new(-CASA_WIDTH/2, yBase + CASA_HEIGHT/2, 0), "Bright red", pastaCasa)
        criarPart(Vector3.new(PAREDE_THICKNESS, CASA_HEIGHT, CASA_LENGTH), frente + Vector3.new(CASA_WIDTH/2, yBase + CASA_HEIGHT/2, 0), "Bright red", pastaCasa)

        -- Teto do andar
        criarPart(Vector3.new(CASA_WIDTH, PAREDE_THICKNESS, CASA_LENGTH), frente + Vector3.new(0, yBase + CASA_HEIGHT + PAREDE_THICKNESS/2, 0), "Bright red", pastaCasa)
    end

    -- Cria dois andares
    criarAndar(0)               -- 1º andar
    criarAndar(CASA_HEIGHT)     -- 2º andar
end

-- Função para remover a pasta inteira
local function removerCasa()
    local pasta = workspace:FindFirstChild(NOME_PASTA)
    if pasta then
        pasta:Destroy()
    end
end

-- Detecta teclas
UserInput.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    -- Ç cria a casa
    if input.KeyCode == Enum.KeyCode.Semicolon then
        criarCasa()
    -- P remove a pasta/casa
    elseif input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == "P" then
        removerCasa()
    end
end)

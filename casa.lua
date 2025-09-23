-- CasaGiganteVazia.lua
local UserInput = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

-- Dimensões da casa
local CASA_WIDTH = 40      -- largura
local CASA_LENGTH = 30     -- comprimento
local CASA_HEIGHT = 8      -- altura de cada andar
local PAREDE_THICKNESS = 1

-- Tamanho das aberturas
local ABERTURA_LARGURA = 4
local ABERTURA_ALTURA = 7

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

-- Função que cria a casa gigante com aberturas
local function criarCasa()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local frente = hrp.Position + hrp.CFrame.LookVector * (CASA_LENGTH + 10)

    local model = Instance.new("Model")
    model.Name = "CasaGiganteVazia"
    model.Parent = workspace

    -- Função auxiliar para criar um andar com abertura frontal
    local function criarAndar(yBase)
        -- Chão do andar
        criarPart(Vector3.new(CASA_WIDTH, PAREDE_THICKNESS, CASA_LENGTH), frente + Vector3.new(0, yBase + PAREDE_THICKNESS/2, 0), "Bright red", model)

        -- Paredes: frontal dividida para abrir espaço no meio
        local aberturaMeio = ABERTURA_LARGURA
        local paredeLado = (CASA_WIDTH - aberturaMeio) / 2

        -- Paredes frontal esquerda
        criarPart(Vector3.new(paredeLado, CASA_HEIGHT, PAREDE_THICKNESS), frente + Vector3.new(-(paredeLado+aberturaMeio)/2, yBase + CASA_HEIGHT/2, CASA_LENGTH/2), "Bright red", model)
        -- Paredes frontal direita
        criarPart(Vector3.new(paredeLado, CASA_HEIGHT, PAREDE_THICKNESS), frente + Vector3.new((paredeLado+aberturaMeio)/2, yBase + CASA_HEIGHT/2, CASA_LENGTH/2), "Bright red", model)

        -- Parede traseira inteira
        criarPart(Vector3.new(CASA_WIDTH, CASA_HEIGHT, PAREDE_THICKNESS), frente + Vector3.new(0, yBase + CASA_HEIGHT/2, -CASA_LENGTH/2), "Bright red", model)

        -- Paredes laterais
        criarPart(Vector3.new(PAREDE_THICKNESS, CASA_HEIGHT, CASA_LENGTH), frente + Vector3.new(-CASA_WIDTH/2, yBase + CASA_HEIGHT/2, 0), "Bright red", model)
        criarPart(Vector3.new(PAREDE_THICKNESS, CASA_HEIGHT, CASA_LENGTH), frente + Vector3.new(CASA_WIDTH/2, yBase + CASA_HEIGHT/2, 0), "Bright red", model)

        -- Teto do andar
        criarPart(Vector3.new(CASA_WIDTH, PAREDE_THICKNESS, CASA_LENGTH), frente + Vector3.new(0, yBase + CASA_HEIGHT + PAREDE_THICKNESS/2, 0), "Bright red", model)
    end

    -- Cria dois andares
    criarAndar(0)               -- 1º andar
    criarAndar(CASA_HEIGHT)     -- 2º andar
end

-- Detecta tecla ç
UserInput.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Semicolon then
        criarCasa()
    end
end)

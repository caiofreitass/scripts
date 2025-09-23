-- CasaGiganteComColisao.lua
local UserInput = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local NOME_PASTA = "MinhaCasa"

-- Dimensões da casa
local CASA_WIDTH = 40
local CASA_LENGTH = 30
local CASA_HEIGHT = 8
local PAREDE_THICKNESS = 1
local ABERTURA_LARGURA = 4

-- Função para criar part com colisão
local function criarPart(size, pos, cor, parent)
    local part = Instance.new("Part")
    part.Size = size
    part.Position = pos
    part.Anchored = true
    part.CanCollide = true -- todos colidem
    part.BrickColor = BrickColor.new(cor)
    part.Parent = parent or workspace
    return part
end

-- Função para criar a casa gigante
local function criarCasa()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local frente = hrp.Position + hrp.CFrame.LookVector * (CASA_LENGTH + 10)

    -- Remove pasta se já existir
    local pastaExistente = workspace:FindFirstChild(NOME_PASTA)
    if pastaExistente then pastaExistente:Destroy() end
    local pastaCasa = Instance.new("Folder")
    pastaCasa.Name = NOME_PASTA
    pastaCasa.Parent = workspace

    local function criarAndar(yBase)
        -- Chão
        criarPart(Vector3.new(CASA_WIDTH, PAREDE_THICKNESS, CASA_LENGTH), frente + Vector3.new(0, yBase + PAREDE_THICKNESS/2, 0), "Bright red", pastaCasa)

        local aberturaMeio = ABERTURA_LARGURA
        local paredeLado = (CASA_WIDTH - aberturaMeio) / 2

        -- Paredes frontais
        criarPart(Vector3.new(paredeLado, CASA_HEIGHT, PAREDE_THICKNESS), frente + Vector3.new(-(paredeLado+aberturaMeio)/2, yBase + CASA_HEIGHT/2, CASA_LENGTH/2), "Bright red", pastaCasa)
        criarPart(Vector3.new(paredeLado, CASA_HEIGHT, PAREDE_THICKNESS), frente + Vector3.new((paredeLado+aberturaMeio)/2, yBase + CASA_HEIGHT/2, CASA_LENGTH/2), "Bright red", pastaCasa)

        -- Parede traseira
        criarPart(Vector3.new(CASA_WIDTH, CASA_HEIGHT, PAREDE_THICKNESS), frente + Vector3.new(0, yBase + CASA_HEIGHT/2, -CASA_LENGTH/2), "Bright red", pastaCasa)

        -- Laterais
        criarPart(Vector3.new(PAREDE_THICKNESS, CASA_HEIGHT, CASA_LENGTH), frente + Vector3.new(-CASA_WIDTH/2, yBase + CASA_HEIGHT/2, 0), "Bright red", pastaCasa)
        criarPart(Vector3.new(PAREDE_THICKNESS, CASA_HEIGHT, CASA_LENGTH), frente + Vector3.new(CASA_WIDTH/2, yBase + CASA_HEIGHT/2, 0), "Bright red", pastaCasa)

        -- Teto
        criarPart(Vector3.new(CASA_WIDTH, PAREDE_THICKNESS, CASA_LENGTH), frente + Vector3.new(0, yBase + CASA_HEIGHT + PAREDE_THICKNESS/2, 0), "Bright red", pastaCasa)
    end

    criarAndar(0)           -- 1º andar
    criarAndar(CASA_HEIGHT) -- 2º andar
end

-- Função para remover a casa
local function removerCasa()
    local pasta = workspace:FindFirstChild(NOME_PASTA)
    if pasta then
        pasta:Destroy()
    end
end

-- Detecta teclas
UserInput.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Semicolon then
        criarCasa()
    elseif input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == "P" then
        removerCasa()
    end
end)

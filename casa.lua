-- CasaGiganteVaziaComRemoveEPhysics.lua
local UserInput = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

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

-- Função que cria a casa gigante com abertura frontal
local function criarCasa()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local frente = hrp.Position + hrp.CFrame.LookVector * (CASA_LENGTH + 10)

    local model = Instance.new("Model")
    model.Name = "CasaGiganteVazia"
    model.Parent = workspace

    -- Função auxiliar para criar cada andar
    local function criarAndar(yBase)
        -- Chão do andar
        criarPart(Vector3.new(CASA_WIDTH, PAREDE_THICKNESS, CASA_LENGTH), frente + Vector3.new(0, yBase + PAREDE_THICKNESS/2, 0), "Bright red", model)

        -- Paredes frontais com abertura
        local aberturaMeio = ABERTURA_LARGURA
        local paredeLado = (CASA_WIDTH - aberturaMeio) / 2

        criarPart(Vector3.new(paredeLado, CASA_HEIGHT, PAREDE_THICKNESS), frente + Vector3.new(-(paredeLado+aberturaMeio)/2, yBase + CASA_HEIGHT/2, CASA_LENGTH/2), "Bright red", model)
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

-- Função para remover todas as casas criadas
local function removerCasas()
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj.Name == "CasaGiganteVazia" then
            obj:Destroy()
        end
    end
end

-- Função para desancorar todas as parts das casas
local function liberarCasas()
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj.Name == "CasaGiganteVazia" then
            for _, part in pairs(obj:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Anchored = false
                end
            end
        end
    end
end

-- Detecta teclas
UserInput.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Semicolon then
        criarCasa()
    elseif input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == "P" then
        removerCasas()
    elseif input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == "O" then
        liberarCasas()
    end
end)

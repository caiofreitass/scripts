-- CriarCasa.lua (LocalScript)
local UserInput = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- Dimensões da casa
local CASA_WIDTH = 10
local CASA_LENGTH = 10
local CASA_HEIGHT = 6
local PAREDE_THICKNESS = 1

-- Função para criar uma part
local function criarPart(size, pos, cor)
    local part = Instance.new("Part")
    part.Size = size
    part.Position = pos
    part.Anchored = true
    part.BrickColor = BrickColor.new(cor)
    part.Parent = workspace
    return part
end

-- Função que cria a casa à frente do jogador
local function criarCasa()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart

    -- Posição base: à frente do jogador
    local frente = hrp.Position + hrp.CFrame.LookVector * (CASA_LENGTH + 5)

    -- Cria chão
    criarPart(Vector3.new(CASA_WIDTH, PAREDE_THICKNESS, CASA_LENGTH), frente + Vector3.new(0, PAREDE_THICKNESS/2, 0), "Bright red")

    -- Cria paredes
    -- Parede frontal
    criarPart(Vector3.new(CASA_WIDTH, CASA_HEIGHT, PAREDE_THICKNESS), frente + Vector3.new(0, CASA_HEIGHT/2, CASA_LENGTH/2), "Bright red")
    -- Parede traseira
    criarPart(Vector3.new(CASA_WIDTH, CASA_HEIGHT, PAREDE_THICKNESS), frente + Vector3.new(0, CASA_HEIGHT/2, -CASA_LENGTH/2), "Bright red")
    -- Parede lateral esquerda
    criarPart(Vector3.new(PAREDE_THICKNESS, CASA_HEIGHT, CASA_LENGTH), frente + Vector3.new(-CASA_WIDTH/2, CASA_HEIGHT/2, 0), "Bright red")
    -- Parede lateral direita
    criarPart(Vector3.new(PAREDE_THICKNESS, CASA_HEIGHT, CASA_LENGTH), frente + Vector3.new(CASA_WIDTH/2, CASA_HEIGHT/2, 0), "Bright red")

    -- Cria teto
    criarPart(Vector3.new(CASA_WIDTH, PAREDE_THICKNESS, CASA_LENGTH), frente + Vector3.new(0, CASA_HEIGHT + PAREDE_THICKNESS/2, 0), "Bright red")
end

-- Detecta tecla pressionada
UserInput.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Semicolon then -- tecla Ç normalmente é KeyCode.Semicolon
        criarCasa()
    end
end)

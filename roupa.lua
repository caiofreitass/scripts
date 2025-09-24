local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Espera o personagem
local char = player.Character or player.CharacterAdded:Wait()
local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
if not torso then return end

-- Lista de partes da armadura
local armaduraParts = {}

-- Função para criar uma peça de armadura
local function criarArmadura(tamanho, cor, offset)
    local part = Instance.new("Part")
    part.Size = tamanho
    part.BrickColor = BrickColor.new(cor)
    part.Anchored = true
    part.CanCollide = false
    part.Transparency = 0.3
    part.Parent = workspace

    -- Atualiza posição a cada frame
    local conn
    conn = RunService.RenderStepped:Connect(function()
        if char.PrimaryPart then
            part.CFrame = char.PrimaryPart.CFrame * CFrame.new(offset)
        else
            conn:Disconnect()
        end
    end)

    table.insert(armaduraParts, part)
end

-- Função para ativar armadura
local function ativarArmadura()
    if #armaduraParts > 0 then return end
    criarArmadura(Vector3.new(2,3,1), "Bright blue", Vector3.new(0,0,0))   -- Torso
    criarArmadura(Vector3.new(3,1,1), "Bright red", Vector3.new(0,1.5,0))    -- Ombros
    criarArmadura(Vector3.new(1,3,1), "Bright green", Vector3.new(-1,0,0))   -- Braço esquerdo
    criarArmadura(Vector3.new(1,3,1), "Bright green", Vector3.new(1,0,0))    -- Braço direito
    criarArmadura(Vector3.new(2,1,1), "Bright yellow", Vector3.new(0,-1.5,0)) -- Cintura
end

-- Função para desativar armadura
local function desativarArmadura()
    for _, part in pairs(armaduraParts) do
        part:Destroy()
    end
    armaduraParts = {}
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "ArmaduraGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0,150,0,50)
btn.Position = UDim2.new(0,10,0,10)
btn.Text = "Ativar/Desativar Armadura"
btn.BackgroundColor3 = Color3.fromRGB(0,150,255)
btn.TextColor3 = Color3.new(1,1,1)
btn.Font = Enum.Font.SourceSansBold
btn.TextScaled = true
btn.Parent = gui

-- Alterna armadura ao clicar
btn.MouseButton1Click:Connect(function()
    if #armaduraParts == 0 then
        ativarArmadura()
    else
        desativarArmadura()
    end
end)

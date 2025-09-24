-- === Armadura Visual “Ilusão Global” ===
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local char = player.Character or player.CharacterAdded:Wait()
local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
local head = char:FindFirstChild("Head")

local partesClone = {}
local distancia = Vector3.new(0,0,5) -- distância da ilusão
local ativo = false

-- Cria uma parte neon como “armadura”
local function criarParteClone(nome, tamanho, cor, offset)
    local part = Instance.new("Part")
    part.Size = tamanho
    part.BrickColor = BrickColor.new(cor)
    part.Anchored = true
    part.CanCollide = false
    part.Material = Enum.Material.Neon
    part.Parent = workspace
    part.Name = nome
    table.insert(partesClone, {part=part, offset=offset})
end

-- Ativar armadura
local function ativarArmadura()
    if ativo then return end
    ativo = true

    criarParteClone("TorsoClone", Vector3.new(2,3,1), "Bright blue", Vector3.new(0,0,0))
    criarParteClone("CapaClone", Vector3.new(2.5,4,0.3), "Bright orange", Vector3.new(0,-1,0))
    criarParteClone("ElmoClone", Vector3.new(2,1,2), "Bright purple", Vector3.new(0,2,0))

    RunService.RenderStepped:Connect(function()
        local t = tick()
        for _, p in pairs(partesClone) do
            p.part.CFrame = torso.CFrame * CFrame.new(p.offset + Vector3.new(math.sin(t)*0.2,0,math.cos(t)*0.2))
        end
    end)
end

-- Desativar armadura
local function desativarArmadura()
    for _, p in pairs(partesClone) do
        p.part:Destroy()
    end
    partesClone = {}
    ativo = false
end

-- GUI simples
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

local btnToggle = Instance.new("TextButton")
btnToggle.Size = UDim2.new(0,220,0,50)
btnToggle.Position = UDim2.new(0,10,0,10)
btnToggle.Text = "Ativar/Desativar Armadura"
btnToggle.Parent = gui

btnToggle.MouseButton1Click:Connect(function()
    if ativo then
        desativarArmadura()
    else
        ativarArmadura()
    end
end)

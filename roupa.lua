local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Espera o personagem
local char = player.Character or player.CharacterAdded:Wait()

-- Partes principais
local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
local leftArm = char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm")
local rightArm = char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm")
local leftLeg = char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("Left Leg")
local rightLeg = char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg")
local head = char:FindFirstChild("Head")

local armaduraParts = {}
local capa, elmo
local espadas = {}

-- Função para criar parte visual
local function criarParte(parteBase, tamanho, cor, offset, transpar)
    if not parteBase then return end
    local part = Instance.new("Part")
    part.Size = tamanho
    part.BrickColor = BrickColor.new(cor)
    part.Anchored = true
    part.CanCollide = false
    part.Transparency = transpar or 0.3
    part.Material = Enum.Material.Neon
    part.Parent = workspace

    local conn
    conn = RunService.RenderStepped:Connect(function()
        if parteBase.Parent then
            part.CFrame = parteBase.CFrame * CFrame.new(offset)
        else
            conn:Disconnect()
        end
    end)

    table.insert(armaduraParts, part)
    return part
end

-- Função para criar espada flutuante
local function criarEspada(distancia, angulo, cor)
    local part = Instance.new("Part")
    part.Size = Vector3.new(0.2,3,0.5)
    part.Anchored = true
    part.CanCollide = false
    part.BrickColor = BrickColor.new(cor)
    part.Material = Enum.Material.Neon
    part.Parent = workspace
    table.insert(espadas, {part=part, distancia=distancia, angulo=angulo})
end

-- Ativar armadura épica
local function ativarArmadura()
    if #armaduraParts > 0 then return end

    -- Corpo e cabeça
    criarParte(torso, Vector3.new(2,3,1), "Bright blue", Vector3.new(0,0,0))
    criarParte(leftArm, Vector3.new(1,3,1), "Bright green", Vector3.new(0,0,0))
    criarParte(rightArm, Vector3.new(1,3,1), "Bright green", Vector3.new(0,0,0))
    criarParte(leftLeg, Vector3.new(1,3,1), "Bright yellow", Vector3.new(0,0,0))
    criarParte(rightLeg, Vector3.new(1,3,1), "Bright yellow", Vector3.new(0,0,0))
    elmo = criarParte(head, Vector3.new(2,1,2), "Bright purple", Vector3.new(0,0,0))

    -- Ombreiras
    criarParte(leftArm, Vector3.new(2,1,1), "Bright red", Vector3.new(0,1.5,0))
    criarParte(rightArm, Vector3.new(2,1,1), "Bright red", Vector3.new(0,1.5,0))

    -- Capa animada
    capa = criarParte(torso, Vector3.new(2.5,4,0.3), "Bright orange", Vector3.new(0,-1,0), 0.4)
    RunService.RenderStepped:Connect(function()
        if capa then
            local t = tick()
            capa.CFrame = torso.CFrame * CFrame.new(0,-1,0) * CFrame.Angles(0, math.sin(t*2)*0.2, 0)
        end
    end)

    -- Espadas flutuantes
    criarEspada(3, 0, "Bright red")
    criarEspada(3, math.pi/2, "Bright blue")
    criarEspada(3, math.pi, "Bright green")
    criarEspada(3, math.pi*1.5, "Bright yellow")

    RunService.RenderStepped:Connect(function()
        local t = tick()
        for i, espada in pairs(espadas) do
            espada.part.CFrame = torso.CFrame * CFrame.new(
                espada.distancia*math.cos(t + espada.angulo),
                1.5,
                espada.distancia*math.sin(t + espada.angulo)
            )
        end
        if elmo then
            elmo.CFrame = head.CFrame * CFrame.Angles(0, t*1.5, 0)
        end
    end)

    -- Efeito brilho pulsante
    for _, part in pairs(armaduraParts) do
        RunService.RenderStepped:Connect(function()
            local alpha = (math.sin(tick()*3)+1)/2*0.3 + 0.2
            part.Transparency = alpha
        end)
    end
end

-- Desativar armadura
local function desativarArmadura()
    for _, part in pairs(armaduraParts) do part:Destroy() end
    for _, espada in pairs(espadas) do espada.part:Destroy() end
    armaduraParts = {}
    espadas = {}
    capa = nil
    elmo = nil
end

-- Mudar cor da armadura
local function mudarCor(cor)
    for _, part in pairs(armaduraParts) do
        part.BrickColor = BrickColor.new(cor)
    end
    for _, espada in pairs(espadas) do
        espada.part.BrickColor = BrickColor.new(cor)
    end
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "ArmaduraGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local btnToggle = Instance.new("TextButton")
btnToggle.Size = UDim2.new(0,200,0,50)
btnToggle.Position = UDim2.new(0,10,0,10)
btnToggle.Text = "Ativar/Desativar Armadura Épica"
btnToggle.BackgroundColor3 = Color3.fromRGB(0,150,255)
btnToggle.TextColor3 = Color3.new(1,1,1)
btnToggle.Font = Enum.Font.SourceSansBold
btnToggle.TextScaled = true
btnToggle.Parent = gui

local btnCor = Instance.new("TextButton")
btnCor.Size = UDim2.new(0,200,0,50)
btnCor.Position = UDim2.new(0,10,0,70)
btnCor.Text = "Mudar Cor"
btnCor.BackgroundColor3 = Color3.fromRGB(255,100,50)
btnCor.TextColor3 = Color3.new(1,1,1)
btnCor.Font = Enum.Font.SourceSansBold
btnCor.TextScaled = true
btnCor.Parent = gui

local cores = {"Bright blue","Bright red","Bright green","Bright yellow","Bright purple","Bright orange"}
local indice = 1

btnToggle.MouseButton1Click:Connect(function()
    if #armaduraParts == 0 then
        ativarArmadura()
    else
        desativarArmadura()
    end
end)

btnCor.MouseButton1Click:Connect(function()
    if #armaduraParts > 0 then
        mudarCor(cores[indice])
        indice = indice + 1
        if indice > #cores then indice = 1 end
    end
end)

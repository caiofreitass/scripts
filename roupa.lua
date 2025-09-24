local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
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
local particulas = {}

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

-- Função criar espada flutuante
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

-- Função criar partículas neon
local function criarParticula(offset)
    local part = Instance.new("Part")
    part.Size = Vector3.new(0.2,0.2,0.2)
    part.Anchored = true
    part.CanCollide = false
    part.Material = Enum.Material.Neon
    part.BrickColor = BrickColor.Random()
    part.Transparency = 0
    part.Parent = workspace
    table.insert(particulas, {part=part, offset=offset})
end

-- Ativar armadura ultra-épica
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

    -- Capa balançando
    capa = criarParte(torso, Vector3.new(2.5,4,0.3), "Bright orange", Vector3.new(0,-1,0),0.4)

    -- Espadas flutuantes
    criarEspada(3, 0, "Bright red")
    criarEspada(3, math.pi/2, "Bright blue")
    criarEspada(3, math.pi, "Bright green")
    criarEspada(3, math.pi*1.5, "Bright yellow")

    -- Partículas neon saindo do torso
    for i=1,8 do
        criarParticula(Vector3.new(math.random(-1,1),math.random(0,2),math.random(-1,1)))
    end

    RunService.RenderStepped:Connect(function()
        local t = tick()
        -- Capa balançando
        if capa then
            capa.CFrame = torso.CFrame * CFrame.new(0,-1,0) * CFrame.Angles(0, math.sin(t*2)*0.25, 0)
        end
        -- Espadas girando
        for _, espada in pairs(espadas) do
            espada.part.CFrame = torso.CFrame * CFrame.new(
                espada.distancia*math.cos(t + espada.angulo),
                1.5,
                espada.distancia*math.sin(t + espada.angulo)
            )
        end
        -- Elmo rotativo flutuante
        if elmo then
            elmo.CFrame = head.CFrame * CFrame.new(0,0.2*math.sin(t*2),0) * CFrame.Angles(0, t*1.5, 0)
        end
        -- Partículas piscando
        for _, p in pairs(particulas) do
            p.part.CFrame = torso.CFrame * CFrame.new(p.offset)
            p.part.BrickColor = BrickColor.Random()
            p.part.Transparency = 0.3 + 0.7*math.abs(math.sin(t*3))
        end
        -- Brilho pulsante nas peças
        for _, part in pairs(armaduraParts) do
            part.Transparency = 0.2 + 0.2*math.abs(math.sin(t*3))
        end
    end)
end

-- Desativar armadura
local function desativarArmadura()
    for _, part in pairs(armaduraParts) do part:Destroy() end
    for _, espada in pairs(espadas) do espada.part:Destroy() end
    for _, p in pairs(particulas) do p.part:Destroy() end
    armaduraParts = {}
    espadas = {}
    particulas = {}
    capa = nil
    elmo = nil
end

-- Mudar cor da armadura
local function mudarCor(cor)
    for _, part in pairs(armaduraParts) do part.BrickColor = BrickColor.new(cor) end
    for _, espada in pairs(espadas) do espada.part.BrickColor = BrickColor.new(cor) end
    for _, p in pairs(particulas) do p.part.BrickColor = BrickColor.new(cor) end
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "ArmaduraUltraGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local btnToggle = Instance.new("TextButton")
btnToggle.Size = UDim2.new(0,220,0,50)
btnToggle.Position = UDim2.new(0,10,0,10)
btnToggle.Text = "Ativar/Desativar Armadura Ultra"
btnToggle.BackgroundColor3 = Color3.fromRGB(0,150,255)
btnToggle.TextColor3 = Color3.new(1,1,1)
btnToggle.Font = Enum.Font.SourceSansBold
btnToggle.TextScaled = true
btnToggle.Parent = gui

local btnCor = Instance.new("TextButton")
btnCor.Size = UDim2.new(0,220,0,50)
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

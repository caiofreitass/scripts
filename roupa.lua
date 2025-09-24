local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Espera o personagem
local char = player.Character or player.CharacterAdded:Wait()
local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
local head = char:FindFirstChild("Head")

-- Partes e efeitos
local armaduraParts, espadas, particulas, ataques = {}, {}, {}, {}
local capa, elmo
local voando = false
local velocidadeVoo = 10

-- Funções principais já definidas anteriormente
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
    RunService.RenderStepped:Connect(function()
        if parteBase.Parent then
            part.CFrame = parteBase.CFrame * CFrame.new(offset)
        end
    end)
    table.insert(armaduraParts, part)
    return part
end

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

local function criarAtaque()
    local part = Instance.new("Part")
    part.Size = Vector3.new(0.2,5,0.2)
    part.Anchored = true
    part.CanCollide = false
    part.Material = Enum.Material.Neon
    part.BrickColor = BrickColor.Random()
    part.Transparency = 0.3
    part.Parent = workspace
    table.insert(ataques, part)
    local tween = TweenService:Create(part, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {Size=Vector3.new(0.2,10,0.2)})
    tween:Play()
    task.delay(0.5, function() part:Destroy() end)
end

-- Ativar armadura + voo
local function ativarArmadura()
    if #armaduraParts > 0 then return end
    -- Corpo, cabeça, ombreiras, capa
    criarParte(torso, Vector3.new(2,3,1), "Bright blue", Vector3.new(0,0,0))
    criarParte(head, Vector3.new(2,1,2), "Bright purple", Vector3.new(0,0,0))
    capa = criarParte(torso, Vector3.new(2.5,4,0.3), "Bright orange", Vector3.new(0,-1,0),0.4)
    criarEspada(3,0,"Bright red")
    criarEspada(3,math.pi/2,"Bright blue")
    criarEspada(3,math.pi,"Bright green")
    criarEspada(3,math.pi*1.5,"Bright yellow")
    for i=1,8 do criarParticula(Vector3.new(math.random(-1,1),math.random(0,2),math.random(-1,1))) end

    RunService.RenderStepped:Connect(function()
        local t = tick()
        if capa then capa.CFrame = torso.CFrame * CFrame.new(0,-1,0) * CFrame.Angles(0, math.sin(t*2)*0.25, 0) end
        for _, espada in pairs(espadas) do
            espada.part.CFrame = torso.CFrame * CFrame.new(espada.distancia*math.cos(t + espada.angulo),1.5,espada.distancia*math.sin(t + espada.angulo))
        end
        for _, p in pairs(particulas) do
            p.part.CFrame = torso.CFrame * CFrame.new(p.offset)
            p.part.BrickColor = BrickColor.Random()
            p.part.Transparency = 0.3 + 0.7*math.abs(math.sin(t*3))
        end
        if voando then
            torso.CFrame = torso.CFrame + Vector3.new(0, math.sin(t*3)*0.05, 0)
        end
    end)
end

local function desativarArmadura()
    for _, part in pairs(armaduraParts) do part:Destroy() end
    for _, espada in pairs(espadas) do espada.part:Destroy() end
    for _, p in pairs(particulas) do p.part:Destroy() end
    for _, atk in pairs(ataques) do atk:Destroy() end
    armaduraParts, espadas, particulas, ataques = {}, {}, {}, {}
    capa = nil
    voando = false
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

local btnToggle = Instance.new("TextButton")
btnToggle.Size = UDim2.new(0,220,0,50)
btnToggle.Position = UDim2.new(0,10,0,10)
btnToggle.Text = "Ativar/Desativar Armadura"
btnToggle.Parent = gui

local btnCor = Instance.new("TextButton")
btnCor.Size = UDim2.new(0,220,0,50)
btnCor.Position = UDim2.new(0,10,0,70)
btnCor.Text = "Mudar Cor"
btnCor.Parent = gui

local btnAtaque = Instance.new("TextButton")
btnAtaque.Size = UDim2.new(0,220,0,50)
btnAtaque.Position = UDim2.new(0,10,0,130)
btnAtaque.Text = "Ataque de Raio"
btnAtaque.Parent = gui

local btnVoo = Instance.new("TextButton")
btnVoo.Size = UDim2.new(0,220,0,50)
btnVoo.Position = UDim2.new(0,10,0,190)
btnVoo.Text = "Ativar/Desativar Voo"
btnVoo.Parent = gui

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
        for _, part in pairs(armaduraParts) do part.BrickColor = BrickColor.new(cores[indice]) end
        indice = indice + 1
        if indice > #cores then indice = 1 end
    end
end)

btnAtaque.MouseButton1Click:Connect(function()
    if #armaduraParts > 0 then
        for i=1,6 do criarAtaque() end
    end
end)

btnVoo.MouseButton1Click:Connect(function()
    if #armaduraParts > 0 then
        voando = not voando
    end
end)

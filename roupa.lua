-- === BLOCO ÚNICO: Armadura Visual para Todos ===
-- LocalScript + RemoteEvent

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- Criar RemoteEvent se não existir
local remote = ReplicatedStorage:FindFirstChild("ArmaduraRemote")
if not remote then
    remote = Instance.new("RemoteEvent")
    remote.Name = "ArmaduraRemote"
    remote.Parent = ReplicatedStorage
end

-- ================= SERVER =================
if game:GetService("RunService"):IsServer() then
    local Armaduras = {} -- Armazenar armaduras de cada jogador

    local function criarParteServidor(nome, tamanho, cor)
        local part = Instance.new("Part")
        part.Name = nome
        part.Size = tamanho
        part.BrickColor = BrickColor.new(cor)
        part.Anchored = true
        part.CanCollide = false
        part.Material = Enum.Material.Neon
        part.Parent = workspace
        return part
    end

    remote.OnServerEvent:Connect(function(player, acao, dados)
        if acao == "criar" then
            if Armaduras[player] then return end
            local torso = dados.TorsoCFrame
            local parts = {}
            parts["torso"] = criarParteServidor(player.Name.."_Torso", Vector3.new(2,3,1), "Bright blue")
            parts["capa"] = criarParteServidor(player.Name.."_Capa", Vector3.new(2.5,4,0.3), "Bright orange")
            Armaduras[player] = parts
        elseif acao == "atualizar" then
            local parts = Armaduras[player]
            if not parts then return end
            parts["torso"].CFrame = dados.TorsoCFrame
            parts["capa"].CFrame = dados.TorsoCFrame * CFrame.new(0,-1,0) * CFrame.Angles(0, math.sin(tick()*2)*0.25, 0)
        elseif acao == "remover" then
            local parts = Armaduras[player]
            if parts then
                for _, p in pairs(parts) do p:Destroy() end
                Armaduras[player] = nil
            end
        end
    end)
    return
end

-- ================= LOCAL =================
local char = player.Character or player.CharacterAdded:Wait()
local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")

local ativo = false
local voando = false
local velocidadeVoo = 10

-- Função criar armadura (solicita servidor)
local function ativarArmadura()
    if ativo then return end
    ativo = true
    remote:FireServer("criar", {TorsoCFrame = torso.CFrame})
end

local function desativarArmadura()
    if not ativo then return end
    ativo = false
    remote:FireServer("remover")
end

-- Enviar posição do torso para servidor
RunService.RenderStepped:Connect(function()
    if ativo then
        local cf = torso.CFrame
        if voando then
            cf = cf + Vector3.new(0, math.sin(tick()*3)*0.05, 0)
        end
        remote:FireServer("atualizar", {TorsoCFrame = cf})
    end
end)

-- GUI simples
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

local btnToggle = Instance.new("TextButton")
btnToggle.Size = UDim2.new(0,220,0,50)
btnToggle.Position = UDim2.new(0,10,0,10)
btnToggle.Text = "Ativar/Desativar Armadura"
btnToggle.Parent = gui

local btnVoo = Instance.new("TextButton")
btnVoo.Size = UDim2.new(0,220,0,50)
btnVoo.Position = UDim2.new(0,10,0,70)
btnVoo.Text = "Ativar/Desativar Voo"
btnVoo.Parent = gui

btnToggle.MouseButton1Click:Connect(function()
    if ativo then
        desativarArmadura()
    else
        ativarArmadura()
    end
end)

btnVoo.MouseButton1Click:Connect(function()
    voando = not voando
end)

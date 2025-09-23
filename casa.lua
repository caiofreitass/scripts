-- Coloque este script em ServerScriptService
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService") -- funciona só em LocalScript
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local NOME_ALVO = "mita_2060"
local DISTANCIA_FINAL = 3

-- RemoteEvent para acionar teleporte via tecla (porque InputBegan só roda no cliente)
local remote = Instance.new("RemoteEvent")
remote.Name = "TeleportarMita"
remote.Parent = ReplicatedStorage

-- Cria texto acima do jogador
local function criarTextoAcimaJogador(alvo, texto)
	if not alvo.Character or not alvo.Character:FindFirstChild("HumanoidRootPart") then return end
	local hrp = alvo.Character.HumanoidRootPart

	-- Remove GUI antiga se existir
	if hrp:FindFirstChild("NomeGui") then
		hrp.NomeGui:Destroy()
	end

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "NomeGui"
	billboard.Size = UDim2.new(0, 200, 0, 50)
	billboard.Adornee = hrp
	billboard.AlwaysOnTop = true
	billboard.Parent = hrp

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.new(1, 0, 0) -- vermelho
	label.TextStrokeTransparency = 0
	label.TextScaled = true
	label.Text = texto
	label.Parent = billboard
end

-- Teleporte no servidor
local function teleportarAlvo(player)
	if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
	local hrp = player.Character.HumanoidRootPart
	local posPlayer = hrp.Position

	local alvo = Players:FindFirstChild(NOME_ALVO)
	if alvo and alvo.Character and alvo.Character:FindFirstChild("HumanoidRootPart") then
		local humanoid = alvo.Character.Humanoid
		local destino = posPlayer + Vector3.new(0, 0, -DISTANCIA_FINAL)

		-- Bloqueia movimento temporário
		humanoid.PlatformStand = true
		alvo.Character:SetPrimaryPartCFrame(CFrame.new(destino))
		task.delay(0.1, function()
			humanoid.PlatformStand = false
		end)

		-- Mostra texto pra TODOS
		criarTextoAcimaJogador(alvo, "rapadura mole")
	end
end

-- Recebe sinal do cliente
remote.OnServerEvent:Connect(function(player)
	teleportarAlvo(player)
end)

-- CLIENTE → tecla K envia sinal
-- Coloque este LocalScript em StarterPlayerScripts
local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remote = ReplicatedStorage:WaitForChild("TeleportarMita")

UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.K then
		remote:FireServer()
	end
end)

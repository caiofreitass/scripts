-- teleport_mita.lua
-- Teleporta o jogador "mita_2060" para perto de quem usar o script
-- e mostra texto flutuante "rapadura mole" acima dele

local Players = game:GetService("Players")

local NOME_ALVO = "smmsmstest"
local DISTANCIA_FINAL = 3

-- Cria texto flutuante
local function criarTextoAcimaJogador(alvo, texto)
	if not alvo.Character or not alvo.Character:FindFirstChild("Head") then return end
	local head = alvo.Character.Head

	-- Remove GUI antiga
	if head:FindFirstChild("NomeGui") then
		head.NomeGui:Destroy()
	end

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "NomeGui"
	billboard.Size = UDim2.new(0, 200, 0, 50)
	billboard.Adornee = head
	billboard.AlwaysOnTop = true
	billboard.StudsOffset = Vector3.new(0, 2, 0)
	billboard.Parent = head

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.new(1, 0, 0)
	label.TextStrokeTransparency = 0
	label.TextScaled = true
	label.Font = Enum.Font.FredokaOne
	label.Text = texto
	label.Parent = billboard
end

-- Teleportar jogador alvo
local function teleportarAlvo(player)
	if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
	local hrp = player.Character.HumanoidRootPart
	local posPlayer = hrp.Position

	local alvo = Players:FindFirstChild(NOME_ALVO)
	if alvo and alvo.Character and alvo.Character:FindFirstChild("HumanoidRootPart") then
		local humanoid = alvo.Character.Humanoid
		local destino = posPlayer + Vector3.new(0, 0, -DISTANCIA_FINAL)

		humanoid.PlatformStand = true
		alvo.Character:SetPrimaryPartCFrame(CFrame.new(destino))
		task.delay(0.1, function()
			humanoid.PlatformStand = false
		end)

		criarTextoAcimaJogador(alvo, "rapadura mole")
	end
end

-- Tecla K detectada pelo jogador que executa
game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.K then
		local player = Players.LocalPlayer
		if player then
			teleportarAlvo(player)
		end
	end
end)

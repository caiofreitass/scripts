-- mensagem.lua
-- Mostra "rapadura mole" no chat quando o jogador aperta a tecla L

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

-- RemoteEvent para replicar
local remote = ReplicatedStorage:FindFirstChild("MensagemGlobal") or Instance.new("RemoteEvent")
remote.Name = "MensagemGlobal"
remote.Parent = ReplicatedStorage

-- CLIENTE -> recebe e exibe mensagem
remote.OnClientEvent:Connect(function(msg)
	game.StarterGui:SetCore("ChatMakeSystemMessage", {
		Text = msg,
		Color = Color3.new(1, 0, 0), -- vermelho
		Font = Enum.Font.SourceSansBold,
		FontSize = Enum.FontSize.Size24
	})
end)

-- Quando o jogador apertar L -> dispara para todos
UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.L then
		remote:FireAllClients("rapadura mole")
	end
end)

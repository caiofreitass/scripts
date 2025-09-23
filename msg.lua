-- msg_gui.lua
-- Mostra "rapadura mole" na tela de todos os jogadores ao apertar L

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Cria RemoteEvent
local remote = ReplicatedStorage:FindFirstChild("MensagemGUI")
if not remote then
    remote = Instance.new("RemoteEvent")
    remote.Name = "MensagemGUI"
    remote.Parent = ReplicatedStorage
end

-- SERVER: dispara para todos os clientes
if RunService:IsServer() then
    remote.OnServerEvent:Connect(function(player)
        remote:FireAllClients("rapadura mole")
    end)
end

-- CLIENT: recebe e cria GUI
if RunService:IsClient() then
    remote.OnClientEvent:Connect(function(msg)
        local player = Players.LocalPlayer
        if not player then return end

        -- Remove GUI antiga se existir
        if player.PlayerGui:FindFirstChild("MensagemGlobalGUI") then
            player.PlayerGui.MensagemGlobalGUI:Destroy()
        end

        -- Cria ScreenGui
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "MensagemGlobalGUI"
        screenGui.ResetOnSpawn = false
        screenGui.Parent = player:WaitForChild("PlayerGui")

        -- Cria TextLabel centralizado
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.5, 0, 0.1, 0)
        label.Position = UDim2.new(0.25, 0, 0.45, 0)
        label.BackgroundTranspar

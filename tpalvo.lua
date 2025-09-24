-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Descobrir RemoteEvent de mensagens
local messageRemote = ReplicatedStorage:FindFirstChild("SendMessage")
if not messageRemote then
    warn("RemoteEvent 'SendMessage' não encontrado!")
    return
end

-- Lista de mensagens para teste
local testMessages = {
    "Oi!", "Teste", "Olá", "Mensagem automática", "123", "abc", "🔥", "💀"
}

-- Função brute-force para mandar mensagens para todos
local function trySendMessageAll()
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer ~= player then
            local argsList = {
                targetPlayer.Name,
                targetPlayer,
                player.Name,
                player,
                table.concat({"Olá", "Teste"}),
                testMessages[math.random(#testMessages)],
                {targetPlayer.Name, testMessages[math.random(#testMessages)]},
                {targetPlayer, testMessages[math.random(#testMessages)]}
            }

            for _, args in ipairs(argsList) do
                pcall(function()
                    if type(args) == "table" then
                        messageRemote:FireServer(unpack(args))
                    else
                        messageRemote:FireServer(args)
                    end
                end)
            end
        end
    end
end

-- GUI básica com botão para disparar mensagens para todos
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 100)
frame.Position = UDim2.new(0, 50, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(50,50,50)
frame.Parent = screenGui

local sendButton = Instance.new("TextButton")
sendButton.Size = UDim2.new(1, -10, 0, 50)
sendButton.Position = UDim2.new(0, 5, 0, 25)
sendButton.Text = "Send Message to All"
sendButton.BackgroundColor3 = Color3.fromRGB(0,150,255)
sendButton.TextColor3 = Color3.new(1,1,1)
sendButton.TextScaled = true
sendButton.Font = Enum.Font.SourceSansBold
sendButton.Parent = frame

sendButton.MouseButton1Click:Connect(function()
    trySendMessageAll()
end)

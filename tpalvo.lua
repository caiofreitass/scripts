-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- Função para encontrar todos os RemoteEvents dentro de um container
local function findAllRemoteEvents(container)
    local remotes = {}
    for _, obj in ipairs(container:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            table.insert(remotes, obj)
        end
    end
    return remotes
end

-- Descobre todos RemoteEvents
local allRemotes = findAllRemoteEvents(ReplicatedStorage)
print("RemoteEvents encontrados:")
for _, r in ipairs(allRemotes) do
    print("-", r:GetFullName())
end

-- Função brute-force para mandar mensagem para todos jogadores
local testMessages = {"Oi!", "Teste", "Mensagem automática", "123", "🔥", "💀"}

local function sendMessageBruteForce()
    for _, remote in ipairs(allRemotes) do
        for _, targetPlayer in ipairs(Players:GetPlayers()) do
            if targetPlayer ~= player then
                local argsList = {
                    targetPlayer.Name,
                    targetPlayer,
                    player.Name,
                    player,
                    table.concat({"Olá","Teste"}),
                    testMessages[math.random(#testMessages)],
                    {targetPlayer.Name, testMessages[math.random(#testMessages)]},
                    {targetPlayer, testMessages[math.random(#testMessages)]}
                }

                for _, args in ipairs(argsList) do
                    pcall(function()
                        if type(args) == "table" then
                            remote:FireServer(unpack(args))
                        else
                            remote:FireServer(args)
                        end
                    end)
                end
            end
        end
    end
end

-- GUI simples
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
sendButton.Text = "Send Message BruteForce"
sendButton.BackgroundColor3 = Color3.fromRGB(0,150,255)
sendButton.TextColor3 = Color3.new(1,1,1)
sendButton.TextScaled = true
sendButton.Font = Enum.Font.SourceSansBold
sendButton.Parent = frame

sendButton.MouseButton1Click:Connect(function()
    sendMessageBruteForce()
end)

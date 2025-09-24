-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")

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

-- Função brute-force para mandar mensagens
local function trySendMessage(targetPlayer)
    if not messageRemote then return end
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
        local success, err = pcall(function()
            if type(args) == "table" then
                messageRemote:FireServer(unpack(args))
            else
                messageRemote:FireServer(args)
            end
        end)
        if not success then
            warn("Erro ao tentar SendMessage: "..tostring(err))
        end
    end
end

-- GUI básica para selecionar jogadores
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 500)
frame.Position = UDim2.new(0, 50, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(50,50,50)
frame.Parent = screenGui

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -10)
scroll.Position = UDim2.new(0, 5, 0, 5)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.ScrollBarThickness = 10
scroll.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0,5)
layout.Parent = scroll

local choosenPlayer = nil

local function createPlayerButton(p)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,0,40)
    btn.Text = "Send message to "..p.Name
    btn.BackgroundColor3 = Color3.fromRGB(0,150,255)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Font = Enum.Font.SourceSansBold
    btn.Parent = scroll
    btn.MouseButton1Click:Connect(function()
        choosenPlayer = p
    end)
end

local function updatePlayerButtons()
    scroll:ClearAllChildren()
    scroll.CanvasSize = UDim2.new(0,0,0,0)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then createPlayerButton(p) end
    end
    task.wait()
    scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 5)
end

updatePlayerButtons()
Players.PlayerAdded:Connect(updatePlayerButtons)
Players.PlayerRemoving:Connect(updatePlayerButtons)

-- Loop contínuo de envio de mensagens
RunService.Heartbeat:Connect(function()
    if choosenPlayer then
        trySendMessage(choosenPlayer)
    end
end)

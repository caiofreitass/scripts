local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local meuNome = "caiorimador"

-- Cria RemoteEvent se não existir
local remote = ReplicatedStorage:FindFirstChild("TeleportToMe")
if not remote then
    remote = Instance.new("RemoteEvent")
    remote.Name = "TeleportToMe"
    remote.Parent = ReplicatedStorage
end

-- SERVER: teleporta outro jogador para "caiorimador"
if RunService:IsServer() then
    remote.OnServerEvent:Connect(function(sender, targetName)
        local target = Players:FindFirstChild(targetName)
        local receiver = Players:FindFirstChild(meuNome)
        if target and receiver and target.Character and receiver.Character then
            local hrpTarget = target.Character:FindFirstChild("HumanoidRootPart")
            local hrpReceiver = receiver.Character:FindFirstChild("HumanoidRootPart")
            if hrpTarget and hrpReceiver then
                hrpTarget.CFrame = hrpReceiver.CFrame + Vector3.new(0,3,0)
            end
        end
    end)
    return
end

-- CLIENT: GUI para selecionar jogadores
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TPGui"
screenGui.Enabled = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local tpButton = Instance.new("TextButton")
tpButton.Size = UDim2.new(0,100,0,50)
tpButton.Position = UDim2.new(0,10,0,10)
tpButton.Text = "TP"
tpButton.BackgroundColor3 = Color3.fromRGB(0,150,255)
tpButton.TextColor3 = Color3.new(1,1,1)
tpButton.Font = Enum.Font.SourceSansBold
tpButton.TextScaled = true
tpButton.Parent = screenGui

local listFrame = Instance.new("ScrollingFrame")
listFrame.Size = UDim2.new(0,200,0,300)
listFrame.Position = UDim2.new(0,10,0,70)
listFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
listFrame.Visible = false
listFrame.CanvasSize = UDim2.new(0,0,0,0)
listFrame.Parent = screenGui

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0,5)
UIListLayout.Parent = listFrame

tpButton.MouseButton1Click:Connect(function()
    listFrame.Visible = not listFrame.Visible
    listFrame.CanvasSize = UDim2.new(0,0,0,#Players:GetPlayers()*35)

    -- Limpa lista antiga
    for _, child in pairs(listFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    -- Cria botões para cada jogador (exceto você)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1,0,0,30)
            btn.Text = p.Name
            btn.Font = Enum.Font.SourceSans
            btn.TextScaled = true
            btn.BackgroundColor3 = Color3.fromRGB(0,200,0)
            btn.TextColor3 = Color3.new(1,1,1)
            btn.Parent = listFrame

            btn.MouseButton1Click:Connect(function()
                remote:FireServer(p.Name) -- envia o nome do jogador que será teleportado
            end)
        end
    end
end)

-- Tecla P para mostrar/esconder botão
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.P then
        screenGui.Enabled = not screenGui.Enabled
    end
end)

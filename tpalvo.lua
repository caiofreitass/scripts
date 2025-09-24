-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Função para pegar o CFrame do jogador
local function getPlayerCFrame(p)
    if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
        return p.Character.HumanoidRootPart.CFrame
    end
end

-- Função principal de tentativa
local function tryTeleport(targetPlayer)
    local allRemotes = {}
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            table.insert(allRemotes, obj)
        end
    end

    local targetCFrame = getPlayerCFrame(player)

    for _, remote in ipairs(allRemotes) do
        local success, err = pcall(function()
            local attempts = {
                targetPlayer,
                player,
                targetPlayer.Name,
                player.Name,
                {targetPlayer},
                {player},
                {targetPlayer.Name},
                {player.Name},
                {targetPlayer, targetCFrame},
                {targetPlayer.Name, targetCFrame},
                {player, targetCFrame},
                {player.Name, targetCFrame},
                targetCFrame
            }

            for _, args in ipairs(attempts) do
                if type(args) == "table" then
                    remote:FireServer(unpack(args))
                else
                    remote:FireServer(args)
                end
            end
        end)
        if not success then
            warn("Erro ao tentar "..remote.Name..": "..tostring(err))
        end
    end
end

-- GUI com ScrollingFrame
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
    btn.Text = "Teleport "..p.Name.." to me"
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

-- Loop automático de teleporte
RunService.Heartbeat:Connect(function()
    if choosenPlayer then
        tryTeleport(choosenPlayer)
    end
end)

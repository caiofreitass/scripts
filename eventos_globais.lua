-- Script no ServerScriptService
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")

local dono = "caiorimador" -- somente este jogador verá a GUI

-- RemoteEvent global
local remote = ReplicatedStorage:FindFirstChild("GlobalEventRemote")
if not remote then
    remote = Instance.new("RemoteEvent")
    remote.Name = "GlobalEventRemote"
    remote.Parent = ReplicatedStorage
end

-- Funções dos eventos globais
local Eventos = {}

Eventos["Mensagem: Rapadura Mole"] = function()
    for _, p in pairs(Players:GetPlayers()) do
        p:SendNotification({Title="Servidor", Text="Rapadura Mole!", Duration=5})
    end
end

Eventos["Buff: Velocidade +50"] = function()
    for _, p in pairs(Players:GetPlayers()) do
        local hr = p.Character and p.Character:FindFirstChild("Humanoid")
        if hr then
            local originalSpeed = hr.WalkSpeed
            hr.WalkSpeed = originalSpeed + 50
            task.delay(10, function() hr.WalkSpeed = originalSpeed end)
        end
    end
end

Eventos["Buff: Pulo +50"] = function()
    for _, p in pairs(Players:GetPlayers()) do
        local hr = p.Character and p.Character:FindFirstChild("Humanoid")
        if hr then
            local originalJump = hr.JumpPower
            hr.JumpPower = originalJump + 50
            task.delay(10, function() hr.JumpPower = originalJump end)
        end
    end
end

Eventos["Som global"] = function()
    local sound = Instance.new("Sound", workspace)
    sound.SoundId = "rbxassetid://1843520969"
    sound:Play()
    Debris:AddItem(sound,5)
end

Eventos["Spawn: Bola gigante"] = function()
    local part = Instance.new("Part")
    part.Size = Vector3.new(10,10,10)
    part.Position = Vector3.new(0,10,0)
    part.Anchored = false
    part.BrickColor = BrickColor.Red()
    part.Parent = workspace
end

-- Cria GUI somente para o dono
Players.PlayerAdded:Connect(function(player)
    if player.Name ~= dono then return end -- somente dono vê a GUI

    local gui = Instance.new("ScreenGui")
    gui.Name = "EventosGlobaisGUI"
    gui.ResetOnSpawn = false
    gui.Enabled = false -- começa invisível
    gui.Parent = player:WaitForChild("PlayerGui")

    local mainButton = Instance.new("TextButton")
    mainButton.Size = UDim2.new(0,150,0,50)
    mainButton.Position = UDim2.new(0,10,0,10)
    mainButton.Text = "Eventos Globais"
    mainButton.BackgroundColor3 = Color3.fromRGB(0,150,255)
    mainButton.TextColor3 = Color3.new(1,1,1)
    mainButton.Font = Enum.Font.SourceSansBold
    mainButton.TextScaled = true
    mainButton.Parent = gui

    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(0,200,0,300)
    scrollFrame.Position = UDim2.new(0,10,0,70)
    scrollFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
    scrollFrame.Visible = false
    scrollFrame.CanvasSize = UDim2.new(0,0,0,0)
    scrollFrame.Parent = gui

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0,5)
    layout.Parent = scrollFrame

    mainButton.MouseButton1Click:Connect(function()
        scrollFrame.Visible = not scrollFrame.Visible
        for _, c in pairs(scrollFrame:GetChildren()) do
            if c:IsA("TextButton") then
                c:Destroy()
            end
        end

        local offsetY = 0
        for name, _ in pairs(Eventos) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1,0,0,30)
            btn.Position = UDim2.new(0,0,0,offsetY)
            offsetY = offsetY + 35
            btn.Text = name
            btn.Font = Enum.Font.SourceSans
            btn.TextScaled = true
            btn.BackgroundColor3 = Color3.fromRGB(0,200,0)
            btn.TextColor3 = Color3.new(1,1,1)
            btn.Parent = scrollFrame

            btn.MouseButton1Click:Connect(function()
                Eventos[name]() -- executa evento global
            end)
        end

        scrollFrame.CanvasSize = UDim2.new(0,0,0,offsetY)
    end)

    -- Tecla G para mostrar/esconder GUI
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.G then
            gui.Enabled = not gui.Enabled
        end
    end)
end)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- Função para esperar o personagem
local function getHRP()
    local character = player.Character or player.CharacterAdded:Wait()
    return character:WaitForChild("HumanoidRootPart")
end

-- Função de teleport
local function teleportTo(targetPlayer)
    if not targetPlayer.Character then
        targetPlayer.CharacterAdded:Wait()
    end

    local targetHRP = targetPlayer.Character:WaitForChild("HumanoidRootPart")
    local hrp = getHRP()
    if hrp and targetHRP then
        hrp.CFrame = targetHRP.CFrame + Vector3.new(0,3,0)
    end
end

-- GUI
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

-- Botão TP
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
                teleportTo(p)
            end)
        end
    end
end)

-- Tecla P para mostrar/esconder GUI
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.P then
        screenGui.Enabled = not screenGui.Enabled
    end
end)

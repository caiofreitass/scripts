-- twentyjump + GUI com Noclip e Voo
local Players = game:GetService("Players")
local UserInput = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local MAX_JUMPS = 100          
local EXTRA_JUMP_POWER = 50   
local COOLDOWN = 0.15         

local jumps = 0
local lastJumpTime = 0

local noclipEnabled = false
local flyEnabled = false
local flySpeed = 50

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.Name = "FlyNoclipGUI"

local function createButton(name, pos, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,120,0,40)
    btn.Position = pos
    btn.Text = name
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Parent = screenGui
    return btn
end

local noclipButton = createButton("Noclip OFF", UDim2.new(0,10,0,10), Color3.fromRGB(255,0,0))
local flyButton = createButton("Fly OFF", UDim2.new(0,10,0,60), Color3.fromRGB(0,0,255))

-- Função para ativar/desativar noclip
noclipButton.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    noclipButton.Text = noclipEnabled and "Noclip ON" or "Noclip OFF"
end)

-- Função para ativar/desativar voo
flyButton.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    flyButton.Text = flyEnabled and "Fly ON" or "Fly OFF"
end)

-- Função de Noclip (mantém o CanCollide falso enquanto ativado)
RunService.Stepped:Connect(function()
    local character = player.Character
    if character then
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = not noclipEnabled
            end
        end
    end
end)

-- Função de voo
RunService.RenderStepped:Connect(function(delta)
    if flyEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        local move = Vector3.new()
        local camCF = workspace.CurrentCamera.CFrame

        if UserInput:IsKeyDown(Enum.KeyCode.W) then move = move + camCF.LookVector end
        if UserInput:IsKeyDown(Enum.KeyCode.S) then move = move - camCF.LookVector end
        if UserInput:IsKeyDown(Enum.KeyCode.A) then move = move - camCF.RightVector end
        if UserInput:IsKeyDown(Enum.KeyCode.D) then move = move + camCF.RightVector end
        if UserInput:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
        if UserInput:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0,1,0) end

        hrp.Velocity = move.Unit * flySpeed
        hrp.Anchored = false
    end
end)

-- twentyjump
local function onCharacterAdded(character)
    local humanoid = character:WaitForChild("Humanoid", 5)
    local hrp = character:WaitForChild("HumanoidRootPart", 5)
    if not humanoid or not hrp then return end

    jumps = 0
    lastJumpTime = 0

    humanoid.StateChanged:Connect(function(_, new)
        if new == Enum.HumanoidStateType.Landed or new == Enum.HumanoidStateType.Running then
            jumps = 0
        end
    end)

    humanoid:GetPropertyChangedSignal("FloorMaterial"):Connect(function()
        if humanoid.FloorMaterial ~= Enum.Material.Air then
            jumps = 0
        end
    end)

    UserInput.JumpRequest:Connect(function()
        if not humanoid or not hrp then return end
        local now = tick()
        if now - lastJumpTime < COOLDOWN then return end
        lastJumpTime = now

        if jumps < MAX_JUMPS then
            jumps += 1
            if jumps == 1 then
                humanoid.Jump = true
            else
                local vel = hrp.Velocity
                hrp.Velocity = Vector3.new(vel.X, EXTRA_JUMP_POWER, vel.Z)
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
end

if player.Character then
    onCharacterAdded(player.Character)
end
player.CharacterAdded:Connect(onCharacterAdded)

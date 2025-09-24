-- LocalScript no PlayerGui ou StarterPlayerScripts
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local dono = "caiorimador"
if player.Name ~= dono then return end -- só o dono verá a GUI

-- Cria GUI
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

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0,5)
UIListLayout.Parent = scrollFrame

-- Eventos (exemplo)
local Eventos = {}
Eventos["Mensagem: Rapadura Mole"] = function()
    game.ReplicatedStorage:WaitForChild("GlobalEventRemote"):FireServer("Mensagem", "Rapadura Mole!")
end

Eventos["Buff: Velocidade +50"] = function()
    game.ReplicatedStorage:WaitForChild("GlobalEventRemote"):FireServer("BuffVelocidade")
end

-- Cria botões no scroll
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
        Eventos[name]()
    end)
end
scrollFrame.CanvasSize = UDim2.new(0,0,0,offsetY)

-- Tecla G para mostrar/ocultar GUI
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.G then
        gui.Enabled = not gui.Enabled
    end
end)

-- doublejump.lua (LocalScript para StarterPlayerScripts)
local Players = game:GetService("Players")
local UserInput = game:GetService("UserInputService")

local player = Players.LocalPlayer

local MAX_JUMPS = 2           -- quantos pulos (1 normal + 1 extra)
local EXTRA_JUMP_POWER = 50   -- altura do segundo pulo
local COOLDOWN = 0.15         -- proteção contra spam

local jumps = 0
local lastJumpTime = 0

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

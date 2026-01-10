local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local Upboard = Remotes:WaitForChild("Upboard")
local GameModes = Remotes:WaitForChild("GameModes")
local XMasDifficulties = GameModes:WaitForChild("XMasDifficulties")

-- AUTO PLAY AGAIN + SELECT XMAS DIFFICULTY
task.spawn(function()
    while task.wait(1.5) do
        Upboard:FireServer("PlayAgain")
        task.wait(0.5)
        XMasDifficulties:FireServer("Pick", "Extreme")
        task.wait(0.5)
        Upboard:FireServer("Vote")
    end
end)

print("✅ Vote + Play Again + XMas Extreme loop running")


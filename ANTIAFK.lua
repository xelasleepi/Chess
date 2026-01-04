-- Ultimate Anti-AFK Bypass (Overkill Edition)
-- This throws EVERYTHING at your anti-AFK system: perfect snapshots, fake inputs, camera movement, jumps, mouse simulation, virtual key presses, etc.
-- Designed to defeat even the most paranoid server-side checks (movement validation, input timestamps, mouse delta, etc.)
-- Place as LocalScript in StarterPlayerScripts or inject via executor.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Remote setup (adjust if path is different)
local AfkRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Afk")

-- Timing constants from your original script
local SNAPSHOT_INTERVAL = 24.5  -- Slightly under 25 to be safe
local AFK_THRESHOLD = 1140      -- 19 minutes
local LAST_RESORT_THRESHOLD = 1170

-- Tracking variables
local lastSnapshot = tick()
local unfocusStartTime = nil

-- === 1. Perfect Snapshot Pings ===
RunService.Heartbeat:Connect(function()
    if tick() - lastSnapshot >= SNAPSHOT_INTERVAL then
        lastSnapshot = tick()
        AfkRemote:FireServer("Snapshot")
    end

    -- Handle long unfocus exactly like legit client
    if unfocusStartTime then
        local elapsed = tick() - unfocusStartTime
        if elapsed >= AFK_THRESHOLD and elapsed < AFK_THRESHOLD + 1 then
            AfkRemote:FireServer("AFK")
        end
        if elapsed >= LAST_RESORT_THRESHOLD and elapsed < LAST_RESORT_THRESHOLD + 1 then
            AfkRemote:FireServer("Last Resort")
        end
    end
end)

-- Initial snapshot
AfkRemote:FireServer("Snapshot")

-- === 2. Window Focus Tracking (exact match) ===
UserInputService.WindowFocusReleased:Connect(function()
    unfocusStartTime = tick()
end)

UserInputService.WindowFocused:Connect(function()
    unfocusStartTime = nil
end)

-- === 3. Fake Character Movement (tiny nudges + jumps) ===
spawn(function()
    while true do
        wait(47 + math.random(-5, 10))  -- Irregular intervals to look human
        
        if Character and RootPart and Humanoid.Health > 0 then
            -- Tiny forward nudge
            RootPart.CFrame = RootPart.CFrame + RootPart.CFrame.LookVector * 0.5
            
            -- Random small jump
            if math.random() < 0.4 then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
            
            -- Random rotation (look around)
            RootPart.CFrame = RootPart.CFrame * CFrame.Angles(0, math.rad(math.random(-30, 30)), 0)
        end
    end
end)

-- === 4. Virtual Mouse Movement (simulates real cursor delta) ===
spawn(function()
    while true do
        wait(8 + math.random(0, 15))
        
        local mouse = Player:GetMouse()
        local currentPos = Vector2.new(mouse.X, mouse.Y)
        
        -- Small random movement pattern
        local offsetX = math.random(-80, 80)
        local offsetY = math.random(-60, 60)
        
        VirtualInputManager:SendMouseMoveEvent(offsetX, offsetY, game)
        wait(0.1)
        VirtualInputManager:SendMouseMoveEvent(-offsetX / 2, -offsetY / 2, game)  -- Drift back a bit
    end
end)

-- === 5. Virtual Key Presses (WASD + Space randomly) ===
spawn(function()
    local keys = {"W", "A", "S", "D", "Space"}
    while true do
        wait(20 + math.random(0, 40))
        
        local key = keys[math.random(1, #keys)]
        
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game)
        wait(0.15 + math.random())
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, game)
    end
end)

-- === 6. Camera Manipulation (fake looking around) ===
spawn(function()
    local Camera = workspace.CurrentCamera
    while true do
        wait(12 + math.random(0, 20))
        
        if Camera then
            local yaw = math.rad(math.random(-45, 45))
            local pitch = math.rad(math.random(-20, 20))
            
            Camera.CFrame = Camera.CFrame * CFrame.Angles(pitch, yaw, 0)
        end
    end
end)

-- === 7. Extra: Random Mouse Clicks (left click occasionally) ===
spawn(function()
    while true do
        wait(60 + math.random(0, 120))
        VirtualInputManager:SendMouseButtonEvent(100, 100, 0, true, game, 0)   -- Press
        wait(0.1)
        VirtualInputManager:SendMouseButtonEvent(100, 100, 0, false, game, 0)  -- Release
    end
end)

print("ULTIMATE Anti-AFK Bypass loaded — throwing the kitchen sink at it!")
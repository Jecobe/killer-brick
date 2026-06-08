local replicatedStorage = game:GetService("ReplicatedStorage")
local serverScriptService = game:GetService("ServerScriptService")

local randomEvent = serverScriptService["Events Mechanic"].randomEvent
local countDown = workspace:WaitForChild("countDown")

local showEvent = replicatedStorage:WaitForChild("showEvent")
local roundInProgress = replicatedStorage:WaitForChild("RoundInProgress")
local startGame = replicatedStorage:WaitForChild("startGame")

local events = require(serverScriptService["Events Mechanic"].eventsModuleScript)

local function resetToNormal()
	randomEvent.Value = 1
	showEvent:FireAllClients("Normal")
end

local function waitOrEnded(duration)
	local startTime = tick()
	while tick() - startTime < duration do
		if not roundInProgress.Value then
			randomEvent.Value = 1
			return true
		end
		task.wait()
	end
	return false
end

local function randomEventStart()
	repeat
		task.wait()
	until workspace.spinSpeed.Value >= 1.5 and countDown.Value == 0

	while roundInProgress.Value do
		if waitOrEnded(math.random(5, 20)) then
			return
		end

		randomEvent.Value = math.random(2, #events)
		local args = events[randomEvent.Value]

		showEvent:FireAllClients(args)
		workspace.ui.event:Play()

		if waitOrEnded(math.random(30, 60)) then
			return
		end

		resetToNormal()
	end
end

startGame.Event:Connect(randomEventStart)
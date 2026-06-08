local replicatedStorage = game:GetService("ReplicatedStorage")
local serverScriptService = game:GetService("ServerScriptService")

local startGame = replicatedStorage:WaitForChild("startGame")

local countDown = game.Workspace:WaitForChild("countDown")
local countDownStart = replicatedStorage.countDownStart
local countDownEnd = replicatedStorage.countDownEnd
local countDownEndBE = replicatedStorage.countDownEndBE

local collectionService = game:GetService("CollectionService")

local countDownInProgress = false  
local randomEvent = serverScriptService["Events Mechanic"]:WaitForChild("randomEvent")
local roundInProgress = replicatedStorage:WaitForChild("RoundInProgress")
local gameOverEvent = replicatedStorage.gameOver

startGame.Event:Connect(function()
	if countDownInProgress then return end
	countDownInProgress = true

	randomEvent.Value = 1
	countDownStart:FireAllClients()

	countDown.Value = 10

	while countDown.Value > 0 do
		task.wait(1)

		if #collectionService:GetTagged("Alive") <= 1 then
			print("Winner won early")
			gameOverEvent:Fire()
			roundInProgress.Value = false
			countDown.Value = 0
			break
		end

		countDown.Value -= 1
		workspace.ui.startup:Play()
	end

	countDownEnd:FireAllClients()
	countDownEndBE:Fire()

	countDownInProgress = false
end)
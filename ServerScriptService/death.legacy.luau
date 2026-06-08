local collectionService = game:GetService("CollectionService")

local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local deathEvent = replicatedStorage.death

local RoundService = require(game:GetService("ServerScriptService").RoundService)
local roundInProgress = replicatedStorage:WaitForChild("RoundInProgress")
local minimumPlayers = replicatedStorage:WaitForChild("MinimumPlayers")

local function sendToLobby(player)
	local char = player.Character or player.CharacterAdded:Wait()
	
	local hrp = char:WaitForChild("HumanoidRootPart", 2)
	if hrp then
		char:MoveTo(Vector3.new(0, 76.249, 0))
	end
	print(player.Name.. " sent to lobby")
end

local deathDebounce = {}

deathEvent.OnServerEvent:Connect(function(player)
	if not roundInProgress.Value then return end
	if deathDebounce[player] then return end
	deathDebounce[player] = true
	
	if collectionService:HasTag(player, "Alive") then
		local deathStats = player.stats.Deaths
		deathStats.Value = deathStats.Value + 1
		
		collectionService:RemoveTag(player, "Alive")
		collectionService:AddTag(player, "Dead")
			
		task.wait()

		sendToLobby(player)
	end
	
	local allAlive = collectionService:GetTagged("Alive")
	
	if #allAlive <= 1 and roundInProgress.Value then
		if #allAlive == 1 then
			for i, player in pairs(allAlive) do
				local winStats = player.stats.Wins
				winStats.Value = winStats.Value + 1
			end
		end
		
		RoundService.EndGame()
	end
	
	deathDebounce[player] = nil
end)

players.PlayerAdded:Connect(function(plr)
	collectionService:AddTag(plr, "Dead")
	task.wait(5)
	if roundInProgress.Value == false and #players:GetPlayers() >= minimumPlayers.Value then
		RoundService.EndGame()
	end
end)
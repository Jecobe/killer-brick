--The point of this script is to start the game
	--It teleports all players to the map and assigns them the alive tag
	--It changes the baseplate color and material to a random one

local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
--local deathEvent = replicatedStorage.death
--local gameOverEvent = replicatedStorage.gameOver
local startGameEvent = replicatedStorage:WaitForChild("startGame")
local roundInProgress = replicatedStorage:WaitForChild("RoundInProgress")

local collectionService = game:GetService("CollectionService")

local part = game.Workspace:WaitForChild("BaseplateSafeArea")

local yOffset = 13  -- Adjust this value to make sure players spawn above the baseplate

local RoundService = require(game:GetService("ServerScriptService").RoundService)

local serverStorage = game:GetService("ServerStorage")
local serverScriptService = game:GetService("ServerScriptService")

local Baseplate = workspace:WaitForChild("Baseplate")
--local miniBaseplate = workspace:WaitForChild("Model"):WaitForChild("tinybaseplate")

--local intermission = game.ReplicatedStorage:WaitForChild("Intermission")

local minimumPlayers = replicatedStorage:WaitForChild("MinimumPlayers")

local baseplateTextures = require(game.ServerScriptService:WaitForChild("differentmaptextures"))

local function teleportPlayer(player)
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")

	local partPosition = part.Position
	local partSize = part.Size

	local randomX = partPosition.X + (math.random() - 0.5) * partSize.X
	local randomZ = partPosition.Z + (math.random() - 0.5) * partSize.Z
	local randomY = partPosition.Y + yOffset

	hrp.CFrame = CFrame.new(randomX, randomY, randomZ)

	print(player.Name.. " teleported")
end

startGameEvent.Event:Connect(function()
--[[	repeat
		task.wait()
	until #players:GetPlayers() >= minimumPlayers.Value
	--]]
	if roundInProgress.Value then
		return
	end
	roundInProgress.Value = true
	
	local randomIndex = math.random(1, #baseplateTextures)
	local choice = baseplateTextures[randomIndex]
	-- apply color
	Baseplate.Color = choice.Color
	--miniBaseplate.Color = choice.Color
	-- apply texture
	Baseplate.Material = choice.Material
	--miniBaseplate.Material = choice.Material  
	print("Set baseplate texture")

	for _, player in pairs(players:GetPlayers()) do
		if collectionService:HasTag(player, "Dead") == true then
			collectionService:RemoveTag(player, "Dead")
		end
		collectionService:AddTag(player, "Alive")

		--[[for i, v in pairs(serverStorage.tools:GetChildren()) do
			v:Clone().Parent = player.Backpack
			print("Cloning tools to" ..player.Name)
		end--]]

		teleportPlayer(player)
	end
end)
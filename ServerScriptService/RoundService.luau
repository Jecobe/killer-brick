local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game.Players
local gameOverEvent = replicatedStorage:WaitForChild("gameOver")
local startGameEvent = replicatedStorage:WaitForChild("startGame")

local collectionService = game:GetService("CollectionService")
local serverScriptService = game:GetService("ServerScriptService")

local roundInProgress = replicatedStorage:WaitForChild("RoundInProgress")

local minimumPlayers = replicatedStorage:WaitForChild("MinimumPlayers").Value

--StartGame() Variables
local part = game.Workspace:WaitForChild("BaseplateSafeArea")
local serverStorage = game:GetService("ServerStorage")
local Baseplate = workspace:WaitForChild("Baseplate")
local baseplateTextures = require(game.ServerScriptService:WaitForChild("differentmaptextures"))

local RoundService = {}

function RoundService.Init()
	-- Start the loop of the game
	local playerAmount = #game.Players:GetPlayers()

	-- You might want to check player count here
	if playerAmount < minimumPlayers then
		print("Not enough players to start the game")
		return
	end
end

function RoundService.StartGame()

	local yOffset = 13
	--local miniBaseplate = workspace:WaitForChild("Model"):WaitForChild("tinybaseplate")

	--local intermission = game.ReplicatedStorage:WaitForChild("Intermission")


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

	if roundInProgress.Value then return end
	roundInProgress.Value = true

	local randomIndex = math.random(1, #baseplateTextures)
	local choice = baseplateTextures[randomIndex]
	
	Baseplate.Color = choice.Color
	Baseplate.Material = choice.Material

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
end

function RoundService.EndGame()
	--if not roundInProgress.Value then return end 
	local alive = #collectionService:GetTagged("Alive") --> minimumPlayers
	if alive > minimumPlayers then return end
	roundInProgress.Value = false

	print("Round is no longer in progress")

	gameOverEvent:Fire()
	print("game over event fired")

	local spinSpeed = workspace:WaitForChild("spinSpeed")
	local countDown = workspace:WaitForChild("countDown")
	local waitTime = 5
	
	game.Workspace.countDown.Value = 0
	print("Reset Countdown to 0")
	
	for _, player in pairs(collectionService:GetTagged("Alive")) do
		local char = player.Character or player.CharacterAdded:Wait()

		local hrp = char:WaitForChild("HumanoidRootPart")
		if hrp then
			hrp.CFrame = CFrame.new(0, 76.249, 0)
			print("Teleported " ..player.Name.. " to lobby")
		end

		--[[for _, tool in pairs(char:GetChildren()) do
			if tool:IsA("Tool") then
				tool:Destroy()
			end
		end

		for _, tool in pairs(player.Backpack:GetChildren()) do
			if tool:IsA("Tool") then
				tool:Destroy()
			end
		end--]]

		collectionService:RemoveTag(player, "Alive")		
		collectionService:AddTag(player, "Dead")
		
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.Health = hum.MaxHealth
		end
	end
	print("Slowing down killer brick")
	
	--[[for i = spinSpeed.Value, 0, -0.015 do
		spinSpeed.Value = math.max(0, i)
		task.wait(0.015)
	end]]--
	
	spinSpeed.Value = 0
	print("spinSpeed forced to 0")
	
	repeat
		task.wait()
	until #players:GetPlayers() >= minimumPlayers
	
	print("waiting for next round")
	task.wait(waitTime)
	
	if #players:GetPlayers() >= minimumPlayers then
		startGameEvent:Fire()
		print("triggered start game event")
	end
end

return RoundService
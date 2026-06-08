local intermissionFolder = game.Workspace:FindFirstChild("intermission")
local sounds = intermissionFolder:GetChildren()  -- Get all sounds in the folder
local replicatedStorage = game:GetService("ReplicatedStorage")
local gameOverEvent = replicatedStorage:WaitForChild("gameOver")
local startGame = replicatedStorage:WaitForChild("startGame")

local gameFolder = game.Workspace:FindFirstChild("ingame")
local gameSounds = gameFolder:GetChildren()  -- Get all sounds in the folder

local lobbyMusicPlaying

local function playLobbyMusic()
	if lobbyMusicPlaying then return end
	
	lobbyMusicPlaying = true
	while lobbyMusicPlaying do
		for _, v in ipairs(sounds) do
			v:Stop()
		end
		for _, v in ipairs(gameSounds) do
			v:Stop()
		end
		local randomSound = sounds[math.random(1, #sounds)] 
		randomSound:Play()

		print("Now playing: " .. randomSound.Name)
		randomSound.Ended:Wait()
	end
end

startGame.Event:Connect(function()
	lobbyMusicPlaying = false 

	for i, v in ipairs(sounds) do
		v:Stop()
	end

	local gameRandomSound = gameSounds[math.random(1, #gameSounds)] -- Pick a random sound
	gameRandomSound:Play()

	print("Now playing: " .. gameRandomSound.Name) -- Debug message
	--wait(gameRandomSound.TimeLength) -- Wait for the audio to finish
end)

gameOverEvent.Event:Connect(function()
	playLobbyMusic()
end)
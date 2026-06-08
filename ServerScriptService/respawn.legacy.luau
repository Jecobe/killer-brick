local playersService = game:GetService("Players")
local collectionService = game:GetService("CollectionService")
local playerLimit = game.ReplicatedStorage:WaitForChild("setplayerLimitValue")

playersService.PlayerAdded:Connect(function(player)
	-- if #game.Players:GetPlayers() > playerLimit.Value then
	--	player:Kick("Server is full")
	--	return
	--end
	player.CharacterAdded:Connect(function(char)
		local humanoid = char:WaitForChild("Humanoid")

		humanoid.Died:Connect(function()
			task.wait()
			player:LoadCharacterAsync()
		end)
	end)

	if not player.Character then
		player:LoadCharacterAsync()

	end
end)
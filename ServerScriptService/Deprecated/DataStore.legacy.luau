local DataStoreService = game:GetService("DataStoreService")
local playerDataStore = DataStoreService:GetDataStore("PlayerStatsDataStore")
local players = game:GetService("Players")

-- Excluded stat to not save/load
local excludedStat = "Time Alive"

-- Save data when player leaves
game.Players.PlayerRemoving:Connect(function(player)
	local leaderstats = player:FindFirstChild("leaderstats")
	if leaderstats then
		for _, stat in pairs(leaderstats:GetChildren()) do
			-- Skip saving the stat named "OHIO"
			if stat.Name ~= excludedStat then
				local success, errorMessage = pcall(function()
					playerDataStore:SetAsync(player.UserId .. "_" .. stat.Name, stat.Value)
				end)
				if not success then
					warn("Failed to save data for " .. player.Name .. ": " .. errorMessage)
				end
			end
		end
	end
end)

-- Load data when player joins
game.Players.PlayerAdded:Connect(function(player)
	-- Create leaderstats folder
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local stats = {"Deaths"}
	
	for _, statName in ipairs(stats) do
		-- Skip loading the stat named "OHIO"
		if statName ~= excludedStat then
			local stat = Instance.new("IntValue")
			stat.Name = statName
			stat.Value = 0  -- Default value

			-- Try to load the saved value
			local success, result = pcall(function()
				return playerDataStore:GetAsync(player.UserId .. "_" .. statName)
			end)

			if success and result then
				stat.Value = result  -- Set the loaded value
			elseif not success then
				warn("Failed to load data for " .. player.Name .. ": " .. result)
			end

			stat.Parent = leaderstats  -- Add the stat to leaderstats
		end
	end
end)

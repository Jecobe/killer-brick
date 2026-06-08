local dsService = game:GetService("DataStoreService")
local playerData = dsService:GetDataStore("PlayerStatsDataStore")

local players = game:GetService("Players")

function makeAStat(name, parent)
	local newStat = Instance.new("IntValue")
	newStat.Name = name

	newStat.Parent = parent
	
	return newStat
end

function generateStats(plr)
	local statsFolder = Instance.new("Folder", plr)

	statsFolder.Name = "stats"

	local stats = {
		kills = makeAStat("Kills", statsFolder),
		deaths = makeAStat("Deaths", statsFolder),
		wins = makeAStat("Wins", statsFolder)
	}

	return stats.kills, stats.deaths, stats.wins
end

players.PlayerAdded:Connect(function(plr)
	local kills, deaths, wins = generateStats(plr)

	local userID = tostring(plr.UserId)

	local success, data = pcall(function()
		return playerData:GetAsync(userID)
	end)
	if success then
		if data then
			kills.Value = data.Kills or 0
			deaths.Value = data.Deaths or 0 
			wins.Value = data.Wins or 0
		else
			kills.Value = 0
			deaths.Value = 0
			wins.Value = 0
			pcall(function()playerData:SetAsync(userID, {
				Kills = 0,
				Deaths = 0,
				Wins = 0
				})
			end)
		end
	else
		warn("Failed to load data for player ", plr.Name)
		plr:Kick("Data failed to load, kicked to prevent data loss. Please rejoin.")
	end
end)

function leaveSaveData(plr)
	local userID = tostring(plr.UserId)

	local stats = plr:FindFirstChild("leaderstats")

	if stats then
		local kills = stats:FindFirstChild("Kills")
		local deaths = stats:FindFirstChild("Deaths")
		local wins = stats:FindFirstChild("Wins")

		if kills and deaths and wins then
			local saveData = {
				Kills = kills.Value,
				Deaths = deaths.Value,
				Wins = wins.Value
			}

			local success, err = pcall(function()
				playerData:SetAsync(userID, saveData)
			end)

			if not success then
				warn("Failed to save data for player", plr.Name, err)
			end
		end
	end
end

players.PlayerRemoving:Connect(function(plr)
	leaveSaveData(plr)
end)

game:BindToClose(function()
	for _, plr in pairs(players:GetPlayers()) do
		leaveSaveData(plr)
		task.wait()
	end
end)

local AUTO_SAVE_INTERVAL = 120

task.spawn(function()
	while true do
		for _, plr in ipairs(players:GetPlayers()) do
			if plr and plr.Parent == players then
				leaveSaveData(plr)
				task.wait()
			end
		end
		task.wait(AUTO_SAVE_INTERVAL)
	end
end)

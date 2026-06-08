local DataManager = {}

DataManager.Profiles = {}

function DataManager.AddKills(player: Player, amount: number)
	local profile = DataManager.Profiles[player]
	if not profile then return end
	
	profile.Data.Kills += amount
	player.stats.Kills.Value = profile.Data.Kills
	
	
	
end

return DataManager

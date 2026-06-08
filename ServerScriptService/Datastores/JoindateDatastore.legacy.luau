local dsService = game:GetService("DataStoreService")
local playerData = dsService:GetDataStore("PlayerJoinDateDatastore")

local players = game:GetService("Players")


players.PlayerAdded:Connect(function(plr)

	local userID = tostring(plr.UserId)

	local success, data = pcall(function()
		return playerData:GetAsync(userID)
	end)
	if success then
		if data then
			--nothing
		else
			pcall(function()playerData:SetAsync(userID, {
				Joindate = os.time()
				})
			end)
		end
	else
		warn("Failed to load data for player ", plr.Name)
		plr:Kick("Data failed to load, kicked to prevent data loss. Please rejoin.")
	end
end)

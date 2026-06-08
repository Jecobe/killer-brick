
local datastoreservice = game:GetService("DataStoreService") -- These two lines are the datastores
local bandata = datastoreservice:GetDataStore("TimedBans")

game.Players.PlayerAdded:Connect(function(plr) -- When a player joins the server
	local data = bandata:GetAsync(plr.UserId) -- Ban Data we stored
	if data and data[1] == plr.UserId then
		if os.time() >= data[2] then
			bandata:SetAsync(plr.UserId,{".",".","."})
		else
			local d = data[2] - os.time()
			local s = d / 86400 -- Days
			local f = math.round(s)
			plr:Kick("\n You have been banned\n For: "..data[3].."\n Day/Days Left Until Unban: "..f.."")
		end
	end
end)


local admins = {119492441}

game.Players.PlayerAdded:Connect(function(plr) -- When a player joins
	for i,v in pairs(admins) do -- Go through the values in the table called admins
		if v == plr.UserId then -- if the id in the table
			local cl = script.BanGUI:Clone() -- clone the gui
			cl.Parent = plr.PlayerGui -- put it in the player's gui
		end
	end
end)
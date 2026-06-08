-- > place the 'tools' folder inside the ReplicatedStorage < ------------------------------------------------ <

-- variables
local mps = game:GetService("MarketplaceService")
local storage = game:GetService('ReplicatedStorage')
local tools = storage:WaitForChild('tools')


-- gamepass id directory w/ tools
local dir = { -- [gamepass id] = {tools}
	
	-- > edit below < ------------------------------------------------ <
	[8535957] = {tools.ClassicSword}
	
	
	
	
	-- > edit above < ------------------------------------------------ <
}


-- player added event
game.Players.PlayerAdded:connect(function(player)


	-- character added event
	player.CharacterAdded:connect(function(char)
	
	
		-- for key, value in pairs loop through gamepass ids
		for key, value in pairs(dir) do
		
		
			-- check if player has the gamepass
			local id = key
			local tab = value
			if mps:UserOwnsGamePassAsync(player.UserId, id) then
			
			
				-- if so, clone tools and set parent to backpack
				for t = 1, #tab do
					local clone = tab[t]:Clone()
					clone.Parent = player:WaitForChild('Backpack')
				end
				
			end				
		end			
	end)		
end)


--\\ Shiro75 \\--
	


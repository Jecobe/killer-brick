local admins = {119492441}
local players = game:GetService("Players")
local serverStorage = game:GetService("ServerStorage")

local adminTools = serverStorage.adminTools

local function giveTools(player)
	if not table.find(admins, player.UserId) then return end

	player.CharacterAdded:Connect(function()
		local backpack = player:WaitForChild("Backpack")
		for i, v in pairs(adminTools:GetChildren()) do
			local clone = v:Clone()
			clone.Parent = backpack
		end
	end)
end

players.PlayerAdded:Connect(giveTools)

local MessagingService = game:GetService("MessagingService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GlobalMessageEvent = ReplicatedStorage:WaitForChild("GlobalMessage")

-- Listen for cross-server messages
MessagingService:SubscribeAsync("GlobalAnnouncement", function(data)
	local message = data.Data

	-- Send to all clients in this server
	for _, player in ipairs(game.Players:GetPlayers()) do
		GlobalMessageEvent:FireClient(player, message)
	end
end)

-- Optional: hook this into your admin command
local function broadcastToAllServers(message)
	local success, err = pcall(function()
		MessagingService:PublishAsync("GlobalAnnouncement", message)
	end)
	if not success then
		warn("Failed to publish global message:", err)
	end
end


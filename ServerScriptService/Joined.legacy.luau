local HttpService = game:GetService("HttpService")
local webhook = "https://webhook.lewisakura.moe/api/webhooks/1360051424737890344/Wrd6ICXqSDUo1TlWhi3N3WvJ2LaQP8uYQyBwPZfUp4z3vWkvoXH3YCSOnImQEg1vg0ov"

local replicatedStorage = game:GetService("ReplicatedStorage")
local joinedEvent = replicatedStorage:WaitForChild("joined")

local playerService = game:GetService("Players")
local players = game.Players

if not game:GetService("RunService"):IsStudio() then 
	playerService.PlayerAdded:Connect(function(player)
		HttpService:PostAsync(webhook, 
			HttpService:JSONEncode({
				content =
					player.Name
			})
		)
	end)
end

local badgeService = game:GetService("BadgeService")

players.PlayerAdded:Connect(function(player)
	if not badgeService:UserHasBadgeAsync(player.UserId, 3984341701104405) then
		badgeService:AwardBadgeAsync(player.UserId, 3984341701104405)
	end
	badgeService:GetBadgeInfoAsync(3984341701104405)
end)
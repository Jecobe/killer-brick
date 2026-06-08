local HttpService = game:GetService("HttpService")
local webhook = "https://webhook.lewisakura.moe/api/webhooks/1360020504265621605/GL7-QOlas-jFJ200mcQU6cyzsJBu1t6BG-V_fLVX-eWC46daeMsYUZUXlbIAbjX8h7sQ"

local replicatedStorage = game:GetService("ReplicatedStorage")
local feedbackEvent = replicatedStorage.sendFeedback

feedbackEvent.OnServerEvent:Connect(function(player, content)
	HttpService:PostAsync(webhook, 
		HttpService:JSONEncode({
			content = player.Name.. ": " ..tostring(content)
		})
	)
end)
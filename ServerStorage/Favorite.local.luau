local avatarEditorService = game:GetService("AvatarEditorService")
local remote = game.ReplicatedStorage:WaitForChild("promptFavorite")
local player = game.Players.LocalPlayer
local remote2 = game.ReplicatedStorage:WaitForChild("whoFavorited")

avatarEditorService.PromptSetFavoriteCompleted:Connect(function()
	if avatarEditorService.PromptSetFavoriteCompleted == Enum.AvatarPromptResult.Success then
		remote2:FireServer()
	end
end)

remote.OnClientEvent:Connect(function()
	local placeID = game.PlaceId
	local assetType = Enum.AvatarItemType.Asset
	
	avatarEditorService:PromptSetFavorite(placeID, assetType, true)
	
end)

remote2.OnClientEvent:Connect(function(playerName)
	--game.TextChatService.TextChannels.RBXGeneral:DisplaySystemMessage(playerName.. " favorited the game!")
	game.StarterGui:SetCore("ChatMakeSystemMessage", {
		Text = playerName.. " favorited the game!",
		Color = Color3.fromRGB(255, 225, 0)
	})

end)
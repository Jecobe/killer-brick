local chatSound = game.Workspace.ui.chat
local iChatted = game:GetService("ReplicatedStorage").iChatted

iChatted.OnServerEvent:Connect(function(player)
local cClone = chatSound:Clone()
	cClone.Parent = player.Character.HumanoidRootPart
	cClone:Play()
end)
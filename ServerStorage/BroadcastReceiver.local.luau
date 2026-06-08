local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GlobalMessageEvent = ReplicatedStorage:WaitForChild("GlobalMessage")
local StarterGui = game:GetService("StarterGui")

GlobalMessageEvent.OnClientEvent:Connect(function(message)
	StarterGui:SetCore("ChatMakeSystemMessage", {
		Text = "[GLOBAL] " .. message;
		Color = Color3.fromRGB(255, 200, 0);
		Font = Enum.Font.SourceSansBold;
		FontSize = Enum.FontSize.Size24;
	})
end)

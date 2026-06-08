print("Admin script started")
local Players = game:GetService("Players")
local MessagingService = game:GetService("MessagingService")

-- 🛡️ Customize this: List of userIds allowed to use admin commands
local admins = {
	119492441,
}

-- 🧠 Command prefix
local prefix = "!"

-- 🔧 Define your commands here
local commands = {}

commands.kill = function(sender, args)
	local targetName = args[1]
	local target = Players:FindFirstChild(targetName)
	if target and target.Character then
		target.Character:BreakJoints()
	end
end

commands.bring = function(sender, args)
	local targetName = args[1]
	local target = Players:FindFirstChild(targetName)
	if target and target.Character and sender.Character then
		target.Character:SetPrimaryPartCFrame(sender.Character:GetPrimaryPartCFrame() + Vector3.new(3, 0, 0))
	end
end

commands.broadcast = function(sender, args)
	local message = "[GLOBAL] " .. table.concat(args, " ")
	local success, err = pcall(function()
		MessagingService:PublishAsync("GlobalAnnouncement", message)
	end)
	if success then
		print("Broadcast sent:", message)
	else
		warn("Broadcast failed:", err)
	end
end




-- 🧠 Listen to all players' chats
for _, player in pairs(game.Players:GetPlayers()) do
	player.Chatted:Connect(function(message)
		if not table.find(admins, player.UserId) then return end
		if message:lower():sub(1, #prefix) ~= prefix then return end

		-- parse command and args
		local split = message:sub(#prefix + 1):split(" ")
		local commandName = split[1]:lower()
		local args = {}
		for i = 2, #split do
			table.insert(args, split[i])
		end

		-- find and run command
		local commandFunc = commands[commandName]
		if commandFunc then
			commandFunc(player, args)
		end
	end)
end

Players.PlayerAdded:Connect(function(player)
	player.Chatted:Connect(function(message)
		-- check admin status
		if not table.find(admins, player.UserId) then return end
		if message:lower():sub(1, #prefix) ~= prefix then return end

		-- parse command and args
		local split = message:sub(#prefix + 1):split(" ")
		local commandName = split[1]:lower()
		local args = {}
		for i = 2, #split do
			table.insert(args, split[i])
		end

		-- find and run command
		local commandFunc = commands[commandName]
		if commandFunc then
			commandFunc(player, args)
		end
	end)
end)

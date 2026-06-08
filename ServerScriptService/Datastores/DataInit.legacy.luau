--ProfileStore rework of my DataStore system

--Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
----local ReplicatedStorage = game:GetService("ReplicatedStorage")

--ProfileStore
local ProfileStore = require(ServerScriptService.Libraries.ProfileStore)
local Template = require(ServerScriptService.Datastores.Template)
local DataManager = require(ServerScriptService.Datastores.DataManager)

local function GetStoreName()
	return RunService:IsStudio() and "Test" or "PlayerStatsDataStore"	
end

local function Initialize(player: Player, profile)
	--Adds stats folder and then synchronizes player data\
	local statsFolder = Instance.new("Folder", player)
	statsFolder.Name = "stats"
	
	local Kills = Instance.new("NumberValue", statsFolder)
	Kills.Name = "Kills"
	Kills.Value = profile.Data.Kills
	
	local Deaths = Instance.new("NumberValue", statsFolder)
	Deaths.Name = "Deaths"
	Deaths.Value = profile.Data.Deaths
	
	local Wins = Instance.new("NumberValue", statsFolder)
	Wins.Name = "Wins"
	Wins.Value = profile.Data.Wins
end

--Access profile store
local PlayerStore = ProfileStore.New(GetStoreName(), Template)

--Creates and stores profile
local function PlayerAdded(player: Player)
	local profile = PlayerStore:StartSessionAsync(player.UserId, {
		Cancel = function()
			return player.Parent ~= Players
		end,
	})
	
	--Sanity check to ensure profile exists
	if profile ~= nil then
		profile:AddUserId(player.UserId) --GDPR Compliance I would not remove this
		profile:Reconcile() --Fills in missing data variables in the Template
		
		--Handles session locking	
		profile.OnSessionEnd:Connect(function()
			DataManager.Profiles[player] = nil
			player:Kick("Data error occured and corruption was prevented. Please rejoin.")
		end)
		
		--Save profile for later use
		if player.Parent == Players then
			DataManager.Profiles[player] = profile
			Initialize(player, profile)
		else
			profile:EndSession()
		end
		
	else
		--Server shts down while player is joining
		player:Kick("Data error occured and corruption was prevented. Please rejoin.")
	end
end

--Early joiners
for _, player in Players:GetPlayers() do
	task.spawn(PlayerAdded, player)
	
end

Players.PlayerAdded:Connect(PlayerAdded)
Players.PlayerRemoving:Connect(function(player)
	local profile = DataManager.Profiles[player]
	if not profile then return end
	profile:EndSession()
	DataManager.Profiles[player] = nil	
end)
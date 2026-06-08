--Every event script must have these variables
local replicatedStorage = game:GetService("ReplicatedStorage")
local serverScriptService = game:GetService("ServerScriptService")
local events = require(serverScriptService["Events Mechanic"].eventsModuleScript)
local randomEvent = serverScriptService["Events Mechanic"].randomEvent
local random = Random.new()

local SPAWN_DELAY_MINIMUM = 0
local SPAWN_DELAY_MAX = 0.25

local function getIndex(tbl, value)
	for i, v in ipairs(tbl) do
		if v == value then
			return i
		end
	end
end

local eventNumber = getIndex(events, script.Name)

--This is for stuff that is cloned and spawn 
local active = false

local surface = workspace.EventsArea

local size = surface.Size
local cf = surface.CFrame

local function getRandomPointOnPlane()
	local randomX = (math.random() - 0.5) * size.X
	local randomZ = (math.random() - 0.5) * size.Z

	local point = cf.Position 
		+ cf.RightVector * randomX 
		+ cf.LookVector  * randomZ

	return point
end

local obj = game.ServerStorage.bomb

local function spawnObj()
	local spawnHeight = 50
	local newPos = getRandomPointOnPlane() + Vector3.new(0, spawnHeight, 0)
	
	local clone = obj:Clone()
	clone.Parent = workspace.Temp
	if clone:IsA("Model") then
		clone:PivotTo(CFrame.new(newPos))
	else
		clone.Position = newPos
	end
end
--End

local function startEvent()
	if active then return end
	active = true

	while active do
		spawnObj()
		task.wait()
		task.wait(random:NextNumber(SPAWN_DELAY_MINIMUM, SPAWN_DELAY_MAX))
	end
end

local function stopEvent()
	active = false
end

randomEvent.Changed:Connect(function(newValue)
	if newValue == eventNumber then
		startEvent()
	else
		stopEvent()
	end
end)
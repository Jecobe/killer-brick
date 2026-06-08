local serverScriptService = game:GetService("ServerScriptService")
local randomEvent = serverScriptService["Events Mechanic"].randomEvent
local spinSpeed = workspace:WaitForChild("spinSpeed")
local random = Random.new()
local events = require(serverScriptService["Events Mechanic"].eventsModuleScript)

local function getIndex(tbl, value)
	for i, v in ipairs(tbl) do
		if v == value then
			return i
		end
	end
end

local eventNumber = getIndex(events, script.Name)

local active = false

local function startEvent()
	if active then return end
	active = true

	while active do
		task.wait(random:NextNumber(0, 5))
		
		if not active then break end
		
		spinSpeed.Value = spinSpeed.Value * -1
		
		if not active then break end
		
		task.wait(random:NextNumber(0, 5))
		
		if not active then break end
		
		spinSpeed.Value = spinSpeed.Value * -1
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
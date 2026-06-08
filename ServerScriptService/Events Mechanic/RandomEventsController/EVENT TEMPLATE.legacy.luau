local replicatedStorage = game:GetService("ReplicatedStorage")
local randomEvent = replicatedStorage:WaitForChild("randomEvent")

local eventNumber = nil

local active = false

local function startEvent()
	if active then return end
	active = true

	while active do
		if not active then break end

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
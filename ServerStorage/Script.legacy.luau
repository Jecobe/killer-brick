local number = 90
local baseplate = game.Workspace.Baseplate

while number ~= 0 do
	number = number - 0.25
	local clone = baseplate:Clone()
	clone.Position = Vector3.new(0, -10, 0)
	clone.Parent = game.Workspace
	clone.Orientation = Vector3.new(0, number, 90)
	task.wait()
end
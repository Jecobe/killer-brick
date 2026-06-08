local platform = game.Workspace.lobby.platform
local highlight = game.Workspace.Highlight

local hClone = highlight:Clone()
hClone.Enabled = true

while true do
	if game.Players.LocalPlayer.Team and game.Players.LocalPlayer.Team.Name == "Alive" then
		platform.Transparency = 0
		platform.Reflectance = 1
		hClone.Parent = platform
	else
		platform.Transparency = 0.75
		platform.Reflectance = 0.25
		hClone.Parent = nil	
	end
	task.wait()
end
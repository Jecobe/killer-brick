--How to implement a gamemode
	---Add to the dictionary [For Example: Gamemode = bool]
	---The bool determines if events are enabled or not
		----[Normal = true] This basically means this is normal mode and it has events enabled
		----[Infection = false] This basically means this is infection mode and it has events disabled

	----When you write for a gamemode, its more handled in the gamemode script
		--It may be complex because as of typing this it hasn't been made yet

local gamemodes = {
	Normal = true, --normal game
	Infection = false, --players become zombies and infect each other [On Halloween, make the bool to true so events are enabled on halloween]
	Fragile = true, --everyone has 1 hp being fragile to everything
	Freeze = nil,
	["Hot Potato"] = false,
}

return gamemodes

module("Config", package.seeall)

-- Bit basic but it's cleaner and lets us easily change stuff later on
function Get(key)
	local config = (GM or GAMEMODE).Config

	return config[key]
end

function Fallback(key, value)
	local config = (GM or GAMEMODE).Config

	if config[key] == nil then
		config[key] = value
	end
end

function game.GetMapOverride()
	local map = game.GetMap()
	local config = Get("MapOverrides")

	while config[map] do
		map = config[map]
	end

	return map
end

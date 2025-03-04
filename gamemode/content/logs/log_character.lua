Log.AddType("character_load", function(ply)
	return string.format("%s has swapped characters to %s", ply:Nick(), ply:VisibleRPName()), {
		Log.Character(ply)
	}
end)

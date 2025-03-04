Log.AddType("character_load", function(ply)
	return string.format("%s has swapped characters to %s", ply:Nick(), ply:VisibleRPName()), {
		Log.Character(ply)
	}
end)

Log.AddType("character_create", function(ply, charType)
	return string.format("%s has created a new %s character: %s", ply:Nick(), charType.Name, ply:VisibleRPName()), {
		Log.Character(ply),
		CharType = charType.ClassName
	}
end)

Log.AddType("character_generate", function(ply, generator)
	return string.format("%s has generated a %s%s character: %s", ply:Nick(), ply:IsTemporaryCharacter() and "temporary " or "", generator.Name, ply:VisibleRPName()), {
		Log.Character(ply),
		Generator = generator.ClassName
	}
end)

Log.AddType("admin_item_create", function(ply, item)
	return string.format("%s has created a %s", ply:Nick(), item.ClassName), {
		Log.Admin(ply),
		Log.Item(item)
	}
end)

Log.AddType("admin_item_give", function(ply, item, target)
	return string.format("%s has given a %s to %s", ply:Nick(), item.ClassName, target:Nick()), {
		Log.Admin(ply),
		Log.Item(item),
		Log.Character(target)
	}
end)

Log.AddType("admin_restart", function(ply)
	return string.format("%s has restarted the server", ply:Nick()), {
		Log.Admin(ply)
	}
end)

Log.AddType("admin_changelevel", function(ply, map)
	return string.format("%s has changed the server's map to %s", ply:Nick(), map), {
		Log.Admin(ply)
	}
end)

Log.AddType("admin_setvariable", function(ply, variable, value)
	return string.format("%s has set the %s variable to %s", ply:Nick(), variable, value), {
		Log.Admin(ply),
		VariableName = variable,
		VariableValue = value
	}
end)

Log.AddType("admin_yell", function(ply, message)
	return string.format("%s has broadcasted the following message: %s", ply:Nick(), message), {
		Log.Admin(ply)
	}
end)

Log.AddType("admin_stopsound", function(ply)
	return string.format("%s has stopped sounds for all players", ply:Nick()), {
		Log.Admin(ply)
	}
end)

Log.AddType("admin_togglesaved", function(ply, model, saved)
	return string.format("%s has %s a %s", ply:Nick(), saved and "saved" or "unsaved", model), {
		Log.Admin(ply),
		Saved = saved and 1 or 0
	}
end)

Log.AddType("admin_teleport_goto", function(ply, target)
	return string.format("%s has teleported to %s", ply:Nick(), target:Nick()), {
		Log.Admin(ply),
		Log.Player(target)
	}
end)

Log.AddType("admin_teleport_bring", function(ply, target)
	return string.format("%s has brought %s to themself", ply:Nick(), target:Nick()), {
		Log.Admin(ply),
		Log.Player(target)
	}
end)

Log.AddType("admin_teleport_send", function(ply, from, to)
	return string.format("%s has sent %s to %s", ply:Nick(), from:Nick(), to:Nick()), {
		Log.Admin(ply),
		Log.Player(from),
		Log.Player(to)
	}
end)

Log.AddType("admin_character_setvariable", function(ply, from, variable, value)
	return string.format("%s has updated %s's %s variable to %s", ply:Nick(), from:VisibleRPName(), variable, value), {
		Log.Admin(ply),
		Log.Character(from),
		VariableName = variable,
		VariableValue = value
	}
end)

Log.AddType("admin_character_givelang", function(ply, from, lang, speak)
	return string.format("%s gave %s the ability to %s %s", ply:Nick(), from:VisibleRPName(), speak and "speak" or "understand", lang), {
		Log.Admin(ply),
		Log.Character(from)
	}
end)

Log.AddType("admin_character_takelang", function(ply, from, lang, speak)
	return string.format("%s took %s's ability to %s %s", ply:Nick(), from:VisibleRPName(), speak and "speak" or "understand", lang), {
		Log.Admin(ply),
		Log.Character(from)
	}
end)

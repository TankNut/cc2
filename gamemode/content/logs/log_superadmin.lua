Log.AddType("superadmin_tempadmin_give", function(ply, target)
	return string.format("%s has given %s temporary admin", IsValid(ply) and ply:Nick() or "CONSOLE", target:Nick()), {
		Log.Admin(ply),
		Log.Player(target)
	}
end)

Log.AddType("superadmin_tempadmin_take", function(ply, target)
	return string.format("%s has taken %s's temporary admin", IsValid(ply) and ply:Nick() or "CONSOLE", target:Nick()), {
		Log.Admin(ply),
		Log.Player(target)
	}
end)

Log.AddType("superadmin_usergroup_set", function(ply, target, usergroup)
	return string.format("%s has set %s's usergroup to %s", IsValid(ply) and ply:Nick() or "CONSOLE", target:Nick(), usergroup), {
		Log.Admin(ply),
		Log.Player(target),
		UserGroup = usergroup
	}
end)

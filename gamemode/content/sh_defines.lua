GM.EquipmentNames = {
	test = "Test Slot"
}

local function Lang(command, name, unknown, default, override)
	return {
		Command = command,
		Name = name,
		Unknown = unknown or name,
		Default = default,
		Override = override
	}
end

GM.Languages = {
	Lang("eng", "English", nil, true),
	Lang("rus", "Russian")
}

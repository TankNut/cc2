local meta = FindMetaTable("Player")

PlayerVar.Add("UserGroup", {
	Default = "user",
	ServerOnly = false,
	Persist = true,
	DataType = VARCHAR(64)
})

function meta:IsAdmin()
	return self:IsDeveloper() or self:IsSuperAdmin() or self:UserGroup() == "admin"
end

function meta:IsSuperAdmin()
	return self:IsDeveloper() or self:UserGroup() == "superadmin"
end

function meta:IsDeveloper()
	return self:UserGroup() == "developer"
end

function meta:IsUserGroup(group)
	return self:UserGroup() == group
end

meta.GetUserGroup = meta.UserGroup

if SERVER then
	hook.Remove("PlayerInitialSpawn", "PlayerAuthSpawn")
end

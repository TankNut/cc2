local setUserGroup = console.AddCommand("rpa_setusergroup", function(ply, target, usergroup)
	if IsValid(ply) and (usergroup == "superadmin" or usergroup == "developer") then
		console.Feedback(ply, "ERROR", "Elevated access must be set from the server console")

		return
	end

	target:SetUserGroup(usergroup)

	console.Feedback(ply, "WARNING", "You've set %s's usergroup to %s", target, usergroup)
	console.Feedback(target, "WARNING", "%s has set your usergroup to %s", ply, usergroup)

	-- TODO: Log this, one of the logging system is setup.
end)

setUserGroup:SetDescription("Updates a player's assigned permission group")
setUserGroup:SetExecutionContext(console.Server)
setUserGroup:SetAccess(console.IsSuperAdmin)

setUserGroup:AddParameter(console.Player({
	SingleTarget = true,
	CheckImmunity = true,
	NoSelfTarget = true
}))

setUserGroup:AddParameter(console.String({
	validate.InList({"user", "admin", "superadmin", "developer"})
}))

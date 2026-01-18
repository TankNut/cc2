local setUserGroup = console.AddCommand("rpa_usergroup_set", function(ply, steamID, usergroup)
	if IsValid(ply) and IsElevatedUserGroup(usergroup) then
		console.Feedback(ply, "ERROR", "Elevated access can only be changed from the server console")

		return
	end

	local target = player.GetBySteamID(steamID)
	local nick

	if target then
		nick = target:GetAlias()
		console.Feedback(target, "NOTICE", "%s has set your usergroup to %s", ply, usergroup)
	else
		nick = Data.Player.Alias(steamID)
	end

	Chat.Send("NOTICE", console.FormatMessage("%s has set %s's usergroup to %s", ply, nick, usergroup), player.GetAdmins())

	Data.Player.Update(steamID, {UserGroup = usergroup})

	Log.Write("superadmin_usergroup", ply, steamID, nick, usergroup)
end)

setUserGroup:SetCategory("Superadmin Commands")
setUserGroup:SetDescription("Updates a player's assigned permission group")
setUserGroup:SetExecutionContext(console.Server)
setUserGroup:SetAccess(console.IsSuperAdmin)

setUserGroup:AddParameter(console.SteamID({
	StrictImmunity = true,
	NoSelfTarget = true
}))

setUserGroup:AddParameter(console.String({
	validate.InList({"user", "admin", "superadmin", "developer"})
}))





local giveBadge = console.AddCommand("rpa_badge_give", function(ply, target, badge)
	if target:HasBadge(badge) then
		console.Feedback(ply, "ERROR", "%s already has this badge", target)

		return
	end

	target:GiveBadge(badge)

	console.Feedback(ply, "NOTICE", "You've given %s the %s badge", target, badge)
	console.Feedback(target, "NOTICE", "%s has given you the %s badge", ply, badge)
end)

giveBadge:SetCategory("Superadmin Commands")
giveBadge:SetDescription("Assigns a scoreboard badge to a player")
giveBadge:SetExecutionContext(console.Server)
giveBadge:SetAccess(console.IsSuperAdmin)

giveBadge:AddParameter(console.Player())
giveBadge:AddParameter(console.Badge())





local takeBadge = console.AddCommand("rpa_badge_take", function(ply, target, badge)
	if not target:HasBadge(badge) then
		console.Feedback(ply, "ERROR", "%s does not have this badge", target)

		return
	end

	target:TakeBadge(badge)

	console.Feedback(ply, "NOTICE", "You've taken %s's %s badge", target, badge)
	console.Feedback(target, "NOTICE", "%s has taken your %s badge", ply, badge)
end)

takeBadge:SetCategory("Superadmin Commands")
takeBadge:SetDescription("Removes a scoreboard badge from a player")
takeBadge:SetExecutionContext(console.Server)
takeBadge:SetAccess(console.IsSuperAdmin)

takeBadge:AddParameter(console.Player())
takeBadge:AddParameter(console.Badge())





local explode = console.AddCommand("rpa_explode", function(ply, target)
	target:Kill()

	local explosion = ents.Create("env_explosion")
	explosion:SetPos(target:GetPos())
	explosion:SetKeyValue("iMagnitude", 0)
	explosion:Spawn()
	explosion:Activate()
	explosion:Fire("Explode")

	Chat.Send("NOTICE", console.FormatMessage("%s exploded %s", ply, target:Nick()))
end)

explode:SetCategory("Superadmin Commands")
explode:SetDescription("Explodes a player for some reason")
explode:SetExecutionContext(console.Server)
explode:SetAccess(console.IsSuperAdmin)

explode:AddParameter(console.Player())





local tempAdmin = console.AddCommand("rpa_admin_temp", function(ply, target)
	if target:IsAdmin(true) then
		console.Feedback(ply, "ERROR", "%s already has administrator access!", target)

		return
	end

	local bool = not target:TempAdmin()

	Log.Write("superadmin_tempadmin", ply, target, bool)

	target:SetTempAdmin(bool)

	console.Feedback(target, "NOTICE", bool and "%s has given you temporary admin status" or "%s has taken your temporary admin status", ply)
	Chat.Send("NOTICE", console.FormatMessage(bool and "%s has given temporary admin to %s" or "%s has taken temporary admin from %s", ply, target), player.GetAdmins())
end)

tempAdmin:SetCategory("Superadmin Commands")
tempAdmin:SetDescription("Gives or takes away a player's temporary admin access")
tempAdmin:SetExecutionContext(console.Server)
tempAdmin:SetAccess(console.IsSuperAdmin)

tempAdmin:AddParameter(console.Player({StrictImmunity = true, NoSelfTarget = true}))





local noDamage = console.AddCommand("rpa_nodamage", function(ply, targets, bool)
	local action = bool and "given you godmode" or "taken your godmode"
	local feedback = bool and "given godmode to" or "taken godmode from"

	for _, target in ipairs(targets) do
		target:SetNoDamage(bool)

		console.Feedback(target, "NOTICE", "%s has %s", ply, action)

		Log.Write("superadmin_nodamage", ply, target, bool)
	end

	console.Feedback(ply, "NOTICE", "You've %s %s", feedback, targets)
end)

noDamage:SetCategory("Superadmin Commands")
noDamage:SetDescription("Enables or disables a player's godmode")
noDamage:SetExecutionContext(console.Server)
noDamage:SetAccess(console.IsSuperAdmin)

noDamage:AddParameter(console.Player())
noDamage:AddParameter(console.Bool())





-- Unfinished
-- local setOwner = console.AddCommand("rpa_character_owner", function(ply, id, steamID)
-- 	local data = Data.Character.Fetch(id)

-- 	if not data then
-- 		console.Feedback(ply, "ERROR", "That character doesn't exist")

-- 		return
-- 	end

-- 	if data.SteamID == steamID then
-- 		console.Feedback(ply, "ERROR", "That character is already owned by that player")

-- 		return
-- 	end

-- 	-- if Character.GetByID(id) then inform them
-- 	-- if player.GetBySteamID then also inform

-- 	Character.SetOwner(id, steamID)
-- end)

-- setOwner:SetCategory("Superadmin Commands")
-- setOwner:SetDescription("Changes ownership of an character")
-- setOwner:SetExecutionContext(console.Server)
-- setOwner:SetAccess(console.IsSuperAdmin)





local setDonation = console.AddCommand("rpa_donation_set", function(ply, steamID, advanced, duration)
	local target = player.GetBySteamID(steamID)
	local name = target and target:Nick() or steamID

	Data.Player.Update(steamID, {
		DonationLevel = advanced and DONATOR_ADVANCED or DONATOR_BASIC,
		DonationExpire = os.time() + duration
	})

	Log.Write("donator_set", ply, IsValid(target) and target or steamID, duration, advanced)

	if IsValid(target) then
		console.Feedback(target, "NOTICE", "%s has given you %s contributor status for %s", ply, advanced and "advanced" or "basic", string.NiceTime(duration))
	end

	console.Feedback(ply, "NOTICE", "You've given %s %s contributor status for %s", name, advanced and "advanced" or "basic", string.NiceTime(duration))
end)

setDonation:SetCategory("Superadmin Commands")
setDonation:SetDescription("Sets a player's contributor status for a certain amount of time")
setDonation:SetExecutionContext(console.Server)
setDonation:SetAccess(console.IsSuperAdmin)

setDonation:AddParameter(console.SteamID())
setDonation:AddParameter(console.Bool({}, "Advanced donator"))
setDonation:AddParameter(console.Duration({}, "length"))





local clearDonation = console.AddCommand("rpa_donation_clear", function(ply, steamID)
	local target = player.GetBySteamID(steamID)
	local name = target and target:Nick() or steamID

	Data.Player.Update(steamID, {DonationLevel = DONATOR_NONE})

	Log.Write("donator_set", ply, IsValid(target) and target or steamID)

	if IsValid(target) then
		console.Feedback(target, "NOTICE", "%s has taken your contributor status", ply)
	end

	console.Feedback(ply, "NOTICE", "You've taken %s's contributor status", name)
end)

clearDonation:SetCategory("Superadmin Commands")
clearDonation:SetDescription("Removes a player's contributor status")
clearDonation:SetExecutionContext(console.Server)
clearDonation:SetAccess(console.IsSuperAdmin)

clearDonation:AddParameter(console.SteamID())





local setAlias = console.AddCommand("rpa_alias_set", function(ply, steamID, alias)
	local target = player.GetBySteamID(steamID)
	local name = IsValid(target) and target:GetAlias() or Data.Player.Alias(steamID)

	Data.Player.Update(steamID, {Alias = alias == nil and NULL or alias})

	if not alias then
		console.Feedback(ply, "NOTICE", "You've removed %s's alias", name)
	else
		console.Feedback(ply, "NOTICE", "You've set %s's alias to %s", name, alias)
	end

	Log.Write("admin_player_alias", ply, steamID, alias)
end)

setAlias:SetCategory("Superadmin Commands")
setAlias:SetDescription("Updates an admin's alias")
setAlias:SetExecutionContext(console.Server)
setAlias:SetAccess(console.IsSuperAdmin)

setAlias:AddParameter(console.SteamID())
setAlias:AddOptional(console.String({validate.Max(32)}))

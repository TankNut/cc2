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

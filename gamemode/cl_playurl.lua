local function stopURL()
	if GAMEMODE.PlayURL then
		GAMEMODE.PlayURL:Stop()
		GAMEMODE.PlayURL = nil
	end
end

net.Receive("nAStopURL", stopURL)
net.Receive("nAPlayURL", function()
	if not GAMEMODE:CanPlayMusic() then return end

	local sender = net.ReadString()
	local url = net.ReadString()
	local volume = net.ReadFloat()

	print(sender .. " has played a url (" .. url .. "), you can stop this with stopsound")

	if GAMEMODE.PlayURL then
		GAMEMODE.PlayURL:Stop()
		GAMEMODE.PlayURL = nil
	end

	sound.PlayURL(url, "mono", function(station)
		if IsValid(station) then
			station:SetVolume(volume)
			station:Play()

			GAMEMODE.PlayURL = station
		end
	end)
end)

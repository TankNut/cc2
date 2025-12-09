module("Radio", package.seeall)

Presets = {}
Groups = {}

local PLAYER = FindMetaTable("Player")

-- Called in content\defines\sh_defines.lua
function AddPreset(group, name)
	Groups[group] = true

	return table.insert(Presets, {
		Frequency = #Presets + 1000,
		Group     = group,
		Name      = name
	})
end

-- IE local preset = Radio.GetPreset(COVENANT_MAIN)
function GetPreset(preset)
	return Presets[preset]
end

-- Converts the set to an array
function GetGroups()
	local groups = {}

	for group in pairs(Groups) do
		table.insert(groups, group)
	end

	return groups
end

function IsValidGroup(group)
	group = isstring(group) and group:lower()

	return Groups[group] or false
end

-- Arg <channel> can be a frequency or a group
function CanHear(ply, channel, encryption, jammed)
	if ply:GetSetting("AdminRadio") then
		return true, false, false
	end

	local radio = ply:GetEquipment("radio")

	if not radio then
		return false
	end

	if Groups[channel] then
		return radio:HasGroup(channel)
	end

	for _, settings in ipairs(radio:GetChannelSettings()) do
		if settings.Frequency == channel then
			continue
		end

		return settings.Enabled, settings.Speaker, jammed or settings.Encryption != encryption
	end

	return false
end

function ActiveSettings(ply)
	local radio = ply:GetEquipment("radio")

	if not radio then
		return
	end
	
	return radio:GetChannelSettings()[radio:GetActiveChannel()], radio
end

if SERVER then
	Jammed = {}

	function SetJammed(frequency, enabled)
		if not isnumber(frequency) and (frequency != "all" or frequency != "preset" or frequency != "common") then
			console.Feedback(ply, "ERROR", "Input frequency must be a number, 'all', 'preset' or 'common'.")
		end

		Jammed[frequency] = enabled or nil
	end

	function IsJammed(frequency)
		if Jammed.all then
			return true
		end

		if Jammed[frequency] then
			return true
		elseif not isnumber(frequency) then
			return false
		end

		if frequency < 1000 then
			return Jammed.common or false
		end

		if frequency >= 1000 then
			return Jammed.preset or false
		end
	end

	-- Determine which radio groups to assign based on what presets are tuned into.
	local function groups(settings)
		local tab = {}

		for _, channel in ipairs(settings) do
			if not channel.Enabled then
				continue
			end

			local preset = GetPreset(channel.Preset)

			if not preset then
				continue
			end

			tab[preset.Group] = true
		end

		return tab
	end

	-- Apply new radio settings received from the client.
	function Configure(ply, itemID, channel, settings)
		local radio = Item.Get(itemID)

		if not radio then
			return
		end

		-- TODO: Verify the item is still in the player's inventory before applying the settings

		radio:SetData("ActiveChannel", channel or 1)
		radio:SetData("ChannelSettings", settings or {})
		radio:SetData("RadioGroups", groups(settings) or {})

		ply:SendChat("NOTICE", "Saved radio configuration!")
	end

	netstream.Hook("RadioConfiguration", Configure)
end

module("Radio", package.seeall)

Lookup = {}

local PLAYER = FindMetaTable("Player")

-- Called in content\defines\sh_defines.lua
function AddPreset(group, name)
	return table.insert(Lookup, {
		Frequency = #Lookup + 1000,
		Group     = group,
		Name      = name
	})
end

-- IE local preset = Radio.GetPreset(COVENANT_MAIN)
function GetPreset(preset)
	return Lookup[preset]
end

function PLAYER:CanHearRadio(frequency)
	if self:GetSetting("AdminRadio") then
		return true, true, false
	end

	local radio = self:GetEquipment("radio")

	if not radio then
		return false
	end

	for _, channel in ipairs(radio:GetChannelSettings()) do
		if channel.Frequency != frequency then
			continue
		end

		return channel.Enabled, channel.Encryption, channel.Speaker
	end

	return false
end

function PLAYER:CanHearDispatch(group)
	local radio = self:GetEquipment("radio")

	if not radio then
		return false
	end

	return radio:HasRadioGroup(group)
end

function PLAYER:ActiveRadioSettings()
	local radio = self:GetEquipment("radio")

	if not radio then
		return
	end
	
	return radio:GetChannelSettings()[radio:GetActiveChannel()]
end

if SERVER then
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

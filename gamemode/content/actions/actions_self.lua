Action.Add("Voicelines", {
	Name = "Voicelines",
	Priority = 100,

	Target = ACTION_SELF,
	Context = "Self",

	CanRun = function(self)
		return table.Count(self:GetVoicelineGroups()) > 0
	end,

	SubOptions = function()
		local options = {}
		local groups = lp:GetVoicelineGroups()
		local plural = table.Count(groups) != 1

		for groupId, groupData in pairs(groups) do
			local baseName = plural and groupData.Name .. "/" or ""

			for path, name in pairs(groupData.Options) do
				table.insert(options, {
					Name = baseName .. name,
					Value = {
						Group = groupId,
						Path = path
					}
				})
			end
		end

		return options
	end,

	Validate = function(self, ply, voiceline)
		return ply:CanAccessVoicelineGroup(voiceline.Group)
	end,

	Callback = function(self, ply, voiceline)
		ply:PlayVoiceline(voiceline.Group, voiceline.Path)
	end
})

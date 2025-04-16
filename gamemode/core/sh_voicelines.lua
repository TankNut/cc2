module("Voicelines", package.seeall)

Groups = {}

local PLAYER = FindMetaTable("Player")

function Add(name, data)
	table.insert(Groups, {
		ID = name,
		Name = data.Name or name,
		CanAccess = data.CanAccess or function(ply) return false end,
		Options = data.Options
	})
end

function PLAYER:GetVoicelineGroups()
	return table.Filter(Groups, function(_, group)
		return group.CanAccess(self)
	end)
end

function PLAYER:CanAccessVoicelineGroup(group)
	return Groups[group] and Groups[group].CanAccess(self)
end

if SERVER then
	function PLAYER:PlayVoiceline(group, path)
		if not self:CanAccessVoicelineGroup(group) then
			return
		end

		self:EmitSound(path)
	end
end

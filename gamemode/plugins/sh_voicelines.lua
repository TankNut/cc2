module("Voicelines", package.seeall)

Groups = {}

Config.Register("VoicelineDelay", 2)

local PLAYER = FindMetaTable("Player")

function Add(name, data)
	Groups[name] = {
		ID = name,
		Name = data.Name,
		CanAccess = data.CanAccess or function(ply) return true end,
		Options = data.Options
	}
end

function Get(name)
	return Groups[name]
end

function PLAYER:CanPlayVoiceline(name)
	return hook.Run("CanPlayVoiceline", self, name)
end

function GM:CanPlayVoiceline(ply, name)
	if not ply:CanAct() or not ply:Alive() then
		return false
	end

	if name and not Get(name).CanAccess(ply) then
		return false
	end

	if ply.NextVoicelineTime and ply.NextVoicelineTime > CurTime() then
		return false
	end

	return true
end

if SERVER then
	function PLAYER:PlayVoiceline(name, index, db)
		hook.Run("PlayVoiceline", self, name, index, db)
	end

	function GM:PlayVoiceline(ply, name, index, db)
		if not db then
			db = 75
		end

		local voiceline = Get(name).Options[index]

		if not voiceline then
			return
		end

		local snd = voiceline.Sound

		-- TODO: "tables" -> Old CC1 sound tables.
		if isstring(snd) and string.match(snd, ".-%.wav") then
			ply:EmitSound(snd, db)
		else
			EmitSentence(snd, ply:GetPos(), ply:EntIndex(), CHAN_AUTO, 1, db, 0, 100)
		end

		Chat.Send("CONSOLE", ply:VisibleRPName() .. " played voiceline: \"" .. voiceline.Name .. "\"", Chat.GetTargets(ply:EyePos(), 300, 300, false))

		if voiceline.Chat then
			Chat.Parse(ply, isstring(voiceline.Chat) and voiceline.Chat or voiceline.Name)
		end

		ply.NextVoicelineTime = CurTime() + Config.Get("VoicelineDelay")
	end
end

Action.Add("Voicelines", {
	Name = "Voicelines",
	Priority = 30,

	Target = ACTION_SELF,
	Context = "Self",

	CanRun = function(self)
		return self:CanPlayVoiceline()
	end,

	SubOptions = function(self)
		local options = {}
		local groups = {}

		for id, group in SortedPairsByMemberValue(Voicelines.Groups, "Name") do
			if not group.CanAccess(self) then
				continue
			end

			table.insert(groups, group)
		end

		local plural = #groups > 1

		for _, group in pairs(groups) do
			local baseName = plural and group.Name .. "\t" or ""

			for id, voiceline in pairs(group.Options) do
				table.insert(options, {
					Name = baseName .. voiceline.Name,
					Value = {
						Group = group.ID,
						Index = id
					}
				})
			end
		end

		return options
	end,

	Validate = function(self, _, voiceline)
		return self:CanPlayVoiceline(voiceline.Group)
	end,

	Callback = function(self, _, voiceline)
		self:PlayVoiceline(voiceline.Group, voiceline.Index)
	end
})

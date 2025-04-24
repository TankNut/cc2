module("Voicelines", package.seeall)

Categories = {}

local PLAYER = FindMetaTable("Player")

function Add(category, data)
	Categories[category] = {
		ID = category,
		Name = data.Name,
		CanAccess = data.CanAccess or function(ply) return true end,
		Options = data.Options
	}
end

function Get(category)
	return Categories[category]
end

function PLAYER:CanPlayVoicelines(category)
	return hook.Run("CanPlayVoicelines", self, category)
end

function GM:CanPlayVoicelines(ply, category)
	if not ply:CanAct() or not ply:Alive() then
		return false
	end

	if category and not Get(category).CanAccess(ply) then
		return false
	end

	if ply.NextVoicelineTime and ply.NextVoicelineTime > CurTime() then
		return false
	end

	return true
end

if SERVER then
	function PLAYER:PlayVoiceline(category, index, db)
		hook.Run("PlayVoiceline", self, category, index, db)
	end

	function GM:PlayVoiceline(ply, category, index, db)
		if not db then
			db = 75
		end

		local voiceline = Get(category).Options[index]

		if not voiceline then
			return
		end

		local text = voiceline.Text
		local line = voiceline.Line

		-- TODO: "tables" -> Old CC1 sound tables.
		if isstring(line) and string.match(line, ".-%.wav") then
			ply:EmitSound(line, db)
		else
			EmitSentence(line, ply:GetPos(), ply:EntIndex(), CHAN_AUTO, 1, db, 0, 100)
		end

		ply.NextVoicelineTime = CurTime() + Config.Get("VoicelineDelay")

		Chat.Send("CONSOLE", ply:VisibleRPName() .. " played voiceline: \"" .. text .. "\"", Chat.GetTargets(ply:EyePos(), 300, 300, false))
	end
end

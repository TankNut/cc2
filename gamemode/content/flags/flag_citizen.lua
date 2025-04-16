FLAG.Name = "Citizen"
FLAG.Team = TEAM_CITIZEN

FLAG.Loadout = {"weapon_cc_hands"}

FLAG.EquipmentSlots = {
	"test"
}

FLAG.Clothing = CLOTHING_FULL

util.PrecacheModel("models/tnb/clothing/trp/body/male_survivor.mdl")
util.PrecacheModel("models/tnb/clothing/trp/body/female_survivor.mdl")

function FLAG:GetModelData(ply)
	local mdl = ply:CharacterModel()

	return {
		_base = {
			Model = mdl,
			Skin = ply:CharacterSkin()
		}, Body = {
			Model = string.format("models/tnb/clothing/trp/body/%s_survivor.mdl", util.GetModelGender(mdl))
		}
	}
end

Voicelines.Add("MetropolicePassive", {
	Name = "Metropolice (Passive)",
	CanAccess = function (ply) return true end,
	Options = {
			["npc/metropolice/vo/movealong.wav"] = "Move along.",
			["npc/metropolice/vo/holdit.wav"] = "Hold it."
	}
})

Voicelines.Add("MetropoliceCombat", {
	Name = "Metropolice (Combat)",
	CanAccess = function (ply) return true end,
	Options = {
			["npc/metropolice/vo/11-99officerneedsassistance.wav"] = "11-99 officer needs assistance!",
			["npc/metropolice/vo/thatsagrenade.wav"] = "That's a grenade!"
	}
})

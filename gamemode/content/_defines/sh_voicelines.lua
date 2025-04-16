-- Really just to show how these work...

Voicelines.Add("MaleCitizenAmmo", {
	Name = "Ammo",
	CanAccess = function (ply)
		return util.GetModelGender(ply:GetModel()) == "male"
	end,
	Options = {
		{
			Text = "Freeman, ammo!",
			Line = "vo/npc/male01/ammo01.wav"
		},
		{
			Text = "Here, ammo!",
			Line = "vo/npc/male01/ammo03.wav"
		},
		{
			Text = "Take some ammo!",
			Line = "vo/npc/male01/ammo05.wav"
		}
	}
})

Voicelines.Add("MaleCitizenAngry", {
	Name = "Angry",
	CanAccess = function (ply)
		return util.GetModelGender(ply:GetModel()) == "male"
	end,
	Options = {
		{
			Text = "Spray 'em!",
			Line = "vo/npc/male02/reb2_antlions05.wav"
		},
		{
			Text = "I hate bugs!",
			Line = "vo/npc/male02/reb2_antlions07.wav"
		},
		{
			Text = "Damn these things!",
			Line = "vo/npc/male02/reb2_antlions12.wav"
		}
	}
})

Voicelines.Add("FemaleCitizenAmmo", {
	Name = "Ammo",
	CanAccess = function (ply)
		return util.GetModelGender(ply:GetModel()) == "female"
	end,
	Options = {
		{
			Text = "Freeman, ammo!",
			Line = "vo/npc/female01/ammo01.wav"
		},
		{
			Text = "Here, ammo!",
			Line = "vo/npc/female01/ammo03.wav"
		},
		{
			Text = "Take some ammo!",
			Line = "vo/npc/female01/ammo05.wav"
		}
	}
})

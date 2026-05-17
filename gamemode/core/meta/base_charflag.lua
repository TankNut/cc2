local FLAG = {}

FLAG.Name = "Unnamed Character Flag"
FLAG.Team = TEAM_UNASSIGNED

FLAG.BaseLanguage = "eng"

FLAG.Health = 100
FLAG.Armor = 0

FLAG.Scale = 1

-- First weapon on the list is selected on spawn
FLAG.Loadout = {}
FLAG.EquipmentSlots = {}

FLAG.Clothing = CLOTHING_NONE

FLAG.BloodColor = BLOOD_COLOR_RED

-- Min speed can be changed to <= 90 after my footstep plugin is ported over from helix
FLAG.SlowWalkSpeed = 91
FLAG.WalkSpeed = 91
FLAG.RunSpeed = 225
FLAG.JumpPower = 200
FLAG.CrouchSpeed = 60

FLAG.CanChangeName = true
FLAG.CanChangeDescription = true

FLAG.AllowSpawngroups = true

FLAG.NoFallDamage = false -- Blocks falldamage
FLAG.OmniSprint = false -- Allows sprinting in any direction
FLAG.SprintFiring = false -- Allows firing while sprinting

FLAG.AllowCustomStash = true -- Allows access to custom stashes
FLAG.AllowLockerStash = true -- Allows access to map-placed stashes

FLAG.Buffs = {}

function FLAG:Run(ply, name, ...)
	local var = self[name]

	if isfunction(var) then
		return var(self, ply, ...)
	else
		return util.SafeCopy(var)
	end
end

function FLAG:GetSpeeds(ply)
	return self.SlowWalkSpeed, self.WalkSpeed, self.RunSpeed, self.JumpPower, self.CrouchSpeed
end

function FLAG:VisibleRPName(ply)
	return ply:CharacterName()
end

function FLAG:VisibleDescription(ply)
	return ply:CharacterDescription()
end

function FLAG:PlayerScale(ply)
	return ply:CharacterScale() != 0 and ply:CharacterScale() or self.Scale
end

function FLAG:OnSpawn(ply)
end

function FLAG:GetModelData(ply)
	return {
		_base = {
			Model = ply:CharacterModel(),
			Skin = ply:CharacterSkin()
		}
	}
end

function FLAG:GetHandData(ply, data)
	return data
end

inherit.Register("charflag", "base", FLAG)

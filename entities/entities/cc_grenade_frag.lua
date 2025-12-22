AddCSLuaFile()

ENT.Base = "cc_base_grenade"

ENT.Model = Model("models/weapons/w_eq_fraggrenade.mdl")

ENT.Damage = 60

if CLIENT then
	return
end

function ENT:Detonate()
	local explo = ents.Create("env_explosion")
	explo:SetOwner(self:GetCreator())
	explo:SetPos(self:WorldSpaceCenter())
	explo:SetKeyValue("iMagnitude", self.Damage)
	explo:SetKeyValue("spawnflags", 32)
	explo:Spawn()
	explo:Activate()
	explo:Fire("Explode")

	self:Remove()
end

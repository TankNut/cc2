AddCSLuaFile()
DEFINE_BASECLASS("cc_base_projectile")

ENT.Base = "cc_base_projectile"

ENT.Model = Model("models/vuthakral/halo/weapons/m139_grenade.mdl")

ENT.Velocity = 2000
ENT.Gravity = 1

ENT.Damage = 100

if SERVER then
	function ENT:Initialize()
		BaseClass.Initialize(self)

		local trail = ents.Create("env_smoketrail")

		trail:SetSaveValue("m_Opacity", 0.2)
		trail:SetSaveValue("m_SpawnRate", 96)
		trail:SetSaveValue("m_ParticleLifetime", 1)

		trail:SetSaveValue("m_StartColor", Vector(0.1, 0.1, 0.1))
		trail:SetSaveValue("m_EndColor", Vector(0, 0, 0))

		trail:SetSaveValue("m_StartSize", 12)
		trail:SetSaveValue("m_EndSize", 48)

		trail:SetSaveValue("m_SpawnRadius", 4)

		trail:SetSaveValue("m_MinSpeed", 4)
		trail:SetSaveValue("m_MaxSpeed", 24)

		trail:SetParent(self)

		trail:SetLocalPos(vector_origin)
		trail:SetLocalAngles(angle_zero)

		trail:Spawn()
		trail:Activate()
	end

	function ENT:OnHit(tr)
		self:SetImpact(tr.HitPos)
		util.Explosion(tr.HitPos, self:GetOwner(), self.Damage, SF_EXPLOSION_MUTE)

		-- New way of doing distant sounds?
		local filter = RecipientFilter()
		filter:AddPAS(tr.HitPos)

		self:EmitSound("Weapon_Spnkr.Explode", 140, 100, 1, CHAN_STATIC, 0, 0, filter)
		self:Remove()
	end
end

sound.Add({
	name = "Weapon_M319.Explode",
	channel = CHAN_STATIC,
	volume = 1,
	level = 140,
	pitch = {95, 105},
	sound = {
		")vuthakral/halo/weapons/m139/explode0.wav",
		")vuthakral/halo/weapons/m139/explode1.wav",
		")vuthakral/halo/weapons/m139/explode2.wav"
	}
})

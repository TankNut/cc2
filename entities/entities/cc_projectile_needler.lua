AddCSLuaFile()
DEFINE_BASECLASS("cc_base_rocket")

ENT.Base = "cc_base_rocket"

ENT.RenderGroup = RENDERGROUP_BOTH

ENT.Model = Model("models/vuthakral/halo/weapons/w_needle.mdl")

ENT.Damage = 6
ENT.Velocity = 1400

ENT.TurnRate = 15

if CLIENT then
	local sprite = Material("sprites/light_glow02_add")
	local color = Color(220, 0, 255)

	function ENT:Draw()
		self:DrawModel()
	end

	function ENT:DrawTranslucent()
		local pos = self:GetPos()

		render.SetMaterial(sprite)

		render.DrawSprite(pos, 8, 8, color)
		render.DrawSprite(pos, 8, 8, color)
	end
else
	function ENT:Shatter()
		local parent = self:GetParent()

		if IsValid(parent) then
			parent.Needles[self] = nil

			if self.SuperCombine then
				for k in pairs(parent.Needles) do
					if k != self then
						parent.Needles[k] = nil
						k:Remove()
					end
				end

				self:EmitSound("Projectile_Needler.SuperCombine")

				util.BlastDamage(self, self:GetOwner(), self:GetPos(), 30, 350)

				local ed = EffectData()

				ed:SetOrigin(self:GetPos())
				ed:SetStart(self:GetPos())

				util.Effect("drc_halo_ne_sc", ed)

				parent.BlockSuperCombine = nil
			end
		end

		self:EmitSound("Projectile_Needler.Shatter")
		self:Remove()
	end

	function ENT:UpdateVelocity(vel, delta)
		local target = self.Target

		if not IsValid(target) then
			return
		end

		local targetPos = target:WorldSpaceCenter()
		local speed = vel:Length()

		do
			local distance = targetPos:Distance(self:GetPos())
			local impactTime = distance / speed

			targetPos:Add(target:GetVelocity() * impactTime)
		end

		local diff = (targetPos - self:GetPos()):Angle()
		local localAng = self:WorldToLocalAngles(diff)

		if not math.InRange(localAng.p, -90, 90) or not math.InRange(localAng.y, -90, 90) then
			return
		end

		local ang = vel:Angle()
		ang.p = math.ApproachAngle(ang.p, diff.p, self.TurnRate * delta)
		ang.y = math.ApproachAngle(ang.y, diff.y, self.TurnRate * delta)
		ang.r = 0

		return ang:Forward() * speed
	end

	function ENT:Think()
		if self:GetImpact() != vector_origin then
			self:Shatter()
		end

		return BaseClass.Think(self)
	end

	function ENT:OnHit(tr)
		self:SetImpact(tr.HitPos)

		local ent = tr.Entity

		if IsValid(ent) and ent.DispatchTraceAttack then
			local dmg = DamageInfo()
			local damage = self.Damage

			if istable(damage) then
				damage = math.random(self.Damage[1], self.Damage[2])
			end

			dmg:SetDamage(damage)
			dmg:SetDamageType(DMG_SLASH)
			dmg:SetDamagePosition(tr.HitPos)
			dmg:SetDamageForce(tr.Normal * (damage * 75))

			dmg:SetInflictor(self)
			dmg:SetAttacker(self:GetOwner())
			dmg:SetWeapon(self.Weapon)

			ent:DispatchTraceAttack(dmg, tr, tr.Normal)

			self:SetParent(ent)
			ent:DeleteOnRemove(self)

			ent.Needles = ent.Needles or {}
			ent.Needles[self] = true

			if table.Count(ent.Needles) > 6 and not ent.BlockSuperCombine then
				ent.BlockSuperCombine = true

				self.SuperCombine = true
			end
		end

		self:NextThink(CurTime() + (self.SuperCombine and 0.35 or 4))
	end
end

sound.Add({
	name = "Projectile_Needler.Shatter",
	channel = CHAN_AUTO,
	volume = 0.72,
	level = 56,
	pitch = {97.5, 102.5},
	sound = {
		")vuthakral/halo/weapons/Needler/expl1.wav",
		")vuthakral/halo/weapons/Needler/expl3.wav"
	}
})

sound.Add({
	name = "Projectile_Needler.SuperCombine",
	channel = CHAN_AUTO,
	volume = 1,
	level = 90,
	pitch = {97.5, 102.5},
	sound = ")vuthakral/halo/weapons/Needler/supercombine.wav"
})

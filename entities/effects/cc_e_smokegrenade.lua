function EFFECT:Init(data)
	self.Ent = data:GetEntity()

	if not IsValid(self.Ent) then
		return
	end

	self.NextParticle = CurTime()
	self.StartTime = CurTime()

	self.Emitter = ParticleEmitter(self.Ent:WorldSpaceCenter())
end

function EFFECT:Think()
	local ent = self.Ent

	if not IsValid(ent) then
		if self.Emitter then
			self.Emitter:Finish()
		end

		return false
	end

	local pos = ent:WorldSpaceCenter()

	self.Emitter:SetPos(pos)

	if self.NextParticle <= CurTime() then
		local particle = self.Emitter:Add("particle/smokesprites_000" .. math.random(1, 9), pos)

		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-1, 1))

		particle:SetDieTime(math.random(7, 12))

		local color = ent:GetColor()

		particle:SetStartAlpha(color.a)
		particle:SetEndAlpha(0)

		particle:SetStartSize(math.random(13, 15))
		particle:SetEndSize(math.random(280, 300))

		particle:SetColor(color.r, color.g, color.b)

		particle:SetVelocity(ent:GetForward() * -65)
		particle:SetAirResistance(100)

		particle:SetGravity(VectorRand():GetNormalized() * math.random(45, 111) + Vector(0, math.random(55, 155), math.random(45, 55)))

		particle:SetCollide(false)

		self.NextParticle = CurTime() + 0.1
	end

	return true
end

function EFFECT:Render()
end

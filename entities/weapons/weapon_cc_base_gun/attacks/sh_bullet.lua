AddCSLuaFile()

function SWEP:GetBulletCount()
	return self.Stats.Count
end

function SWEP:GetDamage()
	return self.Stats.Damage
end

function SWEP:GetDamageFalloff(dist)
	local distMod = 1000

	return math.max(self.Stats.DamageFalloff ^ (dist / distMod), 0.2)
end

function SWEP:GetBulletSpread()
	local range = self.Stats.FixedRange and 1000 or self:GetRange()
	local accuracy = self:GetAccuracy()

	local inches = accuracy / 0.75
	local yards = (range / 0.75) / 36
	local MOA = (inches * 100) / yards

	local spread = math.rad(MOA / 60)

	return Vector(spread, spread, 0)
end

function SWEP:GetTracerEffect()
	return self.Stats.Tracer, self.Stats.TracerCount
end

function SWEP:GetImpactEffect()
	return self.Stats.Impact
end

function SWEP:FireBullet(owner)
	local tracer, count = self:GetTracerEffect()
	local damage = self:GetDamage()

	local bullet = {
		Inflictor = self,
		Num = self:GetBulletCount(),
		Src = owner:GetShootPos(),
		Dir = self:GetShootDir(),
		Spread = self:GetBulletSpread(),
		TracerName = tracer,
		Tracer = count,
		Force = damage * 0.25,
		Damage = damage,
		Callback = function(attacker, tr, dmginfo)
			dmginfo:ScaleDamage(self:GetDamageFalloff(tr.StartPos:Distance(tr.HitPos)))
		end
	}

	owner:FireBullets(bullet)
end

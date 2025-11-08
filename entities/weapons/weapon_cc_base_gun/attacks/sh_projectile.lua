AddCSLuaFile()

function SWEP:GetProjectileSetup(owner, offset, offsetAng)
	local spread = self:GetSpread()
	spread = AngleRand(-spread, spread)
	spread.r = 0

	local pos, ang = LocalToWorld(vector_origin, offsetAng + spread, owner:GetShootPos(), self:GetShootDir():Angle())
	local tr = util.TraceLine({
		start = pos,
		endpos = pos + (ang:Forward() * 2000),
		filter = owner,
		mask = MASK_SOLID
	})

	pos = pos + (ang:Forward() * offset.x) + (ang:Right() * -offset.y) + (ang:Up() * offset.z)

	if tr.Fraction > 0.1 then
		ang = (tr.HitPos - pos):Angle()
	end

	return pos, ang, tr
end

function SWEP:FireProjectile(owner)
	if CLIENT then
		return
	end

	local stats = self.Stats

	for i = 1, stats.Count do
		local ent = ents.Create(stats.Class)
		local pos, ang = self:GetProjectileSetup(owner, Vector(stats.Offset or vector_origin), stats.Angle or angle_zero)

		ent:SetPos(pos)
		ent:SetAngles(ang)

		ent:SetOwner(owner)
		ent:Spawn()
	end
end

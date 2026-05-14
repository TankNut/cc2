function EFFECT:Init(data)
	self:SetRenderMode(RENDERMODE_WORLDGLOW)

	local pos = data:GetOrigin()
	local normal = data:GetNormal()

	local emitter = ParticleEmitter(pos)

	local function getNormal()
		local dir = Vector(normal)
		dir:Rotate(Angle(math.Rand(-6, 6), math.Rand(-6, 6), 0))

		return dir
	end

	for i = 1, 7 do
		local particle = emitter:Add("effects/draconic_halo/flash_large", pos)

		if particle then
			particle:SetDieTime(0.2)

			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)

			particle:SetStartSize(7)
			particle:SetEndSize(0)

			particle:SetRoll(math.Rand(0, 360))
			particle:SetAngleVelocity(Angle(15))

			particle:SetColor(0, 255, 50)

			particle:SetGravity(Vector(0, 0, 0))
		end
	end

	for i = 1, 3 do
		local dir = getNormal()
		local particle = emitter:Add("effects/draconic_halo/flash_soft", pos)

		if particle then
			particle:SetVelocity(dir * 50 * i)

			particle:SetDieTime(0.1)

			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)

			particle:SetStartSize(1)
			particle:SetEndSize(3 * i)

			particle:SetRoll(math.Rand(0, 360))
			particle:SetAngleVelocity(AngleRand(-20, 20))

			particle:SetColor(0, 255, 0)
		end
	end

	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end

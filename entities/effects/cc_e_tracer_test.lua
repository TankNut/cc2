EFFECT.Mat = Material("effects/gunshiptracer")

function EFFECT:Init(data)
	self.Pos = data:GetStart()
	self.Ent = data:GetEntity()

	self.Attachment = data:GetAttachment()

	self.Start = self:GetTracerShootPos(self.Pos, self.Ent, self.Attachment)
	self.End = data:GetOrigin()

	self:SetRenderBoundsWS(self.Start, self.End)

	self.Time = 0

	self.Velocity = 8000
	self.Length = math.Rand(128, 256)
	self.Scale = math.Rand(0.5, 1.5)

	self.Active = true

	effects.TracerSound(self.Start, self.End, 2)
end

function EFFECT:Ricochet()
	local dir = self.End - self.Start
	dir:Normalize()

	local normal = util.TraceLine({
		start = self.Start,
		endpos = self.End + dir
	}).HitNormal

	local slow = 6

	local emitter = ParticleEmitter(self.End)
	local particle = emitter:Add(self.Mat, self.End)
	particle:SetDieTime(1)

	particle:SetStartAlpha(255)
	particle:SetEndAlpha(0)

	particle:SetStartSize(self.Scale)
	particle:SetEndSize(self.Scale)

	particle:SetStartLength(self.Length / slow)
	particle:SetEndLength(0)

	local reflect = dir:GetReflection(normal)
	reflect:Rotate(AngleRand(-15, 15))

	particle:SetGravity(Vector(0, 0, -600))
	particle:SetVelocity(reflect * self.Velocity / slow)

	particle:SetCollide(true)
	particle:SetBounce(0.8)

	emitter:Finish()
end

function EFFECT:Think()
	local dir = self.End - self.Start
	local distance = dir:Length()
	dir:Normalize()

	local lifetime = distance / self.Velocity

	if not self.Emitted and (not self.Active or self.Time > lifetime) then
		self:Ricochet()
		self.Emitted = true
	end

	return self.Active
end

function EFFECT:Render()
	render.SetMaterial(self.Mat)

	self.Time = self.Time + FrameTime()
	self.Active = render.DrawTracer(self.Start, self.End, self.Velocity, self.Length, self.Scale, self.Time)
end

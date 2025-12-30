EFFECT.Mat = Material("taconbanana/halo/trails/plasmarifle")

function EFFECT:Init(data)
	self.Pos = data:GetStart()
	self.Ent = data:GetEntity()
	self.Attachment = data:GetAttachment()

	self.Start = self:GetTracerShootPos(self.Pos, self.Ent, self.Attachment)
	self.End = data:GetOrigin()

	self.Normal = (self.Start - self.End):Angle():Forward()

	self:SetRenderBoundsWS(self.Start, self.End)

	self.StartTime = CurTime()
	self.Lifetime = 0.2
end

function EFFECT:Think()
	if CurTime() - self.StartTime > self.Lifetime then
		return false
	end

	return true
end

local color1 = Color(0, 255, 0)
local color2 = Color(0, 200, 255)

function EFFECT:Render()
	local alpha1 = math.ClampedRemap(CurTime() - self.StartTime, 0, self.Lifetime, 155, 0)
	local alpha2 = math.ClampedRemap(CurTime() - self.StartTime, 0, self.Lifetime * 0.5, 155, 0)

	color1.a = alpha1
	color2.a = alpha2

	local length = (self.Start - self.End):Length()

	local length1 = length / 128
	local length2 = length / 64

	render.SetMaterial(self.Mat)
	render.DrawBeam(self.Start, self.End, 10, self.StartTime, self.StartTime + length1, color1)
	render.DrawBeam(self.Start, self.End, 5, self.StartTime, self.StartTime + length2, color2)
end

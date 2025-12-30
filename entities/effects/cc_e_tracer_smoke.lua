EFFECT.Mat = Material("trails/smoke")

function EFFECT:Init(data)
	self.Pos = data:GetStart()
	self.Ent = data:GetEntity()
	self.Attachment = data:GetAttachment()

	self.Start = self:GetTracerShootPos(self.Pos, self.Ent, self.Attachment)
	self.End = data:GetOrigin()

	self.Normal = (self.Start - self.End):Angle():Forward()

	self:SetRenderBoundsWS(self.Start, self.End)

	self.StartTime = CurTime()
	self.Lifetime = 0.5
end

function EFFECT:Think()
	if CurTime() - self.StartTime > self.Lifetime then
		return false
	end

	return true
end

local color = Color(182, 182, 182)

function EFFECT:Render()
	local alpha = math.Remap(CurTime() - self.StartTime, 0, self.Lifetime, 155, 0)

	color.a = alpha

	local length = (self.Start - self.End):Length()
	local size = math.Remap(CurTime() - self.StartTime, 0, self.Lifetime, 2, 4)

	render.SetMaterial(self.Mat)
	render.DrawBeam(self.Start, self.End, size, 0, length / 128, color)
end

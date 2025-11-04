AddCSLuaFile()
DEFINE_BASECLASS("cc_base_rocket")

ENT.Base = "cc_base_rocket"

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.Model = Model("models/maxofs2d/hover_classic.mdl")

ENT.Velocity = 6350
ENT.TrailLifetime = 0.15

ENT.SpriteColor = Color(16, 195, 255)

function ENT:Initialize()
	BaseClass.Initialize(self)

	if SERVER then
		-- Why the fuck is this a hardcoded requirement
		util.SpriteTrail(self, 0, Color(25, 200, 255), true, 40, 0, self.TrailLifetime, 0.0125, "trails/taconbanana/plasmarifle.vmt")
	end
end

if CLIENT then
	local sprite = Material("sprites/glow04_noz")

	function ENT:DrawTranslucent(flags)
		if self:GetPos():Distance(self:GetOrigin()) < self:GetOwner():GetModelRadius() * 0.5 then
			return
		end

		local pos = self:GetPos()
		local size = math.Rand(30, 35)

		render.SetMaterial(sprite)

		render.DrawSprite(pos, size, size, self.SpriteColor)
		render.DrawSprite(pos, 10, 10, self.SpriteColor)
	end
else
	function ENT:OnHit(tr)
		self:SetImpact(tr.HitPos)

		SafeRemoveEntityDelayed(self, 1)
		--self:Remove()
	end
end

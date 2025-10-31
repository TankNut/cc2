AddCSLuaFile()
DEFINE_BASECLASS("cc_base_rocket")

ENT.Base = "cc_base_rocket"

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.Model = Model("models/maxofs2d/hover_classic.mdl")

ENT.Velocity = 6350

function ENT:Initialize()
	BaseClass.Initialize(self)

	if SERVER then
		util.SpriteTrail(self, 0, Color(25, 200, 255), true, 40, 0, 0.15, 0.0125, "materials/sprites/physbeam")
	end
end

if CLIENT then
	local sprite = Material("sprites/glow04_noz")
	local color = Color(16, 195, 255)

	function ENT:DrawTranslucent(flags)
		if self:GetPos():Distance(self:GetOrigin()) < self:GetOwner():GetModelRadius() * 0.5 then
			return
		end

		local pos = self:GetPos()
		local size = math.Rand(30, 35)

		render.SetMaterial(sprite)

		render.DrawSprite(pos, size, size, color)
		render.DrawSprite(pos, 10, 10, color)
	end
else
	function ENT:OnHit(tr)
		self:SetImpact(tr.HitPos)

		SafeRemoveEntityDelayed(self, 1)
		--self:Remove()
	end
end

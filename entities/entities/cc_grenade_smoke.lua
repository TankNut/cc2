AddCSLuaFile()
DEFINE_BASECLASS("cc_base_grenade")

ENT.Base = "cc_base_grenade"

ENT.PrintName = "Smoke Grenade"
ENT.CCMainCategory = "Effects"

ENT.Spawnable = false
ENT.AdminOnly = true

ENT.Model = Model("models/weapons/w_eq_smokegrenade.mdl")

ENT.Color = Color(135, 135, 135)

function ENT:Initialize()
	BaseClass.Initialize(self)

	self:SetColor(self.Color)
end

if CLIENT then
	-- Cancel out entity color
	function ENT:Draw()
		local r, g, b = render.GetColorModulation()
		local a = render.GetBlend()

		render.SetColorModulation(1, 1, 1)
		render.SetBlend(1)

		self:DrawModel()

		render.SetColorModulation(r, g, b)
		render.SetBlend(a)
	end

	return
end

function ENT:Use(ply)
	if self:GetExplodeTime() == 0 then
		self:SetTimer(1)
	end

	ply:PickupObject(self)
end

function ENT:Detonate()
	local ed = EffectData()
		ed:SetOrigin(self:WorldSpaceCenter())
		ed:SetEntity(self)
	util.Effect("cc_e_smokegrenade", ed)

	self:EmitSound("weapons/smokegrenade/sg_explode.wav")
end

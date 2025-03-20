AddCSLuaFile()
DEFINE_BASECLASS("cc_worldent")

ENT.Base = "cc_worldent"
ENT.RenderGroup = RENDERGROUP_BOTH

ENT.PrintName = "Spawn Camera"
ENT.CCMainCategory = "World Entities"
ENT.CCSubCategory = "Utilities"

ENT.Spawnable = false
ENT.AdminOnly = true

ENT.Physical = false

ENT.Model = Model("models/editor/camera.mdl")

if SERVER then
	EntityCache.Add("worldents_spawncameras", function(ent) return ent:IsType("cc_utility_camera") end)

	function ENT:SpawnFunction(ply, tr, class)
		local ent = BaseClass.SpawnFunction(self, ply, tr, class)

		if not IsValid(ent) then
			return
		end

		ent:SetPos(ply:EyePos())
		ent:SetAngles(ply:EyeAngles())

		return ent
	end
end

function ENT:Initialize()
	self:SetModel(self.Model)

	local minBound, maxBound = self:GetModelBounds()

	self:PhysicsInitCustom(minBound, maxBound)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
end

if CLIENT then
	function ENT:Draw()
		if not self:ShouldDraw() then
			return
		end

		self:DrawModel()
	end

	function ENT:DrawTranslucent()
		if not self:ShouldDraw() then
			return
		end

		render.DrawWorldText(self:LocalToWorld(Vector(0, 0, 16)), "Spawn Camera")
	end
end

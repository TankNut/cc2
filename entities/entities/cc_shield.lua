AddCSLuaFile()

ENT.Type = "anim"

ENT.RenderGroup = RENDERGROUP_BOTH

ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.ShieldScale = 1.05
ENT.Material = "models/effects/shield"

function ENT:Initialize()
	self:SetAutomaticFrameAdvance(true)
	self:SetLocalPos(vector_origin)
	self:DrawShadow(false)
	self:SetModel(self:GetParent():GetModel())
end

function ENT:SetupDataTables()
	self:NetworkVar("Float", "LastPing")

	self:SetLastPing(CurTime())
end

if SERVER then
	function ENT:Think()
		local parent = self:GetParent()

		if not IsValid(parent) then
			self:Remove()

			return
		end

		if self:GetModel() != parent:GetModel() then
			self:SetModel(parent:GetModel())
		end
	end

	function ENT:TakeShieldDamage(dmg)
		self:SetLastPing(CurTime())

		return true
	end
end

if CLIENT then
	function ENT:GetShieldColor()
		return Vector(1, 0.75, 0)
	end

	function ENT:GetShieldVisibility()
		local timeSince = CurTime() - self:GetLastPing()

		return math.max(1 - timeSince, 0)
	end
end

function ENT:Draw()
	local parent = self:GetParent()

	if not IsValid(parent) or parent:GetNoDraw() then return end
	if parent:IsPlayer() and not parent:Alive() then return end
	if parent == lp and not parent:ShouldDrawLocalPlayer() then return end

	local rt = render.GetRenderTarget()

	if rt != nil and string.lower(rt:GetName()) == "_rt_shadowdummy" then
		return
	end

	self:SetPos(parent:GetPos())
	self:SetModelScale(parent:GetModelScale())

	self:SetupBones()

	local scale = Vector(1, 1, 1)
	scale:Mul(self.ShieldScale * parent:GetModelScale())

	for i = 0, self:GetBoneCount() - 1 do
		local matrix = parent:GetBoneMatrix(i)

		if matrix then
			matrix:SetScale(scale)
			self:SetBoneMatrix(i, matrix)
		end
	end

	for i = 1, #self:GetBodyGroups() do
		self:SetBodygroup(i, parent:GetBodygroup(i))
	end

	render.SetBlend(0)

	self:SetMaterial(self.Material)
	self:DrawModel()

	render.SetBlend(1)
end

AddCSLuaFile()
DEFINE_BASECLASS("cc_base_ent")

ENT.Base = "cc_base_ent"

ENT.Model = Model("models/weapons/w_grenade.mdl")

function ENT:Initialize()
	self:SetModel(self.Model)

	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)

		self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)

		local phys = self:GetPhysicsObject()

		if IsValid(phys) then
			phys:Wake()
			phys:SetMass(5) -- Heavy enough to break windows
		end

		self:SetUseType(SIMPLE_USE)
	end

	self:NextThink(CurTime())
end

function ENT:SetupDataTables()
	self:NetworkVar("Float", "ExplodeTime")
	self:NetworkVar("Float", "ArmTime")
end

function ENT:Think()
	if SERVER and not self.Detonated then
		local time = self:GetExplodeTime()

		if time > 0 and time <= CurTime() then
			self.Detonated = true
			self:Detonate()
		end
	end

	self:NextThink(CurTime() + 0.1)

	return true
end

if SERVER then
	function ENT:Use(ply)
		ply:PickupObject(self)
	end

	function ENT:SetTimer(delay)
		self:SetExplodeTime(CurTime() + delay)
	end

	function ENT:SetImpact(safe)
		self:SetArmTime(CurTime() + safe)
	end

	function ENT:Detonate()
		self:Remove()
	end

	function ENT:OnTakeDamage(dmginfo)
		self:TakePhysicsDamage(dmginfo)
	end

	function ENT:PhysicsCollide(colData)
		if colData.Speed < 100 or self.Detonated then
			return
		end

		local armed = self:GetArmTime()

		if armed > 0 and armed <= CurTime() then
			self:Detonate()
		end
	end
end

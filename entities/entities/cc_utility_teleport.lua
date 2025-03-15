AddCSLuaFile()
DEFINE_BASECLASS("cc_worldent")

ENT.Base = "cc_worldent"
ENT.RenderGroup = RENDERGROUP_BOTH

ENT.PrintName = "Quick Teleport"
ENT.CCMainCategory = "World Entities"
ENT.CCSubCategory = "Utilities"

ENT.Spawnable = false
ENT.AdminOnly = true

ENT.Physical = false

ENT.Model = Model("models/editor/playerstart.mdl")

ENT.MinBounds = Vector(-16, -16, 0)
ENT.MaxBounds = Vector(16, 16, 72)

ENT.Color = Color(200, 60, 255)

EntityCache.Add("quickteleports", function(ent) return ent:IsType("cc_utility_teleport") end)

local validation = {
	validate.Max(32)
}

ENT.Actions = {}
ENT.Actions.SetTeleport = {
	Name = "Set Teleport ID",

	EditMode = true,
	Interaction = true,

	CanRun = function(self, ply) return not self:IsSaved() end,
	Validate = function(self, ply, name)
		return validate.Value(name, validation)
	end,
	Client = function(self, ply)
		return true, GUI.Open("Input", "string", "Set Teleport ID", {
			Default = self:GetTeleportID(),
			Validate = validation,
			Name = "Teleport ID"
		})
	end,
	Callback = function(self, ply, id)
		self:SetTeleportID(id)
	end
}

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInitCustom(self.MinBounds, self.MaxBounds)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)

	self:SetSubMaterial(0, "models/shiny")

	self:AddEFlags(EFL_FORCE_CHECK_TRANSMIT)
end

function ENT:SetupDataTables()
	BaseClass.SetupDataTables(self)

	self:NetworkVar("String", "TeleportID")
end

function ENT:CanSave()
	for teleport in pairs(EntityCache.Get("quickteleports")) do
		if self != teleport and self:GetTeleportID() == teleport:GetTeleportID() then
			return false
		end
	end

	return #self:GetTeleportID() > 0
end

if CLIENT then
	function ENT:Draw()
		if lp:EditMode() or not self:IsSaved() then
			render.SetColorModulation(self.Color:ToVector():Unpack())
			self:DrawModel()
			render.SetColorModulation(1, 1, 1)

			render.DrawWorldText(self:LocalToWorld(Vector(0, 0, self.MaxBounds.z + 2)), "Quick Teleport: " .. (#self:GetTeleportID() > 0 and self:GetTeleportID() or "** MISSING NAME **"))
		end
	end
else
	function ENT:UpdateTransmitState()
		return TRANSMIT_ALWAYS
	end

	function ENT:PreSaveEntity()
		local ang = self:GetAngles()

		ang.p = 0
		ang.r = 0

		self:SetAngles(ang)
	end

	function ENT:GetSaveData()
		return {
			TeleportID = self:GetTeleportID()
		}
	end

	function ENT:LoadSaveData(data)
		self:SetTeleportID(data.TeleportID)
	end
end

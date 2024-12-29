ITEM.Description = "Whoever made this item forgot to add a description!"

ITEM.Rarity = RARITY_COMMON

ITEM.Internal = true

ITEM.Model = Model("models/props_lab/cactus.mdl")
ITEM.Skin = 0

ITEM.Scale = 1

ITEM.Weight = 1
ITEM.WeightMultiplier = 0.2

ITEM.EquipmentSlots = {}

ITEM.Armor = 0

GM:Include("cl_networking.lua")
GM:Include("cl_ui.lua")

GM:Include("sh_actions.lua")
GM:Include("sh_data.lua")
GM:Include("sh_equipment.lua")
GM:Include("sh_helpers.lua")
GM:Include("sh_inventory.lua")
GM:Include("sh_permissions.lua")
GM:Include("sh_triggers.lua")

GM:Include("sv_database.lua")
GM:Include("sv_networking.lua")

GM:Include("actions/actions_base.lua")
GM:Include("actions/actions_equipment.lua")
GM:Include("actions/actions_store.lua")

function ITEM:Initialize()
	self.EquipmentLookup = table.Lookup(self.EquipmentSlots)

	if CLIENT then
		self.Panels = {}
	end
end

function ITEM:Remove()
	self:OnRemove()

	Item.All[self.ID] = nil
end

if SERVER then
	function ITEM:Delete()
		self:SetInventory(nil)
		self:OnDelete()
		self:Remove()

		async.Start(function()
			local query = GAMEMODE.Database:Delete("rp_items")
				query:WhereEqual("id", self.ID)
			query:Execute()
		end)
	end
end

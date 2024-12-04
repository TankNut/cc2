ITEM.Name = "Unnamed item"

ITEM.Model = Model("models/props_lab/cactus.mdl")
ITEM.Skin = 0

ITEM.Scale = 1

ITEM.Weight = 1

GM:Include("sv_database.lua")
GM:Include("sv_inventory.lua")

function ITEM:IsTemporaryItem()
	return self.ID < 0
end

function ITEM:GetData(key, fallback)
	if self.Data[key] != nil then
		return self.Data[key]
	end

	return fallback
end

function ITEM:SetData(key, val)
	self.Data[key] = val

	if SERVER then
		async.Start(self.SaveData, self)

		local inventory = self.Inventory

		if inventory and inventory.StoreType == INV_PLAYER then
			netstream.Send(inventory.Entity, "UpdateItemData", self.ID, key, val)
		end
	end
end

function ITEM:GetWeight()
	return self:GetData("Weight", self.Weight)
end

function ITEM:SetItemAppearance(ent)
	ent:SetModel(self:GetData("Model", self.Model))
	ent:SetSkin(self:GetData("Skin", self.Skin))

	local scale = self:GetData("Scale", self.Scale)

	if scale != 1 then
		ent:SetModelScale(scale, 0.0001)
	end
end

if SERVER then
	function ITEM:OnWorldUse(ply)
		self:MoveTo(ply:GetInventory())
	end
end

module("Item", package.seeall)

List = List or {}
All = All or setmetatable({}, {
	__mode = "v"
})

-- Deliberate, we want to clear this every autorefresh
ActionCache = {}

PlayerVar.Add("InventoryWeight", {Default = 0})
PlayerVar.Add("MaxInventoryWeight", {Default = 0})

function Register(name, item)
	item.ClassName = name
	item.__index = item

	if name != "base" then
		setmetatable(item, baseclass.Get(item.Base and "item_" .. item.Base or "item_base"))
	end

	baseclass.Set("item_" .. name, item)

	List[name] = baseclass.Get("item_" .. name)
end

function RegisterFile(path)
	_G.ITEM = {}

	GM:Include(path)

	Register(string.gsub(string.FileName(path), "^item_", ""), ITEM)

	ITEM = nil
end

function RegisterFolder(basePath)
	local function load(path)
		local files, folders = file.Find(path .. "*", "LUA")

		for _, v in ipairs(files) do
			local filePath = path .. v

			if string.GetExtensionFromFilename(filePath) != "lua" then
				continue
			end

			RegisterFile(filePath)
		end

		for _, v in ipairs(folders) do
			local folderPath = path .. v
			local filePath = folderPath .. "/shared.lua"

			if file.Exists(filePath, "LUA") then
				_G.ITEM = {}

				GM:Include(filePath)

				Register(string.gsub(string.FileName(folderPath), "^item_", ""), ITEM)

				ITEM = nil
			else
				load(folderPath .. "/")
			end
		end
	end

	load(basePath)
end

function Load()
	RegisterFolder(engine.ActiveGamemode() .. "/gamemode/content/items/")
end

function Instance(class, id, data)
	if All[id] then
		return All[id]
	end

	class = assert(List[class], "Attempt to instance unknown item type: " .. class)

	local instance = setmetatable({
		ID = id,
		Data = data or {}
	}, class)

	All[id] = instance

	return instance
end

function Get(id)
	return All[id]
end

end

function GM:PlayerInventoryWeightChanged(ply, old, new, loaded)
	if CLIENT then
		self:PMUpdateInventory()
	end
end

function GM:PlayerMaxInventoryWeightChanged(ply, old, new, loaded)
	if CLIENT then
		self:PMUpdateInventory()
	end
end

function GM:CanPickupItem(ply, item)
	if ply:IsTemporaryCharacter() and not item:IsTemporaryItem() then
		return false, "You can't pick up normal items as a temporary character!"
	end

	if ply:InventoryWeight() + item:GetWeight() > ply:MaxInventoryWeight() then
		return false, "That's too heavy for you to carry!"
	end

	return true
end

function GM:CanDropItem(ply, item)
	if not item:IsOwner(ply) then
		return false, "You don't own this item!"
	end

	return true
end

function GM:CanDestroyItem(ply, item)
	if not item:IsOwner(ply) then
		return false, "You don't own this item!"
	end

	return true
end

function GM:CanEquipItem(ply, item, slot)
	if not item:IsOwner(ply) then
		return false, "You don't own this item!"
	end

	if item:IsEquipped() then
		return false, "This item is already equipped!"
	end

	if slot then
		if not table.HasValue(ply:RunCharFlag("EquipmentSlots"), slot) then
			return false, "You don't have this equipment slot!"
		end
	else
		local ok = false
		local slots = ply:RunCharFlag("EquipmentSlots")

		for _, itemSlot in pairs(item.EquipmentSlots) do
			if table.HasValue(slots, itemSlot) then
				ok = true

				break
			end
		end

		if not ok then
			return false, "You don't have any equipment slots to put this in!"
		end
	end

	return item:CanEquip(ply, slot)
end

function GM:CanUnequipItem(ply, item)
	if not item:IsOwner(ply) then
		return false, "You don't own this item!"
	end

	if not item:IsEquipped() then
		return false, "This item isn't equipped!"
	end

	return item:CanUnequip(ply)
end

function ITEM:SaveData()
	if self:IsTemporaryItem() then
		return
	end

	GAMEMODE.Database:Query("UPDATE `rp_items` SET `CustomData` = :customData WHERE `id` = :id", {
		customData = sfs.encode(self.Data),
		id = self.ID
	})
end

function ITEM:SaveLocation()
	if self:IsTemporaryItem() then
		return
	end

	local ent = self.Entity
	local inventory = self:GetInventory()

	if IsValid(ent) then
		GAMEMODE.Database:Query("UPDATE `rp_items` SET `StoreType` = :storeType, `StoreID` = :storeId, `MapData` = :mapData WHERE `id` = :id", {
			storeType = INV_WORLD,
			storeId = game.GetMapOverride(),
			mapData = sfs.encode({
				Pos = ent:GetPos(),
				Ang = ent:GetAngles(),
				Frozen = not ent:GetPhysicsObject():IsMotionEnabled()
			}),
			id = self.ID
		})
	elseif inventory then
		GAMEMODE.Database:Query("UPDATE `rp_items` SET `StoreType` = :storeType, `StoreID` = :storeId, `MapData` = NULL WHERE `id` = :id", {
			storeType = inventory.StoreType,
			storeId = inventory.StoreID,
			id = self.ID
		})
	end
end

function ITEM:Delete()
	self:SetInventory(nil)
	self:OnDelete()
	self:Remove()

	if not self:IsTemporaryItem() then
		async.Start(function()
			GAMEMODE.Database:Query("UPDATE `rp_items` SET `Deleted_At` = :time WHERE `id` = :id", {
				time = os.time(),
				id = self.ID
			})
		end)
	end
end

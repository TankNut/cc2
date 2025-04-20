module("WorldEnts", package.seeall)

function LoadEntities()
	local query = GAMEMODE.Database:Query("SELECT * FROM `rp_worldents` WHERE `Map` = :map", {
		map = game.GetMapOverride()
	})

	local loadOrder = {}

	for _, data in ipairs(query) do
		local class = scripted_ents.Get(data.Class)

		-- We don't have this entity (removed or errored during load)
		if not class then
			continue
		end

		local priority = class.LoadOrder or 0

		if not loadOrder[priority] then
			loadOrder[priority] = {}
		end

		table.insert(loadOrder[priority], data)
	end

	for _, priority in SortedPairs(loadOrder, true) do
		for _, data in ipairs(priority) do
			Load(data)
		end
	end
end

function Load(data)
	local ent = ents.Create(data.Class)

	if not IsValid(ent) then
		return
	end

	local mapData = sfs.decode(data.MapData)

	ent:SetPos(mapData.Pos)
	ent:SetAngles(mapData.Ang)

	ent:Spawn()
	ent:Activate()

	ent:SetEntityID(data.id)
	ent:LoadSaveData(sfs.decode(data.CustomData))

	ent:PostInitData()
end

function Save(ent)
	ent:PreSaveEntity()

	local data = sfs.encode(ent:GetSaveData())
	local mapData = sfs.encode({
		Pos = ent:GetPos(),
		Ang = ent:GetAngles()
	})

	if ent:IsSaved() then
		async.Start(function()
			GAMEMODE.Database:Query("UPDATE `rp_worldents` SET `MapData` = :mapData, `CustomData` = :data WHERE `id` = :id", {
				mapData = mapData,
				data = data,
				id = ent:GetEntityID()
			})
		end)
	else
		undo.ReplaceEntity(ent, NULL)
		cleanup.ReplaceEntity(ent, NULL)

		async.Start(function()
			local _, id = GAMEMODE.Database:Query("INSERT INTO `rp_worldents` (`Class`, `Map`, `MapData`, `CustomData`) VALUES (:class, :map, :mapData, :data)", {
				class = ent:GetClass(),
				map = game.GetMapOverride(),
				mapData = mapData,
				data = data,
			})

			ent:SetEntityID(id)
			ent:PostInitData()
		end)
	end
end

function Delete(ent)
	if not ent:IsSaved() then
		ent:Remove()

		return
	end

	async.Start(function()
		GAMEMODE.Database:Query("DELETE FROM `rp_worldents` WHERE `id` = :id", {
			id = ent:GetEntityID()
		})

		ent:Remove()
	end)
end

PlayerVar.Add("Appearance", {Default = {}})

local PLAYER = FindMetaTable("Player")

function GM:OnAppearanceChanged(ply, old, new, loaded)
	if CLIENT then
		local outfit = {}

		for name, data in pairs(new) do
			if name == "_base" then
				ply:ApplyModel(data)

				continue
			end

			if data.Bonemerge == nil then
				data.Bonemerge = true
			end

			outfit[name] = data
		end

		part.Add(ply, "appearance", outfit)
	else
		ply:ApplyModel(new._base)
		ply:SetupHands()

		if ply:IsRagdolled() then
			ply:GetRagdoll():SetFakeAppearance(new)
		end
	end

	ply:UpdateHull()
end

if SERVER then
	function GM:GetBaseAppearance(ply)
		if not ply:HasCharacter() then
			return {
				_base = {
					Model = table.Random({"models/crow.mdl", "models/pigeon.mdl", "models/seagull.mdl"})
				}
			}, true
		end

		local override = ply:AppearanceOverride()

		if override then
			return override, true
		end

		return ply:RunCharFlag("GetModelData"), false
	end

	function PLAYER:UpdateAppearance()
		local appearance, hasOverride = hook.Run("GetBaseAppearance", self)

		if not hasOverride then
			local clothing = self:RunCharFlag("Clothing")
			local items = self:GetItems()

			for _, item in pairs(items) do
				if not item.GetModelData then
					continue
				end

				local data = item:GetModelData(self, clothing)

				if data then
					table.Merge(appearance, data)
				end
			end

			for _, item in pairs(items) do
				if not item.PostModelData then
					continue
				end

				item:PostModelData(self, appearance, clothing)
			end

			self:RunCharFlag("PostModelData", appearance)
		end

		assert(appearance._base, "UpdateAppearance somehow ended up without _base model data!")

		if not appearance._base.Color then
			appearance._base.Color = team.GetColor(self:Team())
		end

		self:SetAppearance(appearance)
	end

	function GM:GetHandAppearance(ply)
		local base = ModelData.GetHands(ply:GetModel())

		if not ply:HasCharacter() or ply:AppearanceOverride() then
			return base, true
		end

		return ply:RunCharFlag("GetHandData", base), false
	end

	function GM:PlayerSetHandsModel(ply, ent)
		local hands, hasOverride = hook.Run("GetHandAppearance", ply)

		if not hasOverride then
			local clothing = ply:RunCharFlag("Clothing")
			local items = ply:GetItems()

			for _, item in pairs(items) do
				if not item.GetHandData then
					continue
				end

				local data = item:GetHandData(ply, clothing)

				if data then
					table.Merge(hands, data)
				end
			end

			for _, item in pairs(items) do
				if not item.PostHandData then
					continue
				end

				item:PostHandData(ply, hands, clothing)
			end

			ply:RunCharFlag("PostHandData", hands)
		end

		ent:ApplyModel(hands)
	end
end

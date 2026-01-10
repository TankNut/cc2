module("Hull", package.seeall)

PlayerVar.Add("Scale", {Default = 1})
CharacterVar.Add("CharacterScale", {Default = 0, Field = "Scale", DataType = FLOAT()})

local PLAYER = FindMetaTable("Player")

function PLAYER:UpdateHull()
	local hull = ModelData.GetHull(self:GetModel())
	local scale = hook.Run("GetPlayerScale", self)

	self:SetModelScale(scale, 0.0001)

	timer.Simple(0, function()
		if not IsValid(self) then
			return
		end

		self:SetHull(hull.Standing[1], hull.Standing[2])
		self:SetHullDuck(hull.Crouching[1], hull.Crouching[2])

		self:SetViewOffset(hull.Standing[3] * scale)
		self:SetViewOffsetDucked(hull.Crouching[3] * scale)
	end)
end

function GM:GetPlayerScale(ply)
	return ply:RunCharFlag("PlayerScale") * ply:Scale()
end

function GM:OnScaleChanged(ply, old, new, loaded)
	ply:UpdateHull()
end

function GM:OnCharacterScaleChanged(ply, old, new, loaded)
	ply:UpdateHull()
end

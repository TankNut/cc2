module("Hull", package.seeall)

List = List or {}
Models = Models or {}
Cache = Cache or {}

Default = {
	Standing = {Vector(-16, -16, 0), Vector(16, 16, 72), Vector(0, 0, 64)},
	Crouching = {Vector(-16, -16, 0), Vector(16, 16, 36), Vector(0, 0, 28)},
}

PlayerVar.Add("Scale", {Default = -1})
CharacterVar.Add("Scale", {Default = 1, DataType = FLOAT()})

local meta = FindMetaTable("Player")

function AddType(name, data)
	data.Standing = data.Standing or Default.Standing
	data.Crouching = data.Crouching or data.Standing

	List[name] = data
end

function AddModel(hull, ...)
	for _, match in ipairs({...}) do
		Models[match] = hull
	end
end

function Find(mdl)
	mdl = string.lower(mdl)

	for match, hull in pairs(Models) do
		if string.find(mdl, match) and List[hull] then
			return List[hull]
		end
	end

	return Default
end

function Clear(ply)
	Cache[ply] = nil
end

function meta:GetPlayerScale()
	return Cache[self] or 1
end

function meta:UpdateHull()
	local hull = Find(self:GetModel())
	local scale, visual = hook.Run("GetPlayerScale", self)

	Cache[self] = visual

	self:SetModelScale(visual, 0.0001)

	timer.Simple(0, function()
		if not IsValid(self) then
			return
		end

		self:SetHull(hull.Standing[1] * scale, hull.Standing[2] * scale)
		self:SetHullDuck(hull.Crouching[1] * scale, hull.Crouching[2] * scale)

		self:SetViewOffset(hull.Standing[3] * scale)
		self:SetViewOffsetDucked(hull.Crouching[3] * scale)
	end)
end

function GM:GetPlayerScale(ply)
	local override = ply:Scale()

	if override != -1 then
		return override, override * ply:CharacterScale()
	end

	return ply:RunCharFlag("PlayerScale")
end

function GM:PlayerScaleChanged(ply, old, new, loaded)
	ply:UpdateHull()
end

function GM:CharacterScaleChanged(ply, old, new, loaded)
	if not loaded then
		ply:UpdateHull()
	end
end

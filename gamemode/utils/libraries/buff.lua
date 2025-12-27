module("buff", package.seeall)

All = All or {}

local PLAYER = FindMetaTable("Player")

function Register(name, buff)
	buff.Name = buff.Name or name

	inherit.Register("buff", name, buff, buff.Base or "base")
end

function Hook(func, ...)
	for _, buffs in pairs(All) do
		for _, buff in pairs(buffs) do
			local val = buff[func]

			if isfunction(val) then
				local ret = {val(buff, ...)}

				if #ret > 0 then
					return unpack(ret)
				end
			elseif val != nil then
				return val
			end
		end
	end
end

function PlayerHook(ply, func, ...)
	for _, buff in pairs(ply:GetBuffs()) do
		local val = buff[func]

		if isfunction(val) then
			local ret = {val(buff, ...)}

			if #ret > 0 then
				return unpack(ret)
			end
		elseif val != nil then
			return val
		end
	end
end

function PLAYER:GetBuffs()
	return All[self] or {}
end

function PLAYER:GetBuff(name)
	if not All[self] then
		return
	end

	return All[self][name]
end

function PLAYER:HasBuff(name)
	return tobool(self:GetBuff(name))
end

function PLAYER:AddBuff(name, data)
	local buff = self:GetBuff(name)

	if isnumber(data) then
		data = {Amount = data}
	end

	data = data or {Amount = 1}
	data.CurTime = data.CurTime or CurTime()

	if buff then
		buff:OnDuplicate(data)
	else
		local instance = inherit.Instance("buff", name, {
			Player = self
		})

		self:GetBuffs()[name] = instance

		instance:Initialize(data)
	end

	if SERVER then
		netstream.Send(self, "AddBuff", name, data)
	end
end

function PLAYER:RemoveBuff(name, amount)
	local buff = self:GetBuff(name)

	if not buff then
		return
	end

	if amount == true then
		buff:Remove()
	else
		buff:RemoveStacks(amount or 1)
	end

	if SERVER then
		netstream.Send(self, "RemoveBuff", name, amount)
	end
end

function PLAYER:ClearBuffs()
	for _, buff in pairs(self:GetBuffs()) do
		buff:Remove()
	end

	if SERVER then
		netstream.Send(self, "ClearBuffs")
	end
end

if CLIENT then
	netstream.Hook("AddBuff", function(name, data)
		lp:AddBuff(name, data)
	end)

	netstream.Hook("RemoveBuff", function(name, amount)
		lp:RemoveBuff(name, amount)
	end)

	netstream.Hook("ClearBuffs", function()
		lp:ClearBuffs()
	end)
end

hook.Add("OnEntityCreated", "cc2.Buffs", function(ent)
	if not IsValid(ent) or not ent:IsPlayer() then
		return
	end

	All[ent] = {}
end)

hook.Add("EntityRemoved", "cc2.Buffs", function(ent, fullUpdate)
	if fullUpdate or not ent:IsPlayer() then
		return
	end

	ent:ClearBuffs()

	All[ent] = nil
end)

hook.Add("Think", "cc2.Buffs", function() Hook("Think") end)

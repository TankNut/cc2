ITEM.Base = "base_stacking"
ITEM.Internal = true

ITEM.Rarity = RARITY_COMMON
ITEM.Category = "Medical"

ITEM.CanSelfApply = false
ITEM.SelfApplyTime = 5

ITEM.CanApply = false
ITEM.ApplyTime = 2

ITEM.Range = 50

ITEM.Actions = {}

ITEM.Actions.UseOn = {
	Name = "Use on",
	Priority = ITEM_ACTION_OPTION,

	Context = table.Lookup({
		"InventoryContext", "RightClick", "Examine"
	}),

	CanRun = function(self, ply)
		return self:CanInteract(ply) and #self:GetTargets() > 0
	end,
	SubOptions = function(self)
		return table.Map(self:GetTargets(), function(ply)
			local name = ply == self:GetParent() and "Yourself" or ply:VisibleRPName()

			return {
				Name = name,
				Value = ply
			}
		end)
	end,
	Progress = function(self, ply, target)
		local time = ply == target and self.SelfApplyTime or self.ApplyTime
		local validate = {
			progress.Player(ply, {Alive = true})
		}

		if ply != target then
			table.insert(validate, progress.Player(target, {Alive = true, Range = self.Range}))
		end

		if SERVER then
			self:OnStartApply(ply, target)
		end

		return {
			Name = string.format("Using %s...", self:GetName(true)),
			EndTime = CurTime() + time,
			Validate = validate,
			Callback = CLIENT and stub or nil
		}
	end,
	Validate = function(self, ply, target)
		return self:CanTarget(target)
	end,
	Callback = function(self, ply, target)
		self:OnApply(ply, target)
	end
}

function ITEM:CanTarget(ply)
	if not ply:HasCharacter() or not ply:Alive() then
		return false
	end

	if ply == self:GetParent() then
		return self.CanSelfApply
	end

	return self.CanApply
end

function ITEM:GetTargets()
	local targets = {}
	local parent = self:GetParent()
	local pos = parent:GetPos()

	if self:CanTarget(parent) then
		table.insert(targets, parent)
	end

	for _, ply in player.Iterator() do
		if ply != parent and self:CanTarget(ply) and ply:GetPos():Distance(pos) <= self.Range then
			table.insert(targets, ply)
		end
	end

	return targets
end

if SERVER then
	function ITEM:OnStartApply(ply, target)
	end

	function ITEM:OnApply(ply, target)
	end
end

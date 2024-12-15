local temp = Color(0, 127, 31, 25)
local equip = Color(100, 160, 210, 25)

function ITEM:GetHighlightColor()
	if self:IsEquipped() then
		return equip
	end

	if self:IsTemporaryItem() then
		return temp
	end
end

function ITEM:RemovePanels()
	for panel in pairs(self.Panels) do
		panel:Remove()
	end

	table.Empty(self.Panels)
end

function ITEM:IsSelected()
	return IsValid(CCP.PlayerMenu) and CCP.PlayerMenu.SelectedItem == self.ID
end

function ITEM:ConfigureModelPanel(icon)
	icon:SetModel(self:GetModel())

	local ent = icon:GetEntity()

	self:SetItemAppearance(ent)

	local tab = PositionSpawnIcon(ent, ent:GetPos())

	icon:SetFOV(tab.fov)
	icon:SetCamPos(tab.origin)
	icon:SetLookAng(tab.angles)
end

function ITEM:OpenActionMenu(category)
	local actions = self:GetAvailableActions(category or "Rightclick")

	if #actions < 1 then
		return
	end

	local dmenu = DermaMenu()
	dmenu:SetPos(gui.MousePos())

	for _, action in ipairs(actions) do
		local options = action.SubOptions

		if isfunction(options) then
			options = action.SubOptions(self, lp)
		end

		if options and #options > 0 then
			local parent = dmenu:AddSubMenu(action.Name)

			for _, v in ipairs(options) do
				parent:AddOption(v.Name, function()
					self:RunAction(lp, action.Name, v.Value)
				end)
			end
		else
			dmenu:AddOption(action.Name, function()
				self:RunAction(lp, action.Name)
			end)
		end
	end

	dmenu:Open()
end

local template = [[
<font=CombineControl.LabelBig><colour=ltgrey>%s</colour></font>
<font=CombineControl.LabelSmall><colour=white>%s</colour></font>
]]

function ITEM:DrawTooltip()
	if not self.Tooltip or self.ReloadTooltip then
		self.Tooltip = markup.Parse(string.format(template, self:GetName(), self:GetDescription()), 256)
		self.ReloadTooltip = false
	end

	local x, y = gui.MouseX() + 15 , gui.MouseY() + 5
	local w, h = self.Tooltip:Size()

	surface.SetDrawColor(0, 0, 0, 240)
	surface.DrawRect(x - 5, y - 5, w + 10, h + 10)

	surface.SetDrawColor(0, 0, 0, 255)
	surface.DrawOutlinedRect(x - 5, y - 5, w + 10, h + 10)

	self.Tooltip:Draw(x, y)
end

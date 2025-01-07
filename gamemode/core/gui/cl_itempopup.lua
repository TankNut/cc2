local PANEL = {}
DEFINE_BASECLASS("CCFrame")

function PANEL:Init()
	self:SetSize(400, 450)
	self:DockPadding(10, 10, 10, 10)

	self:SetDraggable(true)
	self:SetCloseOnPause(true)

	self.ModelPanel = self:Add("CCItemModelPanel")
	self.ModelPanel:Dock(TOP)
	self.ModelPanel:SetTall(200)

	self.Buttons = self:Add("DPanel")
	self.Buttons:DockMargin(0, 5, 0, 0)
	self.Buttons:Dock(BOTTOM)
	self.Buttons:SetPaintBackground(false)
	self.Buttons:SetTall(22 * 3 + 15)

	self.Right = self.Buttons:Add("DPanel")
	self.Right:Dock(RIGHT)
	self.Right:SetPaintBackground(false)
	self.Right:SetWide(100)

	self.DestroyButton = self.Right:Add("DButton")
	self.DestroyButton:DockMargin(0, 5, 0, 0)
	self.DestroyButton:Dock(BOTTOM)
	self.DestroyButton:SetText("Destroy")
	self.DestroyButton.DoClick = function()
		self.Item:RunAction(lp, "Destroy")
	end

	self.DropButton = self.Right:Add("DButton")
	self.DropButton:Dock(BOTTOM)
	self.DropButton:DockMargin(0, 5, 0, 0)
	self.DropButton:SetText("Drop")
	self.DropButton.DoClick = function()
		self.Item:RunAction(lp, "Drop")
	end

	self.ActionButton = self.Right:Add("DButton")
	self.ActionButton:Dock(BOTTOM)
	self.ActionButton:DockMargin(0, 5, 0, 0)
	self.ActionButton:SetText("Actions")
	self.ActionButton.DoClick = function()
		self.Item:OpenActionMenu("Examine")
	end

	self.TitleLabel = self:Add("DLabel")
	self.TitleLabel:DockMargin(0, 5, 0, 0)
	self.TitleLabel:Dock(TOP)
	self.TitleLabel:SetFont("CombineControl.LabelGiant")

	self.Scroll = self:Add("DScrollPanel")
	self.Scroll:Dock(FILL)

	self.DescriptionLabel = self.Scroll:Add("ScribeLabel")

	self.DataLabel = self.Buttons:Add("DLabel")
	self.DataLabel:Dock(FILL)
	self.DataLabel:SetContentAlignment(1)
	self.DataLabel:SetTextColor(self:GetSkin().Text.Disabled)

	self:MakePopup()
	self:Center()
end

function PANEL:Setup(item)
	self.Item = item
	self.Item.Panels[self] = true

	local name = item:GetName()

	self:SetTopBar(name)

	self.ModelPanel:SetItem(item)

	self.TitleLabel:SetText(name)
	self.TitleLabel:SizeToContentsY()
	self.TitleLabel:SetTextColor(item:GetRarityData().Color)

	self.DescriptionLabel:SetWide(self.Scroll:GetWide() - 15)
	self.DescriptionLabel:SetText("<font=CombineControl.LabelMedium>\n" .. item:GetDescription())
	self.DescriptionLabel:SizeToContentsY()

	self.DataLabel:SetText(string.format("Weight: %s kg\nTags: %s", item:GetWeight(), table.concat(item:GetTags(), ", ")))

	self.DestroyButton:SetDisabled(not item:CanRunAction(lp, "Destroy"))
	self.DropButton:SetDisabled(not item:CanRunAction(lp, "Drop"))
	self.ActionButton:SetDisabled(#item:GetAvailableActions("Examine") < 1)
end

function PANEL:OnRemove()
	self.Item.Panels[self] = nil
end

derma.DefineControl("GUI_ItemPopup", "", PANEL, "CCFrame")

GUI.Register("ItemPopup", function(item)
	for panel in pairs(item.Panels) do
		if panel:GetName() == "GUI_ItemPopup" and panel.Item == item then
			panel:MoveToFront()

			return
		end
	end

	local panel = vgui.Create("GUI_ItemPopup")

	panel:Setup(item)

	return panel
end)

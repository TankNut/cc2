local PANEL = {}
DEFINE_BASECLASS("CCFrame")

function PANEL:Init()
	self:SetSize(400, 450)
	self:DockPadding(10, 10, 10, 10)

	self:SetDraggable(true)
	self:SetCloseOnPause(true)

	self:MakePopup()
	self:Center()
end

function PANEL:Setup(item)
	self.Item = item
	self.Item.Panels[self] = true

	self:SetTopBar(item:GetName())
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

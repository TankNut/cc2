local PANEL = {}

function PANEL:Init()
	self:SetWide(200)
	self:DockPadding(10, 10, 10, 10)

	if lp:HasCharacter() then
		self:SetCloseOnPause(true)
	end

	self:SetTopBar("Character Generator")
	self:BuildTree()

	self.Buttons = {}
	self:Populate(self.Tree)

	self:MakePopup()
	self:Center()
end

function PANEL:BuildTree()
	self.Tree = {}

	for _, id in ipairs(lp:GetCharacterGenerators()) do
		local generator = CharacterGen.Get(id)

		local exploded = string.Explode("/", generator.Name)
		local node = self.Tree

		for k, name in ipairs(exploded) do
			if k == #exploded then
				node[name] = id
			elseif not node[name] then
				node[name] = {
					_parent = node
				}

				node = node[name]
			else
				node = node[name]
			end
		end
	end
end

function PANEL:Populate(node)
	for _, v in pairs(self.Buttons) do
		v:Remove()
	end

	for key, val in pairs(node) do
		if key == "_parent" then
			continue
		end

		local button = self:Add("DButton")

		button:DockMargin(0, 0, 0, 5)
		button:Dock(TOP)
		button:SetText(key)

		button.DoClick = function(pnl)
			if istable(val) then
				self:Populate(val)
			else
				pnl:SetDisabled(true)

				self.ChoiceMade = true

				netstream.Send("GenCharacter", val)
			end
		end

		table.insert(self.Buttons, button)
	end

	self.Cancel = self:Add("DButton")
	self.Cancel:DockMargin(0, 15, 0, 0)
	self.Cancel:Dock(TOP)
	self.Cancel:SetText("Cancel")

	self.Cancel.DoClick = function(pnl)
		if node._parent then
			self:Populate(node._parent)
		else
			self:Close()
		end
	end

	table.insert(self.Buttons, self.Cancel)

	self:InvalidateLayout(true)
	self:SizeToChildren(false, true)
end

function PANEL:OnClose()
	self:Remove()

	if not self.ChoiceMade then
		GUI.Open("CharacterSelect")
	end
end

function PANEL:PaintFullScreen(x, y, w, h)
	draw.DrawBackgroundBlur(1, x, y, w, h)
end

derma.DefineControl("GUI_CharacterGen", "", PANEL, "CC_Frame")

GUI.Register("CharacterGen", function()
	return vgui.Create("GUI_CharacterGen")
end, true)

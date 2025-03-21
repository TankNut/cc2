local validation = {
	validate.Max(32)
}

Action.Add("SetButtonName", {
	Name = "Set Button Name...",

	Access = ACTION_EDITMODE,
	Target = ACTION_INTERACT,

	CanRun = function(self, ply)
		return self:IsMapButton()
	end,
	Validate = function(self, ply, name)
		return validate.Value(name, validation)
	end,
	Client = function(self)
		return true, GUI.Open("Input", "string", "Change Button Name", {
			Default = self:ButtonName(),
			Validate = validation,
			Name = "Button names"
		})
	end,
	Callback = function(self, ply, name)
		self:SetButtonName(name)
	end
})

Action.Add("SetButtonType", {
	Name = "Set Button Type...",

	Access = ACTION_EDITMODE,
	Target = ACTION_INTERACT,

	CanRun = function(self, ply)
		return self:IsMapButton()
	end,
	SubOptions = function(self, ply)
		return {
			{Name = "Enabled", Value = false},
			{Name = "Disabled", Value = true}
		}
	end,
	Callback = function(self, ply, value)
		self:SetButtonDisabled(value)
	end
})

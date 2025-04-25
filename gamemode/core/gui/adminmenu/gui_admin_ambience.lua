local PANEL = {}

function PANEL:GetSongTypeFromPreset(preset)
	local types = {
		[SONG_IDLE] = "Idle",
		[SONG_ALERT] = "Alert",
		[SONG_ACTION] = "Action",
		[SONG_STINGER] =  "Stinger"
	}

	return types[preset.Type] or "None"
end

function PANEL:CreateRandomizeButton(label, type)
	local button = self:Add("DButton")

	button:SetText(label)
	button:SetWide(150)

	local songs = table.Filter(self.SongPresets:GetLines(), function(_, song)
		return song.Preset.Type == type
	end)

	button:SetDisabled(#songs == 0)

	button.DoClick = function()
		self.SongPresets:ClearSelection()
		self.SongPresets:SelectItem(table.Random(songs))
	end

	return button
end

function PANEL:CreateLabel(text, bold, width)
	local label = self:Add("DLabel")

	label:SetFont("CombineControl.LabelMedium" .. (bold and "Bold" or ""))
	label:SetWide(width or 150)
	label:SetText(text)

	return label
end

function PANEL:SetupCommandButtons(command, list, isPlayButton)
	local types = { "Global", "Local" }

	for _, type in pairs(types) do
		local button = self:Add("DButton")

		button:SetText(type)
		button:SetWide(70)
		button:SetDisabled(isPlayButton)

		button.DoClick = function()
			if isPlayButton then
				local path = string.Trim(self.Input:GetValue())
				local volume = math.Remap(self.Volume:GetValue(), 1, 200, 0.01, 2)

				RunConsoleCommand(command, string.lower(type), path, volume)
			else
				RunConsoleCommand(command, string.lower(type))
			end
		end

		table.insert(list, button)
	end
end

function PANEL:Init()
	self.StopSound = self:Add("DButton")
	self.StopSound:SetWide(150)
	self.StopSound:SetText("Force Stopsound")

	self.StopSound.DoClick = function()
		RunConsoleCommand("rpa_stopsound")
	end

	self.KillAmbience = self:Add("DButton")
	self.KillAmbience:SetWide(150)
	self.KillAmbience:SetText("Kill Ambience")

	self.KillAmbience.DoClick = function()
		RunConsoleCommand("rpa_killambience")
	end

	self.SongPresets = self:Add("DListView")
	self.SongPresets:SetMultiSelect(false)
	self.SongPresets:AddColumn("Type"):SetFixedWidth(50)
	self.SongPresets:AddColumn("Length"):SetFixedWidth(50)
	self.SongPresets:AddColumn("Title")
	self.SongPresets:SetTall(202)

	for _, preset in ipairs(Ambience.Songs) do
		self.SongPresets:AddLine(self:GetSongTypeFromPreset(preset), string.ToMinutesSeconds(preset.Length), preset.Name).Preset = preset
	end

	self.SongPresets.OnRowRightClick = function(_, _, line)
		local path = line.Preset.Path
		local dmenu = DermaMenu()

		dmenu:AddOption("Preview Selection", function()
			Ambience.PlayPreview(audio, math.Remap(self.Volume:GetValue(), 1, 200, 0.01, 2))
		end):SetIcon("icon16/ipod_cast.png")

		dmenu:AddOption("Play Global Music", function()
			RunConsoleCommand("rpa_playmusic", "global", path)
		end):SetIcon("icon16/control_fastforward_blue.png")

		dmenu:AddOption("Play Local Music", function()
			RunConsoleCommand("rpa_playmusic", "local", path)
		end):SetIcon("icon16/control_play_blue.png")

		dmenu:AddOption("Play Global Effect", function()
			RunConsoleCommand("rpa_playeffect", "global", path)
		end):SetIcon("icon16/control_fastforward.png")

		dmenu:AddOption("Play Local Effect", function()
			RunConsoleCommand("rpa_playeffect", "local", path)
		end):SetIcon("icon16/control_play.png")

		dmenu:SetSkin("CombineControl")
		dmenu:Open(gui.MousePos())
	end

	self.SongPresets.OnRowSelected = function(_, _, line)
		self.Input:SetValue(line.Preset.Path)
	end

	self.RandomIdle = self:CreateRandomizeButton("Select Random Idle", SONG_IDLE)
	self.RandomAlert = self:CreateRandomizeButton("Select Random Alert", SONG_ALERT)
	self.RandomAction = self:CreateRandomizeButton("Select Random Action", SONG_ACTION)
	self.RandomStinger = self:CreateRandomizeButton("Select Random Stinger", SONG_STINGER)

	self.InputLabel = self:CreateLabel("File Location or URL", true)
	self.Input = self:Add("DTextEntry")
	self.Input:SetTall(22)
	self.Input:SetUpdateOnType(true)

	self.Input.OnValueChange = function(_, val)
		local disabled = #string.Trim(val) == 0

		self.Preview:SetDisabled(disabled)

		for _, button in pairs(self.PlayMusicButtons) do
			button:SetDisabled(disabled)
		end

		for _, button in pairs(self.PlayEffectButtons) do
			button:SetDisabled(disabled)
		end
	end

	self.Preview = self:Add("DButton")
	self.Preview:SetText("Preview Selection")
	self.Preview:SetWide(150)
	self.Preview:SetDisabled(true)

	self.Preview.DoClick = function()
		local path = string.Trim(self.Input:GetValue())
		local volume = math.Remap(self.Volume:GetValue(), 1, 200, 0.01, 2)

		Ambience.PlayPreview(path, volume)
	end

	self.VolumeLabel = self:CreateLabel("Playback Volume", true)
	self.Volume = self:Add("DNumSlider")
	self.Volume:SetMin(1)
	self.Volume:SetMax(200)
	self.Volume:SetDecimals(0)
	self.Volume:SetValue(100)
	self.Volume.Slider:SetNotches(20)

	self.Volume.PerformLayout = function(pnl, w, h)
		pnl.Label:SetWide(0)
		pnl.TextArea:SetWide(25)
	end

	self.PlayMusic = self:CreateLabel("Play Music", false, 75)
	self.PlayMusicButtons = {}
	self:SetupCommandButtons("rpa_playmusic", self.PlayMusicButtons, true)

	self.StopMusic = self:CreateLabel("Stop Music", false, 75)
	self.StopMusicButtons = {}
	self:SetupCommandButtons("rpa_stopmusic", self.StopMusicButtons, false)

	self.PlayEffect = self:CreateLabel("Play Effect", false, 75)
	self.PlayEffectButtons = {}
	self:SetupCommandButtons("rpa_playeffect", self.PlayEffectButtons, true)

	self.StopEffect = self:CreateLabel("Stop Effect", false, 75)
	self.StopEffectButtons = {}
	self:SetupCommandButtons("rpa_stopeffect", self.StopEffectButtons, false)
end

function PANEL:PerformLayout(w, h)
	self.KillAmbience:AlignRight()
	self.KillAmbience:AlignBottom()

	self.StopSound:AlignRight()
	self.StopSound:MoveAbove(self.KillAmbience, 5)

	self.RandomAction:AlignRight()
	self.RandomAction:AlignTop()

	self.RandomIdle:MoveLeftOf(self.RandomAction, 5)
	self.RandomIdle:AlignTop()

	self.RandomStinger:AlignRight()
	self.RandomStinger:MoveBelow(self.RandomAction, 5)

	self.RandomAlert:MoveLeftOf(self.RandomStinger, 5)
	self.RandomAlert:MoveBelow(self.RandomIdle, 5)

	self.Preview:AlignRight()
	self.Preview:MoveAbove(self.StopSound, 5)

	self.Input:AlignLeft()
	self.Input:StretchRightTo(self.Preview, 10)
	self.Input:MoveAbove(self.StopSound, 5)

	self.InputLabel:AlignLeft()
	self.InputLabel:StretchRightTo(self.Preview, 10)
	self.InputLabel:MoveAbove(self.Input, 5)

	self.Volume:MoveRightOf(self.SongPresets, 5)
	self.Volume:StretchToParent(nil, nil, 0, nil)
	self.Volume:MoveAbove(self.InputLabel, 0)

	self.VolumeLabel:MoveRightOf(self.SongPresets, 10)
	self.VolumeLabel:MoveAbove(self.Volume, -5)

	self.SongPresets:AlignLeft()
	self.SongPresets:StretchRightTo(self.RandomIdle, 10)
	self.SongPresets:StretchBottomTo(self.InputLabel, 5)

	self.PlayMusic:AlignLeft()
	self.PlayMusic:MoveBelow(self.Input, 5)

	local previous = self.PlayMusic

	for _, button in pairs(self.PlayMusicButtons) do
		button:MoveRightOf(previous, 5)
		button:MoveBelow(self.Input, 5)

		previous = button
	end

	self.PlayEffect:MoveRightOf(previous, 20)
	self.PlayEffect:MoveBelow(self.Input, 5)

	previous = self.PlayEffect

	for _, button in pairs(self.PlayEffectButtons) do
		button:MoveRightOf(previous, 5)
		button:MoveBelow(self.Input, 5)

		previous = button
	end

	self.StopMusic:AlignLeft()
	self.StopMusic:MoveBelow(self.PlayMusic, 5)

	previous = self.StopMusic

	for index, button in pairs(self.StopMusicButtons) do
		button:MoveRightOf(previous, 5)
		button:MoveBelow(self.PlayMusicButtons[index], 5)

		previous = button
	end

	self.StopEffect:MoveRightOf(previous, 20)
	self.StopEffect:MoveBelow(self.PlayMusic, 5)

	previous = self.StopEffect

	for index, button in pairs(self.StopEffectButtons) do
		button:MoveRightOf(previous, 5)
		button:MoveBelow(self.PlayEffectButtons[index], 5)

		previous = button
	end
end

derma.DefineControl("CC_AdminMenu_Ambience", "", PANEL, "Panel")

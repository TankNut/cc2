local BaseClass = inherit.Get("hud", "base")

HUD.Name = "Player Labels"

HUD.Default = true
HUD.Setting = "PlayerLabels"

HUD.ExtraSettings = {
	{"Legacy", {
		Name = "    Use Legacy Mode",
		ClientOnly = true,
		Default = false,
		Validate = validate.Bool(),
		Panel = "CC_Setting_Bool",
		Dark = true
	}},
	{"ShowNames", {
		Name = "    Show Character Names",
		ClientOnly = true,
		Default = true,
		Validate = validate.Bool(),
		Panel = "CC_Setting_Bool",
		Dark = true
	}},
	{"ShowDescriptions", {
		Name = "    Show Descriptions",
		ClientOnly = true,
		Default = true,
		Validate = validate.Bool(),
		Panel = "CC_Setting_Bool",
		Dark = true
	}},
	{"ShowTyping", {
		Name = "    Show Typing Indicators",
		ClientOnly = true,
		Default = true,
		Validate = validate.Bool(),
		Panel = "CC_Setting_Bool",
		Dark = true
	}},
	{"AlwaysTyping", {
		Name = "    Always Show Typing Indicators",
		ClientOnly = true,
		Default = true,
		Validate = validate.Bool(),
		Panel = "CC_Setting_Bool",
		Dark = true
	}}
}

function HUD:Initialize()
	self.Cache = {}
end

function HUD:ShouldDraw()
	if Settings.Get("SeeAll") then
		return false
	end

	return BaseClass.ShouldDraw(self)
end

function HUD:IsVisible(ply)
	local ent = self:GetPlayer(ply)

	if self:GetExtraSetting("Legacy") then
		return lp:CanSee(ent, true)
	else
		local tr = lp:GetEyeTrace()

		return tr.Entity == ent and (tr.Fraction * 32768) <= lp:GetSightRange()
	end
end

function HUD:Think()
	for _, ply in player.Iterator() do
		if ply == lp then
			continue
		end

		if not self.Cache[ply] then
			self.Cache[ply] = {
				Alpha = 0,
				FadeTime = CurTime()
			}
		end

		local cache = self.Cache[ply]

		if self:IsVisible(ply) then
			cache.Alpha = math.min(cache.Alpha + FrameTime(), 1)
			cache.FadeTime = CurTime() + 0.05
		elseif cache.FadeTime < CurTime() then
			cache.Alpha = math.max(cache.Alpha - FrameTime(), 0)
		end
	end
end

function HUD:DrawPlayer(ply, alpha)
	local lines = {}

	if self:GetExtraSetting("ShowNames") then
		local color = ColorToHex(team.GetColor(ply:Team()))

		table.insert(lines, {
			scribe.Parse(string.format("<f=CombineControl.PlayerFont><ol><c=%s>%s", color, ply:VisibleRPName())), alpha
		})
	end

	if self:GetExtraSetting("ShowDescriptions") then
		local desc = ply:ShortDescription()

		if #desc > 0 then
			table.insert(lines, {
				scribe.Parse("<f=CombineControl.PlayerFont><ol><c=#DCDCDC>" .. ply:ShortDescription()), alpha
			})
		end
	end

	if self:GetExtraSetting("ShowTyping") and ply:Typing() then
		table.insert(lines, {
			scribe.Parse("<f=CombineControl.LabelMediumItalic><ol><c=cc_normal>" .. ply:GetTypingString()),
			self:GetExtraSetting("AlwaysTyping") and 1 or alpha
		})
	end

	if #lines > 0 then
		self:AddWorldLabel(self:GetPlayer(ply):EyePos() + Vector(0, 0, 10), lines)
	end
end

function HUD:PaintBackground(w, h)
	if Settings.Get("SeeAll") then
		return
	end

	for ply, cache in pairs(self.Cache) do
		if not IsValid(ply) then
			self.Cache[ply] = nil

			continue
		end

		if ply:IsDormant() or ply:GetNoDraw() or not ply:Alive() then
			continue
		end

		self:DrawPlayer(ply, cache.Alpha)
	end
end

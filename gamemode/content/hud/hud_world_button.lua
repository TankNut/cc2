HUD.Name = "Button Labels"

HUD.Setting = "ButtonLabels"

function HUD:Initialize()
	self.Cache = {}
end

function HUD:Think()
	local ct = CurTime()
	local ft = FrameTime()

	for button in pairs(Buttons.List) do
		if not self.Cache[button] then
			self.Cache[button] = {
				Alpha = 0,
				FadeTime = ct,
			}
		end

		local cache = self.Cache[button]

		if lp:CanSee(button, Config.Get("InteractRange")) then
			cache.Alpha = math.min(cache.Alpha + ft, 1)
			cache.FadeTime = ct + 0.05
		elseif cache.FadeTime < ct then
			cache.Alpha = math.max(cache.Alpha - ft, 0)
		end
	end
end

function HUD:PaintBackground(w, h)
	for button, cache in pairs(self.Cache) do
		if not IsValid(button) then
			self.Cache[button] = nil

			continue
		end

		if button:IsDormant() or #button:ButtonName() == 0 then
			continue
		end

		self:AddWorldLabel(button:WorldSpaceCenter(), {{
			scribe.Parse(string.format("<f=BudgetLabel><ol>%s", button:ButtonName())), cache.Alpha
		}})
	end
end

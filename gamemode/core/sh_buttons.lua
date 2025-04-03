module("Buttons", package.seeall)

List = List or {}

EntityVar.Add("IsMapButton", {Default = false})
EntityVar.Add("ButtonName", {Default = ""})
EntityVar.Add("ButtonDisabled", {Default = false})

GlobalVar.Add("ButtonData", {
	Default = {},
	ServerOnly = true,
	Persist = true,
	MapBased = true
})

function GM:OnIsMapButtonChanged(ent)
	List[ent] = true
end

hook.Add("EntityRemoved", "buttons.EntityRemoved", function(ent)
	if List[ent] then
		List[ent] = nil
	end
end)

if SERVER then
	IsLoading = false

	function Save()
		local data = {}

		for button in pairs(List) do
			local mapCreationId = button:MapCreationID()

			if mapCreationId == -1 then
				continue
			end

			local props = {
				ButtonName = button:ButtonName() != "" and button:ButtonName() or nil,
				ButtonDisabled = button:ButtonDisabled() and true or nil
			}

			if table.IsEmpty(props) then
				continue
			end

			data[mapCreationId] = props
		end

		GAMEMODE:SetButtonData(data)

		deferred.Cancel("buttons.save")
	end

	function Load()
		IsLoading = true

		local data = GAMEMODE:ButtonData()

		for button in pairs(List) do
			if not IsValid(button) then
				continue
			end

			local entData = data[button:MapCreationID()]

			if entData then
				if entData.ButtonName then
					button:SetButtonName(entData.ButtonName)
				end

				if entData.ButtonDisabled then
					button:SetButtonDisabled(true)
				end
			end
		end

		deferred.Cancel("buttons.save")

		IsLoading = false
	end

	function GM:OnButtonDataChanged(old, new, loaded)
		if not loaded then
			return -- We only care about this when GlobalVars are loading in.
		end

		Load()
	end

	hook.Add("OnEntityCreated", "buttons.OnEntityCreated", function(ent)
		if not IsValid(ent) or ent:GetClass() != "func_button" then
			return
		end

		ent:SetIsMapButton(true)
	end)

	hook.Add("PlayerUse", "buttons.PlayerUse", function(ply, ent)
		if ent:ButtonDisabled() then
			return false
		end
	end)

	local function queueSave()
		if IsLoading then
			return
		end

		deferred.Call("buttons.save", 60, Save)
	end

	hook.Add("OnButtonNameChanged", "buttons.OnButtonNameChanged", queueSave)
	hook.Add("OnButtonDisabledChanged", "buttons.OnButtonDisabledChanged", queueSave)

	hook.Add("PostCleanupMap", "buttons", Load)
end

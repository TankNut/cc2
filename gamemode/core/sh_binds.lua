function GM:PlayerButtonDown(ply, button)
	if button == KEY_B then
		local weapon = ply:GetActiveWeapon()

		if weapon:IsType("weapon_cc_base") then
			weapon:ToggleHolster()
		end

		return
	end

	if SERVER then
		numpad.Activate(ply, button)
	end
end

if CLIENT then
	function GM:PlayerBindPress(ply, bind, down)
		if not ply:HasCharacter() then
			return true
		end

		if Chat.Bind(bind, down) then return true end
		if WeaponSelect.Bind(bind, down) then return true end
	end

	local toggleSprint = false
	local lastSprint = false

	local toggleCrouch = false
	local lastCrouch = false

	function GM:CreateMove(cmd)
		if Settings.Get("ToggleCrouch") then
			local down = cmd:KeyDown(IN_DUCK)

			if down and not lastCrouch then
				toggleCrouch = not toggleCrouch
			end

			if toggleCrouch then
				cmd:AddKey(IN_DUCK)
			end

			lastCrouch = down
		end

		if Settings.Get("ToggleSprint") then
			local down = cmd:KeyDown(IN_SPEED)

			if down and not lastSprint then
				toggleSprint = not toggleSprint
			end

			if toggleSprint then
				cmd:AddKey(IN_SPEED)
			end

			lastSprint = down
		end
	end

	function GM:ScoreboardShow()
		GUI.Open("Scoreboard")
	end

	function GM:ScoreboardHide()
		GUI.Close("Scoreboard")
	end
else
	function GM:ShowHelp(ply)
		ply:OpenGUI("HelpMenu")
	end

	function GM:ShowTeam(ply)
		ply:OpenGUI("CharacterSelect")
	end

	function GM:ShowSpare1(ply)
		ply:OpenGUI("PlayerMenu")
	end

	function GM:ShowSpare2(ply)
		if ply:IsAdmin() then
			ply:OpenGUI("AdminMenu")
		end
	end
end

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

	local lastForward = 0
	local forward = 0

	local lastSide = 0
	local side = 0

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

		if Settings.Get("AutoWalk") then
			local commandNumber = cmd:CommandNumber()
			local sensitivity = Settings.Get("AutoWalkSensitivity")
			local curTime = CurTime()

			if (lp:KeyPressed(IN_FORWARD) or lp:KeyPressed(IN_BACK)) and commandNumber != 0 then
				local timeSince = curTime - lastForward
				local lastForwardMove = forward

				if forward == 0 and timeSince < sensitivity then
					forward = cmd:GetForwardMove()
					lastForward = 0
				else
					forward = 0
				end

				if lastForwardMove == 0 and forward == 0 then
					lastForward = curTime
				end
			end

			if (lp:KeyPressed(IN_MOVELEFT) or lp:KeyPressed(IN_MOVERIGHT)) and commandNumber != 0 then
				local timeSince = curTime - lastSide
				local lastSideMove = side

				if side == 0 and timeSince < sensitivity then
					side = cmd:GetSideMove()
					lastSide = 0
				else
					side = 0
				end

				if lastSideMove == 0 and side == 0 then
					lastSide = curTime
				end
			end

			if forward != 0 then cmd:SetForwardMove(forward) end
			if side != 0 then cmd:SetSideMove(side) end
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

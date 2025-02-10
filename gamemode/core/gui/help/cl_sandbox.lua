local func = function()
	local str = ""

	str = str .. "<giant><b>Sandbox Permissions:</b></giant>"
	str = str .. "\nTool, Physics, and Prop Spawning permissions are all contained to a single tooltrust permission in CombineControl. By default, you will be given untrusted access to these tools which will allow some basic access to the Garry's Mod sandbox. Server administrators have the ability to individually modify a player's tooltrust at any given time, including issuing a tooltrust ban to prevent abuse."

	-- Scoreboard Recognition
	str = str .. "\n\n<giant><b>Scoreboard Recognition:</b></giant>"
	str = str .. "\nPlayers who have either been banned from accessing the sandbox or granted advanced access to be represented with an icon on the scoreboard that all server administrators can see. Additionally, if you have been set to either of these tooltrust groups, you will see the scoreboard badge next to yourself."

	-- Tooltrust Levels
	local function addTooltrustLevel(tier, description)
		str = str .. string.format("\n\t%s - <dark>%s</dark>", tier, description)
	end

	str = str .. "\n\n<giant><b>ToolTrust Permission Levels:</b></giant>"
	addTooltrustLevel("banned", "Restricted access to prevent sandbox interactions.")
	addTooltrustLevel("untrusted", "Default access with minimal tools, decreased entity counts, and non-solid props.")
	addTooltrustLevel("trusted", "Standard access with standard tools, standard entity counts, and solid props.")
	addTooltrustLevel("advanced", "Applied-for access with advanced tools, increased entity counts, and solid props.")

	return str
end

hook.Add("PopulateHelpMenu", "credits", function(panel)
	panel:AddMenu(4, "Sandbox Permissions", func)
end)


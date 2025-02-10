local text = [[<massive><b><c=cc_primary>CombineControl</c></b></massive>
<iset=3><dark>Built for Taco N Banana</dark>

<giant><b>Credits</b></giant>
	TankNut:	<dark>Lead Developer</dark>
	Drewerth:	<dark>Code</dark>
	Hoplite:	<dark>Technical Design</dark>

<giant><b>Special Thanks</b></giant>
	Dave Brown:	<dark>For keeping TnB alive over the years by shooting cops and bots alike</dark>
	Gangleider:	<dark>For taking over the mantle from Dave and getting this project off the ground</dark>

<dark>Based on a gamemode by Disseminate</dark>]]

hook.Add("PopulateHelpMenu", "credits", function(panel)
	panel:AddMenu(1, "Gamemode Credits", text)
end)

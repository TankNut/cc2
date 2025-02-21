GM.FontFace = system.IsOSX() and "ChatFont" or "Myriad Pro"

surface.CreateFont("CombineControl.ChatRadio", {
	font = "Lucida Console",
	--size = 12,
	size = 14,
	weight = 500})

surface.CreateFont("CombineControl.CombineScanner", {
	font = "Lucida Sans Typewriter",
	antialias = false,
	weight = 800,
	size = 18 })

surface.CreateFont("CombineControl.PlayerFont", {
	font = GM.FontFace,
	size = 17,
	weight = 700})

surface.CreateFont("CombineControl.HUDAmmo", {
	font = GM.FontFace,
	size = 50,
	weight = 500})

surface.CreateFont("CombineControl.HUDAmmoSmall", {
	font = GM.FontFace,
	size = 30,
	weight = 500})

surface.CreateFont("CombineControl.Written", {
	font = "Comic Sans MS",
	size = 20,
	weight = 700})

surface.CreateFont("CombineControl.Scope", {
	font = "Courier New",
	size = 28,
	weight = 1000})

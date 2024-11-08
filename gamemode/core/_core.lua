-- Starting off fresh

function GM:IncludeClient(path)
	if CLIENT then
		include(path)
	else
		AddCSLuaFile(path)
	end
end

function GM:IncludeShared(path)
	AddCSLuaFile(path)
	include(path)
end

function GM:IncludeServer(path)
	if SERVER then
		include(path)
	end
end

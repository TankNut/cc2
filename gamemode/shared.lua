-- 08/11/2024: First cc2 commit
-- 21/03/2025: Last remaining cc code stripped out
-- 30/04/2026: Github repository set to public
AddCSLuaFile()
DeriveGamemode("sandbox")

GM.Name = "CombineControl 2"
GM.Author = "TankNut"
GM.Website = "https://github.com/TankNut"
GM.Email = ""

gameevent.Listen("player_disconnect")
gameevent.Listen("player_changename")

function client(path) if CLIENT then return include(path) else AddCSLuaFile(path) end end
function server(path) if SERVER then return include(path) end end
function shared(path) AddCSLuaFile(path) return include(path) end

hook.Remove("PlayerTick", "TickWidgets")
hook.Remove("PostDrawEffects", "RenderWidgets")

shared("loader.lua")

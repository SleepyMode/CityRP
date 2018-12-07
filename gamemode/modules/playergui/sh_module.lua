
if (SERVER) then
	print("[Modules] PlayerGui Modules Loaded")
	AddCSLuaFile("cl_hud.lua")
end

include("cl_hud.lua")

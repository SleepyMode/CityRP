
if (SERVER) then
	AddCSLuaFile("cl_hud.lua")
else
	include("cl_hud.lua")
end
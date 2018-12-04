
if (SERVER) then
	AddCSLuaFile("sh_playercore.lua")
	AddCSLuaFile("cl_playercore.lua")

	include("sh_playercore.lua")
	include("sv_playercore.lua")
else
	include("sh_playercore.lua")
	include("cl_playercore.lua")
end
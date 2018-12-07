
if (SERVER) then
	AddCSLuaFile("cl_dev.lua")
	AddCSLuaFile("sh_dev.lua")

	include("sh_dev.lua")
	include("sv_dev.lua")
else
	include("sh_dev.lua")
end

if (SERVER) then
	AddCSLuaFile("sh_dev.lua")

	include("sh_dev.lua")
	include("sv_dev.lua")
else
	include("sh_dev.lua")
end
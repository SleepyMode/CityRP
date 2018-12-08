
if (SERVER) then
	AddCSLuaFile("cl_animations.lua")
	AddCSLuaFile("sh_animations.lua")

	include("sh_animations.lua")
	include("sv_animations.lua")
else
	include("sh_animations.lua")
	include("cl_animations.lua")
end

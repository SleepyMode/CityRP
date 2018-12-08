if (SERVER) then
	AddCSLuaFile("cl_animations.lua")
	AddCSLuaFile("sh_animations.lua")
	AddCSLuaFile("sv_animations.lua")

	include("cl_animations.lua")
	include("sh_animations.lua")
	include("sv_animations.lua")
end

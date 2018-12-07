
if (SERVER) then
	AddCSLuaFile("cl_chat.lua")
	AddCSLuaFile("sh_chat.lua")

	include("sh_chat.lua")
	include("sv_chat.lua")
else
	include("sh_chat.lua")
	include("cl_chat.lua")
end
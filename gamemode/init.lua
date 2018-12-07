
-- Files which will be sent to the client
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("sh_init.lua")
AddCSLuaFile("sh_playerfunctions.lua")
AddCSLuaFile("cl_hud.lua")

-- Include external serverside libs
include("libs/sv_mysql.lua")

-- Include shared initialization file
include("sh_init.lua")

--[[-------------------------------------------------------------------------
Database

TODO: Perhaps move it to the 'database' module?
---------------------------------------------------------------------------]]

-- Database Data
local DATABASE_HOST = ""	-- The host of the database
local DATABASE_USER = ""	-- The user which has access to the database
local DATABASE_PASS = ""	-- The password for the mentioned user
local DATABASE_NAME = ""	-- The name of the database
local DATABASE_PORT = 3306	-- Port, don't touch unless you know what you're doing

-- InitPostEntity
-- Called after the entities have been initialized
function GM:InitPostEntity()
	-- Connect to the database
	mysql:Connect(DATABASE_HOST, DATABASE_USER, DATABASE_PASS, DATABASE_NAME, DATABASE_PORT)
end

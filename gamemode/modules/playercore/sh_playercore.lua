
local GM = GAMEMODE or GM

-- Inventory Actions
GM.InventoryActions = {}
GM.InventoryActions.ACTION_DROP = 1
GM.InventoryActions.ACTION_TRANSFER = 2
GM.InventoryActions.ACTION_USE = 3
GM.InventoryActions.ACTION_PICKUP = 4
GM.InventoryActions.ACTION_SELL = 5
GM.InventoryActions.ACTION_BUY = 6

--[[-------------------------------------------------------------------------
Teams
---------------------------------------------------------------------------]]
TEAM_CITIZEN = 1
TEAM_POLICE = 2
TEAM_FIREFIGHTER = 3
TEAM_FIRE = 3
TEAM_MEDIC = 4
TEAM_SECRETSERVICE = 5
TEAM_SS = 5
TEAM_SWAT = 6
TEAM_ROADCREW = 7
TEAM_MAYOR = 8

team.SetUp(TEAM_CITIZEN,	"Citizen",			Color(20,	150,	20,		255))
team.SetUp(TEAM_POLICE,		"Police Officer",	Color(50,	50,		200,	255))
team.SetUp(TEAM_FIRE,		"Firefighter",		Color(255,	100,	0,		255))
team.SetUp(TEAM_MEDIC,		"Medic",			Color(255,	0,		150,	255))
team.SetUp(TEAM_SS,			"Secret Service",	Color(0,	180,	250,	255))
team.SetUp(TEAM_SWAT,		"SWAT Officer",		Color(25,	25,		170,	255))
team.SetUp(TEAM_ROADCREW,	"Roadcrew",			Color(160,	70, 	0,		255))
team.SetUp(TEAM_MAYOR,		"Mayor",			Color(150,	20,		20,		0  ))

--[[-------------------------------------------------------------------------
Networked variables
---------------------------------------------------------------------------]]
function PLAYER:HasCharacter()
	return self:GetNW2Bool("cityrp_haschar")
end

function PLAYER:SteamName()
	return self:Name()
end

function PLAYER:FirstName()
	return self:GetNW2String("cityrp_firstname") or "John"
end

function PLAYER:LastName()
	return self:GetNW2String("cityrp_lastname") or "Doe"
end

function PLAYER:GetRPName()
	return self:FirstName() .. self:LastName()
end

function PLAYER:IsFemale()
	return self:GetNW2Bool("cityrp_female")
end

function PLAYER:IsMale()
	return !self:GetNW2Bool("cityrp_female")
end

function PLAYER:GetFace()
	return self:GetNW2Int("cityrp_face")
end

function PLAYER:GetClothing()
	return self:GetNW2Int("cityrp_clothing")
end

function PLAYER:GetPlaytime()
	return self:GetNW2Float("cityrp_playtime")
end

function PLAYER:GetCash()
	return self:GetNW2Int("cityrp_cash")
end

function PLAYER:GetBankMoney()
	return self:GetNW2Int("cityrp_bank")
end

function PLAYER:GetMoney(bBank)
	return bBank and self:GetNW2Int("cityrp_bank") or self:GetNW2Int("cityrp_cash")
end

--[[-------------------------------------------------------------------------
Hooks
---------------------------------------------------------------------------]]
hook.Add("PlayerSpawn", "cityrp.playercore.PlayerSpawn", function(ply)
	if (IsValid(ply)) then
		ply:SetWalkSpeed(135)
		ply:SetRunSpeed(200)
	end
end)
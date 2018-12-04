
local GM = GAMEMODE or GM

util.AddNetworkString("cityrp_svcl_notify")
util.AddNetworkString("cityrp_svcl_opennamedmenu")
util.AddNetworkString("cityrp_svcl_updateinventory")
util.AddNetworkString("cityrp_clsv_inventoryaction")

--[[-------------------------------------------------------------------------
Functions
---------------------------------------------------------------------------]]
function PLAYER:OpenNamedMenu(name)
	net.Start("cityrp_svcl_opennamedmenu")
		net.WriteString(name)
	net.Send(self)
end

function PLAYER:Notify(message)
	net.Start("cityrp_svcl_notify")
		net.WriteString(message)
	net.Send(self)
end

--[[-------------------------------------------------------------------------
Networking Receivers
------------ ---------------------------------------------------------------]]
net.Receive("cityrp_clsv_inventoryaction", function(len, ply)
	if (IsValid(ply) and ply:HasCharacter())
		local action = net.ReadInt()
		local itemData = net.ReadTable()

		if (!ply:Alive()) then
			ply:Notify("You may not peform inventory actions whilst dead!")
		end

		if (action == GM.InventoryActions.ACTION_DROP) then
			if (hook.Run("PlayerCanDropItem", ply, itemData) == false) then
				ply:Notify("You cannot drop this item.")
			elseif (itemData.gov) then
				ply:Notify("You may not drop government-issued items.")
			else
				-- TODO: Drop the item
			end
		elseif (action == GM.InventoryActions.ACTION_TRANSFER) then
			local storage = net.ReadBool()

			if (storage) then
				-- TODO: Run checks & move to storage
			else
				-- 
			end
		elseif (action == GM.InventoryActions.ACTION_USE) then
			if (hook.Run("PlayerCanUseItem", ply, itemData) == false) then
				ply:Notify("You may not use this item.")
			elseif (!ply:OnGround()) then
				ply:Notify("You may not use items when not on the ground")
			else
				-- TODO: Use the item
			end
		elseif (action == GM.InventoryActions.ACTION_PICKUP) then
			if (hook.Run("PlayerCanPickupItem", ply, itemData) == false) then
				ply:Notify("You may not pick up this item.")
			else
				-- TODO: Pickup the item
			end
		elseif (action == GM.InventoryActions.ACTION_SELL) then
			-- TODO
		elseif (action == GM.InventoryActions.ACTION_BUY) then
			-- TODO
		end
	else
		WarningMessage("[CityRP] Received %u bytes in 'cityrp_clsv_inventoryaction' by a non-valid player or character.", len)
	end
end)

--[[-------------------------------------------------------------------------
Hooks
---------------------------------------------------------------------------]]
hook.Add("PlayerInitialSpawn", "cityrp.playercore.PlayerInitialSpawn", function(ply)
	-- Fix conversion from PlayerAuthed.
	-- Will go over the code later on so this won't be needed
	-- but really just had to get this over with quickly.
	local steamid = ply:SteamID()

	local query = mysql:Select("players")
		query:Where("steamid", steamid)
		query:Callback(function(result, status, lastID)
			if (type(result) == "table" and #result > 0) then
				-- Player exists in database
				local updateQuery = mysql:Update("players")
					updateQuery:Where("id", result.id)
					updateQuery:Update("lastjoin", math.floor(os.time()))
					updateQuery:Update("ipaddress", ply:IPAddress())
					updateQuery:Update("steamname", ply:Name())
				updateQuery:Execute()

				if (result.firstname) then
					ply:SetNW2Int("cityrp_id", result.id)
					ply:SetNW2String("cityrp_firstname", result.firstname)
					ply:SetNW2String("cityrp_lastname", result.lastname)
					ply:SetNW2Float("cityrp_playtime", result.playtime)
					ply:SetNW2Bool("cityrp_female", not not result.gender)
					ply:SetNW2Int("cityrp_face", result.face)
					ply:SetNW2Int("cityrp_clothing", result.clothing)

					ply:SetNW2Bool("cityrp_haschar", true)
					
					local inventoryData = {}
					inventoryData["inventory"] = util.JSONToTable(result.inventory)
					inventoryData["storage"] = util.JSONToTable(result.storage)

					net.Start("cityrp_svcl_updateinventory")
						net.WriteTable(inventoryData)
					net.Send(ply)
				else
					ply:SetNW2Bool("cityrp_haschar", false)
					ply:OpenNamedMenu("charcreate")
				end
			else
				local time = math.floor(os.time())

				local insertQuery = mysql:Insert("players")
					insertQuery:Insert("steamid", steamid)
					insertQuery:Insert("steamname", ply:Name())
					insertQuery:Insert("firstname", "")
					insertQuery:Insert("lastname", "")
					insertQuery:Insert("ipaddress", ply:IPAddress())
					insertQuery:Insert("firstjoin", time)
					insertQuery:Insert("lastjoin", time)
					insertQuery:Insert("playtime", 0)
					insertQuery:Insert("gender", 0)
					insertQuery:Insert("face", 0)
					insertQuery:Insert("clothing", 0)
					insertQuery:Insert("inventory", "")
					insertQuery:Insert("storage", "")
				insertQuery:Execute()

				-- Open the character creation menu
				ply:OpenNamedMenu("charcreate")

				ply:SetNW2Bool("cityrp_haschar", false)
			end
		end)
	query:Execute()
end)

local GM = GAMEMODE or GM

util.AddNetworkString("cityrp_svcl_notify")
util.AddNetworkString("cityrp_svcl_opencharcreation")
util.AddNetworkString("cityrp_svcl_updateinventory")
util.AddNetworkString("cityrp_clsv_inventoryaction")

--[[-------------------------------------------------------------------------
Functions
---------------------------------------------------------------------------]]
function PLAYER:OpenCreationMenu()
	net.Start("cityrp_svcl_opencharcreation")
	net.Send(self)
end

function PLAYER:Notify(message)
	net.Start("cityrp_svcl_notify")
		net.WriteString(message)
	net.Send(self)
end

function PLAYER:GiveItem(id, quantity, data)
	quantity = quantity or 1

	self.rpInventoryData = self.rpInventoryData[id] or {}

	if (GM:GetItemData(id, "stackable")) then
		local quantityLeft = quantity
		local stackSize = GM:GetItemData(id, "stacksize")

		if (#self.rpInventoryData[id] > 0) then
			for k, v in pairs(self.rpInventoryData[id]) do
				if (v.quantity == stackSize) then
					continue
				else
					local diff = stackSize - v.quantity
					quantityLeft = quantityLeft - diff

					v.quantity = stackSize
				end
			end
		end

		if (quantityLeft > 0) then
			for i=1, quantityLeft/stackSize do
				table.insert(self.rpInventoryData[id], {
					quantity = stackSize,
					data = data
				})
			end

			local remaining = quantityLeft % stackSize

			if (remaining != 0) then
				table.insert(self.rpInventoryData[id], {
					quantity = remaining,
					data = data
				})
			end
		end
	else
		for i=1, quantity do
			table.insert(self.rpInventoryData[id], {
				data = data
			})
		end
	end

	ply:UpdateInventory()
end

function PLAYER:HasItem(id)
	return (type(self.rpInventoryData[id]) == "table" and #self.rpInventoryData[id] > 0)
end

function PLAYER:CountItems(id)
	return (type(self.rpInventoryData[id]) == "table") and #self.rpInventoryData[id] or 0
end

function PLAYER:GetItems(id)
	return self.rpInventoryData[id]
end

function PLAYER:TakeItem(id, quantity)
	quantity = quantity or 1

	if (self:CountItems(id) <= quantity) then
		self.rpInventoryData[id] = {}
	else
		if (GM:GetItemData(id, "stackable")) then
			local quantityLeft = quantity
			local stackSize = GM:GetItemData(id, "stacksize")

			if (#self.rpInventoryData[id] > 0) then
				ArrayRemove(rp.inventoryData[id], function(t, i, j)
					local v = t[i]

					return quantityLeft < v.quantity 
				end)
			end
		else
			for i=1, quantity do
				local count = #self.rpInventoryData[id]

				if (count > 0) then
					self.rpInventoryData[id][count] = nil
				else
					break
				end
			end
		end
	end

	ply:UpdateInventory()
end

function PLAYER:UpdateInventory()
	net.Start("cityrp_svcl_updateinventory")
		net.WriteTable(self.rpInventoryData)
	net.Send(self)
end


--[[-------------------------------------------------------------------------
Networking Receivers
------------ ---------------------------------------------------------------]]
net.Receive("cityrp_clsv_inventoryaction", function(len, ply)
	if (IsValid(ply) and ply:HasCharacter()) then
		local action = net.ReadInt()

		if (!ply:Alive()) then
			ply:Notify("You may not peform inventory actions whilst dead!")
			return
		elseif (!ply:OnGround() and !ply:IsFlagSet(FL_INWATER)) then
			ply:Notify("You may not manipulate items while airborne.")
		end

		if (action == GM.InventoryActions.ACTION_DROP) then
			local itemID = net.ReadInt()
			local localID = net.ReadInt() -- The number of the item in the inventory
			local itemData = net.ReadTable()

			if (hook.Run("PlayerCanDropItem", ply, itemData) == false) then
				ply:Notify("You cannot drop this item.")
			elseif (itemData.gov) then
				ply:Notify("You may not drop government-issued items.")
			else
				ply.rpInventoryData[itemID][localID] = nil
				ply:UpdateInventory()
			end
		elseif (action == GM.InventoryActions.ACTION_TRANSFER) then
			local itemID = net.ReadInt()
			local itemData = net.ReadTable()
			local storage = net.ReadBool()

			if (storage) then
				-- TODO: Run checks & move to storage
			else
				-- Disallow, for now.
				ply:Notify("This action is not currently supported.")
			end
		elseif (action == GM.InventoryActions.ACTION_USE) then
			local itemID = net.ReadInt()
			local itemData = net.ReadTable()

			if (hook.Run("PlayerCanUseItem", ply, itemData) == false) then
				ply:Notify("You may not use this item.")
			else
				-- TODO: Use the item
				if (GM:GetItemData(itemID, "usable")) then
					ITEM_DATABASE[itemID]:OnUse(ply, itemData)

					if (GM:GetItemData(itemID, "onetime")) then
						ply:TakeItem(itemID, 1)
					end
				else
					--ply:Notify("This item is not usable.")
				end
			end
--		elseif (action == GM.InventoryActions.ACTION_PICKUP) then
--			local ent = net.ReadEntity()
--
--			if (hook.Run("PlayerCanPickupItem", ply, ent) == false) then
--				ply:Notify("You may not pick up this item.")
--			else
--				ply:GiveItem(ent.rpItemID, 1, ent.rpItemData)
--			end
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
					ply:SetNW2Int("cityrp_cash", result.cash)
					ply:SetNW2Int("cityrp_bank", result.bank)

					ply:SetNW2Bool("cityrp_haschar", true)
					
					local inventoryData = {}
					inventoryData["inventory"] = util.JSONToTable(result.inventory)
					inventoryData["storage"] = util.JSONToTable(result.storage)

					ply.rpInventoryData = inventoryData

					ply:UpdateInventory()
				else
					ply:SetNW2Bool("cityrp_haschar", false)
					ply:OpenCreationMenu()
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
					insertQuery:Insert("cash", 10000) -- Default amount of money for now, I guess.
					insertQuery:Insert("bank", 25000) -- ""
				insertQuery:Execute()

				-- Open the character creation menu
				ply:OpenCreationMenu()

				ply:SetNW2Bool("cityrp_haschar", false)
			end
		end)
	query:Execute()
end)

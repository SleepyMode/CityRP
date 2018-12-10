
SWEP.PrintName		= "CityRP Weapon"
SWEP.Author			= "SleepyMode"

-- The item ID of the magazine using it
-- -1 means it takes no magazine
-- aka infinite ammo
SWEP.MagItemID		= -1

-- The local item ID of the weapon
-- this is automatically set by
-- the gamemode
SWEP.ItemID			= -1

--[[-------------------------------------------------------------------------
	Name: SWEP:PrimaryAttack()
	Desc: +attack1 has been pressed
---------------------------------------------------------------------------]]
function SWEP:PrimaryAttack()
end

--[[---------------------------------------------------------
	Name: SWEP:SecondaryAttack()
	Desc: +attack2 has been pressed
-----------------------------------------------------------]]
function SWEP:SecondaryAttack()
end

--[[---------------------------------------------------------
	Name: SWEP:CanPrimaryAttack()
	Desc: Helper function for checking for no ammo
-----------------------------------------------------------]]
function SWEP:CanPrimaryAttack()
end

--[[---------------------------------------------------------
	Name: SWEP:CanSecondaryAttack()
	Desc:
-----------------------------------------------------------]]
function SWEP:CanSecondaryAttack()
end

--[[---------------------------------------------------------
	Name: SWEP:Reload()
	Desc: Reload is being pressed
-----------------------------------------------------------]]
function SWEP:Reload()
end

--[[---------------------------------------------------------
	Name: SWEP:TakePrimaryAmmo()
	Desc: A convenience function to remove ammo
-----------------------------------------------------------]]
function SWEP:TakeAmmo(count)
end

--[[---------------------------------------------------------
	Name: Ammo1
	Desc: Returns how much of ammo1 the player has
-----------------------------------------------------------]]
function SWEP:Ammo()
	local count = 0
	local invTable = SERVER and self.Owner.rpInventoryData or GAMEMODE.Inventory

	if (type(invTable) == "table" and type(invTable[self.MagItemID]) == "table") then
		for k, v in pairs(invTable[self.MagItemID]) do
			if (type(v.data) == "table" and type(v.data.ammoCount) == "number") then
				count = count + v.data.ammoCount
			end
		end
	end

	return count
end
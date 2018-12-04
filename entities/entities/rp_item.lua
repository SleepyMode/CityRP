
-- Sends the file to the client
AddCSLuaFile()

ENT.Base = "base_entity"
ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_OPAQUE

if (SERVER) then
	function ENT:SetItem(id, data)
		local itemdata = ITEM_DATABASE[id]

		self:SetModel(itemdata.model)

		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)

		self.rpItemID = id
		self.rpItemData = data
	end

	function ENT:Use(activator, caller, useType, value)
		if (IsValid(caller) and caller:IsPlayer()) then
			if (hook.Run("PlayerCanPickupItem", ply, self) == false) then
				ply:Notify("You may not pick up this item.")
			else
				ply:GiveItem(self.rpItemID, 1, self.rpItemData)
				self:Remove()
			end
		end
	end
else
	function ENT:Draw()
		self:DrawModel()
	end
end
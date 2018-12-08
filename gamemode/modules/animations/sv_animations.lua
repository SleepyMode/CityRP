
local GM = GAMEMODE or GM

util.AddNetworkString("cityrp_anim_start")
util.AddNetworkString("cityrp_anim_stop")

--[[-------------------------------------------------------------------------
Functions
---------------------------------------------------------------------------]]
function PLAYER:Animate(anim, time)
	if (GM.AnimationOffsets[anim]) then
		time = time or 0

		self:StopAnimating()

		net.Start("cityrp_anim_start")
			net.WriteEntity(self)
			net.WriteString(anim)
			net.WriteInt(time, 8)
		net.Broadcast()

		self.rpCurrentAnim = anim
		self.rpAnimTime = time
	else
		WarningMessage("[CityRP] Attempted to invoke unknown animation \"%s\"!", anim)
	end
end

function PLAYER:StopAnimating()
	net.Start("cityrp_anim_stop")
		net.WriteEntity(self)
	net.Broadcast()

	self.rpCurrentAnim = nil
	self.rpAnimTime = nil
end

--[[-------------------------------------------------------------------------
Hooks
---------------------------------------------------------------------------]]
hook.Add("PlayerInitialSpawn", "cityrp.animations.PlayerInitialSpawn", function(ply)
	for k, v in pairs(player.GetAll()) do
		if (v.rpCurrentAnim) then
			net.Start("cityrp_anim_start")
				net.WriteEntity(v)
				net.WriteString(v.rpCurrentAnim)
				net.WriteInt(v.rpAnimTime or 0, 8)
			net.Send(ply)
		end
	end
end)
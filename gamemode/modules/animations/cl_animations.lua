
local GM = GAMEMODE or GM


--[[-------------------------------------------------------------------------
Networking Receivers
---------------------------------------------------------------------------]]
net.Receive("cityrp_anim_start", function(len)
	local player = net.ReadEntity()

	if (IsValid(player) and player:HasCharacter()) then
		player.rpAnim = player.rpAnim or {}

		local anim = net.ReadString()
		local time = net.ReadInt(8)

		if (GM.AnimationOffsets[anim]) then
			for k, v in pairs(GM.AnimationOffsets[anim]) do
				player.rpAnim[k] = v
			end
		end
	end
end)

net.Receive("cityrp_anim_stop", function(len)
	local player = net.ReadEntity()

	if (IsValid(player) and player:HasCharacter()) then
		for k, v in pairs(player.rpAnim) do
			player:ManipulateBoneAngles(player:LookupBone(k), Angle(0, 0, 0))
		end

		player.rpAnim = nil
	end
end)

--[[-------------------------------------------------------------------------
Hooks
---------------------------------------------------------------------------]]
hook.Add("Think", "cityrp.animations.Think", function()
	for _, player in pairs(player.GetAll()) do
		if (player.rpAnim) then
			for k, v in pairs(player.rpAnim) do
				player:ManipulateBoneAngles(player:LookupBone(k), v)
			end
		end
	end
end)
--[[-------------------------------------------------------------------------
PlayerSpawn
---------------------------------------------------------------------------]]


hook.Add( "PlayerSpawn", "PlayerSpawn", function( ply )

    timer.Simple(0.1, function()
        if !IsValid(ply) then return end

        ply:SetWalkSpeed(135)
        ply:SetRunSpeed(200)

    end)
end)

include("sh_init.lua")

hook.Add( "HUDShouldDraw", "Hide_Hud", function( name )
if ( name == "CHudHealth" or name == "CHudBattery" ) then
return false
end

end )

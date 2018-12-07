hook.Add( "HUDShouldDraw", "hide hud", function( name )
if ( name == "CHudHealth" or name == "CHudBattery" ) then
return false
end

end )

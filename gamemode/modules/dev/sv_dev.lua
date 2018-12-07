
-- People who are authorized to join during development
local authorized = {
	-- Community Founder
	["76561198060659964"] = true, -- zoephix

	-- Developers
	["76561198018490643"] = true, -- SleepyMode

	-- Other people
	["76561198078156793"] = true -- Zhaloi
}

hook.Add("CheckPassword", "cityrp.dev.CheckPassword", function(steamid64, ipaddress, svPassword, clPassword, name)
	if (!authorized[steamid64]) then
		return false, "You are not authorized to join the server during development periods."
	end
end)
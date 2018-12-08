
local GM = GAMEMODE or GM

GM.AnimationOffsets = {}

function GM:RegisterAnimationOffset(name, data)
	GM.AnimationOffsets[name] = data
end
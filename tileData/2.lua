local name = "rock"
local imgString = "tileData/tileGraphics/tile_002.png"
local w = 32
local h = 32
local props = {
	solid = false,
	show = true,
	animated = false,
	text = nil,
	action = nil,
	quadX = 0,
	quadY = 0,
	group = 0,
	numFrames = 1,
	fps = 0,
	scaleX = 1,
	scaleY = 1,
	rotation = 0,
	collisionX_off = 0,
	collisionY_off = 0,
	other = nil
}

return {name = name, img = imgString, width = w, height = h, prop = props, z = 25}
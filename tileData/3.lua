local name = "posTester"
local imgString = "tileData/tileGraphics/tile_003.png"
local w = 32
local h = 32
local z = 10
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
	scaleX = 2,
	scaleY = 2,
	rotation = 0,
	collisionX_off = 0,
	collisionY_off = 0,
	other = nil
}

return {name = name, img = imgString, width = w, height = h, prop = props, z = z}
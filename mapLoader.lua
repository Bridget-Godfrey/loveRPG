-- mapLoader.lua


TILE_SIZE = 32





MAP = {}
mapLoader = {}


local flipProps = {
	animated = false,
	useTileColor = false,
	flipH = false,
	flipV = true,
	rotation = nil,
	bit6 = false

}
local verticalFlip = {
	animated = false,
	useTileColor = false,
	flipH = true,
	flipV = false,
	rotation = nil,
	bit6 = false

}
local rot1 = {
	animated = false,
	useTileColor = false,
	flipH = false,
	flipV = false,
	rotation = 90,
	bit6 = false

}
local rot2 = {
	animated = false,
	useTileColor = false,
	flipH = false,
	flipV = false,
	rotation = 180,
	bit6 = false

}




mapLoader.loadMap = function (mapname)
	return {
	{1, 1*TILE_SIZE, 2*TILE_SIZE, nil},
	{2, 10*TILE_SIZE, 8*TILE_SIZE, nil},
	{3, 15*TILE_SIZE, 15*TILE_SIZE, rot1},
	{3, 22*TILE_SIZE, 15*TILE_SIZE, rot2},
	{4, 5*TILE_SIZE, 15*TILE_SIZE, nil},
	{5, 5*TILE_SIZE, 10*TILE_SIZE, nil},
	{6, 6*TILE_SIZE, 10*TILE_SIZE, nil},
	{7, 7*TILE_SIZE, 10*TILE_SIZE, nil},
	{8, 8*TILE_SIZE, 10*TILE_SIZE, nil},
	{9, 9*TILE_SIZE, 10*TILE_SIZE, nil},
	{1, 1*TILE_SIZE, 2*TILE_SIZE, nil},
	{11, 10*TILE_SIZE, 10*TILE_SIZE, nil},
	{11, 12*TILE_SIZE, 10*TILE_SIZE, verticalFlip},
	{12, 10*TILE_SIZE, 12*TILE_SIZE, verticalFlip},
	{12, 12*TILE_SIZE, 12*TILE_SIZE, nil},}

end
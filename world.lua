-- world.lua
-- The world checks for tile collisions and answers questions about what exists and where

require "mapLoader"
require "tile"
require "tileLoader"

function loadTiles(cycle)
	return tl_loadTiles(cycle)
end


world = {}
world.map = {}
world.mapSize = 0
world.buildMap = {}
world.drawAfter = {}
world.loadMap = function ( mapNumber )
	world.buildMap = mapLoader.loadMap(mapNumber)
	world.mapSize = table.getn(world.buildMap)
end



function convertWorldToTile(worldX, worldY)
	return math.floor(worldX/TILE_SIZE), math.floor(worldY/TILE_SIZE)
end


world.drawMap = function ()
	for i = 1, world.mapSize do
	-- if world.map[i].y < yPos then --player.colY
		world.map[i].draw() 
	end
end



world.drawUntilY = function (yPos)
		world.drawAfter = {}
		for i = 1, world.mapSize do
			if world.map[i].y < yPos then --player.colY
				world.map[i].draw() 
			else 
				table.insert(world.drawAfter, i)
			end
		end
		
end


world.drawAfterY = function()
	-- player.draw()
	for i = 1, table.getn(world.drawAfter) do
		world.map[world.drawAfter[i]].draw()
	end
end

world.loadTileInstances_ls = function (cycle)
	if cycle == 0 then
		return world.mapSize
	elseif cycle <= world.mapSize then
		table.insert(world.map, newTileInstance(world.buildMap[cycle][1], world.buildMap[cycle][2], world.buildMap[cycle][3], world.buildMap[cycle][4]))
		print ("created instance of " .. TILES[world.buildMap[cycle][1]].name)
	else
		--doNothing
	end

end
world.endLoad = function ()
	world.mapSize = table.getn(world.map)
end

world.checkCollision = function (x, y, w, h)
end


world.quickCheckCollision = function (x, y, w, h)
end

world.slowCheckCollision = function (x, y, w, h, startAt)
	local stAt = startAt or 1
	for i = stAt, world.mapSize do
		if checkTICollision(world.map[i], x, y, w, h) then
			return i
		end
	end
	return false
end

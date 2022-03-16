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
world.xy_map = {}
world.mapSize = 0
world.width = 1080 
world.height = 720
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
		for x = 0, math.floor(world.width/TILE_SIZE)+1 do
			world.xy_map[x] = {}	
			for y = 0, math.floor(world.height/TILE_SIZE)+1 do
				world.xy_map[x][y] = {}	
			end
		end
		return world.mapSize
	elseif cycle <= world.mapSize then
		local inst = newTileInstance(world.buildMap[cycle][1], world.buildMap[cycle][2], world.buildMap[cycle][3], world.buildMap[cycle][4])
		table.insert(world.map, inst)
		table.insert(world.xy_map[math.floor(world.buildMap[cycle][2]/TILE_SIZE)][math.floor(world.buildMap[cycle][3]/TILE_SIZE)], inst)

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
	local mX, mY = convertWorldToTile(x, y)
	local mX2 = math.min(mX+2, math.floor(world.width/TILE_SIZE))
	 	   mX = math.max(mX-2, 0)
	local mY2 = math.min(mY+2, math.floor(world.height/TILE_SIZE))
	       mY = math.max(mY-2, 0)
	for mtx = mX, mX2 do
		for mty = mY, mY2 do
			for i = 1, table.getn(world.xy_map[mtx][mty]) do
				if checkTICollision(world.xy_map[mtx][mty][i], x, y, w, h) then
					return true
				end
			end
		end
	end
	return false
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

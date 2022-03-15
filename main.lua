-- main.lua
-- 2021 Bridget Godfrey
love.graphics.setDefaultFilter( "linear", "nearest", 1 )
--DEPENDANCIES
require "tile"
require "tileLoader"
require "actor"
require "player"
textbox = require "textbox"
--CONSTANTS
VIRTUAL_SCREEN_WIDTH = 1080
VIRTUAL_SCREEN_HEIGHT = 720
LOADING_BAR_WIDTH = VIRTUAL_SCREEN_WIDTH/2
LOADING_BAR_HEIGHT = 80
LOADING_BAR_X = VIRTUAL_SCREEN_WIDTH/4
LOADING_BAR_Y = VIRTUAL_SCREEN_HEIGHT/4
TILE_SIZE = 32
--GLOBALS
gameMode = -2
debugMode = true

--gameMode = -2 Error, -1 Loading, 0 Gameplay, 0.5 textbox, 1 startingMenu , 2 gameOver


loadingScreen = {}


player = nil
player = newPlayer(32, 32*3, 1, nil, 0)
player.initKPFunctions()


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
local tempMap = {
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
	{12, 12*TILE_SIZE, 12*TILE_SIZE, nil},


}

MAP = {}
mapSize = table.getn(tempMap)
function loadTileInstances(cycle)
	if cycle == 0 then
		return mapSize -- eventually get a MAP and a MAP size
	elseif cycle <= mapSize then
		table.insert(MAP, newTileInstance(tempMap[cycle][1], tempMap[cycle][2], tempMap[cycle][3], tempMap[cycle][4]))
		print ("created instance of " .. TILES[tempMap[cycle][1]].name)
	else
		--doNothing
	end

end





function love.load()
	-------------------BEFORE LOADING SCREEN--------------------------
	love.graphics.setDefaultFilter( "linear", "nearest", 1 )

	-------------------SETUP LOADING SCREEN---------------------------
	gameMode = -1
	EXTRA_LOAD_CYCLES = 2

	loadingScreen.flavorText = ""
	loadingScreen.percentageComplete = 0
	loadingScreen.onCycle = 0
	loadingScreen.totalCycles = 10 + EXTRA_LOAD_CYCLES
	loadingScreen.update = function(dt)
		if loadingScreen.onCycle == 0 then
			--stuff to do once at start

				loadingScreen.totalCycles = math.max(loadingScreen.totalCycles, loadTiles(0))
				loadingScreen.totalCycles = math.max(loadingScreen.totalCycles, loadTileInstances(0))
				loadingScreen.totalCycles = loadingScreen.totalCycles + EXTRA_LOAD_CYCLES
				print("number of cycles = " .. loadingScreen.totalCycles)
		elseif loadingScreen.onCycle == 1 then
			loadSaveFile()
		elseif loadingScreen.onCycle == 2 then
			loadKeydata ()
			
		elseif loadingScreen.onCycle >= loadingScreen.totalCycles+EXTRA_LOAD_CYCLES then 
			gameMode = 0
			--stuff to do once at end
		else
			--stub when we have stuff to load it should go in here as functions like loadGraphics(loadingScreen.onCycle)
			local cycle = loadingScreen.onCycle-EXTRA_LOAD_CYCLES-1
			print("on cycle " .. cycle .. ", " .. loadingScreen.onCycle)
			loadTiles(cycle)
			loadTileInstances(cycle)
		end
		loadingScreen.percentageComplete = loadingScreen.onCycle / loadingScreen.totalCycles
		loadingScreen.onCycle = loadingScreen.onCycle + 1
	end
	loadingScreen.draw = function ()
		love.graphics.setColor(1, 1, 1)
		love.graphics.print("LOADING", VIRTUAL_SCREEN_WIDTH/2, VIRTUAL_SCREEN_HEIGHT/2)
		-- local sz = math.max(table.getn(smallGraphics), table.getn(backdropNames))
		love.graphics.rectangle("fill", LOADING_BAR_X, LOADING_BAR_Y, LOADING_BAR_WIDTH*(loadingScreen.percentageComplete), LOADING_BAR_HEIGHT)
		love.graphics.rectangle("line", LOADING_BAR_X, LOADING_BAR_Y, LOADING_BAR_WIDTH, LOADING_BAR_HEIGHT)
	end
end


function love.draw()
	if gameMode == 0 or gameMode== 0.5 then
		if debugMode then
			local px, py, pw, ph = player.getBounds()
			love.graphics.setColor(1, 1, 1, 0.8)
			love.graphics.rectangle("fill", px, py, pw, ph)
			love.graphics.setColor(1, 1, 1, 1)
		end
		local drawAfter = {}
		for i = 1, table.getn(MAP) do
			if MAP[i].y < player.colY then 
				MAP[i].draw() 
			else 
				table.insert(drawAfter, i)
			end
		end
		player.draw()
		for i = 1, table.getn(drawAfter) do
			MAP[drawAfter[i]].draw()
		end
		if debugMode then
			love.graphics.print(love.timer.getFPS(), VIRTUAL_SCREEN_WIDTH*.8, VIRTUAL_SCREEN_HEIGHT*.05, 0, 2, 2)
			love.graphics.setColor(1, 1, 1, 0.3)
			for i= 0, 1080, 32 do
				love.graphics.line(i, 0, i, 720)
			end
			for i= 0, 720, 32 do
				love.graphics.line(0, i, 1080, i)
			end
		end
		if gameMode == 0.5 then
			textbox.draw()
		end
	elseif gameMode == -1 then
		   loadingScreen.draw()
	elseif gameMode == 1 then
		   --draw title screen
	end
end


function love.update(dt)
	if gameMode == 0 then
		player.update(dt)
		local moveP = true
		local firstCol = -1
		local px, py, pw, ph = player.getBounds()
		for i = 1, table.getn(MAP) do
			if checkTICollision(MAP[i], px, py, pw, ph) then
				-- print("collision with " .. TILES[MAP[i].id].name .."")
				moveP = false
				firstCol = i
				if i >= 2 then firstCol = i-1 end
				break
			end
		end
		if moveP then 
			player.move()
		else
			movePX = true
			for i = firstCol, table.getn(MAP) do
				-- print("checking " .. TILES[MAP[i].id].name)
				if checkTICollision(MAP[i], px, player.colY, pw, ph) then
					-- print("collision with " .. TILES[MAP[i].id].name .." (X)")
					movePX = false
					break
				end
			end

			if movePX == false then
			    movePY = true 
				for i = firstCol, table.getn(MAP) do
					if checkTICollision(MAP[i], player.colX+1, py, pw-1, ph) then
						-- print("collision with " .. TILES[MAP[i].id].name .." (Y)")
						movePY= false
						break
					end
				end
				if movePY then
					player.move("Y") 
				else
					--stuck?
				end
			else
				player.move("X")
			end

		end
		
		 
	elseif gameMode == 0.5 then
		textbox.update(dt)
	elseif gameMode == -1 then
		   loadingScreen.update()
	elseif gameMode == 1 then
		   --update title screen
	end
end

function love.keypressed(k)
	--GLOBAL KEY PRESSES
	if k == "q" then
		debugMode = not debugMode
	end
	if k == "escape" then
		love.event.quit()
	end


	--GAMEMODE SPECIFIC
	if gameMode == 0.5 then
		textbox.keyPressed(k)
	elseif gameMode == 0 then
		if k == "e" then
			textbox.addToQueue("TESTING...")
			textbox.addToQueue("testing...")
			textbox.addToQueue("123")
			textbox.start()
		end
		player.keyPressed(k)
	end


	
end

function love.keyreleased(k)
	if gameMode == 0.5 then
		textbox.keyReleased(k)
	else
		player.keyReleased(k)
	end

end







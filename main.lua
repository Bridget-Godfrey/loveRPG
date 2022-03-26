-- main.lua
-- 2021 Bridget Godfrey
love.graphics.setDefaultFilter( "linear", "nearest", 1 )
--DEPENDANCIES
require "world"
require "actor"
require "player"
textbox = require "textbox"
require "spritesheet"
--CONSTANTS
VIRTUAL_SCREEN_WIDTH = 1080
VIRTUAL_SCREEN_HEIGHT = 720
LOADING_BAR_WIDTH = VIRTUAL_SCREEN_WIDTH/2
LOADING_BAR_HEIGHT = 80
LOADING_BAR_X = VIRTUAL_SCREEN_WIDTH/4
LOADING_BAR_Y = VIRTUAL_SCREEN_HEIGHT/4

--GLOBALS
gameMode = -2
debugMode = true

--gameMode = -2 Error, -1 Loading, 0 Gameplay, 0.5 textbox, 1 startingMenu , 2 gameOver


loadingScreen = {}


player = nil
player = newPlayer(32, 32*3, 1, nil, 0)
player.initKPFunctions()

lagSwitch = false
lagTHETA = 0
lagCircleNum = 300 --4000
lagCirclePos = {}

testSS = newSpritesheet("assets/testSpritesheet.png", 32, 32, 0, 0)

lagNUM = math.pi
lagNUM2 = 20
function love.load()
	-------------------BEFORE LOADING SCREEN--------------------------
	love.graphics.setDefaultFilter( "linear", "nearest", 1 )
	world.loadMap(0)
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
				loadingScreen.totalCycles = math.max(loadingScreen.totalCycles, world.loadTileInstances_ls(0))
				loadingScreen.totalCycles = loadingScreen.totalCycles + EXTRA_LOAD_CYCLES
				print("number of cycles = " .. loadingScreen.totalCycles)
		elseif loadingScreen.onCycle == 1 then
			loadSaveFile()
		elseif loadingScreen.onCycle == 2 then
			loadKeydata ()
			
		elseif loadingScreen.onCycle >= loadingScreen.totalCycles+EXTRA_LOAD_CYCLES then 
			world.endLoad()
			gameMode = 0
			--stuff to do once at end
		else
			--stub when we have stuff to load it should go in here as functions like loadGraphics(loadingScreen.onCycle)
			local cycle = loadingScreen.onCycle-EXTRA_LOAD_CYCLES-1
			print("on cycle " .. cycle .. ", " .. loadingScreen.onCycle)
			loadTiles(cycle)
			world.loadTileInstances_ls(cycle)
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
		world.drawUntilY(player.colY)
		player.draw()
		world.drawAfterY()
		if debugMode then
			love.graphics.print(love.timer.getFPS(), VIRTUAL_SCREEN_WIDTH*.8, VIRTUAL_SCREEN_HEIGHT*.05, 0, 2, 2)
			love.graphics.setColor(1, 1, 1, 0.3)
			for i= 0, 1080, 32 do
				love.graphics.line(i, 0, i, 720)
			end
			for i= 0, 720, 32 do
				love.graphics.line(0, i, 1080, i)
			end
			love.graphics.setColor(1, 1, 1, 1)
			local flg = {}
			flg.flipH = true
			flg.flipV = false
			testSS.drawSprite(1, 200, 200, 1,  1, 0, flg)
			testSS.drawSprite(2, 232, 200)
			testSS.drawSprite(3, 298, 200)
			testSS.drawSprite(4, 200, 300)
			testSS.drawSprite(5, 232, 300)
			testSS.drawSprite(6, 298, 300)
		end
		if gameMode == 0.5 then
			textbox.draw()
		end
	elseif gameMode == -1 then
		   loadingScreen.draw()
	elseif gameMode == 1 then
		   --draw title screen
	end

	if lagSwitch then
		local slowBoi = {}
		for i = 1, lagCircleNum do
				if i%10 ~= 0 then
					love.graphics.setColor(0, 0, 1, 0.8)
					love.graphics.circle("fill", lagCirclePos[i][1], lagCirclePos[i][2], 5, 100)
				else
					table.insert(slowBoi, i)
				end
				
				

				-- table.insert(lagCirclePos, {200+math.sin(theta), 60+math.cos(theta)})
			end
			local nextNum = 1
		for i = 1, lagCircleNum do
			love.graphics.setColor(1, 0.25, 0, 0.8)
			if i == slowBoi[nextNum] then
				nextNum = nextNum + 1
				love.graphics.circle("fill", lagCirclePos[i][1], lagCirclePos[i][2], 5, 100)
			end
		end
		love.graphics.setColor(1, 1, 1, 1)			
	end
end


function love.update(dt)

	if lagSwitch then
		local radius = 250
		lagCirclePos = {}
		lagTHETA = lagTHETA + 0.0025

		-- for i = 1, lagCircleNum/2 do
		-- 	table.insert(lagCirclePos, {i*20 + 60, (100+math.sin(i/(lagCircleNum/100))*50) })
		-- end


		for i = 1, lagCircleNum/2 do
				local theta = ((i*((2*math.pi)/(lagCircleNum/2))) + lagTHETA) %(2*math.pi)
				table.insert(lagCirclePos, {(1080/2)+math.sin(theta)*(radius + ((radius/10)*math.sin(theta*lagNUM2))), ((720/2)+math.cos(theta)* (radius + ((radius/10)*math.sin(theta*lagNUM2)))) })
			end


		for i = 1, lagCircleNum/2 do
			local theta = ((i*((2*math.pi)/(lagCircleNum/2))) + lagTHETA  ) %(2*math.pi)
			table.insert(lagCirclePos, {(1080/2)+math.sin(theta)*(radius + ((radius/10)*math.sin((theta + 3.6415926535898)*lagNUM2))), ((720/2)+math.cos(theta)* (radius + ((radius/10)*math.sin((theta + 3.6415926535898)*lagNUM2)))) })
		end
		-- for i = 1, lagCircleNum/4 do
		-- 	local theta = ((i*((2*math.pi)/(lagCircleNum/4))) + lagTHETA  ) %(2*math.pi)
		-- 	table.insert(lagCirclePos, {(1080/2)+math.sin(theta)*(radius + ((radius/10)*math.sin((theta + 3.8415926535898)*lagNUM2))), ((720/2)+math.cos(theta)* (radius + ((radius/10)*math.sin((theta + 3.8415926535898)*lagNUM2)))) })
		-- end
		-- for i = 1, lagCircleNum/4 do
		-- 	local theta = ((i*((2*math.pi)/(lagCircleNum/4))) + lagTHETA  ) %(2*math.pi)
		-- 	table.insert(lagCirclePos, {(1080/2)+math.sin(theta)*(radius + ((radius/10)*math.sin((theta + 3.9415926535898)*lagNUM2))), ((720/2)+math.cos(theta)* (radius + ((radius/10)*math.sin((theta + 3.9415926535898)*lagNUM2)))) })
		-- end
		for i = 1, lagCircleNum*4 do
			local theta = ((i*((2*math.pi)/(lagCircleNum/4))) + lagTHETA  ) %(2*math.pi)
			table.insert(lagCirclePos, {(1080/2)+math.sin(theta)*(radius + ((radius/10)*math.sin((theta + 3.9415926535898)*lagNUM2))), ((720/2)+math.cos(theta)* (radius + ((radius/10)*math.sin((theta + 3.9415926535898)*lagNUM2)))) })
		end
	end

	if gameMode == 0 then
		player.update(dt)
		
		-- 	movePX = true
		-- 	for i = firstCol, table.getn(MAP) do
		-- 		-- print("checking " .. TILES[MAP[i].id].name)
		-- 		if checkTICollision(MAP[i], px, player.colY, pw, ph) then
		-- 			-- print("collision with " .. TILES[MAP[i].id].name .." (X)")
		-- 			movePX = false
		-- 			break
		-- 		end
		-- 	end

		-- 	if movePX == false then
		-- 	    movePY = true 
		-- 		for i = firstCol, table.getn(MAP) do
		-- 			if checkTICollision(MAP[i], player.colX+1, py, pw-1, ph) then
		-- 				-- print("collision with " .. TILES[MAP[i].id].name .." (Y)")
		-- 				movePY= false
		-- 				break
		-- 			end
		-- 		end
		-- 		if movePY then
		-- 			player.move("Y") 
		-- 		else
		-- 			--stuck?
		-- 		end
		-- 	else
		-- 		player.move("X")
		-- 	end

		-- end
		
		 
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
	if lagSwitch then 
		if k == "-" then
			lagCircleNum = lagCircleNum - 200
			print(lagCircleNum)
		end
		if k == "=" then
			lagCircleNum = lagCircleNum + 200
			print(lagCircleNum)
		end
	end
	if k == "9" then
		lagSwitch = not lagSwitch
		if lagSwitch then
			lagCirclePos = {}
			for i = 1, lagCircleNum do
				theta = (i/lagCircleNum)*math.pi*2
				table.insert(lagCirclePos, {200+math.sin(theta), 60+math.cos(theta)})
			end

		end
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







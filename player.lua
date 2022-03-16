--player.lua

require 'keybinds'
require 'world'

PLAYER_SPRITESHEET = nil

PLAYER_SPRITESHEET_PATH = "assets/walk1.png"

local PLAYER_WIDTH = 23
local PLAYER_HEIGHT = 30
local PLAYER_FRAME_WIDTH = 23
local PLAYER_FRAME_HEIGHT = 43

PLAYER_NUM_FRAMES = {}
PLAYER_NUM_FRAMES[0] = 12
PLAYER_NUM_FRAMES[1] = 12 -- number of frames of animation in each row
PLAYER_NUM_FRAMES[2] = 12
PLAYER_NUM_FRAMES[3] = 12
PLAYER_NUM_FPS = {}
PLAYER_NUM_FPS[0] = 22
PLAYER_NUM_FPS[1] = 22 -- FPS for each row in SS
PLAYER_NUM_FPS[2] = 22
PLAYER_NUM_FPS[3] = 22
local rt2over2 = math.sqrt(2)/2
EMPTY_INV = {}
NO_EQUIP = {}

PLAYER_SPRITESHEET = love.graphics.newImage(PLAYER_SPRITESHEET_PATH)
local SS_W = PLAYER_SPRITESHEET:getWidth()
local SS_H = PLAYER_SPRITESHEET:getHeight()


local PLAYER_SPEED = 200



function newPlayer(x, y, playerID, status, facing, inventory, equipment)
	local p = {}
	p.quad = love.graphics.newQuad(0, 0, PLAYER_FRAME_WIDTH, PLAYER_FRAME_HEIGHT, SS_W, SS_H)
	p.x = x or 32
	p.y = y or 32
	p.id = playerID or 1
	p.facing = facing or 0
	p.flipH = true
	p.flipV = false
	p.spriteRow = 0
	p.colX = p.x
	p.colY = p.y + ((2*PLAYER_FRAME_HEIGHT)-PLAYER_HEIGHT)
	p.colYOff = ((2*PLAYER_FRAME_HEIGHT)-PLAYER_HEIGHT)
	p.colW = PLAYER_WIDTH
	p.colH = PLAYER_HEIGHT
	p.frame = 0
	p.rot, p.sx, p.sy = 0, 2, 2
	local s = status or DEFAULT_STATUS
	p.status = s
	p.equipment = equipment or NO_EQUIP
	p.inventory = inventory or EMPTY_INV
	p.numFrames = 12
	p.fps = 12
	p.u, p.d, p.l, p.r = false, false, false, false
	p.setQuad = function ()
		local frame = math.floor(p.frame)%p.numFrames
		p.quad:setViewport(frame*PLAYER_FRAME_WIDTH, p.spriteRow*PLAYER_FRAME_HEIGHT,  PLAYER_FRAME_WIDTH, PLAYER_FRAME_HEIGHT, SS_W, SS_H)
	end
	p.nextX = 0
	p.nextY = 0

	--p.setAnimation = function (numAnimation, flipped)  --MAYBE USE SOMETHING LIKE THIS INSTEAD???
	p.keyPressFunctions = {}
	p.initKPFunctions = function ()
		
		p.keyPressFunctions[K_UP] = function ()
			p.facing = 1
			p.spriteRow = 1
			p.frame = 0
			p.flipH = false
			p.flipV = false
			p.numFrames = PLAYER_NUM_FRAMES[p.spriteRow]
			p.fps = PLAYER_NUM_FPS[p.spriteRow]
			p.setQuad()
			p.d = false
			p.u = true
		end
		p.keyPressFunctions[K_DOWN] = function ()
			p.facing = 3
			p.spriteRow = 2
			p.frame = 0
			p.flipH = false
			p.flipV = false
			p.numFrames = PLAYER_NUM_FRAMES[p.spriteRow]
			p.fps = PLAYER_NUM_FPS[p.spriteRow]
			p.setQuad()
			p.u = false
			p.d = true
		end
		p.keyPressFunctions[K_LEFT] = function ()
			p.facing = 2
			p.spriteRow = 0
			p.frame = 0
			p.flipH = false
			p.flipV = false
			p.numFrames = PLAYER_NUM_FRAMES[p.spriteRow]
			p.fps = PLAYER_NUM_FPS[p.spriteRow]
			-- print("left Pressed")
			p.r = false
			p.l = true
			p.setQuad()
		end
		p.keyPressFunctions[K_RIGHT] = function ()
			p.facing = 0
			p.spriteRow = 0
			p.frame = 0
			p.flipH = true
			p.flipV = false
			p.numFrames = PLAYER_NUM_FRAMES[p.spriteRow]
			p.fps = PLAYER_NUM_FPS[p.spriteRow]
			-- print("right Pressed")
			p.r = true
			p.l = false
			p.setQuad()
		end
	end
	p.keyPressed = function (k)
		 if pcall(p.keyPressFunctions[k]) then
		 elseif debugMode then 
		 	print ('keyPress failed ' .. k)
		 end
	end

	p.keyReleased = function (k)
		if k == K_UP then
			if p.facing == 1 then
				p.findFace()
			end
			p.u = false
		elseif k == K_DOWN then
			if p.facing == 3 then
				p.findFace()
			end
			p.d = false
		elseif k == K_LEFT then
			if p.facing == 2 then
				p.findFace()
			end
			p.l = false
		elseif k == K_RIGHT then
			if p.facing == 0 then
				p.findFace()
			end
			p.r = false
		end

		p.r = love.keyboard.isDown(K_RIGHT)
		p.u = love.keyboard.isDown(K_UP)
		p.l = love.keyboard.isDown(K_LEFT)
		p.d = love.keyboard.isDown(K_DOWN)

		if p.r and p.l then p.l, p.r = false, false end
		if p.d and p.u then p.u, p.d = false, false end
		-- print("key " .. k .. " released")
		--stub (I dont think I need to have much in here)
	end

	p.draw = function ()
		p.setQuad()
		if p.flipH or p.flipV then
			local ox = PLAYER_FRAME_WIDTH/2
			local oy = PLAYER_FRAME_HEIGHT/2
			local sy = p.sy
			local sx = p.sx
			local nx = p.x + ox*p.sx
			local ny = p.y + oy*p.sy

			if p.flipV then 
				sy = -1*sy 
			else 
				sx = -1*sx 
			end
			love.graphics.draw(PLAYER_SPRITESHEET, p.quad, nx, ny, p.rot, sx, sy, ox, oy)
		else
			love.graphics.draw(PLAYER_SPRITESHEET, p.quad, p.x, p.y, p.rot, p.sx, p.sy)
		end
	end

	p.findFace = function ()
		if love.keyboard.isDown(K_UP) then
			p.facing = 1
			p.spriteRow = 1
		elseif love.keyboard.isDown(K_DOWN) then
			p.facing = 3
			p.spriteRow = 2
		elseif love.keyboard.isDown(K_LEFT) then
			p.facing = 2
			p.spriteRow = 0
		elseif love.keyboard.isDown(K_RIGHT) then
			p.facing = 0
			p.spriteRow = 0
			p.flipH = true
		end
	end

	p.update = function (dt)
		local pMoving = true
		-- local lastFace = p.facing
		local pX = p.x
		local pY = p.y
		if p.r and p.u then
			pX = pX + PLAYER_SPEED*dt*rt2over2
			pY= pY- rt2over2*dt*PLAYER_SPEED
		elseif p.r and p.d then
			pX = pX + PLAYER_SPEED*dt*rt2over2
			pY= pY+ rt2over2*dt*PLAYER_SPEED
		elseif p.l and p.u then
			pX = pX - PLAYER_SPEED*dt*rt2over2
			pY= pY- rt2over2*dt*PLAYER_SPEED
		elseif p.l and p.d then
			pX = pX - PLAYER_SPEED*dt*rt2over2
			pY= pY+ rt2over2*dt*PLAYER_SPEED
		elseif p.r then
			pX = pX + PLAYER_SPEED*dt
		elseif p.u then
			pY= pY- PLAYER_SPEED*dt
		elseif p.d then
			pY= pY+ PLAYER_SPEED*dt
		elseif p.l then
			pX = pX - PLAYER_SPEED*dt
		else
			pMoving = false
			if p.spriteRow < 3 then 
				if p.facing == -1 then p.facing = lastFace end
				p.frame = 0 
			
			end
		end
		if pMoving then 
			p.frame = p.frame + (p.fps*dt)  
		end
		p.nextX = pX
		p.nextY = pY

		local firstCol = -1
		local px, py, pw, ph = p.getBounds()
		local tmpCol = world.slowCheckCollision(px, py, pw, ph) 
		if tmpCol ~= false then
			firstCol = tmpCol
			tmpPXCol = world.slowCheckCollision(px, p.colY, pw, ph, firstCol)
			if tmpPXCol ~= false then
				tmpPYCol = world.slowCheckCollision(p.colX+1, py, pw-1, ph, firstCol)
				if tmpPYCol == false then
					p.move("Y")
				end
			else
				p.move("X")
			end

		else
			p.move()
		end

	end
	p.getBounds = function()
		local offsetX = (PLAYER_FRAME_WIDTH*p.sx - p.colW)/2
		return p.nextX+offsetX, p.nextY+p.colYOff, p.colW, p.colH
	end

	p.move = function(mvmode)
		local mvmode = mvmode or "BOTH"
		-- print(mvmode)
		if mvmode == "BOTH" then
			p.x = p.nextX
			p.y = p.nextY
			p.colY = p.y + ((2*PLAYER_FRAME_HEIGHT)-PLAYER_HEIGHT)
		elseif mvmode == "Y" then
			p.y = p.nextY
			p.colY = p.y + ((2*PLAYER_FRAME_HEIGHT)-PLAYER_HEIGHT)
		elseif mvmode == "X" then
			p.x = p.nextX
			p.colX = p.x + (PLAYER_FRAME_WIDTH*p.sx - p.colW)/2
		end
	end

	return p
end
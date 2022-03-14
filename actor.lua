--actor.lua
function newActor (x, y, spriteSheet, ssx, ssy, width, height, fps, mode)
	local a = {}
	a.x = x or 0
	a.y = y or 0
	a.spriteSheet = love.graphics.newImage(spriteSheet)
	a.w = width or 32
	a.h = height or 32
	a.fps = fps or 0
	a.mode = mode or "static"
	a.onFrame = 0
	a.numFrames = numFrames or 0
	a.timer = 0
	a.frameTime = 1/a.fps
	a.ssx = ssx or 0
	a.ssy = ssy or 0
	a.sw = a.spriteSheet:getWidth()
	a.sh = a.spriteSheet:getHeight()
	a.quad = love.graphics.newQuad(ssx, ssy, a.w, a.h, a.spriteSheet:getWidth(), a.spriteSheet:getHeight())

	a.draw = function ()
		love.graphics.draw(a.spriteSheet, a.quad, a.x, a.y)
		
	end
	a.update = function (dt)
		a.timer = a.timer + dt
		if a.timer >= (a.frameTime) then
			a.onFrame = a.onFrame + math.floor(a.timer/(a.frameTime))
			a.ssx = a.onFrame*a.w
			a.quad:setViewport( a.ssx, a.ssy, a.w, a.h, a.sw, a.sh )
		end
	end

	return a
end
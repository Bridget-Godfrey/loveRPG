-- bullet.lua

local BULLET_PRESETS = {}
BULLET_PRESETS[1] = {}
BULLET_PRESETS[1].radius = 5




function newBullet (bulType, x, y, xvelo, yvelo, pattern, height, range)
	local b = {}
	b.x = x or 0
	b.y = y or 0
	b.xvelo = xvelo or 0
	b.yvelo = yvelo or 0
	b.pattern = pattern or 0
	b.height = height or 0
	b.range = range or 0
	


	b.update = function(dt)
	
	end


	b.draw = function ()
	end

	return b
end
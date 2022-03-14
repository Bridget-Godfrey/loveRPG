--tile.lua
TILES = {}

function NOACTION ()
	--stub
end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end
----DRAW FLAGS:
-- nil == all zeros
--bit 0: is animated
--bit 1: uses tile Color
--bit 2: flip horizontal
--bit 3: flip vertical
--bit 4 + 5: rotate 90deg    00 = 0, 01 = 90, 10 = 180, 11= 270
--bit 6: ??????



local bnot =  bit.bnot
local band, bor, bxor =  bit.band,  bit.bor,  bit.bxor
local lshift, rshift, rol =  bit.lshift,  bit.rshift, bit.rol



NO_IMAGE_STRING = "noimg.png"
DEFAULT_WIDTH = 32
local QUARTER_TURN = math.rad(90)



DEFAULT_PROPERTIES = {
	solid = false,
	show = true,
	animated = false,
	text = nil,
	action = nil,
	quadX = 0,
	quadY = 0,
	color = {1, 1, 1, 1},
	group = 0,
	numFrames = 1,
	fps = 0,
	scaleX = 1,
	scaleY = 1,
	rotation = 0,
	collisionX_off = 0,
	collisionY_off = 0,
	collisionW = 0,
	collisionH = 0,

	other = nil
}

INSTANCE_DEFAULT_PROPERTIES = {
	--DRAW FLAGS--
	animated = false,
	useTileColor = false,
	flipH = false,
	flipV = false,
	rotation = 0,
	bit6 = false,

	--ACTIONS--
	hasAction = 1, -- 0 = none, 1 = sameAsParent, 2 = unique
	action = nil,
	other = nil


}

NO_IMAGE_STRING = "tileData/tileGraphics/tile_000.png"


function defineTile (name, width, height, image, properties, z )
	local t = {}
	t.id = table.getn(TILES) + 1
	
	t.name = name or "UNNAMED"
	t.width = width or DEFAULT_WIDTH
	t.height = height or DEFAULT_WIDTH
	local imgStr = image or NO_IMAGE_STRING
	t.image = love.graphics.newImage(imgStr)
	t.solid = properties.solid or DEFAULT_PROPERTIES.solid
	t.show = properties.show or DEFAULT_PROPERTIES.show
	t.animated = properties.animated or DEFAULT_PROPERTIES.animated
	t.text = properties.text or DEFAULT_PROPERTIES.text
	t.action = properties.action or DEFAULT_PROPERTIES.action
	local quadX = properties.quadX or DEFAULT_PROPERTIES.quadX
	local quadY = properties.quadY or DEFAULT_PROPERTIES.quadY
	local quadW = properties.quadW or t.image:getWidth()
	local quadH = properties.quadH or t.image:getHeight()
	t.quad = love.graphics.newQuad( quadX, quadY, quadW, quadH, t.image:getWidth(), t.image:getHeight())
	t.color = properties.color or DEFAULT_PROPERTIES.color
	t.group = properties.group or DEFAULT_PROPERTIES.group
	t.numFrames = properties.numFrames or DEFAULT_PROPERTIES.numFrames
	t.fps = properties.fps or DEFAULT_PROPERTIES.fps
	t.scaleX = properties.scaleX or DEFAULT_PROPERTIES.scaleX
	t.scaleY = properties.scaleY or DEFAULT_PROPERTIES.scaleY 
	t.rotation = math.rad(properties.rotation) or DEFAULT_PROPERTIES.rotation
	t.collisionX_off = properties.collisionX_off or DEFAULT_PROPERTIES.collisionX_off
	t.collisionY_off = properties.collisionY_off or DEFAULT_PROPERTIES.collisionY_off
	t.collisionW = properties.collisionW or t.width
	t.collisionH = properties.collisionH or t.height/2
	t.other = properties.other or DEFAULT_PROPERTIES.other
	if z then 
		t.collisionY_off = z
		t.height = (height*t.scaleY)-(z*t.scaleY)
		print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
	end

	t.draw = function (x, y, flags)
		if flags == nil or flags == 0 then
			-- love.graphics.setColor(t.color)
			love.graphics.draw(t.image, t.quad, x-t.collisionX_off*t.scaleX, y-t.collisionY_off*t.scaleY, t.rotation, t.scaleX, t.scaleY)
		else
			local nx =  x-t.collisionX_off*t.scaleX
			local ny =  y-t.collisionY_off*t.scaleY
			local ox = 0
			local oy = 0
			local sx = t.scaleX
			local sy = t.scaleY
			oy = t.image:getHeight()/2
			ox = t.image:getWidth()/2
			ny = ny + oy*sy
			nx = nx + ox*sx
			local irotation = 0
			if bit.band(48, flags) > 0 then -- if rotation flag set
				irotation = rshift(band(48, flags), 4)*-1*QUARTER_TURN
				-- if rshift(band(48, flags), 4) == 1 then
					
				-- end
				if debugMode then
					-- love.graphics.print(rshift(band(48, flags), 4) .. "r", x+32, 180, 0, 1, 1)
					-- love.graphics.setColor(1, 0, 1, 1)
					-- love.graphics.rectangle("fill", x, y, t.width*t.scaleX, t.height*t.scaleY)
				end
			end
			if band(4, flags) > 0 then
				sx = sx * -1
			end 
			if band(8, flags) > 0 then
				sy = sy * -1
			end

			if bit.band(16, flags) > 0 then
				love.graphics.setColor(t.color)
				love.graphics.draw(t.image, t.quad, nx, ny, irotation, sx, sy, ox, oy)
				love.graphics.setColor(1, 1, 1, 1)
			else
				--love.graphics.setColor(t.color)
				love.graphics.draw(t.image, t.quad, nx, ny, irotation, sx, sy, ox, oy)
			end
		end

		if debugMode then
			love.graphics.setColor(0.1, 0.1, 1, 1)
			love.graphics.printf("" .. t.id, x, y - (DEFAULT_WIDTH/2), DEFAULT_WIDTH, "center")
			love.graphics.setColor(1, 1, 1, 1)
		end


	end


	t.update = function (dt)
		--none
	end


	table.insert(TILES, t)
end




function newTileInstance(id, x, y, props)
	local t = {}
	t.id = id or 0
	t.x = x + TILES[t.id].collisionX_off or -100
	t.y = y + TILES[t.id].collisionY_off*TILES[t.id].scaleY or -100
	t.w = TILES[t.id].width * TILES[t.id].scaleX
	t.h = TILES[t.id].height
	local props = props or  {}
	t.drawFlags = 0
	--DRAW FLAGS--
	if props.animated or INSTANCE_DEFAULT_PROPERTIES.animated then t.drawFlags = t.drawFlags + 1 end
	if props.useTileColor then t.drawFlags = t.drawFlags + 2 end
	if props.flipH or INSTANCE_DEFAULT_PROPERTIES.flipH then t.drawFlags = t.drawFlags + 4 end
	if props.flipV or INSTANCE_DEFAULT_PROPERTIES.flipV then t.drawFlags = t.drawFlags + 8 end
	if props.rotation ~= nil and  props.rotation > 0 then
		print (props.rotation .. "  " .. id)
		local tempR = props.rotation/90
		tempR = lshift(tempR, 4)
		t.drawFlags = t.drawFlags + tempR
	end
	if props.bit6 or INSTANCE_DEFAULT_PROPERTIES.bit6 then t.drawFlags = t.drawFlags + 64 end


	--ACTIONS--
	t.hasAction = props.hasAction or INSTANCE_DEFAULT_PROPERTIES.hasAction
	t.action = props.action or INSTANCE_DEFAULT_PROPERTIES.action
	t.other = props.other or INSTANCE_DEFAULT_PROPERTIES.other
	-- t.drawFlags = bor(TILES[t.id].drawFlag, t.drawFlags)
	print(t.drawFlags)
	t.draw = function()
		TILES[id].draw(t.x, t.y, t.drawFlags)
		if debugMode then 
			love.graphics.setColor(1, 0, 1, .67)
			love.graphics.rectangle("fill", t.x, t.y, t.w, t.h)
			love.graphics.setColor(1, 1, 1, 1)
		end
	end
	return t
end


function checkTICollision(ti, x, y, w, h)
	return CheckCollision(ti.x,ti.y,ti.w,ti.h, x,y,w,h)
end



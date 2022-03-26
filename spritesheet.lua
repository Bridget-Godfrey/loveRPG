-- spritesheet.lua
--handles spritesheets since they can be a mess
	  --Also works as:
	  			-- filename, numSprites
function newSpritesheet(filename, spriteWidth, spriteHeight, marginX, marginY)
	local ss = {}
	ss.image = love.graphics.newImage(filename)
	ss.wholeWidth = ss.image:getWidth()
	ss.wholeHeight = ss.image:getHeight()
	ss.spriteWidth = spriteWidth
	ss.spriteHeight = spriteHeight
	ss.marginX = marginX or 0
	ss.marginY = marginY or 0
	if spriteHeight == nil then
		ss.spriteWidth = math.sqrt(spriteWidth)
		ss.spriteHeight = math.sqrt(spriteWidth)
	end

	ss.definedSprites = {}
	print("READING SPRITESHEET " .. filename)
	local xPos = 0 
	local yPos = 0 
	local numSprites = 0
	local onRow = 1
	while yPos < ss.wholeHeight do
		xPos = 0

		local numHorizontal = 0
		while xPos < ss.wholeWidth do
			local xp = (xPos+(ss.marginX*numHorizontal))
			local yp = (yPos + (ss.marginY* (math.floor(numSprites/onRow))))
			ss.definedSprites[numSprites+1] = love.graphics.newQuad(xp, yp, ss.spriteWidth, ss.spriteHeight, ss.wholeWidth, ss.wholeHeight )
			print("Sprite #" .. numSprites+1 .. " at (" .. xp .. ", " .. yp .. ")")
			xPos = xPos + ss.spriteWidth
			numHorizontal = numHorizontal + 1
			numSprites = numSprites + 1
		end
		onRow = onRow + 1
		yPos = yPos + ss.spriteHeight
	end

	ss.numSprites = table.getn(ss.definedSprites)
	-- ss.defaultQuad = love.graphics.newQuad(0, 0, ss.spriteWidth, ss.spriteHeight, ss.wholeWidth, ss.wholeHeight)

	ss.drawSprite = function (spriteNumber, drawX, drawY, scaleX, scaleY, rot, flags)
		local spriteNumber = spriteNumber or 1
		spriteNumber = ((spriteNumber-1)%ss.numSprites)+1
		-- if spriteNumber == 0 then spriteNumber = ss.numSprites end

		local spriteQuad = ss.definedSprites[spriteNumber]
		-- print(spriteNumber, spriteQuad:getViewport( ))
		local drawX = drawX or 0
		local drawY = drawY or 0
		local rot = rot or 0
		local scaleX = scaleX or 1
		local scaleY = scaleY or 1
		local flags = flags or {}
		love.graphics.setColor(1, 1, 1, 1)
		

		if flags.flipV or flags.flipH then
			local junk1, junk2, spriteWidth, spriteHeight = spriteQuad:getViewport()

			local ox = spriteWidth/2
			local oy = spriteHeight/2
			local nx = drawX + ox*scaleX
			local ny = drawY + oy*scaleY

			if flags.flipV then 
				scaleY = -1*scaleY 
			else 
				scaleX = -1*scaleX 
			end
			love.graphics.draw(ss.image, spriteQuad, nx, ny, rot, scaleX, scaleY, ox, oy)
		else
			love.graphics.draw(ss.image, spriteQuad, drawX, drawY, rot, scaleX, scaleY)
		end


	end

	return ss
end
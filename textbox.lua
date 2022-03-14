--textbox.lua

textbox = {}

queue = {}
textCursor = 0
selectionCursor = 0
floatingTextCursor = 0
currentText = ""
currentType = ""
textSpeed = 100
VIRTUAL_SCREEN_WIDTH = 1080
VIRTUAL_SCREEN_HEIGHT = 720
textbox.addToQueue = function(text, speaker, tb_type, options)
	text = text or "nil"
	speaker = speaker or nil
	tb_type = tb_type or 1
	options = options or {}
	table.insert(queue, {text, speaker, tb_type, options})
end

textbox.start = function ()
	gameMode = 0.5
	currentText = queue[1][1]
	currentType = queue[1][3]
	
	-- newQueue = {}
	-- for i = 2, table.getn(queue) do
	-- 	table.insert(newQueue, queue[i])
	-- end
	-- queue = newQueue 
	table.remove(queue, 1)
end

textbox.draw = function()
	love.graphics.setColor(0.7, 0.7, 0.7, 0.5)
	love.graphics.rectangle("fill", 0, 500, VIRTUAL_SCREEN_WIDTH, VIRTUAL_SCREEN_HEIGHT)
	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.printf(string.sub(currentText, 1, textCursor), 50, 550, VIRTUAL_SCREEN_WIDTH-50)
	love.graphics.setColor(1, 1, 1, 1)
end

textbox.update = function(dt)
	floatingTextCursor = floatingTextCursor + (textSpeed*dt)
	textCursor = math.floor(floatingTextCursor)
end
textbox.keyPressed = function(k)
	if k == "return" then
		-- textbox.progress()
	end
end
textbox.keyReleased = function(k)
	if k == K_ACTION then
		textbox.progress()
	end
end

textbox.progress = function()
	if table.getn(queue) == 0 then
		gameMode = 0
		textCursor = 0
		selectionCursor = 0
		floatingTextCursor = 0
	else
		textCursor = 0
		selectionCursor = 0
		floatingTextCursor = 0
		textbox.start()
	end
end
return textbox
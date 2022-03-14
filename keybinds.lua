--keybinds.lua

require 'savegame'


K_LEFT = "a"
K_RIGHT = "d"
K_UP = "w"
K_DOWN = "s"
K_ACTION = "space"
K_MENU = "e"
K_OTHER =  "q"


function loadKeydata ()
	local tempKD = getKeySettings()
	K_LEFT = tempKD.left
	K_RIGHT = tempKD.right
	K_UP = tempKD.up
	K_DOWN = tempKD.down
	K_ACTION = tempKD.action
	K_MENU = tempKD.menu
	K_OTHER = tempKD.other
end

function storeKeydata ()
	local tempKD = {}
	tempKD.left = K_LEFT
	tempKD.right = K_RIGHT
	tempKD.up = K_UP
	tempKD.down = K_DOWN
	tempKD.action = K_ACTION
	tempKD.menu = K_MENU
	tempKD.other = K_OTHER
	setKeySettings(tempKD)
end

function getKeyName(k)
	return "action"
end
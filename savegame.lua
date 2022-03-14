--savegame.lua
require 'Tserial'


savegamePath = love.filesystem.getIdentity( ) .. "/save.txt"
-- print(savegamePath)

savegameData = {
	savefile1 = {}, --this stores game progress and other non-setting type things
	savefile2 = {},	--this stores game progress and other non-setting type things
	savefile3 = {},	--this stores game progress and other non-setting type things
	keySettings = {left = "a", right = "d", up = "w", down = "s", action = "space", menu = "e", other =  "q"}, --storesKeyBindings and other related keySettings
	options = {}, --stores some user preferences (e.g. fullscreen, colorblind mode, subtitles, etc)
	globalSaveData = {} --  ;)

}
ready_to_save = false





function loadSaveFile()
	-- love.filesystem.setIdentity( name )
	info = love.filesystem.getInfo( savegamePath )
	if info == nil then
		print('save file does not exist!')
		ready_to_save = true
		writeSaveData()
		ready_to_save = false
		-- print('creating new save data!')
	else
		print('loading save data...')
		contents, size = love.filesystem.read(savegamePath)
		if contetns then 
			print('could not read file, encountered error ' .. size)
		else
			print(contents)
			unpacked, err = TSerial.unpack(contents)
			if unpacked then
				savegameData = unpacked
			else
				print ('TSerial encountered the error ' .. err)
			end
		end
	end

end



function writeSaveData()
	local saveData = TSerial.pack(savegameData, nil, true)
	local success, message =love.filesystem.write( savegamePath, saveData)
	if success then 
		print ('file written')
	else 
		print ('creating file...')
		if love.filesystem.isFused() then
	    	local dir = love.filesystem.getSourceBaseDirectory()
	    	local success = love.filesystem.mount(dir)

		    if success then
		        -- If the game is fused and it's located in C:\Program Files\mycoolgame\,
		        -- then we can now load files from that path.
		        -- coolimage = love.graphics.newImage("coolgame/coolimage.png")
		    end
		else
			savegamePath = "save.txt"
		end

		local success, message =love.filesystem.write( savegamePath, saveData)

			if success then 
				print ('file created')
			else 
				print ('file not created: '..message)
			end
	end
end

function getKeySettings ()
	return savegameData.keySettings
end


function setKeySettings (newKeySettings)
	savegameData.keySettings = newKeySettings or savegameData.keySettings
end

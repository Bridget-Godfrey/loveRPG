--tileLoader.lua
require "tile"
NUM_TILES = 12
---PRODUCTION USE ONLY, PLEASE UPDATE BEFORE RELEASE
function dirLookup(dir)
	local i, t, popen = 0, {}, io.popen
	-- local pfile = popen('dir "'')
	for filename in io.popen('dir "'..dir .. '" /b' ):lines() do
	    i = i + 1
	    t[i] = filename
	    print(filename)
	end
	-- pfile:close()
	return t
end


NUM_TILES = table.getn(dirLookup("tileData"))-1

function tl_loadTiles(cycle)
	if cycle == 0 then
		return NUM_TILES
	elseif cycle <= NUM_TILES then
		local tName = "tileData." .. cycle
		local t = require(tName)
		defineTile (t.name, t.width, t.height, t.img, t.prop, t.z )
		print((t.name or "nil Name")  .. " loaded")
	else
		--doNothing
	end
end
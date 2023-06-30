love.filesystem.mount(love.filesystem.getSourceBaseDirectory(), "/", true)
love.filesystem.setRequirePath("?.lua;?/init.lua;scripts/?.lua;scripts/?/init.lua")
require("scripts")

local urfs = require "utils.urfs"
urfs.mount("D:/Engines/SMBX2/data")

Game:init("D:/Engines/SMBX2/worlds/the invasion 2", "TEST.lvlx")

-- Tile.spawn(1, 0, 0)
-- Player.spawn('mario', 0, 0)

-- for i = 0, 20 do
	-- local block = Block.spawn(1, 32 * i, 300)
	-- local block = Block.spawn(1, 32 * i, 332)
	
	-- if i == 10 then
		-- Block.spawn(333, (32 * i) + 32, 300 - 32)
		-- Block.spawn(333, (32 * i), 300 - 64)
		-- Block.spawn(1, (32 * i) - 32, 300 - 64)
		-- Block.spawn(332, (32 * i) - 64, 300 - 64)
		-- Block.spawn(332, (32 * i) - 96, 300 - 32)
	-- end
	
	-- if i == 17 then
		-- local x = (32 * i)
		
		-- for i = 1, 6 do
			-- Block.spawn(168, x + (32 * i), 300 - 96)
		-- end
	-- end
-- end

-- NPC.spawn(1, 64, 0)
local Game = {}

local urfs = require("utils.urfs")
local mounts

local LevelParser = require("utils.parser.level")
local MapParser = require("utils.parser.world")
		
Game.fps = 64.102564102564
-- Game.speed = 1
Game.dt = (1 / Game.fps)

function Game:setFPS(val)
	Game.fps = val
	Game.dt = (1 / Game.fps)
end

function Game:init(worldPath, levelPath)
	if mounts then
		for k,archive in ipairs(mounts) do
			urfs.unmount(archive)
		end
	end
	
	if worldPath then
		mounts = {
			worldPath,
			worldPath .. '/' .. worldPath:match("[^/]*$"),
		}
		
		for k,archive in ipairs(mounts) do
			urfs.mount(archive)
		end
	end
	
	local worldFile
	
	for k, file in ipairs(Files.iterate("")) do
		if file:find(".wldx") then
			worldFile = file
			break
		end
	end
	
	-- print(levelPath:match("(.*[/\\])"), levelPath:match("(.+)%..+$"))
	-- self.level = Level:new(levelPath)
	-- self.map = Map:new(levelPath:match("(.*[/\\])") .. ')
	
	self.paused = false
	
	if levelPath then
		self.level = Level:new(levelPath)
		self.isMap = false
	else
		self.isMap = true
	end
	
	if not self.isMap then
		LevelParser.read(levelPath)
	else
		self.map = Map:new()
		
		MapParser.read(worldFile)
	end
	
	for k,camera in ipairs(Camera) do
		camera:defaultRender()
	end
end

function Game:stage()
	if self.isMap then
		return self.map
	end
	
	return self.level
end

Signal.register('onDraw', function()
	local stage = Game:stage()
	
	if stage then stage:draw() end
end)

Signal.register('onCameraDraw', function(cam)
	local stage = Game:stage()
	
	if stage and stage.render_hud then stage:render_hud(cam) end
end)

Signal.register('onUpdate', function()
	local stage = Game:stage()
	
	if stage then stage:update() end
end)

return Game
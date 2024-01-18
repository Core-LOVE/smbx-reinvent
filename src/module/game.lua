local Game = {}

Game.paths = {}
Game.stage = nil

function Game:setLevelPath(path)
	Files.mountFullPath(Game.paths.episode .. '/' .. path, "")
	Game.paths.level = path
end

function Game:setEpisodePath(path, no_mount)
	if not no_mount then
		Files.mountFullPath(path, "")
	end

	Game.paths.episode = path
end

function Game:loadLevel(path, episodePath)
	if not Game.paths.episode then
		Game:loadEpisode(episodePath)
	end
	
	Game:setLevelPath(Files.noExtension(path))
	Game.stage = Level(path)

	print("Starting Level: " .. path)
end

function Game:loadEpisode(path)
	Game:clear()
	Game:setEpisodePath(path)

	print("Starting Episode at " .. path)
end

function Game:loadTitle()
	local path = "intro.lvlx"
	local episodePath = Files.getRealDirectory(path)

	if not Game.paths.episode then
		Game:loadEpisode(episodePath, true)
	end
	
	Game:setLevelPath(Files.noExtension(path))
	Game.stage = Title(path)

	print("Starting Title Level: " .. path)
end

function Game:clear()
	for k,path in pairs(Game.paths) do
		Files.unmountFullPath(path)
	end
	
	self.paths = {}
	self:setFPS(64.102564102564)
end

function Game:setFPS(val)
	self.fps = val
	self.dt = (1 / val)
end

function Game:update()
	local stage = Game.stage
	
	if stage then
		Game.stage:update()
	end
end

function Game:draw()
	local stage = Game.stage
	
	if stage then
		Game.stage:draw()
	end
end

Signal.register('onUpdate', function()
    Game:update()
end)

Signal.register('onDraw', function()
    Game:draw()
end)

return Game, Game:clear()
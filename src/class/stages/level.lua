local Level, super = Class('Level', Object)

local LevelParser = require("src.lib.parser.level")

function Level:paint(cam)
	for k,v in ipairs(BGO) do 
		v:draw(cam)
	end

	for k,v in ipairs(Block) do 
		v:draw(cam)
	end

	for k,v in ipairs(Player) do
		v:draw()
	end

	for k,v in ipairs(NPC) do
		v:draw()
	end
end

function Level:initialize(path)
	super.initialize(self)
	
	LevelParser.read(path)
	
	self.camera = Camera:new(0, 0, 800, 600):setPaint(function()
		self:paint()
	end):setTarget(Player[1])
end

function Level:update()
	super.update(self)
	
	Block.animation:update()
	BGO.animation:update()

	for k,v in ipairs(Player) do
		v:update()
	end

	for k,v in ipairs(NPC) do
		v:update()
	end

	for k,v in ipairs(Camera) do
		v:update()
	end
end

function Level:draw()
	super.draw(self)

	for k,v in ipairs(Camera) do
		v:draw()
	end
end

return Level
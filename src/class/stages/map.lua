local Map, super = Class('Map', Object)

local WorldParser = require("src.lib.parser.world")

function Map:paint(cam)
	-- for k,v in ipairs(BGO) do 
	-- 	v:draw(cam)
	-- end
end

function Map:initialize(path)
	super.initialize(self)
	
	WorldParser.read(path)
	
	self.player = MapPlayer[1]
	self.camera = Camera:new(0, 0, 800, 600):setPaint(function()
		self:paint()
	end):setTarget(self.player)
end

function Map:update()
	super.update(self)
	
	-- Block.animation:update()
	-- BGO.animation:update()

	-- for k,v in ipairs(Player) do
	-- 	v:update()
	-- end
end

function Map:draw()
	super.draw(self)

	for k,v in ipairs(Camera) do
		v:draw()
	end
end

return Map
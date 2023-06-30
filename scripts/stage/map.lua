local Map = Class('Map')

-- local MapParser = require("utils.parser.world")

function Map:initialize(path)
	local camera = Camera.spawn(0, 0, 800, 600)
	-- camera:defaultRender()
	
	self.camera = camera
end

function Map:update()
	for _, obj in ipairs(Camera) do
		obj:update()
	end
end

function Map:draw()
	for _, obj in ipairs(Camera) do
		obj:draw()
	end
end

function Map:render()
	for _, obj in ipairs(Tile) do
		obj:draw()
	end
end

return Map
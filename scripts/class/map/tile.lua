local Tile, super = Class('Tile', Object)

function Tile.spawn(id, x, y)
	local self = Tile:new(id, x, y)
	table.insert(Tile, self)
end

function Tile:initialize(id, x, y)
	super.initialize(self, x, y)
	self.id = id
end

function Tile:render()
	local texture = Assets.graphics.tile[self.id]
	
	love.graphics.draw(texture, 0, 0)
end

return Tile
local BGO, super = Class('BGO', Object)

function BGO.spawn(id, x, y)
	local class = BGO
	local self = class:new(x, y)
	
	self.idx = #BGO + 1
	self.id = id
	
	table.insert(BGO, self)
	return self
end

function BGO:initialize(x, y)
	super.initialize(self, x, y)
end

function BGO:getZ()
	return LAYERS.BGO
end

function BGO:render()
	local texture = Assets.graphics.background[self.id]
	
	Draw.texture(texture, 0, 0)
end

return BGO
local BGO, super = Class('BGO', Object)

function BGO.spawn(id, x, y)
	local class = BGO
	local self = class:new(x, y)
	
	self.idx = #BGO + 1
	self.id = id
	
	table.insert(BGO, self)
end

function BGO:initialize(x, y)
	super.initialize(self, x, y)
end

return BGO
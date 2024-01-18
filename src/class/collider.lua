local Collider = Class('Collider')

local splash = require("src.lib.splash")
local world = splash.new()

function Collider:initialize(parent, type, ...)
	self.parent = parent
	
	local args = {...}
	
	if type == 'aabb' or type == 'box' then
		self.x = args[1]
		self.y = args[2]
		self.width = args[3]
		self.height = args[4]
		
		self.shape = world:add(
			{}, splash.aabb(self.x, self.y, self.width, self.height)
		)
	elseif type == 'circle' then
		self.x = args[1]
		self.y = args[2]
		self.radius = args[3]
		
		self.shape = world:add(
			{}, splash.circle(self.x, self.y, self.radius)
		)	
	elseif type == 'seg' or type == 'line' then
		self.x = args[1]
		self.y = args[2]
		self.x2 = args[3]
		self.y2 = args[4]
		
		self.shape = world:add(
			{}, splash.seg(self.x, self.y, self.x2, self.y2)
		)		
	end
	
	self.shape.parent = parent
	self.shape.collider = self
end

function Collider:update()	
	local parent = self.parent
	
	world:update(self.shape, parent.x, parent.y)
end

function Collider:remove()
	return world:remove(self.shape)
end

function Collider:move()
	local parent = self.parent
	
	return world:move(self.shape, parent.x + parent.speedX, parent.y + parent.speedY, self.filter, self.callback)
end

function Collider:realShape()
	return world:shape(self.shape)
end

function Collider:sweep(...)
	return self:realShape():sweep(...)
end

return Collider
local Warp, super = Class('Warp', Object)

function Warp:initialize(id, x, y, w, h)
	super.initialize(self, x, y, w or 32, y or 32)

	self.id = id
	self.direction = 0
	self.exit = nil

	table.insert(Warp, self)
end

function Warp:onCollide(obj)
	local exitWarp = self.exit
	
	obj.x = exitWarp.x + exitWarp.width * .5 - obj.width * .5
	obj.y = exitWarp.y + exitWarp.height * .5 - obj.height * .5
	obj.speedY = 0
	obj.speedX = 0
	obj.warpDelay = 50
	obj.isSpinjumping = false
end

return Warp
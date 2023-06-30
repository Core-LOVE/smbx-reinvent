local Warp, super = Class('Warp', Object)

Warp.type = "Warp"

function Warp.spawn(id, x, y, w, h)
	local self = Warp:new(id, x, y, w or 32, h or 32)
	
	table.insert(Warp, self)
	return self
end

function Warp:initialize(id, x, y, w, h)
	super.initialize(self, x, y, w, h)
	
	self.id = id
	self.direction = 0
	self.exit = nil
end

function Warp:onCollide(culprint)
	local exitWarp = self.exit
	
	culprint.x = exitWarp.x + exitWarp.width * .5 - culprint.width * .5
	culprint.y = exitWarp.y + exitWarp.height * .5 - culprint.height * .5
	culprint.speedY = 0
	culprint.speedX = 0
	culprint.warpDelay = 50
	culprint.isSpinjumping = false
end

return Warp
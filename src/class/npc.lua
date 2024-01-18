local NPC, super = Class('NPC', Object)
NPC:include(Physics)

NPC.static.config = Config('npc', {
	width = 32,
	height = 32,
})

function NPC:initialize(id, x, y)
	super.initialize(self, x, y, 32, 32)
	
	self.id = id

	self.gravity = nil

	self:clearCollidesValues()

	table.insert(NPC, self)
end

function NPC:clearCollidesValues()
	self.collidesBlockBottom = false
	self.collidesBlockTop = false
	self.collidesBlockLeft = false
	self.collidesBlockRight = false
	self.collidesSlope = nil
end

function NPC:getGravity()
	return Defines.npc_grav or self.gravity
end

function NPC:physics()
	-- self.x = self.x + self.speedX
	-- self.y = self.y + self.speedY

	self:clearCollidesValues()
	self:collisions()
end

function NPC:behave() end
function NPC:animation() end

function NPC:update()
	self.speedY = math.min(self.speedY + self:getGravity(), Defines.gravity)

	self:behave()
	self:animation()

	super.update(self)
end

return NPC
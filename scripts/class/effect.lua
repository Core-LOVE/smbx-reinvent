local Effect, super = Class('Effect', Object)

Effect.config = Config.register('effect', {
	gravity = 0,
	acceleration = {0, 0},
	
	frames = 1,
	framestyle = 0,
	framespeed = 0,
	direction = -1,
	
	speedX = 0,
	speedY = 0,

	lifetime = 65,
})

function Effect.spawn(id, x, y)
	local self = Effect:new(id, x, y)
	
	self.idx = #Effect + 1
	
	table.insert(Effect, self)
	return self
end

function Effect:initialize(id, x, y)
	self.id = id
	local cfg = Effect[id]
	
	super.initialize(self, x, y, 32, 32)
	
	self.emit = false
	
	self.timer = cfg.lifetime
	
	self.frame = 0
	self.frameTimer = 0
	
	self.variant = 0
end

local framestyleEffect = {[0] = 1,[1] = 2,[2] = 4}

function Effect:getZ()
	return LAYERS.EFFECT
end

function Effect:render()
	local id = self.id
	local texture = Assets.graphics.effect[id]
	local config = Effect[id]
	
	local frame = self.frame
	
    if config.framestyle > 0 and self.direction == 1 then
        frame = frame + self.frames
    end
	
	frame = frame + (self.frames*framestyleEffect[self.framestyle]*(self.variant-1))
	
	local quad = Draw.newQuad(0, frame * self.height, self.width, self.height, texture:getDimensions())
	
	Draw.texture(texture, quad, 0, 0)
end

function Effect:remove()
	super.remove(self)
	
	for k,v in ipairs(Effect) do
		if v == self then
			return table.remove(Effect, k)
		end
	end
end

function Effect:update()
	super.update(self)
	
	local cfg = Effect[id]
	
	if cfg.framespeed > 0 then
		if self.frameTimer >= cfg.framespeed then
			self.frame = (self.animationFrame + 1) % cfg.frames
			self.frameTimer = 0
		end

		self.frameTimer = self.frameTimer + 1
	end
	
	self.x = self.x + self.speedX
	self.y = self.y + self.speedY
	
	self.timer = self.timer - 1
	if self.timer <= 0 then
		self:remove()
	end
end

return Effect
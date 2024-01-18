local Block, super = Class('Block', WeakObject)

Block.static.pool = Pool:new()

Block.static.config = Config:new('block', {
	frames = 1,
	framespeed = 8,
	
	floorslope = 0,
	ceilingslope = 0,
	semisolid = false,
	sizable = false,
	
	pswitch = false,
	
	smashable = false,
	bumpable = false,
})

Block.static.animation = {
	ids 		= {},
	quad 		= {},

	frame 	 	= setmetatable({}, {__index = function(self, k)
		rawset(self, k, 0)
		return rawget(self, k)
	end}),

	frametimer 	= setmetatable({}, {__index = function(self, k)
		rawset(self, k, 0)
		return rawget(self, k)
	end}),

	register = function(self, id)
		self.ids[id] = true
		self:updateQuad(id, self.frame[id])
	end,

	updateQuad = function(self, id, f)
		local img = Assets.graphics.block[id]

		local cfg = Block.config[id]
		local w, h = cfg.width or img:getWidth(), cfg.height or img:getHeight() / cfg.frames

		self.quad[id] = Graphics.newQuad(0, h * f, w, h, img:getDimensions())
	end,

	update = function(self)
		for id in pairs(self.ids) do
			local cfg = Block.config[id]
			
			self.frametimer[id] = self.frametimer[id] + 1

			if self.frametimer[id] >= cfg.framespeed then
				self.frame[id] = (self.frame[id] + 1) % cfg.frames
				self:updateQuad(id, self.frame[id])

				self.frametimer[id] = 0
			end
		end
	end
}

Block.static.updating = {}

function Block:initialize(id, x, y, w, h)
	super.initialize(self, x, y, w or 32, h or 32)
	
	self.id = id
	self.collider = Collider:new(self, 'box', self.x, self.y, self.width, self.height)

	Block.animation:register(id)
	Block.pool:add(self)
end

function Block:update()
	-- self:updateChildren()
	-- self:physics()
	-- self:behave()
end

function Block:hit()
	Signal.emit('onBlockHit', self)
end

function Block:render(cam)
	local id = self.id
	local img = Assets.graphics.block[id]
	
	if img == nil then return end
	
	-- local cfg = Block.config[id]
	-- local w, h = cfg.width or img:getWidth(), cfg.height or img:getHeight() / cfg.frames

	-- local quad = love.graphics.newQuad(0, h * Block.animation.frame[id], w, h, img:getDimensions())
	
	Graphics.draw(img, Block.animation.quad[id], 0, 0)
end

function Block:draw(cam)
	if cam and not cam:collidesWith(self) then return end
	
	super.draw(self, cam)
end

return Block
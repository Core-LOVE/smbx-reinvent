local BGO, super = Class('BGO', WeakObject)

BGO.static.pool = Pool:new()

BGO.static.config = Config:new('background', {
	frames = 1,
	framespeed = 8,
})

BGO.static.animation = {
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
		local img = Assets.graphics.background[id]

		local cfg = BGO.config[id]
		local w, h = cfg.width or img:getWidth(), cfg.height or img:getHeight() / cfg.frames

		self.quad[id] = Graphics.newQuad(0, h * f, w, h, img:getDimensions())
	end,

	update = function(self)
		for id in pairs(self.ids) do
			local cfg = BGO.config[id]
			
			self.frametimer[id] = self.frametimer[id] + 1

			if self.frametimer[id] >= cfg.framespeed then
				self.frame[id] = (self.frame[id] + 1) % cfg.frames
				self:updateQuad(id, self.frame[id])

				self.frametimer[id] = 0
			end
		end
	end
}

function BGO:initialize(id, x, y)
	super.initialize(self, x, y, 32, 32)
	
	self.id = id

	BGO.animation:register(id)
	BGO.pool:add(self)
end

function BGO:render(cam)
	local id = self.id
	local img = Assets.graphics.background[id]
	
	if img == nil then return end
	
	-- local cfg = Block.config[id]
	-- local w, h = cfg.width or img:getWidth(), cfg.height or img:getHeight() / cfg.frames

	-- local quad = love.graphics.newQuad(0, h * Block.animation.frame[id], w, h, img:getDimensions())
	
	Graphics.draw(img, BGO.animation.quad[id], 0, 0)
end

function BGO:draw(cam)
	if cam and not cam:collidesWith(self) then return end
	
	super.draw(self, cam)
end


return BGO
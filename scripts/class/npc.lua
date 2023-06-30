local NPC, super = Class('NPC', Object)

NPC.config = Config.register('npc', {
	width = 32,
	height = 32,
	gfxwidth = 32,
	gfxheight = 32,
	gfxoffsetx = 0,
	gfxoffsety = 0,
	
	speed = 1,
	
	frames = 0,
	framespeed = 8,
	framestyle = 0,
	
	playerblocktop = true,
	npcblocktop = false,
	
	pushable = true,
})

NPC.type = "NPC"

function NPC:clearCollides()
	self.collidesBlockBottom = false
	self.collidesBlockTop = false
	self.collidesBlockLeft = false
	self.collidesBlockRight = false
end

function NPC.spawn(id, x, y)
	local class = Assets.content.npc[id] or NPC
	local self = class:new(id, x, y)
	
	self.idx = #NPC + 1
	
	table.insert(NPC, self)
	return self
end

function NPC:initialize(id, x, y)
	self.id = id
	super.initialize(self, x, y, 32, 32)
	
	self.collider = Collider:new(self, 'box', self.x, self.y, self.width, self.height)
	
	self.collider.callback = function(thing, other, x, y, xgoal, ygoal, normalx, normaly)
		if normalx > 0 then self.collidesBlockLeft = true elseif normalx < 0 then self.collidesBlockRight = true end
		if normaly > 0 then self.collidesBlockBottom = true elseif normaly < 0 then self.collidesBlockTop = true end
		
		if normaly ~= 0 then
			self.speedY = 0
		end
		
		if normalx ~= 0 then
			self.speedX = 0
		end
	end
	
	self.collider.filter = function(thing, other)
		local realOther = other.parent
		
		if realOther.type == "Player" then
			return
		end
		
		return 'slide'
	end
	
	self.direction = 0
	
	self.immune = 0
	self.health = 0
	
	self.frame = 0
	
	self.forcedState = 0
	
	self.forcedTimer = 0
	self.frameTimer = 0
	self.despawnTimer = 180
	
	self.data = {}
	
	self:clearCollides()
end

function NPC:remove()
	self.collider:remove()
	
	for k,v in ipairs(NPC) do
		if v == self then
			return table.remove(NPC, k)
		end
	end
end

function NPC:harm()
	
end

function NPC:kill()

end

function NPC:getGravity()
	return 0.3
end

function NPC:getZ()
	return LAYERS.NPC
end

function NPC:render()
	local texture = Assets.graphics.npc[self.id]
	local cfg = NPC.config[self.id]
	
	local quad = love.graphics.newQuad(0, cfg.gfxheight * self.frame, cfg.gfxwidth, cfg.gfxheight, texture:getDimensions())
	
	Draw.texture(texture, quad, 0, 0)
end

function NPC:onAnimation() end

function NPC:animation()
	local cfg = NPC.config[self.id]
	
	local frames  = cfg.frames
	local framespeed = cfg.framespeed
	local framestyle = cfg.framestyle
	
	local dt = 1
	
	if(frames > 0) then
		self.frameTimer = self.frameTimer + dt
		if(framestyle == 2 and (self.projectile ~= 0 or self.holdingPlayer > 0)) then
			self.frameTimer = self.frameTimer + dt
		end
		if(self.frameTimer >= framespeed) then
			if(framestyle == 0) then
				self.frame = self.frame + 1 * self.direction
			else
				self.frame = self.frame + 1
			end
			self.frameTimer = 0
		end
		if(framestyle == 0) then
			if(self.frame >= frames) then
				self.frame = 0
			end
			if(self.frame < 0) then
				self.frame = frames - 1
			end
		elseif(framestyle == 1) then
			if(self.direction == -1) then
				if(self.frame >= frames) then
					self.frame = 0
				end
				if(self.frame < 0) then
					self.frame = frames
				end
			else
				if(self.frame >= frames * 2) then
					self.frame = frames
				end
				if(self.frame < frames) then
					self.frame = frames
				end
			end
		elseif(framestyle == 2) then
			if(self.holdingPlayer == 0 and self.projectile == 0) then
				if(self.direction == -1) then
					if(self.frame >= frames) then
						self.frame = 0
					end
					if(self.frame < 0) then
						self.frame = frames - 1
					end
				else
					if(self.frame >= frames * 2) then
						self.frame = frames
					end
					if(self.frame < frames) then
						self.frame = frames * 2 - 1
					end
				end
			else
				if(self.direction == -1) then
					if(self.frame >= frames * 3) then
						self.frame = frames * 2
					end
					if(self.frame < frames * 2) then
						self.frame = frames * 3 - 1
					end
				else
					if(self.frame >= frames * 4) then
						self.frame = frames * 3
					end
					if(self.frame < frames * 3) then
						self.frame = frames * 4 - 1
					end
				end
			end
		end
	else
		self:onAnimation()
	end
end

function NPC:update()
	self:clearCollides()
	self:animation()
	-- self.collider:update()
	
	self.speedY = self.speedY + self:getGravity()
	
	local xto, yto = self.collider:move()
	-- local xto, yto = Game:stage().world:move(self.shape, self.x + self.speedX, self.y + self.speedY, nil, function(thing, other, x, y, xgoal, ygoal, normalx, normaly)
		-- if normalx > 0 then self.collidesBlockLeft = true elseif normalx < 0 then self.collidesBlockRight = true end
		-- if normaly > 0 then self.collidesBlockBottom = true elseif normaly < 0 then self.collidesBlockTop = true end
		
		-- if normaly ~= 0 then
			-- self.speedY = 0
		-- end
		
		-- if normalx ~= 0 then
			-- self.speedX = 0
		-- end
		
		-- print(normalx, normaly)
	-- end)
	
	self.x = xto
	self.y = yto
end

return NPC
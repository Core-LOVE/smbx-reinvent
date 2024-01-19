local NPC, super = Class('NPC', Object)
NPC:include(Stateful)

NPC.static.config = Config('npc', {
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

	isvine = false,
})

NPC.static.create = function(id, config)
	return NPC:addState(tostring(id)), NPC
end

function NPC:initializeCollider()
	self.collider = Collider:new(self, 'box', self.x, self.y, self.width, self.height)

	self.collider.callback = function(thing, other, x, y, xgoal, ygoal, normalx, normaly)
		if normalx > 0 then self.collidesBlockLeft = true elseif normalx < 0 then self.collidesBlockRight = true end
		if normaly > 0 then self.collidesBlockTop = true elseif normaly < 0 then self.collidesBlockBottom = true end
		
		if normaly ~= 0 then
			self.speedY = 0
		end
		
		if normalx ~= 0 then
			self.speedX = 0
		end
		
		if self.collidesBlockTop then
			self.jumpForce = 0
			Audio.sfx(3)
		end
	end

	self.collider.filter = function(thing, other)
		local realOther = other.parent

		if type(realOther) == "Block" then
			local cfg = Block.config[realOther.id]
			
			if cfg.passthrough then return end
			
			local hit = true
			
			if cfg.semisolid or cfg.sizable then
				hit = false
				
				local didCollide, t, nx, ny, cornerCollide = self.collider:sweep(other.collider:realShape(), self.x + self.speedX, self.y + self.speedY)
				
				if didCollide and ny < 0 and (self.y + self.height) - 1 < realOther.y and self.speedY > 0 then
					return 'slide'
				end
				
				return
			end
			
			if cfg.floorslope ~= 0 or cfg.ceilingslope ~= 0 then
				hit = false
				
				-- CollisionUtils.slopes(self, realOther)
				return
			end
			
			if cfg.bumpable and hit then
				local didCollide, t, nx, ny, cornerCollide = self.collider:sweep(other.collider:realShape(), self.x + self.speedX, self.y + self.speedY)
				
				if didCollide and ny > 0 then
					realOther:hit()
				end
			end

			return 'slide'
		end	
	end
end

function NPC:initializeData(data) end

function NPC:initialize(id, x, y)
	super.initialize(self, x, y, 32, 32)
	
	self.gravity = nil

	self.direction = 0
	
	self.immune = 0
	self.health = 0
	
	self.frame = 0
	
	self.forcedState = 0
	
	self.forcedTimer = 0
	self.frameTimer = 0
	self.despawnTimer = 180

	self:initializeCollider()
	self:clearCollidesValues()

	self:transform(id)

	self.data = {}
	self:initializeData(self.data)

	table.insert(NPC, self)
end

function NPC:clearCollidesValues()
	self.collidesBlockBottom = false
	self.collidesBlockTop = false
	self.collidesBlockLeft = false
	self.collidesBlockRight = false
	self.collidesSlope = nil
end

function NPC:transform(id)
	local script = Assets.content.npc[id]

	self.id = id
	pcall(function()
		self:gotoState(tostring(id))
	end)
end

function NPC:getGravity()
	if NPC.config[self.id].nogravity then
		return 0
	end

	return Defines.npc_grav or self.gravity
end

function NPC:physics()
	-- self.x = self.x + self.speedX
	-- self.y = self.y + self.speedY

	self:clearCollidesValues()

	local xto, yto = self.collider:move()

	if not self.collidesSlope then
		self.y = yto
	end
	
	self.x = xto
end

function NPC:behave() end

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

		return true
	end
end

function NPC:update()
	self.speedY = math.min(self.speedY + self:getGravity(), Defines.gravity)

	self:behave()
	self:animation()

	super.update(self)
end

function NPC:render(cam)
	local id = self.id
	local img = Assets.graphics.npc[id]
	
	if img == nil then return end
	
	local cfg = NPC.config[id]
	local quad = love.graphics.newQuad(0, cfg.gfxheight * self.frame, cfg.gfxwidth, cfg.gfxheight, img:getDimensions())
	
	Graphics.draw(img, quad, 0, 0)
end

function NPC:draw(cam)
	if cam and not cam:collidesWith(self) then return end
	
	super.draw(self, cam)
end

return NPC
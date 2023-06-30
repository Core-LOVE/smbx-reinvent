local Player, super = Class('Player', Object)

local Keys = require("class.keys")
local splash = require("utils.splash")
local iniParser = require("utils.parser.ini")
local CollisionUtils = require("utils.collisionutils")
local splash = require("utils.splash")

Player.type = "Player"

Player.settings = setmetatable({}, {
	__index = function(_, character)
		rawset(Player.settings, character, setmetatable({}, {__index = function(self, powerup)
			local settings = {}
			
			local characterPath = (character .. '-' .. powerup .. '.ini')
			
			local path = Files.resolve(characterPath) or Files.resolve('config/character/' .. character .. '/' .. characterPath)
			local data = iniParser.read(path)
			
			for k,v in pairs(data.common) do
				settings[k] = v
			end
			
			local function define(y)
				local n = (y == nil and 'X') or 'Y'
				local offset = 'offset' .. n
				
				settings['getSpriteOffset' .. n] = function(settiings, indexX, indexY)
					local frame = data['frame-' .. indexX .. '-' .. indexY]
					
					if not frame then return 0 end
					
					return data['frame-' .. indexX .. '-' .. indexY][offset]
				end
				
				settings['setSpriteOffset' .. n] = function(settiings, indexX, indexY, val)
					data['frame-' .. indexX .. '-' .. indexY][offset] = val
				end	
			end
			
			define()
			define(true)
			
			rawset(self, powerup, settings)
			return rawget(self, powerup)
		end}))
		
		return rawget(Player.settings, character)
	end
})

function Player:clearCollides()
	self.collidesBlockBottom = false
	self.collidesBlockTop = false
	self.collidesBlockLeft = false
	self.collidesBlockRight = false
	self.collidesSlope = nil
end

function Player.spawn(character, x, y)
	local class = Assets.content.character[character] or Player
	local self = class:new(character, x, y)
	
	self.idx = #Player + 1
	
	table.insert(Player, self)
	return self
end

function Player:getSettings()
	return Player.settings[self.character][self.powerup]
end

function Player:initialize(character, x, y)
	self.character = character
	self.powerup = 1
	
	local settings = self:getSettings()
	
	super.initialize(self, x, y, settings.width, settings.height)

	self.collider = Collider(self, 'box', x, y, self.width, self.height)
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
			Play.sound(3)
		end
		-- print(normalx, normaly)
	end
	
	self.collider.filter = function(thing, other)
		local realOther = other.parent
		
		if realOther.type == "Block" then
			local cfg = Block.config[realOther.id]
			local hit = true
			
			if cfg.semisolid then
				hit = false
				
				local didCollide, t, nx, ny, cornerCollide = self.collider:sweep(other.collider:realShape(), self.x + self.speedX, self.y + self.speedY)
				
				if didCollide and ny < 0 and (self.y + self.height) - 1 < realOther.y and self.speedY > 0 then
					return 'slide'
				end
				
				return
			end
			
			if cfg.floorslope ~= 0 or cfg.ceilingslope ~= 0 then
				hit = false
				
				CollisionUtils.slopes(self, realOther)
				return
			end
			
			if cfg.bumpable and hit then
				local didCollide, t, nx, ny, cornerCollide = self.collider:sweep(other.collider:realShape(), self.x + self.speedX, self.y + self.speedY)
				
				if didCollide and ny > 0 then
					realOther:hit()
				end
			end
		elseif realOther.type == "NPC" then
			local didCollide, t, nx, ny, cornerCollide = self.collider:sweep(other.collider:realShape(), self.x + self.speedX, self.y + self.speedY)
			
			if didCollide and ny < 0 and (self.y + self.height) - 1 < realOther.y and self.speedY > 0 then
				return 'slide'
			end
			
			return
		end
		
		return 'slide'
	end
	
	self.keys = Keys:new()
	self.section = 1
	
	self.direction = 1
	self.slideCounter = 0
	
	self.holdingNPC = nil
	
	self.targetWarp = nil
	self.warpDelay = 0
	
	self.frame = 0
	self.frameTimer = 0
	
	self.jumpForce = 0
	self.isSpinjumping = false
	
	self:clearCollides()
end

function Player:getGravity()
	return 0.3
end

do 
	local function animation_onFloor(v, fr, i)
		if v.speedX ~= 0 then
			if v.slideCounter <= 0 then
				v.frameTimer = v.frameTimer + 1
				if v.speedX > Defines.player_walkspeed - 1.5 or v.speedX < -Defines.player_walkspeed + 1.5 then
					v.frameTimer = v.frameTimer + 1 end
				if v.speedX > Defines.player_walkspeed or v.speedX < -Defines.player_walkspeed then
					v.frameTimer = v.frameTimer + 1 end
				if v.speedX > Defines.player_walkspeed + 1 or v.speedX < -Defines.player_walkspeed - 1 then
					v.frameTimer = v.frameTimer + 1 end
				if v.speedX > Defines.player_walkspeed + 2 or v.speedX < -Defines.player_walkspeed - 2 then
					v.frameTimer = v.frameTimer + 1 end

				if v.frameTimer >= 10 then
					v.frameTimer = 0
					if v.frame == fr.stand[i] then v.frame = fr.run[i] else v.frame = fr.stand[i] end
				end
			else
				v.frame = 4
			end
		else
			v.frame = fr.stand[i] 
		end
	end

	local function animation_inAir(v, fr, i)
		if v.isSpinjumping then
			local fspeed = 3
			v.frameTimer = v.frameTimer + 1
			if v.frameTimer < fspeed then
				v.direction = 1
				v.frame = fr.stand[i]
			elseif v.frameTimer < fspeed * 2 then
				v.frame = 15
			elseif v.frameTimer < fspeed * 3 then
				v.direction = -1
				v.frame = fr.stand[i]
			elseif v.frameTimer < fspeed * 4 then
				v.frame = 13 
			elseif v.frameTimer >= fspeed * 5 then
				v.direction = 1
				v.frame = fr.stand[i]
				v.frameTimer = 0
			end
		else
			v.frame = fr.jump[i]
		end
	end

	function Player:update_animation()
		local v = self
		local fr = {
			stand = {[1] = 1, [2] = 5},
			run = {[1] = 2, [2] = 6},
			jump = {[1] = 3, [2] = 6},
		}
		
		local i = 1
		
		if v.holdingNPC then
			i = 2
		end
		
		if not v.targetWarp then
			if v.collidesBlockBottom then
				if not v.slidingSlope then
					animation_onFloor(v, fr, i)
				else
					v.frame = 24
				end
			else
				if not v.slidingSlope then
					animation_inAir(v, fr, i)
				else
					v.frame = 24
				end
			end
		else
			v.frame = 13
		end
	end
end

function Player:update_warp()
	if self.warpDelay > 0 then
		self.warpDelay = (self.warpDelay - 1)
		return
	end
	
	for k, warp in ipairs(Warp) do
		if warp.exit and CollisionUtils.simple(self, warp) then
			return warp:onCollide(self)
		end	
	end
end

function Player:update()
	self.keys:update()
	self:update_animation()
	
	if self.keys.left then
		self.direction = -1
	elseif self.keys.right then
		self.direction = 1
	end
	
	-- WALKING
	
	local speedModifier = 1

	local walkSpeed = Defines.player_walkspeed * speedModifier
	local runSpeed = Defines.player_runspeed * speedModifier

	local walkDirection = (self.keys.left and -1) or (self.keys.right and 1) or 0
	-- print(self.keys.left)
	
	if walkDirection ~= 0 then
		local speedingUpForWalk = (self.speedX * walkDirection < walkSpeed)

		if self.keys.run or speedingUpForWalk then
			if speedingUpForWalk then
				self.speedX = self.speedX + Defines.player_walkingAcceleration * speedModifier * walkDirection
			elseif self.speedX*walkDirection < runSpeed then
				self.speedX = self.speedX + Defines.player_runningAcceleration * speedModifier * walkDirection
			end

			if self.speedX * walkDirection < 0 then
				self.speedX = self.speedX + Defines.player_turningAcceleration * walkDirection
			end
		else
			self.speedX = self.speedX - Defines.player_runToWalkDeceleration * walkDirection
		end
	elseif self.collidesBlockBottom then
		if self.isSpinjumping then self.isSpinjumping = false end
		
		if self.speedX > 0 then
			self.speedX = math.max(0,self.speedX - Defines.player_deceleration*speedModifier)
		elseif self.speedX < 0 then
			self.speedX = math.min(0,self.speedX + Defines.player_deceleration*speedModifier)
		end
	end
	
	-- JUMPING
	
	if self.keys.jump or self.keys.altJump then
		if self.slidingSlope then self.slidingSlope = nil end
		
		if (self.keys.jump == KEYS_PRESSED or self.keys.altJump == KEYS_PRESSED) and self.collidesBlockBottom then
			self.y = self.y - 1
			self.jumpForce = Defines.jumpheight
			
			if self.keys.altJump then
				self.jumpForce = Defines.spinjumpheight
				self.direction = -self.direction
				
				self.isSpinjumping = true
				-- SFX.play(33)	
			else
				self.isSpinjumping = false
				-- SFX.play(1)
			end
			
			if self.isSpinjumping then
				Play.sound(33)			
			else
				Play.sound(1)	
			end
		end

		if self.jumpForce > 0 then
			self.speedY = Defines.player_jumpspeed - math.abs(self.speedX * 0.2)
		end
	end
	
	if not self.keys.jump and not self.keys.altJump then
		self.jumpForce = 0
	elseif self.jumpForce > 0 then
		self.jumpForce = math.max(0, self.jumpForce - 1)
	end
	
	self.speedY = math.min(self.speedY + Defines.player_grav, Defines.gravity)
	
	self:update_warp()
	
	self:clearCollides()

	local xto, yto = self.collider:move()

	if not self.collidesSlope then
		self.y = yto
	end
	
	self.x = xto
	-- self:updateCollision()
end

do
	local function pfrX(plrFrame)
		local A
		A = plrFrame
		A = A - 50
		
		while(A > 100) do
			A = A - 100
		end
		
		if(A > 90) then
			A = 9
		elseif(A > 90) then
			A = 9
		elseif(A > 80) then
			A = 8
		elseif(A > 70) then
			A = 7
		elseif(A > 60) then
			A = 6
		elseif(A > 50) then
			A = 5
		elseif(A > 40) then
			A = 4
		elseif(A > 30) then
			A = 3
		elseif(A > 20) then
			A = 2
		elseif(A > 10) then
			A = 1
		else
			A = 0
		end
		
		return A * 100
	end

	local function pfrY(plrFrame)
		local A
		A = plrFrame
		A = A - 50
		
		while(A > 100) do
			A = A - 100
		end
		
		A = A - 1
		while(A > 9) do
			A = A - 10
		end
		
		return A * 100
	end
	
	function Player:getZ()
		return LAYERS.PLAYER
	end
	
	function Player:render()
		local texture = Assets.graphics[self.character][self.powerup]
		local settings = self:getSettings()
	
		local tx, ty = pfrX(100 + self.frame * self.direction), pfrY(100 + self.frame * self.direction)
		local quad = love.graphics.newQuad(tx, ty, 100, 100, texture:getDimensions())
		
		local ntx, nty = tx / 100, ty / 100
		
		local ox = settings:getSpriteOffsetX(ntx, nty)
		local oy = settings:getSpriteOffsetY(ntx, nty)
		
		Draw.texture(texture, quad, -ox, -oy)
	end
end

return Player
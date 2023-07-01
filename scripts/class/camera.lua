local Camera, super = Class('Camera', Object)

local CollisionUtils = require("utils.collisionutils")

function Camera.spawn(x, y, width, height)
	local self = Camera:new(x, y)
	
	self.idx = #Camera + 1
	
	table.insert(Camera, self)
	return self
end

function Camera:tween(t, ...)
	return Timer.tween(t, self, ...)
end

function Camera:setSize(w, h)
	local w = w or self.width
	local h = h or self.height
	
	self.canvas = love.graphics.newCanvas(self.width, self.height, self.settings)
end

function Camera:defaultRender()
	local stage = Game:stage()
	
	if stage.render then
		self.renderTo = function()
			Draw.push()
			Draw.clear()
			
			Draw.translate(-self.x, -self.y)
			Draw.scale(self.scale_x, self.scale_y)
			Draw.rotate(self.rotation)
			Draw.skew(self.skew_x, self.skew_y)

			stage:render(self)
			Signal.emit('onCameraDraw', self)	
			
			Draw.pop()
		end
	end
end

function Camera:initialize(x, y, width, height, settings)
	local width = width or 800
	local height = height or 600
	
	super.initialize(self, x, y, width, height)
	
	self.settings = settings
	self.canvas = love.graphics.newCanvas(self.width, self.height, self.settings)
	
	self.follow_target = true
	self.limit_to_section = true
	
	self.render_x = 0
	self.render_y = 0
	self.render_scale_x = 1
	self.render_scale_y = 1
	self.render_rotation = 0
	self.render_skew_x = 0
	self.render_skew_y = 0
	self.render_origin_x = 0
	self.render_origin_y = 0
	self.render_offset_x = 0
	self.render_offset_y = 0
end

function Camera:getTarget()
	if self.target then
		return self.target
	end
	
	if self.idx > 2 then return end
	
	return Player[self.idx]
end

function Camera:update_target()
	local target = self:getTarget()
	
	if target == nil then return end
	
	if self.follow_target then
		self.x = (target.x - (self.width * 0.5)) + (target.width * 0.5)
		self.y = (target.y - (self.height * 0.5)) + (target.height * 0.5)
	end
	
	if not self.limit_to_section then return end
	
	local s = target.section

	if s then
		local s = Section[s]
		
		if self.x < s.x then
			self.x = s.x
		elseif self.x + self.width > s.x + s.width then
			self.x = (s.x + s.width) - self.width
		end
		
		if self.y + self.height > s.y + s.height then
			self.y = (s.y + s.height) - self.height
		end
		
		if self.y < s.y then
			self.y = s.y
		end
	end
end

function Camera:update()
	super.update(self)
	
	self:update_target()
	
	if self.renderTo then
		self.canvas:renderTo(self.renderTo)
	end
end

function Camera:render()
	love.graphics.draw(self.canvas)
end

function Camera:draw() 
	if self.isHidden then return end
	
	Draw.rawPush()
	
		Draw.rawTranslate(self.render_x + self.render_offset_x, self.render_y + self.render_offset_y)
		Draw.rawScale(self.render_scale_x, self.render_scale_y)
		Draw.rawRotate(self.render_rotation)
		Draw.rawSkew(self.render_skew_x, self.render_skew_y)
		
		self:render()
		self:drawChildren()
	
	Draw.rawPop()
end

function Camera:collidesWith(obj)
	return CollisionUtils.simple(self, obj)
end

return Camera 
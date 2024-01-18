local Camera, super = Class('Camera', Object)

Camera.static.pool = Pool:new()

function Camera:initialize(x, y, w, h)
	super.initialize(self, x, y, w, h)
	
	self.renderX = 0
	self.renderY = 0
	
	self.targets = {}
	self.follow_target = true
	self.limit_to_section = true
	
	self._canvas = love.graphics.newCanvas(w, h)
	Camera.pool:add(self)
end

function Camera:setPaint(f)
	self.paint = function()
		Graphics.push()
			Graphics.clear(0, 0, 0, 0)
			Graphics.translate(-self.renderX, -self.renderY)
			
			f(cam)
			
		Graphics.pop()
	end
	
	return self
end

-- must be improved
function Camera:setTarget(obj)
	self.targets[1] = obj
	
	return self
end

function Camera:getTarget()
	return self.targets[1]
end

function Camera:update_target()
	local target = self:getTarget()
	
	if not target then return end
	
	if self.follow_target then
		self.renderX = (target.x - (self.width * .5)) + (target.width * .5)
		self.renderY = (target.y - (self.height * .5)) + (target.height * .5)
	end
	
	if not self.limit_to_section then return end
	
	local s = target.section

	if s then
		local s = Section[s]
		
		if self.renderX < s.x then
			self.renderX = s.x
		elseif self.renderX + self.width > s.x + s.width then
			self.renderX = (s.x + s.width) - self.width
		end
		
		if self.renderY + self.height > s.y + s.height then
			self.renderY = (s.y + s.height) - self.height
		end
		
		if self.renderY < s.y then
			self.renderY = s.y
		end
	end
end

function Camera:update()
	super.update(self)
	
	self:update_target()
	
	local paint = self.paint
	
	if paint then
		self._canvas:renderTo(paint)
	end
end

function Camera:render()
	Graphics.draw(self._canvas)
end

function Camera:collidesWith(obj)
   if ((obj.x >= self.renderX + self.width) or
		   (obj.x + obj.width <= self.renderX) or
		   (obj.y >= self.renderY + self.height) or
		   (obj.y + obj.height <= self.renderY)) then
			  return false 
	   else return true
           end
end

return Camera
local WeakObject = Class('WeakObject')

function WeakObject:initialize(x, y, width, height)
	self.active = true
	self.isHidden = false
	
	self.x = x or 0
	self.y = y or 0
	self.speedX = 0
	self.speedY = 0
	self.width = width or 0
	self.height = height or 0
end

function WeakObject:remove() end

function WeakObject:draw(cam) 
	if (self.isHidden) then return end
	
	Graphics.push()
		
		Graphics.translate(self.x, self.y)
		
		self:render(cam)
		
		-- if self.type ~= "Block" then 
			-- Draw.rectangle('line', 0, 0, self.width, self.height)
		-- end
		
	Graphics.pop()
end

function WeakObject:render(cam) end

return WeakObject